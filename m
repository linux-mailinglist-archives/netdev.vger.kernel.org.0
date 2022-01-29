Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320BE4A323D
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 23:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353413AbiA2WDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 17:03:02 -0500
Received: from mail-dm3nam07on2115.outbound.protection.outlook.com ([40.107.95.115]:64192
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353314AbiA2WCr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jan 2022 17:02:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ajw8O9gUFoP+Wkkni0Xbg3sWHywZYtbjojFDmaKmwwsPF24/LMe8BpHtiW5EdWOmAj5837WxE3v5gVet8SVORGKx6+l0ZtfIxleV0qHXKCCyoPQg9+G0F5+tINJBtRKo8Ispr7Zn/6RfbVc60VAuAwxO+04+PPgr/rd5gRG5DqxzlI3IQVqiWGEliKwuBLSRC/adYFcD+4p72agLWw6WEPxn/GuL+67T8lvwaVnyAY9VTPoSubOe2+ajSR95Ln6RAa6/ZIejN9qH1R3c11nDBgCE1h8YdNWcVR0dVllazArYXkxeMMVQev61DanhfSQ4p8KkyaFs06n0aVh8YxzH8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fq0XfOFnknP4gEGy3ySIqK+4XO+EvwLbb5AQpmtz3hM=;
 b=I/3eeO7WE5rj7rqAr0YFQPhrooYfLYGWRaAqUw0SYVwDMEtFf1AUZVRK3GVfFgSH+3n76+4dukuk7HdqYJvcqEmwmKjtG6zQOMpHkmv+c/BhQubt3j58fTyeiDERRu1WMsTqr5iWQWku7VsTpVWdCEJNBHSgJ+dLN/0rI1k+c7Cejw1GW+Bm99h+BnOk+xmEMH0MW/O5MDJIitCRI55WkpDsjxRdcZHXBWB0lgWQXRR+nFLygEp0YHs6xEStOJxPCyDlDdXioR58ItfCUcMQ0TEMhZijK0X3NWhPleQP2mNQp80Bh7D7OcPDUvawsx0yFehdLpYEieD4z/wApw1xaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fq0XfOFnknP4gEGy3ySIqK+4XO+EvwLbb5AQpmtz3hM=;
 b=WMbIe9PhoKXzHd7BPdxaLwuh++EuGCCxTjxNHZyUJXJ/ldI7LNLBzWt3lPm0gMa4R/khdZZIuzEhgONfyYgkY0zegt2wbQy0Zb00+BPuKYrn2U/9FLHpR2zrNuakDJyQKM573Bzd3pR1+OlBjniyM5agsn0uk3LeID5o7379os0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BYAPR10MB2968.namprd10.prod.outlook.com
 (2603:10b6:a03:85::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Sat, 29 Jan
 2022 22:02:44 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4930.020; Sat, 29 Jan 2022
 22:02:44 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Subject: [RFC v6 net-next 6/9] mfd: ocelot: add support for external mfd control over SPI for the VSC7512
Date:   Sat, 29 Jan 2022 14:02:18 -0800
Message-Id: <20220129220221.2823127-7-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220129220221.2823127-1-colin.foster@in-advantage.com>
References: <20220129220221.2823127-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CO1PR15CA0113.namprd15.prod.outlook.com
 (2603:10b6:101:21::33) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e541ad9-892d-421d-0ed7-08d9e3731376
X-MS-TrafficTypeDiagnostic: BYAPR10MB2968:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2968F09AEDE2C9AF9BBBC602A4239@BYAPR10MB2968.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JE5l7ERB5bvLMLHs8MEYSS62CF6xyGfX0r/ago6pRrSy0i/MIDGLA3mcs9Cjb1Ay1QBa9EblOk9YKcFBtMpC1xkeQXwKCQ/WS4UJVG5k9C4v/DpzXvHZFmCbGM8ZpGTtdoXIXykosKqoGQiEQGznuORthU7B93l25pQnRV7vex8PTiPQPfY+gLsWRZM9ltKnBrwuBkqDCLIGRZf/Sequ3SQA05WqyCRIJTLntCoxLIMelokwZNt/Xc7Wyas+cfstOVUh/P6TBlkUwsRXNjmX7vXaQPrzeB8NarnSj7tcUQVAFH8LeOYikfzxxaDNptNIu/tGP02p3c/v3PyxbsWhU8FSy7qaK1KhkMiimfVL2pZ2QJuWXmPoqEOlLxT3Gll2ODmfr2d2FNstW9n4MBCP/I0ljZKdGuUayVZNaCDrxqOJRCPcDT1s6tq+bro2wjxxNZI0DScWagFx1QxhqaiGMi6Hupbtz2VBop3ObYfeLCDZZjwvKY24Qatu8ZWd0MMPwwkTPJ6IWpV/TjuoWU5TMvfMaV2fGfanqI55MDbaiouUM5aPNqladsQbS3l2yr2TSNkylo5IR+T6LP7aI+OHeHIxWUwn0JId6BL1wwnOSCp0Fij+asT/Jj8Hjx5XhRkW4p1cLRZ94kh6PkFERBUJdG8bB/ctDGFZb29a6svB0mxGUBCBW8qNlf2FCJpaZwGA5qJ8YL5rQ201o6SCGFh6Iw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(376002)(346002)(42606007)(396003)(39840400004)(366004)(186003)(508600001)(5660300002)(6486002)(1076003)(86362001)(66946007)(8676002)(66476007)(26005)(4326008)(66556008)(8936002)(7416002)(107886003)(6506007)(38350700002)(6512007)(2906002)(30864003)(44832011)(6666004)(2616005)(52116002)(38100700002)(83380400001)(316002)(36756003)(54906003)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U1xFi5JMtIRdD2tkIHIc/VrwrKgpuyEcPmEIRyUiQDt5DC2E0XCSRlu2qpP4?=
 =?us-ascii?Q?l1uB7kgyZ0tEOEFrA3ntbduecKUDjhqsKSdasOspho19gEaMsoHAg/43FrI4?=
 =?us-ascii?Q?4n73zWZqnchX5Y0vWGEYc0Bj2DkPk5aKuJukffSpfn5SJexayNAu0kZJ6GjH?=
 =?us-ascii?Q?/LjJrac/ujNi/N51URBu6r+pOeETl0wpNCGWEuFqORLw98xuVmk64btap3iE?=
 =?us-ascii?Q?5xw4xulG7QWj2b21on4r7QtMUggSUEEEBwBh5ygOYq6gUEqBc23mFv6NKqtg?=
 =?us-ascii?Q?+mfaSoYDj/lwEwUMnkCM7qPn0v6EczmE5wVapZZXJechgsAW416bHRQPBxvh?=
 =?us-ascii?Q?03tiwd1eRVRFKdHT2VKij9fJGJIf9h2L0Tbusa6MkR/0wubRfGpqJhrrFCKt?=
 =?us-ascii?Q?WI13UlmKsvY516dddkrxnoOBSWW1xt9I0279GkrfiXgz7a1DmdejknkM8SFU?=
 =?us-ascii?Q?rpyleqqssbEZq6W6WqM8hl+1j/G9SZnqT0k4Qq9lh5LuyjgM95LiNWvEQGRD?=
 =?us-ascii?Q?arVlTAu/uIvvSc8IdsD/GMa94HwcqS4rhNHQY82t6lKXMzHCAjvyMtUTSFOZ?=
 =?us-ascii?Q?/07YXpbwrItp4Dgds3De42Fa0GyR0gX9T++wLYMYmmiWGL8DkhrEoCj+a/KU?=
 =?us-ascii?Q?jxf7v2pbF5e9bO38daxmkVGYxDoALKeU1ODHaayvs2jB4be8rRWC9J1HNSvJ?=
 =?us-ascii?Q?eW6RJRObYFkQ/JeqJfaCpiGWG5lcwZQEPqoe/Oa0sxyjjam7Gf7vrc2rjBLA?=
 =?us-ascii?Q?HR/RfH6E3NsrhtxpgyFSMZ0olwT6sriy1oRcA2QwIFm3fmzlEUFINkqSQRD+?=
 =?us-ascii?Q?c34FhOmwiaeNNEOZT/4Gver2/21CUUagYsD0Vu3pDefowxgGyrjoK9QVkFx8?=
 =?us-ascii?Q?ZiHcku6uqOf7wRQIDyC4Tu1jAVeoTw42oQL8cXPEdqv3TLwwYSwxN/GX/UWN?=
 =?us-ascii?Q?AUYpE3/YC/3KT+XnbzU7fr2mWYHg6nXGm5b1RkUMmK26l+0+9p/ybDUX8WBW?=
 =?us-ascii?Q?Ql+UsBmKNrPvzw01zMHfa9hSYA00B0th2vrZL/lVlRNqJkZan3SmMChF3wx0?=
 =?us-ascii?Q?YmIwQFJQYD+jgIZxfU8/3X54CNfOdGmpQz8hDTI2r/rzzP5xhOzPlwBdDq6h?=
 =?us-ascii?Q?i82xpgzXt02LudvmgNckbmTZbdYYnicM5GBBKrbtjrIikRB18h4XG7pV5L5R?=
 =?us-ascii?Q?ycIJF0ttW0Mu6vWRsIWMoJ/xAKczEJBrUSZXr/J4k4BhxRE4L/jBc825WC7V?=
 =?us-ascii?Q?Kausah/PSyYRIixYgMBfUHfetGF2m7fcNaT6M32MmgxU7Er3pZ7/2H7YITyJ?=
 =?us-ascii?Q?Q07isJBWGx/mhUgc51MLhP9TycwI7R1Z3l+er0FGsUU1btKQw70b0TfDggUJ?=
 =?us-ascii?Q?m3MzuKEoIOrk/QyHgXTFo2bMmK41kU6vW2EuijOuiRw2yvZvtFAr9ZEjrjmS?=
 =?us-ascii?Q?5oVYdyAxS4rcVpmPqpebSRDDwg63GMgwtyTU3e9rPfEULhyH08RUCJq4blk3?=
 =?us-ascii?Q?NInjSFQ84BUMHcQCEWq8PU/FBEwMKObMFLIedszYhP5ohxUQjDibGBau1Y7H?=
 =?us-ascii?Q?V8CjKx3J7uGXpOMUXdpMK0ImRmOeu2Xr4c9CMQ4uooKqUI05kLUGONl8bnId?=
 =?us-ascii?Q?xzxca0FNCNvKWPpwkB1wx7aHQTO2L2GM1w6EPtXVIFiKzKt/kYOk8MoN+KTM?=
 =?us-ascii?Q?bJ2HYw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e541ad9-892d-421d-0ed7-08d9e3731376
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2022 22:02:43.9227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aCL3Lxqz9j2n/0y6pDlnAv9kgRnMcEtm3cUA5m0jTp4spf1uHg07nwFiLnAMGv3O6IPuFMT+ztgq/EnWy2v7d30THWx3WhIMEfVKh4l7IlM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2968
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a single SPI MFD ocelot device that manages the SPI bus on the
external chip and can handle requests for regmaps. This should allow any
ocelot driver (pinctrl, miim, etc.) to be used externally, provided they
utilize regmaps.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/mfd/Kconfig                       |  19 ++
 drivers/mfd/Makefile                      |   3 +
 drivers/mfd/ocelot-core.c                 | 165 +++++++++++
 drivers/mfd/ocelot-spi.c                  | 325 ++++++++++++++++++++++
 drivers/mfd/ocelot.h                      |  36 +++
 drivers/net/mdio/mdio-mscc-miim.c         |  21 +-
 drivers/pinctrl/pinctrl-microchip-sgpio.c |  22 +-
 drivers/pinctrl/pinctrl-ocelot.c          |  29 +-
 include/soc/mscc/ocelot.h                 |  11 +
 9 files changed, 614 insertions(+), 17 deletions(-)
 create mode 100644 drivers/mfd/ocelot-core.c
 create mode 100644 drivers/mfd/ocelot-spi.c
 create mode 100644 drivers/mfd/ocelot.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index ba0b3eb131f1..57bbf2d11324 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -948,6 +948,25 @@ config MFD_MENF21BMC
 	  This driver can also be built as a module. If so the module
 	  will be called menf21bmc.
 
+config MFD_OCELOT
+	tristate "Microsemi Ocelot External Control Support"
+	select MFD_CORE
+	help
+	  Say yes here to add support for Ocelot chips (VSC7511, VSC7512,
+	  VSC7513, VSC7514) controlled externally.
+
+	  All four of these chips can be controlled internally (MMIO) or
+	  externally via SPI, I2C, PCIe. This enables control of these chips
+	  over one or more of these buses.
+
+config MFD_OCELOT_SPI
+	tristate "Microsemi Ocelot SPI interface"
+	depends on MFD_OCELOT
+	depends on SPI_MASTER
+	select REGMAP_SPI
+	help
+	  Say yes here to add control to the MFD_OCELOT chips via SPI.
+
 config EZX_PCAP
 	bool "Motorola EZXPCAP Support"
 	depends on SPI_MASTER
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index df1ecc4a4c95..12513843067a 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -120,6 +120,9 @@ obj-$(CONFIG_MFD_MC13XXX_I2C)	+= mc13xxx-i2c.o
 
 obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
 
+obj-$(CONFIG_MFD_OCELOT)	+= ocelot-core.o
+obj-$(CONFIG_MFD_OCELOT_SPI)	+= ocelot-spi.o
+
 obj-$(CONFIG_EZX_PCAP)		+= ezx-pcap.o
 obj-$(CONFIG_MFD_CPCAP)		+= motorola-cpcap.o
 
diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
new file mode 100644
index 000000000000..590489481b8c
--- /dev/null
+++ b/drivers/mfd/ocelot-core.c
@@ -0,0 +1,165 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * MFD core driver for the Ocelot chip family.
+ *
+ * The VSC7511, 7512, 7513, and 7514 can be controlled internally via an
+ * on-chip MIPS processor, or externally via SPI, I2C, PCIe. This core driver is
+ * intended to be the bus-agnostic glue between, for example, the SPI bus and
+ * the MFD children.
+ *
+ * Copyright 2021 Innovative Advantage Inc.
+ *
+ * Author: Colin Foster <colin.foster@in-advantage.com>
+ */
+
+#include <linux/mfd/core.h>
+#include <linux/module.h>
+#include <linux/regmap.h>
+
+#include <asm/byteorder.h>
+
+#include "ocelot.h"
+
+#define GCB_SOFT_RST (0x0008)
+
+#define SOFT_CHIP_RST (0x1)
+
+static const struct resource vsc7512_gcb_resource = {
+	.start	= 0x71070000,
+	.end	= 0x7107022b,
+	.name	= "devcpu_gcb",
+};
+
+static int ocelot_reset(struct ocelot_core *core)
+{
+	int ret;
+
+	/*
+	 * Reset the entire chip here to put it into a completely known state.
+	 * Other drivers may want to reset their own subsystems. The register
+	 * self-clears, so one write is all that is needed
+	 */
+	ret = regmap_write(core->gcb_regmap, GCB_SOFT_RST, SOFT_CHIP_RST);
+	if (ret)
+		return ret;
+
+	msleep(100);
+
+	/*
+	 * A chip reset will clear the SPI configuration, so it needs to be done
+	 * again before we can access any more registers
+	 */
+	ret = ocelot_spi_initialize(core);
+
+	return ret;
+}
+
+static struct regmap *ocelot_devm_regmap_init(struct ocelot_core *core,
+					      struct device *dev,
+					      const struct resource *res)
+{
+	struct regmap *regmap;
+
+	regmap = dev_get_regmap(dev, res->name);
+	if (!regmap)
+		regmap = ocelot_spi_devm_get_regmap(core, dev, res);
+
+	return regmap;
+}
+
+struct regmap *ocelot_get_regmap_from_resource(struct device *dev,
+					       const struct resource *res)
+{
+	struct ocelot_core *core = dev_get_drvdata(dev);
+
+	return ocelot_devm_regmap_init(core, dev, res);
+}
+EXPORT_SYMBOL(ocelot_get_regmap_from_resource);
+
+static const struct resource vsc7512_miim1_resources[] = {
+	{
+		.start = 0x710700c0,
+		.end = 0x710700e3,
+		.name = "gcb_miim1",
+		.flags = IORESOURCE_MEM,
+	},
+};
+
+static const struct resource vsc7512_pinctrl_resources[] = {
+	{
+		.start = 0x71070034,
+		.end = 0x7107009f,
+		.name = "gcb_gpio",
+		.flags = IORESOURCE_MEM,
+	},
+};
+
+static const struct resource vsc7512_sgpio_resources[] = {
+	{
+		.start = 0x710700f8,
+		.end = 0x710701f7,
+		.name = "gcb_sio",
+		.flags = IORESOURCE_MEM,
+	},
+};
+
+static const struct mfd_cell vsc7512_devs[] = {
+	{
+		.name = "pinctrl-ocelot",
+		.of_compatible = "mscc,ocelot-pinctrl",
+		.num_resources = ARRAY_SIZE(vsc7512_pinctrl_resources),
+		.resources = vsc7512_pinctrl_resources,
+	},
+	{
+		.name = "pinctrl-sgpio",
+		.of_compatible = "mscc,ocelot-sgpio",
+		.num_resources = ARRAY_SIZE(vsc7512_sgpio_resources),
+		.resources = vsc7512_sgpio_resources,
+	},
+	{
+		.name = "ocelot-miim1",
+		.of_compatible = "mscc,ocelot-miim",
+		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
+		.resources = vsc7512_miim1_resources,
+	},
+};
+
+int ocelot_core_init(struct ocelot_core *core)
+{
+	struct device *dev = core->dev;
+	int ret;
+
+	dev_set_drvdata(dev, core);
+
+	core->gcb_regmap = ocelot_devm_regmap_init(core, dev,
+						   &vsc7512_gcb_resource);
+	if (!core->gcb_regmap)
+		return -ENOMEM;
+
+	/* Prepare the chip */
+	ret = ocelot_reset(core);
+	if (ret) {
+		dev_err(dev, "ocelot mfd reset failed with code %d\n", ret);
+		return ret;
+	}
+
+	ret = devm_mfd_add_devices(dev, PLATFORM_DEVID_NONE, vsc7512_devs,
+				   ARRAY_SIZE(vsc7512_devs), NULL, 0, NULL);
+	if (ret) {
+		dev_err(dev, "error adding mfd devices\n");
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_core_init);
+
+int ocelot_remove(struct ocelot_core *core)
+{
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_remove);
+
+MODULE_DESCRIPTION("Ocelot Chip MFD driver");
+MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/mfd/ocelot-spi.c b/drivers/mfd/ocelot-spi.c
new file mode 100644
index 000000000000..1e268a4dfa17
--- /dev/null
+++ b/drivers/mfd/ocelot-spi.c
@@ -0,0 +1,325 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * SPI core driver for the Ocelot chip family.
+ *
+ * This driver will handle everything necessary to allow for communication over
+ * SPI to the VSC7511, VSC7512, VSC7513 and VSC7514 chips. The main functions
+ * are to prepare the chip's SPI interface for a specific bus speed, and a host
+ * processor's endianness. This will create and distribute regmaps for any MFD
+ * children.
+ *
+ * Copyright 2021 Innovative Advantage Inc.
+ *
+ * Author: Colin Foster <colin.foster@in-advantage.com>
+ */
+
+#include <linux/iopoll.h>
+#include <linux/kconfig.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/regmap.h>
+#include <linux/spi/spi.h>
+
+#include <asm/byteorder.h>
+
+#include "ocelot.h"
+
+struct ocelot_spi {
+	int spi_padding_bytes;
+	struct spi_device *spi;
+	struct ocelot_core core;
+	struct regmap *cpuorg_regmap;
+};
+
+#define DEV_CPUORG_IF_CTRL	(0x0000)
+#define DEV_CPUORG_IF_CFGSTAT	(0x0004)
+
+static const struct resource vsc7512_dev_cpuorg_resource = {
+	.start	= 0x71000000,
+	.end	= 0x710002ff,
+	.name	= "devcpu_org",
+};
+
+#define VSC7512_BYTE_ORDER_LE 0x00000000
+#define VSC7512_BYTE_ORDER_BE 0x81818181
+#define VSC7512_BIT_ORDER_MSB 0x00000000
+#define VSC7512_BIT_ORDER_LSB 0x42424242
+
+static struct ocelot_spi *core_to_ocelot_spi(struct ocelot_core *core)
+{
+	return container_of(core, struct ocelot_spi, core);
+}
+
+static int ocelot_spi_init_bus(struct ocelot_spi *ocelot_spi)
+{
+	struct spi_device *spi;
+	struct device *dev;
+	u32 val, check;
+	int err;
+
+	spi = ocelot_spi->spi;
+	dev = &spi->dev;
+
+#ifdef __LITTLE_ENDIAN
+	val = VSC7512_BYTE_ORDER_LE;
+#else
+	val = VSC7512_BYTE_ORDER_BE;
+#endif
+
+	err = regmap_write(ocelot_spi->cpuorg_regmap, DEV_CPUORG_IF_CTRL, val);
+	if (err)
+		return err;
+
+	val = ocelot_spi->spi_padding_bytes;
+	err = regmap_write(ocelot_spi->cpuorg_regmap, DEV_CPUORG_IF_CFGSTAT,
+			   val);
+	if (err)
+		return err;
+
+	check = val | 0x02000000;
+
+	err = regmap_read(ocelot_spi->cpuorg_regmap, DEV_CPUORG_IF_CFGSTAT,
+			  &val);
+	if (err)
+		return err;
+
+	if (check != val)
+		return -ENODEV;
+
+	return 0;
+}
+
+int ocelot_spi_initialize(struct ocelot_core *core)
+{
+	struct ocelot_spi *ocelot_spi = core_to_ocelot_spi(core);
+
+	return ocelot_spi_init_bus(ocelot_spi);
+}
+EXPORT_SYMBOL(ocelot_spi_initialize);
+
+static unsigned int ocelot_spi_translate_address(unsigned int reg)
+{
+	return cpu_to_be32((reg & 0xffffff) >> 2);
+}
+
+struct ocelot_spi_regmap_context {
+	u32 base;
+	struct ocelot_spi *ocelot_spi;
+};
+
+static int ocelot_spi_reg_read(void *context, unsigned int reg,
+			       unsigned int *val)
+{
+	struct ocelot_spi_regmap_context *regmap_context = context;
+	struct ocelot_spi *ocelot_spi = regmap_context->ocelot_spi;
+	struct spi_transfer tx, padding, rx;
+	struct spi_message msg;
+	struct spi_device *spi;
+	unsigned int addr;
+	u8 *tx_buf;
+
+	WARN_ON(!val);
+
+	spi = ocelot_spi->spi;
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
+	struct ocelot_spi *ocelot_spi = regmap_context->ocelot_spi;
+	struct spi_transfer tx[2] = {0};
+	struct spi_message msg;
+	struct spi_device *spi;
+	unsigned int addr;
+	u8 *tx_buf;
+
+	spi = ocelot_spi->spi;
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
+struct regmap *
+ocelot_spi_devm_get_regmap(struct ocelot_core *core, struct device *dev,
+			   const struct resource *res)
+{
+	struct ocelot_spi *ocelot_spi = core_to_ocelot_spi(core);
+	struct ocelot_spi_regmap_context *context;
+	struct regmap_config regmap_config;
+	struct regmap *regmap;
+
+	context = devm_kzalloc(dev, sizeof(*context), GFP_KERNEL);
+	if (IS_ERR(context))
+		return ERR_CAST(context);
+
+	context->base = res->start;
+	context->ocelot_spi = ocelot_spi;
+
+	memcpy(&regmap_config, &ocelot_spi_regmap_config,
+	       sizeof(ocelot_spi_regmap_config));
+
+	regmap_config.name = res->name;
+	regmap_config.max_register = res->end - res->start;
+
+	regmap = devm_regmap_init(dev, NULL, context, &regmap_config);
+	if (IS_ERR(regmap))
+		return ERR_CAST(regmap);
+
+	return regmap;
+}
+
+static int ocelot_spi_probe(struct spi_device *spi)
+{
+	struct device *dev = &spi->dev;
+	struct ocelot_spi *ocelot_spi;
+	int err;
+
+	ocelot_spi = devm_kzalloc(dev, sizeof(*ocelot_spi), GFP_KERNEL);
+
+	if (!ocelot_spi)
+		return -ENOMEM;
+
+	if (spi->max_speed_hz <= 500000) {
+		ocelot_spi->spi_padding_bytes = 0;
+	} else {
+		/*
+		 * Calculation taken from the manual for IF_CFGSTAT:IF_CFG.
+		 * Register access time is 1us, so we need to configure and send
+		 * out enough padding bytes between the read request and data
+		 * transmission that lasts at least 1 microsecond.
+		 */
+		ocelot_spi->spi_padding_bytes = 1 +
+			(spi->max_speed_hz / 1000000 + 2) / 8;
+	}
+
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
+	ocelot_spi->cpuorg_regmap =
+		ocelot_spi_devm_get_regmap(&ocelot_spi->core, dev,
+					   &vsc7512_dev_cpuorg_resource);
+	if (!ocelot_spi->cpuorg_regmap)
+		return -ENOMEM;
+
+	ocelot_spi->core.dev = dev;
+
+	/*
+	 * The chip must be set up for SPI before it gets initialized and reset.
+	 * This must be done before calling init, and after a chip reset is
+	 * performed.
+	 */
+	err = ocelot_spi_init_bus(ocelot_spi);
+	if (err) {
+		dev_err(dev, "Error %d initializing Ocelot SPI bus\n", err);
+		return err;
+	}
+
+	err = ocelot_core_init(&ocelot_spi->core);
+	if (err < 0) {
+		dev_err(dev, "Error %d initializing Ocelot MFD\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
+static int ocelot_spi_remove(struct spi_device *spi)
+{
+	return 0;
+}
+
+const struct of_device_id ocelot_spi_of_match[] = {
+	{ .compatible = "mscc,vsc7512_mfd_spi" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, ocelot_spi_of_match);
+
+static struct spi_driver ocelot_spi_driver = {
+	.driver = {
+		.name = "ocelot_mfd_spi",
+		.of_match_table = of_match_ptr(ocelot_spi_of_match),
+	},
+	.probe = ocelot_spi_probe,
+	.remove = ocelot_spi_remove,
+};
+module_spi_driver(ocelot_spi_driver);
+
+MODULE_DESCRIPTION("Ocelot Chip MFD SPI driver");
+MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
+MODULE_LICENSE("Dual MIT/GPL");
diff --git a/drivers/mfd/ocelot.h b/drivers/mfd/ocelot.h
new file mode 100644
index 000000000000..8bb2b57002be
--- /dev/null
+++ b/drivers/mfd/ocelot.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/*
+ * Copyright 2021 Innovative Advantage Inc.
+ */
+
+#include <linux/kconfig.h>
+#include <linux/regmap.h>
+
+struct ocelot_core {
+	struct device *dev;
+	struct regmap *gcb_regmap;
+};
+
+void ocelot_get_resource_name(char *name, const struct resource *res,
+			      int size);
+int ocelot_core_init(struct ocelot_core *core);
+int ocelot_remove(struct ocelot_core *core);
+
+#if IS_ENABLED(CONFIG_MFD_OCELOT_SPI)
+struct regmap *ocelot_spi_devm_get_regmap(struct ocelot_core *core,
+					  struct device *dev,
+					  const struct resource *res);
+int ocelot_spi_initialize(struct ocelot_core *core);
+#else
+static inline struct regmap *ocelot_spi_devm_get_regmap(
+		struct ocelot_core *core, struct device *dev,
+		const struct resource *res)
+{
+	return NULL;
+}
+
+static inline int ocelot_spi_initialize(struct ocelot_core *core)
+{
+	return -EOPNOTSUPP;
+}
+#endif
diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 07baf8390744..8e54bde06fd5 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -11,11 +11,13 @@
 #include <linux/iopoll.h>
 #include <linux/kernel.h>
 #include <linux/mdio/mdio-mscc-miim.h>
+#include <linux/mfd/core.h>
 #include <linux/module.h>
 #include <linux/of_mdio.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
+#include <soc/mscc/ocelot.h>
 
 #define MSCC_MIIM_REG_STATUS		0x0
 #define		MSCC_MIIM_STATUS_STAT_PENDING	BIT(2)
@@ -230,13 +232,20 @@ static int mscc_miim_probe(struct platform_device *pdev)
 	struct mii_bus *bus;
 	int ret;
 
-	regs = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
-	if (IS_ERR(regs)) {
-		dev_err(dev, "Unable to map MIIM registers\n");
-		return PTR_ERR(regs);
-	}
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	if (!device_is_mfd(pdev)) {
+		regs = devm_ioremap_resource(dev, res);
+		if (IS_ERR(regs)) {
+			dev_err(dev, "Unable to map MIIM registers\n");
+			return PTR_ERR(regs);
+		}
 
-	mii_regmap = devm_regmap_init_mmio(dev, regs, &mscc_miim_regmap_config);
+		mii_regmap = devm_regmap_init_mmio(dev, regs,
+						   &mscc_miim_regmap_config);
+	} else {
+		mii_regmap = ocelot_get_regmap_from_resource(dev->parent, res);
+	}
 
 	if (IS_ERR(mii_regmap)) {
 		dev_err(dev, "Unable to create MIIM regmap\n");
diff --git a/drivers/pinctrl/pinctrl-microchip-sgpio.c b/drivers/pinctrl/pinctrl-microchip-sgpio.c
index 8db3caf15cf2..53df095b33e0 100644
--- a/drivers/pinctrl/pinctrl-microchip-sgpio.c
+++ b/drivers/pinctrl/pinctrl-microchip-sgpio.c
@@ -12,6 +12,7 @@
 #include <linux/clk.h>
 #include <linux/gpio/driver.h>
 #include <linux/io.h>
+#include <linux/mfd/core.h>
 #include <linux/mod_devicetable.h>
 #include <linux/module.h>
 #include <linux/pinctrl/pinmux.h>
@@ -19,6 +20,7 @@
 #include <linux/property.h>
 #include <linux/regmap.h>
 #include <linux/reset.h>
+#include <soc/mscc/ocelot.h>
 
 #include "core.h"
 #include "pinconf.h"
@@ -137,7 +139,9 @@ static inline int sgpio_addr_to_pin(struct sgpio_priv *priv, int port, int bit)
 
 static inline u32 sgpio_get_addr(struct sgpio_priv *priv, u32 rno, u32 off)
 {
-	return priv->properties->regoff[rno] + off;
+	int stride = regmap_get_reg_stride(priv->regs);
+
+	return (priv->properties->regoff[rno] + off) * stride;
 }
 
 static u32 sgpio_readl(struct sgpio_priv *priv, u32 rno, u32 off)
@@ -818,6 +822,7 @@ static int microchip_sgpio_probe(struct platform_device *pdev)
 	struct fwnode_handle *fwnode;
 	struct reset_control *reset;
 	struct sgpio_priv *priv;
+	struct resource *res;
 	struct clk *clk;
 	u32 __iomem *regs;
 	u32 val;
@@ -850,11 +855,18 @@ static int microchip_sgpio_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	regs = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(regs))
-		return PTR_ERR(regs);
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	if (!device_is_mfd(pdev)) {
+		regs = devm_ioremap_resource(dev, res);
+		if (IS_ERR(regs))
+			return PTR_ERR(regs);
+
+		priv->regs = devm_regmap_init_mmio(dev, regs, &regmap_config);
+	} else {
+		priv->regs = ocelot_get_regmap_from_resource(dev->parent, res);
+	}
 
-	priv->regs = devm_regmap_init_mmio(dev, regs, &regmap_config);
 	if (IS_ERR(priv->regs))
 		return PTR_ERR(priv->regs);
 
diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index b6ad3ffb4596..d5485c6a0e20 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -10,6 +10,7 @@
 #include <linux/gpio/driver.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/mfd/core.h>
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
@@ -20,6 +21,7 @@
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
+#include <soc/mscc/ocelot.h>
 
 #include "core.h"
 #include "pinconf.h"
@@ -1123,6 +1125,9 @@ static int lan966x_pinmux_set_mux(struct pinctrl_dev *pctldev,
 	return 0;
 }
 
+#if defined(REG)
+#undef REG
+#endif
 #define REG(r, info, p) ((r) * (info)->stride + (4 * ((p) / 32)))
 
 static int ocelot_gpio_set_direction(struct pinctrl_dev *pctldev,
@@ -1805,6 +1810,7 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct ocelot_pinctrl *info;
 	struct regmap *pincfg;
+	struct resource *res;
 	void __iomem *base;
 	int ret;
 	struct regmap_config regmap_config = {
@@ -1819,16 +1825,27 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
 
 	info->desc = (struct pinctrl_desc *)device_get_match_data(dev);
 
-	base = devm_ioremap_resource(dev,
-			platform_get_resource(pdev, IORESOURCE_MEM, 0));
-	if (IS_ERR(base))
-		return PTR_ERR(base);
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (IS_ERR(res)) {
+		dev_err(dev, "Failed to get resource\n");
+		return PTR_ERR(res);
+	}
 
 	info->stride = 1 + (info->desc->npins - 1) / 32;
 
-	regmap_config.max_register = OCELOT_GPIO_SD_MAP * info->stride + 15 * 4;
+	if (!device_is_mfd(pdev)) {
+		base = devm_ioremap_resource(dev, res);
+		if (IS_ERR(base))
+			return PTR_ERR(base);
+
+		regmap_config.max_register =
+			OCELOT_GPIO_SD_MAP * info->stride + 15 * 4;
+
+		info->map = devm_regmap_init_mmio(dev, base, &regmap_config);
+	} else {
+		info->map = ocelot_get_regmap_from_resource(dev->parent, res);
+	}
 
-	info->map = devm_regmap_init_mmio(dev, base, &regmap_config);
 	if (IS_ERR(info->map)) {
 		dev_err(dev, "Failed to create regmap\n");
 		return PTR_ERR(info->map);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 5c3a3597f1d2..70fae9c8b649 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -969,4 +969,15 @@ ocelot_mrp_del_ring_role(struct ocelot *ocelot, int port,
 }
 #endif
 
+#if IS_ENABLED(CONFIG_MFD_OCELOT)
+struct regmap *ocelot_get_regmap_from_resource(struct device *dev,
+					       const struct resource *res);
+#else
+static inline struct regmap *
+ocelot_get_regmap_from_resource(struct device *dev, const struct resource *res)
+{
+	return NULL;
+}
+#endif
+
 #endif
-- 
2.25.1

