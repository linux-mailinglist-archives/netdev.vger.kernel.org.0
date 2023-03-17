Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE746BED73
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbjCQP4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbjCQP4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:56:01 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9A5C9CBA
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:55:57 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54463468d06so50371867b3.7
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679068557;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wzAnHVfQK6IG+Vn1edY5oYX24EnB2xmyocSZNhH1d3Q=;
        b=hakLmSHKQ3DSF4rklv7ak50YyVzEypZmdHslVJsqwIiQQn7+sK1xAS2Rvdg30k+Fsm
         XPkhOSJBXKTiL0M+o3OpoUqq6mcrrUUmMW62wKzD1LR1XQz3cZd9FBh+kyZsvePIDSZB
         8a7MSCukGcRwLIo8gGvEtKNPDjdBuemyXXnUu8HRMtK6Ga8YaP1BIZvKsQ3GuSa35nDG
         VBgczyH+2+RW4hTo0KN/INNALwAvrotEihGbkyfuZvr6YenyQCd0wp+amFNyuq5hWuCD
         odTWIyT8F7YPDRCWgsQvp+lIHqpDYAreqZGTRGi4n6U8Jida1yQdmpLhZ5rrD49m6NFR
         i8cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679068557;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wzAnHVfQK6IG+Vn1edY5oYX24EnB2xmyocSZNhH1d3Q=;
        b=UMKjacytS6dD2284bWHdH2e5x8qRbcWhq8MCtZku0M9gZUdaSwBHNzJCN2lBki2zMa
         8fbckFeTy+hC9zVzbPkLK4Y67LtRPKJvAamLVM3tYpqGfVAUiZZRDOlmypDJVtOH2bRa
         BKB4uEGPh4MPlZ1rTQFzJ8/PKytA0fGzTMJOwpTnNz5qULfW69IteSnDOsA9wRzOOTrR
         CoIT6pDTWSdW1tM6WKNKhCTXwFO2cc4e4kB8wUI1mt4HuIDCF6u8znWTx+zJ5g2yY4Io
         qLSMswgSfsSMcoj7UP0KAv10LUtMV5LOTtmTxXg2dKKdBlqru59zHV3jPXB9XsdtGypb
         QE+w==
X-Gm-Message-State: AO0yUKUv7V01ewrRkpTkm8HFPT6P6AFny1taF8nEUNBpNSMJ7gKhxX1m
        4njQEmdGbaElbHGw5iAJgwraKH8OeOFMRQ==
X-Google-Smtp-Source: AK7set8twqSDMaWsJCeVYv8y44Ur3+YM4kAkkVa11SUPiYQ4kujXbBCsNDSl8lF1jRqKLi+jFqA4Vp7KmRXVlQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a5b:c0a:0:b0:b5c:f48:3083 with SMTP id
 f10-20020a5b0c0a000000b00b5c0f483083mr24611ybq.11.1679068557413; Fri, 17 Mar
 2023 08:55:57 -0700 (PDT)
Date:   Fri, 17 Mar 2023 15:55:39 +0000
In-Reply-To: <20230317155539.2552954-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230317155539.2552954-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230317155539.2552954-11-edumazet@google.com>
Subject: [PATCH net-next 10/10] tcp: preserve const qualifier in tcp_sk()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Willem de Bruijn <willemb@google.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can change tcp_sk() to propagate its argument const qualifier,
thanks to container_of_const().

We have two places where a const sock pointer has to be upgraded
to a write one. We have been using const qualifier for lockless
listeners to clearly identify points where writes could happen.

Add tcp_sk_rw() helper to better document these.

tcp_inbound_md5_hash(), __tcp_grow_window(), tcp_reset_check()
and tcp_rack_reo_wnd() get an additional const qualififer
for their @tp local variables.

smc_check_reset_syn_req() also needs a similar change.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/tcp.h      | 10 ++++++----
 include/net/tcp.h        |  2 +-
 net/ipv4/tcp.c           |  2 +-
 net/ipv4/tcp_input.c     |  4 ++--
 net/ipv4/tcp_minisocks.c |  5 +++--
 net/ipv4/tcp_output.c    |  9 +++++++--
 net/ipv4/tcp_recovery.c  |  2 +-
 7 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index ca7f05a130d2d14d530207adcc1cc50b7b830c80..b4c08ac86983568a9511258708724da15d0b999e 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -472,10 +472,12 @@ enum tsq_flags {
 	TCPF_MTU_REDUCED_DEFERRED	= (1UL << TCP_MTU_REDUCED_DEFERRED),
 };
 
-static inline struct tcp_sock *tcp_sk(const struct sock *sk)
-{
-	return (struct tcp_sock *)sk;
-}
+#define tcp_sk(ptr) container_of_const(ptr, struct tcp_sock, inet_conn.icsk_inet.sk)
+
+/* Variant of tcp_sk() upgrading a const sock to a read/write tcp socket.
+ * Used in context of (lockless) tcp listeners.
+ */
+#define tcp_sk_rw(ptr) container_of(ptr, struct tcp_sock, inet_conn.icsk_inet.sk)
 
 struct tcp_timewait_sock {
 	struct inet_timewait_sock tw_sk;
diff --git a/include/net/tcp.h b/include/net/tcp.h
index db9f828e9d1ee4546951a408935b6c5f90851a93..a0a91a988272710470cd20f22e02e49476513239 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -529,7 +529,7 @@ static inline void tcp_synq_overflow(const struct sock *sk)
 
 	last_overflow = READ_ONCE(tcp_sk(sk)->rx_opt.ts_recent_stamp);
 	if (!time_between32(now, last_overflow, last_overflow + HZ))
-		WRITE_ONCE(tcp_sk(sk)->rx_opt.ts_recent_stamp, now);
+		WRITE_ONCE(tcp_sk_rw(sk)->rx_opt.ts_recent_stamp, now);
 }
 
 /* syncookies: no recent synqueue overflow on this listening socket? */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 01569de651b65aa5641fb0c06e0fb81dc40cd85a..fd68d49490f2849a41397be5bf78dbf07cadd7ff 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4570,7 +4570,7 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 	const __u8 *hash_location = NULL;
 	struct tcp_md5sig_key *hash_expected;
 	const struct tcphdr *th = tcp_hdr(skb);
-	struct tcp_sock *tp = tcp_sk(sk);
+	const struct tcp_sock *tp = tcp_sk(sk);
 	int genhash, l3index;
 	u8 newhash[16];
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 754ddbe0577f139d209032b4f15787392fe9a1d5..2b75cd9e2e92ea1b6e8e16485a8792790a905ade 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -458,7 +458,7 @@ static void tcp_sndbuf_expand(struct sock *sk)
 static int __tcp_grow_window(const struct sock *sk, const struct sk_buff *skb,
 			     unsigned int skbtruesize)
 {
-	struct tcp_sock *tp = tcp_sk(sk);
+	const struct tcp_sock *tp = tcp_sk(sk);
 	/* Optimize this! */
 	int truesize = tcp_win_from_space(sk, skbtruesize) >> 1;
 	int window = tcp_win_from_space(sk, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2])) >> 1;
@@ -5693,7 +5693,7 @@ static void tcp_urg(struct sock *sk, struct sk_buff *skb, const struct tcphdr *t
  */
 static bool tcp_reset_check(const struct sock *sk, const struct sk_buff *skb)
 {
-	struct tcp_sock *tp = tcp_sk(sk);
+	const struct tcp_sock *tp = tcp_sk(sk);
 
 	return unlikely(TCP_SKB_CB(skb)->seq == (tp->rcv_nxt - 1) &&
 			(1 << sk->sk_state) & (TCPF_CLOSE_WAIT | TCPF_LAST_ACK |
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 9a7ef7732c24c94d4a01d5911ebe51f21371a457..dac0d62120e623ad3f206daa1785eddb39452fd6 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -463,7 +463,7 @@ void tcp_ca_openreq_child(struct sock *sk, const struct dst_entry *dst)
 }
 EXPORT_SYMBOL_GPL(tcp_ca_openreq_child);
 
-static void smc_check_reset_syn_req(struct tcp_sock *oldtp,
+static void smc_check_reset_syn_req(const struct tcp_sock *oldtp,
 				    struct request_sock *req,
 				    struct tcp_sock *newtp)
 {
@@ -492,7 +492,8 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
 	const struct inet_request_sock *ireq = inet_rsk(req);
 	struct tcp_request_sock *treq = tcp_rsk(req);
 	struct inet_connection_sock *newicsk;
-	struct tcp_sock *oldtp, *newtp;
+	const struct tcp_sock *oldtp;
+	struct tcp_sock *newtp;
 	u32 seq;
 
 	if (!newsk)
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index f7e00d90a7304cdbaee493d994c6ab1063392d34..b9e07f1951419c3a2858eea0c26f604b96f0be70 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -4127,8 +4127,13 @@ int tcp_rtx_synack(const struct sock *sk, struct request_sock *req)
 	if (!res) {
 		TCP_INC_STATS(sock_net(sk), TCP_MIB_RETRANSSEGS);
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNRETRANS);
-		if (unlikely(tcp_passive_fastopen(sk)))
-			tcp_sk(sk)->total_retrans++;
+		if (unlikely(tcp_passive_fastopen(sk))) {
+			/* sk has const attribute because listeners are lockless.
+			 * However in this case, we are dealing with a passive fastopen
+			 * socket thus we can change total_retrans value.
+			 */
+			tcp_sk_rw(sk)->total_retrans++;
+		}
 		trace_tcp_retransmit_synack(sk, req);
 	}
 	return res;
diff --git a/net/ipv4/tcp_recovery.c b/net/ipv4/tcp_recovery.c
index 50abaa941387d3e7328b6859ea5118937fc12be4..acf4869c5d3b568227aca71d95a765493e452a85 100644
--- a/net/ipv4/tcp_recovery.c
+++ b/net/ipv4/tcp_recovery.c
@@ -4,7 +4,7 @@
 
 static u32 tcp_rack_reo_wnd(const struct sock *sk)
 {
-	struct tcp_sock *tp = tcp_sk(sk);
+	const struct tcp_sock *tp = tcp_sk(sk);
 
 	if (!tp->reord_seen) {
 		/* If reordering has not been observed, be aggressive during
-- 
2.40.0.rc2.332.ga46443480c-goog

