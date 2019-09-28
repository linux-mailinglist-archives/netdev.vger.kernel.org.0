Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1862C1165
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 18:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbfI1QuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 12:50:22 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46724 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfI1QuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 12:50:21 -0400
Received: by mail-pg1-f196.google.com with SMTP id a3so5027873pgm.13;
        Sat, 28 Sep 2019 09:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YIGe6kGHiMoc1Pv8mu+sUF30b2C6XCtTdnexzPuW3fM=;
        b=YAAiaj6HkFDusexvZ4pVY+knik2439+J4vyaW/HNquGrVBMMm+ZRQUhrQpaRyZQWzJ
         zsHsYuxhx/tv8feScAxEdU6C7e6hi1DUtPgIsNBQ4EfDuyYhzEQvDXysxSf3BXQeRAhM
         4IMW+C2nTtAb99hEnymCEnkQ70oHmzaLavOZkAMTRW71U787DRno7uqB9Jbeg5v3Ciiw
         8u5tNjcGXxBPcPQo7qBXkAxPPHSUuCnb15ak1mxZUY4uhh7rLomvvm4sA7Po3sGYTg29
         BxNhbah+kVXWcpzohLYwTJsTzQlYScpQKEYMM+qON3EuoqjgeHilKExFF7C5st1SHKiK
         vFDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YIGe6kGHiMoc1Pv8mu+sUF30b2C6XCtTdnexzPuW3fM=;
        b=QMRvjM9/SkwwiSAyOVlRRb/0tHP5yBNvNFqqk9/XnBzu4gHl+ka1e/FctkN2SugM/j
         atgfx7HmTSJlbnSSSbsappauIRDbNesPsdmHpNacjuzSJGTVDneZ8cnYVtzR96mI2Asm
         +/sVjHNMhIoNt+xgliw7xlD6Wq+LNp4+VK16YcO5vgmFOdKiVsySNRsnzeS6jYhGEVhN
         TmUu76sFXmoV8GqY+qTBhOjEdTe/g/mpVXqARYlbtSVjFXM4BnHAFpScA37VLbJIIx0p
         JOuVwEXLTZYs1nQu4R1LhfCRBJQr/eg3rfaolD44GWrMJ/1K4FQttRSVUHEMIjWbg+6p
         bmMg==
X-Gm-Message-State: APjAAAU9W9LMjCUGkKFtNSkxcAR1MkaZtapNswDSQz1b5Yxz2ahh5y9K
        3C0Kq9rds6NoRfUVgyj1c56zqhf7Kb1WCPCM
X-Google-Smtp-Source: APXvYqws01n8gMC81BC+XnnyQmtlvoO7/3VvQW0/grxt3f8+rFfJ7csJYQOQpquu5yAHGdtOXCkBcQ==
X-Received: by 2002:a17:90a:2464:: with SMTP id h91mr17725096pje.9.1569689420728;
        Sat, 28 Sep 2019 09:50:20 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id 30sm8663092pjk.25.2019.09.28.09.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Sep 2019 09:50:19 -0700 (PDT)
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
Subject: [PATCH net v4 09/12] net: core: add ignore flag to netdev_adjacent structure
Date:   Sat, 28 Sep 2019 16:48:40 +0000
Message-Id: <20190928164843.31800-10-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190928164843.31800-1-ap420073@gmail.com>
References: <20190928164843.31800-1-ap420073@gmail.com>
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

v3 -> v4 :
 - Add missing static keyword in the dev.c
 - Expose netdev_adjacent_change_{prepare/commit/abort} instead of
   netdev_adjacent_dev_{enable/disable}
v2 -> v3 :
 - Modify nesting infra code to use iterator instead of recursive
v1 -> v2 :
 - This patch is not changed

 include/linux/netdevice.h |  10 ++
 net/core/dev.c            | 234 ++++++++++++++++++++++++++++++++++----
 2 files changed, 222 insertions(+), 22 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 613007aa5986..d1f99d4f41bb 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4333,6 +4333,16 @@ int netdev_master_upper_dev_link(struct net_device *dev,
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
index 13cb646fb98f..0b60bcd5033e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6490,6 +6490,9 @@ struct netdev_adjacent {
 	/* upper master flag, there can only be one master device per list */
 	bool master;
 
+	/* lookup ignore flag */
+	bool ignore;
+
 	/* counter for the number of times this device was added to us */
 	u16 ref_nr;
 
@@ -6512,7 +6515,7 @@ static struct netdev_adjacent *__netdev_find_adj(struct net_device *adj_dev,
 	return NULL;
 }
 
-static int __netdev_has_upper_dev(struct net_device *upper_dev, void *data)
+static int ____netdev_has_upper_dev(struct net_device *upper_dev, void *data)
 {
 	struct net_device *dev = data;
 
@@ -6533,7 +6536,7 @@ bool netdev_has_upper_dev(struct net_device *dev,
 {
 	ASSERT_RTNL();
 
-	return netdev_walk_all_upper_dev_rcu(dev, __netdev_has_upper_dev,
+	return netdev_walk_all_upper_dev_rcu(dev, ____netdev_has_upper_dev,
 					     upper_dev);
 }
 EXPORT_SYMBOL(netdev_has_upper_dev);
@@ -6551,7 +6554,7 @@ EXPORT_SYMBOL(netdev_has_upper_dev);
 bool netdev_has_upper_dev_all_rcu(struct net_device *dev,
 				  struct net_device *upper_dev)
 {
-	return !!netdev_walk_all_upper_dev_rcu(dev, __netdev_has_upper_dev,
+	return !!netdev_walk_all_upper_dev_rcu(dev, ____netdev_has_upper_dev,
 					       upper_dev);
 }
 EXPORT_SYMBOL(netdev_has_upper_dev_all_rcu);
@@ -6595,6 +6598,22 @@ struct net_device *netdev_master_upper_dev_get(struct net_device *dev)
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
@@ -6645,8 +6664,9 @@ struct net_device *netdev_upper_get_next_dev_rcu(struct net_device *dev,
 }
 EXPORT_SYMBOL(netdev_upper_get_next_dev_rcu);
 
-static struct net_device *netdev_next_upper_dev(struct net_device *dev,
-						struct list_head **iter)
+static struct net_device *__netdev_next_upper_dev(struct net_device *dev,
+						  struct list_head **iter,
+						  bool *ignore)
 {
 	struct netdev_adjacent *upper;
 
@@ -6656,6 +6676,7 @@ static struct net_device *netdev_next_upper_dev(struct net_device *dev,
 		return NULL;
 
 	*iter = &upper->list;
+	*ignore = upper->ignore;
 
 	return upper->dev;
 }
@@ -6677,14 +6698,15 @@ static struct net_device *netdev_next_upper_dev_rcu(struct net_device *dev,
 	return upper->dev;
 }
 
-int netdev_walk_all_upper_dev(struct net_device *dev,
-			      int (*fn)(struct net_device *dev,
-					void *data),
-			      void *data)
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
@@ -6698,9 +6720,11 @@ int netdev_walk_all_upper_dev(struct net_device *dev,
 
 		next = NULL;
 		while (1) {
-			udev = netdev_next_upper_dev(now, &iter);
+			udev = __netdev_next_upper_dev(now, &iter, &ignore);
 			if (!udev)
 				break;
+			if (ignore)
+				continue;
 
 			if (!next) {
 				next = udev;
@@ -6777,6 +6801,15 @@ int netdev_walk_all_upper_dev_rcu(struct net_device *dev,
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
@@ -6873,6 +6906,23 @@ static struct net_device *netdev_next_lower_dev(struct net_device *dev,
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
@@ -6923,6 +6973,58 @@ int netdev_walk_all_lower_dev(struct net_device *dev,
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
@@ -6942,11 +7044,14 @@ static u8 __netdev_upper_depth(struct net_device *dev)
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
@@ -6959,11 +7064,14 @@ static u8 __netdev_lower_depth(struct net_device *dev)
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
@@ -7131,6 +7239,7 @@ static int __netdev_adjacent_dev_insert(struct net_device *dev,
 	adj->master = master;
 	adj->ref_nr = 1;
 	adj->private = private;
+	adj->ignore = false;
 	dev_hold(adj_dev);
 
 	pr_debug("Insert adjacency: dev %s adj_dev %s adj->ref_nr %d; dev_hold on %s\n",
@@ -7281,17 +7390,17 @@ static int __netdev_upper_dev_link(struct net_device *dev,
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
@@ -7314,11 +7423,11 @@ static int __netdev_upper_dev_link(struct net_device *dev,
 		goto rollback;
 
 	__netdev_update_upper_level(dev, NULL);
-	netdev_walk_all_lower_dev(dev, __netdev_update_upper_level, NULL);
+	__netdev_walk_all_lower_dev(dev, __netdev_update_upper_level, NULL);
 
 	__netdev_update_lower_level(upper_dev, NULL);
-	netdev_walk_all_upper_dev(upper_dev, __netdev_update_lower_level, NULL);
-
+	__netdev_walk_all_upper_dev(upper_dev, __netdev_update_lower_level,
+				    NULL);
 	return 0;
 
 rollback:
@@ -7403,13 +7512,94 @@ void netdev_upper_dev_unlink(struct net_device *dev,
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

