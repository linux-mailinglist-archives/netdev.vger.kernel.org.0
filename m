Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4D3509389
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 01:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383154AbiDTXY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 19:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232806AbiDTXY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 19:24:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 36F291B7B6
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 16:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650496899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k5L7j2fJ+L907oBgkd9l6h6lJ3Ziohgmrwe/AW3irxA=;
        b=YA7agoqPgEjKRrqxm6a1m0Ocd94xXT3PUHn0s6ML8qp/K7QlBVuWe7wy2uccrl6WdwTq/r
        bLJAXttKyTmxkXQJ/yT9YNMJWeYhBkM7gRlXzrJnDstAN0oQhglMC8l38ARqm3eEtaPqER
        hFQEDIgHWj5RiUfiJz4cDYyDq774w2w=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-45-4-TpeIIWNi-lyCm_PYNXQQ-1; Wed, 20 Apr 2022 19:21:38 -0400
X-MC-Unique: 4-TpeIIWNi-lyCm_PYNXQQ-1
Received: by mail-wm1-f70.google.com with SMTP id q6-20020a1cf306000000b0038c5726365aso1637249wmq.3
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 16:21:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k5L7j2fJ+L907oBgkd9l6h6lJ3Ziohgmrwe/AW3irxA=;
        b=JMICWVtv6mrlbcI1T/3F4oSzStCuhAVmG2jrZYGjP9o4nkC5k5TKbCjZEKXQNWqK3f
         h3qojCaz1EBeeeDs5MaEpBhw00zLBrv7TXkemXD+yF94zKGOI68qizeCZkQcNvoPKQ7b
         SoFfmUjt3cELdELjt5yAqFkWUzrBiVEY/OWPixta52W3180wR1+AsWJ4Iqo2ZLDxZnjw
         p0L2ZIDiTh9myeJ5ilBtsTN7dkFmdx+73qIliaWZ5oXSx/C+t8f85irGc1LIaaLi9KmK
         l79KCDl6enqdioeMwQlSiL6NlIvwkcPnJCQEUjNvEGOSYVN6CXCVgzLBXcQUVgSEq6Mt
         VcAg==
X-Gm-Message-State: AOAM530cGFOc0N0UT2igyr6uTXeOy0uXfTIrq73rvZ0Iy7n8cgL5CWMl
        MJQGd1H+l7ePX3a/F7SfOdrTszq8rtUE2dCrCUpRrM5CzqUt/K6oWsfvNlG7Q4EQ4FZZdYrQGZk
        nFidTKdNIzU4VSBKf
X-Received: by 2002:a05:6000:18cb:b0:207:8c65:3fd4 with SMTP id w11-20020a05600018cb00b002078c653fd4mr17250694wrq.131.1650496896543;
        Wed, 20 Apr 2022 16:21:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwnqRGxW7K+/DGxqy5HuA6ehIaLHbq5paltJgXKymrarYvf0AEhxe1WC5bFKgjT1WvSm37tfQ==
X-Received: by 2002:a05:6000:18cb:b0:207:8c65:3fd4 with SMTP id w11-20020a05600018cb00b002078c653fd4mr17250682wrq.131.1650496896320;
        Wed, 20 Apr 2022 16:21:36 -0700 (PDT)
Received: from debian.home (2a01cb058d3818005c1e4a7b0f47339f.ipv6.abo.wanadoo.fr. [2a01:cb05:8d38:1800:5c1e:4a7b:f47:339f])
        by smtp.gmail.com with ESMTPSA id h206-20020a1c21d7000000b003925bfba0e3sm585205wmh.25.2022.04.20.16.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 16:21:36 -0700 (PDT)
Date:   Thu, 21 Apr 2022 01:21:33 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, dccp@vger.kernel.org
Subject: [PATCH net-next 2/3] ipv4: Avoid using RTO_ONLINK with
 ip_route_connect().
Message-ID: <492f91626cab774d7dda27147629c3d56537f847.1650470610.git.gnault@redhat.com>
References: <cover.1650470610.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1650470610.git.gnault@redhat.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that ip_rt_fix_tos() doesn't reset ->flowi4_scope unconditionally,
we don't have to rely on the RTO_ONLINK bit to properly set the scope
of a flowi4 structure. We can just set ->flowi4_scope explicitly and
avoid using RTO_ONLINK in ->flowi4_tos.

This patch converts callers of ip_route_connect(). Instead of setting
the tos parameter with RT_CONN_FLAGS(sk), as all callers do, we can:

  1- Drop the tos parameter from ip_route_connect(): its value was
     entirely based on sk, which is also passed as parameter.

  2- Set ->flowi4_scope depending on the SOCK_LOCALROUTE socket option
     instead of always initialising it with RT_SCOPE_UNIVERSE (let's
     define ip_sock_rt_scope() for this purpose).

  3- Avoid overloading ->flowi4_tos with RTO_ONLINK: since the scope is
     now properly initialised, we don't need to tell ip_rt_fix_tos() to
     adjust ->flowi4_scope for us. So let's define ip_sock_rt_tos(),
     which is the same as RT_CONN_FLAGS() but without the RTO_ONLINK
     bit overload.

Note:
  In the original ip_route_connect() code, __ip_route_output_key()
  might clear the RTO_ONLINK bit of fl4->flowi4_tos (because of
  ip_rt_fix_tos()). Therefore flowi4_update_output() had to reuse the
  original tos variable. Now that we don't set RTO_ONLINK any more,
  this is not a problem and we can use fl4->flowi4_tos in
  flowi4_update_output().

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 include/net/route.h | 36 ++++++++++++++++++++++++------------
 net/dccp/ipv4.c     |  5 ++---
 net/ipv4/af_inet.c  |  6 +++---
 net/ipv4/datagram.c |  7 +++----
 net/ipv4/tcp_ipv4.c |  5 ++---
 5 files changed, 34 insertions(+), 25 deletions(-)

diff --git a/include/net/route.h b/include/net/route.h
index 25404fc2b483..991a3985712d 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -43,6 +43,19 @@
 #define RT_CONN_FLAGS(sk)   (RT_TOS(inet_sk(sk)->tos) | sock_flag(sk, SOCK_LOCALROUTE))
 #define RT_CONN_FLAGS_TOS(sk,tos)   (RT_TOS(tos) | sock_flag(sk, SOCK_LOCALROUTE))
 
+static inline __u8 ip_sock_rt_scope(const struct sock *sk)
+{
+	if (sock_flag(sk, SOCK_LOCALROUTE))
+		return RT_SCOPE_LINK;
+
+	return RT_SCOPE_UNIVERSE;
+}
+
+static inline __u8 ip_sock_rt_tos(const struct sock *sk)
+{
+	return RT_TOS(inet_sk(sk)->tos);
+}
+
 struct ip_tunnel_info;
 struct fib_nh;
 struct fib_info;
@@ -289,39 +302,38 @@ static inline char rt_tos2priority(u8 tos)
  * ip_route_newports() calls.
  */
 
-static inline void ip_route_connect_init(struct flowi4 *fl4, __be32 dst, __be32 src,
-					 u32 tos, int oif, u8 protocol,
+static inline void ip_route_connect_init(struct flowi4 *fl4, __be32 dst,
+					 __be32 src, int oif, u8 protocol,
 					 __be16 sport, __be16 dport,
-					 struct sock *sk)
+					 const struct sock *sk)
 {
 	__u8 flow_flags = 0;
 
 	if (inet_sk(sk)->transparent)
 		flow_flags |= FLOWI_FLAG_ANYSRC;
 
-	flowi4_init_output(fl4, oif, sk->sk_mark, tos, RT_SCOPE_UNIVERSE,
-			   protocol, flow_flags, dst, src, dport, sport,
-			   sk->sk_uid);
+	flowi4_init_output(fl4, oif, sk->sk_mark, ip_sock_rt_tos(sk),
+			   ip_sock_rt_scope(sk), protocol, flow_flags, dst,
+			   src, dport, sport, sk->sk_uid);
 }
 
-static inline struct rtable *ip_route_connect(struct flowi4 *fl4,
-					      __be32 dst, __be32 src, u32 tos,
-					      int oif, u8 protocol,
+static inline struct rtable *ip_route_connect(struct flowi4 *fl4, __be32 dst,
+					      __be32 src, int oif, u8 protocol,
 					      __be16 sport, __be16 dport,
 					      struct sock *sk)
 {
 	struct net *net = sock_net(sk);
 	struct rtable *rt;
 
-	ip_route_connect_init(fl4, dst, src, tos, oif, protocol,
-			      sport, dport, sk);
+	ip_route_connect_init(fl4, dst, src, oif, protocol, sport, dport, sk);
 
 	if (!dst || !src) {
 		rt = __ip_route_output_key(net, fl4);
 		if (IS_ERR(rt))
 			return rt;
 		ip_rt_put(rt);
-		flowi4_update_output(fl4, oif, tos, fl4->daddr, fl4->saddr);
+		flowi4_update_output(fl4, oif, fl4->flowi4_tos, fl4->daddr,
+				     fl4->saddr);
 	}
 	security_sk_classify_flow(sk, flowi4_to_flowi_common(fl4));
 	return ip_route_output_flow(net, fl4, sk);
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index ae662567a6cb..82696ab86f74 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -76,9 +76,8 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	orig_dport = usin->sin_port;
 	fl4 = &inet->cork.fl.u.ip4;
 	rt = ip_route_connect(fl4, nexthop, inet->inet_saddr,
-			      RT_CONN_FLAGS(sk), sk->sk_bound_dev_if,
-			      IPPROTO_DCCP,
-			      orig_sport, orig_dport, sk);
+			      sk->sk_bound_dev_if, IPPROTO_DCCP, orig_sport,
+			      orig_dport, sk);
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);
 
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 195ecfa2f000..93da9f783bec 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1233,9 +1233,9 @@ static int inet_sk_reselect_saddr(struct sock *sk)
 
 	/* Query new route. */
 	fl4 = &inet->cork.fl.u.ip4;
-	rt = ip_route_connect(fl4, daddr, 0, RT_CONN_FLAGS(sk),
-			      sk->sk_bound_dev_if, sk->sk_protocol,
-			      inet->inet_sport, inet->inet_dport, sk);
+	rt = ip_route_connect(fl4, daddr, 0, sk->sk_bound_dev_if,
+			      sk->sk_protocol, inet->inet_sport,
+			      inet->inet_dport, sk);
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);
 
diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
index 48f337ccf949..ffd57523331f 100644
--- a/net/ipv4/datagram.c
+++ b/net/ipv4/datagram.c
@@ -44,10 +44,9 @@ int __ip4_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len
 			saddr = inet->mc_addr;
 	}
 	fl4 = &inet->cork.fl.u.ip4;
-	rt = ip_route_connect(fl4, usin->sin_addr.s_addr, saddr,
-			      RT_CONN_FLAGS(sk), oif,
-			      sk->sk_protocol,
-			      inet->inet_sport, usin->sin_port, sk);
+	rt = ip_route_connect(fl4, usin->sin_addr.s_addr, saddr, oif,
+			      sk->sk_protocol, inet->inet_sport,
+			      usin->sin_port, sk);
 	if (IS_ERR(rt)) {
 		err = PTR_ERR(rt);
 		if (err == -ENETUNREACH)
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 157265aecbed..2c2d42142555 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -229,9 +229,8 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	orig_dport = usin->sin_port;
 	fl4 = &inet->cork.fl.u.ip4;
 	rt = ip_route_connect(fl4, nexthop, inet->inet_saddr,
-			      RT_CONN_FLAGS(sk), sk->sk_bound_dev_if,
-			      IPPROTO_TCP,
-			      orig_sport, orig_dport, sk);
+			      sk->sk_bound_dev_if, IPPROTO_TCP, orig_sport,
+			      orig_dport, sk);
 	if (IS_ERR(rt)) {
 		err = PTR_ERR(rt);
 		if (err == -ENETUNREACH)
-- 
2.21.3

