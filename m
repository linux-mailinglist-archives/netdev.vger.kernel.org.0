Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 458574DC5FA
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 13:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbiCQMqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 08:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233660AbiCQMqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 08:46:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 460B710507D
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 05:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647521114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cyl9Y9Shs7l/iWslbHqnNb9Omf5IPpBek4AvRueMKPY=;
        b=f3uQGqKlgEy1DRcznLHHDmq0OCKwpWHl8VCLDAT970WSTF8Egvwl67lxsD9bv6Z8Tvm+PE
        11LGR7wWUiukqXlgNNy/sTrNZPBe52DeAtVV7xtACmAz8QQKolScraidWqW7wv3RCipsey
        tS+MSrh5LkDgR5LE9xR0UOHhPsWCwfQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-cUZE7Al0MsiKvNgyoQOUsw-1; Thu, 17 Mar 2022 08:45:13 -0400
X-MC-Unique: cUZE7Al0MsiKvNgyoQOUsw-1
Received: by mail-wm1-f72.google.com with SMTP id q65-20020a1c4344000000b0038c7c65e120so394838wma.7
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 05:45:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cyl9Y9Shs7l/iWslbHqnNb9Omf5IPpBek4AvRueMKPY=;
        b=RUhO2RfjkcS1D9k8G4wEYpNRKxP/H9MOw1PnO2FOlhqNNaGDQOZ3TT0KTjgGH4X83s
         QZiXnXVYcXPIR9FuTu3maIkk19PqwchE+pLdd3uGF4zA4z5r+r9IIQnMn4Zd5NKwLndA
         GdDZAEX3SvWIo5GE4zwX8EI8muJPM8a68svL6wHWgmX4wUytS9BwoLbCQHQle5BqaECP
         KoJixrVyLeT7KkRWjqYrf7rLRUvSnaRzXPI9caFgLHPrKeUDesbtwmztAAjHADVgkieY
         zTYdz1KnIfeLBrnpuEt56NwHa/Rrs9Eg4zVYMsPrqoIGRRXGi63UA+4Ougw1jkvCov3Y
         zv+g==
X-Gm-Message-State: AOAM532f/fldKneh5VoHy9GtOxdDXxWin8j612Y7TglY9TgENuswg8CQ
        gatYPI0LrdvTD9R968oQzIY06Sl45E1v4k2E0qeVnx/lcWDx9tOomTpbY7mr8kENxYaS1TZPzZu
        MIuq/rdYTfUZ0sk/f
X-Received: by 2002:a05:6000:1d87:b0:203:e5c8:7cf3 with SMTP id bk7-20020a0560001d8700b00203e5c87cf3mr3659197wrb.704.1647521111756;
        Thu, 17 Mar 2022 05:45:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJXVyeP6NJrPm38k6vTxaOflpgRklkNQqqypM22SvD73rr5I2fY0wDR+0nWHO9WXlVdQ9BDg==
X-Received: by 2002:a05:6000:1d87:b0:203:e5c8:7cf3 with SMTP id bk7-20020a0560001d8700b00203e5c87cf3mr3659180wrb.704.1647521111487;
        Thu, 17 Mar 2022 05:45:11 -0700 (PDT)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id 10-20020adf808a000000b001edd413a952sm3854392wrl.95.2022.03.17.05.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 05:45:11 -0700 (PDT)
Date:   Thu, 17 Mar 2022 13:45:09 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: [PATCH net v2 1/2] ipv4: Fix route lookups when handling ICMP
 redirects and PMTU updates
Message-ID: <8cbc1e6f2319dd50d4289bec6604174484ca615c.1647519748.git.gnault@redhat.com>
References: <cover.1647519748.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1647519748.git.gnault@redhat.com>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
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

Note 1: We can't sanitise ->flowi4_tos and ->flowi4_scope in a central
place (like __build_flow_key() or flowi4_init_output()), because
ip_route_output_key_hash() expects non-sanitised values. When called
with sanitised values, it can erroneously overwrite RT_SCOPE_LINK with
RT_SCOPE_UNIVERSE in ->flowi4_scope. Therefore we have to be careful to
sanitise the values only for those paths that don't call
ip_route_output_key_hash().

Note 2: The problem is mostly about sanitising ->flowi4_tos. Having
->flowi4_scope initialised with RT_SCOPE_UNIVERSE instead of
RT_SCOPE_LINK probably wasn't really a problem: sockets with the
SOCK_LOCALROUTE flag set (those that'd result in RTO_ONLINK being set)
normally shouldn't receive ICMP redirects or PMTU updates.

Fixes: 4895c771c7f0 ("ipv4: Add FIB nexthop exceptions.")
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

