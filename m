Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6FAC5443DC
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 08:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239026AbiFIGel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 02:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239019AbiFIGef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 02:34:35 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66EB39B8A
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 23:34:27 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id v11-20020a17090a4ecb00b001e2c5b837ccso25829741pjl.3
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 23:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=33tdRE/1/Zw7WdIazFpVj3yQuE9jkTZYCHdzZhOXJcs=;
        b=fkkK83E5ugE6pPmDPxjKafb9ijLJryzgUiIKaZgIqGApmwRGToEeMy9X1tYqiBY4Sj
         z/1F4gYJOFO8hv341bVaFKKPYFXfxRAjHXTHn2XAxn2yO+aEZrn3F/C3uqpYNFec8keB
         nkrSDyab2qQmjtxJCpiILZvGnPqj/YIu9dF99ge4B/xlYcgZQnP4mSicsugolDCFiBLq
         zHEqaO9SbM2o6VsBmreLTY90gBvUcjaXNF+BDgmwFzFpiFTzljAhUuntxTpojfW6I64O
         xhcFCe2Rqxr228yoWwRDTwBum7dazuoYwOOXFBcS9a5ikD67N7IfxuYOCBu/tnrrzWMt
         sawA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=33tdRE/1/Zw7WdIazFpVj3yQuE9jkTZYCHdzZhOXJcs=;
        b=0Mihhu4G/6k1W5bLhDfrtIKjwaNRNgUM38N+S4/Ab4g171eTiASFtiyBNPt5dT5YaH
         8ZZlZ6uGzYoVZzKUgMvs4lHU5ZVwH2MX6WPPqLn2L4J2HVpRusuNcXw6uKpkQerNDZN2
         jntT6noNpW6LWyT8kj892q28I3igW5T2fK4TOiVuYdiIoP4tyi2LGJgSAk+4aJ3wMeRl
         ywRzaNmvYxjPruTkmn0GGxS3xzc8RXFF3V4iQGnxKyyKsPJPeHoi0OeVOaMeR+M/rVBm
         ILh3AraLHGdlC5aG/W8P2r+WwwpYG7jamCm1tQhi7OY/nCLiLiU3GkjTyGyk+Gom89N1
         C7JA==
X-Gm-Message-State: AOAM532/p3pIp73a86pHh5Zrko1e2nyCQzjrnARhyimAMSRMcuIqniU1
        zCCWMbpZ5SlpV39VsoJX8yM=
X-Google-Smtp-Source: ABdhPJwoWgOyubbQ+wx20Ua4W85jICqQg1g9XtUElDd7E75vlgAPWp8TMNXS4qx4GAYjl0dZ1H6hyQ==
X-Received: by 2002:a17:902:ecca:b0:166:3e34:4d01 with SMTP id a10-20020a170902ecca00b001663e344d01mr36813281plh.97.1654756467165;
        Wed, 08 Jun 2022 23:34:27 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f579:a14f:f943:9d9a])
        by smtp.gmail.com with ESMTPSA id 199-20020a6215d0000000b0051b9c0af43dsm16340050pfv.155.2022.06.08.23.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 23:34:26 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 6/7] net: keep sk->sk_forward_alloc as small as possible
Date:   Wed,  8 Jun 2022 23:34:11 -0700
Message-Id: <20220609063412.2205738-7-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220609063412.2205738-1-eric.dumazet@gmail.com>
References: <20220609063412.2205738-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Currently, tcp_memory_allocated can hit tcp_mem[] limits quite fast.

Each TCP socket can forward allocate up to 2 MB of memory, even after
flow became less active.

10,000 sockets can have reserved 20 GB of memory,
and we have no shrinker in place to reclaim that.

Instead of trying to reclaim the extra allocations in some places,
just keep sk->sk_forward_alloc values as small as possible.

This should not impact performance too much now we have per-cpu
reserves: Changes to tcp_memory_allocated should not be too frequent.

For sockets not using SO_RESERVE_MEM:
 - idle sockets (no packets in tx/rx queues) have zero forward alloc.
 - non idle sockets have a forward alloc smaller than one page.

Note:

 - Removal of SK_RECLAIM_CHUNK and SK_RECLAIM_THRESHOLD
   is left to MPTCP maintainers as a follow up.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h           | 29 ++---------------------------
 net/core/datagram.c          |  3 ---
 net/ipv4/tcp.c               |  7 -------
 net/ipv4/tcp_input.c         |  4 ----
 net/ipv4/tcp_timer.c         | 19 ++++---------------
 net/iucv/af_iucv.c           |  2 --
 net/mptcp/protocol.c         |  2 +-
 net/sctp/sm_statefuns.c      |  2 --
 net/sctp/socket.c            |  5 -----
 net/sctp/stream_interleave.c |  2 --
 net/sctp/ulpqueue.c          |  4 ----
 11 files changed, 7 insertions(+), 72 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index cf288f7e9019106dfb466be707d34dacf33b339c..0063e8410a4e3ed91aef9cf34eb1127f7ce33b93 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1627,19 +1627,6 @@ static inline void sk_mem_reclaim_final(struct sock *sk)
 	sk_mem_reclaim(sk);
 }
 
-static inline void sk_mem_reclaim_partial(struct sock *sk)
-{
-	int reclaimable;
-
-	if (!sk_has_account(sk))
-		return;
-
-	reclaimable = sk->sk_forward_alloc - sk_unused_reserved_mem(sk);
-
-	if (reclaimable > (int)PAGE_SIZE)
-		__sk_mem_reclaim(sk, reclaimable - 1);
-}
-
 static inline void sk_mem_charge(struct sock *sk, int size)
 {
 	if (!sk_has_account(sk))
@@ -1647,29 +1634,17 @@ static inline void sk_mem_charge(struct sock *sk, int size)
 	sk->sk_forward_alloc -= size;
 }
 
-/* the following macros control memory reclaiming in sk_mem_uncharge()
+/* the following macros control memory reclaiming in mptcp_rmem_uncharge()
  */
 #define SK_RECLAIM_THRESHOLD	(1 << 21)
 #define SK_RECLAIM_CHUNK	(1 << 20)
 
 static inline void sk_mem_uncharge(struct sock *sk, int size)
 {
-	int reclaimable;
-
 	if (!sk_has_account(sk))
 		return;
 	sk->sk_forward_alloc += size;
-	reclaimable = sk->sk_forward_alloc - sk_unused_reserved_mem(sk);
-
-	/* Avoid a possible overflow.
-	 * TCP send queues can make this happen, if sk_mem_reclaim()
-	 * is not called and more than 2 GBytes are released at once.
-	 *
-	 * If we reach 2 MBytes, reclaim 1 MBytes right now, there is
-	 * no need to hold that much forward allocation anyway.
-	 */
-	if (unlikely(reclaimable >= SK_RECLAIM_THRESHOLD))
-		__sk_mem_reclaim(sk, SK_RECLAIM_CHUNK);
+	sk_mem_reclaim(sk);
 }
 
 /*
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 50f4faeea76cc9b7ac48f7814c3badf1251421a5..35791f86bd1a0b96352dab5657ebb730db4ada2c 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -320,7 +320,6 @@ EXPORT_SYMBOL(skb_recv_datagram);
 void skb_free_datagram(struct sock *sk, struct sk_buff *skb)
 {
 	consume_skb(skb);
-	sk_mem_reclaim_partial(sk);
 }
 EXPORT_SYMBOL(skb_free_datagram);
 
@@ -336,7 +335,6 @@ void __skb_free_datagram_locked(struct sock *sk, struct sk_buff *skb, int len)
 	slow = lock_sock_fast(sk);
 	sk_peek_offset_bwd(sk, len);
 	skb_orphan(skb);
-	sk_mem_reclaim_partial(sk);
 	unlock_sock_fast(sk, slow);
 
 	/* skb is now orphaned, can be freed outside of locked section */
@@ -396,7 +394,6 @@ int skb_kill_datagram(struct sock *sk, struct sk_buff *skb, unsigned int flags)
 				      NULL);
 
 	kfree_skb(skb);
-	sk_mem_reclaim_partial(sk);
 	return err;
 }
 EXPORT_SYMBOL(skb_kill_datagram);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e6bdf8e2c09a156c45eae9490419b93b35f6e191..14ebb4ec4a51f3c55501aa53423ce897599e8637 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -858,9 +858,6 @@ struct sk_buff *tcp_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
 {
 	struct sk_buff *skb;
 
-	if (unlikely(tcp_under_memory_pressure(sk)))
-		sk_mem_reclaim_partial(sk);
-
 	skb = alloc_skb_fclone(size + MAX_TCP_HEADER, gfp);
 	if (likely(skb)) {
 		bool mem_scheduled;
@@ -2764,8 +2761,6 @@ void __tcp_close(struct sock *sk, long timeout)
 		__kfree_skb(skb);
 	}
 
-	sk_mem_reclaim(sk);
-
 	/* If socket has been already reset (e.g. in tcp_reset()) - kill it. */
 	if (sk->sk_state == TCP_CLOSE)
 		goto adjudge_to_death;
@@ -2873,7 +2868,6 @@ void __tcp_close(struct sock *sk, long timeout)
 		}
 	}
 	if (sk->sk_state != TCP_CLOSE) {
-		sk_mem_reclaim(sk);
 		if (tcp_check_oom(sk, 0)) {
 			tcp_set_state(sk, TCP_CLOSE);
 			tcp_send_active_reset(sk, GFP_ATOMIC);
@@ -2951,7 +2945,6 @@ void tcp_write_queue_purge(struct sock *sk)
 	}
 	tcp_rtx_queue_purge(sk);
 	INIT_LIST_HEAD(&tcp_sk(sk)->tsorted_sent_queue);
-	sk_mem_reclaim(sk);
 	tcp_clear_all_retrans_hints(tcp_sk(sk));
 	tcp_sk(sk)->packets_out = 0;
 	inet_csk(sk)->icsk_backoff = 0;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 3fb117022558a408a664ea7c8fe2303296247ead..fdc7beb81b684560ed9e66b24464d870fdd6650e 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -805,7 +805,6 @@ static void tcp_event_data_recv(struct sock *sk, struct sk_buff *skb)
 			 * restart window, so that we send ACKs quickly.
 			 */
 			tcp_incr_quickack(sk, TCP_MAX_QUICKACKS);
-			sk_mem_reclaim(sk);
 		}
 	}
 	icsk->icsk_ack.lrcvtime = now;
@@ -4390,7 +4389,6 @@ void tcp_fin(struct sock *sk)
 	skb_rbtree_purge(&tp->out_of_order_queue);
 	if (tcp_is_sack(tp))
 		tcp_sack_reset(&tp->rx_opt);
-	sk_mem_reclaim(sk);
 
 	if (!sock_flag(sk, SOCK_DEAD)) {
 		sk->sk_state_change(sk);
@@ -5336,7 +5334,6 @@ static bool tcp_prune_ofo_queue(struct sock *sk)
 		tcp_drop_reason(sk, rb_to_skb(node),
 				SKB_DROP_REASON_TCP_OFO_QUEUE_PRUNE);
 		if (!prev || goal <= 0) {
-			sk_mem_reclaim(sk);
 			if (atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf &&
 			    !tcp_under_memory_pressure(sk))
 				break;
@@ -5383,7 +5380,6 @@ static int tcp_prune_queue(struct sock *sk)
 			     skb_peek(&sk->sk_receive_queue),
 			     NULL,
 			     tp->copied_seq, tp->rcv_nxt);
-	sk_mem_reclaim(sk);
 
 	if (atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf)
 		return 0;
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 20cf4a98c69d85d07c884d7bc8316191ff962bd8..2208755e8efc6e6847459aa222cd576aadc0f387 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -290,15 +290,13 @@ void tcp_delack_timer_handler(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 
-	sk_mem_reclaim_partial(sk);
-
 	if (((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)) ||
 	    !(icsk->icsk_ack.pending & ICSK_ACK_TIMER))
-		goto out;
+		return;
 
 	if (time_after(icsk->icsk_ack.timeout, jiffies)) {
 		sk_reset_timer(sk, &icsk->icsk_delack_timer, icsk->icsk_ack.timeout);
-		goto out;
+		return;
 	}
 	icsk->icsk_ack.pending &= ~ICSK_ACK_TIMER;
 
@@ -317,10 +315,6 @@ void tcp_delack_timer_handler(struct sock *sk)
 		tcp_send_ack(sk);
 		__NET_INC_STATS(sock_net(sk), LINUX_MIB_DELAYEDACKS);
 	}
-
-out:
-	if (tcp_under_memory_pressure(sk))
-		sk_mem_reclaim(sk);
 }
 
 
@@ -600,11 +594,11 @@ void tcp_write_timer_handler(struct sock *sk)
 
 	if (((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)) ||
 	    !icsk->icsk_pending)
-		goto out;
+		return;
 
 	if (time_after(icsk->icsk_timeout, jiffies)) {
 		sk_reset_timer(sk, &icsk->icsk_retransmit_timer, icsk->icsk_timeout);
-		goto out;
+		return;
 	}
 
 	tcp_mstamp_refresh(tcp_sk(sk));
@@ -626,9 +620,6 @@ void tcp_write_timer_handler(struct sock *sk)
 		tcp_probe_timer(sk);
 		break;
 	}
-
-out:
-	sk_mem_reclaim(sk);
 }
 
 static void tcp_write_timer(struct timer_list *t)
@@ -743,8 +734,6 @@ static void tcp_keepalive_timer (struct timer_list *t)
 		elapsed = keepalive_time_when(tp) - elapsed;
 	}
 
-	sk_mem_reclaim(sk);
-
 resched:
 	inet_csk_reset_keepalive_timer (sk, elapsed);
 	goto out;
diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index a0385ddbffcfc775b74768d5a889fcf7cbec1ee8..498a0c35b7bb20c9eae5aa8e5fee78170c08e831 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -278,8 +278,6 @@ static void iucv_sock_destruct(struct sock *sk)
 	skb_queue_purge(&sk->sk_receive_queue);
 	skb_queue_purge(&sk->sk_error_queue);
 
-	sk_mem_reclaim(sk);
-
 	if (!sock_flag(sk, SOCK_DEAD)) {
 		pr_err("Attempt to release alive iucv socket %p\n", sk);
 		return;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 9563124ac8af9f9f45b16f23d5d77f17dd83d0c5..e0fb9f96c45c81e70f8f72dd1df7c49ff3150370 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -975,7 +975,7 @@ static void __mptcp_mem_reclaim_partial(struct sock *sk)
 	if (reclaimable > (int)PAGE_SIZE)
 		__mptcp_rmem_reclaim(sk, reclaimable - 1);
 
-	sk_mem_reclaim_partial(sk);
+	sk_mem_reclaim(sk);
 }
 
 static void mptcp_mem_reclaim_partial(struct sock *sk)
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 52edee1322fc36b0400569f8e6de2133adf6cd74..f6ee7f4040c14ef087ab8faca4552a2f9c505e9a 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -6590,8 +6590,6 @@ static int sctp_eat_data(const struct sctp_association *asoc,
 			pr_debug("%s: under pressure, reneging for tsn:%u\n",
 				 __func__, tsn);
 			deliver = SCTP_CMD_RENEGE;
-		} else {
-			sk_mem_reclaim(sk);
 		}
 	}
 
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 05174acd981a8c304300b7a39b366d758d6fbafa..171f1a35d205225cdec9dbc6d0a07f446ce92996 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1824,9 +1824,6 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 	if (sctp_wspace(asoc) < (int)msg_len)
 		sctp_prsctp_prune(asoc, sinfo, msg_len - sctp_wspace(asoc));
 
-	if (sk_under_memory_pressure(sk))
-		sk_mem_reclaim(sk);
-
 	if (sctp_wspace(asoc) <= 0 || !sk_wmem_schedule(sk, msg_len)) {
 		timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 		err = sctp_wait_for_sndbuf(asoc, &timeo, msg_len);
@@ -9195,8 +9192,6 @@ static int sctp_wait_for_sndbuf(struct sctp_association *asoc, long *timeo_p,
 			goto do_error;
 		if (signal_pending(current))
 			goto do_interrupted;
-		if (sk_under_memory_pressure(sk))
-			sk_mem_reclaim(sk);
 		if ((int)msg_len <= sctp_wspace(asoc) &&
 		    sk_wmem_schedule(sk, msg_len))
 			break;
diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index 6b13f737ebf2e437114ea1fae6157aab7b1a6fb8..bb22b71df7a34202748faf93e8b4a4a08ab312ca 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -979,8 +979,6 @@ static void sctp_renege_events(struct sctp_ulpq *ulpq, struct sctp_chunk *chunk,
 
 	if (freed >= needed && sctp_ulpevent_idata(ulpq, chunk, gfp) <= 0)
 		sctp_intl_start_pd(ulpq, gfp);
-
-	sk_mem_reclaim(asoc->base.sk);
 }
 
 static void sctp_intl_stream_abort_pd(struct sctp_ulpq *ulpq, __u16 sid,
diff --git a/net/sctp/ulpqueue.c b/net/sctp/ulpqueue.c
index 407fed46931b9f1a7f07f3d1657b24eb2a39a147..0a8510a0c5e69789f8911cacd59aeb9c4b5ae20d 100644
--- a/net/sctp/ulpqueue.c
+++ b/net/sctp/ulpqueue.c
@@ -1100,12 +1100,8 @@ void sctp_ulpq_renege(struct sctp_ulpq *ulpq, struct sctp_chunk *chunk,
 		else if (retval == 1)
 			sctp_ulpq_reasm_drain(ulpq);
 	}
-
-	sk_mem_reclaim(asoc->base.sk);
 }
 
-
-
 /* Notify the application if an association is aborted and in
  * partial delivery mode.  Send up any pending received messages.
  */
-- 
2.36.1.255.ge46751e96f-goog

