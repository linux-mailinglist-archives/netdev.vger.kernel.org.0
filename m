Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A459D413729
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 18:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234500AbhIUQSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 12:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234497AbhIUQSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 12:18:23 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02DB1C0613CF;
        Tue, 21 Sep 2021 09:16:51 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id g8so76403210edt.7;
        Tue, 21 Sep 2021 09:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k7p7QaTSoTZWLvuDt7GtkWZSqdjOhyzdDvUctatw7Fo=;
        b=oWOFbYW1gjoYkv/W6G+lPtM4GuoH3Fcvu+QrAvbXISECYQ07E6LUrNaoSRCf6Lf+FX
         k3RVAcWwTF+9287kvXsT4XyUNoGDa6NM8V9JPAfkL4f2HPIoZLoas+QF6wvCj/526vj5
         i1XOuxeX1GTDdbxigmdqRmF3A7HoD2mrQIyP+RW3Htvo1/twzYRVylT3paTJSAp9JTPN
         8LOQs9gjvE/eGaBvfMKJZHdFxYlz/pDsnc4h60EnT4+kcZ1Q5Eq3jFtgK4chk8e31JoV
         lQelqyv0QI8zXPR/Gq0QWUnCR7MBB68KIt/oGpeabTps26I4VnXW37b0qZE0ZcyibVoP
         iGUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k7p7QaTSoTZWLvuDt7GtkWZSqdjOhyzdDvUctatw7Fo=;
        b=Nouy6STaD1RY8Q4mr+CpgHWMWhTiIflVBhH7zd7z9x2/Ms+HRknL6WC8dEV6ix4qQ5
         FsLCy3Ft948nMNbBJV2c5ydIqoE6Hlh04yWTvsh5JyzRozkpsoKiahSDH7Q+7qme+ZjV
         llKd/a4PXOd2zLoGkyHp2LH1ZCZ42MrNgT05y1IA+y5JIctqnYBsPwxm8JF3WDJ1xWB/
         LXHtEw6zHayf1UIcAppLJlh1JWvsJulUewpLGmmOuxse6VMNOMQZ3dDc63MUS26WwAFb
         idzhhgZTtrwuyjwcJ2NU7OWL2OUWYj1b5mgAa/HSlGfFknbA+sPF9nPwdxBWmiOyC5s+
         5f/w==
X-Gm-Message-State: AOAM531dX/Ty8auAcAs3ZSjRs+EC5/Jzdas1D0mVs2h2D8v1krAMYxO5
        Mubopk/Kh5jn8NaDcLkZJaA=
X-Google-Smtp-Source: ABdhPJxRqxWpjIVx7eTB5IaEK5vZ1zXnQx3Xwt+6BHoE6U+3ZhuLFloVnBcCqvRbaLZ/T8i12idO3Q==
X-Received: by 2002:a17:906:a18f:: with SMTP id s15mr36911009ejy.269.1632240924153;
        Tue, 21 Sep 2021 09:15:24 -0700 (PDT)
Received: from pinky.lan ([2a04:241e:502:1df0:b065:9bdf:4016:277])
        by smtp.gmail.com with ESMTPSA id kx17sm7674075ejc.51.2021.09.21.09.15.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 09:15:23 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
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
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/19] tcp: authopt: Add crypto initialization
Date:   Tue, 21 Sep 2021 19:14:48 +0300
Message-Id: <5707b6b12d5329f43f76daaabbb270ea7ec3e640.1632240523.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1632240523.git.cdleonard@gmail.com>
References: <cover.1632240523.git.cdleonard@gmail.com>
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
 include/net/tcp_authopt.h |  15 ++++
 net/ipv4/tcp_authopt.c    | 167 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 182 insertions(+)

diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index 19d304de18f8..f6d7d6fa50c0 100644
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
@@ -18,10 +32,11 @@ struct tcp_authopt_key_info {
 	u8 send_id, recv_id;
 	u8 alg_id;
 	u8 keylen;
 	u8 key[TCP_AUTHOPT_MAXKEYLEN];
 	struct sockaddr_storage addr;
+	struct tcp_authopt_alg_imp *alg;
 };
 
 /**
  * struct tcp_authopt_info - Per-socket information regarding tcp_authopt
  *
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index a771e5754c8a..a682f88509aa 100644
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
+	alg->tfms = alloc_percpu(struct crypto_shash*);
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
@@ -201,10 +355,12 @@ void tcp_authopt_clear(struct sock *sk)
 int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 {
 	struct tcp_authopt_key opt;
 	struct tcp_authopt_info *info;
 	struct tcp_authopt_key_info *key_info, *old_key_info;
+	struct tcp_authopt_alg_imp *alg;
+	int err;
 
 	sock_owned_by_me(sk);
 
 	err = _copy_from_sockptr_tolerant((u8*)&opt, sizeof(opt), optval, optlen);
 	if (err)
@@ -237,10 +393,20 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
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
@@ -249,10 +415,11 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
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

