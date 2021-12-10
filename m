Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF9446FF18
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 11:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234511AbhLJK4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 05:56:40 -0500
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:8406 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239459AbhLJK4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 05:56:36 -0500
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BA6cotC026429;
        Fri, 10 Dec 2021 05:52:37 -0500
Received: from nwd2mta3.analog.com ([137.71.173.56])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3cv1tbrw1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Dec 2021 05:52:37 -0500
Received: from ASHBMBX9.ad.analog.com (ASHBMBX9.ad.analog.com [10.64.17.10])
        by nwd2mta3.analog.com (8.14.7/8.14.7) with ESMTP id 1BAAqZCX021149
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 10 Dec 2021 05:52:35 -0500
Received: from ASHBMBX9.ad.analog.com (10.64.17.10) by ASHBMBX9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.14; Fri, 10 Dec
 2021 05:52:34 -0500
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Fri, 10 Dec 2021 05:52:34 -0500
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 1BAAqLrF008399;
        Fri, 10 Dec 2021 05:52:32 -0500
From:   <alexandru.tachici@analog.com>
To:     <andrew@lunn.ch>
CC:     <o.rempel@pengutronix.de>, <alexandru.tachici@analog.com>,
        <davem@davemloft.net>, <devicetree@vger.kernel.org>,
        <hkallweit1@gmail.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <robh+dt@kernel.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v4 5/7] net: phy: adin1100: Add initial support for ADIN1100 industrial PHY
Date:   Fri, 10 Dec 2021 13:05:07 +0200
Message-ID: <20211210110509.20970-6-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211210110509.20970-1-alexandru.tachici@analog.com>
References: <20211210110509.20970-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: 8WuRJi7m0u6OMcXRhAM7H2tOC75NAWtP
X-Proofpoint-ORIG-GUID: 8WuRJi7m0u6OMcXRhAM7H2tOC75NAWtP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-10_03,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 phishscore=0 mlxlogscore=999 clxscore=1015 impostorscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112100059
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
 drivers/net/phy/Kconfig    |   7 ++
 drivers/net/phy/Makefile   |   1 +
 drivers/net/phy/adin1100.c | 247 +++++++++++++++++++++++++++++++++++++
 3 files changed, 255 insertions(+)
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
index 000000000000..23d1ae61e0ef
--- /dev/null
+++ b/drivers/net/phy/adin1100.c
@@ -0,0 +1,247 @@
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
+#define ADIN_FORCED_MODE			0x8000
+#define   ADIN_FORCED_MODE_EN			BIT(0)
+
+#define ADIN_CRSM_SFT_RST			0x8810
+#define   ADIN_CRSM_SFT_RST_EN			BIT(0)
+
+#define ADIN_CRSM_SFT_PD_CNTRL			0x8812
+#define   ADIN_CRSM_SFT_PD_CNTRL_EN		BIT(0)
+
+#define ADIN_AN_PHY_INST_STATUS			0x8030
+#define   ADIN_IS_CFG_SLV			BIT(2)
+#define   ADIN_IS_CFG_MST			BIT(3)
+
+#define ADIN_CRSM_STAT				0x8818
+#define   ADIN_CRSM_SFT_PD_RDY			BIT(1)
+#define   ADIN_CRSM_SYS_RDY			BIT(0)
+
+/**
+ * struct adin_priv - ADIN PHY driver private data
+ * @tx_level_2v4_able:		set if the PHY supports 2.4V TX levels (10BASE-T1L)
+ * @tx_level_2v4:		set if the PHY requests 2.4V TX levels (10BASE-T1L)
+ * @tx_level_prop_present:	set if the TX level is specified in DT
+ */
+struct adin_priv {
+	unsigned int		tx_level_2v4_able:1;
+	unsigned int		tx_level_2v4:1;
+	unsigned int		tx_level_prop_present:1;
+};
+
+static int adin_read_status(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = genphy_c45_read_status(phydev);
+	if (ret)
+		return ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_AN, ADIN_AN_PHY_INST_STATUS);
+	if (ret < 0)
+		return ret;
+
+	if (ret & ADIN_IS_CFG_SLV)
+		phydev->master_slave_state = MASTER_SLAVE_STATE_SLAVE;
+
+	if (ret & ADIN_IS_CFG_MST)
+		phydev->master_slave_state = MASTER_SLAVE_STATE_MASTER;
+
+	return 0;
+}
+
+static int adin_config_aneg(struct phy_device *phydev)
+{
+	struct adin_priv *priv = phydev->priv;
+	int ret;
+
+	if (phydev->autoneg == AUTONEG_DISABLE) {
+		ret = genphy_c45_pma_setup_forced(phydev);
+		if (ret < 0)
+			return ret;
+
+		if (priv->tx_level_prop_present && priv->tx_level_2v4) {
+			ret = phy_set_bits_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_B10L_PMA_CTRL,
+					       MDIO_PMA_10T1L_CTRL_2V4_EN);
+			if (ret < 0)
+				return ret;
+		} else {
+			ret = phy_clear_bits_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_B10L_PMA_CTRL,
+						 MDIO_PMA_10T1L_CTRL_2V4_EN);
+			if (ret < 0)
+				return ret;
+		}
+
+		/* Force PHY to use above configurations */
+		return phy_set_bits_mmd(phydev, MDIO_MMD_AN, ADIN_FORCED_MODE, ADIN_FORCED_MODE_EN);
+	}
+
+	ret = phy_clear_bits_mmd(phydev, MDIO_MMD_AN, ADIN_FORCED_MODE, ADIN_FORCED_MODE_EN);
+	if (ret < 0)
+		return ret;
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
+	return genphy_c45_config_aneg(phydev);
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
+	priv->tx_level_prop_present = device_property_present(dev, "phy-10base-t1l-2.4vpp");
+	if (priv->tx_level_prop_present) {
+		ret = device_property_read_u8(dev, "phy-10base-t1l-2.4vpp", &val);
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
+	return genphy_c45_pma_read_abilities(phydev);
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

