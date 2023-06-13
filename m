Return-Path: <netdev+bounces-10347-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91F3472DF1D
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 12:20:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF61F1C20CA6
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 10:20:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C83CA3C0B9;
	Tue, 13 Jun 2023 10:15:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3ED28C15
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 10:15:05 +0000 (UTC)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55229192
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 03:15:01 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f8c5d0b216so5172805e9.1
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 03:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent.com; s=google; t=1686651300; x=1689243300;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N3EvG4bx9yG1/mYfSmQ2wVSFlKC8qVb7fVvvw4JD6B4=;
        b=ZwkkaG+OH1ROkfG388rA4GSxE3tRek8+cyoHh2MJgcvz2mk2IIL3ESQ2hSDn6ca/O2
         SkS2DBksghbdul4Z1P9u+Q0dIqth+CI4OeQPmteCYer8Yy7xEDKTuewozg8tgtmxSjbM
         aqykQ7nKfPKjWgIg/Y7xOzLdvGjgrx6izjf5zR1YKL1kgvOjVacQ89s1y3fYFpwC4E83
         ZBAfsI+HVWWtDZYh9ZWjJdue4ZTc45zbq23tLj5aK1OdtbsLwBrLFVA8yDyHAloDQc+Z
         5zUE/zD+NiVdf3TtZ4kJ3jo2xItT32asLxkWtTxXMANgWS1pgF5FZg61dtzE86kvh3Tg
         e9vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686651300; x=1689243300;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N3EvG4bx9yG1/mYfSmQ2wVSFlKC8qVb7fVvvw4JD6B4=;
        b=ScpjoZB402vybdvkStuiL8kDC+znx04KezTVPJ3gUpvd/lA/MHksFZmk2NyIN47gD+
         pZSycZC3cLnTglVfe5Aaj1rqZfJNOKuHXh+6lYeT1XF3pMU2tJCMCLTQa7vL9vGQDO+p
         hqDbVRtySDgQFqlIrq4LHP97CFxpvc8uEt6Dcz/f88EcBpZaaXN7GCACs19PZbtq75Jo
         KTwW6pFg3KypFKboBGfVvPPLOaT2sB7xchtFvuIedJOqMC0F8uEoJ7qRCE8WNLRuaXLj
         O8E92Ua3R1zJB9GQ8PDT4Hn4ZB7GH2iRvDqOdP+DDheuek8cJl2VX9xcuQm1HTZs6xTi
         a59g==
X-Gm-Message-State: AC+VfDwrizncqS+srMy7IG88X1vFduL6c6Vcl6uiC2HWE4CA2T8D5zoD
	UXh7BEOvx3KaqAXTnIzDXix9gA==
X-Google-Smtp-Source: ACHHUZ56TbBoul5tsY4oHlwQf8pY5cMx3yeUwW9jhKpsXkhBIjzoqnD/wpyYCLq6B7pGpXkMmyaQBg==
X-Received: by 2002:a05:6000:6:b0:30f:bb0c:d19d with SMTP id h6-20020a056000000600b0030fbb0cd19dmr5111857wrx.64.1686651299704;
        Tue, 13 Jun 2023 03:14:59 -0700 (PDT)
Received: from [192.168.133.193] ([5.148.46.226])
        by smtp.gmail.com with ESMTPSA id k15-20020a5d6e8f000000b0030e6096afb6sm15075020wrz.12.2023.06.13.03.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 03:14:59 -0700 (PDT)
From: Lorenz Bauer <lmb@isovalent.com>
Date: Tue, 13 Jun 2023 11:14:56 +0100
Subject: [PATCH bpf-next v2 1/6] net: export inet_lookup_reuseport and
 inet6_lookup_reuseport
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230613-so-reuseport-v2-1-b7c69a342613@isovalent.com>
References: <20230613-so-reuseport-v2-0-b7c69a342613@isovalent.com>
In-Reply-To: <20230613-so-reuseport-v2-0-b7c69a342613@isovalent.com>
To: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, David Ahern <dsahern@kernel.org>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Andrii Nakryiko <andrii@kernel.org>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
 Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, 
 KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, 
 Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, 
 Joe Stringer <joe@wand.net.nz>, Mykola Lysenko <mykolal@fb.com>, 
 Shuah Khan <shuah@kernel.org>, Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: Hemanth Malla <hemanthmalla@gmail.com>, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Lorenz Bauer <lmb@isovalent.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Rename the existing reuseport helpers for IPv4 and IPv6 so that they
can be invoked in the follow up commit. Export them so that DCCP which
may be built as a module can access them.

No change in functionality.

Signed-off-by: Lorenz Bauer <lmb@isovalent.com>
---
 include/net/inet6_hashtables.h |  7 +++++++
 include/net/inet_hashtables.h  |  5 +++++
 net/ipv4/inet_hashtables.c     | 15 ++++++++-------
 net/ipv6/inet6_hashtables.c    | 19 ++++++++++---------
 4 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/include/net/inet6_hashtables.h b/include/net/inet6_hashtables.h
index 56f1286583d3..032ddab48f8f 100644
--- a/include/net/inet6_hashtables.h
+++ b/include/net/inet6_hashtables.h
@@ -48,6 +48,13 @@ struct sock *__inet6_lookup_established(struct net *net,
 					const u16 hnum, const int dif,
 					const int sdif);
 
+struct sock *inet6_lookup_reuseport(struct net *net, struct sock *sk,
+				    struct sk_buff *skb, int doff,
+				    const struct in6_addr *saddr,
+				    __be16 sport,
+				    const struct in6_addr *daddr,
+				    unsigned short hnum);
+
 struct sock *inet6_lookup_listener(struct net *net,
 				   struct inet_hashinfo *hashinfo,
 				   struct sk_buff *skb, int doff,
diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 99bd823e97f6..8734f3488f5d 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -379,6 +379,11 @@ struct sock *__inet_lookup_established(struct net *net,
 				       const __be32 daddr, const u16 hnum,
 				       const int dif, const int sdif);
 
+struct sock *inet_lookup_reuseport(struct net *net, struct sock *sk,
+				   struct sk_buff *skb, int doff,
+				   __be32 saddr, __be16 sport,
+				   __be32 daddr, unsigned short hnum);
+
 static inline struct sock *
 	inet_lookup_established(struct net *net, struct inet_hashinfo *hashinfo,
 				const __be32 saddr, const __be16 sport,
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index e7391bf310a7..920131e4a65d 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -332,10 +332,10 @@ static inline int compute_score(struct sock *sk, struct net *net,
 	return score;
 }
 
-static inline struct sock *lookup_reuseport(struct net *net, struct sock *sk,
-					    struct sk_buff *skb, int doff,
-					    __be32 saddr, __be16 sport,
-					    __be32 daddr, unsigned short hnum)
+struct sock *inet_lookup_reuseport(struct net *net, struct sock *sk,
+				   struct sk_buff *skb, int doff,
+				   __be32 saddr, __be16 sport,
+				   __be32 daddr, unsigned short hnum)
 {
 	struct sock *reuse_sk = NULL;
 	u32 phash;
@@ -346,6 +346,7 @@ static inline struct sock *lookup_reuseport(struct net *net, struct sock *sk,
 	}
 	return reuse_sk;
 }
+EXPORT_SYMBOL_GPL(inet_lookup_reuseport);
 
 /*
  * Here are some nice properties to exploit here. The BSD API
@@ -369,8 +370,8 @@ static struct sock *inet_lhash2_lookup(struct net *net,
 	sk_nulls_for_each_rcu(sk, node, &ilb2->nulls_head) {
 		score = compute_score(sk, net, hnum, daddr, dif, sdif);
 		if (score > hiscore) {
-			result = lookup_reuseport(net, sk, skb, doff,
-						  saddr, sport, daddr, hnum);
+			result = inet_lookup_reuseport(net, sk, skb, doff,
+						       saddr, sport, daddr, hnum);
 			if (result)
 				return result;
 
@@ -399,7 +400,7 @@ static inline struct sock *inet_lookup_run_bpf(struct net *net,
 	if (no_reuseport || IS_ERR_OR_NULL(sk))
 		return sk;
 
-	reuse_sk = lookup_reuseport(net, sk, skb, doff, saddr, sport, daddr, hnum);
+	reuse_sk = inet_lookup_reuseport(net, sk, skb, doff, saddr, sport, daddr, hnum);
 	if (reuse_sk)
 		sk = reuse_sk;
 	return sk;
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index b64b49012655..b7c56867314e 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -111,12 +111,12 @@ static inline int compute_score(struct sock *sk, struct net *net,
 	return score;
 }
 
-static inline struct sock *lookup_reuseport(struct net *net, struct sock *sk,
-					    struct sk_buff *skb, int doff,
-					    const struct in6_addr *saddr,
-					    __be16 sport,
-					    const struct in6_addr *daddr,
-					    unsigned short hnum)
+struct sock *inet6_lookup_reuseport(struct net *net, struct sock *sk,
+				    struct sk_buff *skb, int doff,
+				    const struct in6_addr *saddr,
+				    __be16 sport,
+				    const struct in6_addr *daddr,
+				    unsigned short hnum)
 {
 	struct sock *reuse_sk = NULL;
 	u32 phash;
@@ -127,6 +127,7 @@ static inline struct sock *lookup_reuseport(struct net *net, struct sock *sk,
 	}
 	return reuse_sk;
 }
+EXPORT_SYMBOL_GPL(inet6_lookup_reuseport);
 
 /* called with rcu_read_lock() */
 static struct sock *inet6_lhash2_lookup(struct net *net,
@@ -143,8 +144,8 @@ static struct sock *inet6_lhash2_lookup(struct net *net,
 	sk_nulls_for_each_rcu(sk, node, &ilb2->nulls_head) {
 		score = compute_score(sk, net, hnum, daddr, dif, sdif);
 		if (score > hiscore) {
-			result = lookup_reuseport(net, sk, skb, doff,
-						  saddr, sport, daddr, hnum);
+			result = inet6_lookup_reuseport(net, sk, skb, doff,
+							saddr, sport, daddr, hnum);
 			if (result)
 				return result;
 
@@ -175,7 +176,7 @@ static inline struct sock *inet6_lookup_run_bpf(struct net *net,
 	if (no_reuseport || IS_ERR_OR_NULL(sk))
 		return sk;
 
-	reuse_sk = lookup_reuseport(net, sk, skb, doff, saddr, sport, daddr, hnum);
+	reuse_sk = inet6_lookup_reuseport(net, sk, skb, doff, saddr, sport, daddr, hnum);
 	if (reuse_sk)
 		sk = reuse_sk;
 	return sk;

-- 
2.40.1


