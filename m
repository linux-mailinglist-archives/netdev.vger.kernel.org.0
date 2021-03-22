Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28C234534E
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 00:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhCVXwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 19:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbhCVXwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 19:52:07 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516BDC061756;
        Mon, 22 Mar 2021 16:52:06 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id hq27so24111706ejc.9;
        Mon, 22 Mar 2021 16:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BNvDq+x5CxEA4hEvtyw+m92SUzw5QJRpJT5L5Ues/LY=;
        b=Yw6J3YU91PE3S7nRGRtFPukroEe3a29Qwcg1bbbRodpIsgpsrshXdOBtQPviUOcDWW
         ivKTXsdAueqsPEWF+ghn6RQbvlMoWooZQgMjUpZ6VtJgKNd3tMeJAykemZ//kPZc2jZA
         1QXB+e21mGR3pFlJgsmCnERytFrJlho8P61D+GMS1NqN5j888G8DmChmIbHaoJ4FQEep
         UtCkMyi1y3CkmfN+Qb/SLGsY29Yx6e4bfMFBy5JbBb9FjiAZvxa0fS9EC0FyLTOKKzjJ
         JR39FpYTmAUZslY2psg+K+ubdV/qJ+UGWh8DI3X8Adby4zsLgCxtwC5XNKYoOcN9c5UX
         8Ljw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BNvDq+x5CxEA4hEvtyw+m92SUzw5QJRpJT5L5Ues/LY=;
        b=B719mdj1ztbt7h5Izg3Re5kUZRaF0wi8PDOphuIVvaNl8gApD2d/BOieHCLHD91yqq
         MniqxiWD/CgDlTlwdQ369gJBy0QJCzmuNJAAytplp9jgItGjUjd7yOi687Sa9ajyithG
         c+cjRVKA6QQ5SjkT43oUWjUR+vSx3DZqK29RHBeLNnS776shTczzjT+kVTJO2F3JhlQy
         hbNoVlvZmhG9UhPmnCpnfn4hUtk5+JjFim+eZfXqFhpVl++JRJvyVu95kCxrA3JyIs6b
         IVO4Ux4f4bLIHIn9oeyCE74p1TlUNQzo6+z7BaThLVmANn+mpPrgB2cxlwC0gF+Zz1gt
         IgKA==
X-Gm-Message-State: AOAM530fFAUougrtaqlS63C7siHQoqDAoyiNM2T16ukH1VkBmSX6tseV
        gb7aJfBNqtiOfam6CkfyKn0=
X-Google-Smtp-Source: ABdhPJwe1lKNo4oFMnfLTrr2BoV1MCJEZMkuqJrV57E2eGPk3w7Su+AjGvYLL+OIyzI0CR0FXpCzHA==
X-Received: by 2002:a17:906:5e01:: with SMTP id n1mr2123334eju.359.1616457125062;
        Mon, 22 Mar 2021 16:52:05 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id q16sm12436933edv.61.2021.03.22.16.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 16:52:04 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Ivan Vecera <ivecera@redhat.com>,
        linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v4 net-next 03/11] net: bridge: add helper to replay port and host-joined mdb entries
Date:   Tue, 23 Mar 2021 01:51:44 +0200
Message-Id: <20210322235152.268695-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210322235152.268695-1-olteanv@gmail.com>
References: <20210322235152.268695-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

I have a system with DSA ports, and udhcpcd is configured to bring
interfaces up as soon as they are created.

I create a bridge as follows:

ip link add br0 type bridge

As soon as I create the bridge and udhcpcd brings it up, I also have
avahi which automatically starts sending IPv6 packets to advertise some
local services, and because of that, the br0 bridge joins the following
IPv6 groups due to the code path detailed below:

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

There was some opportunity for reuse between br_mdb_switchdev_host_port,
br_mdb_notify and the newly added br_mdb_queue_one in how the switchdev
mdb object is created, so a helper was created.

Suggested-by: Ido Schimmel <idosch@idosch.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/if_bridge.h |   9 +++
 include/net/switchdev.h   |   1 +
 net/bridge/br_mdb.c       | 148 +++++++++++++++++++++++++++++++++-----
 3 files changed, 141 insertions(+), 17 deletions(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index ebd16495459c..f6472969bb44 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -69,6 +69,8 @@ bool br_multicast_has_querier_anywhere(struct net_device *dev, int proto);
 bool br_multicast_has_querier_adjacent(struct net_device *dev, int proto);
 bool br_multicast_enabled(const struct net_device *dev);
 bool br_multicast_router(const struct net_device *dev);
+int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
+		  struct notifier_block *nb, struct netlink_ext_ack *extack);
 #else
 static inline int br_multicast_list_adjacent(struct net_device *dev,
 					     struct list_head *br_ip_list)
@@ -93,6 +95,13 @@ static inline bool br_multicast_router(const struct net_device *dev)
 {
 	return false;
 }
+static inline int br_mdb_replay(struct net_device *br_dev,
+				struct net_device *dev,
+				struct notifier_block *nb,
+				struct netlink_ext_ack *extack)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #if IS_ENABLED(CONFIG_BRIDGE) && IS_ENABLED(CONFIG_BRIDGE_VLAN_FILTERING)
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index b7fc7d0f54e2..8c3218177136 100644
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
index 8846c5bcd075..95fa4af0e8dd 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -506,6 +506,134 @@ static void br_mdb_complete(struct net_device *dev, int err, void *priv)
 	kfree(priv);
 }
 
+static void br_switchdev_mdb_populate(struct switchdev_obj_port_mdb *mdb,
+				      const struct net_bridge_mdb_entry *mp)
+{
+	if (mp->addr.proto == htons(ETH_P_IP))
+		ip_eth_mc_map(mp->addr.dst.ip4, mdb->addr);
+#if IS_ENABLED(CONFIG_IPV6)
+	else if (mp->addr.proto == htons(ETH_P_IPV6))
+		ipv6_eth_mc_map(&mp->addr.dst.ip6, mdb->addr);
+#endif
+	else
+		ether_addr_copy(mdb->addr, mp->addr.dst.mac_addr);
+
+	mdb->vid = mp->addr.vid;
+}
+
+static int br_mdb_replay_one(struct notifier_block *nb, struct net_device *dev,
+			     struct switchdev_obj_port_mdb *mdb,
+			     struct netlink_ext_ack *extack)
+{
+	struct switchdev_notifier_port_obj_info obj_info = {
+		.info = {
+			.dev = dev,
+			.extack = extack,
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
+			    const struct net_bridge_mdb_entry *mp,
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
+	br_switchdev_mdb_populate(mdb, mp);
+	list_add_tail(&mdb->obj.list, mdb_list);
+
+	return 0;
+}
+
+int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
+		  struct notifier_block *nb, struct netlink_ext_ack *extack)
+{
+	struct net_bridge_mdb_entry *mp;
+	struct switchdev_obj *obj, *tmp;
+	struct net_bridge *br;
+	LIST_HEAD(mdb_list);
+	int err = 0;
+
+	ASSERT_RTNL();
+
+	if (!netif_is_bridge_master(br_dev) || !netif_is_bridge_port(dev))
+		return -EINVAL;
+
+	br = netdev_priv(br_dev);
+
+	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED))
+		return 0;
+
+	/* We cannot walk over br->mdb_list protected just by the rtnl_mutex,
+	 * because the write-side protection is br->multicast_lock. But we
+	 * need to emulate the [ blocking ] calling context of a regular
+	 * switchdev event, so since both br->multicast_lock and RCU read side
+	 * critical sections are atomic, we have no choice but to pick the RCU
+	 * read side lock, queue up all our events, leave the critical section
+	 * and notify switchdev from blocking context.
+	 */
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
+		err = br_mdb_replay_one(nb, dev, SWITCHDEV_OBJ_PORT_MDB(obj),
+					extack);
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
+EXPORT_SYMBOL_GPL(br_mdb_replay);
+
 static void br_mdb_switchdev_host_port(struct net_device *dev,
 				       struct net_device *lower_dev,
 				       struct net_bridge_mdb_entry *mp,
@@ -515,18 +643,12 @@ static void br_mdb_switchdev_host_port(struct net_device *dev,
 		.obj = {
 			.id = SWITCHDEV_OBJ_ID_HOST_MDB,
 			.flags = SWITCHDEV_F_DEFER,
+			.orig_dev = dev,
 		},
-		.vid = mp->addr.vid,
 	};
 
-	if (mp->addr.proto == htons(ETH_P_IP))
-		ip_eth_mc_map(mp->addr.dst.ip4, mdb.addr);
-#if IS_ENABLED(CONFIG_IPV6)
-	else
-		ipv6_eth_mc_map(&mp->addr.dst.ip6, mdb.addr);
-#endif
+	br_switchdev_mdb_populate(&mdb, mp);
 
-	mdb.obj.orig_dev = dev;
 	switch (type) {
 	case RTM_NEWMDB:
 		switchdev_port_obj_add(lower_dev, &mdb.obj, NULL);
@@ -558,21 +680,13 @@ void br_mdb_notify(struct net_device *dev,
 			.id = SWITCHDEV_OBJ_ID_PORT_MDB,
 			.flags = SWITCHDEV_F_DEFER,
 		},
-		.vid = mp->addr.vid,
 	};
 	struct net *net = dev_net(dev);
 	struct sk_buff *skb;
 	int err = -ENOBUFS;
 
 	if (pg) {
-		if (mp->addr.proto == htons(ETH_P_IP))
-			ip_eth_mc_map(mp->addr.dst.ip4, mdb.addr);
-#if IS_ENABLED(CONFIG_IPV6)
-		else if (mp->addr.proto == htons(ETH_P_IPV6))
-			ipv6_eth_mc_map(&mp->addr.dst.ip6, mdb.addr);
-#endif
-		else
-			ether_addr_copy(mdb.addr, mp->addr.dst.mac_addr);
+		br_switchdev_mdb_populate(&mdb, mp);
 
 		mdb.obj.orig_dev = pg->key.port->dev;
 		switch (type) {
-- 
2.25.1

