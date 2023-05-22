Return-Path: <netdev+bounces-4325-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CBFCB70C145
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 16:38:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 906B128103A
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:38:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E502713AC8;
	Mon, 22 May 2023 14:38:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D918714278
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 14:38:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B942F4
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 07:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684766292;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CKRD9+9UtmyjsQhADPVn0alMuxSJCeFi3wku7C3YHJs=;
	b=NngFiXCvGmGzWrJCuZwT2Vn6pobTO5wmod4Nay7H1tJLhc7MYpidd+Nhc09PKMOUEx9UQo
	grinfK1kXILoK/fu1usUZtpK0jNjtV7xMwj9XYh8ecGoZ83q4Ty427IB96Fw/nUpU6UcHT
	vtkSz/IwpZPJC7cGkWJaBo+tIEhLZ18=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-180-bSK7c7msP_el4UTffV2Qfw-1; Mon, 22 May 2023 10:38:11 -0400
X-MC-Unique: bSK7c7msP_el4UTffV2Qfw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-30953bcb997so1233708f8f.2
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 07:38:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684766289; x=1687358289;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CKRD9+9UtmyjsQhADPVn0alMuxSJCeFi3wku7C3YHJs=;
        b=ACX3LdUr9LgINT+WXeH6I0i0PvPTpbZQ8wFTAZOPfOgRtb7+pekc4TgP3T3rNQ9LOZ
         rdgS/B5fg6c7ZFhKtQEkQnm1IOWlsB5dsoPaWugJTDKM+E7TNBUkw2f90gev+LiQmmM3
         tayQkPhWD+kD0DenKGKfGbcB2fY2SxPRklH/KLWusyn94Foh2JxfQLJ7dKVD9U9/htej
         BC5lCJTp9gFMH/VIeOrnLUwjf20MSBc/yVQ0UWbRfBXhxfhOHgNj3ELT6oFEX69NS515
         zGfqbTbA7dPsPcUZKlEgM/tno24FiR6TA5pDlIU9Vb0lUlqcwvY1mcl3MHGG41ie2ka4
         vzIg==
X-Gm-Message-State: AC+VfDwXg2PwBsL/B1NCVIZS2J14ofqYBN/RMshYsD3hCrLojUgVHaeC
	JSbI0aXb5gGSRh1Gx/h3ZLOaaTEXI25kZF9C/QipUsElo9ylqrN/vfBrYoVWQ67w3Hj2CA1PoJe
	90fQDELIwskbNCsp2OxK3N3q7
X-Received: by 2002:adf:e8ce:0:b0:309:50e7:7d0 with SMTP id k14-20020adfe8ce000000b0030950e707d0mr6982192wrn.31.1684766289453;
        Mon, 22 May 2023 07:38:09 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6v/wN27J0lhtqEjlrhqIxd6gqles27SwZjQ9Uz9n3r+yWZla5iP8r9raykGCTtsaBwIi9USA==
X-Received: by 2002:adf:e8ce:0:b0:309:50e7:7d0 with SMTP id k14-20020adfe8ce000000b0030950e707d0mr6982181wrn.31.1684766289290;
        Mon, 22 May 2023 07:38:09 -0700 (PDT)
Received: from debian (2a01cb058d652b001c6f8f132b579d2b.ipv6.abo.wanadoo.fr. [2a01:cb05:8d65:2b00:1c6f:8f13:2b57:9d2b])
        by smtp.gmail.com with ESMTPSA id c11-20020adfe74b000000b00306281cfa59sm7994843wrn.47.2023.05.22.07.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 07:38:08 -0700 (PDT)
Date: Mon, 22 May 2023 16:38:07 +0200
From: Guillaume Nault <gnault@redhat.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next 3/3] udp: Stop using RTO_ONLINK.
Message-ID: <abc28174280c6947ab78ce77772df695b812843c.1684764727.git.gnault@redhat.com>
References: <cover.1684764727.git.gnault@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1684764727.git.gnault@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Use ip_sendmsg_scope() to properly initialise the scope in
flowi4_init_output(), instead of overriding tos with the RTO_ONLINK
flag. The objective is to eventually remove RTO_ONLINK, which will
allow converting .flowi4_tos to dscp_t.

Now that the scope is determined by ip_sendmsg_scope(), we need to
check its result to set the 'connected' variable.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/ipv4/udp.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index aa32afd871ee..64750baa55d6 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1062,8 +1062,8 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	int free = 0;
 	int connected = 0;
 	__be32 daddr, faddr, saddr;
+	u8 tos, scope;
 	__be16 dport;
-	u8  tos;
 	int err, is_udplite = IS_UDPLITE(sk);
 	int corkreq = READ_ONCE(up->corkflag) || msg->msg_flags&MSG_MORE;
 	int (*getfrag)(void *, char *, int, int, int, struct sk_buff *);
@@ -1183,12 +1183,9 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		connected = 0;
 	}
 	tos = get_rttos(&ipc, inet);
-	if (sock_flag(sk, SOCK_LOCALROUTE) ||
-	    (msg->msg_flags & MSG_DONTROUTE) ||
-	    (ipc.opt && ipc.opt->opt.is_strictroute)) {
-		tos |= RTO_ONLINK;
+	scope = ip_sendmsg_scope(inet, &ipc, msg);
+	if (scope == RT_SCOPE_LINK)
 		connected = 0;
-	}
 
 	if (ipv4_is_multicast(daddr)) {
 		if (!ipc.oif || netif_index_is_l3_master(sock_net(sk), ipc.oif))
@@ -1221,11 +1218,9 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 		fl4 = &fl4_stack;
 
-		flowi4_init_output(fl4, ipc.oif, ipc.sockc.mark, tos,
-				   RT_SCOPE_UNIVERSE, sk->sk_protocol,
-				   flow_flags,
-				   faddr, saddr, dport, inet->inet_sport,
-				   sk->sk_uid);
+		flowi4_init_output(fl4, ipc.oif, ipc.sockc.mark, tos, scope,
+				   sk->sk_protocol, flow_flags, faddr, saddr,
+				   dport, inet->inet_sport, sk->sk_uid);
 
 		security_sk_classify_flow(sk, flowi4_to_flowi_common(fl4));
 		rt = ip_route_output_flow(net, fl4, sk);
-- 
2.39.2


