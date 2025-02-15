
::                Name: BATSCAN.BAT     
::             Purpose:  Scan ports, show those open and tell me what they do.
::              Author: Auggger  
::            Revision: 1.2
:: Suport Files Needed: none
::       Files Created: 2/14/2025

::If you study any of my BATCH files, I will have a main area with subroutines that
::I will call from the main menu.  yeah it might not be the right way, but it's my way.
::document everything you do so others can understand your script also.

echo off
:: same as @echo off

title  WiFi Network Scanner
color 0f
mode con cols=100 lines=46
:TOP
cls
call :TITLE
echo.
call :ColorText 0b "  Scanning, please wait....."
timeout /t 3 >NULL
::MENULOOP
cls
call :TITLE
echo.
echo.
call :ColorText 0a "Networks Currently Available"
on error
   cls
    call :TITLE
	 echo.
      call :ColorText 0e "You are connected by Lan Cable, not Wifi"
       echo.
	    for /f "tokens=2 delims==" %%F in ('wmic nic where "NetConnectionStatus=2 and AdapterTypeId=0" get  NetConnectionID /format:list') do set interfaceName=%%F
         call :ColorText 0e "Your Current Active Interface is %interfaceName%"
		  echo. 
           call :ColorText 0e "All Active Lan Connection(s)"	   
            netsh interface show interface
		     echo.
		      pause
               goto :EXIT

set /p connect= "Do you wish to connect to a known network above (Y/N)?"
if %connect%==Y goto :DOIT
if %connect%==y goto :DOIT 
if %connect%==N goto :EXIT 
if %connect%==n goto :EXIT
goto :MENULOOP

:DOIT 
cls
call :TITLE
echo.
echo.
call :ColorText 0b "Known Networks Available"
netsh wlan show networks
echo.
echo.
netsh interface show interface
goto :EXIT
set /p interface= " What is the Interface Name (Enter to Exit) ?"

::if %interface%==" " goto :EXIT

set /p ssid= "  What is the ssid ?"
set /p name= "  What is the Name ?"

echo.
call :ColorText 0e "Using interface %interface%, I will attempt to connect to ssid %ssid%, please wait."
echo.

timeout /t 3 >NULL
netsh wlan connect ssid=%ssid% name=%name% interface=%interface%


:EXIT
del NULL
exit

::================================== SUBROUTINES START HERE ============================

:TITLE
echo.
echo.
echo.
echo          "$$$$$$$\   $$$$$$\ $$$$$$$$\        $$$$$$\   $$$$$$\   $$$$$$\  $$\   $$\  "
echo          "$$  __$$\ $$  __$$\\__$$  __|      $$  __$$\ $$  __$$\ $$  __$$\ $$$\  $$ | "
echo          "$$ |  $$ |$$ /  $$ |  $$ |         $$ /  \__|$$ /  \__|$$ /  $$ |$$$$\ $$ | "
echo          "$$$$$$$\ |$$$$$$$$ |  $$ |         \$$$$$$\  $$ |      $$$$$$$$ |$$ $$\$$ | "
echo          "$$  __$$\ $$  __$$ |  $$ |          \____$$\ $$ |      $$  __$$ |$$ \$$$$ | "
echo          "$$ |  $$ |$$ |  $$ |  $$ |         $$\   $$ |$$ |  $$\ $$ |  $$ |$$ |\$$$ | "
echo          "$$$$$$$  |$$ |  $$ |  $$ |         \$$$$$$  |\$$$$$$  |$$ |  $$ |$$ | \$$ | "
echo          "\_______/ \__|  \__|  \__|          \______/  \______/ \__|  \__|\__|  \__| "
echo.
call :ColorText 0a "                                    WiFi Network Scanner  ver. 1.0"
call :ColorText 0e "                             Scan and return information on WiFi Networks"
exit /b 

:NoWiFi
on error
   cls
    call :TITLE
netsh interface show interface
exit /b

:ColorText
::USEAGE - CALL :ColorText 08 "Hello!"
echo off
<nul set /p .=. > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
echo(%DEL%%DEL%%DEL%
del "%~2" > nul 2>&1
exit /b