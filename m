Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B81D46D29B
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 12:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbhLHLnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 06:43:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232753AbhLHLm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 06:42:59 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39231C0698FD;
        Wed,  8 Dec 2021 03:38:24 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id g14so7312430edb.8;
        Wed, 08 Dec 2021 03:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WRLWa8lRaYgTnoCjf0MCIMJlWF3rpMYgtwIN9Z8LM1M=;
        b=eWiVFueOszF5uuwc8NXtDO5jeEUqecM6jiRT8TM7BBH/Czzfmdlhpexxhhqd3yRUDS
         2HalnVoyBjgkdIwzgJZIRjtFjsGo4O5HyhAUyIEPW+UDOyD4B6rBfbFf8vzoJGUmvtSa
         vrLAIJbUGlrEmhAnYgH618y8OHkumZOMCqZPQMcJqwRiAk2NVI8odEc5X5zINlsLwAsP
         uzmYkOxxQMPJDr+56WwqINHznzz9KCbeVg5fVXu5s+R6Yh13iPUa+eY41SY1FEu01d0k
         Wyo2nEfu9yDGoL180yjmw8ShaegBI6vFkigi/gizBCw0o/yDYjRIslwFUdi1m5bt3oTs
         cWgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WRLWa8lRaYgTnoCjf0MCIMJlWF3rpMYgtwIN9Z8LM1M=;
        b=k9mwLpCLWeCjcy9mzqGsjgSywCpM5M2OgIff6sqqvdynqOVGq+ngv+20vBFFz6n4w5
         G3WVKtJq9F5dt5NVl3dHJbgtzzjLVu5uGVQdiIVe8s9vDhdhARkLuFReMGOTCOi+4fZX
         Sw0PdMDVpV4tEdYc2t4is1jCyUU72KQB8hNKDUSuV3T4tqSPewIwATfffMfl9AV0lodq
         ZOu1JY+dokzY9B5OP8YZU4qn/n2o6zOuw5Hi4nAZpFa6yAFIl4EJebFGg6VQeI3/nddf
         kz+a8bIuCZ+nwLWC5gby0Z62Ob573evbbJui2kfNT6DBWE15UOE2bUiidmt7NBqqm5CC
         ocEQ==
X-Gm-Message-State: AOAM533mzfgfcSOAsDpA9rO36iYEhGAA4tF5cb/aQFMm0Ir4f9DhbELb
        F8ri8W9OAzOXvJuTVqj+vyQ=
X-Google-Smtp-Source: ABdhPJwr8rmdlj27hRPGAsQjoGELSadhS6i8HUm884Suw3+dYk9TiTfbmYbQWUsLZY4xr8WmDMzHlw==
X-Received: by 2002:aa7:df9a:: with SMTP id b26mr18034715edy.107.1638963502765;
        Wed, 08 Dec 2021 03:38:22 -0800 (PST)
Received: from ponky.lan ([2a04:241e:501:3870:3c9f:e05b:4dff:43ba])
        by smtp.gmail.com with ESMTPSA id g11sm1883810edz.53.2021.12.08.03.38.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 03:38:22 -0800 (PST)
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
Subject: [PATCH v3 15/18] tcp: authopt: Add prefixlen support
Date:   Wed,  8 Dec 2021 13:37:30 +0200
Message-Id: <9ea8e4b68d98e22e0e7e818e64bbc86f73d46c1e.1638962992.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1638962992.git.cdleonard@gmail.com>
References: <cover.1638962992.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows making a key apply to an addr/prefix instead of just the
full addr. This is enabled through a custom flag, default behavior is
still full address match.

This is equivalent to TCP_MD5SIG_FLAG_PREFIX from TCP_MD5SIG and has
the same use-cases.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/net/tcp_authopt.h |  2 ++
 include/uapi/linux/tcp.h  | 10 ++++++
 net/ipv4/tcp_authopt.c    | 67 ++++++++++++++++++++++++++++++++++++---
 3 files changed, 75 insertions(+), 4 deletions(-)

diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index e57bc732f737..6c50395c0412 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -41,10 +41,12 @@ struct tcp_authopt_key_info {
 	u8 keylen;
 	/** @key: Same as &tcp_authopt_key.key */
 	u8 key[TCP_AUTHOPT_MAXKEYLEN];
 	/** @l3index: Same as &tcp_authopt_key.ifindex */
 	int l3index;
+	/** @prefix: Length of addr match (default full) */
+	int prefixlen;
 	/** @addr: Same as &tcp_authopt_key.addr */
 	struct sockaddr_storage addr;
 	/** @alg: Algorithm implementation matching alg_id */
 	struct tcp_authopt_alg_imp *alg;
 };
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index ed27feb93b0e..b1063e1e1b9f 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -403,18 +403,21 @@ struct tcp_authopt {
  * @TCP_AUTHOPT_KEY_EXCLUDE_OPTS: Exclude TCP options from signature
  * @TCP_AUTHOPT_KEY_ADDR_BIND: Key only valid for `tcp_authopt.addr`
  * @TCP_AUTHOPT_KEY_IFINDEX: Key only valid for `tcp_authopt.ifindex`
  * @TCP_AUTHOPT_KEY_NOSEND: Key invalid for send (expired)
  * @TCP_AUTHOPT_KEY_NORECV: Key invalid for recv (expired)
+ * @TCP_AUTHOPT_KEY_PREFIXLEN: Valid value in `tcp_authopt.prefixlen`, otherwise
+ * match full address length
  */
 enum tcp_authopt_key_flag {
 	TCP_AUTHOPT_KEY_DEL = (1 << 0),
 	TCP_AUTHOPT_KEY_EXCLUDE_OPTS = (1 << 1),
 	TCP_AUTHOPT_KEY_ADDR_BIND = (1 << 2),
 	TCP_AUTHOPT_KEY_IFINDEX = (1 << 3),
 	TCP_AUTHOPT_KEY_NOSEND = (1 << 4),
 	TCP_AUTHOPT_KEY_NORECV = (1 << 5),
+	TCP_AUTHOPT_KEY_PREFIXLEN = (1 << 6),
 };
 
 /**
  * enum tcp_authopt_alg - Algorithms for TCP Authentication Option
  */
@@ -465,10 +468,17 @@ struct tcp_authopt_key {
 	 * connections through this interface. Interface must be an vrf master.
 	 *
 	 * This is similar to `tcp_msg5sig.tcpm_ifindex`
 	 */
 	int	ifindex;
+	/**
+	 * @prefixlen: length of prefix to match
+	 *
+	 * Without the TCP_AUTHOPT_KEY_PREFIXLEN flag this is ignored and a full
+	 * address match is performed.
+	 */
+	int	prefixlen;
 };
 
 /* setsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE, ...) */
 
 #define TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT 0x1
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 946d598258b1..5069bb80054e 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -1,8 +1,13 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
+#include "linux/in6.h"
+#include "linux/inetdevice.h"
 #include "linux/net.h"
+#include "linux/socket.h"
+#include "linux/tcp.h"
+#include "net/ipv6.h"
 #include <linux/kernel.h>
 #include <net/tcp.h>
 #include <net/tcp_authopt.h>
 #include <crypto/hash.h>
 
@@ -219,10 +224,14 @@ static bool tcp_authopt_key_match_exact(struct tcp_authopt_key_info *info,
 		return false;
 	if ((info->flags & TCP_AUTHOPT_KEY_IFINDEX) != (key->flags & TCP_AUTHOPT_KEY_IFINDEX))
 		return false;
 	if ((info->flags & TCP_AUTHOPT_KEY_IFINDEX) && info->l3index != key->ifindex)
 		return false;
+	if ((info->flags & TCP_AUTHOPT_KEY_PREFIXLEN) != (key->flags & TCP_AUTHOPT_KEY_PREFIXLEN))
+		return false;
+	if ((info->flags & TCP_AUTHOPT_KEY_PREFIXLEN) && info->prefixlen != key->prefixlen)
+		return false;
 	if ((info->flags & TCP_AUTHOPT_KEY_ADDR_BIND) != (key->flags & TCP_AUTHOPT_KEY_ADDR_BIND))
 		return false;
 	if (info->flags & TCP_AUTHOPT_KEY_ADDR_BIND)
 		if (!ipvx_addr_match(&info->addr, &key->addr))
 			return false;
@@ -236,17 +245,20 @@ static bool tcp_authopt_key_match_skb_addr(struct tcp_authopt_key_info *key,
 	u16 keyaf = key->addr.ss_family;
 	struct iphdr *iph = (struct iphdr *)skb_network_header(skb);
 
 	if (keyaf == AF_INET && iph->version == 4) {
 		struct sockaddr_in *key_addr = (struct sockaddr_in *)&key->addr;
+		u32 mask = inet_make_mask(key->prefixlen);
 
-		return iph->saddr == key_addr->sin_addr.s_addr;
+		return (iph->saddr & mask) == key_addr->sin_addr.s_addr;
 	} else if (keyaf == AF_INET6 && iph->version == 6) {
 		struct ipv6hdr *ip6h = (struct ipv6hdr *)skb_network_header(skb);
 		struct sockaddr_in6 *key_addr = (struct sockaddr_in6 *)&key->addr;
 
-		return ipv6_addr_equal(&ip6h->saddr, &key_addr->sin6_addr);
+		return ipv6_prefix_equal(&ip6h->saddr,
+					 &key_addr->sin6_addr,
+					 key->prefixlen);
 	}
 
 	/* This actually happens with ipv6-mapped-ipv4-addresses
 	 * IPv6 listen sockets will be asked to validate ipv4 packets.
 	 */
@@ -262,16 +274,19 @@ static bool tcp_authopt_key_match_sk_addr(struct tcp_authopt_key_info *key,
 	if (keyaf != addr_sk->sk_family)
 		return false;
 
 	if (keyaf == AF_INET) {
 		struct sockaddr_in *key_addr = (struct sockaddr_in *)&key->addr;
+		u32 mask = inet_make_mask(key->prefixlen);
 
-		return addr_sk->sk_daddr == key_addr->sin_addr.s_addr;
+		return (addr_sk->sk_daddr & mask) == key_addr->sin_addr.s_addr;
 	} else if (keyaf == AF_INET6) {
 		struct sockaddr_in6 *key_addr = (struct sockaddr_in6 *)&key->addr;
 
-		return ipv6_addr_equal(&addr_sk->sk_v6_daddr, &key_addr->sin6_addr);
+		return ipv6_prefix_equal(&addr_sk->sk_v6_daddr,
+					 &key_addr->sin6_addr,
+					 key->prefixlen);
 	}
 
 	return false;
 }
 
@@ -296,10 +311,16 @@ static bool better_key_match(struct tcp_authopt_key_info *old, struct tcp_authop
 	/* l3index always overrides non-l3index */
 	if (old->l3index && new->l3index == 0)
 		return false;
 	if (old->l3index == 0 && new->l3index)
 		return true;
+	/* Full address match overrides match by prefixlen */
+	if (!(new->flags & TCP_AUTHOPT_KEY_PREFIXLEN) && (old->flags & TCP_AUTHOPT_KEY_PREFIXLEN))
+		return false;
+	/* Longer prefixes are better matches */
+	if (new->prefixlen > old->prefixlen)
+		return true;
 
 	return false;
 }
 
 static struct tcp_authopt_key_info *tcp_authopt_lookup_send(struct tcp_authopt_info *info,
@@ -596,20 +617,31 @@ void tcp_authopt_clear(struct sock *sk)
 #define TCP_AUTHOPT_KEY_KNOWN_FLAGS ( \
 	TCP_AUTHOPT_KEY_DEL | \
 	TCP_AUTHOPT_KEY_EXCLUDE_OPTS | \
 	TCP_AUTHOPT_KEY_ADDR_BIND | \
 	TCP_AUTHOPT_KEY_IFINDEX | \
+	TCP_AUTHOPT_KEY_PREFIXLEN | \
 	TCP_AUTHOPT_KEY_NOSEND | \
 	TCP_AUTHOPT_KEY_NORECV)
 
+static bool ipv6_addr_is_prefix(struct in6_addr *addr, int plen)
+{
+	struct in6_addr copy;
+
+	ipv6_addr_prefix_copy(&copy, addr, plen);
+
+	return !!memcmp(&copy, addr, sizeof(*addr));
+}
+
 int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 {
 	struct tcp_authopt_key opt;
 	struct tcp_authopt_info *info;
 	struct tcp_authopt_key_info *key_info, *old_key_info;
 	struct tcp_authopt_alg_imp *alg;
 	int l3index = 0;
+	int prefixlen;
 	int err;
 
 	sock_owned_by_me(sk);
 	err = check_sysctl_tcp_authopt();
 	if (err)
@@ -641,10 +673,36 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 	if (opt.flags & TCP_AUTHOPT_KEY_ADDR_BIND) {
 		if (sk->sk_family != opt.addr.ss_family)
 			return -EINVAL;
 	}
 
+	/* check prefixlen */
+	if (opt.flags & TCP_AUTHOPT_KEY_PREFIXLEN) {
+		prefixlen = opt.prefixlen;
+		if (sk->sk_family == AF_INET) {
+			if (prefixlen < 0 || prefixlen > 32)
+				return -EINVAL;
+			if (((struct sockaddr_in *)&opt.addr)->sin_addr.s_addr &
+			    ~inet_make_mask(prefixlen))
+				return -EINVAL;
+		}
+		if (sk->sk_family == AF_INET6) {
+			if (prefixlen < 0 || prefixlen > 128)
+				return -EINVAL;
+			if (!ipv6_addr_is_prefix(&((struct sockaddr_in6 *)&opt.addr)->sin6_addr,
+						 prefixlen))
+				return -EINVAL;
+		}
+	} else {
+		if (sk->sk_family == AF_INET)
+			prefixlen = 32;
+		else if (sk->sk_family == AF_INET6)
+			prefixlen = 128;
+		else
+			return -EINVAL;
+	}
+
 	/* Initialize tcp_authopt_info if not already set */
 	info = __tcp_authopt_info_get_or_create(sk);
 	if (IS_ERR(info))
 		return PTR_ERR(info);
 
@@ -688,10 +746,11 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 	key_info->alg = alg;
 	key_info->keylen = opt.keylen;
 	memcpy(key_info->key, opt.key, opt.keylen);
 	memcpy(&key_info->addr, &opt.addr, sizeof(key_info->addr));
 	key_info->l3index = l3index;
+	key_info->prefixlen = prefixlen;
 	hlist_add_head_rcu(&key_info->node, &info->head);
 
 	return 0;
 }
 
-- 
2.25.1

