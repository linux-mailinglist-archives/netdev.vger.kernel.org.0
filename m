Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2630323B73
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 12:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235045AbhBXLsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 06:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235037AbhBXLqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 06:46:14 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD7AC06121D
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:18 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id mm21so2245732ejb.12
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EABo2wmdvoZSCpRCQk6mPqSgnBg7SprnKIxoTK9v1D4=;
        b=tbvCYZ/zIiN7JvdefxIII4/xvgeV5BMidpeNv4UoAU1B/L0s+62Rw2iYKZhn0DeuAI
         phzrKzAo2uTkmhalZ9G6nKAFZ4czt8XCIInBWEu+62JS4h6ddRCOfAz86f9PJWfn1afU
         QA3tXA1flQQY5urirscFGEtbEAT4ww7K1mfCgwPwYkBgqJu2q46HizrlxeNKtfICM0Ni
         X6ICYjTJKIFqjh8yMtJPoK3g5DXPMcmwi35sNxiIz+A8B6ezcpVmqzSa0h0xMsUEC05Z
         8yeq8hhtRKZieOJwl+V53N0mROCtZFMx/ndURPaswv/hyQPHBa4lFOuP9YlzXeAvCIN3
         Qm3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EABo2wmdvoZSCpRCQk6mPqSgnBg7SprnKIxoTK9v1D4=;
        b=IfwI38w9wyJhYd/cIXs9Eim4DG7LztfM/glqGChdHdfC0XA1Hns7BZSdzfATUbtmV3
         cWGbQa2hPbQ8Iu3UdvEZc9s00dZKIPfQJOgMXp21ZvSFg6BGshRfOCtfUAaldV09uf2I
         vqjBTbvfEgUD6GaK/HM/JrwT+2LI0/uxQ3+QR+FXbwPfqdGMRaypL8NZhhgSf9RJvv26
         DrFYf3lnTM9zdmJZfqPUzv6w2Y8TwK2bIHEoFNnoq5PQw1a9WZgNi1XYlC9S4d7l7g36
         zdsMpxpDwmAdgmNE8pVU2YXYIydTcs5D9HYGJ22c33qeT0qmSoqlXXip7fomS3W7HhH8
         pjgw==
X-Gm-Message-State: AOAM533AemrQ80djUWM5t+ixuZ2Yl50svxDwJx0uKfnb6gkC/bLKZfOm
        6SNFcwX/WaHrGbFUSGxdeRgp4aT9L7k=
X-Google-Smtp-Source: ABdhPJxKSpZCud710deOk/36uWpJF5ejX7gK6d3dCAsdVqMmboSS1XUeXy+SkuSkUDNlNKjWl/jSLg==
X-Received: by 2002:a17:907:2da5:: with SMTP id gt37mr29474232ejc.324.1614167056539;
        Wed, 24 Feb 2021 03:44:16 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id r5sm1203921ejx.96.2021.02.24.03.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 03:44:16 -0800 (PST)
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
Subject: [RFC PATCH v2 net-next 14/17] net: dsa: replay port and host-joined mdb entries when joining the bridge
Date:   Wed, 24 Feb 2021 13:43:47 +0200
Message-Id: <20210224114350.2791260-15-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210224114350.2791260-1-olteanv@gmail.com>
References: <20210224114350.2791260-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

I have udhcpcd in my system and this is configured to bring interfaces
up as soon as they are created.

I create a bridge as follows:

ip link add br0 type bridge

As soon as I create the bridge and udhcpcd brings it up, I have some
other crap (avahi) that starts sending some random IPv6 packets to
advertise some local services, and from there, the br0 bridge joins the
following IPv6 groups:

33:33:ff:6d:c1:9c vid 0
33:33:00:00:00:6a vid 0
33:33:00:00:00:fb vid 0

br_dev_xmit
-> br_multicast_rcv
   -> br_ip6_multicast_add_group
      -> __br_multicast_add_group
         -> br_multicast_host_join
            -> br_mdb_notify

This is all fine, but inside br_mdb_notify we have br_mdb_switchdev_host
hooked up, and switchdev will attempt to offload the host joined groups
to an empty list of ports. Of course nobody offloads them.

Then when we add a port to br0:

ip link set swp0 master br0

the bridge doesn't replay the host-joined MDB entries from br_add_if,
and eventually the host joined addresses expire, and a switchdev
notification for deleting it is emitted, but surprise, the original
addition was already completely missed.

The strategy to address this problem is to replay the MDB entries (both
the port ones and the host joined ones) when the new port joins the
bridge, similar to what vxlan_fdb_replay does (in that case, its FDB can
be populated and only then attached to a bridge that you offload).
However there are 2 possibilities: the addresses can be 'pushed' by the
bridge into the port, or the port can 'pull' them from the bridge.

Considering that in the general case, the new port can be really late to
the party, and there may have been many other switchdev ports that
already received the initial notification, we would like to avoid
delivering duplicate events to them, since they might misbehave. And
currently, the bridge calls the entire switchdev notifier chain, whereas
for replaying it should just call the notifier block of the new guy.
But the bridge doesn't know what is the new guy's notifier block, it
just knows where the switchdev notifier chain is. So for simplification,
we make this a driver-initiated pull for now, and the notifier block is
passed as an argument.

To emulate the calling context for mdb objects (deferred and put on the
blocking notifier chain), we must iterate under RCU protection through
the bridge's mdb entries, queue them, and only call them once we're out
of the RCU read-side critical section.

Suggested-by: Ido Schimmel <idosch@idosch.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/if_bridge.h |   8 +++
 include/net/switchdev.h   |   1 +
 net/bridge/br_mdb.c       | 117 ++++++++++++++++++++++++++++++++++++++
 net/dsa/slave.c           |  17 +++++-
 4 files changed, 141 insertions(+), 2 deletions(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index b979005ea39c..2f0e5713bf39 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -69,6 +69,8 @@ bool br_multicast_has_querier_anywhere(struct net_device *dev, int proto);
 bool br_multicast_has_querier_adjacent(struct net_device *dev, int proto);
 bool br_multicast_enabled(const struct net_device *dev);
 bool br_multicast_router(const struct net_device *dev);
+int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
+		  struct notifier_block *nb);
 #else
 static inline int br_multicast_list_adjacent(struct net_device *dev,
 					     struct list_head *br_ip_list)
@@ -93,6 +95,12 @@ static inline bool br_multicast_router(const struct net_device *dev)
 {
 	return false;
 }
+static inline int br_mdb_replay(struct net_device *br_dev,
+				struct net_device *dev,
+				struct notifier_block *nb)
+{
+	return -EINVAL;
+}
 #endif
 
 #if IS_ENABLED(CONFIG_BRIDGE) && IS_ENABLED(CONFIG_BRIDGE_VLAN_FILTERING)
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index ca7223a79135..f1a5a9a3634d 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -68,6 +68,7 @@ enum switchdev_obj_id {
 };
 
 struct switchdev_obj {
+	struct list_head list;
 	struct net_device *orig_dev;
 	enum switchdev_obj_id id;
 	u32 flags;
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 8846c5bcd075..170353510c35 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -506,6 +506,123 @@ static void br_mdb_complete(struct net_device *dev, int err, void *priv)
 	kfree(priv);
 }
 
+static int br_mdb_replay_one(struct notifier_block *nb, struct net_device *dev,
+			     struct switchdev_obj_port_mdb *mdb)
+{
+	struct switchdev_notifier_port_obj_info obj_info = {
+		.info = {
+			.dev = dev,
+		},
+		.obj = &mdb->obj,
+	};
+	int err;
+
+	err = nb->notifier_call(nb, SWITCHDEV_PORT_OBJ_ADD, &obj_info);
+	return notifier_to_errno(err);
+}
+
+static int br_mdb_queue_one(struct list_head *mdb_list,
+			    enum switchdev_obj_id id,
+			    struct net_bridge_mdb_entry *mp,
+			    struct net_device *orig_dev)
+{
+	struct switchdev_obj_port_mdb *mdb;
+
+	mdb = kzalloc(sizeof(*mdb), GFP_ATOMIC);
+	if (!mdb)
+		return -ENOMEM;
+
+	mdb->obj.id = id;
+	mdb->obj.orig_dev = orig_dev;
+	mdb->vid = mp->addr.vid;
+
+	if (mp->addr.proto == htons(ETH_P_IP))
+		ip_eth_mc_map(mp->addr.dst.ip4, mdb->addr);
+#if IS_ENABLED(CONFIG_IPV6)
+	else if (mp->addr.proto == htons(ETH_P_IPV6))
+		ipv6_eth_mc_map(&mp->addr.dst.ip6, mdb->addr);
+#endif
+	else
+		ether_addr_copy(mdb->addr, mp->addr.dst.mac_addr);
+
+	list_add_tail(&mdb->obj.list, mdb_list);
+
+	return 0;
+}
+
+int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
+		  struct notifier_block *nb)
+{
+	struct net_bridge_mdb_entry *mp;
+	struct switchdev_obj *obj, *tmp;
+	struct list_head mdb_list;
+	struct net_bridge *br;
+	int err = 0;
+
+	ASSERT_RTNL();
+
+	INIT_LIST_HEAD(&mdb_list);
+
+	if (!netif_is_bridge_master(br_dev))
+		return -EINVAL;
+
+	if (!netif_is_bridge_port(dev))
+		return -EINVAL;
+
+	br = netdev_priv(br_dev);
+
+	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED))
+		return 0;
+
+	rcu_read_lock();
+
+	hlist_for_each_entry_rcu(mp, &br->mdb_list, mdb_node) {
+		struct net_bridge_port_group __rcu **pp;
+		struct net_bridge_port_group *p;
+
+		if (mp->host_joined) {
+			err = br_mdb_queue_one(&mdb_list,
+					       SWITCHDEV_OBJ_ID_HOST_MDB,
+					       mp, br_dev);
+			if (err) {
+				rcu_read_unlock();
+				goto out_free_mdb;
+			}
+		}
+
+		for (pp = &mp->ports; (p = rcu_dereference(*pp)) != NULL;
+		     pp = &p->next) {
+			if (p->key.port->dev != dev)
+				continue;
+
+			err = br_mdb_queue_one(&mdb_list,
+					       SWITCHDEV_OBJ_ID_PORT_MDB,
+					       mp, dev);
+			if (err) {
+				rcu_read_unlock();
+				goto out_free_mdb;
+			}
+		}
+	}
+
+	rcu_read_unlock();
+
+	list_for_each_entry(obj, &mdb_list, list) {
+		err = br_mdb_replay_one(nb, dev, SWITCHDEV_OBJ_PORT_MDB(obj));
+		if (err)
+			goto out_free_mdb;
+	}
+
+out_free_mdb:
+	list_for_each_entry_safe(obj, tmp, &mdb_list, list) {
+		list_del(&obj->list);
+		kfree(SWITCHDEV_OBJ_PORT_MDB(obj));
+	}
+
+	return err;
+}
+EXPORT_SYMBOL(br_mdb_replay);
+
 static void br_mdb_switchdev_host_port(struct net_device *dev,
 				       struct net_device *lower_dev,
 				       struct net_bridge_mdb_entry *mp,
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index a32875d3dc5f..10b4a0f72dcb 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2290,6 +2290,9 @@ bool dsa_slave_dev_check(const struct net_device *dev)
 }
 EXPORT_SYMBOL_GPL(dsa_slave_dev_check);
 
+/* Circular reference */
+static struct notifier_block dsa_slave_switchdev_blocking_notifier;
+
 static int dsa_slave_changeupper(struct net_device *dev,
 				 struct netdev_notifier_changeupper_info *info)
 {
@@ -2297,10 +2300,15 @@ static int dsa_slave_changeupper(struct net_device *dev,
 	int err = NOTIFY_DONE;
 
 	if (netif_is_bridge_master(info->upper_dev)) {
+		struct net_device *bridge_dev = info->upper_dev;
+
 		if (info->linking) {
-			err = dsa_port_bridge_join(dp, info->upper_dev);
-			if (!err)
+			err = dsa_port_bridge_join(dp, bridge_dev);
+			if (!err) {
 				dsa_bridge_mtu_normalization(dp);
+				br_mdb_replay(bridge_dev, dev,
+					      &dsa_slave_switchdev_blocking_notifier);
+			}
 			err = notifier_from_errno(err);
 		} else {
 			dsa_port_bridge_leave(dp, info->upper_dev);
@@ -2361,6 +2369,11 @@ dsa_slave_lag_changeupper(struct net_device *dev,
 			break;
 	}
 
+	if (netif_is_bridge_master(info->upper_dev) && !err) {
+		br_mdb_replay(info->upper_dev, dev,
+			      &dsa_slave_switchdev_blocking_notifier);
+	}
+
 	return err;
 }
 
-- 
2.25.1

