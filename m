Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D77A3E4E92
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 23:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236464AbhHIVg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 17:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236489AbhHIVgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 17:36:17 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5700DC061796;
        Mon,  9 Aug 2021 14:35:56 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id by4so8069080edb.0;
        Mon, 09 Aug 2021 14:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jwg/vlMjLeqvnzKvhuAvM489DRXjR5AM0zPOQaopkAM=;
        b=U7rXbzLgI7rCzUkZmArmJGz6d3kZ/uGPQ8DuU+I+R6GW3gaSzf6BX0q3LycRrVdGjd
         EMek1OE1jFPL46BxtuZikhguMKqmuCt5rXclhZY0BipENVnM2kOVEkdVNqwXfvAOhTbs
         +TWfU2KbWGskE3wOrzIbGW9piCJj6Rv2ZqtnScPimjE3kQt3c29y0PzzHm6J1O+vt6d7
         BP6Kc7Q/ocob9yzkQguZ7mo4lbeRQFCjpQS3HX+aDuIS41z1WEw9pAlv9ADSlDFAFiMA
         OyDz5RTxKxKJoWxVY1tN99N1cG58RwiCGmzWv5ykx3yHp08RiUkaYEE0vkn2Ckw/IxXh
         FY0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jwg/vlMjLeqvnzKvhuAvM489DRXjR5AM0zPOQaopkAM=;
        b=VBZyluPXSyKneFGENNM2IzSxwvZEqgNDCO+FWBIcgdBFKXeaLhriOJr60SJDyCWeWK
         1nmb5EyXpgdX68SyayLd9pzKscM9PaiibXJnmyC299i/t9k0iq9X+7lbli5B1iyAcGMo
         PJxBsWMTEG/g+pHVBqq1WBUy0a0qPoJ3OZQO5effrwgJsh2+0sziNtoHKQS+WD7sNMjS
         lizxMbwaaBPBhZGprvScg0I9BiRdSvLksf8ntVjNpJheJUGjVVCyb4hl5+pKXVEJE61U
         ccf2kJpxTAXD6ZzMIECJl2DW62pWy17qG7q8MT42U5h93FffBNbezsKxnlaWCcaNdgjp
         JJjg==
X-Gm-Message-State: AOAM531gASASWPWPRn+1yQTfIDHao3GqhJT3zQlY9l/K4PBxNbxem3Kn
        qCTdvAwPVVr1qya0zTu92Cs=
X-Google-Smtp-Source: ABdhPJwfdDlOw/JIChnvUlsK4HmbwACkFuhpXdoHne0/WCxITRL/k851OzuES6BP5vJ9vtIKektKhQ==
X-Received: by 2002:aa7:d757:: with SMTP id a23mr458430eds.29.1628544954877;
        Mon, 09 Aug 2021 14:35:54 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:688d:23e:82c6:84aa])
        by smtp.gmail.com with ESMTPSA id v24sm5542932edt.41.2021.08.09.14.35.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 14:35:54 -0700 (PDT)
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
Subject: [RFCv2 5/9] tcp: authopt: Hook into tcp core
Date:   Tue, 10 Aug 2021 00:35:34 +0300
Message-Id: <28ccc211be7d2886b6c2a287a6fcfd55ee3b6e2b.1628544649.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1628544649.git.cdleonard@gmail.com>
References: <cover.1628544649.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tcp_authopt features exposes a minimal interface to the rest of the
TCP stack. Only a few functions are exposed and if the feature is
disabled they return neutral values, avoiding ifdefs in the rest of the
code.

Add calls into tcp authopt from send, receive and accept code.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/net/tcp_authopt.h |  55 +++++++++
 net/ipv4/tcp_authopt.c    | 227 ++++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_input.c      |  17 +++
 net/ipv4/tcp_ipv4.c       |   3 +
 net/ipv4/tcp_minisocks.c  |   2 +
 net/ipv4/tcp_output.c     |  56 +++++++++-
 net/ipv6/tcp_ipv6.c       |   4 +
 7 files changed, 363 insertions(+), 1 deletion(-)

diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index bd5ba95e15de..28ebc77473a4 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -15,10 +15,11 @@ struct tcp_authopt_key_info {
 	/* Wire identifiers */
 	u8 send_id, recv_id;
 	u8 alg_id;
 	u8 keylen;
 	u8 key[TCP_AUTHOPT_MAXKEYLEN];
+	u8 maclen;
 	struct rcu_head rcu;
 	struct sockaddr_storage addr;
 	struct tcp_authopt_alg_imp *alg;
 };
 
@@ -31,15 +32,52 @@ struct tcp_authopt_info {
 	u32 dst_isn;
 	struct rcu_head rcu;
 };
 
 #ifdef CONFIG_TCP_AUTHOPT
+struct tcp_authopt_key_info *tcp_authopt_select_key(const struct sock *sk,
+						    const struct sock *addr_sk,
+						    u8 *rnextkeyid);
 void tcp_authopt_clear(struct sock *sk);
 int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen);
 int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *key);
 int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen);
+int tcp_authopt_hash(
+		char *hash_location,
+		struct tcp_authopt_key_info *key,
+		struct sock *sk, struct sk_buff *skb);
+int __tcp_authopt_openreq(struct sock *newsk, const struct sock *oldsk, struct request_sock *req);
+static inline int tcp_authopt_openreq(
+		struct sock *newsk,
+		const struct sock *oldsk,
+		struct request_sock *req)
+{
+	if (!rcu_dereference(tcp_sk(oldsk)->authopt_info))
+		return 0;
+	else
+		return __tcp_authopt_openreq(newsk, oldsk, req);
+}
+int __tcp_authopt_inbound_check(
+		struct sock *sk,
+		struct sk_buff *skb,
+		struct tcp_authopt_info *info);
+static inline int tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb)
+{
+	struct tcp_authopt_info *info = rcu_dereference(tcp_sk(sk)->authopt_info);
+
+	if (info)
+		return __tcp_authopt_inbound_check(sk, skb, info);
+	else
+		return 0;
+}
 #else
+static struct tcp_authopt_key_info *tcp_authopt_select_key(const struct sock *sk,
+							   const struct sock *addr_sk,
+							   u8 *rnextkeyid);
+{
+	return NULL;
+}
 static inline int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
 {
 	return -ENOPROTOOPT;
 }
 static inline int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *key)
@@ -51,8 +89,25 @@ static inline void tcp_authopt_clear(struct sock *sk)
 }
 static inline int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 {
 	return -ENOPROTOOPT;
 }
+static inline int tcp_authopt_hash(
+		char *hash_location,
+		struct tcp_authopt_key_info *key,
+		struct sock *sk, struct sk_buff *skb)
+{
+	return -EINVAL;
+}
+static inline int tcp_authopt_openreq(struct sock *newsk,
+				      const struct sock *oldsk,
+				      struct request_sock *req)
+{
+	return 0;
+}
+static inline int tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb)
+{
+	return 0;
+}
 #endif
 
 #endif /* _LINUX_TCP_AUTHOPT_H */
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index a42daadf6b7d..493461e46460 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -168,10 +168,66 @@ struct tcp_authopt_key_info *__tcp_authopt_key_info_lookup(const struct sock *sk
 			return key;
 
 	return NULL;
 }
 
+struct tcp_authopt_key_info *tcp_authopt_lookup_send(struct tcp_authopt_info *info,
+						     const struct sock *addr_sk,
+						     int send_id)
+{
+	struct tcp_authopt_key_info *result = NULL;
+	struct tcp_authopt_key_info *key;
+
+	hlist_for_each_entry_rcu(key, &info->head, node, 0) {
+		if (send_id >= 0 && key->send_id != send_id)
+			continue;
+		if (key->flags & TCP_AUTHOPT_KEY_ADDR_BIND) {
+			if (addr_sk->sk_family == AF_INET) {
+				struct sockaddr_in *key_addr = (struct sockaddr_in *)&key->addr;
+				const struct in_addr *daddr =
+					(const struct in_addr *)&addr_sk->sk_daddr;
+
+				if (WARN_ON(key_addr->sin_family != AF_INET))
+					continue;
+				if (memcmp(daddr, &key_addr->sin_addr, sizeof(*daddr)))
+					continue;
+			}
+			if (addr_sk->sk_family == AF_INET6) {
+				struct sockaddr_in6 *key_addr = (struct sockaddr_in6 *)&key->addr;
+				const struct in6_addr *daddr = &addr_sk->sk_v6_daddr;
+
+				if (WARN_ON(key_addr->sin6_family != AF_INET6))
+					continue;
+				if (memcmp(daddr, &key_addr->sin6_addr, sizeof(*daddr)))
+					continue;
+			}
+		}
+		if (result && net_ratelimit())
+			pr_warn("ambiguous tcp authentication keys configured for send\n");
+		result = key;
+	}
+
+	return result;
+}
+
+/* Select key for sending
+ * addr_sk is the sock used for comparing daddr, it is only different from sk in
+ * the synack case.
+ */
+struct tcp_authopt_key_info *tcp_authopt_select_key(const struct sock *sk,
+						    const struct sock *addr_sk,
+						    u8 *rnextkeyid)
+{
+	struct tcp_authopt_info *info;
+
+	info = rcu_dereference(tcp_sk(sk)->authopt_info);
+	if (!info)
+		return NULL;
+
+	return tcp_authopt_lookup_send(info, addr_sk, -1);
+}
+
 static struct tcp_authopt_info *__tcp_authopt_info_get_or_create(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_authopt_info *info;
 
@@ -336,16 +392,69 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 	key_info->recv_id = opt.recv_id;
 	key_info->alg_id = opt.alg;
 	key_info->alg = alg;
 	key_info->keylen = opt.keylen;
 	memcpy(key_info->key, opt.key, opt.keylen);
+	key_info->maclen = alg->maclen;
 	memcpy(&key_info->addr, &opt.addr, sizeof(key_info->addr));
 	hlist_add_head_rcu(&key_info->node, &info->head);
 
 	return 0;
 }
 
+static int tcp_authopt_clone_keys(struct sock *newsk,
+				  const struct sock *oldsk,
+				  struct tcp_authopt_info *new_info,
+				  struct tcp_authopt_info *old_info)
+{
+	struct tcp_authopt_key_info *old_key;
+	struct tcp_authopt_key_info *new_key;
+
+	hlist_for_each_entry_rcu(old_key, &old_info->head, node, lockdep_sock_is_held(sk)) {
+		new_key = sock_kmalloc(newsk, sizeof(*new_key), GFP_ATOMIC);
+		if (!new_key)
+			return -ENOMEM;
+		memcpy(new_key, old_key, sizeof(*new_key));
+		tcp_authopt_alg_incref(old_key->alg);
+		hlist_add_head_rcu(&new_key->node, &new_info->head);
+	}
+
+	return 0;
+}
+
+/** Called to create accepted sockets.
+ *
+ *  Need to copy authopt info from listen socket.
+ */
+int __tcp_authopt_openreq(struct sock *newsk, const struct sock *oldsk, struct request_sock *req)
+{
+	struct tcp_authopt_info *old_info;
+	struct tcp_authopt_info *new_info;
+	int err;
+
+	old_info = rcu_dereference(tcp_sk(oldsk)->authopt_info);
+	if (!old_info)
+		return 0;
+
+	new_info = kmalloc(sizeof(*new_info), GFP_ATOMIC | __GFP_ZERO);
+	if (!new_info)
+		return -ENOMEM;
+
+	sk_nocaps_add(newsk, NETIF_F_GSO_MASK);
+	new_info->src_isn = tcp_rsk(req)->snt_isn;
+	new_info->dst_isn = tcp_rsk(req)->rcv_isn;
+	INIT_HLIST_HEAD(&new_info->head);
+	err = tcp_authopt_clone_keys(newsk, oldsk, new_info, old_info);
+	if (err) {
+		__tcp_authopt_info_free(newsk, new_info);
+		return err;
+	}
+	rcu_assign_pointer(tcp_sk(newsk)->authopt_info, new_info);
+
+	return 0;
+}
+
 /* feed traffic key into shash */
 static int tcp_authopt_shash_traffic_key(struct shash_desc *desc,
 					 struct sock *sk,
 					 struct sk_buff *skb,
 					 bool input,
@@ -808,5 +917,123 @@ int __tcp_authopt_calc_mac(struct sock *sk,
 
 out:
 	tcp_authopt_put_mac_shash(key, mac_tfm);
 	return err;
 }
+
+int tcp_authopt_hash(char *hash_location,
+		     struct tcp_authopt_key_info *key,
+		     struct sock *sk,
+		     struct sk_buff *skb)
+{
+	/* MAC inside option is truncated to 12 bytes but crypto API needs output
+	 * buffer to be large enough so we use a buffer on the stack.
+	 */
+	u8 macbuf[TCP_AUTHOPT_MAXMACBUF];
+	int err;
+
+	if (WARN_ON(key->maclen > sizeof(macbuf)))
+		return -ENOBUFS;
+
+	err = __tcp_authopt_calc_mac(sk, skb, key, false, macbuf);
+	if (err) {
+		memset(hash_location, 0, key->maclen);
+		return err;
+	}
+	memcpy(hash_location, macbuf, key->maclen);
+
+	return 0;
+}
+
+static struct tcp_authopt_key_info *tcp_authopt_lookup_recv(struct sock *sk,
+							    struct sk_buff *skb,
+							    struct tcp_authopt_info *info,
+							    int recv_id)
+{
+	struct tcp_authopt_key_info *result = NULL;
+	struct tcp_authopt_key_info *key;
+
+	/* multiple matches will cause occasional failures */
+	hlist_for_each_entry_rcu(key, &info->head, node, 0) {
+		if (recv_id >= 0 && key->recv_id != recv_id)
+			continue;
+		if (key->flags & TCP_AUTHOPT_KEY_ADDR_BIND) {
+			if (sk->sk_family == AF_INET) {
+				struct sockaddr_in *key_addr = (struct sockaddr_in *)&key->addr;
+				struct iphdr *iph = (struct iphdr *)skb_network_header(skb);
+
+				if (WARN_ON(key_addr->sin_family != AF_INET))
+					continue;
+				if (WARN_ON(iph->version != 4))
+					continue;
+				if (memcmp(&iph->saddr, &key_addr->sin_addr, sizeof(iph->saddr)))
+					continue;
+			}
+			if (sk->sk_family == AF_INET6) {
+				struct sockaddr_in6 *key_addr = (struct sockaddr_in6 *)&key->addr;
+				struct ipv6hdr *iph = (struct ipv6hdr *)skb_network_header(skb);
+
+				if (WARN_ON(key_addr->sin6_family != AF_INET6))
+					continue;
+				if (WARN_ON(iph->version != 6))
+					continue;
+				if (memcmp(&iph->saddr, &key_addr->sin6_addr, sizeof(iph->saddr)))
+					continue;
+			}
+		}
+		if (result && net_ratelimit())
+			pr_warn("ambiguous tcp authentication keys configured for receive\n");
+		result = key;
+	}
+
+	return result;
+}
+
+int __tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb, struct tcp_authopt_info *info)
+{
+	struct tcphdr *th = (struct tcphdr *)skb_transport_header(skb);
+	struct tcphdr_authopt *opt;
+	struct tcp_authopt_key_info *key;
+	u8 macbuf[16];
+	int err;
+
+	opt = (struct tcphdr_authopt *)tcp_authopt_find_option(th);
+	key = tcp_authopt_lookup_recv(sk, skb, info, opt ? opt->keyid : -1);
+
+	/* nothing found or expected */
+	if (!opt && !key)
+		return 0;
+	if (!opt && key) {
+		net_info_ratelimited("TCP Authentication Missing\n");
+		return -EINVAL;
+	}
+	if (opt && !key) {
+		/* RFC5925 Section 7.3:
+		 * A TCP-AO implementation MUST allow for configuration of the behavior
+		 * of segments with TCP-AO but that do not match an MKT. The initial
+		 * default of this configuration SHOULD be to silently accept such
+		 * connections.
+		 */
+		if (info->flags & TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED) {
+			net_info_ratelimited("TCP Authentication Unexpected: Rejected\n");
+			return -EINVAL;
+		} else {
+			net_info_ratelimited("TCP Authentication Unexpected: Accepted\n");
+			return 0;
+		}
+	}
+
+	/* bad inbound key len */
+	if (key->maclen + 4 != opt->len)
+		return -EINVAL;
+
+	err = __tcp_authopt_calc_mac(sk, skb, key, true, macbuf);
+	if (err)
+		return err;
+
+	if (memcmp(macbuf, opt->mac, key->maclen)) {
+		net_info_ratelimited("TCP Authentication Failed\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 3f7bd7ae7d7a..e0b51b2f747f 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -70,10 +70,11 @@
 #include <linux/sysctl.h>
 #include <linux/kernel.h>
 #include <linux/prefetch.h>
 #include <net/dst.h>
 #include <net/tcp.h>
+#include <net/tcp_authopt.h>
 #include <net/inet_common.h>
 #include <linux/ipsec.h>
 #include <asm/unaligned.h>
 #include <linux/errqueue.h>
 #include <trace/events/tcp.h>
@@ -5967,18 +5968,34 @@ void tcp_init_transfer(struct sock *sk, int bpf_op, struct sk_buff *skb)
 	if (!icsk->icsk_ca_initialized)
 		tcp_init_congestion_control(sk);
 	tcp_init_buffer_space(sk);
 }
 
+static void tcp_authopt_finish_connect(struct sock *sk, struct sk_buff *skb)
+{
+#ifdef CONFIG_TCP_AUTHOPT
+	struct tcp_authopt_info *info;
+
+	info = rcu_dereference_protected(tcp_sk(sk)->authopt_info, lockdep_sock_is_held(sk));
+	if (!info)
+		return;
+
+	info->src_isn = ntohl(tcp_hdr(skb)->ack_seq) - 1;
+	info->dst_isn = ntohl(tcp_hdr(skb)->seq);
+#endif
+}
+
 void tcp_finish_connect(struct sock *sk, struct sk_buff *skb)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
 
 	tcp_set_state(sk, TCP_ESTABLISHED);
 	icsk->icsk_ack.lrcvtime = tcp_jiffies32;
 
+	tcp_authopt_finish_connect(sk, skb);
+
 	if (skb) {
 		icsk->icsk_af_ops->sk_rx_dst_set(sk, skb);
 		security_inet_conn_established(sk, skb);
 		sk_mark_napi_id(sk, skb);
 	}
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 1348615c7576..a1d39183908c 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2060,10 +2060,13 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		goto discard_and_relse;
 
 	if (tcp_v4_inbound_md5_hash(sk, skb, dif, sdif))
 		goto discard_and_relse;
 
+	if (tcp_authopt_inbound_check(sk, skb))
+		goto discard_and_relse;
+
 	nf_reset_ct(skb);
 
 	if (tcp_filter(sk, skb))
 		goto discard_and_relse;
 	th = (const struct tcphdr *)skb->data;
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 0a4f3f16140a..4d7d86547b0e 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -24,10 +24,11 @@
 #include <linux/slab.h>
 #include <linux/sysctl.h>
 #include <linux/workqueue.h>
 #include <linux/static_key.h>
 #include <net/tcp.h>
+#include <net/tcp_authopt.h>
 #include <net/inet_common.h>
 #include <net/xfrm.h>
 #include <net/busy_poll.h>
 
 static bool tcp_in_window(u32 seq, u32 end_seq, u32 s_win, u32 e_win)
@@ -539,10 +540,11 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
 #ifdef CONFIG_TCP_MD5SIG
 	newtp->md5sig_info = NULL;	/*XXX*/
 	if (newtp->af_specific->md5_lookup(sk, newsk))
 		newtp->tcp_header_len += TCPOLEN_MD5SIG_ALIGNED;
 #endif
+	tcp_authopt_openreq(newsk, sk, req);
 	if (skb->len >= TCP_MSS_DEFAULT + newtp->tcp_header_len)
 		newicsk->icsk_ack.last_seg_size = skb->len - newtp->tcp_header_len;
 	newtp->rx_opt.mss_clamp = req->mss;
 	tcp_ecn_openreq_child(newtp, req);
 	newtp->fastopen_req = NULL;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 29553fce8502..0e9ed6578809 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -37,10 +37,11 @@
 
 #define pr_fmt(fmt) "TCP: " fmt
 
 #include <net/tcp.h>
 #include <net/mptcp.h>
+#include <net/tcp_authopt.h>
 
 #include <linux/compiler.h>
 #include <linux/gfp.h>
 #include <linux/module.h>
 #include <linux/static_key.h>
@@ -411,10 +412,11 @@ static inline bool tcp_urg_mode(const struct tcp_sock *tp)
 
 #define OPTION_SACK_ADVERTISE	(1 << 0)
 #define OPTION_TS		(1 << 1)
 #define OPTION_MD5		(1 << 2)
 #define OPTION_WSCALE		(1 << 3)
+#define OPTION_AUTHOPT		(1 << 4)
 #define OPTION_FAST_OPEN_COOKIE	(1 << 8)
 #define OPTION_SMC		(1 << 9)
 #define OPTION_MPTCP		(1 << 10)
 
 static void smc_options_write(__be32 *ptr, u16 *options)
@@ -435,16 +437,21 @@ static void smc_options_write(__be32 *ptr, u16 *options)
 struct tcp_out_options {
 	u16 options;		/* bit field of OPTION_* */
 	u16 mss;		/* 0 to disable */
 	u8 ws;			/* window scale, 0 to disable */
 	u8 num_sack_blocks;	/* number of SACK blocks to include */
-	u8 hash_size;		/* bytes in hash_location */
 	u8 bpf_opt_len;		/* length of BPF hdr option */
+#ifdef CONFIG_TCP_AUTHOPT
+	u8 authopt_rnextkeyid; /* rnextkey */
+#endif
 	__u8 *hash_location;	/* temporary pointer, overloaded */
 	__u32 tsval, tsecr;	/* need to include OPTION_TS */
 	struct tcp_fastopen_cookie *fastopen_cookie;	/* Fast open cookie */
 	struct mptcp_out_options mptcp;
+#ifdef CONFIG_TCP_AUTHOPT
+	struct tcp_authopt_key_info *authopt_key;
+#endif
 };
 
 static void mptcp_options_write(__be32 *ptr, const struct tcp_sock *tp,
 				struct tcp_out_options *opts)
 {
@@ -617,10 +624,24 @@ static void tcp_options_write(__be32 *ptr, struct tcp_sock *tp,
 		/* overload cookie hash location */
 		opts->hash_location = (__u8 *)ptr;
 		ptr += 4;
 	}
 
+#ifdef CONFIG_TCP_AUTHOPT
+	if (unlikely(OPTION_AUTHOPT & options)) {
+		struct tcp_authopt_key_info *key = opts->authopt_key;
+
+		WARN_ON(!key);
+		*ptr++ = htonl((TCPOPT_AUTHOPT << 24) | ((4 + key->maclen) << 16) |
+			       (key->send_id << 8) | opts->authopt_rnextkeyid);
+		/* overload cookie hash location */
+		opts->hash_location = (__u8 *)ptr;
+		/* maclen is currently always 12 but try to align nicely anyway. */
+		ptr += (key->maclen + 3) / 4;
+	}
+#endif
+
 	if (unlikely(opts->mss)) {
 		*ptr++ = htonl((TCPOPT_MSS << 24) |
 			       (TCPOLEN_MSS << 16) |
 			       opts->mss);
 	}
@@ -752,10 +773,28 @@ static void mptcp_set_option_cond(const struct request_sock *req,
 			}
 		}
 	}
 }
 
+static int tcp_authopt_init_options(const struct sock *sk,
+				    const struct sock *addr_sk,
+				    struct tcp_out_options *opts)
+{
+#ifdef CONFIG_TCP_AUTHOPT
+	struct tcp_authopt_key_info *key;
+
+	key = tcp_authopt_select_key(sk, addr_sk, &opts->authopt_rnextkeyid);
+	if (key) {
+		opts->options |= OPTION_AUTHOPT;
+		opts->authopt_key = key;
+		return 4 + key->maclen;
+	}
+#endif
+
+	return 0;
+}
+
 /* Compute TCP options for SYN packets. This is not the final
  * network wire format yet.
  */
 static unsigned int tcp_syn_options(struct sock *sk, struct sk_buff *skb,
 				struct tcp_out_options *opts,
@@ -774,10 +813,11 @@ static unsigned int tcp_syn_options(struct sock *sk, struct sk_buff *skb,
 			opts->options |= OPTION_MD5;
 			remaining -= TCPOLEN_MD5SIG_ALIGNED;
 		}
 	}
 #endif
+	remaining -= tcp_authopt_init_options(sk, sk, opts);
 
 	/* We always get an MSS option.  The option bytes which will be seen in
 	 * normal data packets should timestamps be used, must be in the MSS
 	 * advertised.  But we subtract them from tp->mss_cache so that
 	 * calculations in tcp_sendmsg are simpler etc.  So account for this
@@ -862,10 +902,11 @@ static unsigned int tcp_synack_options(const struct sock *sk,
 		 */
 		if (synack_type != TCP_SYNACK_COOKIE)
 			ireq->tstamp_ok &= !ireq->sack_ok;
 	}
 #endif
+	remaining -= tcp_authopt_init_options(sk, req_to_sk(req), opts);
 
 	/* We always send an MSS option. */
 	opts->mss = mss;
 	remaining -= TCPOLEN_MSS_ALIGNED;
 
@@ -930,10 +971,11 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
 			opts->options |= OPTION_MD5;
 			size += TCPOLEN_MD5SIG_ALIGNED;
 		}
 	}
 #endif
+	size += tcp_authopt_init_options(sk, sk, opts);
 
 	if (likely(tp->rx_opt.tstamp_ok)) {
 		opts->options |= OPTION_TS;
 		opts->tsval = skb ? tcp_skb_timestamp(skb) + tp->tsoffset : 0;
 		opts->tsecr = tp->rx_opt.ts_recent;
@@ -1365,10 +1407,17 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 		sk_nocaps_add(sk, NETIF_F_GSO_MASK);
 		tp->af_specific->calc_md5_hash(opts.hash_location,
 					       md5, sk, skb);
 	}
 #endif
+#ifdef CONFIG_TCP_AUTHOPT
+	if (opts.authopt_key) {
+		sk_nocaps_add(sk, NETIF_F_GSO_MASK);
+		err = tcp_authopt_hash(opts.hash_location, opts.authopt_key, sk, skb);
+		WARN_ON(err); // FIXME
+	}
+#endif
 
 	/* BPF prog is the last one writing header option */
 	bpf_skops_write_hdr_opt(sk, skb, NULL, NULL, 0, &opts);
 
 	INDIRECT_CALL_INET(icsk->icsk_af_ops->send_check,
@@ -3602,10 +3651,15 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	if (md5)
 		tcp_rsk(req)->af_specific->calc_md5_hash(opts.hash_location,
 					       md5, req_to_sk(req), skb);
 	rcu_read_unlock();
 #endif
+#ifdef CONFIG_TCP_AUTHOPT
+	/* If signature fails we do nothing */
+	if (opts.authopt_key)
+		tcp_authopt_hash(opts.hash_location, opts.authopt_key, req_to_sk(req), skb);
+#endif
 
 	bpf_skops_write_hdr_opt((struct sock *)sk, skb, req, syn_skb,
 				synack_type, &opts);
 
 	skb->skb_mstamp_ns = now;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 0ce52d46e4f8..51381a9c2bd5 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -40,10 +40,11 @@
 #include <linux/icmpv6.h>
 #include <linux/random.h>
 #include <linux/indirect_call_wrapper.h>
 
 #include <net/tcp.h>
+#include <net/tcp_authopt.h>
 #include <net/ndisc.h>
 #include <net/inet6_hashtables.h>
 #include <net/inet6_connection_sock.h>
 #include <net/ipv6.h>
 #include <net/transp_v6.h>
@@ -1733,10 +1734,13 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		goto discard_and_relse;
 
 	if (tcp_v6_inbound_md5_hash(sk, skb, dif, sdif))
 		goto discard_and_relse;
 
+	if (tcp_authopt_inbound_check(sk, skb))
+		goto discard_and_relse;
+
 	if (tcp_filter(sk, skb))
 		goto discard_and_relse;
 	th = (const struct tcphdr *)skb->data;
 	hdr = ipv6_hdr(skb);
 	tcp_v6_fill_cb(skb, hdr, th);
-- 
2.25.1

