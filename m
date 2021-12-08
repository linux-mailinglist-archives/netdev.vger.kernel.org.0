Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27CB446D261
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 12:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbhLHLlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 06:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232545AbhLHLlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 06:41:37 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132ADC0617A1;
        Wed,  8 Dec 2021 03:38:04 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id o20so7315617eds.10;
        Wed, 08 Dec 2021 03:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RFw2RQjkTFDoBaa82P8+bnSrEcpG6WIvemEsOajZP3k=;
        b=ltCI6OHobpahrmB4ku0odAN9yfTkO6TRmS9ckIjlouMrngD+IFhrOqQHj9pOF66QME
         MnVi9Pfjzws308bxGaIeFsqpzMUxGxduOVpK4TZ7sKHCXNuhtrdJqEUQSoMAyYanEz/y
         elxHTunZwMER1AO2y0+LmZRooY2rEBzGpvuwYghY85YDZ50/dsb94dyjqxrW1r531UV/
         zY92pxoYvRJRficWSIDliFJq5cf3P0Bq1Uxgt3pVg5o7BZDEOHab8Ra6N2VMrpO97ICd
         pbAHSw7Ox17ofKN3kH6jyFKk1BSgptczH5OcBAM07Cr1SWRXLksQoNC1JLERvODnsFP3
         obSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RFw2RQjkTFDoBaa82P8+bnSrEcpG6WIvemEsOajZP3k=;
        b=ZTdZqFbaz+dsQmiC46QSzgyawuD/tVeezyfPaFwVw50J3VWxnVPsvUbfbDH6kkLamI
         yNUmjagB6co/vWIL/SPFyyf3kZvXHMhVHQK8531nz++byFErvzdeusw/HGMGaSXgFwbP
         pU5qK8BOSvrqvhEa5sxixHTjkFhs/0/N078eH5dYJv6D6OxA0Z5Qu//SBJMAPP0CUpKh
         lgBc4W3XsaPn/lTlf+ly9bz6dyioqYP49SRfpzOJjN0sPVbbqeSNBfXX8IN4S+rbkoLD
         t/2NuVaB2GUqTv62GgJS2PLAP48Yp3pck9hToty6Ij2qPjZ7MWHK6uswCkbVFrRuYYXi
         A+5w==
X-Gm-Message-State: AOAM530r00CFLnqUjrDre6RLwpA+czrifH2mzWnmj4jUtHZk9YtcW6wl
        QJ4arXSOMTy3Bnc6KVUUPBs=
X-Google-Smtp-Source: ABdhPJxHW9Mg1vngFawSOz3rnVyHEg/j9692rU0zHHAA9zds/d001sGEVDA9cGAXFKzI9s6a5YSF7g==
X-Received: by 2002:a05:6402:3481:: with SMTP id v1mr19060285edc.337.1638963482620;
        Wed, 08 Dec 2021 03:38:02 -0800 (PST)
Received: from ponky.lan ([2a04:241e:501:3870:3c9f:e05b:4dff:43ba])
        by smtp.gmail.com with ESMTPSA id g11sm1883810edz.53.2021.12.08.03.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 03:38:02 -0800 (PST)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Francesco Ruggeri <fruggeri@arista.com>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 03/18] tcp: authopt: Add crypto initialization
Date:   Wed,  8 Dec 2021 13:37:18 +0200
Message-Id: <4b46ef74e1504c2377e9d7c22b2882e3424dfbd8.1638962992.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1638962992.git.cdleonard@gmail.com>
References: <cover.1638962992.git.cdleonard@gmail.com>
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
index e6740ef29a84..478969d53094 100644
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
+	local_bh_disable();
+	return *this_cpu_ptr(alg->tfms);
+}
+
+static void tcp_authopt_alg_put_tfm(struct tcp_authopt_alg_imp *alg, struct crypto_shash *tfm)
+{
+	WARN_ON(tfm != *this_cpu_ptr(alg->tfms));
+	local_bh_enable();
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

