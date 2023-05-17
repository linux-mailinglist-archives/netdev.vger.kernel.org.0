Return-Path: <netdev+bounces-3189-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D1405705EAE
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 06:29:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE4441C20C2E
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 04:29:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 538C04411;
	Wed, 17 May 2023 04:28:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BB8524B
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:28:49 +0000 (UTC)
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029241FEB
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 21:28:45 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-55a64f0053fso2464837b3.3
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 21:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684297724; x=1686889724;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a9SePqv2sA4WBykfynVUqE0c5GYx2e/4PQNghak+by8=;
        b=GT7U5gJ1zuRSFTh3GNhCvJIlEylP5+gdB2e6r4au8yr/1a5OXxI97mPBlbF7NFSxAA
         djnPOZbkC7t4D6rmlvdbrRfUgDDmC2EiaeLh6RDjsiN0/tAe4FEc3BWPrVIBlDdUKgYt
         BHsrfV5pfhajNIKvUJ0k/a4/WgGD1zkNDLQCSfRRCZ9aTT7GDBUcS+OlpRm+dVAP7hNd
         jMPuoj2vqGE7AMYI5Kt5gpLnVMQ4nuZZckIo3XMn0kzFk4MY8H/ivXrbBeSOL8B/NFon
         yfoNRpqpwiWL2gNTGX6f516s/W9XNhUwWxZWbasQ9ugF5a/NzNDH+UCYlkZXXqGe53lI
         fpfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684297724; x=1686889724;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a9SePqv2sA4WBykfynVUqE0c5GYx2e/4PQNghak+by8=;
        b=j3hxFQy3dVcHWneBwsoHBlsf79LLUKu3hBLq80AZaJDmAxwhg0X6zjiUSTwbwTnREu
         4VPKOkZsDRjYS9XB2LPc6nobI1E/pEPHxSbYOwPBwuhhKkLTuEMj0gNlhntrtcuKRWja
         JZ830jIQiy++eo8rEpamt+thaU6V/6voKuonehCKhW6OyfGg8ZOmTNwVGoKx+M2NIfRk
         Gi7I4jBQLkDXF/LSDEHHDJL3xGlV2zduLa8d1P9eZKk33Wau4mL5fUW7ahDby0rK2Nx8
         ZZgoOzD2xZDSco9/HKI8VowrivMxlPAyor2R9CJtITp5nK39MB0ocCeVePGEV117lY62
         8zdQ==
X-Gm-Message-State: AC+VfDwVhRMKUOQZOotOZyC19UNNnDPWLpGZyGODyKqe6eM6MFVfG0ev
	pm6y/2f6YdrEkBwNhypFqS6I0CAKoyLqkg==
X-Google-Smtp-Source: ACHHUZ5T+uV6NwFZzoNpByxVMw8FBl0Llj0Sbs57xJAqbVOtEY3e6VxVIaJ7yeyABxbzk7QEtvU6Ww==
X-Received: by 2002:a81:74c1:0:b0:561:a124:1c90 with SMTP id p184-20020a8174c1000000b00561a1241c90mr2613226ywc.0.1684297724219;
        Tue, 16 May 2023 21:28:44 -0700 (PDT)
Received: from kickker.attlocal.net ([2600:1700:6cf8:1240:30e8:b259:6a48:875c])
        by smtp.gmail.com with ESMTPSA id x136-20020a81a08e000000b0054fcbf35b94sm388780ywg.87.2023.05.16.21.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 21:28:43 -0700 (PDT)
From: Kui-Feng Lee <thinker.li@gmail.com>
X-Google-Original-From: Kui-Feng Lee <kuifeng@meta.com>
To: netdev@vger.kernel.org,
	ast@kernel.org,
	martin.lau@linux.dev,
	kernel-team@meta.com
Cc: Kui-Feng Lee <kuifeng@meta.com>
Subject: [RFC PATCH net-next 1/2] net: Remove expired routes with separated timers.
Date: Tue, 16 May 2023 21:27:56 -0700
Message-Id: <20230517042757.161832-2-kuifeng@meta.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230517042757.161832-1-kuifeng@meta.com>
References: <20230517042757.161832-1-kuifeng@meta.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

FIB6 GC walks tries of fib6_tables to remove expired routes.  Walking a
tree can be expensive if the number of routes in a table is big.
Creating a separated timer for each route that can expire will avoid
this potential issue.

Signed-off-by: Kui-Feng Lee <kuifeng@meta.com>
---
 include/net/ip6_fib.h | 19 ++++------
 net/ipv6/addrconf.c   |  8 ++--
 net/ipv6/ip6_fib.c    | 88 ++++++++++++++++++++++++++++++++++++-------
 net/ipv6/ndisc.c      |  2 +-
 net/ipv6/route.c      |  6 +--
 5 files changed, 91 insertions(+), 32 deletions(-)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 05e6f756feaf..850995306718 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -161,6 +161,8 @@ struct fib6_nh {
 	struct rt6_exception_bucket __rcu *rt6i_exception_bucket;
 };
 
+struct fib6_info_timer;
+
 struct fib6_info {
 	struct fib6_table		*fib6_table;
 	struct fib6_info __rcu		*fib6_next;
@@ -179,6 +181,7 @@ struct fib6_info {
 
 	refcount_t			fib6_ref;
 	unsigned long			expires;
+	struct fib6_info_timer		*timer;
 	struct dst_metrics		*fib6_metrics;
 #define fib6_pmtu		fib6_metrics->metrics[RTAX_MTU-1]
 
@@ -247,18 +250,11 @@ static inline bool fib6_requires_src(const struct fib6_info *rt)
 	return rt->fib6_src.plen > 0;
 }
 
-static inline void fib6_clean_expires(struct fib6_info *f6i)
-{
-	f6i->fib6_flags &= ~RTF_EXPIRES;
-	f6i->expires = 0;
-}
+void fib6_clean_expires(struct fib6_info *f6i);
 
-static inline void fib6_set_expires(struct fib6_info *f6i,
-				    unsigned long expires)
-{
-	f6i->expires = expires;
-	f6i->fib6_flags |= RTF_EXPIRES;
-}
+void fib6_set_expires(struct net *net,
+		      struct fib6_info *f6i,
+		      unsigned long expires);
 
 static inline bool fib6_check_expired(const struct fib6_info *f6i)
 {
@@ -388,6 +384,7 @@ struct fib6_table {
 	struct inet_peer_base	tb6_peers;
 	unsigned int		flags;
 	unsigned int		fib_seq;
+	struct hlist_head	tb6_timer_hlist;
 #define RT6_TABLE_HAS_DFLT_ROUTER	BIT(0)
 };
 
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 3797917237d0..13e2366613c4 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1254,7 +1254,8 @@ cleanup_prefix_route(struct inet6_ifaddr *ifp, unsigned long expires,
 			ip6_del_rt(dev_net(ifp->idev->dev), f6i, false);
 		else {
 			if (!(f6i->fib6_flags & RTF_EXPIRES))
-				fib6_set_expires(f6i, expires);
+				fib6_set_expires(dev_net(ifp->idev->dev),
+						 f6i, expires);
 			fib6_info_release(f6i);
 		}
 	}
@@ -2762,7 +2763,8 @@ void addrconf_prefix_rcv(struct net_device *dev, u8 *opt, int len, bool sllao)
 				rt = NULL;
 			} else if (addrconf_finite_timeout(rt_expires)) {
 				/* not infinity */
-				fib6_set_expires(rt, jiffies + rt_expires);
+				fib6_set_expires(net, rt,
+						 jiffies + rt_expires);
 			} else {
 				fib6_clean_expires(rt);
 			}
@@ -4723,7 +4725,7 @@ static int modify_prefix_route(struct inet6_ifaddr *ifp,
 		if (!expires)
 			fib6_clean_expires(f6i);
 		else
-			fib6_set_expires(f6i, expires);
+			fib6_set_expires(dev_net(ifp->idev->dev), f6i, expires);
 
 		fib6_info_release(f6i);
 	}
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 2438da5ff6da..8a10a0355816 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -25,6 +25,7 @@
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/slab.h>
+#include <linux/timer.h>
 
 #include <net/ip.h>
 #include <net/ipv6.h>
@@ -54,6 +55,12 @@ struct fib6_cleaner {
 #define FWS_INIT FWS_L
 #endif
 
+struct fib6_info_timer {
+	struct timer_list timer;
+	struct fib6_info *f6i;
+	struct net *net;
+};
+
 static struct fib6_info *fib6_find_prefix(struct net *net,
 					 struct fib6_table *table,
 					 struct fib6_node *fn);
@@ -144,6 +151,66 @@ static __be32 addr_bit_set(const void *token, int fn_bit)
 	       addr[fn_bit >> 5];
 }
 
+static void f6i_gc_timer_cb(struct timer_list *t)
+{
+	struct fib6_info_timer *timer;
+	struct nl_info info = {
+		.nlh = NULL,
+	};
+	struct fib6_info *f6i;
+	int res;
+
+	timer = from_timer(timer, t, timer);
+	info.nl_net = timer->net;
+	f6i = timer->f6i;
+	spin_lock(&f6i->fib6_table->tb6_lock);
+
+	res = fib6_del(f6i, &info);
+	if (res != 0) {
+#if RT6_DEBUG >= 2
+		pr_debug("%s: del failed: rt=%p@%p err=%d\n",
+			 __func__, f6i,
+			 rcu_access_pointer(f6i->fib6_node),
+			 res);
+#endif
+	}
+
+	spin_unlock(&f6i->fib6_table->tb6_lock);
+
+	fib6_info_release(f6i);
+}
+
+void fib6_clean_expires(struct fib6_info *f6i)
+{
+	f6i->fib6_flags &= ~RTF_EXPIRES;
+	f6i->expires = 0;
+	if (!f6i->timer)
+		return;
+	if (try_to_del_timer_sync(&f6i->timer->timer) == 1)
+		fib6_info_release(f6i);
+}
+
+void fib6_set_expires(struct net *net,struct fib6_info *f6i,
+		      unsigned long expires)
+{
+	f6i->expires = expires;
+	f6i->fib6_flags |= RTF_EXPIRES;
+	if (!f6i->timer) {
+		f6i->timer = kzalloc(sizeof(*f6i->timer), GFP_ATOMIC);
+		if (!f6i->timer) {
+			/* XXX: error handling */
+			panic("fib6_set_expires: kzalloc failed");
+			return;
+		}
+		f6i->timer->f6i = f6i;
+		f6i->timer->net = net;
+		timer_setup(&f6i->timer->timer, f6i_gc_timer_cb, 0);
+	}
+	fib6_info_hold(f6i);
+	if (mod_timer(&f6i->timer->timer, expires) == 1)
+		fib6_info_release(f6i);
+}
+
 struct fib6_info *fib6_info_alloc(gfp_t gfp_flags, bool with_fib6_nh)
 {
 	struct fib6_info *f6i;
@@ -175,6 +242,7 @@ void fib6_info_destroy_rcu(struct rcu_head *head)
 		fib6_nh_release(f6i->fib6_nh);
 
 	ip_fib_metrics_put(f6i->fib6_metrics);
+	kfree(f6i->timer);
 	kfree(f6i);
 }
 EXPORT_SYMBOL_GPL(fib6_info_destroy_rcu);
@@ -246,6 +314,7 @@ static struct fib6_table *fib6_alloc_table(struct net *net, u32 id)
 				   net->ipv6.fib6_null_entry);
 		table->tb6_root.fn_flags = RTN_ROOT | RTN_TL_ROOT | RTN_RTINFO;
 		inet_peer_base_init(&table->tb6_peers);
+		INIT_HLIST_HEAD(&table->tb6_timer_hlist);
 	}
 
 	return table;
@@ -1120,7 +1189,8 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 				if (!(rt->fib6_flags & RTF_EXPIRES))
 					fib6_clean_expires(iter);
 				else
-					fib6_set_expires(iter, rt->expires);
+					fib6_set_expires(info->nl_net,
+							 iter, rt->expires);
 
 				if (rt->fib6_pmtu)
 					fib6_metric_set(iter, RTAX_MTU,
@@ -2025,6 +2095,9 @@ int fib6_del(struct fib6_info *rt, struct nl_info *info)
 		if (rt == cur) {
 			if (fib6_requires_src(cur))
 				fib6_routes_require_src_dec(info->nl_net);
+			if (cur->timer &&
+			    try_to_del_timer_sync(&cur->timer->timer) == 1)
+				fib6_info_release(cur);
 			fib6_del_route(table, fn, rtp, info);
 			return 0;
 		}
@@ -2290,19 +2363,6 @@ static int fib6_age(struct fib6_info *rt, void *arg)
 	struct fib6_gc_args *gc_args = arg;
 	unsigned long now = jiffies;
 
-	/*
-	 *	check addrconf expiration here.
-	 *	Routes are expired even if they are in use.
-	 */
-
-	if (rt->fib6_flags & RTF_EXPIRES && rt->expires) {
-		if (time_after(now, rt->expires)) {
-			RT6_TRACE("expiring %p\n", rt);
-			return -1;
-		}
-		gc_args->more++;
-	}
-
 	/*	Also age clones in the exception table.
 	 *	Note, that clones are aged out
 	 *	only if they are not in use now.
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 18634ebd20a4..1d4cf7f73097 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1407,7 +1407,7 @@ static enum skb_drop_reason ndisc_router_discovery(struct sk_buff *skb)
 	}
 
 	if (rt)
-		fib6_set_expires(rt, jiffies + (HZ * lifetime));
+		fib6_set_expires(net, rt, jiffies + (HZ * lifetime));
 	if (in6_dev->cnf.accept_ra_min_hop_limit < 256 &&
 	    ra_msg->icmph.icmp6_hop_limit) {
 		if (in6_dev->cnf.accept_ra_min_hop_limit <= ra_msg->icmph.icmp6_hop_limit) {
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index e3aec46bd466..87721a2a91b6 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -990,7 +990,7 @@ int rt6_route_rcv(struct net_device *dev, u8 *opt, int len,
 		if (!addrconf_finite_timeout(lifetime))
 			fib6_clean_expires(rt);
 		else
-			fib6_set_expires(rt, jiffies + HZ * lifetime);
+			fib6_set_expires(net, rt, jiffies + HZ * lifetime);
 
 		fib6_info_release(rt);
 	}
@@ -3755,8 +3755,8 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
 		rt->dst_nocount = true;
 
 	if (cfg->fc_flags & RTF_EXPIRES)
-		fib6_set_expires(rt, jiffies +
-				clock_t_to_jiffies(cfg->fc_expires));
+		fib6_set_expires(net, rt, jiffies +
+				 clock_t_to_jiffies(cfg->fc_expires));
 	else
 		fib6_clean_expires(rt);
 
-- 
2.34.1


