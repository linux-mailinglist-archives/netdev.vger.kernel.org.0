Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C124E2A0C81
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 18:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbgJ3RaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 13:30:04 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:58276 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbgJ3RaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 13:30:03 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 09UHTrPa053573;
        Fri, 30 Oct 2020 12:29:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1604078993;
        bh=hld/OnRKzHIEUCvZwFdM8WfUkDrNt7So0/3bngitfUY=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=kTsIlKEwplPXBN++1FHyD1p499p6mBeoQYWJZ0DUXC3uLkuU8/lyMMz/hdA2JadFo
         cXjJ1TZ/w9VCCNVkJP/MOy/fOA4k143DyFYST0PpqhHj1n1f2MW8xE7cU77y41FYGr
         Of5z6+DG4XnCPhHP8xReDYAevjIa6MBhrXmECDaY=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 09UHTrCS056298
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 30 Oct 2020 12:29:53 -0500
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 30
 Oct 2020 12:29:53 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 30 Oct 2020 12:29:53 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 09UHTqQX046332;
        Fri, 30 Oct 2020 12:29:53 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <robh@kernel.org>
CC:     <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v3 4/4] net: phy: dp83td510: Add support for the DP83TD510 Ethernet PHY
Date:   Fri, 30 Oct 2020 12:29:50 -0500
Message-ID: <20201030172950.12767-5-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201030172950.12767-1-dmurphy@ti.com>
References: <20201030172950.12767-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DP83TD510E is an ultra-low power Ethernet physical layer transceiver
that supports 10M single pair cable.

The device supports both 2.4-V p2p and 1-V p2p output voltage as defined
by IEEE 802.3cg 10Base-T1L specfications. These modes can be forced via
the device tree or the device is defaulted to auto negotiation to
determine the proper p2p voltage.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/Kconfig     |   6 +
 drivers/net/phy/Makefile    |   1 +
 drivers/net/phy/dp83td510.c | 681 ++++++++++++++++++++++++++++++++++++
 3 files changed, 688 insertions(+)
 create mode 100644 drivers/net/phy/dp83td510.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 698bea312adc..017252e1504c 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -302,6 +302,12 @@ config DP83869_PHY
 	  Currently supports the DP83869 PHY.  This PHY supports copper and
 	  fiber connections.
 
+config DP83TD510_PHY
+	tristate "Texas Instruments DP83TD510 10M Single Pair Ethernet PHY"
+	help
+	  Support for the DP83TD510 Ethernet PHY. This PHY supports a 10M single
+	  pair Ethernet connection.
+
 config VITESSE_PHY
 	tristate "Vitesse PHYs"
 	help
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index a13e402074cf..bf62ce211eb4 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -56,6 +56,7 @@ obj-$(CONFIG_DP83848_PHY)	+= dp83848.o
 obj-$(CONFIG_DP83867_PHY)	+= dp83867.o
 obj-$(CONFIG_DP83869_PHY)	+= dp83869.o
 obj-$(CONFIG_DP83TC811_PHY)	+= dp83tc811.o
+obj-$(CONFIG_DP83TD510_PHY)	+= dp83td510.o
 obj-$(CONFIG_FIXED_PHY)		+= fixed_phy.o
 obj-$(CONFIG_ICPLUS_PHY)	+= icplus.o
 obj-$(CONFIG_INTEL_XWAY_PHY)	+= intel-xway.o
diff --git a/drivers/net/phy/dp83td510.c b/drivers/net/phy/dp83td510.c
new file mode 100644
index 000000000000..0d1471bdcd45
--- /dev/null
+++ b/drivers/net/phy/dp83td510.c
@@ -0,0 +1,681 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Driver for the Texas Instruments DP83TD510 PHY
+ * Copyright (C) 2020 Texas Instruments Incorporated - https://www.ti.com/
+ */
+
+#include <linux/ethtool.h>
+#include <linux/etherdevice.h>
+#include <linux/kernel.h>
+#include <linux/mii.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/phy.h>
+#include <linux/netdevice.h>
+
+#define DP83TD510E_PHY_ID	0x20000180
+#define DP83TD510_DEVADDR_AN	0x7
+#define DP83TD510_DEVADDR	0x1f
+#define DP83TD510_PMD_DEVADDR	0x1
+
+#define DP83TD510_MII_REG	0x0
+#define DP83TD510_PHY_STAT	0x10
+#define DP83TD510_GEN_CFG	0x11
+#define DP83TD510_INT_REG1	0x12
+#define DP83TD510_INT_REG2	0x13
+#define DP83TD510_MAC_CFG_1	0x17
+
+#define DP83TD510_ANEG_CTRL	0x200
+#define DP83TD510_PMD_CTRL	0x834
+
+#define DP83TD510_SOR_1		0x467
+
+#define DP83TD510_HW_RESET	BIT(15)
+#define DP83TD510_SW_RESET	BIT(14)
+
+/* GEN CFG bits */
+#define DP83TD510_INT_OE	BIT(0)
+#define DP83TD510_INT_EN	BIT(1)
+
+/* INT REG 1 bits */
+#define DP83TD510_INT1_ESD_EN	BIT(3)
+#define DP83TD510_INT1_LINK_EN	BIT(5)
+#define DP83TD510_INT1_RHF_EN	BIT(7)
+#define DP83TD510_INT1_ESD	BIT(11)
+#define DP83TD510_INT1_LINK	BIT(13)
+#define DP83TD510_INT1_RHF	BIT(15)
+
+/* INT REG 2 bits */
+#define DP83TD510_INT2_POR_EN	BIT(0)
+#define DP83TD510_INT2_POL_EN	BIT(1)
+#define DP83TD510_INT2_PAGE_EN	BIT(5)
+#define DP83TD510_INT2_POR	BIT(8)
+#define DP83TD510_INT2_POL	BIT(9)
+#define DP83TD510_INT2_PAGE	BIT(13)
+
+/* MAC CFG bits */
+#define DP83TD510_RX_CLK_SHIFT	BIT(12)
+#define DP83TD510_TX_CLK_SHIFT	BIT(11)
+
+#define DP83TD510_MASTER_MODE	BIT(14)
+#define DP83TD510_AUTO_NEG_EN	BIT(12)
+#define DP83TD510_2_4V		BIT(7)
+#define DP83TD510_RGMII		BIT(8)
+
+#define DP83TD510_FIFO_DEPTH_MASK	GENMASK(6, 5)
+#define DP83TD510_FIFO_DEPTH_4_B_NIB	0
+#define DP83TD510_FIFO_DEPTH_5_B_NIB	BIT(5)
+#define DP83TD510_FIFO_DEPTH_6_B_NIB	BIT(6)
+#define DP83TD510_FIFO_DEPTH_8_B_NIB	(BIT(5) | BIT(6))
+
+const int dp83td510_feature_array[3] = {
+	ETHTOOL_LINK_MODE_10baseT1L_Half_BIT,
+	ETHTOOL_LINK_MODE_10baseT1L_Full_BIT,
+	ETHTOOL_LINK_MODE_TP_BIT,
+};
+
+struct dp83td510_private {
+	bool hi_diff_output;
+	u32 tx_fifo_depth;
+	u32 rgmii_delay;
+	bool is_rgmii;
+};
+
+struct dp83td510_init_reg {
+	int reg;
+	int val;
+};
+
+static struct dp83td510_init_reg dp83td510_master_1_0[] = {
+	{ 0x000d, 0x0001 }, /* force 1.0v swing */
+	{ 0x000e, 0x08f6 },
+	{ 0x000d, 0x4001 },
+	{ 0x000e, 0x0000 },
+	{ 0x0608, 0x003b }, /* disable_0_transition */
+	{ 0x0862, 0x39f8 }, /* AGC Gain during Autoneg */
+	{ 0x081a, 0x67c0 }, /* deq offset for 1V swing */
+	{ 0x081c, 0xfb62 }, /* deq offset for 2.4V swing */
+	{ 0x0830, 0x05a3 }, /* Enable energy lost fallback */
+	{ 0x0855, 0x1b55 }, /* MSE Threshold change */
+	{ 0x0831, 0x0403 }, /* energy detect threshold */
+	{ 0x0856, 0x1800 }, /* good1 MSE threshold change */
+	{ 0x0857, 0x8fa0 }, /* Enable fallback to phase 1 on watchdog trigger */
+	{ 0x0871, 0x000c }, /* TED input changed to slicer_in without FFE */
+	{ 0x0883, 0x022e }, /* Enable Rx Filter, Change PGA threshold for Short Cable detection */
+	{ 0x0402, 0x1800 }, /* Adjusr LD swing */
+	{ 0x0878, 0x2248 }, /* Change PI up/down polarity */
+	{ 0x010c, 0x0008 }, /* tx filter coefficient */
+	{ 0x0112, 0x1212 }, /* tx filter scaling factor */
+	{ 0x0809, 0x5c80 }, /* AGC retrain */
+	{ 0x0803, 0x1529 }, /* Master Ph1 Back-off */
+	{ 0x0804, 0x1a33 }, /* Master Ph1 Back-off */
+	{ 0x0805, 0x1f3d }, /* Master Ph1 Back-off */
+	{ 0x0850, 0x045b }, /* hybrid gain & delay */
+	{ 0x0874, 0x6967 }, /* kp step 0 for master */
+	{ 0x0852, 0x7800 }, /* FAGC init gain */
+	{ 0x0806, 0x1e1e }, /* Master/Slave Ph2 Back-off */
+	{ 0x0807, 0x2525 }, /* Master/Slave Ph2 Back-off */
+	{ 0x0808, 0x2c2c }, /* Master/Slave Ph2 Back-off */
+	{ 0x0850, 0x0590 }, /* Hybrid Gain/Delay Code */
+	{ 0x0827, 0x4000 }, /* Echo Fixed Delay */
+	{ 0x0849, 0x0fe4 }, /* Hybrid Cal enable */
+	{ 0x084b, 0x04b5 }, /* Echo Score Sel */
+	{ 0x0018, 0x0043 }, /* Set CRS/RX_DV pin as RX_DV for RMII repeater mode */
+};
+
+static struct dp83td510_init_reg dp83td510_slave_1_0[] = {
+	{ 0x000d, 0x0001 }, /* force 1.0v swing */
+	{ 0x000d, 0x4001 },
+	{ 0x000e, 0x0000 },
+	{ 0x0608, 0x003b }, /* disable_0_transition */
+	{ 0x0862, 0x39f8 }, /* AGC Gain during Autoneg */
+	{ 0x081a, 0x67c0 }, /* deq offset for 1V swing */
+	{ 0x081c, 0xfb62 }, /* deq offset for 2.4V swing */
+	{ 0x0830, 0x05a3 }, /* Enable energy lost fallback */
+	{ 0x0855, 0x1b55 }, /* MSE Threshold change */
+	{ 0x0831, 0x0403 }, /* energy detect threshold */
+	{ 0x0856, 0x1800 }, /* good1 MSE threshold change */
+	{ 0x0857, 0x8fa0 }, /* Enable fallback to phase 1 on watchdog trigger */
+	{ 0x0871, 0x000c }, /* TED input changed to slicer_in without FFE */
+	{ 0x0883, 0x022e }, /* Enable Rx Filter, PGA threshold for Short Cable detection */
+	{ 0x0402, 0x1800 }, /* Adjusr LD swing */
+	{ 0x0878, 0x2248 }, /* Change PI up/down polarity */
+	{ 0x010c, 0x0008 }, /* tx filter coefficient */
+	{ 0x0112, 0x1212 }, /* tx filter scaling factor */
+	{ 0x0809, 0x5c80 }, /* AGC retrain */
+	{ 0x0803, 0x1529 }, /* Master Ph1 Back-off */
+	{ 0x0804, 0x1a33 }, /* Master Ph1 Back-off */
+	{ 0x0805, 0x1f3d }, /* Master Ph1 Back-off */
+	{ 0x0850, 0x045b }, /* hybrid gain & delay */
+	{ 0x0874, 0x6967 }, /* kp step 0 for master */
+	{ 0x0852, 0x7800 }, /* FAGC init gain */
+	{ 0x0806, 0x1e1e }, /* Master/Slave Ph2 Back-off */
+	{ 0x0807, 0x2525 }, /* Master/Slave Ph2 Back-off */
+	{ 0x0808, 0x2c2c }, /* Master/Slave Ph2 Back-off */
+	{ 0x0850, 0x0590 }, /* Hybrid Gain/Delay Code */
+	{ 0x0827, 0x4000 }, /* Echo Fixed Delay */
+	{ 0x0849, 0x0fe4 }, /* Hybrid Cal enable */
+	{ 0x084b, 0x04b5 }, /* Echo Score Sel */
+	{ 0x0018, 0x0043 }, /* Set CRS/RX_DV pin as RX_DV for RMII repeater mode */
+};
+
+static struct dp83td510_init_reg dp83td510_master_2_4[] = {
+	{ 0x000d, 0x0001 }, /* force 2.4v swing */
+	{ 0x000e, 0x08f6 },
+	{ 0x000d, 0x4001 },
+	{ 0x000e, 0x1000 },
+	{ 0x0608, 0x003b }, /* disable_0_transition */
+	{ 0x0862, 0x39f8 }, /* AGC Gain during Autoneg */
+	{ 0x081a, 0x67c0 }, /* deq offset for 1V swing */
+	{ 0x081c, 0xfb62 }, /* deq offset for 2.4V swing */
+	{ 0x0830, 0x05a3 }, /* Enable energy lost fallback */
+	{ 0x0855, 0x1b55 }, /* MSE Threshold change */
+	{ 0x0831, 0x0403 }, /* energy detect threshold */
+	{ 0x0856, 0x1800 }, /* good1 MSE threshold change */
+	{ 0x0857, 0x8fa0 }, /* Enable fallback to phase 1 on watchdog trigger */
+	{ 0x0871, 0x000c }, /* TED input changed to slicer_in without FFE */
+	{ 0x0883, 0x022e }, /* Enable Rx Filter, Change PGA threshold for Short Cable detection */
+	{ 0x0402, 0x1800 }, /* Adjusr LD swing */
+	{ 0x0878, 0x2248 }, /* Change PI up/down polarity */
+	{ 0x010c, 0x0008 }, /* tx filter coefficient */
+	{ 0x0112, 0x1212 }, /* tx filter scaling factor */
+	{ 0x0809, 0x5c80 }, /* AGC retrain */
+	{ 0x0803, 0x1529 }, /* Master Ph1 Back-off */
+	{ 0x0804, 0x1a33 }, /* Master Ph1 Back-off */
+	{ 0x0805, 0x1f3d }, /* Master Ph1 Back-off */
+	{ 0x0850, 0x045b }, /* hybrid gain & delay */
+	{ 0x0874, 0x6967 }, /* kp step 0 for master */
+	{ 0x0852, 0x7800 }, /* FAGC init gain */
+	{ 0x0806, 0x1e1e }, /* Master/Slave Ph2 Back-off */
+	{ 0x0807, 0x2525 }, /* Master/Slave Ph2 Back-off */
+	{ 0x0808, 0x2c2c }, /* Master/Slave Ph2 Back-off */
+	{ 0x0850, 0x0590 }, /* Hybrid Gain/Delay Code */
+	{ 0x0827, 0x4000 }, /* Echo Fixed Delay */
+	{ 0x0849, 0x0fe4 }, /* Hybrid Cal enable */
+	{ 0x084b, 0x04b5 }, /* Echo Score Sel */
+	{ 0x0018, 0x0043 }, /* Set CRS/RX_DV pin as RX_DV for RMII repeater mode */
+};
+
+static struct dp83td510_init_reg dp83td510_slave_2_4[] = {
+	{ 0x000d, 0x0001}, /* force 2.4v swing */
+	{ 0x000e, 0x08f6},
+	{ 0x000d, 0x4001},
+	{ 0x000e, 0x1000},
+	{ 0x0608, 0x003b}, /* disable_0_transition */
+	{ 0x0862, 0x39f8}, /* AGC Gain during Autoneg */
+	{ 0x081a, 0x67c0}, /* deq offset for 1V swing */
+	{ 0x081c, 0xfb62}, /* deq offset for 2.4V swing */
+	{ 0x0830, 0x05a3}, /* Enable energy lost fallback */
+	{ 0x0855, 0x1b55}, /* MSE Threshold change */
+	{ 0x0831, 0x0403}, /* energy detect threshold */
+	{ 0x0856, 0x1800}, /* good1 MSE threshold change */
+	{ 0x0857, 0x8fa0}, /* Enable fallback to phase 1 on watchdog trigger */
+	{ 0x0871, 0x000c}, /* TED input changed to slicer_in without FFE */
+	{ 0x0883, 0x022e}, /* Enable Rx Filter, Change PGA threshold for Short Cable detection */
+	{ 0x0402, 0x1800}, /* Adjusr LD swing */
+	{ 0x0878, 0x2248}, /* Change PI up/down polarity */
+	{ 0x010c, 0x0008}, /* tx filter coefficient */
+	{ 0x0112, 0x1212}, /* tx filter scaling factor */
+	{ 0x0809, 0x5c80}, /* AGC retrain */
+	{ 0x0803, 0x1529}, /* Master Ph1 Back-off */
+	{ 0x0804, 0x1a33}, /* Master Ph1 Back-off */
+	{ 0x0805, 0x1f3d}, /* Master Ph1 Back-off */
+	{ 0x0850, 0x045b}, /* hybrid gain & delay */
+	{ 0x0874, 0x6967}, /* kp step 0 for master */
+	{ 0x0852, 0x7800}, /* FAGC init gain */
+	{ 0x0806, 0x1e1e}, /* Master/Slave Ph2 Back-off */
+	{ 0x0807, 0x2525}, /* Master/Slave Ph2 Back-off */
+	{ 0x0808, 0x2c2c}, /* Master/Slave Ph2 Back-off */
+	{ 0x0850, 0x0590}, /* Hybrid Gain/Delay Code */
+	{ 0x0827, 0x4000}, /* Echo Fixed Delay */
+	{ 0x0849, 0x0fe4}, /* Hybrid Cal enable */
+	{ 0x084b, 0x04b5}, /* Echo Score Sel */
+	{ 0x0018, 0x0043}, /* Set CRS/RX_DV pin as RX_DV for RMII repeater mode */
+};
+
+static struct dp83td510_init_reg dp83td510_auto_neg[] = {
+	{ 0x608, 0x003b }, /* disable_0_transition */
+	{ 0x862, 0x39f8 }, /* AGC Gain during Autoneg */
+	{ 0x81a, 0x67c0 }, /* deq offset for 1V swing */
+	{ 0x81c, 0xfb62 }, /* deq offset for 2.4V swing */
+	{ 0x830, 0x05a3 }, /* Enable energy lost fallback */
+	{ 0x855, 0x1b55 }, /* MSE Threshold change */
+	{ 0x831, 0x0403 }, /* energy detect threshold */
+	{ 0x856, 0x1800 }, /* good1 MSE threshold change */
+	{ 0x857, 0x8fa0 }, /* Enable fallback to phase 1 on watchdog trigger */
+	{ 0x871, 0x000c }, /* TED input changed to slicer_in without FFE */
+	{ 0x883, 0x022e }, /* Enable Rx Filter Change PGA threshold for Short Cable detection */
+	{ 0x402, 0x1800 }, /* Adjusr LD swing */
+	{ 0x878, 0x2248 }, /* Change PI up/down polarity */
+	{ 0x10c, 0x0008 }, /* tx filter coefficient */
+	{ 0x112, 0x1212 }, /* tx filter scaling factor */
+	{ 0x809, 0x5c80 }, /* AGC retrain */
+	{ 0x803, 0x1529 }, /* Master Ph1 Back-off */
+	{ 0x804, 0x1a33 }, /* Master Ph1 Back-off */
+	{ 0x805, 0x1f3d }, /* Master Ph1 Back-off */
+	{ 0x850, 0x045b }, /* hybrid gain & delay */
+	{ 0x874, 0x6967 }, /* kp step 0 for master */
+	{ 0x852, 0x7800 }, /* FAGC init gain */
+	{ 0x806, 0x1e1e }, /* Master/Slave Ph2 Back-off */
+	{ 0x807, 0x2525 }, /* Master/Slave Ph2 Back-off */
+	{ 0x808, 0x2c2c }, /* Master/Slave Ph2 Back-off */
+	{ 0x850, 0x0590 }, /* Hybrid Gain/Delay Code */
+	{ 0x827, 0x4000 }, /* Echo Fixed Delay */
+	{ 0x849, 0x0fe4 }, /* Hybrid Cal enable */
+	{ 0x84b, 0x04b5 }, /* Echo Score Sel */
+	{ 0x018, 0x0043 }, /* Set CRS/RX_DV pin as RX_DV for RMII repeater mode */
+};
+
+static int dp83td510_ack_interrupt(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = phy_read(phydev, DP83TD510_INT_REG1);
+	if (ret < 0)
+		return ret;
+
+	ret = phy_read(phydev, DP83TD510_INT_REG2);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int dp83td510_config_intr(struct phy_device *phydev)
+{
+	int int_status;
+	int gen_cfg_val;
+	int ret;
+
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		int_status = phy_read(phydev, DP83TD510_INT_REG1);
+		if (int_status < 0)
+			return int_status;
+
+		int_status = (DP83TD510_INT1_ESD_EN | DP83TD510_INT1_LINK_EN |
+			      DP83TD510_INT1_RHF_EN);
+
+		ret = phy_write(phydev, DP83TD510_INT_REG1, int_status);
+		if (ret)
+			return ret;
+
+		int_status = phy_read(phydev, DP83TD510_INT_REG2);
+		if (int_status < 0)
+			return int_status;
+
+		int_status = (DP83TD510_INT2_POR | DP83TD510_INT2_POL |
+				DP83TD510_INT2_PAGE);
+
+		ret = phy_write(phydev, DP83TD510_INT_REG2, int_status);
+		if (ret)
+			return ret;
+
+		gen_cfg_val = phy_read(phydev, DP83TD510_GEN_CFG);
+		if (gen_cfg_val < 0)
+			return gen_cfg_val;
+
+		gen_cfg_val |= DP83TD510_INT_OE | DP83TD510_INT_EN;
+
+	} else {
+		ret = phy_write(phydev, DP83TD510_INT_REG1, 0);
+		if (ret)
+			return ret;
+
+		ret = phy_write(phydev, DP83TD510_INT_REG2, 0);
+		if (ret)
+			return ret;
+
+		gen_cfg_val = phy_read(phydev, DP83TD510_GEN_CFG);
+		if (gen_cfg_val < 0)
+			return gen_cfg_val;
+
+		gen_cfg_val &= ~DP83TD510_INT_EN;
+	}
+
+	return phy_write(phydev, DP83TD510_GEN_CFG, gen_cfg_val);
+}
+
+static int dp83td510_configure_mode(struct phy_device *phydev)
+{
+	struct dp83td510_private *dp83td510 = phydev->priv;
+	struct dp83td510_init_reg *init_data;
+	int size;
+	int ret;
+	int i;
+
+	ret = phy_set_bits(phydev, DP83TD510_MII_REG, DP83TD510_HW_RESET);
+	if (ret < 0)
+		return ret;
+
+	switch (phydev->master_slave_set) {
+	case MASTER_SLAVE_CFG_MASTER_FORCE:
+		if (dp83td510->hi_diff_output) {
+			size = ARRAY_SIZE(dp83td510_master_2_4);
+			init_data = dp83td510_master_2_4;
+		} else {
+			size = ARRAY_SIZE(dp83td510_master_1_0);
+			init_data = dp83td510_master_1_0;
+		}
+		break;
+	case MASTER_SLAVE_CFG_SLAVE_FORCE:
+		if (dp83td510->hi_diff_output) {
+			size = ARRAY_SIZE(dp83td510_slave_2_4);
+			init_data = dp83td510_slave_2_4;
+		} else {
+			size = ARRAY_SIZE(dp83td510_slave_1_0);
+			init_data = dp83td510_slave_1_0;
+		}
+		break;
+	case MASTER_SLAVE_CFG_UNKNOWN:
+	case MASTER_SLAVE_CFG_UNSUPPORTED:
+		phydev_warn(phydev, "Unsupported Master/Slave mode\n");
+		return -ENOTSUPP;
+	case MASTER_SLAVE_CFG_SLAVE_PREFERRED:
+	case MASTER_SLAVE_CFG_MASTER_PREFERRED:
+	default:
+		size = ARRAY_SIZE(dp83td510_auto_neg);
+		init_data = dp83td510_auto_neg;
+		break;
+	};
+
+	for (i = 0; i < size; i++) {
+		ret = phy_write_mmd(phydev, DP83TD510_DEVADDR, init_data[i].reg,
+				    init_data[i].val);
+		if (ret)
+			return ret;
+	}
+
+	return phy_set_bits(phydev, DP83TD510_MII_REG, DP83TD510_SW_RESET);
+}
+
+static int dp83td510_read_status(struct phy_device *phydev)
+{
+	int mst_slave_cfg;
+	int auto_neg = 0;
+	int ret;
+
+	ret = genphy_read_status_fixed(phydev);
+	if (ret)
+		return ret;
+
+	mst_slave_cfg = phy_read_mmd(phydev, DP83TD510_PMD_DEVADDR, DP83TD510_PMD_CTRL);
+	mst_slave_cfg = DP83TD510_MASTER_MODE;
+	if (mst_slave_cfg < 0)
+		return mst_slave_cfg;
+
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, phydev->supported))
+		auto_neg = 1;
+
+	if (mst_slave_cfg & DP83TD510_MASTER_MODE) {
+		if (auto_neg) {
+			phydev->master_slave_get = MASTER_SLAVE_CFG_MASTER_PREFERRED;
+			phydev->master_slave_set = MASTER_SLAVE_CFG_MASTER_PREFERRED;
+		} else {
+			phydev->master_slave_get = MASTER_SLAVE_CFG_MASTER_FORCE;
+			phydev->master_slave_set = MASTER_SLAVE_CFG_MASTER_FORCE;
+		}
+	} else {
+		if (auto_neg) {
+			phydev->master_slave_get = MASTER_SLAVE_CFG_SLAVE_PREFERRED;
+			phydev->master_slave_set = MASTER_SLAVE_CFG_SLAVE_PREFERRED;
+		} else {
+			phydev->master_slave_get = MASTER_SLAVE_CFG_SLAVE_FORCE;
+			phydev->master_slave_set = MASTER_SLAVE_CFG_SLAVE_FORCE;
+		}
+	}
+
+	return 0;
+}
+
+static int dp83td510_get_features(struct phy_device *phydev)
+{
+	linkmode_set_bit_array(dp83td510_feature_array,
+			       ARRAY_SIZE(dp83td510_feature_array),
+			       phydev->supported);
+
+	return 0;
+}
+
+static int dp83td510_config_aneg(struct phy_device *phydev)
+{
+	int pmd_ctrl = DP83TD510_MASTER_MODE;
+	int ret;
+
+	switch (phydev->master_slave_set) {
+	case MASTER_SLAVE_CFG_MASTER_PREFERRED:
+	case MASTER_SLAVE_CFG_MASTER_FORCE:
+		if (phydev->autoneg)
+			linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, phydev->supported);
+		else
+			linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, phydev->supported);
+
+		pmd_ctrl = DP83TD510_MASTER_MODE;
+		break;
+	case MASTER_SLAVE_CFG_SLAVE_PREFERRED:
+	case MASTER_SLAVE_CFG_SLAVE_FORCE:
+		if (phydev->autoneg)
+			linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, phydev->supported);
+		else
+			linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, phydev->supported);
+
+		pmd_ctrl = 0;
+		break;
+	case MASTER_SLAVE_CFG_UNKNOWN:
+	case MASTER_SLAVE_CFG_UNSUPPORTED:
+	default:
+		phydev_warn(phydev, "Unsupported Master/Slave mode\n");
+		return -ENOTSUPP;
+	}
+
+	if (phydev->autoneg) {
+		ret = phy_modify_mmd(phydev, DP83TD510_DEVADDR_AN,
+				     DP83TD510_ANEG_CTRL,
+				     DP83TD510_AUTO_NEG_EN,
+				     DP83TD510_AUTO_NEG_EN);
+		if (ret)
+			return ret;
+	} else {
+		ret = phy_modify_mmd(phydev, DP83TD510_DEVADDR_AN,
+				     DP83TD510_ANEG_CTRL,
+				     DP83TD510_AUTO_NEG_EN, 0);
+		if (ret)
+			return ret;
+
+		ret = phy_modify_mmd(phydev, DP83TD510_PMD_DEVADDR,
+				     DP83TD510_PMD_CTRL,
+				     DP83TD510_MASTER_MODE, pmd_ctrl);
+		if (ret)
+			return ret;
+	}
+
+	return dp83td510_configure_mode(phydev);
+}
+
+static int dp83td510_config_init(struct phy_device *phydev)
+{
+	struct dp83td510_private *dp83td510 = phydev->priv;
+	int mst_slave_cfg;
+	int ret = 0;
+
+	if (phy_interface_is_rgmii(phydev)) {
+		if (dp83td510->rgmii_delay) {
+			ret = phy_set_bits_mmd(phydev, DP83TD510_DEVADDR,
+					       DP83TD510_MAC_CFG_1, dp83td510->rgmii_delay);
+			if (ret)
+				return ret;
+		}
+	}
+
+	if (phydev->interface == PHY_INTERFACE_MODE_RMII) {
+		ret = phy_modify(phydev, DP83TD510_GEN_CFG,
+				 DP83TD510_FIFO_DEPTH_MASK,
+				 dp83td510->tx_fifo_depth);
+		if (ret)
+			return ret;
+	}
+
+	mst_slave_cfg = phy_read_mmd(phydev, DP83TD510_PMD_DEVADDR, DP83TD510_PMD_CTRL);
+	mst_slave_cfg = DP83TD510_MASTER_MODE;
+	if (mst_slave_cfg < 0)
+		return mst_slave_cfg;
+
+	if (mst_slave_cfg & DP83TD510_MASTER_MODE) {
+		if(phydev->autoneg) {
+			phydev->master_slave_get = MASTER_SLAVE_CFG_MASTER_PREFERRED;
+			phydev->master_slave_set = MASTER_SLAVE_CFG_MASTER_PREFERRED;
+		} else {
+			phydev->master_slave_get = MASTER_SLAVE_CFG_MASTER_FORCE;
+			phydev->master_slave_set = MASTER_SLAVE_CFG_MASTER_FORCE;
+		}
+	} else {
+		if(phydev->autoneg) {
+			phydev->master_slave_get = MASTER_SLAVE_CFG_SLAVE_PREFERRED;
+			phydev->master_slave_set = MASTER_SLAVE_CFG_SLAVE_PREFERRED;
+		} else {
+			phydev->master_slave_get = MASTER_SLAVE_CFG_SLAVE_FORCE;
+			phydev->master_slave_set = MASTER_SLAVE_CFG_SLAVE_FORCE;
+		}
+	}
+
+	return 0;
+}
+
+static int dp83td510_phy_reset(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = phy_set_bits(phydev, DP83TD510_MII_REG, DP83TD510_SW_RESET);
+	if (ret < 0)
+		return ret;
+
+	usleep_range(10, 20);
+
+	return dp83td510_config_init(phydev);
+}
+
+static int dp83td510_read_straps(struct phy_device *phydev)
+{
+	struct dp83td510_private *dp83td510 = phydev->priv;
+	int strap;
+
+	strap = phy_read_mmd(phydev, DP83TD510_DEVADDR, DP83TD510_SOR_1);
+	if (strap < 0)
+		return strap;
+
+	if (strap & DP83TD510_RGMII)
+		dp83td510->is_rgmii = true;
+
+	return 0;
+};
+
+#if IS_ENABLED(CONFIG_OF_MDIO)
+static int dp83td510_of_init(struct phy_device *phydev)
+{
+	struct dp83td510_private *dp83td510 = phydev->priv;
+	struct device *dev = &phydev->mdio.dev;
+	struct device_node *of_node = dev->of_node;
+	s32 rx_int_delay;
+	s32 tx_int_delay;
+	int ret;
+
+	if (!of_node)
+		return -ENODEV;
+
+	ret = dp83td510_read_straps(phydev);
+	if (ret)
+		return ret;
+
+	dp83td510->hi_diff_output = device_property_read_bool(&phydev->mdio.dev,
+							      "tx-rx-output-high");
+
+	if (device_property_read_u32(&phydev->mdio.dev, "tx-fifo-depth",
+				     &dp83td510->tx_fifo_depth))
+		dp83td510->tx_fifo_depth = DP83TD510_FIFO_DEPTH_5_B_NIB;
+
+	switch (dp83td510->tx_fifo_depth) {
+	case 4:
+		dp83td510->tx_fifo_depth = DP83TD510_FIFO_DEPTH_4_B_NIB;
+		break;
+	case 5:
+		dp83td510->tx_fifo_depth = DP83TD510_FIFO_DEPTH_5_B_NIB;
+		break;
+	case 6:
+		dp83td510->tx_fifo_depth = DP83TD510_FIFO_DEPTH_6_B_NIB;
+		break;
+	case 8:
+		dp83td510->tx_fifo_depth = DP83TD510_FIFO_DEPTH_8_B_NIB;
+		break;
+	default:
+		dp83td510->tx_fifo_depth = DP83TD510_FIFO_DEPTH_5_B_NIB;
+	}
+
+	rx_int_delay = phy_get_internal_delay(phydev, dev, NULL, 0, true);
+	if (rx_int_delay <= 0)
+		dp83td510->rgmii_delay = DP83TD510_RX_CLK_SHIFT;
+	else
+		dp83td510->rgmii_delay = 0;
+
+	tx_int_delay = phy_get_internal_delay(phydev, dev, NULL, 0, false);
+	if (tx_int_delay <= 0)
+		dp83td510->rgmii_delay |= DP83TD510_TX_CLK_SHIFT;
+	else
+		dp83td510->rgmii_delay &= ~DP83TD510_TX_CLK_SHIFT;
+
+	return 0;
+}
+#else
+static int dp83869_of_init(struct phy_device *phydev)
+{
+	return dp83td510_read_straps(phydev);
+}
+#endif /* CONFIG_OF_MDIO */
+
+static int dp83td510_probe(struct phy_device *phydev)
+{
+	struct dp83td510_private *dp83td510;
+	int ret;
+
+	dp83td510 = devm_kzalloc(&phydev->mdio.dev, sizeof(*dp83td510), GFP_KERNEL);
+	if (!dp83td510)
+		return -ENOMEM;
+
+	phydev->priv = dp83td510;
+
+	ret = dp83td510_of_init(phydev);
+	if (ret)
+		return ret;
+
+	return dp83td510_config_init(phydev);
+}
+
+static struct phy_driver dp83td510_driver[] = {
+	{
+		PHY_ID_MATCH_MODEL(DP83TD510E_PHY_ID),
+		.name		= "TI DP83TD510E",
+		.probe          = dp83td510_probe,
+		.config_init	= dp83td510_config_init,
+		.soft_reset	= dp83td510_phy_reset,
+
+		/* IRQ related */
+		.ack_interrupt	= dp83td510_ack_interrupt,
+		.config_intr	= dp83td510_config_intr,
+		.config_aneg	= dp83td510_config_aneg,
+		.read_status	= dp83td510_read_status,
+
+		.get_features	= dp83td510_get_features,
+
+		.suspend	= genphy_suspend,
+		.resume		= genphy_resume,
+	},
+};
+module_phy_driver(dp83td510_driver);
+
+static struct mdio_device_id __maybe_unused dp83td510_tbl[] = {
+	{ PHY_ID_MATCH_MODEL(DP83TD510E_PHY_ID) },
+	{ }
+};
+MODULE_DEVICE_TABLE(mdio, dp83td510_tbl);
+
+MODULE_DESCRIPTION("Texas Instruments DP83TD510E PHY driver");
+MODULE_AUTHOR("Dan Murphy <dmurphy@ti.com");
+MODULE_LICENSE("GPL v2");
+
-- 
2.28.0.585.ge1cfff676549

