Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73DD359BC79
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 11:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234223AbiHVJNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 05:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbiHVJM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 05:12:58 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D722F3B2;
        Mon, 22 Aug 2022 02:12:28 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id f14so7403260qkm.0;
        Mon, 22 Aug 2022 02:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=2fvahmCP6fgUtz12efKvT8cnv75am6qomqsw7veYScQ=;
        b=mMs2NjduS9kOkRBmMgKAFlTQ5qatTuHz5LQx1NkaCUQGz/XgemW0hYV5lA3SFMwgES
         HPpqxrMn5cNaLzRCQM2nqLDdfSsbsCSxYz0QCveGhNDJ2DpBz04iW804/FVYsN2Zbht9
         oYLvi5fRSlaH4qCYP8sWBsazvaD/UKKSphL4z2Q6zvx0aOiFzetTjblzpq6MOGCqWsaP
         yEHIdo7ouJVUsdTzZQAIvQEwe4FqHW4bsAg4wTJocXzvBJUyGdPXkPUt1masggoQvtd9
         KTHqlGhfhnKkUpiRWDqruZgWds60wfY7bZtvJmVA3Bh4h5fSn5rVzu/l7aCfV0Za7Bnq
         z1Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=2fvahmCP6fgUtz12efKvT8cnv75am6qomqsw7veYScQ=;
        b=YPeMz6VNIxmFzHNKg6E1TVvYW+oeCP6hjmr4ImSCml7SpUrvHHhbL+1t267X5x/mes
         gQ8ru4IZAHpqhgOV3ou5Dk3CbmolLUcUTWk9+/bvyrHJq10Kn4Cv727NBeP7nfeY7CiV
         IqCWC3M4Irf+KKFdHQ3W8bLg8oKfVkyXY5V1g5XCxhvAQ7dWpAQ3Ea3Wp6rh6h/7uF1f
         7lJwhk9qREVKWfVqS5nESpklHTx0rEEp52cL2/yZuF1WIptosAnoYYKGUdJ/x8iyT38T
         ZqvOX9jSuyLnm/Fth1FT620lqZHlEmg4cw9qTCYtKXaLAC4HtuoZX6M8GxSaZ57DOQ6T
         MS2Q==
X-Gm-Message-State: ACgBeo1q6fOsZRifnGKYWM1h66/Mg6OPISHcuGY3Cj3ZwNXQWSTunL2+
        wIU2P7NT3PvjZnqTv+ifMQ==
X-Google-Smtp-Source: AA6agR681qZn+OY8hYP0CYPx47lPT7P4ZTU+4P04yniRccFURb5nJ5zEwMPCLCaIuqXtSxRmYAkPEA==
X-Received: by 2002:a05:620a:4104:b0:6bb:61ce:73a3 with SMTP id j4-20020a05620a410400b006bb61ce73a3mr11715102qko.250.1661159547437;
        Mon, 22 Aug 2022 02:12:27 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-52-52-7-82.us-west-1.compute.amazonaws.com. [52.52.7.82])
        by smtp.gmail.com with ESMTPSA id c23-20020a05620a269700b006b893d135basm10388282qkp.86.2022.08.22.02.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 02:12:27 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Peilin Ye <peilin.ye@bytedance.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Dave Taht <dave.taht@gmail.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH RFC v2 net-next 2/5] net/udp: Implement Qdisc backpressure algorithm
Date:   Mon, 22 Aug 2022 02:12:20 -0700
Message-Id: <881f3d5bf87bdf4c19a0bd0ae0bf51fbeca7978d.1661158173.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1661158173.git.peilin.ye@bytedance.com>
References: <cover.1661158173.git.peilin.ye@bytedance.com>
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

From: Peilin Ye <peilin.ye@bytedance.com>

Support Qdisc backpressure for UDP (IPv4 and IPv6) sockets by
implementing the (*backpressure) callback:

  1. When a shaper Qdisc drops a packet due to TC egress congestion,
     halve the effective send buffer [1], then (re)scedule the
     backpressure timer.

  [1] sndbuf - overlimits_new == 1/2 * (sndbuf - overlimits_old)

  2. When the timer expires, double the effective send buffer [2].  If
     the socket is still overlimit, reschedule the timer itself.

  [2] sndbuf - overlimits_new == 2 * (sndbuf - overlimits_old)

In sock_wait_for_wmem() and sock_alloc_send_pskb(), check the size of
effective send buffer instead, so that overlimit sockets send slower.
See sk_sndbuf_avail().

The timer interval is specified by a new per-net sysctl,
sysctl_udp_backpressure_interval.  Default is 100 milliseconds, meaning
that an overlimit UDP socket will try to double its effective send
buffer every 100 milliseconds.  Use 0 to disable Qdisc backpressure for
UDP sockets.

Generally, longer interval means lower packet drop rate, but also makes
overlimit sockets slower to recover when TC egress becomes idle (or the
shaper Qdisc gets removed, etc.)

Test results with TBF + SFQ Qdiscs, 500 Mbits/sec rate limit with 16
iperf UDP '-b 1G' clients:

  Interval       Throughput  Drop Rate  CPU Usage [3]
   0 (disabled)  480.0 Mb/s     96.50%     68.38%
   10   ms       486.4 Mb/s      9.28%      1.30%
   100  ms       486.4 Mb/s      1.10%      1.11%
   1000 ms       486.4 Mb/s      0.13%      0.81%

  [3] perf-top, __pv_queued_spin_lock_slowpath()

Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 Documentation/networking/ip-sysctl.rst | 11 ++++
 include/linux/udp.h                    |  3 ++
 include/net/netns/ipv4.h               |  1 +
 include/net/udp.h                      |  1 +
 net/core/sock.c                        |  4 +-
 net/ipv4/sysctl_net_ipv4.c             |  7 +++
 net/ipv4/udp.c                         | 69 +++++++++++++++++++++++++-
 net/ipv6/udp.c                         |  2 +-
 8 files changed, 94 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 56cd4ea059b2..a0d8e9518fda 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1070,6 +1070,17 @@ udp_rmem_min - INTEGER
 udp_wmem_min - INTEGER
 	UDP does not have tx memory accounting and this tunable has no effect.
 
+udp_backpressure_interval - INTEGER
+	The time interval (in milliseconds) in which an overlimit UDP socket
+	tries to increase its effective send buffer size, used by Qdisc
+	backpressure.  A longer interval typically results in a lower packet
+	drop rate, but also makes it slower for overlimit UDP sockets to
+	recover from backpressure when TC egress becomes idle.
+
+	0 to disable Qdisc backpressure for UDP sockets.
+
+	Default: 100
+
 RAW variables
 =============
 
diff --git a/include/linux/udp.h b/include/linux/udp.h
index 254a2654400f..dd017994738b 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -86,6 +86,9 @@ struct udp_sock {
 
 	/* This field is dirtied by udp_recvmsg() */
 	int		forward_deficit;
+
+	/* Qdisc backpressure timer */
+	struct timer_list	backpressure_timer;
 };
 
 #define UDP_MAX_SEGMENTS	(1 << 6UL)
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index c7320ef356d9..01f72ddf23e0 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -182,6 +182,7 @@ struct netns_ipv4 {
 
 	int sysctl_udp_wmem_min;
 	int sysctl_udp_rmem_min;
+	int sysctl_udp_backpressure_interval;
 
 	u8 sysctl_fib_notify_on_flag_change;
 
diff --git a/include/net/udp.h b/include/net/udp.h
index 5ee88ddf79c3..82018e58659b 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -279,6 +279,7 @@ int udp_init_sock(struct sock *sk);
 int udp_pre_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len);
 int __udp_disconnect(struct sock *sk, int flags);
 int udp_disconnect(struct sock *sk, int flags);
+void udp_backpressure(struct sock *sk);
 __poll_t udp_poll(struct file *file, struct socket *sock, poll_table *wait);
 struct sk_buff *skb_udp_tunnel_segment(struct sk_buff *skb,
 				       netdev_features_t features,
diff --git a/net/core/sock.c b/net/core/sock.c
index 167d471b176f..cb6ba66f80c8 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2614,7 +2614,7 @@ static long sock_wait_for_wmem(struct sock *sk, long timeo)
 			break;
 		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
-		if (refcount_read(&sk->sk_wmem_alloc) < READ_ONCE(sk->sk_sndbuf))
+		if (refcount_read(&sk->sk_wmem_alloc) < sk_sndbuf_avail(sk))
 			break;
 		if (sk->sk_shutdown & SEND_SHUTDOWN)
 			break;
@@ -2649,7 +2649,7 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
 		if (sk->sk_shutdown & SEND_SHUTDOWN)
 			goto failure;
 
-		if (sk_wmem_alloc_get(sk) < READ_ONCE(sk->sk_sndbuf))
+		if (sk_wmem_alloc_get(sk) < sk_sndbuf_avail(sk))
 			break;
 
 		sk_set_bit(SOCKWQ_ASYNC_NOSPACE, sk);
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 5490c285668b..1e509a417b92 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -1337,6 +1337,13 @@ static struct ctl_table ipv4_net_table[] = {
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ONE
 	},
+	{
+		.procname	= "udp_backpressure_interval",
+		.data		= &init_net.ipv4.sysctl_udp_backpressure_interval,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_ms_jiffies,
+	},
 	{
 		.procname	= "fib_notify_on_flag_change",
 		.data		= &init_net.ipv4.sysctl_fib_notify_on_flag_change,
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 34eda973bbf1..ff58f638c834 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -110,6 +110,7 @@
 #include <trace/events/skb.h>
 #include <net/busy_poll.h>
 #include "udp_impl.h"
+#include <net/sock.h>
 #include <net/sock_reuseport.h>
 #include <net/addrconf.h>
 #include <net/udp_tunnel.h>
@@ -1614,10 +1615,73 @@ void udp_destruct_sock(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(udp_destruct_sock);
 
+static inline int udp_backpressure_interval_get(struct sock *sk)
+{
+	return READ_ONCE(sock_net(sk)->ipv4.sysctl_udp_backpressure_interval);
+}
+
+static inline void udp_reset_backpressure_timer(struct sock *sk,
+						unsigned long expires)
+{
+	sk_reset_timer(sk, &udp_sk(sk)->backpressure_timer, expires);
+}
+
+static void udp_backpressure_timer(struct timer_list *t)
+{
+	struct udp_sock *up = from_timer(up, t, backpressure_timer);
+	int interval, sndbuf, overlimits;
+	struct sock *sk = &up->inet.sk;
+
+	interval = udp_backpressure_interval_get(sk);
+	if (!interval) {
+		/* Qdisc backpressure has been turned off */
+		WRITE_ONCE(sk->sk_overlimits, 0);
+		goto out;
+	}
+
+	sndbuf = READ_ONCE(sk->sk_sndbuf);
+	overlimits = READ_ONCE(sk->sk_overlimits);
+
+	/* sndbuf - overlimits_new == 2 * (sndbuf - overlimits_old) */
+	overlimits = min_t(int, overlimits, sndbuf - SOCK_MIN_SNDBUF);
+	overlimits = max_t(int, (2 * overlimits) - sndbuf, 0);
+	WRITE_ONCE(sk->sk_overlimits, overlimits);
+
+	if (overlimits > 0)
+		udp_reset_backpressure_timer(sk, jiffies + interval);
+
+out:
+	sock_put(sk);
+}
+
+void udp_backpressure(struct sock *sk)
+{
+	int interval, sndbuf, overlimits;
+
+	interval = udp_backpressure_interval_get(sk);
+	if (!interval)	/* Qdisc backpressure is off */
+		return;
+
+	sndbuf = READ_ONCE(sk->sk_sndbuf);
+	overlimits = READ_ONCE(sk->sk_overlimits);
+
+	/* sndbuf - overlimits_new == 1/2 * (sndbuf - overlimits_old) */
+	overlimits = min_t(int, overlimits, sndbuf - SOCK_MIN_SNDBUF);
+	overlimits += (sndbuf - overlimits) >> 1;
+	WRITE_ONCE(sk->sk_overlimits, overlimits);
+
+	if (overlimits > 0)
+		udp_reset_backpressure_timer(sk, jiffies + interval);
+}
+EXPORT_SYMBOL_GPL(udp_backpressure);
+
 int udp_init_sock(struct sock *sk)
 {
-	skb_queue_head_init(&udp_sk(sk)->reader_queue);
+	struct udp_sock *up = udp_sk(sk);
+
+	skb_queue_head_init(&up->reader_queue);
 	sk->sk_destruct = udp_destruct_sock;
+	timer_setup(&up->backpressure_timer, udp_backpressure_timer, 0);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(udp_init_sock);
@@ -2653,6 +2717,7 @@ void udp_destroy_sock(struct sock *sk)
 	/* protects from races with udp_abort() */
 	sock_set_flag(sk, SOCK_DEAD);
 	udp_flush_pending_frames(sk);
+	sk_stop_timer(sk, &up->backpressure_timer);
 	unlock_sock_fast(sk, slow);
 	if (static_branch_unlikely(&udp_encap_needed_key)) {
 		if (up->encap_type) {
@@ -2946,6 +3011,7 @@ struct proto udp_prot = {
 #ifdef CONFIG_BPF_SYSCALL
 	.psock_update_sk_prot	= udp_bpf_update_proto,
 #endif
+	.backpressure		= udp_backpressure,
 	.memory_allocated	= &udp_memory_allocated,
 	.per_cpu_fw_alloc	= &udp_memory_per_cpu_fw_alloc,
 
@@ -3268,6 +3334,7 @@ static int __net_init udp_sysctl_init(struct net *net)
 {
 	net->ipv4.sysctl_udp_rmem_min = PAGE_SIZE;
 	net->ipv4.sysctl_udp_wmem_min = PAGE_SIZE;
+	net->ipv4.sysctl_udp_backpressure_interval = msecs_to_jiffies(100);
 
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	net->ipv4.sysctl_udp_l3mdev_accept = 0;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 16c176e7c69a..106032af6756 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1735,7 +1735,7 @@ struct proto udpv6_prot = {
 #ifdef CONFIG_BPF_SYSCALL
 	.psock_update_sk_prot	= udp_bpf_update_proto,
 #endif
-
+	.backpressure		= udp_backpressure,
 	.memory_allocated	= &udp_memory_allocated,
 	.per_cpu_fw_alloc	= &udp_memory_per_cpu_fw_alloc,
 
-- 
2.20.1

