Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 065973D3EC6
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 19:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbhGWQv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 12:51:26 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:8405 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232160AbhGWQvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 12:51:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1627061511; x=1658597511;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aj4oroYRsYueQwPQetrr7BUQ9F1CZBoMx+4BwgvCXLQ=;
  b=pQmXjvIdqQl4Ih/eTQl3cYeubyQ+GqqlBRxG3/zsatUYjOq1hfjPlEej
   ef2w69h6OgtjvOb3u9UbXfSzl7nSXF+q9StgXMRsEffGxWRr0lW/EpmWy
   e3xkoE1wJ8UmUDqN8EBEqLBXZIh2ko+keotIsXfxlWYUnY/EvyBMfmo0j
   PWGOpBRCER53eZh+SUG8kbUebQgnLVAosBeHM4BVg1/iHYQdBxyyW0IhB
   oZn9+z2BoEs9f1AAzn3m7ARnh6KGLEfRe/F61gGikve+9iyFHFLfCk9+4
   8MShbLOcmkoqgFaD7+qV92zieOIo+TLvozpiMtpvDQCGiDx6TRefwv5wR
   Q==;
IronPort-SDR: JxUbwX9rLB8ssJqcWnjfBdK6XOpPTeNbAMrVyzyY2geffeBhuo8TH6XAvZ4RFr+5wuRjWjFPpn
 yNPYWWp7HoqtAJpbZc0Ksqsu8ks/LGhsIVGJ3YTIORRQ+yAbpgu8KPkeygCFjrdXgmuv1YZlY3
 nG7UgilEdf335dpveLROQhGAqBxdHjwNVXqRqgrYRh+A9OPNRwDZu/TUDkT2cIOYdzOP1/VM2n
 dzZJWMkXNFwrE5Hj4/I2iR2zt2EG2BT8AFN0JTIsJgO3OLf2lKThgcO/c2I4pjVNZBsi17Hckp
 7dwUDrX+YMQEG3mYewKuHVkV
X-IronPort-AV: E=Sophos;i="5.84,264,1620716400"; 
   d="scan'208";a="125755665"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Jul 2021 10:31:50 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Jul 2021 10:31:50 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 23 Jul 2021 10:31:45 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v3 net-next 06/10] net: dsa: microchip: add support for phylink management
Date:   Fri, 23 Jul 2021 23:01:04 +0530
Message-ID: <20210723173108.459770-7-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
References: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for phylink_validate() and reused KSZ commmon API for
phylink_mac_link_down() operation

lan937x_phylink_mac_config configures the interface using
lan937x_mac_config and lan937x_phylink_mac_link_up configures
the speed/duplex/flow control.

Currently SGMII & in-band neg are not supported & it will be
added later.

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
---
 drivers/net/dsa/microchip/lan937x_dev.c  | 46 ++++++++++++
 drivers/net/dsa/microchip/lan937x_dev.h  |  3 +
 drivers/net/dsa/microchip/lan937x_main.c | 90 ++++++++++++++++++++++++
 3 files changed, 139 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_dev.c b/drivers/net/dsa/microchip/lan937x_dev.c
index 86e84a79f464..c36fdc4692ff 100644
--- a/drivers/net/dsa/microchip/lan937x_dev.c
+++ b/drivers/net/dsa/microchip/lan937x_dev.c
@@ -477,6 +477,52 @@ void lan937x_mac_config(struct ksz_device *dev, int port,
 	lan937x_pwrite8(dev, port, REG_PORT_XMII_CTRL_1, data8);
 }
 
+void lan937x_config_interface(struct ksz_device *dev, int port,
+			      int speed, int duplex,
+			      bool tx_pause, bool rx_pause)
+{
+	u8 xmii_ctrl0, xmii_ctrl1;
+
+	lan937x_pread8(dev, port, REG_PORT_XMII_CTRL_0, &xmii_ctrl0);
+	lan937x_pread8(dev, port, REG_PORT_XMII_CTRL_1, &xmii_ctrl1);
+
+	switch (speed) {
+	case SPEED_1000:
+		lan937x_config_gbit(dev, true, &xmii_ctrl1);
+		break;
+	case SPEED_100:
+		lan937x_config_gbit(dev, false, &xmii_ctrl1);
+		xmii_ctrl0 |= PORT_MAC_SPEED_100;
+		break;
+	case SPEED_10:
+		lan937x_config_gbit(dev, false, &xmii_ctrl1);
+		xmii_ctrl0 &= ~PORT_MAC_SPEED_100;
+		break;
+	default:
+		dev_err(dev->dev, "Unsupported speed on port %d: %d\n",
+			port, speed);
+		return;
+	}
+
+	if (duplex)
+		xmii_ctrl0 |= PORT_FULL_DUPLEX;
+	else
+		xmii_ctrl0 &= ~PORT_FULL_DUPLEX;
+
+	if (tx_pause)
+		xmii_ctrl0 |= PORT_TX_FLOW_CTRL;
+	else
+		xmii_ctrl1 &= ~PORT_TX_FLOW_CTRL;
+
+	if (rx_pause)
+		xmii_ctrl0 |= PORT_RX_FLOW_CTRL;
+	else
+		xmii_ctrl0 &= ~PORT_RX_FLOW_CTRL;
+
+	lan937x_pwrite8(dev, port, REG_PORT_XMII_CTRL_0, xmii_ctrl0);
+	lan937x_pwrite8(dev, port, REG_PORT_XMII_CTRL_1, xmii_ctrl1);
+}
+
 void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 {
 	struct ksz_port *p = &dev->ports[port];
diff --git a/drivers/net/dsa/microchip/lan937x_dev.h b/drivers/net/dsa/microchip/lan937x_dev.h
index 76c00db05616..0ddd7aa87468 100644
--- a/drivers/net/dsa/microchip/lan937x_dev.h
+++ b/drivers/net/dsa/microchip/lan937x_dev.h
@@ -36,6 +36,9 @@ void lan937x_cfg_port_member(struct ksz_device *dev, int port,
 			     u8 member);
 void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port);
 int lan937x_enable_spi_indirect_access(struct ksz_device *dev);
+void lan937x_config_interface(struct ksz_device *dev, int port,
+			      int speed, int duplex,
+			      bool tx_pause, bool rx_pause);
 void lan937x_mac_config(struct ksz_device *dev, int port,
 			phy_interface_t interface);
 
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index d43db522d07e..74b6c9563dc1 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -292,6 +292,92 @@ static int lan937x_get_max_mtu(struct dsa_switch *ds, int port)
 	return (FR_MAX_SIZE - VLAN_ETH_HLEN - ETH_FCS_LEN);
 }
 
+static void lan937x_phylink_mac_config(struct dsa_switch *ds, int port,
+				       unsigned int mode,
+				       const struct phylink_link_state *state)
+{
+	struct ksz_device *dev = ds->priv;
+
+	/* Internal PHYs */
+	if (lan937x_is_internal_phy_port(dev, port))
+		return;
+
+	if (phylink_autoneg_inband(mode)) {
+		dev_err(ds->dev, "In-band AN not supported!\n");
+		return;
+	}
+	lan937x_mac_config(dev, port, state->interface);
+}
+
+static void lan937x_phylink_mac_link_up(struct dsa_switch *ds, int port,
+					unsigned int mode,
+					phy_interface_t interface,
+					struct phy_device *phydev,
+					int speed, int duplex,
+					bool tx_pause, bool rx_pause)
+{
+	struct ksz_device *dev = ds->priv;
+
+	/* Internal PHYs */
+	if (lan937x_is_internal_phy_port(dev, port))
+		return;
+
+	if (phylink_autoneg_inband(mode)) {
+		dev_err(ds->dev, "In-band AN not supported!\n");
+		return;
+	}
+	lan937x_config_interface(dev, port, speed, duplex,
+				 tx_pause, rx_pause);
+}
+
+static void lan937x_phylink_validate(struct dsa_switch *ds, int port,
+				     unsigned long *supported,
+				     struct phylink_link_state *state)
+{
+	struct ksz_device *dev = ds->priv;
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+
+	/* Check for unsupported interfaces */
+	if (!phy_interface_mode_is_rgmii(state->interface) &&
+	    state->interface != PHY_INTERFACE_MODE_RMII &&
+	    state->interface != PHY_INTERFACE_MODE_MII &&
+	    state->interface != PHY_INTERFACE_MODE_INTERNAL) {
+		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		dev_err(ds->dev, "Unsupported interface '%s' for port %d\n",
+			phy_modes(state->interface), port);
+		return;
+	}
+
+	/* For RGMII, RMII, MII and internal TX phy port */
+	if (phy_interface_mode_is_rgmii(state->interface) ||
+	    state->interface == PHY_INTERFACE_MODE_RMII ||
+	    state->interface == PHY_INTERFACE_MODE_MII ||
+	    lan937x_is_internal_100BTX_phy_port(dev, port)) {
+		phylink_set(mask, 10baseT_Half);
+		phylink_set(mask, 10baseT_Full);
+		phylink_set(mask, 100baseT_Half);
+		phylink_set(mask, 100baseT_Full);
+		phylink_set(mask, Autoneg);
+		phylink_set_port_modes(mask);
+		phylink_set(mask, Pause);
+		phylink_set(mask, Asym_Pause);
+	}
+
+	/*  For RGMII interface */
+	if (phy_interface_mode_is_rgmii(state->interface))
+		phylink_set(mask, 1000baseT_Full);
+
+	/* For T1 PHY */
+	if (lan937x_is_internal_t1_phy_port(dev, port)) {
+		phylink_set(mask, 100baseT1_Full);
+		phylink_set_port_modes(mask);
+	}
+
+	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
+	bitmap_and(state->advertising, state->advertising, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+
 const struct dsa_switch_ops lan937x_switch_ops = {
 	.get_tag_protocol = lan937x_get_tag_protocol,
 	.setup = lan937x_setup,
@@ -304,6 +390,10 @@ const struct dsa_switch_ops lan937x_switch_ops = {
 	.port_fast_age = ksz_port_fast_age,
 	.port_max_mtu = lan937x_get_max_mtu,
 	.port_change_mtu = lan937x_change_mtu,
+	.phylink_validate = lan937x_phylink_validate,
+	.phylink_mac_link_down = ksz_mac_link_down,
+	.phylink_mac_config = lan937x_phylink_mac_config,
+	.phylink_mac_link_up = lan937x_phylink_mac_link_up,
 };
 
 int lan937x_switch_register(struct ksz_device *dev)
-- 
2.27.0

