Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2973643F695
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 07:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231913AbhJ2F0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 01:26:42 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:29272 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbhJ2F0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 01:26:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1635485046; x=1667021046;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h5TUqWFX65eAVTWhjiLL/x30mOubBO3aNQWs0cjZUo8=;
  b=Cand9psKxi7VQ8M6Z/XczMnne4ERN2dFpvgCxy9K4DdV7vW1v0OcIi55
   DNt78CLs+kQxDblYlulJCLWepjAMs0RelqL+Sgu/nOTO1rue5e72Hrswf
   bwKRWTgfHTNZ2xNGJrgtHODI1KWprC8nWcvGEA/LnHH0tOX4sAlmCqoY5
   I9V827T094Diod8Tf33lMuXiMWQu90iDOwebKux3l7D8Nrmz7jPwNt2qB
   kvwO/2KOSMqQTzojnYvL0elnARfEPnNVfOr5D/bDnNEDTDQenNaWymk1z
   v2OoeXrSKz7BfBqvSv5gU3s22NXxXhL/2/X+UYC6uu2nPiQOI4wJD1bn6
   A==;
IronPort-SDR: f1CFHaFQ6Ih7MeHznYDxC58w0eXd3flFhZDfigssqn1fD7rcBF/6W3AkqApNtjO+H5B5DO/H77
 HrsbMQ+EDjVTW4NpnAhhm4NBI2m3K6Gl4kbqOgwBRxNlw2zzF32BZAoy0gPQ/Kt2GHuGjYc/Oy
 W7AA/ZmV+7bCpnm/ZTjillGKJdNKZ+87ktWx8Hjx20rQXTDmRAgkK8Elb7cZ8Mn4ldlDPJom1Z
 WFA2fqfy8Tv5p3nUS8pXjUiRXVcIUiQUiNEPPz4tp/n7+9y2O3wHauERrhzJ42BhJJY3ecJdbR
 5CiYUkK+L4fJW+5BiuSJIfmI
X-IronPort-AV: E=Sophos;i="5.87,191,1631602800"; 
   d="scan'208";a="137295300"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Oct 2021 22:24:05 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 28 Oct 2021 22:24:04 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 28 Oct 2021 22:23:56 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v6 net-next 06/10] net: dsa: microchip: add support for phylink management
Date:   Fri, 29 Oct 2021 10:52:52 +0530
Message-ID: <20211029052256.144739-7-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211029052256.144739-1-prasanna.vengateshan@microchip.com>
References: <20211029052256.144739-1-prasanna.vengateshan@microchip.com>
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
 drivers/net/dsa/microchip/lan937x_dev.c  | 154 +++++++++++++++++++++++
 drivers/net/dsa/microchip/lan937x_dev.h  |   5 +
 drivers/net/dsa/microchip/lan937x_main.c |  98 +++++++++++++++
 3 files changed, 257 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_dev.c b/drivers/net/dsa/microchip/lan937x_dev.c
index b04881e66abd..1dcc01fb2138 100644
--- a/drivers/net/dsa/microchip/lan937x_dev.c
+++ b/drivers/net/dsa/microchip/lan937x_dev.c
@@ -393,6 +393,160 @@ int lan937x_internal_phy_read(struct ksz_device *dev, int addr, int reg,
 	return ksz_read16(dev, REG_VPHY_IND_DATA__2, val);
 }
 
+static void lan937x_config_gbit(struct ksz_device *dev, bool gbit, u8 *data)
+{
+	if (gbit)
+		*data &= ~PORT_MII_NOT_1GBIT;
+	else
+		*data |= PORT_MII_NOT_1GBIT;
+}
+
+static void lan937x_update_rgmii_tx_rx_delay(struct ksz_device *dev, int port,
+					     bool is_tx)
+{
+	struct ksz_port *p = &dev->ports[port];
+	u16 data16;
+	int reg;
+	u8 val;
+
+	if (is_tx) {
+		reg = REG_PORT_XMII_CTRL_5;
+		val = p->rgmii_tx_val;
+	} else {
+		reg = REG_PORT_XMII_CTRL_4;
+		val = p->rgmii_rx_val;
+	}
+
+	lan937x_pread16(dev, port, reg, &data16);
+
+	/* clear tune Adjust */
+	data16 &= ~PORT_TUNE_ADJ;
+	data16 |= (val << 7);
+	lan937x_pwrite16(dev, port, reg, data16);
+
+	data16 |= PORT_DLL_RESET;
+	/* write DLL reset to take effect */
+	lan937x_pwrite16(dev, port, reg, data16);
+}
+
+static void lan937x_apply_rgmii_delay(struct ksz_device *dev, int port, u8 val)
+{
+	struct ksz_port *p = &dev->ports[port];
+
+	/* Clear Ingress & Egress internal delay enabled bits */
+	val &= ~(PORT_RGMII_ID_EG_ENABLE | PORT_RGMII_ID_IG_ENABLE);
+
+	if (p->rgmii_tx_val) {
+		lan937x_update_rgmii_tx_rx_delay(dev, port, true);
+		dev_info(dev->dev, "Applied rgmii tx delay for the port %d\n",
+			 port);
+		val |= PORT_RGMII_ID_EG_ENABLE;
+	}
+
+	if (p->rgmii_rx_val) {
+		lan937x_update_rgmii_tx_rx_delay(dev, port, false);
+		dev_info(dev->dev, "Applied rgmii rx delay for the port %d\n",
+			 port);
+		val |= PORT_RGMII_ID_IG_ENABLE;
+	}
+
+	/* Enable RGMII internal delays */
+	lan937x_pwrite8(dev, port, REG_PORT_XMII_CTRL_1, val);
+}
+
+void lan937x_mac_config(struct ksz_device *dev, int port,
+			phy_interface_t interface)
+{
+	u8 data8;
+
+	lan937x_pread8(dev, port, REG_PORT_XMII_CTRL_1, &data8);
+
+	/* clear MII selection & set it based on interface later */
+	data8 &= ~PORT_MII_SEL_M;
+
+	/* configure MAC based on interface */
+	switch (interface) {
+	case PHY_INTERFACE_MODE_MII:
+		lan937x_config_gbit(dev, false, &data8);
+		data8 |= PORT_MII_SEL;
+		break;
+	case PHY_INTERFACE_MODE_RMII:
+		lan937x_config_gbit(dev, false, &data8);
+		data8 |= PORT_RMII_SEL;
+		break;
+	case PHY_INTERFACE_MODE_RGMII:
+		lan937x_config_gbit(dev, true, &data8);
+		data8 |= PORT_RGMII_SEL;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+		lan937x_config_gbit(dev, true, &data8);
+		data8 |= PORT_RGMII_SEL;
+
+		/* Apply rgmii internal delay for the mac */
+		lan937x_apply_rgmii_delay(dev, port, data8);
+
+		/* rgmii delay configuration is already applied above,
+		 * hence return from here as no changes required
+		 */
+		return;
+	default:
+		dev_err(dev->dev, "Unsupported interface '%s' for port %d\n",
+			phy_modes(interface), port);
+		return;
+	}
+
+	/* Write the updated value */
+	lan937x_pwrite8(dev, port, REG_PORT_XMII_CTRL_1, data8);
+}
+
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
index 9e276f317cb3..43dc8918f63e 100644
--- a/drivers/net/dsa/microchip/lan937x_dev.h
+++ b/drivers/net/dsa/microchip/lan937x_dev.h
@@ -33,6 +33,11 @@ void lan937x_cfg_port_member(struct ksz_device *dev, int port,
 			     u8 member);
 void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port);
 int lan937x_enable_spi_indirect_access(struct ksz_device *dev);
+void lan937x_config_interface(struct ksz_device *dev, int port,
+			      int speed, int duplex,
+			      bool tx_pause, bool rx_pause);
+void lan937x_mac_config(struct ksz_device *dev, int port,
+			phy_interface_t interface);
 
 struct mib_names {
 	int index;
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index fff60b55eba8..5dfd60fbc322 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -326,6 +326,100 @@ static int lan937x_get_max_mtu(struct dsa_switch *ds, int port)
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
+
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
+	    state->interface != PHY_INTERFACE_MODE_NA &&
+	    state->interface != PHY_INTERFACE_MODE_INTERNAL) {
+		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		dev_err(ds->dev, "Unsupported interface '%s' for port %d\n",
+			phy_modes(state->interface), port);
+		return;
+	}
+
+	/* For RGMII, RMII, MII and internal TX phy port and
+	 * as per phylink.h, when @state->interface is %PHY_INTERFACE_MODE_NA,
+	 * phylink expects the MAC driver to return all supported link modes.
+	 */
+	if (phy_interface_mode_is_rgmii(state->interface) ||
+	    state->interface == PHY_INTERFACE_MODE_RMII ||
+	    state->interface == PHY_INTERFACE_MODE_MII ||
+	    state->interface == PHY_INTERFACE_MODE_NA ||
+	    lan937x_is_internal_base_tx_phy_port(dev, port)) {
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
+	/* For RGMII interface */
+	if (phy_interface_mode_is_rgmii(state->interface) ||
+	    state->interface == PHY_INTERFACE_MODE_NA)
+		phylink_set(mask, 1000baseT_Full);
+
+	/* For T1 PHY */
+	if (lan937x_is_internal_base_t1_phy_port(dev, port) ||
+	    state->interface == PHY_INTERFACE_MODE_NA) {
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
@@ -338,6 +432,10 @@ const struct dsa_switch_ops lan937x_switch_ops = {
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

