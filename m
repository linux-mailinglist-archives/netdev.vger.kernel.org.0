Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 316154CEF72
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 03:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbiCGCNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 21:13:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234715AbiCGCNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 21:13:43 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2099.outbound.protection.outlook.com [40.107.93.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73FC19C34;
        Sun,  6 Mar 2022 18:12:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lw3FkyWDzd6ROL2FeXgVWgF6zq7hWLXWFgb0SbjNSikCmEBvIFtSHLBD7DTEi1FV7cDrDQu+FjTle3K8yAiVhvff/vjWzETfC/Oat3hOmB425/mKM38IQ1u2BdZM/gb4hojLqhRIGIu7/O0gGr2Xu1LVB1jllWoCjPelPPejd3/4XseemG5GPbLWdr+8neMTrrxlgGSkSh5qwowj6AodKyKlb92wkElxvV3ni9RaGndKhBB8eZ7wVj6IitRKeVWFp0Z41ATOvJ3RL8sRmYk0PF8UZm70rmNqtko5dow9CGxtp9/W7qryadkItoyD62txjZmdiLOfKvCOD/0VlYFq0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BXcJndMTJt8qPNbDIco/zIUAX664IBv5oTo02bPwI0s=;
 b=lQjOrQJa2DXExdoXTSfHenkvhIyOO1vnA3mf3vPzW+tLm4Wd1zelqM5QDQaaUKTQsn7DW8+FaYqnlVN8aLHBhKdj9cLf9anOWe3jYdunY+sPj/XlmKlMyY+zMKuIAi7MXP09JttGUMualA2W0R0SD8DOOCgqCYlNoA3DuoQF6Ty9l0dwxiB3ceKF0i8XEhb4JpIkv63lELOmHEhaZIsLHDX51j4XQ1Hs/y0dRTzqep6ALzML40LXxo6k94BDPZZP1fNXc6lftAYTP7V9kcZfjJZZ80ggtyyvkbK9b4TClpbBY85JcVRUkn1hlx9rFwk9dcmQ9O+X2JLrujm9y8ar8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BXcJndMTJt8qPNbDIco/zIUAX664IBv5oTo02bPwI0s=;
 b=mZRl09bDgdnbcmE6/97GI7FrJTpwYzazb5bUJ8dCGQYBzuvk1A0B1dk3nC5wDcF3mNcly1Z8/9b+mdtG64bL2PuVoVhaIdP5NVyEsGIH2W4wRsjpIGU0HqN3P5mcl3Pw+9Wx9VAiZbzN2EWzReW2jbuqAmdNpDVzq8KJohzX32w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4553.namprd10.prod.outlook.com
 (2603:10b6:806:11a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 02:12:33 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5%6]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 02:12:33 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Marc Zyngier <maz@kernel.org>,
        Hector Martin <marcan@marcan.st>,
        Angela Czubak <acz@semihalf.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
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
Subject: [RFC v7 net-next 10/13] mfd: ocelot: add support for the vsc7512 chip via spi
Date:   Sun,  6 Mar 2022 18:12:05 -0800
Message-Id: <20220307021208.2406741-11-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220307021208.2406741-1-colin.foster@in-advantage.com>
References: <20220307021208.2406741-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0174.namprd04.prod.outlook.com
 (2603:10b6:303:85::29) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e348bf52-7608-47fc-8bcd-08d9ffdff08d
X-MS-TrafficTypeDiagnostic: SA2PR10MB4553:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB4553E69B21DEEB2F949FF630A4089@SA2PR10MB4553.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3OSo42UhImwuh4WG4+r4HEYjHxs0ihG7GBIQe+9pSbSZye3RsDs9xm22k2Ey0ifJ0ozRdGhplzGGkN8nJQHz1VpvAYySEZOxqf1t4lkk+u2NNi4ZcWj21xAsrrUV7Mjf2+s+2OnxJNG+jpyo3O5iHZ2uwLlzXzaOJlGUvDoPl/uIC6g/+WcvBaP3LBd/ek1XxBSRavxi/Vyzh2YV0i41mF5W5TsTskuFp9rGJ8dk2JFKjx/Y4hBPj9P4iRWrONtQHTxPCjIXbC6mq9IKIzHiS6hyZe/X8cegCqQipoS2IcC3zeUz1n2x6shi253MiUFGxNVK8p/2EpeF1rLAnRE8/mqO6qBZE+aRxZA3P3yOJgy8m0srzw0LFGVKLde7Jg7UY3tbX7zqqEyndDU+HRD+AathCVXEyYrm4nSYOcHs7HMHrWwD/6SwB9/rqhg/dHFekcb+EUcHLr/6pCV85vWr3lWqor48qcR65/Lgg3g4VURfRLKF480AQjr/1VRIHcG6z+ywf4MniepNd5w4XrW+DfjeyWvMWCmzzalQaDnH8c3cdd/ZTPBPAkRQhagsySyntubjuTB1tBrM1VA4R4Dmmukj3OIuTPjMHOKeqSlTqBN4U2A6Xtz8Ym3JH2Uh4QbudrAwUja+nL3tp5eUXCY4T6UykqRl2LLc6x98XGbZPOXabXpt+O2/mfBixABBWHcX4FLYewIc2GJl0EHqrN3sGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(376002)(42606007)(396003)(136003)(39840400004)(346002)(38350700002)(86362001)(508600001)(107886003)(38100700002)(6486002)(54906003)(36756003)(44832011)(30864003)(6666004)(6506007)(66556008)(66946007)(4326008)(316002)(66476007)(8676002)(6512007)(26005)(186003)(8936002)(83380400001)(52116002)(1076003)(5660300002)(7416002)(2616005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hWv5OMvpzdGzGk+CQbQ32tC1DPR6NF85X+vHcVrD2Ix85TRdbMmFkhOhAqeX?=
 =?us-ascii?Q?o401h22B3Go0H73cr2ZbbLkKevnUBpZs8c0DuqQjlliPyywIb4duWAIX8diP?=
 =?us-ascii?Q?9Sr1HEeJ7PTqxIvUKEkqb4X1K9KVXY2bYJDo4alG3E2blVPD0Sjn7Y1tfqJ/?=
 =?us-ascii?Q?PFLwWhg+tdzwkBX4G9AO1lDk6iMt3Wg9B+0q6NKW6l1p1s9Fl9H+FuShCET2?=
 =?us-ascii?Q?fTuEZMEg0p+UICT3lc8WTwhTWSqVRBbNhJ0cvkaYoJwTFEEVt/0vW8PdLjsX?=
 =?us-ascii?Q?lIsSFa5kyeuYLqt7EvaKoSPn+soH+LJh/XV6wJdc5ymaXeSXmHO88/WGM+4v?=
 =?us-ascii?Q?mmQKKEtLAYyvPb+bp20XUV3SHAompqMvSTLTB9g9elQaEUZJPmq7jg/WBU37?=
 =?us-ascii?Q?C+EUbdFc5GOcBXTSyxpmcPXYQXqQG+02FUghklyvDTbDbGDso16A5WMCX4ZM?=
 =?us-ascii?Q?9zWUpqRes+Fo5ck8Nx8Ee0fvKuFyVDty9+hzUpphbWZj+/o940beIBWkW53n?=
 =?us-ascii?Q?2ZPhhci3UgTzc2WcIyoGFICgMYzXCrV1dmDwU5KpA8bEneco60Ra9uo1xVF6?=
 =?us-ascii?Q?jCQ83cJYwSB+2aFyFSLEFRbvlQXHJt2oTkG6kOCPpyFGv605ERsWSI/VCvkG?=
 =?us-ascii?Q?JmC20E8PzQ3MFCOQ87hCOMzKAnurA1QBmgImk46br5Na4D7Y3seGM5KU0IsS?=
 =?us-ascii?Q?M07gA+UniytHCZk9HLkvtU0yiOVu+9j9LbeY4y8mo7tO9R181/AJDu1hhl4y?=
 =?us-ascii?Q?QEzqx1j9qEjlZeN1JSG4dbw2T/Kaii8KpoHvCnKeI0o/dvYM4mkZRSJUGM2E?=
 =?us-ascii?Q?k6SfG1IZ5pbMEAX4ZT7eRr5d5BKhuJ+ncF0P3ZferAjC+ZG6MTjqR+fsw5Gx?=
 =?us-ascii?Q?+cE7q+y9ATNI8Am3EiLDfnPPEwwudrc74WqqoivxFBekXErK0EXl12gtiQg8?=
 =?us-ascii?Q?A1+oBCKit42AFbWjdTalqv1dDFQ6uFHF06bpNShTGDP0Rvh0TqDsfBQ66MIg?=
 =?us-ascii?Q?v3lpnWET9sUbTE52LevxC6kfYnHFA2AZF2V8F2FA9SxW5e/cUg0lYHt5aLiE?=
 =?us-ascii?Q?PQP/sh/WaMKvz7rdOQzmKy/SapyxZ5NwxFuAO3JVwRMjbdEianXaBglx2cEn?=
 =?us-ascii?Q?6eQoaofVaJ0bBxniXNFebE31kKO0VT0xTAPExT7O07p/553gnj+7kcf9b3zB?=
 =?us-ascii?Q?vE3JVAknGll4A8R50xRgV0dAZ/ycw5JW3HhWzgE5iiVFCjwe8bXohyWbfq7H?=
 =?us-ascii?Q?x+KwGzNX1DRqXxYyAZbluOt6IC6932hKjq6CvNnkDP0twwbjl7YXQadrbR8l?=
 =?us-ascii?Q?YPWkfDBJQfENWbxVy1UvpbZiRpkR5fWGd2GFIQhTqKARALqGLpiMPz6WEaPX?=
 =?us-ascii?Q?Yz3V6RTKACJ4doTxFb7lTeldtu7il1tQ1XNWwUQ9yI0H1uxka34hGBUbUIw1?=
 =?us-ascii?Q?fjfFBfm0ctpn9MVDbgnJqdQtmvz9//0Wq3YAKXn9EEIE1Rge142QvSXwPzYB?=
 =?us-ascii?Q?9Kin7PHJ47o+WICWC0/T5INZ3Y/BmXESgD1WZkuw4qfSb4f2lgZv6shYAyV9?=
 =?us-ascii?Q?B7hsldhQOoKftsLbNxSJ5kxFAjzB7KCSb+/WhCDEG4ZznbXIU+M95diVug57?=
 =?us-ascii?Q?dGvZgOT6p/R4Ft3FxA61nkKy6vnA9GtmWOsPA7prjqcHanGCWQxA/Ljx6lWT?=
 =?us-ascii?Q?INUYvYBvvf0MihAwTGhiCwYnALY=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e348bf52-7608-47fc-8bcd-08d9ffdff08d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 02:12:33.1202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ZkceWNDF6YnIHEdAM0JjgNOmeBAw2n4BoRC40uLCEtmMmA6OLbXuj0sOEHM745iv+zXzHiL/v1DP03WAmYUiwB9mlHJu4yeBBdVM5YFCUQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4553
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VSC7512 is a networking chip that contains several peripherals. Many of
these peripherals are currently supported by the VSC7513 and VSC7514 chips,
but those run on an internal CPU. The VSC7512 lacks this CPU, and must be
controlled externally.

Utilize the existing drivers by referencing the chip as an MFD. Add support
for the two MDIO buses, the internal phys, pinctrl, serial GPIO, and HSIO.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/mfd/Kconfig       |  24 +++
 drivers/mfd/Makefile      |   3 +
 drivers/mfd/ocelot-core.c | 189 +++++++++++++++++++++++
 drivers/mfd/ocelot-spi.c  | 313 ++++++++++++++++++++++++++++++++++++++
 drivers/mfd/ocelot.h      |  42 +++++
 include/soc/mscc/ocelot.h |   5 +
 6 files changed, 576 insertions(+)
 create mode 100644 drivers/mfd/ocelot-core.c
 create mode 100644 drivers/mfd/ocelot-spi.c
 create mode 100644 drivers/mfd/ocelot.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index ba0b3eb131f1..d4312a5252d0 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -948,6 +948,30 @@ config MFD_MENF21BMC
 	  This driver can also be built as a module. If so the module
 	  will be called menf21bmc.
 
+config MFD_OCELOT
+	tristate "Microsemi Ocelot External Control Support"
+	select MFD_CORE
+	help
+	  Ocelot is a family of networking chips that support multiple ethernet
+	  and fibre interfaces. In addition to networking, they contain several
+	  other functions, including pictrl, MDIO, and communication with
+	  external chips. While some chips have an internal processor capable of
+	  running an OS, others don't. All chips can be controlled externally
+	  through different interfaces, including SPI, I2C, and PCIe.
+
+	  Say yes here to add support for Ocelot chips (VSC7511, VSC7512,
+	  VSC7513, VSC7514) controlled externally.
+
+	  If unsure, say N
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
index 000000000000..36e4326a853a
--- /dev/null
+++ b/drivers/mfd/ocelot-core.c
@@ -0,0 +1,189 @@
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
+#include <soc/mscc/ocelot.h>
+
+#include <asm/byteorder.h>
+
+#include "ocelot.h"
+
+#define GCB_SOFT_RST 0x0008
+
+#define SOFT_CHIP_RST 0x1
+
+#define VSC7512_GCB_RES_START	0x71070000
+#define VSC7512_GCB_RES_SIZE	0x14
+
+#define VSC7512_MIIM0_RES_START	0x7107009c
+#define VSC7512_MIIM0_RES_SIZE	0x24
+
+#define VSC7512_MIIM1_RES_START	0x710700c0
+#define VSC7512_MIIM1_RES_SIZE	0x24
+
+#define VSC7512_PHY_RES_START	0x710700f0
+#define VSC7512_PHY_RES_SIZE	0x4
+
+#define VSC7512_HSIO_RES_START	0x710d0000
+#define VSC7512_HSIO_RES_SIZE	0x10000
+
+#define VSC7512_GPIO_RES_START	0x71070034
+#define VSC7512_GPIO_RES_SIZE	0x6c
+
+#define VSC7512_SIO_RES_START	0x710700f8
+#define VSC7512_SIO_RES_SIZE	0x100
+
+static const struct resource vsc7512_gcb_resource =
+	DEFINE_RES_REG_NAMED(VSC7512_GCB_RES_START, VSC7512_GCB_RES_SIZE,
+			     "devcpu_gcb_chip_regs");
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
+	return ret;
+}
+
+static struct regmap *ocelot_devm_regmap_init(struct ocelot_core *core,
+					      struct device *child,
+					      const struct resource *res)
+{
+	/*
+	 * Call directly into ocelot_spi to get a new regmap. This will need to
+	 * be expanded if additional bus types are to be supported in the
+	 * future.
+	 */
+	return ocelot_spi_devm_get_regmap(core, child, res);
+}
+
+struct regmap *ocelot_get_regmap_from_resource(struct device *child,
+					       const struct resource *res)
+{
+	struct ocelot_core *core = dev_get_drvdata(child->parent);
+
+	return ocelot_devm_regmap_init(core, child, res);
+}
+EXPORT_SYMBOL(ocelot_get_regmap_from_resource);
+
+static const struct resource vsc7512_miim0_resources[] = {
+	DEFINE_RES_REG_NAMED(VSC7512_MIIM0_RES_START, VSC7512_MIIM0_RES_SIZE,
+			     "gcb_miim0"),
+	DEFINE_RES_REG_NAMED(VSC7512_PHY_RES_START, VSC7512_PHY_RES_SIZE,
+			     "gcb_phy"),
+};
+
+static const struct resource vsc7512_miim1_resources[] = {
+	DEFINE_RES_REG_NAMED(VSC7512_MIIM1_RES_START, VSC7512_MIIM1_RES_SIZE,
+			     "gcb_miim1"),
+};
+
+static const struct resource vsc7512_hsio_resources[] = {
+	DEFINE_RES_REG_NAMED(VSC7512_HSIO_RES_START, VSC7512_HSIO_RES_SIZE,
+			     "hsio"),
+};
+
+static const struct resource vsc7512_pinctrl_resources[] = {
+	DEFINE_RES_REG_NAMED(VSC7512_GPIO_RES_START, VSC7512_GPIO_RES_SIZE,
+			     "gcb_gpio"),
+};
+
+static const struct resource vsc7512_sgpio_resources[] = {
+	DEFINE_RES_REG_NAMED(VSC7512_SIO_RES_START, VSC7512_SIO_RES_SIZE,
+			     "gcb_sio"),
+};
+
+static const struct mfd_cell vsc7512_devs[] = {
+	{
+		.name = "ocelot-pinctrl",
+		.of_compatible = "mscc,ocelot-pinctrl",
+		.num_resources = ARRAY_SIZE(vsc7512_pinctrl_resources),
+		.resources = vsc7512_pinctrl_resources,
+	}, {
+		.name = "ocelot-sgpio",
+		.of_compatible = "mscc,ocelot-sgpio",
+		.num_resources = ARRAY_SIZE(vsc7512_sgpio_resources),
+		.resources = vsc7512_sgpio_resources,
+	}, {
+		.name = "ocelot-miim0",
+		.of_compatible = "mscc,ocelot-miim",
+		.num_resources = ARRAY_SIZE(vsc7512_miim0_resources),
+		.resources = vsc7512_miim0_resources,
+	}, {
+		.name = "ocelot-miim1",
+		.of_compatible = "mscc,ocelot-miim",
+		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
+		.resources = vsc7512_miim1_resources,
+	}, {
+		.name = "ocelot-serdes",
+		.of_compatible = "mscc,vsc7514-serdes",
+		.num_resources = ARRAY_SIZE(vsc7512_hsio_resources),
+		.resources = vsc7512_hsio_resources,
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
+	if (IS_ERR(core->gcb_regmap))
+		return -ENOMEM;
+
+	ret = ocelot_reset(core);
+	if (ret) {
+		dev_err(dev, "Failed to reset device: %d\n", ret);
+		return ret;
+	}
+
+	/*
+	 * A chip reset will clear the SPI configuration, so it needs to be done
+	 * again before we can access any registers
+	 */
+	ret = ocelot_spi_initialize(core);
+	if (ret) {
+		dev_err(dev, "Failed to initialize SPI interface: %d\n", ret);
+		return ret;
+	}
+
+	ret = devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, vsc7512_devs,
+				   ARRAY_SIZE(vsc7512_devs), NULL, 0, NULL);
+	if (ret) {
+		dev_err(dev, "Failed to add sub-devices: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_core_init);
+
+MODULE_DESCRIPTION("Externally Controlled Ocelot Chip Driver");
+MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/mfd/ocelot-spi.c b/drivers/mfd/ocelot-spi.c
new file mode 100644
index 000000000000..c788e239c9a7
--- /dev/null
+++ b/drivers/mfd/ocelot-spi.c
@@ -0,0 +1,313 @@
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
+#define DEV_CPUORG_IF_CTRL	0x0000
+#define DEV_CPUORG_IF_CFGSTAT	0x0004
+
+#define CFGSTAT_IF_NUM_VCORE	(0 << 24)
+#define CFGSTAT_IF_NUM_VRAP	(1 << 24)
+#define CFGSTAT_IF_NUM_SI	(2 << 24)
+#define CFGSTAT_IF_NUM_MIIM	(3 << 24)
+
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
+int ocelot_spi_initialize(struct ocelot_core *core)
+{
+	u32 val, check;
+	int err;
+
+#ifdef __LITTLE_ENDIAN
+	val = VSC7512_BYTE_ORDER_LE;
+#else
+	val = VSC7512_BYTE_ORDER_BE;
+#endif
+
+	err = regmap_write(core->cpuorg_regmap, DEV_CPUORG_IF_CTRL, val);
+	if (err)
+		return err;
+
+	val = core->spi_padding_bytes;
+	err = regmap_write(core->cpuorg_regmap, DEV_CPUORG_IF_CFGSTAT, val);
+	if (err)
+		return err;
+
+	/*
+	 * After we write the interface configuration, read it back here. This
+	 * will verify several different things. The first is that the number of
+	 * padding bytes actually got written correctly. These are found in bits
+	 * 0:3.
+	 *
+	 * The second is that bit 16 is cleared. Bit 16 is IF_CFGSTAT:IF_STAT,
+	 * and will be set if the register access is too fast. This would be in
+	 * the condition that the number of padding bytes is insufficient for
+	 * the SPI bus frequency.
+	 *
+	 * The last check is for bits 31:24, which define the interface by which
+	 * the registers are being accessed. Since we're accessing them via the
+	 * serial interface, it must return IF_NUM_SI.
+	 */
+	check = val | CFGSTAT_IF_NUM_SI;
+
+	err = regmap_read(core->cpuorg_regmap, DEV_CPUORG_IF_CFGSTAT, &val);
+	if (err)
+		return err;
+
+	if (check != val)
+		return -ENODEV;
+
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_spi_initialize);
+
+/*
+ * The SPI protocol for interfacing with the ocelot chips uses 24 bits, while
+ * the register locations are defined as 32-bit. The least significant two bits
+ * get shifted out, as register accesses must always be word-aligned, leaving
+ * bits 21:0 as the 22-bit address. It must always be big-endian, whereas the
+ * payload can be optimized for bit / byte order to match whatever architecture
+ * the controlling CPU has.
+ */
+static unsigned int ocelot_spi_translate_address(unsigned int reg)
+{
+	return cpu_to_be32((reg & 0xffffff) >> 2);
+}
+
+struct ocelot_spi_regmap_context {
+	u32 base;
+	struct ocelot_core *core;
+};
+
+static int ocelot_spi_reg_read(void *context, unsigned int reg,
+			       unsigned int *val)
+{
+	struct ocelot_spi_regmap_context *regmap_context = context;
+	struct ocelot_core *core = regmap_context->core;
+	struct spi_transfer tx, padding, rx;
+	struct spi_message msg;
+	struct spi_device *spi;
+	unsigned int addr;
+	u8 *tx_buf;
+
+	spi = core->spi;
+
+	addr = ocelot_spi_translate_address(reg + regmap_context->base);
+	tx_buf = (u8 *)&addr;
+
+	spi_message_init(&msg);
+
+	memset(&tx, 0, sizeof(tx));
+
+	/* Ignore the first byte for the 24-bit address */
+	tx.tx_buf = &tx_buf[1];
+	tx.len = 3;
+
+	spi_message_add_tail(&tx, &msg);
+
+	if (core->spi_padding_bytes > 0) {
+		u8 dummy_buf[16] = {0};
+
+		memset(&padding, 0, sizeof(padding));
+
+		/* Just toggle the clock for padding bytes */
+		padding.len = core->spi_padding_bytes;
+		padding.tx_buf = dummy_buf;
+		padding.dummy_data = 1;
+
+		spi_message_add_tail(&padding, &msg);
+	}
+
+	memset(&rx, 0, sizeof(rx));
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
+	struct ocelot_core *core = regmap_context->core;
+	struct spi_transfer tx[2] = {0};
+	struct spi_message msg;
+	struct spi_device *spi;
+	unsigned int addr;
+	u8 *tx_buf;
+
+	spi = core->spi;
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
+ocelot_spi_devm_get_regmap(struct ocelot_core *core, struct device *child,
+			   const struct resource *res)
+{
+	struct ocelot_spi_regmap_context *context;
+	struct regmap_config regmap_config;
+
+	context = devm_kzalloc(child, sizeof(*context), GFP_KERNEL);
+	if (IS_ERR(context))
+		return ERR_CAST(context);
+
+	context->base = res->start;
+	context->core = core;
+
+	memcpy(&regmap_config, &ocelot_spi_regmap_config,
+	       sizeof(ocelot_spi_regmap_config));
+
+	regmap_config.name = res->name;
+	regmap_config.max_register = res->end - res->start;
+
+	return devm_regmap_init(child, NULL, context, &regmap_config);
+}
+
+static int ocelot_spi_probe(struct spi_device *spi)
+{
+	struct device *dev = &spi->dev;
+	struct ocelot_core *core;
+	int err;
+
+	core = devm_kzalloc(dev, sizeof(*core), GFP_KERNEL);
+	if (!core)
+		return -ENOMEM;
+
+	if (spi->max_speed_hz <= 500000) {
+		core->spi_padding_bytes = 0;
+	} else {
+		/*
+		 * Calculation taken from the manual for IF_CFGSTAT:IF_CFG.
+		 * Register access time is 1us, so we need to configure and send
+		 * out enough padding bytes between the read request and data
+		 * transmission that lasts at least 1 microsecond.
+		 */
+		core->spi_padding_bytes = 1 +
+			(spi->max_speed_hz / 1000000 + 2) / 8;
+	}
+
+	core->spi = spi;
+
+	spi->bits_per_word = 8;
+
+	err = spi_setup(spi);
+	if (err < 0) {
+		dev_err(&spi->dev, "Error %d initializing SPI\n", err);
+		return err;
+	}
+
+	core->cpuorg_regmap =
+		ocelot_spi_devm_get_regmap(core, dev,
+					   &vsc7512_dev_cpuorg_resource);
+	if (IS_ERR(core->cpuorg_regmap))
+		return -ENOMEM;
+
+	core->dev = dev;
+
+	/*
+	 * The chip must be set up for SPI before it gets initialized and reset.
+	 * This must be done before calling init, and after a chip reset is
+	 * performed.
+	 */
+	err = ocelot_spi_initialize(core);
+	if (err) {
+		dev_err(dev, "Error %d initializing Ocelot SPI bus\n", err);
+		return err;
+	}
+
+	err = ocelot_core_init(core);
+	if (err < 0) {
+		dev_err(dev, "Error %d initializing Ocelot MFD\n", err);
+		return err;
+	}
+
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
+};
+module_spi_driver(ocelot_spi_driver);
+
+MODULE_DESCRIPTION("SPI Controlled Ocelot Chip Driver");
+MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
+MODULE_LICENSE("Dual MIT/GPL");
diff --git a/drivers/mfd/ocelot.h b/drivers/mfd/ocelot.h
new file mode 100644
index 000000000000..20d3853dd6d2
--- /dev/null
+++ b/drivers/mfd/ocelot.h
@@ -0,0 +1,42 @@
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
+	struct regmap *cpuorg_regmap;
+
+#if IS_ENABLED(CONFIG_MFD_OCELOT_SPI)
+	int spi_padding_bytes;
+	struct spi_device *spi;
+#endif
+};
+
+void ocelot_get_resource_name(char *name, const struct resource *res,
+			      int size);
+int ocelot_core_init(struct ocelot_core *core);
+int ocelot_remove(struct ocelot_core *core);
+
+#if IS_ENABLED(CONFIG_MFD_OCELOT_SPI)
+struct regmap *ocelot_spi_devm_get_regmap(struct ocelot_core *core,
+					  struct device *child,
+					  const struct resource *res);
+int ocelot_spi_initialize(struct ocelot_core *core);
+#else
+static inline struct regmap *ocelot_spi_devm_get_regmap(
+		struct ocelot_core *core, struct device *child,
+		const struct resource *res)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+static inline int ocelot_spi_initialize(struct ocelot_core *core)
+{
+	return -EOPNOTSUPP;
+}
+#endif
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 998616511ffb..d9e2710d5646 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -1018,11 +1018,16 @@ ocelot_mrp_del_ring_role(struct ocelot *ocelot, int port,
 }
 #endif
 
+#if IS_ENABLED(CONFIG_MFD_OCELOT)
+struct regmap *ocelot_get_regmap_from_resource(struct device *child,
+					       const struct resource *res);
+#else
 static inline struct regmap *
 ocelot_get_regmap_from_resource(struct device *child,
 				const struct resource *res)
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
+#endif
 
 #endif
-- 
2.25.1

