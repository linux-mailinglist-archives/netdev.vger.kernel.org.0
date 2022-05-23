Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2478F53107D
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234189AbiEWKnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 06:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234256AbiEWKnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 06:43:25 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 621BE3150D
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:43:21 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id wh22so27739825ejb.7
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T12dTiKTwaKzbwS7CxIAt6TR3zoC9o8zO5xudjwnx/g=;
        b=XVAqnC8jAKHOoTvoaehLaHSNt8+dAyKUY1o1BVux/9NyZzdvh2k+FXkpU5oFzFcrUy
         JMQr8dgBvBpvJY1x4RR3gncoGKOBdIGI2QPPCNQ9Kj+LxhlqIR0ktQbcTL4X67jieIXu
         NkzHSA/Ienwzfy4C1xTia+zs3WvP8e5HV5KMN+izyD0e+sVwKBZqGRc/rQxX1ZRp/avk
         d02/NQ1XA0AOnc68tHsCsrFQqN/knfjXhf2mXv3IxD/rlzkW1uTBjSZ6WtbxIIjKdIwV
         WAGaFjC+IEtSMICL1mHkECb3Zj2PtOHs60nG1liHuJ1LsepHMEkMsUg+2BMovhvG27xL
         DauA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T12dTiKTwaKzbwS7CxIAt6TR3zoC9o8zO5xudjwnx/g=;
        b=46pZ2r8agTfdZeYt/9eqBKiFWwwc9dznlXig3sOxMQ3DXQkMfAqs0+EgLepkDOV5oP
         TRJqcvYFBagTuWNXKlPK+opg80cY3MtUfzBD6b4usQHxTgANN5JjkTclFdAFFWQA3Bo8
         t9O1xFyHjFqxfielkqQIhAUyVKTnDni1k8w/3enl6d8v/xasKY4iXbejP700DPrzvqXM
         ghHYs+Sjcryq2fHA+cVO0xL4P7QpcOkFBDjGu00Cm2DiiLjgT7YiM8ob1WoDl6lTiq38
         YIdo4SGuxSpNvBgNh2L8pI42XP1mCJz26/McjuS0KkcTo4niNETR0WkTX19Cts16IyGE
         tpVA==
X-Gm-Message-State: AOAM532XQoY+eM1v8XPAQFj7p6FfFcA1ABQkyzPBe6SD54LWCmkG/XTo
        7PDEEuXqQwRtD7QYOw3zbtZEHgK8XWk=
X-Google-Smtp-Source: ABdhPJwz3dTBRCDXz+ybBlW+dhvJDL1K1b2moGZzs3BT6/GODw5MtO7qmw2kNpgefeVlLmht3NBH/A==
X-Received: by 2002:a17:907:1b25:b0:6da:8206:fc56 with SMTP id mp37-20020a1709071b2500b006da8206fc56mr18424228ejc.81.1653302599341;
        Mon, 23 May 2022 03:43:19 -0700 (PDT)
Received: from localhost.localdomain ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id j18-20020a1709066dd200b006feb875503fsm2584822ejt.78.2022.05.23.03.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 03:43:18 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Frank Wunderlich <frank-w@public-files.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH net-next 09/12] net: dsa: introduce dsa_port_get_master()
Date:   Mon, 23 May 2022 13:42:53 +0300
Message-Id: <20220523104256.3556016-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220523104256.3556016-1-olteanv@gmail.com>
References: <20220523104256.3556016-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There is a desire to support for DSA masters in a LAG.

That configuration is intended to work by simply enslaving the master to
a bonding/team device. But the physical DSA master (the LAG slave) still
has a dev->dsa_ptr, and that cpu_dp still corresponds to the physical
CPU port.

However, we would like to be able to retrieve the LAG that's the upper
of the physical DSA master. In preparation for that, introduce a helper
called dsa_port_get_master() that replaces all occurrences of the
dp->cpu_dp->master pattern. The distinction between LAG and non-LAG will
be made later within the helper itself.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/bcm_sf2.c                     |  4 +--
 drivers/net/dsa/bcm_sf2_cfp.c                 |  4 +--
 drivers/net/dsa/lan9303-core.c                |  4 +--
 .../net/ethernet/mediatek/mtk_ppe_offload.c   |  2 +-
 include/net/dsa.h                             |  5 ++++
 net/dsa/dsa2.c                                |  8 +++---
 net/dsa/dsa_priv.h                            |  2 +-
 net/dsa/port.c                                | 28 +++++++++----------
 net/dsa/slave.c                               | 11 ++++----
 net/dsa/tag_8021q.c                           |  4 +--
 10 files changed, 38 insertions(+), 34 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 87e81c636339..4551528d822c 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -982,7 +982,7 @@ static int bcm_sf2_sw_resume(struct dsa_switch *ds)
 static void bcm_sf2_sw_get_wol(struct dsa_switch *ds, int port,
 			       struct ethtool_wolinfo *wol)
 {
-	struct net_device *p = dsa_to_port(ds, port)->cpu_dp->master;
+	struct net_device *p = dsa_port_to_master(dsa_to_port(ds, port));
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	struct ethtool_wolinfo pwol = { };
 
@@ -1006,7 +1006,7 @@ static void bcm_sf2_sw_get_wol(struct dsa_switch *ds, int port,
 static int bcm_sf2_sw_set_wol(struct dsa_switch *ds, int port,
 			      struct ethtool_wolinfo *wol)
 {
-	struct net_device *p = dsa_to_port(ds, port)->cpu_dp->master;
+	struct net_device *p = dsa_port_to_master(dsa_to_port(ds, port));
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	s8 cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
 	struct ethtool_wolinfo pwol =  { };
diff --git a/drivers/net/dsa/bcm_sf2_cfp.c b/drivers/net/dsa/bcm_sf2_cfp.c
index edbe5e7f1cb6..90636ae3db98 100644
--- a/drivers/net/dsa/bcm_sf2_cfp.c
+++ b/drivers/net/dsa/bcm_sf2_cfp.c
@@ -1102,7 +1102,7 @@ static int bcm_sf2_cfp_rule_get_all(struct bcm_sf2_priv *priv,
 int bcm_sf2_get_rxnfc(struct dsa_switch *ds, int port,
 		      struct ethtool_rxnfc *nfc, u32 *rule_locs)
 {
-	struct net_device *p = dsa_to_port(ds, port)->cpu_dp->master;
+	struct net_device *p = dsa_port_to_master(dsa_to_port(ds, port));
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	int ret = 0;
 
@@ -1145,7 +1145,7 @@ int bcm_sf2_get_rxnfc(struct dsa_switch *ds, int port,
 int bcm_sf2_set_rxnfc(struct dsa_switch *ds, int port,
 		      struct ethtool_rxnfc *nfc)
 {
-	struct net_device *p = dsa_to_port(ds, port)->cpu_dp->master;
+	struct net_device *p = dsa_port_to_master(dsa_to_port(ds, port));
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	int ret = 0;
 
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index e03ff1f267bb..181e082b0919 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1090,7 +1090,7 @@ static int lan9303_port_enable(struct dsa_switch *ds, int port,
 	if (!dsa_port_is_user(dp))
 		return 0;
 
-	vlan_vid_add(dp->cpu_dp->master, htons(ETH_P_8021Q), port);
+	vlan_vid_add(dsa_port_to_master(dp), htons(ETH_P_8021Q), port);
 
 	return lan9303_enable_processing_port(chip, port);
 }
@@ -1103,7 +1103,7 @@ static void lan9303_port_disable(struct dsa_switch *ds, int port)
 	if (!dsa_port_is_user(dp))
 		return;
 
-	vlan_vid_del(dp->cpu_dp->master, htons(ETH_P_8021Q), port);
+	vlan_vid_del(dsa_port_to_master(dp), htons(ETH_P_8021Q), port);
 
 	lan9303_disable_processing_port(chip, port);
 	lan9303_phy_write(ds, chip->phy_addr_base + port, MII_BMCR, BMCR_PDOWN);
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index c9353071f96a..632af8c97043 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -174,7 +174,7 @@ mtk_flow_get_dsa_port(struct net_device **dev)
 	if (dp->cpu_dp->tag_ops->proto != DSA_TAG_PROTO_MTK)
 		return -ENODEV;
 
-	*dev = dp->cpu_dp->master;
+	*dev = dsa_port_to_master(dp);
 
 	return dp->index;
 #else
diff --git a/include/net/dsa.h b/include/net/dsa.h
index ad345fa17297..7f6ca944c092 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -714,6 +714,11 @@ static inline bool dsa_port_offloads_lag(struct dsa_port *dp,
 	return dsa_port_lag_dev_get(dp) == lag->dev;
 }
 
+static inline struct net_device *dsa_port_to_master(const struct dsa_port *dp)
+{
+	return dp->cpu_dp->master;
+}
+
 static inline
 struct net_device *dsa_port_to_bridge_port(const struct dsa_port *dp)
 {
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 74167bf0fbe5..8ff5467ac3e2 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1246,11 +1246,11 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 	 * attempts to change the tagging protocol. If we ever lift the IFF_UP
 	 * restriction, there needs to be another mutex which serializes this.
 	 */
-	list_for_each_entry(dp, &dst->ports, list) {
-		if (dsa_port_is_cpu(dp) && (dp->master->flags & IFF_UP))
+	dsa_tree_for_each_user_port(dp, dst) {
+		if (dsa_port_to_master(dp)->flags & IFF_UP)
 			goto out_unlock;
 
-		if (dsa_port_is_user(dp) && (dp->slave->flags & IFF_UP))
+		if (dp->slave->flags & IFF_UP)
 			goto out_unlock;
 	}
 
@@ -1780,7 +1780,7 @@ void dsa_switch_shutdown(struct dsa_switch *ds)
 	rtnl_lock();
 
 	dsa_switch_for_each_user_port(dp, ds) {
-		master = dp->cpu_dp->master;
+		master = dsa_port_to_master(dp);
 		slave_dev = dp->slave;
 
 		netdev_upper_dev_unlink(master, slave_dev);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index cc1cc866dc42..f3562cef32ad 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -322,7 +322,7 @@ dsa_slave_to_master(const struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 
-	return dp->cpu_dp->master;
+	return dsa_port_to_master(dp);
 }
 
 /* If under a bridge with vlan_filtering=0, make sure to send pvid-tagged
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 85cac22cb056..8557217ed5de 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1022,7 +1022,7 @@ int dsa_port_standalone_host_fdb_add(struct dsa_port *dp,
 int dsa_port_bridge_host_fdb_add(struct dsa_port *dp,
 				 const unsigned char *addr, u16 vid)
 {
-	struct dsa_port *cpu_dp = dp->cpu_dp;
+	struct net_device *master = dsa_port_to_master(dp);
 	struct dsa_db db = {
 		.type = DSA_DB_BRIDGE,
 		.bridge = *dp->bridge,
@@ -1033,8 +1033,8 @@ int dsa_port_bridge_host_fdb_add(struct dsa_port *dp,
 	 * requires rtnl_lock(), since we can't guarantee that is held here,
 	 * and we can't take it either.
 	 */
-	if (cpu_dp->master->priv_flags & IFF_UNICAST_FLT) {
-		err = dev_uc_add(cpu_dp->master, addr);
+	if (master->priv_flags & IFF_UNICAST_FLT) {
+		err = dev_uc_add(master, addr);
 		if (err)
 			return err;
 	}
@@ -1073,15 +1073,15 @@ int dsa_port_standalone_host_fdb_del(struct dsa_port *dp,
 int dsa_port_bridge_host_fdb_del(struct dsa_port *dp,
 				 const unsigned char *addr, u16 vid)
 {
-	struct dsa_port *cpu_dp = dp->cpu_dp;
+	struct net_device *master = dsa_port_to_master(dp);
 	struct dsa_db db = {
 		.type = DSA_DB_BRIDGE,
 		.bridge = *dp->bridge,
 	};
 	int err;
 
-	if (cpu_dp->master->priv_flags & IFF_UNICAST_FLT) {
-		err = dev_uc_del(cpu_dp->master, addr);
+	if (master->priv_flags & IFF_UNICAST_FLT) {
+		err = dev_uc_del(master, addr);
 		if (err)
 			return err;
 	}
@@ -1204,14 +1204,14 @@ int dsa_port_standalone_host_mdb_add(const struct dsa_port *dp,
 int dsa_port_bridge_host_mdb_add(const struct dsa_port *dp,
 				 const struct switchdev_obj_port_mdb *mdb)
 {
-	struct dsa_port *cpu_dp = dp->cpu_dp;
+	struct net_device *master = dsa_port_to_master(dp);
 	struct dsa_db db = {
 		.type = DSA_DB_BRIDGE,
 		.bridge = *dp->bridge,
 	};
 	int err;
 
-	err = dev_mc_add(cpu_dp->master, mdb->addr);
+	err = dev_mc_add(master, mdb->addr);
 	if (err)
 		return err;
 
@@ -1248,14 +1248,14 @@ int dsa_port_standalone_host_mdb_del(const struct dsa_port *dp,
 int dsa_port_bridge_host_mdb_del(const struct dsa_port *dp,
 				 const struct switchdev_obj_port_mdb *mdb)
 {
-	struct dsa_port *cpu_dp = dp->cpu_dp;
+	struct net_device *master = dsa_port_to_master(dp);
 	struct dsa_db db = {
 		.type = DSA_DB_BRIDGE,
 		.bridge = *dp->bridge,
 	};
 	int err;
 
-	err = dev_mc_del(cpu_dp->master, mdb->addr);
+	err = dev_mc_del(master, mdb->addr);
 	if (err)
 		return err;
 
@@ -1290,19 +1290,19 @@ int dsa_port_host_vlan_add(struct dsa_port *dp,
 			   const struct switchdev_obj_port_vlan *vlan,
 			   struct netlink_ext_ack *extack)
 {
+	struct net_device *master = dsa_port_to_master(dp);
 	struct dsa_notifier_vlan_info info = {
 		.dp = dp,
 		.vlan = vlan,
 		.extack = extack,
 	};
-	struct dsa_port *cpu_dp = dp->cpu_dp;
 	int err;
 
 	err = dsa_port_notify(dp, DSA_NOTIFIER_HOST_VLAN_ADD, &info);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-	vlan_vid_add(cpu_dp->master, htons(ETH_P_8021Q), vlan->vid);
+	vlan_vid_add(master, htons(ETH_P_8021Q), vlan->vid);
 
 	return err;
 }
@@ -1310,18 +1310,18 @@ int dsa_port_host_vlan_add(struct dsa_port *dp,
 int dsa_port_host_vlan_del(struct dsa_port *dp,
 			   const struct switchdev_obj_port_vlan *vlan)
 {
+	struct net_device *master = dsa_port_to_master(dp);
 	struct dsa_notifier_vlan_info info = {
 		.dp = dp,
 		.vlan = vlan,
 	};
-	struct dsa_port *cpu_dp = dp->cpu_dp;
 	int err;
 
 	err = dsa_port_notify(dp, DSA_NOTIFIER_HOST_VLAN_DEL, &info);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-	vlan_vid_del(cpu_dp->master, htons(ETH_P_8021Q), vlan->vid);
+	vlan_vid_del(master, htons(ETH_P_8021Q), vlan->vid);
 
 	return err;
 }
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index c0be747c66ac..0d0deca99eba 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1481,8 +1481,7 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
 static int dsa_slave_setup_ft_block(struct dsa_switch *ds, int port,
 				    void *type_data)
 {
-	struct dsa_port *cpu_dp = dsa_to_port(ds, port)->cpu_dp;
-	struct net_device *master = cpu_dp->master;
+	struct net_device *master = dsa_port_to_master(dsa_to_port(ds, port));
 
 	if (!master->netdev_ops->ndo_setup_tc)
 		return -EOPNOTSUPP;
@@ -2123,13 +2122,14 @@ static int dsa_slave_fill_forward_path(struct net_device_path_ctx *ctx,
 				       struct net_device_path *path)
 {
 	struct dsa_port *dp = dsa_slave_to_port(ctx->dev);
+	struct net_device *master = dsa_port_to_master(dp);
 	struct dsa_port *cpu_dp = dp->cpu_dp;
 
 	path->dev = ctx->dev;
 	path->type = DEV_PATH_DSA;
 	path->dsa.proto = cpu_dp->tag_ops->proto;
 	path->dsa.port = dp->index;
-	ctx->dev = cpu_dp->master;
+	ctx->dev = master;
 
 	return 0;
 }
@@ -2247,9 +2247,9 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 void dsa_slave_setup_tagger(struct net_device *slave)
 {
 	struct dsa_port *dp = dsa_slave_to_port(slave);
+	struct net_device *master = dsa_port_to_master(dp);
 	struct dsa_slave_priv *p = netdev_priv(slave);
 	const struct dsa_port *cpu_dp = dp->cpu_dp;
-	struct net_device *master = cpu_dp->master;
 	const struct dsa_switch *ds = dp->ds;
 
 	slave->needed_headroom = cpu_dp->tag_ops->needed_headroom;
@@ -2306,8 +2306,7 @@ int dsa_slave_resume(struct net_device *slave_dev)
 
 int dsa_slave_create(struct dsa_port *port)
 {
-	const struct dsa_port *cpu_dp = port->cpu_dp;
-	struct net_device *master = cpu_dp->master;
+	struct net_device *master = dsa_port_to_master(port);
 	struct dsa_switch *ds = port->ds;
 	const char *name = port->name;
 	struct net_device *slave_dev;
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 01a427800797..b91c2894b6fd 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -332,7 +332,7 @@ static int dsa_tag_8021q_port_setup(struct dsa_switch *ds, int port)
 	if (!dsa_port_is_user(dp))
 		return 0;
 
-	master = dp->cpu_dp->master;
+	master = dsa_port_to_master(dp);
 
 	err = dsa_port_tag_8021q_vlan_add(dp, vid, false);
 	if (err) {
@@ -361,7 +361,7 @@ static void dsa_tag_8021q_port_teardown(struct dsa_switch *ds, int port)
 	if (!dsa_port_is_user(dp))
 		return;
 
-	master = dp->cpu_dp->master;
+	master = dsa_port_to_master(dp);
 
 	dsa_port_tag_8021q_vlan_del(dp, vid, false);
 
-- 
2.25.1

