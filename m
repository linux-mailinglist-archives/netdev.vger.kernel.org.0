Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C5228A240
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 00:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389619AbgJJWzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730235AbgJJTu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:50:28 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FAF8C0613A6
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 03:45:34 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id w21so9114985pfc.7
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 03:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7kDyicVnemf+97vSMnHND6q/0cC3Faf1x64wHvnAiYU=;
        b=TGfDZ8tSvIy6s6P5gNA6zgwo5FFiBrWoF2vxRAiZn7HCZ7OZYpifmSrWAviXxnIkpI
         c5Y81F5fc4Znxu6s5nR+c+uiPeZR75Vga+byGDz+SKCwQsDISBCpXpbcBYDjlr8deIPP
         xlhn/dQzRe3381p3Iq5u7T5ELgIo2IGl+EZSjaoTosWKeP338QoEWm4dLdCpEpU46rap
         VbD3NIS9+BoSBKXR/F45VvwGJj5upbp2iGylge1QfCBpGP4MdV98f2ygzKCYXgBErq7I
         pB+6aHbDPQoVfvNysor5hVC2kCiocrHCdKn1RuHaPB6JSPOIZDXQ+Bar48GSN0cTm4ou
         Uj6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7kDyicVnemf+97vSMnHND6q/0cC3Faf1x64wHvnAiYU=;
        b=NoJTHC0+BkaQ6v7CNVyDKBF8kPQRhZrUpBJr8vvWXusUzdoRu3dnTozJkqao4fBoix
         nIVsGRkzSB67zQMpOycvoTYeJcitPqDArpPTA3ueLxYeBjJr6zRslfRijKM2psxBcBWJ
         cRLFOHkD34P/z30E2q/qepQ3xl0a9c5OWnScb9qcxnIUmQz+xL4Slk7vW0s08wegBGMD
         yYmDCjv3b4jHGuDvW/iVzFNF4dyVlbojvKtBHV/clme1z8n+zmtxGL/4QcMF81slOXHo
         4+6JVxSqHgFxZFbn92Jf+M9XTgiBp7TXjg5d5F2TGdiuoKJ7cLIoF0e46Bf61vI1GvN+
         oLRQ==
X-Gm-Message-State: AOAM532iVis1eJ6ywuE186cahNE3wcyazmHOgeNq/xywhXVzv69lEF32
        cH/Hn48DkYV4MUd/Yaxm50aRKg==
X-Google-Smtp-Source: ABdhPJwW+myip0mhMxOVtzbe4oquIgi1etPLX4AHjdj0ApW1SIKkEvVWACBRFWgZrck8ueAf4VQlnw==
X-Received: by 2002:a17:90a:1bc3:: with SMTP id r3mr9767091pjr.196.1602326733948;
        Sat, 10 Oct 2020 03:45:33 -0700 (PDT)
Received: from Smcdef-MBP.local.net ([103.136.220.73])
        by smtp.gmail.com with ESMTPSA id p4sm11096891pgp.83.2020.10.10.03.45.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 10 Oct 2020 03:45:33 -0700 (PDT)
From:   Muchun Song <songmuchun@bytedance.com>
To:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com,
        akpm@linux-foundation.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, shakeelb@google.com, guro@fb.com,
        iamjoonsoo.kim@lge.com, laoar.shao@gmail.com, chris@chrisdown.name,
        daniel@iogearbox.net, kafai@fb.com, ast@kernel.org,
        jakub@cloudflare.com, linmiaohe@huawei.com, keescook@chromium.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH] mm: memcontrol: localize mem_cgroup_sockets_enabled() check
Date:   Sat, 10 Oct 2020 18:45:21 +0800
Message-Id: <20201010104521.67262-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the mem_cgroup_sockets_enabled() checks into memcg socket charge
or uncharge functions, so the users don't have to explicitly check that
condition.

This is purely code cleanup patch without any functional change. But
move the sk_memcg member of the sock structure to the CONFIG_MEMCG
scope.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/memcontrol.h      | 78 ++++++++++++++++++++++++++-------
 include/net/sock.h              |  5 ++-
 include/net/tcp.h               |  3 +-
 mm/memcontrol.c                 | 43 +++++++++++++-----
 net/core/sock.c                 | 15 +++----
 net/ipv4/inet_connection_sock.c |  6 +--
 net/ipv4/tcp_output.c           |  3 +-
 7 files changed, 111 insertions(+), 42 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 924177502479..a1395b584947 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1460,21 +1460,48 @@ static inline void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 #endif	/* CONFIG_CGROUP_WRITEBACK */
 
 struct sock;
-bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages);
-void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages);
 #ifdef CONFIG_MEMCG
+bool __mem_cgroup_charge_skmem(struct sock *sk, unsigned int nr_pages);
+void __mem_cgroup_uncharge_skmem(struct sock *sk, unsigned int nr_pages);
+
 extern struct static_key_false memcg_sockets_enabled_key;
-#define mem_cgroup_sockets_enabled static_branch_unlikely(&memcg_sockets_enabled_key)
-void mem_cgroup_sk_alloc(struct sock *sk);
+
+static inline bool mem_cgroup_sockets_enabled(void)
+{
+	return static_branch_unlikely(&memcg_sockets_enabled_key);
+}
+
+static inline bool mem_cgroup_charge_skmem(struct sock *sk,
+					   unsigned int nr_pages)
+{
+	if (mem_cgroup_sockets_enabled())
+		return __mem_cgroup_charge_skmem(sk, nr_pages);
+	return true;
+}
+
+static inline void mem_cgroup_uncharge_skmem(struct sock *sk,
+					     unsigned int nr_pages)
+{
+	if (mem_cgroup_sockets_enabled())
+		__mem_cgroup_uncharge_skmem(sk, nr_pages);
+}
+
+void __mem_cgroup_sk_alloc(struct sock *sk);
+
+static inline void mem_cgroup_sk_alloc(struct sock *sk)
+{
+	if (mem_cgroup_sockets_enabled())
+		__mem_cgroup_sk_alloc(sk);
+}
+
 void mem_cgroup_sk_free(struct sock *sk);
-static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
+
+bool __mem_cgroup_under_socket_pressure(const struct sock *sk);
+
+static inline bool mem_cgroup_under_socket_pressure(const struct sock *sk)
 {
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
-		return true;
-	do {
-		if (time_before(jiffies, memcg->socket_pressure))
-			return true;
-	} while ((memcg = parent_mem_cgroup(memcg)));
+	if (mem_cgroup_sockets_enabled())
+		return __mem_cgroup_under_socket_pressure(sk);
 	return false;
 }
 
@@ -1483,10 +1510,31 @@ extern int memcg_expand_shrinker_maps(int new_id);
 extern void memcg_set_shrinker_bit(struct mem_cgroup *memcg,
 				   int nid, int shrinker_id);
 #else
-#define mem_cgroup_sockets_enabled 0
-static inline void mem_cgroup_sk_alloc(struct sock *sk) { };
-static inline void mem_cgroup_sk_free(struct sock *sk) { };
-static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
+static inline bool mem_cgroup_sockets_enabled(void)
+{
+	return false;
+}
+
+static inline bool mem_cgroup_charge_skmem(struct sock *sk,
+					   unsigned int nr_pages)
+{
+	return true;
+}
+
+static inline void mem_cgroup_uncharge_skmem(struct sock *sk,
+					     unsigned int nr_pages)
+{
+}
+
+static inline void mem_cgroup_sk_alloc(struct sock *sk)
+{
+}
+
+static inline void mem_cgroup_sk_free(struct sock *sk)
+{
+}
+
+static inline bool mem_cgroup_under_socket_pressure(const struct sock *sk)
 {
 	return false;
 }
diff --git a/include/net/sock.h b/include/net/sock.h
index 7dd3051551fb..f486a121fb99 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -502,7 +502,9 @@ struct sock {
 	void			*sk_security;
 #endif
 	struct sock_cgroup_data	sk_cgrp_data;
+#ifdef CONFIG_MEMCG
 	struct mem_cgroup	*sk_memcg;
+#endif
 	void			(*sk_state_change)(struct sock *sk);
 	void			(*sk_data_ready)(struct sock *sk);
 	void			(*sk_write_space)(struct sock *sk);
@@ -1311,8 +1313,7 @@ static inline bool sk_under_memory_pressure(const struct sock *sk)
 	if (!sk->sk_prot->memory_pressure)
 		return false;
 
-	if (mem_cgroup_sockets_enabled && sk->sk_memcg &&
-	    mem_cgroup_under_socket_pressure(sk->sk_memcg))
+	if (mem_cgroup_under_socket_pressure(sk))
 		return true;
 
 	return !!*sk->sk_prot->memory_pressure;
diff --git a/include/net/tcp.h b/include/net/tcp.h
index e85d564446c6..c2efcf3c1495 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -257,8 +257,7 @@ extern unsigned long tcp_memory_pressure;
 /* optimized version of sk_under_memory_pressure() for TCP sockets */
 static inline bool tcp_under_memory_pressure(const struct sock *sk)
 {
-	if (mem_cgroup_sockets_enabled && sk->sk_memcg &&
-	    mem_cgroup_under_socket_pressure(sk->sk_memcg))
+	if (mem_cgroup_under_socket_pressure(sk))
 		return true;
 
 	return READ_ONCE(tcp_memory_pressure);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4d722f4eaba8..331d7cd92e3d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7012,13 +7012,10 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage)
 DEFINE_STATIC_KEY_FALSE(memcg_sockets_enabled_key);
 EXPORT_SYMBOL(memcg_sockets_enabled_key);
 
-void mem_cgroup_sk_alloc(struct sock *sk)
+void __mem_cgroup_sk_alloc(struct sock *sk)
 {
 	struct mem_cgroup *memcg;
 
-	if (!mem_cgroup_sockets_enabled)
-		return;
-
 	/* Do not associate the sock with unrelated interrupted task's memcg. */
 	if (in_interrupt())
 		return;
@@ -7041,18 +7038,39 @@ void mem_cgroup_sk_free(struct sock *sk)
 		css_put(&sk->sk_memcg->css);
 }
 
+bool __mem_cgroup_under_socket_pressure(const struct sock *sk)
+{
+	struct mem_cgroup *memcg = sk->sk_memcg;
+
+	if (!memcg)
+		return false;
+
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
+		return true;
+	do {
+		if (time_before(jiffies, memcg->socket_pressure))
+			return true;
+	} while ((memcg = parent_mem_cgroup(memcg)));
+	return false;
+}
+EXPORT_SYMBOL(__mem_cgroup_under_socket_pressure);
+
 /**
- * mem_cgroup_charge_skmem - charge socket memory
- * @memcg: memcg to charge
+ * __mem_cgroup_charge_skmem - charge socket memory
+ * @sk: socket to charge
  * @nr_pages: number of pages to charge
  *
  * Charges @nr_pages to @memcg. Returns %true if the charge fit within
  * @memcg's configured limit, %false if the charge had to be forced.
  */
-bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
+bool __mem_cgroup_charge_skmem(struct sock *sk, unsigned int nr_pages)
 {
+	struct mem_cgroup *memcg = sk->sk_memcg;
 	gfp_t gfp_mask = GFP_KERNEL;
 
+	if (!memcg)
+		return true;
+
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
 		struct page_counter *fail;
 
@@ -7079,12 +7097,17 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
 }
 
 /**
- * mem_cgroup_uncharge_skmem - uncharge socket memory
- * @memcg: memcg to uncharge
+ * __mem_cgroup_uncharge_skmem - uncharge socket memory
+ * @sk: socket to uncharge
  * @nr_pages: number of pages to uncharge
  */
-void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
+void __mem_cgroup_uncharge_skmem(struct sock *sk, unsigned int nr_pages)
 {
+	struct mem_cgroup *memcg = sk->sk_memcg;
+
+	if (!memcg)
+		return;
+
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
 		page_counter_uncharge(&memcg->tcpmem, nr_pages);
 		return;
diff --git a/net/core/sock.c b/net/core/sock.c
index ba9e7d91e2ef..5972d26f03ae 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1901,9 +1901,10 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 
 		sock_reset_flag(newsk, SOCK_DONE);
 
+#ifdef CONFIG_MEMCG
 		/* sk->sk_memcg will be populated at accept() time */
 		newsk->sk_memcg = NULL;
-
+#endif
 		cgroup_sk_clone(&newsk->sk_cgrp_data);
 
 		rcu_read_lock();
@@ -2587,10 +2588,10 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 {
 	struct proto *prot = sk->sk_prot;
 	long allocated = sk_memory_allocated_add(sk, amt);
-	bool charged = true;
+	bool charged;
 
-	if (mem_cgroup_sockets_enabled && sk->sk_memcg &&
-	    !(charged = mem_cgroup_charge_skmem(sk->sk_memcg, amt)))
+	charged = mem_cgroup_charge_skmem(sk, amt);
+	if (!charged)
 		goto suppress_allocation;
 
 	/* Under limit. */
@@ -2653,8 +2654,7 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 
 	sk_memory_allocated_sub(sk, amt);
 
-	if (mem_cgroup_sockets_enabled && sk->sk_memcg)
-		mem_cgroup_uncharge_skmem(sk->sk_memcg, amt);
+	mem_cgroup_uncharge_skmem(sk, amt);
 
 	return 0;
 }
@@ -2693,8 +2693,7 @@ void __sk_mem_reduce_allocated(struct sock *sk, int amount)
 {
 	sk_memory_allocated_sub(sk, amount);
 
-	if (mem_cgroup_sockets_enabled && sk->sk_memcg)
-		mem_cgroup_uncharge_skmem(sk->sk_memcg, amount);
+	mem_cgroup_uncharge_skmem(sk, amount);
 
 	if (sk_under_memory_pressure(sk) &&
 	    (sk_memory_allocated(sk) < sk_prot_mem_limits(sk, 0)))
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index b457dd2d6c75..06959f4ec70e 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -511,7 +511,7 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
 
 out:
 	release_sock(sk);
-	if (newsk && mem_cgroup_sockets_enabled) {
+	if (newsk && mem_cgroup_sockets_enabled()) {
 		int amt;
 
 		/* atomically get the memory usage, set and charge the
@@ -525,8 +525,8 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
 		amt = sk_mem_pages(newsk->sk_forward_alloc +
 				   atomic_read(&newsk->sk_rmem_alloc));
 		mem_cgroup_sk_alloc(newsk);
-		if (newsk->sk_memcg && amt)
-			mem_cgroup_charge_skmem(newsk->sk_memcg, amt);
+		if (amt)
+			mem_cgroup_charge_skmem(newsk, amt);
 
 		release_sock(newsk);
 	}
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index ab79d36ed07f..ce235cc02b7e 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3369,8 +3369,7 @@ void sk_forced_mem_schedule(struct sock *sk, int size)
 	sk->sk_forward_alloc += amt * SK_MEM_QUANTUM;
 	sk_memory_allocated_add(sk, amt);
 
-	if (mem_cgroup_sockets_enabled && sk->sk_memcg)
-		mem_cgroup_charge_skmem(sk->sk_memcg, amt);
+	mem_cgroup_charge_skmem(sk, amt);
 }
 
 /* Send a FIN. The caller locks the socket for us.
-- 
2.20.1

