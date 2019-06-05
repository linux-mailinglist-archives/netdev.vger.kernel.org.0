Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58E1B36678
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 23:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfFEVLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 17:11:51 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:43647 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbfFEVLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 17:11:51 -0400
Received: from orion.localdomain ([77.2.1.21]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1N9d91-1gWAgb0g9V-015WNM; Wed, 05 Jun 2019 23:11:40 +0200
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH] net: ipv6: drop unneeded likely() call around IS_ERR()
Date:   Wed,  5 Jun 2019 23:11:34 +0200
Message-Id: <1559769094-20889-1-git-send-email-info@metux.net>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K1:kzfUvZBslRGK3Eqrp6dPN79wrH2uqqwUiUqIcqkdKDPcXMi7HSW
 yqCx5iuw3QsUMKVapKZTdGC83bjYvCCEc/hMo94i3Ht/xG8V5INfOHqUOr04XIT+R7zdZ6N
 C+Oj5rY65s2k5RHUEHUuznRUGd+75FR/j4G0vyaq1onvSi5q85XeAhzZa/dSmx2GtoELh6e
 u6NwEV0z62ADVXGutPXHQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:qNyOPwVhyQU=:zJHJhAopzU9Xe7/ZXoO7+Q
 ONV0m0GK/eeyDKetGYx1tRXveBeMCU3NxFNkScMyMJwtL2qnQDWlscxFYOoezDt2Jd23s8GPq
 qAGvKXVaS7JWGWNJ9tUqqOM3TowhVSLgOerbjjDuzDY/SQHbDjxo7/gV6k56hX+T/FtKNr9vs
 8i0Yx6QamFgnHatbNPDfK/jtmPKblMyQ485wQYqjV2pqSvNh06xDvi67+bYs0degVVp0Pm0u6
 AK8eGFa1FSeFX6+NOz4YW0iMC+wYh04i/zMcc1/mMRvMxcird65hm9abCZbUZPK4KGMxb7UTX
 Nf+17poJ5MfHBIE4hYKmV9adcIfp5JNLNdWmdBFx9c98e1Ufl2CzHnYqbFkRyrDyq3B6gye4w
 Aa7WzEu74MRPve54aQmMbVc0qocnCwZPF2aFR0tYc/PgYdytaONJRd1eP8ry7GN6Zcu8q6qLa
 ICnwGQP4GcfI2Nd0Y9YNJCWXTokNJQuI81kxHsCnXy0gqdkgzqCBwJBfQqHL6pom1I9JdXBcL
 lEOevO1q5ovMZkLVffSuNb5S+/KbN4LkiqK/OnWFfv+2cI7gZd4oGBm20ZNtmJ09gS5N1TnRB
 WjZoaJ9JLPjg5PDIEwk1BDOaPy7n1uUV/vg21TJAKqy8RnlpFlHZQA0Q6k+uzAXHkhewQjee0
 u6+5gaVgCjzpLOurC56LPIx+bzROs2dTgQtM2YyRCupYSUA5Xu/qhdvJhRpXtvXgjBMwITPQa
 z8d5RymCBhINDwKe3VGtZkT9M0YCoo4ybRb5CQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Enrico Weigelt <info@metux.net>

IS_ERR() already calls unlikely(), so this extra unlikely() call
around IS_ERR() is not needed.

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 net/ipv6/inet6_hashtables.c | 2 +-
 net/ipv6/udp.c              | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index b2a55f3..cf60fae 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -174,7 +174,7 @@ struct sock *inet6_lookup_listener(struct net *net,
 				     saddr, sport, &in6addr_any, hnum,
 				     dif, sdif);
 done:
-	if (unlikely(IS_ERR(result)))
+	if (IS_ERR(result))
 		return NULL;
 	return result;
 }
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index b3418a7..6935183 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -215,7 +215,7 @@ struct sock *__udp6_lib_lookup(struct net *net,
 					  exact_dif, hslot2,
 					  skb);
 	}
-	if (unlikely(IS_ERR(result)))
+	if (IS_ERR(result))
 		return NULL;
 	return result;
 }
-- 
1.9.1

