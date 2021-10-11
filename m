Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C16429131
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 16:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244513AbhJKOQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 10:16:09 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:28440 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243983AbhJKONb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 10:13:31 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19B6n1Q8027367;
        Mon, 11 Oct 2021 10:11:13 -0400
Received: from nwd2mta4.analog.com ([137.71.173.58])
        by mx0a-00128a01.pphosted.com with ESMTP id 3bm8qfuv7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 10:11:13 -0400
Received: from ASHBMBX8.ad.analog.com (ASHBMBX8.ad.analog.com [10.64.17.5])
        by nwd2mta4.analog.com (8.14.7/8.14.7) with ESMTP id 19BEBC7b034955
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 11 Oct 2021 10:11:12 -0400
Received: from ASHBMBX8.ad.analog.com (10.64.17.5) by ASHBMBX8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.5; Mon, 11 Oct 2021
 10:11:11 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server id 15.2.858.5 via Frontend Transport;
 Mon, 11 Oct 2021 10:11:11 -0400
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 19BEAxn8020418;
        Mon, 11 Oct 2021 10:11:09 -0400
From:   <alexandru.tachici@analog.com>
To:     <andrew@lunn.ch>
CC:     <o.rempel@pengutronix.de>, <alexandru.tachici@analog.com>,
        <davem@davemloft.net>, <devicetree@vger.kernel.org>,
        <hkallweit1@gmail.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <robh+dt@kernel.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v3 4/8] net: phy: adin1100: Add initial support for ADIN1100 industrial PHY
Date:   Mon, 11 Oct 2021 17:22:11 +0300
Message-ID: <20211011142215.9013-5-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211011142215.9013-1-alexandru.tachici@analog.com>
References: <20211011142215.9013-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-ORIG-GUID: qGww8DHz0-m9v1w9LPYqKrK8pwEQwvWF
X-Proofpoint-GUID: qGww8DHz0-m9v1w9LPYqKrK8pwEQwvWF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-11_04,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 suspectscore=0 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110110082
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Ardelean <alexandru.ardelean@analog.com>

The ADIN1100 is a low power single port 10BASE-T1L transceiver designed for
industrial Ethernet applications and is compliant with the IEEE 802.3cg
Ethernet standard for long reach 10 Mb/s Single Pair Ethernet.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 drivers/net/phy/Kconfig    |   7 +
 drivers/net/phy/Makefile   |   1 +
 drivers/net/phy/adin1100.c | 279 +++++++++++++++++++++++++++++++++++++
 3 files changed, 287 insertions(+)
 create mode 100644 drivers/net/phy/adin1100.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 902495afcb38..2f65d39e0f2c 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -83,6 +83,13 @@ config ADIN_PHY
 	  - ADIN1300 - Robust,Industrial, Low Latency 10/100/1000 Gigabit
 	    Ethernet PHY
 
+config ADIN1100_PHY
+	tristate "Analog Devices Industrial Ethernet T1L PHYs"
+	help
+	  Adds support for the Analog Devices Industrial T1L Ethernet PHYs.
+	  Currently supports the:
+	  - ADIN1100 - Robust,Industrial, Low Power 10BASE-T1L Ethernet PHY
+
 config AQUANTIA_PHY
 	tristate "Aquantia PHYs"
 	help
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index b2728d00fc9a..b82651b57043 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -31,6 +31,7 @@ sfp-obj-$(CONFIG_SFP)		+= sfp-bus.o
 obj-y				+= $(sfp-obj-y) $(sfp-obj-m)
 
 obj-$(CONFIG_ADIN_PHY)		+= adin.o
+obj-$(CONFIG_ADIN1100_PHY)	+= adin1100.o
 obj-$(CONFIG_AMD_PHY)		+= amd.o
 aquantia-objs			+= aquantia_main.o
 ifdef CONFIG_HWMON
diff --git a/drivers/net/phy/adin1100.c b/drivers/net/phy/adin1100.c
new file mode 100644
index 000000000000..dc5c1987dc43
--- /dev/null
+++ b/drivers/net/phy/adin1100.c
@@ -0,0 +1,279 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/*
+ *  Driver for Analog Devices Industrial Ethernet T1L PHYs
+ *
+ * Copyright 2020 Analog Devices Inc.
+ */
+#include <linux/kernel.h>
+#include <linux/bitfield.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mii.h>
+#include <linux/phy.h>
+#include <linux/property.h>
+
+#define PHY_ID_ADIN1100				0x0283bc81
+
+static const int phy_10_features_array[] = {
+	ETHTOOL_LINK_MODE_10baseT1L_Full_BIT,
+};
+
+#define ADIN_CRSM_SFT_RST			0x8810
+#define   ADIN_CRSM_SFT_RST_EN			BIT(0)
+
+#define ADIN_CRSM_SFT_PD_CNTRL			0x8812
+#define   ADIN_CRSM_SFT_PD_CNTRL_EN		BIT(0)
+
+#define ADIN_CRSM_STAT				0x8818
+#define   ADIN_CRSM_SFT_PD_RDY			BIT(1)
+#define   ADIN_CRSM_SYS_RDY			BIT(0)
+
+/**
+ * struct adin_priv - ADIN PHY driver private data
+ * tx_level_2v4_able		set if the PHY supports 2.4V TX levels (10BASE-T1L)
+ * tx_level_2v4			set if the PHY requests 2.4V TX levels (10BASE-T1L)
+ * tx_level_prop_present	set if the TX level is specified in DT
+ */
+struct adin_priv {
+	unsigned int		tx_level_2v4_able:1;
+	unsigned int		tx_level_2v4:1;
+	unsigned int		tx_level_prop_present:1;
+};
+
+static void adin_mii_adv_m_to_ethtool_adv_t(unsigned long *advertising, u32 adv)
+{
+	if (adv & MDIO_AN_T1_ADV_M_B10L)
+		linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT1L_Full_BIT, advertising);
+}
+
+static int adin_read_lpa(struct phy_device *phydev)
+{
+	int val;
+
+	linkmode_zero(phydev->lp_advertising);
+
+	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_T1_STAT);
+	if (val < 0)
+		return val;
+
+	if (!(val & MDIO_AN_STAT1_COMPLETE)) {
+		phydev->pause = 0;
+		phydev->asym_pause = 0;
+
+		return 0;
+	}
+
+	linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+			 phydev->lp_advertising);
+
+	/* Read the link partner's base page advertisement */
+	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_T1_LP_L);
+	if (val < 0)
+		return val;
+
+	phydev->pause = val & MDIO_AN_T1_LP_L_PAUSE_CAP ? 1 : 0;
+	phydev->asym_pause = val & MDIO_AN_T1_LP_L_PAUSE_ASYM ? 1 : 0;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_T1_LP_M);
+	if (val < 0)
+		return val;
+
+	adin_mii_adv_m_to_ethtool_adv_t(phydev->lp_advertising, val);
+
+	return 0;
+}
+
+static int adin_read_status(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = genphy_c45_read_link(phydev);
+	if (ret)
+		return ret;
+
+	phydev->speed = SPEED_UNKNOWN;
+	phydev->duplex = DUPLEX_UNKNOWN;
+	phydev->pause = 0;
+	phydev->asym_pause = 0;
+
+	if (phydev->autoneg == AUTONEG_ENABLE) {
+		ret = adin_read_lpa(phydev);
+		if (ret)
+			return ret;
+
+		phy_resolve_aneg_linkmode(phydev);
+	} else {
+		/* Only one mode & duplex supported */
+		linkmode_zero(phydev->lp_advertising);
+		phydev->speed = SPEED_10;
+		phydev->duplex = DUPLEX_FULL;
+	}
+
+	return ret;
+}
+
+static int adin_config_aneg(struct phy_device *phydev)
+{
+	struct adin_priv *priv = phydev->priv;
+	int ret;
+
+	/* No sense to continue if auto-neg is disabled,
+	 * only one link-mode supported.
+	 */
+	if (phydev->autoneg == AUTONEG_DISABLE)
+		return 0;
+
+	/* Request increased transmit level from LP. */
+	if (priv->tx_level_prop_present && priv->tx_level_2v4) {
+		ret = phy_set_bits_mmd(phydev, MDIO_MMD_AN, MDIO_AN_T1_ADV_H,
+				       MDIO_AN_T1_ADV_H_10L_TX_HI |
+				       MDIO_AN_T1_ADV_H_10L_TX_HI_REQ);
+		if (ret < 0)
+			return ret;
+	}
+
+	/* Disable 2.4 Vpp transmit level. */
+	if ((priv->tx_level_prop_present && !priv->tx_level_2v4) || !priv->tx_level_2v4_able) {
+		ret = phy_clear_bits_mmd(phydev, MDIO_MMD_AN, MDIO_AN_T1_ADV_H,
+					 MDIO_AN_T1_ADV_H_10L_TX_HI |
+					 MDIO_AN_T1_ADV_H_10L_TX_HI_REQ);
+		if (ret < 0)
+			return ret;
+	}
+
+	return phy_set_bits_mmd(phydev, MDIO_MMD_AN, MDIO_AN_T1_CTRL, BMCR_ANRESTART);
+}
+
+static int adin_set_powerdown_mode(struct phy_device *phydev, bool en)
+{
+	int ret;
+	int val;
+
+	if (en)
+		val = ADIN_CRSM_SFT_PD_CNTRL_EN;
+	else
+		val = 0;
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_VEND1,
+			    ADIN_CRSM_SFT_PD_CNTRL, val);
+	if (ret < 0)
+		return ret;
+
+	return phy_read_mmd_poll_timeout(phydev, MDIO_MMD_VEND1, ADIN_CRSM_STAT, ret,
+					 (ret & ADIN_CRSM_SFT_PD_RDY) == val,
+					 1000, 30000, true);
+}
+
+static int adin_suspend(struct phy_device *phydev)
+{
+	return adin_set_powerdown_mode(phydev, true);
+}
+
+static int adin_resume(struct phy_device *phydev)
+{
+	return adin_set_powerdown_mode(phydev, false);
+}
+
+static int adin_set_loopback(struct phy_device *phydev, bool enable)
+{
+	if (enable)
+		return phy_set_bits_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_10T1L_CTRL,
+					BMCR_LOOPBACK);
+
+	/* PCS loopback (according to 10BASE-T1L spec) */
+	return phy_clear_bits_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_10T1L_CTRL,
+				 BMCR_LOOPBACK);
+}
+
+static int adin_soft_reset(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, ADIN_CRSM_SFT_RST, ADIN_CRSM_SFT_RST_EN);
+	if (ret < 0)
+		return ret;
+
+	return phy_read_mmd_poll_timeout(phydev, MDIO_MMD_VEND1, ADIN_CRSM_STAT, ret,
+					 (ret & ADIN_CRSM_SYS_RDY),
+					 10000, 30000, true);
+}
+
+static int adin_get_features(struct phy_device *phydev)
+{
+	struct adin_priv *priv = phydev->priv;
+	struct device *dev = &phydev->mdio.dev;
+	int ret;
+	u8 val;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_10T1L_STAT);
+	if (ret < 0)
+		return ret;
+
+	/* This depends on the voltage level from the power source */
+	priv->tx_level_2v4_able = !!(ret & MDIO_PMA_10T1L_STAT_2V4_ABLE);
+
+	phydev_dbg(phydev, "PHY supports 2.4V TX level: %s\n",
+		   priv->tx_level_2v4_able ? "yes" : "no");
+
+	priv->tx_level_prop_present = device_property_present(dev, "10base-t1l-2.4vpp");
+	if (priv->tx_level_prop_present) {
+		ret = device_property_read_u8(dev, "10base-t1l-2.4vpp", &val);
+		if (ret < 0)
+			return ret;
+
+		priv->tx_level_2v4 = val;
+		if (!priv->tx_level_2v4 && priv->tx_level_2v4_able)
+			phydev_info(phydev,
+				    "PHY supports 2.4V TX level, but disabled via config\n");
+	}
+
+	linkmode_set_bit_array(phy_basic_ports_array, ARRAY_SIZE(phy_basic_ports_array),
+			       phydev->supported);
+
+	linkmode_set_bit_array(phy_10_features_array, ARRAY_SIZE(phy_10_features_array),
+			       phydev->supported);
+
+	return 0;
+}
+
+static int adin_probe(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	struct adin_priv *priv;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	phydev->priv = priv;
+
+	return 0;
+}
+
+static struct phy_driver adin_driver[] = {
+	{
+		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1100),
+		.name			= "ADIN1100",
+		.get_features		= adin_get_features,
+		.soft_reset		= adin_soft_reset,
+		.probe			= adin_probe,
+		.config_aneg		= adin_config_aneg,
+		.read_status		= adin_read_status,
+		.set_loopback		= adin_set_loopback,
+		.suspend		= adin_suspend,
+		.resume			= adin_resume,
+	},
+};
+
+module_phy_driver(adin_driver);
+
+static struct mdio_device_id __maybe_unused adin_tbl[] = {
+	{ PHY_ID_MATCH_MODEL(PHY_ID_ADIN1100) },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(mdio, adin_tbl);
+MODULE_DESCRIPTION("Analog Devices Industrial Ethernet T1L PHY driver");
+MODULE_LICENSE("Dual BSD/GPL");
-- 
2.25.1

