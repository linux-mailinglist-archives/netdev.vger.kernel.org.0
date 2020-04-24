Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF661B6A36
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 02:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgDXAIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 20:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728046AbgDXAIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 20:08:51 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BF5C09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 17:08:51 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id o185so3753890pgo.3
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 17:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bgrcJbdAM54yhCvKWN7+hyKwB+AZzyGWHKRZCgw0NO4=;
        b=ZMd3S5RWOZ0ajxUUsL7bwEGKFbcg5Lo4huXEV9eKBtoCrnnAz4FEXlNiB3eIJpnEwC
         jQQOcm515nwEBdEGdp15u5X2yvtWILNaF8+JG6Oe+hcyMnk7P6b1vloN/xD+lIeiyaOS
         i4+gWs+IGQ73/VpWpAErBAOXfciUC+YSwdArB8Q47v8RqcPQV3XOqjchcruX1fsJv1Dw
         JyoL4GgWmtoGJtWHtFQnCiqCApNPn1X/kswHdFqNtHnPHB2uQsIrNbJLkFnsjnWFxgHk
         GPw7AnTKWhGNTG1iDtzcKyTxSxRmG1ZoaSHplYwIABPgH6j4RNBm2AsOfEBN+JVoB48R
         s9aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bgrcJbdAM54yhCvKWN7+hyKwB+AZzyGWHKRZCgw0NO4=;
        b=gHogtobgdDeOY18HmtEmWqR7QiXfbzZaZGEFCWxmu3wOjCUNU+oRfuEC6IyFzrU4jF
         54u1GE05dqiDtPSkRQOOoAPkxW3Xd1vEaAl9hfEcBJ72XI+d679x9Au2uoz4tDDM3TVD
         KRlCtiCqV6lxs+qQp2POBT4MOwDs3Gk/iAQbELwqiynRCXntR73k7QQBTTZh9WdjmaKZ
         bDU4j/cISV3MNlgLF57ZdWDW6k+M2aGcm2Z/zi1pNeeJSL7GgXlPSi+NOVyLTAW18Nyh
         5/TCoHSSH9F1WvG+w/MnjxvwuPLk4ySz+UJgZRdvxmKN3p+rrf/WmZNbHTeN1CXiLlgt
         hbQA==
X-Gm-Message-State: AGi0PuZ4D/DsN8XLSgl5rJmEgurfDyDwGRoz80RQ5sOp6GTad9DzF1a6
        7yCE9OcSESsSjXp7J+V5BNCzr3lv
X-Google-Smtp-Source: APiQypK4u+3Ucuxtih4kEL9xrM4lhEGznPXwNsUXQpjmnm1ihghmMqweTnUnr6+e4YQe43JU5+7BgQ==
X-Received: by 2002:a63:e749:: with SMTP id j9mr6124018pgk.319.1587686930975;
        Thu, 23 Apr 2020 17:08:50 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([219.142.146.4])
        by smtp.gmail.com with ESMTPSA id p10sm3836100pff.210.2020.04.23.17.08.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Apr 2020 17:08:50 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org, azhou@ovn.org, blp@ovn.org, u9012063@gmail.com
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v4 1/5] net: openvswitch: expand the meters supported number
Date:   Fri, 24 Apr 2020 08:08:02 +0800
Message-Id: <1587686886-16347-2-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587686886-16347-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1587686886-16347-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

In kernel datapath of Open vSwitch, there are only 1024
buckets of meter in one datapath. If installing more than
1024 (e.g. 8192) meters, it may lead to the performance drop.
But in some case, for example, Open vSwitch used as edge
gateway, there should be 20K at least, where meters used for
IP address bandwidth limitation.

[Open vSwitch userspace datapath has this issue too.]

For more scalable meter, this patch use meter array instead of
hash tables, and expand/shrink the array when necessary. So we
can install more meters than before in the datapath.
Introducing the struct *dp_meter_instance, it's easy to
expand meter though changing the *ti point in the struct
*dp_meter_table.

Cc: Pravin B Shelar <pshelar@ovn.org>
Cc: Andy Zhou <azhou@ovn.org>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Acked-by: Pravin B Shelar <pshelar@ovn.org>
---
 net/openvswitch/datapath.h |   2 +-
 net/openvswitch/meter.c    | 240 ++++++++++++++++++++++++++++---------
 net/openvswitch/meter.h    |  16 ++-
 3 files changed, 195 insertions(+), 63 deletions(-)

diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
index e239a46c2f94..2016dd107939 100644
--- a/net/openvswitch/datapath.h
+++ b/net/openvswitch/datapath.h
@@ -82,7 +82,7 @@ struct datapath {
 	u32 max_headroom;
 
 	/* Switch meters. */
-	struct hlist_head *meters;
+	struct dp_meter_table meter_tbl;
 };
 
 /**
diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 5010d1ddd4bd..f806ded1dd0a 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -19,8 +19,6 @@
 #include "datapath.h"
 #include "meter.h"
 
-#define METER_HASH_BUCKETS 1024
-
 static const struct nla_policy meter_policy[OVS_METER_ATTR_MAX + 1] = {
 	[OVS_METER_ATTR_ID] = { .type = NLA_U32, },
 	[OVS_METER_ATTR_KBPS] = { .type = NLA_FLAG },
@@ -39,6 +37,11 @@ static const struct nla_policy band_policy[OVS_BAND_ATTR_MAX + 1] = {
 	[OVS_BAND_ATTR_STATS] = { .len = sizeof(struct ovs_flow_stats) },
 };
 
+static u32 meter_hash(struct dp_meter_instance *ti, u32 id)
+{
+	return id % ti->n_meters;
+}
+
 static void ovs_meter_free(struct dp_meter *meter)
 {
 	if (!meter)
@@ -47,40 +50,153 @@ static void ovs_meter_free(struct dp_meter *meter)
 	kfree_rcu(meter, rcu);
 }
 
-static struct hlist_head *meter_hash_bucket(const struct datapath *dp,
-					    u32 meter_id)
-{
-	return &dp->meters[meter_id & (METER_HASH_BUCKETS - 1)];
-}
-
 /* Call with ovs_mutex or RCU read lock. */
-static struct dp_meter *lookup_meter(const struct datapath *dp,
+static struct dp_meter *lookup_meter(const struct dp_meter_table *tbl,
 				     u32 meter_id)
 {
+	struct dp_meter_instance *ti = rcu_dereference_ovsl(tbl->ti);
+	u32 hash = meter_hash(ti, meter_id);
 	struct dp_meter *meter;
-	struct hlist_head *head;
 
-	head = meter_hash_bucket(dp, meter_id);
-	hlist_for_each_entry_rcu(meter, head, dp_hash_node,
-				lockdep_ovsl_is_held()) {
-		if (meter->id == meter_id)
-			return meter;
-	}
+	meter = rcu_dereference_ovsl(ti->dp_meters[hash]);
+	if (meter && likely(meter->id == meter_id))
+		return meter;
+
 	return NULL;
 }
 
-static void attach_meter(struct datapath *dp, struct dp_meter *meter)
+static struct dp_meter_instance *dp_meter_instance_alloc(const u32 size)
+{
+	struct dp_meter_instance *ti;
+
+	ti = kvzalloc(sizeof(*ti) +
+		      sizeof(struct dp_meter *) * size,
+		      GFP_KERNEL);
+	if (!ti)
+		return NULL;
+
+	ti->n_meters = size;
+
+	return ti;
+}
+
+static void dp_meter_instance_free(struct dp_meter_instance *ti)
+{
+	kvfree(ti);
+}
+
+static void dp_meter_instance_free_rcu(struct rcu_head *rcu)
+{
+	struct dp_meter_instance *ti;
+
+	ti = container_of(rcu, struct dp_meter_instance, rcu);
+	kvfree(ti);
+}
+
+static int
+dp_meter_instance_realloc(struct dp_meter_table *tbl, u32 size)
+{
+	struct dp_meter_instance *ti = rcu_dereference_ovsl(tbl->ti);
+	int n_meters = min(size, ti->n_meters);
+	struct dp_meter_instance *new_ti;
+	int i;
+
+	new_ti = dp_meter_instance_alloc(size);
+	if (!new_ti)
+		return -ENOMEM;
+
+	for (i = 0; i < n_meters; i++)
+		new_ti->dp_meters[i] =
+			rcu_dereference_ovsl(ti->dp_meters[i]);
+
+	rcu_assign_pointer(tbl->ti, new_ti);
+	call_rcu(&ti->rcu, dp_meter_instance_free_rcu);
+
+	return 0;
+}
+
+static void dp_meter_instance_insert(struct dp_meter_instance *ti,
+				     struct dp_meter *meter)
+{
+	u32 hash;
+
+	hash = meter_hash(ti, meter->id);
+	rcu_assign_pointer(ti->dp_meters[hash], meter);
+}
+
+static void dp_meter_instance_remove(struct dp_meter_instance *ti,
+				     struct dp_meter *meter)
 {
-	struct hlist_head *head = meter_hash_bucket(dp, meter->id);
+	u32 hash;
 
-	hlist_add_head_rcu(&meter->dp_hash_node, head);
+	hash = meter_hash(ti, meter->id);
+	RCU_INIT_POINTER(ti->dp_meters[hash], NULL);
 }
 
-static void detach_meter(struct dp_meter *meter)
+static int attach_meter(struct dp_meter_table *tbl, struct dp_meter *meter)
 {
+	struct dp_meter_instance *ti = rcu_dereference_ovsl(tbl->ti);
+	u32 hash = meter_hash(ti, meter->id);
+
+	/* In generally, slots selected should be empty, because
+	 * OvS uses id-pool to fetch a available id.
+	 */
+	if (unlikely(rcu_dereference_ovsl(ti->dp_meters[hash])))
+		return -EBUSY;
+
+	dp_meter_instance_insert(ti, meter);
+
+	/* That function is thread-safe. */
+	if (++tbl->count >= ti->n_meters)
+		if (dp_meter_instance_realloc(tbl, ti->n_meters * 2))
+			goto expand_err;
+
+	return 0;
+
+expand_err:
+	dp_meter_instance_remove(ti, meter);
+	tbl->count--;
+	return -ENOMEM;
+}
+
+static int detach_meter(struct dp_meter_table *tbl, struct dp_meter *meter)
+{
+	struct dp_meter_instance *ti;
+
 	ASSERT_OVSL();
-	if (meter)
-		hlist_del_rcu(&meter->dp_hash_node);
+	if (!meter)
+		return 0;
+
+	ti = rcu_dereference_ovsl(tbl->ti);
+	dp_meter_instance_remove(ti, meter);
+
+	tbl->count--;
+
+	/* Shrink the meter array if necessary. */
+	if (ti->n_meters > DP_METER_ARRAY_SIZE_MIN &&
+	    tbl->count <= (ti->n_meters / 4)) {
+		int half_size = ti->n_meters / 2;
+		int i;
+
+		/* Avoid hash collision, don't move slots to other place.
+		 * Make sure there are no references of meters in array
+		 * which will be released.
+		 */
+		for (i = half_size; i < ti->n_meters; i++)
+			if (rcu_dereference_ovsl(ti->dp_meters[i]))
+				goto out;
+
+		if (dp_meter_instance_realloc(tbl, half_size))
+			goto shrink_err;
+	}
+
+out:
+	return 0;
+
+shrink_err:
+	dp_meter_instance_insert(ti, meter);
+	tbl->count++;
+	return -ENOMEM;
 }
 
 static struct sk_buff *
@@ -273,6 +389,7 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, struct genl_info *info)
 	struct sk_buff *reply;
 	struct ovs_header *ovs_reply_header;
 	struct ovs_header *ovs_header = info->userhdr;
+	struct dp_meter_table *meter_tbl;
 	struct datapath *dp;
 	int err;
 	u32 meter_id;
@@ -300,12 +417,18 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, struct genl_info *info)
 		goto exit_unlock;
 	}
 
+	meter_tbl = &dp->meter_tbl;
 	meter_id = nla_get_u32(a[OVS_METER_ATTR_ID]);
 
-	/* Cannot fail after this. */
-	old_meter = lookup_meter(dp, meter_id);
-	detach_meter(old_meter);
-	attach_meter(dp, meter);
+	old_meter = lookup_meter(meter_tbl, meter_id);
+	err = detach_meter(meter_tbl, old_meter);
+	if (err)
+		goto exit_unlock;
+
+	err = attach_meter(meter_tbl, meter);
+	if (err)
+		goto exit_unlock;
+
 	ovs_unlock();
 
 	/* Build response with the meter_id and stats from
@@ -337,14 +460,14 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, struct genl_info *info)
 
 static int ovs_meter_cmd_get(struct sk_buff *skb, struct genl_info *info)
 {
-	struct nlattr **a = info->attrs;
-	u32 meter_id;
 	struct ovs_header *ovs_header = info->userhdr;
 	struct ovs_header *ovs_reply_header;
+	struct nlattr **a = info->attrs;
+	struct dp_meter *meter;
+	struct sk_buff *reply;
 	struct datapath *dp;
+	u32 meter_id;
 	int err;
-	struct sk_buff *reply;
-	struct dp_meter *meter;
 
 	if (!a[OVS_METER_ATTR_ID])
 		return -EINVAL;
@@ -365,7 +488,7 @@ static int ovs_meter_cmd_get(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	/* Locate meter, copy stats. */
-	meter = lookup_meter(dp, meter_id);
+	meter = lookup_meter(&dp->meter_tbl, meter_id);
 	if (!meter) {
 		err = -ENOENT;
 		goto exit_unlock;
@@ -390,18 +513,17 @@ static int ovs_meter_cmd_get(struct sk_buff *skb, struct genl_info *info)
 
 static int ovs_meter_cmd_del(struct sk_buff *skb, struct genl_info *info)
 {
-	struct nlattr **a = info->attrs;
-	u32 meter_id;
 	struct ovs_header *ovs_header = info->userhdr;
 	struct ovs_header *ovs_reply_header;
+	struct nlattr **a = info->attrs;
+	struct dp_meter *old_meter;
+	struct sk_buff *reply;
 	struct datapath *dp;
+	u32 meter_id;
 	int err;
-	struct sk_buff *reply;
-	struct dp_meter *old_meter;
 
 	if (!a[OVS_METER_ATTR_ID])
 		return -EINVAL;
-	meter_id = nla_get_u32(a[OVS_METER_ATTR_ID]);
 
 	reply = ovs_meter_cmd_reply_start(info, OVS_METER_CMD_DEL,
 					  &ovs_reply_header);
@@ -416,14 +538,19 @@ static int ovs_meter_cmd_del(struct sk_buff *skb, struct genl_info *info)
 		goto exit_unlock;
 	}
 
-	old_meter = lookup_meter(dp, meter_id);
+	meter_id = nla_get_u32(a[OVS_METER_ATTR_ID]);
+	old_meter = lookup_meter(&dp->meter_tbl, meter_id);
 	if (old_meter) {
 		spin_lock_bh(&old_meter->lock);
 		err = ovs_meter_cmd_reply_stats(reply, meter_id, old_meter);
 		WARN_ON(err);
 		spin_unlock_bh(&old_meter->lock);
-		detach_meter(old_meter);
+
+		err = detach_meter(&dp->meter_tbl, old_meter);
+		if (err)
+			goto exit_unlock;
 	}
+
 	ovs_unlock();
 	ovs_meter_free(old_meter);
 	genlmsg_end(reply, ovs_reply_header);
@@ -443,16 +570,16 @@ static int ovs_meter_cmd_del(struct sk_buff *skb, struct genl_info *info)
 bool ovs_meter_execute(struct datapath *dp, struct sk_buff *skb,
 		       struct sw_flow_key *key, u32 meter_id)
 {
-	struct dp_meter *meter;
-	struct dp_meter_band *band;
 	long long int now_ms = div_u64(ktime_get_ns(), 1000 * 1000);
 	long long int long_delta_ms;
-	u32 delta_ms;
-	u32 cost;
+	struct dp_meter_band *band;
+	struct dp_meter *meter;
 	int i, band_exceeded_max = -1;
 	u32 band_exceeded_rate = 0;
+	u32 delta_ms;
+	u32 cost;
 
-	meter = lookup_meter(dp, meter_id);
+	meter = lookup_meter(&dp->meter_tbl, meter_id);
 	/* Do not drop the packet when there is no meter. */
 	if (!meter)
 		return false;
@@ -570,32 +697,27 @@ struct genl_family dp_meter_genl_family __ro_after_init = {
 
 int ovs_meters_init(struct datapath *dp)
 {
-	int i;
+	struct dp_meter_table *tbl = &dp->meter_tbl;
+	struct dp_meter_instance *ti;
 
-	dp->meters = kmalloc_array(METER_HASH_BUCKETS,
-				   sizeof(struct hlist_head), GFP_KERNEL);
-
-	if (!dp->meters)
+	ti = dp_meter_instance_alloc(DP_METER_ARRAY_SIZE_MIN);
+	if (!ti)
 		return -ENOMEM;
 
-	for (i = 0; i < METER_HASH_BUCKETS; i++)
-		INIT_HLIST_HEAD(&dp->meters[i]);
+	rcu_assign_pointer(tbl->ti, ti);
+	tbl->count = 0;
 
 	return 0;
 }
 
 void ovs_meters_exit(struct datapath *dp)
 {
+	struct dp_meter_table *tbl = &dp->meter_tbl;
+	struct dp_meter_instance *ti = rcu_dereference_raw(tbl->ti);
 	int i;
 
-	for (i = 0; i < METER_HASH_BUCKETS; i++) {
-		struct hlist_head *head = &dp->meters[i];
-		struct dp_meter *meter;
-		struct hlist_node *n;
-
-		hlist_for_each_entry_safe(meter, n, head, dp_hash_node)
-			kfree(meter);
-	}
+	for (i = 0; i < ti->n_meters; i++)
+		ovs_meter_free(ti->dp_meters[i]);
 
-	kfree(dp->meters);
+	dp_meter_instance_free(ti);
 }
diff --git a/net/openvswitch/meter.h b/net/openvswitch/meter.h
index f645913870bd..f52052d30a16 100644
--- a/net/openvswitch/meter.h
+++ b/net/openvswitch/meter.h
@@ -13,11 +13,13 @@
 #include <linux/openvswitch.h>
 #include <linux/genetlink.h>
 #include <linux/skbuff.h>
+#include <linux/bits.h>
 
 #include "flow.h"
 struct datapath;
 
 #define DP_MAX_BANDS		1
+#define DP_METER_ARRAY_SIZE_MIN	BIT_ULL(10)
 
 struct dp_meter_band {
 	u32 type;
@@ -30,9 +32,6 @@ struct dp_meter_band {
 struct dp_meter {
 	spinlock_t lock;    /* Per meter lock */
 	struct rcu_head rcu;
-	struct hlist_node dp_hash_node; /*Element in datapath->meters
-					 * hash table.
-					 */
 	u32 id;
 	u16 kbps:1, keep_stats:1;
 	u16 n_bands;
@@ -42,6 +41,17 @@ struct dp_meter {
 	struct dp_meter_band bands[];
 };
 
+struct dp_meter_instance {
+	struct rcu_head rcu;
+	u32 n_meters;
+	struct dp_meter __rcu *dp_meters[];
+};
+
+struct dp_meter_table {
+	struct dp_meter_instance __rcu *ti;
+	u32 count;
+};
+
 extern struct genl_family dp_meter_genl_family;
 int ovs_meters_init(struct datapath *dp);
 void ovs_meters_exit(struct datapath *dp);
-- 
2.23.0

