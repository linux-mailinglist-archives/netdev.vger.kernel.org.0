Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5836D4E1EE9
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 02:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344100AbiCUB5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 21:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242733AbiCUB5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 21:57:43 -0400
Received: from tmailer.gwdg.de (tmailer.gwdg.de [134.76.10.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAFC815B072;
        Sun, 20 Mar 2022 18:56:17 -0700 (PDT)
Received: from excmbx-17.um.gwdg.de ([134.76.9.228] helo=email.gwdg.de)
        by mailer.gwdg.de with esmtp (GWDG Mailer)
        (envelope-from <alexander.vorwerk@stud.uni-goettingen.de>)
        id 1nW7HH-0006vC-Lh; Mon, 21 Mar 2022 02:56:11 +0100
Received: from notebook.fritz.box (10.250.9.199) by excmbx-17.um.gwdg.de
 (134.76.9.228) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id 15.1.2375.24; Mon, 21
 Mar 2022 02:56:10 +0100
From:   Alexander Vorwerk <alexander.vorwerk@stud.uni-goettingen.de>
To:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Alexander Vorwerk <alexander.vorwerk@stud.uni-goettingen.de>
Subject: [PATCH] net: ipv4: update route.c to match coding-style guidelines
Date:   Mon, 21 Mar 2022 02:55:50 +0100
Message-ID: <20220321015550.11255-1-alexander.vorwerk@stud.uni-goettingen.de>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.250.9.199]
X-ClientProxiedBy: excmbx-14.um.gwdg.de (134.76.9.225) To excmbx-17.um.gwdg.de
 (134.76.9.228)
X-Virus-Scanned: (clean) by clamav
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel has some code coding-stlye guidelines defined at
Documentation/process/coding-style.rst

This patch fixes most of the code-style issues in route.c

Signed-off-by: Alexander Vorwerk <alexander.vorwerk@stud.uni-goettingen.de>
---
 net/ipv4/route.c | 75 ++++++++++++++++++++++--------------------------
 1 file changed, 35 insertions(+), 40 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 63f3256a407d..7daf63f2f1dd 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -109,7 +109,7 @@
 #define RT_FL_TOS(oldflp4) \
 	((oldflp4)->flowi4_tos & (IPTOS_RT_MASK | RTO_ONLINK))
 
-#define RT_GC_TIMEOUT (300*HZ)
+#define RT_GC_TIMEOUT (300 * HZ)
 
 #define DEFAULT_MIN_PMTU (512 + 20 + 20)
 #define DEFAULT_MTU_EXPIRES (10 * 60 * HZ)
@@ -235,10 +235,10 @@ static void *rt_cpu_seq_start(struct seq_file *seq, loff_t *pos)
 	if (*pos == 0)
 		return SEQ_START_TOKEN;
 
-	for (cpu = *pos-1; cpu < nr_cpu_ids; ++cpu) {
+	for (cpu = *pos - 1; cpu < nr_cpu_ids; ++cpu) {
 		if (!cpu_possible(cpu))
 			continue;
-		*pos = cpu+1;
+		*pos = cpu + 1;
 		return &per_cpu(rt_cache_stat, cpu);
 	}
 	return NULL;
@@ -251,12 +251,11 @@ static void *rt_cpu_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	for (cpu = *pos; cpu < nr_cpu_ids; ++cpu) {
 		if (!cpu_possible(cpu))
 			continue;
-		*pos = cpu+1;
+		*pos = cpu + 1;
 		return &per_cpu(rt_cache_stat, cpu);
 	}
 	(*pos)++;
 	return NULL;
-
 }
 
 static void rt_cpu_seq_stop(struct seq_file *seq, void *v)
@@ -348,7 +347,7 @@ static int __net_init ip_rt_do_proc_init(struct net *net)
 
 #ifdef CONFIG_IP_ROUTE_CLASSID
 	pde = proc_create_single("rt_acct", 0, net->proc_net,
-			rt_acct_proc_show);
+				 rt_acct_proc_show);
 	if (!pde)
 		goto err3;
 #endif
@@ -414,7 +413,7 @@ static struct neighbour *ipv4_neigh_lookup(const struct dst_entry *dst,
 		n = ip_neigh_gw4(dev, rt->rt_gw4);
 	} else if (rt->rt_gw_family == AF_INET6) {
 		n = ip_neigh_gw6(dev, &rt->rt_gw6);
-        } else {
+	} else {
 		__be32 pkey;
 
 		pkey = skb ? ip_hdr(skb)->daddr : *((__be32 *) daddr);
@@ -782,8 +781,8 @@ static void __ip_do_redirect(struct rtable *rt, struct sk_buff *skb, struct flow
 				fib_select_path(net, &res, fl4, skb);
 				nhc = FIB_RES_NHC(res);
 				update_or_create_fnhe(nhc, fl4->daddr, new_gw,
-						0, false,
-						jiffies + ip_rt_gc_timeout);
+						      0, false,
+						      jiffies + ip_rt_gc_timeout);
 			}
 			if (kill_route)
 				rt->dst.obsolete = DST_OBSOLETE_KILL;
@@ -796,7 +795,7 @@ static void __ip_do_redirect(struct rtable *rt, struct sk_buff *skb, struct flow
 reject_redirect:
 #ifdef CONFIG_IP_ROUTE_VERBOSE
 	if (IN_DEV_LOG_MARTIANS(in_dev)) {
-		const struct iphdr *iph = (const struct iphdr *) skb->data;
+		const struct iphdr *iph = (const struct iphdr *)skb->data;
 		__be32 daddr = iph->daddr;
 		__be32 saddr = iph->saddr;
 
@@ -813,14 +812,14 @@ static void ip_do_redirect(struct dst_entry *dst, struct sock *sk, struct sk_buf
 {
 	struct rtable *rt;
 	struct flowi4 fl4;
-	const struct iphdr *iph = (const struct iphdr *) skb->data;
+	const struct iphdr *iph = (const struct iphdr *)skb->data;
 	struct net *net = dev_net(skb->dev);
 	int oif = skb->dev->ifindex;
 	u8 tos = RT_TOS(iph->tos);
 	u8 prot = iph->protocol;
 	u32 mark = skb->mark;
 
-	rt = (struct rtable *) dst;
+	rt = (struct rtable *)dst;
 
 	__build_flow_key(net, &fl4, sk, iph, oif, tos, prot, mark, 0);
 	__ip_do_redirect(rt, skb, &fl4, true);
@@ -844,8 +843,7 @@ static struct dst_entry *ipv4_negative_advice(struct dst_entry *dst)
 	return ret;
 }
 
-/*
- * Algorithm:
+/* Algorithm:
  *	1. The first ip_rt_redirect_number redirects are sent
  *	   with exponential backoff, then we stop sending them at all,
  *	   assuming that the host ignores our redirects.
@@ -1043,7 +1041,7 @@ static void ip_rt_update_pmtu(struct dst_entry *dst, struct sock *sk,
 			      struct sk_buff *skb, u32 mtu,
 			      bool confirm_neigh)
 {
-	struct rtable *rt = (struct rtable *) dst;
+	struct rtable *rt = (struct rtable *)dst;
 	struct flowi4 fl4;
 
 	ip_rt_build_flow_key(&fl4, sk, skb);
@@ -1181,7 +1179,7 @@ EXPORT_SYMBOL_GPL(ipv4_sk_redirect);
 INDIRECT_CALLABLE_SCOPE struct dst_entry *ipv4_dst_check(struct dst_entry *dst,
 							 u32 cookie)
 {
-	struct rtable *rt = (struct rtable *) dst;
+	struct rtable *rt = (struct rtable *)dst;
 
 	/* All IPV4 dsts are created with ->obsolete set to the value
 	 * DST_OBSOLETE_FORCE_CHK which forces validation calls down
@@ -1246,8 +1244,7 @@ static int ip_rt_bug(struct net *net, struct sock *sk, struct sk_buff *skb)
 	return 0;
 }
 
-/*
- * We do not cache source address of outgoing interface,
+/* We do not cache source address of outgoing interface,
  * because it is used only by IP RR, TS and SRR options,
  * so that it out of fast path.
  *
@@ -1259,9 +1256,9 @@ void ip_rt_get_source(u8 *addr, struct sk_buff *skb, struct rtable *rt)
 {
 	__be32 src;
 
-	if (rt_is_output_route(rt))
+	if (rt_is_output_route(rt)) {
 		src = ip_hdr(skb)->saddr;
-	else {
+	} else {
 		struct fib_result res;
 		struct iphdr *iph = ip_hdr(skb);
 		struct flowi4 fl4 = {
@@ -1600,8 +1597,9 @@ static void rt_set_nexthop(struct rtable *rt, __be32 daddr,
 			}
 			rt_add_uncached_list(rt);
 		}
-	} else
+	} else {
 		rt_add_uncached_list(rt);
+	}
 
 #ifdef CONFIG_IP_ROUTE_CLASSID
 #ifdef CONFIG_IP_MULTIPLE_TABLES
@@ -1732,7 +1730,7 @@ static int ip_route_input_mc(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	rth->dst.tclassid = itag;
 #endif
 	rth->dst.output = ip_rt_bug;
-	rth->rt_is_input= 1;
+	rth->rt_is_input = 1;
 
 #ifdef CONFIG_IP_MROUTE
 	if (!ipv4_is_local_multicast(daddr) && IN_DEV_MFORWARD(in_dev))
@@ -1744,7 +1742,6 @@ static int ip_route_input_mc(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 	return 0;
 }
 
-
 static void ip_handle_martian_source(struct net_device *dev,
 				     struct in_device *in_dev,
 				     struct sk_buff *skb,
@@ -1754,8 +1751,7 @@ static void ip_handle_martian_source(struct net_device *dev,
 	RT_CACHE_STAT_INC(in_martian_src);
 #ifdef CONFIG_IP_ROUTE_VERBOSE
 	if (IN_DEV_LOG_MARTIANS(in_dev) && net_ratelimit()) {
-		/*
-		 *	RFC1812 recommendation, if source is martian,
+		/*	RFC1812 recommendation, if source is martian,
 		 *	the only hint is MAC header.
 		 */
 		pr_warn("martian source %pI4 from %pI4, on dev %s\n",
@@ -2188,8 +2184,7 @@ static struct net_device *ip_rt_get_dev(struct net *net,
 	return dev ? : net->loopback_dev;
 }
 
-/*
- *	NOTE. We drop all the packets that has local source
+/*	NOTE. We drop all the packets that has local source
  *	addresses, because every properly looped back packet
  *	must have correct destination already attached by output routine.
  *	Changes in the enforced policies must be applied also to
@@ -2351,7 +2346,7 @@ out:	return err;
 	if (!rth)
 		goto e_nobufs;
 
-	rth->dst.output= ip_rt_bug;
+	rth->dst.output = ip_rt_bug;
 #ifdef CONFIG_IP_ROUTE_CLASSID
 	rth->dst.tclassid = itag;
 #endif
@@ -2359,8 +2354,8 @@ out:	return err;
 
 	RT_CACHE_STAT_INC(in_slow_tot);
 	if (res->type == RTN_UNREACHABLE) {
-		rth->dst.input= ip_error;
-		rth->dst.error= -err;
+		rth->dst.input = ip_error;
+		rth->dst.error = -err;
 		rth->rt_flags	&= ~RTCF_LOCAL;
 	}
 
@@ -2693,7 +2688,6 @@ struct rtable *ip_route_output_key_hash_rcu(struct net *net, struct flowi4 *fl4,
 		}
 	}
 
-
 	if (fl4->flowi4_oif) {
 		dev_out = dev_get_by_index_rcu(net, fl4->flowi4_oif);
 		rth = ERR_PTR(-ENODEV);
@@ -2725,8 +2719,10 @@ struct rtable *ip_route_output_key_hash_rcu(struct net *net, struct flowi4 *fl4,
 
 	if (!fl4->daddr) {
 		fl4->daddr = fl4->saddr;
-		if (!fl4->daddr)
-			fl4->daddr = fl4->saddr = htonl(INADDR_LOOPBACK);
+		if (!fl4->daddr) {
+			fl4->daddr = htonl(INADDR_LOOPBACK);
+			fl4->saddr = htonl(INADDR_LOOPBACK);
+		}
 		dev_out = net->loopback_dev;
 		fl4->flowi4_oif = LOOPBACK_IFINDEX;
 		res->type = RTN_LOCAL;
@@ -2814,7 +2810,7 @@ static struct dst_ops ipv4_dst_blackhole_ops = {
 
 struct dst_entry *ipv4_blackhole_route(struct net *net, struct dst_entry *dst_orig)
 {
-	struct rtable *ort = (struct rtable *) dst_orig;
+	struct rtable *ort = (struct rtable *)dst_orig;
 	struct rtable *rt;
 
 	rt = dst_alloc(&ipv4_dst_blackhole_ops, NULL, 1, DST_OBSOLETE_DEAD, 0);
@@ -3265,7 +3261,7 @@ static int inet_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 			     struct netlink_ext_ack *extack)
 {
 	struct net *net = sock_net(in_skb->sk);
-	struct nlattr *tb[RTA_MAX+1];
+	struct nlattr *tb[RTA_MAX + 1];
 	u32 table_id = RT_TABLE_MAIN;
 	__be16 sport = 0, dport = 0;
 	struct fib_result res = {};
@@ -3440,7 +3436,7 @@ static int ip_rt_gc_elasticity __read_mostly	= 8;
 static int ip_min_valid_pmtu __read_mostly	= IPV4_MIN_MTU;
 
 static int ipv4_sysctl_rtcache_flush(struct ctl_table *__ctl, int write,
-		void *buffer, size_t *lenp, loff_t *ppos)
+				     void *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct net *net = (struct net *)__ctl->extra1;
 
@@ -3699,7 +3695,7 @@ int __init ip_rt_init(void)
 					      NULL,
 					      &ip_idents_mask,
 					      2048,
-					      256*1024);
+					      256 * 1024);
 
 	ip_idents = idents_hash;
 
@@ -3722,7 +3718,7 @@ int __init ip_rt_init(void)
 
 	ipv4_dst_ops.kmem_cachep =
 		kmem_cache_create("ip_dst_cache", sizeof(struct rtable), 0,
-				  SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+				  SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
 
 	ipv4_dst_blackhole_ops.kmem_cachep = ipv4_dst_ops.kmem_cachep;
 
@@ -3757,8 +3753,7 @@ int __init ip_rt_init(void)
 }
 
 #ifdef CONFIG_SYSCTL
-/*
- * We really need to sanitize the damn ipv4 init order, then all
+/* We really need to sanitize the damn ipv4 init order, then all
  * this nonsense will go away.
  */
 void __init ip_static_sysctl_init(void)
-- 
2.17.1

