Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5027951EF31
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 21:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbiEHTGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 15:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347839AbiEHS5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 14:57:39 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2134.outbound.protection.outlook.com [40.107.223.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92EB2A1B1;
        Sun,  8 May 2022 11:53:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fDU7rGEoTHszG5l5R+5NItEBkI3pUsq4N96yMr4KQGCGuLZR/+7ikx9tGCjxeb/7VPFWIx1cHRh4eiek7yR/7MHF8T8VquFGrdVO7m+sCWGO3ZnyZiLyM4Zp0ZEskzAghuVFQk7jWIKrpl6K1nrdhxlxQ/lhbEQeczBm1hDXO8KY3+9rhDD4n/AuHNRdMUizXhw5OX03NmPz90rvX2lP31bFVhaBW2AIizgc17tdrR/ZB8D4xiqj24whQVMEvhFxBI/HlNwvJLtSSK1e8nAny5eSnMivmc4SmZIhIv+kaZC6Klbq60+Jc/hEdfGKptUI9Bg7W8OJgr95+HVUcpdwUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n/1/wtc2gbnSEslFA+vW4p017aD5PD/WLOblDeiguoc=;
 b=TikdZGvjqX9KeO/YD3qSNQWxXj9lDgpuFKoRtJR+0qRM2K7yKscPVcsFAflZnafBVfOtmbs8+UJuw4T9TV5svp3EmEOK8Dl5p48h5fdIp+9RHUqMwtEVOsZvSRkMBREAIldFlRb0RGp91xsGBR3yFzJk0duBPZTUmJ87140QThAPgv6VItDXNrz3D8Q1xYnsGM1JueYz3Rq2PPo82WMkU8TmT4w4c3LhOBC+99vA9YGlFDPGuFfxVSeMAV/C1tOFGHRsxNld8RLGg1VWIkJd3OzbHKiSD5X8YBdhLBlUvHwa6lunH+gZvxJgn9dnFj+mUY+omj1CSMKE0mDvpX8pjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n/1/wtc2gbnSEslFA+vW4p017aD5PD/WLOblDeiguoc=;
 b=EvbtkyUYWqgvUvWvz9yZs/N1q7lsfHnmOlGsIr4gvB0ZvzVDvpzz1Csp6RDCLJhK+mLBSPteicZh/YHvPiaN8DoQb1JfA5mXKVAtsIqFpM4d/Hqk/tj3ERATGdMSG34TRRmeK+3H3KrtbY1vNxAzAET4MvxJcxdFVTfxosAAd0I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB5533.namprd10.prod.outlook.com
 (2603:10b6:a03:3f7::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Sun, 8 May
 2022 18:53:46 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.020; Sun, 8 May 2022
 18:53:45 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>, Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [RFC v8 net-next 08/16] mfd: ocelot: add support for the vsc7512 chip via spi
Date:   Sun,  8 May 2022 11:53:05 -0700
Message-Id: <20220508185313.2222956-9-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508185313.2222956-1-colin.foster@in-advantage.com>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0045.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::20) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 722a6198-9bdc-4c4e-796e-08da31241452
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5533:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB553334780A121FD1E4B37A9BA4C79@SJ0PR10MB5533.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ISDGbZjos40osL6Fw7l6CWcIM6ongc5sSc15UWvCkdClPNaHMd4c7TKFa5HfqVyoKiEOe2vtmQyKcL8ow+HFZWHtLHG1HO5bSflqdmt7mccQQyr/c8go1g7/9tmgOo06GOwDJxJG2ggTEPtM9qjAAiZwvkExgvPUMCSJQOnpbcLMr+o0gQM36FCI5exLzhZoBK4e5o9GwpGJH67li5mKewXQoVHqvzqAid5IU++Wa4nzAa/6Q+B5ssnDs16MNCEa+jJ65RZwA60onZNSQKNQESWc31wVg14Iu4ZUQimHX9faLnL4GtA9bjZ9bslt2BMgdD4b4tsae7FfCL7SUQ0v8a7PYAUCEpOsdGtDQ+1Uyxrrjh/ZQLhzKZAr1DfMPZuG4G5iOylEX2w+CqDWydsAsklT0uJOUoQqie75A5fJ+zXMqRZeGVSjWUVvd1eu6AO/UZRcM8vGM7t0upr/5sIT1FOQ2TZoXKTkyz0ZCMXLOtkeg9APBTrCtqBWpN08U2a4w8sQ+qP2bHvfGKkk538NtN80dflLUGiFfnelC5R4ZaOz57ciOz/5qaaR7L+RZGqNtmOZ+v9YvmP+JaJEvpaq4FIZc6eA3W8w6Hqk+bwatCf8DMblGV+HqqhH97dFE4Ee4Ecq3m6PPym7XbA3aJivQBo+kfEyVBkC7u/+419W24E7WSJZOQTuPa5KOoAisYPzWT3e4z3JNE5zwyMV0ho79w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39840400004)(136003)(376002)(366004)(396003)(346002)(316002)(66946007)(6666004)(30864003)(26005)(66556008)(508600001)(44832011)(6512007)(6486002)(66476007)(52116002)(186003)(86362001)(2906002)(4326008)(54906003)(8676002)(38100700002)(2616005)(38350700002)(6506007)(83380400001)(8936002)(7416002)(1076003)(36756003)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xh7qjJjAsoPzK75XBt0YWGFX2S8x7mqgRfX0RcTWKsUY38Vtjf3LYet/Wcbs?=
 =?us-ascii?Q?ygI5I4r+q++uosFztAhup0Sq+vj4Mwuq+9UZ7fn6n7lozHqUtM2Mz9zI46H+?=
 =?us-ascii?Q?Rk/i+35soG02dg9MW2PFwzGX7IuHMT7wi2cwF/J6VGbMDQhu3n17ium8hFQU?=
 =?us-ascii?Q?S7QK6Uk7U7pZQxJFDaOhuUHDdx7pOpnvRdb9KzZdLHEUCmEPivdsPvTPqIHj?=
 =?us-ascii?Q?A+HSJA2rlWK4Nxo87Iom8a1rqdl5dKWd/bqrJ/EXsmJplFB7dmRC5xb2Ir8v?=
 =?us-ascii?Q?Z0zIRA+Ta8YUcpA8z1yPsW0LwGZyTZjXqRz6SSL5EZ8rfgNMjvfqoFQUkief?=
 =?us-ascii?Q?EaH9hhMUvoK/bkmpxKnZM+MvHcPKG7G9WS8uOt26uQDQ5X2zQ61z1WjWVcLK?=
 =?us-ascii?Q?p+rBSmpw/EtBlXxYQAhPnJc60LOzAtmoAb7sMff/2S63+CfmDzFwwBkUSDF5?=
 =?us-ascii?Q?qvbleY1pxxUOwLL4PvCbEK/zl51zENSK+Zm0KLHdUhyYe8QyCQ+vVw3QRmDc?=
 =?us-ascii?Q?tqV5LA4zCV2uHQ++YQIc/mvNThP0P8x+G2b3pS61SJtoh2SBu2UCdCntY02Y?=
 =?us-ascii?Q?5CnT4h5QVUPI3BED0VPk1Z4MAECvoh3GVtgieEjSigXlmlLAuPAwiyrMCxQS?=
 =?us-ascii?Q?XDr52Zv6NM/75OCt8l5LTwLKHcL/Fk7En7kCbeLBnX3w2vVzjzSULw1AjEJy?=
 =?us-ascii?Q?EwehisvNVReTyYmJ7T+QpSY2KRbYdTtqpQCx+ptD1wdBjBwuMrenqJ2ZHc+G?=
 =?us-ascii?Q?VTXSZmBY0B3KDIVUl0vDVj2zmjSQxfYLCumca4nxqKDab2NVEFhrePIUlFiR?=
 =?us-ascii?Q?x59IQuAuOQzC20RCG9vxMhj8sh/7mCKnXIByRjwjUuqzjoqrLIe7dLpQugyt?=
 =?us-ascii?Q?E04WtRmQsVeHkAz4ayhkls1jKEgpYb9JAAWb7Kuy8GHiFf0ajpI0SR2tqrZ6?=
 =?us-ascii?Q?++8jAcWLmBwEsB44aWf6GUdOjlFvZ2dWN2a4zD6ym1Vdt5DaHDnABDUv8cXs?=
 =?us-ascii?Q?bgyWiTuYyVRH/LMSRdhi0qT2NAfrrwtPk3WeoMT/6WXgNJqiCOu9Kjypf2q3?=
 =?us-ascii?Q?3NhhejyxLpS+IEobzBKPWQh4PvtFFDuWVBZLsqjqLk5SIrhmJvkCCihHnzVk?=
 =?us-ascii?Q?Tra224JVt9ObAbD9NE62J9VKzU1UZtlNFzKZFfLjxPeUBCieyIQOJiSty2Xs?=
 =?us-ascii?Q?Bob0VaB0/ODeOoXE6Qxj8ktB+XEUDJ0Fe+oNP/zcaoZcLmm0J89T0dfAmHw/?=
 =?us-ascii?Q?gD7WGkaXDu1dgWc1/3E2fS7vkzwyG/G9qAciUljtHU/e7Z6X9MtuceqgUz2Z?=
 =?us-ascii?Q?9W/bnmY+7OvQoXgWBwTq2Nzxuw6neRVDwzOs1n8dNKjwd3QcM2F8Px5i1yK3?=
 =?us-ascii?Q?sTOOS+hOPh/lbMmpMGMb5Oo2GvBLzrdZyYVJl/pss6u5b5oqk51bK7UJvsHg?=
 =?us-ascii?Q?UWB4O2mwEELXyz/J3wiq5Ep9FPzDmhYnfkh5gTs7JRW6uA9n83ifdhWCY4ly?=
 =?us-ascii?Q?t/Dj6NeQqeqArKGfO7X+SQXaXLf/145jUr63wPC8yCYFb1sDJjuxz6R3McaC?=
 =?us-ascii?Q?zV4Tu/7S1pzAozEu5Qc2hPBB1FnxlwnPEre7mfC51MWPU8QOay2xQ0Ki+oMJ?=
 =?us-ascii?Q?y1Y+Ng/FAOluQ+3uztcLvsjHEcGwY4x6rbkiwon4vXHcmlpc+b2R3t3ZMaOG?=
 =?us-ascii?Q?ITipT33fjFC72gck4+FCMHqO/xk01snnLth0n0NBYrJbrISAKgBzukxWsnwH?=
 =?us-ascii?Q?fqiPkLTQ4oNDsOJr0KwsDCTswzgt6OSh776EAUd9Vmvocn3l82eu?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 722a6198-9bdc-4c4e-796e-08da31241452
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 18:53:45.8379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t7rKWrHGoRFhf/kvYVw64fKglbHZVc1wSwGT5KyB2dhYVInRn5UFoUIB9ZT40QAL/4JBOii/VyFhtO7NIO4+yQ0gQErxUrr+G7TNuhEDK/Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5533
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
 drivers/mfd/Kconfig       |  18 +++
 drivers/mfd/Makefile      |   2 +
 drivers/mfd/ocelot-core.c | 135 +++++++++++++++++
 drivers/mfd/ocelot-spi.c  | 311 ++++++++++++++++++++++++++++++++++++++
 drivers/mfd/ocelot.h      |  34 +++++
 include/soc/mscc/ocelot.h |   5 +
 6 files changed, 505 insertions(+)
 create mode 100644 drivers/mfd/ocelot-core.c
 create mode 100644 drivers/mfd/ocelot-spi.c
 create mode 100644 drivers/mfd/ocelot.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 3b59456f5545..ff177173ca11 100644
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
index 000000000000..117028f7d845
--- /dev/null
+++ b/drivers/mfd/ocelot-core.c
@@ -0,0 +1,135 @@
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
+#include <linux/module.h>
+#include <linux/regmap.h>
+#include <soc/mscc/ocelot.h>
+
+#include <asm/byteorder.h>
+
+#include "ocelot.h"
+
+#define GCB_SOFT_RST		0x0008
+
+#define SOFT_CHIP_RST		0x1
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
+#define VSC7512_GPIO_RES_START	0x71070034
+#define VSC7512_GPIO_RES_SIZE	0x6c
+
+#define VSC7512_SIO_RES_START	0x710700f8
+#define VSC7512_SIO_RES_SIZE	0x100
+
+int ocelot_chip_reset(struct device *dev)
+{
+	struct ocelot_ddata *ddata = dev_get_drvdata(dev);
+	int ret;
+
+	/*
+	 * Reset the entire chip here to put it into a completely known state.
+	 * Other drivers may want to reset their own subsystems. The register
+	 * self-clears, so one write is all that is needed
+	 */
+	ret = regmap_write(ddata->gcb_regmap, GCB_SOFT_RST, SOFT_CHIP_RST);
+	if (ret)
+		return ret;
+
+	msleep(100);
+
+	return ret;
+}
+EXPORT_SYMBOL(ocelot_chip_reset);
+
+struct regmap *ocelot_init_regmap_from_resource(struct device *child,
+						const struct resource *res)
+{
+	struct device *dev = child->parent;
+
+	return ocelot_spi_devm_init_regmap(dev, child, res);
+}
+EXPORT_SYMBOL(ocelot_init_regmap_from_resource);
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
+	},
+};
+
+int ocelot_core_init(struct device *dev)
+{
+	int ret;
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
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/ocelot-spi.c b/drivers/mfd/ocelot-spi.c
new file mode 100644
index 000000000000..95754deb0b57
--- /dev/null
+++ b/drivers/mfd/ocelot-spi.c
@@ -0,0 +1,311 @@
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
+#define VSC7512_CPUORG_RES_START	0x71000000
+#define VSC7512_CPUORG_RES_SIZE		0x2ff
+
+#define VSC7512_GCB_RES_START	0x71070000
+#define VSC7512_GCB_RES_SIZE	0x14
+
+static const struct resource vsc7512_dev_cpuorg_resource =
+	DEFINE_RES_REG_NAMED(VSC7512_CPUORG_RES_START, VSC7512_CPUORG_RES_SIZE,
+			     "devcpu_org");
+
+static const struct resource vsc7512_gcb_resource =
+	DEFINE_RES_REG_NAMED(VSC7512_GCB_RES_START, VSC7512_GCB_RES_SIZE,
+			     "devcpu_gcb_chip_regs");
+
+int ocelot_spi_initialize(struct device *dev)
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
+EXPORT_SYMBOL(ocelot_spi_initialize);
+
+static const struct regmap_config ocelot_spi_regmap_config = {
+	.reg_bits = 24,
+	.reg_stride = 4,
+	.reg_downshift = 2,
+	.val_bits = 32,
+
+	.write_flag_mask = 0x80,
+
+	.max_register = 0xffffffff,
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
+	static const u8 dummy_buf[16] = {0};
+	struct spi_transfer tx, padding, rx;
+	struct ocelot_ddata *ddata = context;
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
+	if (ddata->spi_padding_bytes > 0) {
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
+ocelot_spi_devm_init_regmap(struct device *dev, struct device *child,
+			    const struct resource *res)
+{
+	struct ocelot_ddata *ddata = dev_get_drvdata(dev);
+	struct regmap_config regmap_config;
+
+	memcpy(&regmap_config, &ocelot_spi_regmap_config,
+	       sizeof(ocelot_spi_regmap_config));
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
+		dev_err(&spi->dev, "Error %d initializing SPI\n", err);
+		return err;
+	}
+
+	ddata->cpuorg_regmap =
+		ocelot_spi_devm_init_regmap(dev, dev,
+					    &vsc7512_dev_cpuorg_resource);
+	if (IS_ERR(ddata->cpuorg_regmap))
+		return -ENOMEM;
+
+	ddata->gcb_regmap = ocelot_spi_devm_init_regmap(dev, dev,
+							&vsc7512_gcb_resource);
+	if (IS_ERR(ddata->gcb_regmap))
+		return -ENOMEM;
+
+	/*
+	 * The chip must be set up for SPI before it gets initialized and reset.
+	 * This must be done before calling init, and after a chip reset is
+	 * performed.
+	 */
+	err = ocelot_spi_initialize(dev);
+	if (err) {
+		dev_err(dev, "Error %d initializing Ocelot SPI bus\n", err);
+		return err;
+	}
+
+	err = ocelot_chip_reset(dev);
+	if (err) {
+		dev_err(dev, "Failed to reset device: %d\n", err);
+		return err;
+	}
+
+	/*
+	 * A chip reset will clear the SPI configuration, so it needs to be done
+	 * again before we can access any registers
+	 */
+	err = ocelot_spi_initialize(dev);
+	if (err) {
+		dev_err(dev,
+			"Failed to initialize Ocelot SPI bus after reset: %d\n",
+			err);
+		return err;
+	}
+
+	err = ocelot_core_init(dev);
+	if (err < 0) {
+		dev_err(dev, "Error %d initializing Ocelot core\n", err);
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
index 000000000000..b68e6343caca
--- /dev/null
+++ b/drivers/mfd/ocelot.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/*
+ * Copyright 2021 Innovative Advantage Inc.
+ */
+
+#include <linux/regmap.h>
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
+struct regmap *ocelot_spi_devm_init_regmap(struct device *dev,
+					   struct device *child,
+					   const struct resource *res);
+int ocelot_spi_initialize(struct device *dev);
+
+#define OCELOT_SPI_BYTE_ORDER_LE 0x00000000
+#define OCELOT_SPI_BYTE_ORDER_BE 0x81818181
+
+#ifdef __LITTLE_ENDIAN
+#define OCELOT_SPI_BYTE_ORDER OCELOT_SPI_BYTE_ORDER_LE
+#else
+#define OCELOT_SPI_BYTE_ORDER OCELOT_SPI_BYTE_ORDER_BE
+#endif
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 1897119ebb9a..f9124a66e386 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -1039,11 +1039,16 @@ ocelot_mrp_del_ring_role(struct ocelot *ocelot, int port,
 }
 #endif
 
+#if IS_ENABLED(CONFIG_MFD_OCELOT)
+struct regmap *ocelot_init_regmap_from_resource(struct device *child,
+						const struct resource *res);
+#else
 static inline struct regmap *
 ocelot_init_regmap_from_resource(struct device *child,
 				 const struct resource *res)
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
+#endif
 
 #endif
-- 
2.25.1

