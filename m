Return-Path: <netdev+bounces-3190-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E418705EB0
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 06:29:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 045811C20D63
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 04:29:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9DFF525C;
	Wed, 17 May 2023 04:28:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C98524B
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:28:50 +0000 (UTC)
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65AD22D43
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 21:28:47 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-561a33b6d63so2455517b3.1
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 21:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684297726; x=1686889726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d/7gA/c6VpSUlE3EoNmEF5z95jsdujFFtQNzT2gDqxE=;
        b=hqOnwH8Ks0oBqZb7vlGnHgNj6ZTamEqSFkZKFU92VKvi9Tpgd3Op2ywcdJWTwpYU2i
         Ut3re6rwCzbM/XBgmMKR+X4H+srlANGOlXLXiPYFjmzIJ/gsk7LO05lTsZvEksN0/5xp
         IHOPH4j3Y3zRUspUwCpiPqPxUoWP2PrPSkO76ub0FnQ0mVgujRwb4waUk7ucBcsC8OMQ
         JiDfu1lu9wU/XVJmJ8PUGcxQqTeJ7B/xphcwywpFi798ZDvASkFnymJbBsocHs90lvgz
         YQPlbPbBTYdmZLOjmmTBl6hELQuC95pnEDPjitfUFJQ8NbwuWyRP4pK+yVKN/nDOWWVl
         v4jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684297726; x=1686889726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d/7gA/c6VpSUlE3EoNmEF5z95jsdujFFtQNzT2gDqxE=;
        b=bpu60sFMrfJXpYf4UlhPtZEjGn5BLzHJtX4FTX0nyu49vrRJXH4GGwvTZ6NF/C+c0C
         QvyF0Fpz/pKpMDU5867Ef5SaDSIPly7emNITUI3Q7SHQxFshE/b9VmGTW8KJ5H6e7gLh
         qP4hE8OIAA0LRoewQmbOB6hn0pZs61pVzB6gvTEh62CumhbAvlqTapUWZqGJmIRkEj32
         AXzVL2Nz35NBU8DiEBea7KiRNDfFu1dnFmWSN6KovoiCDg0CvZttHydTiPvqcdrCpx40
         Kytl5Qrz23pN4Gbd8pCIVj1onRJJZGooRex/d0YJW4shrIRV0leBmWeIDv4POZf2Usnz
         ZsOw==
X-Gm-Message-State: AC+VfDxcX6fYzh9ntBQEb4cpKzUxODIE4eKtYIL6oL17kGfuwZoJoxtZ
	sS2bOebEyrtTdGGoiOT3oUR/Rvhi7Lofpg==
X-Google-Smtp-Source: ACHHUZ5tiN0X/DM8ce3aqBK6QXeAqVjqxyml7CSmSpWU7AQ9uYKDUl7Qy08jOuAtfdaP0vYTuQKobQ==
X-Received: by 2002:a0d:ee41:0:b0:55a:60d1:814b with SMTP id x62-20020a0dee41000000b0055a60d1814bmr35404600ywe.20.1684297726091;
        Tue, 16 May 2023 21:28:46 -0700 (PDT)
Received: from kickker.attlocal.net ([2600:1700:6cf8:1240:30e8:b259:6a48:875c])
        by smtp.gmail.com with ESMTPSA id x136-20020a81a08e000000b0054fcbf35b94sm388780ywg.87.2023.05.16.21.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 21:28:45 -0700 (PDT)
From: Kui-Feng Lee <thinker.li@gmail.com>
X-Google-Original-From: Kui-Feng Lee <kuifeng@meta.com>
To: netdev@vger.kernel.org,
	ast@kernel.org,
	martin.lau@linux.dev,
	kernel-team@meta.com
Cc: Kui-Feng Lee <kuifeng@meta.com>
Subject: [RFC PATCH net-next 2/2] net: Remove unused code and variables.
Date: Tue, 16 May 2023 21:27:57 -0700
Message-Id: <20230517042757.161832-3-kuifeng@meta.com>
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

Since GC has been removed, some functions and variables are useless.  That
includes some sysctl variables that control GC.

Signed-off-by: Kui-Feng Lee <kuifeng@meta.com>
---
 include/net/ip6_fib.h    |   2 -
 include/net/ip6_route.h  |   2 -
 include/net/netns/ipv6.h |   6 ---
 net/ipv6/ip6_fib.c       |  72 -------------------------
 net/ipv6/ndisc.c         |   2 -
 net/ipv6/route.c         | 113 ++-------------------------------------
 6 files changed, 4 insertions(+), 193 deletions(-)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 850995306718..5c7dea981e7a 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -495,8 +495,6 @@ void fib6_rt_update(struct net *net, struct fib6_info *rt,
 void inet6_rt_notify(int event, struct fib6_info *rt, struct nl_info *info,
 		     unsigned int flags);
 
-void fib6_run_gc(unsigned long expires, struct net *net, bool force);
-
 void fib6_gc_cleanup(void);
 
 int fib6_init(void);
diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 3556595ce59a..d99c09ea1859 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -152,8 +152,6 @@ u32 rt6_multipath_hash(const struct net *net, const struct flowi6 *fl6,
 
 struct dst_entry *icmp6_dst_alloc(struct net_device *dev, struct flowi6 *fl6);
 
-void fib6_force_start_gc(struct net *net);
-
 struct fib6_info *addrconf_f6i_alloc(struct net *net, struct inet6_dev *idev,
 				     const struct in6_addr *addr, bool anycast,
 				     gfp_t gfp_flags);
diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index 3cceb3e9320b..64e7d3944637 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -20,12 +20,8 @@ struct netns_sysctl_ipv6 {
 	struct ctl_table_header *frags_hdr;
 	struct ctl_table_header *xfrm6_hdr;
 #endif
-	int flush_delay;
 	int ip6_rt_max_size;
-	int ip6_rt_gc_min_interval;
-	int ip6_rt_gc_timeout;
 	int ip6_rt_gc_interval;
-	int ip6_rt_gc_elasticity;
 	int ip6_rt_mtu_expires;
 	int ip6_rt_min_advmss;
 	u32 multipath_hash_fields;
@@ -70,14 +66,12 @@ struct netns_ipv6 {
 	struct fib6_info	*fib6_null_entry;
 	struct rt6_info		*ip6_null_entry;
 	struct rt6_statistics   *rt6_stats;
-	struct timer_list       ip6_fib_timer;
 	struct hlist_head       *fib_table_hash;
 	struct fib6_table       *fib6_main_tbl;
 	struct list_head	fib6_walkers;
 	rwlock_t		fib6_walker_lock;
 	spinlock_t		fib6_gc_lock;
 	atomic_t		ip6_rt_gc_expire;
-	unsigned long		ip6_rt_last_gc;
 	unsigned char		flowlabel_has_excl;
 #ifdef CONFIG_IPV6_MULTIPLE_TABLES
 	bool			fib6_has_custom_rules;
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 8a10a0355816..72c4c4bf4289 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1391,21 +1391,6 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 	return 0;
 }
 
-static void fib6_start_gc(struct net *net, struct fib6_info *rt)
-{
-	if (!timer_pending(&net->ipv6.ip6_fib_timer) &&
-	    (rt->fib6_flags & RTF_EXPIRES))
-		mod_timer(&net->ipv6.ip6_fib_timer,
-			  jiffies + net->ipv6.sysctl.ip6_rt_gc_interval);
-}
-
-void fib6_force_start_gc(struct net *net)
-{
-	if (!timer_pending(&net->ipv6.ip6_fib_timer))
-		mod_timer(&net->ipv6.ip6_fib_timer,
-			  jiffies + net->ipv6.sysctl.ip6_rt_gc_interval);
-}
-
 static void __fib6_update_sernum_upto_root(struct fib6_info *rt,
 					   int sernum)
 {
@@ -1549,7 +1534,6 @@ int fib6_add(struct fib6_node *root, struct fib6_info *rt,
 		if (rt->nh)
 			list_add(&rt->nh_list, &rt->nh->f6i_list);
 		__fib6_update_sernum_upto_root(rt, fib6_new_sernum(info->nl_net));
-		fib6_start_gc(info->nl_net, rt);
 	}
 
 out:
@@ -2354,59 +2338,6 @@ static void fib6_flush_trees(struct net *net)
 	__fib6_clean_all(net, NULL, new_sernum, NULL, false);
 }
 
-/*
- *	Garbage collection
- */
-
-static int fib6_age(struct fib6_info *rt, void *arg)
-{
-	struct fib6_gc_args *gc_args = arg;
-	unsigned long now = jiffies;
-
-	/*	Also age clones in the exception table.
-	 *	Note, that clones are aged out
-	 *	only if they are not in use now.
-	 */
-	rt6_age_exceptions(rt, gc_args, now);
-
-	return 0;
-}
-
-void fib6_run_gc(unsigned long expires, struct net *net, bool force)
-{
-	struct fib6_gc_args gc_args;
-	unsigned long now;
-
-	if (force) {
-		spin_lock_bh(&net->ipv6.fib6_gc_lock);
-	} else if (!spin_trylock_bh(&net->ipv6.fib6_gc_lock)) {
-		mod_timer(&net->ipv6.ip6_fib_timer, jiffies + HZ);
-		return;
-	}
-	gc_args.timeout = expires ? (int)expires :
-			  net->ipv6.sysctl.ip6_rt_gc_interval;
-	gc_args.more = 0;
-
-	fib6_clean_all(net, fib6_age, &gc_args);
-	now = jiffies;
-	net->ipv6.ip6_rt_last_gc = now;
-
-	if (gc_args.more)
-		mod_timer(&net->ipv6.ip6_fib_timer,
-			  round_jiffies(now
-					+ net->ipv6.sysctl.ip6_rt_gc_interval));
-	else
-		del_timer(&net->ipv6.ip6_fib_timer);
-	spin_unlock_bh(&net->ipv6.fib6_gc_lock);
-}
-
-static void fib6_gc_timer_cb(struct timer_list *t)
-{
-	struct net *arg = from_timer(arg, t, ipv6.ip6_fib_timer);
-
-	fib6_run_gc(0, arg, true);
-}
-
 static int __net_init fib6_net_init(struct net *net)
 {
 	size_t size = sizeof(struct hlist_head) * FIB6_TABLE_HASHSZ;
@@ -2423,7 +2354,6 @@ static int __net_init fib6_net_init(struct net *net)
 	spin_lock_init(&net->ipv6.fib6_gc_lock);
 	rwlock_init(&net->ipv6.fib6_walker_lock);
 	INIT_LIST_HEAD(&net->ipv6.fib6_walkers);
-	timer_setup(&net->ipv6.ip6_fib_timer, fib6_gc_timer_cb, 0);
 
 	net->ipv6.rt6_stats = kzalloc(sizeof(*net->ipv6.rt6_stats), GFP_KERNEL);
 	if (!net->ipv6.rt6_stats)
@@ -2481,8 +2411,6 @@ static void fib6_net_exit(struct net *net)
 {
 	unsigned int i;
 
-	del_timer_sync(&net->ipv6.ip6_fib_timer);
-
 	for (i = 0; i < FIB6_TABLE_HASHSZ; i++) {
 		struct hlist_head *head = &net->ipv6.fib_table_hash[i];
 		struct hlist_node *tmp;
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 1d4cf7f73097..714e4fd8c13d 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1869,7 +1869,6 @@ static int ndisc_netdev_event(struct notifier_block *this, unsigned long event,
 	switch (event) {
 	case NETDEV_CHANGEADDR:
 		neigh_changeaddr(&nd_tbl, dev);
-		fib6_run_gc(0, net, false);
 		fallthrough;
 	case NETDEV_UP:
 		idev = in6_dev_get(dev);
@@ -1898,7 +1897,6 @@ static int ndisc_netdev_event(struct notifier_block *this, unsigned long event,
 		break;
 	case NETDEV_DOWN:
 		neigh_ifdown(&nd_tbl, dev);
-		fib6_run_gc(0, net, false);
 		break;
 	case NETDEV_NOTIFY_PEERS:
 		ndisc_send_unsol_na(dev);
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 87721a2a91b6..1d2ebbfc5090 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -249,8 +249,7 @@ static void ip6_confirm_neigh(const struct dst_entry *dst, const void *daddr)
 
 static struct dst_ops ip6_dst_ops_template = {
 	.family			=	AF_INET6,
-	.gc			=	ip6_dst_gc,
-	.gc_thresh		=	1024,
+	.gc_thresh		=	~0,
 	.check			=	ip6_dst_check,
 	.default_advmss		=	ip6_default_advmss,
 	.mtu			=	ip6_mtu,
@@ -1724,7 +1723,6 @@ static int rt6_insert_exception(struct rt6_info *nrt,
 		spin_lock_bh(&f6i->fib6_table->tb6_lock);
 		fib6_update_sernum(net, f6i);
 		spin_unlock_bh(&f6i->fib6_table->tb6_lock);
-		fib6_force_start_gc(net);
 	}
 
 	return err;
@@ -3283,28 +3281,6 @@ struct dst_entry *icmp6_dst_alloc(struct net_device *dev,
 	return dst;
 }
 
-static void ip6_dst_gc(struct dst_ops *ops)
-{
-	struct net *net = container_of(ops, struct net, ipv6.ip6_dst_ops);
-	int rt_min_interval = net->ipv6.sysctl.ip6_rt_gc_min_interval;
-	int rt_elasticity = net->ipv6.sysctl.ip6_rt_gc_elasticity;
-	int rt_gc_timeout = net->ipv6.sysctl.ip6_rt_gc_timeout;
-	unsigned long rt_last_gc = net->ipv6.ip6_rt_last_gc;
-	unsigned int val;
-	int entries;
-
-	if (time_after(rt_last_gc + rt_min_interval, jiffies))
-		goto out;
-
-	fib6_run_gc(atomic_inc_return(&net->ipv6.ip6_rt_gc_expire), net, true);
-	entries = dst_entries_get_slow(ops);
-	if (entries < ops->gc_thresh)
-		atomic_set(&net->ipv6.ip6_rt_gc_expire, rt_gc_timeout >> 1);
-out:
-	val = atomic_read(&net->ipv6.ip6_rt_gc_expire);
-	atomic_set(&net->ipv6.ip6_rt_gc_expire, val - (val >> rt_elasticity));
-}
-
 static int ip6_nh_lookup_table(struct net *net, struct fib6_config *cfg,
 			       const struct in6_addr *gw_addr, u32 tbid,
 			       int flags, struct fib6_result *res)
@@ -6319,25 +6295,6 @@ static int rt6_stats_seq_show(struct seq_file *seq, void *v)
 
 #ifdef CONFIG_SYSCTL
 
-static int ipv6_sysctl_rtcache_flush(struct ctl_table *ctl, int write,
-			      void *buffer, size_t *lenp, loff_t *ppos)
-{
-	struct net *net;
-	int delay;
-	int ret;
-	if (!write)
-		return -EINVAL;
-
-	net = (struct net *)ctl->extra1;
-	delay = net->ipv6.sysctl.flush_delay;
-	ret = proc_dointvec(ctl, write, buffer, lenp, ppos);
-	if (ret)
-		return ret;
-
-	fib6_run_gc(delay <= 0 ? 0 : (unsigned long)delay, net, delay > 0);
-	return 0;
-}
-
 static struct ctl_table ipv6_route_table_template[] = {
 	{
 		.procname	=	"max_size",
@@ -6346,48 +6303,6 @@ static struct ctl_table ipv6_route_table_template[] = {
 		.mode		=	0644,
 		.proc_handler	=	proc_dointvec,
 	},
-	{
-		.procname	=	"gc_thresh",
-		.data		=	&ip6_dst_ops_template.gc_thresh,
-		.maxlen		=	sizeof(int),
-		.mode		=	0644,
-		.proc_handler	=	proc_dointvec,
-	},
-	{
-		.procname	=	"flush",
-		.data		=	&init_net.ipv6.sysctl.flush_delay,
-		.maxlen		=	sizeof(int),
-		.mode		=	0200,
-		.proc_handler	=	ipv6_sysctl_rtcache_flush
-	},
-	{
-		.procname	=	"gc_min_interval",
-		.data		=	&init_net.ipv6.sysctl.ip6_rt_gc_min_interval,
-		.maxlen		=	sizeof(int),
-		.mode		=	0644,
-		.proc_handler	=	proc_dointvec_jiffies,
-	},
-	{
-		.procname	=	"gc_timeout",
-		.data		=	&init_net.ipv6.sysctl.ip6_rt_gc_timeout,
-		.maxlen		=	sizeof(int),
-		.mode		=	0644,
-		.proc_handler	=	proc_dointvec_jiffies,
-	},
-	{
-		.procname	=	"gc_interval",
-		.data		=	&init_net.ipv6.sysctl.ip6_rt_gc_interval,
-		.maxlen		=	sizeof(int),
-		.mode		=	0644,
-		.proc_handler	=	proc_dointvec_jiffies,
-	},
-	{
-		.procname	=	"gc_elasticity",
-		.data		=	&init_net.ipv6.sysctl.ip6_rt_gc_elasticity,
-		.maxlen		=	sizeof(int),
-		.mode		=	0644,
-		.proc_handler	=	proc_dointvec,
-	},
 	{
 		.procname	=	"mtu_expires",
 		.data		=	&init_net.ipv6.sysctl.ip6_rt_mtu_expires,
@@ -6402,13 +6317,6 @@ static struct ctl_table ipv6_route_table_template[] = {
 		.mode		=	0644,
 		.proc_handler	=	proc_dointvec,
 	},
-	{
-		.procname	=	"gc_min_interval_ms",
-		.data		=	&init_net.ipv6.sysctl.ip6_rt_gc_min_interval,
-		.maxlen		=	sizeof(int),
-		.mode		=	0644,
-		.proc_handler	=	proc_dointvec_ms_jiffies,
-	},
 	{
 		.procname	=	"skip_notify_on_dev_down",
 		.data		=	&init_net.ipv6.sysctl.skip_notify_on_dev_down,
@@ -6431,17 +6339,9 @@ struct ctl_table * __net_init ipv6_route_sysctl_init(struct net *net)
 
 	if (table) {
 		table[0].data = &net->ipv6.sysctl.ip6_rt_max_size;
-		table[1].data = &net->ipv6.ip6_dst_ops.gc_thresh;
-		table[2].data = &net->ipv6.sysctl.flush_delay;
-		table[2].extra1 = net;
-		table[3].data = &net->ipv6.sysctl.ip6_rt_gc_min_interval;
-		table[4].data = &net->ipv6.sysctl.ip6_rt_gc_timeout;
-		table[5].data = &net->ipv6.sysctl.ip6_rt_gc_interval;
-		table[6].data = &net->ipv6.sysctl.ip6_rt_gc_elasticity;
-		table[7].data = &net->ipv6.sysctl.ip6_rt_mtu_expires;
-		table[8].data = &net->ipv6.sysctl.ip6_rt_min_advmss;
-		table[9].data = &net->ipv6.sysctl.ip6_rt_gc_min_interval;
-		table[10].data = &net->ipv6.sysctl.skip_notify_on_dev_down;
+		table[1].data = &net->ipv6.sysctl.ip6_rt_mtu_expires;
+		table[2].data = &net->ipv6.sysctl.ip6_rt_min_advmss;
+		table[3].data = &net->ipv6.sysctl.skip_notify_on_dev_down;
 
 		/* Don't export sysctls to unprivileged users */
 		if (net->user_ns != &init_user_ns)
@@ -6504,12 +6404,7 @@ static int __net_init ip6_route_net_init(struct net *net)
 #endif
 #endif
 
-	net->ipv6.sysctl.flush_delay = 0;
 	net->ipv6.sysctl.ip6_rt_max_size = INT_MAX;
-	net->ipv6.sysctl.ip6_rt_gc_min_interval = HZ / 2;
-	net->ipv6.sysctl.ip6_rt_gc_timeout = 60*HZ;
-	net->ipv6.sysctl.ip6_rt_gc_interval = 30*HZ;
-	net->ipv6.sysctl.ip6_rt_gc_elasticity = 9;
 	net->ipv6.sysctl.ip6_rt_mtu_expires = 10*60*HZ;
 	net->ipv6.sysctl.ip6_rt_min_advmss = IPV6_MIN_MTU - 20 - 40;
 	net->ipv6.sysctl.skip_notify_on_dev_down = 0;
-- 
2.34.1


