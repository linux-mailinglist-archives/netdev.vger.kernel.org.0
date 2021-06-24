Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6303B31B3
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 16:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbhFXOrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 10:47:51 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:61658 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231194AbhFXOrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 10:47:46 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15OEfUfG024009;
        Thu, 24 Jun 2021 10:45:09 -0400
Received: from nwd2mta4.analog.com ([137.71.173.58])
        by mx0a-00128a01.pphosted.com with ESMTP id 39bk4vj7a8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 10:45:09 -0400
Received: from ASHBMBX9.ad.analog.com (ASHBMBX9.ad.analog.com [10.64.17.10])
        by nwd2mta4.analog.com (8.14.7/8.14.7) with ESMTP id 15OEj8fX041081
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Jun 2021 10:45:08 -0400
Received: from ASHBCASHYB4.ad.analog.com (10.64.17.132) by
 ASHBMBX9.ad.analog.com (10.64.17.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.5;
 Thu, 24 Jun 2021 10:45:07 -0400
Received: from ASHBMBX8.ad.analog.com (10.64.17.5) by
 ASHBCASHYB4.ad.analog.com (10.64.17.132) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.5;
 Thu, 24 Jun 2021 10:45:06 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server id 15.2.858.5 via Frontend Transport;
 Thu, 24 Jun 2021 10:45:06 -0400
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 15OEj0IK003029;
        Thu, 24 Jun 2021 10:45:03 -0400
From:   <alexandru.tachici@analog.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>
Subject: [PATCH 1/4] net: phy: adin1100: Add initial support for ADIN1100 industrial PHY
Date:   Thu, 24 Jun 2021 17:53:50 +0300
Message-ID: <20210624145353.6910-2-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210624145353.6910-1-alexandru.tachici@analog.com>
References: <20210624145353.6910-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: QdbMjFJoHD5snEMFzmRxdCPU5sf7egIh
X-Proofpoint-ORIG-GUID: QdbMjFJoHD5snEMFzmRxdCPU5sf7egIh
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-24_12:2021-06-24,2021-06-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106240081
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
 drivers/net/phy/adin1100.c | 437 +++++++++++++++++++++++++++++++++++++
 3 files changed, 445 insertions(+)
 create mode 100644 drivers/net/phy/adin1100.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index c56f703ae998..8f9f61fe0020 100644
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
index 172bb193ae6a..3bd6a369d60c 100644
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
index 000000000000..8d85a4d00d80
--- /dev/null
+++ b/drivers/net/phy/adin1100.c
@@ -0,0 +1,437 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/**
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
+	ETHTOOL_LINK_MODE_10baseT_Full_BIT,
+};
+
+#define ADIN_B10L_PCS_CNTRL			0x08e6
+#define   ADIN_PCS_CNTRL_B10L_LB_PCS_EN		BIT(14)
+
+#define ADIN_B10L_PMA_CNTRL			0x08f6
+#define   ADIN_PMA_CNTRL_B10L_LB_PMA_LOC_EN	BIT(0)
+
+#define ADIN_B10L_PMA_STAT			0x08f7
+#define   ADIN_PMA_STAT_B10L_LB_PMA_LOC_ABLE	BIT(13)
+#define   ADIN_PMA_STAT_B10L_TX_LVL_HI_ABLE	BIT(12)
+
+#define ADIN_AN_CONTROL				0x0200
+#define   ADIN_AN_RESTART			BIT(9)
+#define   ADIN_AN_EN				BIT(12)
+
+#define ADIN_AN_STATUS				0x0201
+#define ADIN_AN_ADV_ABILITY_L			0x0202
+#define ADIN_AN_ADV_ABILITY_M			0x0203
+#define ADIN_AN_ADV_ABILITY_H			0x0204U
+#define   ADIN_AN_ADV_B10L_TX_LVL_HI_ABL	BIT(13)
+#define   ADIN_AN_ADV_B10L_TX_LVL_HI_REQ	BIT(12)
+
+#define ADIN_AN_LP_ADV_ABILITY_L		0x0205
+
+#define ADIN_AN_LP_ADV_ABILITY_M		0x0206
+#define   ADIN_AN_LP_ADV_B10L			BIT(14)
+#define   ADIN_AN_LP_ADV_B1000			BIT(7)
+#define   ADIN_AN_LP_ADV_B10S_FD		BIT(6)
+#define   ADIN_AN_LP_ADV_B100			BIT(5)
+#define   ADIN_AN_LP_ADV_MST			BIT(4)
+
+#define ADIN_AN_LP_ADV_ABILITY_H		0x0207
+#define   ADIN_AN_LP_ADV_B10L_EEE		BIT(14)
+#define   ADIN_AN_LP_ADV_B10L_TX_LVL_HI_ABL	BIT(13)
+#define   ADIN_AN_LP_ADV_B10L_TX_LVL_HI_REQ	BIT(12)
+#define   ADIN_AN_LP_ADV_B10S_HD		BIT(11)
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
+#define ADIN_MAC_IF_LOOPBACK			0x803d
+#define   ADIN_MAC_IF_LOOPBACK_EN		BIT(0)
+#define   ADIN_MAC_IF_REMOTE_LOOPBACK_EN	BIT(2)
+
+/**
+ * struct adin_priv - ADIN PHY driver private data
+ * tx_level_24v			set if the PHY supports 2.4V TX levels (10BASE-T1L)
+ */
+struct adin_priv {
+	unsigned int		tx_level_24v:1;
+};
+
+static int adin_match_phy_device(struct phy_device *phydev)
+{
+	struct mii_bus *bus = phydev->mdio.bus;
+	int phy_addr = phydev->mdio.addr;
+	u32 id;
+	int rc;
+
+	mutex_lock(&bus->mdio_lock);
+
+	/* Need to call __mdiobus_read() directly here, because at this point
+	 * in time, the driver isn't attached to the PHY device.
+	 */
+	rc = __mdiobus_read(bus, phy_addr, MDIO_DEVID1);
+	if (rc < 0) {
+		mutex_unlock(&bus->mdio_lock);
+		return rc;
+	}
+
+	id = rc << 16;
+
+	rc = __mdiobus_read(bus, phy_addr, MDIO_DEVID2);
+	mutex_unlock(&bus->mdio_lock);
+
+	if (rc < 0)
+		return rc;
+
+	id |= rc;
+
+	switch (id) {
+	case PHY_ID_ADIN1100:
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+static void adin_mii_adv_m_to_ethtool_adv_t(unsigned long *advertising, u32 adv)
+{
+	if (adv & ADIN_AN_LP_ADV_B10L)
+		linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT, advertising);
+	if (adv & ADIN_AN_LP_ADV_B1000) {
+		linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT, advertising);
+		linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT, advertising);
+	}
+	if (adv & ADIN_AN_LP_ADV_B10S_FD)
+		linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT, advertising);
+	if (adv & ADIN_AN_LP_ADV_B100)
+		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT, advertising);
+}
+
+static void adin_mii_adv_h_to_ethtool_adv_t(unsigned long *advertising, u32 adv)
+{
+	if (adv & ADIN_AN_LP_ADV_B10S_HD)
+		linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT, advertising);
+}
+
+static int adin_read_lpa(struct phy_device *phydev)
+{
+	int val;
+
+	linkmode_zero(phydev->lp_advertising);
+
+	val = phy_read_mmd(phydev, MDIO_MMD_AN, ADIN_AN_STATUS);
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
+	val = phy_read_mmd(phydev, MDIO_MMD_AN, ADIN_AN_LP_ADV_ABILITY_L);
+	if (val < 0)
+		return val;
+
+	phydev->pause = val & LPA_PAUSE_CAP ? 1 : 0;
+	phydev->asym_pause = val & LPA_PAUSE_ASYM ? 1 : 0;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_AN, ADIN_AN_LP_ADV_ABILITY_M);
+	if (val < 0)
+		return val;
+
+	adin_mii_adv_m_to_ethtool_adv_t(phydev->lp_advertising, val);
+
+	val = phy_read_mmd(phydev, MDIO_MMD_AN, ADIN_AN_LP_ADV_ABILITY_H);
+	if (val < 0)
+		return val;
+
+	adin_mii_adv_h_to_ethtool_adv_t(phydev->lp_advertising, val);
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
+	if (priv->tx_level_24v)
+		ret = phy_set_bits_mmd(phydev, MDIO_MMD_AN,
+				       ADIN_AN_ADV_ABILITY_H,
+				       ADIN_AN_ADV_B10L_TX_LVL_HI_ABL |
+				       ADIN_AN_ADV_B10L_TX_LVL_HI_REQ);
+	else
+		ret = phy_clear_bits_mmd(phydev, MDIO_MMD_AN,
+					 ADIN_AN_ADV_ABILITY_H,
+					 ADIN_AN_ADV_B10L_TX_LVL_HI_ABL |
+					 ADIN_AN_ADV_B10L_TX_LVL_HI_REQ);
+
+	if (ret < 0)
+		return ret;
+
+	return phy_set_bits_mmd(phydev, MDIO_MMD_AN, ADIN_AN_CONTROL, ADIN_AN_RESTART);
+}
+
+static void adin_link_change_notify(struct phy_device *phydev)
+{
+	bool tx_level_24v;
+	bool lp_tx_level_24v;
+	int val, mask;
+
+	if (phydev->state != PHY_RUNNING || phydev->autoneg == AUTONEG_DISABLE)
+		return;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_AN, ADIN_AN_LP_ADV_ABILITY_H);
+	if (val < 0)
+		return;
+
+	mask = ADIN_AN_LP_ADV_B10L_TX_LVL_HI_ABL | ADIN_AN_LP_ADV_B10L_TX_LVL_HI_REQ;
+	lp_tx_level_24v = (val & mask) == mask;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_AN, ADIN_AN_ADV_ABILITY_H);
+	if (val < 0)
+		return;
+
+	mask = ADIN_AN_ADV_B10L_TX_LVL_HI_ABL | ADIN_AN_ADV_B10L_TX_LVL_HI_REQ;
+	tx_level_24v = (val & mask) == mask;
+
+	if (tx_level_24v && lp_tx_level_24v)
+		phydev_info(phydev, "Negotiated 2.4V TX level\n");
+	else
+		phydev_info(phydev, "Negotiated 1.0V TX level\n");
+}
+
+static int adin_set_powerdown_mode(struct phy_device *phydev, bool en)
+{
+	int ret, timeout;
+	u16 val;
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
+	timeout = 30;
+	while (timeout-- > 0) {
+		ret = phy_read_mmd(phydev, MDIO_MMD_VEND1,
+				   ADIN_CRSM_STAT);
+		if (ret < 0)
+			return ret;
+
+		if ((ret & ADIN_CRSM_SFT_PD_RDY) == val)
+			return 0;
+
+		mdelay(1);
+	}
+
+	return -ETIMEDOUT;
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
+	int ret;
+
+	if (enable)
+		return phy_set_bits_mmd(phydev, MDIO_MMD_PCS,
+					ADIN_B10L_PCS_CNTRL,
+					ADIN_PCS_CNTRL_B10L_LB_PCS_EN);
+
+	/* MAC interface block loopback */
+	ret = phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1, ADIN_MAC_IF_LOOPBACK,
+				 ADIN_MAC_IF_LOOPBACK_EN |
+				 ADIN_MAC_IF_REMOTE_LOOPBACK_EN);
+	if (ret < 0)
+		return ret;
+
+	/* PCS loopback (according to 10BASE-T1L spec) */
+	ret = phy_clear_bits_mmd(phydev, MDIO_MMD_PCS, ADIN_B10L_PCS_CNTRL,
+				 ADIN_PCS_CNTRL_B10L_LB_PCS_EN);
+	if (ret < 0)
+		return ret;
+
+	/* PMA loopback (according to 10BASE-T1L spec) */
+	return phy_clear_bits_mmd(phydev, MDIO_MMD_PMAPMD, ADIN_B10L_PMA_CNTRL,
+				  ADIN_PMA_CNTRL_B10L_LB_PMA_LOC_EN);
+}
+
+static int adin_config_init(struct phy_device *phydev)
+{
+	struct adin_priv *priv = phydev->priv;
+	struct device *dev = &phydev->mdio.dev;
+	int ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, ADIN_B10L_PMA_STAT);
+	if (ret < 0)
+		return ret;
+
+	/* This depends on the voltage level from the power source */
+	priv->tx_level_24v = !!(ret & ADIN_PMA_STAT_B10L_TX_LVL_HI_ABLE);
+
+	phydev_dbg(phydev, "PHY supports 2.4V TX level: %s\n",
+		   priv->tx_level_24v ? "yes" : "no");
+
+	if (priv->tx_level_24v &&
+	    device_property_present(dev, "adi,disable-2-4-v-tx-level")) {
+		phydev_info(phydev,
+			    "PHY supports 2.4V TX level, but disabled via config\n");
+		priv->tx_level_24v = 0;
+	}
+
+	return 0;
+}
+
+static int adin_soft_reset(struct phy_device *phydev)
+{
+	int timeout;
+	int ret;
+
+	ret = phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, ADIN_CRSM_SFT_RST, ADIN_CRSM_SFT_RST_EN);
+	if (ret < 0)
+		return ret;
+
+	timeout = 30;
+	while (timeout >= 0) {
+		ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, ADIN_CRSM_STAT);
+		if (ret < 0)
+			return ret;
+
+		if (ret & ADIN_CRSM_SYS_RDY)
+			return 0;
+
+		usleep_range(10000, 15000);
+		timeout -= 10;
+	}
+
+	return -ETIMEDOUT;
+}
+
+static int adin_get_features(struct phy_device *phydev)
+{
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
+		.match_phy_device	= adin_match_phy_device,
+		.soft_reset		= adin_soft_reset,
+		.probe			= adin_probe,
+		.config_init		= adin_config_init,
+		.config_aneg		= adin_config_aneg,
+		.link_change_notify	= adin_link_change_notify,
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

