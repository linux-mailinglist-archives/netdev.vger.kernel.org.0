Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A377F546BF6
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 19:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350322AbiFJR5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 13:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350284AbiFJR5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 13:57:22 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2121.outbound.protection.outlook.com [40.107.223.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FC59809A;
        Fri, 10 Jun 2022 10:57:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hl4hC4QYEvwVAqv/N/P4eDN7/iE0dasUdhXSZ3H4ptr+zizXmKAnUCzgTn/7DUJbims9X6O4Apq/1KcBogxL3jEGR67jEtsvbbwpZD7zhr0hODKFzmMx9iHL/xs8Tjy2NYybiZ3AuOr+JWYtQTsrhwKaMOond4bk/DlrQ2i8TYMO9wtqf9gNZ+PjGcxVmm7GoLzLqyX1fDWZprXaTaVsxEO7J9t2Cid1NDJ/J4EjiLxAclIbB4lP+97bA+uv3WvoOtroRGBmanXOKgIifNaBl3O7tQbXu1LPnWxzSgRKTa+l5URSwNA8Vk/4Mbe7hFwJyeQNKY9GFfcw3J26xqJasw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZgsmEn5X1X540pN5z6SjiYH4yk2icMj8bfBNOlVbn8o=;
 b=mb5+IDjdCJ6SQAb3hgfyaYuM1tb2ElmGJ8tEpr1pwOY7IRhqAf/aIeq6qvZyQbQipmjPknCqK5KQGxWx6iGsEsBLGDvAEGeT4b8J+0n+ywPwsZLnx2UC45JWi98KGBX7lnmv4t/GLmVtFtAAlFWe75g/mnPRBbl/TO5y1Rk2NY673RRgzBVYa0qYdZKDHE7dY20/hqKuZTK8+PW5J4woNkJYVk4d3I5DyzSBlLqaQw+Kvu4hzNSVn7CYSLX0e7EFPjRyT5GqZwKfxtCGYZUH1DifZhudsJIFc5TVW+UE7aeR4dmqxC5rXQDxedV683dPImQA19GhjRRqtWhbJjJr/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZgsmEn5X1X540pN5z6SjiYH4yk2icMj8bfBNOlVbn8o=;
 b=JAI6gKVT5TqwaEgOb81ZnAvAivDLiQFZsee6JSKQmeltzZ13mkQi0kyKhaLaMjrjzUtbSEj2b4yTEYJtQS+SQqcZLBc/nYLynH4Nq+Kz/Mn7neoACTPJ12Yh2GM0r7HfCE6ZY2ZQ/Jf5J3MgpYnrPWHzixIno4VmCwu0nK+oMTc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB3356.namprd10.prod.outlook.com
 (2603:10b6:5:1a9::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.15; Fri, 10 Jun
 2022 17:57:11 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f%7]) with mapi id 15.20.5332.014; Fri, 10 Jun 2022
 17:57:11 +0000
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
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH v9 net-next 7/7] mfd: ocelot: add support for the vsc7512 chip via spi
Date:   Fri, 10 Jun 2022 10:56:55 -0700
Message-Id: <20220610175655.776153-8-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220610175655.776153-1-colin.foster@in-advantage.com>
References: <20220610175655.776153-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR19CA0070.namprd19.prod.outlook.com
 (2603:10b6:300:94::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9ed76bf-9ed8-49a1-eb98-08da4b0aa47a
X-MS-TrafficTypeDiagnostic: DM6PR10MB3356:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB33568D33F94CC05E9BBFB42FA4A69@DM6PR10MB3356.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bp1OCMzTlK5OLfRPoh+eE0SpEDMwQQQC0/t6nQSXe1WbtE/DF5l5rC2ziFPV/wR/y/2n/XAavO8TYVhjNH9rPVz/Zmdd0/L9QYmlkgH3Kc36rMaWr6X4NWBrnMusXu4BVG+fMsurl2IWRc044Qhe5iGlrQGia7MQlxnJulcYToDfKcxU/OZsF92pAOw6GZQFwLLGC1CmhhOv3ZTiPDbuvnAQH+toyYcxI4TnEutUn/jr1ULW3knCLurGL8z9jTo0Rs3zYFjGw3kwVQOTUJmNB7ViTJ+VLpHVKyMzplWFfWxvx90exZtRXiKXW8bjq2x0pN0iNe4eowP6GPRs7Zrsgd8E//KWLde31GYjC+yqDt1928j2Q6PWDnQAlUJ863UC14aUf+TYGg7I7xIXkLFTzsPcmzyQzVbKcW2JU80fUWnicyKodhPxRIAXipyS0+9ImuBrSRbcUdZKCWNcI/tSSj6vfs1qog4iTAvMyOOCiuMA2rNqmfziY2/A5VH87BiFxTW2De5elcZzevbPvvUxs1XS/ZW4AuvA2iTMXG6CtkuTIElpCL6cvCo8b7wc9BF2bpH3YCUBXiCeU59LcMXgiQFuf0ZleHsHzYsSnL3su3f2OHq5RroYDQfoxJu6XjLynhUP8FziWoB7o4t6z3IKR7ESrT7drwp311e3QkT6tamVBkhKe8rJkHzeH4maeW30a1Wn3/cd9c/nNM3ZmE61Tw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(366004)(396003)(136003)(39830400003)(1076003)(54906003)(316002)(4326008)(52116002)(8676002)(2616005)(86362001)(508600001)(6512007)(26005)(6506007)(6666004)(41300700001)(6486002)(186003)(83380400001)(2906002)(38350700002)(44832011)(8936002)(36756003)(38100700002)(66556008)(66946007)(66476007)(7416002)(30864003)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jA/oM7TcdbPRmbgsPYfJcpQyBzf6/Rjj7JdmaVXeljwQhCgXot1XP9yGoQBv?=
 =?us-ascii?Q?s+cKodFKTIAWB0KinNOeT/6b2F8stDikx0QEX5OiYg0oIFqCAt06rkqgQ0RP?=
 =?us-ascii?Q?TMXX3ahy3r+kFyVKkMFuzVbS66KiR//8+nLyiDCWaRCD3RBSzW1qjR+yHba2?=
 =?us-ascii?Q?Cqqcu+kIGAn20p+iPjnEXmFBPAokpov4RAv5K0msTrgkYoNPTRxqvuoMOmPe?=
 =?us-ascii?Q?ov3LI9TZvyORXqepCy55QXEB9UUFELFLf7i2qL7Nh+8pSUWgEPaA2775GOrw?=
 =?us-ascii?Q?qU98Q0qa7amjePKwiOfr1zx/eIkFtYbLQbJQGmUZGSou6cQZpsWp8e9eAoIw?=
 =?us-ascii?Q?NOpbCa878orpkocebYUleHrmj+CAyKekJYsAF5DKLFK2pFuhi2pFoItrRTHl?=
 =?us-ascii?Q?9LmnMepXdii/wSkumLpsZoPnV01H2uETfpyMc9zGLwwymGSBTzpqRr4BeONC?=
 =?us-ascii?Q?WZZ3yRikdS5cLvfplnK9d38LA1Nhq89K4V5NFyLqwZU/0DrzvBxy1G8/z7rw?=
 =?us-ascii?Q?Za7y0fVpo5GtHTFy+aLWNqMSdPqzdTY9Pid0c0ML2GxkJxpxD/Y/UUiMXhWR?=
 =?us-ascii?Q?mCah2RjE3CqjEJ1WuMyf0lomryEbRsUOjQYXN2mUarQp8E2vhIWOaaNCdNHp?=
 =?us-ascii?Q?SM9sEEbwQcjssj84vfw3s2Tj7YYFaUS8nzFZ9lHseOz8uYn46Wu74ywDIl/D?=
 =?us-ascii?Q?livfEfHsN1PF+6PFSd7uv0KZQhVNPgLp4TUksVUlUdATOUc2ANGw6Jr6J4UN?=
 =?us-ascii?Q?PbKdcXFSShUKVhnsPosR0ELQ4dL2y2otHWMJqeGr5O1efNFO8z4+Pv/B1GMf?=
 =?us-ascii?Q?YA1oDRN8bizMP7hiCyrehUgKwRAbGSYJ+a1/pthsx0cefy6/bC5a++GX2aO0?=
 =?us-ascii?Q?O7pOm/KK6V3e6SeJgU6COkHuRpX0crr5cOoTLBzo+mXxvRpg85GXjwr7NJ/W?=
 =?us-ascii?Q?STXCZuSqUd1SGpGijmLXJMomU63xx3A7aCUGAf3TsBWd+fzjTEtuTfVqEx5T?=
 =?us-ascii?Q?mUxCZ3HCGnh1AZmS8vWfH5MwIt5TzxbJUtpf9R90lwZrsyeeCrzWuSqdS6X7?=
 =?us-ascii?Q?GPFJgd/Dugeb8yvSg4E10gRW9wrTherjxDIn7QFelK0bjvf9zmdVLsPoszbY?=
 =?us-ascii?Q?W2QkSkcHsyCheHeT5L36ZqUTlKsLoOVOKz/7wTRNQoGZsLcLTmoN+xJeb95S?=
 =?us-ascii?Q?IVIsuA4kuC6oJXN71M2Yp1ZdaS4szney/1kmfwEMVff8LEZModUj1heIILhb?=
 =?us-ascii?Q?deY4K4+tsfDEkD4zWAWOF2/7mDVKexLFPCA0bdUzloA3wz4Chwq4D9P0J/0v?=
 =?us-ascii?Q?ushswBwFYvlaBRk8QaqIP6FIIuM1uDcvu2fznaLeIFXl4BdofvZ7CM+chQej?=
 =?us-ascii?Q?zmNkelgqlRv4u2hpJ7OVNMxOueIXrZDPfbTw9XntuRPuJ65CuxeniSuHxFnY?=
 =?us-ascii?Q?xVAQyzJUV/vVnbgnYUZuEj8QLDbRpgjIzvsrsHKLGrcRFTun4XQquUYfFYNn?=
 =?us-ascii?Q?VQTQyJSItmGbQZo8EzMLKf3W/XHgJUSSgE3szpLVeRFWFzbSKZGx0fQZiksN?=
 =?us-ascii?Q?TLMIb1Or9+W7cjxUcdcEjKReqMTa19hXwE3p2AgKt0cRTDCe3l8eo8dxQI6h?=
 =?us-ascii?Q?WPzKFYXQsH+gC3bcRsCHUsAFLMt5An7nOUPvMje6edyVknFohL3HSGwEbJK/?=
 =?us-ascii?Q?SrBeZByL0jDD3gQ/H/G3+3Vvy4i1CWSuN6md/xqKx812NwZ2cH4uq1CNhyNu?=
 =?us-ascii?Q?tk8wx1Be+u59Ec2Ov8K+w1GachkgqGjNwqxRA0Sfk4E31q3Jbc3n?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9ed76bf-9ed8-49a1-eb98-08da4b0aa47a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 17:57:10.9652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f9VZ29zLfVX3z7y2raJvyyvGHom50xsr8biHKx3v3bxxChNNnt4qTsxmPwCNBRx5Bpc74KGPtya2ZX5RBpKg+mHIWGoKiTiCpzwmF28w6qE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3356
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
 MAINTAINERS                |   1 +
 drivers/mfd/Kconfig        |  18 +++
 drivers/mfd/Makefile       |   2 +
 drivers/mfd/ocelot-core.c  | 184 ++++++++++++++++++++++
 drivers/mfd/ocelot-spi.c   | 313 +++++++++++++++++++++++++++++++++++++
 drivers/mfd/ocelot.h       |  28 ++++
 include/linux/mfd/ocelot.h |  10 ++
 7 files changed, 556 insertions(+)
 create mode 100644 drivers/mfd/ocelot-core.c
 create mode 100644 drivers/mfd/ocelot-spi.c
 create mode 100644 drivers/mfd/ocelot.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 119fb4207ba3..d24ec7c591a6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14356,6 +14356,7 @@ OCELOT EXTERNAL SWITCH CONTROL
 M:	Colin Foster <colin.foster@in-advantage.com>
 S:	Supported
 F:	Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
+F:	drivers/mfd/ocelot*
 F:	include/linux/mfd/ocelot.h
 
 OCXL (Open Coherent Accelerator Processor Interface OpenCAPI) DRIVER
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 3b59456f5545..6887b513b3fb 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -962,6 +962,24 @@ config MFD_MENF21BMC
 	  This driver can also be built as a module. If so the module
 	  will be called menf21bmc.
 
+config MFD_OCELOT
+	bool "Microsemi Ocelot External Control Support"
+	depends on SPI_MASTER
+	select MFD_CORE
+	select REGMAP_SPI
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
index 000000000000..edc7698b6b1d
--- /dev/null
+++ b/drivers/mfd/ocelot-core.c
@@ -0,0 +1,184 @@
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
+struct regmap *ocelot_init_regmap_from_resource(struct device *child,
+						const struct resource *res)
+{
+	struct device *dev = child->parent;
+
+	return ocelot_spi_init_regmap(dev, child, res);
+}
+EXPORT_SYMBOL_NS(ocelot_init_regmap_from_resource, MFD_OCELOT);
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
+		.of_reg = vsc7512_miim0_resources[0].start,
+		.use_of_reg = true,
+		.num_resources = ARRAY_SIZE(vsc7512_miim0_resources),
+		.resources = vsc7512_miim0_resources,
+	}, {
+		.name = "ocelot-miim1",
+		.of_compatible = "mscc,ocelot-miim",
+		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
+		.of_reg = vsc7512_miim1_resources[0].start,
+		.use_of_reg = true,
+		.resources = vsc7512_miim1_resources,
+	},
+};
+
+void
+ocelot_platform_init_regmap_from_resource(struct platform_device *pdev,
+					  unsigned int index,
+					  struct regmap **map,
+					  struct resource **res,
+					  const struct regmap_config *config)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *resource;
+	struct resource **pres;
+	u32 __iomem *regs;
+
+	*map = ERR_PTR(ENODEV);
+	pres = res ? res : &resource;
+
+	regs = devm_platform_get_and_ioremap_resource(pdev, index, res);
+	if (IS_ERR(regs)) {
+		/*
+		 * Fall back to using IORESOURCE_REG, which is possible in an
+		 * MFD configuration
+		 */
+		*pres = platform_get_resource(pdev, IORESOURCE_REG, index);
+		if (!*pres) {
+			dev_err_probe(dev, PTR_ERR(*pres),
+				      "Failed to get resource\n");
+			return;
+		}
+
+		*map = ocelot_spi_init_regmap(dev->parent, dev, *pres);
+	} else {
+		*map = devm_regmap_init_mmio(dev, regs, config);
+	}
+}
+
+int ocelot_core_init(struct device *dev)
+{
+	return devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, vsc7512_devs,
+				    ARRAY_SIZE(vsc7512_devs), NULL, 0, NULL);
+}
+EXPORT_SYMBOL_NS(ocelot_core_init, MFD_OCELOT);
+
+MODULE_DESCRIPTION("Externally Controlled Ocelot Chip Driver");
+MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/ocelot-spi.c b/drivers/mfd/ocelot-spi.c
new file mode 100644
index 000000000000..e07dc1d040a8
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
+ocelot_spi_init_regmap(struct device *dev, struct device *child,
+		       const struct resource *res)
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
+	return devm_regmap_init(child, &ocelot_spi_regmap_bus, ddata,
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
+	r = ocelot_spi_init_regmap(dev, dev, &vsc7512_dev_cpuorg_resource);
+	if (IS_ERR(r))
+		return PTR_ERR(r);
+
+	ddata->cpuorg_regmap = r;
+
+	r = ocelot_spi_init_regmap(dev, dev, &vsc7512_gcb_resource);
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
+	{ .compatible = "mscc,vsc7512-spi" },
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
index 000000000000..cf33c3ab89c2
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
+struct regmap *ocelot_spi_init_regmap(struct device *dev, struct device *child,
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
diff --git a/include/linux/mfd/ocelot.h b/include/linux/mfd/ocelot.h
index 40e775f1143f..624879e89f5a 100644
--- a/include/linux/mfd/ocelot.h
+++ b/include/linux/mfd/ocelot.h
@@ -2,9 +2,18 @@
 /* Copyright 2022 Innovative Advantage Inc. */
 
 #include <linux/err.h>
+#include <linux/kconfig.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 
+#if IS_ENABLED(CONFIG_MFD_OCELOT)
+void
+ocelot_platform_init_regmap_from_resource(struct platform_device *pdev,
+					  unsigned int index,
+					  struct regmap **map,
+					  struct resource **res,
+					  const struct regmap_config *config);
+#else
 static inline void
 ocelot_platform_init_regmap_from_resource(struct platform_device *pdev,
 					  unsigned int index,
@@ -20,3 +29,4 @@ ocelot_platform_init_regmap_from_resource(struct platform_device *pdev,
 	else
 		*map = ERR_PTR(ENODEV);
 }
+#endif
-- 
2.25.1

