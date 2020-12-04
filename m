Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2BD2CE9AF
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 09:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387429AbgLDIdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 03:33:12 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:46855 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgLDIdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 03:33:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607070791; x=1638606791;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=C06/teZu3x/3Zv+c2DOYSzyNiZcTimywoBUcKYK11MA=;
  b=0p2O384gQRAyB/sNgvsmvZmkmBCEOs5SrZz/XAEFy6EcmjNs5K+tgoAs
   WMR1dmeCKIuQfI2D3AJ3fPSgEKuRoc4YXNtiIs9oyIXVDi2rZeSsiF4AS
   H8SReZFjYcpedQofESQU40xaKr88kBXw/8plSk7cg6iTdgCIk8aiIoIb5
   8G9a68ZvUotA4UsVcgN8XPdv9p86pLuxSCvR0S+JZE+UZ6kXR/Ko1yYZu
   KV2YfJdlAS/+mMpu9zOGvekCphZChow1k8beVPTTz5ZmGMNI/jBEqeWiz
   09XIhhiRV/KNZwYKJqML79YDg0OD/mFODGlfqhF9xRbHvps41QetgdIad
   A==;
IronPort-SDR: FWRSdhRV5CpSyxsUIu3FwVbgw1ZipYp65IlQyytaUklKi/2grvCIH/ftrB+jIVrZCZr1ee/wnU
 BNeG/75heB/ypNqFkUQTxyrGjUNZCJvr0u4qn19SWnsBX9tXc29jwB73sKEVLdUWeXysOHfuxe
 +PzMSl+PdIugj9bukdXSu8LYid51/hFaLV3NuTwOvBcJXSsYUPAxCc6KusupUw3TPxXrXpb5fX
 D2pUpzMa+pni9z/CA4T4CWO9LU3F0BzbD985ryBh5BeAvnJ/uKSb6C0rnNL3TCsA+My+x21nOv
 2CI=
X-IronPort-AV: E=Sophos;i="5.78,392,1599548400"; 
   d="scan'208";a="98610887"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2020 01:32:05 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 01:32:04 -0700
Received: from [10.171.246.90] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 4 Dec 2020 01:31:59 -0700
Subject: Re: [PATCH] ethernet: select CONFIG_CRC32 as needed
To:     Arnd Bergmann <arnd@kernel.org>, Mark Einon <mark.einon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Claudiu Beznea" <claudiu.beznea@microchip.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "Simon Horman" <simon.horman@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>
CC:     Arnd Bergmann <arnd@arndb.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <oss-drivers@netronome.com>
References: <20201203232114.1485603-1-arnd@kernel.org>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <ea88bb03-28c4-f5ff-3c9f-25157c793971@microchip.com>
Date:   Fri, 4 Dec 2020 09:31:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201203232114.1485603-1-arnd@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/12/2020 at 00:20, Arnd Bergmann wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> From: Arnd Bergmann <arnd@arndb.de>
> 
> A number of ethernet drivers require crc32 functionality to be
> avaialable in the kernel, causing a link error otherwise:
> 
> arm-linux-gnueabi-ld: drivers/net/ethernet/agere/et131x.o: in function `et1310_setup_device_for_multicast':
> et131x.c:(.text+0x5918): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/cadence/macb_main.o: in function `macb_start_xmit':
> macb_main.c:(.text+0x4b88): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/faraday/ftgmac100.o: in function `ftgmac100_set_rx_mode':
> ftgmac100.c:(.text+0x2b38): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/freescale/fec_main.o: in function `set_multicast_list':
> fec_main.c:(.text+0x6120): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/freescale/fman/fman_dtsec.o: in function `dtsec_add_hash_mac_address':
> fman_dtsec.c:(.text+0x830): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/freescale/fman/fman_dtsec.o:fman_dtsec.c:(.text+0xb68): more undefined references to `crc32_le' follow
> arm-linux-gnueabi-ld: drivers/net/ethernet/netronome/nfp/nfpcore/nfp_hwinfo.o: in function `nfp_hwinfo_read':
> nfp_hwinfo.c:(.text+0x250): undefined reference to `crc32_be'
> arm-linux-gnueabi-ld: nfp_hwinfo.c:(.text+0x288): undefined reference to `crc32_be'
> arm-linux-gnueabi-ld: drivers/net/ethernet/netronome/nfp/nfpcore/nfp_resource.o: in function `nfp_resource_acquire':
> nfp_resource.c:(.text+0x144): undefined reference to `crc32_be'
> arm-linux-gnueabi-ld: nfp_resource.c:(.text+0x158): undefined reference to `crc32_be'
> arm-linux-gnueabi-ld: drivers/net/ethernet/nxp/lpc_eth.o: in function `lpc_eth_set_multicast_list':
> lpc_eth.c:(.text+0x1934): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/rocker/rocker_ofdpa.o: in function `ofdpa_flow_tbl_do':
> rocker_ofdpa.c:(.text+0x2e08): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/rocker/rocker_ofdpa.o: in function `ofdpa_flow_tbl_del':
> rocker_ofdpa.c:(.text+0x3074): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/rocker/rocker_ofdpa.o: in function `ofdpa_port_fdb':
> arm-linux-gnueabi-ld: drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.o: in function `mlx5dr_ste_calc_hash_index':
> dr_ste.c:(.text+0x354): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/microchip/lan743x_main.o: in function `lan743x_netdev_set_multicast':
> lan743x_main.c:(.text+0x5dc4): undefined reference to `crc32_le'
> 
> Add the missing 'select CRC32' entries in Kconfig for each of them.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/net/ethernet/agere/Kconfig              | 1 +
>   drivers/net/ethernet/cadence/Kconfig            | 1 +

For Cadence macb driver:
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

>   drivers/net/ethernet/faraday/Kconfig            | 1 +
>   drivers/net/ethernet/freescale/Kconfig          | 1 +
>   drivers/net/ethernet/freescale/fman/Kconfig     | 1 +
>   drivers/net/ethernet/mellanox/mlx5/core/Kconfig | 1 +
>   drivers/net/ethernet/microchip/Kconfig          | 1 +
>   drivers/net/ethernet/netronome/Kconfig          | 1 +
>   drivers/net/ethernet/nxp/Kconfig                | 1 +
>   drivers/net/ethernet/rocker/Kconfig             | 1 +
>   10 files changed, 10 insertions(+)
> 
> diff --git a/drivers/net/ethernet/agere/Kconfig b/drivers/net/ethernet/agere/Kconfig
> index d92516ae59cc..9cd750184947 100644
> --- a/drivers/net/ethernet/agere/Kconfig
> +++ b/drivers/net/ethernet/agere/Kconfig
> @@ -21,6 +21,7 @@ config ET131X
>          tristate "Agere ET-1310 Gigabit Ethernet support"
>          depends on PCI
>          select PHYLIB
> +       select CRC32
>          help
>            This driver supports Agere ET-1310 ethernet adapters.
> 
> diff --git a/drivers/net/ethernet/cadence/Kconfig b/drivers/net/ethernet/cadence/Kconfig
> index 85858163bac5..e432a68ac520 100644
> --- a/drivers/net/ethernet/cadence/Kconfig
> +++ b/drivers/net/ethernet/cadence/Kconfig
> @@ -23,6 +23,7 @@ config MACB
>          tristate "Cadence MACB/GEM support"
>          depends on HAS_DMA && COMMON_CLK
>          select PHYLINK
> +       select CRC32
>          help
>            The Cadence MACB ethernet interface is found on many Atmel AT32 and
>            AT91 parts.  This driver also supports the Cadence GEM (Gigabit
> diff --git a/drivers/net/ethernet/faraday/Kconfig b/drivers/net/ethernet/faraday/Kconfig
> index c2677ec0564d..3d1e9a302148 100644
> --- a/drivers/net/ethernet/faraday/Kconfig
> +++ b/drivers/net/ethernet/faraday/Kconfig
> @@ -33,6 +33,7 @@ config FTGMAC100
>          depends on !64BIT || BROKEN
>          select PHYLIB
>          select MDIO_ASPEED if MACH_ASPEED_G6
> +       select CRC32
>          help
>            This driver supports the FTGMAC100 Gigabit Ethernet controller
>            from Faraday. It is used on Faraday A369, Andes AG102 and some
> diff --git a/drivers/net/ethernet/freescale/Kconfig b/drivers/net/ethernet/freescale/Kconfig
> index a1d53ddf1593..3f9175bdce77 100644
> --- a/drivers/net/ethernet/freescale/Kconfig
> +++ b/drivers/net/ethernet/freescale/Kconfig
> @@ -25,6 +25,7 @@ config FEC
>          depends on (M523x || M527x || M5272 || M528x || M520x || M532x || \
>                     ARCH_MXC || SOC_IMX28 || COMPILE_TEST)
>          default ARCH_MXC || SOC_IMX28 if ARM
> +       select CRC32
>          select PHYLIB
>          imply PTP_1588_CLOCK
>          help
> diff --git a/drivers/net/ethernet/freescale/fman/Kconfig b/drivers/net/ethernet/freescale/fman/Kconfig
> index 34150182cc35..48bf8088795d 100644
> --- a/drivers/net/ethernet/freescale/fman/Kconfig
> +++ b/drivers/net/ethernet/freescale/fman/Kconfig
> @@ -4,6 +4,7 @@ config FSL_FMAN
>          depends on FSL_SOC || ARCH_LAYERSCAPE || COMPILE_TEST
>          select GENERIC_ALLOCATOR
>          select PHYLIB
> +       select CRC32
>          default n
>          help
>                  Freescale Data-Path Acceleration Architecture Frame Manager
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> index 99f1ec3b2575..3e371d24c462 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> @@ -198,6 +198,7 @@ config MLX5_EN_TLS
>   config MLX5_SW_STEERING
>          bool "Mellanox Technologies software-managed steering"
>          depends on MLX5_CORE_EN && MLX5_ESWITCH
> +       select CRC32
>          default y
>          help
>          Build support for software-managed steering in the NIC.
> diff --git a/drivers/net/ethernet/microchip/Kconfig b/drivers/net/ethernet/microchip/Kconfig
> index 31f9a82dc113..d0f6dfe0dcf3 100644
> --- a/drivers/net/ethernet/microchip/Kconfig
> +++ b/drivers/net/ethernet/microchip/Kconfig
> @@ -47,6 +47,7 @@ config LAN743X
>          depends on PCI
>          select PHYLIB
>          select CRC16
> +       select CRC32
>          help
>            Support for the Microchip LAN743x PCI Express Gigabit Ethernet chip
> 
> diff --git a/drivers/net/ethernet/netronome/Kconfig b/drivers/net/ethernet/netronome/Kconfig
> index d8b99d6a0356..b82758d5beed 100644
> --- a/drivers/net/ethernet/netronome/Kconfig
> +++ b/drivers/net/ethernet/netronome/Kconfig
> @@ -22,6 +22,7 @@ config NFP
>          depends on VXLAN || VXLAN=n
>          depends on TLS && TLS_DEVICE || TLS_DEVICE=n
>          select NET_DEVLINK
> +       select CRC32
>          help
>            This driver supports the Netronome(R) NFP4000/NFP6000 based
>            cards working as a advanced Ethernet NIC.  It works with both
> diff --git a/drivers/net/ethernet/nxp/Kconfig b/drivers/net/ethernet/nxp/Kconfig
> index ee83a71c2509..c84997db828c 100644
> --- a/drivers/net/ethernet/nxp/Kconfig
> +++ b/drivers/net/ethernet/nxp/Kconfig
> @@ -3,6 +3,7 @@ config LPC_ENET
>          tristate "NXP ethernet MAC on LPC devices"
>          depends on ARCH_LPC32XX || COMPILE_TEST
>          select PHYLIB
> +       select CRC32
>          help
>            Say Y or M here if you want to use the NXP ethernet MAC included on
>            some NXP LPC devices. You can safely enable this option for LPC32xx
> diff --git a/drivers/net/ethernet/rocker/Kconfig b/drivers/net/ethernet/rocker/Kconfig
> index 99e1290e0307..2318811ff75a 100644
> --- a/drivers/net/ethernet/rocker/Kconfig
> +++ b/drivers/net/ethernet/rocker/Kconfig
> @@ -19,6 +19,7 @@ if NET_VENDOR_ROCKER
>   config ROCKER
>          tristate "Rocker switch driver (EXPERIMENTAL)"
>          depends on PCI && NET_SWITCHDEV && BRIDGE
> +       select CRC32
>          help
>            This driver supports Rocker switch device.
> 
> --
> 2.27.0
> 


-- 
Nicolas Ferre
