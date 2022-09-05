Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0B5C5ACC74
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 09:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235490AbiIEHIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 03:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237050AbiIEHHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 03:07:08 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DCC3ED4B;
        Mon,  5 Sep 2022 00:06:41 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id og21so15165227ejc.2;
        Mon, 05 Sep 2022 00:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=xCw5q8VQfq0DXn00kPNE+QaTnVNFPq55IEgRZMfRqU4=;
        b=aP/x3S+ifdbsqeyNf828x+/CIreGIilRQ5hdAQKDHo0oOQ0K0e5CAF8cV2J+5zxhZB
         ywBtmgEO2/qJs/zbfmhBeIPGGu/UQfe43rbP7eXCKFlvNI3vv2gnsDrDzRDgCZGBH1u8
         F+Z0LHsCm/onsSOWwDATPBuVu17pZfUM1oLm7pY0FHAtYmnU4hD7xkU82SXUUWS612Ts
         UwMiGcTRratqzlQCiIOKCpVrcjrnjpfuwg50tndV4+opLCm7CFwk7de/gAVejYkfnYdk
         4u6WV3R3CdpzueghIDlOEipop/FSypOZi6uxqijtrx29m8sapi/BjF3dhtGEEsODGc0f
         /fcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=xCw5q8VQfq0DXn00kPNE+QaTnVNFPq55IEgRZMfRqU4=;
        b=05tw2gMsToahNVbQL/yhMkrYKtJEZovAh+yOUtsYjgVhifCYhz8HDIacif0Dm0m/6x
         yJgQUivBJVomz5uP2JuJYwY+pps935AP/oYcUtDMqEQ8thoMYvS4BVYC3CcDmg8biqIi
         I9T8qqsaeR4j6E//9vX/z+UQbzVOvI7JbgTSPkTvfhrBZA8L8jj+8nPjq/h0ruswspli
         vaAaSH7uKyfmyXDRKJmIhokvgdDzE3LF6ud/FQl6wn+GL5/ISTqhaRmHWnm94xMFbP7s
         +91LQDB7SM5jbGYtgDW6OOYOvIO9DmwP2odC3n04mC/bxdip9HsypTf1ZKHq/5ZNXhXn
         kDBQ==
X-Gm-Message-State: ACgBeo31gl8UhPogr7LdcqtziRumzGb5BVSTfHffwqrVYy+bhL0eqi08
        XIIPbJRQOo2YhcTy188QwqQ=
X-Google-Smtp-Source: AA6agR7KZ0zj50JBamW+PXK8JbC+ASu8tl1LmnA5B9JPCduYa3DDJDy2eUjr9xb7Vvnt/OkLywu5FA==
X-Received: by 2002:a17:906:974b:b0:733:10e:b940 with SMTP id o11-20020a170906974b00b00733010eb940mr34863864ejy.326.1662361600536;
        Mon, 05 Sep 2022 00:06:40 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:40ec:9f50:387:3cfb])
        by smtp.gmail.com with ESMTPSA id n27-20020a056402515b00b0043cf2e0ce1csm5882775edd.48.2022.09.05.00.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 00:06:40 -0700 (PDT)
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
Subject: [PATCH v8 15/26] tcp: authopt: Add prefixlen support
Date:   Mon,  5 Sep 2022 10:05:51 +0300
Message-Id: <bc586e2a5be00ff79d8c623a5e721f3e8bb56df4.1662361354.git.cdleonard@gmail.com>
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

This allows making a key apply to an addr/prefix instead of just the
full addr. This is enabled through a custom flag, default behavior is
still full address match.

This is equivalent to TCP_MD5SIG_FLAG_PREFIX from TCP_MD5SIG and has
the same use-cases.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 Documentation/networking/tcp_authopt.rst |  1 +
 include/net/tcp_authopt.h                |  2 +
 include/uapi/linux/tcp.h                 | 10 ++++
 net/ipv4/tcp_authopt.c                   | 63 ++++++++++++++++++++++--
 4 files changed, 72 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/tcp_authopt.rst b/Documentation/networking/tcp_authopt.rst
index cbdea65e2b5d..d0191d0c6c02 100644
--- a/Documentation/networking/tcp_authopt.rst
+++ b/Documentation/networking/tcp_authopt.rst
@@ -38,10 +38,11 @@ new flags.
 
  * Address binding is optional, by default keys match all addresses
  * Local address is ignored, matching is done by remote address
  * Ports are ignored
  * It is possible to match a specific VRF by l3index (default is to ignore)
+ * It is possible to match with a fixed prefixlen (default is full address)
 
 RFC5925 requires that key ids do not overlap when tcp identifiers (addr/port)
 overlap. This is not enforced by linux, configuring ambiguous keys will result
 in packet drops and lost connections.
 
diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index e450f7c30043..6260c3ef6864 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -47,10 +47,12 @@ struct tcp_authopt_key_info {
 	u8 keylen;
 	/** @key: Same as &tcp_authopt_key.key */
 	u8 key[TCP_AUTHOPT_MAXKEYLEN];
 	/** @l3index: Same as &tcp_authopt_key.ifindex */
 	int l3index;
+	/** @prefixlen: Length of addr match (default full) */
+	int prefixlen;
 	/** @addr: Same as &tcp_authopt_key.addr */
 	struct sockaddr_storage addr;
 	/** @alg: Algorithm implementation matching alg_id */
 	struct tcp_authopt_alg_imp *alg;
 };
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 28be52f4e411..274ddfefd6de 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -372,18 +372,21 @@ struct tcp_authopt {
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
@@ -434,10 +437,17 @@ struct tcp_authopt_key {
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
index 3704af8202eb..daeecb64c89e 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -4,10 +4,11 @@
 #include <net/ip.h>
 #include <net/ipv6.h>
 #include <net/tcp.h>
 #include <linux/kref.h>
 #include <crypto/hash.h>
+#include <linux/inetdevice.h>
 
 /* This is mainly intended to protect against local privilege escalations through
  * a rarely used feature so it is deliberately not namespaced.
  */
 int sysctl_tcp_authopt;
@@ -269,10 +270,14 @@ static bool tcp_authopt_key_match_exact(struct tcp_authopt_key_info *info,
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
@@ -286,17 +291,20 @@ static bool tcp_authopt_key_match_skb_addr(struct tcp_authopt_key_info *key,
 	u16 keyaf = key->addr.ss_family;
 	struct iphdr *iph = (struct iphdr *)skb_network_header(skb);
 
 	if (keyaf == AF_INET && iph->version == 4) {
 		struct sockaddr_in *key_addr = (struct sockaddr_in *)&key->addr;
+		__be32 mask = inet_make_mask(key->prefixlen);
 
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
@@ -312,17 +320,20 @@ static bool tcp_authopt_key_match_sk_addr(struct tcp_authopt_key_info *key,
 	if (keyaf != addr_sk->sk_family)
 		return false;
 
 	if (keyaf == AF_INET) {
 		struct sockaddr_in *key_addr = (struct sockaddr_in *)&key->addr;
+		__be32 mask = inet_make_mask(key->prefixlen);
 
-		return addr_sk->sk_daddr == key_addr->sin_addr.s_addr;
+		return (addr_sk->sk_daddr & mask) == key_addr->sin_addr.s_addr;
 #if IS_ENABLED(CONFIG_IPV6)
 	} else if (keyaf == AF_INET6) {
 		struct sockaddr_in6 *key_addr = (struct sockaddr_in6 *)&key->addr;
 
-		return ipv6_addr_equal(&addr_sk->sk_v6_daddr, &key_addr->sin6_addr);
+		return ipv6_prefix_equal(&addr_sk->sk_v6_daddr,
+					 &key_addr->sin6_addr,
+					 key->prefixlen);
 #endif
 	}
 
 	return false;
 }
@@ -348,10 +359,16 @@ static bool better_key_match(struct tcp_authopt_key_info *old, struct tcp_authop
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
 
 /**
@@ -536,21 +553,32 @@ int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
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
+	ipv6_addr_prefix(&copy, addr, plen);
+
+	return !memcmp(&copy, addr, sizeof(*addr));
+}
+
 int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 {
 	struct tcp_authopt_key opt;
 	struct tcp_authopt_info *info;
 	struct tcp_authopt_key_info *key_info, *old_key_info;
 	struct netns_tcp_authopt *net = sock_net_tcp_authopt(sk);
 	struct tcp_authopt_alg_imp *alg;
 	int l3index = 0;
+	int prefixlen;
 	int err;
 
 	sock_owned_by_me(sk);
 	err = check_sysctl_tcp_authopt();
 	if (err)
@@ -586,10 +614,36 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
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
 
@@ -635,10 +689,11 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 	key_info->alg = alg;
 	key_info->keylen = opt.keylen;
 	memcpy(key_info->key, opt.key, opt.keylen);
 	memcpy(&key_info->addr, &opt.addr, sizeof(key_info->addr));
 	key_info->l3index = l3index;
+	key_info->prefixlen = prefixlen;
 	hlist_add_head_rcu(&key_info->node, &net->head);
 	mutex_unlock(&net->mutex);
 
 	return 0;
 }
-- 
2.25.1

