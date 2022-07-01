Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C480F5639DA
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 21:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbiGAT1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 15:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232394AbiGAT0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 15:26:39 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2120.outbound.protection.outlook.com [40.107.100.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D540A3C72F;
        Fri,  1 Jul 2022 12:26:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BpVSdPNUTCcV3pVNtVmlRqbEmP28HEPaNz84cj1K9Xx96qpwEziYOKl3yhKZyqSozjoKAgQuj6iGFg1QcrNSylOJpoc0HPRE+zztPKLsgwjek2K5kNujZgFDDIzKxXdXt3EOG1FTym2mQkav/y/74bSds7tqEJsbqdSEHuL8B/AmSyphJi6OpPHs4Y9mKWjFNR890Zgey+CkEF2RnzOSBj69VtvIt5S5UqEIAIPgTD5gUltC7QxpGqPPKLg3dTtggzvkgcVld9S/uqdyTz8XjBGmP9gOKvwciCywmYk3/70ED/VgGJceQb1fOV0rpjlkQ1U7fiXmqC6FencG59x4ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QSqdkYDiiiPrrn9s5LBfoqFZB5g8jPLZYUU3AasxqYo=;
 b=gKbmOJ6f/azMaxep+C3KBg2sZS3ViiJDQVi5ydqUrRxaU4apw/F0AoZFheZAx4HhX9QY4QkawBqJVjB0Z8l3Xe9OCoh4hIND/Z/LArbujZDG9IKaLg2VygN+mJhfAJbKTl8GT6huZPs3XjbUPuO2arZJW2TPSkK7sAy678P//gOOBrQS4M5s2xIMv25d4RAhN5qc1wD8WNzn47Eu5KZs7bOEzB+ewF1nEbqvNzKe7aoxKlEAjMSDlJvSUFZnc/HYbBJ8gDqRgPPGbOaM6JrnMG7WkepTCI9FCKzx2b2fp4VBzkafGDGjab1eL91Yb7tEZeW42+GQI+JMAz3PV+cvSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSqdkYDiiiPrrn9s5LBfoqFZB5g8jPLZYUU3AasxqYo=;
 b=j1rKsDOVqR3DK9YOCzZaGtmqbmCQ09CMjMvAKkysdQ2iyNRaeYbxCYSkl1lJWXxV1arLneTvaqQwpdXKZajoXqppTHoDmQMLk4edi2rA/eX+RvxFzbJTt3ZErl2rjWXeQWz5tsAGEHDx/abbRnlxh0sSQQ+KucKvBYfHpfPub1Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CY4PR1001MB2230.namprd10.prod.outlook.com
 (2603:10b6:910:46::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Fri, 1 Jul
 2022 19:26:25 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Fri, 1 Jul 2022
 19:26:25 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        katie.morris@in-advantage.com
Subject: [PATCH v12 net-next 9/9] mfd: ocelot: add support for the vsc7512 chip via spi
Date:   Fri,  1 Jul 2022 12:26:09 -0700
Message-Id: <20220701192609.3970317-10-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220701192609.3970317-1-colin.foster@in-advantage.com>
References: <20220701192609.3970317-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR1601CA0006.namprd16.prod.outlook.com
 (2603:10b6:300:da::16) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08885e46-8fbf-4262-9bda-08da5b979675
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2230:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sr/uhvzpDKPIJSk133zmf6h8TQLQZdgPD0usLc+Yh4Qv4cchMZLay3r3nCGb1dEJ4rF698WMrHWJeS6L5dw63UgUM6GHEG5/agpyeVoU47JA9vJ2Eqp89g9FDLkGseLNqR2EIbATJMw5OieW0MsUzTHkHgvYCUBomLNJ335grVkJJI/pP/YgiBpS9Ixy8ghHZtpIZWjEHEOAZwIXtw1JGzXW9Eu3t35h1dTER8mHc0vWQKUV6oOVj4h2cybS/0xdwS+8p+LruoIMJgg1CXdB4dJ6BG0dkvRxNsBZFwTsiS0R0yxSx4Yl7oi1BWV++vcv6ZXHP+Kmm9lng7f4c9Jah3UP2yVWXvAWvRPgetqtEWcgedbwkXsve4dK1XAtf91Lj7qZVnvCNnZ4I7B0gGFdFnjntyhrVszM1kD/tU03Yk92IeE3YL06VTsIgUXiUFOpmaBGbrUluk2yDGZMx3DWsqwP+DAQNvvYwOOFgZjS0/9Vbdmk4UdEhyb2OkAOyezCSW5Brozf6uml7+JS6hL0S/6+YPkUGMyxYVRO459DLXFoswc4jqWY1vey8rSve2z84AQpsx10Ue7kc1to+agXv9ApCI+oirfBUTL5FsdWJdyxU9gYI9cmS+6tY3QFH+AS4Drx4hF6/ft1SaTnYAC1KO+ZmCHPXvNKFB7KasHLNqG8zYm9tCQ3p/yo4a9GB+IoMmJRe0a81mMz5oUXnEugb7rN3fUeYn3N6l8YsF+G0lOqzexeX8Ncs0qbUcE6Tm3n7/V0YLUCeLZRX4RVy+m2UV07HCDCYBQpVCf5cUYOEU1QnnVGg2NvZyy/+QMbMQFO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(39830400003)(376002)(136003)(396003)(66476007)(38350700002)(186003)(8676002)(8936002)(4326008)(86362001)(66946007)(1076003)(5660300002)(6666004)(38100700002)(107886003)(83380400001)(66556008)(7416002)(41300700001)(478600001)(316002)(36756003)(52116002)(44832011)(2906002)(6512007)(2616005)(6506007)(6486002)(26005)(54906003)(30864003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TPYwGZaZruVnJLpQwKv2zq2JthTVp3hg1nP9DICCW4y8YXNMDA0GAZ47v6an?=
 =?us-ascii?Q?2qlEqHtnesa3whq+TH/1x0vyofmSu4FQdxXYlPq1U70i8V448Gpw/LhZBbt2?=
 =?us-ascii?Q?K1dCVeHQOcy4hUiTmLWUtAx5mvsmZz7jT00j10nd28tcnXhrhDXhlc3ZG0c7?=
 =?us-ascii?Q?ap0JmN+hgFrTff5UIZuh0YZFKHxE7u6I2xO4LYGp0sbezatzKPouTxn0Arej?=
 =?us-ascii?Q?F1VcF0U12Qa0z42Kxr4K7XbiJHl/OLWHtf5qV5fYmmLlqWr8pombtogjeb2m?=
 =?us-ascii?Q?o8koVZIOMnjCz6XQHZlpwEfXTbbR7bKIopg0/KtTbICvuwl1MxdBrehFcjGV?=
 =?us-ascii?Q?nn/ToOmy0we1iTxrIxlg1PTrCr93zehO+uXgZAFPibHIL/XmQaJuJZqG47K7?=
 =?us-ascii?Q?YaQvmmnZeMFRZ6HmaqxoGmnuKI6qlhiDvW0FEFUiyvarzXirOxUwp8USF/uu?=
 =?us-ascii?Q?JBYPgE1g+X3pzo6m+rpJq0ONHYXf5CWKX/PvU6EaqX7h9j9AG8RznMEQANYJ?=
 =?us-ascii?Q?76LUy1XO0JcMVrBdua1xuOMu9ubmkyrFjEU9x/HwAWLDE9lr0MYBwtMwptOL?=
 =?us-ascii?Q?N9ssXr7oZ2aR3aWf0t1IAasuia7va/8MvtQqxJQfuzn+rQrr1fCRnGDzpqY7?=
 =?us-ascii?Q?fxyLCYsivsVP5L7VlUIlf3zDubiLlRmooqiqpv2WhNl2AqCy6aJz4No968PG?=
 =?us-ascii?Q?yLm7GqPK3iFmmYEMLddkge785r0psa0q9VWEWSLU9trFDdx4ZKOPVrjF8AbH?=
 =?us-ascii?Q?HmZLwp6BoszLV2z3hSZgEE0ddFm0Nt9VYReQWUMMOLB9h/3byXnBoKk2A8xg?=
 =?us-ascii?Q?aQI4KybaPRX7/G7+0SVcriIY5Gh+bAFkQ5EoKEQUVFbYO93lFKSeZ0b6+Uni?=
 =?us-ascii?Q?aV9CcJagjgtbB23Sb0hwBG3iIKYub/Co8LlZmZOqk8fGFpF3S8oK8WFhbWdh?=
 =?us-ascii?Q?bDE/eyF5yk2IuLkeRQxxYGz4Y5c6/jZ2XH4Uvqer+tob5UH38wuFCkpAhzKv?=
 =?us-ascii?Q?UeqxL6Uf/d1+M0GfAOWjm4+bUTwCCbbqU0q2xoT+YiRZk2ZeOqwfNq4JBEc9?=
 =?us-ascii?Q?xdFedtf8xiqSHmOO1nGWQBcY/OM/i7+p6NVyJ5w+pM9pRhzbRI4n1ac716b4?=
 =?us-ascii?Q?xDZRfd3co6tgieAqGemn4SLYo1ZPtCmQBzso/WtolbWtXy7DrAPYf1Ly85bu?=
 =?us-ascii?Q?tRANxgjoH77Op2k465B3V0B8QHcN7cLl/S2ZgFc/PoH/szclcLIbkBACYIDb?=
 =?us-ascii?Q?HpmrbUZWvWu6aNa3/xZ1yFf9aMXW2+cY6Y1GZyjDFWgsbV6x3O3l7Z36ZLQC?=
 =?us-ascii?Q?LkAYNuiz0hxYZZIN1MdjkLMhmTQdQzK8mNjLFvNAsE9uP6EoyGn5xSt2RsaJ?=
 =?us-ascii?Q?N4vaiebmGoR6CO5UdBpFtaEnvQzTovw2YQngemuw+2b6PXSCSmuJVnsajhq2?=
 =?us-ascii?Q?lIOxQM0x031GRaKT8P9tw4pzCS7MDs4LFtQQWIFULfDH57kkqgR68XalSf+U?=
 =?us-ascii?Q?1Ays89lVAdSvv0o1XYjlFag/T/VoT1SDLCo2yMcX2/t94MX79STALAmRqOiF?=
 =?us-ascii?Q?4h4/Va3DYNLz8kSgYiQciLqmTDKSipVxlThglL29cMvVbtqrehsHijn+3zQg?=
 =?us-ascii?Q?vq/hewQFKdQoMB74G6ORryc=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08885e46-8fbf-4262-9bda-08da5b979675
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 19:26:25.0856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dWNFdwHXzxhqdRuPgnq4XpmcAZ97KmtT54hFhVGm++K49hEhRb1avTsnTBb4WKOKHhEbqWeBS/65Fy+u61Gdeg36Wp5rF5GyavrpJeuDsW0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2230
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
for the two MDIO buses, the internal phys, pinctrl, and serial GPIO.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 MAINTAINERS               |   1 +
 drivers/mfd/Kconfig       |  18 +++
 drivers/mfd/Makefile      |   2 +
 drivers/mfd/ocelot-core.c | 164 ++++++++++++++++++++
 drivers/mfd/ocelot-spi.c  | 312 ++++++++++++++++++++++++++++++++++++++
 drivers/mfd/ocelot.h      |  28 ++++
 6 files changed, 525 insertions(+)
 create mode 100644 drivers/mfd/ocelot-core.c
 create mode 100644 drivers/mfd/ocelot-spi.c
 create mode 100644 drivers/mfd/ocelot.h

diff --git a/MAINTAINERS b/MAINTAINERS
index a67828cbda20..3ce2853e01a2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14417,6 +14417,7 @@ OCELOT EXTERNAL SWITCH CONTROL
 M:	Colin Foster <colin.foster@in-advantage.com>
 S:	Supported
 F:	Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
+F:	drivers/mfd/ocelot*
 F:	include/linux/mfd/ocelot.h
 
 OCXL (Open Coherent Accelerator Processor Interface OpenCAPI) DRIVER
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 3b59456f5545..21da9a92c2a8 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -962,6 +962,24 @@ config MFD_MENF21BMC
 	  This driver can also be built as a module. If so the module
 	  will be called menf21bmc.
 
+config MFD_OCELOT
+	tristate "Microsemi Ocelot External Control Support"
+	depends on SPI_MASTER
+	select MFD_CORE
+	select REGMAP_SPI
+	help
+	  Ocelot is a family of networking chips that support multiple ethernet
+	  and fibre interfaces. In addition to networking, they contain several
+	  other functions, including pinctrl, MDIO, and communication with
+	  external chips. While some chips have an internal processor capable of
+	  running an OS, others don't. All chips can be controlled externally
+	  through different interfaces, including SPI, I2C, and PCIe.
+
+	  Say yes here to add support for Ocelot chips (VSC7511, VSC7512,
+	  VSC7513, VSC7514) controlled externally.
+
+	  If unsure, say N.
+
 config EZX_PCAP
 	bool "Motorola EZXPCAP Support"
 	depends on SPI_MASTER
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 858cacf659d6..bc517632ba5f 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -120,6 +120,8 @@ obj-$(CONFIG_MFD_MC13XXX_I2C)	+= mc13xxx-i2c.o
 
 obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
 
+obj-$(CONFIG_MFD_OCELOT)	+= ocelot-core.o ocelot-spi.o
+
 obj-$(CONFIG_EZX_PCAP)		+= ezx-pcap.o
 obj-$(CONFIG_MFD_CPCAP)		+= motorola-cpcap.o
 
diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
new file mode 100644
index 000000000000..abb7b5034032
--- /dev/null
+++ b/drivers/mfd/ocelot-core.c
@@ -0,0 +1,164 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * Core driver for the Ocelot chip family.
+ *
+ * The VSC7511, 7512, 7513, and 7514 can be controlled internally via an
+ * on-chip MIPS processor, or externally via SPI, I2C, PCIe. This core driver is
+ * intended to be the bus-agnostic glue between, for example, the SPI bus and
+ * the child devices.
+ *
+ * Copyright 2021, 2022 Innovative Advantage Inc.
+ *
+ * Author: Colin Foster <colin.foster@in-advantage.com>
+ */
+
+#include <linux/mfd/core.h>
+#include <linux/mfd/ocelot.h>
+#include <linux/module.h>
+#include <linux/regmap.h>
+#include <soc/mscc/ocelot.h>
+
+#include "ocelot.h"
+
+#define GCB_SOFT_RST			0x0008
+
+#define SOFT_CHIP_RST			0x1
+
+#define VSC7512_MIIM0_RES_START		0x7107009c
+#define VSC7512_MIIM0_RES_SIZE		0x24
+
+#define VSC7512_MIIM1_RES_START		0x710700c0
+#define VSC7512_MIIM1_RES_SIZE		0x24
+
+#define VSC7512_PHY_RES_START		0x710700f0
+#define VSC7512_PHY_RES_SIZE		0x4
+
+#define VSC7512_GPIO_RES_START		0x71070034
+#define VSC7512_GPIO_RES_SIZE		0x6c
+
+#define VSC7512_SIO_CTRL_RES_START	0x710700f8
+#define VSC7512_SIO_CTRL_RES_SIZE	0x100
+
+#define VSC7512_GCB_RST_SLEEP		100
+#define VSC7512_GCB_RST_TIMEOUT		100000
+
+static int ocelot_gcb_chip_rst_status(struct ocelot_ddata *ddata)
+{
+	int val, err;
+
+	err = regmap_read(ddata->gcb_regmap, GCB_SOFT_RST, &val);
+	if (err)
+		val = -1;
+
+	return val;
+}
+
+int ocelot_chip_reset(struct device *dev)
+{
+	struct ocelot_ddata *ddata = dev_get_drvdata(dev);
+	int ret, val;
+
+	/*
+	 * Reset the entire chip here to put it into a completely known state.
+	 * Other drivers may want to reset their own subsystems. The register
+	 * self-clears, so one write is all that is needed and wait for it to
+	 * clear.
+	 */
+	ret = regmap_write(ddata->gcb_regmap, GCB_SOFT_RST, SOFT_CHIP_RST);
+	if (ret)
+		return ret;
+
+	ret = readx_poll_timeout(ocelot_gcb_chip_rst_status, ddata, val, !val,
+				 VSC7512_GCB_RST_SLEEP,
+				 VSC7512_GCB_RST_TIMEOUT);
+	if (ret)
+		return dev_err_probe(ddata->dev, ret, "timeout: chip reset\n");
+
+	return 0;
+}
+EXPORT_SYMBOL_NS(ocelot_chip_reset, MFD_OCELOT);
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
+static const struct resource vsc7512_pinctrl_resources[] = {
+	DEFINE_RES_REG_NAMED(VSC7512_GPIO_RES_START, VSC7512_GPIO_RES_SIZE,
+			     "gcb_gpio"),
+};
+
+static const struct resource vsc7512_sgpio_resources[] = {
+	DEFINE_RES_REG_NAMED(VSC7512_SIO_CTRL_RES_START,
+			     VSC7512_SIO_CTRL_RES_SIZE,
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
+		.of_reg = VSC7512_MIIM0_RES_START,
+		.use_of_reg = true,
+		.num_resources = ARRAY_SIZE(vsc7512_miim0_resources),
+		.resources = vsc7512_miim0_resources,
+	}, {
+		.name = "ocelot-miim1",
+		.of_compatible = "mscc,ocelot-miim",
+		.of_reg = VSC7512_MIIM1_RES_START,
+		.use_of_reg = true,
+		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
+		.resources = vsc7512_miim1_resources,
+	},
+};
+
+static void ocelot_core_try_add_regmap(struct device *dev,
+				       const struct resource *res)
+{
+	if (!dev_get_regmap(dev, res->name))
+		ocelot_spi_init_regmap(dev, res);
+}
+
+static void ocelot_core_try_add_regmaps(struct device *dev,
+					const struct mfd_cell *cell)
+{
+	int i;
+
+	for (i = 0; i < cell->num_resources; i++)
+		ocelot_core_try_add_regmap(dev, &cell->resources[i]);
+}
+
+int ocelot_core_init(struct device *dev)
+{
+	int i, ndevs;
+
+	ndevs = ARRAY_SIZE(vsc7512_devs);
+
+	for (i = 0; i < ndevs; i++)
+		ocelot_core_try_add_regmaps(dev, &vsc7512_devs[i]);
+
+	return devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, vsc7512_devs,
+				    ndevs, NULL, 0, NULL);
+}
+EXPORT_SYMBOL_NS(ocelot_core_init, MFD_OCELOT);
+
+MODULE_DESCRIPTION("Externally Controlled Ocelot Chip Driver");
+MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/ocelot-spi.c b/drivers/mfd/ocelot-spi.c
new file mode 100644
index 000000000000..dd57f01db25c
--- /dev/null
+++ b/drivers/mfd/ocelot-spi.c
@@ -0,0 +1,312 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * SPI core driver for the Ocelot chip family.
+ *
+ * This driver will handle everything necessary to allow for communication over
+ * SPI to the VSC7511, VSC7512, VSC7513 and VSC7514 chips. The main functions
+ * are to prepare the chip's SPI interface for a specific bus speed, and a host
+ * processor's endianness. This will create and distribute regmaps for any
+ * children.
+ *
+ * Copyright 2021, 2022 Innovative Advantage Inc.
+ *
+ * Author: Colin Foster <colin.foster@in-advantage.com>
+ */
+
+#include <linux/iopoll.h>
+#include <linux/kconfig.h>
+#include <linux/module.h>
+#include <linux/regmap.h>
+#include <linux/spi/spi.h>
+
+#include <asm/byteorder.h>
+
+#include "ocelot.h"
+
+#define DEV_CPUORG_IF_CTRL		0x0000
+#define DEV_CPUORG_IF_CFGSTAT		0x0004
+
+#define CFGSTAT_IF_NUM_VCORE		(0 << 24)
+#define CFGSTAT_IF_NUM_VRAP		(1 << 24)
+#define CFGSTAT_IF_NUM_SI		(2 << 24)
+#define CFGSTAT_IF_NUM_MIIM		(3 << 24)
+
+#define VSC7512_DEVCPU_ORG_RES_START	0x71000000
+#define VSC7512_DEVCPU_ORG_RES_SIZE	0x38
+
+#define VSC7512_CHIP_REGS_RES_START	0x71070000
+#define VSC7512_CHIP_REGS_RES_SIZE	0x14
+
+static const struct resource vsc7512_dev_cpuorg_resource =
+	DEFINE_RES_REG_NAMED(VSC7512_DEVCPU_ORG_RES_START,
+			     VSC7512_DEVCPU_ORG_RES_SIZE,
+			     "devcpu_org");
+
+static const struct resource vsc7512_gcb_resource =
+	DEFINE_RES_REG_NAMED(VSC7512_CHIP_REGS_RES_START,
+			     VSC7512_CHIP_REGS_RES_SIZE,
+			     "devcpu_gcb_chip_regs");
+
+static int ocelot_spi_initialize(struct device *dev)
+{
+	struct ocelot_ddata *ddata = dev_get_drvdata(dev);
+	u32 val, check;
+	int err;
+
+	val = OCELOT_SPI_BYTE_ORDER;
+
+	/*
+	 * The SPI address must be big-endian, but we want the payload to match
+	 * our CPU. These are two bits (0 and 1) but they're repeated such that
+	 * the write from any configuration will be valid. The four
+	 * configurations are:
+	 *
+	 * 0b00: little-endian, MSB first
+	 * |            111111   | 22221111 | 33222222 |
+	 * | 76543210 | 54321098 | 32109876 | 10987654 |
+	 *
+	 * 0b01: big-endian, MSB first
+	 * | 33222222 | 22221111 | 111111   |          |
+	 * | 10987654 | 32109876 | 54321098 | 76543210 |
+	 *
+	 * 0b10: little-endian, LSB first
+	 * |              111111 | 11112222 | 22222233 |
+	 * | 01234567 | 89012345 | 67890123 | 45678901 |
+	 *
+	 * 0b11: big-endian, LSB first
+	 * | 22222233 | 11112222 |   111111 |          |
+	 * | 45678901 | 67890123 | 89012345 | 01234567 |
+	 */
+	err = regmap_write(ddata->cpuorg_regmap, DEV_CPUORG_IF_CTRL, val);
+	if (err)
+		return err;
+
+	/*
+	 * Apply the number of padding bytes between a read request and the data
+	 * payload. Some registers have access times of up to 1us, so if the
+	 * first payload bit is shifted out too quickly, the read will fail.
+	 */
+	val = ddata->spi_padding_bytes;
+	err = regmap_write(ddata->cpuorg_regmap, DEV_CPUORG_IF_CFGSTAT, val);
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
+	err = regmap_read(ddata->cpuorg_regmap, DEV_CPUORG_IF_CFGSTAT, &val);
+	if (err)
+		return err;
+
+	if (check != val)
+		return -ENODEV;
+
+	return 0;
+}
+
+static const struct regmap_config ocelot_spi_regmap_config = {
+	.reg_bits = 24,
+	.reg_stride = 4,
+	.reg_downshift = 2,
+	.val_bits = 32,
+
+	.write_flag_mask = 0x80,
+
+	.use_single_write = true,
+	.can_multi_write = false,
+
+	.reg_format_endian = REGMAP_ENDIAN_BIG,
+	.val_format_endian = REGMAP_ENDIAN_NATIVE,
+};
+
+static int ocelot_spi_regmap_bus_read(void *context,
+				      const void *reg, size_t reg_size,
+				      void *val, size_t val_size)
+{
+	struct ocelot_ddata *ddata = context;
+	static const u8 dummy_buf[16] = {0};
+	struct spi_transfer tx, padding, rx;
+	struct spi_device *spi = ddata->spi;
+	struct spi_message msg;
+
+	spi = ddata->spi;
+
+	spi_message_init(&msg);
+
+	memset(&tx, 0, sizeof(tx));
+
+	tx.tx_buf = reg;
+	tx.len = reg_size;
+
+	spi_message_add_tail(&tx, &msg);
+
+	if (ddata->spi_padding_bytes) {
+		memset(&padding, 0, sizeof(padding));
+
+		padding.len = ddata->spi_padding_bytes;
+		padding.tx_buf = dummy_buf;
+		padding.dummy_data = 1;
+
+		spi_message_add_tail(&padding, &msg);
+	}
+
+	memset(&rx, 0, sizeof(rx));
+	rx.rx_buf = val;
+	rx.len = val_size;
+
+	spi_message_add_tail(&rx, &msg);
+
+	return spi_sync(spi, &msg);
+}
+
+static int ocelot_spi_regmap_bus_write(void *context, const void *data,
+				       size_t count)
+{
+	struct ocelot_ddata *ddata = context;
+	struct spi_device *spi = ddata->spi;
+
+	return spi_write(spi, data, count);
+}
+
+static const struct regmap_bus ocelot_spi_regmap_bus = {
+	.write = ocelot_spi_regmap_bus_write,
+	.read = ocelot_spi_regmap_bus_read,
+};
+
+struct regmap *
+ocelot_spi_init_regmap(struct device *dev, const struct resource *res)
+{
+	struct ocelot_ddata *ddata = dev_get_drvdata(dev);
+	struct regmap_config regmap_config;
+
+	memcpy(&regmap_config, &ocelot_spi_regmap_config,
+	       sizeof(regmap_config));
+
+	regmap_config.name = res->name;
+	regmap_config.max_register = res->end - res->start;
+	regmap_config.reg_base = res->start;
+
+	return devm_regmap_init(dev, &ocelot_spi_regmap_bus, ddata,
+				&regmap_config);
+}
+
+static int ocelot_spi_probe(struct spi_device *spi)
+{
+	struct device *dev = &spi->dev;
+	struct ocelot_ddata *ddata;
+	struct regmap *r;
+	int err;
+
+	ddata = devm_kzalloc(dev, sizeof(*ddata), GFP_KERNEL);
+	if (!ddata)
+		return -ENOMEM;
+
+	ddata->dev = dev;
+	dev_set_drvdata(dev, ddata);
+
+	if (spi->max_speed_hz <= 500000) {
+		ddata->spi_padding_bytes = 0;
+	} else {
+		/*
+		 * Calculation taken from the manual for IF_CFGSTAT:IF_CFG.
+		 * Register access time is 1us, so we need to configure and send
+		 * out enough padding bytes between the read request and data
+		 * transmission that lasts at least 1 microsecond.
+		 */
+		ddata->spi_padding_bytes = 1 +
+			(spi->max_speed_hz / 1000000 + 2) / 8;
+	}
+
+	ddata->spi = spi;
+
+	spi->bits_per_word = 8;
+
+	err = spi_setup(spi);
+	if (err < 0) {
+		return dev_err_probe(&spi->dev, err,
+				     "Error performing SPI setup\n");
+	}
+
+	r = ocelot_spi_init_regmap(dev, &vsc7512_dev_cpuorg_resource);
+	if (IS_ERR(r))
+		return PTR_ERR(r);
+
+	ddata->cpuorg_regmap = r;
+
+	r = ocelot_spi_init_regmap(dev, &vsc7512_gcb_resource);
+	if (IS_ERR(r))
+		return PTR_ERR(r);
+
+	ddata->gcb_regmap = r;
+
+	/*
+	 * The chip must be set up for SPI before it gets initialized and reset.
+	 * This must be done before calling init, and after a chip reset is
+	 * performed.
+	 */
+	err = ocelot_spi_initialize(dev);
+	if (err)
+		return dev_err_probe(dev, err, "Error initializing SPI bus\n");
+
+	err = ocelot_chip_reset(dev);
+	if (err)
+		return dev_err_probe(dev, err, "Error resetting device\n");
+
+	/*
+	 * A chip reset will clear the SPI configuration, so it needs to be done
+	 * again before we can access any registers
+	 */
+	err = ocelot_spi_initialize(dev);
+	if (err) {
+		return dev_err_probe(dev, err,
+				     "Error initializing SPI bus after reset\n");
+	}
+
+	err = ocelot_core_init(dev);
+	if (err < 0) {
+		return dev_err_probe(dev, err,
+				     "Error initializing Ocelot core\n");
+		return err;
+	}
+
+	return 0;
+}
+
+static const struct spi_device_id ocelot_spi_ids[] = {
+	{ "vsc7512", 0 },
+	{ }
+};
+
+static const struct of_device_id ocelot_spi_of_match[] = {
+	{ .compatible = "mscc,vsc7512" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, ocelot_spi_of_match);
+
+static struct spi_driver ocelot_spi_driver = {
+	.driver = {
+		.name = "ocelot_spi",
+		.of_match_table = ocelot_spi_of_match,
+	},
+	.id_table = ocelot_spi_ids,
+	.probe = ocelot_spi_probe,
+};
+module_spi_driver(ocelot_spi_driver);
+
+MODULE_DESCRIPTION("SPI Controlled Ocelot Chip Driver");
+MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
+MODULE_LICENSE("Dual MIT/GPL");
diff --git a/drivers/mfd/ocelot.h b/drivers/mfd/ocelot.h
new file mode 100644
index 000000000000..4afb628ff7e6
--- /dev/null
+++ b/drivers/mfd/ocelot.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/* Copyright 2021, 2022 Innovative Advantage Inc. */
+
+#include <asm/byteorder.h>
+
+struct ocelot_ddata {
+	struct device *dev;
+	struct regmap *gcb_regmap;
+	struct regmap *cpuorg_regmap;
+	int spi_padding_bytes;
+	struct spi_device *spi;
+};
+
+int ocelot_chip_reset(struct device *dev);
+int ocelot_core_init(struct device *dev);
+
+/* SPI-specific routines that won't be necessary for other interfaces */
+struct regmap *ocelot_spi_init_regmap(struct device *dev,
+				      const struct resource *res);
+
+#define OCELOT_SPI_BYTE_ORDER_LE 0x00000000
+#define OCELOT_SPI_BYTE_ORDER_BE 0x81818181
+
+#ifdef __LITTLE_ENDIAN
+#define OCELOT_SPI_BYTE_ORDER OCELOT_SPI_BYTE_ORDER_LE
+#else
+#define OCELOT_SPI_BYTE_ORDER OCELOT_SPI_BYTE_ORDER_BE
+#endif
-- 
2.25.1

