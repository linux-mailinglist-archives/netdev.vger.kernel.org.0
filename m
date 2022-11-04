Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36F2161A083
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 20:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiKDTHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 15:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiKDTHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 15:07:02 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90BC4C24A
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 12:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1667588821; x=1699124821;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=at4wKoeXfLWMfxROO5FmxzGVLopflmcr6WZ9R0dJ4ks=;
  b=dVUJZYGwAREEdLPZEIRE9S8wgwE2HxEoRvWSk4yyk0KqQzsUyzR2pwY3
   3ISi13Dj129YsZlXTwmOvdTE/twbwOc/zdM6Q9rsYnn1YI6hrcVHsCnjD
   8wvhVwnwomXXwJSFv1u/Ed/WQCC8SpNFNI2i+yC3LlJ/PcJUhZpg6jYEd
   Y=;
X-IronPort-AV: E=Sophos;i="5.96,138,1665446400"; 
   d="scan'208";a="1070802835"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-b1c0e1d0.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 19:06:53 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-b1c0e1d0.us-west-2.amazon.com (Postfix) with ESMTPS id 49EB381DBC;
        Fri,  4 Nov 2022 19:06:53 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Fri, 4 Nov 2022 19:06:52 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.223) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Fri, 4 Nov 2022 19:06:50 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 1/6] udp: Clean up some functions.
Date:   Fri, 4 Nov 2022 12:06:07 -0700
Message-ID: <20221104190612.24206-2-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221104190612.24206-1-kuniyu@amazon.com>
References: <20221104190612.24206-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.223]
X-ClientProxiedBy: EX13D38UWB001.ant.amazon.com (10.43.161.10) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
index 89accc3c8bb3..adb8e64cf614 100644
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
@@ -2518,10 +2518,13 @@ static struct sock *__udp4_lib_mcast_demux_lookup(struct net *net,
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
@@ -2549,14 +2552,18 @@ static struct sock *__udp4_lib_demux_lookup(struct net *net,
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
@@ -2969,10 +2976,10 @@ EXPORT_SYMBOL(udp_prot);
 
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
@@ -3003,9 +3010,9 @@ static struct sock *udp_get_first(struct seq_file *seq, int start)
 
 static struct sock *udp_get_next(struct seq_file *seq, struct sock *sk)
 {
-	struct udp_seq_afinfo *afinfo;
 	struct udp_iter_state *state = seq->private;
 	struct net *net = seq_file_net(seq);
+	struct udp_seq_afinfo *afinfo;
 
 	if (state->bpf_seq_afinfo)
 		afinfo = state->bpf_seq_afinfo;
@@ -3061,8 +3068,8 @@ EXPORT_SYMBOL(udp_seq_next);
 
 void udp_seq_stop(struct seq_file *seq, void *v)
 {
-	struct udp_seq_afinfo *afinfo;
 	struct udp_iter_state *state = seq->private;
+	struct udp_seq_afinfo *afinfo;
 
 	if (state->bpf_seq_afinfo)
 		afinfo = state->bpf_seq_afinfo;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 10f45658dbf6..9452fb175f11 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1063,12 +1063,16 @@ static struct sock *__udp6_lib_demux_lookup(struct net *net,
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

