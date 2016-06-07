$version = "0.91.52"


function replaceVersionInfo($version)
{
	$versionInfoRegex = new-object Text.RegularExpressions.Regex "// NPP plugin platform for .Net v(\d+\.\d+(\.\d+)?) by Kasper B. Graversen etc.", "None"

	$files = get-ChildItem -Path . -Recurse -ErrorAction SilentlyContinue -Filter *.cs
	ForEach ($f in $files)
    {
		$name = $f.Fullname
		$content  = [IO.File]::ReadAllText($name)
		$original = $content
		
		$content = $versionInfoRegex.Replace($content, "// NPP plugin platform for .Net v"+ $version + " by Kasper B. Graversen etc.")
		If ($content -ne $original)
		{
			[IO.File]::WriteAllText("$name", $content, [Text.Encoding]::"UTF8")
		}
	}
}

cd 'Visual Studio Project Template C#'
$filename = "NppPlugin" + $version + ".zip"
write-host "# zip the projectTemplate '$filename'" -foreground green
& 'C:\Program Files\7-Zip\7z.exe' a -tzip $filename *


$vsTemplatepath = [Environment]::GetFolderPath("MyDocuments")+'\Visual Studio 2015\Templates\ProjectTemplates\Visual C#\'
write-host "# Copy projectTemplate to VS: '$vsTemplatepath'" -foreground green
del "$($vsTemplatepath)\nppplugin*.zip"
copy $filename $($vsTemplatepath)


write-host "# Zip template and all source files" -foreground green
cd ..
replaceVersionInfo($version)
& 'C:\Program Files\7-Zip\7z.exe' a -tzip c:\temp\nppDemoAndProjectTemplate$($version).zip * 


write-host "# remove temp files" -foreground green
rm 'Visual Studio Project Template C#\NppPlugin*.zip'
