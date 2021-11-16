Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6B5452AD1
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 07:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbhKPGaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 01:30:18 -0500
Received: from mail-bn8nam12on2128.outbound.protection.outlook.com ([40.107.237.128]:38113
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231279AbhKPG2H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 01:28:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LWryAJhnSye9EqiFLZ3qurNAqJs8mz1XD8oylOxjjJsklNvLAX+ReMlqUSfDsXKwF3vxS/M265+qjTgRkZCHojC4s2TUgrGkHIiGZeRhOVxe3irWGGdh27sgCJgplf7Da5OVmzauBXfvC+QaPACE8U2I5VAPiaS5IkEO19a9IwfypM6QHZOXDqADb/u7gTYhZsodTaJuCYXF8fpcOZfN/ELP/grkjlPXRHqCCerC4m9bbjASXPd99nAf36UFhYrTdiu1pXYegHeLTxIgd+F0eKcMFJQr9UNASeWafqr1UrErdA924JZ7zc/M9CukvzLL+LStg+RH3D0BZl227Xr/9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UVEFQ48pRASMnkcjHYeli18jdIiZoJZmOjvh8qu7mus=;
 b=Wcsg3eKEy16CEhEF+PWkQZqvy2oNv1OW8izw/+A2XQTiGJVNWdlTPwYUZE9gIgJCTjjTi4dAnQabjd4SII1w0ly7eNDafHdYuMD+Tdi+KddoF0HDuwolWyUN+223S02A+0y1FxG8fh9gZjBc1q8WC4AE60aLIhFAXoS7a80t/mwljG7kM/lSI5Jl95wjT97RIe5aXnqzbuvM8Nj7dk5E59ITcs3sLqI/w2kc+Uqs/vV7Ko0sEJL/fWt13HnFPNhkoHuy72eTyNOvl41ydb0Gq/EC+GQ5UzGGjeoJryjXdz6HwO2YiVr8LwPtNN8o1Ces6AcHM1Yhg4V7kFGIEgRDtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVEFQ48pRASMnkcjHYeli18jdIiZoJZmOjvh8qu7mus=;
 b=cg/+DdtRNoK/d0ySvcfme16FrxARE/WQwq/u4zGiBQhD4xGhryFW3luMIfVIAZ+i+zoYVgtameUwMlQAWgK9HVEdBv1AQvhdw9tPaWPfwdKB14a/hQv4YmuLUSORX4qgfFLGwS1F9bbGacWMgn2fDrLTNunGOR95ZT4PehBvXVU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1501.namprd10.prod.outlook.com
 (2603:10b6:300:24::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Tue, 16 Nov
 2021 06:24:00 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4690.026; Tue, 16 Nov 2021
 06:24:00 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [RFC PATCH v4 net-next 23/23] net: dsa: ocelot: felix: add support for VSC75XX control over SPI
Date:   Mon, 15 Nov 2021 22:23:28 -0800
Message-Id: <20211116062328.1949151-24-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116062328.1949151-1-colin.foster@in-advantage.com>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR11CA0028.namprd11.prod.outlook.com
 (2603:10b6:300:115::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR11CA0028.namprd11.prod.outlook.com (2603:10b6:300:115::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Tue, 16 Nov 2021 06:23:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42861876-bf13-4b17-3026-08d9a8c9ad84
X-MS-TrafficTypeDiagnostic: MWHPR10MB1501:
X-Microsoft-Antispam-PRVS: <MWHPR10MB150127FACBE2BD7A26B8DA27A4999@MWHPR10MB1501.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:741;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j8Ae3beibUGrLz4cZZZDY4UEpm7x8CxAIBBe/I7jzWrk3IT93RtgVZa5vtzZTEeltUZEsz7eO7MF7NKXpmU6aVhCuB+CNatbt2WS7vmdAwOhGLaZ4QkWZAGgGLqoLWAMXuhdfXD+nQJcCBjyUww1vjMDIbUcXzGQJoB8jp8OCKQfTejIN7eEujSGrkouE+B/fOcDfi3yowPnrsHXFJUDDWGwkkvCdGxxUEzhk/uWwp3j5uhQf+EjJ4A8fMkzzxqHomBHdL56U2rHnQS/2RY3U+VlDOqQVBycBZFwUUDv7+n6G45wPSOD7OnD736jzqOvlJYfOuYrUBpoIvcgGiSj2glWStIzH07txy1zwO5UQhppr+t3JLh/1jxs8KiPy9yL6rS2ldSsBl5AcOZ8jHkGC/NIwy1wluES+ysHvzDWzpbsiXcJ+VpCwQjlJDmy5eE/xArkjhmbmVtYJY/0dwOQ4HSJbMn/3wwXy1Kb9iaodzEih2q9n/U8ggvqpjTm3Qb7F6fOHTd5D9FYWX8wTGeefWpCeSPKwz8Ep/f3op27vEXaY/1Vkl+qMQDfZIZTyHg+nxN4Pvhdlm08AZgWObCq/RwygDwZuKTVRr3q6r84ROCQmF7sLHbWPl6epGP4JYfsgTpDDT2SMZBlNUN1VgvQYAc8kOIWxW0/pzH4Ir+Fuzy3jwgSOZHitCesrYGYg3P00vLD29XmUkE72MplCtOrBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(366004)(39840400004)(346002)(4326008)(2616005)(30864003)(956004)(186003)(44832011)(7416002)(6506007)(1076003)(26005)(86362001)(6486002)(38350700002)(66946007)(54906003)(36756003)(38100700002)(316002)(6512007)(5660300002)(2906002)(508600001)(66556008)(8676002)(66476007)(6666004)(8936002)(83380400001)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QM62OrCRy99Mp7d4JWmtspokSS0qiHDuurrOX+Emp34MxduOoXHgA1nUZC34?=
 =?us-ascii?Q?69Y20G3HsFjG/DLAAffTJrTF5M/ET6UIYw+0ATupZ66qOI79XFnD8GW5vcl4?=
 =?us-ascii?Q?GfxUfXXuJ2Syu8s1iIb0DojV+jE5uQP54MzHzRePH+Tg1D+70PNpE2YRdR3Y?=
 =?us-ascii?Q?HAZSWFZHIr1qNw/Uu54a+ZvaZc+r5WXrqMRJvuYKL8yTLG+jrTai6BR+8V0n?=
 =?us-ascii?Q?c1ziBA3sznqACz3JolRcKmtZEZcj0PIDW/IKHycByKBhaDAnJQiZCojMOV1H?=
 =?us-ascii?Q?L26qy3DtD1c6fVykqqxeR5tdEyinGqQw4Eoe3vi1QDI9KgWhbpdIJSUxHejX?=
 =?us-ascii?Q?TL94b8zuYi8ELvws65g6DqAxpVtGEoxwyJCqXcdMb2O8JwJwYJfpGXehzQAr?=
 =?us-ascii?Q?NfZQ+hLUizaj7PSIKAsCFCZSsUCSU4oM2g4ITkH5Fdy73Isix1ZtaUzJiWVL?=
 =?us-ascii?Q?LFocaW+rmSZeJyKpDz4yJ2qMUgHcQubL1qBRvEk1GV+HjWkVrDdkjIt4z92R?=
 =?us-ascii?Q?yKaXKLp/ha6K9gNLkoUx/u6i76Q/HvEYJB4LBvwDSnm95fS3CcBnv7QU3I5d?=
 =?us-ascii?Q?+SoX7L2mjmIfuPV2Y7Cv/2pu68d0fV4vnWBGbfXKLtFzWAKts+FW9S1MC7eX?=
 =?us-ascii?Q?7Ow+YxALf1a2wPy88O2EhT8MO0+CpUWkex5skGeQbFCDM7J00v1GRoduulC0?=
 =?us-ascii?Q?pOgkPOj79+FAI5Om4VEoqLK9Jsf1GXppaed+ki7FzSxAKiiGtNjmp2vSzyn6?=
 =?us-ascii?Q?U/LRgZ1tbt/nCAZ/HWiQ5YKn2X0zMFvbgvQqewFRPBalGqCkLyBSrKIknm85?=
 =?us-ascii?Q?jKyCogOFsQjfqGAbHrBH6q9CUI1ig2qJLgJLdO7MUB8ER/RbGw+Z1YeK65Hp?=
 =?us-ascii?Q?MAWDqIYT5m985PAfA3kfKLu2TPl3/8qkYz1Bv/6y0H44qPVVaiTBYaY9HR6m?=
 =?us-ascii?Q?GudHFf9aTDJDwFjMGCgxppE4MRCaFHh3XQjdG2EfoUbIz44HZJVONnsj9e94?=
 =?us-ascii?Q?YMawfXzw3tvj2NdYJHkDZtL6l+rtflrx26jI7Tyctg7J89tZ7ZUYSzHhQS7I?=
 =?us-ascii?Q?W3gHELocLuE2uctVMP3WlYB5v2auSyqFUZG7WNEp/UvJCcPJ6qjVSuJP0SAq?=
 =?us-ascii?Q?sh7CIlcWVgR8NxqNgF0IkfMHSZqtzrFLa18tVH6zBy4AGoXGHkptAZ4SXcWM?=
 =?us-ascii?Q?fsCrHUAe5J8iqgN/6SVhcED/99YY07mtJyMppykpxLdO/Q9ngWPrxzILQgg9?=
 =?us-ascii?Q?nl6QOIgfhqtopu4TAqtXvcWvkt2NuYIDEHIBUXLJnzkHT1lTBs7N4s6l4HPf?=
 =?us-ascii?Q?jnQmdesxyToquwQ4OBB7nl4IHCFLif/EwRpHIP9gchYaoQ0nvTcMuowM+/z8?=
 =?us-ascii?Q?5qcqPVqhY9NYf9wpZkpA6uoRThYmpG5IB92EKAc4z568oqdsKiBIhGhNN/0x?=
 =?us-ascii?Q?xkStPetAljr19C6mIMM33Cv4uyUVSwL/5JWmvbR8MtB3T+Gna3owBzl00HKZ?=
 =?us-ascii?Q?xpFtrSznjZtmVO6Q9PZr6oWrzsUCvSMomojrmK7cfTijftqIIc4t/khfntTH?=
 =?us-ascii?Q?pOROCQfAUQeRL8FRMNcphfy0R/ogclLr1cgZgPSdpkbcc2q8R+wTzIOhyUtI?=
 =?us-ascii?Q?wQ00ePMl7zBg2ipkXSNEbWNo+q5ARHlULP+C5GQWZsxq4HbLZW8Axin5IGFy?=
 =?us-ascii?Q?VFp3sabOJCJkDKbjqywiV4NjS/M=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42861876-bf13-4b17-3026-08d9a8c9ad84
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 06:24:00.4718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YzEngnG685c0UQ0ELgWvmr26ynO5DfXqX0ZAHRQc+RoEnO/9seVHj5WtpPKqtAPU4Y2vVAkvxcJiG+Iet1SEYpJS/a+YtNuMpyoYDU/+DNo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1501
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Utilize the Felix and Ocelot drivers to allow control of the VSC7511,
VSC7512, VSC7513 and VSC7514 chips from an external CPU over SPI.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/Kconfig              |  15 +
 drivers/net/dsa/ocelot/Makefile             |   6 +
 drivers/net/dsa/ocelot/ocelot_vsc7512_spi.c | 946 ++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot.c          |   8 +
 include/soc/mscc/ocelot.h                   |  26 +
 include/soc/mscc/vsc7514_regs.h             |  16 +-
 6 files changed, 1009 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/dsa/ocelot/ocelot_vsc7512_spi.c

diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index 220b0b027b55..43982909b6bf 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -15,6 +15,21 @@ config NET_DSA_MSCC_FELIX
 	  This driver supports the VSC9959 (Felix) switch, which is embedded as
 	  a PCIe function of the NXP LS1028A ENETC RCiEP.
 
+config NET_DSA_MSCC_OCELOT_SPI
+	tristate "Ocelot Ethernet SPI switch support"
+	depends on NET_DSA && SPI
+	depends on NET_VENDOR_MICROSEMI
+	select MDIO_MSCC_MIIM
+	select PINCTRL_MICROCHIP_SGPIO
+	select PINCTRL_OCELOT
+	select MSCC_OCELOT_SWITCH_LIB
+	select NET_DSA_TAG_OCELOT_8021Q
+	select NET_DSA_TAG_OCELOT
+	help
+	  This driver supports the VSC7511, VSC7512, VSC7513 and VSC7514 chips
+	  when controlled through SPI. It can be used with the Microsemi dev
+	  boards and an external CPU or custom hardware.
+
 config NET_DSA_MSCC_SEVILLE
 	tristate "Ocelot / Seville Ethernet switch support"
 	depends on NET_DSA
diff --git a/drivers/net/dsa/ocelot/Makefile b/drivers/net/dsa/ocelot/Makefile
index 34b9b128efb8..6ccd5482de7b 100644
--- a/drivers/net/dsa/ocelot/Makefile
+++ b/drivers/net/dsa/ocelot/Makefile
@@ -1,11 +1,17 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_NET_DSA_MSCC_FELIX) += mscc_felix.o
+obj-$(CONFIG_NET_DSA_MSCC_OCELOT_SPI) += mscc_ocelot_spi.o
 obj-$(CONFIG_NET_DSA_MSCC_SEVILLE) += mscc_seville.o
 
 mscc_felix-objs := \
 	felix.o \
 	felix_vsc9959.o
 
+mscc_ocelot_spi-objs := \
+	felix.o \
+	felix_mdio.o \
+	ocelot_vsc7512_spi.o
+
 mscc_seville-objs := \
 	felix.o \
 	felix_mdio.o \
diff --git a/drivers/net/dsa/ocelot/ocelot_vsc7512_spi.c b/drivers/net/dsa/ocelot/ocelot_vsc7512_spi.c
new file mode 100644
index 000000000000..c4a6f4b7a717
--- /dev/null
+++ b/drivers/net/dsa/ocelot/ocelot_vsc7512_spi.c
@@ -0,0 +1,946 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/* Copyright 2017 Microsemi Corporation
+ * Copyright 2018-2019 NXP Semiconductors
+ * Copyright 2021 Innovative Advantage Inc.
+ */
+
+#include <asm/byteorder.h>
+#include <linux/spi/spi.h>
+#include <linux/iopoll.h>
+#include <linux/kconfig.h>
+#include <linux/mdio.h>
+#include <linux/phylink.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/regmap.h>
+#include <soc/mscc/ocelot_ana.h>
+#include <soc/mscc/ocelot_dev.h>
+#include <soc/mscc/ocelot_qsys.h>
+#include <soc/mscc/ocelot_vcap.h>
+#include <soc/mscc/ocelot_ptp.h>
+#include <soc/mscc/ocelot_sys.h>
+#include <soc/mscc/ocelot.h>
+#include <soc/mscc/vsc7514_regs.h>
+#include "felix.h"
+#include "felix_mdio.h"
+
+struct ocelot_spi_data {
+	int spi_padding_bytes;
+	struct felix felix;
+	struct spi_device *spi;
+};
+
+static const u32 vsc7512_dev_cpuorg_regmap[] = {
+	REG(DEV_CPUORG_IF_CTRL,			0x0000),
+	REG(DEV_CPUORG_IF_CFGSTAT,		0x0004),
+	REG(DEV_CPUORG_ORG_CFG,			0x0008),
+	REG(DEV_CPUORG_ERR_CNTS,		0x000c),
+	REG(DEV_CPUORG_TIMEOUT_CFG,		0x0010),
+	REG(DEV_CPUORG_GPR,			0x0014),
+	REG(DEV_CPUORG_MAILBOX_SET,		0x0018),
+	REG(DEV_CPUORG_MAILBOX_CLR,		0x001c),
+	REG(DEV_CPUORG_MAILBOX,			0x0020),
+	REG(DEV_CPUORG_SEMA_CFG,		0x0024),
+	REG(DEV_CPUORG_SEMA0,			0x0028),
+	REG(DEV_CPUORG_SEMA0_OWNER,		0x002c),
+	REG(DEV_CPUORG_SEMA1,			0x0030),
+	REG(DEV_CPUORG_SEMA1_OWNER,		0x0034),
+};
+
+static const u32 vsc7512_gcb_regmap[] = {
+	REG(GCB_SOFT_RST,			0x0008),
+	REG(GCB_GPIO_GPIO_OUT_SET,		0x0034),
+	REG(GCB_GPIO_GPIO_OUT_CLR,		0x0038),
+	REG(GCB_GPIO_GPIO_OUT,			0x003c),
+	REG(GCB_GPIO_GPIO_IN,			0x0040),
+	REG(GCB_GPIO_GPIO_OE,			0x0044),
+	REG(GCB_GPIO_GPIO_ALT,			0x0054),
+	REG(GCB_MIIM_MII_STATUS,		0x009c),
+	REG(GCB_MIIM_MII_CMD,			0x00a4),
+	REG(GCB_MIIM_MII_DATA,			0x00a8),
+	REG(GCB_PHY_PHY_CFG,			0x00f0),
+	REG(GCB_PHY_PHY_STAT,			0x00f4),
+	REG(GCB_SIO_CTRL_SIO_INPUT_DATA,	0x00f8),
+};
+
+static const u32 *vsc7512_regmap[TARGET_MAX] = {
+	[ANA] = vsc7514_ana_regmap,
+	[QS] = vsc7514_qs_regmap,
+	[QSYS] = vsc7514_qsys_regmap,
+	[REW] = vsc7514_rew_regmap,
+	[SYS] = vsc7514_sys_regmap,
+	[S0] = vsc7514_vcap_regmap,
+	[S1] = vsc7514_vcap_regmap,
+	[S2] = vsc7514_vcap_regmap,
+	[PTP] = vsc7514_ptp_regmap,
+	[GCB] = vsc7512_gcb_regmap,
+	[DEV_GMII] = vsc7514_dev_gmii_regmap,
+	[DEV_CPUORG] = vsc7512_dev_cpuorg_regmap,
+};
+
+#define VSC7512_BYTE_ORDER_LE 0x00000000
+#define VSC7512_BYTE_ORDER_BE 0x81818181
+#define VSC7512_BIT_ORDER_MSB 0x00000000
+#define VSC7512_BIT_ORDER_LSB 0x42424242
+
+static void ocelot_spi_reset_phys(struct ocelot *ocelot)
+{
+	ocelot_write(ocelot, 0, GCB_PHY_PHY_CFG);
+	ocelot_write(ocelot, 0x1ff, GCB_PHY_PHY_CFG);
+	mdelay(500);
+}
+
+static struct ocelot_spi_data *felix_to_ocelot_spi(struct felix *felix)
+{
+	return container_of(felix, struct ocelot_spi_data, felix);
+}
+
+static struct ocelot_spi_data *ocelot_to_ocelot_spi(struct ocelot *ocelot)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+
+	return felix_to_ocelot_spi(felix);
+}
+
+static int ocelot_spi_init_bus(struct ocelot *ocelot)
+{
+	struct ocelot_spi_data *ocelot_spi;
+	struct spi_device *spi;
+	u32 val, check;
+
+	ocelot_spi = ocelot_to_ocelot_spi(ocelot);
+	spi = ocelot_spi->spi;
+
+	val = 0;
+
+#ifdef __LITTLE_ENDIAN
+	val |= VSC7512_BYTE_ORDER_LE;
+#else
+	val |= VSC7512_BYTE_ORDER_BE;
+#endif
+
+	ocelot_write(ocelot, val, DEV_CPUORG_IF_CTRL);
+
+	val = ocelot_spi->spi_padding_bytes;
+	ocelot_write(ocelot, val, DEV_CPUORG_IF_CFGSTAT);
+
+	check = val | 0x02000000;
+
+	val = ocelot_read(ocelot, DEV_CPUORG_IF_CFGSTAT);
+	if (check != val) {
+		dev_err(&spi->dev,
+			"Error configuring SPI bus. V: 0x%08x != 0x%08x\n", val,
+			check);
+		return -ENODEV;
+	}
+
+	/* The internal copper phys need to be enabled before the mdio bus is
+	 * scanned.
+	 */
+	ocelot_spi_reset_phys(ocelot);
+
+	return 0;
+}
+
+static int vsc7512_reset(struct ocelot *ocelot)
+{
+	int retries = 100;
+	int ret, val;
+
+	ocelot_field_write(ocelot, GCB_SOFT_RST_CHIP_RST, 1);
+
+	/* Note: This is adapted from the PCIe reset strategy. The manual doesn't
+	 * suggest how to do a reset over SPI, and the register strategy isn't
+	 * possible.
+	 */
+	msleep(100);
+
+	ret = ocelot_spi_init_bus(ocelot);
+	if (ret)
+		return ret;
+
+	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_INIT], 1);
+	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
+
+	do {
+		msleep(1);
+		regmap_field_read(ocelot->regfields[SYS_RESET_CFG_MEM_INIT],
+				  &val);
+	} while (val && --retries);
+
+	if (!retries)
+		return -ETIMEDOUT;
+
+	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
+
+	return 0;
+}
+
+static u32 ocelot_offset_from_reg_base(struct ocelot *ocelot, u32 target,
+				       u32 reg)
+{
+	return ocelot->map[target][reg & REG_MASK];
+}
+
+static void ocelot_spi_register_pinctrl(struct ocelot *ocelot)
+{
+	struct device_node *pinctrl_node;
+	struct device *dev = ocelot->dev;
+	struct regmap *regmap;
+	u32 pinctrl_offset;
+	int err;
+
+	pinctrl_node = of_get_child_by_name(dev->of_node, "pinctrl");
+	if (!pinctrl_node)
+		return;
+
+	regmap = ocelot->targets[GCB];
+	pinctrl_offset = ocelot_offset_from_reg_base(ocelot, GCB,
+						     GCB_GPIO_GPIO_OUT_SET);
+
+	err = ocelot_pinctrl_core_probe(dev, NULL, regmap, pinctrl_offset, NULL,
+					0, pinctrl_node);
+	if (err) {
+		dev_info(dev, "error setting up pinctrl device\n");
+		return;
+	}
+}
+
+static int vsc7512_spi_bus_init(struct ocelot *ocelot)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct device *dev = ocelot->dev;
+	struct device_node *mdio_node;
+	int rval;
+
+	rval = ocelot_spi_init_bus(ocelot);
+	if (rval) {
+		dev_err(ocelot->dev, "error initializing SPI bus\n");
+		goto clear_mdio;
+	}
+
+	/* Set up the pins before probing the MDIO bus */
+	ocelot_spi_register_pinctrl(ocelot);
+
+	mdio_node = of_get_child_by_name(dev->of_node, "mdio");
+	if (!mdio_node)
+		dev_info(ocelot->dev,
+			 "mdio children not found in device tree\n");
+
+	rval = felix_of_mdio_register(ocelot, mdio_node);
+	if (rval)
+		dev_err(ocelot->dev, "error registering MDIO bus\n");
+
+	felix->ds->slave_mii_bus = felix->imdio;
+
+	return rval;
+
+clear_mdio:
+	felix->imdio = NULL;
+	return rval;
+}
+
+static const struct ocelot_ops vsc7512_ops = {
+	.bus_init	= vsc7512_spi_bus_init,
+	.reset		= vsc7512_reset,
+	.wm_enc		= ocelot_wm_enc,
+	.wm_dec		= ocelot_wm_dec,
+	.wm_stat	= ocelot_wm_stat,
+	.port_to_netdev	= felix_port_to_netdev,
+	.netdev_to_port	= felix_netdev_to_port,
+};
+
+/* Addresses are relative to the SPI device's base address, downshifted by 2*/
+static const struct resource vsc7512_target_io_res[TARGET_MAX] = {
+	[ANA] = {
+		.start	= 0x71880000,
+		.end	= 0x7188ffff,
+		.name	= "ana",
+	},
+	[QS] = {
+		.start	= 0x71080000,
+		.end	= 0x710800ff,
+		.name	= "qs",
+	},
+	[QSYS] = {
+		.start	= 0x71800000,
+		.end	= 0x719fffff,
+		.name	= "qsys",
+	},
+	[REW] = {
+		.start	= 0x71030000,
+		.end	= 0x7103ffff,
+		.name	= "rew",
+	},
+	[SYS] = {
+		.start	= 0x71010000,
+		.end	= 0x7101ffff,
+		.name	= "sys",
+	},
+	[S0] = {
+		.start	= 0x71040000,
+		.end	= 0x710403ff,
+		.name	= "s0",
+	},
+	[S1] = {
+		.start	= 0x71050000,
+		.end	= 0x710503ff,
+		.name	= "s1",
+	},
+	[S2] = {
+		.start	= 0x71060000,
+		.end	= 0x710603ff,
+		.name	= "s2",
+	},
+	[GCB] =	{
+		.start	= 0x71070000,
+		.end	= 0x7107022b,
+		.name	= "devcpu_gcb",
+	},
+	[DEV_CPUORG] = {
+		.start	= 0x71000000,
+		.end	= 0x710003ff,
+		.name	= "devcpu_org",
+	},
+};
+
+static const struct resource vsc7512_port_io_res[] = {
+	{
+		.start	= 0x711e0000,
+		.end	= 0x711effff,
+		.name	= "port0",
+	},
+	{
+		.start	= 0x711f0000,
+		.end	= 0x711fffff,
+		.name	= "port1",
+	},
+	{
+		.start	= 0x71200000,
+		.end	= 0x7120ffff,
+		.name	= "port2",
+	},
+	{
+		.start	= 0x71210000,
+		.end	= 0x7121ffff,
+		.name	= "port3",
+	},
+	{
+		.start	= 0x71220000,
+		.end	= 0x7122ffff,
+		.name	= "port4",
+	},
+	{
+		.start	= 0x71230000,
+		.end	= 0x7123ffff,
+		.name	= "port5",
+	},
+	{
+		.start	= 0x71240000,
+		.end	= 0x7124ffff,
+		.name	= "port6",
+	},
+	{
+		.start	= 0x71250000,
+		.end	= 0x7125ffff,
+		.name	= "port7",
+	},
+	{
+		.start	= 0x71260000,
+		.end	= 0x7126ffff,
+		.name	= "port8",
+	},
+	{
+		.start	= 0x71270000,
+		.end	= 0x7127ffff,
+		.name	= "port9",
+	},
+	{
+		.start	= 0x71280000,
+		.end	= 0x7128ffff,
+		.name	= "port10",
+	},
+};
+
+static const struct reg_field vsc7512_regfields[REGFIELD_MAX] = {
+	[ANA_ADVLEARN_VLAN_CHK] = REG_FIELD(ANA_ADVLEARN, 11, 11),
+	[ANA_ADVLEARN_LEARN_MIRROR] = REG_FIELD(ANA_ADVLEARN, 0, 10),
+	[ANA_ANEVENTS_MSTI_DROP] = REG_FIELD(ANA_ANEVENTS, 27, 27),
+	[ANA_ANEVENTS_ACLKILL] = REG_FIELD(ANA_ANEVENTS, 26, 26),
+	[ANA_ANEVENTS_ACLUSED] = REG_FIELD(ANA_ANEVENTS, 25, 25),
+	[ANA_ANEVENTS_AUTOAGE] = REG_FIELD(ANA_ANEVENTS, 24, 24),
+	[ANA_ANEVENTS_VS2TTL1] = REG_FIELD(ANA_ANEVENTS, 23, 23),
+	[ANA_ANEVENTS_STORM_DROP] = REG_FIELD(ANA_ANEVENTS, 22, 22),
+	[ANA_ANEVENTS_LEARN_DROP] = REG_FIELD(ANA_ANEVENTS, 21, 21),
+	[ANA_ANEVENTS_AGED_ENTRY] = REG_FIELD(ANA_ANEVENTS, 20, 20),
+	[ANA_ANEVENTS_CPU_LEARN_FAILED] = REG_FIELD(ANA_ANEVENTS, 19, 19),
+	[ANA_ANEVENTS_AUTO_LEARN_FAILED] = REG_FIELD(ANA_ANEVENTS, 18, 18),
+	[ANA_ANEVENTS_LEARN_REMOVE] = REG_FIELD(ANA_ANEVENTS, 17, 17),
+	[ANA_ANEVENTS_AUTO_LEARNED] = REG_FIELD(ANA_ANEVENTS, 16, 16),
+	[ANA_ANEVENTS_AUTO_MOVED] = REG_FIELD(ANA_ANEVENTS, 15, 15),
+	[ANA_ANEVENTS_DROPPED] = REG_FIELD(ANA_ANEVENTS, 14, 14),
+	[ANA_ANEVENTS_CLASSIFIED_DROP] = REG_FIELD(ANA_ANEVENTS, 13, 13),
+	[ANA_ANEVENTS_CLASSIFIED_COPY] = REG_FIELD(ANA_ANEVENTS, 12, 12),
+	[ANA_ANEVENTS_VLAN_DISCARD] = REG_FIELD(ANA_ANEVENTS, 11, 11),
+	[ANA_ANEVENTS_FWD_DISCARD] = REG_FIELD(ANA_ANEVENTS, 10, 10),
+	[ANA_ANEVENTS_MULTICAST_FLOOD] = REG_FIELD(ANA_ANEVENTS, 9, 9),
+	[ANA_ANEVENTS_UNICAST_FLOOD] = REG_FIELD(ANA_ANEVENTS, 8, 8),
+	[ANA_ANEVENTS_DEST_KNOWN] = REG_FIELD(ANA_ANEVENTS, 7, 7),
+	[ANA_ANEVENTS_BUCKET3_MATCH] = REG_FIELD(ANA_ANEVENTS, 6, 6),
+	[ANA_ANEVENTS_BUCKET2_MATCH] = REG_FIELD(ANA_ANEVENTS, 5, 5),
+	[ANA_ANEVENTS_BUCKET1_MATCH] = REG_FIELD(ANA_ANEVENTS, 4, 4),
+	[ANA_ANEVENTS_BUCKET0_MATCH] = REG_FIELD(ANA_ANEVENTS, 3, 3),
+	[ANA_ANEVENTS_CPU_OPERATION] = REG_FIELD(ANA_ANEVENTS, 2, 2),
+	[ANA_ANEVENTS_DMAC_LOOKUP] = REG_FIELD(ANA_ANEVENTS, 1, 1),
+	[ANA_ANEVENTS_SMAC_LOOKUP] = REG_FIELD(ANA_ANEVENTS, 0, 0),
+	[ANA_TABLES_MACACCESS_B_DOM] = REG_FIELD(ANA_TABLES_MACACCESS, 18, 18),
+	[ANA_TABLES_MACTINDX_BUCKET] = REG_FIELD(ANA_TABLES_MACTINDX, 10, 11),
+	[ANA_TABLES_MACTINDX_M_INDEX] = REG_FIELD(ANA_TABLES_MACTINDX, 0, 9),
+	[GCB_SOFT_RST_SWC_RST] = REG_FIELD(GCB_SOFT_RST, 1, 1),
+	[GCB_SOFT_RST_CHIP_RST] = REG_FIELD(GCB_SOFT_RST, 0, 0),
+	[QSYS_TIMED_FRAME_ENTRY_TFRM_VLD] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 20, 20),
+	[QSYS_TIMED_FRAME_ENTRY_TFRM_FP] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 8, 19),
+	[QSYS_TIMED_FRAME_ENTRY_TFRM_PORTNO] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 4, 7),
+	[QSYS_TIMED_FRAME_ENTRY_TFRM_TM_SEL] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 1, 3),
+	[QSYS_TIMED_FRAME_ENTRY_TFRM_TM_T] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 0, 0),
+	[SYS_RESET_CFG_CORE_ENA] = REG_FIELD(SYS_RESET_CFG, 2, 2),
+	[SYS_RESET_CFG_MEM_ENA] = REG_FIELD(SYS_RESET_CFG, 1, 1),
+	[SYS_RESET_CFG_MEM_INIT] = REG_FIELD(SYS_RESET_CFG, 0, 0),
+	/* Replicated per number of ports (12), register size 4 per port */
+	[QSYS_SWITCH_PORT_MODE_PORT_ENA] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 14, 14, 12, 4),
+	[QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 11, 13, 12, 4),
+	[QSYS_SWITCH_PORT_MODE_YEL_RSRVD] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 10, 10, 12, 4),
+	[QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 9, 9, 12, 4),
+	[QSYS_SWITCH_PORT_MODE_TX_PFC_ENA] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 1, 8, 12, 4),
+	[QSYS_SWITCH_PORT_MODE_TX_PFC_MODE] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 0, 0, 12, 4),
+	[SYS_PORT_MODE_DATA_WO_TS] = REG_FIELD_ID(SYS_PORT_MODE, 5, 6, 12, 4),
+	[SYS_PORT_MODE_INCL_INJ_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 3, 4, 12, 4),
+	[SYS_PORT_MODE_INCL_XTR_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 1, 2, 12, 4),
+	[SYS_PORT_MODE_INCL_HDR_ERR] = REG_FIELD_ID(SYS_PORT_MODE, 0, 0, 12, 4),
+	[SYS_PAUSE_CFG_PAUSE_START] = REG_FIELD_ID(SYS_PAUSE_CFG, 10, 18, 12, 4),
+	[SYS_PAUSE_CFG_PAUSE_STOP] = REG_FIELD_ID(SYS_PAUSE_CFG, 1, 9, 12, 4),
+	[SYS_PAUSE_CFG_PAUSE_ENA] = REG_FIELD_ID(SYS_PAUSE_CFG, 0, 1, 12, 4),
+	[GCB_MIIM_MII_STATUS_PENDING] = REG_FIELD(GCB_MIIM_MII_STATUS, 2, 2),
+	[GCB_MIIM_MII_STATUS_BUSY] = REG_FIELD(GCB_MIIM_MII_STATUS, 3, 3),
+};
+
+static const struct ocelot_stat_layout vsc7512_stats_layout[] = {
+	{ .offset = 0x00,	.name = "rx_octets", },
+	{ .offset = 0x01,	.name = "rx_unicast", },
+	{ .offset = 0x02,	.name = "rx_multicast", },
+	{ .offset = 0x03,	.name = "rx_broadcast", },
+	{ .offset = 0x04,	.name = "rx_shorts", },
+	{ .offset = 0x05,	.name = "rx_fragments", },
+	{ .offset = 0x06,	.name = "rx_jabbers", },
+	{ .offset = 0x07,	.name = "rx_crc_align_errs", },
+	{ .offset = 0x08,	.name = "rx_sym_errs", },
+	{ .offset = 0x09,	.name = "rx_frames_below_65_octets", },
+	{ .offset = 0x0A,	.name = "rx_frames_65_to_127_octets", },
+	{ .offset = 0x0B,	.name = "rx_frames_128_to_255_octets", },
+	{ .offset = 0x0C,	.name = "rx_frames_256_to_511_octets", },
+	{ .offset = 0x0D,	.name = "rx_frames_512_to_1023_octets", },
+	{ .offset = 0x0E,	.name = "rx_frames_1024_to_1526_octets", },
+	{ .offset = 0x0F,	.name = "rx_frames_over_1526_octets", },
+	{ .offset = 0x10,	.name = "rx_pause", },
+	{ .offset = 0x11,	.name = "rx_control", },
+	{ .offset = 0x12,	.name = "rx_longs", },
+	{ .offset = 0x13,	.name = "rx_classified_drops", },
+	{ .offset = 0x14,	.name = "rx_red_prio_0", },
+	{ .offset = 0x15,	.name = "rx_red_prio_1", },
+	{ .offset = 0x16,	.name = "rx_red_prio_2", },
+	{ .offset = 0x17,	.name = "rx_red_prio_3", },
+	{ .offset = 0x18,	.name = "rx_red_prio_4", },
+	{ .offset = 0x19,	.name = "rx_red_prio_5", },
+	{ .offset = 0x1A,	.name = "rx_red_prio_6", },
+	{ .offset = 0x1B,	.name = "rx_red_prio_7", },
+	{ .offset = 0x1C,	.name = "rx_yellow_prio_0", },
+	{ .offset = 0x1D,	.name = "rx_yellow_prio_1", },
+	{ .offset = 0x1E,	.name = "rx_yellow_prio_2", },
+	{ .offset = 0x1F,	.name = "rx_yellow_prio_3", },
+	{ .offset = 0x20,	.name = "rx_yellow_prio_4", },
+	{ .offset = 0x21,	.name = "rx_yellow_prio_5", },
+	{ .offset = 0x22,	.name = "rx_yellow_prio_6", },
+	{ .offset = 0x23,	.name = "rx_yellow_prio_7", },
+	{ .offset = 0x24,	.name = "rx_green_prio_0", },
+	{ .offset = 0x25,	.name = "rx_green_prio_1", },
+	{ .offset = 0x26,	.name = "rx_green_prio_2", },
+	{ .offset = 0x27,	.name = "rx_green_prio_3", },
+	{ .offset = 0x28,	.name = "rx_green_prio_4", },
+	{ .offset = 0x29,	.name = "rx_green_prio_5", },
+	{ .offset = 0x2A,	.name = "rx_green_prio_6", },
+	{ .offset = 0x2B,	.name = "rx_green_prio_7", },
+	{ .offset = 0x40,	.name = "tx_octets", },
+	{ .offset = 0x41,	.name = "tx_unicast", },
+	{ .offset = 0x42,	.name = "tx_multicast", },
+	{ .offset = 0x43,	.name = "tx_broadcast", },
+	{ .offset = 0x44,	.name = "tx_collision", },
+	{ .offset = 0x45,	.name = "tx_drops", },
+	{ .offset = 0x46,	.name = "tx_pause", },
+	{ .offset = 0x47,	.name = "tx_frames_below_65_octets", },
+	{ .offset = 0x48,	.name = "tx_frames_65_to_127_octets", },
+	{ .offset = 0x49,	.name = "tx_frames_128_255_octets", },
+	{ .offset = 0x4A,	.name = "tx_frames_256_511_octets", },
+	{ .offset = 0x4B,	.name = "tx_frames_512_1023_octets", },
+	{ .offset = 0x4C,	.name = "tx_frames_1024_1526_octets", },
+	{ .offset = 0x4D,	.name = "tx_frames_over_1526_octets", },
+	{ .offset = 0x4E,	.name = "tx_yellow_prio_0", },
+	{ .offset = 0x4F,	.name = "tx_yellow_prio_1", },
+	{ .offset = 0x50,	.name = "tx_yellow_prio_2", },
+	{ .offset = 0x51,	.name = "tx_yellow_prio_3", },
+	{ .offset = 0x52,	.name = "tx_yellow_prio_4", },
+	{ .offset = 0x53,	.name = "tx_yellow_prio_5", },
+	{ .offset = 0x54,	.name = "tx_yellow_prio_6", },
+	{ .offset = 0x55,	.name = "tx_yellow_prio_7", },
+	{ .offset = 0x56,	.name = "tx_green_prio_0", },
+	{ .offset = 0x57,	.name = "tx_green_prio_1", },
+	{ .offset = 0x58,	.name = "tx_green_prio_2", },
+	{ .offset = 0x59,	.name = "tx_green_prio_3", },
+	{ .offset = 0x5A,	.name = "tx_green_prio_4", },
+	{ .offset = 0x5B,	.name = "tx_green_prio_5", },
+	{ .offset = 0x5C,	.name = "tx_green_prio_6", },
+	{ .offset = 0x5D,	.name = "tx_green_prio_7", },
+	{ .offset = 0x5E,	.name = "tx_aged", },
+	{ .offset = 0x80,	.name = "drop_local", },
+	{ .offset = 0x81,	.name = "drop_tail", },
+	{ .offset = 0x82,	.name = "drop_yellow_prio_0", },
+	{ .offset = 0x83,	.name = "drop_yellow_prio_1", },
+	{ .offset = 0x84,	.name = "drop_yellow_prio_2", },
+	{ .offset = 0x85,	.name = "drop_yellow_prio_3", },
+	{ .offset = 0x86,	.name = "drop_yellow_prio_4", },
+	{ .offset = 0x87,	.name = "drop_yellow_prio_5", },
+	{ .offset = 0x88,	.name = "drop_yellow_prio_6", },
+	{ .offset = 0x89,	.name = "drop_yellow_prio_7", },
+	{ .offset = 0x8A,	.name = "drop_green_prio_0", },
+	{ .offset = 0x8B,	.name = "drop_green_prio_1", },
+	{ .offset = 0x8C,	.name = "drop_green_prio_2", },
+	{ .offset = 0x8D,	.name = "drop_green_prio_3", },
+	{ .offset = 0x8E,	.name = "drop_green_prio_4", },
+	{ .offset = 0x8F,	.name = "drop_green_prio_5", },
+	{ .offset = 0x90,	.name = "drop_green_prio_6", },
+	{ .offset = 0x91,	.name = "drop_green_prio_7", },
+};
+
+static unsigned int ocelot_spi_translate_address(unsigned int reg)
+{
+	return cpu_to_be32((reg & 0xffffff) >> 2);
+}
+
+struct ocelot_spi_regmap_context {
+	struct spi_device *spi;
+	u32 base;
+};
+
+static int ocelot_spi_reg_read(void *context, unsigned int reg,
+			       unsigned int *val)
+{
+	struct ocelot_spi_regmap_context *regmap_context = context;
+	struct spi_transfer tx, padding, rx;
+	struct ocelot_spi_data *ocelot_spi;
+	struct spi_message msg;
+	struct spi_device *spi;
+	unsigned int addr;
+	u8 *tx_buf;
+
+	WARN_ON(!val);
+
+	spi = regmap_context->spi;
+
+	ocelot_spi = spi_get_drvdata(spi);
+
+	addr = ocelot_spi_translate_address(reg + regmap_context->base);
+	tx_buf = (u8 *)&addr;
+
+	spi_message_init(&msg);
+
+	memset(&tx, 0, sizeof(struct spi_transfer));
+
+	/* Ignore the first byte for the 24-bit address */
+	tx.tx_buf = &tx_buf[1];
+	tx.len = 3;
+
+	spi_message_add_tail(&tx, &msg);
+
+	if (ocelot_spi->spi_padding_bytes > 0) {
+		u8 dummy_buf[16] = {0};
+
+		memset(&padding, 0, sizeof(struct spi_transfer));
+
+		/* Just toggle the clock for padding bytes */
+		padding.len = ocelot_spi->spi_padding_bytes;
+		padding.tx_buf = dummy_buf;
+		padding.dummy_data = 1;
+
+		spi_message_add_tail(&padding, &msg);
+	}
+
+	memset(&rx, 0, sizeof(struct spi_transfer));
+	rx.rx_buf = val;
+	rx.len = 4;
+
+	spi_message_add_tail(&rx, &msg);
+
+	return spi_sync(spi, &msg);
+}
+
+static int ocelot_spi_reg_write(void *context, unsigned int reg,
+				unsigned int val)
+{
+	struct ocelot_spi_regmap_context *regmap_context = context;
+	struct spi_transfer tx[2] = {0};
+	struct spi_message msg;
+	struct spi_device *spi;
+	unsigned int addr;
+	u8 *tx_buf;
+
+	spi = regmap_context->spi;
+
+	addr = ocelot_spi_translate_address(reg + regmap_context->base);
+	tx_buf = (u8 *)&addr;
+
+	spi_message_init(&msg);
+
+	/* Ignore the first byte for the 24-bit address and set the write bit */
+	tx_buf[1] |= BIT(7);
+	tx[0].tx_buf = &tx_buf[1];
+	tx[0].len = 3;
+
+	spi_message_add_tail(&tx[0], &msg);
+
+	memset(&tx[1], 0, sizeof(struct spi_transfer));
+	tx[1].tx_buf = &val;
+	tx[1].len = 4;
+
+	spi_message_add_tail(&tx[1], &msg);
+
+	return spi_sync(spi, &msg);
+}
+
+static const struct regmap_config ocelot_spi_regmap_config = {
+	.reg_bits = 24,
+	.reg_stride = 4,
+	.val_bits = 32,
+
+	.reg_read = ocelot_spi_reg_read,
+	.reg_write = ocelot_spi_reg_write,
+
+	.max_register = 0xffffffff,
+	.use_single_write = true,
+	.use_single_read = true,
+	.can_multi_write = false,
+
+	.reg_format_endian = REGMAP_ENDIAN_BIG,
+	.val_format_endian = REGMAP_ENDIAN_NATIVE,
+};
+
+static void vsc7512_phylink_validate(struct ocelot *ocelot, int port,
+				     unsigned long *supported,
+				     struct phylink_link_state *state)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+
+	if (state->interface != PHY_INTERFACE_MODE_NA &&
+	    state->interface != ocelot_port->phy_mode) {
+		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		return;
+	}
+
+	phylink_set_port_modes(mask);
+
+	phylink_set(mask, Pause);
+	phylink_set(mask, Autoneg);
+	phylink_set(mask, Asym_Pause);
+	phylink_set(mask, 10baseT_Half);
+	phylink_set(mask, 10baseT_Full);
+	phylink_set(mask, 100baseT_Half);
+	phylink_set(mask, 100baseT_Full);
+	phylink_set(mask, 1000baseT_Half);
+	phylink_set(mask, 1000baseT_Full);
+
+	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
+	bitmap_and(state->advertising, state->advertising, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+
+static int vsc7512_prevalidate_phy_mode(struct ocelot *ocelot, int port,
+					phy_interface_t phy_mode)
+{
+	switch (phy_mode) {
+	case PHY_INTERFACE_MODE_INTERNAL:
+		if (port < 4)
+			return 0;
+		return -EOPNOTSUPP;
+	case PHY_INTERFACE_MODE_SGMII:
+		if (port < 8)
+			return 0;
+		return -EOPNOTSUPP;
+	case PHY_INTERFACE_MODE_QSGMII:
+		if (port == 7 || port == 8 || port == 10)
+			return 0;
+		return -EOPNOTSUPP;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int vsc7512_port_setup_tc(struct dsa_switch *ds, int port,
+				 enum tc_setup_type type, void *type_data)
+{
+	return -EOPNOTSUPP;
+}
+
+static struct vcap_props vsc7512_vcap_props[] = {
+	[VCAP_ES0] = {
+		.action_type_width = 0,
+		.action_table = {
+			[ES0_ACTION_TYPE_NORMAL] = {
+				.width = 73,
+				.count = 1,
+			},
+		},
+		.target = S0,
+		.keys = vsc7514_vcap_es0_keys,
+		.actions = vsc7514_vcap_es0_actions,
+	},
+	[VCAP_IS1] = {
+		.action_type_width = 0,
+		.action_table = {
+			[IS1_ACTION_TYPE_NORMAL] = {
+				.width = 78,
+				.count = 4,
+			},
+		},
+		.target = S1,
+		.keys = vsc7514_vcap_is1_keys,
+		.actions = vsc7514_vcap_is1_actions,
+	},
+	[VCAP_IS2] = {
+		.action_type_width = 1,
+		.action_table = {
+			[IS2_ACTION_TYPE_NORMAL] = {
+				.width = 49,
+				.count = 2,
+			},
+			[IS2_ACTION_TYPE_SMAC_SIP] = {
+				.width = 6,
+				.count = 4,
+			},
+		},
+		.target = S2,
+		.keys = vsc7514_vcap_is2_keys,
+		.actions = vsc7514_vcap_is2_actions,
+	},
+};
+
+static struct regmap *vsc7512_regmap_init(struct ocelot *ocelot,
+					  struct resource *res)
+{
+	struct ocelot_spi_regmap_context *context;
+	struct regmap_config regmap_config;
+	struct ocelot_spi_data *ocelot_spi;
+	struct regmap *regmap;
+	struct device *dev;
+	char name[32];
+
+	ocelot_spi = ocelot_to_ocelot_spi(ocelot);
+	dev = &ocelot_spi->spi->dev;
+
+	context = devm_kzalloc(dev, sizeof(struct ocelot_spi_regmap_context),
+			       GFP_KERNEL);
+
+	if (IS_ERR(context))
+		return ERR_CAST(context);
+
+	context->base = res->start;
+	context->spi = ocelot_spi->spi;
+
+	memcpy(&regmap_config, &ocelot_spi_regmap_config,
+	       sizeof(ocelot_spi_regmap_config));
+
+	/* A unique bus name is required for each regmap */
+	if (res->name)
+		snprintf(name, sizeof(name) - 1, "ocelot_spi-%s", res->name);
+	else
+		snprintf(name, sizeof(name) - 1, "ocelot_spi@0x%08x",
+			 res->start);
+
+	regmap_config.name = name;
+	regmap_config.max_register = res->end - res->start;
+
+	regmap = devm_regmap_init(dev, NULL, context, &regmap_config);
+
+	if (IS_ERR(regmap))
+		return ERR_CAST(regmap);
+
+	return regmap;
+}
+
+static unsigned long vsc7512_get_quirk_for_port(struct ocelot *ocelot,
+						int port)
+{
+	/* Currently Ocelot PCS is not functioning. When that happens, different
+	 * ports will have different quirks, which will need to be addressed
+	 * here.
+	 */
+	return 0;
+}
+
+static const struct felix_info ocelot_spi_info = {
+	.target_io_res			= vsc7512_target_io_res,
+	.port_io_res			= vsc7512_port_io_res,
+	.regfields			= vsc7512_regfields,
+	.map				= vsc7512_regmap,
+	.ops				= &vsc7512_ops,
+	.stats_layout			= vsc7512_stats_layout,
+	.num_stats			= ARRAY_SIZE(vsc7512_stats_layout),
+	.vcap				= vsc7512_vcap_props,
+	.num_mact_rows			= 1024,
+	.num_ports			= 11,
+	.num_tx_queues			= OCELOT_NUM_TC,
+	.mdio_bus_alloc			= felix_mdio_bus_alloc,
+	.mdio_bus_free			= felix_mdio_bus_free,
+	.phylink_validate		= vsc7512_phylink_validate,
+	.prevalidate_phy_mode		= vsc7512_prevalidate_phy_mode,
+	.port_setup_tc			= vsc7512_port_setup_tc,
+	.init_regmap			= vsc7512_regmap_init,
+	.get_quirk_for_port		= vsc7512_get_quirk_for_port,
+};
+
+static void ocelot_spi_register_sgpio(struct ocelot *ocelot)
+{
+	struct device *dev = ocelot->dev;
+	struct device_node *sgpio_node;
+	u32 offset;
+	int err;
+
+	sgpio_node = of_get_child_by_name(dev->of_node, "sgpio");
+	if (!sgpio_node)
+		return;
+
+	offset = ocelot_offset_from_reg_base(ocelot, GCB,
+					     GCB_SIO_CTRL_SIO_INPUT_DATA);
+	err = microchip_sgpio_core_probe(dev, sgpio_node, ocelot->targets[GCB],
+					 offset);
+
+	if (err)
+		dev_info(dev, "error setting up sgpio device\n");
+}
+
+static int ocelot_spi_probe(struct spi_device *spi)
+{
+	struct ocelot_spi_data *ocelot_spi;
+	struct dsa_switch *ds;
+	struct ocelot *ocelot;
+	struct felix *felix;
+	struct device *dev;
+	int err;
+
+	dev = &spi->dev;
+
+	ocelot_spi = devm_kzalloc(dev, sizeof(struct ocelot_spi_data),
+				  GFP_KERNEL);
+
+	if (!ocelot_spi)
+		return -ENOMEM;
+
+	if (spi->max_speed_hz <= 500000) {
+		ocelot_spi->spi_padding_bytes = 0;
+	} else {
+		/* Calculation taken from the manual for IF_CFGSTAT:IF_CFG. Err
+		 * on the side of more padding bytes, as having too few can be
+		 * difficult to detect at runtime.
+		 */
+		ocelot_spi->spi_padding_bytes = 1 +
+			(spi->max_speed_hz / 1000000 + 2) / 8;
+	}
+
+	dev_set_drvdata(dev, ocelot_spi);
+	ocelot_spi->spi = spi;
+
+	spi->bits_per_word = 8;
+
+	err = spi_setup(spi);
+	if (err < 0) {
+		dev_err(&spi->dev, "Error %d initializing SPI\n", err);
+		return err;
+	}
+
+	felix = &ocelot_spi->felix;
+
+	ocelot = &felix->ocelot;
+	ocelot->dev = dev;
+
+	ocelot->num_flooding_pgids = 1;
+
+	felix->info = &ocelot_spi_info;
+
+	ds = kzalloc(sizeof(*ds), GFP_KERNEL);
+	if (!ds) {
+		err = -ENOMEM;
+		dev_err(dev, "Failed to allocate DSA switch\n");
+		return err;
+	}
+
+	ds->dev = &spi->dev;
+	ds->num_ports = felix->info->num_ports;
+	ds->num_tx_queues = felix->info->num_tx_queues;
+
+	ds->ops = &felix_switch_ops;
+	ds->priv = ocelot;
+	felix->ds = ds;
+	felix->tag_proto = DSA_TAG_PROTO_OCELOT;
+
+	err = dsa_register_switch(ds);
+
+	if (err) {
+		dev_err(dev, "Failed to register DSA switch: %d\n", err);
+		goto err_register_ds;
+	}
+
+	ocelot_spi_register_sgpio(ocelot);
+
+	return 0;
+
+err_register_ds:
+	kfree(ds);
+	return err;
+}
+
+static int ocelot_spi_remove(struct spi_device *spi)
+{
+	struct ocelot_spi_data *ocelot_spi;
+	struct felix *felix;
+
+	ocelot_spi = spi_get_drvdata(spi);
+	felix = &ocelot_spi->felix;
+
+	dsa_unregister_switch(felix->ds);
+
+	kfree(felix->ds);
+
+	devm_kfree(&spi->dev, ocelot_spi);
+
+	return 0;
+}
+
+const struct of_device_id vsc7512_of_match[] = {
+	{ .compatible = "mscc,vsc7514" },
+	{ .compatible = "mscc,vsc7513" },
+	{ .compatible = "mscc,vsc7512" },
+	{ .compatible = "mscc,vsc7511" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, vsc7512_of_match);
+
+static struct spi_driver ocelot_vsc7512_spi_driver = {
+	.driver = {
+		.name = "vsc7512",
+		.of_match_table = of_match_ptr(vsc7512_of_match),
+	},
+	.probe = ocelot_spi_probe,
+	.remove = ocelot_spi_remove,
+};
+module_spi_driver(ocelot_vsc7512_spi_driver);
+
+MODULE_DESCRIPTION("Ocelot Switch SPI driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index e6c18b598d5c..5a4c046b5e20 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2243,6 +2243,14 @@ int ocelot_init(struct ocelot *ocelot)
 	int i, ret;
 	u32 port;
 
+	if (ocelot->ops->bus_init) {
+		ret = ocelot->ops->bus_init(ocelot);
+		if (ret) {
+			dev_err(ocelot->dev, "Bus init failed\n");
+			return ret;
+		}
+	}
+
 	if (ocelot->ops->reset) {
 		ret = ocelot->ops->reset(ocelot);
 		if (ret) {
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 8c27f8f79fff..6aeb7eac73f5 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -121,6 +121,7 @@ enum ocelot_target {
 	PTP,
 	GCB,
 	DEV_GMII,
+	DEV_CPUORG,
 	TARGET_MAX,
 };
 
@@ -396,9 +397,18 @@ enum ocelot_reg {
 	PTP_CLK_CFG_ADJ_CFG,
 	PTP_CLK_CFG_ADJ_FREQ,
 	GCB_SOFT_RST = GCB << TARGET_OFFSET,
+	GCB_GPIO_GPIO_OUT_SET,
+	GCB_GPIO_GPIO_OUT_CLR,
+	GCB_GPIO_GPIO_OUT,
+	GCB_GPIO_GPIO_IN,
+	GCB_GPIO_GPIO_OE,
+	GCB_GPIO_GPIO_ALT,
 	GCB_MIIM_MII_STATUS,
 	GCB_MIIM_MII_CMD,
 	GCB_MIIM_MII_DATA,
+	GCB_PHY_PHY_CFG,
+	GCB_PHY_PHY_STAT,
+	GCB_SIO_CTRL_SIO_INPUT_DATA,
 	DEV_CLOCK_CFG = DEV_GMII << TARGET_OFFSET,
 	DEV_PORT_MISC,
 	DEV_EVENTS,
@@ -438,6 +448,20 @@ enum ocelot_reg {
 	PCS1G_TSTPAT_STATUS,
 	DEV_PCS_FX100_CFG,
 	DEV_PCS_FX100_STATUS,
+	DEV_CPUORG_IF_CTRL = DEV_CPUORG << TARGET_OFFSET,
+	DEV_CPUORG_IF_CFGSTAT,
+	DEV_CPUORG_ORG_CFG,
+	DEV_CPUORG_ERR_CNTS,
+	DEV_CPUORG_TIMEOUT_CFG,
+	DEV_CPUORG_GPR,
+	DEV_CPUORG_MAILBOX_SET,
+	DEV_CPUORG_MAILBOX_CLR,
+	DEV_CPUORG_MAILBOX,
+	DEV_CPUORG_SEMA_CFG,
+	DEV_CPUORG_SEMA0,
+	DEV_CPUORG_SEMA0_OWNER,
+	DEV_CPUORG_SEMA1,
+	DEV_CPUORG_SEMA1_OWNER,
 };
 
 enum ocelot_regfield {
@@ -496,6 +520,7 @@ enum ocelot_regfield {
 	SYS_RESET_CFG_MEM_ENA,
 	SYS_RESET_CFG_MEM_INIT,
 	GCB_SOFT_RST_SWC_RST,
+	GCB_SOFT_RST_CHIP_RST,
 	GCB_MIIM_MII_STATUS_PENDING,
 	GCB_MIIM_MII_STATUS_BUSY,
 	SYS_PAUSE_CFG_PAUSE_START,
@@ -552,6 +577,7 @@ struct ocelot;
 struct ocelot_ops {
 	struct net_device *(*port_to_netdev)(struct ocelot *ocelot, int port);
 	int (*netdev_to_port)(struct net_device *dev);
+	int (*bus_init)(struct ocelot *ocelot);
 	int (*reset)(struct ocelot *ocelot);
 	u16 (*wm_enc)(u16 value);
 	u16 (*wm_dec)(u16 value);
diff --git a/include/soc/mscc/vsc7514_regs.h b/include/soc/mscc/vsc7514_regs.h
index c39f64079a0f..98743e252012 100644
--- a/include/soc/mscc/vsc7514_regs.h
+++ b/include/soc/mscc/vsc7514_regs.h
@@ -8,14 +8,14 @@
 #ifndef VSC7514_REGS_H
 #define VSC7514_REGS_H
 
-extern const u32 ocelot_ana_regmap[];
-extern const u32 ocelot_qs_regmap[];
-extern const u32 ocelot_qsys_regmap[];
-extern const u32 ocelot_rew_regmap[];
-extern const u32 ocelot_sys_regmap[];
-extern const u32 ocelot_vcap_regmap[];
-extern const u32 ocelot_ptp_regmap[];
-extern const u32 ocelot_dev_gmii_regmap[];
+extern const u32 vsc7514_ana_regmap[];
+extern const u32 vsc7514_qs_regmap[];
+extern const u32 vsc7514_qsys_regmap[];
+extern const u32 vsc7514_rew_regmap[];
+extern const u32 vsc7514_sys_regmap[];
+extern const u32 vsc7514_vcap_regmap[];
+extern const u32 vsc7514_ptp_regmap[];
+extern const u32 vsc7514_dev_gmii_regmap[];
 
 extern const struct vcap_field vsc7514_vcap_es0_keys[];
 extern const struct vcap_field vsc7514_vcap_es0_actions[];
-- 
2.25.1

