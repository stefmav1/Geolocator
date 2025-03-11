@echo off
title Geolocator
color 0A
setlocal enabledelayedexpansion

:geolocate
cls
echo Enter IP Address:
set /p ipAddress="> "

echo Fetching location for %ipAddress%...
curl -s "http://ip-api.com/json/%ipAddress%" > ipinfo.txt

if not exist ipinfo.txt (
    echo Failed to fetch location information.
    pause
    exit /b
)

for /f "delims=" %%A in ('powershell -Command "Get-Content ipinfo.txt | ConvertFrom-Json | Select-Object -ExpandProperty country"') do set country=%%A
for /f "delims=" %%A in ('powershell -Command "Get-Content ipinfo.txt | ConvertFrom-Json | Select-Object -ExpandProperty regionName"') do set region=%%A
for /f "delims=" %%A in ('powershell -Command "Get-Content ipinfo.txt | ConvertFrom-Json | Select-Object -ExpandProperty city"') do set city=%%A
for /f "delims=" %%A in ('powershell -Command "Get-Content ipinfo.txt | ConvertFrom-Json | Select-Object -ExpandProperty lat"') do set lat=%%A
for /f "delims=" %%A in ('powershell -Command "Get-Content ipinfo.txt | ConvertFrom-Json | Select-Object -ExpandProperty lon"') do set lon=%%A
for /f "delims=" %%A in ('powershell -Command "Get-Content ipinfo.txt | ConvertFrom-Json | Select-Object -ExpandProperty timezone"') do set timezone=%%A

echo.
echo Location Info for %ipAddress%:
echo Country: %country%
echo Region: %region%
echo City: %city% 
echo Time Zone: %timezone%
echo Latitude: %lat%
echo Longitude: %lon%

set "lat=%lat:,=.%"
set "lon=%lon:,=.%"

set mapLink="https://www.google.com/maps/search/?api=1&query=%lat%,%lon%"

timeout /t 1 /nobreak >nul
echo View on Google Maps: %mapLink%

pause >nul
exit
