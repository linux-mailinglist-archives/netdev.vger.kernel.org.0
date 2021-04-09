Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C28435A5F4
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 20:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234580AbhDISln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 14:41:43 -0400
Received: from mail-eopbgr00045.outbound.protection.outlook.com ([40.107.0.45]:11030
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234571AbhDISlm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 14:41:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PNJWgag+fWfA8bSu9Y0L1Qun33GdYtDXMPV0GVexo+igsE6mIVn3n84vMfkSLI620U4ByPZHrk7C0W2jsAtmHmyPSCn0qaZu68pVtLwqzrUeZm4P4sPKSNuvo71T8baDXvb8ffjUfNFNoZftthWVxM/V8xBnpaUgmrchIL4Ss+/GlN47iQcoBPvFcXqchAvdXxmd3/Qmm7ATi/QqXDnVqBf6257oxJJCthZjFzsX//rcKXwz1Ts0CK4axwtqaEt0bF96WLD29sVOtp+lmTzv3lQpYK6VqDUq2nbio3WB0028GogDLmDyn1LVk8Dy6pgfakKe9LEflRI88XAJlGD3PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ujrnNH9smN+a6hBc9WGC9q35zZ+mUH1IE9vvqtW4LOk=;
 b=Su2bna7TYBwzdvC2IvGGXzTjr+UFPee6o4rQgR/GbcO1A6a5F1mjSKL2RRBxDYJwijnW0SL3yJRy1GKv/Dj7+c8S5expQJ9hmCO6qoj8TR21Kz/BSda7ejqpOb4q67QGDm7KRp4VhsCF6+CAAiCbqTqmruojWhjlQ4b6BH0nI05gYL5Ig3auw29uNshvF0R+PIfLe6QxfuNRgh9hfkOfUnIGHA5A8uND+bCEGHLDnXG6WixtLuRS1AcAqKe2LXrycSXEDyEK2C/z8CgZldw3Qb6XuVE+JNJluWEi0om+2ir1vlBMRT0yEdKeqvgJ5hQcc4lOn2iSVZUW1ONs1rwzdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ujrnNH9smN+a6hBc9WGC9q35zZ+mUH1IE9vvqtW4LOk=;
 b=NaetZZ0bkmqSFr8wtcJi49W64+mz0LfQLaaNwhvAL7ONLTe4eYgXMTlpw/ALHZUlhjUESf36UxhmpsuZuTrHvUbi3hQMpx8aAvh8Y+YG7Aydt9t/UzxOYESxc7xy/mc+ZIu5q3a2VSJBzGEidTI1DsOETnnPHpcOAU+57+p3i0g=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com (2603:10a6:803:5f::31)
 by VI1PR04MB4128.eurprd04.prod.outlook.com (2603:10a6:803:45::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Fri, 9 Apr
 2021 18:41:25 +0000
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945]) by VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945%6]) with mapi id 15.20.4020.018; Fri, 9 Apr 2021
 18:41:24 +0000
From:   "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH] phy: nxp-c45: add driver for tja1103
Date:   Fri,  9 Apr 2021 21:41:06 +0300
Message-Id: <20210409184106.264463-1-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [89.45.21.213]
X-ClientProxiedBy: AM4PR07CA0036.eurprd07.prod.outlook.com
 (2603:10a6:205:1::49) To VI1PR04MB5101.eurprd04.prod.outlook.com
 (2603:10a6:803:5f::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (89.45.21.213) by AM4PR07CA0036.eurprd07.prod.outlook.com (2603:10a6:205:1::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.8 via Frontend Transport; Fri, 9 Apr 2021 18:41:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d02c387-295f-48d2-5a47-08d8fb8713e3
X-MS-TrafficTypeDiagnostic: VI1PR04MB4128:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4128BE210590BA370106BB599F739@VI1PR04MB4128.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LuVKFTKmDm4peHMNMbexqy2OHRsIo0iLRGYBwNwri+0f9Ges+mmoKe49NgA6zi6UobSvHdZFg+HcHcKY1lta00LjPDYSm96oSsZTU6sBBFUFWyx2osxShEjaLHWSZdZGXByTSthM13+oI/Pbey33TN+idnuepbbxqRAxP9VYrD4qcIlOTb+Q5Rs7QiOobPeSVa1VqLRfqs97nTjFGt8IFUlcreZpGJbExEXFj3j4t1vkugLkSrhTu2sWa7Bs1u3BGwtiOFoOYWzCxNMI4D1LW92GxoF/kuqtFV2tOW1kYRm5ZqEYpOHqkm8Iv+HKfdVK4vuTXOuQoFO+jmO82dpfInATPiErVeAogrRpG/fsv+3bolKr2C+a64LtyODlh6sfyqPiqms4YG9Qqof7VCz6ghIJr2QeE5l2oW/a8cpBD17HNdI4dfh6MxWbFAuWBY28yVMTx8oWKGPJYCZ9qnwBm+mVTRv6cjA+u+fFVCEJXLFC9hVRm3odrP7EVDdzHusjB3PCPRQQqJMBe6GR9vB0fHa3ijsT5FkxKUWTg3k4RpkIxRx9dQ0SkRQVYjpFR7XKRinTtccA0Ck80McnMOhxCk7Z3Q9X/yhuq9AJvvLJb+0ll4OnNbW6ea4bNMRhxJBgamNHljHJSzIl9/234ukPujoCFokb3j23NKjwYZkPoBzNM21y/rUGqSSp2RZZ8abo/kVPNUOm5CxEcY1qSIfUA6n+/SvyUlJnZ06oQNJwi7PYYK5UxNVaDvdz6f1zy6To
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5101.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(316002)(6486002)(956004)(4326008)(38350700001)(2616005)(186003)(6512007)(86362001)(30864003)(26005)(16526019)(1076003)(52116002)(8936002)(5660300002)(478600001)(38100700001)(8676002)(66476007)(66946007)(66556008)(83380400001)(69590400012)(2906002)(6666004)(6506007)(41350200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9siuUiN2PYj57xK5hZ2jon54QwPuJqhQqmrVIW+JHmvNdqJv1lTJ7eqPCEiD?=
 =?us-ascii?Q?1hz+jLF8c231eo9aXj7RyaG0Bh+kW3/Hof6xqR3Sne04lUFe9ZeTbZVe+/Qk?=
 =?us-ascii?Q?d8cHZIOMU3EgyrNcAnU28li4OqXihglYiqhGXnp1vFz70juZgjkKxduTMB27?=
 =?us-ascii?Q?chWL29iv1XZ9U2c0FbLGeq8vBBote+06MpVjt7WyRqNwKU471H29/tkyciX6?=
 =?us-ascii?Q?b+XVoUmXzEX8+gWX7wS7RCDlq4cASlrXzmuX8MdGx3woJ6XlgD04pTYv0G58?=
 =?us-ascii?Q?N8jG4eYgmAgpBwb3d07iwvXUmo4ljhDFw8LZbpBS4XxlM7rY5p0HCzPJpJzT?=
 =?us-ascii?Q?atR48wRbwl2ZpNlkAW4lAz+azm/pM6/joLuQOp+ROyGlO6T15mxWwtfgLUZt?=
 =?us-ascii?Q?3+CanzwKg4qhk8H6lthOBsqv31+YqnHup0Ry9JK2TBz2CzGUcMWjhpQSiu+1?=
 =?us-ascii?Q?8lmHe6a/jLDYL0kL6//D+Zjb5voHgauCXfg9sT2VHs2yXTDvA4FIceB2lVjW?=
 =?us-ascii?Q?CFcatvtnKonlsm5OT+xVUMor3nq2P89I4fqf0VKcM8BjKPi25XFDEW4yj3CI?=
 =?us-ascii?Q?T+ZrgJVtNSPcodmJptOHeB6MmXYIT5WFkPbjE0vuE3cB1rNUJlKWdVv1OYqT?=
 =?us-ascii?Q?MBkeI/grXda0gNMTZJ/Sh1f0QO59ncMkAbF8qk8CNh+uUuWy6B3ROtVTuoYN?=
 =?us-ascii?Q?tYG4MiWXsFCdFFHbCjD8SonH/tYnU7tZGjlvzPan/TXR5TtbEvx7y/9vnPrT?=
 =?us-ascii?Q?+XutRanNBWVi0McZT/v+QYSBsDDZ0QQ4eJw0A9rWKAnu5c5mHrunYeR7TWBH?=
 =?us-ascii?Q?EHJjmvDmcjNDrbHftPwtSlHI7raNrIacCwGoa/e6bJHcjQR3P7Sd1h8HLB8X?=
 =?us-ascii?Q?brvZNAlOxU8JVMnTSXZygDSdEnWL9RUD+nhWerCvl0FGHe6DCbV9tJJWifG/?=
 =?us-ascii?Q?vXbj9UhbM+er3TeZ6noLRr6r5Nw2CQvM1ZCuz+PBgAe2PcvaQ6ueKe4mgWN2?=
 =?us-ascii?Q?DSczWuV+TY+tj3nktA8aBy2cqR2aL4HxkcSZNSsx8e19++jP3w8/uHzz/zBU?=
 =?us-ascii?Q?nLSmQ2DZKVORRckvZb9pttiu/FnC3qy1rv/AXA/yZ+g2iFAfpW+0v2f2XeZp?=
 =?us-ascii?Q?EAdTX4rP2Uk7LGskvWazPE1cKKK1JTJ4Yk/fV5Tg8vkPsT/+i83HvTbcnGHh?=
 =?us-ascii?Q?UTACcBBzuLm/pSon4cuwo21zrhF2xxQUmOtDrmtQfoBBKOFVjhraYKsUjc1O?=
 =?us-ascii?Q?r7ej5ifhpyUt7q6O511vZl1zculZmysAkcLOIjCUxW0IrGQPoNKZ8RKNwlLD?=
 =?us-ascii?Q?FheTqVVcvUywH4PPrd/zlA7T?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d02c387-295f-48d2-5a47-08d8fb8713e3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5101.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 18:41:24.7817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2IZvd9kXcnclOv0TpbcnF7ojK+hQNmGHQGO0TCGPP14m8WK03OOKE85qlpT9HF6h1RE4Q+Abt6RjmqBu63EJ7L9S3SeAP/bY8T0gOglHxkE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4128
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add driver for tja1103 driver and for future NXP C45 PHYs.

Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 MAINTAINERS               |   6 +
 drivers/net/phy/Kconfig   |   6 +
 drivers/net/phy/Makefile  |   1 +
 drivers/net/phy/nxp-c45.c | 622 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 635 insertions(+)
 create mode 100644 drivers/net/phy/nxp-c45.c

diff --git a/MAINTAINERS b/MAINTAINERS
index a008b70f3c16..082a5eca8913 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12518,6 +12518,12 @@ F:	drivers/nvmem/
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
index 698bea312adc..fd2da80b5339 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -228,6 +228,12 @@ config NATIONAL_PHY
 	help
 	  Currently supports the DP83865 PHY.
 
+config NXP_C45_PHY
+	tristate "NXP C45 PHYs"
+	help
+	  Enable support for NXP C45 PHYs.
+	  Currently supports only the TJA1103 PHY.
+
 config NXP_TJA11XX_PHY
 	tristate "NXP TJA11xx PHYs support"
 	depends on HWMON
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index a13e402074cf..a18f095748b5 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -70,6 +70,7 @@ obj-$(CONFIG_MICROCHIP_PHY)	+= microchip.o
 obj-$(CONFIG_MICROCHIP_T1_PHY)	+= microchip_t1.o
 obj-$(CONFIG_MICROSEMI_PHY)	+= mscc/
 obj-$(CONFIG_NATIONAL_PHY)	+= national.o
+obj-$(CONFIG_NXP_C45_PHY)	+= nxp-c45.o
 obj-$(CONFIG_NXP_TJA11XX_PHY)	+= nxp-tja11xx.o
 obj-$(CONFIG_QSEMI_PHY)		+= qsemi.o
 obj-$(CONFIG_REALTEK_PHY)	+= realtek.o
diff --git a/drivers/net/phy/nxp-c45.c b/drivers/net/phy/nxp-c45.c
new file mode 100644
index 000000000000..2961799f7d05
--- /dev/null
+++ b/drivers/net/phy/nxp-c45.c
@@ -0,0 +1,622 @@
+// SPDX-License-Identifier: GPL-2.0
+/* NXP C45 PHY driver
+ * Copyright (C) 2021 NXP
+ * Copyright (C) 2021 Radu Pirea <radu-nicolae.pirea@oss.nxp.com>
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
+#define B100T1_PMAPMD_CTL		0x0834
+#define B100T1_PMAPMD_CONFIG_EN		BIT(15)
+#define B100T1_PMAPMD_MASTER		BIT(14)
+#define MASTER_MODE			(B100T1_PMAPMD_CONFIG_EN | B100T1_PMAPMD_MASTER)
+#define SLAVE_MODE			(B100T1_PMAPMD_CONFIG_EN)
+
+#define DEVICE_CONTROL			0x0040
+#define DEVICE_CONTROL_RESET		BIT(15)
+#define DEVICE_CONTROL_CONFIG_GLOBAL_EN	BIT(14)
+#define DEVICE_CONTROL_CONFIG_ALL_EN	BIT(13)
+#define RESET_POLL_NS			(250 * NSEC_PER_MSEC)
+
+#define PHY_CONTROL			0x8100
+#define PHY_CONFIG_EN			BIT(14)
+#define PHY_START_OP			BIT(0)
+
+#define PHY_CONFIG			0x8108
+#define PHY_CONFIG_AUTO			BIT(0)
+
+#define SIGNAL_QUALITY			0x8320
+#define SQI_VALID			BIT(14)
+#define SQI_MASK			GENMASK(2, 0)
+#define MAX_SQI				SQI_MASK
+
+#define CABLE_TEST			0x8330
+#define CABLE_TEST_ENABLE		BIT(15)
+#define CABLE_TEST_START		BIT(14)
+#define CABLE_TEST_VALID		BIT(13)
+#define CABLE_TEST_OK			0x00
+#define CABLE_TEST_SHORTED		0x01
+#define CABLE_TEST_OPEN			0x02
+#define CABLE_TEST_UNKNOWN		0x07
+
+#define PORT_CONTROL			0x8040
+#define PORT_CONTROL_EN			BIT(14)
+
+#define PORT_INFRA_CONTROL		0xAC00
+#define PORT_INFRA_CONTROL_EN		BIT(14)
+
+#define VND1_RXID			0xAFCC
+#define VND1_TXID			0xAFCD
+#define ID_ENABLE			BIT(15)
+
+#define ABILITIES			0xAFC4
+#define RGMII_ID_ABILITY		BIT(15)
+#define RGMII_ABILITY			BIT(14)
+#define RMII_ABILITY			BIT(10)
+#define REVMII_ABILITY			BIT(9)
+#define MII_ABILITY			BIT(8)
+#define SGMII_ABILITY			BIT(0)
+
+#define MII_BASIC_CONFIG		0xAFC6
+#define MII_BASIC_CONFIG_REV		BIT(8)
+#define MII_BASIC_CONFIG_SGMII		0x9
+#define MII_BASIC_CONFIG_RGMII		0x7
+#define MII_BASIC_CONFIG_RMII		0x5
+#define MII_BASIC_CONFIG_MII		0x4
+
+#define SYMBOL_ERROR_COUNTER		0x8350
+#define LINK_DROP_COUNTER		0x8352
+#define LINK_LOSSES_AND_FAILURES	0x8353
+#define R_GOOD_FRAME_CNT		0xA950
+#define R_BAD_FRAME_CNT			0xA952
+#define R_RXER_FRAME_CNT		0xA954
+#define RX_PREAMBLE_COUNT		0xAFCE
+#define TX_PREAMBLE_COUNT		0xAFCF
+#define RX_IPG_LENGTH			0xAFD0
+#define TX_IPG_LENGTH			0xAFD1
+#define COUNTERS_EN			BIT(15)
+
+#define CLK_25MHZ_PS_PERIOD		40000UL
+#define PS_PER_DEGREE			(CLK_25MHZ_PS_PERIOD / 360)
+#define MIN_ID_PS			8222U
+#define MAX_ID_PS			11300U
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
+	{ "phy_symbol_error_cnt", MDIO_MMD_VEND1, SYMBOL_ERROR_COUNTER, 0, GENMASK(15, 0) },
+	{ "phy_link_status_drop_cnt", MDIO_MMD_VEND1, LINK_DROP_COUNTER, 8, GENMASK(13, 8) },
+	{ "phy_link_availability_drop_cnt", MDIO_MMD_VEND1, LINK_DROP_COUNTER, 0, GENMASK(5, 0) },
+	{ "phy_link_loss_cnt", MDIO_MMD_VEND1, LINK_LOSSES_AND_FAILURES, 10, GENMASK(15, 10) },
+	{ "phy_link_failure_cnt", MDIO_MMD_VEND1, LINK_LOSSES_AND_FAILURES, 0, GENMASK(9, 0) },
+	{ "r_good_frame_cnt", MDIO_MMD_VEND1, R_GOOD_FRAME_CNT, 0, GENMASK(15, 0) },
+	{ "r_bad_frame_cnt", MDIO_MMD_VEND1, R_BAD_FRAME_CNT, 0, GENMASK(15, 0) },
+	{ "r_rxer_frame_cnt", MDIO_MMD_VEND1, R_RXER_FRAME_CNT, 0, GENMASK(15, 0) },
+	{ "rx_preamble_count", MDIO_MMD_VEND1, RX_PREAMBLE_COUNT, 0, GENMASK(5, 0) },
+	{ "tx_preamble_count", MDIO_MMD_VEND1, TX_PREAMBLE_COUNT, 0, GENMASK(5, 0) },
+	{ "rx_ipg_length", MDIO_MMD_VEND1, RX_IPG_LENGTH, 0, GENMASK(8, 0) },
+	{ "tx_ipg_length", MDIO_MMD_VEND1, TX_IPG_LENGTH, 0, GENMASK(8, 0) },
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
+		ret = phy_read_mmd(phydev, nxp_c45_hw_stats[i].mmd, nxp_c45_hw_stats[i].reg);
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
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, DEVICE_CONTROL, DEVICE_CONTROL_CONFIG_GLOBAL_EN |
+		      DEVICE_CONTROL_CONFIG_ALL_EN);
+	usleep_range(400, 450);
+
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, PORT_CONTROL, PORT_CONTROL_EN);
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, PHY_CONTROL, PHY_CONFIG_EN);
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, PORT_INFRA_CONTROL, PORT_INFRA_CONTROL_EN);
+
+	return 0;
+}
+
+static int nxp_c45_start_op(struct phy_device *phydev)
+{
+	int reg;
+
+	reg = phy_read_mmd(phydev, MDIO_MMD_VEND1, PHY_CONTROL);
+	reg |= PHY_START_OP;
+
+	return phy_write_mmd(phydev, MDIO_MMD_VEND1, PHY_CONTROL, reg);
+}
+
+static bool nxp_c45_can_sleep(struct phy_device *phydev)
+{
+	int reg;
+
+	reg = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_STAT1);
+	if (reg < 0)
+		return false;
+
+	return !!(reg & MDIO_STAT1_LPOWERABLE);
+}
+
+static int nxp_c45_resume(struct phy_device *phydev)
+{
+	int reg;
+
+	if (!nxp_c45_can_sleep(phydev))
+		return -EOPNOTSUPP;
+
+	reg = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_CTRL1);
+	reg &= ~MDIO_CTRL1_LPOWER;
+	phy_write_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_CTRL1, reg);
+
+	return 0;
+}
+
+static int nxp_c45_suspend(struct phy_device *phydev)
+{
+	int reg;
+
+	if (!nxp_c45_can_sleep(phydev))
+		return -EOPNOTSUPP;
+
+	reg = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_CTRL1);
+	reg |= MDIO_CTRL1_LPOWER;
+	phy_write_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_CTRL1, reg);
+
+	return 0;
+}
+
+static int nxp_c45_reset_done(struct phy_device *phydev)
+{
+	return !(phy_read_mmd(phydev, MDIO_MMD_VEND1, DEVICE_CONTROL) & DEVICE_CONTROL_RESET);
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
+	ret = phy_write_mmd(phydev, MDIO_MMD_VEND1, DEVICE_CONTROL, DEVICE_CONTROL_RESET);
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
+	return phy_write_mmd(phydev, MDIO_MMD_VEND1, CABLE_TEST,
+			     CABLE_TEST_ENABLE | CABLE_TEST_START);
+}
+
+static int nxp_c45_cable_test_get_status(struct phy_device *phydev,
+					 bool *finished)
+{
+	int ret;
+	u8 cable_test_result;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, CABLE_TEST);
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
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, CABLE_TEST, 0);
+
+	return nxp_c45_start_op(phydev);
+}
+
+static int nxp_c45_setup_master_slave(struct phy_device *phydev)
+{
+	switch (phydev->master_slave_set) {
+	case MASTER_SLAVE_CFG_MASTER_FORCE:
+	case MASTER_SLAVE_CFG_MASTER_PREFERRED:
+		phy_write_mmd(phydev, MDIO_MMD_PMAPMD, B100T1_PMAPMD_CTL, MASTER_MODE);
+		break;
+	case MASTER_SLAVE_CFG_SLAVE_PREFERRED:
+	case MASTER_SLAVE_CFG_SLAVE_FORCE:
+		phy_write_mmd(phydev, MDIO_MMD_PMAPMD, B100T1_PMAPMD_CTL, SLAVE_MODE);
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
+	reg = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, B100T1_PMAPMD_CTL);
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
+static int nxp_c45_set_loopback(struct phy_device *phydev, bool enable)
+{
+	int reg;
+
+	reg = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_CTRL1);
+	if (reg < 0)
+		return reg;
+
+	if (enable)
+		reg |= MDIO_PCS_CTRL1_LOOPBACK;
+	else
+		reg &= ~MDIO_PCS_CTRL1_LOOPBACK;
+
+	phy_write_mmd(phydev, MDIO_MMD_PCS, MDIO_CTRL1, reg);
+
+	phydev->loopback_enabled = enable;
+
+	phydev_dbg(phydev, "Loopback %s\n", enable ? "enabled" : "disabled");
+
+	return 0;
+}
+
+static int nxp_c45_get_sqi(struct phy_device *phydev)
+{
+	int reg;
+
+	reg = phy_read_mmd(phydev, MDIO_MMD_VEND1, SIGNAL_QUALITY);
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
+	return (phase_offset_raw - 738) / 9;
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
+		degree = tx_delay / PS_PER_DEGREE;
+		phy_write_mmd(phydev, MDIO_MMD_VEND1, VND1_TXID,
+			      ID_ENABLE | nxp_c45_get_phase_shift(degree));
+	}
+
+	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+	    phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
+		degree = rx_delay / PS_PER_DEGREE;
+		phy_write_mmd(phydev, MDIO_MMD_VEND1, VND1_RXID,
+			      ID_ENABLE | nxp_c45_get_phase_shift(degree));
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
+		ret = device_property_read_u32(&phydev->mdio.dev, "tx-internal-delay-ps",
+					       &priv->tx_delay);
+		if (ret) {
+			phydev_err(phydev, "tx-internal-delay-ps property missing\n");
+			return ret;
+		}
+		ret = nxp_c45_check_delay(phydev, priv->tx_delay);
+		if (ret) {
+			phydev_err(phydev, "tx-internal-delay-ps invalid value\n");
+			return ret;
+		}
+	}
+
+	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
+		ret = device_property_read_u32(&phydev->mdio.dev, "rx-internal-delay-ps",
+					       &priv->rx_delay);
+		if (ret) {
+			phydev_err(phydev, "rx-internal-delay-ps property missing\n");
+			return ret;
+		}
+		ret = nxp_c45_check_delay(phydev, priv->rx_delay);
+		if (ret) {
+			phydev_err(phydev, "rx-internal-delay-ps invalid value\n");
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
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, ABILITIES);
+	phydev_dbg(phydev, "Clause 45 managed PHY abilities 0x%x\n", ret);
+
+	switch (phydev->interface) {
+	case PHY_INTERFACE_MODE_RGMII:
+		if (!(ret & RGMII_ABILITY)) {
+			phydev_err(phydev, "rgmii mode not supported\n");
+			return -EINVAL;
+		}
+		phy_write_mmd(phydev, MDIO_MMD_VEND1, MII_BASIC_CONFIG, MII_BASIC_CONFIG_RGMII);
+		break;
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+		if (!(ret & RGMII_ID_ABILITY)) {
+			phydev_err(phydev, "rgmii-id, rgmii-txid, rgmii-rxid modes are not supported\n");
+			return -EINVAL;
+		}
+		phy_write_mmd(phydev, MDIO_MMD_VEND1, MII_BASIC_CONFIG, MII_BASIC_CONFIG_RGMII);
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
+		phy_write_mmd(phydev, MDIO_MMD_VEND1, MII_BASIC_CONFIG, MII_BASIC_CONFIG_MII);
+		break;
+	case PHY_INTERFACE_MODE_REVMII:
+		if (!(ret & REVMII_ABILITY)) {
+			phydev_err(phydev, "rev-mii mode not supported\n");
+			return -EINVAL;
+		}
+		phy_write_mmd(phydev, MDIO_MMD_VEND1, MII_BASIC_CONFIG, MII_BASIC_CONFIG_MII |
+			      MII_BASIC_CONFIG_REV);
+		break;
+	case PHY_INTERFACE_MODE_RMII:
+		if (!(ret & RMII_ABILITY)) {
+			phydev_err(phydev, "rmii mode not supported\n");
+			return -EINVAL;
+		}
+		phy_write_mmd(phydev, MDIO_MMD_VEND1, MII_BASIC_CONFIG, MII_BASIC_CONFIG_RMII);
+		break;
+	case PHY_INTERFACE_MODE_SGMII:
+		if (!(ret & SGMII_ABILITY)) {
+			phydev_err(phydev, "sgmii mode not supported\n");
+			return -EINVAL;
+		}
+		phy_write_mmd(phydev, MDIO_MMD_VEND1, MII_BASIC_CONFIG, MII_BASIC_CONFIG_SGMII);
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
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, PHY_CONFIG);
+	ret &= ~PHY_CONFIG_AUTO;
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, PHY_CONFIG, ret);
+
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, LINK_DROP_COUNTER, COUNTERS_EN);
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, RX_PREAMBLE_COUNT, COUNTERS_EN);
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, TX_PREAMBLE_COUNT, COUNTERS_EN);
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, RX_IPG_LENGTH, COUNTERS_EN);
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, TX_IPG_LENGTH, COUNTERS_EN);
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
+		.suspend		= nxp_c45_suspend,
+		.resume			= nxp_c45_resume,
+		.get_sset_count		= nxp_c45_get_sset_count,
+		.get_strings		= nxp_c45_get_strings,
+		.get_stats		= nxp_c45_get_stats,
+		.cable_test_start	= nxp_c45_cable_test_start,
+		.cable_test_get_status	= nxp_c45_cable_test_get_status,
+		.set_loopback		= nxp_c45_set_loopback,
+		.get_sqi		= nxp_c45_get_sqi,
+		.get_sqi_max		= nxp_c45_get_sqi_max,
+	},
+};
+
+module_phy_driver(nxp_c45_driver);
+
+static struct mdio_device_id __maybe_unused nxp_c45_tbl[] = {
+	{ PHY_ID_MATCH_MODEL(PHY_ID_BASE_T1) }
+};
+
+MODULE_DEVICE_TABLE(mdio, nxp_c45_tbl);
+
+MODULE_AUTHOR("Radu Pirea <radu-nicolae.pirea@oss.nxp.com>");
+MODULE_DESCRIPTION("NXP C45 PHY driver");
+MODULE_LICENSE("GPL v2");
-- 
2.31.1

