Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6462938E731
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 15:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbhEXNQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 09:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232538AbhEXNQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 09:16:16 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA691C061756
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 06:14:44 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id s22so41526191ejv.12
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 06:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3PpKnB3359CBoQooBHqadBm9XVzt4DWYWpfHHOwNIEI=;
        b=oomNHsYD7Pvp6kCQEOzvu/pMrHiu576N+Ac7MiWbBM8vaTiFAy9KE7IJrO5KlzSky+
         rWXJcfJqADTgUSGlsRfqMjSLiLAAzWhk0GXEy0jkHLevKmo3S/ldP7PNzxd9pLkJUwrt
         vd/ZCgsp5b6LezVsesdrLrv64u2B99eWJybqcRMbCUS0AtLyB2PZsSPXOMRTdIyJb6Wk
         yIBQCy3AQPVYVrJM3KVZ4BXPQp8oIn0+nlrSBPquKY3Yq+VlW5Zk1nQFOkmMKEPCibfC
         EGMVT5dvq5mOpcWvmQNfk3kIV4XJFYTFVS5SYZKKY9uQns6iWn/OFeAiFg2MZnKILnwX
         xUeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3PpKnB3359CBoQooBHqadBm9XVzt4DWYWpfHHOwNIEI=;
        b=VRIu+Q9WIogr8x+DChZb91tbGZ3Sx8I8ErKSphp5e6miiowOV7QH2acXkM/63cxW7j
         GRybcl1G77KgMp8I6ZeE0quREi281EW3aDqhS17fhwv/i8QP4kQ77rMwiNIW0zXDl14/
         bN0f4kFsXZ4HrKlGhpAVQgfGLstiJFsxeycAml4QcKLS4eJMH/FOP0a1FX1IMDjzfylL
         qGfFH+DcA93O1nUpqkgI2T0czN4XdwR6ZXoi0V/5faMf/uVVIuJDuG6bJsDw5z8zeIv2
         wuOlgIvbfId4nHI9FFAdD3rplog/HtyYt1D8+vtSJbLotAcz/RnWmYvZpe3u2p5ilWIs
         KO4A==
X-Gm-Message-State: AOAM531iayMwaNhaq9V+QVS1r9mIi7bDa0Bx0EV8T4fz7NfbAnKWBBcq
        8eluKbWaBp3j56KaPv07HPHQoXXDXF4=
X-Google-Smtp-Source: ABdhPJwPoo9zaFcUEG6RqmRQX21HEriB0R1Jygbn+DgKB5CX2t4Vp7qMNmiSk6p6/YLrEDMKm8qHnQ==
X-Received: by 2002:a17:906:d89:: with SMTP id m9mr24344031eji.191.1621862083251;
        Mon, 24 May 2021 06:14:43 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g13sm8009139ejz.24.2021.05.24.06.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 06:14:42 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 1/9] net: dsa: sja1105: parameterize the number of ports
Date:   Mon, 24 May 2021 16:14:13 +0300
Message-Id: <20210524131421.1030789-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524131421.1030789-1-olteanv@gmail.com>
References: <20210524131421.1030789-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The sja1105 driver will gain support for the next-gen SJA1110 switch,
which is very similar except for the fact it has more than 5 ports.

So we need to replace the hardcoded SJA1105_NUM_PORTS in this driver
with ds->num_ports. This patch is as mechanical as possible (save for
the fact that ds->num_ports is not an integer constant expression).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_clocking.c |  3 +-
 drivers/net/dsa/sja1105/sja1105_flower.c   |  9 ++--
 drivers/net/dsa/sja1105/sja1105_main.c     | 61 +++++++++++++---------
 drivers/net/dsa/sja1105/sja1105_spi.c      |  4 +-
 drivers/net/dsa/sja1105/sja1105_tas.c      | 14 ++---
 5 files changed, 53 insertions(+), 38 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_clocking.c b/drivers/net/dsa/sja1105/sja1105_clocking.c
index 2a9b8a6a5306..f54b4d03a002 100644
--- a/drivers/net/dsa/sja1105/sja1105_clocking.c
+++ b/drivers/net/dsa/sja1105/sja1105_clocking.c
@@ -721,9 +721,10 @@ int sja1105_clocking_setup_port(struct sja1105_private *priv, int port)
 
 int sja1105_clocking_setup(struct sja1105_private *priv)
 {
+	struct dsa_switch *ds = priv->ds;
 	int port, rc;
 
-	for (port = 0; port < SJA1105_NUM_PORTS; port++) {
+	for (port = 0; port < ds->num_ports; port++) {
 		rc = sja1105_clocking_setup_port(priv, port);
 		if (rc < 0)
 			return rc;
diff --git a/drivers/net/dsa/sja1105/sja1105_flower.c b/drivers/net/dsa/sja1105/sja1105_flower.c
index 973761132fc3..77c54126b3fc 100644
--- a/drivers/net/dsa/sja1105/sja1105_flower.c
+++ b/drivers/net/dsa/sja1105/sja1105_flower.c
@@ -35,6 +35,7 @@ static int sja1105_setup_bcast_policer(struct sja1105_private *priv,
 {
 	struct sja1105_rule *rule = sja1105_rule_find(priv, cookie);
 	struct sja1105_l2_policing_entry *policing;
+	struct dsa_switch *ds = priv->ds;
 	bool new_rule = false;
 	unsigned long p;
 	int rc;
@@ -59,7 +60,7 @@ static int sja1105_setup_bcast_policer(struct sja1105_private *priv,
 
 	policing = priv->static_config.tables[BLK_IDX_L2_POLICING].entries;
 
-	if (policing[(SJA1105_NUM_PORTS * SJA1105_NUM_TC) + port].sharindx != port) {
+	if (policing[(ds->num_ports * SJA1105_NUM_TC) + port].sharindx != port) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Port already has a broadcast policer");
 		rc = -EEXIST;
@@ -72,7 +73,7 @@ static int sja1105_setup_bcast_policer(struct sja1105_private *priv,
 	 * point to the newly allocated policer
 	 */
 	for_each_set_bit(p, &rule->port_mask, SJA1105_NUM_PORTS) {
-		int bcast = (SJA1105_NUM_PORTS * SJA1105_NUM_TC) + p;
+		int bcast = (ds->num_ports * SJA1105_NUM_TC) + p;
 
 		policing[bcast].sharindx = rule->bcast_pol.sharindx;
 	}
@@ -435,7 +436,7 @@ int sja1105_cls_flower_del(struct dsa_switch *ds, int port,
 	policing = priv->static_config.tables[BLK_IDX_L2_POLICING].entries;
 
 	if (rule->type == SJA1105_RULE_BCAST_POLICER) {
-		int bcast = (SJA1105_NUM_PORTS * SJA1105_NUM_TC) + port;
+		int bcast = (ds->num_ports * SJA1105_NUM_TC) + port;
 
 		old_sharindx = policing[bcast].sharindx;
 		policing[bcast].sharindx = port;
@@ -486,7 +487,7 @@ void sja1105_flower_setup(struct dsa_switch *ds)
 
 	INIT_LIST_HEAD(&priv->flow_block.rules);
 
-	for (port = 0; port < SJA1105_NUM_PORTS; port++)
+	for (port = 0; port < ds->num_ports; port++)
 		priv->flow_block.l2_policer_used[port] = true;
 }
 
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 1976856dbf63..0e4e27b444fa 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -106,6 +106,7 @@ static int sja1105_init_mac_settings(struct sja1105_private *priv)
 		.ingress = false,
 	};
 	struct sja1105_mac_config_entry *mac;
+	struct dsa_switch *ds = priv->ds;
 	struct sja1105_table *table;
 	int i;
 
@@ -117,16 +118,16 @@ static int sja1105_init_mac_settings(struct sja1105_private *priv)
 		table->entry_count = 0;
 	}
 
-	table->entries = kcalloc(SJA1105_NUM_PORTS,
+	table->entries = kcalloc(ds->num_ports,
 				 table->ops->unpacked_entry_size, GFP_KERNEL);
 	if (!table->entries)
 		return -ENOMEM;
 
-	table->entry_count = SJA1105_NUM_PORTS;
+	table->entry_count = ds->num_ports;
 
 	mac = table->entries;
 
-	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
+	for (i = 0; i < ds->num_ports; i++) {
 		mac[i] = default_mac;
 		if (i == dsa_upstream_port(priv->ds, i)) {
 			/* STP doesn't get called for CPU port, so we need to
@@ -161,6 +162,7 @@ static int sja1105_init_mii_settings(struct sja1105_private *priv,
 {
 	struct device *dev = &priv->spidev->dev;
 	struct sja1105_xmii_params_entry *mii;
+	struct dsa_switch *ds = priv->ds;
 	struct sja1105_table *table;
 	int i;
 
@@ -182,7 +184,7 @@ static int sja1105_init_mii_settings(struct sja1105_private *priv,
 
 	mii = table->entries;
 
-	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
+	for (i = 0; i < ds->num_ports; i++) {
 		if (dsa_is_unused_port(priv->ds, i))
 			continue;
 
@@ -265,8 +267,6 @@ static int sja1105_init_static_fdb(struct sja1105_private *priv)
 
 static int sja1105_init_l2_lookup_params(struct sja1105_private *priv)
 {
-	struct sja1105_table *table;
-	u64 max_fdb_entries = SJA1105_MAX_L2_LOOKUP_COUNT / SJA1105_NUM_PORTS;
 	struct sja1105_l2_lookup_params_entry default_l2_lookup_params = {
 		/* Learned FDB entries are forgotten after 300 seconds */
 		.maxage = SJA1105_AGEING_TIME_MS(300000),
@@ -274,8 +274,6 @@ static int sja1105_init_l2_lookup_params(struct sja1105_private *priv)
 		.dyn_tbsz = SJA1105ET_FDB_BIN_SIZE,
 		/* And the P/Q/R/S equivalent setting: */
 		.start_dynspc = 0,
-		.maxaddrp = {max_fdb_entries, max_fdb_entries, max_fdb_entries,
-			     max_fdb_entries, max_fdb_entries, },
 		/* 2^8 + 2^5 + 2^3 + 2^2 + 2^1 + 1 in Koopman notation */
 		.poly = 0x97,
 		/* This selects between Independent VLAN Learning (IVL) and
@@ -299,6 +297,15 @@ static int sja1105_init_l2_lookup_params(struct sja1105_private *priv)
 		.owr_dyn = true,
 		.drpnolearn = true,
 	};
+	struct dsa_switch *ds = priv->ds;
+	struct sja1105_table *table;
+	u64 max_fdb_entries;
+	int port;
+
+	max_fdb_entries = SJA1105_MAX_L2_LOOKUP_COUNT / ds->num_ports;
+
+	for (port = 0; port < ds->num_ports; port++)
+		default_l2_lookup_params.maxaddrp[port] = max_fdb_entries;
 
 	table = &priv->static_config.tables[BLK_IDX_L2_LOOKUP_PARAMS];
 
@@ -388,6 +395,7 @@ static int sja1105_init_static_vlan(struct sja1105_private *priv)
 static int sja1105_init_l2_forwarding(struct sja1105_private *priv)
 {
 	struct sja1105_l2_forwarding_entry *l2fwd;
+	struct dsa_switch *ds = priv->ds;
 	struct sja1105_table *table;
 	int i, j;
 
@@ -408,7 +416,7 @@ static int sja1105_init_l2_forwarding(struct sja1105_private *priv)
 	l2fwd = table->entries;
 
 	/* First 5 entries define the forwarding rules */
-	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
+	for (i = 0; i < ds->num_ports; i++) {
 		unsigned int upstream = dsa_upstream_port(priv->ds, i);
 
 		for (j = 0; j < SJA1105_NUM_TC; j++)
@@ -436,8 +444,8 @@ static int sja1105_init_l2_forwarding(struct sja1105_private *priv)
 	 * Create a one-to-one mapping.
 	 */
 	for (i = 0; i < SJA1105_NUM_TC; i++)
-		for (j = 0; j < SJA1105_NUM_PORTS; j++)
-			l2fwd[SJA1105_NUM_PORTS + i].vlan_pmap[j] = i;
+		for (j = 0; j < ds->num_ports; j++)
+			l2fwd[ds->num_ports + i].vlan_pmap[j] = i;
 
 	return 0;
 }
@@ -533,7 +541,7 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 		 */
 		.host_port = dsa_upstream_port(priv->ds, 0),
 		/* Default to an invalid value */
-		.mirr_port = SJA1105_NUM_PORTS,
+		.mirr_port = priv->ds->num_ports,
 		/* Link-local traffic received on casc_port will be forwarded
 		 * to host_port without embedding the source port and device ID
 		 * info in the destination MAC address (presumably because it
@@ -541,7 +549,7 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 		 * that). Default to an invalid port (to disable the feature)
 		 * and overwrite this if we find any DSA (cascaded) ports.
 		 */
-		.casc_port = SJA1105_NUM_PORTS,
+		.casc_port = priv->ds->num_ports,
 		/* No TTEthernet */
 		.vllupformat = SJA1105_VL_FORMAT_PSFP,
 		.vlmarker = 0,
@@ -662,6 +670,7 @@ static int sja1105_init_avb_params(struct sja1105_private *priv)
 static int sja1105_init_l2_policing(struct sja1105_private *priv)
 {
 	struct sja1105_l2_policing_entry *policing;
+	struct dsa_switch *ds = priv->ds;
 	struct sja1105_table *table;
 	int port, tc;
 
@@ -683,8 +692,8 @@ static int sja1105_init_l2_policing(struct sja1105_private *priv)
 	policing = table->entries;
 
 	/* Setup shared indices for the matchall policers */
-	for (port = 0; port < SJA1105_NUM_PORTS; port++) {
-		int bcast = (SJA1105_NUM_PORTS * SJA1105_NUM_TC) + port;
+	for (port = 0; port < ds->num_ports; port++) {
+		int bcast = (ds->num_ports * SJA1105_NUM_TC) + port;
 
 		for (tc = 0; tc < SJA1105_NUM_TC; tc++)
 			policing[port * SJA1105_NUM_TC + tc].sharindx = port;
@@ -693,7 +702,7 @@ static int sja1105_init_l2_policing(struct sja1105_private *priv)
 	}
 
 	/* Setup the matchall policer parameters */
-	for (port = 0; port < SJA1105_NUM_PORTS; port++) {
+	for (port = 0; port < ds->num_ports; port++) {
 		int mtu = VLAN_ETH_FRAME_LEN + ETH_FCS_LEN;
 
 		if (dsa_is_cpu_port(priv->ds, port))
@@ -759,9 +768,10 @@ static int sja1105_static_config_load(struct sja1105_private *priv,
 static int sja1105_parse_rgmii_delays(struct sja1105_private *priv,
 				      const struct sja1105_dt_port *ports)
 {
+	struct dsa_switch *ds = priv->ds;
 	int i;
 
-	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
+	for (i = 0; i < ds->num_ports; i++) {
 		if (ports[i].role == XMII_MAC)
 			continue;
 
@@ -1638,7 +1648,7 @@ static int sja1105_bridge_member(struct dsa_switch *ds, int port,
 
 	l2_fwd = priv->static_config.tables[BLK_IDX_L2_FORWARDING].entries;
 
-	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
+	for (i = 0; i < ds->num_ports; i++) {
 		/* Add this port to the forwarding matrix of the
 		 * other ports in the same bridge, and viceversa.
 		 */
@@ -1854,7 +1864,7 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 	 * switch wants to see in the static config in order to allow us to
 	 * change it through the dynamic interface later.
 	 */
-	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
+	for (i = 0; i < ds->num_ports; i++) {
 		speed_mbps[i] = sja1105_speed[mac[i].speed];
 		mac[i].speed = SJA1105_SPEED_AUTO;
 	}
@@ -1906,7 +1916,7 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 	if (rc < 0)
 		goto out;
 
-	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
+	for (i = 0; i < ds->num_ports; i++) {
 		rc = sja1105_adjust_port_config(priv, i, speed_mbps[i]);
 		if (rc < 0)
 			goto out;
@@ -3024,7 +3034,7 @@ static void sja1105_teardown(struct dsa_switch *ds)
 	struct sja1105_bridge_vlan *v, *n;
 	int port;
 
-	for (port = 0; port < SJA1105_NUM_PORTS; port++) {
+	for (port = 0; port < ds->num_ports; port++) {
 		struct sja1105_port *sp = &priv->ports[port];
 
 		if (!dsa_is_user_port(ds, port))
@@ -3227,6 +3237,7 @@ static int sja1105_mirror_apply(struct sja1105_private *priv, int from, int to,
 {
 	struct sja1105_general_params_entry *general_params;
 	struct sja1105_mac_config_entry *mac;
+	struct dsa_switch *ds = priv->ds;
 	struct sja1105_table *table;
 	bool already_enabled;
 	u64 new_mirr_port;
@@ -3237,7 +3248,7 @@ static int sja1105_mirror_apply(struct sja1105_private *priv, int from, int to,
 
 	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
 
-	already_enabled = (general_params->mirr_port != SJA1105_NUM_PORTS);
+	already_enabled = (general_params->mirr_port != ds->num_ports);
 	if (already_enabled && enabled && general_params->mirr_port != to) {
 		dev_err(priv->ds->dev,
 			"Delete mirroring rules towards port %llu first\n",
@@ -3251,7 +3262,7 @@ static int sja1105_mirror_apply(struct sja1105_private *priv, int from, int to,
 		int port;
 
 		/* Anybody still referencing mirr_port? */
-		for (port = 0; port < SJA1105_NUM_PORTS; port++) {
+		for (port = 0; port < ds->num_ports; port++) {
 			if (mac[port].ing_mirr || mac[port].egr_mirr) {
 				keep = true;
 				break;
@@ -3259,7 +3270,7 @@ static int sja1105_mirror_apply(struct sja1105_private *priv, int from, int to,
 		}
 		/* Unset already_enabled for next time */
 		if (!keep)
-			new_mirr_port = SJA1105_NUM_PORTS;
+			new_mirr_port = ds->num_ports;
 	}
 	if (new_mirr_port != general_params->mirr_port) {
 		general_params->mirr_port = new_mirr_port;
@@ -3681,7 +3692,7 @@ static int sja1105_probe(struct spi_device *spi)
 	}
 
 	/* Connections between dsa_port and sja1105_port */
-	for (port = 0; port < SJA1105_NUM_PORTS; port++) {
+	for (port = 0; port < ds->num_ports; port++) {
 		struct sja1105_port *sp = &priv->ports[port];
 		struct dsa_port *dp = dsa_to_port(ds, port);
 		struct net_device *slave;
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index df3a780e9dcc..f22340e77fd5 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -309,10 +309,10 @@ int static_config_buf_prepare_for_upload(struct sja1105_private *priv,
 
 int sja1105_static_config_upload(struct sja1105_private *priv)
 {
-	unsigned long port_bitmap = GENMASK_ULL(SJA1105_NUM_PORTS - 1, 0);
 	struct sja1105_static_config *config = &priv->static_config;
 	const struct sja1105_regs *regs = priv->info->regs;
 	struct device *dev = &priv->spidev->dev;
+	struct dsa_switch *ds = priv->ds;
 	struct sja1105_status status;
 	int rc, retries = RETRIES;
 	u8 *config_buf;
@@ -333,7 +333,7 @@ int sja1105_static_config_upload(struct sja1105_private *priv)
 	 * Tx on all ports and waiting for current packet to drain.
 	 * Otherwise, the PHY will see an unterminated Ethernet packet.
 	 */
-	rc = sja1105_inhibit_tx(priv, port_bitmap, true);
+	rc = sja1105_inhibit_tx(priv, GENMASK_ULL(ds->num_ports - 1, 0), true);
 	if (rc < 0) {
 		dev_err(dev, "Failed to inhibit Tx on ports\n");
 		rc = -ENXIO;
diff --git a/drivers/net/dsa/sja1105/sja1105_tas.c b/drivers/net/dsa/sja1105/sja1105_tas.c
index 31d8acff1f01..e6153848a950 100644
--- a/drivers/net/dsa/sja1105/sja1105_tas.c
+++ b/drivers/net/dsa/sja1105/sja1105_tas.c
@@ -27,7 +27,7 @@ static int sja1105_tas_set_runtime_params(struct sja1105_private *priv)
 
 	tas_data->enabled = false;
 
-	for (port = 0; port < SJA1105_NUM_PORTS; port++) {
+	for (port = 0; port < ds->num_ports; port++) {
 		const struct tc_taprio_qopt_offload *offload;
 
 		offload = tas_data->offload[port];
@@ -164,6 +164,7 @@ int sja1105_init_scheduling(struct sja1105_private *priv)
 	struct sja1105_tas_data *tas_data = &priv->tas_data;
 	struct sja1105_gating_config *gating_cfg = &tas_data->gating_cfg;
 	struct sja1105_schedule_entry *schedule;
+	struct dsa_switch *ds = priv->ds;
 	struct sja1105_table *table;
 	int schedule_start_idx;
 	s64 entry_point_delta;
@@ -207,7 +208,7 @@ int sja1105_init_scheduling(struct sja1105_private *priv)
 	}
 
 	/* Figure out the dimensioning of the problem */
-	for (port = 0; port < SJA1105_NUM_PORTS; port++) {
+	for (port = 0; port < ds->num_ports; port++) {
 		if (tas_data->offload[port]) {
 			num_entries += tas_data->offload[port]->num_entries;
 			num_cycles++;
@@ -269,7 +270,7 @@ int sja1105_init_scheduling(struct sja1105_private *priv)
 	schedule_entry_points_params->clksrc = SJA1105_TAS_CLKSRC_PTP;
 	schedule_entry_points_params->actsubsch = num_cycles - 1;
 
-	for (port = 0; port < SJA1105_NUM_PORTS; port++) {
+	for (port = 0; port < ds->num_ports; port++) {
 		const struct tc_taprio_qopt_offload *offload;
 		/* Relative base time */
 		s64 rbt;
@@ -468,6 +469,7 @@ bool sja1105_gating_check_conflicts(struct sja1105_private *priv, int port,
 	struct sja1105_gating_config *gating_cfg = &priv->tas_data.gating_cfg;
 	size_t num_entries = gating_cfg->num_entries;
 	struct tc_taprio_qopt_offload *dummy;
+	struct dsa_switch *ds = priv->ds;
 	struct sja1105_gate_entry *e;
 	bool conflict;
 	int i = 0;
@@ -491,7 +493,7 @@ bool sja1105_gating_check_conflicts(struct sja1105_private *priv, int port,
 	if (port != -1) {
 		conflict = sja1105_tas_check_conflicts(priv, port, dummy);
 	} else {
-		for (port = 0; port < SJA1105_NUM_PORTS; port++) {
+		for (port = 0; port < ds->num_ports; port++) {
 			conflict = sja1105_tas_check_conflicts(priv, port,
 							       dummy);
 			if (conflict)
@@ -554,7 +556,7 @@ int sja1105_setup_tc_taprio(struct dsa_switch *ds, int port,
 		}
 	}
 
-	for (other_port = 0; other_port < SJA1105_NUM_PORTS; other_port++) {
+	for (other_port = 0; other_port < ds->num_ports; other_port++) {
 		if (other_port == port)
 			continue;
 
@@ -885,7 +887,7 @@ void sja1105_tas_teardown(struct dsa_switch *ds)
 
 	cancel_work_sync(&priv->tas_data.tas_work);
 
-	for (port = 0; port < SJA1105_NUM_PORTS; port++) {
+	for (port = 0; port < ds->num_ports; port++) {
 		offload = priv->tas_data.offload[port];
 		if (!offload)
 			continue;
-- 
2.25.1

