Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41B7BDF558
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 20:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730122AbfJUStM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 14:49:12 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40721 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbfJUStM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 14:49:12 -0400
Received: by mail-pg1-f195.google.com with SMTP id 15so2992201pgt.7;
        Mon, 21 Oct 2019 11:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NAURb4MpFzJOvk1d4WdGMsLkzkraGz82CodJJ7jNdzo=;
        b=KqpXJIz1YFWHKuJQDP73HX8zyIYb0zAYKmDwN1uudqCZUDMrTW4XnUOlIHPeFdQQ7X
         dLpTdGKIsd8kQuhfgvAA7SF23mrDxBImicMPIpSKRlvWlB/Ez7yK0W0OiAhbmA1j/aUe
         nCGNVub8riNsSL96GLwyxn9dG1VTuM7bDg9umIn3L+wRNGJaEJ5AYhiObDhFJVoXB1tK
         RkgvUP+xLu0RBgmsmFQVByMq5sXmfccmNXqUYijjV0x2fiTtwLbpChb3b+8Wjkas1rAQ
         B3yDYrV3e4F9h5HgyOIL0vqDusQbenJrwy9SUriAuhjfpkxvbvWe9mQ5g3GmU7GU42Ll
         IYBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NAURb4MpFzJOvk1d4WdGMsLkzkraGz82CodJJ7jNdzo=;
        b=Yu2WtmOWb4HlG8KdajDmSCc3QJHRJUejH/mdxitSCaDrW3v5kE68kwGGquJMAzgfSr
         E+mjJJgmQ5ApA2sVKFkaKuksDp+z/qKFe5hwhhNUjgMrdFPKcy2CprwV7sZf77sC9cpG
         C7+79begUUVz8rUKj8xVbJfYuH5uJFlXMiHzQNKj1fU0LCYuqTHkLbLTY1OGCKIalRm4
         T3IjOPd09PgCOQ+vEeSJjQxSV5NM8wGpP61bPgK1Sodwnm9gXPM2tRT9QSvW2d0gUfTG
         53fxQkgqUrdZFR9vPdy6+wfcR9waxDXOoV8S8mKT1pbctLcmzT6biG52oRuVgp357kMI
         91rg==
X-Gm-Message-State: APjAAAUSD+JpuW4qx1Cz5tPVTC7RkxsrsezbV2yU/16lv7s3PE8SGeQs
        GLokfBXf1rqx7RzprEcshcA=
X-Google-Smtp-Source: APXvYqw1WOPb8Haqyz4RnO8pXuCoyV3zswDcTAIowC+EamLVEcz5uyq0/rRHqPVyaPyoR3QiVxEyqg==
X-Received: by 2002:a63:1b44:: with SMTP id b4mr15307491pgm.421.1571683750870;
        Mon, 21 Oct 2019 11:49:10 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id ev20sm14502835pjb.19.2019.10.21.11.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 11:49:09 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, jakub.kicinski@netronome.com,
        johannes@sipsolutions.net, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, jiri@resnulli.us, sd@queasysnail.net,
        roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com, schuffelen@google.com, bjorn@mork.no
Cc:     ap420073@gmail.com
Subject: [PATCH net v5 07/10] net: core: add ignore flag to netdev_adjacent structure
Date:   Mon, 21 Oct 2019 18:47:56 +0000
Message-Id: <20191021184759.13125-7-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191021184759.13125-1-ap420073@gmail.com>
References: <20191021184759.13125-1-ap420073@gmail.com>
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

This patch also adds new functions for other modules.
netdev_adjacent_change_prepare()
netdev_adjacent_change_commit()
netdev_adjacent_change_abort()

netdev_adjacent_change_prepare() inserts new device into adjacent list
but new device is not allowed to use immediately.
If netdev_adjacent_change_prepare() fails, it internally rollbacks
adjacent list so that we don't need any other action.
netdev_adjacent_change_commit() deletes old device in the adjacent list
and allows new device to use.
netdev_adjacent_change_abort() rollbacks adjacent list.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v4 -> v5 :
 - This patch is not changed
v3 -> v4 :
 - Add missing static keyword in the dev.c
 - Expose netdev_adjacent_change_{prepare/commit/abort} instead of
   netdev_adjacent_dev_{enable/disable}
v2 -> v3 :
 - Modify nesting infra code to use iterator instead of recursive
v1 -> v2 :
 - This patch is not changed


 include/linux/netdevice.h |  10 ++
 net/core/dev.c            | 230 ++++++++++++++++++++++++++++++++++----
 2 files changed, 219 insertions(+), 21 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index c93df7cf187b..6c6490e15cd4 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4324,6 +4324,16 @@ int netdev_master_upper_dev_link(struct net_device *dev,
 				 struct netlink_ext_ack *extack);
 void netdev_upper_dev_unlink(struct net_device *dev,
 			     struct net_device *upper_dev);
+int netdev_adjacent_change_prepare(struct net_device *old_dev,
+				   struct net_device *new_dev,
+				   struct net_device *dev,
+				   struct netlink_ext_ack *extack);
+void netdev_adjacent_change_commit(struct net_device *old_dev,
+				   struct net_device *new_dev,
+				   struct net_device *dev);
+void netdev_adjacent_change_abort(struct net_device *old_dev,
+				  struct net_device *new_dev,
+				  struct net_device *dev);
 void netdev_adjacent_rename_links(struct net_device *dev, char *oldname);
 void *netdev_lower_dev_get_private(struct net_device *dev,
 				   struct net_device *lower_dev);
diff --git a/net/core/dev.c b/net/core/dev.c
index 6b6d0fc65ef3..bd6790cef521 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6408,6 +6408,9 @@ struct netdev_adjacent {
 	/* upper master flag, there can only be one master device per list */
 	bool master;
 
+	/* lookup ignore flag */
+	bool ignore;
+
 	/* counter for the number of times this device was added to us */
 	u16 ref_nr;
 
@@ -6430,7 +6433,7 @@ static struct netdev_adjacent *__netdev_find_adj(struct net_device *adj_dev,
 	return NULL;
 }
 
-static int __netdev_has_upper_dev(struct net_device *upper_dev, void *data)
+static int ____netdev_has_upper_dev(struct net_device *upper_dev, void *data)
 {
 	struct net_device *dev = data;
 
@@ -6451,7 +6454,7 @@ bool netdev_has_upper_dev(struct net_device *dev,
 {
 	ASSERT_RTNL();
 
-	return netdev_walk_all_upper_dev_rcu(dev, __netdev_has_upper_dev,
+	return netdev_walk_all_upper_dev_rcu(dev, ____netdev_has_upper_dev,
 					     upper_dev);
 }
 EXPORT_SYMBOL(netdev_has_upper_dev);
@@ -6469,7 +6472,7 @@ EXPORT_SYMBOL(netdev_has_upper_dev);
 bool netdev_has_upper_dev_all_rcu(struct net_device *dev,
 				  struct net_device *upper_dev)
 {
-	return !!netdev_walk_all_upper_dev_rcu(dev, __netdev_has_upper_dev,
+	return !!netdev_walk_all_upper_dev_rcu(dev, ____netdev_has_upper_dev,
 					       upper_dev);
 }
 EXPORT_SYMBOL(netdev_has_upper_dev_all_rcu);
@@ -6513,6 +6516,22 @@ struct net_device *netdev_master_upper_dev_get(struct net_device *dev)
 }
 EXPORT_SYMBOL(netdev_master_upper_dev_get);
 
+static struct net_device *__netdev_master_upper_dev_get(struct net_device *dev)
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
@@ -6563,8 +6582,9 @@ struct net_device *netdev_upper_get_next_dev_rcu(struct net_device *dev,
 }
 EXPORT_SYMBOL(netdev_upper_get_next_dev_rcu);
 
-static struct net_device *netdev_next_upper_dev(struct net_device *dev,
-						struct list_head **iter)
+static struct net_device *__netdev_next_upper_dev(struct net_device *dev,
+						  struct list_head **iter,
+						  bool *ignore)
 {
 	struct netdev_adjacent *upper;
 
@@ -6574,6 +6594,7 @@ static struct net_device *netdev_next_upper_dev(struct net_device *dev,
 		return NULL;
 
 	*iter = &upper->list;
+	*ignore = upper->ignore;
 
 	return upper->dev;
 }
@@ -6595,14 +6616,15 @@ static struct net_device *netdev_next_upper_dev_rcu(struct net_device *dev,
 	return upper->dev;
 }
 
-static int netdev_walk_all_upper_dev(struct net_device *dev,
-				     int (*fn)(struct net_device *dev,
-					       void *data),
-				     void *data)
+static int __netdev_walk_all_upper_dev(struct net_device *dev,
+				       int (*fn)(struct net_device *dev,
+						 void *data),
+				       void *data)
 {
 	struct net_device *udev, *next, *now, *dev_stack[MAX_NEST_DEV + 1];
 	struct list_head *niter, *iter, *iter_stack[MAX_NEST_DEV + 1];
 	int ret, cur = 0;
+	bool ignore;
 
 	now = dev;
 	iter = &dev->adj_list.upper;
@@ -6616,9 +6638,11 @@ static int netdev_walk_all_upper_dev(struct net_device *dev,
 
 		next = NULL;
 		while (1) {
-			udev = netdev_next_upper_dev(now, &iter);
+			udev = __netdev_next_upper_dev(now, &iter, &ignore);
 			if (!udev)
 				break;
+			if (ignore)
+				continue;
 
 			next = udev;
 			niter = &udev->adj_list.upper;
@@ -6688,6 +6712,15 @@ int netdev_walk_all_upper_dev_rcu(struct net_device *dev,
 }
 EXPORT_SYMBOL_GPL(netdev_walk_all_upper_dev_rcu);
 
+static bool __netdev_has_upper_dev(struct net_device *dev,
+				   struct net_device *upper_dev)
+{
+	ASSERT_RTNL();
+
+	return __netdev_walk_all_upper_dev(dev, ____netdev_has_upper_dev,
+					   upper_dev);
+}
+
 /**
  * netdev_lower_get_next_private - Get the next ->private from the
  *				   lower neighbour list
@@ -6784,6 +6817,23 @@ static struct net_device *netdev_next_lower_dev(struct net_device *dev,
 	return lower->dev;
 }
 
+static struct net_device *__netdev_next_lower_dev(struct net_device *dev,
+						  struct list_head **iter,
+						  bool *ignore)
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
@@ -6831,6 +6881,55 @@ int netdev_walk_all_lower_dev(struct net_device *dev,
 }
 EXPORT_SYMBOL_GPL(netdev_walk_all_lower_dev);
 
+static int __netdev_walk_all_lower_dev(struct net_device *dev,
+				       int (*fn)(struct net_device *dev,
+						 void *data),
+				       void *data)
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
+			ldev = __netdev_next_lower_dev(now, &iter, &ignore);
+			if (!ldev)
+				break;
+			if (ignore)
+				continue;
+
+			next = ldev;
+			niter = &ldev->adj_list.lower;
+			dev_stack[cur] = now;
+			iter_stack[cur++] = iter;
+			break;
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
@@ -6850,11 +6949,14 @@ static u8 __netdev_upper_depth(struct net_device *dev)
 	struct net_device *udev;
 	struct list_head *iter;
 	u8 max_depth = 0;
+	bool ignore;
 
 	for (iter = &dev->adj_list.upper,
-	     udev = netdev_next_upper_dev(dev, &iter);
+	     udev = __netdev_next_upper_dev(dev, &iter, &ignore);
 	     udev;
-	     udev = netdev_next_upper_dev(dev, &iter)) {
+	     udev = __netdev_next_upper_dev(dev, &iter, &ignore)) {
+		if (ignore)
+			continue;
 		if (max_depth < udev->upper_level)
 			max_depth = udev->upper_level;
 	}
@@ -6867,11 +6969,14 @@ static u8 __netdev_lower_depth(struct net_device *dev)
 	struct net_device *ldev;
 	struct list_head *iter;
 	u8 max_depth = 0;
+	bool ignore;
 
 	for (iter = &dev->adj_list.lower,
-	     ldev = netdev_next_lower_dev(dev, &iter);
+	     ldev = __netdev_next_lower_dev(dev, &iter, &ignore);
 	     ldev;
-	     ldev = netdev_next_lower_dev(dev, &iter)) {
+	     ldev = __netdev_next_lower_dev(dev, &iter, &ignore)) {
+		if (ignore)
+			continue;
 		if (max_depth < ldev->lower_level)
 			max_depth = ldev->lower_level;
 	}
@@ -7035,6 +7140,7 @@ static int __netdev_adjacent_dev_insert(struct net_device *dev,
 	adj->master = master;
 	adj->ref_nr = 1;
 	adj->private = private;
+	adj->ignore = false;
 	dev_hold(adj_dev);
 
 	pr_debug("Insert adjacency: dev %s adj_dev %s adj->ref_nr %d; dev_hold on %s\n",
@@ -7185,17 +7291,17 @@ static int __netdev_upper_dev_link(struct net_device *dev,
 		return -EBUSY;
 
 	/* To prevent loops, check if dev is not upper device to upper_dev. */
-	if (netdev_has_upper_dev(upper_dev, dev))
+	if (__netdev_has_upper_dev(upper_dev, dev))
 		return -EBUSY;
 
 	if ((dev->lower_level + upper_dev->upper_level) > MAX_NEST_DEV)
 		return -EMLINK;
 
 	if (!master) {
-		if (netdev_has_upper_dev(dev, upper_dev))
+		if (__netdev_has_upper_dev(dev, upper_dev))
 			return -EEXIST;
 	} else {
-		master_dev = netdev_master_upper_dev_get(dev);
+		master_dev = __netdev_master_upper_dev_get(dev);
 		if (master_dev)
 			return master_dev == upper_dev ? -EEXIST : -EBUSY;
 	}
@@ -7218,10 +7324,11 @@ static int __netdev_upper_dev_link(struct net_device *dev,
 		goto rollback;
 
 	__netdev_update_upper_level(dev, NULL);
-	netdev_walk_all_lower_dev(dev, __netdev_update_upper_level, NULL);
+	__netdev_walk_all_lower_dev(dev, __netdev_update_upper_level, NULL);
 
 	__netdev_update_lower_level(upper_dev, NULL);
-	netdev_walk_all_upper_dev(upper_dev, __netdev_update_lower_level, NULL);
+	__netdev_walk_all_upper_dev(upper_dev, __netdev_update_lower_level,
+				    NULL);
 
 	return 0;
 
@@ -7307,13 +7414,94 @@ void netdev_upper_dev_unlink(struct net_device *dev,
 				      &changeupper_info.info);
 
 	__netdev_update_upper_level(dev, NULL);
-	netdev_walk_all_lower_dev(dev, __netdev_update_upper_level, NULL);
+	__netdev_walk_all_lower_dev(dev, __netdev_update_upper_level, NULL);
 
 	__netdev_update_lower_level(upper_dev, NULL);
-	netdev_walk_all_upper_dev(upper_dev, __netdev_update_lower_level, NULL);
+	__netdev_walk_all_upper_dev(upper_dev, __netdev_update_lower_level,
+				    NULL);
 }
 EXPORT_SYMBOL(netdev_upper_dev_unlink);
 
+static void __netdev_adjacent_dev_set(struct net_device *upper_dev,
+				      struct net_device *lower_dev,
+				      bool val)
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
+static void netdev_adjacent_dev_disable(struct net_device *upper_dev,
+					struct net_device *lower_dev)
+{
+	__netdev_adjacent_dev_set(upper_dev, lower_dev, true);
+}
+
+static void netdev_adjacent_dev_enable(struct net_device *upper_dev,
+				       struct net_device *lower_dev)
+{
+	__netdev_adjacent_dev_set(upper_dev, lower_dev, false);
+}
+
+int netdev_adjacent_change_prepare(struct net_device *old_dev,
+				   struct net_device *new_dev,
+				   struct net_device *dev,
+				   struct netlink_ext_ack *extack)
+{
+	int err;
+
+	if (!new_dev)
+		return 0;
+
+	if (old_dev && new_dev != old_dev)
+		netdev_adjacent_dev_disable(dev, old_dev);
+
+	err = netdev_upper_dev_link(new_dev, dev, extack);
+	if (err) {
+		if (old_dev && new_dev != old_dev)
+			netdev_adjacent_dev_enable(dev, old_dev);
+		return err;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(netdev_adjacent_change_prepare);
+
+void netdev_adjacent_change_commit(struct net_device *old_dev,
+				   struct net_device *new_dev,
+				   struct net_device *dev)
+{
+	if (!new_dev || !old_dev)
+		return;
+
+	if (new_dev == old_dev)
+		return;
+
+	netdev_adjacent_dev_enable(dev, old_dev);
+	netdev_upper_dev_unlink(old_dev, dev);
+}
+EXPORT_SYMBOL(netdev_adjacent_change_commit);
+
+void netdev_adjacent_change_abort(struct net_device *old_dev,
+				  struct net_device *new_dev,
+				  struct net_device *dev)
+{
+	if (!new_dev)
+		return;
+
+	if (old_dev && new_dev != old_dev)
+		netdev_adjacent_dev_enable(dev, old_dev);
+
+	netdev_upper_dev_unlink(new_dev, dev);
+}
+EXPORT_SYMBOL(netdev_adjacent_change_abort);
+
 /**
  * netdev_bonding_info_change - Dispatch event about slave change
  * @dev: device
-- 
2.17.1

