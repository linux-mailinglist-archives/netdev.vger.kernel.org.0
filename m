Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC25580B20
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 08:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237673AbiGZGQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 02:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237490AbiGZGPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 02:15:49 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4DAAE53;
        Mon, 25 Jul 2022 23:15:47 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id i13so7382012edj.11;
        Mon, 25 Jul 2022 23:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dNut1tYrnFJpk8I6+5NwfzPqP/nyk6YyQOFAs7t5ZVg=;
        b=NLo+A1qwzqlhHU1a022A5mzpSl92rZYp1Eeer7j8Kw3r2n5KvL2j/1G/daoBBtypb3
         r8/4lSOBW5v3v4WdNX+pd+/cHlO6Ur4/Gl3gGbHtb9Q9LJ1Wse9rBSUhs0fxnGiwi99f
         4RilOx/JjGWdZh1z2HAMCD7QG8Wx6ja4pYZcYw2lc8lcl2i+Gmfnqs1aeqJE4Q9x89Bb
         j0n6iwTGvqo56bcLJpNM5R3G6djPk61TSoAewrBJFmfP5ijTP9sk20ZYLJP6IFVZi1I+
         BkmDhyz1EBMezV2vyx6O2T8Uwas7qhSIGg4PV43UYsQgiqVffl6F5thkMUVL218T8ASn
         9FlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dNut1tYrnFJpk8I6+5NwfzPqP/nyk6YyQOFAs7t5ZVg=;
        b=4S1upVLKpRXkU1hZWnFh6a+DXWrc5/yViq8P3WPuRVxOKR9nFz99lrcsIy9X/yCPrH
         6zfDfODkiQGHGFN/QITQU1qz7WnIQlUvLjvnQvizeKbQ+MUZL2Sl7Sfd73WHEOLYdveo
         OH6DM5+AbH4wFRHnMxGTzIElRqfj64/hjZCqpWt/4L7lpGf+ZRw7tFmqeRGFbGwPqw2z
         smc2fv3/RT73d5IKK9h4HQLfi+WIknr1IS/GAsT+Vj42FrsJFSJ5Cu0j4FqPZZ4h5iXu
         XKxRkVDkpwfvjC3M4VhvgXj1A079xE+ITEfCDUkIj+aAqzZFJdlAa0Pq9HuiUIr5/mE4
         28jw==
X-Gm-Message-State: AJIora8fyCIiKeJIErClR/FEoAoP+Yqt+KvLppyKL9/EWblxi5G1UGEH
        ICb0IZYlzNo2s+44VR9ew6Y=
X-Google-Smtp-Source: AGRyM1sGzzCON7MzVAjqqeGQ+eo/1vpbGqkIK0PNKgM3dgSpWCP8h7ZyTM4yTv+b4A0spLHZlGgMdg==
X-Received: by 2002:a05:6402:44d:b0:43b:e6e2:c98 with SMTP id p13-20020a056402044d00b0043be6e20c98mr11607700edw.323.1658816145601;
        Mon, 25 Jul 2022 23:15:45 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:2b68:36a:5a94:4ba1])
        by smtp.gmail.com with ESMTPSA id l23-20020a056402345700b0043ba7df7a42sm8133067edc.26.2022.07.25.23.15.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 23:15:45 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 04/26] tcp: authopt: Add crypto initialization
Date:   Tue, 26 Jul 2022 09:15:06 +0300
Message-Id: <021c05d5a2cd4d139bdb65e60c604a823bea5fab.1658815925.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1658815925.git.cdleonard@gmail.com>
References: <cover.1658815925.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The crypto_shash API is used in order to compute packet signatures. The
API comes with several unfortunate limitations:

1) Allocating a crypto_shash can sleep and must be done in user context.
2) Packet signatures must be computed in softirq context
3) Packet signatures use dynamic "traffic keys" which require exclusive
access to crypto_shash for crypto_setkey.

The solution is to allocate one crypto_shash for each possible cpu for
each algorithm at setsockopt time. The per-cpu tfm is then borrowed from
softirq context, signatures are computed and the tfm is returned.

The pool for each algorithm is allocated on first use.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/net/tcp_authopt.h |  16 +++
 net/ipv4/tcp_authopt.c    | 199 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 214 insertions(+), 1 deletion(-)

diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index bc2cff82830d..ed9995c8d486 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -4,10 +4,24 @@
 
 #include <uapi/linux/tcp.h>
 #include <net/netns/tcp_authopt.h>
 #include <linux/tcp.h>
 
+/* According to RFC5925 the length of the authentication option varies based on
+ * the signature algorithm. Linux only implements the algorithms defined in
+ * RFC5926 which have a constant length of 16.
+ *
+ * This is used in stack allocation of tcp option buffers for output. It is
+ * shorter than the length of the MD5 option.
+ *
+ * Input packets can have authentication options of different lengths but they
+ * will always be flagged as invalid (since no such algorithms are supported).
+ */
+#define TCPOLEN_AUTHOPT_OUTPUT	16
+
+struct tcp_authopt_alg_imp;
+
 /**
  * struct tcp_authopt_key_info - Representation of a Master Key Tuple as per RFC5925
  *
  * Key structure lifetime is protected by RCU so send/recv code needs to hold a
  * single rcu_read_lock until they're done with the key.
@@ -33,10 +47,12 @@ struct tcp_authopt_key_info {
 	u8 keylen;
 	/** @key: Same as &tcp_authopt_key.key */
 	u8 key[TCP_AUTHOPT_MAXKEYLEN];
 	/** @addr: Same as &tcp_authopt_key.addr */
 	struct sockaddr_storage addr;
+	/** @alg: Algorithm implementation matching alg_id */
+	struct tcp_authopt_alg_imp *alg;
 };
 
 /**
  * struct tcp_authopt_info - Per-socket information regarding tcp_authopt
  *
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index d38e9c89c89d..005fac36760b 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -2,15 +2,201 @@
 
 #include <net/tcp_authopt.h>
 #include <net/ipv6.h>
 #include <net/tcp.h>
 #include <linux/kref.h>
+#include <crypto/hash.h>
 
 /* This is enabled when first struct tcp_authopt_info is allocated and never released */
 DEFINE_STATIC_KEY_FALSE(tcp_authopt_needed_key);
 EXPORT_SYMBOL(tcp_authopt_needed_key);
 
+/* All current algorithms have a mac length of 12 but crypto API digestsize can be larger */
+#define TCP_AUTHOPT_MAXMACBUF			20
+#define TCP_AUTHOPT_MAX_TRAFFIC_KEY_LEN		20
+#define TCP_AUTHOPT_MACLEN			12
+
+struct tcp_authopt_alg_pool {
+	struct crypto_ahash *tfm;
+	struct ahash_request *req;
+};
+
+/* Constant data with per-algorithm information from RFC5926
+ * The "KDF" and "MAC" happen to be the same for both algorithms.
+ */
+struct tcp_authopt_alg_imp {
+	/* Name of algorithm in crypto-api */
+	const char *alg_name;
+	/* One of the TCP_AUTHOPT_ALG_* constants from uapi */
+	u8 alg_id;
+	/* Length of traffic key */
+	u8 traffic_key_len;
+
+	/* shared crypto_ahash */
+	struct mutex init_mutex;
+	bool init_done;
+	struct tcp_authopt_alg_pool __percpu *pool;
+};
+
+static struct tcp_authopt_alg_imp tcp_authopt_alg_list[] = {
+	{
+		.alg_id = TCP_AUTHOPT_ALG_HMAC_SHA_1_96,
+		.alg_name = "hmac(sha1)",
+		.traffic_key_len = 20,
+		.init_mutex = __MUTEX_INITIALIZER(tcp_authopt_alg_list[0].init_mutex),
+	},
+	{
+		.alg_id = TCP_AUTHOPT_ALG_AES_128_CMAC_96,
+		.alg_name = "cmac(aes)",
+		.traffic_key_len = 16,
+		.init_mutex = __MUTEX_INITIALIZER(tcp_authopt_alg_list[1].init_mutex),
+	},
+};
+
+/* get a pointer to the tcp_authopt_alg instance or NULL if id invalid */
+static inline struct tcp_authopt_alg_imp *tcp_authopt_alg_get(int alg_num)
+{
+	if (alg_num <= 0 || alg_num > 2)
+		return NULL;
+	return &tcp_authopt_alg_list[alg_num - 1];
+}
+
+static int tcp_authopt_alg_pool_init(struct tcp_authopt_alg_imp *alg,
+				     struct tcp_authopt_alg_pool *pool)
+{
+	pool->tfm = crypto_alloc_ahash(alg->alg_name, 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(pool->tfm))
+		return PTR_ERR(pool->tfm);
+
+	pool->req = ahash_request_alloc(pool->tfm, GFP_ATOMIC);
+	if (IS_ERR(pool->req))
+		return PTR_ERR(pool->req);
+	ahash_request_set_callback(pool->req, 0, NULL, NULL);
+
+	return 0;
+}
+
+static void tcp_authopt_alg_pool_free(struct tcp_authopt_alg_pool *pool)
+{
+	if (!IS_ERR_OR_NULL(pool->req))
+		ahash_request_free(pool->req);
+	pool->req = NULL;
+	if (!IS_ERR_OR_NULL(pool->tfm))
+		crypto_free_ahash(pool->tfm);
+	pool->tfm = NULL;
+}
+
+static void __tcp_authopt_alg_free(struct tcp_authopt_alg_imp *alg)
+{
+	int cpu;
+	struct tcp_authopt_alg_pool *pool;
+
+	if (!alg->pool)
+		return;
+	for_each_possible_cpu(cpu) {
+		pool = per_cpu_ptr(alg->pool, cpu);
+		tcp_authopt_alg_pool_free(pool);
+	}
+	free_percpu(alg->pool);
+	alg->pool = NULL;
+}
+
+static int __tcp_authopt_alg_init(struct tcp_authopt_alg_imp *alg)
+{
+	struct tcp_authopt_alg_pool *pool;
+	int cpu;
+	int err;
+
+	BUILD_BUG_ON(TCP_AUTHOPT_MAXMACBUF < TCPOLEN_AUTHOPT_OUTPUT);
+	if (WARN_ON_ONCE(alg->traffic_key_len > TCP_AUTHOPT_MAX_TRAFFIC_KEY_LEN))
+		return -ENOBUFS;
+
+	alg->pool = alloc_percpu(struct tcp_authopt_alg_pool);
+	if (!alg->pool)
+		return -ENOMEM;
+	for_each_possible_cpu(cpu) {
+		pool = per_cpu_ptr(alg->pool, cpu);
+		err = tcp_authopt_alg_pool_init(alg, pool);
+		if (err)
+			goto out_err;
+
+		pool = per_cpu_ptr(alg->pool, cpu);
+		/* sanity checks: */
+		if (WARN_ON_ONCE(crypto_ahash_digestsize(pool->tfm) != alg->traffic_key_len)) {
+			err = -EINVAL;
+			goto out_err;
+		}
+		if (WARN_ON_ONCE(crypto_ahash_digestsize(pool->tfm) > TCP_AUTHOPT_MAXMACBUF)) {
+			err = -EINVAL;
+			goto out_err;
+		}
+	}
+	return 0;
+
+out_err:
+	pr_info("Failed to initialize %s\n", alg->alg_name);
+	__tcp_authopt_alg_free(alg);
+	return err;
+}
+
+static int tcp_authopt_alg_require(struct tcp_authopt_alg_imp *alg)
+{
+	int err = 0;
+
+	mutex_lock(&alg->init_mutex);
+	if (alg->init_done)
+		goto out;
+	err = __tcp_authopt_alg_init(alg);
+	if (err)
+		goto out;
+	pr_info("initialized tcp-ao algorithm %s", alg->alg_name);
+	alg->init_done = true;
+
+out:
+	mutex_unlock(&alg->init_mutex);
+	return err;
+}
+
+static struct tcp_authopt_alg_pool *tcp_authopt_alg_get_pool(struct tcp_authopt_alg_imp *alg)
+{
+	local_bh_disable();
+	return this_cpu_ptr(alg->pool);
+}
+
+static void tcp_authopt_alg_put_pool(struct tcp_authopt_alg_imp *alg,
+				     struct tcp_authopt_alg_pool *pool)
+{
+	WARN_ON(pool != this_cpu_ptr(alg->pool));
+	local_bh_enable();
+}
+
+__always_unused
+static struct tcp_authopt_alg_pool *tcp_authopt_get_kdf_pool(struct tcp_authopt_key_info *key)
+{
+	return tcp_authopt_alg_get_pool(key->alg);
+}
+
+__always_unused
+static void tcp_authopt_put_kdf_pool(struct tcp_authopt_key_info *key,
+				     struct tcp_authopt_alg_pool *pool)
+{
+	return tcp_authopt_alg_put_pool(key->alg, pool);
+}
+
+__always_unused
+static struct tcp_authopt_alg_pool *tcp_authopt_get_mac_pool(struct tcp_authopt_key_info *key)
+{
+	return tcp_authopt_alg_get_pool(key->alg);
+}
+
+__always_unused
+static void tcp_authopt_put_mac_pool(struct tcp_authopt_key_info *key,
+				     struct tcp_authopt_alg_pool *pool)
+{
+	return tcp_authopt_alg_put_pool(key->alg, pool);
+}
+
 static inline struct netns_tcp_authopt *sock_net_tcp_authopt(const struct sock *sk)
 {
 	return &sock_net(sk)->tcp_authopt;
 }
 
@@ -53,11 +239,10 @@ void tcp_authopt_clear(struct sock *sk)
 	if (info) {
 		tcp_authopt_free(sk, info);
 		tcp_sk(sk)->authopt_info = NULL;
 	}
 }
-
 /* checks that ipv4 or ipv6 addr matches. */
 static bool ipvx_addr_match(struct sockaddr_storage *a1,
 			    struct sockaddr_storage *a2)
 {
 	if (a1->ss_family != a2->ss_family)
@@ -212,10 +397,11 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 {
 	struct tcp_authopt_key opt;
 	struct tcp_authopt_info *info;
 	struct tcp_authopt_key_info *key_info, *old_key_info;
 	struct netns_tcp_authopt *net = sock_net_tcp_authopt(sk);
+	struct tcp_authopt_alg_imp *alg;
 	int err;
 
 	sock_owned_by_me(sk);
 	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
@@ -253,10 +439,20 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 	/* Initialize tcp_authopt_info if not already set */
 	info = __tcp_authopt_info_get_or_create(sk);
 	if (IS_ERR(info))
 		return PTR_ERR(info);
 
+	/* check the algorithm */
+	alg = tcp_authopt_alg_get(opt.alg);
+	if (!alg)
+		return -EINVAL;
+	if (WARN_ON_ONCE(alg->alg_id != opt.alg))
+		return -EINVAL;
+	err = tcp_authopt_alg_require(alg);
+	if (err)
+		return err;
+
 	key_info = kmalloc(sizeof(*key_info), GFP_KERNEL | __GFP_ZERO);
 	if (!key_info)
 		return -ENOMEM;
 	mutex_lock(&net->mutex);
 	kref_init(&key_info->ref);
@@ -268,10 +464,11 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 		tcp_authopt_key_del(net, old_key_info);
 	key_info->flags = opt.flags & TCP_AUTHOPT_KEY_KNOWN_FLAGS;
 	key_info->send_id = opt.send_id;
 	key_info->recv_id = opt.recv_id;
 	key_info->alg_id = opt.alg;
+	key_info->alg = alg;
 	key_info->keylen = opt.keylen;
 	memcpy(key_info->key, opt.key, opt.keylen);
 	memcpy(&key_info->addr, &opt.addr, sizeof(key_info->addr));
 	hlist_add_head_rcu(&key_info->node, &net->head);
 	mutex_unlock(&net->mutex);
-- 
2.25.1

