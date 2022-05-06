Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED9851DFBD
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 21:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389728AbiEFTsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 15:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388813AbiEFTsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 15:48:30 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9065B6A04A;
        Fri,  6 May 2022 12:44:46 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id y3so6776604qtn.8;
        Fri, 06 May 2022 12:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cXiQMICJP3bxY1/QE8ewT+olGQfAupwoldLomWdcXI4=;
        b=DHjktLcZ00A5m18JehZWYxviKPezFv0NNgEVI40vV2zf+mEVtMM2RFwlV4czW8Vbk5
         HkgwHVFU8WT4Bs34NRF+b8B5uH+UhfXGgl6JssfI+TtBce+3vRHsPoN7F6ufk8PgZKt1
         uKe0Pg1Z1MZ4Uem0T92rHGHx5jawDWJRgg9ZUbEPgL5JLeIjTrF9UA2Hc+XjlXzUv8gF
         e62Mqq0qWe1v7NbzaxeL4+4F5OUHFetNkhcwYnNf3m9Y56+NB9SHWiih8dVqJUupNTlN
         4etfLdHmu3aj0um/UPzYTJ0Ody6BFxYipuG7Q8qTxnK/IWmHHOiLFiRXMNx8UDUBZEaD
         YRgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cXiQMICJP3bxY1/QE8ewT+olGQfAupwoldLomWdcXI4=;
        b=Uv+/JTJuu4xdWDJhgR05draA0SuLqOCYXgAyNVGGFSm9ekR/kZRwfC0DdaL12kOI97
         GjtggZkn0K+4MDMwuJ7jJ6e6sKG4h577ctTMKo/67NvZhKUXQXhCzdgYkV5JlTFUj5lY
         7eJnrPsB2xCg15laskXZ4wDJyRew1qmd3jRK8NIzF72nPPlNRE/NllwEH22BaTvUiucn
         cQrpF6SAZbnctndPR5fJpc3I9rwpZyHKEm8ZQO8TVijfhAZRNHtnqoj7iPf8AAeBUgmP
         kER9XyO8pD7whew+aMgpAMs8PfO2SM2mGJtEqHuCPomp+5NUSpZVVNtoWlSZlu0JT9TF
         bajQ==
X-Gm-Message-State: AOAM533DtJWjlLKO+shoo5VEyQnjTmDGR3dXkc7cVbZsmQCwuUh6Yw1O
        fuzjadTBViCZ7n0DG7xkPA==
X-Google-Smtp-Source: ABdhPJwJuyS5vbPmqZSAtTzTUVPVw8K2A2rWFl+k295aS7kdAos3n2zR5GOzWDnlzxzqB4tIKG2ZQg==
X-Received: by 2002:a05:622a:1b8d:b0:2f2:f4a6:d9dd with SMTP id bp13-20020a05622a1b8d00b002f2f4a6d9ddmr4432083qtb.242.1651866285599;
        Fri, 06 May 2022 12:44:45 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-52-72-174-210.compute-1.amazonaws.com. [52.72.174.210])
        by smtp.gmail.com with ESMTPSA id bj32-20020a05620a192000b0069fc2a7e7a5sm2744121qkb.75.2022.05.06.12.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 12:44:45 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Peilin Ye <peilin.ye@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH RFC v1 net-next 1/4] net: Introduce Qdisc backpressure infrastructure
Date:   Fri,  6 May 2022 12:44:22 -0700
Message-Id: <f4090d129b685df72070f708294550fbc513f888.1651800598.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651800598.git.peilin.ye@bytedance.com>
References: <cover.1651800598.git.peilin.ye@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Peilin Ye <peilin.ye@bytedance.com>

Currently sockets (especially UDP ones) can drop a lot of traffic at TC
egress when rate limited by shaper Qdiscs like HTB.  Improve it by
implementing the following state machine for sockets (currently only
support UDP and TCP ones):

  ┌────────────────┐  [a]  ┌────────────────┐  [b]  ┌────────────────┐
  │ SK_UNTHROTTLED │─ ─ ─ >│  SK_OVERLIMIT  │─ ─ ─ >│  SK_THROTTLED  │
  └────────────────┘       └────────────────┘       └────────────────┘
           └─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ < ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─┘
                                   [c]

Take TBF as an example,

  [a] When TBF's inner Qdisc (e.g. bfifo) becomes full, TBF fails to
      enqueue an skb belonging to UNTHROTTLED socket A.  socket A is
      marked as OVERLIMIT, and added to TBF's "backpressure_list";

  [b] When TBF runs out of tokens, it marks all OVERLIMIT sockets
      (including A) on its backpressure_list as THROTTLED, and schedules
      a Qdisc watchdog timer to wait for more tokens;

  [c] After the timer expires, all THROTTLED sockets (including A) are
      removed from TBF's backpressure_list, and marked as UNTHROTTLED.

UDP and TCP sleep on THROTTLED sockets in sock_wait_for_wmem() and
sk_stream_wait_memory() respectively.  epoll() and friends should not
report EPOLL{OUT,WRNORM} for THROTTLED sockets.  When unthrottling in [c],
call ->sk_write_space() to wake up UDP and/or TCP waiters, and notify
SOCKWQ_ASYNC_NOSPACE subscribers.

For each device, backpressure_list operations are always serialized by
Qdisc root_lock.

When marking a socket as OVERLIMIT in [a], use a cmpxchg() to make sure
that multiple CPUs do not try to add this socket to different
backpressure_lists (on different devices) concurrently.

After removing a THROTTLED socket from backpressure_list in [c], use a
smp_store_release() to make sure changes have been committed to memory
before marking the socket as UNTHROTTLED.

Suggested-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 include/net/sch_generic.h | 43 +++++++++++++++++++++++++++++++++++++++
 include/net/sock.h        | 18 +++++++++++++++-
 net/core/dev.c            |  1 +
 net/core/sock.c           |  6 ++++--
 net/ipv4/tcp_ipv4.c       | 11 +++++++---
 net/sched/sch_generic.c   |  4 ++++
 6 files changed, 77 insertions(+), 6 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 9bab396c1f3b..5ddbe0b65cb6 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -19,6 +19,7 @@
 #include <net/gen_stats.h>
 #include <net/rtnetlink.h>
 #include <net/flow_offload.h>
+#include <net/sock.h>
 
 struct Qdisc_ops;
 struct qdisc_walker;
@@ -108,6 +109,7 @@ struct Qdisc {
 	struct gnet_stats_queue	__percpu *cpu_qstats;
 	int			pad;
 	refcount_t		refcnt;
+	struct list_head	backpressure_list;
 
 	/*
 	 * For performance sake on SMP, we put highly modified fields at the end
@@ -1221,6 +1223,47 @@ static inline int qdisc_drop_all(struct sk_buff *skb, struct Qdisc *sch,
 	return NET_XMIT_DROP;
 }
 
+static inline void qdisc_backpressure_overlimit(struct Qdisc *sch, struct sk_buff *skb)
+{
+	struct sock *sk = skb->sk;
+
+	if (!sk || !sk_fullsock(sk))
+		return;
+
+	if (cmpxchg(&sk->sk_backpressure_status, SK_UNTHROTTLED, SK_OVERLIMIT) == SK_UNTHROTTLED) {
+		sock_hold(sk);
+		list_add_tail(&sk->sk_backpressure_node, &sch->backpressure_list);
+	}
+}
+
+static inline void qdisc_backpressure_throttle(struct Qdisc *sch)
+{
+	struct list_head *pos;
+	struct sock *sk;
+
+	list_for_each(pos, &sch->backpressure_list) {
+		sk = list_entry(pos, struct sock, sk_backpressure_node);
+
+		WRITE_ONCE(sk->sk_backpressure_status, SK_THROTTLED);
+	}
+}
+
+static inline void qdisc_backpressure_unthrottle(struct Qdisc *sch)
+{
+	struct list_head *pos, *next;
+	struct sock *sk;
+
+	list_for_each_safe(pos, next, &sch->backpressure_list) {
+		sk = list_entry(pos, struct sock, sk_backpressure_node);
+
+		list_del_init(pos);
+		smp_store_release(&sk->sk_backpressure_status, SK_UNTHROTTLED);
+		sk->sk_write_space(sk);
+
+		sock_put(sk);
+	}
+}
+
 /* Length to Time (L2T) lookup in a qdisc_rate_table, to determine how
    long it will take to send a packet given its size.
  */
diff --git a/include/net/sock.h b/include/net/sock.h
index 73063c88a249..6ed2de43dc98 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -315,6 +315,8 @@ struct sk_filter;
   *	@sk_rcvtimeo: %SO_RCVTIMEO setting
   *	@sk_sndtimeo: %SO_SNDTIMEO setting
   *	@sk_txhash: computed flow hash for use on transmit
+  *	@sk_backpressure_status: Qdisc backpressure status
+  *	@sk_backpressure_node: linkage for Qdisc backpressure list
   *	@sk_txrehash: enable TX hash rethink
   *	@sk_filter: socket filtering instructions
   *	@sk_timer: sock cleanup timer
@@ -468,6 +470,8 @@ struct sock {
 	unsigned int		sk_gso_max_size;
 	gfp_t			sk_allocation;
 	__u32			sk_txhash;
+	u32			sk_backpressure_status; /* see enum sk_backpressure */
+	struct list_head	sk_backpressure_node;
 
 	/*
 	 * Because of non atomicity rules, all
@@ -548,6 +552,12 @@ enum sk_pacing {
 	SK_PACING_FQ		= 2,
 };
 
+enum sk_backpressure {
+	SK_UNTHROTTLED	= 0,
+	SK_OVERLIMIT	= 1,
+	SK_THROTTLED	= 2,
+};
+
 /* Pointer stored in sk_user_data might not be suitable for copying
  * when cloning the socket. For instance, it can point to a reference
  * counted object. sk_user_data bottom bit is set if pointer must not
@@ -2522,12 +2532,18 @@ static inline struct page_frag *sk_page_frag(struct sock *sk)
 
 bool sk_page_frag_refill(struct sock *sk, struct page_frag *pfrag);
 
+static inline bool sk_is_throttled(const struct sock *sk)
+{
+	return READ_ONCE(sk->sk_backpressure_status) == SK_THROTTLED;
+}
+
 /*
  *	Default write policy as shown to user space via poll/select/SIGIO
  */
 static inline bool sock_writeable(const struct sock *sk)
 {
-	return refcount_read(&sk->sk_wmem_alloc) < (READ_ONCE(sk->sk_sndbuf) >> 1);
+	return !sk_is_throttled(sk) &&
+	       refcount_read(&sk->sk_wmem_alloc) < (READ_ONCE(sk->sk_sndbuf) >> 1);
 }
 
 static inline gfp_t gfp_any(void)
diff --git a/net/core/dev.c b/net/core/dev.c
index c2d73595a7c3..7c3d136725b9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5013,6 +5013,7 @@ static __latent_entropy void net_tx_action(struct softirq_action *h)
 			if (!(q->flags & TCQ_F_NOLOCK)) {
 				root_lock = qdisc_lock(q);
 				spin_lock(root_lock);
+				qdisc_backpressure_unthrottle(q);
 			} else if (unlikely(test_bit(__QDISC_STATE_DEACTIVATED,
 						     &q->state))) {
 				/* There is a synchronize_net() between
diff --git a/net/core/sock.c b/net/core/sock.c
index be20a1af20e5..7ed9d2bd991f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2034,6 +2034,7 @@ struct sock *sk_alloc(struct net *net, int family, gfp_t priority,
 
 		sock_net_set(sk, net);
 		refcount_set(&sk->sk_wmem_alloc, 1);
+		INIT_LIST_HEAD(&sk->sk_backpressure_node);
 
 		mem_cgroup_sk_alloc(sk);
 		cgroup_sk_alloc(&sk->sk_cgrp_data);
@@ -2589,7 +2590,8 @@ static long sock_wait_for_wmem(struct sock *sk, long timeo)
 			break;
 		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
-		if (refcount_read(&sk->sk_wmem_alloc) < READ_ONCE(sk->sk_sndbuf))
+		if (!sk_is_throttled(sk) &&
+		    refcount_read(&sk->sk_wmem_alloc) < READ_ONCE(sk->sk_sndbuf))
 			break;
 		if (sk->sk_shutdown & SEND_SHUTDOWN)
 			break;
@@ -2624,7 +2626,7 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
 		if (sk->sk_shutdown & SEND_SHUTDOWN)
 			goto failure;
 
-		if (sk_wmem_alloc_get(sk) < READ_ONCE(sk->sk_sndbuf))
+		if (!sk_is_throttled(sk) && sk_wmem_alloc_get(sk) < READ_ONCE(sk->sk_sndbuf))
 			break;
 
 		sk_set_bit(SOCKWQ_ASYNC_NOSPACE, sk);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 918816ec5dd4..6e905995bfa2 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3006,9 +3006,14 @@ void tcp4_proc_exit(void)
  */
 bool tcp_stream_memory_free(const struct sock *sk, int wake)
 {
-	const struct tcp_sock *tp = tcp_sk(sk);
-	u32 notsent_bytes = READ_ONCE(tp->write_seq) -
-			    READ_ONCE(tp->snd_nxt);
+	const struct tcp_sock *tp;
+	u32 notsent_bytes;
+
+	if (sk_is_throttled(sk))
+		return false;
+
+	tp = tcp_sk(sk);
+	notsent_bytes = READ_ONCE(tp->write_seq) - READ_ONCE(tp->snd_nxt);
 
 	return (notsent_bytes << wake) < tcp_notsent_lowat(tp);
 }
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index dba0b3e24af5..9ab314b874a7 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -674,6 +674,7 @@ struct Qdisc noop_qdisc = {
 		.qlen = 0,
 		.lock = __SPIN_LOCK_UNLOCKED(noop_qdisc.skb_bad_txq.lock),
 	},
+	.backpressure_list =	LIST_HEAD_INIT(noop_qdisc.backpressure_list),
 };
 EXPORT_SYMBOL(noop_qdisc);
 
@@ -947,6 +948,7 @@ struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
 	qdisc_skb_head_init(&sch->q);
 	gnet_stats_basic_sync_init(&sch->bstats);
 	spin_lock_init(&sch->q.lock);
+	INIT_LIST_HEAD(&sch->backpressure_list);
 
 	if (ops->static_flags & TCQ_F_CPUSTATS) {
 		sch->cpu_bstats =
@@ -1025,6 +1027,8 @@ void qdisc_reset(struct Qdisc *qdisc)
 	if (ops->reset)
 		ops->reset(qdisc);
 
+	qdisc_backpressure_unthrottle(qdisc);
+
 	__skb_queue_purge(&qdisc->gso_skb);
 	__skb_queue_purge(&qdisc->skb_bad_txq);
 
-- 
2.20.1

