Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73DCE58886D
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 10:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235199AbiHCID4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 04:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiHCIDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 04:03:55 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CA813E06;
        Wed,  3 Aug 2022 01:03:54 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id h21-20020a17090aa89500b001f31a61b91dso1203239pjq.4;
        Wed, 03 Aug 2022 01:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=RwvyogrdBi+y8HfLgDtU4bktAJ8/XfTU9q1x/3DRwCU=;
        b=c0YeISaCd+S1jZos5qQf/JlbMQefnTgWDCgM1xQxcVb9HekW3Jgk7V8Cffy2urjJvx
         jEx6u2vqEPMVTLzRh6QZVxVEPlWsM/XylyBW8GlQAFS4g5jYOI7ess7rnG/6qUHokIDW
         40QK2HBfhFtNpbAp/YKjetK5EQypDxhvCzDgKHcLpAyL65//QPNZDXaK7Jvy366FQVAp
         oSRTl3RmI3LrDuVD1KPeqTLWchS/Fy+rKi/ObB2GdUHzyDuQ4E3d0dj6XjhpjMOXY6su
         wBSx+ycqJK695SyK1xf05PjRP6QQITgufa6U97zkufSgpDFqQyUv4bZw6DZ/vBfGbAGY
         axbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=RwvyogrdBi+y8HfLgDtU4bktAJ8/XfTU9q1x/3DRwCU=;
        b=zAfhxR5YgeziegFvlSqp2NmIz/eFYvI5qclA9Bcq3GOZYKp7rwSt8PJ0e+ROnmq5mD
         NMI3Ys4XJFXz03z7H7lpDAH0YWssxZeIjbR5mGpT3kXVPiqA+EdkJk2I6VU49zq+iWwR
         VXxrsZsBwoltNJtCx6VQ4mgfftDLHJH1dHhB/4druGbtRekDUtdolXXz7QP8PwNBtzK4
         y9SWAi4nEjBO+YfsazLpT/FHqIxA06ZZCdlUJpfB7JhPdfu3CLw0xFHZDPf0UTfwyecu
         tGNWa/MYlEehr2OwJQAMuligIB1rjotHJmPkerUEPVDlnas0MUL5cjij/pi1Ud9PgwVh
         +F6w==
X-Gm-Message-State: ACgBeo078xxj673pNA4nKJSf3L0+T2j1LdtsHtOOjeUCq5ywqm9iFlwJ
        TkgGaxw2b0EgTr1g76q1lJ4=
X-Google-Smtp-Source: AA6agR76/zwYY+giGq5yekiXmJsdEH4fDSZnMo741CT5PmvXy90Qoa4vPHpH4CjSQgEHpkV2J4Xvkg==
X-Received: by 2002:a17:902:f646:b0:168:e2da:8931 with SMTP id m6-20020a170902f64600b00168e2da8931mr25097102plg.84.1659513833884;
        Wed, 03 Aug 2022 01:03:53 -0700 (PDT)
Received: from localhost ([223.104.103.89])
        by smtp.gmail.com with ESMTPSA id h27-20020a63211b000000b0040d48cf046csm10530027pgh.55.2022.08.03.01.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 01:03:53 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com
Cc:     andrii@kernel.org, ast@kernel.org, borisp@nvidia.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        edumazet@google.com, guwen@linux.alibaba.com,
        john.fastabend@gmail.com, kafai@fb.com, kgraul@linux.ibm.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com, 18801353760@163.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        jakub@cloudflare.com, paskripkin@gmail.com,
        skhan@linuxfoundation.org, Hawkins Jiawei <yin31149@gmail.com>
Subject: [PATCH v3] net/smc: fix refcount bug in sk_psock_get (2)
Date:   Wed,  3 Aug 2022 16:03:38 +0800
Message-Id: <20220803080338.166730-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <00000000000026328205e08cdbeb@google.com>
References: <00000000000026328205e08cdbeb@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzkaller reports refcount bug as follows:
------------[ cut here ]------------
refcount_t: saturated; leaking memory.
WARNING: CPU: 1 PID: 3605 at lib/refcount.c:19 refcount_warn_saturate+0xf4/0x1e0 lib/refcount.c:19
Modules linked in:
CPU: 1 PID: 3605 Comm: syz-executor208 Not tainted 5.18.0-syzkaller-03023-g7e062cda7d90 #0
 <TASK>
 __refcount_add_not_zero include/linux/refcount.h:163 [inline]
 __refcount_inc_not_zero include/linux/refcount.h:227 [inline]
 refcount_inc_not_zero include/linux/refcount.h:245 [inline]
 sk_psock_get+0x3bc/0x410 include/linux/skmsg.h:439
 tls_data_ready+0x6d/0x1b0 net/tls/tls_sw.c:2091
 tcp_data_ready+0x106/0x520 net/ipv4/tcp_input.c:4983
 tcp_data_queue+0x25f2/0x4c90 net/ipv4/tcp_input.c:5057
 tcp_rcv_state_process+0x1774/0x4e80 net/ipv4/tcp_input.c:6659
 tcp_v4_do_rcv+0x339/0x980 net/ipv4/tcp_ipv4.c:1682
 sk_backlog_rcv include/net/sock.h:1061 [inline]
 __release_sock+0x134/0x3b0 net/core/sock.c:2849
 release_sock+0x54/0x1b0 net/core/sock.c:3404
 inet_shutdown+0x1e0/0x430 net/ipv4/af_inet.c:909
 __sys_shutdown_sock net/socket.c:2331 [inline]
 __sys_shutdown_sock net/socket.c:2325 [inline]
 __sys_shutdown+0xf1/0x1b0 net/socket.c:2343
 __do_sys_shutdown net/socket.c:2351 [inline]
 __se_sys_shutdown net/socket.c:2349 [inline]
 __x64_sys_shutdown+0x50/0x70 net/socket.c:2349
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
 </TASK>

During SMC fallback process in connect syscall, kernel will
replaces TCP with SMC. In order to forward wakeup
smc socket waitqueue after fallback, kernel will sets
clcsk->sk_user_data to origin smc socket in
smc_fback_replace_callbacks().

Later, in shutdown syscall, kernel will calls
sk_psock_get(), which treats the clcsk->sk_user_data
as psock type, triggering the refcnt warning.

So, the root cause is that smc and psock, both will use
sk_user_data field. So they will mismatch this field
easily.

This patch solves it by using another bit(defined as
SK_USER_DATA_PSOCK) in PTRMASK, to mark whether
sk_user_data points to a psock object or not.
This patch depends on a PTRMASK introduced in commit f1ff5ce2cd5e
("net, sk_msg: Clear sk_user_data pointer on clone if tagged").

Reported-and-tested-by: syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Wen Gu <guwen@linux.alibaba.com>
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
---
v2 -> v3:
  - use SK_USER_DATA_PSOCK instead of SK_USER_DATA_NOTPSOCK
to patch the bug
  - refactor the code on assigning to sk_user_data field
in psock part
  - refactor the code on getting and setting the flag
with sk_user_data field

v1 -> v2:
  - add bit in PTRMASK to patch the bug

 include/linux/skmsg.h |  2 +-
 include/net/sock.h    | 58 +++++++++++++++++++++++++++++++------------
 net/core/skmsg.c      |  3 ++-
 3 files changed, 45 insertions(+), 18 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index c5a2d6f50f25..81bfa1a33623 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -277,7 +277,7 @@ static inline void sk_msg_sg_copy_clear(struct sk_msg *msg, u32 start)
 
 static inline struct sk_psock *sk_psock(const struct sock *sk)
 {
-	return rcu_dereference_sk_user_data(sk);
+	return rcu_dereference_sk_user_data_psock(sk);
 }
 
 static inline void sk_psock_set_state(struct sk_psock *psock,
diff --git a/include/net/sock.h b/include/net/sock.h
index 9fa54762e077..d010910d5879 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -545,14 +545,24 @@ enum sk_pacing {
 	SK_PACING_FQ		= 2,
 };
 
-/* Pointer stored in sk_user_data might not be suitable for copying
- * when cloning the socket. For instance, it can point to a reference
- * counted object. sk_user_data bottom bit is set if pointer must not
- * be copied.
+/* flag bits in sk_user_data
+ *
+ * SK_USER_DATA_NOCOPY - Pointer stored in sk_user_data might
+ * not be suitable for copying when cloning the socket.
+ * For instance, it can point to a reference counted object.
+ * sk_user_data bottom bit is set if pointer must not be copied.
+ *
+ * SK_USER_DATA_BPF    - Managed by BPF
+ *
+ * SK_USER_DATA_PSOCK  - Mark whether pointer stored in sk_user_data points
+ * to psock type. This bit should be set when sk_user_data is
+ * assigned to a psock object.
  */
 #define SK_USER_DATA_NOCOPY	1UL
-#define SK_USER_DATA_BPF	2UL	/* Managed by BPF */
-#define SK_USER_DATA_PTRMASK	~(SK_USER_DATA_NOCOPY | SK_USER_DATA_BPF)
+#define SK_USER_DATA_BPF	2UL
+#define SK_USER_DATA_PSOCK	4UL
+#define SK_USER_DATA_PTRMASK	~(SK_USER_DATA_NOCOPY | SK_USER_DATA_BPF |\
+				  SK_USER_DATA_PSOCK)
 
 /**
  * sk_user_data_is_nocopy - Test if sk_user_data pointer must not be copied
@@ -570,19 +580,35 @@ static inline bool sk_user_data_is_nocopy(const struct sock *sk)
 	void *__tmp = rcu_dereference(__sk_user_data((sk)));		\ (void *)((uintptr_t)__tmp & SK_USER_DATA_PTRMASK);		\
 })
-#define rcu_assign_sk_user_data(sk, ptr)				\
+#define rcu_assign_sk_user_data_with_flags(sk, ptr, flags)		\
 ({									\
-	uintptr_t __tmp = (uintptr_t)(ptr);				\
-	WARN_ON_ONCE(__tmp & ~SK_USER_DATA_PTRMASK);			\
-	rcu_assign_pointer(__sk_user_data((sk)), __tmp);		\
-})
-#define rcu_assign_sk_user_data_nocopy(sk, ptr)				\
-({									\
-	uintptr_t __tmp = (uintptr_t)(ptr);				\
-	WARN_ON_ONCE(__tmp & ~SK_USER_DATA_PTRMASK);			\
+	uintptr_t __tmp1 = (uintptr_t)(ptr),				\
+		  __tmp2 = (uintptr_t)(flags);				\
+	WARN_ON_ONCE(__tmp1 & ~SK_USER_DATA_PTRMASK);			\
+	WARN_ON_ONCE(__tmp2 & SK_USER_DATA_PTRMASK);			\
 	rcu_assign_pointer(__sk_user_data((sk)),			\
-			   __tmp | SK_USER_DATA_NOCOPY);		\
+			   __tmp1 | __tmp2);				\
 })
+#define rcu_assign_sk_user_data(sk, ptr)				\
+	rcu_assign_sk_user_data_with_flags(sk, ptr, 0)
+
+/**
+ * rcu_dereference_sk_user_data_psock - return psock if sk_user_data
+ * points to the psock type(SK_USER_DATA_PSOCK flag is set), otherwise
+ * return NULL
+ *
+ * @sk: socket
+ */
+static inline
+struct sk_psock *rcu_dereference_sk_user_data_psock(const struct sock *sk)
+{
+	uintptr_t __tmp = (uintptr_t)rcu_dereference(__sk_user_data((sk)));
+
+	if (__tmp & SK_USER_DATA_PSOCK)
+		return (struct sk_psock *)(__tmp & SK_USER_DATA_PTRMASK);
+
+	return NULL;
+}
 
 static inline
 struct net *sock_net(const struct sock *sk)
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index b0fcd0200e84..d174897dbb4b 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -735,7 +735,8 @@ struct sk_psock *sk_psock_init(struct sock *sk, int node)
 	sk_psock_set_state(psock, SK_PSOCK_TX_ENABLED);
 	refcount_set(&psock->refcnt, 1);
 
-	rcu_assign_sk_user_data_nocopy(sk, psock);
+	rcu_assign_sk_user_data_with_flags(sk, psock, SK_USER_DATA_NOCOPY |
+						      SK_USER_DATA_PSOCK);
 	sock_hold(sk);
 
 out:
-- 
2.25.1

