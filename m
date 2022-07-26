Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEE06581AE2
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 22:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239929AbiGZUQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 16:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239867AbiGZUQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 16:16:22 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C2A32B8F
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 13:16:15 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id q18so11190849wrx.8
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 13:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=Eehr4I6LShNPnqC8iBpwixr+0n5YGJ6W1hkSoL6jCXQ=;
        b=g2/reOHW1eJbSXHaa1DvAMlFs2zXHAgHPrGCu/RS16SCytzEIvFndxzuYNXT4GWYfe
         V7pAkoe4ABpxg1IbikjFCoqATQNRCSO/z1Yycaq3lRakL9NxbpOBZzQxxdihVbMIkwtX
         NZ2E3K7Z+i7HMGZun2Ey/5Rsw4lkCRSO6L8D8y6GODSTOL9UY3Nb/xU6owmj9kwlIWTJ
         u/88DoY1abaAxAy4YWTbM9IAcSWc47wLhx+OKHJ/kHBAGV/lmdmtrAGusT6l3I9McN7x
         Ro+wsqoq7xN+hAUKg39zMUEoAyCGunQioHZSA9Q2ZojXCwRuG99EPd6HlNMM0yfh4FIV
         84Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Eehr4I6LShNPnqC8iBpwixr+0n5YGJ6W1hkSoL6jCXQ=;
        b=49q2ZbGsZFOGNF26j/5tb0drBpzfNT170Zytty01s5Nb2vgLzcsBO3JJakSO2NpbHM
         6Sn2xnEiFRWzrqw8msiypA85L0Fh7CT0+O9kBZE1JOTW/jMr8L6FTFekcU9tWkZuejN8
         UyamvAg3qEDEY4urMyJdNbaIPyN20oyncH653/Nu0jsWFk7bukB6k8JJRAmjmOa3jjvK
         TxLxzazBrwdXRec9zIzoJZ9Kat58F9RrSdbXYmx1NxVopK8BNj91aKSz7QuMrpmSgL5Y
         gkqlXdHoFvN2ZVVNadrI7GY1sxmThkALYTKrBuhnkk2u3sdaFE+mEbH+AVm2glcMa46I
         jpsQ==
X-Gm-Message-State: AJIora/HD47RxQuROWgcbbG4le4Sk+1cAUmkJE4Msp5WMJSpaOtzy/YU
        HnM0zB+oh1HcFDPhEFswqWc5hw==
X-Google-Smtp-Source: AGRyM1uVbzFsXTbvL6A2nOYM6ttwODXmdQywk1yFcQ8V0rwXJHiB0bUjPmQaRKZ/gDlecdLa4vnigw==
X-Received: by 2002:adf:facb:0:b0:21e:4f54:9651 with SMTP id a11-20020adffacb000000b0021e4f549651mr12470112wrs.378.1658866573724;
        Tue, 26 Jul 2022 13:16:13 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id m6-20020a05600c3b0600b003a320e6f011sm28073wms.1.2022.07.26.13.16.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 13:16:13 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH 5/6] net/tcp: Use crypto_pool for TCP-MD5
Date:   Tue, 26 Jul 2022 21:15:59 +0100
Message-Id: <20220726201600.1715505-6-dima@arista.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220726201600.1715505-1-dima@arista.com>
References: <20220726201600.1715505-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 include/net/tcp.h        | 22 +++------
 net/ipv4/Kconfig         |  2 +-
 net/ipv4/tcp.c           | 99 +++++++++++-----------------------------
 net/ipv4/tcp_ipv4.c      | 90 +++++++++++++++++++++---------------
 net/ipv4/tcp_minisocks.c | 22 +++++++--
 net/ipv6/tcp_ipv6.c      | 53 ++++++++++-----------
 6 files changed, 127 insertions(+), 161 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index aa735f963723..7060dd1cf6cd 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1652,12 +1652,6 @@ union tcp_md5sum_block {
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
@@ -1713,17 +1707,15 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
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
+int tcp_md5_hash_skb_data(struct crypto_pool_ahash *, const struct sk_buff *,
 			  unsigned int header_len);
-int tcp_md5_hash_key(struct tcp_md5sig_pool *hp,
+int tcp_md5_hash_key(struct crypto_pool_ahash *hp,
 		     const struct tcp_md5sig_key *key);
 
 /* From tcp_fastopen.c */
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index e983bb0c5012..c341864e4398 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -733,7 +733,7 @@ config DEFAULT_TCP_CONG
 
 config TCP_MD5SIG
 	bool "TCP: MD5 Signature Option support (RFC2385)"
-	select CRYPTO
+	select CRYPTO_POOL
 	select CRYPTO_MD5
 	help
 	  RFC2385 specifies a method of giving MD5 protection to TCP sessions.
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 300056008e90..73abb00e12bf 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -244,6 +244,7 @@
 #define pr_fmt(fmt) "TCP: " fmt
 
 #include <crypto/hash.h>
+#include <crypto/pool.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/types.h>
@@ -4355,92 +4356,43 @@ int tcp_getsockopt(struct sock *sk, int level, int optname, char __user *optval,
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
+	int ret;
 
-		ahash_request_set_callback(req, 0, NULL, NULL);
+	ret = crypto_pool_reserve_scratch(sizeof(union tcp_md5sum_block) +
+					  sizeof(struct tcphdr));
+	if (ret)
+		return ret;
 
-		per_cpu(tcp_md5sig_pool, cpu).md5_req = req;
-	}
-	/* before setting tcp_md5sig_pool_populated, we must commit all writes
-	 * to memory. See smp_rmb() in tcp_get_md5sig_pool()
-	 */
-	smp_wmb();
-	tcp_md5sig_pool_populated = true;
+	ret = crypto_pool_alloc_ahash("md5");
+	if (ret >= 0)
+		tcp_md5_crypto_pool_id = ret;
+	return ret;
 }
+EXPORT_SYMBOL(tcp_md5_alloc_crypto_pool);
 
-bool tcp_alloc_md5sig_pool(void)
+void tcp_md5_release_crypto_pool(void)
 {
-	if (unlikely(!tcp_md5sig_pool_populated)) {
-		mutex_lock(&tcp_md5sig_mutex);
-
-		if (!tcp_md5sig_pool_populated)
-			__tcp_alloc_md5sig_pool();
-
-		mutex_unlock(&tcp_md5sig_mutex);
-	}
-	return tcp_md5sig_pool_populated;
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
-	if (tcp_md5sig_pool_populated) {
-		/* coupled with smp_wmb() in __tcp_alloc_md5sig_pool() */
-		smp_rmb();
-		return this_cpu_ptr(&tcp_md5sig_pool);
-	}
-	local_bh_enable();
-	return NULL;
+	crypto_pool_add(tcp_md5_crypto_pool_id);
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
@@ -4474,16 +4426,17 @@ int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *hp,
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
index 5b0caaea5029..100e142ed03a 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -79,6 +79,7 @@
 #include <linux/btf_ids.h>
 
 #include <crypto/hash.h>
+#include <crypto/pool.h>
 #include <linux/scatterlist.h>
 
 #include <trace/events/tcp.h>
@@ -1206,10 +1207,6 @@ int __tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 	key = sock_kmalloc(sk, sizeof(*key), gfp | __GFP_ZERO);
 	if (!key)
 		return -ENOMEM;
-	if (!tcp_alloc_md5sig_pool()) {
-		sock_kfree_s(sk, key, sizeof(*key));
-		return -ENOMEM;
-	}
 
 	memcpy(key->key, newkey, newkeylen);
 	key->keylen = newkeylen;
@@ -1228,8 +1225,13 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 		   int family, u8 prefixlen, int l3index, u8 flags,
 		   const u8 *newkey, u8 newkeylen)
 {
-	if (tcp_md5sig_info_add(sk, GFP_KERNEL))
+	if (tcp_md5_alloc_crypto_pool())
+		return -ENOMEM;
+
+	if (tcp_md5sig_info_add(sk, GFP_KERNEL)) {
+		tcp_md5_release_crypto_pool();
 		return -ENOMEM;
+	}
 
 	static_branch_inc(&tcp_md5_needed.key);
 
@@ -1242,8 +1244,12 @@ int tcp_md5_key_copy(struct sock *sk, const union tcp_md5_addr *addr,
 		     int family, u8 prefixlen, int l3index,
 		     struct tcp_md5sig_key *key)
 {
-	if (tcp_md5sig_info_add(sk, sk_gfp_mask(sk, GFP_ATOMIC)))
+	tcp_md5_add_crypto_pool();
+
+	if (tcp_md5sig_info_add(sk, sk_gfp_mask(sk, GFP_ATOMIC))) {
+		tcp_md5_release_crypto_pool();
 		return -ENOMEM;
+	}
 
 	atomic_inc(&tcp_md5_needed.key.key.enabled);
 
@@ -1342,7 +1348,7 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
 			      cmd.tcpm_key, cmd.tcpm_keylen);
 }
 
-static int tcp_v4_md5_hash_headers(struct tcp_md5sig_pool *hp,
+static int tcp_v4_md5_hash_headers(struct crypto_pool_ahash *hp,
 				   __be32 daddr, __be32 saddr,
 				   const struct tcphdr *th, int nbytes)
 {
@@ -1350,7 +1356,7 @@ static int tcp_v4_md5_hash_headers(struct tcp_md5sig_pool *hp,
 	struct scatterlist sg;
 	struct tcphdr *_th;
 
-	bp = hp->scratch;
+	bp = hp->base.scratch;
 	bp->saddr = saddr;
 	bp->daddr = daddr;
 	bp->pad = 0;
@@ -1362,37 +1368,34 @@ static int tcp_v4_md5_hash_headers(struct tcp_md5sig_pool *hp,
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
+	if (crypto_pool_get(tcp_md5_crypto_pool_id, (struct crypto_pool *)&hp))
 		goto clear_hash_noput;
-	req = hp->md5_req;
 
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
+	crypto_pool_put();
 	return 0;
 
 clear_hash:
-	tcp_put_md5sig_pool();
+	crypto_pool_put();
 clear_hash_noput:
 	memset(md5_hash, 0, 16);
 	return 1;
@@ -1402,8 +1405,7 @@ int tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
 			const struct sock *sk,
 			const struct sk_buff *skb)
 {
-	struct tcp_md5sig_pool *hp;
-	struct ahash_request *req;
+	struct crypto_pool_ahash hp;
 	const struct tcphdr *th = tcp_hdr(skb);
 	__be32 saddr, daddr;
 
@@ -1416,29 +1418,27 @@ int tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
 		daddr = iph->daddr;
 	}
 
-	hp = tcp_get_md5sig_pool();
-	if (!hp)
+	if (crypto_pool_get(tcp_md5_crypto_pool_id, (struct crypto_pool *)&hp))
 		goto clear_hash_noput;
-	req = hp->md5_req;
 
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
+	crypto_pool_put();
 	return 0;
 
 clear_hash:
-	tcp_put_md5sig_pool();
+	crypto_pool_put();
 clear_hash_noput:
 	memset(md5_hash, 0, 16);
 	return 1;
@@ -2257,6 +2257,18 @@ static int tcp_v4_init_sock(struct sock *sk)
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
@@ -2281,10 +2293,12 @@ void tcp_v4_destroy_sock(struct sock *sk)
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
index 5d475a45a478..d1d30337ffec 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -297,8 +297,10 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
 				key = tp->af_specific->md5_lookup(sk, sk);
 				if (key) {
 					tcptw->tw_md5_key = kmemdup(key, sizeof(*key), GFP_ATOMIC);
-					BUG_ON(tcptw->tw_md5_key && !tcp_alloc_md5sig_pool());
+					if (WARN_ON(!tcptw->tw_md5_key))
+						break;
 					atomic_inc(&tcp_md5_needed.key.key.enabled);
+					tcp_md5_add_crypto_pool();
 				}
 			}
 		} while (0);
@@ -335,16 +337,26 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
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
index cb891a71db0d..f75569f889e7 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -64,6 +64,7 @@
 #include <linux/seq_file.h>
 
 #include <crypto/hash.h>
+#include <crypto/pool.h>
 #include <linux/scatterlist.h>
 
 #include <trace/events/tcp.h>
@@ -665,7 +666,7 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 			      cmd.tcpm_key, cmd.tcpm_keylen);
 }
 
-static int tcp_v6_md5_hash_headers(struct tcp_md5sig_pool *hp,
+static int tcp_v6_md5_hash_headers(struct crypto_pool_ahash *hp,
 				   const struct in6_addr *daddr,
 				   const struct in6_addr *saddr,
 				   const struct tcphdr *th, int nbytes)
@@ -674,7 +675,7 @@ static int tcp_v6_md5_hash_headers(struct tcp_md5sig_pool *hp,
 	struct scatterlist sg;
 	struct tcphdr *_th;
 
-	bp = hp->scratch;
+	bp = hp->base.scratch;
 	/* 1. TCP pseudo-header (RFC2460) */
 	bp->saddr = *saddr;
 	bp->daddr = *daddr;
@@ -686,38 +687,35 @@ static int tcp_v6_md5_hash_headers(struct tcp_md5sig_pool *hp,
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
+	if (crypto_pool_get(tcp_md5_crypto_pool_id, (struct crypto_pool *)&hp))
 		goto clear_hash_noput;
-	req = hp->md5_req;
 
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
+	crypto_pool_put();
 	return 0;
 
 clear_hash:
-	tcp_put_md5sig_pool();
+	crypto_pool_put();
 clear_hash_noput:
 	memset(md5_hash, 0, 16);
 	return 1;
@@ -729,8 +727,7 @@ static int tcp_v6_md5_hash_skb(char *md5_hash,
 			       const struct sk_buff *skb)
 {
 	const struct in6_addr *saddr, *daddr;
-	struct tcp_md5sig_pool *hp;
-	struct ahash_request *req;
+	struct crypto_pool_ahash hp;
 	const struct tcphdr *th = tcp_hdr(skb);
 
 	if (sk) { /* valid for establish/request sockets */
@@ -742,29 +739,27 @@ static int tcp_v6_md5_hash_skb(char *md5_hash,
 		daddr = &ip6h->daddr;
 	}
 
-	hp = tcp_get_md5sig_pool();
-	if (!hp)
+	if (crypto_pool_get(tcp_md5_crypto_pool_id, (struct crypto_pool *)&hp))
 		goto clear_hash_noput;
-	req = hp->md5_req;
 
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
+	crypto_pool_put();
 	return 0;
 
 clear_hash:
-	tcp_put_md5sig_pool();
+	crypto_pool_put();
 clear_hash_noput:
 	memset(md5_hash, 0, 16);
 	return 1;
-- 
2.36.1

