Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4A4305FA8
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 16:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343844AbhA0PcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 10:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343852AbhA0P2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 10:28:17 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC9CC06178A
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 07:27:36 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id d13so1234901plg.0
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 07:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uwUcCoN1q3foJDlKQ8fdAyfKdW1K77/eMl3VlF9JlRc=;
        b=tauGahDTBmsZ80/UWcA1MgyGjNX6EtViUUZehxSlsAA2lTBg6Cmi02YVTw75g7Fg/d
         tNH9kanYA8B88gcGKU0DIeVoiB11NsjqyrqxnrzDdNtWba1VdTJFQJDcgM2sMOMObFuF
         PAG5xNPTm8NO5+FpnyeDX8zQ7w7L2ISHzA16VaBahVzuDJ/D6w78zjBrbRwxCiZf/KEZ
         l7u0526lSpgWAgypXzp8YYx3sdjG1ZItANgoeMbkbnwnByg0sRFJ8q1ztjrY+ERBlD9y
         4fPSut/OWyfhUZZQAF0ClriCF9jkFA5sOeGF42cOUYwXyeK8jJSdOzGZmMrXfBxUUGzc
         Tx8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uwUcCoN1q3foJDlKQ8fdAyfKdW1K77/eMl3VlF9JlRc=;
        b=DNOv5cM79yAlJ2O4ia5gUrhLXNn3nTz83x1OsFCylcC0DJhFiKFInHZMKI6swFvLhW
         kVUeq77aBQafN6d8ghZVhbzEinCcJFewX17KBCWWaJzL87zj+C9fPAH5asSXpgVbbCdm
         mlaPpb6D56P/7Cr/rnBcD69Si2tIenKgicV5I61NnVS8Ev6zLGri1X+O+zA8lEMpRg0D
         Laa7tvFswm3lAT5NlLWwDrstH4mSwM6edALhd+/StH2QSbQA1gFrD79oxdjkbQYguNxe
         HQXCN9HP5/r/TenieygVSeDknRVbuSH9cnaHX0GM2KqHy18kkHzdXxz1uKBEge1wGk1p
         LtJg==
X-Gm-Message-State: AOAM533f5g4azi8QPy7JjPJ2Ercder/jrjJbglclvoc+YdgZjySDPcU+
        2cYnv2ypQektXJWzGVrRvvo=
X-Google-Smtp-Source: ABdhPJwzNTA8SW1u6FVKwMBp06CHZUBWTQodC9gpVJXHDy6jhGw5mbN/cdc00dGAo4l1rro2nHztjQ==
X-Received: by 2002:a17:90b:e8f:: with SMTP id fv15mr6342167pjb.178.1611761256445;
        Wed, 27 Jan 2021 07:27:36 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f432:4a55:3c04:2918])
        by smtp.gmail.com with ESMTPSA id 21sm2736348pfu.136.2021.01.27.07.27.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 07:27:35 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] net: reduce indentation level in sk_clone_lock()
Date:   Wed, 27 Jan 2021 07:27:31 -0800
Message-Id: <20210127152731.748663-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Rework initial test to jump over init code
if memory allocation has failed.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/sock.c | 209 ++++++++++++++++++++++++------------------------
 1 file changed, 103 insertions(+), 106 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index bbcd4b97eddd1341a71760f95a9420930a0e8f64..4600e58828da612682086b595d0a79b6e4806a67 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1876,123 +1876,120 @@ static void sk_init_common(struct sock *sk)
 struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 {
 	struct proto *prot = READ_ONCE(sk->sk_prot);
-	struct sock *newsk;
+	struct sk_filter *filter;
 	bool is_charged = true;
+	struct sock *newsk;
 
 	newsk = sk_prot_alloc(prot, priority, sk->sk_family);
-	if (newsk != NULL) {
-		struct sk_filter *filter;
+	if (!newsk)
+		goto out;
 
-		sock_copy(newsk, sk);
+	sock_copy(newsk, sk);
 
-		newsk->sk_prot_creator = prot;
+	newsk->sk_prot_creator = prot;
 
-		/* SANITY */
-		if (likely(newsk->sk_net_refcnt))
-			get_net(sock_net(newsk));
-		sk_node_init(&newsk->sk_node);
-		sock_lock_init(newsk);
-		bh_lock_sock(newsk);
-		newsk->sk_backlog.head	= newsk->sk_backlog.tail = NULL;
-		newsk->sk_backlog.len = 0;
+	/* SANITY */
+	if (likely(newsk->sk_net_refcnt))
+		get_net(sock_net(newsk));
+	sk_node_init(&newsk->sk_node);
+	sock_lock_init(newsk);
+	bh_lock_sock(newsk);
+	newsk->sk_backlog.head	= newsk->sk_backlog.tail = NULL;
+	newsk->sk_backlog.len = 0;
 
-		atomic_set(&newsk->sk_rmem_alloc, 0);
-		/*
-		 * sk_wmem_alloc set to one (see sk_free() and sock_wfree())
-		 */
-		refcount_set(&newsk->sk_wmem_alloc, 1);
-		atomic_set(&newsk->sk_omem_alloc, 0);
-		sk_init_common(newsk);
-
-		newsk->sk_dst_cache	= NULL;
-		newsk->sk_dst_pending_confirm = 0;
-		newsk->sk_wmem_queued	= 0;
-		newsk->sk_forward_alloc = 0;
-		atomic_set(&newsk->sk_drops, 0);
-		newsk->sk_send_head	= NULL;
-		newsk->sk_userlocks	= sk->sk_userlocks & ~SOCK_BINDPORT_LOCK;
-		atomic_set(&newsk->sk_zckey, 0);
-
-		sock_reset_flag(newsk, SOCK_DONE);
-
-		/* sk->sk_memcg will be populated at accept() time */
-		newsk->sk_memcg = NULL;
-
-		cgroup_sk_clone(&newsk->sk_cgrp_data);
-
-		rcu_read_lock();
-		filter = rcu_dereference(sk->sk_filter);
-		if (filter != NULL)
-			/* though it's an empty new sock, the charging may fail
-			 * if sysctl_optmem_max was changed between creation of
-			 * original socket and cloning
-			 */
-			is_charged = sk_filter_charge(newsk, filter);
-		RCU_INIT_POINTER(newsk->sk_filter, filter);
-		rcu_read_unlock();
-
-		if (unlikely(!is_charged || xfrm_sk_clone_policy(newsk, sk))) {
-			/* We need to make sure that we don't uncharge the new
-			 * socket if we couldn't charge it in the first place
-			 * as otherwise we uncharge the parent's filter.
-			 */
-			if (!is_charged)
-				RCU_INIT_POINTER(newsk->sk_filter, NULL);
-			sk_free_unlock_clone(newsk);
-			newsk = NULL;
-			goto out;
-		}
-		RCU_INIT_POINTER(newsk->sk_reuseport_cb, NULL);
-
-		if (bpf_sk_storage_clone(sk, newsk)) {
-			sk_free_unlock_clone(newsk);
-			newsk = NULL;
-			goto out;
-		}
-
-		/* Clear sk_user_data if parent had the pointer tagged
-		 * as not suitable for copying when cloning.
-		 */
-		if (sk_user_data_is_nocopy(newsk))
-			newsk->sk_user_data = NULL;
-
-		newsk->sk_err	   = 0;
-		newsk->sk_err_soft = 0;
-		newsk->sk_priority = 0;
-		newsk->sk_incoming_cpu = raw_smp_processor_id();
-		if (likely(newsk->sk_net_refcnt))
-			sock_inuse_add(sock_net(newsk), 1);
-
-		/*
-		 * Before updating sk_refcnt, we must commit prior changes to memory
-		 * (Documentation/RCU/rculist_nulls.rst for details)
+	atomic_set(&newsk->sk_rmem_alloc, 0);
+
+	/* sk_wmem_alloc set to one (see sk_free() and sock_wfree()) */
+	refcount_set(&newsk->sk_wmem_alloc, 1);
+
+	atomic_set(&newsk->sk_omem_alloc, 0);
+	sk_init_common(newsk);
+
+	newsk->sk_dst_cache	= NULL;
+	newsk->sk_dst_pending_confirm = 0;
+	newsk->sk_wmem_queued	= 0;
+	newsk->sk_forward_alloc = 0;
+	atomic_set(&newsk->sk_drops, 0);
+	newsk->sk_send_head	= NULL;
+	newsk->sk_userlocks	= sk->sk_userlocks & ~SOCK_BINDPORT_LOCK;
+	atomic_set(&newsk->sk_zckey, 0);
+
+	sock_reset_flag(newsk, SOCK_DONE);
+
+	/* sk->sk_memcg will be populated at accept() time */
+	newsk->sk_memcg = NULL;
+
+	cgroup_sk_clone(&newsk->sk_cgrp_data);
+
+	rcu_read_lock();
+	filter = rcu_dereference(sk->sk_filter);
+	if (filter != NULL)
+		/* though it's an empty new sock, the charging may fail
+		 * if sysctl_optmem_max was changed between creation of
+		 * original socket and cloning
 		 */
-		smp_wmb();
-		refcount_set(&newsk->sk_refcnt, 2);
-
-		/*
-		 * Increment the counter in the same struct proto as the master
-		 * sock (sk_refcnt_debug_inc uses newsk->sk_prot->socks, that
-		 * is the same as sk->sk_prot->socks, as this field was copied
-		 * with memcpy).
-		 *
-		 * This _changes_ the previous behaviour, where
-		 * tcp_create_openreq_child always was incrementing the
-		 * equivalent to tcp_prot->socks (inet_sock_nr), so this have
-		 * to be taken into account in all callers. -acme
+		is_charged = sk_filter_charge(newsk, filter);
+	RCU_INIT_POINTER(newsk->sk_filter, filter);
+	rcu_read_unlock();
+
+	if (unlikely(!is_charged || xfrm_sk_clone_policy(newsk, sk))) {
+		/* We need to make sure that we don't uncharge the new
+		 * socket if we couldn't charge it in the first place
+		 * as otherwise we uncharge the parent's filter.
 		 */
-		sk_refcnt_debug_inc(newsk);
-		sk_set_socket(newsk, NULL);
-		sk_tx_queue_clear(newsk);
-		RCU_INIT_POINTER(newsk->sk_wq, NULL);
-
-		if (newsk->sk_prot->sockets_allocated)
-			sk_sockets_allocated_inc(newsk);
+		if (!is_charged)
+			RCU_INIT_POINTER(newsk->sk_filter, NULL);
+		sk_free_unlock_clone(newsk);
+		newsk = NULL;
+		goto out;
+	}
+	RCU_INIT_POINTER(newsk->sk_reuseport_cb, NULL);
 
-		if (sock_needs_netstamp(sk) &&
-		    newsk->sk_flags & SK_FLAGS_TIMESTAMP)
-			net_enable_timestamp();
+	if (bpf_sk_storage_clone(sk, newsk)) {
+		sk_free_unlock_clone(newsk);
+		newsk = NULL;
+		goto out;
 	}
+
+	/* Clear sk_user_data if parent had the pointer tagged
+	 * as not suitable for copying when cloning.
+	 */
+	if (sk_user_data_is_nocopy(newsk))
+		newsk->sk_user_data = NULL;
+
+	newsk->sk_err	   = 0;
+	newsk->sk_err_soft = 0;
+	newsk->sk_priority = 0;
+	newsk->sk_incoming_cpu = raw_smp_processor_id();
+	if (likely(newsk->sk_net_refcnt))
+		sock_inuse_add(sock_net(newsk), 1);
+
+	/* Before updating sk_refcnt, we must commit prior changes to memory
+	 * (Documentation/RCU/rculist_nulls.rst for details)
+	 */
+	smp_wmb();
+	refcount_set(&newsk->sk_refcnt, 2);
+
+	/* Increment the counter in the same struct proto as the master
+	 * sock (sk_refcnt_debug_inc uses newsk->sk_prot->socks, that
+	 * is the same as sk->sk_prot->socks, as this field was copied
+	 * with memcpy).
+	 *
+	 * This _changes_ the previous behaviour, where
+	 * tcp_create_openreq_child always was incrementing the
+	 * equivalent to tcp_prot->socks (inet_sock_nr), so this have
+	 * to be taken into account in all callers. -acme
+	 */
+	sk_refcnt_debug_inc(newsk);
+	sk_set_socket(newsk, NULL);
+	sk_tx_queue_clear(newsk);
+	RCU_INIT_POINTER(newsk->sk_wq, NULL);
+
+	if (newsk->sk_prot->sockets_allocated)
+		sk_sockets_allocated_inc(newsk);
+
+	if (sock_needs_netstamp(sk) && newsk->sk_flags & SK_FLAGS_TIMESTAMP)
+		net_enable_timestamp();
 out:
 	return newsk;
 }
-- 
2.30.0.280.ga3ce27912f-goog

