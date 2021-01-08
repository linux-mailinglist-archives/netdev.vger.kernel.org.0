Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164D52EF5D2
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 17:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbhAHQdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 11:33:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728292AbhAHQdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 11:33:02 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8671C0612FE
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 08:32:21 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id c7so11778824edv.6
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 08:32:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eH3qpeJWhBhUclxAjuxgpD80hx2i1ZWe5ao+Mipp3Ec=;
        b=qtatG2tQLAo1ZLV0j63KdJS8ZwsvbAtg1/+Q24oXqgp6vuaJaiQEj4Nd6ZeIk1CbQy
         Ae6vHjMiXgCNmD8CO6CiiOwQDWwSqr332zFlnOROid3kvEzQdd7DPjWWQxT8zx4IV560
         6q5zFNoZz7zO6iMINKAII7O3OiSbbiGnBTFEdP6z4KMy8uGI0fMjcxafq41XO+HglqM5
         1ehazd67WNoUaM3dUSav0Y7ReoLCQrzqDRdysaJgTMF7cGHL2Grckzk8dUpEffICvsNi
         LPCZ9S1HkZzVwDUHO4xyghh9uvejmkGpcMFkuFzlsOeTz2lCH5poliGX5t9SiPVu/HpM
         zaLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eH3qpeJWhBhUclxAjuxgpD80hx2i1ZWe5ao+Mipp3Ec=;
        b=RIAD2baoAo9Bp1aRj0x8n4y+hgcoy92mJa5SNW409Ab6Kj5dH7pwGLkgp9zTeuUNbl
         5hvzhb8o3L7M8iwgxw2kpX7vSV+RjRWbTjmzoIAIPl12KQdfOHLGVVIqoNxhBdtborpf
         iJ+V4ldK97DpE8Ob1IzWkzv7tmsXq0CVhbwFsQQF4RN4N5l4NcHF/tBtS0iBr7cQSm2Q
         nvLkNvr2gmf5ramv+Oko29KAwU5a58lcPAa9DiJkUbs4aGPfMo0B1qc9VlOB4IjWerIo
         JO3byOUeimwR09MTKhawQQm3x/99tE6a8yg5JJR1ifL5tf+GParz2N6pXMTzZn9sYQ7h
         GjKQ==
X-Gm-Message-State: AOAM530YRFqRnoY8ECq7kVfxP4DtTe23RTyYdNP8f6NQ5kWa7U0C/Tr8
        lij3Z+BkBvvnoW60wTZRQ9k=
X-Google-Smtp-Source: ABdhPJycHAKukbeTUsWpfIxXeWrSLyVSbBICfKP7DGl13o//s1gjcXZPxoNj7BUbFq3a77ppm7jf0Q==
X-Received: by 2002:aa7:cac2:: with SMTP id l2mr5795734edt.141.1610123540624;
        Fri, 08 Jan 2021 08:32:20 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id x6sm3957737edl.67.2021.01.08.08.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 08:32:20 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
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
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH v5 net-next 02/16] net: introduce a mutex for the netns interface lists
Date:   Fri,  8 Jan 2021 18:31:45 +0200
Message-Id: <20210108163159.358043-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108163159.358043-1-olteanv@gmail.com>
References: <20210108163159.358043-1-olteanv@gmail.com>
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
Changes in v5:
None.

Changes in v4:
None.

Changes in v3:
None.

 include/linux/netdevice.h   | 10 +++++++++
 include/net/net_namespace.h |  6 +++++
 net/core/dev.c              | 44 +++++++++++++++++++++++++------------
 3 files changed, 46 insertions(+), 14 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 1ec3ac5d5bbf..8aae2386bd37 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4376,6 +4376,16 @@ static inline void netif_addr_unlock_bh(struct net_device *dev)
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
index 8e02240bb11c..53c12f92025c 100644
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

