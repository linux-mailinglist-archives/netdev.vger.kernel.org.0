Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17EC1610300
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 22:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236933AbiJ0Uoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 16:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236849AbiJ0UoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 16:44:19 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7539082D
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:44:03 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id w14so4154320wru.8
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZrgLizh1C804U+r+l0m4Xy4SPh4jwBzIG8ijp90cT4Y=;
        b=cMCDxmxxsZyQWMfJGv73+N3+AZl+yd10NZc02gpC82WJ/iyUbuSbuABQi/4InmIsjN
         kYL2x/3+oCy7hQZktcSpgkt6XWivU/rbc5ZY782YsRkR2ZNhHXI7HUVo04/IS0PYk/OY
         6kxmhI/7aoJLLWBnk7Y1pxvLhr89RBEQKsRj1OkCoSSzrA2SsXrjF9P43vp2nDMO0AOB
         fq+40H7RszKEYf/ikNxqqmAFvN3Jj5f7FQfvN0BDuddCEyondAd7gxqAmVKCJGyzDQhN
         OnXk4Hf0wJHq9KSJKtN4d5Zxn2Yf3wnQbRpRDstixVYBR9pCmprfxrQEt2Z9boJ1OPYy
         PxVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZrgLizh1C804U+r+l0m4Xy4SPh4jwBzIG8ijp90cT4Y=;
        b=zg5u5GHDh3kKcZQ92fT3bcVoOztA1M2Y+Jv6O5EUcQSI3J+JYhIRAL6zyOO8k/N2AX
         vWpdlKheGdbOhlRLb1jr0OuLYwmKIX16wjdatu3RJ/ktylehVTepIUEBZGwhZKAGaRy7
         d6B34IcHoQuLQrnVvUQlejmOYvp/6ZIZ9tqjt3qaJsZSGLFUbt1/gOEkYryniVf+0RrI
         fC/Cy3XJ89PmtTCJvp1hzufnINEkrHXqvw3u5iC3EmOlj5WVdnTogKyNfYnVvg0+Jac2
         SWK64hbjDIjo12ex6mlDEbXrx/xrdYG/8GC3d4Aa9eFCsoMDn/eCoav5C01nsLqEKjs/
         NpZw==
X-Gm-Message-State: ACrzQf1SkKoP0EZBXuR5VmBvnowzTeWiU1wqn6VioPMWQiZO3XimmPUQ
        R+ndbL6kMYz3MXodM3i3yc0WkQ==
X-Google-Smtp-Source: AMsMyM7ZrH+7+mXNrgMwKDU7op6xsT4TMj7wvnEbEnL2Ud9S1EYWoNJCzURdfCybIlZQKSuWkqoYlg==
X-Received: by 2002:a05:6000:1866:b0:236:715a:16c1 with SMTP id d6-20020a056000186600b00236715a16c1mr15060104wri.537.1666903442852;
        Thu, 27 Oct 2022 13:44:02 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n3-20020a5d6b83000000b00236644228besm1968739wrx.40.2022.10.27.13.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 13:44:02 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3 05/36] net/tcp: Use crypto_pool for TCP-MD5
Date:   Thu, 27 Oct 2022 21:43:16 +0100
Message-Id: <20221027204347.529913-6-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027204347.529913-1-dima@arista.com>
References: <20221027204347.529913-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 net/ipv4/Kconfig         |   2 +-
 net/ipv4/tcp.c           | 105 ++++++++++-----------------------------
 net/ipv4/tcp_ipv4.c      |  90 +++++++++++++++++++--------------
 net/ipv4/tcp_minisocks.c |  22 ++++++--
 net/ipv6/tcp_ipv6.c      |  53 +++++++++-----------
 6 files changed, 129 insertions(+), 167 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index a0cdf013782a..03dbe1940fec 100644
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
index 936ed566cc89..d6f494f2c350 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -244,6 +244,7 @@
 #define pr_fmt(fmt) "TCP: " fmt
 
 #include <crypto/hash.h>
+#include <crypto/pool.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/types.h>
@@ -4407,98 +4408,45 @@ int tcp_getsockopt(struct sock *sk, int level, int optname, char __user *optval,
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
+	ret = crypto_pool_alloc_ahash("md5");
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
@@ -4532,16 +4480,17 @@ int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *hp,
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
index f812d507fc9a..08ffba6c33f4 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -79,6 +79,7 @@
 #include <linux/btf_ids.h>
 
 #include <crypto/hash.h>
+#include <crypto/pool.h>
 #include <linux/scatterlist.h>
 
 #include <trace/events/tcp.h>
@@ -1223,10 +1224,6 @@ static int __tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 	key = sock_kmalloc(sk, sizeof(*key), gfp | __GFP_ZERO);
 	if (!key)
 		return -ENOMEM;
-	if (!tcp_alloc_md5sig_pool()) {
-		sock_kfree_s(sk, key, sizeof(*key));
-		return -ENOMEM;
-	}
 
 	memcpy(key->key, newkey, newkeylen);
 	key->keylen = newkeylen;
@@ -1248,8 +1245,13 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
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
 
 		static_branch_inc(&tcp_md5_needed.key);
 	}
@@ -1266,8 +1268,12 @@ int tcp_md5_key_copy(struct sock *sk, const union tcp_md5_addr *addr,
 	struct tcp_sock *tp = tcp_sk(sk);
 
 	if (!rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk))) {
-		if (tcp_md5sig_info_add(sk, sk_gfp_mask(sk, GFP_ATOMIC)))
+		tcp_md5_add_crypto_pool();
+
+		if (tcp_md5sig_info_add(sk, sk_gfp_mask(sk, GFP_ATOMIC))) {
+			tcp_md5_release_crypto_pool();
 			return -ENOMEM;
+		}
 
 		atomic_inc(&tcp_md5_needed.key.key.enabled);
 	}
@@ -1367,7 +1373,7 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
 			      cmd.tcpm_key, cmd.tcpm_keylen);
 }
 
-static int tcp_v4_md5_hash_headers(struct tcp_md5sig_pool *hp,
+static int tcp_v4_md5_hash_headers(struct crypto_pool_ahash *hp,
 				   __be32 daddr, __be32 saddr,
 				   const struct tcphdr *th, int nbytes)
 {
@@ -1375,7 +1381,7 @@ static int tcp_v4_md5_hash_headers(struct tcp_md5sig_pool *hp,
 	struct scatterlist sg;
 	struct tcphdr *_th;
 
-	bp = hp->scratch;
+	bp = hp->base.scratch;
 	bp->saddr = saddr;
 	bp->daddr = daddr;
 	bp->pad = 0;
@@ -1387,37 +1393,34 @@ static int tcp_v4_md5_hash_headers(struct tcp_md5sig_pool *hp,
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
@@ -1427,8 +1430,7 @@ int tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
 			const struct sock *sk,
 			const struct sk_buff *skb)
 {
-	struct tcp_md5sig_pool *hp;
-	struct ahash_request *req;
+	struct crypto_pool_ahash hp;
 	const struct tcphdr *th = tcp_hdr(skb);
 	__be32 saddr, daddr;
 
@@ -1441,29 +1443,27 @@ int tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
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
@@ -2286,6 +2286,18 @@ static int tcp_v4_init_sock(struct sock *sk)
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
@@ -2310,10 +2322,12 @@ void tcp_v4_destroy_sock(struct sock *sk)
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
index fb500160b8d2..f7a75dce140b 100644
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
index f528702185c4..2c5c0ca7de67 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -64,6 +64,7 @@
 #include <linux/seq_file.h>
 
 #include <crypto/hash.h>
+#include <crypto/pool.h>
 #include <linux/scatterlist.h>
 
 #include <trace/events/tcp.h>
@@ -684,7 +685,7 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 			      cmd.tcpm_key, cmd.tcpm_keylen);
 }
 
-static int tcp_v6_md5_hash_headers(struct tcp_md5sig_pool *hp,
+static int tcp_v6_md5_hash_headers(struct crypto_pool_ahash *hp,
 				   const struct in6_addr *daddr,
 				   const struct in6_addr *saddr,
 				   const struct tcphdr *th, int nbytes)
@@ -693,7 +694,7 @@ static int tcp_v6_md5_hash_headers(struct tcp_md5sig_pool *hp,
 	struct scatterlist sg;
 	struct tcphdr *_th;
 
-	bp = hp->scratch;
+	bp = hp->base.scratch;
 	/* 1. TCP pseudo-header (RFC2460) */
 	bp->saddr = *saddr;
 	bp->daddr = *daddr;
@@ -705,38 +706,35 @@ static int tcp_v6_md5_hash_headers(struct tcp_md5sig_pool *hp,
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
@@ -748,8 +746,7 @@ static int tcp_v6_md5_hash_skb(char *md5_hash,
 			       const struct sk_buff *skb)
 {
 	const struct in6_addr *saddr, *daddr;
-	struct tcp_md5sig_pool *hp;
-	struct ahash_request *req;
+	struct crypto_pool_ahash hp;
 	const struct tcphdr *th = tcp_hdr(skb);
 
 	if (sk) { /* valid for establish/request sockets */
@@ -761,29 +758,27 @@ static int tcp_v6_md5_hash_skb(char *md5_hash,
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
2.38.1

