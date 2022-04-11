Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A00424FBBB8
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 14:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345982AbiDKMJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 08:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344701AbiDKMI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 08:08:56 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E523CA66
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 05:06:42 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 15so4990445ljw.8
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 05:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=insPQorh5tkNHySDDQreThipvd/VYR2Fe7Q2dLgZVzk=;
        b=nPClcgx1MjeYrtoHGAbH0e2hAArf4vk8ojpmv014H8iuaaPhlgu7NMEPIVyDHTy4St
         3V141GxkDtj8TrZ4xRakiYb8RjPcs1mCYCjpIjvAYHIpcgAfNVMEyRMtBXsDvz8U2Nt0
         ZFna9VOXtGQJINM4C3bw3RAVRnx1Q2aOgNHcIzggn82wvEibRWoq699qKccELVd6KE0g
         XorsKcFF9GewvrNrFXBst4Wd97FgWhFPnzj4QSvR2fKYbyHtYvCumfKryskimM5vT/ip
         pMiHnReQGtozveX0SOyepw1X49x6zu3tg90PfOSGHIpqXDZdrsWbLDWHJtYKdE3ALBnd
         jXkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=insPQorh5tkNHySDDQreThipvd/VYR2Fe7Q2dLgZVzk=;
        b=odRoTs6KpTK4jtBijzq2dtsnZD5bUpg+rXkjUHTJM2SLztQFrPW+AzGKz7cL5/vcE0
         7iaKfNzGfyA3AMTzv429DB0+89y53zoNyK2O96hn9XUsZKosb4EZ9XmulvxdtfoiVKts
         cFErCIuod4h+6EzcGtLx4b0LGexuWNI844Y7baCXMg2zaxVMOXNs94z7YD5LKgrOMrKN
         dqT5DAtEpjnJzA9On8v7wgjUNkklqM0KC14U06Zzp7MnQ2t+6iw345BqMG2rVY0Q5d16
         p4G+84WoINC4WWm52/1SE/zAinqkj2nPNWlGySDrQPCLvpURejKm2zC8VoYkaR74yrlY
         Mh4A==
X-Gm-Message-State: AOAM530NXxrZjv9bl1SR8D/nIuGnfjDYGS9hIv81w6WhJ1G7PdDAzz16
        LP9JEZHTLFWnn/bhsUukpflCH3T6n5XfkA==
X-Google-Smtp-Source: ABdhPJylLR2SeV6sR3ixfsV98CC+Br7X69YBjuy1phW4noImDyh1/eSGN6kcZuTP/bIbr6MgvUNkbw==
X-Received: by 2002:a2e:9241:0:b0:24b:63e8:1cd with SMTP id v1-20020a2e9241000000b0024b63e801cdmr2649239ljg.390.1649678799971;
        Mon, 11 Apr 2022 05:06:39 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id s10-20020a19ad4a000000b0044826a25a2esm3297627lfd.292.2022.04.11.05.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 05:06:38 -0700 (PDT)
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
Subject: [PATCH v4 net-next 2/3] net: dsa: Add support for offloading tc matchall with drop target
Date:   Mon, 11 Apr 2022 14:06:32 +0200
Message-Id: <20220411120633.40054-3-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220411120633.40054-1-mattias.forsblad@gmail.com>
References: <20220411120633.40054-1-mattias.forsblad@gmail.com>
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
 include/net/dsa.h       |  14 +++
 include/net/switchdev.h |   2 +
 net/dsa/dsa2.c          |   2 +
 net/dsa/dsa_priv.h      |   2 +
 net/dsa/port.c          |  14 +++
 net/dsa/slave.c         | 233 +++++++++++++++++++++++++++++++++++++++-
 6 files changed, 264 insertions(+), 3 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 52b6da7d45b3..009a03889d7c 100644
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
@@ -234,13 +243,17 @@ struct dsa_mall_tc_entry {
 	union {
 		struct dsa_mall_mirror_tc_entry mirror;
 		struct dsa_mall_policer_tc_entry policer;
+		struct dsa_mall_drop_tc_entry drop;
 	};
 };
 
 struct dsa_bridge {
 	struct net_device *dev;
+	struct dsa_switch_tree *dst;
 	unsigned int num;
 	bool tx_fwd_offload;
+	bool local_rcv:1;
+	bool local_rcv_effective:1;
 	refcount_t refcount;
 	u8 have_foreign:1;
 };
@@ -1035,6 +1048,7 @@ struct dsa_switch_ops {
 	int	(*port_policer_add)(struct dsa_switch *ds, int port,
 				    struct dsa_mall_policer_tc_entry *policer);
 	void	(*port_policer_del)(struct dsa_switch *ds, int port);
+	int	(*bridge_local_rcv)(struct dsa_switch *ds, struct dsa_bridge *bridge);
 	int	(*port_setup_tc)(struct dsa_switch *ds, int port,
 				 enum tc_setup_type type, void *type_data);
 
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index aa0171d5786d..0dd9a870547a 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -31,6 +31,7 @@ enum switchdev_attr_id {
 	SWITCHDEV_ATTR_ID_BRIDGE_MST,
 	SWITCHDEV_ATTR_ID_MRP_PORT_ROLE,
 	SWITCHDEV_ATTR_ID_VLAN_MSTI,
+	SWITCHDEV_ATTR_ID_BRIDGE_LOCAL_RCV,
 };
 
 struct switchdev_mst_state {
@@ -66,6 +67,7 @@ struct switchdev_attr {
 		bool mc_disabled;			/* MC_DISABLED */
 		u8 mrp_port_role;			/* MRP_PORT_ROLE */
 		struct switchdev_vlan_msti vlan_msti;	/* VLAN_MSTI */
+		u8 local_rcv;				/* BRIDGE_LOCAL_RCV */
 	} u;
 };
 
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index ca6af86964bc..2bb53ec436da 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -247,6 +247,8 @@ static struct dsa_switch_tree *dsa_tree_alloc(int index)
 	INIT_LIST_HEAD(&dst->list);
 	list_add_tail(&dst->list, &dsa_tree_list);
 
+	INIT_LIST_HEAD(&dst->tc_indr_block_list);
+
 	kref_init(&dst->refcount);
 
 	return dst;
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index d610776ecd76..bb3fc785731f 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -321,6 +321,8 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu);
 int dsa_slave_manage_vlan_filtering(struct net_device *dev,
 				    bool vlan_filtering);
 int dsa_bridge_foreign_dev_update(struct net_device *bridge_dev);
+int dsa_setup_bridge_tc_indr(struct dsa_bridge *bridge);
+void dsa_cleanup_bridge_tc_indr(struct dsa_bridge *bridge);
 
 static inline struct dsa_port *dsa_slave_to_port(const struct net_device *dev)
 {
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 32d472a82241..9dbeeea76ef3 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -361,6 +361,9 @@ static int dsa_port_bridge_create(struct dsa_port *dp,
 	refcount_set(&bridge->refcount, 1);
 
 	bridge->dev = br;
+	bridge->local_rcv = true;
+	bridge->local_rcv_effective = true;
+	bridge->dst = dp->ds->dst;
 
 	bridge->num = dsa_bridge_num_get(br, ds->max_num_bridges);
 	if (ds->max_num_bridges && !bridge->num) {
@@ -372,6 +375,8 @@ static int dsa_port_bridge_create(struct dsa_port *dp,
 
 	dp->bridge = bridge;
 
+	dsa_setup_bridge_tc_indr(bridge);
+
 	return 0;
 }
 
@@ -388,6 +393,8 @@ static void dsa_port_bridge_destroy(struct dsa_port *dp,
 	if (bridge->num)
 		dsa_bridge_num_put(br, bridge->num);
 
+	dsa_cleanup_bridge_tc_indr(bridge);
+
 	kfree(bridge);
 }
 
@@ -602,8 +609,15 @@ int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
 	if (err)
 		goto err_bridge_join;
 
+	err = dsa_bridge_foreign_dev_update(bridge_dev);
+	if (err)
+		goto err_foreign_update;
+
 	return 0;
 
+err_foreign_update:
+	dsa_port_pre_bridge_leave(dp, bridge_dev);
+	dsa_port_bridge_leave(dp, bridge_dev);
 err_bridge_join:
 	dsa_port_notify(dp, DSA_NOTIFIER_LAG_LEAVE, &info);
 err_lag_join:
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index feaf64564c6e..d3872fa0479d 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1246,6 +1246,82 @@ dsa_slave_add_cls_matchall_mirred(struct net_device *dev,
 	return err;
 }
 
+static void
+dsa_slave_bridge_local_rcv_offload_notify(struct dsa_bridge *bridge, bool local_rcv)
+{
+	struct switchdev_attr attr = {
+		.orig_dev = bridge->dev,
+		.id = SWITCHDEV_ATTR_ID_BRIDGE_LOCAL_RCV,
+		.flags = SWITCHDEV_F_DEFER,
+		.u.local_rcv = local_rcv,
+	};
+
+	switchdev_port_attr_set(bridge->dev, &attr, NULL);
+}
+
+static int dsa_slave_bridge_local_rcv_offload(struct net_device *dev,
+					      struct dsa_mall_drop_tc_entry *drop)
+{
+	struct dsa_port *dp = NULL;
+	int new_local_rcv;
+	int err;
+
+	if (!dsa_slave_dev_check(dev))
+		return 0;
+
+	dp = dsa_slave_to_port(dev);
+	if (!dp || !dp->bridge)
+		return 0;
+
+	new_local_rcv = dp->bridge->local_rcv || dp->bridge->have_foreign;
+	if (new_local_rcv != dp->bridge->local_rcv_effective) {
+		dp->bridge->local_rcv_effective = new_local_rcv;
+		err = dp->ds->ops->bridge_local_rcv(dp->ds, dp->bridge);
+		if (err)
+			return err;
+
+		dsa_slave_bridge_local_rcv_offload_notify(dp->bridge, new_local_rcv);
+	}
+
+	return 0;
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
+	int err;
+
+	if (!ds->ops->bridge_local_rcv)
+		return -EOPNOTSUPP;
+
+	mall_tc_entry = kzalloc(sizeof(*mall_tc_entry), GFP_KERNEL);
+	if (!mall_tc_entry)
+		return -ENOMEM;
+
+	mall_tc_entry->cookie = cls->cookie;
+	mall_tc_entry->type = DSA_PORT_MALL_DROP;
+	drop = &mall_tc_entry->drop;
+	drop->enable = true;
+	dp->bridge->local_rcv = false;
+	err = dsa_slave_bridge_local_rcv_offload(dev, drop);
+	if (err)
+		goto out;
+
+	list_add_tail(&mall_tc_entry->list, &p->mall_tc_list);
+
+out:
+	kfree(mall_tc_entry);
+
+	return err;
+}
+
 static int
 dsa_slave_add_cls_matchall_police(struct net_device *dev,
 				  struct tc_cls_matchall_offload *cls,
@@ -1320,6 +1396,10 @@ static int dsa_slave_add_cls_matchall(struct net_device *dev,
 	else if (flow_offload_has_one_action(&cls->rule->action) &&
 		 cls->rule->action.entries[0].id == FLOW_ACTION_POLICE)
 		err = dsa_slave_add_cls_matchall_police(dev, cls, ingress);
+	else if (flow_offload_has_one_action(&cls->rule->action) &&
+		 cls->rule->action.entries[0].id == FLOW_ACTION_DROP &&
+		 cls->common.prio == 1)
+		err = dsa_slave_add_cls_matchall_drop(dev, cls, ingress);
 
 	return err;
 }
@@ -1347,6 +1427,13 @@ static void dsa_slave_del_cls_matchall(struct net_device *dev,
 		if (ds->ops->port_policer_del)
 			ds->ops->port_policer_del(ds, dp->index);
 		break;
+	case DSA_PORT_MALL_DROP:
+		if (!dp->bridge)
+			return;
+		dp->bridge->local_rcv = true;
+		mall_tc_entry->drop.enable = false;
+		dsa_slave_bridge_local_rcv_offload(dev, &mall_tc_entry->drop);
+		break;
 	default:
 		WARN_ON(1);
 	}
@@ -1430,7 +1517,8 @@ static int dsa_slave_setup_tc_cls_flower(struct net_device *dev,
 	}
 }
 
-static int dsa_slave_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
+static int dsa_slave_setup_tc_block_cb(enum tc_setup_type type,
+				       void *cls,
 				       void *cb_priv, bool ingress)
 {
 	struct net_device *dev = cb_priv;
@@ -1440,9 +1528,9 @@ static int dsa_slave_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 
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
@@ -1514,6 +1602,133 @@ static int dsa_slave_setup_ft_block(struct dsa_switch *ds, int port,
 	return master->netdev_ops->ndo_setup_tc(master, TC_SETUP_FT, type_data);
 }
 
+static LIST_HEAD(dsa_slave_block_indr_cb_list);
+
+struct dsa_slave_indr_block_cb_priv {
+	struct dsa_bridge *bridge;
+	struct list_head list;
+};
+
+static int dsa_slave_setup_bridge_block_cb(enum tc_setup_type type,
+					   void *type_data,
+					   void *cb_priv)
+{
+	struct dsa_slave_indr_block_cb_priv *priv = cb_priv;
+	struct tc_cls_matchall_offload *cls;
+	struct dsa_switch_tree *dst;
+	struct dsa_port *dp;
+	int ret = 0;
+
+	cls = (struct tc_cls_matchall_offload *)type_data;
+
+	list_for_each_entry(dst, &dsa_tree_list, list) {
+		dsa_tree_for_each_user_port(dp, dst) {
+			if (dsa_port_offloads_bridge_dev(dp, priv->bridge->dev))
+				ret += dsa_slave_setup_tc_block_cb(type, cls, dp->slave, true);
+		}
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
+		if (cb_priv->bridge->dev == netdev)
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
+				     struct dsa_bridge *bridge,
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
+		if (netdev != bridge->dev)
+			return 0;
+
+		cb_priv = kmalloc(sizeof(*cb_priv), GFP_KERNEL);
+		if (!cb_priv)
+			return -ENOMEM;
+
+		cb_priv->bridge = bridge;
+		list_add(&cb_priv->list, &bridge->dst->tc_indr_block_list);
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
+		cb_priv = dsa_slave_tc_indr_block_cb_lookup(bridge->dst, netdev);
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
@@ -1535,6 +1750,17 @@ static int dsa_slave_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	return ds->ops->port_setup_tc(ds, dp->index, type, type_data);
 }
 
+int dsa_setup_bridge_tc_indr(struct dsa_bridge *bridge)
+{
+	return flow_indr_dev_register(dsa_slave_setup_bridge_tc_indr_cb, bridge);
+}
+
+void dsa_cleanup_bridge_tc_indr(struct dsa_bridge *bridge)
+{
+	flow_indr_dev_unregister(dsa_slave_setup_bridge_tc_indr_cb,
+				 bridge, dsa_slave_setup_tc_indr_rel);
+}
+
 static int dsa_slave_get_rxnfc(struct net_device *dev,
 			       struct ethtool_rxnfc *nfc, u32 *rule_locs)
 {
@@ -2943,6 +3169,7 @@ int dsa_bridge_foreign_dev_update(struct net_device *bridge_dev)
 	}
 
 	bridge->have_foreign = have_foreign;
+	dsa_slave_bridge_local_rcv_offload(first_slave, NULL);
 
 	return 0;
 }
-- 
2.25.1

