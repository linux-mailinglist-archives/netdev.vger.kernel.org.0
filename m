Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE7C3605AD
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 11:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbhDOJ3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 05:29:15 -0400
Received: from mail-eopbgr140072.outbound.protection.outlook.com ([40.107.14.72]:62785
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231488AbhDOJ3G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 05:29:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VFvDiSQMErfKefYDl0+nw7YKt4glldnH8C8GG8ipy4BkMsSDl+WM6ZKjcTEZ/5YcvdYgz7L532y2rN0IDkpEKmpRiTwqDsbNTaQxA4ODBNkD+5g6l9OyqvFtg52qCq4vMYEB4NasFLYUJIDY23znZTguT4tK6iY1eLy3nSVC42qwvxLpOXaJHuUqKEB8ja7GKxkxitCgK1rjDcD/SIogiKoGeOkMF7sXP8HYmG+2N45Ye8bHlJyBtVgrT6I73wqp9k8EQs2YQ598kkr/Q6aIAHvJNL7PCN6XofUCdAQFWouhs0KtqmvTJ4WwLcfjA/0mcE/Y7voKBjRP9AsBNo2oAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MczFHiWKC9HsdPL9X2hBXjRHP2jwulLupW0Q0yjfe3Y=;
 b=PbRwrgEzLbVPm7nWgasOxM/+CPIJsO/GA7duhN8PUdujm50ctSxTHW5IXBVN/wuqpO2IU0OSSSsrQrZbIjkTayGK69GLEue0NqKd3w4hk0RfcHmN15M9Qh2BbnASHCP4VKSlRhGvx9dIZinj4SbfnnlAuD+dutgDOhzSibDcvJCpydvdbvLrkX7iIuYFTo8HxBvbCv/vtbRNyoFzE+oxOuiK6DjlftNSyWl+jMf1VI7u2QUKhWxs3iXrXU5NeaYbk+S7eU1QFExKMWV+D0iNzpnZL21kYIV3Z+E8IP+Zm2N8C5xo5v/6foZsZj580SGRDrjtBXPFUsgyosdyUYLrxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MczFHiWKC9HsdPL9X2hBXjRHP2jwulLupW0Q0yjfe3Y=;
 b=LSg/GaJTyITd4XH4dX/1QUp4lz2EgbDsNwbB8m/v5utLozX7hwVzmgFzXknn1o18JfjNNkVVGEGudENOQDE7EvcheiHG/Y4YIpz3MYBVhSurq2IuYxfBtIVF5us8saP6IY0Z0Au+mHv21pfZJjyD2rgj92nq5AvItxBsTcqKO9o=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com (2603:10a6:803:5f::31)
 by VI1PR0402MB3871.eurprd04.prod.outlook.com (2603:10a6:803:16::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Thu, 15 Apr
 2021 09:28:38 +0000
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945]) by VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945%6]) with mapi id 15.20.4020.022; Thu, 15 Apr 2021
 09:28:38 +0000
From:   "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH v2 2/2] phy: nxp-c45: add driver for tja1103
Date:   Thu, 15 Apr 2021 12:25:38 +0300
Message-Id: <20210415092538.78398-3-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415092538.78398-1-radu-nicolae.pirea@oss.nxp.com>
References: <20210415092538.78398-1-radu-nicolae.pirea@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [89.45.21.213]
X-ClientProxiedBy: AM0PR02CA0177.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::14) To VI1PR04MB5101.eurprd04.prod.outlook.com
 (2603:10a6:803:5f::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (89.45.21.213) by AM0PR02CA0177.eurprd02.prod.outlook.com (2603:10a6:20b:28e::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Thu, 15 Apr 2021 09:28:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b0c9e95-cff3-461c-f519-08d8fff0d9c6
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3871:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3871F320C0AA5B5EE244650E9F4D9@VI1PR0402MB3871.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UEF6ebvQ/gz5c0XMmMMYWifSITgPgo4iiGATAHMRerq1VRwMJzB68ewCf595ieVhesB68snn9wzClExUnYffZQ1g5nDNeNWmq1gWvJk080KgsIkP7kQ0P2K+owerugxWXDZ2P6G4T5LwNbxUrEkxxv0W4zx2U/eX6GtkmhLiO+uZ8Dwtoihj0J4PMmiLU6FrqHiRoxWk2JHyiPj1RDD5cmc3nHToXBLCvZQHvhA92Q5XlJg+HRd7o+5HSbNe3Wlo9xtJtxW4OfLa5SeX4p+R0qZtcm8kCjQvdhXAf+z9rngaUM4BTbv1Mb5Svxkq5XPbpKABXRZEqcnZ2TXFpLCW1SfS7jQjPpj8iGlN4mriHeWvMIA1WnnPkdl4eu+RmvTYTZko28sndG7BYg92p2Wx4jn6U4A0DjqipE/MpLy+s7sRYJApMnumgiNO1ZRbvIRy7Ix7M9FoAn3ItKXhTdFE3LCs7pG94R5/t0cZFbIMGuphWPgueEavpG5zvJrusZn7xtMe6whJqyZvhgImcAkuNeE0bz6ff8coH50nXhkkI0TReD2vfuTice6qtU5JlV4e5Qd5jwpevkefNS1cLp5lXnxrI2tuZtrORfdvOLYwk6/Xk2I5bqO8NTz0S8vj/oZnrAiE7Im1o0D1z5RpBbYOx/aFousF+cLsFcvxXn1v+CVacjVQKUUq+7qXwhs26qSSz/6+BT98vKxXTgssd1RfPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5101.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(8676002)(66946007)(52116002)(186003)(38100700002)(66476007)(6506007)(8936002)(66556008)(86362001)(16526019)(5660300002)(478600001)(26005)(2616005)(30864003)(6486002)(6512007)(38350700002)(2906002)(69590400012)(4326008)(316002)(83380400001)(1076003)(956004)(41350200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FMNtBY8rnGZ5E3t03oiFNVW3f5wig+BLTOYQYSFO7jB11/G3n4P9k9erM3vylvp3TJ6lHMm9DblOXZbP9iAO9ihZOXfk3ATU3P147GLd+xtu8RMnsM9o5kJhZzGdXyoISrGDHnt9vDUD7kt2yfXEP+He2LVZMccvbSC0MZ5WvWh0pXWJruObRS8RQqJFD4Tp7It2zhcF8mnsWecoNMUTi/MciX/ZxouIobil1Pe/KGrd7OCQOmgK0XHu967G9VRikXwFRNGSyfFcRG8G7O/oohEbdZNU+ppKBrbzpefS9hkbAe5XW60GnoYV4duckhNsaEif/5gpfS75n7ahUdfsCAEIUKipwnoDEli+1kLWCiT89iuDxGCqlIXw9JIXC5jtRLY0St5uXD6Uh8HQpE1cMACD2HzqVYIWit1G58exD8a0VPON7tmLSrqBnt/VQn1uWuZ+vxCAWfLPCyqVsTQdmzvjOL57HBVVoueMKr8NcVrhcAxkR/fv00J6qT3+8aYKdWVK7zJi4j4Pd5J2LqyvA/3Ng+jS7NmeLs3nE7y4XXPu4TOuKe77zoLXDXn/f2kU2xfN9r8+ApFCa59HgN2dy8CMEpkSDGSauQlBsUBUTSE7Memmyb9Ka2w/DtHbYRvTV4srWNz34gSHSFdoEy/RzzTuJXypyALC6GHXB6UbluZwj5Od0mMmH8xAJcB8awavmV0b89d4B8iPVBvpl/WSVTIe+J7E9yIpIYoTggAVmYJg6eJFa5i8sy8Ni6pmAbl/
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b0c9e95-cff3-461c-f519-08d8fff0d9c6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5101.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 09:28:38.5702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cu8Q8Bn3wdBRgBjfswxAwiD++NNlNBN1qrdA3jClVLWWOq8K5pXj5xD8aJVqldhdiULF9u3OZo1izAZMAoNJC39N0Jql0kUql4pWWwhRSVI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3871
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add driver for tja1103 driver and for future NXP C45 PHYs.

Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 MAINTAINERS                       |   6 +
 drivers/net/phy/Kconfig           |   6 +
 drivers/net/phy/Makefile          |   1 +
 drivers/net/phy/nxp-c45-tja11xx.c | 607 ++++++++++++++++++++++++++++++
 4 files changed, 620 insertions(+)
 create mode 100644 drivers/net/phy/nxp-c45-tja11xx.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 795b9941c151..840ac3f46d7a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12830,6 +12830,12 @@ F:	drivers/nvmem/
 F:	include/linux/nvmem-consumer.h
 F:	include/linux/nvmem-provider.h
 
+NXP C45 PHY DRIVER
+M:	Radu Pirea <radu-nicolae.pirea@oss.nxp.com>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/phy/nxp-c45.c
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
index 000000000000..b66262e1f299
--- /dev/null
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -0,0 +1,607 @@
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
+#define PHY_ID_BASE_T1			0x001BB010
+
+#define PMAPMD_B100T1_PMAPMD_CTL		0x0834
+#define B100T1_PMAPMD_CONFIG_EN		BIT(15)
+#define B100T1_PMAPMD_MASTER		BIT(14)
+#define MASTER_MODE			(B100T1_PMAPMD_CONFIG_EN | \
+	B100T1_PMAPMD_MASTER)
+#define SLAVE_MODE			(B100T1_PMAPMD_CONFIG_EN)
+
+#define VEND1_DEVICE_CONTROL		0x0040
+#define DEVICE_CONTROL_RESET		BIT(15)
+#define DEVICE_CONTROL_CONFIG_GLOBAL_EN	BIT(14)
+#define DEVICE_CONTROL_CONFIG_ALL_EN	BIT(13)
+#define RESET_POLL_NS			(250 * NSEC_PER_MSEC)
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
+static int nxp_c45_reset_done(struct phy_device *phydev)
+{
+	return !(phy_read_mmd(phydev, MDIO_MMD_VEND1, VEND1_DEVICE_CONTROL) &
+		DEVICE_CONTROL_RESET);
+}
+
+static int nxp_c45_reset_done_or_timeout(struct phy_device *phydev,
+					 ktime_t timeout)
+{
+	ktime_t cur = ktime_get();
+
+	return nxp_c45_reset_done(phydev) || ktime_after(cur, timeout);
+}
+
+static int nxp_c45_soft_reset(struct phy_device *phydev)
+{
+	ktime_t timeout;
+	int ret;
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_DEVICE_CONTROL,
+			    DEVICE_CONTROL_RESET);
+	if (ret)
+		return ret;
+
+	timeout = ktime_add_ns(ktime_get(), RESET_POLL_NS);
+	spin_until_cond(nxp_c45_reset_done_or_timeout(phydev, timeout));
+	if (!nxp_c45_reset_done(phydev)) {
+		phydev_err(phydev, "reset fail\n");
+		return -EIO;
+	}
+	return 0;
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
+		PHY_ID_MATCH_MODEL(PHY_ID_BASE_T1),
+		.name			= "NXP C45 BASE-T1",
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
+	{ PHY_ID_MATCH_MODEL(PHY_ID_BASE_T1) },
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

