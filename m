Return-Path: <netdev+bounces-1242-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BFED6FCDD0
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 20:29:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 30D0D1C20C23
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 18:29:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F26B719523;
	Tue,  9 May 2023 18:29:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D972AF9FB
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 18:29:53 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7A155A1
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 11:29:50 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-55a2648c164so104208057b3.2
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 11:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683656990; x=1686248990;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oSOTjgE0U4IHov6TWFATA3AwpEor+a3HwW72xrp0hMw=;
        b=qL6DUGq71nUEM4omSNLhJ7Q7Oo5Sf0ChAklHh+sdSsRi8e5TD0i7Igckx/CTj4uCQQ
         +imTVUHCSSq2Y52PMyJobBsEJmSkJsx40gun65NsVnfr2yrwddgfu/LtbioGfsYLxjLJ
         ghsVy45R8uTyNy6SIoksfC56Jx6KuRNmpe/cOTdBWBFWk0rIfn2xYDCKRohikqiBeTYp
         oB4YUbv44hwmNqSCPH5i8yy+hQ29FnO4WzfvuEAaA88oBRliaPwv8T9za3OlYBfmbKyE
         ORjvLhgzY0avgPGl641twYuu4TGkKVVomebvssCOixhj52gk0KsyMBlxsKHYJmTpX5GX
         tDxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683656990; x=1686248990;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oSOTjgE0U4IHov6TWFATA3AwpEor+a3HwW72xrp0hMw=;
        b=LTUR1i1lUtfLnZYqTZZ4wxYbm0ULdDtFw1cTHjSBNB2iZbde7FFIYu8nBJpL4Ifkwj
         w73+eI7r2/iEhfEYY5uaeJJl/jAKYb8Xgs15QCombmdEMFM5LvheeSD+4bMqTqC6SeLC
         aBtWVbE3NnzJuqGr5FJY/yVeSQeyY/6TBBE3N+6po1J2pHgXnUGEX8NxAg/DSP38G1kp
         oz94EYaR1DDSOqJynxPoMhxcWmvJRb2idhejqhcVXX8YAhSdBX+aoI6hHtu1BvvQboPq
         imcl9wU3F4MKb4JtMIFTddrRUYqSv8tNjj1ip02XezEfRmSbEpgdzOgjnk62mzHM6pZh
         Ulmw==
X-Gm-Message-State: AC+VfDxw71c5Vmo8ehMSFhl2/CAdC8u8BM0ucqIkiCANcKjBd3ADVIxI
	ETB/SJBrpZibUWHA7ALkSPkg0jFHKtlDSw==
X-Google-Smtp-Source: ACHHUZ5oiEKDEqZcmelNtgxhyZnT4K7rFakW0hGzkte9XxeHKG8BTLgUQBLKd7JwXhirypUHUk6LU6vnyHKv0w==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:451e:0:b0:55d:9678:114c with SMTP id
 s30-20020a81451e000000b0055d9678114cmr8916297ywa.9.1683656990058; Tue, 09 May
 2023 11:29:50 -0700 (PDT)
Date: Tue,  9 May 2023 18:29:48 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.521.gf1e218fcd8-goog
Message-ID: <20230509182948.3793097-1-edumazet@google.com>
Subject: [PATCH net] net: deal with most data-races in sk_wait_event()
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>, syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

__condition is evaluated twice in sk_wait_event() macro.

First invocation is lockless, and reads can race with writes,
as spotted by syzbot.

BUG: KCSAN: data-race in sk_stream_wait_connect / tcp_disconnect

write to 0xffff88812d83d6a0 of 4 bytes by task 9065 on cpu 1:
tcp_disconnect+0x2cd/0xdb0
inet_shutdown+0x19e/0x1f0 net/ipv4/af_inet.c:911
__sys_shutdown_sock net/socket.c:2343 [inline]
__sys_shutdown net/socket.c:2355 [inline]
__do_sys_shutdown net/socket.c:2363 [inline]
__se_sys_shutdown+0xf8/0x140 net/socket.c:2361
__x64_sys_shutdown+0x31/0x40 net/socket.c:2361
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

read to 0xffff88812d83d6a0 of 4 bytes by task 9040 on cpu 0:
sk_stream_wait_connect+0x1de/0x3a0 net/core/stream.c:75
tcp_sendmsg_locked+0x2e4/0x2120 net/ipv4/tcp.c:1266
tcp_sendmsg+0x30/0x50 net/ipv4/tcp.c:1484
inet6_sendmsg+0x63/0x80 net/ipv6/af_inet6.c:651
sock_sendmsg_nosec net/socket.c:724 [inline]
sock_sendmsg net/socket.c:747 [inline]
__sys_sendto+0x246/0x300 net/socket.c:2142
__do_sys_sendto net/socket.c:2154 [inline]
__se_sys_sendto net/socket.c:2150 [inline]
__x64_sys_sendto+0x78/0x90 net/socket.c:2150
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

value changed: 0x00000000 -> 0x00000068

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/stream.c   | 12 ++++++------
 net/ipv4/tcp_bpf.c  |  2 +-
 net/llc/af_llc.c    |  8 +++++---
 net/smc/smc_close.c |  4 ++--
 net/smc/smc_rx.c    |  4 ++--
 net/smc/smc_tx.c    |  4 ++--
 net/tipc/socket.c   |  4 ++--
 net/tls/tls_main.c  |  3 ++-
 8 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/net/core/stream.c b/net/core/stream.c
index 434446ab14c578b2d4c4c0ff8467c7129f7c66d8..f5c4e47df16505571d575ff367b31d9ef6998bd6 100644
--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -73,8 +73,8 @@ int sk_stream_wait_connect(struct sock *sk, long *timeo_p)
 		add_wait_queue(sk_sleep(sk), &wait);
 		sk->sk_write_pending++;
 		done = sk_wait_event(sk, timeo_p,
-				     !sk->sk_err &&
-				     !((1 << sk->sk_state) &
+				     !READ_ONCE(sk->sk_err) &&
+				     !((1 << READ_ONCE(sk->sk_state)) &
 				       ~(TCPF_ESTABLISHED | TCPF_CLOSE_WAIT)), &wait);
 		remove_wait_queue(sk_sleep(sk), &wait);
 		sk->sk_write_pending--;
@@ -87,9 +87,9 @@ EXPORT_SYMBOL(sk_stream_wait_connect);
  * sk_stream_closing - Return 1 if we still have things to send in our buffers.
  * @sk: socket to verify
  */
-static inline int sk_stream_closing(struct sock *sk)
+static int sk_stream_closing(const struct sock *sk)
 {
-	return (1 << sk->sk_state) &
+	return (1 << READ_ONCE(sk->sk_state)) &
 	       (TCPF_FIN_WAIT1 | TCPF_CLOSING | TCPF_LAST_ACK);
 }
 
@@ -142,8 +142,8 @@ int sk_stream_wait_memory(struct sock *sk, long *timeo_p)
 
 		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 		sk->sk_write_pending++;
-		sk_wait_event(sk, &current_timeo, sk->sk_err ||
-						  (sk->sk_shutdown & SEND_SHUTDOWN) ||
+		sk_wait_event(sk, &current_timeo, READ_ONCE(sk->sk_err) ||
+						  (READ_ONCE(sk->sk_shutdown) & SEND_SHUTDOWN) ||
 						  (sk_stream_memory_free(sk) &&
 						  !vm_wait), &wait);
 		sk->sk_write_pending--;
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index ebf91751193706ccec1bb9cfac48be28b5e28337..2e9547467edbecbae7a8e01ab780de37064f6df3 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -168,7 +168,7 @@ static int tcp_msg_wait_data(struct sock *sk, struct sk_psock *psock,
 	sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
 	ret = sk_wait_event(sk, &timeo,
 			    !list_empty(&psock->ingress_msg) ||
-			    !skb_queue_empty(&sk->sk_receive_queue), &wait);
+			    !skb_queue_empty_lockless(&sk->sk_receive_queue), &wait);
 	sk_clear_bit(SOCKWQ_ASYNC_WAITDATA, sk);
 	remove_wait_queue(sk_sleep(sk), &wait);
 	return ret;
diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index da7fe94bea2eb8b6d1fe84bfdb8d1fa7cf5f6879..9ffbc667be6cf4c13d2f731e003510efeed8ee29 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -583,7 +583,8 @@ static int llc_ui_wait_for_disc(struct sock *sk, long timeout)
 
 	add_wait_queue(sk_sleep(sk), &wait);
 	while (1) {
-		if (sk_wait_event(sk, &timeout, sk->sk_state == TCP_CLOSE, &wait))
+		if (sk_wait_event(sk, &timeout,
+				  READ_ONCE(sk->sk_state) == TCP_CLOSE, &wait))
 			break;
 		rc = -ERESTARTSYS;
 		if (signal_pending(current))
@@ -603,7 +604,8 @@ static bool llc_ui_wait_for_conn(struct sock *sk, long timeout)
 
 	add_wait_queue(sk_sleep(sk), &wait);
 	while (1) {
-		if (sk_wait_event(sk, &timeout, sk->sk_state != TCP_SYN_SENT, &wait))
+		if (sk_wait_event(sk, &timeout,
+				  READ_ONCE(sk->sk_state) != TCP_SYN_SENT, &wait))
 			break;
 		if (signal_pending(current) || !timeout)
 			break;
@@ -622,7 +624,7 @@ static int llc_ui_wait_for_busy_core(struct sock *sk, long timeout)
 	while (1) {
 		rc = 0;
 		if (sk_wait_event(sk, &timeout,
-				  (sk->sk_shutdown & RCV_SHUTDOWN) ||
+				  (READ_ONCE(sk->sk_shutdown) & RCV_SHUTDOWN) ||
 				  (!llc_data_accept_state(llc->state) &&
 				   !llc->remote_busy_flag &&
 				   !llc->p_flag), &wait))
diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index 31db7438857c9f81fd336bfce74c5c92b7d275c6..dbdf03e8aa5b55f29d71e9f7c28169cac358740f 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -67,8 +67,8 @@ static void smc_close_stream_wait(struct smc_sock *smc, long timeout)
 
 		rc = sk_wait_event(sk, &timeout,
 				   !smc_tx_prepared_sends(&smc->conn) ||
-				   sk->sk_err == ECONNABORTED ||
-				   sk->sk_err == ECONNRESET ||
+				   READ_ONCE(sk->sk_err) == ECONNABORTED ||
+				   READ_ONCE(sk->sk_err) == ECONNRESET ||
 				   smc->conn.killed,
 				   &wait);
 		if (rc)
diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
index 4380d32f5a5f96205d486dea4ff763435bc2e95d..9a2f3638d161d2ff7d7261835a5b13be63b11701 100644
--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -267,9 +267,9 @@ int smc_rx_wait(struct smc_sock *smc, long *timeo,
 	sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
 	add_wait_queue(sk_sleep(sk), &wait);
 	rc = sk_wait_event(sk, timeo,
-			   sk->sk_err ||
+			   READ_ONCE(sk->sk_err) ||
 			   cflags->peer_conn_abort ||
-			   sk->sk_shutdown & RCV_SHUTDOWN ||
+			   READ_ONCE(sk->sk_shutdown) & RCV_SHUTDOWN ||
 			   conn->killed ||
 			   fcrit(conn),
 			   &wait);
diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index f4b6a71ac488a40e1a36abe4562017fff7e98739..45128443f1f10ff8bea1dc65214c1db3beefc135 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -113,8 +113,8 @@ static int smc_tx_wait(struct smc_sock *smc, int flags)
 			break; /* at least 1 byte of free & no urgent data */
 		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 		sk_wait_event(sk, &timeo,
-			      sk->sk_err ||
-			      (sk->sk_shutdown & SEND_SHUTDOWN) ||
+			      READ_ONCE(sk->sk_err) ||
+			      (READ_ONCE(sk->sk_shutdown) & SEND_SHUTDOWN) ||
 			      smc_cdc_rxed_any_close(conn) ||
 			      (atomic_read(&conn->sndbuf_space) &&
 			       !conn->urg_tx_pend),
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 37edfe10f8c6ffea553a54b24b9513bd2e18d694..dd73d71c02a99df7acd7ce3fb0d4a96d1778171d 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -314,9 +314,9 @@ static void tsk_rej_rx_queue(struct sock *sk, int error)
 		tipc_sk_respond(sk, skb, error);
 }
 
-static bool tipc_sk_connected(struct sock *sk)
+static bool tipc_sk_connected(const struct sock *sk)
 {
-	return sk->sk_state == TIPC_ESTABLISHED;
+	return READ_ONCE(sk->sk_state) == TIPC_ESTABLISHED;
 }
 
 /* tipc_sk_type_connectionless - check if the socket is datagram socket
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index b32c112984dd9567fd9d07cc6850f234c1914a43..f2e7302a4d96b9f7ddd4ddf9afb6cac5672886e6 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -111,7 +111,8 @@ int wait_on_pending_writer(struct sock *sk, long *timeo)
 			break;
 		}
 
-		if (sk_wait_event(sk, timeo, !sk->sk_write_pending, &wait))
+		if (sk_wait_event(sk, timeo,
+				  !READ_ONCE(sk->sk_write_pending), &wait))
 			break;
 	}
 	remove_wait_queue(sk_sleep(sk), &wait);
-- 
2.40.1.521.gf1e218fcd8-goog


