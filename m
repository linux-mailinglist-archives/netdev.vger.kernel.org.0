Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD54A2BB24A
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbgKTSRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:17:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbgKTSRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 13:17:11 -0500
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DB5C0613CF;
        Fri, 20 Nov 2020 10:17:11 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id l36so9586953ota.4;
        Fri, 20 Nov 2020 10:17:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9EBvmcQ3t+uSMbsSclnU9MTbwYcDmsNY4HFJq8NB8BQ=;
        b=n6gMgwGeD/Jw2AWrxHrdKR2g25Oju/x6UxAJXFAHJM99xfK3EMq8Hqz8yLjXdjZMWX
         yZgkFgCOZlP5WJbNsZ91z1ine7+HcP3sOGfqIBdbWGuwQ1EDzEy6I5Rzq3Xm7uyHOoOy
         y3407UXXtWIXHSjgabX0MY5+aENjYLE/iu7d0bjAuhtkobsOOE4b534MQT7THo2IS5j2
         HhzUVbvPoxqsg9kJi1MJFovIBP6j+xL6D12Ln0M4Y8agE8n5K1cCJZoaeMHDp3xEvhVQ
         0wK/ol6axRAzrXQEoUt1prZ8FUC7yqlrPKQdsaC66yT/Q3aoxfiojWFXPE38spZXefRK
         zsOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9EBvmcQ3t+uSMbsSclnU9MTbwYcDmsNY4HFJq8NB8BQ=;
        b=TCYR6xDBuKJQ4igJsErB/6Ko13aej5+yPWuC8W4ctABnkey1p8Ds5YkWE9ORkLVmLS
         AMt0xURA85nf7JZFwm60w4I0V2+C58x6+0PlMsClMGxK8K9vPCNX+Dc6w5sOXXLbdh2G
         xjysloqSQhmFUSss1wvgZyaOGFGk/4HeGo/oxefGLAr3fOOyB7I+eRF4IdM3iM297qIo
         BBeCMd2JuPwLRCrOnMBAlMr87BYGPqfyAlZQb3ZzJyS//oXDcT229J9hgVRD4vvyRAPo
         KQYB4JEzbnw2tbKSvjOHXjNg1v8x8b9q1zTN4FtD5d1/f+wWXYLv7zMNjK1cHhidU1K/
         mMQw==
X-Gm-Message-State: AOAM530Jzq9+UB0qIHdBMIb2SEA89eBGeoNTDPy5caV8856MptM3DU3+
        Gq/jk7YJUnSZjG6WVQYVLA==
X-Google-Smtp-Source: ABdhPJyeSPgcQiBd+2RNHGuN5twDYThkzaODxYd1x/7d+QXrtf+APGNMYeXxo0TAkwbCU1pQCaqjng==
X-Received: by 2002:a9d:740d:: with SMTP id n13mr14726204otk.37.1605896230302;
        Fri, 20 Nov 2020 10:17:10 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id y35sm1764420otb.5.2020.11.20.10.17.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Nov 2020 10:17:09 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller " <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next 2/3] net: dsa: add Arrow SpeedChips XRS700x driver
Date:   Fri, 20 Nov 2020 12:16:26 -0600
Message-Id: <20201120181627.21382-3-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20201120181627.21382-1-george.mccollister@gmail.com>
References: <20201120181627.21382-1-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a driver with initial support for the Arrow SpeedChips XRS7000
series of gigabit Ethernet switch chips which are typically used in
critical networking applications.

The switches have up to three RGMII ports and one RMII port.
Management to the switches can be performed over i2c or mdio.

Support for advanced features such as PTP and
HSR/PRP (IEC 62439-3 Clause 5 & 4) is not included in this patch and
may be added at a later date.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 drivers/net/dsa/Kconfig        |  26 ++
 drivers/net/dsa/Makefile       |   3 +
 drivers/net/dsa/xrs700x.c      | 529 +++++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/xrs700x.h      |  27 +++
 drivers/net/dsa/xrs700x_i2c.c  | 148 ++++++++++++
 drivers/net/dsa/xrs700x_mdio.c | 160 +++++++++++++
 drivers/net/dsa/xrs700x_reg.h  | 205 ++++++++++++++++
 7 files changed, 1098 insertions(+)
 create mode 100644 drivers/net/dsa/xrs700x.c
 create mode 100644 drivers/net/dsa/xrs700x.h
 create mode 100644 drivers/net/dsa/xrs700x_i2c.c
 create mode 100644 drivers/net/dsa/xrs700x_mdio.c
 create mode 100644 drivers/net/dsa/xrs700x_reg.h

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index f6a0488589fc..e5ec3c602bcb 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -134,4 +134,30 @@ config NET_DSA_VITESSE_VSC73XX_PLATFORM
 	  This enables support for the Vitesse VSC7385, VSC7388, VSC7395
 	  and VSC7398 SparX integrated ethernet switches, connected over
 	  a CPU-attached address bus and work in memory-mapped I/O mode.
+
+config NET_DSA_XRS700X
+	tristate
+	depends on NET_DSA
+	select NET_DSA_TAG_XRS700X
+	select REGMAP
+	help
+	  This enables support for Arrow SpeedChips XRS7003/7004 gigabit
+	  Ethernet switches.
+
+config NET_DSA_XRS700X_I2C
+	tristate "Arrow XRS7000X series switch in I2C mode"
+	depends on NET_DSA && I2C
+	select NET_DSA_XRS700X
+	select REGMAP_I2C
+	help
+	  Enable I2C support for Arrow SpeedChips XRS7003/7004 gigabit Ethernet
+	  switches.
+
+config NET_DSA_XRS700X_MDIO
+	tristate "Arrow XRS7000X series switch in MDIO mode"
+	depends on NET_DSA
+	select NET_DSA_XRS700X
+	help
+	  Enable MDIO support for Arrow SpeedChips XRS7003/7004 gigabit Ethernet
+	  switches.
 endmenu
diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
index a84adb140a04..4528d6b57fc8 100644
--- a/drivers/net/dsa/Makefile
+++ b/drivers/net/dsa/Makefile
@@ -17,6 +17,9 @@ obj-$(CONFIG_NET_DSA_SMSC_LAN9303_MDIO) += lan9303_mdio.o
 obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX) += vitesse-vsc73xx-core.o
 obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX_PLATFORM) += vitesse-vsc73xx-platform.o
 obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX_SPI) += vitesse-vsc73xx-spi.o
+obj-$(CONFIG_NET_DSA_XRS700X) += xrs700x.o
+obj-$(CONFIG_NET_DSA_XRS700X_I2C) += xrs700x_i2c.o
+obj-$(CONFIG_NET_DSA_XRS700X_MDIO) += xrs700x_mdio.o
 obj-y				+= b53/
 obj-y				+= hirschmann/
 obj-y				+= microchip/
diff --git a/drivers/net/dsa/xrs700x.c b/drivers/net/dsa/xrs700x.c
new file mode 100644
index 000000000000..6cef3b534d5d
--- /dev/null
+++ b/drivers/net/dsa/xrs700x.c
@@ -0,0 +1,529 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020 NovaTech LLC
+ * George McCollister <george.mccollister@gmail.com>
+ */
+
+#include <net/dsa.h>
+#include <linux/if_bridge.h>
+#include "xrs700x.h"
+#include "xrs700x_reg.h"
+
+#define XRS700X_MIB_INTERVAL msecs_to_jiffies(30000)
+
+#define XRS7003E_ID	0x100
+#define XRS7003F_ID	0x101
+#define XRS7004E_ID	0x200
+#define XRS7004F_ID	0x201
+
+struct xrs700x_model {
+	unsigned int id;
+	const char *name;
+	size_t num_ports;
+};
+
+static const struct xrs700x_model xrs700x_models[] = {
+	{XRS7003E_ID, "XRS7003E", 3},
+	{XRS7003F_ID, "XRS7003F", 3},
+	{XRS7004E_ID, "XRS7004E", 4},
+	{XRS7004F_ID, "XRS7004F", 4},
+};
+
+struct xrs700x_mib {
+	unsigned int offset;
+	const char *name;
+};
+
+static const struct xrs700x_mib xrs700x_mibs[] = {
+	{XRS_RX_GOOD_OCTETS_L(0), "rx_good_octets"},
+	{XRS_RX_BAD_OCTETS_L(0), "rx_bad_octets"},
+	{XRS_RX_UNICAST_L(0), "rx_unicast"},
+	{XRS_RX_BROADCAST_L(0), "rx_broadcast"},
+	{XRS_RX_MULTICAST_L(0), "rx_multicast"},
+	{XRS_RX_UNDERSIZE_L(0), "rx_undersize"},
+	{XRS_RX_FRAGMENTS_L(0), "rx_fragments"},
+	{XRS_RX_OVERSIZE_L(0), "rx_oversize"},
+	{XRS_RX_JABBER_L(0), "rx_jabber"},
+	{XRS_RX_ERR_L(0), "rx_err"},
+	{XRS_RX_CRC_L(0), "rx_crc"},
+	{XRS_RX_64_L(0), "rx_64"},
+	{XRS_RX_65_127_L(0), "rx_65_127"},
+	{XRS_RX_128_255_L(0), "rx_128_255"},
+	{XRS_RX_256_511_L(0), "rx_256_511"},
+	{XRS_RX_512_1023_L(0), "rx_512_1023"},
+	{XRS_RX_1024_1536_L(0), "rx_1024_1536"},
+	{XRS_RX_HSR_PRP_L(0), "rx_hsr_prp"},
+	{XRS_RX_WRONGLAN_L(0), "rx_wronglan"},
+	{XRS_RX_DUPLICATE_L(0), "rx_duplicate"},
+	{XRS_TX_OCTETS_L(0), "tx_octets"},
+	{XRS_TX_UNICAST_L(0), "tx_unicast"},
+	{XRS_TX_BROADCAST_L(0), "tx_broadcast"},
+	{XRS_TX_MULTICAST_L(0), "tx_multicast"},
+	{XRS_TX_HSR_PRP_L(0), "tx_hsr_prp"},
+	{XRS_PRIQ_DROP_L(0), "priq_drop"},
+	{XRS_EARLY_DROP_L(0), "early_drop"},
+};
+
+static void xrs700x_get_strings(struct dsa_switch *ds, int port,
+				u32 stringset, uint8_t *data)
+{
+	int i;
+
+	if (stringset != ETH_SS_STATS)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(xrs700x_mibs); i++) {
+		strlcpy(data, xrs700x_mibs[i].name, ETH_GSTRING_LEN);
+		data += ETH_GSTRING_LEN;
+	}
+}
+
+static int xrs700x_get_sset_count(struct dsa_switch *ds, int port, int sset)
+{
+	if (sset != ETH_SS_STATS)
+		return -EOPNOTSUPP;
+
+	return ARRAY_SIZE(xrs700x_mibs);
+}
+
+static void xrs700x_read_port_counters(struct xrs700x *priv, int port)
+{
+	int i;
+	struct xrs700x_port *p = &priv->ports[port];
+
+	mutex_lock(&p->mib_mutex);
+
+	/* Capture counter values */
+	regmap_write(priv->regmap, XRS_CNT_CTRL(port), 1);
+
+	for (i = 0; i < ARRAY_SIZE(xrs700x_mibs); i++) {
+		unsigned int high = 0, low = 0, reg;
+
+		reg = xrs700x_mibs[i].offset + XRS_PORT_OFFSET * port;
+		regmap_read(priv->regmap, reg, &low);
+		regmap_read(priv->regmap, reg + 2, &high);
+
+		p->mib_data[i] += (high << 16) | low;
+	}
+
+	mutex_unlock(&p->mib_mutex);
+}
+
+static void xrs700x_mib_work(struct work_struct *work)
+{
+	struct xrs700x *priv = container_of(work, struct xrs700x,
+					    mib_work.work);
+	int i;
+
+	for (i = 0; i < priv->ds->num_ports; i++)
+		xrs700x_read_port_counters(priv, i);
+
+	schedule_delayed_work(&priv->mib_work, XRS700X_MIB_INTERVAL);
+}
+
+static void xrs700x_get_ethtool_stats(struct dsa_switch *ds, int port,
+				      uint64_t *data)
+{
+	struct xrs700x *priv = ds->priv;
+	struct xrs700x_port *p = &priv->ports[port];
+
+	xrs700x_read_port_counters(priv, port);
+
+	mutex_lock(&p->mib_mutex);
+	memcpy(data, p->mib_data, sizeof(*data) * ARRAY_SIZE(xrs700x_mibs));
+	mutex_unlock(&p->mib_mutex);
+}
+
+static int xrs700x_setup_regmap_range(struct xrs700x *priv)
+{
+	struct reg_field ps_forward = REG_FIELD_ID(XRS_PORT_STATE(0), 0, 1,
+						   priv->ds->num_ports,
+						   XRS_PORT_OFFSET);
+	struct reg_field ps_management = REG_FIELD_ID(XRS_PORT_STATE(0), 2, 3,
+						      priv->ds->num_ports,
+						      XRS_PORT_OFFSET);
+	struct reg_field ps_sel_speed = REG_FIELD_ID(XRS_PORT_STATE(0), 4, 9,
+						     priv->ds->num_ports,
+						     XRS_PORT_OFFSET);
+	struct reg_field ps_cur_speed = REG_FIELD_ID(XRS_PORT_STATE(0), 10, 11,
+						     priv->ds->num_ports,
+						     XRS_PORT_OFFSET);
+
+	priv->ps_forward = devm_regmap_field_alloc(priv->dev, priv->regmap,
+						   ps_forward);
+	if (IS_ERR(priv->ps_forward))
+		return PTR_ERR(priv->ps_forward);
+
+	priv->ps_management = devm_regmap_field_alloc(priv->dev, priv->regmap,
+						      ps_management);
+	if (IS_ERR(priv->ps_management))
+		return PTR_ERR(priv->ps_management);
+
+	priv->ps_sel_speed = devm_regmap_field_alloc(priv->dev, priv->regmap,
+						     ps_sel_speed);
+	if (IS_ERR(priv->ps_sel_speed))
+		return PTR_ERR(priv->ps_sel_speed);
+
+	priv->ps_cur_speed = devm_regmap_field_alloc(priv->dev, priv->regmap,
+						     ps_cur_speed);
+	if (IS_ERR(priv->ps_cur_speed))
+		return PTR_ERR(priv->ps_cur_speed);
+
+	return 0;
+}
+
+static enum dsa_tag_protocol xrs700x_get_tag_protocol(struct dsa_switch *ds,
+						      int port,
+						      enum dsa_tag_protocol m)
+{
+	return DSA_TAG_PROTO_XRS700X;
+}
+
+static int xrs700x_reset(struct dsa_switch *ds)
+{
+	struct xrs700x *priv = ds->priv;
+	int ret;
+	unsigned int val;
+
+	ret = regmap_write(priv->regmap, XRS_GENERAL, XRS_GENERAL_RESET);
+	if (ret)
+		goto error;
+
+	ret = regmap_read_poll_timeout(priv->regmap, XRS_GENERAL,
+				       val, !(val & XRS_GENERAL_RESET),
+				       10, 1000);
+error:
+	if (ret) {
+		dev_err_ratelimited(priv->dev, "error resetting switch: %d\n",
+				    ret);
+	}
+
+	return ret;
+}
+
+static void xrs700x_port_stp_state_set(struct dsa_switch *ds, int port,
+				       u8 state)
+{
+	struct xrs700x *priv = ds->priv;
+	unsigned int val;
+
+	switch (state) {
+	case BR_STATE_DISABLED:
+		val = XRS_PORT_DISABLED;
+		break;
+	case BR_STATE_LISTENING:
+		val = XRS_PORT_DISABLED;
+		break;
+	case BR_STATE_LEARNING:
+		val = XRS_PORT_LEARNING;
+		break;
+	case BR_STATE_FORWARDING:
+		val = XRS_PORT_FORWARDING;
+		break;
+	case BR_STATE_BLOCKING:
+		val = XRS_PORT_DISABLED;
+		break;
+	default:
+		dev_err(ds->dev, "invalid STP state: %d\n", state);
+		return;
+	}
+
+	regmap_fields_write(priv->ps_forward, port, val);
+
+	dev_dbg_ratelimited(priv->dev, "%s - port: %d, state: %u, val: 0x%x\n",
+			    __func__, port, state, val);
+}
+
+static int xrs700x_port_setup(struct dsa_switch *ds, int port)
+{
+	struct xrs700x *priv = ds->priv;
+	bool cpu_port = dsa_is_cpu_port(ds, port);
+	unsigned int val;
+	int ret, i;
+
+	xrs700x_port_stp_state_set(ds, port, BR_STATE_DISABLED);
+
+	/* Disable forwarding to non-CPU ports */
+	for (val = 0, i = 0; i < ds->num_ports; i++) {
+		if (!dsa_is_cpu_port(ds, i))
+			val |= BIT(i);
+	}
+
+	ret = regmap_write(priv->regmap, XRS_PORT_FWD_MASK(port), val);
+	if (ret)
+		return ret;
+
+	val = cpu_port ? XRS_PORT_MODE_MANAGEMENT : XRS_PORT_MODE_NORMAL;
+	ret = regmap_fields_write(priv->ps_management, port, val);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int xrs700x_setup(struct dsa_switch *ds)
+{
+	struct xrs700x *priv = ds->priv;
+	int ret, i;
+
+	ret = xrs700x_reset(ds);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < ds->num_ports; i++) {
+		ret = xrs700x_port_setup(ds, i);
+		if (ret)
+			return ret;
+	}
+
+	schedule_delayed_work(&priv->mib_work, XRS700X_MIB_INTERVAL);
+
+	return 0;
+}
+
+static void xrs700x_phylink_validate(struct dsa_switch *ds, int port,
+				     unsigned long *supported,
+				     struct phylink_link_state *state)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+
+	switch (port) {
+	case 0:
+		break;
+	case 1:
+	case 2:
+	case 3:
+		phylink_set(mask, 1000baseT_Full);
+		break;
+	default:
+		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		dev_err(ds->dev, "Unsupported port: %i\n", port);
+		return;
+	}
+
+	phylink_set_port_modes(mask);
+
+	/* The switch only supports full duplex. */
+	phylink_set(mask, 10baseT_Full);
+	phylink_set(mask, 100baseT_Full);
+
+	bitmap_and(supported, supported, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	bitmap_and(state->advertising, state->advertising, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+
+static void xrs700x_phylink_mac_config(struct dsa_switch *ds, int port,
+				       unsigned int mode,
+				       const struct phylink_link_state *state)
+{
+	struct xrs700x *priv = ds->priv;
+	unsigned int val;
+
+	switch (state->speed) {
+	case SPEED_1000:
+		val = XRS_PORT_SPEED_1000;
+		break;
+	case SPEED_100:
+		val = XRS_PORT_SPEED_100;
+		break;
+	case SPEED_10:
+		val = XRS_PORT_SPEED_10;
+		break;
+	default:
+		return;
+	}
+
+	regmap_fields_write(priv->ps_sel_speed, port, val);
+
+	dev_dbg_ratelimited(priv->dev, "%s: port: %d mode: %u speed: %u\n",
+			    __func__, port, mode, state->speed);
+}
+
+static int xrs700x_bridge_join(struct dsa_switch *ds, int port,
+			       struct net_device *bridge)
+{
+	struct xrs700x *priv = ds->priv;
+	unsigned int i, ret, mask = 0;
+
+	for (i = 0; i < ds->num_ports; i++) {
+		if (dsa_to_port(ds, i)->bridge_dev == bridge ||
+		    dsa_is_cpu_port(ds, i))
+			continue;
+
+		mask |= BIT(i);
+	}
+
+	dev_dbg(priv->dev, "%s: port: %d mask: 0x%x\n", __func__,
+		port, mask);
+
+	for (i = 0; i < ds->num_ports; i++) {
+		if (dsa_to_port(ds, i)->bridge_dev != bridge)
+			continue;
+
+		ret = regmap_write(priv->regmap, XRS_PORT_FWD_MASK(i), mask);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static void xrs700x_bridge_leave(struct dsa_switch *ds, int port,
+				 struct net_device *bridge)
+{
+	struct xrs700x *priv = ds->priv;
+	unsigned int i, cpu_mask = 0, mask = 0;
+
+	for (i = 0; i < ds->num_ports; i++) {
+		if (dsa_is_cpu_port(ds, i))
+			continue;
+
+		cpu_mask |= BIT(i);
+
+		if (dsa_to_port(ds, i)->bridge_dev == bridge)
+			continue;
+
+		mask |= BIT(i);
+	}
+
+	dev_dbg(priv->dev, "%s: port: %d mask: 0x%x\n", __func__,
+		port, mask);
+
+	for (i = 0; i < ds->num_ports; i++) {
+		if (dsa_to_port(ds, i)->bridge_dev != bridge)
+			continue;
+
+		regmap_write(priv->regmap, XRS_PORT_FWD_MASK(i), mask);
+	}
+
+	regmap_write(priv->regmap, XRS_PORT_FWD_MASK(port), cpu_mask);
+}
+
+static const struct dsa_switch_ops xrs700x_ops = {
+	.get_tag_protocol	= xrs700x_get_tag_protocol,
+	.setup			= xrs700x_setup,
+	.port_stp_state_set	= xrs700x_port_stp_state_set,
+	.phylink_validate	= xrs700x_phylink_validate,
+	.phylink_mac_config	= xrs700x_phylink_mac_config,
+	.get_strings		= xrs700x_get_strings,
+	.get_sset_count		= xrs700x_get_sset_count,
+	.get_ethtool_stats	= xrs700x_get_ethtool_stats,
+	.port_bridge_join	= xrs700x_bridge_join,
+	.port_bridge_leave	= xrs700x_bridge_leave,
+};
+
+static int xrs700x_detect(struct xrs700x *dev)
+{
+	int i, ret;
+	unsigned int id;
+
+	ret = regmap_read(dev->regmap, XRS_DEV_ID0, &id);
+	if (ret) {
+		dev_err(dev->dev, "error %d while reading switch id.\n",
+			ret);
+		return ret;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(xrs700x_models); i++) {
+		if (xrs700x_models[i].id == id) {
+			dev->ds->num_ports = xrs700x_models[i].num_ports;
+			dev_info(dev->dev, "%s detected.\n",
+				 xrs700x_models[i].name);
+			return 0;
+		}
+	}
+
+	dev_err(dev->dev, "unknown switch id 0x%x.\n", id);
+
+	return -ENODEV;
+}
+
+struct xrs700x *xrs700x_switch_alloc(struct device *base, void *priv)
+{
+	struct dsa_switch *ds;
+	struct xrs700x *dev;
+
+	ds = devm_kzalloc(base, sizeof(*ds), GFP_KERNEL);
+	if (!ds)
+		return NULL;
+
+	ds->dev = base;
+	ds->num_ports = DSA_MAX_PORTS;
+
+	dev = devm_kzalloc(base, sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return NULL;
+
+	INIT_DELAYED_WORK(&dev->mib_work, xrs700x_mib_work);
+
+	ds->ops = &xrs700x_ops;
+	ds->priv = dev;
+	dev->dev = base;
+
+	dev->ds = ds;
+	dev->priv = priv;
+
+	return dev;
+}
+EXPORT_SYMBOL(xrs700x_switch_alloc);
+
+static int xrs700x_alloc_port_mib(struct xrs700x *dev, int port)
+{
+	struct xrs700x_port *p = &dev->ports[port];
+	size_t mib_size = sizeof(*p->mib_data) * ARRAY_SIZE(xrs700x_mibs);
+
+	p->mib_data = devm_kzalloc(dev->dev, mib_size, GFP_KERNEL);
+	if (!p->mib_data)
+		return -ENOMEM;
+
+	mutex_init(&p->mib_mutex);
+
+	return 0;
+}
+
+int xrs700x_switch_register(struct xrs700x *dev)
+{
+	int ret;
+	int i;
+
+	ret = xrs700x_detect(dev);
+	if (ret)
+		return ret;
+
+	ret = xrs700x_setup_regmap_range(dev);
+	if (ret)
+		return ret;
+
+	dev->ports = devm_kzalloc(dev->dev,
+				  sizeof(*dev->ports) * dev->ds->num_ports,
+				  GFP_KERNEL);
+	if (!dev->ports)
+		return -ENOMEM;
+
+	for (i = 0; i < dev->ds->num_ports; i++) {
+		ret = xrs700x_alloc_port_mib(dev, i);
+		if (ret)
+			return ret;
+	}
+
+	ret = dsa_register_switch(dev->ds);
+
+	if (ret)
+		cancel_delayed_work_sync(&dev->mib_work);
+
+	return ret;
+}
+EXPORT_SYMBOL(xrs700x_switch_register);
+
+void xrs700x_switch_remove(struct xrs700x *dev)
+{
+	cancel_delayed_work_sync(&dev->mib_work);
+
+	dsa_unregister_switch(dev->ds);
+}
+EXPORT_SYMBOL(xrs700x_switch_remove);
+
+MODULE_AUTHOR("George McCollister <george.mccollister@gmail.com>");
+MODULE_DESCRIPTION("Arrow SpeedChips XRS700x DSA driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/dsa/xrs700x.h b/drivers/net/dsa/xrs700x.h
new file mode 100644
index 000000000000..53acf4359477
--- /dev/null
+++ b/drivers/net/dsa/xrs700x.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/device.h>
+#include <linux/mutex.h>
+#include <linux/regmap.h>
+#include <linux/workqueue.h>
+
+struct xrs700x_port {
+	struct mutex mib_mutex; /* protects mib_data */
+	uint64_t *mib_data;
+};
+
+struct xrs700x {
+	struct dsa_switch *ds;
+	struct device *dev;
+	void *priv;
+	struct regmap *regmap;
+	struct regmap_field *ps_forward;
+	struct regmap_field *ps_management;
+	struct regmap_field *ps_sel_speed;
+	struct regmap_field *ps_cur_speed;
+	struct delayed_work mib_work;
+	struct xrs700x_port *ports;
+};
+
+struct xrs700x *xrs700x_switch_alloc(struct device *base, void *priv);
+int xrs700x_switch_register(struct xrs700x *dev);
+void xrs700x_switch_remove(struct xrs700x *dev);
diff --git a/drivers/net/dsa/xrs700x_i2c.c b/drivers/net/dsa/xrs700x_i2c.c
new file mode 100644
index 000000000000..30f6c5ce825b
--- /dev/null
+++ b/drivers/net/dsa/xrs700x_i2c.c
@@ -0,0 +1,148 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020 NovaTech LLC
+ * George McCollister <george.mccollister@gmail.com>
+ */
+
+#include <linux/bits.h>
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include "xrs700x.h"
+#include "xrs700x_reg.h"
+
+static int xrs700x_i2c_reg_read(void *context, unsigned int reg,
+				unsigned int *val)
+{
+	int ret;
+	unsigned char buf[4];
+	struct device *dev = context;
+	struct i2c_client *i2c = to_i2c_client(dev);
+
+	buf[0] = reg >> 23 & 0xff;
+	buf[1] = reg >> 15 & 0xff;
+	buf[2] = reg >> 7 & 0xff;
+	buf[3] = (reg & 0x7f) << 1;
+
+	ret = i2c_master_send(i2c, buf, sizeof(buf));
+	if (ret < 0) {
+		dev_err(dev, "xrs i2c_master_send returned %d\n", ret);
+		return ret;
+	}
+
+	ret = i2c_master_recv(i2c, buf, 2);
+	if (ret < 0) {
+		dev_err(dev, "xrs i2c_master_recv returned %d\n", ret);
+		return ret;
+	}
+
+	*val = buf[0] << 8 | buf[1];
+
+	return 0;
+}
+
+static int xrs700x_i2c_reg_write(void *context, unsigned int reg,
+				 unsigned int val)
+{
+	int ret;
+	unsigned char buf[6];
+	struct device *dev = context;
+	struct i2c_client *i2c = to_i2c_client(dev);
+
+	buf[0] = reg >> 23 & 0xff;
+	buf[1] = reg >> 15 & 0xff;
+	buf[2] = reg >> 7 & 0xff;
+	buf[3] = (reg & 0x7f) << 1 | 1;
+	buf[4] = val >> 8 & 0xff;
+	buf[5] = val & 0xff;
+
+	ret = i2c_master_send(i2c, buf, sizeof(buf));
+	if (ret < 0) {
+		dev_err(dev, "xrs i2c_master_send returned %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static const struct regmap_config xrs700x_i2c_regmap_config = {
+	.val_bits = 16,
+	.reg_stride = 2,
+	.reg_bits = 32,
+	.pad_bits = 0,
+	.write_flag_mask = 0,
+	.read_flag_mask = 0,
+	.reg_read = xrs700x_i2c_reg_read,
+	.reg_write = xrs700x_i2c_reg_write,
+	.max_register = 0,
+	.cache_type = REGCACHE_NONE,
+	.reg_format_endian = REGMAP_ENDIAN_BIG,
+	.val_format_endian = REGMAP_ENDIAN_BIG
+};
+
+static int xrs700x_i2c_probe(struct i2c_client *i2c,
+			     const struct i2c_device_id *i2c_id)
+{
+	struct xrs700x *dev;
+	int ret;
+
+	dev = xrs700x_switch_alloc(&i2c->dev, i2c);
+	if (!dev)
+		return -ENOMEM;
+
+	dev->regmap = devm_regmap_init(&i2c->dev, NULL, &i2c->dev,
+				       &xrs700x_i2c_regmap_config);
+	if (IS_ERR(dev->regmap)) {
+		ret = PTR_ERR(dev->regmap);
+		dev_err(&i2c->dev, "Failed to initialize regmap: %d\n", ret);
+		return ret;
+	}
+
+	ret = xrs700x_switch_register(dev);
+
+	/* Main DSA driver may not be started yet. */
+	if (ret)
+		return ret;
+
+	i2c_set_clientdata(i2c, dev);
+
+	return 0;
+}
+
+static int xrs700x_i2c_remove(struct i2c_client *i2c)
+{
+	struct xrs700x *dev = i2c_get_clientdata(i2c);
+
+	xrs700x_switch_remove(dev);
+
+	return 0;
+}
+
+static const struct i2c_device_id xrs700x_i2c_id[] = {
+	{ "xrs700x-switch", 0 },
+	{},
+};
+
+MODULE_DEVICE_TABLE(i2c, xrs700x_i2c_id);
+
+static const struct of_device_id xrs700x_i2c_dt_ids[] = {
+	{ .compatible = "arrow,xrs7003" },
+	{ .compatible = "arrow,xrs7004" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, xrs700x_i2c_dt_ids);
+
+static struct i2c_driver xrs700x_i2c_driver = {
+	.driver = {
+		.name	= "xrs700x-i2c",
+		.of_match_table = of_match_ptr(xrs700x_i2c_dt_ids),
+	},
+	.probe	= xrs700x_i2c_probe,
+	.remove	= xrs700x_i2c_remove,
+	.id_table = xrs700x_i2c_id,
+};
+
+module_i2c_driver(xrs700x_i2c_driver);
+
+MODULE_AUTHOR("George McCollister <george.mccollister@gmail.com>");
+MODULE_DESCRIPTION("Arrow SpeedChips XRS700x DSA I2C driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/dsa/xrs700x_mdio.c b/drivers/net/dsa/xrs700x_mdio.c
new file mode 100644
index 000000000000..6152bed43192
--- /dev/null
+++ b/drivers/net/dsa/xrs700x_mdio.c
@@ -0,0 +1,160 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020 NovaTech LLC
+ * George McCollister <george.mccollister@gmail.com>
+ */
+
+#include <linux/bitfield.h>
+#include <linux/bits.h>
+#include <linux/mdio.h>
+#include <linux/module.h>
+#include <linux/phy.h>
+#include "xrs700x.h"
+#include "xrs700x_reg.h"
+
+#define XRS_MDIO_IBA0	0x10
+#define XRS_MDIO_IBA1	0x11
+#define XRS_MDIO_IBD	0x14
+
+#define XRS_IB_READ	0x0
+#define XRS_IB_WRITE	0x1
+
+static int xrs700x_mdio_reg_read(void *context, unsigned int reg,
+				 unsigned int *val)
+{
+	int ret;
+	struct mdio_device *mdiodev = context;
+	struct device *dev = &mdiodev->dev;
+	u16 uval;
+
+	uval = (u16)FIELD_GET(GENMASK(31, 16), reg);
+
+	ret = mdiobus_write(mdiodev->bus, mdiodev->addr, XRS_MDIO_IBA1, uval);
+	if (ret < 0) {
+		dev_err(dev, "xrs mdiobus_write returned %d\n", ret);
+		return ret;
+	}
+
+	uval = (u16)((reg & GENMASK(15, 1)) | XRS_IB_READ);
+
+	ret = mdiobus_write(mdiodev->bus, mdiodev->addr, XRS_MDIO_IBA0, uval);
+	if (ret < 0) {
+		dev_err(dev, "xrs mdiobus_write returned %d\n", ret);
+		return ret;
+	}
+
+	ret = mdiobus_read(mdiodev->bus, mdiodev->addr, XRS_MDIO_IBD);
+	if (ret < 0) {
+		dev_err(dev, "xrs mdiobus_read returned %d\n", ret);
+		return ret;
+	}
+
+	*val = (unsigned int)ret;
+
+	return 0;
+}
+
+static int xrs700x_mdio_reg_write(void *context, unsigned int reg,
+				  unsigned int val)
+{
+	int ret;
+	struct mdio_device *mdiodev = context;
+	struct device *dev = &mdiodev->dev;
+	u16 uval;
+
+	ret = mdiobus_write(mdiodev->bus, mdiodev->addr, XRS_MDIO_IBD, (u16)val);
+	if (ret < 0) {
+		dev_err(dev, "xrs mdiobus_write returned %d\n", ret);
+		return ret;
+	}
+
+	uval = (u16)FIELD_GET(GENMASK(31, 16), reg);
+
+	ret = mdiobus_write(mdiodev->bus, mdiodev->addr, XRS_MDIO_IBA1, uval);
+	if (ret < 0) {
+		dev_err(dev, "xrs mdiobus_write returned %d\n", ret);
+		return ret;
+	}
+
+	uval = (u16)((reg & GENMASK(15, 1)) | XRS_IB_WRITE);
+
+	ret = mdiobus_write(mdiodev->bus, mdiodev->addr, XRS_MDIO_IBA0, uval);
+	if (ret < 0) {
+		dev_err(dev, "xrs mdiobus_write returned %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static const struct regmap_config xrs700x_mdio_regmap_config = {
+	.val_bits = 16,
+	.reg_stride = 2,
+	.reg_bits = 32,
+	.pad_bits = 0,
+	.write_flag_mask = 0,
+	.read_flag_mask = 0,
+	.reg_read = xrs700x_mdio_reg_read,
+	.reg_write = xrs700x_mdio_reg_write,
+	.max_register = XRS_VLAN(MAX_VLAN),
+	.cache_type = REGCACHE_NONE,
+	.reg_format_endian = REGMAP_ENDIAN_BIG,
+	.val_format_endian = REGMAP_ENDIAN_BIG
+};
+
+static int xrs700x_mdio_probe(struct mdio_device *mdiodev)
+{
+	struct xrs700x *dev;
+	int ret;
+
+	dev = xrs700x_switch_alloc(&mdiodev->dev, mdiodev);
+	if (!dev)
+		return -ENOMEM;
+
+	dev->regmap = devm_regmap_init(&mdiodev->dev, NULL, mdiodev,
+				       &xrs700x_mdio_regmap_config);
+	if (IS_ERR(dev->regmap)) {
+		ret = PTR_ERR(dev->regmap);
+		dev_err(&mdiodev->dev, "Failed to initialize regmap: %d\n", ret);
+		return ret;
+	}
+
+	ret = xrs700x_switch_register(dev);
+
+	/* Main DSA driver may not be started yet. */
+	if (ret)
+		return ret;
+
+	dev_set_drvdata(&mdiodev->dev, dev);
+
+	return 0;
+}
+
+static void xrs700x_mdio_remove(struct mdio_device *mdiodev)
+{
+	struct xrs700x *dev = dev_get_drvdata(&mdiodev->dev);
+
+	xrs700x_switch_remove(dev);
+}
+
+static const struct of_device_id xrs700x_mdio_dt_ids[] = {
+	{ .compatible = "arrow,xrs7003" },
+	{ .compatible = "arrow,xrs7004" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, xrs700x_mdio_dt_ids);
+
+static struct mdio_driver xrs700x_mdio_driver = {
+	.mdiodrv.driver = {
+		.name	= "xrs700x-mdio",
+		.of_match_table = xrs700x_mdio_dt_ids,
+	},
+	.probe	= xrs700x_mdio_probe,
+	.remove	= xrs700x_mdio_remove,
+};
+
+mdio_module_driver(xrs700x_mdio_driver);
+
+MODULE_AUTHOR("George McCollister <george.mccollister@gmail.com>");
+MODULE_DESCRIPTION("Arrow SpeedChips XRS700x DSA MDIO driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/dsa/xrs700x_reg.h b/drivers/net/dsa/xrs700x_reg.h
new file mode 100644
index 000000000000..b2d7f1bd382d
--- /dev/null
+++ b/drivers/net/dsa/xrs700x_reg.h
@@ -0,0 +1,205 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Register Base Addresses */
+#define XRS_DEVICE_ID_BASE		0x0
+#define XRS_GPIO_BASE			0x10000
+#define XRS_PORT_OFFSET			0x10000
+#define XRS_PORT_BASE(x)		(0x200000 + XRS_PORT_OFFSET * (x))
+#define XRS_RTC_BASE			0x280000
+#define XRS_TS_OFFSET			0x8000
+#define XRS_TS_BASE(x)			(0x290000 + XRS_TS_OFFSET * (x))
+#define XRS_SWITCH_CONF_BASE		0x300000
+
+/* Device Identification Registers */
+#define XRS_DEV_ID0			(XRS_DEVICE_ID_BASE + 0)
+#define XRS_DEV_ID1			(XRS_DEVICE_ID_BASE + 2)
+#define XRS_INT_ID0			(XRS_DEVICE_ID_BASE + 4)
+#define XRS_INT_ID1			(XRS_DEVICE_ID_BASE + 6)
+#define XRS_REV_ID			(XRS_DEVICE_ID_BASE + 8)
+
+/* GPIO Registers */
+#define XRS_CONFIG0			(XRS_GPIO_BASE + 0x1000)
+#define XRS_INPUT_STATUS0		(XRS_GPIO_BASE + 0x1002)
+#define XRS_CONFIG1			(XRS_GPIO_BASE + 0x1004)
+#define XRS_INPUT_STATUS1		(XRS_GPIO_BASE + 0x1006)
+#define XRS_CONFIG2			(XRS_GPIO_BASE + 0x1008)
+#define XRS_INPUT_STATUS2		(XRS_GPIO_BASE + 0x100a)
+
+/* Port Configuration Registers */
+#define XRS_PORT_GEN_BASE(x)		(XRS_PORT_BASE(x) + 0x0)
+#define XRS_PORT_HSR_BASE(x)		(XRS_PORT_BASE(x) + 0x2000)
+#define XRS_PORT_PTP_BASE(x)		(XRS_PORT_BASE(x) + 0x4000)
+#define XRS_PORT_CNT_BASE(x)		(XRS_PORT_BASE(x) + 0x6000)
+#define XRS_PORT_IPO_BASE(x)		(XRS_PORT_BASE(x) + 0x8000)
+
+/* Port Configuration Registers - General and State */
+#define XRS_PORT_STATE(x)		(XRS_PORT_GEN_BASE(x) + 0x0)
+#define XRS_PORT_FORWARDING		0
+#define XRS_PORT_LEARNING		1
+#define XRS_PORT_DISABLED		2
+#define XRS_PORT_MODE_NORMAL		0
+#define XRS_PORT_MODE_MANAGEMENT	1
+#define XRS_PORT_SPEED_1000		0x12
+#define XRS_PORT_SPEED_100		0x20
+#define XRS_PORT_SPEED_10		0x30
+#define XRS_PORT_VLAN(x)		(XRS_PORT_GEN_BASE(x) + 0x10)
+#define XRS_PORT_VLAN0_MAPPING(x)	(XRS_PORT_GEN_BASE(x) + 0x12)
+#define XRS_PORT_FWD_MASK(x)		(XRS_PORT_GEN_BASE(x) + 0x14)
+#define XRS_PORT_VLAN_PRIO(x)		(XRS_PORT_GEN_BASE(x) + 0x16)
+
+/* Port Configuration Registers - HSR/PRP */
+#define XRS_HSR_CFG(x)			(XRS_PORT_HSR_BASE(x) + 0x0)
+
+/* Port Configuration Registers - PTP */
+#define XRS_PTP_RX_SYNC_DELAY_NS_LO(x)	(XRS_PORT_PTP_BASE(x) + 0x2)
+#define XRS_PTP_RX_SYNC_DELAY_NS_HI(x)	(XRS_PORT_PTP_BASE(x) + 0x4)
+#define XRS_PTP_RX_EVENT_DELAY_NS(x)	(XRS_PORT_PTP_BASE(x) + 0xa)
+#define XRS_PTP_TX_EVENT_DELAY_NS(x)	(XRS_PORT_PTP_BASE(x) + 0x12)
+
+/* Port Configuration Registers - Counter */
+#define XRS_CNT_CTRL(x)			(XRS_PORT_CNT_BASE(x) + 0x0)
+#define XRS_RX_GOOD_OCTETS_L(x)		(XRS_PORT_CNT_BASE(x) + 0x200)
+#define XRS_RX_GOOD_OCTETS_H(x)		(XRS_PORT_CNT_BASE(x) + 0x202)
+#define XRS_RX_BAD_OCTETS_L(x)		(XRS_PORT_CNT_BASE(x) + 0x204)
+#define XRS_RX_BAD_OCTETS_H(x)		(XRS_PORT_CNT_BASE(x) + 0x206)
+#define XRS_RX_UNICAST_L(x)		(XRS_PORT_CNT_BASE(x) + 0x208)
+#define XRS_RX_UNICAST_H(x)		(XRS_PORT_CNT_BASE(x) + 0x20a)
+#define XRS_RX_BROADCAST_L(x)		(XRS_PORT_CNT_BASE(x) + 0x20c)
+#define XRS_RX_BROADCAST_H(x)		(XRS_PORT_CNT_BASE(x) + 0x20e)
+#define XRS_RX_MULTICAST_L(x)		(XRS_PORT_CNT_BASE(x) + 0x210)
+#define XRS_RX_MULTICAST_H(x)		(XRS_PORT_CNT_BASE(x) + 0x212)
+#define XRS_RX_UNDERSIZE_L(x)		(XRS_PORT_CNT_BASE(x) + 0x214)
+#define XRS_RX_UNDERSIZE_H(x)		(XRS_PORT_CNT_BASE(x) + 0x216)
+#define XRS_RX_FRAGMENTS_L(x)		(XRS_PORT_CNT_BASE(x) + 0x218)
+#define XRS_RX_FRAGMENTS_H(x)		(XRS_PORT_CNT_BASE(x) + 0x21a)
+#define XRS_RX_OVERSIZE_L(x)		(XRS_PORT_CNT_BASE(x) + 0x21c)
+#define XRS_RX_OVERSIZE_H(x)		(XRS_PORT_CNT_BASE(x) + 0x21e)
+#define XRS_RX_JABBER_L(x)		(XRS_PORT_CNT_BASE(x) + 0x220)
+#define XRS_RX_JABBER_H(x)		(XRS_PORT_CNT_BASE(x) + 0x222)
+#define XRS_RX_ERR_L(x)			(XRS_PORT_CNT_BASE(x) + 0x224)
+#define XRS_RX_ERR_H(x)			(XRS_PORT_CNT_BASE(x) + 0x226)
+#define XRS_RX_CRC_L(x)			(XRS_PORT_CNT_BASE(x) + 0x228)
+#define XRS_RX_CRC_H(x)			(XRS_PORT_CNT_BASE(x) + 0x22a)
+#define XRS_RX_64_L(x)			(XRS_PORT_CNT_BASE(x) + 0x22c)
+#define XRS_RX_64_H(x)			(XRS_PORT_CNT_BASE(x) + 0x22e)
+#define XRS_RX_65_127_L(x)		(XRS_PORT_CNT_BASE(x) + 0x230)
+#define XRS_RX_65_127_H(x)		(XRS_PORT_CNT_BASE(x) + 0x232)
+#define XRS_RX_128_255_L(x)		(XRS_PORT_CNT_BASE(x) + 0x234)
+#define XRS_RX_128_255_H(x)		(XRS_PORT_CNT_BASE(x) + 0x236)
+#define XRS_RX_256_511_L(x)		(XRS_PORT_CNT_BASE(x) + 0x238)
+#define XRS_RX_256_511_H(x)		(XRS_PORT_CNT_BASE(x) + 0x23a)
+#define XRS_RX_512_1023_L(x)		(XRS_PORT_CNT_BASE(x) + 0x23c)
+#define XRS_RX_512_1023_H(x)		(XRS_PORT_CNT_BASE(x) + 0x23e)
+#define XRS_RX_1024_1536_L(x)		(XRS_PORT_CNT_BASE(x) + 0x240)
+#define XRS_RX_1024_1536_H(x)		(XRS_PORT_CNT_BASE(x) + 0x242)
+#define XRS_RX_HSR_PRP_L(x)		(XRS_PORT_CNT_BASE(x) + 0x244)
+#define XRS_RX_HSR_PRP_H(x)		(XRS_PORT_CNT_BASE(x) + 0x246)
+#define XRS_RX_WRONGLAN_L(x)		(XRS_PORT_CNT_BASE(x) + 0x248)
+#define XRS_RX_WRONGLAN_H(x)		(XRS_PORT_CNT_BASE(x) + 0x24a)
+#define XRS_RX_DUPLICATE_L(x)		(XRS_PORT_CNT_BASE(x) + 0x24c)
+#define XRS_RX_DUPLICATE_H(x)		(XRS_PORT_CNT_BASE(x) + 0x24e)
+#define XRS_TX_OCTETS_L(x)		(XRS_PORT_CNT_BASE(x) + 0x280)
+#define XRS_TX_OCTETS_H(x)		(XRS_PORT_CNT_BASE(x) + 0x282)
+#define XRS_TX_UNICAST_L(x)		(XRS_PORT_CNT_BASE(x) + 0x284)
+#define XRS_TX_UNICAST_H(x)		(XRS_PORT_CNT_BASE(x) + 0x286)
+#define XRS_TX_BROADCAST_L(x)		(XRS_PORT_CNT_BASE(x) + 0x288)
+#define XRS_TX_BROADCAST_H(x)		(XRS_PORT_CNT_BASE(x) + 0x28a)
+#define XRS_TX_MULTICAST_L(x)		(XRS_PORT_CNT_BASE(x) + 0x28c)
+#define XRS_TX_MULTICAST_H(x)		(XRS_PORT_CNT_BASE(x) + 0x28e)
+#define XRS_TX_HSR_PRP_L(x)		(XRS_PORT_CNT_BASE(x) + 0x290)
+#define XRS_TX_HSR_PRP_H(x)		(XRS_PORT_CNT_BASE(x) + 0x292)
+#define XRS_PRIQ_DROP_L(x)		(XRS_PORT_CNT_BASE(x) + 0x2c0)
+#define XRS_PRIQ_DROP_H(x)		(XRS_PORT_CNT_BASE(x) + 0x2c2)
+#define XRS_EARLY_DROP_L(x)		(XRS_PORT_CNT_BASE(x) + 0x2c4)
+#define XRS_EARLY_DROP_H(x)		(XRS_PORT_CNT_BASE(x) + 0x2c6)
+
+/* Port Configuration Registers - Inbound Policy 0 - 15 */
+#define XRS_ETH_ADDR_CFG(x, p)		(XRS_PORT_IPO_BASE(x) + \
+					 (p) * 0x20 + 0x0)
+#define XRS_ETH_ADDR_FWD_ALLOW(x, p)	(XRS_PORT_IPO_BASE(x) + \
+					 (p) * 0x20 + 0x2)
+#define XRS_ETH_ADDR_FWD_MIRROR(x, p)	(XRS_PORT_IPO_BASE(x) + \
+					 (p) * 0x20 + 0x4)
+#define XRS_ETH_ADDR_0(x, p)		(XRS_PORT_IPO_BASE(x) + \
+					 (p) * 0x20 + 0x8)
+#define XRS_ETH_ADDR_1(x, p)		(XRS_PORT_IPO_BASE(x) + \
+					 (p) * 0x20 + 0xa)
+#define XRS_ETH_ADDR_2(x, p)		(XRS_PORT_IPO_BASE(x) + \
+					 (p) * 0x20 + 0xc)
+
+/* RTC Registers */
+#define XRS_CUR_NSEC0			(XRS_RTC_BASE + 0x1004)
+#define XRS_CUR_NSEC1			(XRS_RTC_BASE + 0x1006)
+#define XRS_CUR_SEC0			(XRS_RTC_BASE + 0x1008)
+#define XRS_CUR_SEC1			(XRS_RTC_BASE + 0x100a)
+#define XRS_CUR_SEC2			(XRS_RTC_BASE + 0x100c)
+#define XRS_TIME_CC0			(XRS_RTC_BASE + 0x1010)
+#define XRS_TIME_CC1			(XRS_RTC_BASE + 0x1012)
+#define XRS_TIME_CC2			(XRS_RTC_BASE + 0x1014)
+#define XRS_STEP_SIZE0			(XRS_RTC_BASE + 0x1020)
+#define XRS_STEP_SIZE1			(XRS_RTC_BASE + 0x1022)
+#define XRS_STEP_SIZE2			(XRS_RTC_BASE + 0x1024)
+#define XRS_ADJUST_NSEC0		(XRS_RTC_BASE + 0x1034)
+#define XRS_ADJUST_NSEC1		(XRS_RTC_BASE + 0x1036)
+#define XRS_ADJUST_SEC0			(XRS_RTC_BASE + 0x1038)
+#define XRS_ADJUST_SEC1			(XRS_RTC_BASE + 0x103a)
+#define XRS_ADJUST_SEC2			(XRS_RTC_BASE + 0x103c)
+#define XRS_TIME_CMD			(XRS_RTC_BASE + 0x1040)
+
+/* Time Stamper Registers */
+#define XRS_TS_CTRL(x)			(XRS_TS_BASE(x) + 0x1000)
+#define XRS_TS_INT_MASK(x)		(XRS_TS_BASE(x) + 0x1008)
+#define XRS_TS_INT_STATUS(x)		(XRS_TS_BASE(x) + 0x1010)
+#define XRS_TS_NSEC0(x)			(XRS_TS_BASE(x) + 0x1104)
+#define XRS_TS_NSEC1(x)			(XRS_TS_BASE(x) + 0x1106)
+#define XRS_TS_SEC0(x)			(XRS_TS_BASE(x) + 0x1108)
+#define XRS_TS_SEC1(x)			(XRS_TS_BASE(x) + 0x110a)
+#define XRS_TS_SEC2(x)			(XRS_TS_BASE(x) + 0x110c)
+#define XRS_PNCT0(x)			(XRS_TS_BASE(x) + 0x1110)
+#define XRS_PNCT1(x)			(XRS_TS_BASE(x) + 0x1112)
+
+/* Switch Configuration Registers */
+#define XRS_SWITCH_GEN_BASE		(XRS_SWITCH_CONF_BASE + 0x0)
+#define XRS_SWITCH_TS_BASE		(XRS_SWITCH_CONF_BASE + 0x2000)
+#define XRS_SWITCH_VLAN_BASE		(XRS_SWITCH_CONF_BASE + 0x4000)
+
+/* Switch Configuration Registers - General */
+#define XRS_GENERAL			(XRS_SWITCH_GEN_BASE + 0x10)
+#define XRS_GENERAL_TIME_TRAILER	BIT(9)
+#define XRS_GENERAL_MOD_SYNC		BIT(10)
+#define XRS_GENERAL_CUT_THRU		BIT(13)
+#define XRS_GENERAL_CLR_MAC_TBL		BIT(14)
+#define XRS_GENERAL_RESET		BIT(15)
+#define XRS_MT_CLEAR_MASK		(XRS_SWITCH_GEN_BASE + 0x12)
+#define XRS_ADDRESS_AGING		(XRS_SWITCH_GEN_BASE + 0x20)
+#define XRS_TS_CTRL_TX			(XRS_SWITCH_GEN_BASE + 0x28)
+#define XRS_TS_CTRL_RX			(XRS_SWITCH_GEN_BASE + 0x2a)
+#define XRS_INT_MASK			(XRS_SWITCH_GEN_BASE + 0x2c)
+#define XRS_INT_STATUS			(XRS_SWITCH_GEN_BASE + 0x2e)
+#define XRS_MAC_TABLE0			(XRS_SWITCH_GEN_BASE + 0x200)
+#define XRS_MAC_TABLE1			(XRS_SWITCH_GEN_BASE + 0x202)
+#define XRS_MAC_TABLE2			(XRS_SWITCH_GEN_BASE + 0x204)
+#define XRS_MAC_TABLE3			(XRS_SWITCH_GEN_BASE + 0x206)
+
+/* Switch Configuration Registers - Frame Timestamp */
+#define XRS_TX_TS_NS_LO(t)		(XRS_SWITCH_TS_BASE + 0x80 * (t) + 0x0)
+#define XRS_TX_TS_NS_HI(t)		(XRS_SWITCH_TS_BASE + 0x80 * (t) + 0x2)
+#define XRS_TX_TS_S_LO(t)		(XRS_SWITCH_TS_BASE + 0x80 * (t) + 0x4)
+#define XRS_TX_TS_S_HI(t)		(XRS_SWITCH_TS_BASE + 0x80 * (t) + 0x6)
+#define XRS_TX_TS_HDR(t, h)		(XRS_SWITCH_TS_BASE + 0x80 * (t) + \
+					 0x2 * (h) + 0xe)
+#define XRS_RX_TS_NS_LO(t)		(XRS_SWITCH_TS_BASE + 0x80 * (t) + \
+					 0x200)
+#define XRS_RX_TS_NS_HI(t)		(XRS_SWITCH_TS_BASE + 0x80 * (t) + \
+					 0x202)
+#define XRS_RX_TS_S_LO(t)		(XRS_SWITCH_TS_BASE + 0x80 * (t) + \
+					 0x204)
+#define XRS_RX_TS_S_HI(t)		(XRS_SWITCH_TS_BASE + 0x80 * (t) + \
+					 0x206)
+#define XRS_RX_TS_HDR(t, h)		(XRS_SWITCH_TS_BASE + 0x80 * (t) + \
+					 0x2 * (h) + 0xe)
+
+/* Switch Configuration Registers - VLAN */
+#define XRS_VLAN(v)			(XRS_SWITCH_VLAN_BASE + 0x2 * (v))
+
+#define MAX_VLAN			4095
-- 
2.11.0

