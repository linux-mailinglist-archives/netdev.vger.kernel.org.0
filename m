Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABAC41A026
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 22:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237024AbhI0UcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 16:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235825AbhI0UcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 16:32:12 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F115C061575
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 13:30:34 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id v19so13309992pjh.2
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 13:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=llnw.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=8Crp/mKlKCJoRPApaEQ45TzUsLI1jNtTwgloDzwU01g=;
        b=e7oPQ1Ylx3GOzE20U/dqy20eGLCy7P0YfEmY2q6XbN/hntKEap2FrkGNmFg1Wvz/J4
         0nmu3O58HopA64lqwoiW0w8Fr37Sdx+rS3hfexCPDNkvTbji9UZdod6qHoiymgcL/N0a
         oBKx4EtdihuLlzC0PY18aBLyOpOQpj0N9xzHE9iBA0uHUqgGfZLpyGwIwAmyJd26WVkP
         34DSjNIVE7fL72IasRXrnX0vmHt9ncFQBOKbz8NBDI9UEdWvmFzgNf8/qEuwBbR7rTTy
         ANMUbjkO87pGn+3AkSIpGkdYmbbxFx4hiwzUwZVMeWkhZGd1tTv+DcZf65sBScvA306+
         SlZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8Crp/mKlKCJoRPApaEQ45TzUsLI1jNtTwgloDzwU01g=;
        b=q60kHx/RWNuA6BZ2dTH/HDQBEx608ce1KeyBUbJpMwULrPKFx0XlJavpDplRBz91NW
         bf/fNu8JfY9Jm35+GAXGJRJCsAiYEEVSE2GEG4ytsnjF7meVAtHUqDCaxlriYFvG8867
         7nuGN73xbWsYAvxyItcVSu75HDt4CRzRKQ80KYeqms3M6gjpf3zLauXIL40UUj4iAny/
         kayX9ozHSBeudMEs7wEGDUsZ2ex4Qnv0MgEkhl+o0bLppurs2NMJOU8i6v9kPZqrZo7c
         QhEXNvKUTqeLe98Y17IAQFRzFO9Fo5Etly0hY4uK5opZ9LPJkAW27MpIus43f582Y24X
         xTcg==
X-Gm-Message-State: AOAM531ZfWyaotcgiFdp7OUCObMvs8Uca1Cdw4Le2I8X4zQ6X5Yb3YY4
        Vi8ZFqRhqNHLhvfy3zMWr58CpgkcFiC3dkuioagOLA==
X-Google-Smtp-Source: ABdhPJyNv8DUPruJhQsC1rVx7VyNkixtCC1guW889HiNEC5gmzh+PdyHS61wNlr4T+TD1RdKgPH7yg==
X-Received: by 2002:a17:90a:19e:: with SMTP id 30mr1071056pjc.131.1632774633962;
        Mon, 27 Sep 2021 13:30:33 -0700 (PDT)
Received: from localhost.localdomain (wsip-184-181-13-226.ph.ph.cox.net. [184.181.13.226])
        by smtp.googlemail.com with ESMTPSA id q20sm18606748pfc.57.2021.09.27.13.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 13:30:33 -0700 (PDT)
From:   Johannes Lundberg <jlundberg@llnw.com>
To:     linux-kernel@vger.kernel.org
Cc:     Johannes Lundberg <jlundberg@llnw.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Alexander Aring <aahringo@redhat.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org
Subject: [PATCH] fs: eventpoll: add empty event
Date:   Mon, 27 Sep 2021 13:29:17 -0700
Message-Id: <20210927202923.7360-1-jlundberg@llnw.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The EPOLLEMPTY event will trigger when the TCP write buffer becomes
empty, i.e., when all outgoing data have been ACKed.

The need for this functionality comes from a business requirement
of measuring with higher precision how much time is spent
transmitting data to a client. For reference, similar functionality
was previously added to FreeBSD as the kqueue event EVFILT_EMPTY.

Signed-off-by: Johannes Lundberg <jlundberg@llnw.com>
---
 include/net/sock.h             | 11 +++++++++++
 include/uapi/linux/eventpoll.h |  1 +
 net/core/sock.c                |  5 +++++
 net/core/stream.c              | 14 ++++++++++++++
 net/ipv4/tcp.c                 |  5 +++++
 5 files changed, 36 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index c005c3c750e8..9047a9e225a9 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -516,6 +516,7 @@ struct sock {
 	void			(*sk_state_change)(struct sock *sk);
 	void			(*sk_data_ready)(struct sock *sk);
 	void			(*sk_write_space)(struct sock *sk);
+	void			(*sk_empty)(struct sock *sk);
 	void			(*sk_error_report)(struct sock *sk);
 	int			(*sk_backlog_rcv)(struct sock *sk,
 						  struct sk_buff *skb);
@@ -965,6 +966,7 @@ static inline void sk_wmem_queued_add(struct sock *sk, int val)
 	WRITE_ONCE(sk->sk_wmem_queued, sk->sk_wmem_queued + val);
 }
 
+void sk_stream_empty(struct sock *sk);
 void sk_stream_write_space(struct sock *sk);
 
 /* OOB backlog add */
@@ -1288,6 +1290,11 @@ static inline void sk_refcnt_debug_release(const struct sock *sk)
 
 INDIRECT_CALLABLE_DECLARE(bool tcp_stream_memory_free(const struct sock *sk, int wake));
 
+static inline bool sk_stream_is_empty(const struct sock *sk)
+{
+	return (sk->sk_wmem_queued == 0);
+}
+
 static inline bool __sk_stream_memory_free(const struct sock *sk, int wake)
 {
 	if (READ_ONCE(sk->sk_wmem_queued) >= READ_ONCE(sk->sk_sndbuf))
@@ -1559,6 +1566,10 @@ DECLARE_STATIC_KEY_FALSE(tcp_tx_skb_cache_key);
 static inline void sk_wmem_free_skb(struct sock *sk, struct sk_buff *skb)
 {
 	sk_wmem_queued_add(sk, -skb->truesize);
+
+	if (sk_stream_is_empty(sk))
+		sk->sk_empty(sk);
+
 	sk_mem_uncharge(sk, skb->truesize);
 	if (static_branch_unlikely(&tcp_tx_skb_cache_key) &&
 	    !sk->sk_tx_skb_cache && !skb_cloned(skb)) {
diff --git a/include/uapi/linux/eventpoll.h b/include/uapi/linux/eventpoll.h
index 8a3432d0f0dc..aab9f1f624d0 100644
--- a/include/uapi/linux/eventpoll.h
+++ b/include/uapi/linux/eventpoll.h
@@ -39,6 +39,7 @@
 #define EPOLLWRNORM	(__force __poll_t)0x00000100
 #define EPOLLWRBAND	(__force __poll_t)0x00000200
 #define EPOLLMSG	(__force __poll_t)0x00000400
+#define EPOLLEMPTY	(__force __poll_t)0x00000800
 #define EPOLLRDHUP	(__force __poll_t)0x00002000
 
 /* Set exclusive wakeup mode for the target file descriptor */
diff --git a/net/core/sock.c b/net/core/sock.c
index 512e629f9780..f917791d8149 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3062,6 +3062,10 @@ static void sock_def_write_space(struct sock *sk)
 	rcu_read_unlock();
 }
 
+static void sock_def_empty(struct sock *sk)
+{
+}
+
 static void sock_def_destruct(struct sock *sk)
 {
 }
@@ -3136,6 +3140,7 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 	sk->sk_state_change	=	sock_def_wakeup;
 	sk->sk_data_ready	=	sock_def_readable;
 	sk->sk_write_space	=	sock_def_write_space;
+	sk->sk_empty		=	sock_def_empty;
 	sk->sk_error_report	=	sock_def_error_report;
 	sk->sk_destruct		=	sock_def_destruct;
 
diff --git a/net/core/stream.c b/net/core/stream.c
index 4f1d4aa5fb38..c7e4135542a2 100644
--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -21,6 +21,20 @@
 #include <linux/wait.h>
 #include <net/sock.h>
 
+void sk_stream_empty(struct sock *sk)
+{
+	struct socket *sock = sk->sk_socket;
+	struct socket_wq *wq;
+
+	if (sk_stream_is_empty(sk) && sock) {
+		rcu_read_lock();
+		wq = rcu_dereference(sk->sk_wq);
+		if (skwq_has_sleeper(wq))
+			wake_up_interruptible_poll(&wq->wait, EPOLLEMPTY);
+		rcu_read_unlock();
+	}
+}
+
 /**
  * sk_stream_write_space - stream socket write_space callback.
  * @sk: socket
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e8b48df73c85..550bae79af06 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -453,6 +453,8 @@ void tcp_init_sock(struct sock *sk)
 	tp->tsoffset = 0;
 	tp->rack.reo_wnd_steps = 1;
 
+	sk->sk_empty = sk_stream_empty;
+
 	sk->sk_write_space = sk_stream_write_space;
 	sock_set_flag(sk, SOCK_USE_WRITE_QUEUE);
 
@@ -561,6 +563,9 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 		    tp->urg_data)
 			target++;
 
+		if (sk_stream_is_empty(sk))
+			mask |= EPOLLEMPTY;
+
 		if (tcp_stream_is_readable(sk, target))
 			mask |= EPOLLIN | EPOLLRDNORM;
 
-- 
2.17.1

