Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0F73F6B16
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 23:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235477AbhHXVgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 17:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235483AbhHXVgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 17:36:19 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E2BBC0617A8;
        Tue, 24 Aug 2021 14:35:34 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id me10so18846182ejb.11;
        Tue, 24 Aug 2021 14:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rH4bYGauaxv2Wl+jiZaPd02GWdhR4IMZOZfUFE7drY0=;
        b=MWO7txWzOK+UA7qYaeB0ByfyroreBfP5IoTlKFGUWageT3HiILxZxtvz0OtmnuZq5N
         b/HUGHnhyElFkfuSmlPd6LhciErcOlh/4EWNqwiYBXY3eb91OXeUV4ZNyFUayypW2pTW
         KnDgNLk9/IZi7bygKl6p8WrpCqtioV+13geeytH4/U9/L61HJY0EdkKFRYlJV2PfhVG4
         bYdX+aa0A3RWlP7ZBpHfG3TAFutkyT8xKCFlLBEN7f8OE0Q1DT7i86OYNIzps3iDY3Nh
         YphheMSppTlCHVU69/xxnANkk1WZ2V5NpXAnxFiuKtfXnV+ails3XLFvYtdOehhtv7ar
         6vPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rH4bYGauaxv2Wl+jiZaPd02GWdhR4IMZOZfUFE7drY0=;
        b=uBIYuWDrwYX/ejkWjIOorfKbFCMoP3mrOAmJl0xKXWqSMRv4eVW3phWJ48k4hfHurl
         I3vH1FPFSeGXWNkLpNJxMc8ueAWPwTOn7JKctHx7aE7II9sq5LD7zDAVJXLSIpCbhzJp
         UiYJl1K29+LZXfinaPb7tB0FRxLd+xJsedzx6MF7l+jopVpzMEfthFtrilimYXoYmaAS
         1CeTZaEiLjz2DaNsJqJ3/VNIPWwp9UHLdHCUl1BiGeEYHbtTXg/TTTHIY9KyY5jvuqHh
         hIwR4vwpa9kC07MxnyitNr5s9ulXYspyCBu8MGIG+G7vbA+kj8w84K3kQ0rbJ+rq/kGh
         9Okg==
X-Gm-Message-State: AOAM530qGOoCPtItt1VZOd8NCaQ4E5Wy3H76KwchziiE4mqMJgQ7sPMW
        uKu1iCqatCr0tN3Oxm5TLeA=
X-Google-Smtp-Source: ABdhPJznRja0rsYkh10d5kdpNeqHjeMPeBMFgYdTO5pZTJuljEJfr1aDNsVRZQGwleqza+aX8ra4+A==
X-Received: by 2002:a17:906:378f:: with SMTP id n15mr16338909ejc.467.1629840932724;
        Tue, 24 Aug 2021 14:35:32 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:ed0a:7326:fbac:b4c])
        by smtp.gmail.com with ESMTPSA id d16sm12348357edu.8.2021.08.24.14.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 14:35:32 -0700 (PDT)
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
Subject: [RFCv3 05/15] tcp: authopt: Add crypto initialization
Date:   Wed, 25 Aug 2021 00:34:38 +0300
Message-Id: <abb720b34b9eef1cc52ef68017334e27a2af83c6.1629840814.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1629840814.git.cdleonard@gmail.com>
References: <cover.1629840814.git.cdleonard@gmail.com>
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

The pool for each algorithm is reference counted, initialized at
setsockopt time and released in tcp_authopt_key_info's rcu callback

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/net/tcp_authopt.h |   3 +
 net/ipv4/tcp_authopt.c    | 177 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 178 insertions(+), 2 deletions(-)

diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index b4277112b506..c9ee2059b442 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -2,10 +2,12 @@
 #ifndef _LINUX_TCP_AUTHOPT_H
 #define _LINUX_TCP_AUTHOPT_H
 
 #include <uapi/linux/tcp.h>
 
+struct tcp_authopt_alg_imp;
+
 /**
  * struct tcp_authopt_key_info - Representation of a Master Key Tuple as per RFC5925
  *
  * Key structure lifetime is only protected by RCU so readers needs to hold a
  * single rcu_read_lock until they're done with the key.
@@ -20,10 +22,11 @@ struct tcp_authopt_key_info {
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
index f6dddc5775ff..ce560bd88903 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -4,10 +4,161 @@
 #include <net/tcp.h>
 #include <net/tcp_authopt.h>
 #include <crypto/hash.h>
 #include <trace/events/tcp.h>
 
+/* All current algorithms have a mac length of 12 but crypto API digestsize can be larger */
+#define TCP_AUTHOPT_MAXMACBUF	20
+#define TCP_AUTHOPT_MAX_TRAFFIC_KEY_LEN	20
+
+struct tcp_authopt_alg_imp {
+	/* Name of algorithm in crypto-api */
+	const char *alg_name;
+	/* One of the TCP_AUTHOPT_ALG_* constants from uapi */
+	u8 alg_id;
+	/* Length of traffic key */
+	u8 traffic_key_len;
+	/* Length of mac in TCP option */
+	u8 maclen;
+
+	/* shared crypto_shash */
+	spinlock_t lock;
+	int ref_cnt;
+	struct crypto_shash *tfm;
+};
+
+static struct tcp_authopt_alg_imp tcp_authopt_alg_list[] = {
+	{
+		.alg_id = TCP_AUTHOPT_ALG_HMAC_SHA_1_96,
+		.alg_name = "hmac(sha1)",
+		.traffic_key_len = 20,
+		.maclen = 12,
+		.lock = __SPIN_LOCK_UNLOCKED(tcp_authopt_alg_list[0].lock),
+	},
+	{
+		.alg_id = TCP_AUTHOPT_ALG_AES_128_CMAC_96,
+		.alg_name = "cmac(aes)",
+		.traffic_key_len = 16,
+		.maclen = 12,
+		.lock = __SPIN_LOCK_UNLOCKED(tcp_authopt_alg_list[1].lock),
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
+/* Mark an algorithm as in-use from user context */
+static int tcp_authopt_alg_require(struct tcp_authopt_alg_imp *alg)
+{
+	struct crypto_shash *tfm = NULL;
+	bool need_init = false;
+
+	might_sleep();
+
+	/* If we're the first user then we need to initialize shash but we might lose the race. */
+	spin_lock_bh(&alg->lock);
+	WARN_ON(alg->ref_cnt < 0);
+	if (alg->ref_cnt == 0)
+		need_init = true;
+	else
+		++alg->ref_cnt;
+	spin_unlock_bh(&alg->lock);
+
+	/* Already initialized */
+	if (!need_init)
+		return 0;
+
+	tfm = crypto_alloc_shash(alg->alg_name, 0, 0);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
+	spin_lock_bh(&alg->lock);
+	if (alg->ref_cnt == 0)
+		/* race won */
+		alg->tfm = tfm;
+	else
+		/* race lost, free tfm later */
+		need_init = false;
+	++alg->ref_cnt;
+	spin_unlock_bh(&alg->lock);
+
+	if (!need_init)
+		crypto_free_shash(tfm);
+	else
+		pr_info("initialized tcp-ao %s", alg->alg_name);
+
+	return 0;
+}
+
+static void tcp_authopt_alg_release(struct tcp_authopt_alg_imp *alg)
+{
+	struct crypto_shash *tfm_to_free = NULL;
+
+	spin_lock_bh(&alg->lock);
+	--alg->ref_cnt;
+	WARN_ON(alg->ref_cnt < 0);
+	if (alg->ref_cnt == 0) {
+		tfm_to_free = alg->tfm;
+		alg->tfm = NULL;
+	}
+	spin_unlock_bh(&alg->lock);
+
+	if (tfm_to_free) {
+		pr_info("released tcp-ao %s", alg->alg_name);
+		crypto_free_shash(tfm_to_free);
+	}
+}
+
+/* increase reference count on an algorithm that is already in use */
+static void tcp_authopt_alg_incref(struct tcp_authopt_alg_imp *alg)
+{
+	spin_lock_bh(&alg->lock);
+	WARN_ON(alg->ref_cnt <= 0);
+	++alg->ref_cnt;
+	spin_unlock_bh(&alg->lock);
+}
+
+static struct crypto_shash *tcp_authopt_alg_get_tfm(struct tcp_authopt_alg_imp *alg)
+{
+	spin_lock_bh(&alg->lock);
+	WARN_ON(alg->ref_cnt < 0);
+	return alg->tfm;
+}
+
+static void tcp_authopt_alg_put_tfm(struct tcp_authopt_alg_imp *alg, struct crypto_shash *tfm)
+{
+	WARN_ON(tfm != alg->tfm);
+	spin_unlock_bh(&alg->lock);
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
@@ -118,17 +269,25 @@ int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
 	opt->flags = info->flags & TCP_AUTHOPT_KNOWN_FLAGS;
 
 	return 0;
 }
 
+static void tcp_authopt_key_free_rcu(struct rcu_head *rcu)
+{
+	struct tcp_authopt_key_info *key = container_of(rcu, struct tcp_authopt_key_info, rcu);
+
+	tcp_authopt_alg_release(key->alg);
+	kfree(key);
+}
+
 static void tcp_authopt_key_del(struct sock *sk,
 				struct tcp_authopt_info *info,
 				struct tcp_authopt_key_info *key)
 {
 	hlist_del_rcu(&key->node);
 	atomic_sub(sizeof(*key), &sk->sk_omem_alloc);
-	kfree_rcu(key, rcu);
+	call_rcu(&key->rcu, tcp_authopt_key_free_rcu);
 }
 
 /* free info and keys but don't touch tp->authopt_info */
 static void __tcp_authopt_info_free(struct sock *sk, struct tcp_authopt_info *info)
 {
@@ -160,10 +319,12 @@ void tcp_authopt_clear(struct sock *sk)
 int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 {
 	struct tcp_authopt_key opt;
 	struct tcp_authopt_info *info;
 	struct tcp_authopt_key_info *key_info;
+	struct tcp_authopt_alg_imp *alg;
+	int err;
 
 	sock_owned_by_me(sk);
 
 	/* If userspace optlen is too short fill the rest with zeros */
 	if (optlen > sizeof(opt))
@@ -199,23 +360,35 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 	/* Initialize tcp_authopt_info if not already set */
 	info = __tcp_authopt_info_get_or_create(sk);
 	if (IS_ERR(info))
 		return PTR_ERR(info);
 
+	/* check the algorithm */
+	alg = tcp_authopt_alg_get(opt.alg);
+	if (!alg)
+		return -EINVAL;
+	WARN_ON(alg->alg_id != opt.alg);
+	err = tcp_authopt_alg_require(alg);
+	if (err)
+		return err;
+
 	/* If an old key exists with exact ID then remove and replace.
 	 * RCU-protected readers might observe both and pick any.
 	 */
 	key_info = tcp_authopt_key_lookup_exact(sk, info, &opt);
 	if (key_info)
 		tcp_authopt_key_del(sk, info, key_info);
 	key_info = sock_kmalloc(sk, sizeof(*key_info), GFP_KERNEL | __GFP_ZERO);
-	if (!key_info)
+	if (!key_info) {
+		tcp_authopt_alg_release(alg);
 		return -ENOMEM;
+	}
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

