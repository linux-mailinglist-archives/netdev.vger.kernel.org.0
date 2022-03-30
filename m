Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3CCB4EBFCA
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 13:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343647AbiC3LdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 07:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236467AbiC3LdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 07:33:22 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BC91C1EF0
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 04:31:34 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id h7so35275683lfl.2
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 04:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=By50P1iIbnTrF7xjFgkh5Phe/MZf6bZelhrengB7KRY=;
        b=B9OqpYv+83XboHhMzk3HdLI3yaWBznuZO4Bcd5sqstGtk01d3azhTI9CBHfxawn9ib
         eRRGd1UlyGnYZHMOAukQf4msDYYW0J3YPojdoles43bPMjxy1bX42QMpW0YVttCs2SQS
         dc1Zx9dpKS+1kL0FaznHpwJHAUdUZpWeKCpiS7Xhx/ecXkxg8RKEgZdAvfvvOxj1mHI4
         KxRAcUVv8LefYphK++6pcVhHtiWPFRks0D0a1idUOHpj8ZO8RR/ANfgN05pMPYn6sRg1
         OpTEyoTbeiifK0z0+Q0KtJA89XDYBkOIvHEZDM/TWUjg4b9bhrw77wG9LgZ63RHea0M6
         rgCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=By50P1iIbnTrF7xjFgkh5Phe/MZf6bZelhrengB7KRY=;
        b=j5xI5OoallX9Tzoxag4QN1GTsbEV0oQQBjl6RAORIBAdqtdV/gkyIpPjfCWO+QDqJC
         OAtMFD3vsqZqy6UvxIbpL33u8esaxHqE1JDjQK6J/moXh0T4kFfEoWfNIApNK4vqO3SR
         cLqCr8Z7kGSEB/OOHZ4X+1TCayBxXn0F1Jzz4SLsv20cUdq8BMWSGBrWpPVGpFhhwRfw
         Zet/91Vktm4EMKlLQVsA7nKG7ubxnxfemkiOe/I7vyXc7EN+ASjMyBSwXz1GIYcQz8SZ
         LBSaU0L1/riD0zwHU+thboOuyacYYFd5PDB8TwgcVPaNZWWhABtq25yiVO9la5yE0q8t
         wgNA==
X-Gm-Message-State: AOAM532OCvrUQqzfWlYiBTNHiuUpv69Lz64wOen7ntIJVjHbrXTL0FGh
        lv8Ou0AV20nnA2Ij15YP6EgnNN0BokUIKezq
X-Google-Smtp-Source: ABdhPJwv5L0pDFAbqyyVhPJUp4QhAgClRMwI0LAL/qysoJndjfi631irhjWAAidDJ2GdiDn5mOOGUA==
X-Received: by 2002:a05:6512:3c92:b0:448:5062:268 with SMTP id h18-20020a0565123c9200b0044850620268mr6650435lfv.84.1648639889324;
        Wed, 30 Mar 2022 04:31:29 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id l3-20020a056512332300b0044a34844974sm2305909lfe.12.2022.03.30.04.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 04:31:28 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [RFC PATCH net-next 1/2] net: tc: dsa: Add the matchall filter with drop action for bridged DSA ports.
Date:   Wed, 30 Mar 2022 13:31:15 +0200
Message-Id: <20220330113116.3166219-2-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220330113116.3166219-1-mattias.forsblad@gmail.com>
References: <20220330113116.3166219-1-mattias.forsblad@gmail.com>
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

Use the flow indirect framework on bridged DSA ports to be
able to set up offloading of matchall filter with drop target.

Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
---
 include/net/dsa.h  |  13 +++
 net/dsa/dsa2.c     |   5 ++
 net/dsa/dsa_priv.h |   3 +
 net/dsa/port.c     |   1 +
 net/dsa/slave.c    | 217 ++++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 236 insertions(+), 3 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 934958fda962..ec4d4ef88d4e 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -171,6 +171,9 @@ struct dsa_switch_tree {
 
 	/* Track the largest switch index within a tree */
 	unsigned int last_switch;
+
+	/* For tc indirect bookkeeping */
+	struct list_head tc_indr_block_list;
 };
 
 /* LAG IDs are one-based, the dst->lags array is zero-based */
@@ -212,6 +215,7 @@ static inline int dsa_lag_id(struct dsa_switch_tree *dst,
 enum dsa_port_mall_action_type {
 	DSA_PORT_MALL_MIRROR,
 	DSA_PORT_MALL_POLICER,
+	DSA_PORT_MALL_DROP,
 };
 
 /* TC mirroring entry */
@@ -220,6 +224,11 @@ struct dsa_mall_mirror_tc_entry {
 	bool ingress;
 };
 
+/* TC drop entry */
+struct dsa_mall_drop_tc_entry {
+	bool enable;
+};
+
 /* TC port policer entry */
 struct dsa_mall_policer_tc_entry {
 	u32 burst;
@@ -234,6 +243,7 @@ struct dsa_mall_tc_entry {
 	union {
 		struct dsa_mall_mirror_tc_entry mirror;
 		struct dsa_mall_policer_tc_entry policer;
+		struct dsa_mall_drop_tc_entry drop;
 	};
 };
 
@@ -241,6 +251,7 @@ struct dsa_bridge {
 	struct net_device *dev;
 	unsigned int num;
 	bool tx_fwd_offload;
+	u8 local_rcv:1;
 	refcount_t refcount;
 };
 
@@ -1034,6 +1045,8 @@ struct dsa_switch_ops {
 	int	(*port_policer_add)(struct dsa_switch *ds, int port,
 				    struct dsa_mall_policer_tc_entry *policer);
 	void	(*port_policer_del)(struct dsa_switch *ds, int port);
+	int	(*bridge_local_rcv)(struct dsa_switch *ds, int port,
+				    struct dsa_mall_drop_tc_entry *drop);
 	int	(*port_setup_tc)(struct dsa_switch *ds, int port,
 				 enum tc_setup_type type, void *type_data);
 
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index ca6af86964bc..e87ceb841a70 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -247,6 +247,9 @@ static struct dsa_switch_tree *dsa_tree_alloc(int index)
 	INIT_LIST_HEAD(&dst->list);
 	list_add_tail(&dst->list, &dsa_tree_list);
 
+	INIT_LIST_HEAD(&dst->tc_indr_block_list);
+	dsa_setup_bridge_tc_indr(dst);
+
 	kref_init(&dst->refcount);
 
 	return dst;
@@ -254,6 +257,8 @@ static struct dsa_switch_tree *dsa_tree_alloc(int index)
 
 static void dsa_tree_free(struct dsa_switch_tree *dst)
 {
+	dsa_cleanup_bridge_tc_indr(dst);
+
 	if (dst->tag_ops)
 		dsa_tag_driver_put(dst->tag_ops);
 	list_del(&dst->list);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 5d3f4a67dce1..456bcbe730ba 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -320,6 +320,9 @@ void dsa_slave_setup_tagger(struct net_device *slave);
 int dsa_slave_change_mtu(struct net_device *dev, int new_mtu);
 int dsa_slave_manage_vlan_filtering(struct net_device *dev,
 				    bool vlan_filtering);
+int dsa_setup_bridge_tc_indr(struct dsa_switch_tree *dst);
+void dsa_cleanup_bridge_tc_indr(struct dsa_switch_tree *dst);
+bool dsa_slave_dev_check(const struct net_device *dev);
 
 static inline struct dsa_port *dsa_slave_to_port(const struct net_device *dev)
 {
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 32d472a82241..d35cda9f5c24 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -361,6 +361,7 @@ static int dsa_port_bridge_create(struct dsa_port *dp,
 	refcount_set(&bridge->refcount, 1);
 
 	bridge->dev = br;
+	bridge->local_rcv = 1;
 
 	bridge->num = dsa_bridge_num_get(br, ds->max_num_bridges);
 	if (ds->max_num_bridges && !bridge->num) {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 41c69a6e7854..65096d7fe193 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1246,6 +1246,67 @@ dsa_slave_add_cls_matchall_mirred(struct net_device *dev,
 	return err;
 }
 
+static int dsa_slave_check_offload(struct dsa_port *dp, struct dsa_mall_drop_tc_entry *drop)
+{
+	struct net_device *lower_dev;
+	struct dsa_switch *ds = dp->ds;
+	struct net_device *dev;
+	struct list_head *iter;
+
+	dev = dsa_port_bridge_dev_get(dp);
+	if (!dev)
+		return 0;
+
+	/* Evaluate if there is any foreign interfaces on the bridge.
+	 * If so, don't offload the drop action.
+	 */
+	netdev_for_each_lower_dev(dev, lower_dev, iter) {
+		if (!dsa_slave_dev_check(lower_dev))
+			return 1;
+	}
+
+	return ds->ops->bridge_local_rcv(ds, dp->index, drop);
+}
+
+static int
+dsa_slave_add_cls_matchall_drop(struct net_device *dev,
+				struct tc_cls_matchall_offload *cls,
+				bool ingress)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_slave_priv *p = netdev_priv(dev);
+	struct dsa_mall_tc_entry *mall_tc_entry;
+	struct dsa_mall_drop_tc_entry *drop;
+	struct dsa_switch *ds = dp->ds;
+	struct flow_action_entry *act;
+	int err;
+
+	if (!ds->ops->bridge_local_rcv)
+		return -EOPNOTSUPP;
+
+	act = &cls->rule->action.entries[0];
+
+	mall_tc_entry = kzalloc(sizeof(*mall_tc_entry), GFP_KERNEL);
+	if (!mall_tc_entry)
+		return -ENOMEM;
+
+	mall_tc_entry->cookie = cls->cookie;
+	mall_tc_entry->type = DSA_PORT_MALL_DROP;
+	drop = &mall_tc_entry->drop;
+	drop->enable = true;
+
+	dp->bridge->local_rcv = 0;
+	err = dsa_slave_check_offload(dp, drop);
+	if (err) {
+		kfree(mall_tc_entry);
+		return err;
+	}
+
+	list_add_tail(&mall_tc_entry->list, &p->mall_tc_list);
+
+	return err;
+}
+
 static int
 dsa_slave_add_cls_matchall_police(struct net_device *dev,
 				  struct tc_cls_matchall_offload *cls,
@@ -1320,6 +1381,9 @@ static int dsa_slave_add_cls_matchall(struct net_device *dev,
 	else if (flow_offload_has_one_action(&cls->rule->action) &&
 		 cls->rule->action.entries[0].id == FLOW_ACTION_POLICE)
 		err = dsa_slave_add_cls_matchall_police(dev, cls, ingress);
+	else if (flow_offload_has_one_action(&cls->rule->action) &&
+		 cls->rule->action.entries[0].id == FLOW_ACTION_DROP)
+		err = dsa_slave_add_cls_matchall_drop(dev, cls, ingress);
 
 	return err;
 }
@@ -1347,6 +1411,14 @@ static void dsa_slave_del_cls_matchall(struct net_device *dev,
 		if (ds->ops->port_policer_del)
 			ds->ops->port_policer_del(ds, dp->index);
 		break;
+	case DSA_PORT_MALL_DROP:
+		if (dp->bridge)
+			dp->bridge->local_rcv = 1;
+		mall_tc_entry->drop.enable = false;
+		if (ds->ops->bridge_local_rcv)
+			ds->ops->bridge_local_rcv(ds, dp->index,
+						 &mall_tc_entry->drop);
+		break;
 	default:
 		WARN_ON(1);
 	}
@@ -1430,7 +1502,8 @@ static int dsa_slave_setup_tc_cls_flower(struct net_device *dev,
 	}
 }
 
-static int dsa_slave_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
+static int dsa_slave_setup_tc_block_cb(enum tc_setup_type type,
+				       void *cls,
 				       void *cb_priv, bool ingress)
 {
 	struct net_device *dev = cb_priv;
@@ -1440,9 +1513,9 @@ static int dsa_slave_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 
 	switch (type) {
 	case TC_SETUP_CLSMATCHALL:
-		return dsa_slave_setup_tc_cls_matchall(dev, type_data, ingress);
+		return dsa_slave_setup_tc_cls_matchall(dev, cls, ingress);
 	case TC_SETUP_CLSFLOWER:
-		return dsa_slave_setup_tc_cls_flower(dev, type_data, ingress);
+		return dsa_slave_setup_tc_cls_flower(dev, cls, ingress);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -1514,6 +1587,133 @@ static int dsa_slave_setup_ft_block(struct dsa_switch *ds, int port,
 	return master->netdev_ops->ndo_setup_tc(master, TC_SETUP_FT, type_data);
 }
 
+static LIST_HEAD(dsa_slave_block_indr_cb_list);
+
+struct dsa_slave_indr_block_cb_priv {
+	struct dsa_switch_tree *dst;
+	struct net_device *bridge;
+	struct list_head list;
+};
+
+static int dsa_slave_setup_bridge_block_cb(enum tc_setup_type type,
+					   void *type_data,
+					   void *cb_priv)
+{
+	struct dsa_slave_indr_block_cb_priv *priv = cb_priv;
+	struct tc_cls_matchall_offload *cls;
+	struct dsa_port *dp;
+	int ret = 0;
+
+	cls = (struct tc_cls_matchall_offload *)type_data;
+	list_for_each_entry(dp, &priv->dst->ports, list) {
+		if (!dp->bridge || !dp->slave)
+			continue;
+
+		if (dp->bridge->dev != priv->bridge)
+			continue;
+
+		ret += dsa_slave_setup_tc_block_cb(type, cls, dp->slave, true);
+	}
+
+	return ret;
+}
+
+static struct dsa_slave_indr_block_cb_priv *
+dsa_slave_tc_indr_block_cb_lookup(struct dsa_switch_tree *dst, struct net_device *netdev)
+{
+	struct dsa_slave_indr_block_cb_priv *cb_priv;
+
+	list_for_each_entry(cb_priv, &dst->tc_indr_block_list, list)
+		if (cb_priv->bridge == netdev)
+			return cb_priv;
+
+	return NULL;
+}
+
+static void dsa_slave_setup_tc_indr_rel(void *cb_priv)
+{
+	struct dsa_slave_indr_block_cb_priv *priv = cb_priv;
+
+	list_del(&priv->list);
+	kfree(priv);
+}
+
+static int
+dsa_slave_setup_bridge_tc_indr_block(struct net_device *netdev, struct Qdisc *sch,
+				     struct dsa_switch_tree *dst,
+				     struct flow_block_offload *f, void *data,
+				     void (*cleanup)(struct flow_block_cb *block_cb))
+{
+	struct dsa_slave_indr_block_cb_priv *cb_priv;
+	struct flow_block_cb *block_cb;
+
+	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
+		return -EOPNOTSUPP;
+
+	switch (f->command) {
+	case FLOW_BLOCK_BIND:
+		cb_priv = kmalloc(sizeof(*cb_priv), GFP_KERNEL);
+		if (!cb_priv)
+			return -ENOMEM;
+
+		cb_priv->bridge = netdev;
+		cb_priv->dst = dst;
+		list_add(&cb_priv->list, &dst->tc_indr_block_list);
+
+		block_cb = flow_indr_block_cb_alloc(dsa_slave_setup_bridge_block_cb,
+						    cb_priv, cb_priv,
+						    dsa_slave_setup_tc_indr_rel, f,
+						    netdev, sch, data, cb_priv, cleanup);
+		if (IS_ERR(block_cb)) {
+			list_del(&cb_priv->list);
+			kfree(cb_priv);
+			return PTR_ERR(block_cb);
+		}
+
+		flow_block_cb_add(block_cb, f);
+		list_add_tail(&block_cb->driver_list, &dsa_slave_block_indr_cb_list);
+		break;
+	case FLOW_BLOCK_UNBIND:
+		cb_priv = dsa_slave_tc_indr_block_cb_lookup(dst, netdev);
+		if (!cb_priv)
+			return -ENOENT;
+
+		block_cb = flow_block_cb_lookup(f->block,
+						dsa_slave_setup_bridge_block_cb,
+						cb_priv);
+		if (!block_cb)
+			return -ENOENT;
+
+		flow_indr_block_cb_remove(block_cb, f);
+		list_del(&block_cb->driver_list);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int dsa_slave_setup_bridge_tc_indr_cb(struct net_device *netdev, struct Qdisc *sch,
+					     void *cb_priv,
+					     enum tc_setup_type type, void *type_data,
+					     void *data,
+					     void (*cleanup)(struct flow_block_cb *block_cb))
+{
+	if (!netdev || !netif_is_bridge_master(netdev))
+		return -EOPNOTSUPP;
+
+	switch (type) {
+	case TC_SETUP_BLOCK:
+		return dsa_slave_setup_bridge_tc_indr_block(netdev, sch, cb_priv,
+						     type_data, data, cleanup);
+	default:
+		break;
+	}
+
+	return -EOPNOTSUPP;
+}
+
 static int dsa_slave_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			      void *type_data)
 {
@@ -1535,6 +1735,17 @@ static int dsa_slave_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	return ds->ops->port_setup_tc(ds, dp->index, type, type_data);
 }
 
+int dsa_setup_bridge_tc_indr(struct dsa_switch_tree *dst)
+{
+	return flow_indr_dev_register(dsa_slave_setup_bridge_tc_indr_cb, dst);
+}
+
+void dsa_cleanup_bridge_tc_indr(struct dsa_switch_tree *dst)
+{
+	flow_indr_dev_unregister(dsa_slave_setup_bridge_tc_indr_cb,
+				 dst, dsa_slave_setup_tc_indr_rel);
+}
+
 static int dsa_slave_get_rxnfc(struct net_device *dev,
 			       struct ethtool_rxnfc *nfc, u32 *rule_locs)
 {
-- 
2.25.1

