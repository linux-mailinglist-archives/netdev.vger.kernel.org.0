Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE3A4C725E
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 18:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbiB1RQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 12:16:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbiB1RQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 12:16:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5E4135F77
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 09:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646068566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=cJLvJQ5lJE/eswpQWteUzeGG8Bsh/awLLnymfR8Bi2I=;
        b=cCEbRatyNRyzl+3eT7AnMYmqQPzYNZ5H7Rht+Xw2r9T53fkpqT5FoaQbyOQV8TCjVXmyWo
        p7soCnVSf+KmoLZdYdtoYn3aoJSi3S0iEwZgg2ZDaY/fPXExs/cE+ZoHluqOxxV71olm56
        XbkFYBCAXNi+Kx7c67ODLYy9d+kbbmw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-146-o9ErCfIMNSOHxLu2IIJJkg-1; Mon, 28 Feb 2022 12:16:04 -0500
X-MC-Unique: o9ErCfIMNSOHxLu2IIJJkg-1
Received: by mail-wr1-f72.google.com with SMTP id x15-20020a5d6b4f000000b001ee6c0aa287so2352090wrw.9
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 09:16:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=cJLvJQ5lJE/eswpQWteUzeGG8Bsh/awLLnymfR8Bi2I=;
        b=EjTXmiXC/P+SxU3fZMVKY2OsPLJIRm4KOCVsIJ88f5kKzKAvZVHj+LAHTw3EohI2Ly
         fjXkxe0k9TL55+TYiNooZ2qMeOVyHJa8Gl4vV4ieR0vUzIAaG+Rmhk3jbtyR4HjN3DSS
         5XU3lGUecrvKNjy7IMwsby4G/uOCgDTWx7kO0fKqp7dVk2zJucKZWRL0+6bZnmUXsnfK
         HIkDkWdA9VNtyTxVgrK08ZhgaEPHz9KmSKLlZD3kKx3KDvjzWInTsFSGcTvW+hI59gTh
         5Dbp85pzoiyno+KQfQLhule5Y43JBcxy4wPrIIvoT0ZUoaWNBKtXAhLTED+3dp8i5NwQ
         XAwQ==
X-Gm-Message-State: AOAM53321kx89Ujn5du0cY/8psEB0fM9GaKL3GM9FQaqQqWiB8fCuME/
        9Rx2J4ufAraXCVuq4V+dB71hgrPG1yNEaNgbLPfS4t9IPRnEgp8V3zRNgLKD9opMYpa98RC33ui
        ntlY61CajXdH7oQaG
X-Received: by 2002:a05:6000:1c16:b0:1ef:d315:8c58 with SMTP id ba22-20020a0560001c1600b001efd3158c58mr4150946wrb.504.1646068563454;
        Mon, 28 Feb 2022 09:16:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxIO9p+cgwcxcbq9cOBjknwq2UwFXbO4gL2NTNVwcVZ8pGNEUnRyP54x+GUdb3/bWfUFov0qw==
X-Received: by 2002:a05:6000:1c16:b0:1ef:d315:8c58 with SMTP id ba22-20020a0560001c1600b001efd3158c58mr4150934wrb.504.1646068563218;
        Mon, 28 Feb 2022 09:16:03 -0800 (PST)
Received: from debian.home (2a01cb058d3818005c1e4a7b0f47339f.ipv6.abo.wanadoo.fr. [2a01:cb05:8d38:1800:5c1e:4a7b:f47:339f])
        by smtp.gmail.com with ESMTPSA id c11-20020a05600c0a4b00b0037c91e085ddsm19600959wmq.40.2022.02.28.09.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 09:16:02 -0800 (PST)
Date:   Mon, 28 Feb 2022 18:16:01 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH net] ipv4: fix route lookups when handling ICMP redirects and
 PMTU updates
Message-ID: <cffd245430d10fa2a14c32d1c768eef7cfeb8963.1646068241.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PMTU update and ICMP redirect helper functions initialise their fl4
variable with either __build_flow_key() or build_sk_flow_key(). These
initialisation functions always set ->flowi4_scope with
RT_SCOPE_UNIVERSE and might set the ECN bits of ->flowi4_tos. This is
not a problem when the route lookup is later done via
ip_route_output_key_hash(), which properly clears the ECN bits from
->flowi4_tos and initialises ->flowi4_scope based on the RTO_ONLINK
flag. However, some helpers call fib_lookup() directly, without
sanitising the tos and scope fields, so the route lookup can fail and,
as a result, the ICMP redirect or PMTU update aren't taken into
account.

Fix this by extracting the ->flowi4_tos and ->flowi4_scope sanitisation
code into ip_rt_fix_tos(), then use this function in handlers that call
fib_lookup() directly.

Note 1: we can't just let __build_flow_key() set sanitised values for
tos and scope, because other functions use it and pass the flowi4
structure to ip_route_output_key_hash(), which unconditionally resets
the scope to RT_SCOPE_UNIVERSE if it doesn't see the RTO_ONLINK flag
in ->flowi4_tos.

Note 2: while wrongly initialised ->flowi4_tos could interfere with
ICMP redirects and PMTU updates, setting ->flowi4_scope with
RT_SCOPE_UNIVERSE instead of RT_SCOPE_LINK probably wasn't really a
problem: sockets with SOCK_LOCALROUTE flag set (those that'd result in
RTO_ONLINK being set) normally shouldn't receive redirects and PMTU
updates.

Fixes: d3a25c980fc2 ("ipv4: Fix nexthop exception hash computation.")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/ipv4/route.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index f33ad1f383b6..d5d058de3664 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -499,6 +499,15 @@ void __ip_select_ident(struct net *net, struct iphdr *iph, int segs)
 }
 EXPORT_SYMBOL(__ip_select_ident);
 
+static void ip_rt_fix_tos(struct flowi4 *fl4)
+{
+	__u8 tos = RT_FL_TOS(fl4);
+
+	fl4->flowi4_tos = tos & IPTOS_RT_MASK;
+	fl4->flowi4_scope = tos & RTO_ONLINK ?
+			    RT_SCOPE_LINK : RT_SCOPE_UNIVERSE;
+}
+
 static void __build_flow_key(const struct net *net, struct flowi4 *fl4,
 			     const struct sock *sk,
 			     const struct iphdr *iph,
@@ -824,6 +833,7 @@ static void ip_do_redirect(struct dst_entry *dst, struct sock *sk, struct sk_buf
 	rt = (struct rtable *) dst;
 
 	__build_flow_key(net, &fl4, sk, iph, oif, tos, prot, mark, 0);
+	ip_rt_fix_tos(&fl4);
 	__ip_do_redirect(rt, skb, &fl4, true);
 }
 
@@ -1048,6 +1058,7 @@ static void ip_rt_update_pmtu(struct dst_entry *dst, struct sock *sk,
 	struct flowi4 fl4;
 
 	ip_rt_build_flow_key(&fl4, sk, skb);
+	ip_rt_fix_tos(&fl4);
 
 	/* Don't make lookup fail for bridged encapsulations */
 	if (skb && netif_is_any_bridge_port(skb->dev))
@@ -1122,6 +1133,8 @@ void ipv4_sk_update_pmtu(struct sk_buff *skb, struct sock *sk, u32 mtu)
 			goto out;
 
 		new = true;
+	} else {
+		ip_rt_fix_tos(&fl4);
 	}
 
 	__ip_rt_update_pmtu((struct rtable *)xfrm_dst_path(&rt->dst), &fl4, mtu);
@@ -2603,7 +2616,6 @@ static struct rtable *__mkroute_output(const struct fib_result *res,
 struct rtable *ip_route_output_key_hash(struct net *net, struct flowi4 *fl4,
 					const struct sk_buff *skb)
 {
-	__u8 tos = RT_FL_TOS(fl4);
 	struct fib_result res = {
 		.type		= RTN_UNSPEC,
 		.fi		= NULL,
@@ -2613,9 +2625,7 @@ struct rtable *ip_route_output_key_hash(struct net *net, struct flowi4 *fl4,
 	struct rtable *rth;
 
 	fl4->flowi4_iif = LOOPBACK_IFINDEX;
-	fl4->flowi4_tos = tos & IPTOS_RT_MASK;
-	fl4->flowi4_scope = ((tos & RTO_ONLINK) ?
-			 RT_SCOPE_LINK : RT_SCOPE_UNIVERSE);
+	ip_rt_fix_tos(fl4);
 
 	rcu_read_lock();
 	rth = ip_route_output_key_hash_rcu(net, fl4, &res, skb);
-- 
2.21.3

