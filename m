Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B179441EA1
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 17:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbhKAQjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 12:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232979AbhKAQip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 12:38:45 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90EDAC061220;
        Mon,  1 Nov 2021 09:36:06 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id s1so66348163edd.3;
        Mon, 01 Nov 2021 09:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/FkKDXLaqLnjOCC66Yk6vKvo6+eonK0av1BzTJ6fqeQ=;
        b=AZRSVPJt3YPnawQkNF62e2uSQh6e/GN44SmgWrJg6+1213F5LsbwDoGIqA1P/tI618
         NZIS2GkSoIx6ZrMunNQ0SjSXHhu4edh2/VHAyOhFG1U6Cd/Bvn02mHBVgGkyG62MqEiV
         SDZlp/E1Dvwo2nc8JaIVemmnyhSKeN9yyrthdhoNKdUMwdvE2cpZvFqwE1rHcTu3dCuL
         FDYNS5Co3Qh3BTmEN4apLZaDEpZlO27KT4SOs1IJjW0LsjYg1wrh13jePQmHprZMudz1
         joqT/oV8w8GdeNGgaF6ieQ/KShHWH+YBtDCA1NEWwO2eszf8s+toFNSsBJNur5SyJ2D1
         Tw/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/FkKDXLaqLnjOCC66Yk6vKvo6+eonK0av1BzTJ6fqeQ=;
        b=nom74w7Yg7nGD1R/2OZu4h+fIx+aYpJENAVkxaFiNlAqWNXxOh41JPush1ZlHiroj5
         +E1voQkOX9T8bSpBH+JiH7UEPFkhFtBx5ek9au43rtdMOnv65ppZGEoJGcp8/fHFYKRi
         AG4vqLhs7WUZc2ngRZ1jhPBZSZI5FMBmahv1hrAox4Vfj1hVHiGY/pgc3pldYrqALaSS
         jnYzsdNGvJgTbR4gRILBQmAOKpCiWWlnknhI2jfoJOYbntNXLYm3MFGjEEJLgTUnpa63
         tT40g8t+6STbOa9BijwXldyxAdm51AFIQrCIP7PTx8wZLEJDLj+Y3BQBY8xTl3oSfIHq
         qHqg==
X-Gm-Message-State: AOAM533m7OcTl+apJ7m8n/mAKQ//R3GuwPmx35gIg9xEcZ/nqxRBT4Uz
        D1ZwV08htFmyRz2TSW1ODiI=
X-Google-Smtp-Source: ABdhPJy0hH7+ZB0DB4rgnx2osJOtDBUkXmPkvi0V4AM/H86MvoZAXxiuqj/6iqQmXmG+fLqZffLT2w==
X-Received: by 2002:a17:907:939:: with SMTP id au25mr37111621ejc.166.1635784565141;
        Mon, 01 Nov 2021 09:36:05 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:f5f:2085:7f25:17c])
        by smtp.gmail.com with ESMTPSA id f25sm4124583edv.90.2021.11.01.09.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:36:04 -0700 (PDT)
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
Subject: [PATCH v2 21/25] tcp: authopt: Add initial l3index support
Date:   Mon,  1 Nov 2021 18:34:56 +0200
Message-Id: <4e049d1ade4be3010b4ea63daf2ef3bed4e1892b.1635784253.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1635784253.git.cdleonard@gmail.com>
References: <cover.1635784253.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 include/net/tcp_authopt.h |  2 ++
 include/uapi/linux/tcp.h  | 11 ++++++
 net/ipv4/tcp_authopt.c    | 76 +++++++++++++++++++++++++++++++++++----
 3 files changed, 82 insertions(+), 7 deletions(-)

diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index 9341e10ef542..072d5383f14b 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -39,10 +39,12 @@ struct tcp_authopt_key_info {
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
index e02176390519..a7f5f918ed5a 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -400,15 +400,17 @@ struct tcp_authopt {
  * enum tcp_authopt_key_flag - flags for `tcp_authopt.flags`
  *
  * @TCP_AUTHOPT_KEY_DEL: Delete the key and ignore non-id fields
  * @TCP_AUTHOPT_KEY_EXCLUDE_OPTS: Exclude TCP options from signature
  * @TCP_AUTHOPT_KEY_ADDR_BIND: Key only valid for `tcp_authopt.addr`
+ * @TCP_AUTHOPT_KEY_IFINDEX: Key only valid for `tcp_authopt.ifindex`
  */
 enum tcp_authopt_key_flag {
 	TCP_AUTHOPT_KEY_DEL = (1 << 0),
 	TCP_AUTHOPT_KEY_EXCLUDE_OPTS = (1 << 1),
 	TCP_AUTHOPT_KEY_ADDR_BIND = (1 << 2),
+	TCP_AUTHOPT_KEY_IFINDEX = (1 << 3),
 };
 
 /**
  * enum tcp_authopt_alg - Algorithms for TCP Authentication Option
  */
@@ -450,10 +452,19 @@ struct tcp_authopt_key {
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
index a02fe0d14b63..f497537ce16c 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
+#include "linux/net.h"
 #include <linux/kernel.h>
 #include <net/tcp.h>
 #include <net/tcp_authopt.h>
 #include <crypto/hash.h>
 
@@ -190,10 +191,14 @@ static bool tcp_authopt_key_match_exact(struct tcp_authopt_key_info *info,
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
@@ -257,26 +262,49 @@ static struct tcp_authopt_key_info *tcp_authopt_key_lookup_exact(const struct so
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
 static struct tcp_authopt_key_info *tcp_authopt_lookup_send(struct tcp_authopt_info *info,
 							    const struct sock *addr_sk,
 							    int send_id)
 {
 	struct tcp_authopt_key_info *result = NULL;
 	struct tcp_authopt_key_info *key;
+	int l3index = -1;
 
 	hlist_for_each_entry_rcu(key, &info->head, node, 0) {
 		if (send_id >= 0 && key->send_id != send_id)
 			continue;
 		if (key->flags & TCP_AUTHOPT_KEY_ADDR_BIND)
 			if (!tcp_authopt_key_match_sk_addr(key, addr_sk))
 				continue;
-		if (result && net_ratelimit())
-			pr_warn("ambiguous tcp authentication keys configured for send\n");
-		result = key;
+		if (key->flags & TCP_AUTHOPT_KEY_IFINDEX) {
+			if (l3index < 0)
+				l3index = l3mdev_master_ifindex_by_index(sock_net(addr_sk),
+									 addr_sk->sk_bound_dev_if);
+			if (l3index != key->l3index)
+				continue;
+		}
+		if (better_key_match(result, key))
+			result = key;
+		else if (result)
+			net_warn_ratelimited("ambiguous tcp authentication keys configured for send\n");
 	}
 
 	return result;
 }
 
@@ -527,18 +555,20 @@ void tcp_authopt_clear(struct sock *sk)
 }
 
 #define TCP_AUTHOPT_KEY_KNOWN_FLAGS ( \
 	TCP_AUTHOPT_KEY_DEL | \
 	TCP_AUTHOPT_KEY_EXCLUDE_OPTS | \
-	TCP_AUTHOPT_KEY_ADDR_BIND)
+	TCP_AUTHOPT_KEY_ADDR_BIND | \
+	TCP_AUTHOPT_KEY_IFINDEX)
 
 int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 {
 	struct tcp_authopt_key opt;
 	struct tcp_authopt_info *info;
 	struct tcp_authopt_key_info *key_info, *old_key_info;
 	struct tcp_authopt_alg_imp *alg;
+	int l3index = 0;
 	int err;
 
 	sock_owned_by_me(sk);
 	if (!sysctl_tcp_authopt)
 		return -EPERM;
@@ -584,10 +614,24 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
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
 	key_info = sock_kmalloc(sk, sizeof(*key_info), GFP_KERNEL | __GFP_ZERO);
 	if (!key_info)
 		return -ENOMEM;
 	/* If an old key exists with exact ID then remove and replace.
 	 * RCU-protected readers might observe both and pick any.
@@ -601,10 +645,11 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 	key_info->alg_id = opt.alg;
 	key_info->alg = alg;
 	key_info->keylen = opt.keylen;
 	memcpy(key_info->key, opt.key, opt.keylen);
 	memcpy(&key_info->addr, &opt.addr, sizeof(key_info->addr));
+	key_info->l3index = l3index;
 	hlist_add_head_rcu(&key_info->node, &info->head);
 
 	return 0;
 }
 
@@ -1436,21 +1481,38 @@ static struct tcp_authopt_key_info *tcp_authopt_lookup_recv(struct sock *sk,
 							    struct tcp_authopt_info *info,
 							    int recv_id)
 {
 	struct tcp_authopt_key_info *result = NULL;
 	struct tcp_authopt_key_info *key;
+	int l3index = -1;
 
 	/* multiple matches will cause occasional failures */
 	hlist_for_each_entry_rcu(key, &info->head, node, 0) {
 		if (recv_id >= 0 && key->recv_id != recv_id)
 			continue;
 		if (key->flags & TCP_AUTHOPT_KEY_ADDR_BIND &&
 		    !tcp_authopt_key_match_skb_addr(key, skb))
 			continue;
-		if (result && net_ratelimit())
-			pr_warn("ambiguous tcp authentication keys configured for receive\n");
-		result = key;
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
+		if (better_key_match(result, key))
+			result = key;
+		else if (result)
+			net_warn_ratelimited("ambiguous tcp authentication keys configured for send\n");
 	}
 
 	return result;
 }
 
-- 
2.25.1

