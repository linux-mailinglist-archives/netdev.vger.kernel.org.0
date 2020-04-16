Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04CC81AF2CE
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 19:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgDRRZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 13:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgDRRZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 13:25:12 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A53C061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 10:25:11 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id g6so2806239pgs.9
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 10:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eCMGd0hj6wiyX2tXp+ELFr/xoQ/OXQELJzuPmPPqyqg=;
        b=FeQL9YY2z2SrH+95RmoUj23C/xb1s0bADr2kSN2n9m6nY0E+KCQbZzkwHf9jEkwmzn
         lCS5m1QSSspXy0E/faDlcai2//Fx1CorT6TNl+p9WFgA284lI355cfH6xGcmtnLxZnXB
         w6gnwKdLkLfolnvoYzRKHAWrQWWBp7L3Pcy0IlAs4o/uLPzKT5h0E51LDBxXGUjCO019
         dhSf+pUNr0mSI0/y9DN8Jh0BbSsnE4DNJpJU132z7kdXgxEbQTV9rmQQ6VVDKmXmIgaX
         1ICpwK3hbxz9tnGUHJ/HiikJFmUuJtYegLutjfuLyxg11Ti9PCEHDsGTSSmKzls2QmJn
         O5FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eCMGd0hj6wiyX2tXp+ELFr/xoQ/OXQELJzuPmPPqyqg=;
        b=l6Rpybc4NbSqbHNDyYri7SWMi/5ElL6XxfCuW5Q4dAcqHKUmwd29nkzx9SwoIksf/c
         pze3OKWal8FyvwlJNH+fqkyd9KEx3P7pBIT9/24f1bPgG8lkJ0OKcvdjbOhEADDFQgg1
         OfxKC+YWi9U7AV/8KVosrPFuCskckwVD/I4QCkmm1aS9RIvUJwlU43ujZ2COi0EDqY+u
         G1DDsnXHbT00v//fqCljZTrehnku4JZ1wlqEsMP6z8UoSsQJM76GB+6tXHivanDPh8p0
         8kG1fo266Rlsm6wh95c7o4srANjLKmvG+2niDWnKxeng05DONkCu7x3dWvT+GFDumMbd
         QxYw==
X-Gm-Message-State: AGi0PuYgwxPAsTAwlIKWB+ZcbZOsYVUcde8CvLnD1xc7sdzth00JaBpw
        jIUVMEYLq2cf3BiY/jvpUMbnFGt2
X-Google-Smtp-Source: APiQypJpUTiViBbGshTB70D+lQ/zO5uNrQtod9LMjzGKM93x5FAyUKTx+ykK0jXuNPG9bR3uxNYrhQ==
X-Received: by 2002:a63:4526:: with SMTP id s38mr8850325pga.410.1587230710555;
        Sat, 18 Apr 2020 10:25:10 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([115.171.63.184])
        by smtp.gmail.com with ESMTPSA id s44sm9329251pjc.28.2020.04.18.10.25.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 Apr 2020 10:25:10 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org, azhou@ovn.org, blp@ovn.org, u9012063@gmail.com
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v2 1/5] net: openvswitch: expand the meters supported number
Date:   Thu, 16 Apr 2020 18:16:59 +0800
Message-Id: <1587032223-49460-2-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587032223-49460-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1587032223-49460-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

In kernel datapath of Open vSwitch, there are only 1024
buckets of meter in one dp. If installing more than 1024
(e.g. 8192) meters, it may lead to the performance drop.
But in some case, for example, Open vSwitch used as edge
gateway, there should be 200,000+ at least, meters used for
IP address bandwidth limitation.

[Open vSwitch userspace datapath has this issue too.]

For more scalable meter, this patch expands the buckets
when necessary, so we can install more meters in the datapath.
Introducing the struct *dp_meter_instance*, it's easy to
expand meter though changing the *ti* point in the struct
*dp_meter_table*.

Cc: Pravin B Shelar <pshelar@ovn.org>
Cc: Andy Zhou <azhou@ovn.org>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/datapath.h |   2 +-
 net/openvswitch/meter.c    | 200 +++++++++++++++++++++++++++++--------
 net/openvswitch/meter.h    |  15 ++-
 3 files changed, 169 insertions(+), 48 deletions(-)

diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
index e239a46c2f94..785105578448 100644
--- a/net/openvswitch/datapath.h
+++ b/net/openvswitch/datapath.h
@@ -82,7 +82,7 @@ struct datapath {
 	u32 max_headroom;
 
 	/* Switch meters. */
-	struct hlist_head *meters;
+	struct dp_meter_table *meters;
 };
 
 /**
diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 5010d1ddd4bd..494a0014ecd8 100644
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
@@ -47,40 +50,141 @@ static void ovs_meter_free(struct dp_meter *meter)
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
+	/*
+	 * In generally, slot selected should be empty, because
+	 * OvS uses id-pool to fetch a available id.
+	 */
+	if (unlikely(rcu_dereference_ovsl(ti->dp_meters[hash])))
+		return -EINVAL;
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
+static void detach_meter(struct dp_meter_table *tbl, struct dp_meter *meter)
+{
+	struct dp_meter_instance *ti;
+
 	ASSERT_OVSL();
-	if (meter)
-		hlist_del_rcu(&meter->dp_hash_node);
+	if (!meter)
+		return;
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
+		for (i = half_size; i < ti->n_meters; i++)
+			if (rcu_dereference_ovsl(ti->dp_meters[i]))
+				return;
+
+		dp_meter_instance_realloc(tbl, half_size);
+	}
 }
 
 static struct sk_buff *
@@ -303,9 +407,13 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, struct genl_info *info)
 	meter_id = nla_get_u32(a[OVS_METER_ATTR_ID]);
 
 	/* Cannot fail after this. */
-	old_meter = lookup_meter(dp, meter_id);
-	detach_meter(old_meter);
-	attach_meter(dp, meter);
+	old_meter = lookup_meter(dp->meters, meter_id);
+	detach_meter(dp->meters, old_meter);
+
+	err = attach_meter(dp->meters, meter);
+	if (err)
+		goto exit_unlock;
+
 	ovs_unlock();
 
 	/* Build response with the meter_id and stats from
@@ -365,7 +473,7 @@ static int ovs_meter_cmd_get(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	/* Locate meter, copy stats. */
-	meter = lookup_meter(dp, meter_id);
+	meter = lookup_meter(dp->meters, meter_id);
 	if (!meter) {
 		err = -ENOENT;
 		goto exit_unlock;
@@ -416,13 +524,13 @@ static int ovs_meter_cmd_del(struct sk_buff *skb, struct genl_info *info)
 		goto exit_unlock;
 	}
 
-	old_meter = lookup_meter(dp, meter_id);
+	old_meter = lookup_meter(dp->meters, meter_id);
 	if (old_meter) {
 		spin_lock_bh(&old_meter->lock);
 		err = ovs_meter_cmd_reply_stats(reply, meter_id, old_meter);
 		WARN_ON(err);
 		spin_unlock_bh(&old_meter->lock);
-		detach_meter(old_meter);
+		detach_meter(dp->meters, old_meter);
 	}
 	ovs_unlock();
 	ovs_meter_free(old_meter);
@@ -452,7 +560,7 @@ bool ovs_meter_execute(struct datapath *dp, struct sk_buff *skb,
 	int i, band_exceeded_max = -1;
 	u32 band_exceeded_rate = 0;
 
-	meter = lookup_meter(dp, meter_id);
+	meter = lookup_meter(dp->meters, meter_id);
 	/* Do not drop the packet when there is no meter. */
 	if (!meter)
 		return false;
@@ -570,32 +678,36 @@ struct genl_family dp_meter_genl_family __ro_after_init = {
 
 int ovs_meters_init(struct datapath *dp)
 {
-	int i;
+	struct dp_meter_instance *ti;
+	struct dp_meter_table *tbl;
+
+	tbl = kmalloc(sizeof(*tbl), GFP_KERNEL);
+	if (!tbl)
+		return -ENOMEM;
 
-	dp->meters = kmalloc_array(METER_HASH_BUCKETS,
-				   sizeof(struct hlist_head), GFP_KERNEL);
+	tbl->count = 0;
 
-	if (!dp->meters)
+	ti = dp_meter_instance_alloc(DP_METER_ARRAY_SIZE_MIN);
+	if (!ti) {
+		kfree(tbl);
 		return -ENOMEM;
+	}
 
-	for (i = 0; i < METER_HASH_BUCKETS; i++)
-		INIT_HLIST_HEAD(&dp->meters[i]);
+	rcu_assign_pointer(tbl->ti, ti);
+	dp->meters = tbl;
 
 	return 0;
 }
 
 void ovs_meters_exit(struct datapath *dp)
 {
+	struct dp_meter_table *tbl = dp->meters;
+	struct dp_meter_instance *ti = rcu_dereference_ovsl(tbl->ti);
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
+	kfree(tbl);
 }
diff --git a/net/openvswitch/meter.h b/net/openvswitch/meter.h
index f645913870bd..d91940383bbe 100644
--- a/net/openvswitch/meter.h
+++ b/net/openvswitch/meter.h
@@ -18,6 +18,7 @@
 struct datapath;
 
 #define DP_MAX_BANDS		1
+#define DP_METER_ARRAY_SIZE_MIN	(1ULL << 10)
 
 struct dp_meter_band {
 	u32 type;
@@ -30,9 +31,6 @@ struct dp_meter_band {
 struct dp_meter {
 	spinlock_t lock;    /* Per meter lock */
 	struct rcu_head rcu;
-	struct hlist_node dp_hash_node; /*Element in datapath->meters
-					 * hash table.
-					 */
 	u32 id;
 	u16 kbps:1, keep_stats:1;
 	u16 n_bands;
@@ -42,6 +40,17 @@ struct dp_meter {
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

