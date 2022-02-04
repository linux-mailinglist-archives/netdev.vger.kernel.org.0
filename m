Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6F384A9E1D
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 18:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356392AbiBDRpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 12:45:54 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:44021 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377233AbiBDRpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 12:45:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643996746; x=1675532746;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=irJ4ICpDeHpf8i1FUmbYLIS90fdQ7UyKYJyCBMx9EQA=;
  b=l2n9kxO2+cw+NblcTlqnMB8R0lYfzHSxyvKDBPoHAcdwO9aKkfP5eRoJ
   AHbZXogBDLbrCbp6EvKH1d97IUxkfwhEZ4Vf6Mn7AL4dEAxcFgi/7acSt
   dtOd7yqdbsqIuNGVSqJBRrwj2DyEY2Y4OnGiJ9X9luu1Rrr84k50B61cz
   3l5e6AWJy5BDooJLqfurio1CunrKlDFbCZZxCz+X6R4osLAhGIY+KTxIR
   JB4/PdrFoRvInJosqmIib9mWx3ZJUgttwtdgpknib1/U/2s6a+tEdyKR+
   pTrj/yqQm+H5iqWYVKZoe5+qP+EFS6pIu5w3GNXDDTyzsjc3uosJiUhyq
   w==;
IronPort-SDR: ysck50bkhqwg38LiH1/2Zzzs+hy3+KrmV6Haxx+1GmP5dBk2v+l4yDYDZK9JK0rjrFXhrhSRJZ
 UTRZw7eVIYutaEgwhfVJbCwb7KMrqt3UUpnu7qU6pv0xxgy9q1l2/VnsC1QgxDI6eHgfrAMz6B
 mJ+XPGqP68RqRhUuz7x6mUkfKSz4pgRnbARoedrmBax6/DAdVrXp+Jj4DqPJZcK3dXE/IkxG3W
 RAs9XK5Y1ZvqnuqZhIj6hJ3eearIQGf3q9gDJcLCd7GXz4hQQ64Jyiewov15mBjMdZRdiTfU/z
 /tyV82pjZylP5OuooFlTx2yQ
X-IronPort-AV: E=Sophos;i="5.88,343,1635231600"; 
   d="scan'208";a="84716156"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Feb 2022 10:45:45 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Feb 2022 10:45:45 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 4 Feb 2022 10:45:39 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v7 net-next 06/10] net: dsa: microchip: add support for phylink management
Date:   Fri, 4 Feb 2022 23:14:56 +0530
Message-ID: <20220204174500.72814-7-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220204174500.72814-1-prasanna.vengateshan@microchip.com>
References: <20220204174500.72814-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phylink_get_caps() is implemented and reused KSZ commmon API for
phylink_mac_link_down() operation

lan937x_phylink_mac_config configures the interface using
lan937x_mac_config and lan937x_phylink_mac_link_up configures
the speed/duplex/flow control.

Currently SGMII & in-band neg are not supported & it will be
added later.

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
---
 drivers/net/dsa/microchip/lan937x_dev.c  | 167 +++++++++++++++++++++++
 drivers/net/dsa/microchip/lan937x_dev.h  |   7 +
 drivers/net/dsa/microchip/lan937x_main.c |  71 ++++++++++
 3 files changed, 245 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_dev.c b/drivers/net/dsa/microchip/lan937x_dev.c
index d9a2bc9c732a..90283855305b 100644
--- a/drivers/net/dsa/microchip/lan937x_dev.c
+++ b/drivers/net/dsa/microchip/lan937x_dev.c
@@ -392,6 +392,173 @@ int lan937x_internal_phy_read(struct ksz_device *dev, int addr, int reg,
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
+	u16 data16;
+	int reg;
+	u8 val;
+
+	/* Apply different codes based on the ports as per characterization
+	 * results
+	 */
+	if (is_tx) {
+		reg = REG_PORT_XMII_CTRL_5;
+		val = (port == LAN937X_RGMII_1_PORT) ? RGMII_1_TX_DELAY_2NS :
+						       RGMII_2_TX_DELAY_2NS;
+	} else {
+		reg = REG_PORT_XMII_CTRL_4;
+		val = (port == LAN937X_RGMII_1_PORT) ? RGMII_1_RX_DELAY_2NS :
+						       RGMII_2_RX_DELAY_2NS;
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
+static void lan937x_apply_rgmii_delay(struct ksz_device *dev, int port,
+				      phy_interface_t interface, u8 val)
+{
+	struct ksz_port *p = &dev->ports[port];
+
+	/* Clear Ingress & Egress internal delay enabled bits */
+	val &= ~(PORT_RGMII_ID_EG_ENABLE | PORT_RGMII_ID_IG_ENABLE);
+
+	if (interface == PHY_INTERFACE_MODE_RGMII_TXID ||
+	    interface == PHY_INTERFACE_MODE_RGMII_ID) {
+		/* if the delay is 0, let us not enable DLL */
+		if (p->rgmii_tx_val) {
+			lan937x_update_rgmii_tx_rx_delay(dev, port, true);
+			dev_info(dev->dev, "Applied rgmii tx delay for the port %d\n",
+				 port);
+			val |= PORT_RGMII_ID_EG_ENABLE;
+		}
+	}
+
+	if (interface == PHY_INTERFACE_MODE_RGMII_RXID ||
+	    interface == PHY_INTERFACE_MODE_RGMII_ID) {
+		/* if the delay is 0, let us not enable DLL */
+		if (p->rgmii_rx_val) {
+			lan937x_update_rgmii_tx_rx_delay(dev, port, false);
+			dev_info(dev->dev, "Applied rgmii rx delay for the port %d\n",
+				 port);
+			val |= PORT_RGMII_ID_IG_ENABLE;
+		}
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
+		lan937x_apply_rgmii_delay(dev, port, interface, data8);
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
 	struct dsa_switch *ds = dev->ds;
diff --git a/drivers/net/dsa/microchip/lan937x_dev.h b/drivers/net/dsa/microchip/lan937x_dev.h
index 13d39cf221b2..74d5fd145955 100644
--- a/drivers/net/dsa/microchip/lan937x_dev.h
+++ b/drivers/net/dsa/microchip/lan937x_dev.h
@@ -33,6 +33,13 @@ void lan937x_cfg_port_member(struct ksz_device *dev, int port,
 			     u8 member);
 void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port);
 int lan937x_enable_spi_indirect_access(struct ksz_device *dev);
+void lan937x_config_interface(struct ksz_device *dev, int port,
+			      int speed, int duplex,
+			      bool tx_pause, bool rx_pause);
+void lan937x_mac_config(struct ksz_device *dev, int port,
+			phy_interface_t interface);
+void lan937x_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
+		       u64 *dropped, u64 *cnt);
 
 struct mib_names {
 	int index;
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 1b8fabdf9b35..4a58f2a2929c 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -272,6 +272,73 @@ static int lan937x_get_max_mtu(struct dsa_switch *ds, int port)
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
+
+	lan937x_config_interface(dev, port, speed, duplex,
+				 tx_pause, rx_pause);
+}
+
+static void lan937x_phylink_get_caps(struct dsa_switch *ds, int port,
+				     struct phylink_config *config)
+{
+	struct ksz_device *dev = ds->priv;
+
+	config->mac_capabilities = MAC_100FD;
+
+	/* internal T1 PHY */
+	if (lan937x_is_internal_base_t1_phy_port(dev, port)) {
+		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
+			  config->supported_interfaces);
+	} else {
+		/* MII/RMII/RGMII ports */
+		if (!lan937x_is_internal_base_tx_phy_port(dev, port)) {
+			config->mac_capabilities |= MAC_100HD | MAC_SYM_PAUSE |
+						    MAC_ASYM_PAUSE | MAC_10 |
+						    MAC_1000FD;
+			phy_interface_set_rgmii(config->supported_interfaces);
+
+			__set_bit(PHY_INTERFACE_MODE_MII,
+				  config->supported_interfaces);
+			__set_bit(PHY_INTERFACE_MODE_RMII,
+				  config->supported_interfaces);
+		}
+	}
+}
+
 const struct dsa_switch_ops lan937x_switch_ops = {
 	.get_tag_protocol = lan937x_get_tag_protocol,
 	.setup = lan937x_setup,
@@ -284,6 +351,10 @@ const struct dsa_switch_ops lan937x_switch_ops = {
 	.port_fast_age = ksz_port_fast_age,
 	.port_max_mtu = lan937x_get_max_mtu,
 	.port_change_mtu = lan937x_change_mtu,
+	.phylink_get_caps = lan937x_phylink_get_caps,
+	.phylink_mac_link_down = ksz_mac_link_down,
+	.phylink_mac_config = lan937x_phylink_mac_config,
+	.phylink_mac_link_up = lan937x_phylink_mac_link_up,
 };
 
 int lan937x_switch_register(struct ksz_device *dev)
-- 
2.30.2

