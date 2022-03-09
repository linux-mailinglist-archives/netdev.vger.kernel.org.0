Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 114D04D37AC
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237139AbiCIR3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 12:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235077AbiCIR3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 12:29:14 -0500
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10078.outbound.protection.outlook.com [40.107.1.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170B48594D;
        Wed,  9 Mar 2022 09:28:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BbzB7fbI/dWwoSzmlyHQ7GXM7xnQcIA3M74UWo6cYWBEjUyAg/Mjc0uUTpj6qNFpaAzTpyL1rmJZr4DbcCMHfWkWymxKy9Dmj7jdlRyj7Wt3xhDHUT+Rsfb5h/kTXMAcVa60BYu4jrPyL3JbkJOgtDlsoA0HniydPoR8x+gMKgyaSiObBS+idO/wGnF5HQIg7+QkDZKrY6wur11jwL1Ss8/CzFtAyLunz6eBQRXdg/xlmb/DuqHkqC7ndZofX9CdmMJZgrUIrJkzfuU5/F8ezQckF+rf0Vd1t508eslnS3bhGx1iIvsUff6PWGJRwmya8b0DvJZZkU/dBGEeOGtdHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pg39giArKmljMdgu17iABAbOgEbqTGpw113oWQEBxzw=;
 b=OZef4UZWsr2eCdmcC5dFsvoiYccsM/4ki0M3pIxwOzK0roFHeZPa2bryzsEEQL1bGDjbeD0q60rp1aMc7jYLXR/jkG+5DnqhIa0SI3Cr8UfGJKw0GE1FryaXYcarYPJXdCnlcpEq4ev7Xsd6KeY5kVsj1eUVxjdQI/3fQ+aLnXJxz8wx5JvvBLfSHXPRImtorFYLXvV6E1gHRibyr4QprBjNk5AOkYPnfrTc479UUs9X4ziNM8ZIbS3nKLA4ZKVZ2awEOyo7HxX1LlSXo95tZwQ/OGRxxfljkbbnY6rp+FAgTmEJF9xEbN+FBiQEIrqfR7+5dDZOO70VwtH9mbtoSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pg39giArKmljMdgu17iABAbOgEbqTGpw113oWQEBxzw=;
 b=oYybEDovmnE2Vhb5RHs81MWFNL7VdtVzNT+uQ2K0gamB7a7IhiEsfWmMWWk6EHp6B1k/cUKmaXS9MH1U2RwO5ml4zTGXand/lWx83NQ0x+qS6nNcWL0RILfYSkcmDoH2EFXE6XX1QOh89V1HkmsK1rGLZ4mJnFxkrjogyOmzml4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by PAXPR04MB9422.eurprd04.prod.outlook.com (2603:10a6:102:2b4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.19; Wed, 9 Mar
 2022 17:28:07 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 17:28:07 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 1/8] phy: add support for the Layerscape SerDes 28G
Date:   Wed,  9 Mar 2022 19:27:41 +0200
Message-Id: <20220309172748.3460862-2-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220309172748.3460862-1-ioana.ciornei@nxp.com>
References: <20220309172748.3460862-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR07CA0014.eurprd07.prod.outlook.com
 (2603:10a6:205:1::27) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89034eef-2e2a-4340-e7a5-08da01f22c8b
X-MS-TrafficTypeDiagnostic: PAXPR04MB9422:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB9422740493E2CFDFA217B44AE00A9@PAXPR04MB9422.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GRgAhyi3bSoWsiR0XQ5tusmENAxI/wTyAENntDzlE2QmpMFbNr6phPAcYNuul8+455F4MLBVMLO6kuUrx5sXtWxB7CM7iGqdpUgntyqt4uLv5FXemaYmfiSjM+1MD+pUJH0yd+V3iZz7VPE2hvQyyPXwZQg00bSBM2O1VzOSO/Q5c0A2zb6SWHxppM5VFt9PzZK3YpIMjaTfIt+KKAMnHy6Inc4XgqSRm9yYVclzYu7MLOztci1tfmKCF7Myxso93SvBN89EcQdW4Qhho2RuNSoIgveN2WaYBwdAguFAW2OPlh6nKdro8pRioGzMcpMj+yom/4uyVolWPRJP7ahIvvXy5RxB110YmU+LJp1uvs8Evvf5UTXZqy4gZNqXw45eIs87PCpFu5K5cuys2XTBht3ULO0oJk2pm4KZkA6fqAPPbZchOBT0Knhiqit/h7ZAMRpdiRDDRWUKNV8L5BDvJd9tA09sJmTRs4plCVOPCorG+k3bfYT46NE+BUaJ2NLK8z2r0Jhpn9//d2AYMa3jX8XkwCPWSv1J9M4MJ/6IBsrFPhGOBUrA/44IHOCfif5BGkfPlU6uv/cqrprRgawuSOD5RuBOJY/M9C2H0pZ5j49b9Tou1aXXtkL/I2CISOHrkgMF/HycPOzAHjIrUmm7R7U0vJAEHX0m3SCHUAcBxj90jBJuJqH/3NvwxEfahJh5zj0+mh0jkcNPGwAYYSwgfzyVrIioNfUHIztNCGnhH+N5H77q9L6C1YTpuYzrpU1Cv7nORO+A1dKYxxFHVUabD6MVAym6kAiI69nohdxxkmo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(8936002)(52116002)(2616005)(966005)(6666004)(6512007)(498600001)(6506007)(5660300002)(66946007)(7416002)(36756003)(86362001)(38350700002)(38100700002)(2906002)(1076003)(44832011)(66476007)(66556008)(4326008)(83380400001)(8676002)(30864003)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yzlMJFa+4MfC2D7dYLf7HNM22lw2HGPSqZGJfex77HM79PQYaychO5RT9Kow?=
 =?us-ascii?Q?ykncOdkejvcGcdVR8tWEyvd13h5RpVK61kREk3ITBaGdIe0F2m7T4B6LQJgf?=
 =?us-ascii?Q?an+k9OHiwhiircAfIvBWZUQddqXSTEucZ/kx/55SJcEPtvXHMBOLdLR4Bb/h?=
 =?us-ascii?Q?HpcHWOS6BwsoQDAzedyljN37a0ztQJrfY1WtXoDgGnytFMOqQz2jiRdA60Y4?=
 =?us-ascii?Q?RHjj1jbKEOY+ytsuGc5BYuYEUha685+1kS8YF4CBniwXhXRkQaDOgyUS8l8m?=
 =?us-ascii?Q?9AzKxeHH/itb3XKzAZeXS3hQMC+kIGNNaQW/YEhzD7RRHdYGyx7RG01i1oKI?=
 =?us-ascii?Q?/UVh7t1zILrFK3MKfED1G745y77zBOlzyDGi0pQeLAKbZhyY+hyP6KjV75rw?=
 =?us-ascii?Q?GKrqKe1OEOat23u0RoVLNkC9n7QEmAHWYtuQMr/UqD8mmegReADP6/9uY3VN?=
 =?us-ascii?Q?t1kIpk9tj3Vd3XJdKtIgMHRyjBorZKOQwwYLI2x8M9lPUOmYz1a51L1G4pYh?=
 =?us-ascii?Q?9tS8ooBwfWUlub01HtHJ0xw1u7QyRfxv9X7A9oPNIxtlIYrtBYYUAFpJz8X8?=
 =?us-ascii?Q?BJoHpUVfyB6aqJBMRf6ghtBbmr3JXu/G/xdqLc+o0LSBzShaU95Z8joUzEn0?=
 =?us-ascii?Q?U2oq5oAl/zFaX3spunyivuRvXMLi/oI+/ts4Tk6uLsM2pBSyjMJ/+ZimUjoQ?=
 =?us-ascii?Q?oWpD53AmnrbEVhISpeuTcrkU/Qj2fAwgQsLbLPdvEHxb8YcGCNoUnWACC0As?=
 =?us-ascii?Q?RAswy+RKZ6LyS/12EOGGKZbGOhuSXgrE4VBOd4/nilg1PleTBNAr96w0y6Jz?=
 =?us-ascii?Q?uoeLNJH7Tj6FIXGmJm3KV4pgmiYZ0DGwENCx6ASOgP52xsfQwJ6F6KnfttpV?=
 =?us-ascii?Q?+eAAiCFRfb40AlW6AQ3M1spJ+3zfRjMGrmUAK/iL9dyve0H5HpFPhAnvRHYT?=
 =?us-ascii?Q?8aLqhIyM+oVTwiXFgzyvGAVN7FQ/KBcgt1YE6HkKJ8ZEssWS45L1XMhydMSk?=
 =?us-ascii?Q?s3zx6E0G3DRLg7IV8ZRTsobe2+cTTKHPAYn62FRsj5N0eEU7zKQjrl7QFjTe?=
 =?us-ascii?Q?KPOvPLZfX6mkUzjJ5DjpHdHek1wYbitEFoKCrjeh3BzhLJFNDv7V1I5Chhxi?=
 =?us-ascii?Q?Z4CrxtB5Y02aU6imQ4fHuS4liZJBOQcLOIAUs1YwoFaMXI2uLWQio9/ia1Vh?=
 =?us-ascii?Q?B3hbhcJYFFuTqEYStoCt/0gQW287LSQKAu5Pvg95ulw1Wpl9wKXf7AXLHoWK?=
 =?us-ascii?Q?TlCge4x7v3oZqapEWsvu5i1blQZdMJpLsh26ezqsqDCOhoHuFlOhxWPZxz4A?=
 =?us-ascii?Q?CjZJPgptW30MLtHNpQaPYsQhxAKo1mDPPiIYXwkEAFjSJvEWVM25Y1jTHgJ7?=
 =?us-ascii?Q?LvfR8IG14iz445wSxTNVad/sQhkwAbpYliXP0Vcrb6jsqQcIoHCXVDei5pIW?=
 =?us-ascii?Q?uRxEu9ystyBwvvRxVMKbo8bMIx6IR8lU3wncNde1iYaDqd3Rh6v1/DpPR59I?=
 =?us-ascii?Q?piqJAmRVlS+jAPqw1648nldZPdhmD6cPYRReMiaUUtimjwOBdzSMX1jEb6wC?=
 =?us-ascii?Q?Z+1cvMwA5KD221dh3oY7Y638KG0n41LH+GCAa7ZW8vJPSW2tlOceGV6sPcPT?=
 =?us-ascii?Q?H6yt5deq59+AlOLOXlQiqqM=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89034eef-2e2a-4340-e7a5-08da01f22c8b
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 17:28:07.2830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +qvenWTxKH1u1skv0vvL5guyD4pKivtBfEwktDdF2Hnh8axTgNWTZJe9Fa14q/OD6P53px04XS2HghBji7elsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9422
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a new generic PHY driver to support the Lynx 28G SerDes
block found on some of the Layerscape SoCs such as LX2160A.
At the moment, only the following Ethernet protocols are supported:
SGMII/1000Base-X and 10GBaseR.

SerDes lanes which are not running an Ethernet protocol or a currently
supported Ethenet protocol will be left as it was configured through the
RCW (Reset Configuration Word) at boot time.

At probe time, the platform driver will read the current
configuration of both PLLs found on a SerDes block and will determine
what protocols are supported using that PLL.

For example, if a PLL is configured to generate a clock net (frate) of
5GHz the only protocols sustained by that PLL are SGMII/1000Base-X
(using a quarter of the full clock rate) and QSGMII using the full clock
net frequency on the lane.

On the .set_mode() callback, the PHY driver will first check if the
requested operating mode (protocol) is even supported by the current PLL
configuration and will error out if not.
Then, the lane is reconfigured to run on the requested protocol.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
	- add MODULE_LICENSE

 MAINTAINERS                              |   6 +
 drivers/phy/freescale/Kconfig            |  10 +
 drivers/phy/freescale/Makefile           |   1 +
 drivers/phy/freescale/phy-fsl-lynx-28g.c | 630 +++++++++++++++++++++++
 4 files changed, 647 insertions(+)
 create mode 100644 drivers/phy/freescale/phy-fsl-lynx-28g.c

diff --git a/MAINTAINERS b/MAINTAINERS
index cb75c5d6d78b..dd42305b050c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11336,6 +11336,12 @@ S:	Maintained
 W:	http://linux-test-project.github.io/
 T:	git git://github.com/linux-test-project/ltp.git
 
+LYNX 28G SERDES PHY DRIVER
+M:	Ioana Ciornei <ioana.ciornei@nxp.com>
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	drivers/phy/freescale/phy-fsl-lynx-28g.c
+
 LYNX PCS MODULE
 M:	Ioana Ciornei <ioana.ciornei@nxp.com>
 L:	netdev@vger.kernel.org
diff --git a/drivers/phy/freescale/Kconfig b/drivers/phy/freescale/Kconfig
index c3669c28ea9f..0e91cd99c36b 100644
--- a/drivers/phy/freescale/Kconfig
+++ b/drivers/phy/freescale/Kconfig
@@ -22,3 +22,13 @@ config PHY_FSL_IMX8M_PCIE
 	help
 	  Enable this to add support for the PCIE PHY as found on
 	  i.MX8M family of SOCs.
+
+config PHY_FSL_LYNX_28G
+	tristate "Freescale Layerscape Lynx 28G SerDes PHY support"
+	depends on OF
+	select GENERIC_PHY
+	help
+	  Enable this to add support for the Lynx SerDes 28G PHY as
+	  found on NXP's Layerscape platforms such as LX2160A.
+	  Used to change the protocol running on SerDes lanes at runtime.
+	  Only useful for a restricted set of Ethernet protocols.
diff --git a/drivers/phy/freescale/Makefile b/drivers/phy/freescale/Makefile
index 55d07c742ab0..3518d5dbe8a7 100644
--- a/drivers/phy/freescale/Makefile
+++ b/drivers/phy/freescale/Makefile
@@ -2,3 +2,4 @@
 obj-$(CONFIG_PHY_FSL_IMX8MQ_USB)	+= phy-fsl-imx8mq-usb.o
 obj-$(CONFIG_PHY_MIXEL_MIPI_DPHY)	+= phy-fsl-imx8-mipi-dphy.o
 obj-$(CONFIG_PHY_FSL_IMX8M_PCIE)	+= phy-fsl-imx8m-pcie.o
+obj-$(CONFIG_PHY_FSL_LYNX_28G)		+= phy-fsl-lynx-28g.o
diff --git a/drivers/phy/freescale/phy-fsl-lynx-28g.c b/drivers/phy/freescale/phy-fsl-lynx-28g.c
new file mode 100644
index 000000000000..015194c67ffc
--- /dev/null
+++ b/drivers/phy/freescale/phy-fsl-lynx-28g.c
@@ -0,0 +1,630 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Copyright (c) 2021-2022 NXP. */
+
+#include <linux/module.h>
+#include <linux/phy.h>
+#include <linux/phy/phy.h>
+#include <linux/platform_device.h>
+#include <linux/workqueue.h>
+#include <linux/workqueue.h>
+
+#define LYNX_28G_NUM_LANE			8
+#define LYNX_28G_NUM_PLL			2
+
+/* General registers per SerDes block */
+#define LYNX_28G_PCC8				0x10a0
+#define LYNX_28G_PCC8_SGMII			0x1
+#define LYNX_28G_PCC8_SGMII_DIS			0x0
+
+#define LYNX_28G_PCCC				0x10b0
+#define LYNX_28G_PCCC_10GBASER			0x9
+#define LYNX_28G_PCCC_USXGMII			0x1
+#define LYNX_28G_PCCC_SXGMII_DIS		0x0
+
+#define LYNX_28G_LNa_PCC_OFFSET(lane)		(4 * (LYNX_28G_NUM_LANE - (lane->id) - 1))
+
+/* Per PLL registers */
+#define LYNX_28G_PLLnRSTCTL(pll)		(0x400 + (pll) * 0x100 + 0x0)
+#define LYNX_28G_PLLnRSTCTL_DIS(rstctl)		(((rstctl) & BIT(24)) >> 24)
+#define LYNX_28G_PLLnRSTCTL_LOCK(rstctl)	(((rstctl) & BIT(23)) >> 23)
+
+#define LYNX_28G_PLLnCR0(pll)			(0x400 + (pll) * 0x100 + 0x4)
+#define LYNX_28G_PLLnCR0_REFCLK_SEL(cr0)	(((cr0) & GENMASK(20, 16)))
+#define LYNX_28G_PLLnCR0_REFCLK_SEL_100MHZ	0x0
+#define LYNX_28G_PLLnCR0_REFCLK_SEL_125MHZ	0x10000
+#define LYNX_28G_PLLnCR0_REFCLK_SEL_156MHZ	0x20000
+#define LYNX_28G_PLLnCR0_REFCLK_SEL_150MHZ	0x30000
+#define LYNX_28G_PLLnCR0_REFCLK_SEL_161MHZ	0x40000
+
+#define LYNX_28G_PLLnCR1(pll)			(0x400 + (pll) * 0x100 + 0x8)
+#define LYNX_28G_PLLnCR1_FRATE_SEL(cr1)		(((cr1) & GENMASK(28, 24)))
+#define LYNX_28G_PLLnCR1_FRATE_5G_10GVCO	0x0
+#define LYNX_28G_PLLnCR1_FRATE_5G_25GVCO	0x10000000
+#define LYNX_28G_PLLnCR1_FRATE_10G_20GVCO	0x6000000
+
+/* Per SerDes lane registers */
+/* Lane a General Control Register */
+#define LYNX_28G_LNaGCR0(lane)			(0x800 + (lane) * 0x100 + 0x0)
+#define LYNX_28G_LNaGCR0_PROTO_SEL_MSK		GENMASK(7, 3)
+#define LYNX_28G_LNaGCR0_PROTO_SEL_SGMII	0x8
+#define LYNX_28G_LNaGCR0_PROTO_SEL_XFI		0x50
+#define LYNX_28G_LNaGCR0_IF_WIDTH_MSK		GENMASK(2, 0)
+#define LYNX_28G_LNaGCR0_IF_WIDTH_10_BIT	0x0
+#define LYNX_28G_LNaGCR0_IF_WIDTH_20_BIT	0x2
+
+/* Lane a Tx Reset Control Register */
+#define LYNX_28G_LNaTRSTCTL(lane)		(0x800 + (lane) * 0x100 + 0x20)
+#define LYNX_28G_LNaTRSTCTL_HLT_REQ		BIT(27)
+#define LYNX_28G_LNaTRSTCTL_RST_DONE		BIT(30)
+#define LYNX_28G_LNaTRSTCTL_RST_REQ		BIT(31)
+
+/* Lane a Tx General Control Register */
+#define LYNX_28G_LNaTGCR0(lane)			(0x800 + (lane) * 0x100 + 0x24)
+#define LYNX_28G_LNaTGCR0_USE_PLLF		0x0
+#define LYNX_28G_LNaTGCR0_USE_PLLS		BIT(28)
+#define LYNX_28G_LNaTGCR0_USE_PLL_MSK		BIT(28)
+#define LYNX_28G_LNaTGCR0_N_RATE_FULL		0x0
+#define LYNX_28G_LNaTGCR0_N_RATE_HALF		0x1000000
+#define LYNX_28G_LNaTGCR0_N_RATE_QUARTER	0x2000000
+#define LYNX_28G_LNaTGCR0_N_RATE_MSK		GENMASK(26, 24)
+
+#define LYNX_28G_LNaTECR0(lane)			(0x800 + (lane) * 0x100 + 0x30)
+
+/* Lane a Rx Reset Control Register */
+#define LYNX_28G_LNaRRSTCTL(lane)		(0x800 + (lane) * 0x100 + 0x40)
+#define LYNX_28G_LNaRRSTCTL_HLT_REQ		BIT(27)
+#define LYNX_28G_LNaRRSTCTL_RST_DONE		BIT(30)
+#define LYNX_28G_LNaRRSTCTL_RST_REQ		BIT(31)
+#define LYNX_28G_LNaRRSTCTL_CDR_LOCK		BIT(12)
+
+/* Lane a Rx General Control Register */
+#define LYNX_28G_LNaRGCR0(lane)			(0x800 + (lane) * 0x100 + 0x44)
+#define LYNX_28G_LNaRGCR0_USE_PLLF		0x0
+#define LYNX_28G_LNaRGCR0_USE_PLLS		BIT(28)
+#define LYNX_28G_LNaRGCR0_USE_PLL_MSK		BIT(28)
+#define LYNX_28G_LNaRGCR0_N_RATE_MSK		GENMASK(26, 24)
+#define LYNX_28G_LNaRGCR0_N_RATE_FULL		0x0
+#define LYNX_28G_LNaRGCR0_N_RATE_HALF		0x1000000
+#define LYNX_28G_LNaRGCR0_N_RATE_QUARTER	0x2000000
+#define LYNX_28G_LNaRGCR0_N_RATE_MSK		GENMASK(26, 24)
+
+#define LYNX_28G_LNaRGCR1(lane)			(0x800 + (lane) * 0x100 + 0x48)
+
+#define LYNX_28G_LNaRECR0(lane)			(0x800 + (lane) * 0x100 + 0x50)
+#define LYNX_28G_LNaRECR1(lane)			(0x800 + (lane) * 0x100 + 0x54)
+#define LYNX_28G_LNaRECR2(lane)			(0x800 + (lane) * 0x100 + 0x58)
+
+#define LYNX_28G_LNaRSCCR0(lane)		(0x800 + (lane) * 0x100 + 0x74)
+
+#define LYNX_28G_LNaPSS(lane)			(0x1000 + (lane) * 0x4)
+#define LYNX_28G_LNaPSS_TYPE(pss)		(((pss) & GENMASK(30, 24)) >> 24)
+#define LYNX_28G_LNaPSS_TYPE_SGMII		0x4
+#define LYNX_28G_LNaPSS_TYPE_XFI		0x28
+
+#define LYNX_28G_SGMIIaCR1(lane)		(0x1804 + (lane) * 0x10)
+#define LYNX_28G_SGMIIaCR1_SGPCS_EN		BIT(11)
+#define LYNX_28G_SGMIIaCR1_SGPCS_DIS		0x0
+#define LYNX_28G_SGMIIaCR1_SGPCS_MSK		BIT(11)
+
+struct lynx_28g_priv;
+
+struct lynx_28g_pll {
+	struct lynx_28g_priv *priv;
+	u32 rstctl, cr0, cr1;
+	int id;
+	DECLARE_PHY_INTERFACE_MASK(supported);
+};
+
+struct lynx_28g_lane {
+	struct lynx_28g_priv *priv;
+	bool powered_up;
+	bool init;
+	unsigned int id;
+	phy_interface_t interface;
+};
+
+struct lynx_28g_priv {
+	void __iomem *base;
+	struct device *dev;
+	struct lynx_28g_pll pll[LYNX_28G_NUM_PLL];
+
+	int num_lanes;
+	struct lynx_28g_lane lane[LYNX_28G_NUM_LANE];
+
+	struct delayed_work cdr_check;
+};
+
+static void lynx_28g_rmw(struct lynx_28g_priv *priv, unsigned long off,
+			 u32 val, u32 mask)
+{
+	void __iomem *reg = priv->base + off;
+	u32 orig, tmp;
+
+	orig = ioread32(reg);
+	tmp = orig & ~mask;
+	tmp |= val;
+	iowrite32(tmp, reg);
+}
+
+#define lynx_28g_lane_rmw(lane, reg, val, mask)	\
+	lynx_28g_rmw((lane)->priv, LYNX_28G_##reg(lane->id), \
+		     LYNX_28G_##reg##_##val, LYNX_28G_##reg##_##mask)
+#define lynx_28g_lane_read(lane, reg)			\
+	ioread32((lane)->priv->base + LYNX_28G_##reg((lane)->id))
+#define lynx_28g_pll_read(pll, reg)			\
+	ioread32((pll)->priv->base + LYNX_28G_##reg((pll)->id))
+
+static bool lynx_28g_supports_interface(struct lynx_28g_priv *priv, int intf)
+{
+	int i;
+
+	for (i = 0; i < LYNX_28G_NUM_PLL; i++) {
+		if (LYNX_28G_PLLnRSTCTL_DIS(priv->pll[i].rstctl))
+			continue;
+
+		if (test_bit(intf, priv->pll[i].supported))
+			return true;
+	}
+
+	return false;
+}
+
+static struct lynx_28g_pll *lynx_28g_pll_get(struct lynx_28g_priv *priv,
+					     phy_interface_t intf)
+{
+	struct lynx_28g_pll *pll;
+	int i;
+
+	for (i = 0; i < LYNX_28G_NUM_PLL; i++) {
+		pll = &priv->pll[i];
+
+		if (LYNX_28G_PLLnRSTCTL_DIS(pll->rstctl))
+			continue;
+
+		if (test_bit(intf, pll->supported))
+			return pll;
+	}
+
+	return NULL;
+}
+
+static void lynx_28g_lane_set_nrate(struct lynx_28g_lane *lane,
+				    struct lynx_28g_pll *pll,
+				    phy_interface_t intf)
+{
+	switch (LYNX_28G_PLLnCR1_FRATE_SEL(pll->cr1)) {
+	case LYNX_28G_PLLnCR1_FRATE_5G_10GVCO:
+	case LYNX_28G_PLLnCR1_FRATE_5G_25GVCO:
+		switch (intf) {
+		case PHY_INTERFACE_MODE_SGMII:
+		case PHY_INTERFACE_MODE_1000BASEX:
+			lynx_28g_lane_rmw(lane, LNaTGCR0, N_RATE_QUARTER, N_RATE_MSK);
+			lynx_28g_lane_rmw(lane, LNaRGCR0, N_RATE_QUARTER, N_RATE_MSK);
+			break;
+		default:
+			break;
+		}
+		break;
+	case LYNX_28G_PLLnCR1_FRATE_10G_20GVCO:
+		switch (intf) {
+		case PHY_INTERFACE_MODE_10GBASER:
+		case PHY_INTERFACE_MODE_USXGMII:
+			lynx_28g_lane_rmw(lane, LNaTGCR0, N_RATE_FULL, N_RATE_MSK);
+			lynx_28g_lane_rmw(lane, LNaRGCR0, N_RATE_FULL, N_RATE_MSK);
+			break;
+		default:
+			break;
+		}
+		break;
+	default:
+		break;
+	}
+}
+
+static void lynx_28g_lane_set_pll(struct lynx_28g_lane *lane,
+				  struct lynx_28g_pll *pll)
+{
+	if (pll->id == 0) {
+		lynx_28g_lane_rmw(lane, LNaTGCR0, USE_PLLF, USE_PLL_MSK);
+		lynx_28g_lane_rmw(lane, LNaRGCR0, USE_PLLF, USE_PLL_MSK);
+	} else {
+		lynx_28g_lane_rmw(lane, LNaTGCR0, USE_PLLS, USE_PLL_MSK);
+		lynx_28g_lane_rmw(lane, LNaRGCR0, USE_PLLS, USE_PLL_MSK);
+	}
+}
+
+static void lynx_28g_cleanup_lane(struct lynx_28g_lane *lane)
+{
+	u32 lane_offset = LYNX_28G_LNa_PCC_OFFSET(lane);
+	struct lynx_28g_priv *priv = lane->priv;
+
+	/* Cleanup the protocol configuration registers of the current protocol */
+	switch (lane->interface) {
+	case PHY_INTERFACE_MODE_10GBASER:
+		lynx_28g_rmw(priv, LYNX_28G_PCCC,
+			     LYNX_28G_PCCC_SXGMII_DIS << lane_offset,
+			     GENMASK(3, 0) << lane_offset);
+		break;
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_1000BASEX:
+		lynx_28g_rmw(priv, LYNX_28G_PCC8,
+			     LYNX_28G_PCC8_SGMII_DIS << lane_offset,
+			     GENMASK(3, 0) << lane_offset);
+		break;
+	default:
+		break;
+	}
+}
+
+static void lynx_28g_lane_set_sgmii(struct lynx_28g_lane *lane)
+{
+	u32 lane_offset = LYNX_28G_LNa_PCC_OFFSET(lane);
+	struct lynx_28g_priv *priv = lane->priv;
+	struct lynx_28g_pll *pll;
+
+	lynx_28g_cleanup_lane(lane);
+
+	/* Setup the lane to run in SGMII */
+	lynx_28g_rmw(priv, LYNX_28G_PCC8,
+		     LYNX_28G_PCC8_SGMII << lane_offset,
+		     GENMASK(3, 0) << lane_offset);
+
+	/* Setup the protocol select and SerDes parallel interface width */
+	lynx_28g_lane_rmw(lane, LNaGCR0, PROTO_SEL_SGMII, PROTO_SEL_MSK);
+	lynx_28g_lane_rmw(lane, LNaGCR0, IF_WIDTH_10_BIT, IF_WIDTH_MSK);
+
+	/* Switch to the PLL that works with this interface type */
+	pll = lynx_28g_pll_get(priv, PHY_INTERFACE_MODE_SGMII);
+	lynx_28g_lane_set_pll(lane, pll);
+
+	/* Choose the portion of clock net to be used on this lane */
+	lynx_28g_lane_set_nrate(lane, pll, PHY_INTERFACE_MODE_SGMII);
+
+	/* Enable the SGMII PCS */
+	lynx_28g_lane_rmw(lane, SGMIIaCR1, SGPCS_EN, SGPCS_MSK);
+
+	/* Configure the appropriate equalization parameters for the protocol */
+	iowrite32(0x00808006, priv->base + LYNX_28G_LNaTECR0(lane->id));
+	iowrite32(0x04310000, priv->base + LYNX_28G_LNaRGCR1(lane->id));
+	iowrite32(0x9f800000, priv->base + LYNX_28G_LNaRECR0(lane->id));
+	iowrite32(0x001f0000, priv->base + LYNX_28G_LNaRECR1(lane->id));
+	iowrite32(0x00000000, priv->base + LYNX_28G_LNaRECR2(lane->id));
+	iowrite32(0x00000000, priv->base + LYNX_28G_LNaRSCCR0(lane->id));
+}
+
+static void lynx_28g_lane_set_10gbaser(struct lynx_28g_lane *lane)
+{
+	u32 lane_offset = LYNX_28G_LNa_PCC_OFFSET(lane);
+	struct lynx_28g_priv *priv = lane->priv;
+	struct lynx_28g_pll *pll;
+
+	lynx_28g_cleanup_lane(lane);
+
+	/* Enable the SXGMII lane */
+	lynx_28g_rmw(priv, LYNX_28G_PCCC,
+		     LYNX_28G_PCCC_10GBASER << lane_offset,
+		     GENMASK(3, 0) << lane_offset);
+
+	/* Setup the protocol select and SerDes parallel interface width */
+	lynx_28g_lane_rmw(lane, LNaGCR0, PROTO_SEL_XFI, PROTO_SEL_MSK);
+	lynx_28g_lane_rmw(lane, LNaGCR0, IF_WIDTH_20_BIT, IF_WIDTH_MSK);
+
+	/* Switch to the PLL that works with this interface type */
+	pll = lynx_28g_pll_get(priv, PHY_INTERFACE_MODE_10GBASER);
+	lynx_28g_lane_set_pll(lane, pll);
+
+	/* Choose the portion of clock net to be used on this lane */
+	lynx_28g_lane_set_nrate(lane, pll, PHY_INTERFACE_MODE_10GBASER);
+
+	/* Disable the SGMII PCS */
+	lynx_28g_lane_rmw(lane, SGMIIaCR1, SGPCS_DIS, SGPCS_MSK);
+
+	/* Configure the appropriate equalization parameters for the protocol */
+	iowrite32(0x10808307, priv->base + LYNX_28G_LNaTECR0(lane->id));
+	iowrite32(0x10000000, priv->base + LYNX_28G_LNaRGCR1(lane->id));
+	iowrite32(0x00000000, priv->base + LYNX_28G_LNaRECR0(lane->id));
+	iowrite32(0x001f0000, priv->base + LYNX_28G_LNaRECR1(lane->id));
+	iowrite32(0x81000020, priv->base + LYNX_28G_LNaRECR2(lane->id));
+	iowrite32(0x00002000, priv->base + LYNX_28G_LNaRSCCR0(lane->id));
+}
+
+static int lynx_28g_power_off(struct phy *phy)
+{
+	struct lynx_28g_lane *lane = phy_get_drvdata(phy);
+	u32 trstctl, rrstctl;
+
+	if (!lane->powered_up)
+		return 0;
+
+	/* Issue a halt request */
+	lynx_28g_lane_rmw(lane, LNaTRSTCTL, HLT_REQ, HLT_REQ);
+	lynx_28g_lane_rmw(lane, LNaRRSTCTL, HLT_REQ, HLT_REQ);
+
+	/* Wait until the halting process is complete */
+	do {
+		trstctl = lynx_28g_lane_read(lane, LNaTRSTCTL);
+		rrstctl = lynx_28g_lane_read(lane, LNaRRSTCTL);
+	} while ((trstctl & LYNX_28G_LNaTRSTCTL_HLT_REQ) ||
+		 (rrstctl & LYNX_28G_LNaRRSTCTL_HLT_REQ));
+
+	lane->powered_up = false;
+
+	return 0;
+}
+
+static int lynx_28g_power_on(struct phy *phy)
+{
+	struct lynx_28g_lane *lane = phy_get_drvdata(phy);
+	u32 trstctl, rrstctl;
+
+	if (lane->powered_up)
+		return 0;
+
+	/* Issue a reset request on the lane */
+	lynx_28g_lane_rmw(lane, LNaTRSTCTL, RST_REQ, RST_REQ);
+	lynx_28g_lane_rmw(lane, LNaRRSTCTL, RST_REQ, RST_REQ);
+
+	/* Wait until the reset sequence is completed */
+	do {
+		trstctl = lynx_28g_lane_read(lane, LNaTRSTCTL);
+		rrstctl = lynx_28g_lane_read(lane, LNaRRSTCTL);
+	} while (!(trstctl & LYNX_28G_LNaTRSTCTL_RST_DONE) ||
+		 !(rrstctl & LYNX_28G_LNaRRSTCTL_RST_DONE));
+
+	lane->powered_up = true;
+
+	return 0;
+}
+
+static int lynx_28g_set_mode(struct phy *phy, enum phy_mode mode, int submode)
+{
+	struct lynx_28g_lane *lane = phy_get_drvdata(phy);
+	struct lynx_28g_priv *priv = lane->priv;
+	int powered_up = lane->powered_up;
+	int err = 0;
+
+	if (mode != PHY_MODE_ETHERNET)
+		return -EOPNOTSUPP;
+
+	if (lane->interface == PHY_INTERFACE_MODE_NA)
+		return -EOPNOTSUPP;
+
+	if (!lynx_28g_supports_interface(priv, submode))
+		return -EOPNOTSUPP;
+
+	/* If the lane is powered up, put the lane into the halt state while
+	 * the reconfiguration is being done.
+	 */
+	if (powered_up)
+		lynx_28g_power_off(phy);
+
+	switch (submode) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_1000BASEX:
+		lynx_28g_lane_set_sgmii(lane);
+		break;
+	case PHY_INTERFACE_MODE_10GBASER:
+		lynx_28g_lane_set_10gbaser(lane);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	lane->interface = submode;
+
+out:
+	/* Power up the lane if necessary */
+	if (powered_up)
+		lynx_28g_power_on(phy);
+
+	return err;
+}
+
+static int lynx_28g_validate(struct phy *phy, enum phy_mode mode, int submode,
+			     union phy_configure_opts *opts __always_unused)
+{
+	struct lynx_28g_lane *lane = phy_get_drvdata(phy);
+	struct lynx_28g_priv *priv = lane->priv;
+
+	if (mode != PHY_MODE_ETHERNET)
+		return -EOPNOTSUPP;
+
+	if (!lynx_28g_supports_interface(priv, submode))
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+static int lynx_28g_init(struct phy *phy)
+{
+	struct lynx_28g_lane *lane = phy_get_drvdata(phy);
+
+	/* Mark the fact that the lane was init */
+	lane->init = true;
+
+	/* SerDes lanes are powered on at boot time.  Any lane that is managed
+	 * by this driver will get powered down at init time aka at dpaa2-eth
+	 * probe time.
+	 */
+	lane->powered_up = true;
+	lynx_28g_power_off(phy);
+
+	return 0;
+}
+
+static const struct phy_ops lynx_28g_ops = {
+	.init		= lynx_28g_init,
+	.power_on	= lynx_28g_power_on,
+	.power_off	= lynx_28g_power_off,
+	.set_mode	= lynx_28g_set_mode,
+	.validate	= lynx_28g_validate,
+	.owner		= THIS_MODULE,
+};
+
+static void lynx_28g_pll_read_configuration(struct lynx_28g_priv *priv)
+{
+	struct lynx_28g_pll *pll;
+	int i;
+
+	for (i = 0; i < LYNX_28G_NUM_PLL; i++) {
+		pll = &priv->pll[i];
+		pll->priv = priv;
+		pll->id = i;
+
+		pll->rstctl = lynx_28g_pll_read(pll, PLLnRSTCTL);
+		pll->cr0 = lynx_28g_pll_read(pll, PLLnCR0);
+		pll->cr1 = lynx_28g_pll_read(pll, PLLnCR1);
+
+		if (LYNX_28G_PLLnRSTCTL_DIS(pll->rstctl))
+			continue;
+
+		switch (LYNX_28G_PLLnCR1_FRATE_SEL(pll->cr1)) {
+		case LYNX_28G_PLLnCR1_FRATE_5G_10GVCO:
+		case LYNX_28G_PLLnCR1_FRATE_5G_25GVCO:
+			/* 5GHz clock net */
+			__set_bit(PHY_INTERFACE_MODE_1000BASEX, pll->supported);
+			__set_bit(PHY_INTERFACE_MODE_SGMII, pll->supported);
+			break;
+		case LYNX_28G_PLLnCR1_FRATE_10G_20GVCO:
+			/* 10.3125GHz clock net */
+			__set_bit(PHY_INTERFACE_MODE_10GBASER, pll->supported);
+			break;
+		default:
+			/* 6GHz, 12.890625GHz, 8GHz */
+			break;
+		}
+	}
+}
+
+#define work_to_lynx(w) container_of((w), struct lynx_28g_priv, cdr_check.work)
+
+static void lynx_28g_cdr_lock_check(struct work_struct *work)
+{
+	struct lynx_28g_priv *priv = work_to_lynx(work);
+	struct lynx_28g_lane *lane;
+	u32 rrstctl;
+	int i;
+
+	for (i = 0; i < priv->num_lanes; i++) {
+		lane = &priv->lane[i];
+
+		if (!lane->init)
+			continue;
+
+		if (!lane->powered_up)
+			continue;
+
+		rrstctl = lynx_28g_lane_read(lane, LNaRRSTCTL);
+		if (!(rrstctl & LYNX_28G_LNaRRSTCTL_CDR_LOCK)) {
+			lynx_28g_lane_rmw(lane, LNaRRSTCTL, RST_REQ, RST_REQ);
+			do {
+				rrstctl = lynx_28g_lane_read(lane, LNaRRSTCTL);
+			} while (!(rrstctl & LYNX_28G_LNaRRSTCTL_RST_DONE));
+		}
+	}
+	queue_delayed_work(system_power_efficient_wq, &priv->cdr_check,
+			   msecs_to_jiffies(1000));
+}
+
+static void lynx_28g_lane_read_configuration(struct lynx_28g_lane *lane)
+{
+	u32 pss, protocol;
+
+	pss = lynx_28g_lane_read(lane, LNaPSS);
+	protocol = LYNX_28G_LNaPSS_TYPE(pss);
+	switch (protocol) {
+	case LYNX_28G_LNaPSS_TYPE_SGMII:
+		lane->interface = PHY_INTERFACE_MODE_SGMII;
+		break;
+	case LYNX_28G_LNaPSS_TYPE_XFI:
+		lane->interface = PHY_INTERFACE_MODE_10GBASER;
+		break;
+	default:
+		lane->interface = PHY_INTERFACE_MODE_NA;
+	}
+}
+
+static int lynx_28g_probe(struct platform_device *pdev)
+{
+	struct phy_provider *provider;
+	struct lynx_28g_priv *priv;
+	struct device_node *child;
+	int err, i = 0;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+	priv->dev = &pdev->dev;
+
+	priv->base = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(priv->base))
+		return PTR_ERR(priv->base);
+
+	lynx_28g_pll_read_configuration(priv);
+
+	for_each_available_child_of_node(pdev->dev.of_node, child) {
+		struct lynx_28g_lane *lane;
+		struct phy *phy;
+		u32 val;
+
+		err = of_property_read_u32(child, "reg", &val);
+		if (err < 0) {
+			dev_err(&pdev->dev, "missing 'reg' property (%d)\n", err);
+			continue;
+		}
+
+		if (val >= LYNX_28G_NUM_LANE) {
+			dev_err(&pdev->dev, "invalid 'reg' property\n");
+			continue;
+		}
+
+		lane = &priv->lane[i];
+		memset(lane, 0, sizeof(*lane));
+
+		phy = devm_phy_create(&pdev->dev, child, &lynx_28g_ops);
+		if (IS_ERR(phy)) {
+			of_node_put(child);
+			return PTR_ERR(phy);
+		}
+
+		lane->priv = priv;
+		lane->id = val;
+		phy_set_drvdata(phy, lane);
+		i++;
+
+		lynx_28g_lane_read_configuration(lane);
+	}
+
+	priv->num_lanes = i;
+
+	INIT_DELAYED_WORK(&priv->cdr_check, lynx_28g_cdr_lock_check);
+
+	queue_delayed_work(system_power_efficient_wq, &priv->cdr_check,
+			   msecs_to_jiffies(1000));
+
+	dev_set_drvdata(&pdev->dev, priv);
+	provider = devm_of_phy_provider_register(&pdev->dev,
+						 of_phy_simple_xlate);
+
+	return PTR_ERR_OR_ZERO(provider);
+}
+
+static const struct of_device_id lynx_28g_of_match_table[] = {
+	{ .compatible = "fsl,lynx-28g" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, lynx_28g_of_match_table);
+
+static struct platform_driver lynx_28g_driver = {
+	.probe	= lynx_28g_probe,
+	.driver	= {
+		.name = "lynx-28g",
+		.of_match_table = lynx_28g_of_match_table,
+	},
+};
+module_platform_driver(lynx_28g_driver);
+
+MODULE_AUTHOR("Ioana Ciornei <ioana.ciornei@nxp.com>");
+MODULE_DESCRIPTION("Lynx 28G SerDes PHY driver for Layerscape SoCs");
+MODULE_LICENSE("GPL v2");
-- 
2.33.1

