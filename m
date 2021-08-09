Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2423E4E93
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 23:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236537AbhHIVgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 17:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236464AbhHIVgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 17:36:14 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A69C06179A;
        Mon,  9 Aug 2021 14:35:53 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id f13so26778057edq.13;
        Mon, 09 Aug 2021 14:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fasABbnv0ss+6Ti472SFTrit1e7cgBKyXjzgRW209bE=;
        b=OxsBFjhd43xtBK276GdVF+4UfZJ3GgjuE396jxCJVnnZ0Sx49cbjilCv24aySNsr0e
         3eP8QEYE7DinNTYA8Mu3ak6iocY9xkaYBxxec8wUccDxx8mcgAtXg3Ljo7LK2YR+oBMQ
         Bh2iZZQRA0NZzpt43WxpUPZc3hnCHtgzKA7U6n6OyTLPYRuqAjdKGF9hPHKknn+6G6tX
         E9Zayxek6bHp2ZIexcnsmiVWU47oj8+qfhWYsRNYr7CP1SLSfdcYpAbNRFVqCs1gHabm
         ELA2u+hsJt2EMXeVsSXpngAwDxl62JfdcaaCSd2V9pmpOBRx7anwaowAjmg22Fk7+EbK
         KQ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fasABbnv0ss+6Ti472SFTrit1e7cgBKyXjzgRW209bE=;
        b=ZF2RUmpjRdiOSrWRxJSPkXNcB9rES78uvfgV1JYNwqK/v71z3hX0lF/108QdvOmAs8
         o44UZJ9cciPxqWbwNRuqXVk7pZOJcdFD4vvDg7+MiYWzzVKirPQxFdc2In1tzowjOwnz
         sHOi7HywKLOH/WHSUa+baTKkotqAmO0X/TpCyP0gFPIcSk8QY7pJddw3oiE/IbVUo094
         BLmHRqE60n0EgrzRKU4i3mA5APYIWMGk3XiOh6xXXhXyTY0MfqlS8rFj/psd4ssWUZMI
         7z+/1OQgiFkkxciBhn0CbwM72t/HfqQlU78vGGKfpGAhg6Q5oTyoNt1WNleKZf4HNEPm
         ZQqw==
X-Gm-Message-State: AOAM530VWuklXcg2F4ZJmwaeJwLMDat9pSt2rULtuL5luFlZ/TDQPhUc
        xPHkLCJmaBHqh4MCIPLk3zc=
X-Google-Smtp-Source: ABdhPJw3Qiy1bSZxtekOkTBCmgs0FQ3cgfvXHmQ/ZJJWovH+MFQn1k5JfStgdpS+6xsQpSkbECIdHQ==
X-Received: by 2002:aa7:cc02:: with SMTP id q2mr493658edt.154.1628544951383;
        Mon, 09 Aug 2021 14:35:51 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:688d:23e:82c6:84aa])
        by smtp.gmail.com with ESMTPSA id v24sm5542932edt.41.2021.08.09.14.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 14:35:51 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        David Ahern <dsahern@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [RFCv2 3/9] tcp: authopt: Add crypto initialization
Date:   Tue, 10 Aug 2021 00:35:32 +0300
Message-Id: <fd00ec44f335fd52a5a39c696032aa207e6f1801.1628544649.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1628544649.git.cdleonard@gmail.com>
References: <cover.1628544649.git.cdleonard@gmail.com>
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
index 458d108bb7a8..bd5ba95e15de 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -2,10 +2,12 @@
 #ifndef _LINUX_TCP_AUTHOPT_H
 #define _LINUX_TCP_AUTHOPT_H
 
 #include <uapi/linux/tcp.h>
 
+struct tcp_authopt_alg_imp;
+
 /* Representation of a Master Key Tuple as per RFC5925 */
 struct tcp_authopt_key_info {
 	struct hlist_node node;
 	/* Local identifier */
 	u32 local_id;
@@ -15,10 +17,11 @@ struct tcp_authopt_key_info {
 	u8 alg_id;
 	u8 keylen;
 	u8 key[TCP_AUTHOPT_MAXKEYLEN];
 	struct rcu_head rcu;
 	struct sockaddr_storage addr;
+	struct tcp_authopt_alg_imp *alg;
 };
 
 /* Per-socket information regarding tcp_authopt */
 struct tcp_authopt_info {
 	/* List of tcp_authopt_key_info */
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 5fa7bce8891b..799607fc076f 100644
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
 struct tcp_authopt_key_info *__tcp_authopt_key_info_lookup(const struct sock *sk,
 							   struct tcp_authopt_info *info,
 							   int key_id)
 {
 	struct tcp_authopt_key_info *key;
@@ -75,17 +226,25 @@ int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
 	opt->flags = info->flags & TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED;
 
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
 void __tcp_authopt_info_free(struct sock *sk, struct tcp_authopt_info *info)
 {
@@ -112,10 +271,12 @@ void tcp_authopt_clear(struct sock *sk)
 int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 {
 	struct tcp_authopt_key opt;
 	struct tcp_authopt_info *info;
 	struct tcp_authopt_key_info *key_info;
+	struct tcp_authopt_alg_imp *alg;
+	int err;
 
 	/* If userspace optlen is too short fill the rest with zeros */
 	if (optlen > sizeof(opt))
 		return -EINVAL;
 	memset(&opt, 0, sizeof(opt));
@@ -149,22 +310,34 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 	if (opt.flags & TCP_AUTHOPT_KEY_ADDR_BIND) {
 		if (sk->sk_family != opt.addr.ss_family)
 			return -EINVAL;
 	}
 
+	/* check the algorithm */
+	alg = tcp_authopt_alg_get(opt.alg);
+	if (!alg)
+		return -EINVAL;
+	WARN_ON(alg->alg_id != opt.alg);
+	err = tcp_authopt_alg_require(alg);
+	if (err)
+		return err;
+
 	/* If an old value exists for same local_id it is deleted */
 	key_info = __tcp_authopt_key_info_lookup(sk, info, opt.local_id);
 	if (key_info)
 		tcp_authopt_key_del(sk, info, key_info);
 	key_info = sock_kmalloc(sk, sizeof(*key_info), GFP_KERNEL | __GFP_ZERO);
-	if (!key_info)
+	if (!key_info) {
+		tcp_authopt_alg_release(alg);
 		return -ENOMEM;
+	}
 	key_info->local_id = opt.local_id;
 	key_info->flags = opt.flags & (TCP_AUTHOPT_KEY_EXCLUDE_OPTS | TCP_AUTHOPT_KEY_ADDR_BIND);
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

