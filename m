Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C082969835F
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 19:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbjBOSeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 13:34:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjBOSdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 13:33:54 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB043A0A1
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:33:47 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id r18so14003365wmq.5
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mrTPrXN8vyxihQKYg5wgSRUqcIF2OSEfY/pO2VW01oY=;
        b=C0OuCI393E0cPeqSqAnxWJsbW8vi40Lj1B7JsGxr+E0x6z2Uebnnc/vUfBb1ZU3C2g
         4RZsx9N6dQOKxy1CZi5rBusigCbVy4PefjyGSrgKbda6gjEAcR0+UYQyFlIlxkm6jjaC
         pm0neam1JCFSL+d//Ers8+DuvJPbp8P9mWVLbgSR1l6Ijvv3LEjQ74K97Wp0TCLO1YN2
         ZEGjpP8Iri/7cX2Slhgtk5L4XDjP6YZNlp4BIIrpqX6Fg9OaxGNqIeSTCbQu+/l8JMiP
         nY2spirT0AMOaLMsYH7NC13co39x/u27HS3Odfr8j6NV36zUlnXOQkCe+lG1rUPvlzYr
         s+1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mrTPrXN8vyxihQKYg5wgSRUqcIF2OSEfY/pO2VW01oY=;
        b=ItRHXvp5C5P4ntOXbgAyQs6wSUef4YYoDteEezQAP70e21xyx4Dk00zoeb/ZX3Kn4x
         wWAwZzy6Msp6g+6C4x0UDTGTV0lNUsEHX4DYuI1G/i6gTjriaZgR98RZKSAr2fhp3Q/3
         PwIDjXdQ5XOSfaWzysat4NHaN/PSf5Nh6CnIK2fJfI6eA8PfbK6TKVNDDvxlFkOoNlp3
         HGJNft2IHasdTLixTBVm+5a/3Y8KarxTioC/p95+iWVX/SxfNdZ8usbJaDS7zbj3rzB7
         2DYaJwQJlB87qfl7KAh6scrbUzws6rze6zLppjup2cEmQ7QL4oJWb55ZleWaTWg+QgEg
         /aMQ==
X-Gm-Message-State: AO0yUKXpoHzmpGZlHVboOynqrWtSdjkGQWjb5qUIIl6+ViScjuPOhUpm
        Deu5uzv5hO2x1EIdY6AVpS9I2A==
X-Google-Smtp-Source: AK7set+UswmxRc3ApfjlNIdMIKVtS+CNH8pg6DX8f0wS/er++kAcOzvodBaPw1YqeymW2F0vzWubSg==
X-Received: by 2002:a05:600c:1c9a:b0:3df:fc69:e96b with SMTP id k26-20020a05600c1c9a00b003dffc69e96bmr2994631wms.5.1676486025612;
        Wed, 15 Feb 2023 10:33:45 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id s9-20020a05600c45c900b003e00c9888besm3196306wmo.30.2023.02.15.10.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 10:33:45 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
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
Subject: [PATCH v4 01/21] net/tcp: Prepare tcp_md5sig_pool for TCP-AO
Date:   Wed, 15 Feb 2023 18:33:15 +0000
Message-Id: <20230215183335.800122-2-dima@arista.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230215183335.800122-1-dima@arista.com>
References: <20230215183335.800122-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TCP-AO similarly to TCP-MD5 needs to allocate tfms on a slow-path, which
is setsockopt() and use crypto ahash requests on fast paths, which are
RX/TX softirqs. It as well needs a temporary/scratch buffer for
preparing the hashing request.

Extend tcp_md5sig_pool to support other hashing algorithms than MD5.
Move it in a separate file.

This patch was previously submitted as more generic crypto_pool [1],
but Herbert nacked making it generic crypto API. His view is that crypto
requests should be atomically allocated on fast-paths. So, in this
version I don't move this pool anywhere outside TCP, only extending it
for TCP-AO use-case. It can be converted once there will be per-request
hashing crypto keys.

[1]: https://lore.kernel.org/all/20230118214111.394416-1-dima@arista.com/T/#u
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp.h        |  48 ++++--
 net/ipv4/Kconfig         |   4 +
 net/ipv4/Makefile        |   1 +
 net/ipv4/tcp.c           | 103 +++---------
 net/ipv4/tcp_ipv4.c      |  97 +++++++-----
 net/ipv4/tcp_minisocks.c |  21 ++-
 net/ipv4/tcp_sigpool.c   | 333 +++++++++++++++++++++++++++++++++++++++
 net/ipv6/tcp_ipv6.c      |  58 +++----
 8 files changed, 493 insertions(+), 172 deletions(-)
 create mode 100644 net/ipv4/tcp_sigpool.c

diff --git a/include/net/tcp.h b/include/net/tcp.h
index db9f828e9d1e..e77080003800 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1664,12 +1664,35 @@ union tcp_md5sum_block {
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
 };
+int tcp_sigpool_alloc_ahash(const char *alg, size_t scratch_size);
+void tcp_sigpool_get(unsigned int id);
+void tcp_sigpool_release(unsigned int id);
 
+/**
+ * tcp_sigpool_start - disable bh and start using tcp_sigpool_ahash
+ * @id: tcp_sigpool that was previously allocated by tcp_sigpool_alloc_ahash()
+ * @c: returned tcp_sigpool for usage (uninitialized on failure)
+ */
+int tcp_sigpool_start(unsigned int id, struct tcp_sigpool *c);
+/**
+ * tcp_sigpool_end - enable bh and stop using tcp_sigpool
+ */
+static inline void tcp_sigpool_end(void)
+{
+	rcu_read_unlock_bh();
+}
+size_t tcp_sigpool_algo(unsigned int id, char *buf, size_t buf_len);
 /* - functions */
 int tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
 			const struct sock *sk, const struct sk_buff *skb);
@@ -1725,17 +1748,14 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 #define tcp_twsk_md5_key(twsk)	NULL
 #endif
 
-bool tcp_alloc_md5sig_pool(void);
-
-struct tcp_md5sig_pool *tcp_get_md5sig_pool(void);
-static inline void tcp_put_md5sig_pool(void)
-{
-	local_bh_enable();
-}
+int tcp_md5_alloc_sigpool(void);
+void tcp_md5_release_sigpool(void);
+void tcp_md5_add_sigpool(void);
+extern int tcp_md5_sigpool_id;
 
-int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *, const struct sk_buff *,
-			  unsigned int header_len);
-int tcp_md5_hash_key(struct tcp_md5sig_pool *hp,
+int tcp_md5_hash_skb_data(struct tcp_sigpool *hp,
+			  const struct sk_buff *skb, unsigned int header_len);
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
index af7d2cf490fb..de8ba8cdc056 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -61,6 +61,7 @@ obj-$(CONFIG_TCP_CONG_SCALABLE) += tcp_scalable.o
 obj-$(CONFIG_TCP_CONG_LP) += tcp_lp.o
 obj-$(CONFIG_TCP_CONG_YEAH) += tcp_yeah.o
 obj-$(CONFIG_TCP_CONG_ILLINOIS) += tcp_illinois.o
+obj-$(CONFIG_TCP_SIGPOOL) += tcp_sigpool.o
 obj-$(CONFIG_NET_SOCK_MSG) += tcp_bpf.o
 obj-$(CONFIG_BPF_SYSCALL) += udp_bpf.o
 obj-$(CONFIG_NETLABEL) += cipso_ipv4.o
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 33f559f491c8..5522c5ac24bc 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4413,98 +4413,42 @@ int tcp_getsockopt(struct sock *sk, int level, int optname, char __user *optval,
 EXPORT_SYMBOL(tcp_getsockopt);
 
 #ifdef CONFIG_TCP_MD5SIG
-static DEFINE_PER_CPU(struct tcp_md5sig_pool, tcp_md5sig_pool);
-static DEFINE_MUTEX(tcp_md5sig_mutex);
-static bool tcp_md5sig_pool_populated = false;
+int tcp_md5_sigpool_id = -1;
+EXPORT_SYMBOL(tcp_md5_sigpool_id);
 
-static void __tcp_alloc_md5sig_pool(void)
+int tcp_md5_alloc_sigpool(void)
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
+EXPORT_SYMBOL(tcp_md5_alloc_sigpool);
 
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
+EXPORT_SYMBOL(tcp_md5_release_sigpool);
 
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
+EXPORT_SYMBOL(tcp_md5_add_sigpool);
 
-int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *hp,
+int tcp_md5_hash_skb_data(struct tcp_sigpool *hp,
 			  const struct sk_buff *skb, unsigned int header_len)
 {
 	struct scatterlist sg;
 	const struct tcphdr *tp = tcp_hdr(skb);
-	struct ahash_request *req = hp->md5_req;
+	struct ahash_request *req = hp->req;
 	unsigned int i;
 	const unsigned int head_data_len = skb_headlen(skb) > header_len ?
 					   skb_headlen(skb) - header_len : 0;
@@ -4538,16 +4482,17 @@ int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *hp,
 }
 EXPORT_SYMBOL(tcp_md5_hash_skb_data);
 
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
index 8320d0ecb13a..6701af5922cb 100644
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
@@ -1237,8 +1233,13 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 	struct tcp_sock *tp = tcp_sk(sk);
 
 	if (!rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk))) {
-		if (tcp_md5sig_info_add(sk, GFP_KERNEL))
+		if (tcp_md5_alloc_sigpool())
+			return -ENOMEM;
+
+		if (tcp_md5sig_info_add(sk, GFP_KERNEL)) {
+			tcp_md5_release_sigpool();
 			return -ENOMEM;
+		}
 
 		if (!static_branch_inc(&tcp_md5_needed.key)) {
 			struct tcp_md5sig_info *md5sig;
@@ -1246,6 +1247,7 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
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
+	tcp_sigpool_end();
 	return 0;
 
 clear_hash:
-	tcp_put_md5sig_pool();
-clear_hash_noput:
+	tcp_sigpool_end();
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
+	tcp_sigpool_end();
 	return 0;
 
 clear_hash:
-	tcp_put_md5sig_pool();
-clear_hash_noput:
+	tcp_sigpool_end();
+clear_hash_nostart:
 	memset(md5_hash, 0, 16);
 	return 1;
 }
@@ -2285,6 +2286,18 @@ static int tcp_v4_init_sock(struct sock *sk)
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
@@ -2309,10 +2322,12 @@ void tcp_v4_destroy_sock(struct sock *sk)
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
index e002f2e1d4f2..0219c0e5e2df 100644
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
index 000000000000..2fbd6795ced6
--- /dev/null
+++ b/net/ipv4/tcp_sigpool.c
@@ -0,0 +1,333 @@
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
+static unsigned long __scratch_size;
+static DEFINE_PER_CPU(void __rcu *, sigpool_scratch);
+
+struct sigpool_entry {
+	struct ahash_request * __percpu *req;
+	const char			*alg;
+	struct kref			kref;
+	bool				needs_key;
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
+/*
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
+static int __cpool_alloc_ahash(struct sigpool_entry *e, const char *alg)
+{
+	struct crypto_ahash *hash, *cpu0_hash;
+	int cpu, ret = -ENOMEM;
+
+	e->alg = kstrdup(alg, GFP_KERNEL);
+	if (!e->alg)
+		return -ENOMEM;
+
+	e->req = alloc_percpu(struct ahash_request *);
+	if (!e->req)
+		goto out_free_alg;
+
+	cpu0_hash = crypto_alloc_ahash(alg, 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(cpu0_hash)) {
+		ret = PTR_ERR(cpu0_hash);
+		goto out_free_req;
+	}
+
+	/* If hash has .setkey(), allocate ahash per-CPU, not only request */
+	e->needs_key = crypto_ahash_get_flags(cpu0_hash) & CRYPTO_TFM_NEED_KEY;
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
+		*per_cpu_ptr(e->req, cpu) = req;
+
+		if (e->needs_key)
+			hash = NULL;
+	}
+	kref_init(&e->kref);
+	return 0;
+
+out_free_hash:
+	if (hash != cpu0_hash)
+		crypto_free_ahash(hash);
+
+out_free_per_cpu:
+	for_each_possible_cpu(cpu) {
+		struct ahash_request *req = *per_cpu_ptr(e->req, cpu);
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
+	crypto_free_ahash(cpu0_hash);
+out_free_req:
+	free_percpu(e->req);
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
+		if (cpool[i].alg && !strcmp(cpool[i].alg, alg)) {
+			if (kref_read(&cpool[i].kref) > 0)
+				kref_get(&cpool[i].kref);
+			else
+				kref_init(&cpool[i].kref);
+			ret = i;
+			goto out;
+		}
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
+static void __cpool_free_entry(struct sigpool_entry *e)
+{
+	struct crypto_ahash *hash = NULL;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		if (*per_cpu_ptr(e->req, cpu) == NULL)
+			continue;
+
+		hash = crypto_ahash_reqtfm(*per_cpu_ptr(e->req, cpu));
+		ahash_request_free(*per_cpu_ptr(e->req, cpu));
+		if (e->needs_key) {
+			crypto_free_ahash(hash);
+			hash = NULL;
+		}
+	}
+	if (hash)
+		crypto_free_ahash(hash);
+	free_percpu(e->req);
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
+	c->req = *this_cpu_ptr(cpool[id].req);
+	/* Pairs with tcp_sigpool_reserve_scratch(), scratch area is
+	 * valid (allocated) until tcp_sigpool_end().
+	 */
+	c->scratch = rcu_dereference_bh(*this_cpu_ptr(&sigpool_scratch));
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tcp_sigpool_start);
+
+/**
+ * tcp_sigpool_algo - return algorithm of tcp_sigpool
+ * @id: tcp_sigpool that was previously allocated by tcp_sigpool_alloc_ahash()
+ * @buf: buffer to return name of algorithm
+ * @buf_len: size of @buf
+ */
+size_t tcp_sigpool_algo(unsigned int id, char *buf, size_t buf_len)
+{
+	size_t ret = 0;
+
+	/* slow-path */
+	mutex_lock(&cpool_mutex);
+	if (cpool[id].alg)
+		ret = strscpy(buf, cpool[id].alg, buf_len);
+	mutex_unlock(&cpool_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tcp_sigpool_algo);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Per-CPU pool of crypto requests");
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 11b736a76bd7..116319d56ab2 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -672,7 +672,7 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 			      cmd.tcpm_key, cmd.tcpm_keylen);
 }
 
-static int tcp_v6_md5_hash_headers(struct tcp_md5sig_pool *hp,
+static int tcp_v6_md5_hash_headers(struct tcp_sigpool *hp,
 				   const struct in6_addr *daddr,
 				   const struct in6_addr *saddr,
 				   const struct tcphdr *th, int nbytes)
@@ -693,39 +693,36 @@ static int tcp_v6_md5_hash_headers(struct tcp_md5sig_pool *hp,
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
+	tcp_sigpool_end();
 	return 0;
 
 clear_hash:
-	tcp_put_md5sig_pool();
-clear_hash_noput:
+	tcp_sigpool_end();
+clear_hash_nostart:
 	memset(md5_hash, 0, 16);
 	return 1;
 }
@@ -736,8 +733,7 @@ static int tcp_v6_md5_hash_skb(char *md5_hash,
 			       const struct sk_buff *skb)
 {
 	const struct in6_addr *saddr, *daddr;
-	struct tcp_md5sig_pool *hp;
-	struct ahash_request *req;
+	struct tcp_sigpool hp;
 	const struct tcphdr *th = tcp_hdr(skb);
 
 	if (sk) { /* valid for establish/request sockets */
@@ -749,30 +745,28 @@ static int tcp_v6_md5_hash_skb(char *md5_hash,
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
+	tcp_sigpool_end();
 	return 0;
 
 clear_hash:
-	tcp_put_md5sig_pool();
-clear_hash_noput:
+	tcp_sigpool_end();
+clear_hash_nostart:
 	memset(md5_hash, 0, 16);
 	return 1;
 }
-- 
2.39.1

