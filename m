Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A9755C9EC
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244787AbiF1ITj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 04:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240979AbiF1IS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 04:18:59 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2136.outbound.protection.outlook.com [40.107.212.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B27E2DA9C;
        Tue, 28 Jun 2022 01:17:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=noJ7c6d+hRDLdvRg53Jwzzwo0B7JAYl7AH7uqEMYLApfomDtOXGD7bcSJJDsauQdbmjicl8rykvuxWpYgqoxHuxrctR/S0rkrR6mfG+gYyQaz+nglzlkGFBBsGUQsfZBq+xOecqG5sTuJr5FgI8HZtvr6IaeztlxdjJPbHIgUwNME3uTC+6/LyqXbCekVyeEwjp1obeEhH+Cv5UcIOzEbpaZwzCBnk4g8Vj5PAauVSUUjr4e8aoI5q3az15wVEg4lbMxrHF6JyJIVeXEVWWW/knAI9uZ7rIS/lCk7YJiMqws5D/xpwroIh4W+j4CD3FaXokyQk9zy8r2kiQGrP09WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jEVYLOC2NeV5OT8middd/D4Z47EAVf6LngpdyfXIvvA=;
 b=X4YR2CQRdK5qNDfBQlsbQQ1PeXzZ61hGtdcVVfqyPC1X113P9BBnUILFahDHvr/rK1QKg/6fAkOSvSKLzJ+NnDNJjWeGF6iXQ1kNddH9emZeUcadeF2USEZXDbqcWTauAp/y/eGrzbpzokUy3nbAH8+eG/I4XOXxg52StpUsDNv6OLCVyaAyOFrhiRVaJF1jRxEdaksrbCe4VqBtL8Q2dzraVeCiBhL2yWJTeHt8oNkX6onVb+3LRbcpZIYdEavaMdvZqIykPJVtaOLgKYz0Qntsu8EIng8aWtZUEC+oUm7GPHVNTQxvHQfmlEOQWQ9zTn9Ih5aO6RepACjqnVoSWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jEVYLOC2NeV5OT8middd/D4Z47EAVf6LngpdyfXIvvA=;
 b=WPbTxHAZ83quIKV0aOq1R+bgPPAGNQt79G3B5cpvbH+GoFHjzVFK5MGoPOHDwvTLfBPQ8ooSyJv4M7TgMYfGjr2/08p7L9wwBM+ayyDKAfDT0bkNVMa3azfJVhJRkm2ZOwLBFuqQOfUW7Nzww6uSq9g0Xvag1Bb9JHJ0S2+OUVk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB5891.namprd10.prod.outlook.com
 (2603:10b6:a03:425::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Tue, 28 Jun
 2022 08:17:31 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 08:17:31 +0000
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
Subject: [PATCH v11 net-next 9/9] mfd: ocelot: add support for the vsc7512 chip via spi
Date:   Tue, 28 Jun 2022 01:17:09 -0700
Message-Id: <20220628081709.829811-10-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220628081709.829811-1-colin.foster@in-advantage.com>
References: <20220628081709.829811-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0259.namprd04.prod.outlook.com
 (2603:10b6:303:88::24) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cdb5c727-4a10-4fdf-ce7a-08da58dea574
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5891:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hyIkFs8M/KK0O1rwPJG2p0gRwdXzeG1OJFEgHMforh+LllGtVTehHxnaJ+xIanaqGXqj5W/KAKPXNXy3Y6wXPmOOAg37ksciOYhcWdAYWDlUQK33JqOJqcVp7uq8WdpK5Fb7fs3g2iyvzK71j/alDiw7hMgnzgyDSl39JMtRxJTjZBS68Z2K5pirAwGAaP6LrquczPxd9y8iTlq1pMkRCIWjB42lBF3Q3EWcod70xX1cxfmlxhg00gi0ny91RF+g3ZMB3E8ji4mABlhp02Jap0Gvt92sWzS9VBkXB0QK4jdyrJrDs4OOt+Y30FmG5+YAYjPnN/whGp1jjj6JezWtUcrCGDA0Qqb6cvzFuhVZBgGa/qQ08UBjmHjrb7d+uxuH2CBywhryaDO7gVHvTicaNcU4NiRCZiXNByB+1zRWwNYLA1V1Z1UaJ1Dl/6JdsE1WCFullJIr9XaS7Lkyzt2jYA9x5Kp2LOpGMRZeIuJmWIkqyzt96cVNTDzl7ICMcLV4qjuFPFiRNCFQbTxxSBcQdWUGnFYAWOOKJjxwV15iZ9/6hjs9BgYFf3/3SxygEoX/wHDu53GFU/ATOm7MgIdg7o5wL527LBoOAp2GMKjQBmUziWQZtTrQE0uk2Ye1o4PCSJyyVIVSd/RSZKyH9W9jq/pat4TdiP1jWz0Nj3QWdjhR+K6BLHeqjOK3E/nB1I0ArgadSiEvp657rTB0PJpux1thbTT4kNbtfYns/8Dnm3i1NwjhnMq4wpasXePORFcmi6UEWJMuee5/PlsUmzfpMrrQQ821FOEw8nxOEfI34AE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(396003)(39840400004)(376002)(136003)(36756003)(38100700002)(6512007)(6666004)(41300700001)(38350700002)(44832011)(478600001)(8676002)(4326008)(2616005)(30864003)(66946007)(66556008)(66476007)(6506007)(2906002)(54906003)(86362001)(1076003)(6486002)(8936002)(186003)(5660300002)(7416002)(316002)(83380400001)(26005)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?idGpuo53g8jhc64IpQRUUZ0gJ+mbf27cmhhyoMyYL18imbAjml0ecmwQD1YC?=
 =?us-ascii?Q?hqZzEqzmnHomXT9nM0q4bItMChcrUBtPaN+MsNM2T/yhiP5hG1rOYrArDaAT?=
 =?us-ascii?Q?t5jb89HlEyTYQyN764+jvtHTqMc/8gcw4EBgVLhsv1NYxMyyMyeZ66s4xX3T?=
 =?us-ascii?Q?wQh/AF71su5OA/OdxKnU4MUjw3T5J3LeXI6lkqnX5awvhrB3BUkjXpRSkHdd?=
 =?us-ascii?Q?a91FM3OjQZEEtOrhSCMl+xOHO0bYPWciqRDZ8sKPPq5eJnzx1jkquIEPlK3u?=
 =?us-ascii?Q?HeJVFZ2gowrbqCp7sfMsPTEn6r4tlactsO+vbqzcuZ+2c/oG3Av6JgqGBznQ?=
 =?us-ascii?Q?Edm6BmSL8ePhD8Xb7xGL50hgOQEiQbY6NVds8wMHs4voty9KhI8icwBbK2of?=
 =?us-ascii?Q?1sqWp+ugQO+B4AGV9RFM9P8G7MGyqwXmp8yTwAi6UAEgv0fgprffMgF5HVED?=
 =?us-ascii?Q?wPizKpEwmv1PAwxHcUtZALvi4Rq06e1hV7REZ7KNM1lic7ovL4bJlsWRdfOj?=
 =?us-ascii?Q?nzJVIYGcMfQ5aWl6RwKO8HyP4dIsLYLCpvD6feUt7mjHyiAd5sm8DxJCij9o?=
 =?us-ascii?Q?fcyQ7FcE0DEbLzUKRQM5IqJppXw5cGJPCOiLGbO9AL42s3+gimLenm8EfIpL?=
 =?us-ascii?Q?QKiUxyk5BXinJ/TF8Le9xWSBm6MODXQuNVk5nEDZXaqedoQJpGa2GaG9CJEe?=
 =?us-ascii?Q?jgcSeQErE1RrITZYim0n2dI3x3/TkHPk8VEWeTdYWpV/d3PavIhGuTfHAydM?=
 =?us-ascii?Q?7aBdBwA7NyBQ5G/ifKDk8hbuJ9DMF4yDHzkjwtfdbKyjiXalYOleOjMU6O/F?=
 =?us-ascii?Q?1zQx7Dpbt2g3i35YjoMJBJUUxnZvLqXE6Px6IGPDsQ3K6vhbsVyQTOBZOD9e?=
 =?us-ascii?Q?8jGyCJc18q/crGxb7IBaTPKVJTzE9E/nbGlAaQe8XSBRJZmGLDB0e59b58dG?=
 =?us-ascii?Q?HVazPy+N3WbsLi0cgN8FfsdLENd+YAQkAmEiGLXgtb8erPZuJJHZ9ToTRm/N?=
 =?us-ascii?Q?4hi1YqvRtTP9mH2Jc+uYNdVuyNHNz7GSuHQDkxCi8tJScxP3u/jaB5PZZqlY?=
 =?us-ascii?Q?J+/eK9mms3WQqdwCwt/cz9oZ3gKpGec6Si41mL/hAzDenr1Aw1hMq0nbzEZ2?=
 =?us-ascii?Q?TSyvo+0W9hLLPf2o7IUMk/kyYVhSnLc5vlaVnaVLpgD1aTr22FnmugCBOYLm?=
 =?us-ascii?Q?0eLHUs3mTab8S6kppAyFXTQZUE2jmWVPeJO8FTFMsvcF3e0yf23gtaBE8fud?=
 =?us-ascii?Q?oiW7zdBtQdZN5OLN2uefb4w8+er3ker65hZoxQZCeCPbGzzxhvIykQMKpAiO?=
 =?us-ascii?Q?Fgj6ZmzIVdv4lO74iL+KY6ndHz7Ck/b0EWvavR9tJChe+OZ62ridyTtzPTbw?=
 =?us-ascii?Q?AalKxBUPpsx3SCI7U0vyOhqZ07mz743iPt0CsEy5zza+SxppY8ZLMZ+k9ILM?=
 =?us-ascii?Q?20UQMFcQWWp/8urWT68XrxdzWybcFQ4tKGuVcFVU8l9nr/eSL6gdB+BxYBzb?=
 =?us-ascii?Q?hklfkQy4SDkdbkChn0KXvYZg8hIVxWqptXKk7EvBcxFHogVIDAIRSzsqlTrp?=
 =?us-ascii?Q?CP2hsSKKzkw03708faf8zdeN2w1OBTFdAoBrQOEWscCR3E+IvPwioNeihkO/?=
 =?us-ascii?Q?n0MoIvOI2kBVB3cmzk2b3s4=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdb5c727-4a10-4fdf-ce7a-08da58dea574
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 08:17:31.0257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VmPYc1E266lCv5bmS7IdX/5PMQ4qZjvNTzcR0dzy45jManZZ9UjUWq2EFqtEXNMFC139RWEIH1hNfe2Zk25GZXL84mA0sgr5LQO7xC69DiQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5891
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
 drivers/mfd/ocelot-core.c  | 175 +++++++++++++++++++++
 drivers/mfd/ocelot-spi.c   | 313 +++++++++++++++++++++++++++++++++++++
 drivers/mfd/ocelot.h       |  28 ++++
 include/linux/mfd/ocelot.h |   8 +
 7 files changed, 545 insertions(+)
 create mode 100644 drivers/mfd/ocelot-core.c
 create mode 100644 drivers/mfd/ocelot-spi.c
 create mode 100644 drivers/mfd/ocelot.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 03eba7fd2141..9f2df8906ab6 100644
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
index 000000000000..18cbe5b8a4ef
--- /dev/null
+++ b/drivers/mfd/ocelot-core.c
@@ -0,0 +1,175 @@
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
+struct regmap *
+ocelot_platform_init_regmap_from_resource(struct platform_device *pdev,
+					  unsigned int index,
+					  const struct regmap_config *config)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	struct regmap *map;
+	u32 __iomem *regs;
+
+	map = ERR_PTR(-ENOENT);
+
+	regs = devm_platform_get_and_ioremap_resource(pdev, index, NULL);
+	if (IS_ERR(regs)) {
+		/*
+		 * Fall back to using IORESOURCE_REG, which is possible in an
+		 * MFD configuration
+		 */
+		res = platform_get_resource(pdev, IORESOURCE_REG, index);
+		if (!res) {
+			dev_err_probe(dev, PTR_ERR(res),
+				      "Failed to get resource\n");
+			return map;
+		}
+
+		map = ocelot_spi_init_regmap(dev->parent, dev, res);
+	} else {
+		map = devm_regmap_init_mmio(dev, regs, config);
+	}
+
+	return map;
+}
+EXPORT_SYMBOL_NS(ocelot_platform_init_regmap_from_resource, MFD_OCELOT);
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
index 000000000000..9b08d2f6a855
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
index 5c95e4ee38a6..86c7ae57d0cb 100644
--- a/include/linux/mfd/ocelot.h
+++ b/include/linux/mfd/ocelot.h
@@ -2,12 +2,19 @@
 /* Copyright 2022 Innovative Advantage Inc. */
 
 #include <linux/err.h>
+#include <linux/kconfig.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/types.h>
 
 struct resource;
 
+#if IS_ENABLED(CONFIG_MFD_OCELOT)
+struct regmap *
+ocelot_platform_init_regmap_from_resource(struct platform_device *pdev,
+					  unsigned int index,
+					  const struct regmap_config *config);
+#else
 static inline struct regmap *
 ocelot_platform_init_regmap_from_resource(struct platform_device *pdev,
 					  unsigned int index,
@@ -25,3 +32,4 @@ ocelot_platform_init_regmap_from_resource(struct platform_device *pdev,
 	else
 		return devm_regmap_init_mmio(&pdev->dev, regs, config);
 }
+#endif
-- 
2.25.1

