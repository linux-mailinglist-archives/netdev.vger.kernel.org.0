Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2B9B453AA
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 06:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbfFNEly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 00:41:54 -0400
Received: from cat-porwal-prod-mail1.catalyst.net.nz ([202.78.240.226]:47620
        "EHLO cat-porwal-prod-mail1.catalyst.net.nz" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725767AbfFNEly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 00:41:54 -0400
Received: from timbeale-pc.wgtn.cat-it.co.nz (unknown [IPv6:2404:130:0:1000:ed06:1c1d:e56c:b595])
        (Authenticated sender: timbeale@catalyst.net.nz)
        by cat-porwal-prod-mail1.catalyst.net.nz (Postfix) with ESMTPSA id CF1608148B;
        Fri, 14 Jun 2019 16:41:51 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=catalyst.net.nz;
        s=default; t=1560487311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=CZbQtYJQ75mng+B7XGi300O/A08oqE0teNc/gyrwgvg=;
        b=qgcfQCGhwF/WIfwYYMAAX60XevySsTnaZPsVbeCcS/k2G8l2L4L0dTz2iC3fmgtD9Eet1Q
        z7lpF8O6BHp7agTqxhGxiu0Wv2Nx3hVYYWgs4cokOODQjHj/DUEGr0HtD/Zj6CZzHfgAjd
        d4Sj41D9qBEiyVUl903hMy/PvicwrvL9skNgWNvz0n4KhA3yEmZ5DbySHsrLbEBIJ4PMEh
        QNN24g+DfIN5rGoWi13XUznBmYhnkhFYeSSZKG+tpJlhU8C/PbKFsjBi5ygPbtPlBgxVNP
        L/CZjYfPkUOk9g1keg+JHdcRGDIOuubgnUh+qp8J1l+6k0FW0fi5OvHX/A09zw==
From:   Tim Beale <timbeale@catalyst.net.nz>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        Tim Beale <timbeale@catalyst.net.nz>
Subject: [PATCH net next 1/2] udp: Remove unused parameter (exact_dif)
Date:   Fri, 14 Jun 2019 16:41:26 +1200
Message-Id: <1560487287-198694-1-git-send-email-timbeale@catalyst.net.nz>
X-Mailer: git-send-email 2.7.4
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=catalyst.net.nz;
        s=default; t=1560487312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=CZbQtYJQ75mng+B7XGi300O/A08oqE0teNc/gyrwgvg=;
        b=YeoyecpfWHoHkUn7EmMB6ut5ndK6QgUmBoUNU238kHmrbxumJpFLv54CYfrBaW/UavGmVW
        hbvMS+hoz4bc1CQaAc5RyEWknWhYNiCrP7xVuabilBag0b4yw0qDTWzlKm85u6vIHuyXBZ
        GxEqfqf5vGDZlJvfPA1z0jxpk04u9z7A5tnrhSsvWrtLqQT3BbBsUJVq3bZ6pry1vniEyx
        NnZNkWCT3Trm3DyXNLxxsnHulERWMnaG9jny1iP/XusXZW90+FbUUpGOUA8uDEC2XavcWo
        +OsORdVqUojTloT5s+oHiZymFTLThBsaqcvjiJWF1eTS9e7C1IJobcNFaNgN2Q==
ARC-Seal: i=1; s=default; d=catalyst.net.nz; t=1560487312; a=rsa-sha256;
        cv=none;
        b=WZbQoBqf5qvjOcZw0WG8f7pItXA0mz0LSUhX2wFM5szgj9xWQodHJyHeoc8O3v+vl3fGpJ
        4Je7ToHlzokOyX/WIiFAZPgMwjmgFRy8yOfhYH3HeHadDgRtv7BYGT+LAREwCZd1W5oIlC
        8nggahK4r5QTGcCUI59IghP6qNw+atzWYRbqyi5jCTBH1PBHtYDZnY4R8syPRQzLu6kpEO
        GCqOOguuyJMCKaZcpXHUfRxgS/UjtQRszWXm1yYbxLx4xlNyuRbGUtTAh7xixyzg4p4r9a
        +coqr8ri/amxZSdDNEiKgUoXWQ/biSscxXC8jD+G6LCMZTRono54E0RACDIXYA==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=timbeale@catalyst.net.nz smtp.mailfrom=timbeale@catalyst.net.nz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Originally this was used by the VRF logic in compute_score(), but that
was later replaced by udp_sk_bound_dev_eq() and the parameter became
unused.

Note this change adds an 'unused variable' compiler warning that will be
removed in the next patch (I've split the removal in two to make review
slightly easier).

Signed-off-by: Tim Beale <timbeale@catalyst.net.nz>
---
 net/ipv4/udp.c | 10 +++++-----
 net/ipv6/udp.c | 13 ++++++-------
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 86de412..21febf1 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -364,7 +364,7 @@ int udp_v4_get_port(struct sock *sk, unsigned short snum)
 static int compute_score(struct sock *sk, struct net *net,
 			 __be32 saddr, __be16 sport,
 			 __be32 daddr, unsigned short hnum,
-			 int dif, int sdif, bool exact_dif)
+			 int dif, int sdif)
 {
 	int score;
 	struct inet_sock *inet;
@@ -420,7 +420,7 @@ static u32 udp_ehashfn(const struct net *net, const __be32 laddr,
 static struct sock *udp4_lib_lookup2(struct net *net,
 				     __be32 saddr, __be16 sport,
 				     __be32 daddr, unsigned int hnum,
-				     int dif, int sdif, bool exact_dif,
+				     int dif, int sdif,
 				     struct udp_hslot *hslot2,
 				     struct sk_buff *skb)
 {
@@ -432,7 +432,7 @@ static struct sock *udp4_lib_lookup2(struct net *net,
 	badness = 0;
 	udp_portaddr_for_each_entry_rcu(sk, &hslot2->head) {
 		score = compute_score(sk, net, saddr, sport,
-				      daddr, hnum, dif, sdif, exact_dif);
+				      daddr, hnum, dif, sdif);
 		if (score > badness) {
 			if (sk->sk_reuseport) {
 				hash = udp_ehashfn(net, daddr, hnum,
@@ -468,7 +468,7 @@ struct sock *__udp4_lib_lookup(struct net *net, __be32 saddr,
 
 	result = udp4_lib_lookup2(net, saddr, sport,
 				  daddr, hnum, dif, sdif,
-				  exact_dif, hslot2, skb);
+				  hslot2, skb);
 	if (!result) {
 		hash2 = ipv4_portaddr_hash(net, htonl(INADDR_ANY), hnum);
 		slot2 = hash2 & udptable->mask;
@@ -476,7 +476,7 @@ struct sock *__udp4_lib_lookup(struct net *net, __be32 saddr,
 
 		result = udp4_lib_lookup2(net, saddr, sport,
 					  htonl(INADDR_ANY), hnum, dif, sdif,
-					  exact_dif, hslot2, skb);
+					  hslot2, skb);
 	}
 	if (IS_ERR(result))
 		return NULL;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 6935183..8acd24e 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -111,7 +111,7 @@ void udp_v6_rehash(struct sock *sk)
 static int compute_score(struct sock *sk, struct net *net,
 			 const struct in6_addr *saddr, __be16 sport,
 			 const struct in6_addr *daddr, unsigned short hnum,
-			 int dif, int sdif, bool exact_dif)
+			 int dif, int sdif)
 {
 	int score;
 	struct inet_sock *inet;
@@ -155,8 +155,8 @@ static int compute_score(struct sock *sk, struct net *net,
 static struct sock *udp6_lib_lookup2(struct net *net,
 		const struct in6_addr *saddr, __be16 sport,
 		const struct in6_addr *daddr, unsigned int hnum,
-		int dif, int sdif, bool exact_dif,
-		struct udp_hslot *hslot2, struct sk_buff *skb)
+		int dif, int sdif, struct udp_hslot *hslot2,
+		struct sk_buff *skb)
 {
 	struct sock *sk, *result;
 	int score, badness;
@@ -166,7 +166,7 @@ static struct sock *udp6_lib_lookup2(struct net *net,
 	badness = -1;
 	udp_portaddr_for_each_entry_rcu(sk, &hslot2->head) {
 		score = compute_score(sk, net, saddr, sport,
-				      daddr, hnum, dif, sdif, exact_dif);
+				      daddr, hnum, dif, sdif);
 		if (score > badness) {
 			if (sk->sk_reuseport) {
 				hash = udp6_ehashfn(net, daddr, hnum,
@@ -202,7 +202,7 @@ struct sock *__udp6_lib_lookup(struct net *net,
 	hslot2 = &udptable->hash2[slot2];
 
 	result = udp6_lib_lookup2(net, saddr, sport,
-				  daddr, hnum, dif, sdif, exact_dif,
+				  daddr, hnum, dif, sdif,
 				  hslot2, skb);
 	if (!result) {
 		hash2 = ipv6_portaddr_hash(net, &in6addr_any, hnum);
@@ -212,8 +212,7 @@ struct sock *__udp6_lib_lookup(struct net *net,
 
 		result = udp6_lib_lookup2(net, saddr, sport,
 					  &in6addr_any, hnum, dif, sdif,
-					  exact_dif, hslot2,
-					  skb);
+					  hslot2, skb);
 	}
 	if (IS_ERR(result))
 		return NULL;
-- 
2.7.4

