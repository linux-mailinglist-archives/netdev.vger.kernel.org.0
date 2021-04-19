Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D235636480D
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 18:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238800AbhDSQRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 12:17:23 -0400
Received: from mail-eopbgr70040.outbound.protection.outlook.com ([40.107.7.40]:40420
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238601AbhDSQRL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 12:17:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OxH3jad3nqBrL9x05tpQRbdFMuGUX/oIvxs8J+IXDsE/om1z912xBbi5YNpFGr+hbxH8tt0qdZ6biRbPZbnY6XclBC8KylYHsxlYJYBBvebLqDGXzQyBhUM7Nmq+eWj9C6/o9jyEQo2n6nEdUHeY93GgKIZwvHmQCZoWiPiNXQtIif2vA+YIWCglmkazND++NZ6S0Jmn+D2xZmMBh3WIBV6Qtdym7KKjNENcGmDTXpc9f8Ux3V/KA8QB6o1CvmAHpmY99nLF7bxL9H7zVFGVjMhifdKFuGkWCIWbsoZ/uytQSam2edoWXdICQvPWfCyBIH2ERf8SmJhLJgkEi6NxTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PiAE48TGp4QF2gaboCCNQn9dWyITlkPJp444FB4mMnM=;
 b=A54MjbZVAogt9aAiWCizdRVf6+DK1KRFIktz9WEDHg+Zdw0JuZr6j3XmgQYnR2aajkCtoRGZnK4uIKRhTA3x8jE6IycGzqsXVZAS8N65LPNuxgWLcPHqdT2WkDxn0OcduiMb8orHAo7EQCNd9vNq0132isXDv5FvMtd6vT4XrL7Xeio/SIWA9pKwBe3CbTbMFxghzOUNEtXV+Zj5N/3hgTIh7z9EyrdC0jXMviVoWfOJcZI6e7N64ld7hmjv94ULExvEeQm6yy9OTf5vygXWlM0aPXZc4fZ4nO7YfwuRrupuuDCMoR/s3tyE3DZzKtb5QWKYR+5IQ8IhiApDcSi28A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PiAE48TGp4QF2gaboCCNQn9dWyITlkPJp444FB4mMnM=;
 b=RDJS9bigKfvqEv0fg6VTHSdNodaMJ7PGlSmXL+DtuLlCAVCP3EY8YWsAXGG6fMc1LH7vlUtibEQnsn4nCLj+95FUBVga6mIMHbrdSpXK7zxT/R/R6d6tnZcyufTFvHqqcHw1nnoy8RI+wnaJVl2Q7DKM4bU4WvPo3WjFRCb7fKQ=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com (2603:10a6:803:5f::31)
 by VI1PR04MB7102.eurprd04.prod.outlook.com (2603:10a6:800:124::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.21; Mon, 19 Apr
 2021 16:16:34 +0000
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945]) by VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945%6]) with mapi id 15.20.4042.024; Mon, 19 Apr 2021
 16:16:33 +0000
From:   "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH v3 2/2] phy: nxp-c45: add driver for tja1103
Date:   Mon, 19 Apr 2021 19:14:00 +0300
Message-Id: <20210419161400.260703-3-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419161400.260703-1-radu-nicolae.pirea@oss.nxp.com>
References: <20210419161400.260703-1-radu-nicolae.pirea@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [89.45.21.213]
X-ClientProxiedBy: VI1PR08CA0198.eurprd08.prod.outlook.com
 (2603:10a6:800:d2::28) To VI1PR04MB5101.eurprd04.prod.outlook.com
 (2603:10a6:803:5f::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (89.45.21.213) by VI1PR08CA0198.eurprd08.prod.outlook.com (2603:10a6:800:d2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Mon, 19 Apr 2021 16:16:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 020dc715-c744-47b2-6be7-08d9034e7fd2
X-MS-TrafficTypeDiagnostic: VI1PR04MB7102:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB7102CCFB36056B359CA796449F499@VI1PR04MB7102.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4MJg3KEorc5Flqdj6bq//EQu8GDHXseKQ86Li0dKlXGrB1J1VfqewI+9DAYdRpIGTlU7vvy+wqJLF9RKmlGIPritLKDXQK08r5NMiVE67YhEglnBq92VbgJGh2zULQ01GLIpyPMMCUXeZuqCGFHOmwe3+/lhVK3eJNA4swKCJSvdSqAzIYaVgKvNmpdztGIdqLUBUhi9CzQRoEi3ZZUnAgWKJuyqd7qu+XnqCsjT0oQyovwVxiCXKmEktSlhb6vUQucLzNYOdKjigywcAdn9h36UDtm6ID36uQJebAfnodM7Pm9+QvPuAETyIplXWfZy/AsbkC2lH99OQyBnzIokg47iMnc6JMXQVnFVWU13sScYIy8wJFZhKUkD1IkoyvcwYdUNyf7zDWbfvvb/ord65d7HPwTIe4BSMh8fmKLQ8DI8C4z4Dezvg+y/mW/6UYUQAjYAtuLxPmG6q/5jmCYcQQ5AeGcRLAXr5B3lXzmK+ihIBFRtjP1USlL2AgCbiTALS22cFqRluq3re/mbWa2fFb725zFBNOy9UzwbvAEFDtGsZ3nCxQezl6rH6CxIx3o505AsiGxyDkcCU4JJhcnWU0kTLBj6QtQPz/YBhNszMSUnBJ5KlWpDe4Mdy2xqwH3/PZas0VSPvuPLco9Vt4SABWdq6SgJn7Wf1RtImXv6z3IT80vf2HcqHLwu4E1VaIC+3pZpi852G3KN0sncG4UKVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5101.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(366004)(39850400004)(396003)(956004)(38100700002)(5660300002)(6506007)(8936002)(4326008)(1076003)(83380400001)(6666004)(66946007)(38350700002)(2906002)(6486002)(30864003)(66476007)(186003)(8676002)(6512007)(316002)(2616005)(52116002)(86362001)(16526019)(26005)(66556008)(478600001)(69590400013)(41350200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?GYZv27C2NRN0Zb1XPmobafycNHryNxUm1PduxxhxwCHDwdPj5Y/9lPD6psIl?=
 =?us-ascii?Q?xz0gSSs+IHUqAtxzujQksj0eY+OIF0rXdW27Ofl+CKQInTujhbV1ceGQrcMt?=
 =?us-ascii?Q?s7oj7Dr9fefsqF7fNG13THKdcxHA5zcuoSqlopXjVPcMs/B+3A0+JP2O8jil?=
 =?us-ascii?Q?XGTNnlYoYDmqW38M1Z2R4uDOqgMB4e8SbTlDFYiKa/zJ6Scx2A5YCAKSj0iT?=
 =?us-ascii?Q?N3cEKvW19Zoef76llYRWTlgKsoa7TuPC2SBHOLGjchIInv4RC1XaMPBgjf8q?=
 =?us-ascii?Q?PINAahJdNXF0Xuc/DlOE1VlSTPMDcVNrKoFkm0RnsQttmK8FtQM6OM9jT0Kf?=
 =?us-ascii?Q?1I5PlOegxOa6a8CDv3qzcOE4qxuKyyxJ3iDzic4SZy+RoWCVtHEp6aIr/yYF?=
 =?us-ascii?Q?L1J+N1QxnwOQgoG8jPK4ptEnJGT4S5b0JRi2dKZ4pcJ3mNqFjTPjLZJbfdbi?=
 =?us-ascii?Q?5uYIIrMaFt5JA0NtqGeABXZmiJiM8p+5Jr3pIZHNcTslzqOF+VITmjRUmQl8?=
 =?us-ascii?Q?Ka8ZzLemughDBFP6FH5pNLTEYO/R/EzTYCuHgcp0B9jYW3FxG7nus+wefRwl?=
 =?us-ascii?Q?9m/EIq4F5fCAHzilKgtUTJPzrG/pFR9j/eBq1VnPyFGwA/MYYUZ4hAViSwHo?=
 =?us-ascii?Q?LU2G99VzPm6CzSeOJ2s5EI3wlYEaiyG00FaJmldSyGDU4C+JT8n51TnG0sO8?=
 =?us-ascii?Q?tlX9SLwJ4+miA4lrRRHTQPtAaiqxgS2wCgPW7/WDqqTIW8MwVMNGnSbobYxw?=
 =?us-ascii?Q?UO+Eu+ErXKsQ5OUAFspPQJCKYz/K53uA8Zdlp+41l6b9UefOp5JX3Sd9jrZZ?=
 =?us-ascii?Q?huPAn/hMoE9g9DFsiPWKoZAsFQOVf/xQcjfhYllQtnvxtd5iyxlcJv06Or2s?=
 =?us-ascii?Q?N1cWPKOsc09e3oun6j2dwhjSxJmZeqEHWVHU/lFVz58krHbQno8K4a8PIy8G?=
 =?us-ascii?Q?+GMMAw8s6K0m1HIKhvJ4fru8FkEkL8u7+w+VgV2OiohvLfKF+lcGrbP7m/fj?=
 =?us-ascii?Q?4L695P6mOPmCMO+azJar2Wv5vsyoSsuz1ShYBGEbw231vMJury20UpeoD0Rv?=
 =?us-ascii?Q?kyPnGjnhwcCw+9Fs/h8Rqlptla/XeE4DN4B3ymP67wttmFdJTIH/BrlevT51?=
 =?us-ascii?Q?pNTT5fuEerutd9WmbT2Tw/nRhrenfppMI5R029u7AmYr8Jr9UijGUeO/v6ld?=
 =?us-ascii?Q?LDefs+vveKPIwNn26hUpTf4QlbLftjPNnzTyC1ckq+NckUZ+mSDh7X2dt1K7?=
 =?us-ascii?Q?Evpcfizk00VR/ex5zg361ldJDubUQ8FCmSC/ITN3Cbj9uK/8VNJzZgry210/?=
 =?us-ascii?Q?Ac48brpqTrHWoa3we5EgUGss?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 020dc715-c744-47b2-6be7-08d9034e7fd2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5101.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2021 16:16:33.8603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hBPbFpWGfCL5/DVQ39A+eQcBEHnPKbshuNfzmAcI2a9RozpnY0oLxsCeP2vkwhT8dQ8aNI4VOf0ujGg4abANlSZ1GZ3mjsG1rDI98m70gQs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7102
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add driver for tja1103 driver and for future NXP C45 PHYs.

Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 MAINTAINERS                       |   6 +
 drivers/net/phy/Kconfig           |   6 +
 drivers/net/phy/Makefile          |   1 +
 drivers/net/phy/nxp-c45-tja11xx.c | 588 ++++++++++++++++++++++++++++++
 4 files changed, 601 insertions(+)
 create mode 100644 drivers/net/phy/nxp-c45-tja11xx.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 795b9941c151..5334f470315a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12830,6 +12830,12 @@ F:	drivers/nvmem/
 F:	include/linux/nvmem-consumer.h
 F:	include/linux/nvmem-provider.h
 
+NXP C45 TJA11XX PHY DRIVER
+M:	Radu Pirea <radu-nicolae.pirea@oss.nxp.com>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/phy/nxp-c45-tja11xx.c
+
 NXP FSPI DRIVER
 M:	Ashish Kumar <ashish.kumar@nxp.com>
 R:	Yogesh Gaur <yogeshgaur.83@gmail.com>
diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index a615b3660b05..288bf405ebdb 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -234,6 +234,12 @@ config NATIONAL_PHY
 	help
 	  Currently supports the DP83865 PHY.
 
+config NXP_C45_TJA11XX_PHY
+	tristate "NXP C45 TJA11XX PHYs"
+	help
+	  Enable support for NXP C45 TJA11XX PHYs.
+	  Currently supports only the TJA1103 PHY.
+
 config NXP_TJA11XX_PHY
 	tristate "NXP TJA11xx PHYs support"
 	depends on HWMON
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index de683e3abe63..bcda7ed2455d 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -71,6 +71,7 @@ obj-$(CONFIG_MICROCHIP_PHY)	+= microchip.o
 obj-$(CONFIG_MICROCHIP_T1_PHY)	+= microchip_t1.o
 obj-$(CONFIG_MICROSEMI_PHY)	+= mscc/
 obj-$(CONFIG_NATIONAL_PHY)	+= national.o
+obj-$(CONFIG_NXP_C45_TJA11XX_PHY)	+= nxp-c45-tja11xx.o
 obj-$(CONFIG_NXP_TJA11XX_PHY)	+= nxp-tja11xx.o
 obj-$(CONFIG_QSEMI_PHY)		+= qsemi.o
 obj-$(CONFIG_REALTEK_PHY)	+= realtek.o
diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
new file mode 100644
index 000000000000..47cacda8836f
--- /dev/null
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -0,0 +1,588 @@
+// SPDX-License-Identifier: GPL-2.0
+/* NXP C45 PHY driver
+ * Copyright (C) 2021 NXP
+ * Author: Radu Pirea <radu-nicolae.pirea@oss.nxp.com>
+ */
+
+#include <linux/delay.h>
+#include <linux/ethtool.h>
+#include <linux/ethtool_netlink.h>
+#include <linux/kernel.h>
+#include <linux/mii.h>
+#include <linux/module.h>
+#include <linux/phy.h>
+#include <linux/processor.h>
+#include <linux/property.h>
+
+#define PHY_ID_TJA_1103			0x001BB010
+
+#define PMAPMD_B100T1_PMAPMD_CTL	0x0834
+#define B100T1_PMAPMD_CONFIG_EN		BIT(15)
+#define B100T1_PMAPMD_MASTER		BIT(14)
+#define MASTER_MODE			(B100T1_PMAPMD_CONFIG_EN | \
+					 B100T1_PMAPMD_MASTER)
+#define SLAVE_MODE			(B100T1_PMAPMD_CONFIG_EN)
+
+#define VEND1_DEVICE_CONTROL		0x0040
+#define DEVICE_CONTROL_RESET		BIT(15)
+#define DEVICE_CONTROL_CONFIG_GLOBAL_EN	BIT(14)
+#define DEVICE_CONTROL_CONFIG_ALL_EN	BIT(13)
+
+#define VEND1_PHY_CONTROL		0x8100
+#define PHY_CONFIG_EN			BIT(14)
+#define PHY_START_OP			BIT(0)
+
+#define VEND1_PHY_CONFIG		0x8108
+#define PHY_CONFIG_AUTO			BIT(0)
+
+#define VEND1_SIGNAL_QUALITY		0x8320
+#define SQI_VALID			BIT(14)
+#define SQI_MASK			GENMASK(2, 0)
+#define MAX_SQI				SQI_MASK
+
+#define VEND1_CABLE_TEST		0x8330
+#define CABLE_TEST_ENABLE		BIT(15)
+#define CABLE_TEST_START		BIT(14)
+#define CABLE_TEST_VALID		BIT(13)
+#define CABLE_TEST_OK			0x00
+#define CABLE_TEST_SHORTED		0x01
+#define CABLE_TEST_OPEN			0x02
+#define CABLE_TEST_UNKNOWN		0x07
+
+#define VEND1_PORT_CONTROL		0x8040
+#define PORT_CONTROL_EN			BIT(14)
+
+#define VEND1_PORT_INFRA_CONTROL	0xAC00
+#define PORT_INFRA_CONTROL_EN		BIT(14)
+
+#define VEND1_RXID			0xAFCC
+#define VEND1_TXID			0xAFCD
+#define ID_ENABLE			BIT(15)
+
+#define VEND1_ABILITIES			0xAFC4
+#define RGMII_ID_ABILITY		BIT(15)
+#define RGMII_ABILITY			BIT(14)
+#define RMII_ABILITY			BIT(10)
+#define REVMII_ABILITY			BIT(9)
+#define MII_ABILITY			BIT(8)
+#define SGMII_ABILITY			BIT(0)
+
+#define VEND1_MII_BASIC_CONFIG		0xAFC6
+#define MII_BASIC_CONFIG_REV		BIT(8)
+#define MII_BASIC_CONFIG_SGMII		0x9
+#define MII_BASIC_CONFIG_RGMII		0x7
+#define MII_BASIC_CONFIG_RMII		0x5
+#define MII_BASIC_CONFIG_MII		0x4
+
+#define VEND1_SYMBOL_ERROR_COUNTER	0x8350
+#define VEND1_LINK_DROP_COUNTER		0x8352
+#define VEND1_LINK_LOSSES_AND_FAILURES	0x8353
+#define VEND1_R_GOOD_FRAME_CNT		0xA950
+#define VEND1_R_BAD_FRAME_CNT		0xA952
+#define VEND1_R_RXER_FRAME_CNT		0xA954
+#define VEND1_RX_PREAMBLE_COUNT		0xAFCE
+#define VEND1_TX_PREAMBLE_COUNT		0xAFCF
+#define VEND1_RX_IPG_LENGTH		0xAFD0
+#define VEND1_TX_IPG_LENGTH		0xAFD1
+#define COUNTER_EN			BIT(15)
+
+#define RGMII_PERIOD_PS			8000U
+#define PS_PER_DEGREE			div_u64(RGMII_PERIOD_PS, 360)
+#define MIN_ID_PS			1644U
+#define MAX_ID_PS			2260U
+#define DEFAULT_ID_PS			2000U
+
+struct nxp_c45_phy {
+	u32 tx_delay;
+	u32 rx_delay;
+};
+
+struct nxp_c45_phy_stats {
+	const char	*name;
+	u8		mmd;
+	u16		reg;
+	u8		off;
+	u16		mask;
+};
+
+static const struct nxp_c45_phy_stats nxp_c45_hw_stats[] = {
+	{ "phy_symbol_error_cnt", MDIO_MMD_VEND1,
+		VEND1_SYMBOL_ERROR_COUNTER, 0, GENMASK(15, 0) },
+	{ "phy_link_status_drop_cnt", MDIO_MMD_VEND1,
+		VEND1_LINK_DROP_COUNTER, 8, GENMASK(13, 8) },
+	{ "phy_link_availability_drop_cnt", MDIO_MMD_VEND1,
+		VEND1_LINK_DROP_COUNTER, 0, GENMASK(5, 0) },
+	{ "phy_link_loss_cnt", MDIO_MMD_VEND1,
+		VEND1_LINK_LOSSES_AND_FAILURES, 10, GENMASK(15, 10) },
+	{ "phy_link_failure_cnt", MDIO_MMD_VEND1,
+		VEND1_LINK_LOSSES_AND_FAILURES, 0, GENMASK(9, 0) },
+	{ "r_good_frame_cnt", MDIO_MMD_VEND1,
+		VEND1_R_GOOD_FRAME_CNT, 0, GENMASK(15, 0) },
+	{ "r_bad_frame_cnt", MDIO_MMD_VEND1,
+		VEND1_R_BAD_FRAME_CNT, 0, GENMASK(15, 0) },
+	{ "r_rxer_frame_cnt", MDIO_MMD_VEND1,
+		VEND1_R_RXER_FRAME_CNT, 0, GENMASK(15, 0) },
+	{ "rx_preamble_count", MDIO_MMD_VEND1,
+		VEND1_RX_PREAMBLE_COUNT, 0, GENMASK(5, 0) },
+	{ "tx_preamble_count", MDIO_MMD_VEND1,
+		VEND1_TX_PREAMBLE_COUNT, 0, GENMASK(5, 0) },
+	{ "rx_ipg_length", MDIO_MMD_VEND1,
+		VEND1_RX_IPG_LENGTH, 0, GENMASK(8, 0) },
+	{ "tx_ipg_length", MDIO_MMD_VEND1,
+		VEND1_TX_IPG_LENGTH, 0, GENMASK(8, 0) },
+};
+
+static int nxp_c45_get_sset_count(struct phy_device *phydev)
+{
+	return ARRAY_SIZE(nxp_c45_hw_stats);
+}
+
+static void nxp_c45_get_strings(struct phy_device *phydev, u8 *data)
+{
+	size_t i;
+
+	for (i = 0; i < ARRAY_SIZE(nxp_c45_hw_stats); i++) {
+		strncpy(data + i * ETH_GSTRING_LEN,
+			nxp_c45_hw_stats[i].name, ETH_GSTRING_LEN);
+	}
+}
+
+static void nxp_c45_get_stats(struct phy_device *phydev,
+			      struct ethtool_stats *stats, u64 *data)
+{
+	size_t i;
+	int ret;
+
+	for (i = 0; i < ARRAY_SIZE(nxp_c45_hw_stats); i++) {
+		ret = phy_read_mmd(phydev, nxp_c45_hw_stats[i].mmd,
+				   nxp_c45_hw_stats[i].reg);
+		if (ret < 0) {
+			data[i] = U64_MAX;
+		} else {
+			data[i] = ret & nxp_c45_hw_stats[i].mask;
+			data[i] >>= nxp_c45_hw_stats[i].off;
+		}
+	}
+}
+
+static int nxp_c45_config_enable(struct phy_device *phydev)
+{
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_DEVICE_CONTROL,
+		      DEVICE_CONTROL_CONFIG_GLOBAL_EN |
+		      DEVICE_CONTROL_CONFIG_ALL_EN);
+	usleep_range(400, 450);
+
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_PORT_CONTROL,
+		      PORT_CONTROL_EN);
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_PHY_CONTROL,
+		      PHY_CONFIG_EN);
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_PORT_INFRA_CONTROL,
+		      PORT_INFRA_CONTROL_EN);
+
+	return 0;
+}
+
+static int nxp_c45_start_op(struct phy_device *phydev)
+{
+	return phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_PHY_CONTROL,
+				PHY_START_OP);
+}
+
+static int nxp_c45_soft_reset(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_DEVICE_CONTROL,
+			    DEVICE_CONTROL_RESET);
+	if (ret)
+		return ret;
+
+	return phy_read_mmd_poll_timeout(phydev, MDIO_MMD_VEND1,
+					 VEND1_DEVICE_CONTROL, ret,
+					 !(ret & DEVICE_CONTROL_RESET), 20000,
+					 240000, false);
+}
+
+static int nxp_c45_cable_test_start(struct phy_device *phydev)
+{
+	return phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_CABLE_TEST,
+			     CABLE_TEST_ENABLE | CABLE_TEST_START);
+}
+
+static int nxp_c45_cable_test_get_status(struct phy_device *phydev,
+					 bool *finished)
+{
+	int ret;
+	u8 cable_test_result;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, VEND1_CABLE_TEST);
+	if (!(ret & CABLE_TEST_VALID)) {
+		*finished = false;
+		return 0;
+	}
+
+	*finished = true;
+	cable_test_result = ret & GENMASK(2, 0);
+
+	switch (cable_test_result) {
+	case CABLE_TEST_OK:
+		ethnl_cable_test_result(phydev, ETHTOOL_A_CABLE_PAIR_A,
+					ETHTOOL_A_CABLE_RESULT_CODE_OK);
+		break;
+	case CABLE_TEST_SHORTED:
+		ethnl_cable_test_result(phydev, ETHTOOL_A_CABLE_PAIR_A,
+					ETHTOOL_A_CABLE_RESULT_CODE_SAME_SHORT);
+		break;
+	case CABLE_TEST_OPEN:
+		ethnl_cable_test_result(phydev, ETHTOOL_A_CABLE_PAIR_A,
+					ETHTOOL_A_CABLE_RESULT_CODE_OPEN);
+		break;
+	default:
+		ethnl_cable_test_result(phydev, ETHTOOL_A_CABLE_PAIR_A,
+					ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC);
+	}
+
+	phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_CABLE_TEST,
+			   CABLE_TEST_ENABLE);
+
+	return nxp_c45_start_op(phydev);
+}
+
+static int nxp_c45_setup_master_slave(struct phy_device *phydev)
+{
+	switch (phydev->master_slave_set) {
+	case MASTER_SLAVE_CFG_MASTER_FORCE:
+	case MASTER_SLAVE_CFG_MASTER_PREFERRED:
+		phy_write_mmd(phydev, MDIO_MMD_PMAPMD, PMAPMD_B100T1_PMAPMD_CTL,
+			      MASTER_MODE);
+		break;
+	case MASTER_SLAVE_CFG_SLAVE_PREFERRED:
+	case MASTER_SLAVE_CFG_SLAVE_FORCE:
+		phy_write_mmd(phydev, MDIO_MMD_PMAPMD, PMAPMD_B100T1_PMAPMD_CTL,
+			      SLAVE_MODE);
+		break;
+	case MASTER_SLAVE_CFG_UNKNOWN:
+	case MASTER_SLAVE_CFG_UNSUPPORTED:
+		return 0;
+	default:
+		phydev_warn(phydev, "Unsupported Master/Slave mode\n");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int nxp_c45_read_master_slave(struct phy_device *phydev)
+{
+	int reg;
+
+	phydev->master_slave_get = MASTER_SLAVE_CFG_UNKNOWN;
+	phydev->master_slave_state = MASTER_SLAVE_STATE_UNKNOWN;
+
+	reg = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, PMAPMD_B100T1_PMAPMD_CTL);
+	if (reg < 0)
+		return reg;
+
+	if (reg & B100T1_PMAPMD_MASTER) {
+		phydev->master_slave_get = MASTER_SLAVE_CFG_MASTER_FORCE;
+		phydev->master_slave_state = MASTER_SLAVE_STATE_MASTER;
+	} else {
+		phydev->master_slave_get = MASTER_SLAVE_CFG_SLAVE_FORCE;
+		phydev->master_slave_state = MASTER_SLAVE_STATE_SLAVE;
+	}
+
+	return 0;
+}
+
+static int nxp_c45_config_aneg(struct phy_device *phydev)
+{
+	return nxp_c45_setup_master_slave(phydev);
+}
+
+static int nxp_c45_read_status(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = genphy_c45_read_status(phydev);
+	if (ret)
+		return ret;
+
+	ret = nxp_c45_read_master_slave(phydev);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int nxp_c45_get_sqi(struct phy_device *phydev)
+{
+	int reg;
+
+	reg = phy_read_mmd(phydev, MDIO_MMD_VEND1, VEND1_SIGNAL_QUALITY);
+	if (!(reg & SQI_VALID))
+		return -EINVAL;
+
+	reg &= SQI_MASK;
+
+	return reg;
+}
+
+static int nxp_c45_get_sqi_max(struct phy_device *phydev)
+{
+	return MAX_SQI;
+}
+
+static int nxp_c45_check_delay(struct phy_device *phydev, u32 delay)
+{
+	if (delay < MIN_ID_PS) {
+		phydev_err(phydev, "delay value smaller than %u\n", MIN_ID_PS);
+		return -EINVAL;
+	}
+
+	if (delay > MAX_ID_PS) {
+		phydev_err(phydev, "delay value higher than %u\n", MAX_ID_PS);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static u64 nxp_c45_get_phase_shift(u64 phase_offset_raw)
+{
+	/* The delay in degree phase is 73.8 + phase_offset_raw * 0.9.
+	 * To avoid floating point operations we'll multiply by 10
+	 * and get 1 decimal point precision.
+	 */
+	phase_offset_raw *= 10;
+	phase_offset_raw -= phase_offset_raw;
+	return div_u64(phase_offset_raw, 9);
+}
+
+static void nxp_c45_disable_delays(struct phy_device *phydev)
+{
+	phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_TXID, ID_ENABLE);
+	phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_RXID, ID_ENABLE);
+}
+
+static void nxp_c45_set_delays(struct phy_device *phydev)
+{
+	struct nxp_c45_phy *priv = phydev->priv;
+	u64 tx_delay = priv->tx_delay;
+	u64 rx_delay = priv->rx_delay;
+	u64 degree;
+
+	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
+		degree = div_u64(tx_delay, PS_PER_DEGREE);
+		phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_TXID,
+			      ID_ENABLE | nxp_c45_get_phase_shift(degree));
+	} else {
+		phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_TXID,
+				   ID_ENABLE);
+	}
+
+	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+	    phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
+		degree = div_u64(rx_delay, PS_PER_DEGREE);
+		phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_RXID,
+			      ID_ENABLE | nxp_c45_get_phase_shift(degree));
+	} else {
+		phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_RXID,
+				   ID_ENABLE);
+	}
+}
+
+static int nxp_c45_get_delays(struct phy_device *phydev)
+{
+	struct nxp_c45_phy *priv = phydev->priv;
+	int ret;
+
+	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
+		ret = device_property_read_u32(&phydev->mdio.dev,
+					       "tx-internal-delay-ps",
+					       &priv->tx_delay);
+		if (ret)
+			priv->tx_delay = DEFAULT_ID_PS;
+
+		ret = nxp_c45_check_delay(phydev, priv->tx_delay);
+		if (ret) {
+			phydev_err(phydev,
+				   "tx-internal-delay-ps invalid value\n");
+			return ret;
+		}
+	}
+
+	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+	    phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
+		ret = device_property_read_u32(&phydev->mdio.dev,
+					       "rx-internal-delay-ps",
+					       &priv->rx_delay);
+		if (ret)
+			priv->rx_delay = DEFAULT_ID_PS;
+
+		ret = nxp_c45_check_delay(phydev, priv->rx_delay);
+		if (ret) {
+			phydev_err(phydev,
+				   "rx-internal-delay-ps invalid value\n");
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int nxp_c45_set_phy_mode(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, VEND1_ABILITIES);
+	phydev_dbg(phydev, "Clause 45 managed PHY abilities 0x%x\n", ret);
+
+	switch (phydev->interface) {
+	case PHY_INTERFACE_MODE_RGMII:
+		if (!(ret & RGMII_ABILITY)) {
+			phydev_err(phydev, "rgmii mode not supported\n");
+			return -EINVAL;
+		}
+		phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_MII_BASIC_CONFIG,
+			      MII_BASIC_CONFIG_RGMII);
+		nxp_c45_disable_delays(phydev);
+		break;
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+		if (!(ret & RGMII_ID_ABILITY)) {
+			phydev_err(phydev, "rgmii-id, rgmii-txid, rgmii-rxid modes are not supported\n");
+			return -EINVAL;
+		}
+		phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_MII_BASIC_CONFIG,
+			      MII_BASIC_CONFIG_RGMII);
+		ret = nxp_c45_get_delays(phydev);
+		if (ret)
+			return ret;
+
+		nxp_c45_set_delays(phydev);
+		break;
+	case PHY_INTERFACE_MODE_MII:
+		if (!(ret & MII_ABILITY)) {
+			phydev_err(phydev, "mii mode not supported\n");
+			return -EINVAL;
+		}
+		phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_MII_BASIC_CONFIG,
+			      MII_BASIC_CONFIG_MII);
+		break;
+	case PHY_INTERFACE_MODE_REVMII:
+		if (!(ret & REVMII_ABILITY)) {
+			phydev_err(phydev, "rev-mii mode not supported\n");
+			return -EINVAL;
+		}
+		phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_MII_BASIC_CONFIG,
+			      MII_BASIC_CONFIG_MII | MII_BASIC_CONFIG_REV);
+		break;
+	case PHY_INTERFACE_MODE_RMII:
+		if (!(ret & RMII_ABILITY)) {
+			phydev_err(phydev, "rmii mode not supported\n");
+			return -EINVAL;
+		}
+		phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_MII_BASIC_CONFIG,
+			      MII_BASIC_CONFIG_RMII);
+		break;
+	case PHY_INTERFACE_MODE_SGMII:
+		if (!(ret & SGMII_ABILITY)) {
+			phydev_err(phydev, "sgmii mode not supported\n");
+			return -EINVAL;
+		}
+		phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_MII_BASIC_CONFIG,
+			      MII_BASIC_CONFIG_SGMII);
+		break;
+	case PHY_INTERFACE_MODE_INTERNAL:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int nxp_c45_config_init(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = nxp_c45_config_enable(phydev);
+	if (ret) {
+		phydev_err(phydev, "Failed to enable config\n");
+		return ret;
+	}
+
+	phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_PHY_CONFIG,
+			 PHY_CONFIG_AUTO);
+
+	phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_LINK_DROP_COUNTER,
+			 COUNTER_EN);
+	phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_RX_PREAMBLE_COUNT,
+			 COUNTER_EN);
+	phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_TX_PREAMBLE_COUNT,
+			 COUNTER_EN);
+	phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_RX_IPG_LENGTH,
+			 COUNTER_EN);
+	phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_TX_IPG_LENGTH,
+			 COUNTER_EN);
+
+	ret = nxp_c45_set_phy_mode(phydev);
+	if (ret)
+		return ret;
+
+	phydev->autoneg = AUTONEG_DISABLE;
+
+	return nxp_c45_start_op(phydev);
+}
+
+static int nxp_c45_probe(struct phy_device *phydev)
+{
+	struct nxp_c45_phy *priv;
+
+	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	phydev->priv = priv;
+
+	return 0;
+}
+
+static struct phy_driver nxp_c45_driver[] = {
+	{
+		PHY_ID_MATCH_MODEL(PHY_ID_TJA_1103),
+		.name			= "NXP C45 TJA1103",
+		.features		= PHY_BASIC_T1_FEATURES,
+		.probe			= nxp_c45_probe,
+		.soft_reset		= nxp_c45_soft_reset,
+		.config_aneg		= nxp_c45_config_aneg,
+		.config_init		= nxp_c45_config_init,
+		.read_status		= nxp_c45_read_status,
+		.suspend		= genphy_c45_pma_suspend,
+		.resume			= genphy_c45_pma_resume,
+		.get_sset_count		= nxp_c45_get_sset_count,
+		.get_strings		= nxp_c45_get_strings,
+		.get_stats		= nxp_c45_get_stats,
+		.cable_test_start	= nxp_c45_cable_test_start,
+		.cable_test_get_status	= nxp_c45_cable_test_get_status,
+		.set_loopback		= genphy_c45_loopback,
+		.get_sqi		= nxp_c45_get_sqi,
+		.get_sqi_max		= nxp_c45_get_sqi_max,
+	},
+};
+
+module_phy_driver(nxp_c45_driver);
+
+static struct mdio_device_id __maybe_unused nxp_c45_tbl[] = {
+	{ PHY_ID_MATCH_MODEL(PHY_ID_TJA_1103) },
+	{ /*sentinel*/ },
+};
+
+MODULE_DEVICE_TABLE(mdio, nxp_c45_tbl);
+
+MODULE_AUTHOR("Radu Pirea <radu-nicolae.pirea@oss.nxp.com>");
+MODULE_DESCRIPTION("NXP C45 PHY driver");
+MODULE_LICENSE("GPL v2");
-- 
2.31.1

