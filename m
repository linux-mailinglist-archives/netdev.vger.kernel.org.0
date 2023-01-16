Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A5E66CFF7
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 21:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233175AbjAPUPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 15:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbjAPUPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 15:15:12 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E85523DB9
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 12:15:10 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id f12-20020a7bc8cc000000b003daf6b2f9b9so3412542wml.3
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 12:15:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W9IuZSSGRVZfqc0uwsTQaNNx3sjy+h0W9pWP413z0cw=;
        b=bRyhHljVwOifTNCgT/q0cALqSbwUHCIIL6eIAtJUXrARQpCrHRY0lVoi0XjVOBUsYW
         cf6LcFCdm4GtNEO0sUf73d24mYEbRqbnsqddqDbSwt0TcjIBY5kG4nxfQYtS4ix+yjEo
         nYn5aMMOTdHbOgont4hvd39CgOqqJKWuqSDuVE2hlAmHXjpZ7vEfgtAmzJaWyJ0GiXl8
         gTWqubB+c6LFI1cxVbRYO7d6evswuA3j7g3szaYdpNhyKtKKzIrZwaXcPG2Bd0DvcUDT
         lI6exFIAbu/nJfx18v/EK2g/pzcyT8vMP++/AXqn5xG1vY64i73dK94CdM/v6iV1rkAh
         rEww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W9IuZSSGRVZfqc0uwsTQaNNx3sjy+h0W9pWP413z0cw=;
        b=XkIsZfR9xH1FjwaoReddc7NMkDWusi5q4kcRQdtJDzo17U0U5jd/4cuz19OdMa7Yp5
         Gm/93zyv1C9SjQIFm/E8vA6TYma/QpSSkEd2V9cDZykQ+G4SEg3EdYbyGxTgr/MiesO0
         M/Y9kBnxdvHedpe8mimU05Yi2AoXcxCxgzJcithvV3DgjFGgzOUEBXw0bM1yeRBqxaxD
         RWbSNUx8zSJ2QJQZQG/bvBkRcPzukogctukr5OmsQ7g27FB4od3pzsIiFMOJQt5WL5jS
         sJJp1QOwIFwI7cbX0mPjjqBNZxKbntmwILTqyeQCL+VJ8I74cW6EOOKzSJVBbfdmVll+
         LhhQ==
X-Gm-Message-State: AFqh2kpxhUCVUsv++J/NuP7cRr/ZaNQ8oa488LwrEQLIQ5AXUcL7eB8h
        V69Vxa+UJZ2YB2ylc8HQBsJePA==
X-Google-Smtp-Source: AMrXdXsV/5zTGHA0bcK9fBYldIA64SubJYNQ+IM5Agej0QOyWnE4214qwHtFwt0FzWBjja7CAGeuLQ==
X-Received: by 2002:a05:600c:4c21:b0:3cf:900c:de6b with SMTP id d33-20020a05600c4c2100b003cf900cde6bmr666606wmp.15.1673900108777;
        Mon, 16 Jan 2023 12:15:08 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id bh13-20020a05600c3d0d00b003d358beab9dsm34549829wmb.47.2023.01.16.12.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 12:15:08 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v3 2/4] crypto/net/tcp: Use crypto_pool for TCP-MD5
Date:   Mon, 16 Jan 2023 20:14:56 +0000
Message-Id: <20230116201458.104260-3-dima@arista.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116201458.104260-1-dima@arista.com>
References: <20230116201458.104260-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use crypto_pool API that was designed with tcp_md5sig_pool in mind.
The conversion to use crypto_pool will allow:
- to reuse ahash_request(s) for different users
- to allocate only one per-CPU scratch buffer rather than a new one for
  each user
- to have a common API for net/ users that need ahash on RX/TX fast path

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp.h        |  24 +++------
 net/ipv4/Kconfig         |   1 +
 net/ipv4/tcp.c           | 104 ++++++++++-----------------------------
 net/ipv4/tcp_ipv4.c      | 100 +++++++++++++++++++++----------------
 net/ipv4/tcp_minisocks.c |  21 +++++---
 net/ipv6/tcp_ipv6.c      |  61 +++++++++++------------
 6 files changed, 135 insertions(+), 176 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index db9f828e9d1e..048057cb4c2e 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1664,12 +1664,6 @@ union tcp_md5sum_block {
 #endif
 };
 
-/* - pool: digest algorithm, hash description and scratch buffer */
-struct tcp_md5sig_pool {
-	struct ahash_request	*md5_req;
-	void			*scratch;
-};
-
 /* - functions */
 int tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
 			const struct sock *sk, const struct sk_buff *skb);
@@ -1725,17 +1719,15 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 #define tcp_twsk_md5_key(twsk)	NULL
 #endif
 
-bool tcp_alloc_md5sig_pool(void);
-
-struct tcp_md5sig_pool *tcp_get_md5sig_pool(void);
-static inline void tcp_put_md5sig_pool(void)
-{
-	local_bh_enable();
-}
+struct crypto_pool_ahash;
+int tcp_md5_alloc_crypto_pool(void);
+void tcp_md5_release_crypto_pool(void);
+void tcp_md5_add_crypto_pool(void);
+extern int tcp_md5_crypto_pool_id;
 
-int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *, const struct sk_buff *,
-			  unsigned int header_len);
-int tcp_md5_hash_key(struct tcp_md5sig_pool *hp,
+int tcp_md5_hash_skb_data(struct crypto_pool_ahash *hp,
+			  const struct sk_buff *skb, unsigned int header_len);
+int tcp_md5_hash_key(struct crypto_pool_ahash *hp,
 		     const struct tcp_md5sig_key *key);
 
 /* From tcp_fastopen.c */
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 2dfb12230f08..7e851ec0fc0e 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -744,6 +744,7 @@ config DEFAULT_TCP_CONG
 config TCP_MD5SIG
 	bool "TCP: MD5 Signature Option support (RFC2385)"
 	select CRYPTO
+	select CRYPTO_POOL
 	select CRYPTO_MD5
 	help
 	  RFC2385 specifies a method of giving MD5 protection to TCP sessions.
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index c567d5e8053e..e226771f5985 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -244,6 +244,7 @@
 #define pr_fmt(fmt) "TCP: " fmt
 
 #include <crypto/hash.h>
+#include <crypto/pool.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/types.h>
@@ -4411,98 +4412,42 @@ int tcp_getsockopt(struct sock *sk, int level, int optname, char __user *optval,
 EXPORT_SYMBOL(tcp_getsockopt);
 
 #ifdef CONFIG_TCP_MD5SIG
-static DEFINE_PER_CPU(struct tcp_md5sig_pool, tcp_md5sig_pool);
-static DEFINE_MUTEX(tcp_md5sig_mutex);
-static bool tcp_md5sig_pool_populated = false;
+int tcp_md5_crypto_pool_id = -1;
+EXPORT_SYMBOL(tcp_md5_crypto_pool_id);
 
-static void __tcp_alloc_md5sig_pool(void)
+int tcp_md5_alloc_crypto_pool(void)
 {
-	struct crypto_ahash *hash;
-	int cpu;
-
-	hash = crypto_alloc_ahash("md5", 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(hash))
-		return;
-
-	for_each_possible_cpu(cpu) {
-		void *scratch = per_cpu(tcp_md5sig_pool, cpu).scratch;
-		struct ahash_request *req;
-
-		if (!scratch) {
-			scratch = kmalloc_node(sizeof(union tcp_md5sum_block) +
-					       sizeof(struct tcphdr),
-					       GFP_KERNEL,
-					       cpu_to_node(cpu));
-			if (!scratch)
-				return;
-			per_cpu(tcp_md5sig_pool, cpu).scratch = scratch;
-		}
-		if (per_cpu(tcp_md5sig_pool, cpu).md5_req)
-			continue;
-
-		req = ahash_request_alloc(hash, GFP_KERNEL);
-		if (!req)
-			return;
-
-		ahash_request_set_callback(req, 0, NULL, NULL);
+	size_t scratch_size;
+	int ret;
 
-		per_cpu(tcp_md5sig_pool, cpu).md5_req = req;
+	scratch_size = sizeof(union tcp_md5sum_block) + sizeof(struct tcphdr);
+	ret = crypto_pool_alloc_ahash("md5", scratch_size);
+	if (ret >= 0) {
+		tcp_md5_crypto_pool_id = ret;
+		return 0;
 	}
-	/* before setting tcp_md5sig_pool_populated, we must commit all writes
-	 * to memory. See smp_rmb() in tcp_get_md5sig_pool()
-	 */
-	smp_wmb();
-	/* Paired with READ_ONCE() from tcp_alloc_md5sig_pool()
-	 * and tcp_get_md5sig_pool().
-	*/
-	WRITE_ONCE(tcp_md5sig_pool_populated, true);
+	return ret;
 }
+EXPORT_SYMBOL(tcp_md5_alloc_crypto_pool);
 
-bool tcp_alloc_md5sig_pool(void)
+void tcp_md5_release_crypto_pool(void)
 {
-	/* Paired with WRITE_ONCE() from __tcp_alloc_md5sig_pool() */
-	if (unlikely(!READ_ONCE(tcp_md5sig_pool_populated))) {
-		mutex_lock(&tcp_md5sig_mutex);
-
-		if (!tcp_md5sig_pool_populated)
-			__tcp_alloc_md5sig_pool();
-
-		mutex_unlock(&tcp_md5sig_mutex);
-	}
-	/* Paired with WRITE_ONCE() from __tcp_alloc_md5sig_pool() */
-	return READ_ONCE(tcp_md5sig_pool_populated);
+	crypto_pool_release(tcp_md5_crypto_pool_id);
 }
-EXPORT_SYMBOL(tcp_alloc_md5sig_pool);
+EXPORT_SYMBOL(tcp_md5_release_crypto_pool);
 
-
-/**
- *	tcp_get_md5sig_pool - get md5sig_pool for this user
- *
- *	We use percpu structure, so if we succeed, we exit with preemption
- *	and BH disabled, to make sure another thread or softirq handling
- *	wont try to get same context.
- */
-struct tcp_md5sig_pool *tcp_get_md5sig_pool(void)
+void tcp_md5_add_crypto_pool(void)
 {
-	local_bh_disable();
-
-	/* Paired with WRITE_ONCE() from __tcp_alloc_md5sig_pool() */
-	if (READ_ONCE(tcp_md5sig_pool_populated)) {
-		/* coupled with smp_wmb() in __tcp_alloc_md5sig_pool() */
-		smp_rmb();
-		return this_cpu_ptr(&tcp_md5sig_pool);
-	}
-	local_bh_enable();
-	return NULL;
+	crypto_pool_get(tcp_md5_crypto_pool_id);
 }
-EXPORT_SYMBOL(tcp_get_md5sig_pool);
+EXPORT_SYMBOL(tcp_md5_add_crypto_pool);
 
-int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *hp,
+int tcp_md5_hash_skb_data(struct crypto_pool_ahash *hp,
 			  const struct sk_buff *skb, unsigned int header_len)
 {
 	struct scatterlist sg;
 	const struct tcphdr *tp = tcp_hdr(skb);
-	struct ahash_request *req = hp->md5_req;
+	struct ahash_request *req = hp->req;
 	unsigned int i;
 	const unsigned int head_data_len = skb_headlen(skb) > header_len ?
 					   skb_headlen(skb) - header_len : 0;
@@ -4536,16 +4481,17 @@ int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *hp,
 }
 EXPORT_SYMBOL(tcp_md5_hash_skb_data);
 
-int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct tcp_md5sig_key *key)
+int tcp_md5_hash_key(struct crypto_pool_ahash *hp,
+		     const struct tcp_md5sig_key *key)
 {
 	u8 keylen = READ_ONCE(key->keylen); /* paired with WRITE_ONCE() in tcp_md5_do_add */
 	struct scatterlist sg;
 
 	sg_init_one(&sg, key->key, keylen);
-	ahash_request_set_crypt(hp->md5_req, &sg, NULL, keylen);
+	ahash_request_set_crypt(hp->req, &sg, NULL, keylen);
 
 	/* We use data_race() because tcp_md5_do_add() might change key->key under us */
-	return data_race(crypto_ahash_update(hp->md5_req));
+	return data_race(crypto_ahash_update(hp->req));
 }
 EXPORT_SYMBOL(tcp_md5_hash_key);
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 8320d0ecb13a..53938e080c5f 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -79,6 +79,7 @@
 #include <linux/btf_ids.h>
 
 #include <crypto/hash.h>
+#include <crypto/pool.h>
 #include <linux/scatterlist.h>
 
 #include <trace/events/tcp.h>
@@ -1212,10 +1213,6 @@ static int __tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 	key = sock_kmalloc(sk, sizeof(*key), gfp | __GFP_ZERO);
 	if (!key)
 		return -ENOMEM;
-	if (!tcp_alloc_md5sig_pool()) {
-		sock_kfree_s(sk, key, sizeof(*key));
-		return -ENOMEM;
-	}
 
 	memcpy(key->key, newkey, newkeylen);
 	key->keylen = newkeylen;
@@ -1237,8 +1234,13 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 	struct tcp_sock *tp = tcp_sk(sk);
 
 	if (!rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk))) {
-		if (tcp_md5sig_info_add(sk, GFP_KERNEL))
+		if (tcp_md5_alloc_crypto_pool())
+			return -ENOMEM;
+
+		if (tcp_md5sig_info_add(sk, GFP_KERNEL)) {
+			tcp_md5_release_crypto_pool();
 			return -ENOMEM;
+		}
 
 		if (!static_branch_inc(&tcp_md5_needed.key)) {
 			struct tcp_md5sig_info *md5sig;
@@ -1246,6 +1248,7 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 			md5sig = rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk));
 			rcu_assign_pointer(tp->md5sig_info, NULL);
 			kfree_rcu(md5sig, rcu);
+			tcp_md5_release_crypto_pool();
 			return -EUSERS;
 		}
 	}
@@ -1262,8 +1265,12 @@ int tcp_md5_key_copy(struct sock *sk, const union tcp_md5_addr *addr,
 	struct tcp_sock *tp = tcp_sk(sk);
 
 	if (!rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk))) {
-		if (tcp_md5sig_info_add(sk, sk_gfp_mask(sk, GFP_ATOMIC)))
+		tcp_md5_add_crypto_pool();
+
+		if (tcp_md5sig_info_add(sk, sk_gfp_mask(sk, GFP_ATOMIC))) {
+			tcp_md5_release_crypto_pool();
 			return -ENOMEM;
+		}
 
 		if (!static_key_fast_inc_not_disabled(&tcp_md5_needed.key.key)) {
 			struct tcp_md5sig_info *md5sig;
@@ -1272,6 +1279,7 @@ int tcp_md5_key_copy(struct sock *sk, const union tcp_md5_addr *addr,
 			net_warn_ratelimited("Too many TCP-MD5 keys in the system\n");
 			rcu_assign_pointer(tp->md5sig_info, NULL);
 			kfree_rcu(md5sig, rcu);
+			tcp_md5_release_crypto_pool();
 			return -EUSERS;
 		}
 	}
@@ -1371,7 +1379,7 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
 			      cmd.tcpm_key, cmd.tcpm_keylen);
 }
 
-static int tcp_v4_md5_hash_headers(struct tcp_md5sig_pool *hp,
+static int tcp_v4_md5_hash_headers(struct crypto_pool_ahash *hp,
 				   __be32 daddr, __be32 saddr,
 				   const struct tcphdr *th, int nbytes)
 {
@@ -1379,7 +1387,7 @@ static int tcp_v4_md5_hash_headers(struct tcp_md5sig_pool *hp,
 	struct scatterlist sg;
 	struct tcphdr *_th;
 
-	bp = hp->scratch;
+	bp = hp->base.scratch;
 	bp->saddr = saddr;
 	bp->daddr = daddr;
 	bp->pad = 0;
@@ -1391,38 +1399,35 @@ static int tcp_v4_md5_hash_headers(struct tcp_md5sig_pool *hp,
 	_th->check = 0;
 
 	sg_init_one(&sg, bp, sizeof(*bp) + sizeof(*th));
-	ahash_request_set_crypt(hp->md5_req, &sg, NULL,
+	ahash_request_set_crypt(hp->req, &sg, NULL,
 				sizeof(*bp) + sizeof(*th));
-	return crypto_ahash_update(hp->md5_req);
+	return crypto_ahash_update(hp->req);
 }
 
 static int tcp_v4_md5_hash_hdr(char *md5_hash, const struct tcp_md5sig_key *key,
 			       __be32 daddr, __be32 saddr, const struct tcphdr *th)
 {
-	struct tcp_md5sig_pool *hp;
-	struct ahash_request *req;
+	struct crypto_pool_ahash hp;
 
-	hp = tcp_get_md5sig_pool();
-	if (!hp)
-		goto clear_hash_noput;
-	req = hp->md5_req;
+	if (crypto_pool_start(tcp_md5_crypto_pool_id, &hp.base))
+		goto clear_hash_nostart;
 
-	if (crypto_ahash_init(req))
+	if (crypto_ahash_init(hp.req))
 		goto clear_hash;
-	if (tcp_v4_md5_hash_headers(hp, daddr, saddr, th, th->doff << 2))
+	if (tcp_v4_md5_hash_headers(&hp, daddr, saddr, th, th->doff << 2))
 		goto clear_hash;
-	if (tcp_md5_hash_key(hp, key))
+	if (tcp_md5_hash_key(&hp, key))
 		goto clear_hash;
-	ahash_request_set_crypt(req, NULL, md5_hash, 0);
-	if (crypto_ahash_final(req))
+	ahash_request_set_crypt(hp.req, NULL, md5_hash, 0);
+	if (crypto_ahash_final(hp.req))
 		goto clear_hash;
 
-	tcp_put_md5sig_pool();
+	crypto_pool_end();
 	return 0;
 
 clear_hash:
-	tcp_put_md5sig_pool();
-clear_hash_noput:
+	crypto_pool_end();
+clear_hash_nostart:
 	memset(md5_hash, 0, 16);
 	return 1;
 }
@@ -1431,8 +1436,7 @@ int tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
 			const struct sock *sk,
 			const struct sk_buff *skb)
 {
-	struct tcp_md5sig_pool *hp;
-	struct ahash_request *req;
+	struct crypto_pool_ahash hp;
 	const struct tcphdr *th = tcp_hdr(skb);
 	__be32 saddr, daddr;
 
@@ -1445,30 +1449,28 @@ int tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
 		daddr = iph->daddr;
 	}
 
-	hp = tcp_get_md5sig_pool();
-	if (!hp)
-		goto clear_hash_noput;
-	req = hp->md5_req;
+	if (crypto_pool_start(tcp_md5_crypto_pool_id, &hp.base))
+		goto clear_hash_nostart;
 
-	if (crypto_ahash_init(req))
+	if (crypto_ahash_init(hp.req))
 		goto clear_hash;
 
-	if (tcp_v4_md5_hash_headers(hp, daddr, saddr, th, skb->len))
+	if (tcp_v4_md5_hash_headers(&hp, daddr, saddr, th, skb->len))
 		goto clear_hash;
-	if (tcp_md5_hash_skb_data(hp, skb, th->doff << 2))
+	if (tcp_md5_hash_skb_data(&hp, skb, th->doff << 2))
 		goto clear_hash;
-	if (tcp_md5_hash_key(hp, key))
+	if (tcp_md5_hash_key(&hp, key))
 		goto clear_hash;
-	ahash_request_set_crypt(req, NULL, md5_hash, 0);
-	if (crypto_ahash_final(req))
+	ahash_request_set_crypt(hp.req, NULL, md5_hash, 0);
+	if (crypto_ahash_final(hp.req))
 		goto clear_hash;
 
-	tcp_put_md5sig_pool();
+	crypto_pool_end();
 	return 0;
 
 clear_hash:
-	tcp_put_md5sig_pool();
-clear_hash_noput:
+	crypto_pool_end();
+clear_hash_nostart:
 	memset(md5_hash, 0, 16);
 	return 1;
 }
@@ -2285,6 +2287,18 @@ static int tcp_v4_init_sock(struct sock *sk)
 	return 0;
 }
 
+#ifdef CONFIG_TCP_MD5SIG
+static void tcp_md5sig_info_free_rcu(struct rcu_head *head)
+{
+	struct tcp_md5sig_info *md5sig;
+
+	md5sig = container_of(head, struct tcp_md5sig_info, rcu);
+	kfree(md5sig);
+	static_branch_slow_dec_deferred(&tcp_md5_needed);
+	tcp_md5_release_crypto_pool();
+}
+#endif
+
 void tcp_v4_destroy_sock(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
@@ -2309,10 +2323,12 @@ void tcp_v4_destroy_sock(struct sock *sk)
 #ifdef CONFIG_TCP_MD5SIG
 	/* Clean up the MD5 key list, if any */
 	if (tp->md5sig_info) {
+		struct tcp_md5sig_info *md5sig;
+
+		md5sig = rcu_dereference_protected(tp->md5sig_info, 1);
 		tcp_clear_md5_list(sk);
-		kfree_rcu(rcu_dereference_protected(tp->md5sig_info, 1), rcu);
-		tp->md5sig_info = NULL;
-		static_branch_slow_dec_deferred(&tcp_md5_needed);
+		call_rcu(&md5sig->rcu, tcp_md5sig_info_free_rcu);
+		rcu_assign_pointer(tp->md5sig_info, NULL);
 	}
 #endif
 
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index e002f2e1d4f2..6fbf2d4a4a97 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -261,10 +261,9 @@ static void tcp_time_wait_init(struct sock *sk, struct tcp_timewait_sock *tcptw)
 		tcptw->tw_md5_key = kmemdup(key, sizeof(*key), GFP_ATOMIC);
 		if (!tcptw->tw_md5_key)
 			return;
-		if (!tcp_alloc_md5sig_pool())
-			goto out_free;
 		if (!static_key_fast_inc_not_disabled(&tcp_md5_needed.key.key))
 			goto out_free;
+		tcp_md5_add_crypto_pool();
 	}
 	return;
 out_free:
@@ -349,16 +348,26 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
 }
 EXPORT_SYMBOL(tcp_time_wait);
 
+#ifdef CONFIG_TCP_MD5SIG
+static void tcp_md5_twsk_free_rcu(struct rcu_head *head)
+{
+	struct tcp_md5sig_key *key;
+
+	key = container_of(head, struct tcp_md5sig_key, rcu);
+	kfree(key);
+	static_branch_slow_dec_deferred(&tcp_md5_needed);
+	tcp_md5_release_crypto_pool();
+}
+#endif
+
 void tcp_twsk_destructor(struct sock *sk)
 {
 #ifdef CONFIG_TCP_MD5SIG
 	if (static_branch_unlikely(&tcp_md5_needed.key)) {
 		struct tcp_timewait_sock *twsk = tcp_twsk(sk);
 
-		if (twsk->tw_md5_key) {
-			kfree_rcu(twsk->tw_md5_key, rcu);
-			static_branch_slow_dec_deferred(&tcp_md5_needed);
-		}
+		if (twsk->tw_md5_key)
+			call_rcu(&twsk->tw_md5_key->rcu, tcp_md5_twsk_free_rcu);
 	}
 #endif
 }
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 11b736a76bd7..eb02224c7725 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -64,6 +64,7 @@
 #include <linux/seq_file.h>
 
 #include <crypto/hash.h>
+#include <crypto/pool.h>
 #include <linux/scatterlist.h>
 
 #include <trace/events/tcp.h>
@@ -672,7 +673,7 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 			      cmd.tcpm_key, cmd.tcpm_keylen);
 }
 
-static int tcp_v6_md5_hash_headers(struct tcp_md5sig_pool *hp,
+static int tcp_v6_md5_hash_headers(struct crypto_pool_ahash *hp,
 				   const struct in6_addr *daddr,
 				   const struct in6_addr *saddr,
 				   const struct tcphdr *th, int nbytes)
@@ -681,7 +682,7 @@ static int tcp_v6_md5_hash_headers(struct tcp_md5sig_pool *hp,
 	struct scatterlist sg;
 	struct tcphdr *_th;
 
-	bp = hp->scratch;
+	bp = hp->base.scratch;
 	/* 1. TCP pseudo-header (RFC2460) */
 	bp->saddr = *saddr;
 	bp->daddr = *daddr;
@@ -693,39 +694,36 @@ static int tcp_v6_md5_hash_headers(struct tcp_md5sig_pool *hp,
 	_th->check = 0;
 
 	sg_init_one(&sg, bp, sizeof(*bp) + sizeof(*th));
-	ahash_request_set_crypt(hp->md5_req, &sg, NULL,
+	ahash_request_set_crypt(hp->req, &sg, NULL,
 				sizeof(*bp) + sizeof(*th));
-	return crypto_ahash_update(hp->md5_req);
+	return crypto_ahash_update(hp->req);
 }
 
 static int tcp_v6_md5_hash_hdr(char *md5_hash, const struct tcp_md5sig_key *key,
 			       const struct in6_addr *daddr, struct in6_addr *saddr,
 			       const struct tcphdr *th)
 {
-	struct tcp_md5sig_pool *hp;
-	struct ahash_request *req;
+	struct crypto_pool_ahash hp;
 
-	hp = tcp_get_md5sig_pool();
-	if (!hp)
-		goto clear_hash_noput;
-	req = hp->md5_req;
+	if (crypto_pool_start(tcp_md5_crypto_pool_id, &hp.base))
+		goto clear_hash_nostart;
 
-	if (crypto_ahash_init(req))
+	if (crypto_ahash_init(hp.req))
 		goto clear_hash;
-	if (tcp_v6_md5_hash_headers(hp, daddr, saddr, th, th->doff << 2))
+	if (tcp_v6_md5_hash_headers(&hp, daddr, saddr, th, th->doff << 2))
 		goto clear_hash;
-	if (tcp_md5_hash_key(hp, key))
+	if (tcp_md5_hash_key(&hp, key))
 		goto clear_hash;
-	ahash_request_set_crypt(req, NULL, md5_hash, 0);
-	if (crypto_ahash_final(req))
+	ahash_request_set_crypt(hp.req, NULL, md5_hash, 0);
+	if (crypto_ahash_final(hp.req))
 		goto clear_hash;
 
-	tcp_put_md5sig_pool();
+	crypto_pool_end();
 	return 0;
 
 clear_hash:
-	tcp_put_md5sig_pool();
-clear_hash_noput:
+	crypto_pool_end();
+clear_hash_nostart:
 	memset(md5_hash, 0, 16);
 	return 1;
 }
@@ -736,8 +734,7 @@ static int tcp_v6_md5_hash_skb(char *md5_hash,
 			       const struct sk_buff *skb)
 {
 	const struct in6_addr *saddr, *daddr;
-	struct tcp_md5sig_pool *hp;
-	struct ahash_request *req;
+	struct crypto_pool_ahash hp;
 	const struct tcphdr *th = tcp_hdr(skb);
 
 	if (sk) { /* valid for establish/request sockets */
@@ -749,30 +746,28 @@ static int tcp_v6_md5_hash_skb(char *md5_hash,
 		daddr = &ip6h->daddr;
 	}
 
-	hp = tcp_get_md5sig_pool();
-	if (!hp)
-		goto clear_hash_noput;
-	req = hp->md5_req;
+	if (crypto_pool_start(tcp_md5_crypto_pool_id, &hp.base))
+		goto clear_hash_nostart;
 
-	if (crypto_ahash_init(req))
+	if (crypto_ahash_init(hp.req))
 		goto clear_hash;
 
-	if (tcp_v6_md5_hash_headers(hp, daddr, saddr, th, skb->len))
+	if (tcp_v6_md5_hash_headers(&hp, daddr, saddr, th, skb->len))
 		goto clear_hash;
-	if (tcp_md5_hash_skb_data(hp, skb, th->doff << 2))
+	if (tcp_md5_hash_skb_data(&hp, skb, th->doff << 2))
 		goto clear_hash;
-	if (tcp_md5_hash_key(hp, key))
+	if (tcp_md5_hash_key(&hp, key))
 		goto clear_hash;
-	ahash_request_set_crypt(req, NULL, md5_hash, 0);
-	if (crypto_ahash_final(req))
+	ahash_request_set_crypt(hp.req, NULL, md5_hash, 0);
+	if (crypto_ahash_final(hp.req))
 		goto clear_hash;
 
-	tcp_put_md5sig_pool();
+	crypto_pool_end();
 	return 0;
 
 clear_hash:
-	tcp_put_md5sig_pool();
-clear_hash_noput:
+	crypto_pool_end();
+clear_hash_nostart:
 	memset(md5_hash, 0, 16);
 	return 1;
 }
-- 
2.39.0

