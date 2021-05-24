Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C2E38E732
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 15:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbhEXNQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 09:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbhEXNQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 09:16:16 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C69C06138B
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 06:14:46 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id p24so40491135ejb.1
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 06:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RgXT+XbtC0x2WGoj+P7A9GxEkP0spAtaNYnjMYZhhMA=;
        b=l4P6FhN7MwM//PZdclgNOd04vKJnNbFUm74EX+te0M+D8770AkIMoa84W9mO38IQto
         ww4z/vipuwLgJDCe+lHLxGps7XIhHNvU3Zw9ZZ0AUVltlWApwas0BXPUfFWbkDAlwQn5
         nr7UKg+DY8bEWAad1/LtVtxbzjZRYPevxjAO1P9t1BX41SspxgYXrK0nnrlrnkNbAdH9
         1Ss861ZXYmUy17h5Agj8YDj9FmUXixrAP84gM0XNWSKO/czDQAW5BBS5mHXbGK5+SvMZ
         lQvlJy3Chy+YytU+AimgU8JebHLTxMZBDd2ob/Fj+p3NA+Zev+r1+qEgTuddZ0Efx7Ej
         8NhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RgXT+XbtC0x2WGoj+P7A9GxEkP0spAtaNYnjMYZhhMA=;
        b=lD61RKunSi2d27ZaGe3/WsT6G+0Qx2bmWAEEzsyyFK7sKOPkVez94qeh4RStrqow6h
         +IbxIYUA5nh1+jjNqWQxakNbnsVtSvnT0Ao7IKVRdyzdqMQRGtwgB9GO1oYWEsAYzHeX
         B9lYu27XZkJrrPKZ9if7pqqhWS8WiUQqqnvs6t8WveFjBMm2czvvXjHvdFZbuBtkQwjX
         yfdyzKZG+XJoBEyCqF6aBSBGaloQR3djGds2LFxnMoNNk+mwaCzKDZB5sOE4veV/gqr7
         M8U2IIiszg3O4NHczkzCjZpG6ug23pjIX2R1Z7LcFBxriHq+sY4KJfCLJKSWA8PRCEZC
         PZNQ==
X-Gm-Message-State: AOAM532gH86jGKqjbETluB1jpRDwSlHMAeQRZDHR4sXxRbE+EDaRNN/F
        oAAWLT8/HqSl/d+LZozkrNw=
X-Google-Smtp-Source: ABdhPJz3JVhFHvizc6KbQMtlKnsBBTxEb/vp2/riIPyLTpsESgsDOeZEwd55ZNy1n5Phuba6/P8GNw==
X-Received: by 2002:a17:906:c00f:: with SMTP id e15mr3194813ejz.458.1621862084971;
        Mon, 24 May 2021 06:14:44 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g13sm8009139ejz.24.2021.05.24.06.14.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 06:14:44 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 3/9] net: dsa: sja1105: dimension the data structures for a larger port count
Date:   Mon, 24 May 2021 16:14:15 +0300
Message-Id: <20210524131421.1030789-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524131421.1030789-1-olteanv@gmail.com>
References: <20210524131421.1030789-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Introduce a SJA1105_MAX_NUM_PORTS macro which at the moment is equal to
SJA1105_NUM_PORTS (5). With the introduction of SJA1110, these
structures will need to hold information for up to 11 ports.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h        | 33 ++++++++++++------------
 drivers/net/dsa/sja1105/sja1105_flower.c |  4 +--
 drivers/net/dsa/sja1105/sja1105_main.c   |  8 +++---
 drivers/net/dsa/sja1105/sja1105_tas.h    |  2 +-
 drivers/net/dsa/sja1105/sja1105_vl.c     |  2 +-
 5 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 10fc6b54f9f6..3737a3b38863 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -14,6 +14,7 @@
 #include "sja1105_static_config.h"
 
 #define SJA1105_NUM_PORTS		5
+#define SJA1105_MAX_NUM_PORTS		SJA1105_NUM_PORTS
 #define SJA1105_NUM_TC			8
 #define SJA1105ET_FDB_BIN_SIZE		4
 /* The hardware value is in multiples of 10 ms.
@@ -57,19 +58,19 @@ struct sja1105_regs {
 	u64 ptpclkcorp;
 	u64 ptpsyncts;
 	u64 ptpschtm;
-	u64 ptpegr_ts[SJA1105_NUM_PORTS];
-	u64 pad_mii_tx[SJA1105_NUM_PORTS];
-	u64 pad_mii_rx[SJA1105_NUM_PORTS];
-	u64 pad_mii_id[SJA1105_NUM_PORTS];
-	u64 cgu_idiv[SJA1105_NUM_PORTS];
-	u64 mii_tx_clk[SJA1105_NUM_PORTS];
-	u64 mii_rx_clk[SJA1105_NUM_PORTS];
-	u64 mii_ext_tx_clk[SJA1105_NUM_PORTS];
-	u64 mii_ext_rx_clk[SJA1105_NUM_PORTS];
-	u64 rgmii_tx_clk[SJA1105_NUM_PORTS];
-	u64 rmii_ref_clk[SJA1105_NUM_PORTS];
-	u64 rmii_ext_tx_clk[SJA1105_NUM_PORTS];
-	u64 stats[__MAX_SJA1105_STATS_AREA][SJA1105_NUM_PORTS];
+	u64 ptpegr_ts[SJA1105_MAX_NUM_PORTS];
+	u64 pad_mii_tx[SJA1105_MAX_NUM_PORTS];
+	u64 pad_mii_rx[SJA1105_MAX_NUM_PORTS];
+	u64 pad_mii_id[SJA1105_MAX_NUM_PORTS];
+	u64 cgu_idiv[SJA1105_MAX_NUM_PORTS];
+	u64 mii_tx_clk[SJA1105_MAX_NUM_PORTS];
+	u64 mii_rx_clk[SJA1105_MAX_NUM_PORTS];
+	u64 mii_ext_tx_clk[SJA1105_MAX_NUM_PORTS];
+	u64 mii_ext_rx_clk[SJA1105_MAX_NUM_PORTS];
+	u64 rgmii_tx_clk[SJA1105_MAX_NUM_PORTS];
+	u64 rmii_ref_clk[SJA1105_MAX_NUM_PORTS];
+	u64 rmii_ext_tx_clk[SJA1105_MAX_NUM_PORTS];
+	u64 stats[__MAX_SJA1105_STATS_AREA][SJA1105_MAX_NUM_PORTS];
 };
 
 struct sja1105_info {
@@ -206,8 +207,8 @@ enum sja1105_vlan_state {
 
 struct sja1105_private {
 	struct sja1105_static_config static_config;
-	bool rgmii_rx_delay[SJA1105_NUM_PORTS];
-	bool rgmii_tx_delay[SJA1105_NUM_PORTS];
+	bool rgmii_rx_delay[SJA1105_MAX_NUM_PORTS];
+	bool rgmii_tx_delay[SJA1105_MAX_NUM_PORTS];
 	bool best_effort_vlan_filtering;
 	unsigned long learn_ena;
 	unsigned long ucast_egress_floods;
@@ -220,7 +221,7 @@ struct sja1105_private {
 	struct list_head dsa_8021q_vlans;
 	struct list_head bridge_vlans;
 	struct sja1105_flow_block flow_block;
-	struct sja1105_port ports[SJA1105_NUM_PORTS];
+	struct sja1105_port ports[SJA1105_MAX_NUM_PORTS];
 	/* Serializes transmission of management frames so that
 	 * the switch doesn't confuse them with one another.
 	 */
diff --git a/drivers/net/dsa/sja1105/sja1105_flower.c b/drivers/net/dsa/sja1105/sja1105_flower.c
index 77c54126b3fc..6c10ffa968ce 100644
--- a/drivers/net/dsa/sja1105/sja1105_flower.c
+++ b/drivers/net/dsa/sja1105/sja1105_flower.c
@@ -72,7 +72,7 @@ static int sja1105_setup_bcast_policer(struct sja1105_private *priv,
 	/* Make the broadcast policers of all ports attached to this block
 	 * point to the newly allocated policer
 	 */
-	for_each_set_bit(p, &rule->port_mask, SJA1105_NUM_PORTS) {
+	for_each_set_bit(p, &rule->port_mask, SJA1105_MAX_NUM_PORTS) {
 		int bcast = (ds->num_ports * SJA1105_NUM_TC) + p;
 
 		policing[bcast].sharindx = rule->bcast_pol.sharindx;
@@ -144,7 +144,7 @@ static int sja1105_setup_tc_policer(struct sja1105_private *priv,
 	/* Make the policers for traffic class @tc of all ports attached to
 	 * this block point to the newly allocated policer
 	 */
-	for_each_set_bit(p, &rule->port_mask, SJA1105_NUM_PORTS) {
+	for_each_set_bit(p, &rule->port_mask, SJA1105_MAX_NUM_PORTS) {
 		int index = (p * SJA1105_NUM_TC) + tc;
 
 		policing[index].sharindx = rule->tc_pol.sharindx;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 32bdbdb7cba2..5d5f6555dbac 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1863,8 +1863,8 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 {
 	struct ptp_system_timestamp ptp_sts_before;
 	struct ptp_system_timestamp ptp_sts_after;
+	int speed_mbps[SJA1105_MAX_NUM_PORTS];
 	struct sja1105_mac_config_entry *mac;
-	int speed_mbps[SJA1105_NUM_PORTS];
 	struct dsa_switch *ds = priv->ds;
 	s64 t1, t2, t3, t4;
 	s64 t12, t34;
@@ -2641,7 +2641,7 @@ static int sja1105_notify_crosschip_switches(struct sja1105_private *priv)
 
 static int sja1105_build_vlan_table(struct sja1105_private *priv, bool notify)
 {
-	u16 subvlan_map[SJA1105_NUM_PORTS][DSA_8021Q_N_SUBVLAN];
+	u16 subvlan_map[SJA1105_MAX_NUM_PORTS][DSA_8021Q_N_SUBVLAN];
 	struct sja1105_retagging_entry *new_retagging;
 	struct sja1105_vlan_lookup_entry *new_vlan;
 	struct sja1105_table *table;
@@ -2977,7 +2977,7 @@ static const struct dsa_8021q_ops sja1105_dsa_8021q_ops = {
  */
 static int sja1105_setup(struct dsa_switch *ds)
 {
-	struct sja1105_dt_port ports[SJA1105_NUM_PORTS];
+	struct sja1105_dt_port ports[SJA1105_MAX_NUM_PORTS];
 	struct sja1105_private *priv = ds->priv;
 	int rc;
 
@@ -3670,7 +3670,7 @@ static int sja1105_probe(struct spi_device *spi)
 		return -ENOMEM;
 
 	ds->dev = dev;
-	ds->num_ports = SJA1105_NUM_PORTS;
+	ds->num_ports = SJA1105_MAX_NUM_PORTS;
 	ds->ops = &sja1105_switch_ops;
 	ds->priv = priv;
 	priv->ds = ds;
diff --git a/drivers/net/dsa/sja1105/sja1105_tas.h b/drivers/net/dsa/sja1105/sja1105_tas.h
index 0c173ff51751..c05bd07e8221 100644
--- a/drivers/net/dsa/sja1105/sja1105_tas.h
+++ b/drivers/net/dsa/sja1105/sja1105_tas.h
@@ -39,7 +39,7 @@ struct sja1105_gating_config {
 };
 
 struct sja1105_tas_data {
-	struct tc_taprio_qopt_offload *offload[SJA1105_NUM_PORTS];
+	struct tc_taprio_qopt_offload *offload[SJA1105_MAX_NUM_PORTS];
 	struct sja1105_gating_config gating_cfg;
 	enum sja1105_tas_state state;
 	enum sja1105_ptp_op last_op;
diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
index ffc4042b4502..f6e13e6c6a18 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -386,7 +386,7 @@ static int sja1105_init_virtual_links(struct sja1105_private *priv,
 		if (rule->type != SJA1105_RULE_VL)
 			continue;
 
-		for_each_set_bit(port, &rule->port_mask, SJA1105_NUM_PORTS) {
+		for_each_set_bit(port, &rule->port_mask, SJA1105_MAX_NUM_PORTS) {
 			vl_lookup[k].format = SJA1105_VL_FORMAT_PSFP;
 			vl_lookup[k].port = port;
 			vl_lookup[k].macaddr = rule->key.vl.dmac;
-- 
2.25.1

