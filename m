Return-Path: <netdev+bounces-10348-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1110972DF1F
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 12:20:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A85B1C208C4
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 10:20:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14A133D385;
	Tue, 13 Jun 2023 10:15:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076973D383
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 10:15:05 +0000 (UTC)
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613D6E6
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 03:15:02 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-30e56fc9fd2so5110999f8f.0
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 03:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent.com; s=google; t=1686651301; x=1689243301;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=72bcXZ+J6bNWWGqskqAX/uK8x0vlcNvpBj1vGVpBWRk=;
        b=c5uzEOJd5Q25WT9kSnvSeOMmE49QWmK3kgo7GNYndpP9Ta0GdnL6Z6cNiM+yrPbtQN
         pAIrsQhGIqaBJDxAxA5OjUzKq2RkeqIATkw2ixir3BvqDmgAIURnEF5egFs1uc3hhUXf
         phrc+DShXzZYll8zGFXC9W44aIm/JjqwgqOhFYBCVMMmyXPd9M6q2vWlUXVaGYMeHv5p
         19jDzi3vToRiMlBiNgPxBVfOsNdd7iyLF7CqdeXezxP+1cwujDHs/KcBgyCdtQr+aBdt
         2zM7L1yp5FlesbzZFlrPo9F5Y7KR+30khTKiDZTIi19OoZ5s97rIb9NXvnfJEnvzV1Vc
         +jLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686651301; x=1689243301;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=72bcXZ+J6bNWWGqskqAX/uK8x0vlcNvpBj1vGVpBWRk=;
        b=LNPjft7LvBQ0I9KXR6BrddEqwXSKD/2evY08jHdnt6riHUAJoCG3VFbTcRo0mbky4D
         cCbC5TH6JOfQO/nirFkqB88fh3SZJXs7LQ88ZAF2Gh3KetlRPL86R6NIueJW9TD3bK+P
         jTbJaVjLOkHDa5fRPSWXx96sxVDfNZ7u3LyedcwcbRwJhxLE/su5jHJMwo9blcecuFGX
         GqEIRh6NYnRreFMVqpdSwTWRV8FNy+jMH6gTQthNvffnLdYmosrmcOKAg5LCqGqQGApy
         yjnF0gbnL+MZff0e9wHZ2dbaxUz5Pv07TOtAMznakBMyLJZSEbeq64yvFipJBI8WrkRW
         732A==
X-Gm-Message-State: AC+VfDxjqpNhe7WFV3hUzQo46JD0hSXWFVrIK/hEktU3Gsos1ecvoR3o
	ah1OQuWWp23yqn/ACiUgOdejFg==
X-Google-Smtp-Source: ACHHUZ7Oc83cRk7wLYXsUJMMFHonVPheudevi9JGLAn9ib4hlMOEsCz9G9FOAzY05GDnH95IzZchVQ==
X-Received: by 2002:a5d:4b84:0:b0:30e:5578:280c with SMTP id b4-20020a5d4b84000000b0030e5578280cmr8010143wrt.67.1686651300905;
        Tue, 13 Jun 2023 03:15:00 -0700 (PDT)
Received: from [192.168.133.193] ([5.148.46.226])
        by smtp.gmail.com with ESMTPSA id k15-20020a5d6e8f000000b0030e6096afb6sm15075020wrz.12.2023.06.13.03.15.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 03:15:00 -0700 (PDT)
From: Lorenz Bauer <lmb@isovalent.com>
Date: Tue, 13 Jun 2023 11:14:57 +0100
Subject: [PATCH bpf-next v2 2/6] net: document inet[6]_lookup_reuseport
 sk_state requirements
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230613-so-reuseport-v2-2-b7c69a342613@isovalent.com>
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

The current implementation was extracted from inet[6]_lhash2_lookup
in commit 80b373f74f9e ("inet: Extract helper for selecting socket
from reuseport group") and commit 5df6531292b5 ("inet6: Extract helper
for selecting socket from reuseport group"). In the original context,
sk is always in TCP_LISTEN state and so did not have a separate check.

Add documentation that specifies which sk_state are valid to pass to
the function.

Signed-off-by: Lorenz Bauer <lmb@isovalent.com>
---
 net/ipv4/inet_hashtables.c  | 14 ++++++++++++++
 net/ipv6/inet6_hashtables.c | 14 ++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 920131e4a65d..91f9210d4e83 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -332,6 +332,20 @@ static inline int compute_score(struct sock *sk, struct net *net,
 	return score;
 }
 
+/**
+ * inet_lookup_reuseport() - execute reuseport logic on AF_INET socket if necessary.
+ * @net: network namespace.
+ * @sk: AF_INET socket, must be in TCP_LISTEN state for TCP or TCP_CLOSE for UDP.
+ * @skb: context for a potential SK_REUSEPORT program.
+ * @doff: header offset.
+ * @saddr: source address.
+ * @sport: source port.
+ * @daddr: destination address.
+ * @hnum: destination port in host byte order.
+ *
+ * Return: NULL if sk doesn't have SO_REUSEPORT set, otherwise a pointer to
+ *         the selected sock or an error.
+ */
 struct sock *inet_lookup_reuseport(struct net *net, struct sock *sk,
 				   struct sk_buff *skb, int doff,
 				   __be32 saddr, __be16 sport,
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index b7c56867314e..208998694ae3 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -111,6 +111,20 @@ static inline int compute_score(struct sock *sk, struct net *net,
 	return score;
 }
 
+/**
+ * inet6_lookup_reuseport() - execute reuseport logic on AF_INET6 socket if necessary.
+ * @net: network namespace.
+ * @sk: AF_INET6 socket, must be in TCP_LISTEN state for TCP or TCP_CLOSE for UDP.
+ * @skb: context for a potential SK_REUSEPORT program.
+ * @doff: header offset.
+ * @saddr: source address.
+ * @sport: source port.
+ * @daddr: destination address.
+ * @hnum: destination port in host byte order.
+ *
+ * Return: NULL if sk doesn't have SO_REUSEPORT set, otherwise a pointer to
+ *         the selected sock or an error.
+ */
 struct sock *inet6_lookup_reuseport(struct net *net, struct sock *sk,
 				    struct sk_buff *skb, int doff,
 				    const struct in6_addr *saddr,

-- 
2.40.1


