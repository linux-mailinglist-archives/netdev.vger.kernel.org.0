Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D01E2EEA47
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 01:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729553AbhAHAVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 19:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729393AbhAHAVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 19:21:08 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8C3C0612F6
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 16:20:27 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id ce23so12191028ejb.8
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 16:20:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yeKZYVNeGv9pWq9WOy5R66Y+YcpJG6RNi6Nr2YbpRlc=;
        b=rlSxYUb+8HSIxBj8J2jFdh5ATScIcF/Ub1prt4VidH1zbg1pPdAQHM4WpcC01pb0Oz
         U1YiHh7SJDzegkcGXp2+7wHd3D5RTzrqZstzA3K+otnMUl3CKSQLbVDCJaAAL3N6xHON
         s2YROV7dcarwXvjEPT73UXMTVqy5FLO+IB0ZM7vFBC1j2izcFWIARWkof2s//lQRxhYh
         X6MXtPrrIHc0Q7KMoq8W/mpMXt9cy6sl/nYjDa2ID4CCTFNVQiydWdP/ow4JeDJMIMIo
         Nex0IuFbZqBIi9Iy+8TxPTZ6E6a3lPewKben1sEEAFuHEpdG4+7qgb1UIv8qrM7zctdd
         +L1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yeKZYVNeGv9pWq9WOy5R66Y+YcpJG6RNi6Nr2YbpRlc=;
        b=pxoAlxg+7rSiyrpmrvtoUwVFROsT+bRARDNN33HdBmr/eZykE2HZzHIJS7o/3kQUTK
         WJwEWFjca/b+M1Npf5NgHPFl/D4rbm9U2udffmkEiZ44zseGo9q/1vfKESqbXOOD1gvU
         LNxlv191J8JTTkNMHeb7D1lTjQj+5u5ZZgqUmKNG4nBTEX9fv6VR11w+WBFmOTXhTVP+
         HKkgD5w7GqlhzN2PRfzgdNQQl8hGK2zj/Bk2Ty0vXieahQdu3eN8og+tYPFwSTJ1f+Ia
         stLYumArjCC3y/WpygHyKGXNPcdDVxmh8uJd4cg18cv3ylsb0+6pBadfHMcUfouv2384
         uyLQ==
X-Gm-Message-State: AOAM533r15Xkm/LmaVYH/oM+pCvFS6b8POPe5vjeAeLyvYEudc6V6j1/
        t5F8t/tlf8fGNvpLMUKNfb0=
X-Google-Smtp-Source: ABdhPJzOvycvM30PbSNk3L4PzzSv32Rn1XqcM5pCTzI6ZUAGMCA35xHV6TrWytRWwJhMwWhLpgbBxg==
X-Received: by 2002:a17:906:1199:: with SMTP id n25mr891952eja.293.1610065226115;
        Thu, 07 Jan 2021 16:20:26 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id rk12sm2981691ejb.75.2021.01.07.16.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 16:20:25 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, Florian Westphal <fw@strlen.de>
Subject: [PATCH v4 net-next 02/18] net: introduce a mutex for the netns interface lists
Date:   Fri,  8 Jan 2021 02:19:49 +0200
Message-Id: <20210108002005.3429956-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108002005.3429956-1-olteanv@gmail.com>
References: <20210108002005.3429956-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Currently, any writer that wants to alter the lists of network
interfaces (either the plain list net->dev_base_head, or the hash tables
net->dev_index_head and net->dev_name_head) can keep other writers at
bay using the RTNL mutex.

However, the RTNL mutex has become a very contended resource over the
years, so there is a movement to do finer grained locking.

This patch adds one more way for writers to the network interface lists
to serialize themselves. We assume that all writers to the network
interface lists are easily identifiable because the write side of
dev_base_lock also needs to be held (note that some instances of that
were deliberately skipped, since they only dealt with protecting the
operational state of the netdev).

Holding the RTNL mutex is now optional for new code that alters the
lists, since all relevant writers were made to also hold the new lock.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
- Renamed from netdev_lists_lock to netif_lists_lock.
- Created some helper functions netif_lists_lock() and
  netif_lists_unlock().

 include/linux/netdevice.h   | 10 +++++++++
 include/net/net_namespace.h |  6 +++++
 net/core/dev.c              | 44 +++++++++++++++++++++++++------------
 3 files changed, 46 insertions(+), 14 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 259be67644e3..2cc4800238bd 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4393,6 +4393,16 @@ static inline void netif_addr_unlock_bh(struct net_device *dev)
 	spin_unlock_bh(&dev->addr_list_lock);
 }
 
+static inline void netif_lists_lock(struct net *net)
+{
+	mutex_lock(&net->netif_lists_lock);
+}
+
+static inline void netif_lists_unlock(struct net *net)
+{
+	mutex_unlock(&net->netif_lists_lock);
+}
+
 /*
  * dev_addrs walker. Should be used only for read access. Call with
  * rcu_read_lock held.
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 29567875f428..cac64c3c7ce0 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -183,6 +183,12 @@ struct net {
 	struct sock		*crypto_nlsk;
 #endif
 	struct sock		*diag_nlsk;
+
+	/* Serializes writers to @dev_base_head, @dev_name_head and
+	 * @dev_index_head. It does _not_ protect the netif adjacency lists
+	 * (struct net_device::adj_list).
+	 */
+	struct mutex		netif_lists_lock;
 } __randomize_layout;
 
 #include <linux/seq_file_net.h>
diff --git a/net/core/dev.c b/net/core/dev.c
index 67d912745e5c..49963aaf12b5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -175,13 +175,16 @@ static struct napi_struct *napi_by_id(unsigned int napi_id);
  *
  * Pure readers should hold rcu_read_lock() which should protect them against
  * concurrent changes to the interface lists made by the writers. Pure writers
- * must serialize by holding the RTNL mutex while they loop through the list
- * and make changes to it.
+ * must serialize by holding the @net->netif_lists_lock mutex while they loop
+ * through the list and make changes to it.
+ *
+ * It is possible to hold the RTNL mutex for serializing the writers too, but
+ * this should be avoided in new code due to lock contention.
  *
  * It is also possible to hold the global rwlock_t @dev_base_lock for
  * protection (holding its read side as an alternative to rcu_read_lock, and
- * its write side as an alternative to the RTNL mutex), however this should not
- * be done in new code, since it is deprecated and pending removal.
+ * its write side as an alternative to @net->netif_lists_lock), however this
+ * should not be done in new code, since it is deprecated and pending removal.
  *
  * One other role of @dev_base_lock is to protect against changes in the
  * operational state of a network interface.
@@ -360,12 +363,14 @@ static void list_netdevice(struct net_device *dev)
 
 	ASSERT_RTNL();
 
+	netif_lists_lock(net);
 	write_lock_bh(&dev_base_lock);
 	list_add_tail_rcu(&dev->dev_list, &net->dev_base_head);
 	netdev_name_node_add(net, dev->name_node);
 	hlist_add_head_rcu(&dev->index_hlist,
 			   dev_index_hash(net, dev->ifindex));
 	write_unlock_bh(&dev_base_lock);
+	netif_lists_unlock(net);
 
 	dev_base_seq_inc(net);
 }
@@ -375,16 +380,20 @@ static void list_netdevice(struct net_device *dev)
  */
 static void unlist_netdevice(struct net_device *dev)
 {
+	struct net *net = dev_net(dev);
+
 	ASSERT_RTNL();
 
 	/* Unlink dev from the device chain */
+	netif_lists_lock(net);
 	write_lock_bh(&dev_base_lock);
 	list_del_rcu(&dev->dev_list);
 	netdev_name_node_del(dev->name_node);
 	hlist_del_rcu(&dev->index_hlist);
 	write_unlock_bh(&dev_base_lock);
+	netif_lists_unlock(net);
 
-	dev_base_seq_inc(dev_net(dev));
+	dev_base_seq_inc(net);
 }
 
 /*
@@ -850,11 +859,11 @@ EXPORT_SYMBOL_GPL(dev_fill_metadata_dst);
  *	@net: the applicable net namespace
  *	@name: name to find
  *
- *	Find an interface by name. Must be called under RTNL semaphore
- *	or @dev_base_lock. If the name is found a pointer to the device
- *	is returned. If the name is not found then %NULL is returned. The
- *	reference counters are not incremented so the caller must be
- *	careful with locks.
+ *	Find an interface by name. Must be called under RTNL semaphore,
+ *	@net->netif_lists_lock or @dev_base_lock. If the name is found,
+ *	a pointer to the device is returned. If the name is not found then
+ *	%NULL is returned. The reference counters are not incremented so the
+ *	caller must be careful with locks.
  */
 
 struct net_device *__dev_get_by_name(struct net *net, const char *name)
@@ -920,8 +929,8 @@ EXPORT_SYMBOL(dev_get_by_name);
  *	Search for an interface by index. Returns %NULL if the device
  *	is not found or a pointer to the device. The device has not
  *	had its reference counter increased so the caller must be careful
- *	about locking. The caller must hold either the RTNL semaphore
- *	or @dev_base_lock.
+ *	about locking. The caller must hold either the RTNL semaphore,
+ *	@net->netif_lists_lock or @dev_base_lock.
  */
 
 struct net_device *__dev_get_by_index(struct net *net, int ifindex)
@@ -1330,15 +1339,19 @@ int dev_change_name(struct net_device *dev, const char *newname)
 
 	netdev_adjacent_rename_links(dev, oldname);
 
+	netif_lists_lock(net);
 	write_lock_bh(&dev_base_lock);
 	netdev_name_node_del(dev->name_node);
 	write_unlock_bh(&dev_base_lock);
+	netif_lists_unlock(net);
 
 	synchronize_rcu();
 
+	netif_lists_lock(net);
 	write_lock_bh(&dev_base_lock);
 	netdev_name_node_add(net, dev->name_node);
 	write_unlock_bh(&dev_base_lock);
+	netif_lists_unlock(net);
 
 	ret = call_netdevice_notifiers(NETDEV_CHANGENAME, dev);
 	ret = notifier_to_errno(ret);
@@ -9415,8 +9428,9 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
  *	@net: the applicable net namespace
  *
  *	Returns a suitable unique value for a new device interface
- *	number.  The caller must hold the rtnl semaphore or the
- *	dev_base_lock to be sure it remains unique.
+ *	number.
+ *	The caller must hold the rtnl semaphore, @net->netif_lists_lock or the
+ *	@dev_base_lock to be sure it remains unique.
  */
 static int dev_new_index(struct net *net)
 {
@@ -10999,6 +11013,8 @@ static int __net_init netdev_init(struct net *net)
 	if (net->dev_index_head == NULL)
 		goto err_idx;
 
+	mutex_init(&net->netif_lists_lock);
+
 	RAW_INIT_NOTIFIER_HEAD(&net->netdev_chain);
 
 	return 0;
-- 
2.25.1

