Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AADA32319C
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 20:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233997AbhBWTtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 14:49:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbhBWTtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 14:49:52 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2305DC061574
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 11:49:12 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id c6so27302796ede.0
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 11:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QD32A4V0OeA5+//n3hiRVx/BHd4JJT+vHchd1xSMQlM=;
        b=SmD5wEz8PMrcHFT6kSEnVEFs+H8xT0UeGbwFIlcW9upPySubia2UgFxRgWGO++T08e
         seHMwF6CTt2M88ZBeKLM6jgDTsziCVK1rKhgjzt4VenRHcrdVECB0TBvAMsOA3lzi1XG
         uJrbDE/M1+RYti7PfEAxUwTaUyr4cplxKSYpkp1MZhsmT29neBBXeq7aawPhuVJbJIV0
         v8XiskijUXbBapXH2VQpZkAtm9N2MBt7yn47LB1ZDJyJVrq/hcgep6y83d9KTl4FIE63
         krAgY0RirdqNHZMSswycObohPQn8gls+UeLGyJ07HdsoyYTu/m+DLpOuS74UpxNsVeO2
         +1Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QD32A4V0OeA5+//n3hiRVx/BHd4JJT+vHchd1xSMQlM=;
        b=TZLQQIMWtTo0rXCh19oRTHPqMhjgiAe0ou4RNlNKhEZbkcUoLqbl2SP75cBMDRdINz
         sTGyX7+fSgAzVdO0OkXFzff6P/r01/XgTfavbNsmqRy/XrxiWqxcgWtL6+DQ7xlKsv5t
         T93tKCcaqolh1QaffeZHqaY9se65mb+oArTKxa57hPPYwQSRJyQecR95cpTHL7AvAzTw
         2cr0U+RTge/v8e5HSItM78C0RyN8//mDmh1gemXo4MM4CKe6Oq2Uw8LPyIlJSDsaa9Tr
         HgTZvIUuyuhcsLZA2VHg0r1PfBZJLPqP1EvHbnLsioBY6nCCg5BjInuX2HMfmb+XFPjD
         RX9w==
X-Gm-Message-State: AOAM533AsSyoKdYkH3OUFT/MgKPKYQ135xrZ4sI+/N1xHS8aJPn59SYO
        CiFmnBmR6ZjvWkXhAPpICKw=
X-Google-Smtp-Source: ABdhPJx2yOXZfWBJroJpyEywVCHYNSBjXBiKmIuQDzIrGBV5f3utPRhu33Q5s+ymA8EoiEwbK3cjmQ==
X-Received: by 2002:aa7:d41a:: with SMTP id z26mr17327377edq.359.1614109750879;
        Tue, 23 Feb 2021 11:49:10 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id i9sm13056299ejz.86.2021.02.23.11.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 11:49:10 -0800 (PST)
Date:   Tue, 23 Feb 2021 21:49:08 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: Timing of host-joined bridge multicast groups with switchdev
Message-ID: <20210223194908.ne4a7abulirqfbs6@skbuf>
References: <20210223173753.vrlxhnj5rtvd6i6g@skbuf>
 <YDVBxrkYOtlmO1bn@shredder.lan>
 <20210223180236.e2ggiuxhr5aaayx5@skbuf>
 <YDVXhZdy510mFtG/@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDVXhZdy510mFtG/@shredder.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 09:29:09PM +0200, Ido Schimmel wrote:
> On Tue, Feb 23, 2021 at 08:02:36PM +0200, Vladimir Oltean wrote:
> > On Tue, Feb 23, 2021 at 07:56:22PM +0200, Ido Schimmel wrote:
> > > For route offload you get a dump of all the existing routes when you
> > > register your notifier. It's a bit different with bridge because you
> > > don't care about existing bridges when you just initialize your driver.
> > >
> > > We had a similar issue with VXLAN because its FDB can be populated and
> > > only then attached to a bridge that you offload. Check
> > > vxlan_fdb_replay(). Probably need to introduce something similar for
> > > FDB/MDB entries.
> >
> > So you would be in favor of a driver-voluntary 'pull' type of approach
> > at bridge join, instead of the bridge 'pushing' the addresses?
> >
> > That's all fine, except when we'll have more than 3 switchdev drivers,
> > how do we expect to manage all this complexity duplicated in many places
> > in the kernel, instead of having it in a central place? Are there corner
> > cases I'm missing which make the 'push' approach impractical?
>
> Not sure. It needs to be scheduled when the driver is ready to handle
> it. In br_add_if() after netdev_master_upper_dev_link() is probably a
> good place.
>
> It also needs to be done once and not every time another port joins the
> bridge. This can be done using the port's parent ID, similar to what we
> are already doing with the offload forward mark in
> nbp_switchdev_mark_set().
>
> But I'm not sure how we replay it only for a single notifier block. I'm
> not familiar with setups where you have more than one listener let alone
> more than one that is interested in notifications from a specific
> bridge, so maybe it is OK to just replay it for all the listeners. But I
> would prefer to avoid it if we can.

At least with a driver-initiated pull, this seems to work:

-----------------------------[ cut here ]-----------------------------
From 13cb5ccbe35f64cfabe7dea3f76c8bc778cff9dc Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Tue, 23 Feb 2021 21:45:08 +0200
Subject: [PATCH] net: bridge: add a function that replays port and host-joined
 mdb entries

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/if_bridge.h |   3 +
 include/net/switchdev.h   |   1 +
 net/bridge/br_mdb.c       | 115 ++++++++++++++++++++++++++++++++++++++
 net/dsa/slave.c           |   1 +
 4 files changed, 120 insertions(+)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index b979005ea39c..d1190e2984bc 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -95,6 +95,9 @@ static inline bool br_multicast_router(const struct net_device *dev)
 }
 #endif
 
+int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
+		  struct notifier_block *nb);
+
 #if IS_ENABLED(CONFIG_BRIDGE) && IS_ENABLED(CONFIG_BRIDGE_VLAN_FILTERING)
 bool br_vlan_enabled(const struct net_device *dev);
 int br_vlan_get_pvid(const struct net_device *dev, u16 *p_pvid);
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
index 8846c5bcd075..72978c881e11 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -235,6 +235,121 @@ static int __mdb_fill_info(struct sk_buff *skb,
 	return -EMSGSIZE;
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
+	else
+		ipv6_eth_mc_map(&mp->addr.dst.ip6, mdb->addr);
+#endif
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
 static int br_mdb_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
 			    struct net_device *dev)
 {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 43e403ac70d5..9052ff5efab7 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2070,6 +2070,7 @@ static int dsa_slave_changeupper(struct net_device *dev,
 			err = dsa_port_bridge_join(dp, info->upper_dev);
 			if (!err)
 				dsa_bridge_mtu_normalization(dp);
+			err = br_mdb_replay(info->upper_dev, dev, &dsa_slave_switchdev_blocking_notifier);
 			err = notifier_from_errno(err);
 		} else {
 			dsa_port_bridge_leave(dp, info->upper_dev);
-- 
2.25.1

-----------------------------[ cut here ]-----------------------------

I am just not sure why I need to emit the notification only once per
ASIC. Currently, SWITCHDEV_OBJ_ID_HOST_MDB is emitted for all bridge
ports, so the callers need to reference-count it anyway. As for the port
mdb entries, I am filtering the entries towards just a single port when
that joins. So I think this is okay.
