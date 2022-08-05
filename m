Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D40A58A766
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 09:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240175AbiHEHsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 03:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237624AbiHEHsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 03:48:50 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2834B1018;
        Fri,  5 Aug 2022 00:48:47 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id w14so1960084plp.9;
        Fri, 05 Aug 2022 00:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=7UBWNlO3fLQxQeZLzmYhtN9S9nLT0WpSVtJngbc+X2w=;
        b=eGEcg3HVdqx+0OUna1SJ8l7FDJ0Wai0IltIGS84nmsXrLOzxepd7XFK6P9qZS4aXJR
         QVz+CAPB37lfcElohvPaTg1sa8OAOkILxUC6zBVeuPkS2pBUlj1xKAy+A/CeP5mqgga4
         qoG2FxfRqAZ6tcLVjAbZHFk/ycc5l53Xh7t23Kd8nCyOTd7GBtF2Tp9HXxMI0EGC+wJo
         CrFaoWRlhawGqZAS7C+dgU5OSApVOKUaH98G54TBqhuP+mGuU4sLBDinKJ3+poqPzLju
         Yjz6NEYvKjREhoq6WFqV9vbp3jHvlk0bqWAQa1l/aTP06cMq+LuY4SRDCjHzzESXLyGr
         wGtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=7UBWNlO3fLQxQeZLzmYhtN9S9nLT0WpSVtJngbc+X2w=;
        b=xdWq2/WzjlZpzx5bd3pR/Em02lVfFwM3W63h0uEXgABW806h+J/tCwdMhfzHAYkM2/
         8BMSt1Lr0iFbbjkfbtVj7TLx8KmAhI3eycR/MvDl5qqrtlqfchKwnxLMDmMCSS2fcbY8
         VyO0BUfmWq5bzQ983gOf3uXPLBat/ztQoQ7aBI/HUIxAqOXOE0YU8ptAS3k7dzMi8eFn
         sb6Q5iTHPrBFz7JIaNSfV1CquAkjGQBFyz8eSMYMgcFd1aLPRwQTUV7PdnhTSFmnWMe3
         tXN92/v1mWcFwdsTma1xk6qRdWnIQn4Eyxi62udZpH2mZJEuiJSoVCV8tP0PoLNQnTCo
         PInA==
X-Gm-Message-State: ACgBeo28vNZjePfJ3tGGriMdCEi0ceaVlhyLsNJDIWaj0iJn/1GwFlsn
        uUhR4gqS5fQ/hoxsJyjvxiI=
X-Google-Smtp-Source: AA6agR6v4QLqjaMArP3sGgtyrw+Fmdy7UThiHNXhJHmkKvwTz+wx+iDMM6m/R7il/6yPKy41XuxL7w==
X-Received: by 2002:a17:90b:508a:b0:1f3:3a77:4fde with SMTP id rt10-20020a17090b508a00b001f33a774fdemr6262387pjb.130.1659685726683;
        Fri, 05 Aug 2022 00:48:46 -0700 (PDT)
Received: from localhost ([117.136.0.155])
        by smtp.gmail.com with ESMTPSA id u13-20020a170902714d00b0016d2f0b67e0sm2158889plm.309.2022.08.05.00.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 00:48:46 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     paskripkin@gmail.com, skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        18801353760@163.com, Hawkins Jiawei <yin31149@gmail.com>,
        Wen Gu <guwen@linux.alibaba.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v5 1/2] net: fix refcount bug in sk_psock_get (2)
Date:   Fri,  5 Aug 2022 15:48:34 +0800
Message-Id: <785e4e5b6f7375c3e7d7cfb169d34852c1380587.1659676823.git.yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659676823.git.yin31149@gmail.com>
References: <cover.1659676823.git.yin31149@gmail.com>
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

For there will possibly be more flags in the sk_user_data field,
this patch also refactor sk_user_data flags code to be more generic
to improve its maintainability.

Reported-and-tested-by: syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Wen Gu <guwen@linux.alibaba.com>
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
---
v4 -> v5:
  - add more info about SK_USER_DATA_BPF in comment
  - correct the function definition format
  - generalize rcu_deference_sk_user_data_psock() into
__rcu_deference_sk_user_data_with_flags()

v3 -> v4:
  - change new subject
  - fix diff content, which has been edit accidentally

v2 -> v3:
  - use SK_USER_DATA_PSOCK instead of SK_USER_DATA_NOTPSOCK
to patch the bug
  - refactor the code on assigning to sk_user_data field
in psock part
  - refactor the code on getting and setting the flag
with sk_user_data field

v1 -> v2:
  - add bit in PTRMASK to patch the bug

 include/linux/skmsg.h |  3 +-
 include/net/sock.h    | 68 ++++++++++++++++++++++++++++++-------------
 net/core/skmsg.c      |  4 ++-
 3 files changed, 53 insertions(+), 22 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index c5a2d6f50f25..c5bdc5975a5c 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -277,7 +277,8 @@ static inline void sk_msg_sg_copy_clear(struct sk_msg *msg, u32 start)
 
 static inline struct sk_psock *sk_psock(const struct sock *sk)
 {
-	return rcu_dereference_sk_user_data(sk);
+	return __rcu_dereference_sk_user_data_with_flags(sk,
+							 SK_USER_DATA_PSOCK);
 }
 
 static inline void sk_psock_set_state(struct sk_psock *psock,
diff --git a/include/net/sock.h b/include/net/sock.h
index 9fa54762e077..a5ebc3b28804 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -545,14 +545,26 @@ enum sk_pacing {
 	SK_PACING_FQ		= 2,
 };
 
-/* Pointer stored in sk_user_data might not be suitable for copying
- * when cloning the socket. For instance, it can point to a reference
- * counted object. sk_user_data bottom bit is set if pointer must not
- * be copied.
+/* flag bits in sk_user_data
+ *
+ * - SK_USER_DATA_NOCOPY:      Pointer stored in sk_user_data might
+ *   not be suitable for copying when cloning the socket. For instance,
+ *   it can point to a reference counted object. sk_user_data bottom
+ *   bit is set if pointer must not be copied.
+ *
+ * - SK_USER_DATA_BPF:         Mark whether sk_user_data field is
+ *   managed/owned by a BPF reuseport array. This bit should be set
+ *   when sk_user_data's sk is added to the bpf's reuseport_array.
+ *
+ * - SK_USER_DATA_PSOCK:       Mark whether pointer stored in
+ *   sk_user_data points to psock type. This bit should be set
+ *   when sk_user_data is assigned to a psock object.
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
@@ -565,24 +577,40 @@ static inline bool sk_user_data_is_nocopy(const struct sock *sk)
 
 #define __sk_user_data(sk) ((*((void __rcu **)&(sk)->sk_user_data)))
 
+/**
+ * __rcu_dereference_sk_user_data_with_flags - return the pointer
+ * only if argument flags all has been set in sk_user_data. Otherwise
+ * return NULL
+ *
+ * @sk: socket
+ * @flags: flag bits
+ */
+static inline void *
+__rcu_dereference_sk_user_data_with_flags(const struct sock *sk,
+					  uintptr_t flags)
+{
+	uintptr_t sk_user_data = (uintptr_t)rcu_dereference(__sk_user_data(sk));
+
+	WARN_ON_ONCE(flags & SK_USER_DATA_PTRMASK);
+
+	if ((sk_user_data & flags) == flags)
+		return (void *)(sk_user_data & SK_USER_DATA_PTRMASK);
+	return NULL;
+}
+
 #define rcu_dereference_sk_user_data(sk)				\
+	__rcu_dereference_sk_user_data_with_flags(sk, 0)
+#define __rcu_assign_sk_user_data_with_flags(sk, ptr, flags)		\
 ({									\
-	void *__tmp = rcu_dereference(__sk_user_data((sk)));		\
-	(void *)((uintptr_t)__tmp & SK_USER_DATA_PTRMASK);		\
-})
-#define rcu_assign_sk_user_data(sk, ptr)				\
-({									\
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
+	__rcu_assign_sk_user_data_with_flags(sk, ptr, 0)
 
 static inline
 struct net *sock_net(const struct sock *sk)
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index b0fcd0200e84..10f7afa3d7a5 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -735,7 +735,9 @@ struct sk_psock *sk_psock_init(struct sock *sk, int node)
 	sk_psock_set_state(psock, SK_PSOCK_TX_ENABLED);
 	refcount_set(&psock->refcnt, 1);
 
-	rcu_assign_sk_user_data_nocopy(sk, psock);
+	__rcu_assign_sk_user_data_with_flags(sk, psock,
+					     SK_USER_DATA_NOCOPY |
+					     SK_USER_DATA_PSOCK);
 	sock_hold(sk);
 
 out:
-- 
2.25.1

