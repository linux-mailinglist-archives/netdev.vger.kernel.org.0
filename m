Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630C13FC180
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 05:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239497AbhHaD1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 23:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235848AbhHaD1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 23:27:10 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2CDC061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 20:26:16 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id n18so15373363pgm.12
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 20:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l9W8i/UbE2usvkgKIAmej5xVDAmCFd87zDLsw03STGM=;
        b=iLfdCbjQNUmwGrAdHkbFAFZr+UafxzkwLm8XTUpYDa34/I4DqlXOEdB111HREDGMp4
         FjD0sDK9yDXk2GIB12KWhgXkJXIlSk0Q0KsDx3al2s/72lxi34cQs4i+HqSjdDD6Aml1
         +e4P0wwGiwxX1s3gsgjMxE/GxzGYRi/BAiBl1dduibLAc/3tGxPTq78HE5QkaYEx51h1
         /dcxee73WNBGpZOsqxmH1KMIy6KiLmUcHKdIvY9Fk9Q7Pv6QkeRe4N6I2WE+UcjJHLmT
         9U53FqRiMDYFExCi1srF366fWzrvu76zMXc+A6Fjb3pEa8Sp43QWhkNRyGJ6NGWxNDCV
         z5lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l9W8i/UbE2usvkgKIAmej5xVDAmCFd87zDLsw03STGM=;
        b=AWJQSmnlrbIJjpBPxcAVrbIyXR+QBgGZVG/gs67VS+eMA0x0FhE1bv+M3KnugUB4N3
         hJTnEaZhP8Uz5iVz5CsH3MNKVmhW5zXoJMgaKh8l6/yLxFkn086WEEoKhk/pmbHE8U0t
         Y1XEQF0eTWm3FmN1VlY8ldTYWWG72FQEYlda5aEaHCbtgMahPM+iU4sx0m3F1elChE6j
         X/9Yx1FCU4IIZlNWZxm2h6K665HIElIdOp+t7n8FHPVG9AhVGayP9vsidMcw1i7vBYer
         RnZbQdZJLNP6tDB2pNiGfzXoQMCL8yOfymgHhnj+LLa0GHh2dv5WwtbdeIhmYf8angJB
         ujMQ==
X-Gm-Message-State: AOAM533dSyw5uDNC7ZSTWvuMYl6IfoCYHFQNTlgG1Qv0ZfLQcfxARVav
        JceGE6/4PRTvepUIfwJVOu8=
X-Google-Smtp-Source: ABdhPJyb+hz3ocO0jBph2009MG91pO5+2WMiPhocrPJFQuc5KDHAg0Rkc6uSjlhJBNx72DETg4xdRA==
X-Received: by 2002:a63:1b60:: with SMTP id b32mr24518828pgm.422.1630380375788;
        Mon, 30 Aug 2021 20:26:15 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:9d39:21f7:8d5a:bfe])
        by smtp.gmail.com with ESMTPSA id 192sm16520106pfz.140.2021.08.30.20.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 20:26:15 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] fou: remove sparse errors
Date:   Mon, 30 Aug 2021 20:26:08 -0700
Message-Id: <20210831032608.932407-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

We need to add __rcu qualifier to avoid these errors:

net/ipv4/fou.c:250:18: warning: incorrect type in assignment (different address spaces)
net/ipv4/fou.c:250:18:    expected struct net_offload const **offloads
net/ipv4/fou.c:250:18:    got struct net_offload const [noderef] __rcu **
net/ipv4/fou.c:251:15: error: incompatible types in comparison expression (different address spaces):
net/ipv4/fou.c:251:15:    struct net_offload const [noderef] __rcu *
net/ipv4/fou.c:251:15:    struct net_offload const *
net/ipv4/fou.c:272:18: warning: incorrect type in assignment (different address spaces)
net/ipv4/fou.c:272:18:    expected struct net_offload const **offloads
net/ipv4/fou.c:272:18:    got struct net_offload const [noderef] __rcu **
net/ipv4/fou.c:273:15: error: incompatible types in comparison expression (different address spaces):
net/ipv4/fou.c:273:15:    struct net_offload const [noderef] __rcu *
net/ipv4/fou.c:273:15:    struct net_offload const *
net/ipv4/fou.c:442:18: warning: incorrect type in assignment (different address spaces)
net/ipv4/fou.c:442:18:    expected struct net_offload const **offloads
net/ipv4/fou.c:442:18:    got struct net_offload const [noderef] __rcu **
net/ipv4/fou.c:443:15: error: incompatible types in comparison expression (different address spaces):
net/ipv4/fou.c:443:15:    struct net_offload const [noderef] __rcu *
net/ipv4/fou.c:443:15:    struct net_offload const *
net/ipv4/fou.c:489:18: warning: incorrect type in assignment (different address spaces)
net/ipv4/fou.c:489:18:    expected struct net_offload const **offloads
net/ipv4/fou.c:489:18:    got struct net_offload const [noderef] __rcu **
net/ipv4/fou.c:490:15: error: incompatible types in comparison expression (different address spaces):
net/ipv4/fou.c:490:15:    struct net_offload const [noderef] __rcu *
net/ipv4/fou.c:490:15:    struct net_offload const *
net/ipv4/udp_offload.c:170:26: warning: incorrect type in assignment (different address spaces)
net/ipv4/udp_offload.c:170:26:    expected struct net_offload const **offloads
net/ipv4/udp_offload.c:170:26:    got struct net_offload const [noderef] __rcu **
net/ipv4/udp_offload.c:171:23: error: incompatible types in comparison expression (different address spaces):
net/ipv4/udp_offload.c:171:23:    struct net_offload const [noderef] __rcu *
net/ipv4/udp_offload.c:171:23:    struct net_offload const *

Fixes: efc98d08e1ec ("fou: eliminate IPv4,v6 specific GRO functions")
Fixes: 8bce6d7d0d1e ("udp: Generalize skb_udp_segment")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/fou.c         | 10 +++++-----
 net/ipv4/udp_offload.c |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/fou.c b/net/ipv4/fou.c
index e5f69b0bf3df551e28344ddd1c5068069c823cd1..8fcbc6258ec527f3069f7a525d33929c0ffa1bdf 100644
--- a/net/ipv4/fou.c
+++ b/net/ipv4/fou.c
@@ -230,8 +230,8 @@ static struct sk_buff *fou_gro_receive(struct sock *sk,
 				       struct list_head *head,
 				       struct sk_buff *skb)
 {
+	const struct net_offload __rcu **offloads;
 	u8 proto = fou_from_sock(sk)->protocol;
-	const struct net_offload **offloads;
 	const struct net_offload *ops;
 	struct sk_buff *pp = NULL;
 
@@ -263,10 +263,10 @@ static struct sk_buff *fou_gro_receive(struct sock *sk,
 static int fou_gro_complete(struct sock *sk, struct sk_buff *skb,
 			    int nhoff)
 {
-	const struct net_offload *ops;
+	const struct net_offload __rcu **offloads;
 	u8 proto = fou_from_sock(sk)->protocol;
+	const struct net_offload *ops;
 	int err = -ENOSYS;
-	const struct net_offload **offloads;
 
 	rcu_read_lock();
 	offloads = NAPI_GRO_CB(skb)->is_ipv6 ? inet6_offloads : inet_offloads;
@@ -311,7 +311,7 @@ static struct sk_buff *gue_gro_receive(struct sock *sk,
 				       struct list_head *head,
 				       struct sk_buff *skb)
 {
-	const struct net_offload **offloads;
+	const struct net_offload __rcu **offloads;
 	const struct net_offload *ops;
 	struct sk_buff *pp = NULL;
 	struct sk_buff *p;
@@ -457,8 +457,8 @@ static struct sk_buff *gue_gro_receive(struct sock *sk,
 
 static int gue_gro_complete(struct sock *sk, struct sk_buff *skb, int nhoff)
 {
-	const struct net_offload **offloads;
 	struct guehdr *guehdr = (struct guehdr *)(skb->data + nhoff);
+	const struct net_offload __rcu **offloads;
 	const struct net_offload *ops;
 	unsigned int guehlen = 0;
 	u8 proto;
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 1380a6b6f4ff429960ecb3ffcf1197f80e81b8f3..86d32a1e62ac969fae1879c8cb5f992c1b026987 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -152,8 +152,8 @@ struct sk_buff *skb_udp_tunnel_segment(struct sk_buff *skb,
 				       netdev_features_t features,
 				       bool is_ipv6)
 {
+	const struct net_offload __rcu **offloads;
 	__be16 protocol = skb->protocol;
-	const struct net_offload **offloads;
 	const struct net_offload *ops;
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	struct sk_buff *(*gso_inner_segment)(struct sk_buff *skb,
-- 
2.33.0.259.gc128427fd7-goog

