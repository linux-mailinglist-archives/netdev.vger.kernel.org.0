Return-Path: <netdev+bounces-4323-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 518AA70C141
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 16:38:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F6831C20846
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:38:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F48BD50B;
	Mon, 22 May 2023 14:38:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406FA13AED
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 14:38:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD099FD
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 07:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684766282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D6kaQkoC5xbaGSYGFWfGaRKHibSjXH75c8Xt2vBJoCo=;
	b=NGpcKC0Os4G6jXRd1xdWhghbPeXo4NWedcQR1+Ah4GuWKzEdl58IQHM+1OJxaaAwf9TrCZ
	NMVwKPH3VTY2QtSIRSXn8vbL+DxH4ecmS22kasjUwyettpOt5g9jtg0mDayWMoTiXp9WWe
	nzNQxEWIv2Wo4bWIvODej4P+1Bn8ORY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-404-zN5PAhdyNxKiFupbh7L3nA-1; Mon, 22 May 2023 10:38:01 -0400
X-MC-Unique: zN5PAhdyNxKiFupbh7L3nA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f603b8eb61so7459445e9.0
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 07:38:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684766280; x=1687358280;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D6kaQkoC5xbaGSYGFWfGaRKHibSjXH75c8Xt2vBJoCo=;
        b=Zix8cGJ5j5voMZadPNQsDYVVKNNpkE4Qm7fEt4bim6mbdGtehoO2WnS1xE6dPPK3dX
         ubfGj6vrSwI1DmNATNJYxX3uUmDrcmD3medXFXtrMpNcaw1O6TOSY8GIF/WcHOYMcU5i
         IXwsZrmwmf2sXw/oynweXHIfrZaL9pUdDuxSyUb+R250SauLSHNPpKl5FLDS/L0vshr7
         LBP6xrnPRlGF1Skg4SuOzYEVRr48fu1BrDmni5u01Xk02UzJbzOtpGOqeJR2wS5sL7lQ
         G7ASBzNk6dCoPBd9rtJCZ5bMpXWppU2aIhnAYEBLeM97rQ2K9FMHbsSqF23lqzpXKWjt
         aTQg==
X-Gm-Message-State: AC+VfDyA1V5Vg4P4puoShM+PBK7NPBlfhnsdctoxZvFV3im+7tiC8Dir
	BzC9YWTUAeln1ApfVF3suad2qTIitp3SuClgGUK/KWmwn4nqGea9iW6sZzJheuI4nCEpKcTeW4x
	R4CU3k89HQaSFFExY
X-Received: by 2002:a1c:f217:0:b0:3f4:2c71:b9ad with SMTP id s23-20020a1cf217000000b003f42c71b9admr7913770wmc.30.1684766279986;
        Mon, 22 May 2023 07:37:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7tUxgI+k4KN8exRUNaiAtiHrDM8MXbZm9wXnlswS65TKF4Cqr3iz34qwgRX7zVKKENNHFh4Q==
X-Received: by 2002:a1c:f217:0:b0:3f4:2c71:b9ad with SMTP id s23-20020a1cf217000000b003f42c71b9admr7913755wmc.30.1684766279715;
        Mon, 22 May 2023 07:37:59 -0700 (PDT)
Received: from debian (2a01cb058d652b001c6f8f132b579d2b.ipv6.abo.wanadoo.fr. [2a01:cb05:8d65:2b00:1c6f:8f13:2b57:9d2b])
        by smtp.gmail.com with ESMTPSA id i10-20020adfe48a000000b002fed865c55esm7887282wrm.56.2023.05.22.07.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 07:37:59 -0700 (PDT)
Date: Mon, 22 May 2023 16:37:57 +0200
From: Guillaume Nault <gnault@redhat.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next 1/3] ping: Stop using RTO_ONLINK.
Message-ID: <f4ceb3ad415f7353885baf0a0dc56226ebe8302e.1684764727.git.gnault@redhat.com>
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

Define a new helper to figure out the correct route scope to use on TX,
depending on socket configuration, ancillary data and send flags.

Use this new helper to properly initialise the scope in
flowi4_init_output(), instead of overriding tos with the RTO_ONLINK
flag.

The objective is to eventually remove RTO_ONLINK, which will allow
converting .flowi4_tos to dscp_t.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 include/net/ip.h | 13 +++++++++++++
 net/ipv4/ping.c  | 15 +++++----------
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index c3fffaa92d6e..6e262efa0d55 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -242,6 +242,19 @@ static inline struct sk_buff *ip_finish_skb(struct sock *sk, struct flowi4 *fl4)
 	return __ip_make_skb(sk, fl4, &sk->sk_write_queue, &inet_sk(sk)->cork.base);
 }
 
+/* Get the route scope that should be used when sending a packet. */
+static inline u8 ip_sendmsg_scope(const struct inet_sock *inet,
+				  const struct ipcm_cookie *ipc,
+				  const struct msghdr *msg)
+{
+	if (sock_flag(&inet->sk, SOCK_LOCALROUTE) ||
+	    msg->msg_flags & MSG_DONTROUTE ||
+	    (ipc->opt && ipc->opt->opt.is_strictroute))
+		return RT_SCOPE_LINK;
+
+	return RT_SCOPE_UNIVERSE;
+}
+
 static inline __u8 get_rttos(struct ipcm_cookie* ipc, struct inet_sock *inet)
 {
 	return (ipc->tos != -1) ? RT_TOS(ipc->tos) : RT_TOS(inet->tos);
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 3793c81bda8a..25dd78cee179 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -705,7 +705,7 @@ static int ping_v4_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	struct ip_options_data opt_copy;
 	int free = 0;
 	__be32 saddr, daddr, faddr;
-	u8  tos;
+	u8 tos, scope;
 	int err;
 
 	pr_debug("ping_v4_sendmsg(sk=%p,sk->num=%u)\n", inet, inet->inet_num);
@@ -769,11 +769,7 @@ static int ping_v4_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		faddr = ipc.opt->opt.faddr;
 	}
 	tos = get_rttos(&ipc, inet);
-	if (sock_flag(sk, SOCK_LOCALROUTE) ||
-	    (msg->msg_flags & MSG_DONTROUTE) ||
-	    (ipc.opt && ipc.opt->opt.is_strictroute)) {
-		tos |= RTO_ONLINK;
-	}
+	scope = ip_sendmsg_scope(inet, &ipc, msg);
 
 	if (ipv4_is_multicast(daddr)) {
 		if (!ipc.oif || netif_index_is_l3_master(sock_net(sk), ipc.oif))
@@ -783,10 +779,9 @@ static int ping_v4_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	} else if (!ipc.oif)
 		ipc.oif = inet->uc_index;
 
-	flowi4_init_output(&fl4, ipc.oif, ipc.sockc.mark, tos,
-			   RT_SCOPE_UNIVERSE, sk->sk_protocol,
-			   inet_sk_flowi_flags(sk), faddr, saddr, 0, 0,
-			   sk->sk_uid);
+	flowi4_init_output(&fl4, ipc.oif, ipc.sockc.mark, tos, scope,
+			   sk->sk_protocol, inet_sk_flowi_flags(sk), faddr,
+			   saddr, 0, 0, sk->sk_uid);
 
 	fl4.fl4_icmp_type = user_icmph.type;
 	fl4.fl4_icmp_code = user_icmph.code;
-- 
2.39.2


