Return-Path: <netdev+bounces-4324-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE41170C144
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 16:38:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9E1A28108D
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:38:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80220134AF;
	Mon, 22 May 2023 14:38:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E40E14278
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 14:38:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A27E3B0
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 07:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684766287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RTuSciyWmk8llf+V0Iz0G5RL536uKsfx/ZPPSBh7olQ=;
	b=M1dROke7N2LsRDJCnuAiW6Cdtqwle4RbLzPnhkY+HT/NAnrrSGZPlOeRdBr53Bq9WEopqI
	fhqrY51WZgLXTHzM3wAZ8EJBu26KgKyvRvGR9NDvTrOChhOX7eNngp42Fqg+mP4N7Z3U1R
	yqz8ZNTcUbIgyV87NbnipYir3R9GMGg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-5zN8m7UANXugsx5VwCno-g-1; Mon, 22 May 2023 10:38:06 -0400
X-MC-Unique: 5zN8m7UANXugsx5VwCno-g-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f453ff4cdfso21620585e9.2
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 07:38:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684766285; x=1687358285;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RTuSciyWmk8llf+V0Iz0G5RL536uKsfx/ZPPSBh7olQ=;
        b=SYdyXCzPNtK3h+6XtpvrDVPCayUZSd+XljrIohOL60qUtrzFB8Z0R1AXfSnQoaLOQG
         PxuHkzQMMzpnTb0zV7LS9FKWjCEZRrPoMRJEbWsaTJmaG8kmIW0Sga2pf4msA/L+SouI
         BNUJL4ERDonirxQ02cJQ6qwvb3TF3RCRk/7UWCPTdQUPHF9N93UDjLvl1rOX2mX+bP8Q
         Bq2WngRiVMJEZUnGHwABeQcwRQNIPgGu2wSt7mDU7pWAFU6utQixNsUUGYYIEvMOnxOX
         TlQa9BUa6fwvW5gLwxfQakoOt8BhqGIRN5a50I8+BFbJrggPgy6BZuZS7k4UKHWTF/hm
         BDsg==
X-Gm-Message-State: AC+VfDyLhhPLWn36jwEts9niuWOrV/krvWjaQEby1KUuP6HKPs+NQ38R
	FfYtPBrIVl0yLAUfE/Nx7RvDuPGdXckwRZcg3tMlznp/cVLU1tNSKgoot/Y9UGanyyDFR1ze2eB
	ZTXd9W7/ktqbVkHHX
X-Received: by 2002:a05:600c:2148:b0:3f4:26d4:91b0 with SMTP id v8-20020a05600c214800b003f426d491b0mr6291023wml.40.1684766285131;
        Mon, 22 May 2023 07:38:05 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6I/94VDheuFkH1c4Hn8HWC3aXUJUHHYieGf/ecS/F0U9Nux8wN8953Fcag9c/8Ie5tFNBkjA==
X-Received: by 2002:a05:600c:2148:b0:3f4:26d4:91b0 with SMTP id v8-20020a05600c214800b003f426d491b0mr6291005wml.40.1684766284786;
        Mon, 22 May 2023 07:38:04 -0700 (PDT)
Received: from debian (2a01cb058d652b001c6f8f132b579d2b.ipv6.abo.wanadoo.fr. [2a01:cb05:8d65:2b00:1c6f:8f13:2b57:9d2b])
        by smtp.gmail.com with ESMTPSA id x11-20020a05600c21cb00b003f427db0015sm8588952wmj.38.2023.05.22.07.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 07:38:04 -0700 (PDT)
Date: Mon, 22 May 2023 16:38:02 +0200
From: Guillaume Nault <gnault@redhat.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next 2/3] raw: Stop using RTO_ONLINK.
Message-ID: <6ca7a70859803ff272cc965409856de354fa4e6c.1684764727.git.gnault@redhat.com>
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

The MSG_DONTROUTE and SOCK_LOCALROUTE cases were already handled by
raw_sendmsg() (SOCK_LOCALROUTE was handled by the RT_CONN_FLAGS*()
macros called by get_rtconn_flags()). However, opt.is_strictroute
wasn't taken into account. Therefore, a side effect of this patch is to
now honour opt.is_strictroute, and thus align raw_sendmsg() with
ping_v4_sendmsg() and udp_sendmsg().

Since raw_sendmsg() was the only user of get_rtconn_flags(), we can now
remove this function.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 include/net/ip.h |  5 -----
 net/ipv4/raw.c   | 10 ++++------
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 6e262efa0d55..fab910be252c 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -260,11 +260,6 @@ static inline __u8 get_rttos(struct ipcm_cookie* ipc, struct inet_sock *inet)
 	return (ipc->tos != -1) ? RT_TOS(ipc->tos) : RT_TOS(inet->tos);
 }
 
-static inline __u8 get_rtconn_flags(struct ipcm_cookie* ipc, struct sock* sk)
-{
-	return (ipc->tos != -1) ? RT_CONN_FLAGS_TOS(sk, ipc->tos) : RT_CONN_FLAGS(sk);
-}
-
 /* datagram.c */
 int __ip4_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len);
 int ip4_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len);
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index ff712bf2a98d..8b7b5c842bdd 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -476,10 +476,10 @@ static int raw_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	struct ipcm_cookie ipc;
 	struct rtable *rt = NULL;
 	struct flowi4 fl4;
+	u8 tos, scope;
 	int free = 0;
 	__be32 daddr;
 	__be32 saddr;
-	u8  tos;
 	int err;
 	struct ip_options_data opt_copy;
 	struct raw_frag_vec rfv;
@@ -572,9 +572,8 @@ static int raw_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			daddr = ipc.opt->opt.faddr;
 		}
 	}
-	tos = get_rtconn_flags(&ipc, sk);
-	if (msg->msg_flags & MSG_DONTROUTE)
-		tos |= RTO_ONLINK;
+	tos = get_rttos(&ipc, inet);
+	scope = ip_sendmsg_scope(inet, &ipc, msg);
 
 	if (ipv4_is_multicast(daddr)) {
 		if (!ipc.oif || netif_index_is_l3_master(sock_net(sk), ipc.oif))
@@ -597,8 +596,7 @@ static int raw_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		}
 	}
 
-	flowi4_init_output(&fl4, ipc.oif, ipc.sockc.mark, tos,
-			   RT_SCOPE_UNIVERSE,
+	flowi4_init_output(&fl4, ipc.oif, ipc.sockc.mark, tos, scope,
 			   hdrincl ? IPPROTO_RAW : sk->sk_protocol,
 			   inet_sk_flowi_flags(sk) |
 			    (hdrincl ? FLOWI_FLAG_KNOWN_NH : 0),
-- 
2.39.2


