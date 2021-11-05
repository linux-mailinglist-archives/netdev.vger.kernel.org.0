Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78F9445D95
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 02:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbhKEBwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 21:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbhKEBwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 21:52:41 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EBFC061714
        for <netdev@vger.kernel.org>; Thu,  4 Nov 2021 18:50:02 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id y196so5900712wmc.3
        for <netdev@vger.kernel.org>; Thu, 04 Nov 2021 18:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6tKYXMkUZiulqG3qeKu5r9mJqYJnVYqNGpeigVjU+Ao=;
        b=dxVVptgkmo5Hf4qKaU6tIWQJZ8KheNDjEL/u2yn2INeLVhgagv5Qb9iH2uA01ls69P
         fFjAehOagW1C+kP3E2P1fMCkNQQFUtVr5SA7ku9rX4yryIwempvScgcu+VgiElH27DN2
         VsR4tHh0tK7UcrZSI1a9gPbud8EchA+KUYR9aN2M2xMhn9H9nPbQG0Zy2QKqIYa2ddYF
         kGK/f0ssxtspWTyn/aASYR3kiAcN/BVOjL0M1vowpGPxFH4IbeVq/1mqfr+MTQpzembi
         TLskZ1++x0flqxkGC8wDwjH5CK5dhkrx0/CxVjBvRwMCfAv31xIOg8xw26Q7CjryIl2A
         HkIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6tKYXMkUZiulqG3qeKu5r9mJqYJnVYqNGpeigVjU+Ao=;
        b=Ds31JtaCtRjWMw/+g/VCvU5ZT2nUlsAZxtbKKRPSrOIKnedxI5wdJLhTOAzf7nmndR
         vOh2/oKAtO2faRJrFuCwlEGxc2F1wcWRMgJY72uCNZHzE62K77gWLAFVFFbmY7uepOZq
         6HW5RRd6rN7MGxHva2TeroJlcK5FYKeuZh4+4xu8xNS1yBG23/ZqMcvzZBdgi9CxtTNP
         FhkHx9tvlDtD53C+Z7n7/1ALt16oVsLUZXQUclJ1ICVv0Uv+TKaTzM+IwfwWJNPX8J9F
         Rkx6FiyCILKjMNTv2p1SZ6xolD7B/GqjKLer+I0zdZrvYn1kor60Q4wlwbKSR0/b0ZP6
         v5Fw==
X-Gm-Message-State: AOAM5326BR58QWumpxtpc2uRbjyodsHBREsa+pJMAab1MCiJmUPsMS40
        WyZEcDCN6obJjUELALQBk2xmuwRTV4VRZdul
X-Google-Smtp-Source: ABdhPJxuYJsb/ihoN0Oxy8yu39Bzs+/Sn+JS5kF9wBfjXBsVcTsfk3P/uEeIH0NBZZZWYn1Difmmqw==
X-Received: by 2002:a1c:9851:: with SMTP id a78mr26830003wme.116.1636077000883;
        Thu, 04 Nov 2021 18:50:00 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id c6sm7202421wmq.46.2021.11.04.18.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 18:50:00 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 5/5] tcp/md5: Make more generic tcp_sig_pool
Date:   Fri,  5 Nov 2021 01:49:53 +0000
Message-Id: <20211105014953.972946-6-dima@arista.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211105014953.972946-1-dima@arista.com>
References: <20211105014953.972946-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert tcp_md5sig_pool to more generic tcp_sig_pool.
Now tcp_sig_pool_alloc(const char *alg) can be used to allocate per-cpu
ahash request for different hashing algorithms besides md5.
tcp_sig_pool_get() and tcp_sig_pool_put() should be used to get
ahash_request and scratch area.

Make tcp_sig_pool reusable for TCP Authentication Option support
(TCP-AO, RFC5925), where RFC5926[1] requires HMAC-SHA1 and AES-128_CMAC
hashing at least.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp.h        |  24 +++--
 net/ipv4/tcp.c           | 192 +++++++++++++++++++++++++++------------
 net/ipv4/tcp_ipv4.c      |  46 +++++-----
 net/ipv4/tcp_minisocks.c |   4 +-
 net/ipv6/tcp_ipv6.c      |  44 ++++-----
 5 files changed, 197 insertions(+), 113 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 27eb71dd7ff8..2d868ce8736d 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1628,10 +1628,10 @@ union tcp_md5sum_block {
 #endif
 };
 
-/* - pool: digest algorithm, hash description and scratch buffer */
-struct tcp_md5sig_pool {
-	struct ahash_request	*md5_req;
+struct tcp_sig_pool {
+	struct ahash_request	*req;
 	void			*scratch;
+#define SCRATCH_SIZE (sizeof(union tcp_md5sum_block) + sizeof(struct tcphdr))
 };
 
 /* - functions */
@@ -1671,18 +1671,24 @@ tcp_md5_do_lookup(const struct sock *sk, int l3index,
 #define tcp_twsk_md5_key(twsk)	NULL
 #endif
 
-bool tcp_md5sig_pool_alloc(void);
-bool tcp_md5sig_pool_ready(void);
 
-struct tcp_md5sig_pool *tcp_md5sig_pool_get(void);
-static inline void tcp_md5sig_pool_put(void)
+/* TCP MD5 supports only one hash function, set MD5 id in stone
+ * to avoid needless storing MD5 id in (struct tcp_md5sig_info).
+ */
+#define TCP_MD5_SIG_ID		0
+
+int tcp_sig_pool_alloc(const char *alg);
+bool tcp_sig_pool_ready(unsigned int id);
+
+int tcp_sig_pool_get(unsigned int id, struct tcp_sig_pool *tsp);
+static inline void tcp_sig_pool_put(void)
 {
 	local_bh_enable();
 }
 
-int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *, const struct sk_buff *,
+int tcp_md5_hash_skb_data(struct tcp_sig_pool *, const struct sk_buff *,
 			  unsigned int header_len);
-int tcp_md5_hash_key(struct tcp_md5sig_pool *hp,
+int tcp_md5_hash_key(struct tcp_sig_pool *hp,
 		     const struct tcp_md5sig_key *key);
 
 /* From tcp_fastopen.c */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 8d8692fc9cd5..8307c7b91d09 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4253,32 +4253,79 @@ int tcp_getsockopt(struct sock *sk, int level, int optname, char __user *optval,
 EXPORT_SYMBOL(tcp_getsockopt);
 
 #ifdef CONFIG_TCP_MD5SIG
-static DEFINE_PER_CPU(struct tcp_md5sig_pool, tcp_md5sig_pool);
-static DEFINE_MUTEX(tcp_md5sig_mutex);
-static bool tcp_md5sig_pool_populated = false;
+struct tcp_sig_crypto {
+	struct ahash_request * __percpu	*req;
+	const char			*alg;
+	bool				ready;
+};
+
+#define TCP_SIG_POOL_MAX		8
+static struct tcp_sig_pool_priv_t {
+	struct tcp_sig_crypto		cryptos[TCP_SIG_POOL_MAX];
+	unsigned int			cryptos_nr;
+} tcp_sig_pool_priv = {
+	.cryptos_nr = 1,
+	.cryptos[TCP_MD5_SIG_ID].alg = "md5",
+};
+
+static DEFINE_PER_CPU(void *, tcp_sig_pool_scratch);
+static DEFINE_MUTEX(tcp_sig_pool_mutex);
 
-static void __tcp_md5sig_pool_alloc(void)
+static int tcp_sig_pool_alloc_scrath(void)
 {
-	struct crypto_ahash *hash;
 	int cpu;
 
-	hash = crypto_alloc_ahash("md5", 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(hash))
-		return;
+	for_each_possible_cpu(cpu) {
+		void *scratch = per_cpu(tcp_sig_pool_scratch, cpu);
+
+		if (scratch)
+			continue;
+
+		scratch = kmalloc_node(SCRATCH_SIZE, GFP_KERNEL,
+					cpu_to_node(cpu));
+		if (!scratch)
+			return -ENOMEM;
+		per_cpu(tcp_sig_pool_scratch, cpu) = scratch;
+	}
+	return 0;
+}
+
+bool tcp_sig_pool_ready(unsigned int id)
+{
+	return tcp_sig_pool_priv.cryptos[id].ready;
+}
+EXPORT_SYMBOL(tcp_sig_pool_ready);
+
+static int __tcp_sig_pool_alloc(struct tcp_sig_crypto *crypto, const char *alg)
+{
+	struct crypto_ahash *hash;
+	bool needs_key;
+	int cpu, ret = -ENOMEM;
+
+	crypto->alg = kstrdup(alg, GFP_KERNEL);
+	if (!crypto->alg)
+		return -ENOMEM;
+
+	crypto->req = alloc_percpu(struct ahash_request *);
+	if (!crypto->req)
+		goto out_free_alg;
+
+	hash = crypto_alloc_ahash(alg, 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(hash)) {
+		ret = PTR_ERR(hash);
+		goto out_free_req;
+	}
+
+	/* If hash has .setkey(), allocate ahash per-cpu, not only request */
+	needs_key = crypto_ahash_get_flags(hash) & CRYPTO_TFM_NEED_KEY;
 
 	for_each_possible_cpu(cpu) {
-		void *scratch = per_cpu(tcp_md5sig_pool, cpu).scratch;
 		struct ahash_request *req;
 
-		if (!scratch) {
-			scratch = kmalloc_node(sizeof(union tcp_md5sum_block) +
-					       sizeof(struct tcphdr),
-					       GFP_KERNEL,
-					       cpu_to_node(cpu));
-			if (!scratch)
-				goto out_free;
-			per_cpu(tcp_md5sig_pool, cpu).scratch = scratch;
-		}
+		if (hash == NULL)
+			hash = crypto_alloc_ahash(alg, 0, CRYPTO_ALG_ASYNC);
+		if (IS_ERR(hash))
+			goto out_free;
 
 		req = ahash_request_alloc(hash, GFP_KERNEL);
 		if (!req)
@@ -4286,75 +4333,106 @@ static void __tcp_md5sig_pool_alloc(void)
 
 		ahash_request_set_callback(req, 0, NULL, NULL);
 
-		per_cpu(tcp_md5sig_pool, cpu).md5_req = req;
+		*per_cpu_ptr(crypto->req, cpu) = req;
+
+		if (needs_key)
+			hash = NULL;
 	}
-	/* before setting tcp_md5sig_pool_populated, we must commit all writes
-	 * to memory. See smp_rmb() in tcp_md5sig_pool_get()
+	/* before setting crypto->ready, we must commit all writes
+	 * to memory. See smp_rmb() in tcp_sig_pool_get()
 	 */
 	smp_wmb();
-	tcp_md5sig_pool_populated = true;
-	return;
+	crypto->ready = true;
+	return 0;
 
 out_free:
+	if (!IS_ERR_OR_NULL(hash) && needs_key)
+		crypto_free_ahash(hash);
+
 	for_each_possible_cpu(cpu) {
-		if (per_cpu(tcp_md5sig_pool, cpu).md5_req == NULL)
+		if (*per_cpu_ptr(crypto->req, cpu) == NULL)
 			break;
-		ahash_request_free(per_cpu(tcp_md5sig_pool, cpu).md5_req);
-		per_cpu(tcp_md5sig_pool, cpu).md5_req = NULL;
+		hash = crypto_ahash_reqtfm(*per_cpu_ptr(crypto->req, cpu));
+		ahash_request_free(*per_cpu_ptr(crypto->req, cpu));
+		if (needs_key) {
+			crypto_free_ahash(hash);
+			hash = NULL;
+		}
 	}
-	crypto_free_ahash(hash);
+
+	if (hash)
+		crypto_free_ahash(hash);
+out_free_req:
+	free_percpu(crypto->req);
+out_free_alg:
+	kfree(crypto->alg);
+	return ret;
 }
 
-bool tcp_md5sig_pool_alloc(void)
+int tcp_sig_pool_alloc(const char *alg)
 {
-	if (unlikely(!tcp_md5sig_pool_populated)) {
-		mutex_lock(&tcp_md5sig_mutex);
+	unsigned int i, err;
 
-		if (!tcp_md5sig_pool_populated) {
-			__tcp_md5sig_pool_alloc();
-			if (tcp_md5sig_pool_populated)
-				static_branch_inc(&tcp_md5_needed);
-		}
+	/* slow-path: once per setsockopt() */
+	mutex_lock(&tcp_sig_pool_mutex);
 
-		mutex_unlock(&tcp_md5sig_mutex);
+	err = tcp_sig_pool_alloc_scrath();
+	if (err)
+		goto out;
+
+	for (i = 0; i < tcp_sig_pool_priv.cryptos_nr; i++) {
+		if (!strcmp(tcp_sig_pool_priv.cryptos[i].alg, alg))
+			break;
 	}
-	return tcp_md5sig_pool_populated;
-}
-EXPORT_SYMBOL(tcp_md5sig_pool_alloc);
 
-bool tcp_md5sig_pool_ready(void)
-{
-	return tcp_md5sig_pool_populated;
+	if (i >= TCP_SIG_POOL_MAX) {
+		i = -ENOSPC;
+		goto out;
+	}
+
+	if (tcp_sig_pool_priv.cryptos[i].ready)
+		goto out;
+
+	err = __tcp_sig_pool_alloc(&tcp_sig_pool_priv.cryptos[i], alg);
+	if (!err && i == TCP_MD5_SIG_ID)
+		static_branch_inc(&tcp_md5_needed);
+
+out:
+	mutex_unlock(&tcp_sig_pool_mutex);
+	return err ?: i;
 }
-EXPORT_SYMBOL(tcp_md5sig_pool_ready);
+EXPORT_SYMBOL(tcp_sig_pool_alloc);
 
 /**
- *	tcp_md5sig_pool_get - get md5sig_pool for this user
+ *	tcp_sig_pool_get - get tcp_sig_pool for this user
  *
  *	We use percpu structure, so if we succeed, we exit with preemption
  *	and BH disabled, to make sure another thread or softirq handling
  *	wont try to get same context.
  */
-struct tcp_md5sig_pool *tcp_md5sig_pool_get(void)
+int tcp_sig_pool_get(unsigned int id, struct tcp_sig_pool *tsp)
 {
 	local_bh_disable();
 
-	if (tcp_md5sig_pool_populated) {
-		/* coupled with smp_wmb() in __tcp_md5sig_pool_alloc() */
-		smp_rmb();
-		return this_cpu_ptr(&tcp_md5sig_pool);
+	if (id > tcp_sig_pool_priv.cryptos_nr || !tcp_sig_pool_ready(id)) {
+		local_bh_enable();
+		return -EINVAL;
 	}
-	local_bh_enable();
-	return NULL;
+
+	/* coupled with smp_wmb() in __tcp_sig_pool_alloc() */
+	smp_rmb();
+	tsp->req = *this_cpu_ptr(tcp_sig_pool_priv.cryptos[id].req);
+	tsp->scratch = this_cpu_ptr(&tcp_sig_pool_scratch);
+	return 0;
 }
-EXPORT_SYMBOL(tcp_md5sig_pool_get);
+EXPORT_SYMBOL(tcp_sig_pool_get);
 
-int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *hp,
+int tcp_md5_hash_skb_data(struct tcp_sig_pool *hp,
 			  const struct sk_buff *skb, unsigned int header_len)
 {
 	struct scatterlist sg;
 	const struct tcphdr *tp = tcp_hdr(skb);
-	struct ahash_request *req = hp->md5_req;
+	struct ahash_request *req = hp->req;
 	unsigned int i;
 	const unsigned int head_data_len = skb_headlen(skb) > header_len ?
 					   skb_headlen(skb) - header_len : 0;
@@ -4388,16 +4466,16 @@ int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *hp,
 }
 EXPORT_SYMBOL(tcp_md5_hash_skb_data);
 
-int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct tcp_md5sig_key *key)
+int tcp_md5_hash_key(struct tcp_sig_pool *hp, const struct tcp_md5sig_key *key)
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
index 44db9afa17fc..7e18806c6d82 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1190,7 +1190,7 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 	key = sock_kmalloc(sk, sizeof(*key), gfp | __GFP_ZERO);
 	if (!key)
 		return -ENOMEM;
-	if (WARN_ON_ONCE(!tcp_md5sig_pool_ready())) {
+	if (WARN_ON_ONCE(!tcp_sig_pool_ready(TCP_MD5_SIG_ID))) {
 		sock_kfree_s(sk, key, sizeof(*key));
 		return -ENOMEM;
 	}
@@ -1249,6 +1249,7 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
 	u8 prefixlen = 32;
 	int l3index = 0;
 	u8 flags;
+	int err;
 
 	if (optlen < sizeof(cmd))
 		return -EINVAL;
@@ -1294,14 +1295,15 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
 	if (cmd.tcpm_keylen > TCP_MD5SIG_MAXKEYLEN)
 		return -EINVAL;
 
-	if (!tcp_md5sig_pool_alloc())
-		return -ENOMEM;
+	err = tcp_sig_pool_alloc("md5");
+	if (err < 0 || WARN_ON_ONCE(err != TCP_MD5_SIG_ID))
+		return err;
 
 	return tcp_md5_do_add(sk, addr, AF_INET, prefixlen, l3index, flags,
 			      cmd.tcpm_key, cmd.tcpm_keylen, GFP_KERNEL);
 }
 
-static int tcp_v4_md5_hash_headers(struct tcp_md5sig_pool *hp,
+static int tcp_v4_md5_hash_headers(struct tcp_sig_pool *hp,
 				   __be32 daddr, __be32 saddr,
 				   const struct tcphdr *th, int nbytes)
 {
@@ -1321,37 +1323,36 @@ static int tcp_v4_md5_hash_headers(struct tcp_md5sig_pool *hp,
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
+	struct tcp_sig_pool hp;
 	struct ahash_request *req;
 
-	hp = tcp_md5sig_pool_get();
-	if (!hp)
+	if (tcp_sig_pool_get(TCP_MD5_SIG_ID, &hp))
 		goto clear_hash_noput;
-	req = hp->md5_req;
+	req = hp.req;
 
 	if (crypto_ahash_init(req))
 		goto clear_hash;
-	if (tcp_v4_md5_hash_headers(hp, daddr, saddr, th, th->doff << 2))
+	if (tcp_v4_md5_hash_headers(&hp, daddr, saddr, th, th->doff << 2))
 		goto clear_hash;
-	if (tcp_md5_hash_key(hp, key))
+	if (tcp_md5_hash_key(&hp, key))
 		goto clear_hash;
 	ahash_request_set_crypt(req, NULL, md5_hash, 0);
 	if (crypto_ahash_final(req))
 		goto clear_hash;
 
-	tcp_md5sig_pool_put();
+	tcp_sig_pool_put();
 	return 0;
 
 clear_hash:
-	tcp_md5sig_pool_put();
+	tcp_sig_pool_put();
 clear_hash_noput:
 	memset(md5_hash, 0, 16);
 	return 1;
@@ -1361,7 +1362,7 @@ int tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
 			const struct sock *sk,
 			const struct sk_buff *skb)
 {
-	struct tcp_md5sig_pool *hp;
+	struct tcp_sig_pool hp;
 	struct ahash_request *req;
 	const struct tcphdr *th = tcp_hdr(skb);
 	__be32 saddr, daddr;
@@ -1375,29 +1376,28 @@ int tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
 		daddr = iph->daddr;
 	}
 
-	hp = tcp_md5sig_pool_get();
-	if (!hp)
+	if (tcp_sig_pool_get(TCP_MD5_SIG_ID, &hp))
 		goto clear_hash_noput;
-	req = hp->md5_req;
+	req = hp.req;
 
 	if (crypto_ahash_init(req))
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
 	ahash_request_set_crypt(req, NULL, md5_hash, 0);
 	if (crypto_ahash_final(req))
 		goto clear_hash;
 
-	tcp_md5sig_pool_put();
+	tcp_sig_pool_put();
 	return 0;
 
 clear_hash:
-	tcp_md5sig_pool_put();
+	tcp_sig_pool_put();
 clear_hash_noput:
 	memset(md5_hash, 0, 16);
 	return 1;
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index c99cdb529902..7bfc5a42ce98 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -293,10 +293,10 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
 			tcptw->tw_md5_key = NULL;
 			if (static_branch_unlikely(&tcp_md5_needed)) {
 				struct tcp_md5sig_key *key;
-				bool err = WARN_ON(!tcp_md5sig_pool_ready());
+				bool err = !tcp_sig_pool_ready(TCP_MD5_SIG_ID);
 
 				key = tp->af_specific->md5_lookup(sk, sk);
-				if (key && !err) {
+				if (key && !WARN_ON(err)) {
 					tcptw->tw_md5_key = kmemdup(key, sizeof(*key), GFP_ATOMIC);
 					WARN_ON_ONCE(tcptw->tw_md5_key == NULL);
 				}
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 9147f9f69196..0abc28937058 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -603,6 +603,7 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 	int l3index = 0;
 	u8 prefixlen;
 	u8 flags;
+	int err;
 
 	if (optlen < sizeof(cmd))
 		return -EINVAL;
@@ -654,8 +655,9 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 	if (cmd.tcpm_keylen > TCP_MD5SIG_MAXKEYLEN)
 		return -EINVAL;
 
-	if (!tcp_md5sig_pool_alloc())
-		return -ENOMEM;
+	err = tcp_sig_pool_alloc("md5");
+	if (err < 0 || WARN_ON_ONCE(err != TCP_MD5_SIG_ID))
+		return err;
 
 	if (ipv6_addr_v4mapped(&sin6->sin6_addr))
 		return tcp_md5_do_add(sk, (union tcp_md5_addr *)&sin6->sin6_addr.s6_addr32[3],
@@ -668,7 +670,7 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 			      cmd.tcpm_key, cmd.tcpm_keylen, GFP_KERNEL);
 }
 
-static int tcp_v6_md5_hash_headers(struct tcp_md5sig_pool *hp,
+static int tcp_v6_md5_hash_headers(struct tcp_sig_pool *hp,
 				   const struct in6_addr *daddr,
 				   const struct in6_addr *saddr,
 				   const struct tcphdr *th, int nbytes)
@@ -689,38 +691,37 @@ static int tcp_v6_md5_hash_headers(struct tcp_md5sig_pool *hp,
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
+	struct tcp_sig_pool hp;
 	struct ahash_request *req;
 
-	hp = tcp_md5sig_pool_get();
-	if (!hp)
+	if (tcp_sig_pool_get(TCP_MD5_SIG_ID, &hp))
 		goto clear_hash_noput;
-	req = hp->md5_req;
+	req = hp.req;
 
 	if (crypto_ahash_init(req))
 		goto clear_hash;
-	if (tcp_v6_md5_hash_headers(hp, daddr, saddr, th, th->doff << 2))
+	if (tcp_v6_md5_hash_headers(&hp, daddr, saddr, th, th->doff << 2))
 		goto clear_hash;
-	if (tcp_md5_hash_key(hp, key))
+	if (tcp_md5_hash_key(&hp, key))
 		goto clear_hash;
 	ahash_request_set_crypt(req, NULL, md5_hash, 0);
 	if (crypto_ahash_final(req))
 		goto clear_hash;
 
-	tcp_md5sig_pool_put();
+	tcp_sig_pool_put();
 	return 0;
 
 clear_hash:
-	tcp_md5sig_pool_put();
+	tcp_sig_pool_put();
 clear_hash_noput:
 	memset(md5_hash, 0, 16);
 	return 1;
@@ -732,7 +733,7 @@ static int tcp_v6_md5_hash_skb(char *md5_hash,
 			       const struct sk_buff *skb)
 {
 	const struct in6_addr *saddr, *daddr;
-	struct tcp_md5sig_pool *hp;
+	struct tcp_sig_pool hp;
 	struct ahash_request *req;
 	const struct tcphdr *th = tcp_hdr(skb);
 
@@ -745,29 +746,28 @@ static int tcp_v6_md5_hash_skb(char *md5_hash,
 		daddr = &ip6h->daddr;
 	}
 
-	hp = tcp_md5sig_pool_get();
-	if (!hp)
+	if (tcp_sig_pool_get(TCP_MD5_SIG_ID, &hp))
 		goto clear_hash_noput;
-	req = hp->md5_req;
+	req = hp.req;
 
 	if (crypto_ahash_init(req))
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
 	ahash_request_set_crypt(req, NULL, md5_hash, 0);
 	if (crypto_ahash_final(req))
 		goto clear_hash;
 
-	tcp_md5sig_pool_put();
+	tcp_sig_pool_put();
 	return 0;
 
 clear_hash:
-	tcp_md5sig_pool_put();
+	tcp_sig_pool_put();
 clear_hash_noput:
 	memset(md5_hash, 0, 16);
 	return 1;
-- 
2.33.1

