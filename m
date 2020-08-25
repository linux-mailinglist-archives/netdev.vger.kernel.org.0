Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA3725189C
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 14:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgHYMdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 08:33:39 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10320 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726691AbgHYMdf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 08:33:35 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id EDFE757303068AF559DB;
        Tue, 25 Aug 2020 20:33:28 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Tue, 25 Aug 2020
 20:33:19 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] net: clean up codestyle for net/ipv4
Date:   Tue, 25 Aug 2020 08:32:11 -0400
Message-ID: <20200825123211.33235-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.175]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a pure codestyle cleanup patch. Also add a blank line after
declarations as warned by checkpatch.pl.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/ipv4/ip_options.c | 35 +++++++++++++++++++----------------
 net/ipv4/ip_output.c  |  2 +-
 net/ipv4/route.c      |  6 +++---
 3 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/net/ipv4/ip_options.c b/net/ipv4/ip_options.c
index 948747aac4e2..da1b5038bdfd 100644
--- a/net/ipv4/ip_options.c
+++ b/net/ipv4/ip_options.c
@@ -47,32 +47,32 @@ void ip_options_build(struct sk_buff *skb, struct ip_options *opt,
 	unsigned char *iph = skb_network_header(skb);
 
 	memcpy(&(IPCB(skb)->opt), opt, sizeof(struct ip_options));
-	memcpy(iph+sizeof(struct iphdr), opt->__data, opt->optlen);
+	memcpy(iph + sizeof(struct iphdr), opt->__data, opt->optlen);
 	opt = &(IPCB(skb)->opt);
 
 	if (opt->srr)
-		memcpy(iph+opt->srr+iph[opt->srr+1]-4, &daddr, 4);
+		memcpy(iph + opt->srr + iph[opt->srr + 1] - 4, &daddr, 4);
 
 	if (!is_frag) {
 		if (opt->rr_needaddr)
-			ip_rt_get_source(iph+opt->rr+iph[opt->rr+2]-5, skb, rt);
+			ip_rt_get_source(iph + opt->rr + iph[opt->rr + 2] - 5, skb, rt);
 		if (opt->ts_needaddr)
-			ip_rt_get_source(iph+opt->ts+iph[opt->ts+2]-9, skb, rt);
+			ip_rt_get_source(iph + opt->ts + iph[opt->ts + 2] - 9, skb, rt);
 		if (opt->ts_needtime) {
 			__be32 midtime;
 
 			midtime = inet_current_timestamp();
-			memcpy(iph+opt->ts+iph[opt->ts+2]-5, &midtime, 4);
+			memcpy(iph + opt->ts + iph[opt->ts + 2] - 5, &midtime, 4);
 		}
 		return;
 	}
 	if (opt->rr) {
-		memset(iph+opt->rr, IPOPT_NOP, iph[opt->rr+1]);
+		memset(iph + opt->rr, IPOPT_NOP, iph[opt->rr + 1]);
 		opt->rr = 0;
 		opt->rr_needaddr = 0;
 	}
 	if (opt->ts) {
-		memset(iph+opt->ts, IPOPT_NOP, iph[opt->ts+1]);
+		memset(iph + opt->ts, IPOPT_NOP, iph[opt->ts + 1]);
 		opt->ts = 0;
 		opt->ts_needaddr = opt->ts_needtime = 0;
 	}
@@ -495,26 +495,29 @@ EXPORT_SYMBOL(ip_options_compile);
 void ip_options_undo(struct ip_options *opt)
 {
 	if (opt->srr) {
-		unsigned  char *optptr = opt->__data+opt->srr-sizeof(struct  iphdr);
-		memmove(optptr+7, optptr+3, optptr[1]-7);
-		memcpy(optptr+3, &opt->faddr, 4);
+		unsigned char *optptr = opt->__data + opt->srr - sizeof(struct iphdr);
+
+		memmove(optptr + 7, optptr + 3, optptr[1] - 7);
+		memcpy(optptr + 3, &opt->faddr, 4);
 	}
 	if (opt->rr_needaddr) {
-		unsigned  char *optptr = opt->__data+opt->rr-sizeof(struct  iphdr);
+		unsigned char *optptr = opt->__data + opt->rr - sizeof(struct iphdr);
+
 		optptr[2] -= 4;
-		memset(&optptr[optptr[2]-1], 0, 4);
+		memset(&optptr[optptr[2] - 1], 0, 4);
 	}
 	if (opt->ts) {
-		unsigned  char *optptr = opt->__data+opt->ts-sizeof(struct  iphdr);
+		unsigned char *optptr = opt->__data + opt->ts - sizeof(struct iphdr);
+
 		if (opt->ts_needtime) {
 			optptr[2] -= 4;
-			memset(&optptr[optptr[2]-1], 0, 4);
-			if ((optptr[3]&0xF) == IPOPT_TS_PRESPEC)
+			memset(&optptr[optptr[2] - 1], 0, 4);
+			if ((optptr[3] & 0xF) == IPOPT_TS_PRESPEC)
 				optptr[2] -= 4;
 		}
 		if (opt->ts_needaddr) {
 			optptr[2] -= 4;
-			memset(&optptr[optptr[2]-1], 0, 4);
+			memset(&optptr[optptr[2] - 1], 0, 4);
 		}
 	}
 }
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 61f802d5350c..329a0ab87542 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1351,7 +1351,7 @@ ssize_t	ip_append_page(struct sock *sk, struct flowi4 *fl4, struct page *page,
 	if (cork->flags & IPCORK_OPT)
 		opt = cork->opt;
 
-	if (!(rt->dst.dev->features&NETIF_F_SG))
+	if (!(rt->dst.dev->features & NETIF_F_SG))
 		return -EOPNOTSUPP;
 
 	hh_len = LL_RESERVED_SPACE(rt->dst.dev);
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 18c8baf32de5..96fcdfb9bb26 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1079,7 +1079,7 @@ EXPORT_SYMBOL_GPL(ipv4_update_pmtu);
 
 static void __ipv4_sk_update_pmtu(struct sk_buff *skb, struct sock *sk, u32 mtu)
 {
-	const struct iphdr *iph = (const struct iphdr *) skb->data;
+	const struct iphdr *iph = (const struct iphdr *)skb->data;
 	struct flowi4 fl4;
 	struct rtable *rt;
 
@@ -1127,7 +1127,7 @@ void ipv4_sk_update_pmtu(struct sk_buff *skb, struct sock *sk, u32 mtu)
 		new = true;
 	}
 
-	__ip_rt_update_pmtu((struct rtable *) xfrm_dst_path(&rt->dst), &fl4, mtu);
+	__ip_rt_update_pmtu((struct rtable *)xfrm_dst_path(&rt->dst), &fl4, mtu);
 
 	if (!dst_check(&rt->dst, 0)) {
 		if (new)
@@ -1168,7 +1168,7 @@ EXPORT_SYMBOL_GPL(ipv4_redirect);
 
 void ipv4_sk_redirect(struct sk_buff *skb, struct sock *sk)
 {
-	const struct iphdr *iph = (const struct iphdr *) skb->data;
+	const struct iphdr *iph = (const struct iphdr *)skb->data;
 	struct flowi4 fl4;
 	struct rtable *rt;
 	struct net *net = sock_net(sk);
-- 
2.19.1

