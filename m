Return-Path: <netdev+bounces-2267-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9CB6700F9E
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 22:24:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F553280DE8
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 20:24:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42DF01EA66;
	Fri, 12 May 2023 20:23:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CEAE1EA65
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 20:23:27 +0000 (UTC)
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C295B8F
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 13:23:22 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-307d20548adso1411463f8f.0
        for <netdev@vger.kernel.org>; Fri, 12 May 2023 13:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1683923000; x=1686515000;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sddrjsag3WdHUBWk+FsQ54pZHijONEeZvMeHiWZaE2U=;
        b=WIsuxktH28RqGQpFIkrCg6cWD5+7oSSwLNvyTa7ziglY20Trs2xL575aIPIT7ledHS
         A/ppXhoXQiATNi0dLcgJheG9dTN1xWTZFfKVV3MFA2F8hOV41xV//lnffEh/T5Jmtsz1
         xQhIYjY47TJ7Cj/bs3oAmMN9OBILuS41/NrKnOn9AAc53ek0eZbywjzgrF8C1cux5ocU
         bb2urhuId35mZLb4Zc8+Ra5MLbGvi82tX4qtTxGrq/rmY6GhM3GxXJnAQe5TdZJa0Q2W
         kN0oJ+MZ928zJ5ffEfgnFyUBOrvYHAe1PRFLrTi2hPHdQpzRi13bXV/bZnWpgXNCYnmy
         KGlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683923000; x=1686515000;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sddrjsag3WdHUBWk+FsQ54pZHijONEeZvMeHiWZaE2U=;
        b=jb0fBK0N0Z1l0O2OvW04DFvERYznwHelpr0RR7jMYs2kQk7EDTiQmJ6ukxZQpMjuWI
         E97YExIHWQF0QYkOg2hOa/fgMoT4T38yMBFJFRU8+AN/sBVvozMLZHTQxyGGEpS+ZLYx
         4tgdgkqFHjRa+Ti7q50CtnchMAOcOX69+YG6ovb9NKkBXM0EZKwlKTJUqQrrF+XIIoZ6
         zRWyRMVXoZvul1FbvrEmRBts3klNZt5zDH+8WA2EhUhBX0BJPJireUSWl9RwkVPUwuF1
         gZHhbaEgpb158sEcJbfaloY2RotZze/5mbQ64VeC/EgMrp3dkq4gdyNYnYchiXlw5ZO5
         M7xg==
X-Gm-Message-State: AC+VfDxHwojTyh34SluDQhR9AviiLdH+H908psqUvPUIt/AL13OWLRhg
	e5119vSLAO0eoVOctkX1vwPB9Q==
X-Google-Smtp-Source: ACHHUZ5mQF+NOXWUQvp1B/NkheGIlvqYY+2US6TXGi1XCXDvGvirRjFRowYRZz3nun//geaclhFOJQ==
X-Received: by 2002:a5d:674b:0:b0:306:2dc3:8b67 with SMTP id l11-20020a5d674b000000b003062dc38b67mr19623621wrw.53.1683922999947;
        Fri, 12 May 2023 13:23:19 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n9-20020a05600c294900b003f423508c6bsm17304527wmd.44.2023.05.12.13.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 13:23:19 -0700 (PDT)
From: Dmitry Safonov <dima@arista.com>
To: linux-kernel@vger.kernel.org,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Cc: Dmitry Safonov <dima@arista.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Bob Gilligan <gilligan@arista.com>,
	Dan Carpenter <error27@gmail.com>,
	David Laight <David.Laight@aculab.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Francesco Ruggeri <fruggeri05@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Ivan Delalande <colona@arista.com>,
	Leonard Crestez <cdleonard@gmail.com>,
	Salam Noureddine <noureddine@arista.com>,
	netdev@vger.kernel.org
Subject: [PATCH v6 01/21] net/tcp: Prepare tcp_md5sig_pool for TCP-AO
Date: Fri, 12 May 2023 21:22:51 +0100
Message-Id: <20230512202311.2845526-2-dima@arista.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230512202311.2845526-1-dima@arista.com>
References: <20230512202311.2845526-1-dima@arista.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

TCP-AO, similarly to TCP-MD5, needs to allocate tfms on a slow-path,
which is setsockopt() and use crypto ahash requests on fast paths,
which are RX/TX softirqs. Also, it needs a temporary/scratch buffer
for preparing the hash.

Rework tcp_md5sig_pool in order to support other hashing algorithms
than MD5. It will make it possible to share pre-allocated crypto_ahash
descriptors and scratch area between all TCP hash users.

Internally tcp_sigpool preferences crypto_clone_ahash() API over
pre-allocating per-CPU crypto requests. Kudos to Herbert, who provided
this new crypto API [1]. Currently, there's still per-CPU crypto request
allocation fallback, that is needed for ciphers, that yet don't support
cloning (TCP-AO requires cmac(aes128) in RFC5925).

I was a little concerned over GFP_ATOMIC allocations of ahash and
crypto_request in RX/TX (see tcp_sigpool_start()), so I benchmarked both
"backends" with different algorithms, using patched version of iperf3[2].
On my laptop with i7-7600U @ 2.80GHz:

                         clone-tfm                per-CPU-requests
TCP-MD5                  2.25 Gbits/sec           2.30 Gbits/sec
TCP-AO(hmac(sha1))       2.53 Gbits/sec           2.54 Gbits/sec
TCP-AO(hmac(sha512))     1.67 Gbits/sec           1.64 Gbits/sec
TCP-AO(hmac(sha384))     1.77 Gbits/sec           1.80 Gbits/sec
TCP-AO(hmac(sha224))     1.29 Gbits/sec           1.30 Gbits/sec
TCP-AO(hmac(sha3-512))    481 Mbits/sec            480 Mbits/sec
TCP-AO(hmac(md5))        2.07 Gbits/sec           2.12 Gbits/sec
TCP-AO(hmac(rmd160))     1.01 Gbits/sec            995 Mbits/sec
TCP-AO(cmac(aes128))     [not supporetd yet]      2.11 Gbits/sec

So, it seems that my concerns don't have strong grounds and per-CPU
crypto_request allocation can be dropped/removed from tcp_sigpool once
ciphers get crypto_clone_ahash() support.

[1]: https://lore.kernel.org/all/ZDefxOq6Ax0JeTRH@gondor.apana.org.au/T/#u
[2]: https://github.com/0x7f454c46/iperf/tree/tcp-md5-ao
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp.h        |  47 ++--
 net/ipv4/Kconfig         |   4 +
 net/ipv4/Makefile        |   1 +
 net/ipv4/tcp.c           | 135 ++----------
 net/ipv4/tcp_ipv4.c      |  97 ++++----
 net/ipv4/tcp_minisocks.c |  21 +-
 net/ipv4/tcp_sigpool.c   | 462 +++++++++++++++++++++++++++++++++++++++
 net/ipv6/tcp_ipv6.c      |  58 +++--
 8 files changed, 616 insertions(+), 209 deletions(-)
 create mode 100644 net/ipv4/tcp_sigpool.c

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 04a31643cda3..b77cc2e0b8e6 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1667,12 +1667,36 @@ union tcp_md5sum_block {
 #endif
 };
 
-/* - pool: digest algorithm, hash description and scratch buffer */
-struct tcp_md5sig_pool {
-	struct ahash_request	*md5_req;
-	void			*scratch;
+/*
+ * struct tcp_sigpool - per-CPU pool of ahash_requests
+ * @scratch: per-CPU temporary area, that can be used between
+ *	     tcp_sigpool_start() and tcp_sigpool_end() to perform
+ *	     crypto request
+ * @req: pre-allocated ahash request
+ */
+struct tcp_sigpool {
+	void *scratch;
+	struct ahash_request *req;
+	bool free_req;
 };
+int tcp_sigpool_alloc_ahash(const char *alg, size_t scratch_size);
+void tcp_sigpool_get(unsigned int id);
+void tcp_sigpool_release(unsigned int id);
+int tcp_sigpool_hash_skb_data(struct tcp_sigpool *hp,
+			      const struct sk_buff *skb,
+			      unsigned int header_len);
 
+/**
+ * tcp_sigpool_start - disable bh and start using tcp_sigpool_ahash
+ * @id: tcp_sigpool that was previously allocated by tcp_sigpool_alloc_ahash()
+ * @c: returned tcp_sigpool for usage (uninitialized on failure)
+ */
+int tcp_sigpool_start(unsigned int id, struct tcp_sigpool *c);
+/**
+ * tcp_sigpool_end - enable bh and stop using tcp_sigpool
+ */
+void tcp_sigpool_end(struct tcp_sigpool *c);
+size_t tcp_sigpool_algo(unsigned int id, char *buf, size_t buf_len);
 /* - functions */
 int tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
 			const struct sock *sk, const struct sk_buff *skb);
@@ -1728,17 +1752,12 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 #define tcp_twsk_md5_key(twsk)	NULL
 #endif
 
-bool tcp_alloc_md5sig_pool(void);
+int tcp_md5_alloc_sigpool(void);
+void tcp_md5_release_sigpool(void);
+void tcp_md5_add_sigpool(void);
+extern int tcp_md5_sigpool_id;
 
-struct tcp_md5sig_pool *tcp_get_md5sig_pool(void);
-static inline void tcp_put_md5sig_pool(void)
-{
-	local_bh_enable();
-}
-
-int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *, const struct sk_buff *,
-			  unsigned int header_len);
-int tcp_md5_hash_key(struct tcp_md5sig_pool *hp,
+int tcp_md5_hash_key(struct tcp_sigpool *hp,
 		     const struct tcp_md5sig_key *key);
 
 /* From tcp_fastopen.c */
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 2dfb12230f08..89e2ab023272 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -741,10 +741,14 @@ config DEFAULT_TCP_CONG
 	default "bbr" if DEFAULT_BBR
 	default "cubic"
 
+config TCP_SIGPOOL
+	tristate
+
 config TCP_MD5SIG
 	bool "TCP: MD5 Signature Option support (RFC2385)"
 	select CRYPTO
 	select CRYPTO_MD5
+	select TCP_SIGPOOL
 	help
 	  RFC2385 specifies a method of giving MD5 protection to TCP sessions.
 	  Its main (only?) use is to protect BGP sessions between core routers
diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index b18ba8ef93ad..cd760793cfcb 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -62,6 +62,7 @@ obj-$(CONFIG_TCP_CONG_SCALABLE) += tcp_scalable.o
 obj-$(CONFIG_TCP_CONG_LP) += tcp_lp.o
 obj-$(CONFIG_TCP_CONG_YEAH) += tcp_yeah.o
 obj-$(CONFIG_TCP_CONG_ILLINOIS) += tcp_illinois.o
+obj-$(CONFIG_TCP_SIGPOOL) += tcp_sigpool.o
 obj-$(CONFIG_NET_SOCK_MSG) += tcp_bpf.o
 obj-$(CONFIG_BPF_SYSCALL) += udp_bpf.o
 obj-$(CONFIG_NETLABEL) += cipso_ipv4.o
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4d6392c16b7a..4ab77d02aef2 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4417,141 +4417,44 @@ int tcp_getsockopt(struct sock *sk, int level, int optname, char __user *optval,
 EXPORT_SYMBOL(tcp_getsockopt);
 
 #ifdef CONFIG_TCP_MD5SIG
-static DEFINE_PER_CPU(struct tcp_md5sig_pool, tcp_md5sig_pool);
-static DEFINE_MUTEX(tcp_md5sig_mutex);
-static bool tcp_md5sig_pool_populated = false;
+int tcp_md5_sigpool_id = -1;
+EXPORT_SYMBOL_GPL(tcp_md5_sigpool_id);
 
-static void __tcp_alloc_md5sig_pool(void)
+int tcp_md5_alloc_sigpool(void)
 {
-	struct crypto_ahash *hash;
-	int cpu;
+	size_t scratch_size;
+	int ret;
 
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
-
-		per_cpu(tcp_md5sig_pool, cpu).md5_req = req;
+	scratch_size = sizeof(union tcp_md5sum_block) + sizeof(struct tcphdr);
+	ret = tcp_sigpool_alloc_ahash("md5", scratch_size);
+	if (ret >= 0) {
+		tcp_md5_sigpool_id = ret;
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
 
-bool tcp_alloc_md5sig_pool(void)
+void tcp_md5_release_sigpool(void)
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
+	tcp_sigpool_release(tcp_md5_sigpool_id);
 }
-EXPORT_SYMBOL(tcp_alloc_md5sig_pool);
 
-
-/**
- *	tcp_get_md5sig_pool - get md5sig_pool for this user
- *
- *	We use percpu structure, so if we succeed, we exit with preemption
- *	and BH disabled, to make sure another thread or softirq handling
- *	wont try to get same context.
- */
-struct tcp_md5sig_pool *tcp_get_md5sig_pool(void)
+void tcp_md5_add_sigpool(void)
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
+	tcp_sigpool_get(tcp_md5_sigpool_id);
 }
-EXPORT_SYMBOL(tcp_get_md5sig_pool);
 
-int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *hp,
-			  const struct sk_buff *skb, unsigned int header_len)
-{
-	struct scatterlist sg;
-	const struct tcphdr *tp = tcp_hdr(skb);
-	struct ahash_request *req = hp->md5_req;
-	unsigned int i;
-	const unsigned int head_data_len = skb_headlen(skb) > header_len ?
-					   skb_headlen(skb) - header_len : 0;
-	const struct skb_shared_info *shi = skb_shinfo(skb);
-	struct sk_buff *frag_iter;
-
-	sg_init_table(&sg, 1);
-
-	sg_set_buf(&sg, ((u8 *) tp) + header_len, head_data_len);
-	ahash_request_set_crypt(req, &sg, NULL, head_data_len);
-	if (crypto_ahash_update(req))
-		return 1;
-
-	for (i = 0; i < shi->nr_frags; ++i) {
-		const skb_frag_t *f = &shi->frags[i];
-		unsigned int offset = skb_frag_off(f);
-		struct page *page = skb_frag_page(f) + (offset >> PAGE_SHIFT);
-
-		sg_set_page(&sg, page, skb_frag_size(f),
-			    offset_in_page(offset));
-		ahash_request_set_crypt(req, &sg, NULL, skb_frag_size(f));
-		if (crypto_ahash_update(req))
-			return 1;
-	}
-
-	skb_walk_frags(skb, frag_iter)
-		if (tcp_md5_hash_skb_data(hp, frag_iter, 0))
-			return 1;
-
-	return 0;
-}
-EXPORT_SYMBOL(tcp_md5_hash_skb_data);
-
-int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct tcp_md5sig_key *key)
+int tcp_md5_hash_key(struct tcp_sigpool *hp,
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
index 39bda2b1066e..c6fd2e071e4a 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1212,10 +1212,6 @@ static int __tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 	key = sock_kmalloc(sk, sizeof(*key), gfp | __GFP_ZERO);
 	if (!key)
 		return -ENOMEM;
-	if (!tcp_alloc_md5sig_pool()) {
-		sock_kfree_s(sk, key, sizeof(*key));
-		return -ENOMEM;
-	}
 
 	memcpy(key->key, newkey, newkeylen);
 	key->keylen = newkeylen;
@@ -1237,15 +1233,21 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 	struct tcp_sock *tp = tcp_sk(sk);
 
 	if (!rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk))) {
-		if (tcp_md5sig_info_add(sk, GFP_KERNEL))
+		if (tcp_md5_alloc_sigpool())
 			return -ENOMEM;
 
+		if (tcp_md5sig_info_add(sk, GFP_KERNEL)) {
+			tcp_md5_release_sigpool();
+			return -ENOMEM;
+		}
+
 		if (!static_branch_inc(&tcp_md5_needed.key)) {
 			struct tcp_md5sig_info *md5sig;
 
 			md5sig = rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk));
 			rcu_assign_pointer(tp->md5sig_info, NULL);
 			kfree_rcu(md5sig, rcu);
+			tcp_md5_release_sigpool();
 			return -EUSERS;
 		}
 	}
@@ -1262,8 +1264,12 @@ int tcp_md5_key_copy(struct sock *sk, const union tcp_md5_addr *addr,
 	struct tcp_sock *tp = tcp_sk(sk);
 
 	if (!rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk))) {
-		if (tcp_md5sig_info_add(sk, sk_gfp_mask(sk, GFP_ATOMIC)))
+		tcp_md5_add_sigpool();
+
+		if (tcp_md5sig_info_add(sk, sk_gfp_mask(sk, GFP_ATOMIC))) {
+			tcp_md5_release_sigpool();
 			return -ENOMEM;
+		}
 
 		if (!static_key_fast_inc_not_disabled(&tcp_md5_needed.key.key)) {
 			struct tcp_md5sig_info *md5sig;
@@ -1272,6 +1278,7 @@ int tcp_md5_key_copy(struct sock *sk, const union tcp_md5_addr *addr,
 			net_warn_ratelimited("Too many TCP-MD5 keys in the system\n");
 			rcu_assign_pointer(tp->md5sig_info, NULL);
 			kfree_rcu(md5sig, rcu);
+			tcp_md5_release_sigpool();
 			return -EUSERS;
 		}
 	}
@@ -1371,7 +1378,7 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
 			      cmd.tcpm_key, cmd.tcpm_keylen);
 }
 
-static int tcp_v4_md5_hash_headers(struct tcp_md5sig_pool *hp,
+static int tcp_v4_md5_hash_headers(struct tcp_sigpool *hp,
 				   __be32 daddr, __be32 saddr,
 				   const struct tcphdr *th, int nbytes)
 {
@@ -1391,38 +1398,35 @@ static int tcp_v4_md5_hash_headers(struct tcp_md5sig_pool *hp,
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
+	struct tcp_sigpool hp;
 
-	hp = tcp_get_md5sig_pool();
-	if (!hp)
-		goto clear_hash_noput;
-	req = hp->md5_req;
+	if (tcp_sigpool_start(tcp_md5_sigpool_id, &hp))
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
+	tcp_sigpool_end(&hp);
 	return 0;
 
 clear_hash:
-	tcp_put_md5sig_pool();
-clear_hash_noput:
+	tcp_sigpool_end(&hp);
+clear_hash_nostart:
 	memset(md5_hash, 0, 16);
 	return 1;
 }
@@ -1431,8 +1435,7 @@ int tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
 			const struct sock *sk,
 			const struct sk_buff *skb)
 {
-	struct tcp_md5sig_pool *hp;
-	struct ahash_request *req;
+	struct tcp_sigpool hp;
 	const struct tcphdr *th = tcp_hdr(skb);
 	__be32 saddr, daddr;
 
@@ -1445,30 +1448,28 @@ int tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
 		daddr = iph->daddr;
 	}
 
-	hp = tcp_get_md5sig_pool();
-	if (!hp)
-		goto clear_hash_noput;
-	req = hp->md5_req;
+	if (tcp_sigpool_start(tcp_md5_sigpool_id, &hp))
+		goto clear_hash_nostart;
 
-	if (crypto_ahash_init(req))
+	if (crypto_ahash_init(hp.req))
 		goto clear_hash;
 
-	if (tcp_v4_md5_hash_headers(hp, daddr, saddr, th, skb->len))
+	if (tcp_v4_md5_hash_headers(&hp, daddr, saddr, th, skb->len))
 		goto clear_hash;
-	if (tcp_md5_hash_skb_data(hp, skb, th->doff << 2))
+	if (tcp_sigpool_hash_skb_data(&hp, skb, th->doff << 2))
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
+	tcp_sigpool_end(&hp);
 	return 0;
 
 clear_hash:
-	tcp_put_md5sig_pool();
-clear_hash_noput:
+	tcp_sigpool_end(&hp);
+clear_hash_nostart:
 	memset(md5_hash, 0, 16);
 	return 1;
 }
@@ -2286,6 +2287,18 @@ static int tcp_v4_init_sock(struct sock *sk)
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
+	tcp_md5_release_sigpool();
+}
+#endif
+
 void tcp_v4_destroy_sock(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
@@ -2310,10 +2323,12 @@ void tcp_v4_destroy_sock(struct sock *sk)
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
index dac0d62120e6..63b5c5f42a87 100644
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
+		tcp_md5_add_sigpool();
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
+	tcp_md5_release_sigpool();
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
diff --git a/net/ipv4/tcp_sigpool.c b/net/ipv4/tcp_sigpool.c
new file mode 100644
index 000000000000..2413777a85a8
--- /dev/null
+++ b/net/ipv4/tcp_sigpool.c
@@ -0,0 +1,462 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <crypto/hash.h>
+#include <linux/cpu.h>
+#include <linux/kref.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/percpu.h>
+#include <linux/workqueue.h>
+#include <net/tcp.h>
+
+static size_t __scratch_size;
+static DEFINE_PER_CPU(void __rcu *, sigpool_scratch);
+
+union sigpool_req {
+	struct ahash_request *__percpu	*pcp_req;
+	struct crypto_ahash		*hash;
+};
+
+struct sigpool_entry {
+	union sigpool_req	spr;
+	const char		*alg;
+	struct kref		kref;
+	uint16_t		needs_key:1,
+				clone_ahash:1,
+				reserved:14;
+};
+
+#define CPOOL_SIZE (PAGE_SIZE / sizeof(struct sigpool_entry))
+static struct sigpool_entry cpool[CPOOL_SIZE];
+static unsigned int cpool_populated;
+static DEFINE_MUTEX(cpool_mutex);
+
+/* Slow-path */
+struct scratches_to_free {
+	struct rcu_head rcu;
+	unsigned int cnt;
+	void *scratches[];
+};
+
+static void free_old_scratches(struct rcu_head *head)
+{
+	struct scratches_to_free *stf;
+
+	stf = container_of(head, struct scratches_to_free, rcu);
+	while (stf->cnt--)
+		kfree(stf->scratches[stf->cnt]);
+	kfree(stf);
+}
+
+/**
+ * sigpool_reserve_scratch - re-allocates scratch buffer, slow-path
+ * @size: request size for the scratch/temp buffer
+ */
+static int sigpool_reserve_scratch(size_t size)
+{
+	struct scratches_to_free *stf;
+	size_t stf_sz = struct_size(stf, scratches, num_possible_cpus());
+	int cpu, err = 0;
+
+	lockdep_assert_held(&cpool_mutex);
+	if (__scratch_size >= size)
+		return 0;
+
+	stf = kmalloc(stf_sz, GFP_KERNEL);
+	if (!stf)
+		return -ENOMEM;
+	stf->cnt = 0;
+
+	size = max(size, __scratch_size);
+	cpus_read_lock();
+	for_each_possible_cpu(cpu) {
+		void *scratch, *old_scratch;
+
+		scratch = kmalloc_node(size, GFP_KERNEL, cpu_to_node(cpu));
+		if (!scratch) {
+			err = -ENOMEM;
+			break;
+		}
+
+		old_scratch = rcu_replace_pointer(per_cpu(sigpool_scratch, cpu), scratch, lockdep_is_held(&cpool_mutex));
+		if (!cpu_online(cpu) || !old_scratch) {
+			kfree(old_scratch);
+			continue;
+		}
+		stf->scratches[stf->cnt++] = old_scratch;
+	}
+	cpus_read_unlock();
+	if (!err)
+		__scratch_size = size;
+
+	call_rcu(&stf->rcu, free_old_scratches);
+	return err;
+}
+
+static void sigpool_scratch_free(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		kfree(rcu_replace_pointer(per_cpu(sigpool_scratch, cpu),
+					  NULL, lockdep_is_held(&cpool_mutex)));
+	__scratch_size = 0;
+}
+
+static int __cpool_alloc_pcp(struct sigpool_entry *e, const char *alg,
+			     struct crypto_ahash *cpu0_hash)
+{
+	struct crypto_ahash *hash;
+	int cpu, ret;
+
+	e->spr.pcp_req = alloc_percpu(struct ahash_request *);
+	if (!e->spr.pcp_req)
+		return -ENOMEM;
+
+	hash = cpu0_hash;
+	for_each_possible_cpu(cpu) {
+		struct ahash_request *req;
+
+		/* If ahash has a key - it has to be allocated per-CPU.
+		 * In such case re-use for CPU0 hash that just have been
+		 * allocated above.
+		 */
+		if (!hash)
+			hash = crypto_alloc_ahash(alg, 0, CRYPTO_ALG_ASYNC);
+		if (IS_ERR(hash))
+			goto out_free_per_cpu;
+
+		req = ahash_request_alloc(hash, GFP_KERNEL);
+		if (!req)
+			goto out_free_hash;
+
+		ahash_request_set_callback(req, 0, NULL, NULL);
+
+		*per_cpu_ptr(e->spr.pcp_req, cpu) = req;
+
+		if (e->needs_key)
+			hash = NULL;
+	}
+	return 0;
+
+out_free_hash:
+	if (hash != cpu0_hash)
+		crypto_free_ahash(hash);
+
+out_free_per_cpu:
+	for_each_possible_cpu(cpu) {
+		struct ahash_request *req = *per_cpu_ptr(e->spr.pcp_req, cpu);
+		struct crypto_ahash *pcpu_hash;
+
+		if (!req)
+			break;
+		pcpu_hash = crypto_ahash_reqtfm(req);
+		ahash_request_free(req);
+		/* hash per-CPU, e->needs_key == true */
+		if (pcpu_hash != cpu0_hash)
+			crypto_free_ahash(pcpu_hash);
+	}
+
+	free_percpu(e->spr.pcp_req);
+	return ret;
+}
+
+static int __cpool_try_clone(struct crypto_ahash *hash)
+{
+	struct crypto_ahash *tmp;
+
+	tmp = crypto_clone_ahash(hash);
+	if (IS_ERR(tmp))
+		return PTR_ERR(tmp);
+
+	crypto_free_ahash(tmp);
+	return 0;
+}
+
+static int __cpool_alloc_ahash(struct sigpool_entry *e, const char *alg)
+{
+	struct crypto_ahash *cpu0_hash;
+	int ret;
+
+	e->alg = kstrdup(alg, GFP_KERNEL);
+	if (!e->alg)
+		return -ENOMEM;
+
+	cpu0_hash = crypto_alloc_ahash(alg, 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(cpu0_hash)) {
+		ret = PTR_ERR(cpu0_hash);
+		goto out_free_alg;
+	}
+
+	e->needs_key = crypto_ahash_get_flags(cpu0_hash) & CRYPTO_TFM_NEED_KEY;
+
+	ret = __cpool_try_clone(cpu0_hash);
+	if (!ret) {
+		e->clone_ahash = 1;
+		e->spr.hash = cpu0_hash;
+		kref_init(&e->kref);
+		return 0;
+	}
+	if (ret != -ENOSYS)
+		goto out_free_cpu0_hash;
+
+	/* Fall back to per-cpu ahash request allocation. */
+	ret = __cpool_alloc_pcp(e, alg, cpu0_hash);
+	if (ret)
+		goto out_free_cpu0_hash;
+	e->clone_ahash = 0;
+	kref_init(&e->kref);
+	return 0;
+
+out_free_cpu0_hash:
+	crypto_free_ahash(cpu0_hash);
+out_free_alg:
+	kfree(e->alg);
+	e->alg = NULL;
+	return ret;
+}
+
+/**
+ * tcp_sigpool_alloc_ahash - allocates pool for ahash requests
+ * @alg: name of async hash algorithm
+ * @scratch_size: reserve a tcp_sigpool::scratch buffer of this size
+ */
+int tcp_sigpool_alloc_ahash(const char *alg, size_t scratch_size)
+{
+	int i, ret;
+
+	/* slow-path */
+	mutex_lock(&cpool_mutex);
+	ret = sigpool_reserve_scratch(scratch_size);
+	if (ret)
+		goto out;
+	for (i = 0; i < cpool_populated; i++) {
+		if (!cpool[i].alg)
+			continue;
+		if (strcmp(cpool[i].alg, alg))
+			continue;
+
+		if (kref_read(&cpool[i].kref) > 0)
+			kref_get(&cpool[i].kref);
+		else
+			kref_init(&cpool[i].kref);
+		ret = i;
+		goto out;
+	}
+
+	for (i = 0; i < cpool_populated; i++) {
+		if (!cpool[i].alg)
+			break;
+	}
+	if (i >= CPOOL_SIZE) {
+		ret = -ENOSPC;
+		goto out;
+	}
+
+	ret = __cpool_alloc_ahash(&cpool[i], alg);
+	if (!ret) {
+		ret = i;
+		if (i == cpool_populated)
+			cpool_populated++;
+	}
+out:
+	mutex_unlock(&cpool_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tcp_sigpool_alloc_ahash);
+
+static void __cpool_free_pcp(struct sigpool_entry *e)
+{
+	struct crypto_ahash *hash = NULL;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		if (*per_cpu_ptr(e->spr.pcp_req, cpu) == NULL)
+			continue;
+
+		hash = crypto_ahash_reqtfm(*per_cpu_ptr(e->spr.pcp_req, cpu));
+		ahash_request_free(*per_cpu_ptr(e->spr.pcp_req, cpu));
+		if (e->needs_key) {
+			crypto_free_ahash(hash);
+			hash = NULL;
+		}
+	}
+	if (hash)
+		crypto_free_ahash(hash);
+	free_percpu(e->spr.pcp_req);
+}
+
+static void __cpool_free_entry(struct sigpool_entry *e)
+{
+	if (e->clone_ahash)
+		crypto_free_ahash(e->spr.hash);
+	else
+		__cpool_free_pcp(e);
+
+	kfree(e->alg);
+	memset(e, 0, sizeof(*e));
+}
+
+static void cpool_cleanup_work_cb(struct work_struct *work)
+{
+	unsigned int i;
+	bool free_scratch = true;
+
+	mutex_lock(&cpool_mutex);
+	for (i = 0; i < cpool_populated; i++) {
+		if (kref_read(&cpool[i].kref) > 0) {
+			free_scratch = false;
+			continue;
+		}
+		if (!cpool[i].alg)
+			continue;
+		__cpool_free_entry(&cpool[i]);
+	}
+	if (free_scratch)
+		sigpool_scratch_free();
+	mutex_unlock(&cpool_mutex);
+}
+
+static DECLARE_WORK(cpool_cleanup_work, cpool_cleanup_work_cb);
+static void cpool_schedule_cleanup(struct kref *kref)
+{
+	schedule_work(&cpool_cleanup_work);
+}
+
+/**
+ * tcp_sigpool_release - decreases number of users for a pool. If it was
+ * the last user of the pool, releases any memory that was consumed.
+ * @id: tcp_sigpool that was previously allocated by tcp_sigpool_alloc_ahash()
+ */
+void tcp_sigpool_release(unsigned int id)
+{
+	if (WARN_ON_ONCE(id > cpool_populated || !cpool[id].alg))
+		return;
+
+	/* slow-path */
+	kref_put(&cpool[id].kref, cpool_schedule_cleanup);
+}
+EXPORT_SYMBOL_GPL(tcp_sigpool_release);
+
+/**
+ * tcp_sigpool_get - increases number of users (refcounter) for a pool
+ * @id: tcp_sigpool that was previously allocated by tcp_sigpool_alloc_ahash()
+ */
+void tcp_sigpool_get(unsigned int id)
+{
+	if (WARN_ON_ONCE(id > cpool_populated || !cpool[id].alg))
+		return;
+	kref_get(&cpool[id].kref);
+}
+EXPORT_SYMBOL_GPL(tcp_sigpool_get);
+
+int tcp_sigpool_start(unsigned int id, struct tcp_sigpool *c)
+{
+	rcu_read_lock_bh();
+	if (WARN_ON_ONCE(id > cpool_populated || !cpool[id].alg)) {
+		rcu_read_unlock_bh();
+		return -EINVAL;
+	}
+
+	c->free_req = cpool[id].clone_ahash;
+	if (cpool[id].clone_ahash) {
+		struct crypto_ahash *hash;
+
+		hash = crypto_clone_ahash(cpool[id].spr.hash);
+		if (IS_ERR(hash)) {
+			rcu_read_unlock_bh();
+			return PTR_ERR(hash);
+		}
+		c->req = ahash_request_alloc(hash, GFP_ATOMIC);
+		if (!c->req) {
+			crypto_free_ahash(hash);
+			rcu_read_unlock_bh();
+			return -ENOMEM;
+		}
+		ahash_request_set_callback(c->req, 0, NULL, NULL);
+	} else {
+		c->req = *this_cpu_ptr(cpool[id].spr.pcp_req);
+	}
+	/* Pairs with tcp_sigpool_reserve_scratch(), scratch area is
+	 * valid (allocated) until tcp_sigpool_end().
+	 */
+	c->scratch = rcu_dereference_bh(*this_cpu_ptr(&sigpool_scratch));
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tcp_sigpool_start);
+
+void tcp_sigpool_end(struct tcp_sigpool *c)
+{
+	rcu_read_unlock_bh();
+	if (c->free_req) {
+		struct crypto_ahash *hash = crypto_ahash_reqtfm(c->req);
+
+		ahash_request_free(c->req);
+		crypto_free_ahash(hash);
+	}
+}
+EXPORT_SYMBOL_GPL(tcp_sigpool_end);
+
+/**
+ * tcp_sigpool_algo - return algorithm of tcp_sigpool
+ * @id: tcp_sigpool that was previously allocated by tcp_sigpool_alloc_ahash()
+ * @buf: buffer to return name of algorithm
+ * @buf_len: size of @buf
+ */
+size_t tcp_sigpool_algo(unsigned int id, char *buf, size_t buf_len)
+{
+	if (WARN_ON_ONCE(id > cpool_populated || !cpool[id].alg))
+		return -EINVAL;
+
+	return strscpy(buf, cpool[id].alg, buf_len);
+}
+EXPORT_SYMBOL_GPL(tcp_sigpool_algo);
+
+/**
+ * tcp_sigpool_hash_skb_data - hash data in skb with initialized tcp_sigpool
+ * @hp: tcp_sigpool pointer
+ * @skb: buffer to add sign for
+ * @header_len: TCP header length for this segment
+ */
+int tcp_sigpool_hash_skb_data(struct tcp_sigpool *hp,
+			      const struct sk_buff *skb,
+			      unsigned int header_len)
+{
+	struct scatterlist sg;
+	const struct tcphdr *tp = tcp_hdr(skb);
+	struct ahash_request *req = hp->req;
+	unsigned int i;
+	const unsigned int head_data_len = skb_headlen(skb) > header_len ?
+					   skb_headlen(skb) - header_len : 0;
+	const struct skb_shared_info *shi = skb_shinfo(skb);
+	struct sk_buff *frag_iter;
+
+	sg_init_table(&sg, 1);
+
+	sg_set_buf(&sg, ((u8 *)tp) + header_len, head_data_len);
+	ahash_request_set_crypt(req, &sg, NULL, head_data_len);
+	if (crypto_ahash_update(req))
+		return 1;
+
+	for (i = 0; i < shi->nr_frags; ++i) {
+		const skb_frag_t *f = &shi->frags[i];
+		unsigned int offset = skb_frag_off(f);
+		struct page *page = skb_frag_page(f) + (offset >> PAGE_SHIFT);
+
+		sg_set_page(&sg, page, skb_frag_size(f),
+			    offset_in_page(offset));
+		ahash_request_set_crypt(req, &sg, NULL, skb_frag_size(f));
+		if (crypto_ahash_update(req))
+			return 1;
+	}
+
+	skb_walk_frags(skb, frag_iter)
+		if (tcp_sigpool_hash_skb_data(hp, frag_iter, 0))
+			return 1;
+
+	return 0;
+}
+EXPORT_SYMBOL(tcp_sigpool_hash_skb_data);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Per-CPU pool of crypto requests");
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 7132eb213a7a..7e0c43cb3fd8 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -674,7 +674,7 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 			      cmd.tcpm_key, cmd.tcpm_keylen);
 }
 
-static int tcp_v6_md5_hash_headers(struct tcp_md5sig_pool *hp,
+static int tcp_v6_md5_hash_headers(struct tcp_sigpool *hp,
 				   const struct in6_addr *daddr,
 				   const struct in6_addr *saddr,
 				   const struct tcphdr *th, int nbytes)
@@ -695,39 +695,36 @@ static int tcp_v6_md5_hash_headers(struct tcp_md5sig_pool *hp,
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
+	struct tcp_sigpool hp;
 
-	hp = tcp_get_md5sig_pool();
-	if (!hp)
-		goto clear_hash_noput;
-	req = hp->md5_req;
+	if (tcp_sigpool_start(tcp_md5_sigpool_id, &hp))
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
+	tcp_sigpool_end(&hp);
 	return 0;
 
 clear_hash:
-	tcp_put_md5sig_pool();
-clear_hash_noput:
+	tcp_sigpool_end(&hp);
+clear_hash_nostart:
 	memset(md5_hash, 0, 16);
 	return 1;
 }
@@ -738,8 +735,7 @@ static int tcp_v6_md5_hash_skb(char *md5_hash,
 			       const struct sk_buff *skb)
 {
 	const struct in6_addr *saddr, *daddr;
-	struct tcp_md5sig_pool *hp;
-	struct ahash_request *req;
+	struct tcp_sigpool hp;
 	const struct tcphdr *th = tcp_hdr(skb);
 
 	if (sk) { /* valid for establish/request sockets */
@@ -751,30 +747,28 @@ static int tcp_v6_md5_hash_skb(char *md5_hash,
 		daddr = &ip6h->daddr;
 	}
 
-	hp = tcp_get_md5sig_pool();
-	if (!hp)
-		goto clear_hash_noput;
-	req = hp->md5_req;
+	if (tcp_sigpool_start(tcp_md5_sigpool_id, &hp))
+		goto clear_hash_nostart;
 
-	if (crypto_ahash_init(req))
+	if (crypto_ahash_init(hp.req))
 		goto clear_hash;
 
-	if (tcp_v6_md5_hash_headers(hp, daddr, saddr, th, skb->len))
+	if (tcp_v6_md5_hash_headers(&hp, daddr, saddr, th, skb->len))
 		goto clear_hash;
-	if (tcp_md5_hash_skb_data(hp, skb, th->doff << 2))
+	if (tcp_sigpool_hash_skb_data(&hp, skb, th->doff << 2))
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
+	tcp_sigpool_end(&hp);
 	return 0;
 
 clear_hash:
-	tcp_put_md5sig_pool();
-clear_hash_noput:
+	tcp_sigpool_end(&hp);
+clear_hash_nostart:
 	memset(md5_hash, 0, 16);
 	return 1;
 }
-- 
2.40.0


