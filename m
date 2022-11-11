Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01FD762521E
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 05:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbiKKEDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 23:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbiKKEDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 23:03:35 -0500
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3AD6F344
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 20:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1668139283; x=1699675283;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SvAq9+Q1L5BOvIPkbPRyRX3UP8pBfKsA1bSsXPjkJgQ=;
  b=mwpTOsFrooIKITwuKkEzolppO9QJvD4xBwykNoGj8gZMTDl2wsLDBoEb
   98MN+Gb0pH9c/Qu7yyYK1tZ+xwX3LJX8B6U1xD83b4GH6bAzntzNZw2mw
   tubIcoDxsBys7XfN8Jmx69uX30IgN2+4iWfNHpXWunbatnfQDrQNdBb2m
   g=;
X-IronPort-AV: E=Sophos;i="5.96,155,1665446400"; 
   d="scan'208";a="261983307"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-25ac6bd5.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2022 04:01:15 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1d-m6i4x-25ac6bd5.us-east-1.amazon.com (Postfix) with ESMTPS id 1DA3A420F0;
        Fri, 11 Nov 2022 04:01:13 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Fri, 11 Nov 2022 04:01:13 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.14) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Fri, 11 Nov 2022 04:01:10 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 net-next 1/6] udp: Clean up some functions.
Date:   Thu, 10 Nov 2022 20:00:29 -0800
Message-ID: <20221111040034.29736-2-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221111040034.29736-1-kuniyu@amazon.com>
References: <20221111040034.29736-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.14]
X-ClientProxiedBy: EX13D19UWC002.ant.amazon.com (10.43.162.179) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds no functional change and cleans up some functions
that the following patches touch around so that we make them tidy
and easy to review/revert.  The change is mainly to keep reverse
christmas tree order.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/udp.c | 39 +++++++++++++++++++++++----------------
 net/ipv6/udp.c | 12 ++++++++----
 2 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index b859d6c8298e..a34de263e9ce 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -232,16 +232,16 @@ static int udp_reuseport_add_sock(struct sock *sk, struct udp_hslot *hslot)
 int udp_lib_get_port(struct sock *sk, unsigned short snum,
 		     unsigned int hash2_nulladdr)
 {
-	struct udp_hslot *hslot, *hslot2;
 	struct udp_table *udptable = sk->sk_prot->h.udp_table;
-	int    error = 1;
+	struct udp_hslot *hslot, *hslot2;
 	struct net *net = sock_net(sk);
+	int error = 1;
 
 	if (!snum) {
+		DECLARE_BITMAP(bitmap, PORTS_PER_CHAIN);
+		unsigned short first, last;
 		int low, high, remaining;
 		unsigned int rand;
-		unsigned short first, last;
-		DECLARE_BITMAP(bitmap, PORTS_PER_CHAIN);
 
 		inet_get_local_port_range(net, &low, &high);
 		remaining = (high - low) + 1;
@@ -2519,10 +2519,13 @@ static struct sock *__udp4_lib_mcast_demux_lookup(struct net *net,
 						  __be16 rmt_port, __be32 rmt_addr,
 						  int dif, int sdif)
 {
-	struct sock *sk, *result;
 	unsigned short hnum = ntohs(loc_port);
-	unsigned int slot = udp_hashfn(net, hnum, udp_table.mask);
-	struct udp_hslot *hslot = &udp_table.hash[slot];
+	struct sock *sk, *result;
+	struct udp_hslot *hslot;
+	unsigned int slot;
+
+	slot = udp_hashfn(net, hnum, udp_table.mask);
+	hslot = &udp_table.hash[slot];
 
 	/* Do not bother scanning a too big list */
 	if (hslot->count > 10)
@@ -2550,14 +2553,18 @@ static struct sock *__udp4_lib_demux_lookup(struct net *net,
 					    __be16 rmt_port, __be32 rmt_addr,
 					    int dif, int sdif)
 {
-	unsigned short hnum = ntohs(loc_port);
-	unsigned int hash2 = ipv4_portaddr_hash(net, loc_addr, hnum);
-	unsigned int slot2 = hash2 & udp_table.mask;
-	struct udp_hslot *hslot2 = &udp_table.hash2[slot2];
 	INET_ADDR_COOKIE(acookie, rmt_addr, loc_addr);
-	const __portpair ports = INET_COMBINED_PORTS(rmt_port, hnum);
+	unsigned short hnum = ntohs(loc_port);
+	unsigned int hash2, slot2;
+	struct udp_hslot *hslot2;
+	__portpair ports;
 	struct sock *sk;
 
+	hash2 = ipv4_portaddr_hash(net, loc_addr, hnum);
+	slot2 = hash2 & udp_table.mask;
+	hslot2 = &udp_table.hash2[slot2];
+	ports = INET_COMBINED_PORTS(rmt_port, hnum);
+
 	udp_portaddr_for_each_entry_rcu(sk, &hslot2->head) {
 		if (inet_match(net, sk, acookie, ports, dif, sdif))
 			return sk;
@@ -2970,10 +2977,10 @@ EXPORT_SYMBOL(udp_prot);
 
 static struct sock *udp_get_first(struct seq_file *seq, int start)
 {
-	struct sock *sk;
-	struct udp_seq_afinfo *afinfo;
 	struct udp_iter_state *state = seq->private;
 	struct net *net = seq_file_net(seq);
+	struct udp_seq_afinfo *afinfo;
+	struct sock *sk;
 
 	if (state->bpf_seq_afinfo)
 		afinfo = state->bpf_seq_afinfo;
@@ -3004,9 +3011,9 @@ static struct sock *udp_get_first(struct seq_file *seq, int start)
 
 static struct sock *udp_get_next(struct seq_file *seq, struct sock *sk)
 {
-	struct udp_seq_afinfo *afinfo;
 	struct udp_iter_state *state = seq->private;
 	struct net *net = seq_file_net(seq);
+	struct udp_seq_afinfo *afinfo;
 
 	if (state->bpf_seq_afinfo)
 		afinfo = state->bpf_seq_afinfo;
@@ -3062,8 +3069,8 @@ EXPORT_SYMBOL(udp_seq_next);
 
 void udp_seq_stop(struct seq_file *seq, void *v)
 {
-	struct udp_seq_afinfo *afinfo;
 	struct udp_iter_state *state = seq->private;
+	struct udp_seq_afinfo *afinfo;
 
 	if (state->bpf_seq_afinfo)
 		afinfo = state->bpf_seq_afinfo;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index e2de3d906c82..727de67e4c90 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1064,12 +1064,16 @@ static struct sock *__udp6_lib_demux_lookup(struct net *net,
 			int dif, int sdif)
 {
 	unsigned short hnum = ntohs(loc_port);
-	unsigned int hash2 = ipv6_portaddr_hash(net, loc_addr, hnum);
-	unsigned int slot2 = hash2 & udp_table.mask;
-	struct udp_hslot *hslot2 = &udp_table.hash2[slot2];
-	const __portpair ports = INET_COMBINED_PORTS(rmt_port, hnum);
+	unsigned int hash2, slot2;
+	struct udp_hslot *hslot2;
+	__portpair ports;
 	struct sock *sk;
 
+	hash2 = ipv6_portaddr_hash(net, loc_addr, hnum);
+	slot2 = hash2 & udp_table.mask;
+	hslot2 = &udp_table.hash2[slot2];
+	ports = INET_COMBINED_PORTS(rmt_port, hnum);
+
 	udp_portaddr_for_each_entry_rcu(sk, &hslot2->head) {
 		if (sk->sk_state == TCP_ESTABLISHED &&
 		    inet6_match(net, sk, rmt_addr, loc_addr, ports, dif, sdif))
-- 
2.30.2

