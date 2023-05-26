Return-Path: <netdev+bounces-5760-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C171712AB4
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 18:35:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55CD2281930
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:35:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74F2418B18;
	Fri, 26 May 2023 16:35:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B372CA6
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 16:35:02 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E25ED3
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:35:00 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5655d99da53so24475577b3.0
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685118900; x=1687710900;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YQlDtYQ5sUUT8K4Ue5C47SzDoYZv5zOw2Qw1H42Rdfg=;
        b=ln8dZMw22mdjEYl2Fg+ZZtzwJNJbgxKJ+zeMZ+lURUQZY9jdWqlhL1em/vnJ+A34yj
         DbMfaAfWIfmbGv0S719HUMov+nYs6iJFjXcjetRvHdFek2C5DXj/SjOC5PFyOwfpQby8
         TqXOqXWVVZRWWoYLf1+gQVRGepgSI3J/h/fZRzDTDYzs2PmUCgfylaeeKMMbozGUYRtu
         Q5LIGTXbdoOX0R/PBcLNwRdXeXA1bxYrpWlUR03lh5xx8SVablbbuINi4wieLBuvYosW
         XDpW1D2+++5gTjpZZcIRTF7uuoj4Yz0VPrVOUFYSv1EWbz1xVmhcdz3vY7A4WpkIhW0I
         NmSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685118900; x=1687710900;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YQlDtYQ5sUUT8K4Ue5C47SzDoYZv5zOw2Qw1H42Rdfg=;
        b=iIE+b4C2RS5E6SjtOKjaNCf7MQZK/a1rruRsxGnhbZJvBTWn2/NZpoktzZ7SQaE8zq
         11KtCQOKQLJDT0oKPKRTCqLz1HYfBoaAUDQTDVedzfs3axJb289VBMvwJu6Op7g0s0to
         JJmV5EhVQxvxBGYOYbhm7lmTWKBsTlfHUKU5RBiJKe4DRjIyUA31RG6FceufxFT82aSY
         V/Sx2ERh7sh0/zCv55BVSx4ZOrskeU3zkWp+XWQoEWhkSmwlri9WopC0MnywhPBc+OOT
         GCKQtFWs6Uapvfzl/YECrExsRmYQbSHurvthYVsCwYG2+DrKpcX2oQ1EHQ0cLkQBpXgn
         duaQ==
X-Gm-Message-State: AC+VfDxlvxaFcJSLUikZmccbVGheq+qqna2FySc8JpdoAVJGJ05SloCs
	uY3QeG3/3Vt5dS7Fagbmo0dI+ELfy6U4Pw==
X-Google-Smtp-Source: ACHHUZ5P/yETkoIol8Mrvr/RbxZ86fKE5YZSjyIWdyXPY9OAaziyVTXUK1YlDsrgXAaUpMBLzQFaIjdfDR6/dw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:690c:82c:b0:561:4723:2088 with SMTP
 id by12-20020a05690c082c00b0056147232088mr2327023ywb.4.1685118899860; Fri, 26
 May 2023 09:34:59 -0700 (PDT)
Date: Fri, 26 May 2023 16:34:58 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230526163458.2880232-1-edumazet@google.com>
Subject: [PATCH net] tcp: deny tcp_disconnect() when threads are waiting
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

Historically connect(AF_UNSPEC) has been abused by syzkaller
and other fuzzers to trigger various bugs.

A recent one triggers a divide-by-zero [1], and Paolo Abeni
was able to diagnose the issue.

tcp_recvmsg_locked() has tests about sk_state being not TCP_LISTEN
and TCP REPAIR mode being not used.

Then later if socket lock is released in sk_wait_data(),
another thread can call connect(AF_UNSPEC), then make this
socket a TCP listener.

When recvmsg() is resumed, it can eventually call tcp_cleanup_rbuf()
and attempt a divide by 0 in tcp_rcv_space_adjust() [1]

This patch adds a new socket field, counting number of threads
blocked in sk_wait_event() and inet_wait_for_connect().

If this counter is not zero, tcp_disconnect() returns an error.

This patch adds code in blocking socket system calls, thus should
not hurt performance of non blocking ones.

Note that we probably could revert commit 499350a5a6e7 ("tcp:
initialize rcv_mss to TCP_MIN_MSS instead of 0") to restore
original tcpi_rcv_mss meaning (was 0 if no payload was ever
received on a socket)

[1]
divide error: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 13832 Comm: syz-executor.5 Not tainted 6.3.0-rc4-syzkaller-00224-g00c7b5f4ddc5 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
RIP: 0010:tcp_rcv_space_adjust+0x36e/0x9d0 net/ipv4/tcp_input.c:740
Code: 00 00 00 00 fc ff df 4c 89 64 24 48 8b 44 24 04 44 89 f9 41 81 c7 80 03 00 00 c1 e1 04 44 29 f0 48 63 c9 48 01 e9 48 0f af c1 <49> f7 f6 48 8d 04 41 48 89 44 24 40 48 8b 44 24 30 48 c1 e8 03 48
RSP: 0018:ffffc900033af660 EFLAGS: 00010206
RAX: 4a66b76cbade2c48 RBX: ffff888076640cc0 RCX: 00000000c334e4ac
RDX: 0000000000000000 RSI: dffffc0000000000 RDI: 0000000000000001
RBP: 00000000c324e86c R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8880766417f8
R13: ffff888028fbb980 R14: 0000000000000000 R15: 0000000000010344
FS: 00007f5bffbfe700(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b32f25000 CR3: 000000007ced0000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
tcp_recvmsg_locked+0x100e/0x22e0 net/ipv4/tcp.c:2616
tcp_recvmsg+0x117/0x620 net/ipv4/tcp.c:2681
inet6_recvmsg+0x114/0x640 net/ipv6/af_inet6.c:670
sock_recvmsg_nosec net/socket.c:1017 [inline]
sock_recvmsg+0xe2/0x160 net/socket.c:1038
____sys_recvmsg+0x210/0x5a0 net/socket.c:2720
___sys_recvmsg+0xf2/0x180 net/socket.c:2762
do_recvmmsg+0x25e/0x6e0 net/socket.c:2856
__sys_recvmmsg net/socket.c:2935 [inline]
__do_sys_recvmmsg net/socket.c:2958 [inline]
__se_sys_recvmmsg net/socket.c:2951 [inline]
__x64_sys_recvmmsg+0x20f/0x260 net/socket.c:2951
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f5c0108c0f9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f5bffbfe168 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 00007f5c011ac050 RCX: 00007f5c0108c0f9
RDX: 0000000000000001 RSI: 0000000020000bc0 RDI: 0000000000000003
RBP: 00007f5c010e7b39 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000122 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5c012cfb1f R14: 00007f5bffbfe300 R15: 0000000000022000
</TASK>

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot <syzkaller@googlegroups.com>
Reported-by: Paolo Abeni <pabeni@redhat.com>
Diagnosed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h              | 4 ++++
 net/ipv4/af_inet.c              | 2 ++
 net/ipv4/inet_connection_sock.c | 1 +
 net/ipv4/tcp.c                  | 6 ++++++
 4 files changed, 13 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index 656ea89f60ff90d600d16f40302000db64057c64..b418425d7230c8cee81df34fcc66d771ea5085e9 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -336,6 +336,7 @@ struct sk_filter;
   *	@sk_cgrp_data: cgroup data for this cgroup
   *	@sk_memcg: this socket's memory cgroup association
   *	@sk_write_pending: a write to stream socket waits to start
+  *	@sk_wait_pending: number of threads blocked on this socket
   *	@sk_state_change: callback to indicate change in the state of the sock
   *	@sk_data_ready: callback to indicate there is data to be processed
   *	@sk_write_space: callback to indicate there is bf sending space available
@@ -428,6 +429,7 @@ struct sock {
 	unsigned int		sk_napi_id;
 #endif
 	int			sk_rcvbuf;
+	int			sk_wait_pending;
 
 	struct sk_filter __rcu	*sk_filter;
 	union {
@@ -1174,6 +1176,7 @@ static inline void sock_rps_reset_rxhash(struct sock *sk)
 
 #define sk_wait_event(__sk, __timeo, __condition, __wait)		\
 	({	int __rc;						\
+		__sk->sk_wait_pending++;				\
 		release_sock(__sk);					\
 		__rc = __condition;					\
 		if (!__rc) {						\
@@ -1183,6 +1186,7 @@ static inline void sock_rps_reset_rxhash(struct sock *sk)
 		}							\
 		sched_annotate_sleep();					\
 		lock_sock(__sk);					\
+		__sk->sk_wait_pending--;				\
 		__rc = __condition;					\
 		__rc;							\
 	})
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index c4aab3aacbd89e35520583ab5e17b4e15e53b87e..4a76ebf793b857f5e64d440870d3cca737d1dac2 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -586,6 +586,7 @@ static long inet_wait_for_connect(struct sock *sk, long timeo, int writebias)
 
 	add_wait_queue(sk_sleep(sk), &wait);
 	sk->sk_write_pending += writebias;
+	sk->sk_wait_pending++;
 
 	/* Basic assumption: if someone sets sk->sk_err, he _must_
 	 * change state of the socket from TCP_SYN_*.
@@ -601,6 +602,7 @@ static long inet_wait_for_connect(struct sock *sk, long timeo, int writebias)
 	}
 	remove_wait_queue(sk_sleep(sk), &wait);
 	sk->sk_write_pending -= writebias;
+	sk->sk_wait_pending--;
 	return timeo;
 }
 
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 65ad4251f6fd849c7aeb0d981dc337111fb246b0..1386787eaf1a53e2d1364f3782a68dd2206bde9d 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1142,6 +1142,7 @@ struct sock *inet_csk_clone_lock(const struct sock *sk,
 	if (newsk) {
 		struct inet_connection_sock *newicsk = inet_csk(newsk);
 
+		newsk->sk_wait_pending = 0;
 		inet_sk_set_state(newsk, TCP_SYN_RECV);
 		newicsk->icsk_bind_hash = NULL;
 		newicsk->icsk_bind2_hash = NULL;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index a60f6f4e7cd91f5d06a78b1ae2bf61218bc52ca5..635607ac37e4585a3f730bf93e80e6673733cd55 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3081,6 +3081,12 @@ int tcp_disconnect(struct sock *sk, int flags)
 	int old_state = sk->sk_state;
 	u32 seq;
 
+	/* Deny disconnect if other threads are blocked in sk_wait_event()
+	 * or inet_wait_for_connect().
+	 */
+	if (sk->sk_wait_pending)
+		return -EBUSY;
+
 	if (old_state != TCP_CLOSE)
 		tcp_set_state(sk, TCP_CLOSE);
 
-- 
2.41.0.rc0.172.g3f132b7071-goog


