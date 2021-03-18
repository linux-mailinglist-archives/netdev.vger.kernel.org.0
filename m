Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1B323410DE
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 00:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbhCRXTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 19:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbhCRXS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 19:18:57 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA53C06174A;
        Thu, 18 Mar 2021 16:18:56 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id bx7so8665118edb.12;
        Thu, 18 Mar 2021 16:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2oli4wkvWY6VioO2vYUWVFEJ38L2hnT3TEX3rYVjFmA=;
        b=jcuBSmmcqyADhf0SaTFKQx8VYai36Qvcr0G6toj6f6o0cmxuoV4kZHbQEHuEsb9rvz
         wsRTMU1aeez6ad51GTtQ8zqhFSJSswH0LWyEghMFdEbIdPwIRtxqHjleNHO+CH8I3FpR
         NNo9Ei3+5D4c2oMDaazDAxHW7MlarGF6SAHCSRCLsyApdSIB0YXQ0SRT1jBSmAnVALaB
         t5PDQ58WEL7cG7oHFyG8Cag6Vk+6mGI+Pq879uLbpPr0qBRYE8LR+Gr8iEuX/Nf8l0f3
         CLygsAHzensX+dHULQrlZVNZpAMX+1xjNIoBV7rFQ6ZwC8Q5+52Ulc3M6K0CG4w/STQC
         5qkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2oli4wkvWY6VioO2vYUWVFEJ38L2hnT3TEX3rYVjFmA=;
        b=KnzWipf7n7r/pkwwlOwhzzwbme7ln4VWfGY5XatU715lCEbiWMUSs53itBHXsLtJzG
         pSp3/TIfBaeSzBt/82y0RjtPsiWzBj5U5dJCXRsxL9YSsLb3K2TGavz5B9s9JM36QWSs
         uneA1RtOuZyfMbHnpIF9mWwcvMWNb4lPSrM6+jH2DwuxGIQOrfHwZ2j+iOpIKsqJHk2n
         ltJMGrKxYtz/gS9QYBVjn+AuvjErJEH8+aWqGdtvYxAVs6VoeMVqiJ1f7zuc1r0n19g4
         ny0QZJVW1n9UNiGzeJEta5G2wSDeFvli92CgFDnUNDjgiZYVqeHWnrn0ic0YfdejFHmf
         pNAA==
X-Gm-Message-State: AOAM532q9oSUWl4xESVP9irazbkfIpQRwHGg6wxNNdNp8eEPngxjT+Rs
        /CkIhNSLu0y8XwcQGtH/0uw=
X-Google-Smtp-Source: ABdhPJwVwvPI5qRpLsJtk4pFvYhI42S0+LyWuUlUvs++oZ16Rqlfsv6tp49a+jdMb8bK8Lux2UpHTQ==
X-Received: by 2002:aa7:d347:: with SMTP id m7mr6378193edr.260.1616109535201;
        Thu, 18 Mar 2021 16:18:55 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id bx24sm2801131ejc.88.2021.03.18.16.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 16:18:54 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v2 net-next 08/16] net: dsa: replay port and host-joined mdb entries when joining the bridge
Date:   Fri, 19 Mar 2021 01:18:21 +0200
Message-Id: <20210318231829.3892920-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318231829.3892920-1-olteanv@gmail.com>
References: <20210318231829.3892920-1-olteanv@gmail.com>
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
 include/linux/if_bridge.h |  9 +++++
 net/bridge/br_mdb.c       | 84 +++++++++++++++++++++++++++++++++++++++
 net/dsa/dsa_priv.h        |  2 +
 net/dsa/port.c            |  6 +++
 net/dsa/slave.c           |  2 +-
 5 files changed, 102 insertions(+), 1 deletion(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index ebd16495459c..4c25dafb013d 100644
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
+	return -EINVAL;
+}
 #endif
 
 #if IS_ENABLED(CONFIG_BRIDGE) && IS_ENABLED(CONFIG_BRIDGE_VLAN_FILTERING)
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 8846c5bcd075..23973186094c 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -506,6 +506,90 @@ static void br_mdb_complete(struct net_device *dev, int err, void *priv)
 	kfree(priv);
 }
 
+static int br_mdb_replay_one(struct notifier_block *nb, struct net_device *dev,
+			     struct net_bridge_mdb_entry *mp, int obj_id,
+			     struct net_device *orig_dev,
+			     struct netlink_ext_ack *extack)
+{
+	struct switchdev_notifier_port_obj_info obj_info = {
+		.info = {
+			.dev = dev,
+			.extack = extack,
+		},
+	};
+	struct switchdev_obj_port_mdb mdb = {
+		.obj = {
+			.orig_dev = orig_dev,
+			.id = obj_id,
+		},
+		.vid = mp->addr.vid,
+	};
+	int err;
+
+	if (mp->addr.proto == htons(ETH_P_IP))
+		ip_eth_mc_map(mp->addr.dst.ip4, mdb.addr);
+#if IS_ENABLED(CONFIG_IPV6)
+	else if (mp->addr.proto == htons(ETH_P_IPV6))
+		ipv6_eth_mc_map(&mp->addr.dst.ip6, mdb.addr);
+#endif
+	else
+		ether_addr_copy(mdb.addr, mp->addr.dst.mac_addr);
+
+	obj_info.obj = &mdb.obj;
+
+	err = nb->notifier_call(nb, SWITCHDEV_PORT_OBJ_ADD, &obj_info);
+	return notifier_to_errno(err);
+}
+
+int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
+		  struct notifier_block *nb, struct netlink_ext_ack *extack)
+{
+	struct net_bridge_mdb_entry *mp;
+	struct list_head mdb_list;
+	struct net_bridge *br;
+	int err = 0;
+
+	ASSERT_RTNL();
+
+	INIT_LIST_HEAD(&mdb_list);
+
+	if (!netif_is_bridge_master(br_dev) || !netif_is_bridge_port(dev))
+		return -EINVAL;
+
+	br = netdev_priv(br_dev);
+
+	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED))
+		return 0;
+
+	hlist_for_each_entry(mp, &br->mdb_list, mdb_node) {
+		struct net_bridge_port_group __rcu **pp;
+		struct net_bridge_port_group *p;
+
+		if (mp->host_joined) {
+			err = br_mdb_replay_one(nb, dev, mp,
+						SWITCHDEV_OBJ_ID_HOST_MDB,
+						br_dev, extack);
+			if (err)
+				return err;
+		}
+
+		for (pp = &mp->ports; (p = rtnl_dereference(*pp)) != NULL;
+		     pp = &p->next) {
+			if (p->key.port->dev != dev)
+				continue;
+
+			err = br_mdb_replay_one(nb, dev, mp,
+						SWITCHDEV_OBJ_ID_PORT_MDB,
+						dev, extack);
+			if (err)
+				return err;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(br_mdb_replay);
+
 static void br_mdb_switchdev_host_port(struct net_device *dev,
 				       struct net_device *lower_dev,
 				       struct net_bridge_mdb_entry *mp,
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index b8778c5d8529..b14c43cb88bb 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -262,6 +262,8 @@ static inline bool dsa_tree_offloads_bridge_port(struct dsa_switch_tree *dst,
 
 /* slave.c */
 extern const struct dsa_device_ops notag_netdev_ops;
+extern struct notifier_block dsa_slave_switchdev_blocking_notifier;
+
 void dsa_slave_mii_bus_init(struct dsa_switch *ds);
 int dsa_slave_create(struct dsa_port *dp);
 void dsa_slave_destroy(struct net_device *slave_dev);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 9fde2371e1bc..6670612f96c6 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -199,6 +199,12 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
+	err = br_mdb_replay(br, brport_dev,
+			    &dsa_slave_switchdev_blocking_notifier,
+			    extack);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
 	return 0;
 }
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 1ff48be476bb..b974d8f84a2e 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2396,7 +2396,7 @@ static struct notifier_block dsa_slave_switchdev_notifier = {
 	.notifier_call = dsa_slave_switchdev_event,
 };
 
-static struct notifier_block dsa_slave_switchdev_blocking_notifier = {
+struct notifier_block dsa_slave_switchdev_blocking_notifier = {
 	.notifier_call = dsa_slave_switchdev_blocking_event,
 };
 
-- 
2.25.1

