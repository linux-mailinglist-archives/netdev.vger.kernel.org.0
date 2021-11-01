Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF4B441E60
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 17:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbhKAQiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 12:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232747AbhKAQiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 12:38:11 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BBBC0613F5;
        Mon,  1 Nov 2021 09:35:38 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id g14so4243444edz.2;
        Mon, 01 Nov 2021 09:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h9tJUW4JxbCoyJ/gtajz5JSySNqvffjcQJCzSSjWfuo=;
        b=BkYXYAA/DJ9dyJviGuE19tB5ytP/pP+cwRgIruX1XxI+ctwYD8GtIGb/CZ6NKZq/fa
         FvH8C7Sa9K2Hn0xEaBYsY+RWxAfQVlyb9EvnqgMWUe/QA849KH2cIFnoYLpJ7LuzQS7o
         b72HqP0/GyufoFzij1Z8CY0BAYCQl9bgMY4yh4qAw6b+t8VfkCx1WpU8V43LHjnFBQYa
         Kr5UddcUgUZHiCmo+IrD6VUbg9sjClvTN+uWEWxR9ZhiRVc1+6j/7S3i3TkQIghPw4Xc
         dKHJi9ZTzu5XO9iVWmlJKbBDC48XTJvfkUlE8WDUCVoEX6Pn/BK6RPuB1JY07FGElSip
         YmdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h9tJUW4JxbCoyJ/gtajz5JSySNqvffjcQJCzSSjWfuo=;
        b=L1lqB6/Tw8DKATsmb95ug3JRjJNIEzYMI0nRPvw0HpqDeXJKhrSGJJ49JrK4xeDa7T
         nyGfxw2+Z0LRuOoguJYFVrL7OUGtG+R1/OXgqQEiNNzewtZlsSjoPgoYMz4iGLnaQ6q6
         Ng3APUXysYZxNuvfc3eXIYJXvaqTMaIZvV/RRefdLkfhx4dPBKPdNM1zy/oTj6yzf5mh
         aNTTY1EnhePWRknNQBti18Lh0hoqUvHElIqdrUGREAdo3K9Fe1+faEG3nVynTLtI/885
         /7VTo4IeBEpxZNSfSOZ07A0kajwROUjGB03LvZK+BBKn6Q/kaFOvtuUsfeT2iruaZmtF
         7X9A==
X-Gm-Message-State: AOAM533naSLnq68G3oJD7IzETaYVNvNwQC9lAclW7JvxwadAGmujAlJG
        cZQCe7W7LxldhRnJUEfUCX8=
X-Google-Smtp-Source: ABdhPJzVZVduHGLCfOHgVYB8X4CHMtlGlXraegVsPQYjRW1O7akGs3BdmhgHT27qvLlqy+RJnLafbw==
X-Received: by 2002:a17:906:1683:: with SMTP id s3mr24574108ejd.331.1635784536531;
        Mon, 01 Nov 2021 09:35:36 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:f5f:2085:7f25:17c])
        by smtp.gmail.com with ESMTPSA id f25sm4124583edv.90.2021.11.01.09.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:35:36 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 05/25] tcp: authopt: Add crypto initialization
Date:   Mon,  1 Nov 2021 18:34:40 +0200
Message-Id: <2823e719bde4b055593325c6929d5b25d664b752.1635784253.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1635784253.git.cdleonard@gmail.com>
References: <cover.1635784253.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 include/net/tcp_authopt.h |  16 ++++
 net/ipv4/tcp_authopt.c    | 166 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 182 insertions(+)

diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index 42ad764e98c2..5217b6c7c900 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -2,10 +2,24 @@
 #ifndef _LINUX_TCP_AUTHOPT_H
 #define _LINUX_TCP_AUTHOPT_H
 
 #include <uapi/linux/tcp.h>
 
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
  * Key structure lifetime is only protected by RCU so readers needs to hold a
  * single rcu_read_lock until they're done with the key.
@@ -27,10 +41,12 @@ struct tcp_authopt_key_info {
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
index c412a712f229..5455a9ecfe6b 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -3,10 +3,164 @@
 #include <linux/kernel.h>
 #include <net/tcp.h>
 #include <net/tcp_authopt.h>
 #include <crypto/hash.h>
 
+/* All current algorithms have a mac length of 12 but crypto API digestsize can be larger */
+#define TCP_AUTHOPT_MAXMACBUF			20
+#define TCP_AUTHOPT_MAX_TRAFFIC_KEY_LEN		20
+#define TCP_AUTHOPT_MACLEN			12
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
+	/* shared crypto_shash */
+	struct mutex init_mutex;
+	bool init_done;
+	struct crypto_shash * __percpu *tfms;
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
+static void __tcp_authopt_alg_free(struct tcp_authopt_alg_imp *alg)
+{
+	int cpu;
+	struct crypto_shash *tfm;
+
+	if (!alg->tfms)
+		return;
+	for_each_possible_cpu(cpu) {
+		tfm = *per_cpu_ptr(alg->tfms, cpu);
+		if (tfm) {
+			crypto_free_shash(tfm);
+			*per_cpu_ptr(alg->tfms, cpu) = NULL;
+		}
+	}
+	free_percpu(alg->tfms);
+	alg->tfms = NULL;
+}
+
+static int __tcp_authopt_alg_init(struct tcp_authopt_alg_imp *alg)
+{
+	struct crypto_shash *tfm;
+	int cpu;
+	int err;
+
+	BUILD_BUG_ON(TCP_AUTHOPT_MAXMACBUF < TCPOLEN_AUTHOPT_OUTPUT);
+	if (WARN_ON_ONCE(alg->traffic_key_len > TCP_AUTHOPT_MAX_TRAFFIC_KEY_LEN))
+		return -ENOBUFS;
+
+	alg->tfms = alloc_percpu(struct crypto_shash *);
+	if (!alg->tfms)
+		return -ENOMEM;
+	for_each_possible_cpu(cpu) {
+		tfm = crypto_alloc_shash(alg->alg_name, 0, 0);
+		if (IS_ERR(tfm)) {
+			err = PTR_ERR(tfm);
+			goto out_err;
+		}
+
+		/* sanity checks: */
+		if (WARN_ON_ONCE(crypto_shash_digestsize(tfm) != alg->traffic_key_len)) {
+			err = -EINVAL;
+			goto out_err;
+		}
+		if (WARN_ON_ONCE(crypto_shash_digestsize(tfm) > TCP_AUTHOPT_MAXMACBUF)) {
+			err = -EINVAL;
+			goto out_err;
+		}
+
+		*per_cpu_ptr(alg->tfms, cpu) = tfm;
+	}
+	return 0;
+
+out_err:
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
+static struct crypto_shash *tcp_authopt_alg_get_tfm(struct tcp_authopt_alg_imp *alg)
+{
+	preempt_disable();
+	return *this_cpu_ptr(alg->tfms);
+}
+
+static void tcp_authopt_alg_put_tfm(struct tcp_authopt_alg_imp *alg, struct crypto_shash *tfm)
+{
+	WARN_ON(tfm != *this_cpu_ptr(alg->tfms));
+	preempt_enable();
+}
+
+static struct crypto_shash *tcp_authopt_get_kdf_shash(struct tcp_authopt_key_info *key)
+{
+	return tcp_authopt_alg_get_tfm(key->alg);
+}
+
+static void tcp_authopt_put_kdf_shash(struct tcp_authopt_key_info *key,
+				      struct crypto_shash *tfm)
+{
+	return tcp_authopt_alg_put_tfm(key->alg, tfm);
+}
+
+static struct crypto_shash *tcp_authopt_get_mac_shash(struct tcp_authopt_key_info *key)
+{
+	return tcp_authopt_alg_get_tfm(key->alg);
+}
+
+static void tcp_authopt_put_mac_shash(struct tcp_authopt_key_info *key,
+				      struct crypto_shash *tfm)
+{
+	return tcp_authopt_alg_put_tfm(key->alg, tfm);
+}
+
 /* checks that ipv4 or ipv6 addr matches. */
 static bool ipvx_addr_match(struct sockaddr_storage *a1,
 			    struct sockaddr_storage *a2)
 {
 	if (a1->ss_family != a2->ss_family)
@@ -202,10 +356,11 @@ void tcp_authopt_clear(struct sock *sk)
 int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 {
 	struct tcp_authopt_key opt;
 	struct tcp_authopt_info *info;
 	struct tcp_authopt_key_info *key_info, *old_key_info;
+	struct tcp_authopt_alg_imp *alg;
 	int err;
 
 	sock_owned_by_me(sk);
 
 	err = _copy_from_sockptr_tolerant((u8 *)&opt, sizeof(opt), optval, optlen);
@@ -239,10 +394,20 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
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
 	key_info = sock_kmalloc(sk, sizeof(*key_info), GFP_KERNEL | __GFP_ZERO);
 	if (!key_info)
 		return -ENOMEM;
 	/* If an old key exists with exact ID then remove and replace.
 	 * RCU-protected readers might observe both and pick any.
@@ -252,10 +417,11 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 		tcp_authopt_key_del(sk, info, old_key_info);
 	key_info->flags = opt.flags & TCP_AUTHOPT_KEY_KNOWN_FLAGS;
 	key_info->send_id = opt.send_id;
 	key_info->recv_id = opt.recv_id;
 	key_info->alg_id = opt.alg;
+	key_info->alg = alg;
 	key_info->keylen = opt.keylen;
 	memcpy(key_info->key, opt.key, opt.keylen);
 	memcpy(&key_info->addr, &opt.addr, sizeof(key_info->addr));
 	hlist_add_head_rcu(&key_info->node, &info->head);
 
-- 
2.25.1

