Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A72480238
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 17:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhL0QpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 11:45:13 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30324 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231567AbhL0Qom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 11:44:42 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BRGfn3p012025;
        Mon, 27 Dec 2021 16:43:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=W1HUwQ18XLYWUeGqSeCU6yyCk9f5pZARQm9nB+8uO8Q=;
 b=G8mUl7ZD1aekkH954kclTb+If9iMfBV5hZnTJ8tNwRxazqA/cjDkQ3dpaY9+1KireQOJ
 yXEQT9drKlCcmIxELLJqSyljz9lSL3VeVhBce0Ix7m12Axqwwp7gWuKBac5uU8alVK33
 8ZDUTODRfemqholWgBDzYwNgSS9ccbHZI1T/kf4pMO1k5mWMDbYsFol/AwIfCy0zkt+0
 RBCRzn/AAxJHmkPO/XwShZUjqMjbMjfWad4ugyP6OzwoB5DCJTbwAcVqaPSpxPYlxP7k
 EKgIvFQZHhwo/b7SfumlgwWEnn5b9jGlo81/bJOntpSg6nN/zaJQWKhfEy/34rhG+h9t gA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3d7h7ug0sn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Dec 2021 16:43:29 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BRGgk7e003050;
        Mon, 27 Dec 2021 16:43:27 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3d5tx9bf3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Dec 2021 16:43:26 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BRGhO1139125310
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Dec 2021 16:43:24 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5489DA405F;
        Mon, 27 Dec 2021 16:43:24 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64BB1A405B;
        Mon, 27 Dec 2021 16:43:22 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Dec 2021 16:43:22 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Arnd Bergmann <arnd@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        John Garry <john.garry@huawei.com>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Karsten Keil <isdn@linux-pingi.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Kalle Valo <kvalo@kernel.org>, Jouni Malinen <j@w1.fi>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Mark Brown <broonie@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Teddy Wang <teddy.wang@siliconmotion.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Forest Bond <forest@alittletooquiet.net>,
        Jiri Slaby <jirislaby@kernel.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc:     linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-csky@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, linux-media@vger.kernel.org,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-wireless@vger.kernel.org,
        megaraidlinux.pdl@broadcom.com, linux-spi@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-serial@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-watchdog@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [RFC 01/32] Kconfig: introduce and depend on LEGACY_PCI
Date:   Mon, 27 Dec 2021 17:42:46 +0100
Message-Id: <20211227164317.4146918-2-schnelle@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211227164317.4146918-1-schnelle@linux.ibm.com>
References: <20211227164317.4146918-1-schnelle@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oCM_ROZ6yLRqRSgeoZj_NZ5-9XA65tXR
X-Proofpoint-ORIG-GUID: oCM_ROZ6yLRqRSgeoZj_NZ5-9XA65tXR
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-27_08,2021-12-24_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 phishscore=0 spamscore=0 impostorscore=0 clxscore=1011 priorityscore=1501
 adultscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112270080
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new LEGACY_PCI Kconfig option which gates support for legacy
PCI devices including those attached to a PCI-to-PCI Express bridge and
PCI Express devices using legacy I/O spaces. Note that this is different
from non PCI uses of I/O ports such as by ACPI.

Add dependencies on LEGACY_PCI for all PCI drivers which only target
legacy PCI devices and ifdef legacy PCI specific functions in ata
handling.

Co-developed-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 drivers/ata/Kconfig                          | 34 ++++++++--------
 drivers/ata/ata_generic.c                    |  3 +-
 drivers/ata/libata-sff.c                     |  2 +
 drivers/comedi/Kconfig                       | 42 +++++++++++++++++++
 drivers/gpio/Kconfig                         |  2 +-
 drivers/hwmon/Kconfig                        |  6 +--
 drivers/i2c/busses/Kconfig                   | 24 +++++------
 drivers/input/gameport/Kconfig               |  4 +-
 drivers/isdn/hardware/mISDN/Kconfig          | 14 +++----
 drivers/media/cec/platform/Kconfig           |  2 +-
 drivers/media/pci/dm1105/Kconfig             |  2 +-
 drivers/media/radio/Kconfig                  |  2 +-
 drivers/message/fusion/Kconfig               |  8 ++--
 drivers/net/arcnet/Kconfig                   |  2 +-
 drivers/net/ethernet/8390/Kconfig            |  2 +-
 drivers/net/ethernet/amd/Kconfig             |  2 +-
 drivers/net/ethernet/intel/Kconfig           |  4 +-
 drivers/net/ethernet/sis/Kconfig             |  6 +--
 drivers/net/ethernet/ti/Kconfig              |  4 +-
 drivers/net/ethernet/via/Kconfig             |  4 +-
 drivers/net/fddi/Kconfig                     |  4 +-
 drivers/net/wan/Kconfig                      |  2 +-
 drivers/net/wireless/atmel/Kconfig           |  4 +-
 drivers/net/wireless/intersil/hostap/Kconfig |  4 +-
 drivers/pci/Kconfig                          | 11 +++++
 drivers/scsi/Kconfig                         | 20 ++++-----
 drivers/scsi/aic7xxx/Kconfig.aic79xx         |  2 +-
 drivers/scsi/aic7xxx/Kconfig.aic7xxx         |  2 +-
 drivers/scsi/aic94xx/Kconfig                 |  2 +-
 drivers/scsi/megaraid/Kconfig.megaraid       |  2 +-
 drivers/scsi/mvsas/Kconfig                   |  2 +-
 drivers/scsi/qla2xxx/Kconfig                 |  2 +-
 drivers/spi/Kconfig                          |  1 +
 drivers/staging/sm750fb/Kconfig              |  2 +-
 drivers/staging/vt6655/Kconfig               |  2 +-
 drivers/tty/Kconfig                          |  2 +-
 drivers/tty/serial/Kconfig                   |  2 +-
 drivers/video/fbdev/Kconfig                  | 22 +++++-----
 drivers/watchdog/Kconfig                     |  4 +-
 sound/pci/Kconfig                            | 43 ++++++++++++++++----
 40 files changed, 194 insertions(+), 110 deletions(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index a7da8ea7b3ed..32e0489bd01c 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -556,7 +556,7 @@ comment "PATA SFF controllers with BMDMA"
 
 config PATA_ALI
 	tristate "ALi PATA support"
-	depends on PCI
+	depends on LEGACY_PCI
 	select PATA_TIMINGS
 	help
 	  This option enables support for the ALi ATA interfaces
@@ -566,7 +566,7 @@ config PATA_ALI
 
 config PATA_AMD
 	tristate "AMD/NVidia PATA support"
-	depends on PCI
+	depends on LEGACY_PCI
 	select PATA_TIMINGS
 	help
 	  This option enables support for the AMD and NVidia PATA
@@ -584,7 +584,7 @@ config PATA_ARASAN_CF
 
 config PATA_ARTOP
 	tristate "ARTOP 6210/6260 PATA support"
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	  This option enables support for ARTOP PATA controllers.
 
@@ -621,7 +621,7 @@ config PATA_BK3710
 
 config PATA_CMD64X
 	tristate "CMD64x PATA support"
-	depends on PCI
+	depends on LEGACY_PCI
 	select PATA_TIMINGS
 	help
 	  This option enables support for the CMD64x series chips
@@ -667,7 +667,7 @@ config PATA_CS5536
 
 config PATA_CYPRESS
 	tristate "Cypress CY82C693 PATA support (Very Experimental)"
-	depends on PCI
+	depends on LEGACY_PCI
 	select PATA_TIMINGS
 	help
 	  This option enables support for the Cypress/Contaq CY82C693
@@ -707,7 +707,7 @@ config PATA_FTIDE010
 
 config PATA_HPT366
 	tristate "HPT 366/368 PATA support"
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	  This option enables support for the HPT 366 and 368
 	  PATA controllers via the new ATA layer.
@@ -716,7 +716,7 @@ config PATA_HPT366
 
 config PATA_HPT37X
 	tristate "HPT 370/370A/371/372/374/302 PATA support"
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	  This option enables support for the majority of the later HPT
 	  PATA controllers via the new ATA layer.
@@ -725,7 +725,7 @@ config PATA_HPT37X
 
 config PATA_HPT3X2N
 	tristate "HPT 371N/372N/302N PATA support"
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	  This option enables support for the N variant HPT PATA
 	  controllers via the new ATA layer.
@@ -828,7 +828,7 @@ config PATA_MPC52xx
 
 config PATA_NETCELL
 	tristate "NETCELL Revolution RAID support"
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	  This option enables support for the Netcell Revolution RAID
 	  PATA controller.
@@ -864,7 +864,7 @@ config PATA_OLDPIIX
 
 config PATA_OPTIDMA
 	tristate "OPTI FireStar PATA support (Very Experimental)"
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	  This option enables DMA/PIO support for the later OPTi
 	  controllers found on some old motherboards and in some
@@ -874,7 +874,7 @@ config PATA_OPTIDMA
 
 config PATA_PDC2027X
 	tristate "Promise PATA 2027x support"
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	  This option enables support for Promise PATA pdc20268 to pdc20277 host adapters.
 
@@ -882,7 +882,7 @@ config PATA_PDC2027X
 
 config PATA_PDC_OLD
 	tristate "Older Promise PATA controller support"
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	  This option enables support for the Promise 20246, 20262, 20263,
 	  20265 and 20267 adapters.
@@ -910,7 +910,7 @@ config PATA_RDC
 
 config PATA_SC1200
 	tristate "SC1200 PATA support"
-	depends on PCI && (X86_32 || COMPILE_TEST)
+	depends on LEGACY_PCI && (X86_32 || COMPILE_TEST)
 	help
 	  This option enables support for the NatSemi/AMD SC1200 SoC
 	  companion chip used with the Geode processor family.
@@ -928,7 +928,7 @@ config PATA_SCH
 
 config PATA_SERVERWORKS
 	tristate "SERVERWORKS OSB4/CSB5/CSB6/HT1000 PATA support"
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	  This option enables support for the Serverworks OSB4/CSB5/CSB6 and
 	  HT1000 PATA controllers, via the new ATA layer.
@@ -1005,7 +1005,7 @@ comment "PIO-only SFF controllers"
 
 config PATA_CMD640_PCI
 	tristate "CMD640 PCI PATA support (Experimental)"
-	depends on PCI
+	depends on LEGACY_PCI
 	select PATA_TIMINGS
 	help
 	  This option enables support for the CMD640 PCI IDE
@@ -1086,7 +1086,7 @@ config PATA_NS87410
 
 config PATA_OPTI
 	tristate "OPTI621/6215 PATA support (Very Experimental)"
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	  This option enables full PIO support for the early Opti ATA
 	  controllers found on some old motherboards.
@@ -1197,7 +1197,7 @@ config ATA_GENERIC
 
 config PATA_LEGACY
 	tristate "Legacy ISA PATA support (Experimental)"
-	depends on (ISA || PCI)
+	depends on (ISA || LEGACY_PCI)
 	select PATA_TIMINGS
 	help
 	  This option enables support for ISA/VLB/PCI bus legacy PATA
diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index 20a32e4d501d..791942217e2c 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -197,7 +197,8 @@ static int ata_generic_init_one(struct pci_dev *dev, const struct pci_device_id
 	if (!(command & PCI_COMMAND_IO))
 		return -ENODEV;
 
-	if (dev->vendor == PCI_VENDOR_ID_AL)
+	if (IS_ENABLED(CONFIG_LEGACY_PCI) &&
+	    dev->vendor == PCI_VENDOR_ID_AL)
 		ata_pci_bmdma_clear_simplex(dev);
 
 	if (dev->vendor == PCI_VENDOR_ID_ATI) {
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index b71ea4a680b0..636848ab6839 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -3107,6 +3107,7 @@ EXPORT_SYMBOL_GPL(ata_bmdma_port_start32);
 
 #ifdef CONFIG_PCI
 
+#ifdef CONFIG_LEGACY_PCI
 /**
  *	ata_pci_bmdma_clear_simplex -	attempt to kick device out of simplex
  *	@pdev: PCI device
@@ -3132,6 +3133,7 @@ int ata_pci_bmdma_clear_simplex(struct pci_dev *pdev)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ata_pci_bmdma_clear_simplex);
+#endif
 
 static void ata_bmdma_nodma(struct ata_host *host, const char *reason)
 {
diff --git a/drivers/comedi/Kconfig b/drivers/comedi/Kconfig
index 3cb61fa2c5c3..1b642716c5d3 100644
--- a/drivers/comedi/Kconfig
+++ b/drivers/comedi/Kconfig
@@ -572,6 +572,7 @@ if COMEDI_PCI_DRIVERS
 
 config COMEDI_8255_PCI
 	tristate "Generic PCI based 8255 digital i/o board support"
+	depends on LEGACY_PCI
 	select COMEDI_8255
 	help
 	  Enable support for PCI based 8255 digital i/o boards. This driver
@@ -589,6 +590,7 @@ config COMEDI_8255_PCI
 
 config COMEDI_ADDI_WATCHDOG
 	tristate
+	depends on LEGACY_PCI
 	help
 	  Provides support for the watchdog subdevice found on many ADDI-DATA
 	  boards. This module will be automatically selected when needed. The
@@ -596,6 +598,7 @@ config COMEDI_ADDI_WATCHDOG
 
 config COMEDI_ADDI_APCI_1032
 	tristate "ADDI-DATA APCI_1032 support"
+	depends on LEGACY_PCI
 	help
 	  Enable support for ADDI-DATA APCI_1032 cards
 
@@ -604,6 +607,7 @@ config COMEDI_ADDI_APCI_1032
 
 config COMEDI_ADDI_APCI_1500
 	tristate "ADDI-DATA APCI_1500 support"
+	depends on LEGACY_PCI
 	help
 	  Enable support for ADDI-DATA APCI_1500 cards
 
@@ -612,6 +616,7 @@ config COMEDI_ADDI_APCI_1500
 
 config COMEDI_ADDI_APCI_1516
 	tristate "ADDI-DATA APCI-1016/1516/2016 support"
+	depends on LEGACY_PCI
 	select COMEDI_ADDI_WATCHDOG
 	help
 	  Enable support for ADDI-DATA APCI-1016, APCI-1516 and APCI-2016 boards.
@@ -623,6 +628,7 @@ config COMEDI_ADDI_APCI_1516
 
 config COMEDI_ADDI_APCI_1564
 	tristate "ADDI-DATA APCI_1564 support"
+	depends on LEGACY_PCI
 	select COMEDI_ADDI_WATCHDOG
 	help
 	  Enable support for ADDI-DATA APCI_1564 cards
@@ -632,6 +638,7 @@ config COMEDI_ADDI_APCI_1564
 
 config COMEDI_ADDI_APCI_16XX
 	tristate "ADDI-DATA APCI_16xx support"
+	depends on LEGACY_PCI
 	help
 	  Enable support for ADDI-DATA APCI_16xx cards
 
@@ -640,6 +647,7 @@ config COMEDI_ADDI_APCI_16XX
 
 config COMEDI_ADDI_APCI_2032
 	tristate "ADDI-DATA APCI_2032 support"
+	depends on LEGACY_PCI
 	select COMEDI_ADDI_WATCHDOG
 	help
 	  Enable support for ADDI-DATA APCI_2032 cards
@@ -649,6 +657,7 @@ config COMEDI_ADDI_APCI_2032
 
 config COMEDI_ADDI_APCI_2200
 	tristate "ADDI-DATA APCI_2200 support"
+	depends on LEGACY_PCI
 	select COMEDI_ADDI_WATCHDOG
 	help
 	  Enable support for ADDI-DATA APCI_2200 cards
@@ -658,6 +667,7 @@ config COMEDI_ADDI_APCI_2200
 
 config COMEDI_ADDI_APCI_3120
 	tristate "ADDI-DATA APCI_3120/3001 support"
+	depends on LEGACY_PCI
 	depends on HAS_DMA
 	help
 	  Enable support for ADDI-DATA APCI_3120/3001 cards
@@ -667,6 +677,7 @@ config COMEDI_ADDI_APCI_3120
 
 config COMEDI_ADDI_APCI_3501
 	tristate "ADDI-DATA APCI_3501 support"
+	depends on LEGACY_PCI
 	help
 	  Enable support for ADDI-DATA APCI_3501 cards
 
@@ -675,6 +686,7 @@ config COMEDI_ADDI_APCI_3501
 
 config COMEDI_ADDI_APCI_3XXX
 	tristate "ADDI-DATA APCI_3xxx support"
+	depends on LEGACY_PCI
 	help
 	  Enable support for ADDI-DATA APCI_3xxx cards
 
@@ -683,6 +695,7 @@ config COMEDI_ADDI_APCI_3XXX
 
 config COMEDI_ADL_PCI6208
 	tristate "ADLink PCI-6208A support"
+	depends on LEGACY_PCI
 	help
 	  Enable support for ADLink PCI-6208A cards
 
@@ -691,6 +704,7 @@ config COMEDI_ADL_PCI6208
 
 config COMEDI_ADL_PCI7X3X
 	tristate "ADLink PCI-723X/743X isolated digital i/o board support"
+	depends on LEGACY_PCI
 	help
 	  Enable support for ADlink PCI-723X/743X isolated digital i/o boards.
 	  Supported boards include the 32-channel PCI-7230 (16 in/16 out),
@@ -702,6 +716,7 @@ config COMEDI_ADL_PCI7X3X
 
 config COMEDI_ADL_PCI8164
 	tristate "ADLink PCI-8164 4 Axes Motion Control board support"
+	depends on LEGACY_PCI
 	help
 	  Enable support for ADlink PCI-8164 4 Axes Motion Control board
 
@@ -710,6 +725,7 @@ config COMEDI_ADL_PCI8164
 
 config COMEDI_ADL_PCI9111
 	tristate "ADLink PCI-9111HR support"
+	depends on LEGACY_PCI
 	select COMEDI_8254
 	help
 	  Enable support for ADlink PCI9111 cards
@@ -719,6 +735,7 @@ config COMEDI_ADL_PCI9111
 
 config COMEDI_ADL_PCI9118
 	tristate "ADLink PCI-9118DG, PCI-9118HG, PCI-9118HR support"
+	depends on LEGACY_PCI
 	depends on HAS_DMA
 	select COMEDI_8254
 	help
@@ -729,6 +746,7 @@ config COMEDI_ADL_PCI9118
 
 config COMEDI_ADV_PCI1710
 	tristate "Advantech PCI-171x and PCI-1731 support"
+	depends on LEGACY_PCI
 	select COMEDI_8254
 	help
 	  Enable support for Advantech PCI-1710, PCI-1710HG, PCI-1711,
@@ -739,6 +757,7 @@ config COMEDI_ADV_PCI1710
 
 config COMEDI_ADV_PCI1720
 	tristate "Advantech PCI-1720 support"
+	depends on LEGACY_PCI
 	help
 	  Enable support for Advantech PCI-1720 Analog Output board.
 
@@ -747,6 +766,7 @@ config COMEDI_ADV_PCI1720
 
 config COMEDI_ADV_PCI1723
 	tristate "Advantech PCI-1723 support"
+	depends on LEGACY_PCI
 	help
 	  Enable support for Advantech PCI-1723 cards
 
@@ -755,6 +775,7 @@ config COMEDI_ADV_PCI1723
 
 config COMEDI_ADV_PCI1724
 	tristate "Advantech PCI-1724U support"
+	depends on LEGACY_PCI
 	help
 	  Enable support for Advantech PCI-1724U cards.  These are 32-channel
 	  analog output cards with voltage and current loop output ranges and
@@ -765,6 +786,7 @@ config COMEDI_ADV_PCI1724
 
 config COMEDI_ADV_PCI1760
 	tristate "Advantech PCI-1760 support"
+	depends on LEGACY_PCI
 	help
 	  Enable support for Advantech PCI-1760 board.
 
@@ -773,6 +795,7 @@ config COMEDI_ADV_PCI1760
 
 config COMEDI_ADV_PCI_DIO
 	tristate "Advantech PCI DIO card support"
+	depends on LEGACY_PCI
 	select COMEDI_8254
 	select COMEDI_8255
 	help
@@ -786,6 +809,7 @@ config COMEDI_ADV_PCI_DIO
 
 config COMEDI_AMPLC_DIO200_PCI
 	tristate "Amplicon PCI215/PCI272/PCIe215/PCIe236/PCIe296 DIO support"
+	depends on LEGACY_PCI
 	select COMEDI_AMPLC_DIO200
 	help
 	  Enable support for Amplicon PCI215, PCI272, PCIe215, PCIe236
@@ -796,6 +820,7 @@ config COMEDI_AMPLC_DIO200_PCI
 
 config COMEDI_AMPLC_PC236_PCI
 	tristate "Amplicon PCI236 DIO board support"
+	depends on LEGACY_PCI
 	select COMEDI_AMPLC_PC236
 	help
 	  Enable support for Amplicon PCI236 DIO board.
@@ -805,6 +830,7 @@ config COMEDI_AMPLC_PC236_PCI
 
 config COMEDI_AMPLC_PC263_PCI
 	tristate "Amplicon PCI263 relay board support"
+	depends on LEGACY_PCI
 	help
 	  Enable support for Amplicon PCI263 relay board.  This is a PCI board
 	  with 16 reed relay output channels.
@@ -814,6 +840,7 @@ config COMEDI_AMPLC_PC263_PCI
 
 config COMEDI_AMPLC_PCI224
 	tristate "Amplicon PCI224 and PCI234 support"
+	depends on LEGACY_PCI
 	select COMEDI_8254
 	help
 	  Enable support for Amplicon PCI224 and PCI234 AO boards
@@ -823,6 +850,7 @@ config COMEDI_AMPLC_PCI224
 
 config COMEDI_AMPLC_PCI230
 	tristate "Amplicon PCI230 and PCI260 support"
+	depends on LEGACY_PCI
 	select COMEDI_8254
 	select COMEDI_8255
 	help
@@ -834,6 +862,7 @@ config COMEDI_AMPLC_PCI230
 
 config COMEDI_CONTEC_PCI_DIO
 	tristate "Contec PIO1616L digital I/O board support"
+	depends on LEGACY_PCI
 	help
 	  Enable support for the Contec PIO1616L digital I/O board
 
@@ -842,6 +871,7 @@ config COMEDI_CONTEC_PCI_DIO
 
 config COMEDI_DAS08_PCI
 	tristate "DAS-08 PCI support"
+	depends on LEGACY_PCI
 	select COMEDI_DAS08
 	help
 	  Enable support for PCI DAS-08 cards.
@@ -861,6 +891,7 @@ config COMEDI_DT3000
 
 config COMEDI_DYNA_PCI10XX
 	tristate "Dynalog PCI DAQ series support"
+	depends on LEGACY_PCI
 	help
 	  Enable support for Dynalog PCI DAQ series
 	  PCI-1050
@@ -894,6 +925,7 @@ config COMEDI_ICP_MULTI
 
 config COMEDI_DAQBOARD2000
 	tristate "IOtech DAQboard/2000 support"
+	depends on LEGACY_PCI
 	select COMEDI_8255
 	help
 	  Enable support for the IOtech DAQboard/2000
@@ -911,6 +943,7 @@ config COMEDI_JR3_PCI
 
 config COMEDI_KE_COUNTER
 	tristate "Kolter-Electronic PCI Counter 1 card support"
+	depends on LEGACY_PCI
 	help
 	  Enable support for Kolter-Electronic PCI Counter 1 cards
 
@@ -919,6 +952,7 @@ config COMEDI_KE_COUNTER
 
 config COMEDI_CB_PCIDAS64
 	tristate "MeasurementComputing PCI-DAS 64xx, 60xx, and 4020 support"
+	depends on LEGACY_PCI
 	select COMEDI_8255
 	help
 	  Enable support for ComputerBoards/MeasurementComputing PCI-DAS 64xx,
@@ -929,6 +963,7 @@ config COMEDI_CB_PCIDAS64
 
 config COMEDI_CB_PCIDAS
 	tristate "MeasurementComputing PCI-DAS support"
+	depends on LEGACY_PCI
 	select COMEDI_8254
 	select COMEDI_8255
 	help
@@ -942,6 +977,7 @@ config COMEDI_CB_PCIDAS
 
 config COMEDI_CB_PCIDDA
 	tristate "MeasurementComputing PCI-DDA series support"
+	depends on LEGACY_PCI
 	select COMEDI_8255
 	help
 	  Enable support for ComputerBoards/MeasurementComputing PCI-DDA
@@ -953,6 +989,7 @@ config COMEDI_CB_PCIDDA
 
 config COMEDI_CB_PCIMDAS
 	tristate "MeasurementComputing PCIM-DAS1602/16, PCIe-DAS1602/16 support"
+	depends on LEGACY_PCI
 	select COMEDI_8254
 	select COMEDI_8255
 	help
@@ -964,6 +1001,7 @@ config COMEDI_CB_PCIMDAS
 
 config COMEDI_CB_PCIMDDA
 	tristate "MeasurementComputing PCIM-DDA06-16 support"
+	depends on LEGACY_PCI
 	select COMEDI_8255
 	help
 	  Enable support for ComputerBoards/MeasurementComputing PCIM-DDA06-16
@@ -973,6 +1011,7 @@ config COMEDI_CB_PCIMDDA
 
 config COMEDI_ME4000
 	tristate "Meilhaus ME-4000 support"
+	depends on LEGACY_PCI
 	select COMEDI_8254
 	help
 	  Enable support for Meilhaus PCI data acquisition cards
@@ -1031,6 +1070,7 @@ config COMEDI_NI_670X
 
 config COMEDI_NI_LABPC_PCI
 	tristate "NI Lab-PC PCI-1200 support"
+	depends on LEGACY_PCI
 	select COMEDI_NI_LABPC
 	help
 	  Enable support for National Instruments Lab-PC PCI-1200.
@@ -1040,6 +1080,7 @@ config COMEDI_NI_LABPC_PCI
 
 config COMEDI_NI_PCIDIO
 	tristate "NI PCI-DIO32HS, PCI-6533, PCI-6534 support"
+	depends on LEGACY_PCI
 	depends on HAS_DMA
 	select COMEDI_MITE
 	select COMEDI_8255
@@ -1052,6 +1093,7 @@ config COMEDI_NI_PCIDIO
 
 config COMEDI_NI_PCIMIO
 	tristate "NI PCI-MIO-E series and M series support"
+	depends on LEGACY_PCI
 	depends on HAS_DMA
 	select COMEDI_NI_TIOCMD
 	select COMEDI_8255
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 60d9374c72c0..d36afa5ac6fc 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -687,7 +687,7 @@ config GPIO_VR41XX
 
 config GPIO_VX855
 	tristate "VIA VX855/VX875 GPIO"
-	depends on (X86 || COMPILE_TEST) && PCI
+	depends on (X86 || COMPILE_TEST) && LEGACY_PCI
 	select MFD_CORE
 	select MFD_VX855
 	help
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 64bd3dfba2c4..09397562c396 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1654,7 +1654,7 @@ config SENSORS_S3C_RAW
 
 config SENSORS_SIS5595
 	tristate "Silicon Integrated Systems Corp. SiS5595"
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	  If you say yes here you get support for the integrated sensors in
 	  SiS5595 South Bridges.
@@ -1985,7 +1985,7 @@ config SENSORS_VIA_CPUTEMP
 
 config SENSORS_VIA686A
 	tristate "VIA686A"
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	  If you say yes here you get support for the integrated sensors in
 	  Via 686A/B South Bridges.
@@ -2006,7 +2006,7 @@ config SENSORS_VT1211
 
 config SENSORS_VT8231
 	tristate "VIA VT8231"
-	depends on PCI
+	depends on LEGACY_PCI
 	select HWMON_VID
 	help
 	  If you say yes here then you get support for the integrated sensors
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index dce392839017..a8d6274dc965 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -11,7 +11,7 @@ comment "PC SMBus host controller drivers"
 
 config I2C_ALI1535
 	tristate "ALI 1535"
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	  If you say yes to this option, support will be included for the SMB
 	  Host controller on Acer Labs Inc. (ALI) M1535 South Bridges.  The SMB
@@ -23,7 +23,7 @@ config I2C_ALI1535
 
 config I2C_ALI1563
 	tristate "ALI 1563"
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	  If you say yes to this option, support will be included for the SMB
 	  Host controller on Acer Labs Inc. (ALI) M1563 South Bridges.  The SMB
@@ -35,7 +35,7 @@ config I2C_ALI1563
 
 config I2C_ALI15X3
 	tristate "ALI 15x3"
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	  If you say yes to this option, support will be included for the
 	  Acer Labs Inc. (ALI) M1514 and M1543 motherboard I2C interfaces.
@@ -45,7 +45,7 @@ config I2C_ALI15X3
 
 config I2C_AMD756
 	tristate "AMD 756/766/768/8111 and nVidia nForce"
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	  If you say yes to this option, support will be included for the AMD
 	  756/766/768 mainboard I2C interfaces.  The driver also includes
@@ -70,7 +70,7 @@ config I2C_AMD756_S4882
 
 config I2C_AMD8111
 	tristate "AMD 8111"
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	  If you say yes to this option, support will be included for the
 	  second (SMBus 2.0) AMD 8111 mainboard I2C interface.
@@ -154,7 +154,7 @@ config I2C_I801
 
 config I2C_ISCH
 	tristate "Intel SCH SMBus 1.0"
-	depends on PCI
+	depends on LEGACY_PCI
 	select LPC_SCH
 	help
 	  Say Y here if you want to use SMBus controller on the Intel SCH
@@ -221,7 +221,7 @@ config I2C_CHT_WC
 
 config I2C_NFORCE2
 	tristate "Nvidia nForce2, nForce3 and nForce4"
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	  If you say yes to this option, support will be included for the Nvidia
 	  nForce2, nForce3 and nForce4 families of mainboard I2C interfaces.
@@ -253,7 +253,7 @@ config I2C_NVIDIA_GPU
 
 config I2C_SIS5595
 	tristate "SiS 5595"
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	  If you say yes to this option, support will be included for the
 	  SiS5595 SMBus (a subset of I2C) interface.
@@ -263,7 +263,7 @@ config I2C_SIS5595
 
 config I2C_SIS630
 	tristate "SiS 630/730/964"
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	  If you say yes to this option, support will be included for the
 	  SiS630, SiS730 and SiS964 SMBus (a subset of I2C) interface.
@@ -273,7 +273,7 @@ config I2C_SIS630
 
 config I2C_SIS96X
 	tristate "SiS 96x"
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	  If you say yes to this option, support will be included for the SiS
 	  96x SMBus (a subset of I2C) interfaces.  Specifically, the following
@@ -291,7 +291,7 @@ config I2C_SIS96X
 
 config I2C_VIA
 	tristate "VIA VT82C586B"
-	depends on PCI
+	depends on LEGACY_PCI
 	select I2C_ALGOBIT
 	help
 	  If you say yes to this option, support will be included for the VIA
@@ -302,7 +302,7 @@ config I2C_VIA
 
 config I2C_VIAPRO
 	tristate "VIA VT82C596/82C686/82xx and CX700/VX8xx/VX900"
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	  If you say yes to this option, support will be included for the VIA
 	  VT82C596 and later SMBus interface.  Specifically, the following
diff --git a/drivers/input/gameport/Kconfig b/drivers/input/gameport/Kconfig
index 5a2c2fb3217d..082280f95333 100644
--- a/drivers/input/gameport/Kconfig
+++ b/drivers/input/gameport/Kconfig
@@ -43,7 +43,7 @@ config GAMEPORT_L4
 
 config GAMEPORT_EMU10K1
 	tristate "SB Live and Audigy gameport support"
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	  Say Y here if you have a SoundBlaster Live! or SoundBlaster
 	  Audigy card and want to use its gameport.
@@ -53,7 +53,7 @@ config GAMEPORT_EMU10K1
 
 config GAMEPORT_FM801
 	tristate "ForteMedia FM801 gameport support"
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	  Say Y here if you have ForteMedia FM801 PCI audio controller
 	  (Abit AU10, Genius Sound Maker, HP Workstation zx2000,
diff --git a/drivers/isdn/hardware/mISDN/Kconfig b/drivers/isdn/hardware/mISDN/Kconfig
index 078eeadf707a..2c5e16483179 100644
--- a/drivers/isdn/hardware/mISDN/Kconfig
+++ b/drivers/isdn/hardware/mISDN/Kconfig
@@ -7,14 +7,14 @@ comment "mISDN hardware drivers"
 config MISDN_HFCPCI
 	tristate "Support for HFC PCI cards"
 	depends on MISDN
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	  Enable support for cards with Cologne Chip AG's
 	  HFC PCI chip.
 
 config MISDN_HFCMULTI
 	tristate "Support for HFC multiport cards (HFC-4S/8S/E1)"
-	depends on PCI || CPM1
+	depends on LEGACY_PCI || CPM1
 	depends on MISDN
 	help
 	  Enable support for cards with Cologne Chip AG's HFC multiport
@@ -43,7 +43,7 @@ config MISDN_HFCUSB
 config MISDN_AVMFRITZ
 	tristate "Support for AVM FRITZ!CARD PCI"
 	depends on MISDN
-	depends on PCI
+	depends on LEGACY_PCI
 	select MISDN_IPAC
 	help
 	  Enable support for AVMs FRITZ!CARD PCI cards
@@ -51,7 +51,7 @@ config MISDN_AVMFRITZ
 config MISDN_SPEEDFAX
 	tristate "Support for Sedlbauer Speedfax+"
 	depends on MISDN
-	depends on PCI
+	depends on LEGACY_PCI
 	select MISDN_IPAC
 	select MISDN_ISAR
 	help
@@ -60,7 +60,7 @@ config MISDN_SPEEDFAX
 config MISDN_INFINEON
 	tristate "Support for cards with Infineon chipset"
 	depends on MISDN
-	depends on PCI
+	depends on LEGACY_PCI
 	select MISDN_IPAC
 	help
 	  Enable support for cards with ISAC + HSCX, IPAC or IPAC-SX
@@ -69,14 +69,14 @@ config MISDN_INFINEON
 config MISDN_W6692
 	tristate "Support for cards with Winbond 6692"
 	depends on MISDN
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	  Enable support for Winbond 6692 PCI chip based cards.
 
 config MISDN_NETJET
 	tristate "Support for NETJet cards"
 	depends on MISDN
-	depends on PCI
+	depends on LEGACY_PCI
 	depends on TTY
 	select MISDN_IPAC
 	select MISDN_HDLC
diff --git a/drivers/media/cec/platform/Kconfig b/drivers/media/cec/platform/Kconfig
index b672d3142eb7..5e92ece5b104 100644
--- a/drivers/media/cec/platform/Kconfig
+++ b/drivers/media/cec/platform/Kconfig
@@ -100,7 +100,7 @@ config CEC_TEGRA
 config CEC_SECO
 	tristate "SECO Boards HDMI CEC driver"
 	depends on (X86 || IA64) || COMPILE_TEST
-	depends on PCI && DMI
+	depends on LEGACY_PCI && DMI
 	select CEC_CORE
 	select CEC_NOTIFIER
 	help
diff --git a/drivers/media/pci/dm1105/Kconfig b/drivers/media/pci/dm1105/Kconfig
index e0e3af67c99c..9ecab93685d4 100644
--- a/drivers/media/pci/dm1105/Kconfig
+++ b/drivers/media/pci/dm1105/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config DVB_DM1105
 	tristate "SDMC DM1105 based PCI cards"
-	depends on DVB_CORE && PCI && I2C && I2C_ALGOBIT
+	depends on DVB_CORE && LEGACY_PCI && I2C && I2C_ALGOBIT
 	select DVB_PLL if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_STV0299 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_STV0288 if MEDIA_SUBDRV_AUTOSELECT
diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index d29e29645e04..32eb73993998 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -67,7 +67,7 @@ config USB_DSBR
 
 config RADIO_MAXIRADIO
 	tristate "Guillemot MAXI Radio FM 2000 radio"
-	depends on VIDEO_V4L2 && PCI
+	depends on VIDEO_V4L2 && LEGACY_PCI
 	select RADIO_TEA575X
 	help
 	  Choose Y here if you have this radio card.  This card may also be
diff --git a/drivers/message/fusion/Kconfig b/drivers/message/fusion/Kconfig
index a3d0288fd0e2..cec5995e1911 100644
--- a/drivers/message/fusion/Kconfig
+++ b/drivers/message/fusion/Kconfig
@@ -2,7 +2,7 @@
 
 menuconfig FUSION
 	bool "Fusion MPT device support"
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	Say Y here to get to see options for Fusion Message
 	Passing Technology (MPT) drivers.
@@ -14,7 +14,7 @@ if FUSION
 
 config FUSION_SPI
 	tristate "Fusion MPT ScsiHost drivers for SPI"
-	depends on PCI && SCSI
+	depends on LEGACY_PCI && SCSI
 	select SCSI_SPI_ATTRS
 	help
 	  SCSI HOST support for a parallel SCSI host adapters.
@@ -29,7 +29,7 @@ config FUSION_SPI
 
 config FUSION_FC
 	tristate "Fusion MPT ScsiHost drivers for FC"
-	depends on PCI && SCSI
+	depends on LEGACY_PCI && SCSI
 	depends on SCSI_FC_ATTRS
 	help
 	  SCSI HOST support for a Fiber Channel host adapters.
@@ -48,7 +48,7 @@ config FUSION_FC
 
 config FUSION_SAS
 	tristate "Fusion MPT ScsiHost drivers for SAS"
-	depends on PCI && SCSI
+	depends on LEGACY_PCI && SCSI
 	select SCSI_SAS_ATTRS
 	help
 	  SCSI HOST support for a SAS host adapters.
diff --git a/drivers/net/arcnet/Kconfig b/drivers/net/arcnet/Kconfig
index a51b9dab6d3a..b8038287c4f2 100644
--- a/drivers/net/arcnet/Kconfig
+++ b/drivers/net/arcnet/Kconfig
@@ -4,7 +4,7 @@
 #
 
 menuconfig ARCNET
-	depends on NETDEVICES && (ISA || PCI || PCMCIA)
+	depends on NETDEVICES && (ISA || LEGACY_PCI || PCMCIA)
 	tristate "ARCnet support"
 	help
 	  If you have a network card of this type, say Y and check out the
diff --git a/drivers/net/ethernet/8390/Kconfig b/drivers/net/ethernet/8390/Kconfig
index a4130e643342..0fa43943ea74 100644
--- a/drivers/net/ethernet/8390/Kconfig
+++ b/drivers/net/ethernet/8390/Kconfig
@@ -117,7 +117,7 @@ config NE2000
 
 config NE2K_PCI
 	tristate "PCI NE2000 and clones support (see help)"
-	depends on PCI
+	depends on LEGACY_PCI
 	select CRC32
 	help
 	  This driver is for NE2000 compatible PCI cards. It will not work
diff --git a/drivers/net/ethernet/amd/Kconfig b/drivers/net/ethernet/amd/Kconfig
index 899c8a2a34b6..0ac61a5f1a37 100644
--- a/drivers/net/ethernet/amd/Kconfig
+++ b/drivers/net/ethernet/amd/Kconfig
@@ -56,7 +56,7 @@ config LANCE
 
 config PCNET32
 	tristate "AMD PCnet32 PCI support"
-	depends on PCI
+	depends on LEGACY_PCI
 	select CRC32
 	select MII
 	help
diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index 0b274d8fa45b..45a3c42945fc 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -18,7 +18,7 @@ if NET_VENDOR_INTEL
 
 config E100
 	tristate "Intel(R) PRO/100+ support"
-	depends on PCI
+	depends on LEGACY_PCI
 	select MII
 	help
 	  This driver supports Intel(R) PRO/100 family of adapters.
@@ -41,7 +41,7 @@ config E100
 
 config E1000
 	tristate "Intel(R) PRO/1000 Gigabit Ethernet support"
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	  This driver supports Intel(R) PRO/1000 gigabit ethernet family of
 	  adapters.  For more information on how to identify your adapter, go
diff --git a/drivers/net/ethernet/sis/Kconfig b/drivers/net/ethernet/sis/Kconfig
index 775d76d9890e..bd1b1b81b0e8 100644
--- a/drivers/net/ethernet/sis/Kconfig
+++ b/drivers/net/ethernet/sis/Kconfig
@@ -6,7 +6,7 @@
 config NET_VENDOR_SIS
 	bool "Silicon Integrated Systems (SiS) devices"
 	default y
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
@@ -19,7 +19,7 @@ if NET_VENDOR_SIS
 
 config SIS900
 	tristate "SiS 900/7016 PCI Fast Ethernet Adapter support"
-	depends on PCI
+	depends on LEGACY_PCI
 	select CRC32
 	select MII
 	help
@@ -35,7 +35,7 @@ config SIS900
 
 config SIS190
 	tristate "SiS190/SiS191 gigabit ethernet support"
-	depends on PCI
+	depends on LEGACY_PCI
 	select CRC32
 	select MII
 	help
diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index affcf92cd3aa..8b1d67b00e68 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -6,7 +6,7 @@
 config NET_VENDOR_TI
 	bool "Texas Instruments (TI) devices"
 	default y
-	depends on PCI || EISA || AR7 || ARCH_DAVINCI || ARCH_OMAP2PLUS || ARCH_KEYSTONE || ARCH_K3
+	depends on LEGACY_PCI || EISA || AR7 || ARCH_DAVINCI || ARCH_OMAP2PLUS || ARCH_KEYSTONE || ARCH_K3
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
@@ -159,7 +159,7 @@ config TI_KEYSTONE_NETCP_ETHSS
 
 config TLAN
 	tristate "TI ThunderLAN support"
-	depends on (PCI || EISA)
+	depends on (LEGACY_PCI || EISA)
 	help
 	  If you have a PCI Ethernet network card based on the ThunderLAN chip
 	  which is supported by this driver, say Y here.
diff --git a/drivers/net/ethernet/via/Kconfig b/drivers/net/ethernet/via/Kconfig
index da287ef65be7..0ca7d8f7bfde 100644
--- a/drivers/net/ethernet/via/Kconfig
+++ b/drivers/net/ethernet/via/Kconfig
@@ -18,8 +18,8 @@ if NET_VENDOR_VIA
 
 config VIA_RHINE
 	tristate "VIA Rhine support"
-	depends on PCI || (OF_IRQ && GENERIC_PCI_IOMAP)
-	depends on PCI || ARCH_VT8500 || COMPILE_TEST
+	depends on LEGACY_PCI || (OF_IRQ && GENERIC_PCI_IOMAP)
+	depends on LEGACY_PCI || ARCH_VT8500 || COMPILE_TEST
 	depends on HAS_DMA
 	select CRC32
 	select MII
diff --git a/drivers/net/fddi/Kconfig b/drivers/net/fddi/Kconfig
index 846bf41c2717..1753c08d6423 100644
--- a/drivers/net/fddi/Kconfig
+++ b/drivers/net/fddi/Kconfig
@@ -5,7 +5,7 @@
 
 config FDDI
 	tristate "FDDI driver support"
-	depends on PCI || EISA || TC
+	depends on LEGACY_PCI || EISA || TC
 	help
 	  Fiber Distributed Data Interface is a high speed local area network
 	  design; essentially a replacement for high speed Ethernet. FDDI can
@@ -29,7 +29,7 @@ config DEFZA
 
 config DEFXX
 	tristate "Digital DEFTA/DEFEA/DEFPA adapter support"
-	depends on FDDI && (PCI || EISA || TC)
+	depends on FDDI && (LEGACY_PCI || EISA || TC)
 	help
 	  This is support for the DIGITAL series of TURBOchannel (DEFTA),
 	  EISA (DEFEA) and PCI (DEFPA) controllers which can connect you
diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index 592a8389fc5a..631c4c1c56c8 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -250,7 +250,7 @@ config C101
 
 config FARSYNC
 	tristate "FarSync T-Series support"
-	depends on HDLC && PCI
+	depends on HDLC && LEGACY_PCI
 	help
 	  Support for the FarSync T-Series X.21 (and V.35/V.24) cards by
 	  FarSite Communications Ltd.
diff --git a/drivers/net/wireless/atmel/Kconfig b/drivers/net/wireless/atmel/Kconfig
index ca45a1021cf4..9baa4a19dd38 100644
--- a/drivers/net/wireless/atmel/Kconfig
+++ b/drivers/net/wireless/atmel/Kconfig
@@ -14,7 +14,7 @@ if WLAN_VENDOR_ATMEL
 
 config ATMEL
 	tristate "Atmel at76c50x chipset  802.11b support"
-	depends on CFG80211 && (PCI || PCMCIA)
+	depends on CFG80211 && (LEGACY_PCI || PCMCIA)
 	select WIRELESS_EXT
 	select WEXT_PRIV
 	select FW_LOADER
@@ -32,7 +32,7 @@ config ATMEL
 
 config PCI_ATMEL
 	tristate "Atmel at76c506 PCI cards"
-	depends on ATMEL && PCI
+	depends on ATMEL && LEGACY_PCI
 	help
 	  Enable support for PCI and mini-PCI cards containing the
 	  Atmel at76c506 chip.
diff --git a/drivers/net/wireless/intersil/hostap/Kconfig b/drivers/net/wireless/intersil/hostap/Kconfig
index c865d3156cea..9bcd1c8546ff 100644
--- a/drivers/net/wireless/intersil/hostap/Kconfig
+++ b/drivers/net/wireless/intersil/hostap/Kconfig
@@ -56,7 +56,7 @@ config HOSTAP_FIRMWARE_NVRAM
 
 config HOSTAP_PLX
 	tristate "Host AP driver for Prism2/2.5/3 in PLX9052 PCI adaptors"
-	depends on PCI && HOSTAP
+	depends on LEGACY_PCI && HOSTAP
 	help
 	Host AP driver's version for Prism2/2.5/3 PC Cards in PLX9052 based
 	PCI adaptors.
@@ -70,7 +70,7 @@ config HOSTAP_PLX
 
 config HOSTAP_PCI
 	tristate "Host AP driver for Prism2.5 PCI adaptors"
-	depends on PCI && HOSTAP
+	depends on LEGACY_PCI && HOSTAP
 	help
 	Host AP driver's version for Prism2.5 PCI adaptors.
 
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 43e615aa12ff..e0c99ddc145c 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -23,6 +23,17 @@ menuconfig PCI
 
 if PCI
 
+config LEGACY_PCI
+	bool "Enable support for legacy PCI devices"
+	depends on HAVE_PCI
+	help
+	   This option enables support for legacy PCI devices. This includes
+	   PCI devices attached directly or via a bridge on a PCI Express bus.
+	   It also includes compatibility features on PCI Express devices which
+	   make use of legacy I/O spaces.
+
+	   For maximum compatibility with old hardware say 'Y'
+
 config PCI_DOMAINS
 	bool
 	depends on PCI
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 6e3a04107bb6..5436b2be2c73 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -333,7 +333,7 @@ config SGIWD93_SCSI
 
 config BLK_DEV_3W_XXXX_RAID
 	tristate "3ware 5/6/7/8xxx ATA-RAID support"
-	depends on PCI && SCSI
+	depends on LEGACY_PCI && SCSI
 	help
 	  3ware is the only hardware ATA-Raid product in Linux to date.
 	  This card is 2,4, or 8 channel master mode support only.
@@ -380,7 +380,7 @@ config SCSI_3W_SAS
 
 config SCSI_ACARD
 	tristate "ACARD SCSI support"
-	depends on PCI && SCSI
+	depends on LEGACY_PCI && SCSI
 	help
 	  This driver supports the ACARD SCSI host adapter.
 	  Support Chip <ATP870 ATP876 ATP880 ATP885>
@@ -472,7 +472,7 @@ config SCSI_DPT_I2O
 config SCSI_ADVANSYS
 	tristate "AdvanSys SCSI support"
 	depends on SCSI
-	depends on ISA || EISA || PCI
+	depends on ISA || EISA || LEGACY_PCI
 	depends on ISA_DMA_API || !ISA
 	help
 	  This is a driver for all SCSI host adapters manufactured by
@@ -643,7 +643,7 @@ config SCSI_SNIC_DEBUG_FS
 
 config SCSI_DMX3191D
 	tristate "DMX3191D SCSI support"
-	depends on PCI && SCSI
+	depends on LEGACY_PCI && SCSI
 	select SCSI_SPI_ATTRS
 	help
 	  This is support for Domex DMX3191D SCSI Host Adapters.
@@ -657,7 +657,7 @@ config SCSI_FDOMAIN
 
 config SCSI_FDOMAIN_PCI
 	tristate "Future Domain TMC-3260/AHA-2920A PCI SCSI support"
-	depends on PCI && SCSI
+	depends on LEGACY_PCI && SCSI
 	select SCSI_FDOMAIN
 	help
 	  This is support for Future Domain's PCI SCSI host adapters (TMC-3260)
@@ -710,7 +710,7 @@ config SCSI_GENERIC_NCR5380
 
 config SCSI_IPS
 	tristate "IBM ServeRAID support"
-	depends on PCI && SCSI
+	depends on LEGACY_PCI && SCSI
 	help
 	  This is support for the IBM ServeRAID hardware RAID controllers.
 	  See <http://www.developer.ibm.com/welcome/netfinity/serveraid.html>
@@ -770,7 +770,7 @@ config SCSI_IBMVFC_TRACE
 
 config SCSI_INITIO
 	tristate "Initio 9100U(W) support"
-	depends on PCI && SCSI
+	depends on LEGACY_PCI && SCSI
 	help
 	  This is support for the Initio 91XXU(W) SCSI host adapter.  Please
 	  read the SCSI-HOWTO, available from
@@ -781,7 +781,7 @@ config SCSI_INITIO
 
 config SCSI_INIA100
 	tristate "Initio INI-A100U2W support"
-	depends on PCI && SCSI
+	depends on LEGACY_PCI && SCSI
 	help
 	  This is support for the Initio INI-A100U2W SCSI host adapter.
 	  Please read the SCSI-HOWTO, available from
@@ -1130,7 +1130,7 @@ config SCSI_QLOGIC_FAS
 
 config SCSI_QLOGIC_1280
 	tristate "Qlogic QLA 1240/1x80/1x160 SCSI support"
-	depends on PCI && SCSI
+	depends on LEGACY_PCI && SCSI
 	help
 	  Say Y if you have a QLogic ISP1240/1x80/1x160 SCSI host adapter.
 
@@ -1187,7 +1187,7 @@ config SCSI_SIM710
 
 config SCSI_DC395x
 	tristate "Tekram DC395(U/UW/F) and DC315(U) SCSI support"
-	depends on PCI && SCSI
+	depends on LEGACY_PCI && SCSI
 	select SCSI_SPI_ATTRS
 	help
 	  This driver supports PCI SCSI host adapters based on the ASIC
diff --git a/drivers/scsi/aic7xxx/Kconfig.aic79xx b/drivers/scsi/aic7xxx/Kconfig.aic79xx
index a47dbd500e9a..64332cc73ea0 100644
--- a/drivers/scsi/aic7xxx/Kconfig.aic79xx
+++ b/drivers/scsi/aic7xxx/Kconfig.aic79xx
@@ -5,7 +5,7 @@
 #
 config SCSI_AIC79XX
 	tristate "Adaptec AIC79xx U320 support"
-	depends on PCI && SCSI
+	depends on LEGACY_PCI && SCSI
 	select SCSI_SPI_ATTRS
 	help
 	This driver supports all of Adaptec's Ultra 320 PCI-X
diff --git a/drivers/scsi/aic7xxx/Kconfig.aic7xxx b/drivers/scsi/aic7xxx/Kconfig.aic7xxx
index 0cfd92ce750a..3fa5dc1d1186 100644
--- a/drivers/scsi/aic7xxx/Kconfig.aic7xxx
+++ b/drivers/scsi/aic7xxx/Kconfig.aic7xxx
@@ -5,7 +5,7 @@
 #
 config SCSI_AIC7XXX
 	tristate "Adaptec AIC7xxx Fast -> U160 support"
-	depends on (PCI || EISA) && SCSI
+	depends on (LEGACY_PCI || EISA) && SCSI
 	select SCSI_SPI_ATTRS
 	help
 	This driver supports all of Adaptec's Fast through Ultra 160 PCI
diff --git a/drivers/scsi/aic94xx/Kconfig b/drivers/scsi/aic94xx/Kconfig
index 71931c371b1c..b0cbf65dbe5b 100644
--- a/drivers/scsi/aic94xx/Kconfig
+++ b/drivers/scsi/aic94xx/Kconfig
@@ -8,7 +8,7 @@
 
 config SCSI_AIC94XX
 	tristate "Adaptec AIC94xx SAS/SATA support"
-	depends on PCI
+	depends on LEGACY_PCI
 	select SCSI_SAS_LIBSAS
 	select FW_LOADER
 	help
diff --git a/drivers/scsi/megaraid/Kconfig.megaraid b/drivers/scsi/megaraid/Kconfig.megaraid
index 2adc2afd9f91..4ec46aede490 100644
--- a/drivers/scsi/megaraid/Kconfig.megaraid
+++ b/drivers/scsi/megaraid/Kconfig.megaraid
@@ -67,7 +67,7 @@ config MEGARAID_MAILBOX
 
 config MEGARAID_LEGACY
 	tristate "LSI Logic Legacy MegaRAID Driver"
-	depends on PCI && SCSI
+	depends on LEGACY_PCI && SCSI
 	help
 	This driver supports the LSI MegaRAID 418, 428, 438, 466, 762, 490
 	and 467 SCSI host adapters. This driver also support the all U320
diff --git a/drivers/scsi/mvsas/Kconfig b/drivers/scsi/mvsas/Kconfig
index 79812b80743b..f41f3f4a9f34 100644
--- a/drivers/scsi/mvsas/Kconfig
+++ b/drivers/scsi/mvsas/Kconfig
@@ -9,7 +9,7 @@
 
 config SCSI_MVSAS
 	tristate "Marvell 88SE64XX/88SE94XX SAS/SATA support"
-	depends on PCI
+	depends on LEGACY_PCI
 	select SCSI_SAS_LIBSAS
 	select FW_LOADER
 	help
diff --git a/drivers/scsi/qla2xxx/Kconfig b/drivers/scsi/qla2xxx/Kconfig
index 802c373fd6d9..93afb73858ce 100644
--- a/drivers/scsi/qla2xxx/Kconfig
+++ b/drivers/scsi/qla2xxx/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config SCSI_QLA_FC
 	tristate "QLogic QLA2XXX Fibre Channel Support"
-	depends on PCI && SCSI
+	depends on LEGACY_PCI && SCSI
 	depends on SCSI_FC_ATTRS
 	depends on NVME_FC || !NVME_FC
 	select FW_LOADER
diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 596705d24400..cfbd45767095 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -204,6 +204,7 @@ config SPI_BITBANG
 config SPI_BUTTERFLY
 	tristate "Parallel port adapter for AVR Butterfly (DEVELOPMENT)"
 	depends on PARPORT
+	depends on HAS_IOPORT
 	select SPI_BITBANG
 	help
 	  This uses a custom parallel port cable to connect to an AVR
diff --git a/drivers/staging/sm750fb/Kconfig b/drivers/staging/sm750fb/Kconfig
index 8c0d8a873d5b..d332f912b964 100644
--- a/drivers/staging/sm750fb/Kconfig
+++ b/drivers/staging/sm750fb/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 config FB_SM750
 	tristate "Silicon Motion SM750 framebuffer support"
-	depends on FB && PCI
+	depends on FB && LEGACY_PCI
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
diff --git a/drivers/staging/vt6655/Kconfig b/drivers/staging/vt6655/Kconfig
index d1cd5de46dcf..dd236f54d3a2 100644
--- a/drivers/staging/vt6655/Kconfig
+++ b/drivers/staging/vt6655/Kconfig
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 config VT6655
    tristate "VIA Technologies VT6655 support"
-   depends on PCI && MAC80211 && m
+   depends on LEGACY_PCI && MAC80211 && m
    help
      This is a vendor-written driver for VIA VT6655.
diff --git a/drivers/tty/Kconfig b/drivers/tty/Kconfig
index cc30ff93e2e4..460326a529d6 100644
--- a/drivers/tty/Kconfig
+++ b/drivers/tty/Kconfig
@@ -203,7 +203,7 @@ config MOXA_INTELLIO
 
 config MOXA_SMARTIO
 	tristate "Moxa SmartIO support v. 2.0"
-	depends on SERIAL_NONSTANDARD && PCI
+	depends on SERIAL_NONSTANDARD && LEGACY_PCI
 	help
 	  Say Y here if you have a Moxa SmartIO multiport serial card and/or
 	  want to help develop a new version of this driver.
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index fc543ac97c13..607791b7f693 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -908,7 +908,7 @@ config SERIAL_VR41XX_CONSOLE
 
 config SERIAL_JSM
 	tristate "Digi International NEO and Classic PCI Support"
-	depends on PCI
+	depends on LEGACY_PCI
 	select SERIAL_CORE
 	help
 	  This is a driver for Digi International's Neo and Classic series
diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index 6ed5e608dd04..a3446d44c118 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -343,7 +343,7 @@ config FB_IMX
 
 config FB_CYBER2000
 	tristate "CyberPro 2000/2010/5000 support"
-	depends on FB && PCI && (BROKEN || !SPARC64)
+	depends on FB && LEGACY_PCI && (BROKEN || !SPARC64)
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
@@ -1264,7 +1264,7 @@ config FB_ATY128_BACKLIGHT
 	  Say Y here if you want to control the backlight of your display.
 
 config FB_ATY
-	tristate "ATI Mach64 display support" if PCI || ATARI
+	tristate "ATI Mach64 display support" if LEGACY_PCI || ATARI
 	depends on FB && !SPARC32
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -1315,7 +1315,7 @@ config FB_ATY_BACKLIGHT
 
 config FB_S3
 	tristate "S3 Trio/Virge support"
-	depends on FB && PCI
+	depends on FB && LEGACY_PCI
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
@@ -1374,7 +1374,7 @@ config FB_SAVAGE_ACCEL
 
 config FB_SIS
 	tristate "SiS/XGI display support"
-	depends on FB && PCI
+	depends on FB && LEGACY_PCI
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
@@ -1404,7 +1404,7 @@ config FB_SIS_315
 
 config FB_VIA
 	tristate "VIA UniChrome (Pro) and Chrome9 display support"
-	depends on FB && PCI && GPIOLIB && I2C && (X86 || COMPILE_TEST)
+	depends on FB && LEGACY_PCI && GPIOLIB && I2C && (X86 || COMPILE_TEST)
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
@@ -1442,7 +1442,7 @@ endif
 
 config FB_NEOMAGIC
 	tristate "NeoMagic display support"
-	depends on FB && PCI
+	depends on FB && LEGACY_PCI
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -1470,7 +1470,7 @@ config FB_KYRO
 
 config FB_3DFX
 	tristate "3Dfx Banshee/Voodoo3/Voodoo5 display support"
-	depends on FB && PCI
+	depends on FB && LEGACY_PCI
 	select FB_CFB_IMAGEBLIT
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -1518,7 +1518,7 @@ config FB_VOODOO1
 
 config FB_VT8623
 	tristate "VIA VT8623 support"
-	depends on FB && PCI
+	depends on FB && LEGACY_PCI
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
@@ -1532,7 +1532,7 @@ config FB_VT8623
 
 config FB_TRIDENT
 	tristate "Trident/CyberXXX/CyberBlade support"
-	depends on FB && PCI
+	depends on FB && LEGACY_PCI
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
@@ -1554,7 +1554,7 @@ config FB_TRIDENT
 
 config FB_ARK
 	tristate "ARK 2000PV support"
-	depends on FB && PCI
+	depends on FB && LEGACY_PCI
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
@@ -2226,7 +2226,7 @@ config FB_SSD1307
 
 config FB_SM712
 	tristate "Silicon Motion SM712 framebuffer support"
-	depends on FB && PCI
+	depends on FB && LEGACY_PCI
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 9d222ba17ec6..05258109bcc2 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -2053,7 +2053,7 @@ comment "PCI-based Watchdog Cards"
 
 config PCIPCWATCHDOG
 	tristate "Berkshire Products PCI-PC Watchdog"
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	  This is the driver for the Berkshire Products PCI-PC Watchdog card.
 	  This card simply watches your kernel to make sure it doesn't freeze,
@@ -2068,7 +2068,7 @@ config PCIPCWATCHDOG
 
 config WDTPCI
 	tristate "PCI-WDT500/501 Watchdog timer"
-	depends on PCI
+	depends on LEGACY_PCI
 	help
 	  If you have a PCI-WDT500/501 watchdog board, say Y here, otherwise N.
 
diff --git a/sound/pci/Kconfig b/sound/pci/Kconfig
index 41ce12597177..07d9587eede4 100644
--- a/sound/pci/Kconfig
+++ b/sound/pci/Kconfig
@@ -23,10 +23,10 @@ config SND_AD1889
 
 config SND_ALS300
 	tristate "Avance Logic ALS300/ALS300+"
+	depends on LEGACY_PCI && ZONE_DMA
 	select SND_PCM
 	select SND_AC97_CODEC
 	select SND_OPL3_LIB
-	depends on ZONE_DMA
 	help
 	  Say 'Y' or 'M' to include support for Avance Logic ALS300/ALS300+
 
@@ -35,6 +35,7 @@ config SND_ALS300
 
 config SND_ALS4000
 	tristate "Avance Logic ALS4000"
+	depends on LEGACY_PCI
 	depends on ISA_DMA_API
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
@@ -49,6 +50,7 @@ config SND_ALS4000
 
 config SND_ALI5451
 	tristate "ALi M5451 PCI Audio Controller"
+	depends on LEGACY_PCI
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
 	depends on ZONE_DMA
@@ -96,6 +98,7 @@ config SND_ATIIXP_MODEM
 
 config SND_AU8810
 	tristate "Aureal Advantage"
+	depends on LEGACY_PCI
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
 	help
@@ -110,6 +113,7 @@ config SND_AU8810
 
 config SND_AU8820
 	tristate "Aureal Vortex"
+	depends on LEGACY_PCI
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
 	help
@@ -123,6 +127,7 @@ config SND_AU8820
 
 config SND_AU8830
 	tristate "Aureal Vortex 2"
+	depends on LEGACY_PCI
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
 	help
@@ -151,13 +156,13 @@ config SND_AW2
 
 config SND_AZT3328
 	tristate "Aztech AZF3328 / PCI168"
+	depends on LEGACY_PCI && ZONE_DMA
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_PCM
 	select SND_RAWMIDI
 	select SND_AC97_CODEC
 	select SND_TIMER
-	depends on ZONE_DMA
 	help
 	  Say Y here to include support for Aztech AZF3328 (PCI168)
 	  soundcards.
@@ -172,6 +177,7 @@ config SND_AZT3328
 
 config SND_BT87X
 	tristate "Bt87x Audio Capture"
+	depends on LEGACY_PCI
 	select SND_PCM
 	help
 	  If you want to record audio from TV cards based on
@@ -193,6 +199,7 @@ config SND_BT87X_OVERCLOCK
 
 config SND_CA0106
 	tristate "SB Audigy LS / Live 24bit"
+	depends on LEGACY_PCI
 	select SND_AC97_CODEC
 	select SND_RAWMIDI
 	select SND_VMASTER
@@ -205,6 +212,7 @@ config SND_CA0106
 
 config SND_CMIPCI
 	tristate "C-Media 8338, 8738, 8768, 8770"
+	depends on LEGACY_PCI
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_PCM
@@ -221,6 +229,7 @@ config SND_OXYGEN_LIB
 
 config SND_OXYGEN
 	tristate "C-Media 8786, 8787, 8788 (Oxygen)"
+	depends on LEGACY_PCI
 	select SND_OXYGEN_LIB
 	select SND_PCM
 	select SND_MPU401_UART
@@ -246,6 +255,7 @@ config SND_OXYGEN
 
 config SND_CS4281
 	tristate "Cirrus Logic (Sound Fusion) CS4281"
+	depends on LEGACY_PCI
 	select SND_OPL3_LIB
 	select SND_RAWMIDI
 	select SND_AC97_CODEC
@@ -257,6 +267,7 @@ config SND_CS4281
 
 config SND_CS46XX
 	tristate "Cirrus Logic (Sound Fusion) CS4280/CS461x/CS462x/CS463x"
+	depends on LEGACY_PCI
 	select SND_RAWMIDI
 	select SND_AC97_CODEC
 	select FW_LOADER
@@ -290,6 +301,7 @@ config SND_CS5530
 config SND_CS5535AUDIO
 	tristate "CS5535/CS5536 Audio"
 	depends on X86_32 || MIPS || COMPILE_TEST
+	depends on LEGACY_PCI
 	select SND_PCM
 	select SND_AC97_CODEC
 	help
@@ -307,6 +319,7 @@ config SND_CS5535AUDIO
 
 config SND_CTXFI
 	tristate "Creative Sound Blaster X-Fi"
+	depends on LEGACY_PCI
 	select SND_PCM
 	help
 	  If you want to use soundcards based on Creative Sound Blastr X-Fi
@@ -462,13 +475,13 @@ config SND_INDIGODJX
 
 config SND_EMU10K1
 	tristate "Emu10k1 (SB Live!, Audigy, E-mu APS)"
+	depends on LEGACY_PCI && ZONE_DMA
 	select FW_LOADER
 	select SND_HWDEP
 	select SND_RAWMIDI
 	select SND_AC97_CODEC
 	select SND_TIMER
 	select SND_SEQ_DEVICE if SND_SEQUENCER != n
-	depends on ZONE_DMA
 	help
 	  Say Y to include support for Sound Blaster PCI 512, Live!,
 	  Audigy and E-mu APS (partially supported) soundcards.
@@ -489,6 +502,7 @@ config SND_EMU10K1_SEQ
 
 config SND_EMU10K1X
 	tristate "Emu10k1X (Dell OEM Version)"
+	depends on LEGACY_PCI
 	select SND_AC97_CODEC
 	select SND_RAWMIDI
 	depends on ZONE_DMA
@@ -501,6 +515,7 @@ config SND_EMU10K1X
 
 config SND_ENS1370
 	tristate "(Creative) Ensoniq AudioPCI 1370"
+	depends on LEGACY_PCI
 	select SND_RAWMIDI
 	select SND_PCM
 	help
@@ -511,6 +526,7 @@ config SND_ENS1370
 
 config SND_ENS1371
 	tristate "(Creative) Ensoniq AudioPCI 1371/1373"
+	depends on LEGACY_PCI
 	select SND_RAWMIDI
 	select SND_AC97_CODEC
 	help
@@ -522,10 +538,10 @@ config SND_ENS1371
 
 config SND_ES1938
 	tristate "ESS ES1938/1946/1969 (Solo-1)"
+	depends on LEGACY_PCI && ZONE_DMA
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
-	depends on ZONE_DMA
 	help
 	  Say Y here to include support for soundcards based on ESS Solo-1
 	  (ES1938, ES1946, ES1969) chips.
@@ -535,9 +551,9 @@ config SND_ES1938
 
 config SND_ES1968
 	tristate "ESS ES1968/1978 (Maestro-1/2/2E)"
+	depends on LEGACY_PCI && ZONE_DMA
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
-	depends on ZONE_DMA
 	help
 	  Say Y here to include support for soundcards based on ESS Maestro
 	  1/2/2E chips.
@@ -569,6 +585,7 @@ config SND_ES1968_RADIO
 
 config SND_FM801
 	tristate "ForteMedia FM801"
+	depends on LEGACY_PCI
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
@@ -621,10 +638,10 @@ config SND_HDSPM
 
 config SND_ICE1712
 	tristate "ICEnsemble ICE1712 (Envy24)"
+	depends on LEGACY_PCI && ZONE_DMA
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
 	select BITREVERSE
-	depends on ZONE_DMA
 	help
 	  Say Y here to include support for soundcards based on the
 	  ICE1712 (Envy24) chip.
@@ -640,6 +657,7 @@ config SND_ICE1712
 
 config SND_ICE1724
 	tristate "ICE/VT1724/1720 (Envy24HT/PT)"
+	depends on LEGACY_PCI && ZONE_DMA
 	select SND_RAWMIDI
 	select SND_AC97_CODEC
 	select SND_VMASTER
@@ -712,6 +730,7 @@ config SND_LX6464ES
 config SND_MAESTRO3
 	tristate "ESS Allegro/Maestro3"
 	select SND_AC97_CODEC
+	depends on LEGACY_PCI
 	depends on ZONE_DMA
 	help
 	  Say Y here to include support for soundcards based on ESS Maestro 3
@@ -753,6 +772,7 @@ config SND_NM256
 
 config SND_PCXHR
 	tristate "Digigram PCXHR"
+	depends on LEGACY_PCI
 	select FW_LOADER
 	select SND_PCM
 	select SND_HWDEP
@@ -764,6 +784,7 @@ config SND_PCXHR
 
 config SND_RIPTIDE
 	tristate "Conexant Riptide"
+	depends on LEGACY_PCI
 	select FW_LOADER
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
@@ -808,6 +829,7 @@ config SND_RME9652
 config SND_SE6X
 	tristate "Studio Evolution SE6X"
 	depends on SND_OXYGEN=n && SND_VIRTUOSO=n  # PCI ID conflict
+	depends on LEGACY_PCI
 	select SND_OXYGEN_LIB
 	select SND_PCM
 	select SND_MPU401_UART
@@ -827,10 +849,10 @@ config SND_SIS7019
 
 config SND_SONICVIBES
 	tristate "S3 SonicVibes"
+	depends on LEGACY_PCI && ZONE_DMA
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
-	depends on ZONE_DMA
 	help
 	  Say Y here to include support for soundcards based on the S3
 	  SonicVibes chip.
@@ -840,9 +862,9 @@ config SND_SONICVIBES
 
 config SND_TRIDENT
 	tristate "Trident 4D-Wave DX/NX; SiS 7018"
+	depends on LEGACY_PCI && ZONE_DMA
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
-	depends on ZONE_DMA
 	help
 	  Say Y here to include support for soundcards based on Trident
 	  4D-Wave DX/NX or SiS 7018 chips.
@@ -852,6 +874,7 @@ config SND_TRIDENT
 
 config SND_VIA82XX
 	tristate "VIA 82C686A/B, 8233/8235 AC97 Controller"
+	depends on LEGACY_PCI
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
 	help
@@ -863,6 +886,7 @@ config SND_VIA82XX
 
 config SND_VIA82XX_MODEM
 	tristate "VIA 82C686A/B, 8233 based Modems"
+	depends on LEGACY_PCI
 	select SND_AC97_CODEC
 	help
 	  Say Y here to include support for the integrated MC97 modem on
@@ -873,6 +897,7 @@ config SND_VIA82XX_MODEM
 
 config SND_VIRTUOSO
 	tristate "Asus Virtuoso 66/100/200 (Xonar)"
+	depends on LEGACY_PCI
 	select SND_OXYGEN_LIB
 	select SND_PCM
 	select SND_MPU401_UART
@@ -889,6 +914,7 @@ config SND_VIRTUOSO
 
 config SND_VX222
 	tristate "Digigram VX222"
+	depends on LEGACY_PCI
 	select SND_VX_LIB
 	help
 	  Say Y here to include support for Digigram VX222 soundcards.
@@ -898,6 +924,7 @@ config SND_VX222
 
 config SND_YMFPCI
 	tristate "Yamaha YMF724/740/744/754"
+	depends on LEGACY_PCI
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_AC97_CODEC
-- 
2.32.0

