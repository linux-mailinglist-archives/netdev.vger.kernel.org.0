Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F3B3152B7
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 16:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbhBIPYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 10:24:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232528AbhBIPVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 10:21:22 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D27C061356;
        Tue,  9 Feb 2021 07:20:12 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id z22so24155219edb.9;
        Tue, 09 Feb 2021 07:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aU0GjvrqFFp0zdkheu1bwOsSgZ44lidrzO2B+rFC2wE=;
        b=Wd+uP8/uLZXTv1+RAajYNA8oGtz/Em7q6LdYBSUFcZ9QO0TDXytjaJbpnYSTUm5Kfj
         viQUmf7obWz39nDIthN7PofDzxvL9aApieTQGA/Van9frbyoqHnk/PaikNfc9cv7MDDU
         +P6XkoFJ6sswldjK32PiWl0d4wUZKkqXoAltbvWWCZt0Eqt7utmnVeLTvI4SZMUKU3Ft
         VUMFS5cZjjz1h8BhDWzGrXXw0oRwzMMfRXtY1aGAIaGlLN4XRb12ukhU6eYt73L9YlxJ
         tYK5cvomaAKp4tURmH0TBH2bLGhvTs6DQ0bznzuCrDAB7O/YYulpdVVN+Kmu9zMXqLy1
         1rxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aU0GjvrqFFp0zdkheu1bwOsSgZ44lidrzO2B+rFC2wE=;
        b=QqfcFwFV332ds1pE38zyEX2J3uA37F5zzSVCmIPzNr1exrxP+oL92UH9A1bJUOWJi6
         dC0HkFRLD/Hwaoj/kirSJK00dBr8h3KGlOQ7R23P2OZhPkPZufijY7zQdS3Eq4iPJ5fX
         nvUWJgUz0jjOA8Vzickyf4CFUN7/QEGkeTofOSoSzDPRPhGThlBJmAHCYSAn6zlvjJ4N
         fO25OARsLxQG//+f4DUkVwq0LhrLyFpB0eCNUW7flcuCsLVeWJPFpwPSOdL/GNlxKuBj
         H6z+y/AgjRn3AYmXBGgI4qsWSbow0JHvE+9pCn0/mZqeO1RXHbEi4GiH6sVrPm0BJCVl
         Py7w==
X-Gm-Message-State: AOAM530s4SVnlZRlVOIjwm506Q7j6ZXYCyoOweQN7Ayx7ckXHnY6yuJm
        /BY6bH0o6O5JiDl8OabqLLo=
X-Google-Smtp-Source: ABdhPJx0ZzXZs+kfEDCAxySbDqdATwwF54tdh01diREQzUuEhR2l53D/4tQVGq/8zyD5ekfdqw63zg==
X-Received: by 2002:aa7:d2c7:: with SMTP id k7mr16363001edr.374.1612884010850;
        Tue, 09 Feb 2021 07:20:10 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id q2sm11686108edv.93.2021.02.09.07.20.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 07:20:09 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: [PATCH v2 net-next 11/11] net: dsa: sja1105: offload bridge port flags to device
Date:   Tue,  9 Feb 2021 17:19:36 +0200
Message-Id: <20210209151936.97382-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210209151936.97382-1-olteanv@gmail.com>
References: <20210209151936.97382-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The chip can configure unicast flooding, broadcast flooding and learning.
Learning is per port, while flooding is per {ingress, egress} port pair
and we need to configure the same value for all possible ingress ports
towards the requested one.

While multicast flooding is not officially supported, we can hack it by
using a feature of the second generation (P/Q/R/S) devices, which is that
FDB entries are maskable, and multicast addresses always have an odd
first octet. So by putting a match-all for 00:01:00:00:00:00 addr and
00:01:00:00:00:00 mask at the end of the FDB, we make sure that it is
always checked last, and does not take precedence in front of any other
MDB. So it behaves effectively as an unknown multicast entry.

For the first generation switches, this feature is not available, so
unknown multicast will always be treated the same as unknown unicast.
So the only thing we can do is request the user to offload the settings
for these 2 flags in tandem, i.e.

ip link set swp2 type bridge_slave flood off
Error: sja1105: This chip cannot configure multicast flooding independently of unicast.
ip link set swp2 type bridge_slave flood off mcast_flood off
ip link set swp2 type bridge_slave mcast_flood on
Error: sja1105: This chip cannot configure multicast flooding independently of unicast.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Patch is new.

 drivers/net/dsa/sja1105/sja1105.h      |   2 +
 drivers/net/dsa/sja1105/sja1105_main.c | 212 +++++++++++++++++++++++--
 drivers/net/dsa/sja1105/sja1105_spi.c  |   6 +
 3 files changed, 209 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index d582308c2401..15a0893d0ff1 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -94,6 +94,7 @@ struct sja1105_info {
 	 * pop it when it's equal to TPID2.
 	 */
 	u16 qinq_tpid;
+	bool can_limit_mcast_flood;
 	int (*reset_cmd)(struct dsa_switch *ds);
 	int (*setup_rgmii_delay)(const void *ctx, int port);
 	/* Prototypes from include/net/dsa.h */
@@ -204,6 +205,7 @@ struct sja1105_private {
 	bool rgmii_rx_delay[SJA1105_NUM_PORTS];
 	bool rgmii_tx_delay[SJA1105_NUM_PORTS];
 	bool best_effort_vlan_filtering;
+	unsigned long learn_ena;
 	const struct sja1105_info *info;
 	struct gpio_desc *reset_gpio;
 	struct spi_device *spidev;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 282253543f3b..8373cc1f5df1 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -25,6 +25,8 @@
 #include "sja1105_sgmii.h"
 #include "sja1105_tas.h"
 
+#define SJA1105_UNKNOWN_MULTICAST	0x010000000000ull
+
 static const struct dsa_switch_ops sja1105_switch_ops;
 
 static void sja1105_hw_reset(struct gpio_desc *gpio, unsigned int pulse_len,
@@ -42,15 +44,10 @@ static void
 sja1105_port_allow_traffic(struct sja1105_l2_forwarding_entry *l2_fwd,
 			   int from, int to, bool allow)
 {
-	if (allow) {
-		l2_fwd[from].bc_domain  |= BIT(to);
+	if (allow)
 		l2_fwd[from].reach_port |= BIT(to);
-		l2_fwd[from].fl_domain  |= BIT(to);
-	} else {
-		l2_fwd[from].bc_domain  &= ~BIT(to);
+	else
 		l2_fwd[from].reach_port &= ~BIT(to);
-		l2_fwd[from].fl_domain  &= ~BIT(to);
-	}
 }
 
 /* Structure used to temporarily transport device tree
@@ -220,17 +217,43 @@ static int sja1105_init_mii_settings(struct sja1105_private *priv,
 
 static int sja1105_init_static_fdb(struct sja1105_private *priv)
 {
+	struct sja1105_l2_lookup_entry *l2_lookup;
 	struct sja1105_table *table;
+	int port;
 
 	table = &priv->static_config.tables[BLK_IDX_L2_LOOKUP];
 
-	/* We only populate the FDB table through dynamic
-	 * L2 Address Lookup entries
+	/* We only populate the FDB table through dynamic L2 Address Lookup
+	 * entries, except for a special entry at the end which is a catch-all
+	 * for unknown multicast and will be used to control flooding domain.
 	 */
 	if (table->entry_count) {
 		kfree(table->entries);
 		table->entry_count = 0;
 	}
+
+	if (!priv->info->can_limit_mcast_flood)
+		return 0;
+
+	table->entries = kcalloc(1, table->ops->unpacked_entry_size,
+				 GFP_KERNEL);
+	if (!table->entries)
+		return -ENOMEM;
+
+	table->entry_count = 1;
+	l2_lookup = table->entries;
+
+	/* All L2 multicast addresses have an odd first octet */
+	l2_lookup[0].macaddr = SJA1105_UNKNOWN_MULTICAST;
+	l2_lookup[0].mask_macaddr = SJA1105_UNKNOWN_MULTICAST;
+	l2_lookup[0].lockeds = true;
+	l2_lookup[0].index = SJA1105_MAX_L2_LOOKUP_COUNT - 1;
+
+	/* Flood multicast to every port by default */
+	for (port = 0; port < priv->ds->num_ports; port++)
+		if (!dsa_is_unused_port(priv->ds, port))
+			l2_lookup[0].destports |= BIT(port);
+
 	return 0;
 }
 
@@ -390,6 +413,12 @@ static int sja1105_init_l2_forwarding(struct sja1105_private *priv)
 
 		sja1105_port_allow_traffic(l2fwd, i, upstream, true);
 		sja1105_port_allow_traffic(l2fwd, upstream, i, true);
+
+		l2fwd[i].bc_domain = BIT(upstream);
+		l2fwd[i].fl_domain = BIT(upstream);
+
+		l2fwd[upstream].bc_domain |= BIT(i);
+		l2fwd[upstream].fl_domain |= BIT(i);
 	}
 	/* Next 8 entries define VLAN PCP mapping from ingress to egress.
 	 * Create a one-to-one mapping.
@@ -1514,6 +1543,12 @@ static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 		 */
 		if (!(l2_lookup.destports & BIT(port)))
 			continue;
+
+		/* We need to hide the FDB entry for unknown multicast */
+		if (l2_lookup.macaddr == SJA1105_UNKNOWN_MULTICAST &&
+		    l2_lookup.mask_macaddr == SJA1105_UNKNOWN_MULTICAST)
+			continue;
+
 		u64_to_ether_addr(l2_lookup.macaddr, macaddr);
 
 		/* We need to hide the dsa_8021q VLANs from the user. */
@@ -1605,12 +1640,12 @@ static void sja1105_bridge_stp_state_set(struct dsa_switch *ds, int port,
 	case BR_STATE_LEARNING:
 		mac[port].ingress   = true;
 		mac[port].egress    = false;
-		mac[port].dyn_learn = true;
+		mac[port].dyn_learn = !!(priv->learn_ena & BIT(port));
 		break;
 	case BR_STATE_FORWARDING:
 		mac[port].ingress   = true;
 		mac[port].egress    = true;
-		mac[port].dyn_learn = true;
+		mac[port].dyn_learn = !!(priv->learn_ena & BIT(port));
 		break;
 	default:
 		dev_err(ds->dev, "invalid STP state: %d\n", state);
@@ -3239,6 +3274,160 @@ static void sja1105_port_policer_del(struct dsa_switch *ds, int port)
 	sja1105_static_config_reload(priv, SJA1105_BEST_EFFORT_POLICING);
 }
 
+static int sja1105_port_set_learning(struct sja1105_private *priv, int port,
+				     bool enabled)
+{
+	struct sja1105_mac_config_entry *mac;
+	int rc;
+
+	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
+
+	mac[port].dyn_learn = !!(priv->learn_ena & BIT(port));
+
+	rc = sja1105_dynamic_config_write(priv, BLK_IDX_MAC_CONFIG, port,
+					  &mac[port], true);
+	if (rc)
+		return rc;
+
+	if (enabled)
+		priv->learn_ena |= BIT(port);
+	else
+		priv->learn_ena &= ~BIT(port);
+
+	return 0;
+}
+
+/* Common function for unicast and broadcast flood configuration.
+ * Flooding is configured between each {ingress, egress} port pair, and since
+ * the bridge's semantics are those of "egress flooding", it means we must
+ * enable flooding towards this port from all ingress ports that are in the
+ * same bridge. In practice, we just enable flooding from all possible ingress
+ * ports regardless of whether they're in the same bridge or not, since the
+ * reach_port configuration will not allow flooded frames to leak across
+ * bridging domains anyway.
+ */
+static int sja1105_port_ucast_bcast_flood(struct sja1105_private *priv, int to,
+					  struct switchdev_brport_flags flags)
+{
+	struct sja1105_l2_forwarding_entry *l2_fwd;
+	int from, rc;
+
+	l2_fwd = priv->static_config.tables[BLK_IDX_L2_FORWARDING].entries;
+
+	for (from = 0; from < priv->ds->num_ports; from++) {
+		if (dsa_is_unused_port(priv->ds, from))
+			continue;
+		if (from == to)
+			continue;
+
+		/* Unicast */
+		if (flags.mask & BR_FLOOD) {
+			if (flags.val & BR_FLOOD)
+				l2_fwd[from].fl_domain |= BIT(to);
+			else
+				l2_fwd[from].fl_domain &= ~BIT(to);
+		}
+		/* Broadcast */
+		if (flags.mask & BR_BCAST_FLOOD) {
+			if (flags.val & BR_BCAST_FLOOD)
+				l2_fwd[from].bc_domain |= BIT(to);
+			else
+				l2_fwd[from].bc_domain &= ~BIT(to);
+		}
+
+		rc = sja1105_dynamic_config_write(priv, BLK_IDX_L2_FORWARDING,
+						  from, &l2_fwd[from], true);
+		if (rc < 0)
+			return rc;
+	}
+
+	return 0;
+}
+
+static int sja1105_port_mcast_flood(struct sja1105_private *priv, int to,
+				    struct switchdev_brport_flags flags,
+				    struct netlink_ext_ack *extack)
+{
+	struct sja1105_l2_lookup_entry *l2_lookup;
+	struct sja1105_table *table;
+	int match;
+
+	table = &priv->static_config.tables[BLK_IDX_L2_LOOKUP];
+	l2_lookup = table->entries;
+
+	for (match = 0; match < table->entry_count; match++)
+		if (l2_lookup[match].macaddr == SJA1105_UNKNOWN_MULTICAST &&
+		    l2_lookup[match].mask_macaddr == SJA1105_UNKNOWN_MULTICAST)
+			break;
+
+	if (match == table->entry_count) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Could not find FDB entry for unknown multicast");
+		return -ENOSPC;
+	}
+
+	if (flags.val & BR_MCAST_FLOOD)
+		l2_lookup[match].destports |= BIT(to);
+	else
+		l2_lookup[match].destports &= ~BIT(to);
+
+	return sja1105_dynamic_config_write(priv, BLK_IDX_L2_LOOKUP,
+					    l2_lookup[match].index,
+					    &l2_lookup[match],
+					    true);
+}
+
+static int sja1105_port_bridge_flags(struct dsa_switch *ds, int port,
+				     struct switchdev_brport_flags flags,
+				     struct netlink_ext_ack *extack)
+{
+	struct sja1105_private *priv = ds->priv;
+	int rc;
+
+	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
+			   BR_BCAST_FLOOD))
+		return -EINVAL;
+
+	if (flags.mask & BR_LEARNING) {
+		bool learn_ena = !!(flags.val & BR_LEARNING);
+
+		rc = sja1105_port_set_learning(priv, port, learn_ena);
+		if (rc)
+			return rc;
+	}
+
+	if (flags.mask & (BR_FLOOD | BR_BCAST_FLOOD)) {
+		rc = sja1105_port_ucast_bcast_flood(priv, port, flags);
+		if (rc)
+			return rc;
+	}
+
+	if (flags.mask & (BR_FLOOD | BR_MCAST_FLOOD) &&
+	    !priv->info->can_limit_mcast_flood) {
+		bool multicast = !!(flags.val & BR_MCAST_FLOOD);
+		bool unicast = !!(flags.val & BR_FLOOD);
+
+		if (unicast != multicast) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "This chip cannot configure multicast flooding independently of unicast");
+			return -EINVAL;
+		}
+	}
+
+	/* For chips that can't offload BR_MCAST_FLOOD independently, there
+	 * is nothing to do here, we ensured the configuration is in sync by
+	 * offloading BR_FLOOD.
+	 */
+	if (flags.mask & BR_MCAST_FLOOD && priv->info->can_limit_mcast_flood) {
+		rc = sja1105_port_mcast_flood(priv, port, flags,
+					      extack);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
 static const struct dsa_switch_ops sja1105_switch_ops = {
 	.get_tag_protocol	= sja1105_get_tag_protocol,
 	.setup			= sja1105_setup,
@@ -3262,6 +3451,7 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_fdb_del		= sja1105_fdb_del,
 	.port_bridge_join	= sja1105_bridge_join,
 	.port_bridge_leave	= sja1105_bridge_leave,
+	.port_bridge_flags	= sja1105_port_bridge_flags,
 	.port_stp_state_set	= sja1105_bridge_stp_state_set,
 	.port_vlan_filtering	= sja1105_vlan_filtering,
 	.port_vlan_add		= sja1105_vlan_add,
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 591c5734747d..f7a1514f81e8 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -512,6 +512,7 @@ const struct sja1105_info sja1105e_info = {
 	.static_ops		= sja1105e_table_ops,
 	.dyn_ops		= sja1105et_dyn_ops,
 	.qinq_tpid		= ETH_P_8021Q,
+	.can_limit_mcast_flood	= false,
 	.ptp_ts_bits		= 24,
 	.ptpegr_ts_bytes	= 4,
 	.num_cbs_shapers	= SJA1105ET_MAX_CBS_COUNT,
@@ -529,6 +530,7 @@ const struct sja1105_info sja1105t_info = {
 	.static_ops		= sja1105t_table_ops,
 	.dyn_ops		= sja1105et_dyn_ops,
 	.qinq_tpid		= ETH_P_8021Q,
+	.can_limit_mcast_flood	= false,
 	.ptp_ts_bits		= 24,
 	.ptpegr_ts_bytes	= 4,
 	.num_cbs_shapers	= SJA1105ET_MAX_CBS_COUNT,
@@ -546,6 +548,7 @@ const struct sja1105_info sja1105p_info = {
 	.static_ops		= sja1105p_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
 	.qinq_tpid		= ETH_P_8021AD,
+	.can_limit_mcast_flood	= true,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
 	.num_cbs_shapers	= SJA1105PQRS_MAX_CBS_COUNT,
@@ -564,6 +567,7 @@ const struct sja1105_info sja1105q_info = {
 	.static_ops		= sja1105q_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
 	.qinq_tpid		= ETH_P_8021AD,
+	.can_limit_mcast_flood	= true,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
 	.num_cbs_shapers	= SJA1105PQRS_MAX_CBS_COUNT,
@@ -582,6 +586,7 @@ const struct sja1105_info sja1105r_info = {
 	.static_ops		= sja1105r_table_ops,
 	.dyn_ops		= sja1105pqrs_dyn_ops,
 	.qinq_tpid		= ETH_P_8021AD,
+	.can_limit_mcast_flood	= true,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
 	.num_cbs_shapers	= SJA1105PQRS_MAX_CBS_COUNT,
@@ -601,6 +606,7 @@ const struct sja1105_info sja1105s_info = {
 	.dyn_ops		= sja1105pqrs_dyn_ops,
 	.regs			= &sja1105pqrs_regs,
 	.qinq_tpid		= ETH_P_8021AD,
+	.can_limit_mcast_flood	= true,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
 	.num_cbs_shapers	= SJA1105PQRS_MAX_CBS_COUNT,
-- 
2.25.1

