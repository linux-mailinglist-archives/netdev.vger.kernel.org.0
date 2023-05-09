Return-Path: <netdev+bounces-1254-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C76006FCFA2
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 22:37:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D3BC280E97
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 20:37:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30D0119908;
	Tue,  9 May 2023 20:37:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1785B19900
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 20:37:12 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7528DA
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 13:36:59 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ba22ced2ee5so7376996276.3
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 13:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683664619; x=1686256619;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ht/t8CtgdeXH9DLsil8CKKhOJ9FHx38CotzNT5kvXSo=;
        b=wb2KnRIF/wLQYTYEV3znj8m5FJwRTc2ChgukVbi9amRbuLCGyTogn9VWKLbbs4RzWP
         mu8ToZ7GdrRVaf+1S4qcQ6EgAW6YjEQXSQ89KoNiwbrzonkjNC1bvnC2KXPc8DyXgw1p
         kGDGrq7XR/484EB0EvkjYhQ/ogTpEOE2WxV60ZO4ba+sWbZZ5pmfRz21CfMHXcAv8XyK
         OIbuw6EbeRU4qxtQH+Uc3KgdBFC+NI1jXc5ADTn3Ive9GwL+7/xzxxLbf0r+TRqkbOOb
         bv8svcgeWQ8idCJYvMNpbTAXgAo9TYh7gcJ4ouYvwCIKu5Vncp5Ht1U1RHrSi1fgewOA
         LH5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683664619; x=1686256619;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ht/t8CtgdeXH9DLsil8CKKhOJ9FHx38CotzNT5kvXSo=;
        b=S0wy4bzcZ8dSeTGKQ6uP4yrMU/SDc7QhpiP65iq5qt4srNAX76z5tSAtm/9gEjbMQg
         dsNkIQzvVpj5xuAVPgx928VuTDb+e8Hqf1km6MKcuH7vCwjI7U78H+iaxB3FupxaI41R
         kI2p+q2V3I9mH8uGfxgSqGfzi2cbh4T30W5bPWR63Uay0WG2vjc1HozKBq2bQ1GC7pjI
         Z7hvN8ZTMcQh7m6I4zWASCEwuOn/MWAqgQ5K0YqcgcP0pzoqgjRJYOLQsNX8oh0pdec0
         XQUNOO4WCXeUdE56+PKeLtDKVorFvvcdIBiqyf4Vfalu6ScVKRNvyF/6UkT3dnZDAbcz
         jKBQ==
X-Gm-Message-State: AC+VfDwGcJeNMyosrQVvcbuRKINUtCqLB5sMHQKu0ALOnXn9+LQQ/ib8
	+Z0ivH4P55+CaiOoBGD4T0xHejNpcX4d4Q==
X-Google-Smtp-Source: ACHHUZ6rP40Vwmgmq9Ym0O7BWDHuBumgD4DmY6l45YhE2h8ExcxLTy9NYkPuxqeQq/RUOqL7CdZjHGisQNsI1w==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:2283:0:b0:ba5:38b:fbbe with SMTP id
 i125-20020a252283000000b00ba5038bfbbemr2518262ybi.3.1683664618913; Tue, 09
 May 2023 13:36:58 -0700 (PDT)
Date: Tue,  9 May 2023 20:36:56 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.521.gf1e218fcd8-goog
Message-ID: <20230509203656.3864769-1-edumazet@google.com>
Subject: [PATCH net] tcp: add annotations around sk->sk_shutdown accesses
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

Now sk->sk_shutdown is no longer a bitfield, we can add
standard READ_ONCE()/WRITE_ONCE() annotations to silence
KCSAN reports like the following:

BUG: KCSAN: data-race in tcp_disconnect / tcp_poll

write to 0xffff88814588582c of 1 bytes by task 3404 on cpu 1:
tcp_disconnect+0x4d6/0xdb0 net/ipv4/tcp.c:3121
__inet_stream_connect+0x5dd/0x6e0 net/ipv4/af_inet.c:715
inet_stream_connect+0x48/0x70 net/ipv4/af_inet.c:727
__sys_connect_file net/socket.c:2001 [inline]
__sys_connect+0x19b/0x1b0 net/socket.c:2018
__do_sys_connect net/socket.c:2028 [inline]
__se_sys_connect net/socket.c:2025 [inline]
__x64_sys_connect+0x41/0x50 net/socket.c:2025
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

read to 0xffff88814588582c of 1 bytes by task 3374 on cpu 0:
tcp_poll+0x2e6/0x7d0 net/ipv4/tcp.c:562
sock_poll+0x253/0x270 net/socket.c:1383
vfs_poll include/linux/poll.h:88 [inline]
io_poll_check_events io_uring/poll.c:281 [inline]
io_poll_task_func+0x15a/0x820 io_uring/poll.c:333
handle_tw_list io_uring/io_uring.c:1184 [inline]
tctx_task_work+0x1fe/0x4d0 io_uring/io_uring.c:1246
task_work_run+0x123/0x160 kernel/task_work.c:179
get_signal+0xe64/0xff0 kernel/signal.c:2635
arch_do_signal_or_restart+0x89/0x2a0 arch/x86/kernel/signal.c:306
exit_to_user_mode_loop+0x6f/0xe0 kernel/entry/common.c:168
exit_to_user_mode_prepare+0x6c/0xb0 kernel/entry/common.c:204
__syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
syscall_exit_to_user_mode+0x26/0x140 kernel/entry/common.c:297
do_syscall_64+0x4d/0xc0 arch/x86/entry/common.c:86
entry_SYSCALL_64_after_hwframe+0x63/0xcd

value changed: 0x03 -> 0x00

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/af_inet.c   |  2 +-
 net/ipv4/tcp.c       | 14 ++++++++------
 net/ipv4/tcp_input.c |  4 ++--
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 940062e08f574fbfeed42f72fa8a4b5ce763110c..c4aab3aacbd89e35520583ab5e17b4e15e53b87e 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -894,7 +894,7 @@ int inet_shutdown(struct socket *sock, int how)
 		   EPOLLHUP, even on eg. unconnected UDP sockets -- RR */
 		fallthrough;
 	default:
-		sk->sk_shutdown |= how;
+		WRITE_ONCE(sk->sk_shutdown, sk->sk_shutdown | how);
 		if (sk->sk_prot->shutdown)
 			sk->sk_prot->shutdown(sk, how);
 		break;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 20db115c38c492c010733d5a0a3efbb7dbbea13e..4d6392c16b7a5a9a853c27e3a4b258d000738304 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -498,6 +498,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 	__poll_t mask;
 	struct sock *sk = sock->sk;
 	const struct tcp_sock *tp = tcp_sk(sk);
+	u8 shutdown;
 	int state;
 
 	sock_poll_wait(file, sock, wait);
@@ -540,9 +541,10 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 	 * NOTE. Check for TCP_CLOSE is added. The goal is to prevent
 	 * blocking on fresh not-connected or disconnected socket. --ANK
 	 */
-	if (sk->sk_shutdown == SHUTDOWN_MASK || state == TCP_CLOSE)
+	shutdown = READ_ONCE(sk->sk_shutdown);
+	if (shutdown == SHUTDOWN_MASK || state == TCP_CLOSE)
 		mask |= EPOLLHUP;
-	if (sk->sk_shutdown & RCV_SHUTDOWN)
+	if (shutdown & RCV_SHUTDOWN)
 		mask |= EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
 
 	/* Connected or passive Fast Open socket? */
@@ -559,7 +561,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 		if (tcp_stream_is_readable(sk, target))
 			mask |= EPOLLIN | EPOLLRDNORM;
 
-		if (!(sk->sk_shutdown & SEND_SHUTDOWN)) {
+		if (!(shutdown & SEND_SHUTDOWN)) {
 			if (__sk_stream_is_writeable(sk, 1)) {
 				mask |= EPOLLOUT | EPOLLWRNORM;
 			} else {  /* send SIGIO later */
@@ -2867,7 +2869,7 @@ void __tcp_close(struct sock *sk, long timeout)
 	int data_was_unread = 0;
 	int state;
 
-	sk->sk_shutdown = SHUTDOWN_MASK;
+	WRITE_ONCE(sk->sk_shutdown, SHUTDOWN_MASK);
 
 	if (sk->sk_state == TCP_LISTEN) {
 		tcp_set_state(sk, TCP_CLOSE);
@@ -3119,7 +3121,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 
 	inet_bhash2_reset_saddr(sk);
 
-	sk->sk_shutdown = 0;
+	WRITE_ONCE(sk->sk_shutdown, 0);
 	sock_reset_flag(sk, SOCK_DONE);
 	tp->srtt_us = 0;
 	tp->mdev_us = jiffies_to_usecs(TCP_TIMEOUT_INIT);
@@ -4649,7 +4651,7 @@ void tcp_done(struct sock *sk)
 	if (req)
 		reqsk_fastopen_remove(sk, req, false);
 
-	sk->sk_shutdown = SHUTDOWN_MASK;
+	WRITE_ONCE(sk->sk_shutdown, SHUTDOWN_MASK);
 
 	if (!sock_flag(sk, SOCK_DEAD))
 		sk->sk_state_change(sk);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index a057330d6f59d693cdf634dbd22f1243f8171f58..61b6710f337a3a5c24b3f399cc77a404b7e012f9 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4362,7 +4362,7 @@ void tcp_fin(struct sock *sk)
 
 	inet_csk_schedule_ack(sk);
 
-	sk->sk_shutdown |= RCV_SHUTDOWN;
+	WRITE_ONCE(sk->sk_shutdown, sk->sk_shutdown | RCV_SHUTDOWN);
 	sock_set_flag(sk, SOCK_DONE);
 
 	switch (sk->sk_state) {
@@ -6599,7 +6599,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			break;
 
 		tcp_set_state(sk, TCP_FIN_WAIT2);
-		sk->sk_shutdown |= SEND_SHUTDOWN;
+		WRITE_ONCE(sk->sk_shutdown, sk->sk_shutdown | SEND_SHUTDOWN);
 
 		sk_dst_confirm(sk);
 
-- 
2.40.1.521.gf1e218fcd8-goog


