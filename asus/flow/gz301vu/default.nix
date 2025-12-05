
{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    versionAtLeast
    ;

  cfg = config.hardware.asus.flow.gz301vu;
in
{

  imports = [
    ../../../common/cpu/intel/raptor-lake
    ../../../common/gpu/intel/raptor-lake
    ../../../common/gpu/nvidia/ada-lovelace
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  boot = {
    blacklistedKernelModules = [ "nouveau" ];
  };

  hardware = {

    nvidia = {

      modesetting.enable = true;
      nvidiaSettings = mkDefault true;

      prime = {
        offload = {
          enable = mkDefault true;
          enableOffloadCmd = mkDefault true;
        };
        intelBusId = "PCI:00:02.0";
        nvidiaBusId = "PCI:01:00.0";
      };

      powerManagement = {
        enable = mkDefault true;
        finegrained = mkDefault true;
      };

      dynamicBoost.enable = mkDefault true;

    };
  };

  config = mkMerge [
    {
      # Configure basic system settings:
      boot = {
        kernelModules = [ "kvm-intel" ];
        kernelParams = [
          "mem_sleep_default=deep"
          "pcie_aspm.policy=powersupersave"
        ];
      };

      services = {
        asusd = {
          enable = mkDefault true;
          enableUserService = mkDefault true;
        };

        supergfxd.enable = mkDefault true;


      };

      #flow devices are 2 in 1 laptops
      hardware.sensor.iio.enable = mkDefault true;

    }
  ];
}
