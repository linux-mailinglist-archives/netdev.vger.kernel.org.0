Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5777D229D8B
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 18:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730292AbgGVQww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 12:52:52 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:9364 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgGVQww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 12:52:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1595436772; x=1626972772;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=+afWGUuvydBUDJ1rP0W9TgmIG6g6cw2xWDAsyXoAs2U=;
  b=G9eLG6J1xFVTw/fmzHgZNr/ERHXj5S4Mdujp9wxxtiHuChq3hLeqqZpX
   wMLZms5cxJtUU60OEoxCIDYMm220KJqyRG5DqKlrFTfNaW9MPkP57/Cy1
   RxOheDzI1KgZeeggb/hTdHlELPQVT9ONnIlgG07/FZbKkIRb8Sd4vH+qr
   o=;
IronPort-SDR: MNiIE06t+3hLlpjOnphfNW0Ltra6jx8w7Ul7nOnOQnchEOMryNqiKm/7WmkP4jzkp3QHZex/xX
 ek+N9H2SMPwQ==
X-IronPort-AV: E=Sophos;i="5.75,383,1589241600"; 
   d="scan'208";a="43524156"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 22 Jul 2020 16:52:51 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (Postfix) with ESMTPS id DFFFBA2955;
        Wed, 22 Jul 2020 16:52:47 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Jul 2020 16:52:46 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.248) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Jul 2020 16:52:36 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Willem de Bruijn <willemb@google.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        <netdev@vger.kernel.org>, Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        "Willem de Bruijn" <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net] udp: Remove an unnecessary variable in udp[46]_lib_lookup2().
Date:   Thu, 23 Jul 2020 01:52:27 +0900
Message-ID: <20200722165227.51046-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.248]
X-ClientProxiedBy: EX13D41UWC001.ant.amazon.com (10.43.162.107) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch removes an unnecessary variable in udp[46]_lib_lookup2() and
makes it easier to resolve a merge conflict with bpf-next reported in
the link below.

Link: https://lore.kernel.org/linux-next/20200722132143.700a5ccc@canb.auug.org.au/
Fixes: efc6b6f6c311 ("udp: Improve load balancing for SO_REUSEPORT.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
---
 net/ipv4/udp.c | 15 ++++++++-------
 net/ipv6/udp.c | 15 ++++++++-------
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 4077d589b72e..22fb231e27c3 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -416,7 +416,7 @@ static struct sock *udp4_lib_lookup2(struct net *net,
 				     struct udp_hslot *hslot2,
 				     struct sk_buff *skb)
 {
-	struct sock *sk, *result, *reuseport_result;
+	struct sock *sk, *result;
 	int score, badness;
 	u32 hash = 0;
 
@@ -426,19 +426,20 @@ static struct sock *udp4_lib_lookup2(struct net *net,
 		score = compute_score(sk, net, saddr, sport,
 				      daddr, hnum, dif, sdif);
 		if (score > badness) {
-			reuseport_result = NULL;
+			result = NULL;
 
 			if (sk->sk_reuseport &&
 			    sk->sk_state != TCP_ESTABLISHED) {
 				hash = udp_ehashfn(net, daddr, hnum,
 						   saddr, sport);
-				reuseport_result = reuseport_select_sock(sk, hash, skb,
-									 sizeof(struct udphdr));
-				if (reuseport_result && !reuseport_has_conns(sk, false))
-					return reuseport_result;
+				result = reuseport_select_sock(sk, hash, skb,
+							       sizeof(struct udphdr));
+				if (result && !reuseport_has_conns(sk, false))
+					return result;
 			}
 
-			result = reuseport_result ? : sk;
+			if (!result)
+				result = sk;
 			badness = score;
 		}
 	}
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index a8d74f44056a..29c7bb2609c4 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -148,7 +148,7 @@ static struct sock *udp6_lib_lookup2(struct net *net,
 		int dif, int sdif, struct udp_hslot *hslot2,
 		struct sk_buff *skb)
 {
-	struct sock *sk, *result, *reuseport_result;
+	struct sock *sk, *result;
 	int score, badness;
 	u32 hash = 0;
 
@@ -158,20 +158,21 @@ static struct sock *udp6_lib_lookup2(struct net *net,
 		score = compute_score(sk, net, saddr, sport,
 				      daddr, hnum, dif, sdif);
 		if (score > badness) {
-			reuseport_result = NULL;
+			result = NULL;
 
 			if (sk->sk_reuseport &&
 			    sk->sk_state != TCP_ESTABLISHED) {
 				hash = udp6_ehashfn(net, daddr, hnum,
 						    saddr, sport);
 
-				reuseport_result = reuseport_select_sock(sk, hash, skb,
-									 sizeof(struct udphdr));
-				if (reuseport_result && !reuseport_has_conns(sk, false))
-					return reuseport_result;
+				result = reuseport_select_sock(sk, hash, skb,
+							       sizeof(struct udphdr));
+				if (result && !reuseport_has_conns(sk, false))
+					return result;
 			}
 
-			result = reuseport_result ? : sk;
+			if (!result)
+				result = sk;
 			badness = score;
 		}
 	}
-- 
2.17.2 (Apple Git-113)

