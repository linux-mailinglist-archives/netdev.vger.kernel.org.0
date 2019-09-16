Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0963FB3BCC
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 15:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387962AbfIPNtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 09:49:22 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44044 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733128AbfIPNtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 09:49:21 -0400
Received: by mail-pl1-f196.google.com with SMTP id k1so16955660pls.11
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 06:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=McSuU8z/zNJCxnLPEFOANHVpsoxk6pd/gMe7sJiZLVQ=;
        b=boF81hqlNjLK8LNURAT9GdihfdeVtkz4+893OOV/ID6rMvrusxvpuH6c/3n1P3UsdS
         zSFhO8fOXaFYgLgVgNGzyInr/wFcpH1ACWxos86MQMxhvsrc8lRztndS0nq/Qj/pPMhQ
         D2cJZhg9v25kGAPBsvClYPV2net5AYV2GW35nQP37bXNsde38AmZKpVoq0qNCjo3VjRk
         PmM28C9NnSLZwhwGXS8QackF3y6Lnl5aroY4WN0wvhCODw/eB7Im5YIzRwgp2rbG5GSq
         +s23fgCorsgTO/FERh3uy+95HFhdII/5fFZv1wKFLgQdKaiz6N1E8IVSWL9VVMrDBOSm
         Pm4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=McSuU8z/zNJCxnLPEFOANHVpsoxk6pd/gMe7sJiZLVQ=;
        b=hed4vI61e+5yEf6tkxIPWM8xP4RSKk+rjNnf9F0U1P8doFBVFMqRkfujnVMpPaT6P+
         KB12DbKJ0fSZI+bdQp3ZLoS88jeVwtgLDn1u715mTCm8QXhORMR+8hvepZiFCLtMeBy5
         EMiKG36t6vIMa+khbfuEUbElLarjMHRn1bEElajs0Il6ns/Wz7OgBYxgJf1tHlnomhhh
         jNo9IKVG2kW5elaqaSkD9ic7nJAhpdqomMhH3QebZ4hT4WdHwEQ0w6IrDuDpxXX4m0aG
         yWqvoTYW93M+5BCbVx+Y6ydHn8tm4/U6v8WXtsGli54b1CJTLEmAwcBn1lJzagrt7AcU
         ExoQ==
X-Gm-Message-State: APjAAAXf5eYC8ZWjs1oq9O5Gdvy6kvPLoReNDGqZY5VoW2PXQ6nlOlW7
        iq4GQ15y+FX5INlnPdncgdY=
X-Google-Smtp-Source: APXvYqyk/yUBPA0kLidEt4vhGyR1fz0EeUmPT1/SF/C9/m4+L60CktaDnE2uoMV+onegEwbe03Harw==
X-Received: by 2002:a17:902:9a46:: with SMTP id x6mr2408091plv.12.1568641758864;
        Mon, 16 Sep 2019 06:49:18 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.1.1.1.1 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id z20sm2822266pjn.12.2019.09.16.06.49.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 06:49:17 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jiri@resnulli.us,
        sd@queasysnail.net, roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com
Cc:     ap420073@gmail.com
Subject: [PATCH net v3 09/11] net: core: add ignore flag to netdev_adjacent structure
Date:   Mon, 16 Sep 2019 22:48:00 +0900
Message-Id: <20190916134802.8252-10-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190916134802.8252-1-ap420073@gmail.com>
References: <20190916134802.8252-1-ap420073@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to link an adjacent node, netdev_upper_dev_link() is used
and in order to unlink an adjacent node, netdev_upper_dev_unlink() is used.
unlink operation does not fail, but link operation can fail.

In order to exchange adjacent nodes, we should unlink an old adjacent
node first. then, link a new adjacent node.
If link operation is failed, we should link an old adjacent node again.
But this link operation can fail too.
It eventually breaks the adjacent link relationship.

This patch adds an ignore flag into the netdev_adjacent structure.
If this flag is set, netdev_upper_dev_link() ignores an old adjacent
node for a moment.
So we can skip unlink operation before link operation.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2 -> v3 :
 - Modify nesting infra code to use iterator instead of recursive
v1 -> v2 :
 - This patch is not changed

 include/linux/netdevice.h |   4 +
 net/core/dev.c            | 180 ++++++++++++++++++++++++++++++++++----
 2 files changed, 166 insertions(+), 18 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5bb5756129af..4506810c301b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4319,6 +4319,10 @@ int netdev_master_upper_dev_link(struct net_device *dev,
 				 struct netlink_ext_ack *extack);
 void netdev_upper_dev_unlink(struct net_device *dev,
 			     struct net_device *upper_dev);
+void netdev_adjacent_dev_disable(struct net_device *upper_dev,
+				 struct net_device *lower_dev);
+void netdev_adjacent_dev_enable(struct net_device *upper_dev,
+				struct net_device *lower_dev);
 void netdev_adjacent_rename_links(struct net_device *dev, char *oldname);
 void *netdev_lower_dev_get_private(struct net_device *dev,
 				   struct net_device *lower_dev);
diff --git a/net/core/dev.c b/net/core/dev.c
index fa847ea957ee..12d76b983064 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6448,6 +6448,9 @@ struct netdev_adjacent {
 	/* upper master flag, there can only be one master device per list */
 	bool master;
 
+	/* lookup ignore flag */
+	bool ignore;
+
 	/* counter for the number of times this device was added to us */
 	u16 ref_nr;
 
@@ -6553,6 +6556,22 @@ struct net_device *netdev_master_upper_dev_get(struct net_device *dev)
 }
 EXPORT_SYMBOL(netdev_master_upper_dev_get);
 
+struct net_device *netdev_master_upper_dev_get_ignore(struct net_device *dev)
+{
+	struct netdev_adjacent *upper;
+
+	ASSERT_RTNL();
+
+	if (list_empty(&dev->adj_list.upper))
+		return NULL;
+
+	upper = list_first_entry(&dev->adj_list.upper,
+				 struct netdev_adjacent, list);
+	if (likely(upper->master) && !upper->ignore)
+		return upper->dev;
+	return NULL;
+}
+
 /**
  * netdev_has_any_lower_dev - Check if device is linked to some device
  * @dev: device
@@ -6603,8 +6622,9 @@ struct net_device *netdev_upper_get_next_dev_rcu(struct net_device *dev,
 }
 EXPORT_SYMBOL(netdev_upper_get_next_dev_rcu);
 
-static struct net_device *netdev_next_upper_dev(struct net_device *dev,
-						struct list_head **iter)
+static struct net_device *netdev_next_upper_dev_ignore(struct net_device *dev,
+						       struct list_head **iter,
+						       bool *ignore)
 {
 	struct netdev_adjacent *upper;
 
@@ -6614,6 +6634,7 @@ static struct net_device *netdev_next_upper_dev(struct net_device *dev,
 		return NULL;
 
 	*iter = &upper->list;
+	*ignore = upper->ignore;
 
 	return upper->dev;
 }
@@ -6635,14 +6656,15 @@ static struct net_device *netdev_next_upper_dev_rcu(struct net_device *dev,
 	return upper->dev;
 }
 
-int netdev_walk_all_upper_dev(struct net_device *dev,
-			      int (*fn)(struct net_device *dev,
-					void *data),
-			      void *data)
+int netdev_walk_all_upper_dev_ignore(struct net_device *dev,
+				     int (*fn)(struct net_device *dev,
+					       void *data),
+				     void *data)
 {
 	struct net_device *udev, *next, *now, *dev_stack[MAX_NEST_DEV + 1];
 	struct list_head *niter, *iter, *iter_stack[MAX_NEST_DEV + 1];
 	int ret, cur = 0;
+	bool ignore;
 
 	now = dev;
 	iter = &dev->adj_list.upper;
@@ -6656,9 +6678,12 @@ int netdev_walk_all_upper_dev(struct net_device *dev,
 
 		next = NULL;
 		while (1) {
-			udev = netdev_next_upper_dev(now, &iter);
+			udev = netdev_next_upper_dev_ignore(now, &iter,
+							    &ignore);
 			if (!udev)
 				break;
+			if (ignore)
+				continue;
 
 			if (!next) {
 				next = udev;
@@ -6735,6 +6760,15 @@ int netdev_walk_all_upper_dev_rcu(struct net_device *dev,
 }
 EXPORT_SYMBOL_GPL(netdev_walk_all_upper_dev_rcu);
 
+bool netdev_has_upper_dev_ignore(struct net_device *dev,
+				 struct net_device *upper_dev)
+{
+	ASSERT_RTNL();
+
+	return netdev_walk_all_upper_dev_ignore(dev, __netdev_has_upper_dev,
+						upper_dev);
+}
+
 /**
  * netdev_lower_get_next_private - Get the next ->private from the
  *				   lower neighbour list
@@ -6831,6 +6865,23 @@ static struct net_device *netdev_next_lower_dev(struct net_device *dev,
 	return lower->dev;
 }
 
+static struct net_device *netdev_next_lower_dev_ignore(struct net_device *dev,
+						       struct list_head **iter,
+						       bool *ignore)
+{
+	struct netdev_adjacent *lower;
+
+	lower = list_entry((*iter)->next, struct netdev_adjacent, list);
+
+	if (&lower->list == &dev->adj_list.lower)
+		return NULL;
+
+	*iter = &lower->list;
+	*ignore = lower->ignore;
+
+	return lower->dev;
+}
+
 int netdev_walk_all_lower_dev(struct net_device *dev,
 			      int (*fn)(struct net_device *dev,
 					void *data),
@@ -6881,6 +6932,59 @@ int netdev_walk_all_lower_dev(struct net_device *dev,
 }
 EXPORT_SYMBOL_GPL(netdev_walk_all_lower_dev);
 
+int netdev_walk_all_lower_dev_ignore(struct net_device *dev,
+				     int (*fn)(struct net_device *dev,
+					       void *data),
+				     void *data)
+{
+	struct net_device *ldev, *next, *now, *dev_stack[MAX_NEST_DEV + 1];
+	struct list_head *niter, *iter, *iter_stack[MAX_NEST_DEV + 1];
+	int ret, cur = 0;
+	bool ignore;
+
+	now = dev;
+	iter = &dev->adj_list.lower;
+
+	while (1) {
+		if (now != dev) {
+			ret = fn(now, data);
+			if (ret)
+				return ret;
+		}
+
+		next = NULL;
+		while (1) {
+			ldev = netdev_next_lower_dev_ignore(now, &iter,
+							    &ignore);
+			if (!ldev)
+				break;
+			if (ignore)
+				continue;
+
+			if (!next) {
+				next = ldev;
+				niter = &ldev->adj_list.lower;
+			} else {
+				dev_stack[cur] = ldev;
+				iter_stack[cur++] = &ldev->adj_list.lower;
+				break;
+			}
+		}
+
+		if (!next) {
+			if (!cur)
+				return 0;
+			next = dev_stack[--cur];
+			niter = iter_stack[cur];
+		}
+
+		now = next;
+		iter = niter;
+	}
+
+	return 0;
+}
+
 static struct net_device *netdev_next_lower_dev_rcu(struct net_device *dev,
 						    struct list_head **iter)
 {
@@ -6900,11 +7004,14 @@ static u8 __netdev_upper_depth(struct net_device *dev)
 	struct net_device *udev;
 	struct list_head *iter;
 	u8 max_depth = 0;
+	bool ignore;
 
 	for (iter = &dev->adj_list.upper,
-	     udev = netdev_next_upper_dev(dev, &iter);
+	     udev = netdev_next_upper_dev_ignore(dev, &iter, &ignore);
 	     udev;
-	     udev = netdev_next_upper_dev(dev, &iter)) {
+	     udev = netdev_next_upper_dev_ignore(dev, &iter, &ignore)) {
+		if (ignore)
+			continue;
 		if (max_depth < udev->upper_level)
 			max_depth = udev->upper_level;
 	}
@@ -6917,11 +7024,14 @@ static u8 __netdev_lower_depth(struct net_device *dev)
 	struct net_device *ldev;
 	struct list_head *iter;
 	u8 max_depth = 0;
+	bool ignore;
 
 	for (iter = &dev->adj_list.lower,
-	     ldev = netdev_next_lower_dev(dev, &iter);
+	     ldev = netdev_next_lower_dev_ignore(dev, &iter, &ignore);
 	     ldev;
-	     ldev = netdev_next_lower_dev(dev, &iter)) {
+	     ldev = netdev_next_lower_dev_ignore(dev, &iter, &ignore)) {
+		if (ignore)
+			continue;
 		if (max_depth < ldev->lower_level)
 			max_depth = ldev->lower_level;
 	}
@@ -7089,6 +7199,7 @@ static int __netdev_adjacent_dev_insert(struct net_device *dev,
 	adj->master = master;
 	adj->ref_nr = 1;
 	adj->private = private;
+	adj->ignore = false;
 	dev_hold(adj_dev);
 
 	pr_debug("Insert adjacency: dev %s adj_dev %s adj->ref_nr %d; dev_hold on %s\n",
@@ -7239,17 +7350,17 @@ static int __netdev_upper_dev_link(struct net_device *dev,
 		return -EBUSY;
 
 	/* To prevent loops, check if dev is not upper device to upper_dev. */
-	if (netdev_has_upper_dev(upper_dev, dev))
+	if (netdev_has_upper_dev_ignore(upper_dev, dev))
 		return -EBUSY;
 
 	if ((dev->lower_level + upper_dev->upper_level) > MAX_NEST_DEV)
 		return -EMLINK;
 
 	if (!master) {
-		if (netdev_has_upper_dev(dev, upper_dev))
+		if (netdev_has_upper_dev_ignore(dev, upper_dev))
 			return -EEXIST;
 	} else {
-		master_dev = netdev_master_upper_dev_get(dev);
+		master_dev = netdev_master_upper_dev_get_ignore(dev);
 		if (master_dev)
 			return master_dev == upper_dev ? -EEXIST : -EBUSY;
 	}
@@ -7272,10 +7383,12 @@ static int __netdev_upper_dev_link(struct net_device *dev,
 		goto rollback;
 
 	__netdev_update_upper_level(dev, NULL);
-	netdev_walk_all_lower_dev(dev, __netdev_update_upper_level, NULL);
+	netdev_walk_all_lower_dev_ignore(dev,
+					 __netdev_update_upper_level, NULL);
 
 	__netdev_update_lower_level(upper_dev, NULL);
-	netdev_walk_all_upper_dev(upper_dev, __netdev_update_lower_level, NULL);
+	netdev_walk_all_upper_dev_ignore(upper_dev,
+					 __netdev_update_lower_level, NULL);
 
 	return 0;
 
@@ -7361,13 +7474,44 @@ void netdev_upper_dev_unlink(struct net_device *dev,
 				      &changeupper_info.info);
 
 	__netdev_update_upper_level(dev, NULL);
-	netdev_walk_all_lower_dev(dev, __netdev_update_upper_level, NULL);
+	netdev_walk_all_lower_dev_ignore(dev,
+					 __netdev_update_upper_level, NULL);
 
 	__netdev_update_lower_level(upper_dev, NULL);
-	netdev_walk_all_upper_dev(upper_dev, __netdev_update_lower_level, NULL);
+	netdev_walk_all_upper_dev_ignore(upper_dev,
+					 __netdev_update_lower_level, NULL);
 }
 EXPORT_SYMBOL(netdev_upper_dev_unlink);
 
+void __netdev_adjacent_dev_set(struct net_device *upper_dev,
+			       struct net_device *lower_dev,
+			       bool val)
+{
+	struct netdev_adjacent *adj;
+
+	adj = __netdev_find_adj(lower_dev, &upper_dev->adj_list.lower);
+	if (adj)
+		adj->ignore = val;
+
+	adj = __netdev_find_adj(upper_dev, &lower_dev->adj_list.upper);
+	if (adj)
+		adj->ignore = val;
+}
+
+void netdev_adjacent_dev_disable(struct net_device *upper_dev,
+				 struct net_device *lower_dev)
+{
+	__netdev_adjacent_dev_set(upper_dev, lower_dev, true);
+}
+EXPORT_SYMBOL(netdev_adjacent_dev_disable);
+
+void netdev_adjacent_dev_enable(struct net_device *upper_dev,
+				struct net_device *lower_dev)
+{
+	__netdev_adjacent_dev_set(upper_dev, lower_dev, false);
+}
+EXPORT_SYMBOL(netdev_adjacent_dev_enable);
+
 /**
  * netdev_bonding_info_change - Dispatch event about slave change
  * @dev: device
-- 
2.17.1

