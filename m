Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD801AE680
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 22:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730964AbgDQUHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 16:07:47 -0400
Received: from mail-db8eur05on2040.outbound.protection.outlook.com ([40.107.20.40]:6102
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730573AbgDQUHq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 16:07:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Se/uV2Fp1rNP/+4xQdOZPOYZPRS7uNj4cf+Fn4+P/lsMvrOX75Y3mCrG1WuNUlREtcSbcp4cGMheJqUGU864XnZHemKryG9EaQjbS6fr0stP76vSn+R/NycijWJRXoYWmlzp05hAOnXHSF57Gu1Ut4M0n2VGdsmcOrTd+EFPv+X/NCNjr4K1diFPoYA01VZMvBEdNmLtvJQLcugsW4d9yFX1llOW18dQJdJ/BgA+qZiKb9HYbQ9ogMlPqP2wH2rNazgHu9Za7hlFIXDi3kr44pxY81n5jDdju5qj2bVBOnDjKt1n/FD/qOVfpA7evNcXy1isSiiXL3Uuck61eovTLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TEzc49bRaJZMftpxxk2nAahwYWsKjRFnN39BIl6kFhU=;
 b=bpCDOhF6FAdvRjK+Z+PbrT3/659yoTLUFYubqmffYPRY9YMWHuFTNppFwKj2+8iVtNMIG3seZzwF9nTR0G7G3qwdg2KZjpScf9ndR7k95rARQ6BZ5e3UicRWRZRqjecFs1J4jLfmOzUWpFR8HBZPWGHhtVkhce5XZ/MQRvyRL8OT++ozQNvg07tETp3Dp7hZIGZg1s21e6SyNSdh1EiOP0BT+SBCwNt7SYCdCmOCbnqTfmjj5j47YNG63MiZWJ5D3VWH/1jh4vsK0vaPCw427IUdnBrKu+R9MicoAzrmQlXVVYJd7GIPNd8pPYGxLVzpt8qle8tF2N+96o+laXGZEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TEzc49bRaJZMftpxxk2nAahwYWsKjRFnN39BIl6kFhU=;
 b=sQyCqj5g0Ry6bRIVRahrLr0Sl3oC7uEc/K3JftGwCX5tFDVrIXTxWz/18ttjtSwtlkL1tYE4qbrt1ZTFn9mLHCzh/JVnCedlY6Erkndr3NpQtaSk4SQQm6jTtvSZl+eBaOybfLFrRDZBuKQXpsdJMpPb4QAx+uz0gs4UtU5Vkf8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5917.eurprd05.prod.outlook.com (2603:10a6:803:e5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.17; Fri, 17 Apr
 2020 20:07:33 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2900.030; Fri, 17 Apr 2020
 20:07:33 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Masahiro Yamada <masahiroy@kernel.org>,
        linux-kbuild@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Nicolas Pitre <nico@fluxnic.net>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Saeed Mahameed <saeedm@mellanox.com>, narmstrong@baylibre.com,
        Laurent.pinchart@ideasonboard.com, leon@kernel.org,
        kieran.bingham+renesas@ideasonboard.com, jonas@kwiboo.se,
        airlied@linux.ie, jernej.skrabec@siol.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [RFC PATCH v2 3/3] treewide: drivers: Convert to "uses" keyword for Kconfig weak dependencies
Date:   Fri, 17 Apr 2020 13:06:27 -0700
Message-Id: <20200417200627.129849-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200417200627.129849-1-saeedm@mellanox.com>
References: <20200417200627.129849-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0100.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::41) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0100.namprd05.prod.outlook.com (2603:10b6:a03:e0::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.9 via Frontend Transport; Fri, 17 Apr 2020 20:07:26 +0000
X-Mailer: git-send-email 2.25.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 891840b0-3df2-4034-8f51-08d7e30af58d
X-MS-TrafficTypeDiagnostic: VI1PR05MB5917:|VI1PR05MB5917:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB59171F432A9DE02B25D219A1BED90@VI1PR05MB5917.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-Forefront-PRVS: 0376ECF4DD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(346002)(376002)(366004)(39860400002)(396003)(8676002)(7416002)(26005)(478600001)(86362001)(2906002)(81156014)(52116002)(4326008)(186003)(16526019)(36756003)(956004)(5660300002)(2616005)(54906003)(1076003)(316002)(66556008)(66946007)(66476007)(6506007)(30864003)(8936002)(6512007)(6486002)(54420400002)(579004)(559001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HQter5P71gpziQWuy4cWxRWaFNSZGCXOSSQuar3MHcgsR2nLrKlul3fvFBhMQhfh4uRT0XNLdoLx38VAdohePUoS/EYs5xP0J2/Icn+NOuQtEI6mCwabEvyLqMg45/61EdXHhFozuosFmxeLNVUOYwcXEokkk98wuo8+aV/0pdgQGgeXOdzxqpkNd16NxZ9MN+LUvDNnHsJEGCn6ezkwuuzQN1TDAA8ZLzYhATH8tRJCN79OH7xE3qm1hFRMi/596+IrJNJUO1cxt2q052sy+hEQD6/RllidzJW52Q/jB3rVxkO5nO5vNgo8sCJXDWIDjIoc+Tvf9lmhaVDHKtmzoiHaDVvT6rAkLPp2JOqNe5/Ry4CtXzQwhKEV3YJBDqQlEEjQgScfDC8+maV7Z6O83Fxvdy3vHKZs+nh8zC3Z7XgINmak/hdk8042M5GIPjIUswtPZTsazIStDpp5BmPDi8O7HoeTwo3xo3BGIvu2IO00cfT1ZOWw1L9baiLQ1wd7
X-MS-Exchange-AntiSpam-MessageData: IInOFpP5PPV/NoLeU36FHptUnRZeOC4rCRp6Ki4fbm2TyAgxrTNYEzc0qBlNfCTB5xRzvGBdlnWSMEagLQiHl+aKZPPeijPZntdQCFzQyJuF1PlucBY6/wXQZbnAry2/Tt7Uu/dS7lfHRpks9mvUCg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 891840b0-3df2-4034-8f51-08d7e30af58d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2020 20:07:33.0634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TYxTwNMLEVlhoar74zu8/4GOuxt4auJ1mrBynfQXrskPKjEkPUc4Me3/GRGWO4pFOwJ4c7GNXHeDTvesZnOxhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5917
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the introduction of the "uses" keyword we can avoid repetition and
the explicit confusing expression statement of weak Kconfig dependencies
i.e. (FOO || !FOO).

Convert all single appearances of the above pattern treewide.

This was done via the following script: Courtesy of Arnd Bergmann.

$ git ls-files | grep Kconfig | xargs sed -i 's:depends.on.\([A-Z0-9_a-z]\+\) || \(\1 \?= \?n\|!\1\):uses \1:'

Tested only with make olddefconfig.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/bluetooth/Kconfig                   |  4 +-
 drivers/crypto/hisilicon/Kconfig            |  8 +--
 drivers/edac/Kconfig                        |  4 +-
 drivers/gpu/drm/Kconfig                     |  2 +-
 drivers/gpu/drm/bridge/Kconfig              |  2 +-
 drivers/gpu/drm/msm/Kconfig                 |  4 +-
 drivers/gpu/ipu-v3/Kconfig                  |  2 +-
 drivers/hid/Kconfig                         |  2 +-
 drivers/hwmon/Kconfig                       | 14 ++---
 drivers/iio/adc/Kconfig                     |  2 +-
 drivers/infiniband/hw/i40iw/Kconfig         |  2 +-
 drivers/input/serio/Kconfig                 |  2 +-
 drivers/input/touchscreen/Kconfig           |  2 +-
 drivers/leds/Kconfig                        |  6 +-
 drivers/md/Kconfig                          |  2 +-
 drivers/media/platform/Kconfig              |  2 +-
 drivers/media/usb/dvb-usb/Kconfig           |  2 +-
 drivers/media/usb/gspca/Kconfig             |  2 +-
 drivers/misc/Kconfig                        |  2 +-
 drivers/net/Kconfig                         | 14 ++---
 drivers/net/dsa/b53/Kconfig                 |  2 +-
 drivers/net/ethernet/aquantia/Kconfig       |  2 +-
 drivers/net/ethernet/broadcom/Kconfig       |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/Kconfig | 12 ++--
 drivers/net/ethernet/netronome/Kconfig      |  2 +-
 drivers/net/phy/Kconfig                     |  4 +-
 drivers/net/wireless/ath/wcn36xx/Kconfig    |  4 +-
 drivers/phy/motorola/Kconfig                |  2 +-
 drivers/phy/qualcomm/Kconfig                |  8 +--
 drivers/phy/renesas/Kconfig                 |  2 +-
 drivers/phy/ti/Kconfig                      |  2 +-
 drivers/pinctrl/Kconfig                     |  2 +-
 drivers/platform/x86/Kconfig                | 62 ++++++++++-----------
 drivers/power/supply/Kconfig                |  2 +-
 drivers/remoteproc/Kconfig                  | 20 +++----
 drivers/scsi/Kconfig                        |  4 +-
 drivers/scsi/cxgbi/cxgb4i/Kconfig           |  2 +-
 drivers/scsi/qla2xxx/Kconfig                |  2 +-
 drivers/staging/wfx/Kconfig                 |  2 +-
 drivers/thermal/Kconfig                     |  4 +-
 drivers/usb/dwc2/Kconfig                    |  2 +-
 drivers/usb/dwc3/Kconfig                    |  4 +-
 drivers/usb/gadget/udc/Kconfig              |  2 +-
 drivers/usb/mtu3/Kconfig                    |  2 +-
 drivers/usb/musb/Kconfig                    |  2 +-
 drivers/usb/phy/Kconfig                     | 12 ++--
 drivers/usb/renesas_usbhs/Kconfig           |  2 +-
 drivers/usb/typec/tcpm/Kconfig              |  2 +-
 drivers/watchdog/Kconfig                    |  4 +-
 lib/crypto/Kconfig                          | 12 ++--
 net/bluetooth/Kconfig                       |  2 +-
 net/bridge/Kconfig                          |  2 +-
 net/dsa/Kconfig                             |  2 +-
 net/ipv4/Kconfig                            |  2 +-
 net/mpls/Kconfig                            |  2 +-
 net/netfilter/Kconfig                       | 24 ++++----
 net/nfc/Kconfig                             |  2 +-
 net/rds/Kconfig                             |  2 +-
 net/sctp/Kconfig                            |  2 +-
 net/wimax/Kconfig                           |  2 +-
 net/wireless/Kconfig                        |  2 +-
 sound/soc/fsl/Kconfig                       |  2 +-
 62 files changed, 156 insertions(+), 156 deletions(-)

diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
index 4e73a531b377..c3cb5b739dd7 100644
--- a/drivers/bluetooth/Kconfig
+++ b/drivers/bluetooth/Kconfig
@@ -87,8 +87,8 @@ config BT_HCIBTSDIO
 
 config BT_HCIUART
 	tristate "HCI UART driver"
-	depends on SERIAL_DEV_BUS || !SERIAL_DEV_BUS
-	depends on NVMEM || !NVMEM
+	uses SERIAL_DEV_BUS
+	uses NVMEM
 	depends on TTY
 	help
 	  Bluetooth HCI UART driver.
diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
index f09c6cf7823e..89425b453aa4 100644
--- a/drivers/crypto/hisilicon/Kconfig
+++ b/drivers/crypto/hisilicon/Kconfig
@@ -27,7 +27,7 @@ config CRYPTO_DEV_HISI_SEC2
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
 	depends on PCI && PCI_MSI
-	depends on UACCE || UACCE=n
+	uses UACCE
 	depends on ARM64 || (COMPILE_TEST && 64BIT)
 	help
 	  Support for HiSilicon SEC Engine of version 2 in crypto subsystem.
@@ -41,7 +41,7 @@ config CRYPTO_DEV_HISI_QM
 	tristate
 	depends on ARM64 || COMPILE_TEST
 	depends on PCI && PCI_MSI
-	depends on UACCE || UACCE=n
+	uses UACCE
 	help
 	  HiSilicon accelerator engines use a common queue management
 	  interface. Specific engine driver may use this module.
@@ -51,7 +51,7 @@ config CRYPTO_DEV_HISI_ZIP
 	depends on PCI && PCI_MSI
 	depends on ARM64 || (COMPILE_TEST && 64BIT)
 	depends on !CPU_BIG_ENDIAN || COMPILE_TEST
-	depends on UACCE || UACCE=n
+	uses UACCE
 	select CRYPTO_DEV_HISI_QM
 	help
 	  Support for HiSilicon ZIP Driver
@@ -59,7 +59,7 @@ config CRYPTO_DEV_HISI_ZIP
 config CRYPTO_DEV_HISI_HPRE
 	tristate "Support for HISI HPRE accelerator"
 	depends on PCI && PCI_MSI
-	depends on UACCE || UACCE=n
+	uses UACCE
 	depends on ARM64 || (COMPILE_TEST && 64BIT)
 	select CRYPTO_DEV_HISI_QM
 	select CRYPTO_DH
diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index fe2eb892a1bd..2e065ff5c1dc 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -232,7 +232,7 @@ config EDAC_SBRIDGE
 config EDAC_SKX
 	tristate "Intel Skylake server Integrated MC"
 	depends on PCI && X86_64 && X86_MCE_INTEL && PCI_MMCONFIG && ACPI
-	depends on ACPI_NFIT || !ACPI_NFIT # if ACPI_NFIT=m, EDAC_SKX can't be y
+	uses ACPI_NFIT # if ACPI_NFIT=m, EDAC_SKX can't be y
 	select DMI
 	select ACPI_ADXL
 	help
@@ -244,7 +244,7 @@ config EDAC_SKX
 config EDAC_I10NM
 	tristate "Intel 10nm server Integrated MC"
 	depends on PCI && X86_64 && X86_MCE_INTEL && PCI_MMCONFIG && ACPI
-	depends on ACPI_NFIT || !ACPI_NFIT # if ACPI_NFIT=m, EDAC_I10NM can't be y
+	uses ACPI_NFIT # if ACPI_NFIT=m, EDAC_I10NM can't be y
 	select DMI
 	select ACPI_ADXL
 	help
diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 43594978958e..a009dfc20bec 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -445,7 +445,7 @@ config DRM_MGA
 config DRM_SIS
 	tristate "SiS video cards"
 	depends on DRM && AGP
-	depends on FB_SIS || FB_SIS=n
+	uses FB_SIS
 	help
 	  Choose this option if you have a SiS 630 or compatible video
 	  chipset. If M is selected the module will be called sis. AGP
diff --git a/drivers/gpu/drm/bridge/Kconfig b/drivers/gpu/drm/bridge/Kconfig
index aaed2347ace9..b8a097ff3671 100644
--- a/drivers/gpu/drm/bridge/Kconfig
+++ b/drivers/gpu/drm/bridge/Kconfig
@@ -91,7 +91,7 @@ config DRM_SIL_SII8620
 	depends on OF
 	select DRM_KMS_HELPER
 	imply EXTCON
-	depends on RC_CORE || !RC_CORE
+	uses RC_CORE
 	help
 	  Silicon Image SII8620 HDMI/MHL bridge chip driver.
 
diff --git a/drivers/gpu/drm/msm/Kconfig b/drivers/gpu/drm/msm/Kconfig
index 6deaa7d01654..ae9a397a2e53 100644
--- a/drivers/gpu/drm/msm/Kconfig
+++ b/drivers/gpu/drm/msm/Kconfig
@@ -6,8 +6,8 @@ config DRM_MSM
 	depends on ARCH_QCOM || SOC_IMX5 || (ARM && COMPILE_TEST)
 	depends on OF && COMMON_CLK
 	depends on MMU
-	depends on INTERCONNECT || !INTERCONNECT
-	depends on QCOM_OCMEM || QCOM_OCMEM=n
+	uses INTERCONNECT
+	uses QCOM_OCMEM
 	select QCOM_MDT_LOADER if ARCH_QCOM
 	select REGULATOR
 	select DRM_KMS_HELPER
diff --git a/drivers/gpu/ipu-v3/Kconfig b/drivers/gpu/ipu-v3/Kconfig
index 061fb990c120..e1c489144f94 100644
--- a/drivers/gpu/ipu-v3/Kconfig
+++ b/drivers/gpu/ipu-v3/Kconfig
@@ -2,7 +2,7 @@
 config IMX_IPUV3_CORE
 	tristate "IPUv3 core support"
 	depends on SOC_IMX5 || SOC_IMX6Q || ARCH_MULTIPLATFORM || COMPILE_TEST
-	depends on DRM || !DRM # if DRM=m, this can't be 'y'
+	uses DRM # if DRM=m, this can't be 'y'
 	select BITREVERSE
 	select GENERIC_ALLOCATOR if DRM
 	select GENERIC_IRQ_CHIP
diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 7c89edbd6c5a..df7728b17fa4 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -150,7 +150,7 @@ config HID_APPLEIR
 config HID_ASUS
 	tristate "Asus"
 	depends on LEDS_CLASS
-	depends on ASUS_WMI || ASUS_WMI=n
+	uses ASUS_WMI
 	select POWER_SUPPLY
 	---help---
 	Support for Asus notebook built-in keyboard and touchpad via i2c, and
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 05a30832c6ba..9416c968fdd6 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -350,7 +350,7 @@ config SENSORS_APPLESMC
 config SENSORS_ARM_SCMI
 	tristate "ARM SCMI Sensors"
 	depends on ARM_SCMI_PROTOCOL
-	depends on THERMAL || !THERMAL_OF
+	uses THERMAL_OF
 	help
 	  This driver provides support for temperature, voltage, current
 	  and power sensors available on SCMI based platforms. The actual
@@ -362,7 +362,7 @@ config SENSORS_ARM_SCMI
 config SENSORS_ARM_SCPI
 	tristate "ARM SCPI Sensors"
 	depends on ARM_SCPI_PROTOCOL
-	depends on THERMAL || !THERMAL_OF
+	uses THERMAL_OF
 	help
 	  This driver provides support for temperature, voltage, current
 	  and power sensors available on ARM Ltd's SCP based platforms. The
@@ -381,7 +381,7 @@ config SENSORS_ASB100
 
 config SENSORS_ASPEED
 	tristate "ASPEED AST2400/AST2500 PWM and Fan tach driver"
-	depends on THERMAL || THERMAL=n
+	uses THERMAL
 	select REGMAP
 	help
 	  This driver provides support for ASPEED AST2400/AST2500 PWM
@@ -602,7 +602,7 @@ config SENSORS_GPIO_FAN
 	tristate "GPIO fan"
 	depends on OF_GPIO
 	depends on GPIOLIB || COMPILE_TEST
-	depends on THERMAL || THERMAL=n
+	uses THERMAL
 	help
 	  If you say yes here you get support for fans connected to GPIO lines.
 
@@ -975,7 +975,7 @@ config SENSORS_MAX6642
 config SENSORS_MAX6650
 	tristate "Maxim MAX6650 sensor chip"
 	depends on I2C
-	depends on THERMAL || THERMAL=n
+	uses THERMAL
 	help
 	  If you say yes here you get support for the MAX6650 / MAX6651
 	  sensor chips.
@@ -1289,7 +1289,7 @@ config SENSORS_PC87427
 config SENSORS_NTC_THERMISTOR
 	tristate "NTC thermistor support from Murata"
 	depends on !OF || IIO=n || IIO
-	depends on THERMAL || !THERMAL_OF
+	uses THERMAL_OF
 	help
 	  This driver supports NTC thermistors sensor reading and its
 	  interpretation. The driver can also monitor the temperature and
@@ -1393,7 +1393,7 @@ source "drivers/hwmon/pmbus/Kconfig"
 config SENSORS_PWM_FAN
 	tristate "PWM fan"
 	depends on (PWM && OF) || COMPILE_TEST
-	depends on THERMAL || THERMAL=n
+	uses THERMAL
 	help
 	  If you say yes here you get support for fans connected to PWM lines.
 	  The driver uses the generic PWM interface, thus it will work on a
diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index 12bb8b7ca1ff..dbdcb4380bf6 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -929,7 +929,7 @@ config SUN4I_GPADC
 	tristate "Support for the Allwinner SoCs GPADC"
 	depends on IIO
 	depends on MFD_SUN4I_GPADC || MACH_SUN8I
-	depends on THERMAL || !THERMAL_OF
+	uses THERMAL_OF
 	select REGMAP_IRQ
 	help
 	  Say yes here to build support for Allwinner (A10, A13 and A31) SoCs
diff --git a/drivers/infiniband/hw/i40iw/Kconfig b/drivers/infiniband/hw/i40iw/Kconfig
index e4b45f4cd8f8..a83eb0be04af 100644
--- a/drivers/infiniband/hw/i40iw/Kconfig
+++ b/drivers/infiniband/hw/i40iw/Kconfig
@@ -2,7 +2,7 @@
 config INFINIBAND_I40IW
 	tristate "Intel(R) Ethernet X722 iWARP Driver"
 	depends on INET && I40E
-	depends on IPV6 || !IPV6
+	uses IPV6
 	depends on PCI
 	select GENERIC_ALLOCATOR
 	---help---
diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index 373a1646019e..1dc0c792c642 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -177,7 +177,7 @@ config SERIO_SGI_IOC3
 
 config SERIO_LIBPS2
 	tristate "PS/2 driver library"
-	depends on SERIO_I8042 || SERIO_I8042=n
+	uses SERIO_I8042
 	help
 	  Say Y here if you are using a driver for device connected
 	  to a PS/2 port, such as PS/2 mouse or standard AT keyboard.
diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index c071f7c407b6..fcc040d7ff98 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -1196,7 +1196,7 @@ config TOUCHSCREEN_SUN4I
 	tristate "Allwinner sun4i resistive touchscreen controller support"
 	depends on ARCH_SUNXI || COMPILE_TEST
 	depends on HWMON
-	depends on THERMAL || !THERMAL_OF
+	uses THERMAL_OF
 	help
 	  This selects support for the resistive touchscreen controller
 	  found on Allwinner sunxi SoCs.
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index c664d84e1667..93acfab6789b 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -52,7 +52,7 @@ config LEDS_88PM860X
 config LEDS_AAT1290
 	tristate "LED support for the AAT1290"
 	depends on LEDS_CLASS_FLASH
-	depends on V4L2_FLASH_LED_CLASS || !V4L2_FLASH_LED_CLASS
+	uses V4L2_FLASH_LED_CLASS
 	depends on GPIOLIB || COMPILE_TEST
 	depends on OF
 	depends on PINCTRL
@@ -86,7 +86,7 @@ config LEDS_APU
 config LEDS_AS3645A
 	tristate "AS3645A and LM3555 LED flash controllers support"
 	depends on I2C && LEDS_CLASS_FLASH
-	depends on V4L2_FLASH_LED_CLASS || !V4L2_FLASH_LED_CLASS
+	uses V4L2_FLASH_LED_CLASS
 	help
 	  Enable LED flash class support for AS3645A LED flash
 	  controller. V4L2 flash API is provided as well if
@@ -646,7 +646,7 @@ config LEDS_MAX77650
 config LEDS_MAX77693
 	tristate "LED support for MAX77693 Flash"
 	depends on LEDS_CLASS_FLASH
-	depends on V4L2_FLASH_LED_CLASS || !V4L2_FLASH_LED_CLASS
+	uses V4L2_FLASH_LED_CLASS
 	depends on MFD_MAX77693
 	depends on OF
 	help
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index d6d5ab23c088..86e1c999c24e 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -202,7 +202,7 @@ config BLK_DEV_DM_BUILTIN
 config BLK_DEV_DM
 	tristate "Device mapper support"
 	select BLK_DEV_DM_BUILTIN
-	depends on DAX || DAX=n
+	uses DAX
 	---help---
 	  Device-mapper is a low level volume manager.  It works by allowing
 	  people to specify mappings for ranges of logical sectors.  Various
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index e01bbb9dd1c1..ef21d74a0b7e 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -483,7 +483,7 @@ config VIDEO_QCOM_VENUS
 	tristate "Qualcomm Venus V4L2 encoder/decoder driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
 	depends on (ARCH_QCOM && IOMMU_DMA) || COMPILE_TEST
-	depends on INTERCONNECT || !INTERCONNECT
+	uses INTERCONNECT
 	select QCOM_MDT_LOADER if ARCH_QCOM
 	select QCOM_SCM if ARCH_QCOM
 	select VIDEOBUF2_DMA_SG
diff --git a/drivers/media/usb/dvb-usb/Kconfig b/drivers/media/usb/dvb-usb/Kconfig
index 1a3e5f965ae4..d153f50a7349 100644
--- a/drivers/media/usb/dvb-usb/Kconfig
+++ b/drivers/media/usb/dvb-usb/Kconfig
@@ -45,7 +45,7 @@ config DVB_USB_DIBUSB_MB
 	depends on DVB_USB
 	select DVB_PLL if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_DIB3000MB
-	depends on DVB_DIB3000MC || !DVB_DIB3000MC
+	uses DVB_DIB3000MC
 	select MEDIA_TUNER_MT2060 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Support for USB 1.1 and 2.0 DVB-T receivers based on reference designs made by
diff --git a/drivers/media/usb/gspca/Kconfig b/drivers/media/usb/gspca/Kconfig
index 77a360958239..79ce2ff04632 100644
--- a/drivers/media/usb/gspca/Kconfig
+++ b/drivers/media/usb/gspca/Kconfig
@@ -2,7 +2,7 @@
 menuconfig USB_GSPCA
 	tristate "GSPCA based webcams"
 	depends on VIDEO_V4L2
-	depends on INPUT || INPUT=n
+	uses INPUT
 	select VIDEOBUF2_VMALLOC
 	default m
 	help
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 99e151475d8f..43c0809cc811 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -68,7 +68,7 @@ config DUMMY_IRQ
 config IBM_ASM
 	tristate "Device driver for IBM RSA service processor"
 	depends on X86 && PCI && INPUT
-	depends on SERIAL_8250 || SERIAL_8250=n
+	uses SERIAL_8250
 	---help---
 	  This option enables device driver support for in-band access to the
 	  IBM RSA (Condor) service processor in eServer xSeries systems.
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index b103fbdd0f68..b7fd398a16a6 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -41,7 +41,7 @@ if NET_CORE
 config BONDING
 	tristate "Bonding driver support"
 	depends on INET
-	depends on IPV6 || IPV6=n
+	uses IPV6
 	---help---
 	  Say 'Y' or 'M' if you wish to be able to 'bond' multiple Ethernet
 	  Channels together. This is called 'Etherchannel' by Cisco,
@@ -74,7 +74,7 @@ config DUMMY
 config WIREGUARD
 	tristate "WireGuard secure network tunnel"
 	depends on NET && INET
-	depends on IPV6 || !IPV6
+	uses IPV6
 	select NET_UDP_TUNNEL
 	select DST_CACHE
 	select CRYPTO
@@ -199,7 +199,7 @@ config IPVLAN_L3S
 config IPVLAN
 	tristate "IP-VLAN support"
 	depends on INET
-	depends on IPV6 || !IPV6
+	uses IPV6
 	---help---
 	  This allows one to create virtual devices off of a main interface
 	  and packets will be delivered based on the dest L3 (IPv6/IPv4 addr)
@@ -246,7 +246,7 @@ config VXLAN
 config GENEVE
 	tristate "Generic Network Virtualization Encapsulation"
 	depends on INET
-	depends on IPV6 || !IPV6
+	uses IPV6
 	select NET_UDP_TUNNEL
 	select GRO_CELLS
 	---help---
@@ -262,7 +262,7 @@ config GENEVE
 config BAREUDP
        tristate "Bare UDP Encapsulation"
        depends on INET
-       depends on IPV6 || !IPV6
+       uses IPV6
        select NET_UDP_TUNNEL
        select GRO_CELLS
        help
@@ -412,7 +412,7 @@ config NET_VRF
 	tristate "Virtual Routing and Forwarding (Lite)"
 	depends on IP_MULTIPLE_TABLES
 	depends on NET_L3_MASTER_DEV
-	depends on IPV6 || IPV6=n
+	uses IPV6
 	depends on IPV6_MULTIPLE_TABLES || IPV6=n
 	---help---
 	  This option enables the support for mapping interfaces into VRF's. The
@@ -566,7 +566,7 @@ config NETDEVSIM
 	tristate "Simulated networking device"
 	depends on DEBUG_FS
 	depends on INET
-	depends on IPV6 || IPV6=n
+	uses IPV6
 	select NET_DEVLINK
 	help
 	  This driver is a developer testing tool and software model that can
diff --git a/drivers/net/dsa/b53/Kconfig b/drivers/net/dsa/b53/Kconfig
index f9891a81c808..d4b124247cda 100644
--- a/drivers/net/dsa/b53/Kconfig
+++ b/drivers/net/dsa/b53/Kconfig
@@ -32,7 +32,7 @@ config B53_MMAP_DRIVER
 config B53_SRAB_DRIVER
 	tristate "B53 SRAB connected switch driver"
 	depends on B53 && HAS_IOMEM
-	depends on B53_SERDES || !B53_SERDES
+	uses B53_SERDES
 	default ARCH_BCM_IPROC
 	help
 	  Select to enable support for memory-mapped Switch Register Access
diff --git a/drivers/net/ethernet/aquantia/Kconfig b/drivers/net/ethernet/aquantia/Kconfig
index 76a44b2546ff..575ea831511f 100644
--- a/drivers/net/ethernet/aquantia/Kconfig
+++ b/drivers/net/ethernet/aquantia/Kconfig
@@ -20,7 +20,7 @@ config AQTION
 	tristate "aQuantia AQtion(tm) Support"
 	depends on PCI
 	depends on X86_64 || ARM64 || COMPILE_TEST
-	depends on MACSEC || MACSEC=n
+	uses MACSEC
 	---help---
 	  This enables the support for the aQuantia AQtion(tm) Ethernet card.
 
diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index 53055ce5dfd6..462331914f92 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -184,7 +184,7 @@ config BGMAC_PLATFORM
 config SYSTEMPORT
 	tristate "Broadcom SYSTEMPORT internal MAC support"
 	depends on HAS_IOMEM
-	depends on NET_DSA || !NET_DSA
+	uses NET_DSA
 	select MII
 	select PHYLIB
 	select FIXED_PHY
diff --git a/drivers/net/ethernet/mellanox/mlxsw/Kconfig b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
index f458fd1ce9f8..8642aee4f028 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlxsw/Kconfig
@@ -73,12 +73,12 @@ config MLXSW_SWITCHX2
 config MLXSW_SPECTRUM
 	tristate "Mellanox Technologies Spectrum family support"
 	depends on MLXSW_CORE && MLXSW_PCI && NET_SWITCHDEV && VLAN_8021Q
-	depends on PSAMPLE || PSAMPLE=n
-	depends on BRIDGE || BRIDGE=n
-	depends on IPV6 || IPV6=n
-	depends on NET_IPGRE || NET_IPGRE=n
-	depends on IPV6_GRE || IPV6_GRE=n
-	depends on VXLAN || VXLAN=n
+	uses PSAMPLE
+	uses BRIDGE
+	uses IPV6
+	uses NET_IPGRE
+	uses IPV6_GRE
+	uses VXLAN
 	select GENERIC_ALLOCATOR
 	select PARMAN
 	select OBJAGG
diff --git a/drivers/net/ethernet/netronome/Kconfig b/drivers/net/ethernet/netronome/Kconfig
index a3f68a718813..246b36a9ea39 100644
--- a/drivers/net/ethernet/netronome/Kconfig
+++ b/drivers/net/ethernet/netronome/Kconfig
@@ -19,7 +19,7 @@ if NET_VENDOR_NETRONOME
 config NFP
 	tristate "Netronome(R) NFP4000/NFP6000 NIC driver"
 	depends on PCI && PCI_MSI
-	depends on VXLAN || VXLAN=n
+	uses VXLAN
 	depends on TLS && TLS_DEVICE || TLS_DEVICE=n
 	select NET_DEVLINK
 	---help---
diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 3fa33d27eeba..87c8e408f32c 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -276,7 +276,7 @@ comment "MII PHY device drivers"
 config SFP
 	tristate "SFP cage support"
 	depends on I2C && PHYLINK
-	depends on HWMON || HWMON=n
+	uses HWMON
 	select MDIO_I2C
 
 config ADIN_PHY
@@ -460,7 +460,7 @@ config MICROCHIP_T1_PHY
 
 config MICROSEMI_PHY
 	tristate "Microsemi PHYs"
-	depends on MACSEC || MACSEC=n
+	uses MACSEC
 	select CRYPTO_AES
 	select CRYPTO_ECB
 	---help---
diff --git a/drivers/net/wireless/ath/wcn36xx/Kconfig b/drivers/net/wireless/ath/wcn36xx/Kconfig
index a4b153470a2c..04ee6aa301b1 100644
--- a/drivers/net/wireless/ath/wcn36xx/Kconfig
+++ b/drivers/net/wireless/ath/wcn36xx/Kconfig
@@ -2,8 +2,8 @@
 config WCN36XX
 	tristate "Qualcomm Atheros WCN3660/3680 support"
 	depends on MAC80211 && HAS_DMA
-	depends on QCOM_WCNSS_CTRL || QCOM_WCNSS_CTRL=n
-	depends on RPMSG || RPMSG=n
+	uses QCOM_WCNSS_CTRL
+	uses RPMSG
 	---help---
 	  This module adds support for wireless adapters based on
 	  Qualcomm Atheros WCN3660 and WCN3680 mobile chipsets.
diff --git a/drivers/phy/motorola/Kconfig b/drivers/phy/motorola/Kconfig
index 4b5e605a3daa..1ff125e33ed2 100644
--- a/drivers/phy/motorola/Kconfig
+++ b/drivers/phy/motorola/Kconfig
@@ -5,7 +5,7 @@
 config PHY_CPCAP_USB
 	tristate "CPCAP PMIC USB PHY driver"
 	depends on USB_SUPPORT && IIO
-	depends on USB_MUSB_HDRC || USB_MUSB_HDRC=n
+	uses USB_MUSB_HDRC
 	select GENERIC_PHY
 	select USB_PHY
 	help
diff --git a/drivers/phy/qualcomm/Kconfig b/drivers/phy/qualcomm/Kconfig
index 98674ed094d9..2117ea22778c 100644
--- a/drivers/phy/qualcomm/Kconfig
+++ b/drivers/phy/qualcomm/Kconfig
@@ -44,7 +44,7 @@ config PHY_QCOM_QMP
 config PHY_QCOM_QUSB2
 	tristate "Qualcomm QUSB2 PHY Driver"
 	depends on OF && (ARCH_QCOM || COMPILE_TEST)
-	depends on NVMEM || !NVMEM
+	uses NVMEM
 	select GENERIC_PHY
 	help
 	  Enable this to support the HighSpeed QUSB2 PHY transceiver for USB
@@ -79,7 +79,7 @@ endif
 config PHY_QCOM_USB_HS
 	tristate "Qualcomm USB HS PHY module"
 	depends on USB_ULPI_BUS
-	depends on EXTCON || !EXTCON # if EXTCON=m, this cannot be built-in
+	uses EXTCON # if EXTCON=m, this cannot be built-in
 	select GENERIC_PHY
 	help
 	  Support for the USB high-speed ULPI compliant phy on Qualcomm
@@ -95,7 +95,7 @@ config PHY_QCOM_USB_HSIC
 config PHY_QCOM_USB_HS_28NM
 	tristate "Qualcomm 28nm High-Speed PHY"
 	depends on ARCH_QCOM || COMPILE_TEST
-	depends on EXTCON || !EXTCON # if EXTCON=m, this cannot be built-in
+	uses EXTCON # if EXTCON=m, this cannot be built-in
 	select GENERIC_PHY
 	help
 	  Enable this to support the Qualcomm Synopsys DesignWare Core 28nm
@@ -106,7 +106,7 @@ config PHY_QCOM_USB_HS_28NM
 config PHY_QCOM_USB_SS
 	tristate "Qualcomm USB Super-Speed PHY driver"
 	depends on ARCH_QCOM || COMPILE_TEST
-	depends on EXTCON || !EXTCON # if EXTCON=m, this cannot be built-in
+	uses EXTCON # if EXTCON=m, this cannot be built-in
 	select GENERIC_PHY
 	help
 	  Enable this to support the Super-Speed USB transceiver on various
diff --git a/drivers/phy/renesas/Kconfig b/drivers/phy/renesas/Kconfig
index 111bdcae775c..6d0bb0abf441 100644
--- a/drivers/phy/renesas/Kconfig
+++ b/drivers/phy/renesas/Kconfig
@@ -19,7 +19,7 @@ config PHY_RCAR_GEN3_PCIE
 config PHY_RCAR_GEN3_USB2
 	tristate "Renesas R-Car generation 3 USB 2.0 PHY driver"
 	depends on ARCH_RENESAS
-	depends on EXTCON || !EXTCON # if EXTCON=m, this cannot be built-in
+	uses EXTCON # if EXTCON=m, this cannot be built-in
 	depends on USB_SUPPORT
 	select GENERIC_PHY
 	select USB_COMMON
diff --git a/drivers/phy/ti/Kconfig b/drivers/phy/ti/Kconfig
index 15a3bcf32308..18a8dfa07a29 100644
--- a/drivers/phy/ti/Kconfig
+++ b/drivers/phy/ti/Kconfig
@@ -95,7 +95,7 @@ config TWL4030_USB
 	tristate "TWL4030 USB Transceiver Driver"
 	depends on TWL4030_CORE && REGULATOR_TWL4030 && USB_MUSB_OMAP2PLUS
 	depends on USB_SUPPORT
-	depends on USB_GADGET || !USB_GADGET # if USB_GADGET=m, this can't 'y'
+	uses USB_GADGET # if USB_GADGET=m, this can't 'y'
 	select GENERIC_PHY
 	select USB_PHY
 	help
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 834c59950d1c..9e9479b427b1 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -175,7 +175,7 @@ config PINCTRL_GEMINI
 config PINCTRL_MCP23S08
 	tristate "Microchip MCP23xxx I/O expander"
 	depends on SPI_MASTER || I2C
-	depends on I2C || I2C=n
+	uses I2C
 	select GPIOLIB
 	select GPIOLIB_IRQCHIP
 	select REGMAP_I2C if I2C
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 0ad7ad8cf8e1..dd10a0a06ac4 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -157,7 +157,7 @@ config ACER_WMI
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on SERIO_I8042
 	depends on INPUT
-	depends on RFKILL || RFKILL = n
+	uses RFKILL
 	depends on ACPI_WMI
 	select INPUT_SPARSEKMAP
 	# Acer WMI depends on ACPI_VIDEO when ACPI is enabled
@@ -190,8 +190,8 @@ config ASUS_LAPTOP
 	select NEW_LEDS
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on INPUT
-	depends on RFKILL || RFKILL = n
-	depends on ACPI_VIDEO || ACPI_VIDEO = n
+	uses RFKILL
+	uses ACPI_VIDEO
 	select INPUT_SPARSEKMAP
 	---help---
 	  This is a driver for Asus laptops, Lenovo SL and the Pegatron
@@ -230,9 +230,9 @@ config ASUS_WMI
 	depends on INPUT
 	depends on HWMON
 	depends on BACKLIGHT_CLASS_DEVICE
-	depends on RFKILL || RFKILL = n
+	uses RFKILL
 	depends on HOTPLUG_PCI
-	depends on ACPI_VIDEO || ACPI_VIDEO = n
+	uses ACPI_VIDEO
 	select INPUT_SPARSEKMAP
 	select LEDS_CLASS
 	select NEW_LEDS
@@ -246,7 +246,7 @@ config ASUS_WMI
 config ASUS_NB_WMI
 	tristate "Asus Notebook WMI Driver"
 	depends on ASUS_WMI
-	depends on SERIO_I8042 || SERIO_I8042 = n
+	uses SERIO_I8042
 	---help---
 	  This is a driver for newer Asus notebooks. It adds extra features
 	  like wireless radio and bluetooth control, leds, hotkeys, backlight...
@@ -261,8 +261,8 @@ config EEEPC_LAPTOP
 	tristate "Eee PC Hotkey Driver"
 	depends on ACPI
 	depends on INPUT
-	depends on RFKILL || RFKILL = n
-	depends on ACPI_VIDEO || ACPI_VIDEO = n
+	uses RFKILL
+	uses ACPI_VIDEO
 	depends on HOTPLUG_PCI
 	depends on BACKLIGHT_CLASS_DEVICE
 	select HWMON
@@ -315,8 +315,8 @@ config DCDBAS
 #
 config DELL_SMBIOS
 	tristate "Dell SMBIOS driver"
-	depends on DCDBAS || DCDBAS=n
-	depends on ACPI_WMI || ACPI_WMI=n
+	uses DCDBAS
+	uses ACPI_WMI
 	---help---
 	This provides support for the Dell SMBIOS calling interface.
 	If you have a Dell computer you should enable this option.
@@ -354,8 +354,8 @@ config DELL_LAPTOP
 	tristate "Dell Laptop Extras"
 	depends on DMI
 	depends on BACKLIGHT_CLASS_DEVICE
-	depends on ACPI_VIDEO || ACPI_VIDEO = n
-	depends on RFKILL || RFKILL = n
+	uses ACPI_VIDEO
+	uses RFKILL
 	depends on SERIO_I8042
 	depends on DELL_SMBIOS
 	select POWER_SUPPLY
@@ -410,7 +410,7 @@ config DELL_WMI
 	depends on ACPI_WMI
 	depends on DMI
 	depends on INPUT
-	depends on ACPI_VIDEO || ACPI_VIDEO = n
+	uses ACPI_VIDEO
 	depends on DELL_SMBIOS
 	select DELL_WMI_DESCRIPTOR
 	select INPUT_SPARSEKMAP
@@ -457,7 +457,7 @@ config FUJITSU_LAPTOP
 	depends on ACPI
 	depends on INPUT
 	depends on BACKLIGHT_CLASS_DEVICE
-	depends on ACPI_VIDEO || ACPI_VIDEO = n
+	uses ACPI_VIDEO
 	select INPUT_SPARSEKMAP
 	select LEDS_CLASS
 	---help---
@@ -534,7 +534,7 @@ config HP_WMI
 	tristate "HP WMI extras"
 	depends on ACPI_WMI
 	depends on INPUT
-	depends on RFKILL || RFKILL = n
+	uses RFKILL
 	select INPUT_SPARSEKMAP
 	help
 	 Say Y here if you want to support WMI-based hotkeys on HP laptops and
@@ -574,8 +574,8 @@ config IDEAPAD_LAPTOP
 	depends on RFKILL && INPUT
 	depends on SERIO_I8042
 	depends on BACKLIGHT_CLASS_DEVICE
-	depends on ACPI_VIDEO || ACPI_VIDEO = n
-	depends on ACPI_WMI || ACPI_WMI = n
+	uses ACPI_VIDEO
+	uses ACPI_WMI
 	select INPUT_SPARSEKMAP
 	help
 	  This is a driver for Lenovo IdeaPad netbooks contains drivers for
@@ -604,8 +604,8 @@ config THINKPAD_ACPI
 	depends on ACPI
 	depends on ACPI_BATTERY
 	depends on INPUT
-	depends on RFKILL || RFKILL = n
-	depends on ACPI_VIDEO || ACPI_VIDEO = n
+	uses RFKILL
+	uses ACPI_VIDEO
 	depends on BACKLIGHT_CLASS_DEVICE
 	select HWMON
 	select NVRAM
@@ -818,7 +818,7 @@ config INTEL_MENLOW
 config INTEL_OAKTRAIL
 	tristate "Intel Oaktrail Platform Extras"
 	depends on ACPI
-	depends on ACPI_VIDEO || ACPI_VIDEO = n
+	uses ACPI_VIDEO
 	depends on RFKILL && BACKLIGHT_CLASS_DEVICE && ACPI
 	---help---
 	  Intel Oaktrail platform need this driver to provide interfaces to
@@ -872,7 +872,7 @@ config MSI_LAPTOP
 	tristate "MSI Laptop Extras"
 	depends on ACPI
 	depends on BACKLIGHT_CLASS_DEVICE
-	depends on ACPI_VIDEO || ACPI_VIDEO = n
+	uses ACPI_VIDEO
 	depends on RFKILL
 	depends on INPUT && SERIO_I8042
 	select INPUT_SPARSEKMAP
@@ -895,7 +895,7 @@ config MSI_WMI
 	depends on ACPI_WMI
 	depends on INPUT
 	depends on BACKLIGHT_CLASS_DEVICE
-	depends on ACPI_VIDEO || ACPI_VIDEO = n
+	uses ACPI_VIDEO
 	select INPUT_SPARSEKMAP
 	help
 	 Say Y here if you want to support WMI-based hotkeys on MSI laptops.
@@ -937,8 +937,8 @@ config PCENGINES_APU2
 
 config SAMSUNG_LAPTOP
 	tristate "Samsung Laptop driver"
-	depends on RFKILL || RFKILL = n
-	depends on ACPI_VIDEO || ACPI_VIDEO = n
+	uses RFKILL
+	uses ACPI_VIDEO
 	depends on BACKLIGHT_CLASS_DEVICE
 	select LEDS_CLASS
 	select NEW_LEDS
@@ -969,9 +969,9 @@ config ACPI_TOSHIBA
 	select NEW_LEDS
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on INPUT
-	depends on SERIO_I8042 || SERIO_I8042 = n
-	depends on ACPI_VIDEO || ACPI_VIDEO = n
-	depends on RFKILL || RFKILL = n
+	uses SERIO_I8042
+	uses ACPI_VIDEO
+	uses RFKILL
 	depends on IIO
 	select INPUT_SPARSEKMAP
 	---help---
@@ -1000,7 +1000,7 @@ config ACPI_TOSHIBA
 config TOSHIBA_BT_RFKILL
 	tristate "Toshiba Bluetooth RFKill switch support"
 	depends on ACPI
-	depends on RFKILL || RFKILL = n
+	uses RFKILL
 	---help---
 	  This driver adds support for Bluetooth events for the RFKill
 	  switch on modern Toshiba laptops with full ACPI support and
@@ -1052,7 +1052,7 @@ config TOSHIBA_WMI
 config ACPI_CMPC
 	tristate "CMPC Laptop Extras"
 	depends on ACPI && INPUT
-	depends on RFKILL || RFKILL=n
+	uses RFKILL
 	select BACKLIGHT_CLASS_DEVICE
 	help
 	  Support for Intel Classmate PC ACPI devices, including some
@@ -1063,7 +1063,7 @@ config COMPAL_LAPTOP
 	tristate "Compal (and others) Laptop Extras"
 	depends on ACPI
 	depends on BACKLIGHT_CLASS_DEVICE
-	depends on ACPI_VIDEO || ACPI_VIDEO = n
+	uses ACPI_VIDEO
 	depends on RFKILL
 	depends on HWMON
 	depends on POWER_SUPPLY
@@ -1103,7 +1103,7 @@ config PANASONIC_LAPTOP
 config SONY_LAPTOP
 	tristate "Sony Laptop Extras"
 	depends on ACPI
-	depends on ACPI_VIDEO || ACPI_VIDEO = n
+	uses ACPI_VIDEO
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on INPUT
 	depends on RFKILL
diff --git a/drivers/power/supply/Kconfig b/drivers/power/supply/Kconfig
index f3424fdce341..9ad2218b2c59 100644
--- a/drivers/power/supply/Kconfig
+++ b/drivers/power/supply/Kconfig
@@ -436,7 +436,7 @@ config CHARGER_CPCAP
 config CHARGER_ISP1704
 	tristate "ISP1704 USB Charger Detection"
 	depends on USB_PHY
-	depends on USB_GADGET || !USB_GADGET # if USB_GADGET=m, this can't be 'y'
+	uses USB_GADGET # if USB_GADGET=m, this can't be 'y'
 	help
 	  Say Y to enable support for USB Charger Detection with
 	  ISP1707/ISP1704 USB transceivers.
diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index fbaed079b299..b9c1c92db1bc 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -120,8 +120,8 @@ config QCOM_Q6V5_ADSP
 	depends on OF && ARCH_QCOM
 	depends on QCOM_SMEM
 	depends on RPMSG_QCOM_SMD || (COMPILE_TEST && RPMSG_QCOM_SMD=n)
-	depends on RPMSG_QCOM_GLINK_SMEM || RPMSG_QCOM_GLINK_SMEM=n
-	depends on QCOM_SYSMON || QCOM_SYSMON=n
+	uses RPMSG_QCOM_GLINK_SMEM
+	uses QCOM_SYSMON
 	select MFD_SYSCON
 	select QCOM_MDT_LOADER
 	select QCOM_Q6V5_COMMON
@@ -135,8 +135,8 @@ config QCOM_Q6V5_MSS
 	depends on OF && ARCH_QCOM
 	depends on QCOM_SMEM
 	depends on RPMSG_QCOM_SMD || (COMPILE_TEST && RPMSG_QCOM_SMD=n)
-	depends on RPMSG_QCOM_GLINK_SMEM || RPMSG_QCOM_GLINK_SMEM=n
-	depends on QCOM_SYSMON || QCOM_SYSMON=n
+	uses RPMSG_QCOM_GLINK_SMEM
+	uses QCOM_SYSMON
 	select MFD_SYSCON
 	select QCOM_MDT_LOADER
 	select QCOM_Q6V5_COMMON
@@ -152,8 +152,8 @@ config QCOM_Q6V5_PAS
 	depends on OF && ARCH_QCOM
 	depends on QCOM_SMEM
 	depends on RPMSG_QCOM_SMD || (COMPILE_TEST && RPMSG_QCOM_SMD=n)
-	depends on RPMSG_QCOM_GLINK_SMEM || RPMSG_QCOM_GLINK_SMEM=n
-	depends on QCOM_SYSMON || QCOM_SYSMON=n
+	uses RPMSG_QCOM_GLINK_SMEM
+	uses QCOM_SYSMON
 	select MFD_SYSCON
 	select QCOM_MDT_LOADER
 	select QCOM_Q6V5_COMMON
@@ -169,8 +169,8 @@ config QCOM_Q6V5_WCSS
 	depends on OF && ARCH_QCOM
 	depends on QCOM_SMEM
 	depends on RPMSG_QCOM_SMD || (COMPILE_TEST && RPMSG_QCOM_SMD=n)
-	depends on RPMSG_QCOM_GLINK_SMEM || RPMSG_QCOM_GLINK_SMEM=n
-	depends on QCOM_SYSMON || QCOM_SYSMON=n
+	uses RPMSG_QCOM_GLINK_SMEM
+	uses QCOM_SYSMON
 	select MFD_SYSCON
 	select QCOM_MDT_LOADER
 	select QCOM_Q6V5_COMMON
@@ -202,9 +202,9 @@ config QCOM_WCNSS_PIL
 	tristate "Qualcomm WCNSS Peripheral Image Loader"
 	depends on OF && ARCH_QCOM
 	depends on RPMSG_QCOM_SMD || (COMPILE_TEST && RPMSG_QCOM_SMD=n)
-	depends on RPMSG_QCOM_GLINK_SMEM || RPMSG_QCOM_GLINK_SMEM=n
+	uses RPMSG_QCOM_GLINK_SMEM
 	depends on QCOM_SMEM
-	depends on QCOM_SYSMON || QCOM_SYSMON=n
+	uses QCOM_SYSMON
 	select QCOM_MDT_LOADER
 	select QCOM_RPROC_COMMON
 	select QCOM_SCM
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 17feff174f57..86cf1b5aaf0f 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1155,8 +1155,8 @@ config SCSI_LPFC
 	tristate "Emulex LightPulse Fibre Channel Support"
 	depends on PCI && SCSI
 	depends on SCSI_FC_ATTRS
-	depends on NVME_TARGET_FC || NVME_TARGET_FC=n
-	depends on NVME_FC || NVME_FC=n
+	uses NVME_TARGET_FC
+	uses NVME_FC
 	select CRC_T10DIF
 	---help---
           This lpfc driver supports the Emulex LightPulse
diff --git a/drivers/scsi/cxgbi/cxgb4i/Kconfig b/drivers/scsi/cxgbi/cxgb4i/Kconfig
index d1f1baba3285..69daae0fff1f 100644
--- a/drivers/scsi/cxgbi/cxgb4i/Kconfig
+++ b/drivers/scsi/cxgbi/cxgb4i/Kconfig
@@ -2,7 +2,7 @@
 config SCSI_CXGB4_ISCSI
 	tristate "Chelsio T4 iSCSI support"
 	depends on PCI && INET && (IPV6 || IPV6=n)
-	depends on THERMAL || !THERMAL
+	uses THERMAL
 	depends on ETHERNET
 	select NET_VENDOR_CHELSIO
 	select CHELSIO_T4
diff --git a/drivers/scsi/qla2xxx/Kconfig b/drivers/scsi/qla2xxx/Kconfig
index 764501838e21..909d4213d947 100644
--- a/drivers/scsi/qla2xxx/Kconfig
+++ b/drivers/scsi/qla2xxx/Kconfig
@@ -3,7 +3,7 @@ config SCSI_QLA_FC
 	tristate "QLogic QLA2XXX Fibre Channel Support"
 	depends on PCI && SCSI
 	depends on SCSI_FC_ATTRS
-	depends on NVME_FC || !NVME_FC
+	uses NVME_FC
 	select FW_LOADER
 	select BTREE
 	---help---
diff --git a/drivers/staging/wfx/Kconfig b/drivers/staging/wfx/Kconfig
index 83ee4d0ca8c6..cc2dadfbf0b7 100644
--- a/drivers/staging/wfx/Kconfig
+++ b/drivers/staging/wfx/Kconfig
@@ -1,7 +1,7 @@
 config WFX
 	tristate "Silicon Labs wireless chips WF200 and further"
 	depends on MAC80211
-	depends on MMC || !MMC # do not allow WFX=y if MMC=m
+	uses MMC # do not allow WFX=y if MMC=m
 	depends on (SPI || MMC)
 	help
 	  This is a driver for Silicons Labs WFxxx series (WF200 and further)
diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index 91af271e9bb0..c53ec95afdef 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -243,7 +243,7 @@ config HISI_THERMAL
 config IMX_THERMAL
 	tristate "Temperature sensor driver for Freescale i.MX SoCs"
 	depends on ARCH_MXC || COMPILE_TEST
-	depends on NVMEM || !NVMEM
+	uses NVMEM
 	depends on MFD_SYSCON
 	depends on OF
 	help
@@ -396,7 +396,7 @@ config MTK_THERMAL
 	tristate "Temperature sensor driver for mediatek SoCs"
 	depends on ARCH_MEDIATEK || COMPILE_TEST
 	depends on HAS_IOMEM
-	depends on NVMEM || NVMEM=n
+	uses NVMEM
 	depends on RESET_CONTROLLER
 	default y
 	help
diff --git a/drivers/usb/dwc2/Kconfig b/drivers/usb/dwc2/Kconfig
index 16e1aa304edc..717794bf28ad 100644
--- a/drivers/usb/dwc2/Kconfig
+++ b/drivers/usb/dwc2/Kconfig
@@ -57,7 +57,7 @@ endchoice
 config USB_DWC2_PCI
 	tristate "DWC2 PCI"
 	depends on USB_PCI
-	depends on USB_GADGET || !USB_GADGET
+	uses USB_GADGET
 	select NOP_USB_XCEIV
 	help
 	  The Designware USB2.0 PCI interface module for controllers
diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
index 206caa0ea1c6..41b7bfc56bbf 100644
--- a/drivers/usb/dwc3/Kconfig
+++ b/drivers/usb/dwc3/Kconfig
@@ -55,7 +55,7 @@ comment "Platform Glue Driver Support"
 config USB_DWC3_OMAP
 	tristate "Texas Instruments OMAP5 and similar Platforms"
 	depends on ARCH_OMAP2PLUS || COMPILE_TEST
-	depends on EXTCON || !EXTCON
+	uses EXTCON
 	depends on OF
 	default USB_DWC3
 	help
@@ -128,7 +128,7 @@ config USB_DWC3_ST
 config USB_DWC3_QCOM
 	tristate "Qualcomm Platform"
 	depends on ARCH_QCOM || COMPILE_TEST
-	depends on EXTCON || !EXTCON
+	uses EXTCON
 	depends on (OF || ACPI)
 	default USB_DWC3
 	help
diff --git a/drivers/usb/gadget/udc/Kconfig b/drivers/usb/gadget/udc/Kconfig
index 3a7179e90f4e..4ab9c120ac0c 100644
--- a/drivers/usb/gadget/udc/Kconfig
+++ b/drivers/usb/gadget/udc/Kconfig
@@ -276,7 +276,7 @@ config USB_SNP_CORE
 config USB_SNP_UDC_PLAT
 	tristate "Synopsys USB 2.0 Device controller"
 	depends on USB_GADGET && OF && HAS_DMA
-	depends on EXTCON || EXTCON=n
+	uses EXTCON
 	select USB_SNP_CORE
 	default ARCH_BCM_IPROC
 	help
diff --git a/drivers/usb/mtu3/Kconfig b/drivers/usb/mtu3/Kconfig
index bf98fd36341d..ca299de89485 100644
--- a/drivers/usb/mtu3/Kconfig
+++ b/drivers/usb/mtu3/Kconfig
@@ -6,7 +6,7 @@ config USB_MTU3
 	tristate "MediaTek USB3 Dual Role controller"
 	depends on USB || USB_GADGET
 	depends on ARCH_MEDIATEK || COMPILE_TEST
-	depends on EXTCON || !EXTCON
+	uses EXTCON
 	select USB_XHCI_MTK if USB_SUPPORT && USB_XHCI_HCD
 	help
 	  Say Y or M here if your system runs on MediaTek SoCs with
diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index 3b0d1c20ebe6..6e90462f258c 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -91,7 +91,7 @@ config USB_MUSB_TUSB6010
 config USB_MUSB_OMAP2PLUS
 	tristate "OMAP2430 and onwards"
 	depends on ARCH_OMAP2PLUS && USB
-	depends on OMAP_CONTROL_PHY || !OMAP_CONTROL_PHY
+	uses OMAP_CONTROL_PHY
 	select GENERIC_PHY
 
 config USB_MUSB_AM35X
diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index 4b3fa78995cf..4270bce85eda 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -23,7 +23,7 @@ config AB8500_USB
 config FSL_USB2_OTG
 	tristate "Freescale USB OTG Transceiver Driver"
 	depends on USB_EHCI_FSL && USB_FSL_USB2 && USB_OTG_FSM=y && PM
-	depends on USB_GADGET || !USB_GADGET # if USB_GADGET=m, this can't be 'y'
+	uses USB_GADGET # if USB_GADGET=m, this can't be 'y'
 	select USB_PHY
 	help
 	  Enable this to support Freescale USB OTG transceiver.
@@ -32,7 +32,7 @@ config ISP1301_OMAP
 	tristate "Philips ISP1301 with OMAP OTG"
 	depends on I2C && ARCH_OMAP_OTG
 	depends on USB
-	depends on USB_GADGET || !USB_GADGET # if USB_GADGET=m, this can't be 'y'
+	uses USB_GADGET # if USB_GADGET=m, this can't be 'y'
 	select USB_PHY
 	help
 	  If you say yes here you get support for the Philips ISP1301
@@ -55,7 +55,7 @@ config KEYSTONE_USB_PHY
 
 config NOP_USB_XCEIV
 	tristate "NOP USB Transceiver Driver"
-	depends on USB_GADGET || !USB_GADGET # if USB_GADGET=m, NOP can't be built-in
+	uses USB_GADGET # if USB_GADGET=m, NOP can't be built-in
 	select USB_PHY
 	help
 	  This driver is to be used by all the usb transceiver which are either
@@ -91,7 +91,7 @@ config TWL6030_USB
 config USB_GPIO_VBUS
 	tristate "GPIO based peripheral-only VBUS sensing 'transceiver'"
 	depends on GPIOLIB || COMPILE_TEST
-	depends on USB_GADGET || !USB_GADGET # if USB_GADGET=m, this can't be 'y'
+	uses USB_GADGET # if USB_GADGET=m, this can't be 'y'
 	select USB_PHY
 	help
 	  Provides simple GPIO VBUS sensing for controllers with an
@@ -112,7 +112,7 @@ config OMAP_OTG
 config TAHVO_USB
 	tristate "Tahvo USB transceiver driver"
 	depends on MFD_RETU
-	depends on USB_GADGET || !USB_GADGET # if USB_GADGET=m, this can't be 'y'
+	uses USB_GADGET # if USB_GADGET=m, this can't be 'y'
 	select USB_PHY
 	help
 	  Enable this to support USB transceiver on Tahvo. This is used
@@ -141,7 +141,7 @@ config USB_ISP1301
 config USB_MV_OTG
 	tristate "Marvell USB OTG support"
 	depends on USB_EHCI_MV && USB_MV_UDC && PM && USB_OTG
-	depends on USB_GADGET || !USB_GADGET # if USB_GADGET=m, this can't be 'y'
+	uses USB_GADGET # if USB_GADGET=m, this can't be 'y'
 	select USB_PHY
 	help
 	  Say Y here if you want to build Marvell USB OTG transciever
diff --git a/drivers/usb/renesas_usbhs/Kconfig b/drivers/usb/renesas_usbhs/Kconfig
index d6b3fef3e55b..d9313450c81b 100644
--- a/drivers/usb/renesas_usbhs/Kconfig
+++ b/drivers/usb/renesas_usbhs/Kconfig
@@ -7,7 +7,7 @@ config USB_RENESAS_USBHS
 	tristate 'Renesas USBHS controller'
 	depends on USB_GADGET
 	depends on ARCH_RENESAS || SUPERH || COMPILE_TEST
-	depends on EXTCON || !EXTCON # if EXTCON=m, USBHS cannot be built-in
+	uses EXTCON # if EXTCON=m, USBHS cannot be built-in
 	help
 	  Renesas USBHS is a discrete USB host and peripheral controller chip
 	  that supports both full and high speed USB 2.0 data transfers.
diff --git a/drivers/usb/typec/tcpm/Kconfig b/drivers/usb/typec/tcpm/Kconfig
index 5b986d6c801d..9b50593559c5 100644
--- a/drivers/usb/typec/tcpm/Kconfig
+++ b/drivers/usb/typec/tcpm/Kconfig
@@ -32,7 +32,7 @@ endif # TYPEC_TCPCI
 config TYPEC_FUSB302
 	tristate "Fairchild FUSB302 Type-C chip driver"
 	depends on I2C
-	depends on EXTCON || !EXTCON
+	uses EXTCON
 	help
 	  The Fairchild FUSB302 Type-C chip driver that works with
 	  Type-C Port Controller Manager to provide USB PD and USB
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 0663c604bd64..3f5e354515fb 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -319,7 +319,7 @@ config ZIIRAVE_WATCHDOG
 config RAVE_SP_WATCHDOG
 	tristate "RAVE SP Watchdog timer"
 	depends on RAVE_SP_CORE
-	depends on NVMEM || !NVMEM
+	uses NVMEM
 	select WATCHDOG_CORE
 	help
 	  Support for the watchdog on RAVE SP device.
@@ -1216,7 +1216,7 @@ config ITCO_WDT
 	tristate "Intel TCO Timer/Watchdog"
 	depends on (X86 || IA64) && PCI
 	select WATCHDOG_CORE
-	depends on I2C || I2C=n
+	uses I2C
 	select LPC_ICH if !EXPERT
 	select I2C_I801 if !EXPERT && I2C
 	---help---
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 14c032de276e..b88ef7adeb02 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -26,7 +26,7 @@ config CRYPTO_LIB_BLAKE2S_GENERIC
 
 config CRYPTO_LIB_BLAKE2S
 	tristate "BLAKE2s hash function library"
-	depends on CRYPTO_ARCH_HAVE_LIB_BLAKE2S || !CRYPTO_ARCH_HAVE_LIB_BLAKE2S
+	uses CRYPTO_ARCH_HAVE_LIB_BLAKE2S
 	select CRYPTO_LIB_BLAKE2S_GENERIC if CRYPTO_ARCH_HAVE_LIB_BLAKE2S=n
 	help
 	  Enable the Blake2s library interface. This interface may be fulfilled
@@ -52,7 +52,7 @@ config CRYPTO_LIB_CHACHA_GENERIC
 
 config CRYPTO_LIB_CHACHA
 	tristate "ChaCha library interface"
-	depends on CRYPTO_ARCH_HAVE_LIB_CHACHA || !CRYPTO_ARCH_HAVE_LIB_CHACHA
+	uses CRYPTO_ARCH_HAVE_LIB_CHACHA
 	select CRYPTO_LIB_CHACHA_GENERIC if CRYPTO_ARCH_HAVE_LIB_CHACHA=n
 	help
 	  Enable the ChaCha library interface. This interface may be fulfilled
@@ -77,7 +77,7 @@ config CRYPTO_LIB_CURVE25519_GENERIC
 
 config CRYPTO_LIB_CURVE25519
 	tristate "Curve25519 scalar multiplication library"
-	depends on CRYPTO_ARCH_HAVE_LIB_CURVE25519 || !CRYPTO_ARCH_HAVE_LIB_CURVE25519
+	uses CRYPTO_ARCH_HAVE_LIB_CURVE25519
 	select CRYPTO_LIB_CURVE25519_GENERIC if CRYPTO_ARCH_HAVE_LIB_CURVE25519=n
 	help
 	  Enable the Curve25519 library interface. This interface may be
@@ -112,7 +112,7 @@ config CRYPTO_LIB_POLY1305_GENERIC
 
 config CRYPTO_LIB_POLY1305
 	tristate "Poly1305 library interface"
-	depends on CRYPTO_ARCH_HAVE_LIB_POLY1305 || !CRYPTO_ARCH_HAVE_LIB_POLY1305
+	uses CRYPTO_ARCH_HAVE_LIB_POLY1305
 	select CRYPTO_LIB_POLY1305_GENERIC if CRYPTO_ARCH_HAVE_LIB_POLY1305=n
 	help
 	  Enable the Poly1305 library interface. This interface may be fulfilled
@@ -121,8 +121,8 @@ config CRYPTO_LIB_POLY1305
 
 config CRYPTO_LIB_CHACHA20POLY1305
 	tristate "ChaCha20-Poly1305 AEAD support (8-byte nonce library version)"
-	depends on CRYPTO_ARCH_HAVE_LIB_CHACHA || !CRYPTO_ARCH_HAVE_LIB_CHACHA
-	depends on CRYPTO_ARCH_HAVE_LIB_POLY1305 || !CRYPTO_ARCH_HAVE_LIB_POLY1305
+	uses CRYPTO_ARCH_HAVE_LIB_CHACHA
+	uses CRYPTO_ARCH_HAVE_LIB_POLY1305
 	select CRYPTO_LIB_CHACHA
 	select CRYPTO_LIB_POLY1305
 
diff --git a/net/bluetooth/Kconfig b/net/bluetooth/Kconfig
index 165148c7c4ce..3ee130c770ce 100644
--- a/net/bluetooth/Kconfig
+++ b/net/bluetooth/Kconfig
@@ -6,7 +6,7 @@
 menuconfig BT
 	tristate "Bluetooth subsystem support"
 	depends on NET && !S390
-	depends on RFKILL || !RFKILL
+	uses RFKILL
 	select CRC16
 	select CRYPTO
 	select CRYPTO_SKCIPHER
diff --git a/net/bridge/Kconfig b/net/bridge/Kconfig
index e4fb050e2078..0a4fb1076cb3 100644
--- a/net/bridge/Kconfig
+++ b/net/bridge/Kconfig
@@ -7,7 +7,7 @@ config BRIDGE
 	tristate "802.1d Ethernet Bridging"
 	select LLC
 	select STP
-	depends on IPV6 || IPV6=n
+	uses IPV6
 	---help---
 	  If you say Y here, then your Linux box will be able to act as an
 	  Ethernet bridge, which means that the different Ethernet segments it
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 92663dcb3aa2..2ca052a59a52 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -8,7 +8,7 @@ config HAVE_NET_DSA
 menuconfig NET_DSA
 	tristate "Distributed Switch Architecture"
 	depends on HAVE_NET_DSA
-	depends on BRIDGE || BRIDGE=n
+	uses BRIDGE
 	select NET_SWITCHDEV
 	select PHYLINK
 	select NET_DEVLINK
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 25a8888826b8..d173c882ddf1 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -303,7 +303,7 @@ config SYN_COOKIES
 
 config NET_IPVTI
 	tristate "Virtual (secure) IP: tunneling"
-	depends on IPV6 || IPV6=n
+	uses IPV6
 	select INET_TUNNEL
 	select NET_IP_TUNNEL
 	select XFRM
diff --git a/net/mpls/Kconfig b/net/mpls/Kconfig
index d1ad69b7942a..1b6ede06a594 100644
--- a/net/mpls/Kconfig
+++ b/net/mpls/Kconfig
@@ -25,7 +25,7 @@ config NET_MPLS_GSO
 
 config MPLS_ROUTING
 	tristate "MPLS: routing support"
-	depends on NET_IP_TUNNEL || NET_IP_TUNNEL=n
+	uses NET_IP_TUNNEL
 	depends on PROC_SYSCTL
 	---help---
 	 Add support for forwarding of mpls packets.
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 468fea1aebba..38433805e499 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -228,7 +228,7 @@ config NF_CONNTRACK_FTP
 
 config NF_CONNTRACK_H323
 	tristate "H.323 protocol support"
-	depends on IPV6 || IPV6=n
+	uses IPV6
 	depends on NETFILTER_ADVANCED
 	help
 	  H.323 is a VoIP signalling protocol from ITU-T. As one of the most
@@ -617,7 +617,7 @@ config NFT_XFRM
 
 config NFT_SOCKET
 	tristate "Netfilter nf_tables socket match support"
-	depends on IPV6 || IPV6=n
+	uses IPV6
 	select NF_SOCKET_IPV4
 	select NF_SOCKET_IPV6 if NF_TABLES_IPV6
 	help
@@ -633,7 +633,7 @@ config NFT_OSF
 
 config NFT_TPROXY
 	tristate "Netfilter nf_tables tproxy support"
-	depends on IPV6 || IPV6=n
+	uses IPV6
 	select NF_DEFRAG_IPV4
 	select NF_DEFRAG_IPV6 if NF_TABLES_IPV6
 	select NF_TPROXY_IPV4
@@ -861,7 +861,7 @@ config NETFILTER_XT_TARGET_HL
 
 config NETFILTER_XT_TARGET_HMARK
 	tristate '"HMARK" target support'
-	depends on IP6_NF_IPTABLES || IP6_NF_IPTABLES=n
+	uses IP6_NF_IPTABLES
 	depends on NETFILTER_ADVANCED
 	---help---
 	This option adds the "HMARK" target.
@@ -1016,9 +1016,9 @@ config NETFILTER_XT_TARGET_MASQUERADE
 config NETFILTER_XT_TARGET_TEE
 	tristate '"TEE" - packet cloning to alternate destination'
 	depends on NETFILTER_ADVANCED
-	depends on IPV6 || IPV6=n
+	uses IPV6
 	depends on !NF_CONNTRACK || NF_CONNTRACK
-	depends on IP6_NF_IPTABLES || !IP6_NF_IPTABLES
+	uses IP6_NF_IPTABLES
 	select NF_DUP_IPV4
 	select NF_DUP_IPV6 if IP6_NF_IPTABLES
 	---help---
@@ -1029,8 +1029,8 @@ config NETFILTER_XT_TARGET_TPROXY
 	tristate '"TPROXY" target transparent proxying support'
 	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
-	depends on IPV6 || IPV6=n
-	depends on IP6_NF_IPTABLES || IP6_NF_IPTABLES=n
+	uses IPV6
+	uses IP6_NF_IPTABLES
 	depends on IP_NF_MANGLE
 	select NF_DEFRAG_IPV4
 	select NF_DEFRAG_IPV6 if IP6_NF_IPTABLES != n
@@ -1071,7 +1071,7 @@ config NETFILTER_XT_TARGET_SECMARK
 
 config NETFILTER_XT_TARGET_TCPMSS
 	tristate '"TCPMSS" target support'
-	depends on IPV6 || IPV6=n
+	uses IPV6
 	default m if NETFILTER_ADVANCED=n
 	---help---
 	  This option adds a `TCPMSS' target, which allows you to alter the
@@ -1284,7 +1284,7 @@ config NETFILTER_XT_MATCH_ESP
 
 config NETFILTER_XT_MATCH_HASHLIMIT
 	tristate '"hashlimit" match support'
-	depends on IP6_NF_IPTABLES || IP6_NF_IPTABLES=n
+	uses IP6_NF_IPTABLES
 	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `hashlimit' match.
@@ -1526,8 +1526,8 @@ config NETFILTER_XT_MATCH_SOCKET
 	tristate '"socket" match support'
 	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
-	depends on IPV6 || IPV6=n
-	depends on IP6_NF_IPTABLES || IP6_NF_IPTABLES=n
+	uses IPV6
+	uses IP6_NF_IPTABLES
 	select NF_SOCKET_IPV4
 	select NF_SOCKET_IPV6 if IP6_NF_IPTABLES
 	select NF_DEFRAG_IPV4
diff --git a/net/nfc/Kconfig b/net/nfc/Kconfig
index 9b27599870e3..751c2011da4a 100644
--- a/net/nfc/Kconfig
+++ b/net/nfc/Kconfig
@@ -5,7 +5,7 @@
 
 menuconfig NFC
 	depends on NET
-	depends on RFKILL || !RFKILL
+	uses RFKILL
 	tristate "NFC subsystem support"
 	default n
 	help
diff --git a/net/rds/Kconfig b/net/rds/Kconfig
index c64e154bc18f..ff5fc0380b3d 100644
--- a/net/rds/Kconfig
+++ b/net/rds/Kconfig
@@ -17,7 +17,7 @@ config RDS_RDMA
 config RDS_TCP
 	tristate "RDS over TCP"
 	depends on RDS
-	depends on IPV6 || !IPV6
+	uses IPV6
 	---help---
 	  Allow RDS to use TCP as a transport.
 	  This transport does not support RDMA operations.
diff --git a/net/sctp/Kconfig b/net/sctp/Kconfig
index 6e2eb1dd64ed..9843ec78f9d6 100644
--- a/net/sctp/Kconfig
+++ b/net/sctp/Kconfig
@@ -6,7 +6,7 @@
 menuconfig IP_SCTP
 	tristate "The SCTP Protocol"
 	depends on INET
-	depends on IPV6 || IPV6=n
+	uses IPV6
 	select CRYPTO
 	select CRYPTO_HMAC
 	select CRYPTO_SHA1
diff --git a/net/wimax/Kconfig b/net/wimax/Kconfig
index d13762bc4abc..8c79eed1ba67 100644
--- a/net/wimax/Kconfig
+++ b/net/wimax/Kconfig
@@ -5,7 +5,7 @@
 
 menuconfig WIMAX
 	tristate "WiMAX Wireless Broadband support"
-	depends on RFKILL || !RFKILL
+	uses RFKILL
 	help
 
 	  Select to configure support for devices that provide
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 63cf7131f601..e07801f56010 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -19,7 +19,7 @@ config WEXT_PRIV
 
 config CFG80211
 	tristate "cfg80211 - wireless configuration API"
-	depends on RFKILL || !RFKILL
+	uses RFKILL
 	select FW_LOADER
 	# may need to update this when certificates are changed and are
 	# using a different algorithm, though right now they shouldn't
diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index 65e8cd4be930..d521fdc5930b 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -303,7 +303,7 @@ config SND_SOC_FSL_ASOC_CARD
 	tristate "Generic ASoC Sound Card with ASRC support"
 	depends on OF && I2C
 	# enforce SND_SOC_FSL_ASOC_CARD=m if SND_AC97_CODEC=m:
-	depends on SND_AC97_CODEC || SND_AC97_CODEC=n
+	uses SND_AC97_CODEC
 	select SND_SOC_IMX_AUDMUX
 	select SND_SOC_IMX_PCM_DMA
 	select SND_SOC_FSL_ESAI
-- 
2.25.2

