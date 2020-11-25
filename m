Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C632C488E
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 20:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729608AbgKYTiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 14:38:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729399AbgKYTiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 14:38:19 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11176C0617A7;
        Wed, 25 Nov 2020 11:38:19 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id h3so4083326oie.8;
        Wed, 25 Nov 2020 11:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=o2txbMdosCQBec78rPRzIPxbKVP1PAVWz4ho0D3Nlbs=;
        b=G/cLTyiAnB8A0pTnpmI+ldLc8kw578CU5MICPWZyqE6P6VWb6skDFDky7Pe1moHy8f
         Ih0U3fyRiYYjWfZYmyjPXwi0ap4ZCgd/+FI/t2FjCSU1/o302UU0LbitOVyTyhZKD6/3
         an64aY3feFcDT1SqxX0yESHrfdDiFJvV+V1Qs4epdlBmTV09Uy6ef69gk86HpN6D5TcX
         0Ziq+HNnxjfeVR/gHB9pU6OJVFyeFRz+RalOLepyBo+Z1WnaxNmrQNHrwb8HLOoztzpS
         PXJmuCkRs/Rta9BnkOhWfV7EwY90wnZ8jJCyElo9nmUrjec3W7uNBn2I1oGoO95tyM7b
         Za6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=o2txbMdosCQBec78rPRzIPxbKVP1PAVWz4ho0D3Nlbs=;
        b=n4l7BNY0G4Ao3YeFIwISWaW1B1Ek5XMQbV/6zwlYdeOrMCmURuFrZ04RdirWpXLRjd
         fT+de8ckvj0xY03qtaqH4GE/uFe6FuGmdFuIfstqbmftMdQSvw88p+gzpl1L8SsVL4V+
         BhL6zf0I5Aa851EIlNWpw3HqR//aoRtFGarVxbW3Eo0vJJ7AdxuvqXsDGyLslhOLkTTn
         j3hjixvpoPas7TcFfwN3Y9n283CmeZ+HCdKz9rVRIrQNDrUEA8zNDH3WG+9y1DvUYGDL
         SqdSV+lmjpqdSaIpISbxWVnYDVggxz05EI2hPHxDfQW6uQOXHHFXeTtj6szUJyDUI+HT
         XqNg==
X-Gm-Message-State: AOAM5329RvtZC1a31RLeyjL4Y7FisfW6ppfVgo+vgyc1fAKIh23ZNNiG
        l2Us2KMIMxQsRjyYYB2bq20Vw0EY8t0k
X-Google-Smtp-Source: ABdhPJx2qU74qUcyLm/KqxqjRxKmt9WxDClQukkKRZkPA/s2tbOHHFz0h+dFGQFOQ4o88SBiglqDhQ==
X-Received: by 2002:aca:fc97:: with SMTP id a145mr3287695oii.178.1606333098264;
        Wed, 25 Nov 2020 11:38:18 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id m109sm1655753otc.30.2020.11.25.11.38.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Nov 2020 11:38:17 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller " <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x driver
Date:   Wed, 25 Nov 2020 13:37:39 -0600
Message-Id: <20201125193740.36825-3-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20201125193740.36825-1-george.mccollister@gmail.com>
References: <20201125193740.36825-1-george.mccollister@gmail.com>
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
 drivers/net/dsa/Kconfig                |   2 +
 drivers/net/dsa/Makefile               |   1 +
 drivers/net/dsa/xrs700x/Kconfig        |  26 ++
 drivers/net/dsa/xrs700x/Makefile       |   4 +
 drivers/net/dsa/xrs700x/xrs700x.c      | 585 +++++++++++++++++++++++++++++++++
 drivers/net/dsa/xrs700x/xrs700x.h      |  38 +++
 drivers/net/dsa/xrs700x/xrs700x_i2c.c  | 150 +++++++++
 drivers/net/dsa/xrs700x/xrs700x_mdio.c | 162 +++++++++
 drivers/net/dsa/xrs700x/xrs700x_reg.h  | 205 ++++++++++++
 9 files changed, 1173 insertions(+)
 create mode 100644 drivers/net/dsa/xrs700x/Kconfig
 create mode 100644 drivers/net/dsa/xrs700x/Makefile
 create mode 100644 drivers/net/dsa/xrs700x/xrs700x.c
 create mode 100644 drivers/net/dsa/xrs700x/xrs700x.h
 create mode 100644 drivers/net/dsa/xrs700x/xrs700x_i2c.c
 create mode 100644 drivers/net/dsa/xrs700x/xrs700x_mdio.c
 create mode 100644 drivers/net/dsa/xrs700x/xrs700x_reg.h

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index f6a0488589fc..3af373e90806 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -60,6 +60,8 @@ source "drivers/net/dsa/qca/Kconfig"
 
 source "drivers/net/dsa/sja1105/Kconfig"
 
+source "drivers/net/dsa/xrs700x/Kconfig"
+
 config NET_DSA_QCA8K
 	tristate "Qualcomm Atheros QCA8K Ethernet switch family support"
 	depends on NET_DSA
diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
index a84adb140a04..f3598c040994 100644
--- a/drivers/net/dsa/Makefile
+++ b/drivers/net/dsa/Makefile
@@ -24,3 +24,4 @@ obj-y				+= mv88e6xxx/
 obj-y				+= ocelot/
 obj-y				+= qca/
 obj-y				+= sja1105/
+obj-y				+= xrs700x/
diff --git a/drivers/net/dsa/xrs700x/Kconfig b/drivers/net/dsa/xrs700x/Kconfig
new file mode 100644
index 000000000000..d10a4dce1676
--- /dev/null
+++ b/drivers/net/dsa/xrs700x/Kconfig
@@ -0,0 +1,26 @@
+# SPDX-License-Identifier: GPL-2.0-only
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
diff --git a/drivers/net/dsa/xrs700x/Makefile b/drivers/net/dsa/xrs700x/Makefile
new file mode 100644
index 000000000000..51a3a7d9296a
--- /dev/null
+++ b/drivers/net/dsa/xrs700x/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_NET_DSA_XRS700X) += xrs700x.o
+obj-$(CONFIG_NET_DSA_XRS700X_I2C) += xrs700x_i2c.o
+obj-$(CONFIG_NET_DSA_XRS700X_MDIO) += xrs700x_mdio.o
diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
new file mode 100644
index 000000000000..f3abdb0eeeec
--- /dev/null
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -0,0 +1,585 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020 NovaTech LLC
+ * George McCollister <george.mccollister@gmail.com>
+ */
+
+#include <net/dsa.h>
+#include <linux/if_bridge.h>
+#include <linux/of_device.h>
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
+const struct xrs700x_info xrs7003e_info = {XRS7003E_ID, "XRS7003E", 3};
+const struct xrs700x_info xrs7003f_info = {XRS7003F_ID, "XRS7003F", 3};
+const struct xrs700x_info xrs7004e_info = {XRS7004E_ID, "XRS7004E", 4};
+const struct xrs700x_info xrs7004f_info = {XRS7004F_ID, "XRS7004F", 4};
+
+struct xrs700x_regfield {
+	struct reg_field rf;
+	struct regmap_field **rmf;
+};
+
+struct xrs700x_mib {
+	unsigned int offset;
+	const char *name;
+};
+
+static const struct xrs700x_mib xrs700x_mibs[] = {
+	{XRS_RX_GOOD_OCTETS_L, "rx_good_octets"},
+	{XRS_RX_BAD_OCTETS_L, "rx_bad_octets"},
+	{XRS_RX_UNICAST_L, "rx_unicast"},
+	{XRS_RX_BROADCAST_L, "rx_broadcast"},
+	{XRS_RX_MULTICAST_L, "rx_multicast"},
+	{XRS_RX_UNDERSIZE_L, "rx_undersize"},
+	{XRS_RX_FRAGMENTS_L, "rx_fragments"},
+	{XRS_RX_OVERSIZE_L, "rx_oversize"},
+	{XRS_RX_JABBER_L, "rx_jabber"},
+	{XRS_RX_ERR_L, "rx_err"},
+	{XRS_RX_CRC_L, "rx_crc"},
+	{XRS_RX_64_L, "rx_64"},
+	{XRS_RX_65_127_L, "rx_65_127"},
+	{XRS_RX_128_255_L, "rx_128_255"},
+	{XRS_RX_256_511_L, "rx_256_511"},
+	{XRS_RX_512_1023_L, "rx_512_1023"},
+	{XRS_RX_1024_1536_L, "rx_1024_1536"},
+	{XRS_RX_HSR_PRP_L, "rx_hsr_prp"},
+	{XRS_RX_WRONGLAN_L, "rx_wronglan"},
+	{XRS_RX_DUPLICATE_L, "rx_duplicate"},
+	{XRS_TX_OCTETS_L, "tx_octets"},
+	{XRS_TX_UNICAST_L, "tx_unicast"},
+	{XRS_TX_BROADCAST_L, "tx_broadcast"},
+	{XRS_TX_MULTICAST_L, "tx_multicast"},
+	{XRS_TX_HSR_PRP_L, "tx_hsr_prp"},
+	{XRS_PRIQ_DROP_L, "priq_drop"},
+	{XRS_EARLY_DROP_L, "early_drop"},
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
+	struct xrs700x_port *p = &priv->ports[port];
+	int i;
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
+	struct xrs700x_regfield regfields[] = {
+		{
+			.rf = REG_FIELD_ID(XRS_PORT_STATE(0), 0, 1,
+					   priv->ds->num_ports,
+					   XRS_PORT_OFFSET),
+			.rmf = &priv->ps_forward
+		},
+		{
+			.rf = REG_FIELD_ID(XRS_PORT_STATE(0), 2, 3,
+					   priv->ds->num_ports,
+					   XRS_PORT_OFFSET),
+			.rmf = &priv->ps_management
+		},
+		{
+			.rf = REG_FIELD_ID(XRS_PORT_STATE(0), 4, 9,
+					   priv->ds->num_ports,
+					   XRS_PORT_OFFSET),
+			.rmf = &priv->ps_sel_speed
+		},
+		{
+			.rf = REG_FIELD_ID(XRS_PORT_STATE(0), 10, 11,
+					   priv->ds->num_ports,
+					   XRS_PORT_OFFSET),
+			.rmf = &priv->ps_cur_speed
+		}
+	};
+	int i = 0;
+
+	for (; i < ARRAY_SIZE(regfields); i++) {
+		*regfields[i].rmf = devm_regmap_field_alloc(priv->dev,
+							    priv->regmap,
+							    regfields[i].rf);
+		if (IS_ERR(*regfields[i].rmf))
+			return PTR_ERR(*regfields[i].rmf);
+	}
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
+	unsigned int val;
+	int ret;
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
+	unsigned int bpdus = 1;
+	unsigned int val;
+
+	switch (state) {
+	case BR_STATE_DISABLED:
+		bpdus = 0;
+		fallthrough;
+	case BR_STATE_BLOCKING:
+	case BR_STATE_LISTENING:
+		val = XRS_PORT_DISABLED;
+		break;
+	case BR_STATE_LEARNING:
+		val = XRS_PORT_LEARNING;
+		break;
+	case BR_STATE_FORWARDING:
+		val = XRS_PORT_FORWARDING;
+		break;
+	default:
+		dev_err(ds->dev, "invalid STP state: %d\n", state);
+		return;
+	}
+
+	regmap_fields_write(priv->ps_forward, port, val);
+
+	/* Enable/disable inbound policy added by xrs700x_port_add_bpdu_ipf()
+	 * which allows BPDU forwarding to the CPU port when the front facing
+	 * port is in disabled/learning state.
+	 */
+	regmap_update_bits(priv->regmap, XRS_ETH_ADDR_CFG(port, 0), 1, bpdus);
+
+	dev_dbg_ratelimited(priv->dev, "%s - port: %d, state: %u, val: 0x%x\n",
+			    __func__, port, state, val);
+}
+
+/* Add an inbound policy filter which matches the BPDU destination MAC
+ * and forwards to the CPU port. Leave the policy disabled, it will be
+ * enabled as needed.
+ */
+static int xrs700x_port_add_bpdu_ipf(struct dsa_switch *ds, int port)
+{
+	struct xrs700x *priv = ds->priv;
+	unsigned int val = 0;
+	int i = 0;
+	int ret;
+
+	/* Compare all 48 bits of the destination MAC address. */
+	ret = regmap_write(priv->regmap, XRS_ETH_ADDR_CFG(port, 0), 48 << 2);
+	if (ret)
+		return ret;
+
+	/* match BPDU destination 01:80:c2:00:00:00 */
+	ret = regmap_write(priv->regmap, XRS_ETH_ADDR_0(port, 0), 0x8001);
+	if (ret)
+		return ret;
+
+	ret = regmap_write(priv->regmap, XRS_ETH_ADDR_1(port, 0), 0xc2);
+	if (ret)
+		return ret;
+
+	ret = regmap_write(priv->regmap, XRS_ETH_ADDR_2(port, 0), 0x0);
+	if (ret)
+		return ret;
+
+	/* Mirror BPDU to CPU port */
+	for (; i < ds->num_ports; i++) {
+		if (dsa_is_cpu_port(ds, i))
+			val |= BIT(i);
+	}
+
+	ret = regmap_write(priv->regmap, XRS_ETH_ADDR_FWD_MIRROR(port, 0), val);
+	if (ret)
+		return ret;
+
+	ret = regmap_write(priv->regmap, XRS_ETH_ADDR_FWD_ALLOW(port, 0), 0);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int xrs700x_port_setup(struct dsa_switch *ds, int port)
+{
+	bool cpu_port = dsa_is_cpu_port(ds, port);
+	struct xrs700x *priv = ds->priv;
+	unsigned int val = 0;
+	int ret, i;
+
+	xrs700x_port_stp_state_set(ds, port, BR_STATE_DISABLED);
+
+	/* Disable forwarding to non-CPU ports */
+	for (i = 0; i < ds->num_ports; i++) {
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
+	if (!cpu_port) {
+		ret = xrs700x_port_add_bpdu_ipf(ds, port);
+		if (ret)
+			return ret;
+	}
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
+static void xrs700x_teardown(struct dsa_switch *ds)
+{
+	struct xrs700x *priv = ds->priv;
+
+	cancel_delayed_work_sync(&priv->mib_work);
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
+static void xrs700x_mac_link_up(struct dsa_switch *ds, int port,
+				unsigned int mode, phy_interface_t interface,
+				struct phy_device *phydev,
+				int speed, int duplex,
+				bool tx_pause, bool rx_pause)
+{
+	struct xrs700x *priv = ds->priv;
+	unsigned int val;
+
+	switch (speed) {
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
+			    __func__, port, mode, speed);
+}
+
+static int xrs700x_bridge_common(struct dsa_switch *ds, int port,
+				 struct net_device *bridge, bool join)
+{
+	unsigned int i, ret, cpu_mask = 0, mask = 0;
+	struct xrs700x *priv = ds->priv;
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
+	for (i = 0; i < ds->num_ports; i++) {
+		if (dsa_to_port(ds, i)->bridge_dev != bridge)
+			continue;
+
+		ret = regmap_write(priv->regmap, XRS_PORT_FWD_MASK(i), mask);
+		if (ret)
+			return ret;
+	}
+
+	if (!join) {
+		ret = regmap_write(priv->regmap, XRS_PORT_FWD_MASK(port),
+				   cpu_mask);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int xrs700x_bridge_join(struct dsa_switch *ds, int port,
+			       struct net_device *bridge)
+{
+	return xrs700x_bridge_common(ds, port, bridge, true);
+}
+
+static void xrs700x_bridge_leave(struct dsa_switch *ds, int port,
+				 struct net_device *bridge)
+{
+	xrs700x_bridge_common(ds, port, bridge, false);
+}
+
+static const struct dsa_switch_ops xrs700x_ops = {
+	.get_tag_protocol	= xrs700x_get_tag_protocol,
+	.setup			= xrs700x_setup,
+	.teardown		= xrs700x_teardown,
+	.port_stp_state_set	= xrs700x_port_stp_state_set,
+	.phylink_validate	= xrs700x_phylink_validate,
+	.phylink_mac_link_up	= xrs700x_mac_link_up,
+	.get_strings		= xrs700x_get_strings,
+	.get_sset_count		= xrs700x_get_sset_count,
+	.get_ethtool_stats	= xrs700x_get_ethtool_stats,
+	.port_bridge_join	= xrs700x_bridge_join,
+	.port_bridge_leave	= xrs700x_bridge_leave,
+};
+
+static int xrs700x_detect(struct xrs700x *dev)
+{
+	const struct xrs700x_info *info;
+	unsigned int id;
+	int ret;
+
+	ret = regmap_read(dev->regmap, XRS_DEV_ID0, &id);
+	if (ret) {
+		dev_err(dev->dev, "error %d while reading switch id.\n",
+			ret);
+		return ret;
+	}
+
+	info = of_device_get_match_data(dev->dev);
+	if (!info)
+		return -EINVAL;
+
+	if (info->id == id) {
+		dev->ds->num_ports = info->num_ports;
+		dev_info(dev->dev, "%s detected.\n", info->name);
+		return 0;
+	}
+
+	dev_err(dev->dev, "expected switch id 0x%x but found 0x%x.\n",
+		info->id, id);
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
diff --git a/drivers/net/dsa/xrs700x/xrs700x.h b/drivers/net/dsa/xrs700x/xrs700x.h
new file mode 100644
index 000000000000..1f28b0ecebe0
--- /dev/null
+++ b/drivers/net/dsa/xrs700x/xrs700x.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/device.h>
+#include <linux/mutex.h>
+#include <linux/regmap.h>
+#include <linux/workqueue.h>
+
+struct xrs700x_info {
+	unsigned int id;
+	const char *name;
+	size_t num_ports;
+};
+
+extern const struct xrs700x_info xrs7003e_info;
+extern const struct xrs700x_info xrs7003f_info;
+extern const struct xrs700x_info xrs7004e_info;
+extern const struct xrs700x_info xrs7004f_info;
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
diff --git a/drivers/net/dsa/xrs700x/xrs700x_i2c.c b/drivers/net/dsa/xrs700x/xrs700x_i2c.c
new file mode 100644
index 000000000000..fe64a7757f9e
--- /dev/null
+++ b/drivers/net/dsa/xrs700x/xrs700x_i2c.c
@@ -0,0 +1,150 @@
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
+	struct device *dev = context;
+	struct i2c_client *i2c = to_i2c_client(dev);
+	unsigned char buf[4];
+	int ret;
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
+	struct device *dev = context;
+	struct i2c_client *i2c = to_i2c_client(dev);
+	unsigned char buf[6];
+	int ret;
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
+	{ .compatible = "arrow,xrs7003e", .data = &xrs7003e_info },
+	{ .compatible = "arrow,xrs7003f", .data = &xrs7003f_info },
+	{ .compatible = "arrow,xrs7004e", .data = &xrs7004e_info },
+	{ .compatible = "arrow,xrs7004f", .data = &xrs7004f_info },
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
diff --git a/drivers/net/dsa/xrs700x/xrs700x_mdio.c b/drivers/net/dsa/xrs700x/xrs700x_mdio.c
new file mode 100644
index 000000000000..4fa6cc8f871c
--- /dev/null
+++ b/drivers/net/dsa/xrs700x/xrs700x_mdio.c
@@ -0,0 +1,162 @@
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
+	struct mdio_device *mdiodev = context;
+	struct device *dev = &mdiodev->dev;
+	u16 uval;
+	int ret;
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
+	struct mdio_device *mdiodev = context;
+	struct device *dev = &mdiodev->dev;
+	u16 uval;
+	int ret;
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
+	{ .compatible = "arrow,xrs7003e", .data = &xrs7003e_info },
+	{ .compatible = "arrow,xrs7003f", .data = &xrs7003f_info },
+	{ .compatible = "arrow,xrs7004e", .data = &xrs7004e_info },
+	{ .compatible = "arrow,xrs7004f", .data = &xrs7004f_info },
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
diff --git a/drivers/net/dsa/xrs700x/xrs700x_reg.h b/drivers/net/dsa/xrs700x/xrs700x_reg.h
new file mode 100644
index 000000000000..d162d0b84bac
--- /dev/null
+++ b/drivers/net/dsa/xrs700x/xrs700x_reg.h
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
+#define XRS_RX_GOOD_OCTETS_L		(XRS_PORT_CNT_BASE(0) + 0x200)
+#define XRS_RX_GOOD_OCTETS_H		(XRS_PORT_CNT_BASE(0) + 0x202)
+#define XRS_RX_BAD_OCTETS_L		(XRS_PORT_CNT_BASE(0) + 0x204)
+#define XRS_RX_BAD_OCTETS_H		(XRS_PORT_CNT_BASE(0) + 0x206)
+#define XRS_RX_UNICAST_L		(XRS_PORT_CNT_BASE(0) + 0x208)
+#define XRS_RX_UNICAST_H		(XRS_PORT_CNT_BASE(0) + 0x20a)
+#define XRS_RX_BROADCAST_L		(XRS_PORT_CNT_BASE(0) + 0x20c)
+#define XRS_RX_BROADCAST_H		(XRS_PORT_CNT_BASE(0) + 0x20e)
+#define XRS_RX_MULTICAST_L		(XRS_PORT_CNT_BASE(0) + 0x210)
+#define XRS_RX_MULTICAST_H		(XRS_PORT_CNT_BASE(0) + 0x212)
+#define XRS_RX_UNDERSIZE_L		(XRS_PORT_CNT_BASE(0) + 0x214)
+#define XRS_RX_UNDERSIZE_H		(XRS_PORT_CNT_BASE(0) + 0x216)
+#define XRS_RX_FRAGMENTS_L		(XRS_PORT_CNT_BASE(0) + 0x218)
+#define XRS_RX_FRAGMENTS_H		(XRS_PORT_CNT_BASE(0) + 0x21a)
+#define XRS_RX_OVERSIZE_L		(XRS_PORT_CNT_BASE(0) + 0x21c)
+#define XRS_RX_OVERSIZE_H		(XRS_PORT_CNT_BASE(0) + 0x21e)
+#define XRS_RX_JABBER_L			(XRS_PORT_CNT_BASE(0) + 0x220)
+#define XRS_RX_JABBER_H			(XRS_PORT_CNT_BASE(0) + 0x222)
+#define XRS_RX_ERR_L			(XRS_PORT_CNT_BASE(0) + 0x224)
+#define XRS_RX_ERR_H			(XRS_PORT_CNT_BASE(0) + 0x226)
+#define XRS_RX_CRC_L			(XRS_PORT_CNT_BASE(0) + 0x228)
+#define XRS_RX_CRC_H			(XRS_PORT_CNT_BASE(0) + 0x22a)
+#define XRS_RX_64_L			(XRS_PORT_CNT_BASE(0) + 0x22c)
+#define XRS_RX_64_H			(XRS_PORT_CNT_BASE(0) + 0x22e)
+#define XRS_RX_65_127_L			(XRS_PORT_CNT_BASE(0) + 0x230)
+#define XRS_RX_65_127_H			(XRS_PORT_CNT_BASE(0) + 0x232)
+#define XRS_RX_128_255_L		(XRS_PORT_CNT_BASE(0) + 0x234)
+#define XRS_RX_128_255_H		(XRS_PORT_CNT_BASE(0) + 0x236)
+#define XRS_RX_256_511_L		(XRS_PORT_CNT_BASE(0) + 0x238)
+#define XRS_RX_256_511_H		(XRS_PORT_CNT_BASE(0) + 0x23a)
+#define XRS_RX_512_1023_L		(XRS_PORT_CNT_BASE(0) + 0x23c)
+#define XRS_RX_512_1023_H		(XRS_PORT_CNT_BASE(0) + 0x23e)
+#define XRS_RX_1024_1536_L		(XRS_PORT_CNT_BASE(0) + 0x240)
+#define XRS_RX_1024_1536_H		(XRS_PORT_CNT_BASE(0) + 0x242)
+#define XRS_RX_HSR_PRP_L		(XRS_PORT_CNT_BASE(0) + 0x244)
+#define XRS_RX_HSR_PRP_H		(XRS_PORT_CNT_BASE(0) + 0x246)
+#define XRS_RX_WRONGLAN_L		(XRS_PORT_CNT_BASE(0) + 0x248)
+#define XRS_RX_WRONGLAN_H		(XRS_PORT_CNT_BASE(0) + 0x24a)
+#define XRS_RX_DUPLICATE_L		(XRS_PORT_CNT_BASE(0) + 0x24c)
+#define XRS_RX_DUPLICATE_H		(XRS_PORT_CNT_BASE(0) + 0x24e)
+#define XRS_TX_OCTETS_L			(XRS_PORT_CNT_BASE(0) + 0x280)
+#define XRS_TX_OCTETS_H			(XRS_PORT_CNT_BASE(0) + 0x282)
+#define XRS_TX_UNICAST_L		(XRS_PORT_CNT_BASE(0) + 0x284)
+#define XRS_TX_UNICAST_H		(XRS_PORT_CNT_BASE(0) + 0x286)
+#define XRS_TX_BROADCAST_L		(XRS_PORT_CNT_BASE(0) + 0x288)
+#define XRS_TX_BROADCAST_H		(XRS_PORT_CNT_BASE(0) + 0x28a)
+#define XRS_TX_MULTICAST_L		(XRS_PORT_CNT_BASE(0) + 0x28c)
+#define XRS_TX_MULTICAST_H		(XRS_PORT_CNT_BASE(0) + 0x28e)
+#define XRS_TX_HSR_PRP_L		(XRS_PORT_CNT_BASE(0) + 0x290)
+#define XRS_TX_HSR_PRP_H		(XRS_PORT_CNT_BASE(0) + 0x292)
+#define XRS_PRIQ_DROP_L			(XRS_PORT_CNT_BASE(0) + 0x2c0)
+#define XRS_PRIQ_DROP_H			(XRS_PORT_CNT_BASE(0) + 0x2c2)
+#define XRS_EARLY_DROP_L		(XRS_PORT_CNT_BASE(0) + 0x2c4)
+#define XRS_EARLY_DROP_H		(XRS_PORT_CNT_BASE(0) + 0x2c6)
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

