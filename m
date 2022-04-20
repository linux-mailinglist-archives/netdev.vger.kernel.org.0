Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE0E50938C
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 01:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383164AbiDTXYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 19:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232806AbiDTXYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 19:24:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3AA4D1B7B6
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 16:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650496903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5JKI0IEkS5l0w87wfQkP90Czk2fyxaoY1z6ZxZgHPTk=;
        b=H4X0ElQEm3n2XmKTxsLsU61PcZFkaTUJ3/xz19aj0wWFYzXyTkbU4VMudhqEYJj5CFG0SK
        aJUtSAEXQdxGCy0FRTCbG0mGROU3WbabVzCnT6nVB5VBQ/Se5uhvVflXwAVyhgT/yR6yz6
        BDN9XK8IrD56Q0ykkm2rAtc8YFlINAg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-60-KB2z5MVqPouUYDLaAY7Zpw-1; Wed, 20 Apr 2022 19:21:41 -0400
X-MC-Unique: KB2z5MVqPouUYDLaAY7Zpw-1
Received: by mail-wm1-f72.google.com with SMTP id n4-20020a1ca404000000b00392b49c7ae3so118082wme.3
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 16:21:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5JKI0IEkS5l0w87wfQkP90Czk2fyxaoY1z6ZxZgHPTk=;
        b=kSf+C0E+fvr6Y+exHENEcSWP3ViQm+Es+hqM8yFPpHhnqbGYAPvr3Gbp6Rgg74vEo2
         uTzMO8Bae3v07xmGRMUPI7zLb4KcKJvhjTk+CFpEc5p21YufbszxKIWHKtUjNnFUaZqS
         sM93VXMiFSWY9/kwQlL7kB7nnZQ/UGKqJj3NEM/MYWv3IcTHurocqnAAAjJ5oJmp4kJj
         aAXCxQS9p08zL1vN6RNmIk2An08jDcmwS3V/QfN7a6Hq3qO9/8X52f40Y8/BboXqg+vN
         Y53JR3cLMHQFfhpd19gaH1AaC2wv/JHpYNIlO07IYj7nuglFU06mxMD6ucIxLpYiKia5
         YCwA==
X-Gm-Message-State: AOAM5325ZRLgXoznKc1I4Wi/KfVD5AIrnZvkKdN9y/5ND8wBsbDwkZGF
        nTSpChUVnY6VoB9/8dYcrOU9nHsLd3MpCw1Gwchv7/BDGEpuAfzoKfKnHbCRl3FyWKQ5PuG5xVd
        XbWkH7cV4D/FpSkk4
X-Received: by 2002:a7b:c201:0:b0:38f:f7f5:f6db with SMTP id x1-20020a7bc201000000b0038ff7f5f6dbmr5724058wmi.191.1650496900566;
        Wed, 20 Apr 2022 16:21:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzlMkx5P8NxGaq2mJxf9J09MPWikDHTdr520GZ7cegpVWFw25Y9w9DS/2oH2vkWtiWHuIdKUw==
X-Received: by 2002:a7b:c201:0:b0:38f:f7f5:f6db with SMTP id x1-20020a7bc201000000b0038ff7f5f6dbmr5724046wmi.191.1650496900380;
        Wed, 20 Apr 2022 16:21:40 -0700 (PDT)
Received: from debian.home (2a01cb058d3818005c1e4a7b0f47339f.ipv6.abo.wanadoo.fr. [2a01:cb05:8d38:1800:5c1e:4a7b:f47:339f])
        by smtp.gmail.com with ESMTPSA id v11-20020a056000144b00b0020a9c02f60dsm841171wrx.50.2022.04.20.16.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 16:21:40 -0700 (PDT)
Date:   Thu, 21 Apr 2022 01:21:37 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next 3/3] ipv4: Initialise ->flowi4_scope properly in
 ICMP handlers.
Message-ID: <3aabf0b36042c11bc97343f899563cef2b9288e5.1650470610.git.gnault@redhat.com>
References: <cover.1650470610.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1650470610.git.gnault@redhat.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All the *_redirect() and *_update_pmtu() functions initialise their
struct flowi4 variable with either __build_flow_key() or
build_sk_flow_key(). When sk is provided, these functions use
RT_CONN_FLAGS() to set ->flowi4_tos and always use RT_SCOPE_UNIVERSE
for ->flowi4_scope. Then they rely on ip_rt_fix_tos() to adjust the
scope based on the RTO_ONLINK bit and to mask the tos with
IPTOS_RT_MASK.

This patch modifies __build_flow_key() and build_sk_flow_key() to
properly initialise ->flowi4_tos and ->flowi4_scope, so that the
ICMP redirects and PMTU handlers don't need an extra call to
ip_rt_fix_tos() before doing a fib lookup. That is, we:

  * Drop RT_CONN_FLAGS(): use ip_sock_rt_tos() and ip_sock_rt_scope()
    instead, so that we don't have to rely on ip_rt_fix_tos() to adjust
    the scope anymore.

  * Apply IPTOS_RT_MASK to the tos, so that we don't need
    ip_rt_fix_tos() to do it for us.

  * Drop the ip_rt_fix_tos() calls that now become useless.

The only remaining ip_rt_fix_tos() caller is ip_route_output_key_hash()
which needs it as long as external callers still use the RTO_ONLINK
flag.

Note:
  This patch also drops some useless RT_TOS() calls as IPTOS_RT_MASK is
  a stronger mask.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/ipv4/route.c | 37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index d8f82c0ac132..ffbe2e4f8c89 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -508,23 +508,24 @@ static void ip_rt_fix_tos(struct flowi4 *fl4)
 }
 
 static void __build_flow_key(const struct net *net, struct flowi4 *fl4,
-			     const struct sock *sk,
-			     const struct iphdr *iph,
-			     int oif, u8 tos,
-			     u8 prot, u32 mark, int flow_flags)
+			     const struct sock *sk, const struct iphdr *iph,
+			     int oif, __u8 tos, u8 prot, u32 mark,
+			     int flow_flags)
 {
+	__u8 scope = RT_SCOPE_UNIVERSE;
+
 	if (sk) {
 		const struct inet_sock *inet = inet_sk(sk);
 
 		oif = sk->sk_bound_dev_if;
 		mark = sk->sk_mark;
-		tos = RT_CONN_FLAGS(sk);
+		tos = ip_sock_rt_tos(sk);
+		scope = ip_sock_rt_scope(sk);
 		prot = inet->hdrincl ? IPPROTO_RAW : sk->sk_protocol;
 	}
-	flowi4_init_output(fl4, oif, mark, tos,
-			   RT_SCOPE_UNIVERSE, prot,
-			   flow_flags,
-			   iph->daddr, iph->saddr, 0, 0,
+
+	flowi4_init_output(fl4, oif, mark, tos & IPTOS_RT_MASK, scope,
+			   prot, flow_flags, iph->daddr, iph->saddr, 0, 0,
 			   sock_net_uid(net, sk));
 }
 
@@ -534,9 +535,9 @@ static void build_skb_flow_key(struct flowi4 *fl4, const struct sk_buff *skb,
 	const struct net *net = dev_net(skb->dev);
 	const struct iphdr *iph = ip_hdr(skb);
 	int oif = skb->dev->ifindex;
-	u8 tos = RT_TOS(iph->tos);
 	u8 prot = iph->protocol;
 	u32 mark = skb->mark;
+	__u8 tos = iph->tos;
 
 	__build_flow_key(net, fl4, sk, iph, oif, tos, prot, mark, 0);
 }
@@ -552,7 +553,8 @@ static void build_sk_flow_key(struct flowi4 *fl4, const struct sock *sk)
 	if (inet_opt && inet_opt->opt.srr)
 		daddr = inet_opt->opt.faddr;
 	flowi4_init_output(fl4, sk->sk_bound_dev_if, sk->sk_mark,
-			   RT_CONN_FLAGS(sk), RT_SCOPE_UNIVERSE,
+			   ip_sock_rt_tos(sk) & IPTOS_RT_MASK,
+			   ip_sock_rt_scope(sk),
 			   inet->hdrincl ? IPPROTO_RAW : sk->sk_protocol,
 			   inet_sk_flowi_flags(sk),
 			   daddr, inet->inet_saddr, 0, 0, sk->sk_uid);
@@ -825,14 +827,13 @@ static void ip_do_redirect(struct dst_entry *dst, struct sock *sk, struct sk_buf
 	const struct iphdr *iph = (const struct iphdr *) skb->data;
 	struct net *net = dev_net(skb->dev);
 	int oif = skb->dev->ifindex;
-	u8 tos = RT_TOS(iph->tos);
 	u8 prot = iph->protocol;
 	u32 mark = skb->mark;
+	__u8 tos = iph->tos;
 
 	rt = (struct rtable *) dst;
 
 	__build_flow_key(net, &fl4, sk, iph, oif, tos, prot, mark, 0);
-	ip_rt_fix_tos(&fl4);
 	__ip_do_redirect(rt, skb, &fl4, true);
 }
 
@@ -1061,7 +1062,6 @@ static void ip_rt_update_pmtu(struct dst_entry *dst, struct sock *sk,
 	struct flowi4 fl4;
 
 	ip_rt_build_flow_key(&fl4, sk, skb);
-	ip_rt_fix_tos(&fl4);
 
 	/* Don't make lookup fail for bridged encapsulations */
 	if (skb && netif_is_any_bridge_port(skb->dev))
@@ -1078,8 +1078,8 @@ void ipv4_update_pmtu(struct sk_buff *skb, struct net *net, u32 mtu,
 	struct rtable *rt;
 	u32 mark = IP4_REPLY_MARK(net, skb->mark);
 
-	__build_flow_key(net, &fl4, NULL, iph, oif,
-			 RT_TOS(iph->tos), protocol, mark, 0);
+	__build_flow_key(net, &fl4, NULL, iph, oif, iph->tos, protocol, mark,
+			 0);
 	rt = __ip_route_output_key(net, &fl4);
 	if (!IS_ERR(rt)) {
 		__ip_rt_update_pmtu(rt, &fl4, mtu);
@@ -1136,8 +1136,6 @@ void ipv4_sk_update_pmtu(struct sk_buff *skb, struct sock *sk, u32 mtu)
 			goto out;
 
 		new = true;
-	} else {
-		ip_rt_fix_tos(&fl4);
 	}
 
 	__ip_rt_update_pmtu((struct rtable *)xfrm_dst_path(&rt->dst), &fl4, mtu);
@@ -1169,8 +1167,7 @@ void ipv4_redirect(struct sk_buff *skb, struct net *net,
 	struct flowi4 fl4;
 	struct rtable *rt;
 
-	__build_flow_key(net, &fl4, NULL, iph, oif,
-			 RT_TOS(iph->tos), protocol, 0, 0);
+	__build_flow_key(net, &fl4, NULL, iph, oif, iph->tos, protocol, 0, 0);
 	rt = __ip_route_output_key(net, &fl4);
 	if (!IS_ERR(rt)) {
 		__ip_do_redirect(rt, skb, &fl4, false);
-- 
2.21.3

