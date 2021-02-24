Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A27323B69
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 12:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235006AbhBXLpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 06:45:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234255AbhBXLop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 06:44:45 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6756C06178A
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:04 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id do6so2540656ejc.3
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KWneYLD92B29Pm4MbtcfzLvL38NMVW53l3jrfht4vLQ=;
        b=XYLK2JlnY2C/rvYN0IIR69tZ2IuiXLZ8tUNaJBTmrHEXaJwLGxf5IBCVtqEnkuHNbq
         6QtiOEuRQur+LRwlGbLxr9DaDBzJ0MkOAaOhVPduMvDKO/GBr06Gps2mpeAHiZ/6DphZ
         oEANipBB3It1kYR86gInXBBSi+5FzhqiWINhs6l1Z+9x3oUx7BYFAuKm7Deu2Iq0Rg4q
         1R1mNTetHTA5jmyffSdBBQsmIZ2kUSbspEcsgN7yO64LbGOBVG41fxEmuf6foU2pH+rB
         j57Qbup90DOSxB0Mj8JYR+DQfEEZF0saY1yGGjS11uRI3lZR6ZU6tV7gSFxdsL6lkE5Y
         zxyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KWneYLD92B29Pm4MbtcfzLvL38NMVW53l3jrfht4vLQ=;
        b=dLk3BssWv585H2XnAbH60xnlGTxU6v1TXPr/5GUZd5JqweptBTZBfadS4uzqfGe+g6
         zHnc/LdQeYKjO43N1FksTvFBdxs+rCnn1wtOR+2eHNPElE71h9Szyxcvk5IX4PfzhpVV
         /GOpmYW3eUrv8Zc/YSei6X0XVy/Nat/tlGYa6V3ycNH0+ElrY3Bqbuf0aiaHLkOgtoRF
         9j5JuBfkxpgm+hVTtkiYiFpGMEuMl6DsDN9KKKJQjDCgtGr+rnXXC0J9FpzALSzy/4dI
         nBm5fJ0U1Y1F/IklZpZ9icAQaxkQV4G/Ejtajn9YlDs3UnhPS+LlfixDD2xGGLEaN5Mv
         0+0A==
X-Gm-Message-State: AOAM533rvrDXHB0OqDHOYgpLUknpH1sypxRrYUsDLOBjWJjCFVUFKa7I
        i/3zHs1ugZElkjPIsR0SZPMyaVen1Do=
X-Google-Smtp-Source: ABdhPJyphBuIWf/7ls//YBaQeTfr2HYSLjKvPfyuhVJfMAvX66CGN+pcLCFW/GYKg6YYgfbaGohBfQ==
X-Received: by 2002:a17:907:3e8d:: with SMTP id hs13mr4813522ejc.36.1614167043287;
        Wed, 24 Feb 2021 03:44:03 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id r5sm1203921ejx.96.2021.02.24.03.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 03:44:02 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [RFC PATCH v2 net-next 02/17] net: dsa: reference count the host fdb addresses
Date:   Wed, 24 Feb 2021 13:43:35 +0200
Message-Id: <20210224114350.2791260-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210224114350.2791260-1-olteanv@gmail.com>
References: <20210224114350.2791260-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In preparation of unicast filtering towards the CPU, DSA will need to
send to the CPU several classes of addresses:
- local FDB entries from the bridge
- FDB entries pointing to the software bridge itself
- the MAC addresses used for termination in standalone mode
- the MAC addresses of various upper interfaces (8021q, macvlan) that
  DSA ports might have

So it will no longer be sufficient to gather the address list from a
single source such as the bridge. Consider the fact that the bridge
currently records the MAC address of every bridge port as a local
('permanent') address placed in the FDB. Sure we could use that as an
indication that the address must be sent to the CPU, but that address
needs to be sent to the CPU anyway, even if we're operating in
standalone mode. So the bridge can't dictate anything, we must keep more
addresses, and if we do that, there is a risk that we might delete an
address when it was still used, if we just listen to the deletion event
emitted by the bridge through switchdev. And that is where the
requirement for reference counting comes from.

Similar to host MDB entries, we should create a new notifier in DSA, and
keep the existing one for out-facing FDB entries untouched. We can also
simplify dsa_slave_switchdev_event_work a little bit now, since we
always schedule the work item for a user port now, we can unconditionally
take the refcount on a net_device.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h  |  1 +
 net/dsa/dsa2.c     |  6 ++++
 net/dsa/dsa_priv.h |  7 ++++
 net/dsa/port.c     | 27 ++++++++++++++
 net/dsa/slave.c    | 88 +++++++++++++++++++++++++++++++++++++++++-----
 net/dsa/switch.c   | 50 ++++++++++++++++++++++++++
 6 files changed, 170 insertions(+), 9 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 31381bfcf35c..0210b49f291e 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -293,6 +293,7 @@ struct dsa_port {
 	/* List of MAC addresses that must be extracted from the fabric
 	 * through this CPU port. Valid only for DSA_PORT_TYPE_CPU.
 	 */
+	struct list_head	host_fdb;
 	struct list_head	host_mdb;
 
 	bool setup;
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index d64f1287625d..27654cac1c61 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -328,6 +328,7 @@ static struct dsa_port *dsa_tree_find_first_cpu(struct dsa_switch_tree *dst)
 
 static void dsa_setup_cpu_port(struct dsa_port *cpu_dp)
 {
+	INIT_LIST_HEAD(&cpu_dp->host_fdb);
 	INIT_LIST_HEAD(&cpu_dp->host_mdb);
 }
 
@@ -355,6 +356,11 @@ static void dsa_teardown_cpu_port(struct dsa_port *cpu_dp)
 {
 	struct dsa_host_addr *a, *tmp;
 
+	list_for_each_entry_safe(a, tmp, &cpu_dp->host_fdb, list) {
+		list_del(&a->list);
+		kfree(a);
+	}
+
 	list_for_each_entry_safe(a, tmp, &cpu_dp->host_mdb, list) {
 		list_del(&a->list);
 		kfree(a);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index c730d40b81b9..4043da2bacc0 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -20,6 +20,8 @@ enum {
 	DSA_NOTIFIER_BRIDGE_LEAVE,
 	DSA_NOTIFIER_FDB_ADD,
 	DSA_NOTIFIER_FDB_DEL,
+	DSA_NOTIFIER_HOST_FDB_ADD,
+	DSA_NOTIFIER_HOST_FDB_DEL,
 	DSA_NOTIFIER_HSR_JOIN,
 	DSA_NOTIFIER_HSR_LEAVE,
 	DSA_NOTIFIER_LAG_CHANGE,
@@ -121,6 +123,7 @@ struct dsa_switchdev_event_work {
 	 */
 	unsigned char addr[ETH_ALEN];
 	u16 vid;
+	bool host_addr;
 };
 
 /* DSA_NOTIFIER_HSR_* */
@@ -200,6 +203,10 @@ int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 		     u16 vid);
 int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 		     u16 vid);
+int dsa_port_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
+			  u16 vid);
+int dsa_port_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
+			  u16 vid);
 int dsa_port_fdb_dump(struct dsa_port *dp, dsa_fdb_dump_cb_t *cb, void *data);
 int dsa_port_mdb_add(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index df9ba9b67675..d9ff222c041c 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -503,6 +503,33 @@ int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 	return dsa_port_notify(dp, DSA_NOTIFIER_FDB_DEL, &info);
 }
 
+int dsa_port_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
+			  u16 vid)
+{
+	struct dsa_notifier_fdb_info info = {
+		.sw_index = dp->ds->index,
+		.port = dp->index,
+		.addr = addr,
+		.vid = vid,
+	};
+
+	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_ADD, &info);
+}
+
+int dsa_port_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
+			  u16 vid)
+{
+	struct dsa_notifier_fdb_info info = {
+		.sw_index = dp->ds->index,
+		.port = dp->index,
+		.addr = addr,
+		.vid = vid,
+
+	};
+
+	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_DEL, &info);
+}
+
 int dsa_port_fdb_dump(struct dsa_port *dp, dsa_fdb_dump_cb_t *cb, void *data)
 {
 	struct dsa_switch *ds = dp->ds;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 14a51503efe0..12d51bdb5eea 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -102,6 +102,67 @@ static int dsa_host_mdb_del(struct dsa_port *dp,
 	return 0;
 }
 
+static int dsa_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
+			    u16 vid)
+{
+	struct dsa_port *cpu_dp = dp->cpu_dp;
+	struct dsa_host_addr *a;
+	int err;
+
+	if (!dp->ds->ops->port_fdb_add || !dp->ds->ops->port_fdb_del)
+		return -EOPNOTSUPP;
+
+	a = dsa_host_addr_find(&cpu_dp->host_fdb, addr, vid);
+	if (a) {
+		refcount_inc(&a->refcount);
+		return 0;
+	}
+
+	a = kzalloc(sizeof(*a), GFP_KERNEL);
+	if (!a)
+		return -ENOMEM;
+
+	err = dsa_port_host_fdb_add(dp, addr, vid);
+	if (err) {
+		kfree(a);
+		return err;
+	}
+
+	ether_addr_copy(a->addr, addr);
+	a->vid = vid;
+	refcount_set(&a->refcount, 1);
+	list_add_tail(&a->list, &cpu_dp->host_fdb);
+
+	return 0;
+}
+
+static int dsa_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
+			    u16 vid)
+{
+	struct dsa_port *cpu_dp = dp->cpu_dp;
+	struct dsa_host_addr *a;
+	int err;
+
+	if (!dp->ds->ops->port_fdb_add || !dp->ds->ops->port_fdb_del)
+		return -EOPNOTSUPP;
+
+	a = dsa_host_addr_find(&cpu_dp->host_fdb, addr, vid);
+	if (!a)
+		return -ENOENT;
+
+	if (!refcount_dec_and_test(&a->refcount))
+		return 0;
+
+	err = dsa_port_host_fdb_del(dp, addr, vid);
+	if (err)
+		return err;
+
+	list_del(&a->list);
+	kfree(a);
+
+	return 0;
+}
+
 /* slave mii_bus handling ***************************************************/
 static int dsa_slave_phy_read(struct mii_bus *bus, int addr, int reg)
 {
@@ -2264,8 +2325,12 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 	rtnl_lock();
 	switch (switchdev_work->event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-		err = dsa_port_fdb_add(dp, switchdev_work->addr,
-				       switchdev_work->vid);
+		if (switchdev_work->host_addr)
+			err = dsa_host_fdb_add(dp, switchdev_work->addr,
+					       switchdev_work->vid);
+		else
+			err = dsa_port_fdb_add(dp, switchdev_work->addr,
+					       switchdev_work->vid);
 		if (err) {
 			dev_err(ds->dev,
 				"port %d failed to add %pM vid %d to fdb: %d\n",
@@ -2277,8 +2342,12 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 		break;
 
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		err = dsa_port_fdb_del(dp, switchdev_work->addr,
-				       switchdev_work->vid);
+		if (switchdev_work->host_addr)
+			err = dsa_host_fdb_del(dp, switchdev_work->addr,
+					       switchdev_work->vid);
+		else
+			err = dsa_port_fdb_del(dp, switchdev_work->addr,
+					       switchdev_work->vid);
 		if (err) {
 			dev_err(ds->dev,
 				"port %d failed to delete %pM vid %d from fdb: %d\n",
@@ -2291,8 +2360,7 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 	rtnl_unlock();
 
 	kfree(switchdev_work);
-	if (dsa_is_user_port(ds, dp->index))
-		dev_put(dp->slave);
+	dev_put(dp->slave);
 }
 
 static int dsa_lower_dev_walk(struct net_device *lower_dev,
@@ -2324,6 +2392,7 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
 	const struct switchdev_notifier_fdb_info *fdb_info;
 	struct dsa_switchdev_event_work *switchdev_work;
+	bool host_addr = false;
 	struct dsa_port *dp;
 	int err;
 
@@ -2361,7 +2430,8 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 			if (!p)
 				return NOTIFY_DONE;
 
-			dp = p->dp->cpu_dp;
+			dp = p->dp;
+			host_addr = true;
 
 			if (!dp->ds->assisted_learning_on_cpu_port)
 				return NOTIFY_DONE;
@@ -2391,10 +2461,10 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 		ether_addr_copy(switchdev_work->addr,
 				fdb_info->addr);
 		switchdev_work->vid = fdb_info->vid;
+		switchdev_work->host_addr = host_addr;
 
 		/* Hold a reference on the slave for dsa_fdb_offload_notify */
-		if (dsa_is_user_port(dp->ds, dp->index))
-			dev_hold(dev);
+		dev_hold(dev);
 		dsa_schedule_work(&switchdev_work->work);
 		break;
 	default:
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 94996e213469..a89363117f6f 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -167,6 +167,50 @@ static bool dsa_switch_host_address_match(struct dsa_switch *ds, int port,
 	return false;
 }
 
+static int dsa_switch_host_fdb_add(struct dsa_switch *ds,
+				   struct dsa_notifier_fdb_info *info)
+{
+	int err = 0;
+	int port;
+
+	if (!ds->ops->port_fdb_add)
+		return -EOPNOTSUPP;
+
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_switch_host_address_match(ds, port, info->sw_index,
+						  info->port)) {
+			err = ds->ops->port_fdb_add(ds, port, info->addr,
+						    info->vid);
+			if (err)
+				break;
+		}
+	}
+
+	return err;
+}
+
+static int dsa_switch_host_fdb_del(struct dsa_switch *ds,
+				   struct dsa_notifier_fdb_info *info)
+{
+	int err = 0;
+	int port;
+
+	if (!ds->ops->port_fdb_del)
+		return -EOPNOTSUPP;
+
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_switch_host_address_match(ds, port, info->sw_index,
+						  info->port)) {
+			err = ds->ops->port_fdb_del(ds, info->port, info->addr,
+						    info->vid);
+			if (err)
+				break;
+		}
+	}
+
+	return err;
+}
+
 static int dsa_switch_fdb_add(struct dsa_switch *ds,
 			      struct dsa_notifier_fdb_info *info)
 {
@@ -526,6 +570,12 @@ static int dsa_switch_event(struct notifier_block *nb,
 	case DSA_NOTIFIER_FDB_DEL:
 		err = dsa_switch_fdb_del(ds, info);
 		break;
+	case DSA_NOTIFIER_HOST_FDB_ADD:
+		err = dsa_switch_host_fdb_add(ds, info);
+		break;
+	case DSA_NOTIFIER_HOST_FDB_DEL:
+		err = dsa_switch_host_fdb_del(ds, info);
+		break;
 	case DSA_NOTIFIER_HSR_JOIN:
 		err = dsa_switch_hsr_join(ds, info);
 		break;
-- 
2.25.1

