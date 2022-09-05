Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE1B5ACC02
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 09:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237080AbiIEHHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 03:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236081AbiIEHHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 03:07:08 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED00F3DF20;
        Mon,  5 Sep 2022 00:06:39 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 29so5011384edv.2;
        Mon, 05 Sep 2022 00:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=ihZUtskeoTpuApH7tthaVEzotoUCJZGGD3kpykVDMBg=;
        b=j+cAJ7TJAGo7DnDwa4UEJSLe+MJhcaUQUuA4NgHO7YMdqJBar/dY4vmpwrGhfOBFE6
         7Ah3dTBNB5mStbsPgTHBXvsLrksiSatE4zgHnPwmaugitTgcqS+k3GYHfhS9zLR6S8MI
         3RUn8RU+88DF6PgaS5iuWYSenqzZr+Nwyj0z40cl2jINZ+U+GHf6t8ij9BUJS0I2jbda
         zEzaoWcY7DLkv803G/xM9hMPbHWTzyoe3QygfGkph+LGuiz9rLMm+7g1PUpVOGVBVOif
         99mAXusidHRUHpq7NWHr2CMsKPTCIRGxhGeaK4llNILm9RJaiQCyffCb1ywgP5eFoRwK
         HBuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ihZUtskeoTpuApH7tthaVEzotoUCJZGGD3kpykVDMBg=;
        b=0afyoRfi2eeNJHiLOnppY2pmOFV/bf1fi0jfb/2LAefyJLa4xpL0AQjjN2DtBgir8P
         rRDdJ2I2BvtKhyHRLnbnDcui7RJDdfHR/Bp6YnsFqFcfWwyBO5c9OSLiG3/fKnbQBckT
         y/b09MU1uNh5EoTJ17/nRWcZHwc7dS6v1MHISVXdYZ6sjN2nx/7F28iwCT0aAVVTiODH
         yev3slLPcj2bUjjsiVGcf8gY7WscrDBCpaJY7i8xjlcLylV2A+ApUe3dw3ONUSXj2qBx
         4XLpyHipBC2LuV/9w6mp2GJ7Jyv2yLlKN0s4Ame9t/6nbjPpfT+s3MvJa9tMxMAGA2C1
         7qag==
X-Gm-Message-State: ACgBeo1c9gC1uzjgO6oSzylG6iGmYwHscLHZVu6ryRkrH7HxIww+YRx9
        iBeZwMr3d/v9b30IMKTlw1A=
X-Google-Smtp-Source: AA6agR5vXaifAcenRXpkL6GAjOfCJtzCQekvHCGnPowAkGDzdtDshOvOBtROMAjA06lEi54Lp8dI/w==
X-Received: by 2002:a05:6402:389:b0:44e:ea9:eb2c with SMTP id o9-20020a056402038900b0044e0ea9eb2cmr5883413edv.248.1662361598547;
        Mon, 05 Sep 2022 00:06:38 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:40ec:9f50:387:3cfb])
        by smtp.gmail.com with ESMTPSA id n27-20020a056402515b00b0043cf2e0ce1csm5882775edd.48.2022.09.05.00.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 00:06:37 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Francesco Ruggeri <fruggeri@arista.com>,
        Salam Noureddine <noureddine@arista.com>,
        Philip Paeps <philip@trouble.is>,
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
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8 14/26] tcp: authopt: Add initial l3index support
Date:   Mon,  5 Sep 2022 10:05:50 +0300
Message-Id: <9d9e90a839544dfd5da8aac6eb4355eefbe273a1.1662361354.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1662361354.git.cdleonard@gmail.com>
References: <cover.1662361354.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a parallel feature to tcp_md5sig.tcpm_ifindex support and allows
applications to server multiple VRFs with a single socket.

The ifindex argument must be the ifindex of a VRF device and must match
exactly, keys with ifindex == 0 (outside of VRF) will not match for
connections inside a VRF.

Keys without the TCP_AUTHOPT_KEY_IFINDEX will ignore ifindex and match
both inside and outside VRF.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 Documentation/networking/tcp_authopt.rst |  1 +
 include/net/tcp_authopt.h                |  2 +
 include/uapi/linux/tcp.h                 | 11 ++++
 net/ipv4/tcp_authopt.c                   | 69 ++++++++++++++++++++++--
 4 files changed, 79 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/tcp_authopt.rst b/Documentation/networking/tcp_authopt.rst
index 72adb7a891ce..cbdea65e2b5d 100644
--- a/Documentation/networking/tcp_authopt.rst
+++ b/Documentation/networking/tcp_authopt.rst
@@ -37,10 +37,11 @@ expand over time by increasing the size of `struct tcp_authopt_key` and adding
 new flags.
 
  * Address binding is optional, by default keys match all addresses
  * Local address is ignored, matching is done by remote address
  * Ports are ignored
+ * It is possible to match a specific VRF by l3index (default is to ignore)
 
 RFC5925 requires that key ids do not overlap when tcp identifiers (addr/port)
 overlap. This is not enforced by linux, configuring ambiguous keys will result
 in packet drops and lost connections.
 
diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index 9bc0f58a78cb..e450f7c30043 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -45,10 +45,12 @@ struct tcp_authopt_key_info {
 	u8 alg_id;
 	/** @keylen: Same as &tcp_authopt_key.keylen */
 	u8 keylen;
 	/** @key: Same as &tcp_authopt_key.key */
 	u8 key[TCP_AUTHOPT_MAXKEYLEN];
+	/** @l3index: Same as &tcp_authopt_key.ifindex */
+	int l3index;
 	/** @addr: Same as &tcp_authopt_key.addr */
 	struct sockaddr_storage addr;
 	/** @alg: Algorithm implementation matching alg_id */
 	struct tcp_authopt_alg_imp *alg;
 };
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 75107a7fd935..28be52f4e411 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -369,17 +369,19 @@ struct tcp_authopt {
  * enum tcp_authopt_key_flag - flags for `tcp_authopt.flags`
  *
  * @TCP_AUTHOPT_KEY_DEL: Delete the key and ignore non-id fields
  * @TCP_AUTHOPT_KEY_EXCLUDE_OPTS: Exclude TCP options from signature
  * @TCP_AUTHOPT_KEY_ADDR_BIND: Key only valid for `tcp_authopt.addr`
+ * @TCP_AUTHOPT_KEY_IFINDEX: Key only valid for `tcp_authopt.ifindex`
  * @TCP_AUTHOPT_KEY_NOSEND: Key invalid for send (expired)
  * @TCP_AUTHOPT_KEY_NORECV: Key invalid for recv (expired)
  */
 enum tcp_authopt_key_flag {
 	TCP_AUTHOPT_KEY_DEL = (1 << 0),
 	TCP_AUTHOPT_KEY_EXCLUDE_OPTS = (1 << 1),
 	TCP_AUTHOPT_KEY_ADDR_BIND = (1 << 2),
+	TCP_AUTHOPT_KEY_IFINDEX = (1 << 3),
 	TCP_AUTHOPT_KEY_NOSEND = (1 << 4),
 	TCP_AUTHOPT_KEY_NORECV = (1 << 5),
 };
 
 /**
@@ -423,10 +425,19 @@ struct tcp_authopt_key {
 	 * @addr: Key is only valid for this address
 	 *
 	 * Ignored unless TCP_AUTHOPT_KEY_ADDR_BIND flag is set
 	 */
 	struct __kernel_sockaddr_storage addr;
+	/**
+	 * @ifindex: ifindex of vrf (l3mdev_master) interface
+	 *
+	 * If the TCP_AUTHOPT_KEY_IFINDEX flag is set then key only applies for
+	 * connections through this interface. Interface must be an vrf master.
+	 *
+	 * This is similar to `tcp_msg5sig.tcpm_ifindex`
+	 */
+	int	ifindex;
 };
 
 /* setsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE, ...) */
 
 #define TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT 0x1
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 4dc2fe541498..3704af8202eb 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -1,8 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
 #include <net/tcp_authopt.h>
+#include <net/ip.h>
 #include <net/ipv6.h>
 #include <net/tcp.h>
 #include <linux/kref.h>
 #include <crypto/hash.h>
 
@@ -264,10 +265,14 @@ static bool tcp_authopt_key_match_exact(struct tcp_authopt_key_info *info,
 {
 	if (info->send_id != key->send_id)
 		return false;
 	if (info->recv_id != key->recv_id)
 		return false;
+	if ((info->flags & TCP_AUTHOPT_KEY_IFINDEX) != (key->flags & TCP_AUTHOPT_KEY_IFINDEX))
+		return false;
+	if ((info->flags & TCP_AUTHOPT_KEY_IFINDEX) && info->l3index != key->ifindex)
+		return false;
 	if ((info->flags & TCP_AUTHOPT_KEY_ADDR_BIND) != (key->flags & TCP_AUTHOPT_KEY_ADDR_BIND))
 		return false;
 	if (info->flags & TCP_AUTHOPT_KEY_ADDR_BIND)
 		if (!ipvx_addr_match(&info->addr, &key->addr))
 			return false;
@@ -333,10 +338,24 @@ static struct tcp_authopt_key_info *tcp_authopt_key_lookup_exact(const struct so
 			return key_info;
 
 	return NULL;
 }
 
+static bool better_key_match(struct tcp_authopt_key_info *old, struct tcp_authopt_key_info *new)
+{
+	if (!old)
+		return true;
+
+	/* l3index always overrides non-l3index */
+	if (old->l3index && new->l3index == 0)
+		return false;
+	if (old->l3index == 0 && new->l3index)
+		return true;
+
+	return false;
+}
+
 /**
  * tcp_authopt_lookup_send - lookup key for sending
  *
  * @net: Per-namespace information containing keys
  * @addr_sk: Socket used for destination address lookup
@@ -348,20 +367,29 @@ static struct tcp_authopt_key_info *tcp_authopt_key_lookup_exact(const struct so
 static struct tcp_authopt_key_info *tcp_authopt_lookup_send(struct netns_tcp_authopt *net,
 							    const struct sock *addr_sk)
 {
 	struct tcp_authopt_key_info *result = NULL;
 	struct tcp_authopt_key_info *key;
+	int l3index = -1;
 
 	hlist_for_each_entry_rcu(key, &net->head, node, 0) {
 		if (key->flags & TCP_AUTHOPT_KEY_ADDR_BIND)
 			if (!tcp_authopt_key_match_sk_addr(key, addr_sk))
 				continue;
+		if (key->flags & TCP_AUTHOPT_KEY_IFINDEX) {
+			if (l3index < 0)
+				l3index = l3mdev_master_ifindex_by_index(sock_net(addr_sk),
+									 addr_sk->sk_bound_dev_if);
+			if (l3index != key->l3index)
+				continue;
+		}
 		if (key->flags & TCP_AUTHOPT_KEY_NOSEND)
 			continue;
-		if (result && net_ratelimit())
-			pr_warn("ambiguous tcp authentication keys configured for send\n");
-		result = key;
+		if (better_key_match(result, key))
+			result = key;
+		else if (result)
+			net_warn_ratelimited("ambiguous tcp authentication keys configured for send\n");
 	}
 
 	return result;
 }
 
@@ -507,20 +535,22 @@ int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
 
 #define TCP_AUTHOPT_KEY_KNOWN_FLAGS ( \
 	TCP_AUTHOPT_KEY_DEL | \
 	TCP_AUTHOPT_KEY_EXCLUDE_OPTS | \
 	TCP_AUTHOPT_KEY_ADDR_BIND | \
+	TCP_AUTHOPT_KEY_IFINDEX | \
 	TCP_AUTHOPT_KEY_NOSEND | \
 	TCP_AUTHOPT_KEY_NORECV)
 
 int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 {
 	struct tcp_authopt_key opt;
 	struct tcp_authopt_info *info;
 	struct tcp_authopt_key_info *key_info, *old_key_info;
 	struct netns_tcp_authopt *net = sock_net_tcp_authopt(sk);
 	struct tcp_authopt_alg_imp *alg;
+	int l3index = 0;
 	int err;
 
 	sock_owned_by_me(sk);
 	err = check_sysctl_tcp_authopt();
 	if (err)
@@ -571,10 +601,24 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 		return -EINVAL;
 	err = tcp_authopt_alg_require(alg);
 	if (err)
 		return err;
 
+	/* check ifindex is valid (zero is always valid) */
+	if (opt.flags & TCP_AUTHOPT_KEY_IFINDEX && opt.ifindex) {
+		struct net_device *dev;
+
+		rcu_read_lock();
+		dev = dev_get_by_index_rcu(sock_net(sk), opt.ifindex);
+		if (dev && netif_is_l3_master(dev))
+			l3index = dev->ifindex;
+		rcu_read_unlock();
+
+		if (!l3index)
+			return -EINVAL;
+	}
+
 	key_info = kmalloc(sizeof(*key_info), GFP_KERNEL | __GFP_ZERO);
 	if (!key_info)
 		return -ENOMEM;
 	mutex_lock(&net->mutex);
 	kref_init(&key_info->ref);
@@ -590,10 +634,11 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 	key_info->alg_id = opt.alg;
 	key_info->alg = alg;
 	key_info->keylen = opt.keylen;
 	memcpy(key_info->key, opt.key, opt.keylen);
 	memcpy(&key_info->addr, &opt.addr, sizeof(key_info->addr));
+	key_info->l3index = l3index;
 	hlist_add_head_rcu(&key_info->node, &net->head);
 	mutex_unlock(&net->mutex);
 
 	return 0;
 }
@@ -1379,24 +1424,40 @@ static struct tcp_authopt_key_info *tcp_authopt_lookup_recv(struct sock *sk,
 							    int recv_id,
 							    bool *anykey)
 {
 	struct tcp_authopt_key_info *result = NULL;
 	struct tcp_authopt_key_info *key;
+	int l3index = -1;
 
 	*anykey = false;
 	/* multiple matches will cause occasional failures */
 	hlist_for_each_entry_rcu(key, &net->head, node, 0) {
 		if (key->flags & TCP_AUTHOPT_KEY_ADDR_BIND &&
 		    !tcp_authopt_key_match_skb_addr(key, skb))
 			continue;
+		if (key->flags & TCP_AUTHOPT_KEY_IFINDEX) {
+			if (l3index < 0) {
+				if (skb->protocol == htons(ETH_P_IP)) {
+					l3index = inet_sdif(skb) ? inet_iif(skb) : 0;
+				} else if (skb->protocol == htons(ETH_P_IPV6)) {
+					l3index = inet6_sdif(skb) ? inet6_iif(skb) : 0;
+				} else {
+					WARN_ONCE(1, "unexpected skb->protocol=%x", skb->protocol);
+					continue;
+				}
+			}
+
+			if (l3index != key->l3index)
+				continue;
+		}
 		*anykey = true;
 		// If only keys with norecv flag are present still consider that
 		if (key->flags & TCP_AUTHOPT_KEY_NORECV)
 			continue;
 		if (recv_id >= 0 && key->recv_id != recv_id)
 			continue;
-		if (!result)
+		if (better_key_match(result, key))
 			result = key;
 		else if (result)
 			net_warn_ratelimited("ambiguous tcp authentication keys configured for recv\n");
 	}
 
-- 
2.25.1

