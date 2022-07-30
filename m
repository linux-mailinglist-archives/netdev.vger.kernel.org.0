Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEEF58594C
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 10:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbiG3I7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 04:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiG3I7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 04:59:01 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94451573C;
        Sat, 30 Jul 2022 01:59:00 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id t2-20020a17090a4e4200b001f21572f3a4so7339398pjl.0;
        Sat, 30 Jul 2022 01:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=puomoMAHuQXs/SqXXekCtCcFNLgV0IdV/qMrowpM2aE=;
        b=c6n/Ibwi5WwoKOGlBfoXVvZ9DFfolINEO1XlBObTpSOnTPjqE3HvGjR1snZq1sI6OW
         7deLvVMDOwnRHaaL2/GdUiIhVecUCwH/bHJhJDLAth8Z99QwdmuVRP22AyjSqkpFh8Cm
         DRV91mVkiYQpAo4GjbBm1FbZmEyRTybk2C6k3NdV166qR4vQz3xZvTHW5Fhh8oi1eSDI
         eJ7+/Bu7jdBQJ1Z6Rm16GAACG8x4jFKbPFaRfN51J0Hxkd77NMUAvEl/jOArXyiuZx+Z
         i18Z+BkAlVGd4fRnaUNGyi0cUs/yV49qAhcjb7reiiajNxHv2XivFXStO+/ooUmC6x0i
         SY5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=puomoMAHuQXs/SqXXekCtCcFNLgV0IdV/qMrowpM2aE=;
        b=bzdebplzLz1NNm/dEFyi7sY7ORqYyT6iVVVxH5O0FPSZisOaLlQ3SzJ6fsxgczwT4P
         3CuqeJrp2FEMYl9Fp6Xz5BQy1un+AjD4OWTkhN0/ZWO4/exNLCGEU8WqnbrNqah412Iq
         xYJ+e5j7V5+y1N/xAnMTXGFOIklPB6iBV7cdJDFfEv9KXwcIXzD5fBRr7Ll6SHUGGfV0
         nGFJzmO/Q41XFbWlaB13WW7BaAJ6VbXnXfaPpm88ddoscdq5+y0l7WWtvdWLLUePEm+t
         p1QxAoAsGo/CANaqa90Wg0v/V2QjP5GMVWotVi59rAlG3uj01Oi3bMUAC8P6cFMkYUdD
         mqmw==
X-Gm-Message-State: ACgBeo0/34HhLe+6ilFl38dINJM36+5kE0IInx5ebqcwPC2fcGh8vCuH
        s1ctg1M9JlbYAyuaKfwKrvs=
X-Google-Smtp-Source: AA6agR7pFANRL8Gq/mDm5/a+hLy+KV8WKjhFrH96qRB3vfOwbIDxJC7gHjwRlkdZowAs+2B8sQxa/A==
X-Received: by 2002:a17:90b:1646:b0:1f2:91c8:d0a with SMTP id il6-20020a17090b164600b001f291c80d0amr8857728pjb.5.1659171540275;
        Sat, 30 Jul 2022 01:59:00 -0700 (PDT)
Received: from localhost.localdomain (pcd568068.netvigator.com. [218.102.100.68])
        by smtp.gmail.com with ESMTPSA id 4-20020a620604000000b0052b6277df9esm4321524pfg.43.2022.07.30.01.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jul 2022 01:58:59 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com
Cc:     andrii@kernel.org, ast@kernel.org, jakub@cloudflare.com,
        borisp@nvidia.com, bpf@vger.kernel.org, wenjia@linux.ibm.com,
        ubraun@linux.ibm.com, daniel@iogearbox.net, guvenc@linux.ibm.com,
        davem@davemloft.net, edumazet@google.com, guwen@linux.alibaba.com,
        john.fastabend@gmail.com, kafai@fb.com, kgraul@linux.ibm.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, linux-s390@vger.kernel.org,
        yhs@fb.com, yin31149@gmail.com, 18801353760@163.com,
        paskripkin@gmail.com, skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH v2] net/smc: fix refcount bug in sk_psock_get (2)
Date:   Sat, 30 Jul 2022 16:56:55 +0800
Message-Id: <20220730085654.2598-1-yin31149@gmail.com>
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
...
Call Trace:
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
as sk_psock type, triggering the refcnt warning.

So, the root cause is that smc and psock, both will use
sk_user_data field. So they will mismatch this field
easily.

This patch solves it by using another bit(defined as
SK_USER_DATA_NOTPSOCK) in PTRMASK, to mark whether
sk_user_data points to a sk_psock object or not.
This patch depends on a PTRMASK introduced in commit f1ff5ce2cd5e
("net, sk_msg: Clear sk_user_data pointer on clone if tagged").

Fixes: 341adeec9ada ("net/smc: Forward wakeup to smc socket waitqueue after fallback")
Fixes: a60a2b1e0af1 ("net/smc: reduce active tcp_listen workers")
Reported-and-tested-by: syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Wen Gu <guwen@linux.alibaba.com>
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
---
v1 -> v2: 
  - add bit in PTRMASK to patch the bug

 include/linux/skmsg.h |  2 +-
 include/net/sock.h    | 27 +++++++++++++++++++++++++--
 net/smc/af_smc.c      |  6 ++++--
 net/smc/smc.h         |  2 +-
 4 files changed, 31 insertions(+), 6 deletions(-)

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
index 9fa54762e077..316c0313b2bf 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -549,10 +549,17 @@ enum sk_pacing {
  * when cloning the socket. For instance, it can point to a reference
  * counted object. sk_user_data bottom bit is set if pointer must not
  * be copied.
+ *
+ * SK_USER_DATA_NOCOPY   - test if pointer must not copied
+ * SK_USER_DATA_BPF      - managed by BPF
+ * SK_USER_DATA_NOTPSOCK - test if pointer points to psock
  */
 #define SK_USER_DATA_NOCOPY	1UL
-#define SK_USER_DATA_BPF	2UL	/* Managed by BPF */
-#define SK_USER_DATA_PTRMASK	~(SK_USER_DATA_NOCOPY | SK_USER_DATA_BPF)
+#define SK_USER_DATA_BPF	2UL
+#define SK_USER_DATA_NOTPSOCK	4UL
+#define SK_USER_DATA_PTRMASK	~(SK_USER_DATA_NOCOPY | SK_USER_DATA_BPF |\
+				  SK_USER_DATA_NOTPSOCK)
+
 
 /**
  * sk_user_data_is_nocopy - Test if sk_user_data pointer must not be copied
@@ -584,6 +591,22 @@ static inline bool sk_user_data_is_nocopy(const struct sock *sk)
 			   __tmp | SK_USER_DATA_NOCOPY);		\
 })
 
+/**
+ * rcu_dereference_sk_user_data_psock - return psock if sk_user_data points
+ * to the psock
+ * @sk: socket
+ */
+static inline
+struct sk_psock *rcu_dereference_sk_user_data_psock(const struct sock *sk)
+{
+	uintptr_t __tmp = (uintptr_t)rcu_dereference(__sk_user_data((sk)));
+
+	if (__tmp & SK_USER_DATA_NOTPSOCK)
+		return NULL;
+	return (struct sk_psock *)(__tmp & SK_USER_DATA_PTRMASK);
+}
+
+
 static inline
 struct net *sock_net(const struct sock *sk)
 {
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 433bb5a7df31..d0feccf824c8 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -812,7 +812,8 @@ static void smc_fback_replace_callbacks(struct smc_sock *smc)
 	struct sock *clcsk = smc->clcsock->sk;
 
 	write_lock_bh(&clcsk->sk_callback_lock);
-	clcsk->sk_user_data = (void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
+	clcsk->sk_user_data = (void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY |
+				       SK_USER_DATA_NOTPSOCK);
 
 	smc_clcsock_replace_cb(&clcsk->sk_state_change, smc_fback_state_change,
 			       &smc->clcsk_state_change);
@@ -2470,7 +2471,8 @@ static int smc_listen(struct socket *sock, int backlog)
 	 */
 	write_lock_bh(&smc->clcsock->sk->sk_callback_lock);
 	smc->clcsock->sk->sk_user_data =
-		(void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
+		(void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY |
+			 SK_USER_DATA_NOTPSOCK);
 	smc_clcsock_replace_cb(&smc->clcsock->sk->sk_data_ready,
 			       smc_clcsock_data_ready, &smc->clcsk_data_ready);
 	write_unlock_bh(&smc->clcsock->sk->sk_callback_lock);
diff --git a/net/smc/smc.h b/net/smc/smc.h
index 5ed765ea0c73..c24d0469d267 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -299,7 +299,7 @@ static inline void smc_init_saved_callbacks(struct smc_sock *smc)
 static inline struct smc_sock *smc_clcsock_user_data(const struct sock *clcsk)
 {
 	return (struct smc_sock *)
-	       ((uintptr_t)clcsk->sk_user_data & ~SK_USER_DATA_NOCOPY);
+	       ((uintptr_t)clcsk->sk_user_data & SK_USER_DATA_PTRMASK);
 }
 
 /* save target_cb in saved_cb, and replace target_cb with new_cb */
-- 
2.25.1

