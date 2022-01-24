Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 313ED497ECE
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 13:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239446AbiAXMOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 07:14:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238415AbiAXMNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 07:13:46 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDD0C061759;
        Mon, 24 Jan 2022 04:13:33 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id j2so20650591ejk.6;
        Mon, 24 Jan 2022 04:13:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Npmtzve805AR/GA4sR9uP36/5Oa0bI0e4kLLniMVYtE=;
        b=KW8kiJPA4F9xqOpthf8C0S8zcFZzF0G3n9+jPXA/agZj1HbCDnHT1JvHaDv9i5ct3/
         L+37eelRzOc/RGldzVJf3MgOr4cQqN+ZkFtxL/ej1vKfdCQXfk42ude0Xu8KCWJNlukZ
         lBezUlDiMQ0HM+XhEBRtwH9/tKkKcgzQUTt+lWzignBgQqsprZUZJKpJiR22q/gNcN82
         CpUUCNn82Vgq7FeQ1Gn3i9unIRIa0AXzk4m47Pq0hZ/0QEbJC3jqB8cuO6uOcanUkEUC
         hLhY5GEaaHMN6vNHBgpcl+SY/DgBQ9AjzOixsSh0AbUx3N9lapfFPN78xJIaviiTLNS3
         NC6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Npmtzve805AR/GA4sR9uP36/5Oa0bI0e4kLLniMVYtE=;
        b=TJUmy/QARZt5mPJ8xu8It9r9/Jimi0r//ur4Kyo+V9UQtIHZJWA2xJTHlBjKeF1IkU
         FZxegwFR+Wymd2SLXvokvGKav5JkIt9pKG8mbPkE6+L+9B9KsXAcI6QOwcoXOGkT+6OY
         DdQUoZjbD7sPBytv5VG9RdoxSZdeG+5xFYqTnfD8QW5tcYjZDw224WAtd8j+XVp66Ycb
         liXxrnYKLrIbwpC4u8ysXi8ZkCFHL9poSdUnANfAXz82Mcp5YsFWiIV/8/TYt8UhXMzF
         URo4dAXgddpFTXO7yJ9sAgHgGA994XD6twX8JXXHtcVQGqKJd7D5+ttVTCmVFDEF7O8E
         xFcA==
X-Gm-Message-State: AOAM530OqKErbV2Yi7TIv9uRv3/tIFbMyYOCMFmOvw58D5j2qV2WamVd
        8qLQeJHWRgsy/vUvBEygyqU=
X-Google-Smtp-Source: ABdhPJw6xZiZhywWdRD5PrnpsetavUxqcwLygtMgGTAEVi8Ph6UTj4kJlnJB3O9rFvYHPnK52ozywA==
X-Received: by 2002:a17:907:1c1b:: with SMTP id nc27mr4879335ejc.618.1643026411415;
        Mon, 24 Jan 2022 04:13:31 -0800 (PST)
Received: from ponky.lan ([2a04:241e:502:a09c:a21f:7a9f:9158:4a40])
        by smtp.gmail.com with ESMTPSA id b16sm4847517eja.211.2022.01.24.04.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 04:13:30 -0800 (PST)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Shuah Khan <shuah@kernel.org>,
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
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 06/20] tcp: authopt: Hook into tcp core
Date:   Mon, 24 Jan 2022 14:12:52 +0200
Message-Id: <436766dc4981be6036bfa6a00e40631701b35848.1643026076.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1643026076.git.cdleonard@gmail.com>
References: <cover.1643026076.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tcp_authopt features exposes a minimal interface to the rest of the
TCP stack. Only a few functions are exposed and if the feature is
disabled they return neutral values, avoiding ifdefs in the rest of the
code. This approach is different from MD5.

There very few interactions with MD5 but tcp_parse_md5sig_option was
modifed to parse AO and MD5 simultaneously. If both are present the
packet is droppped as required by RFC5925.

Add calls into tcp authopt from send, receive and accept code.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/net/tcp.h         |  24 +++-
 include/net/tcp_authopt.h | 136 ++++++++++++++++++
 include/uapi/linux/snmp.h |   1 +
 net/ipv4/proc.c           |   1 +
 net/ipv4/tcp_authopt.c    | 286 ++++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_input.c      |  40 ++++--
 net/ipv4/tcp_ipv4.c       |  50 ++++++-
 net/ipv4/tcp_minisocks.c  |  12 ++
 net/ipv4/tcp_output.c     |  85 ++++++++++-
 net/ipv6/tcp_ipv6.c       |  49 ++++++-
 10 files changed, 659 insertions(+), 25 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 1a0513b0ead0..9d22d541fad1 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -422,11 +422,33 @@ int tcp_mmap(struct file *file, struct socket *sock,
 	     struct vm_area_struct *vma);
 #endif
 void tcp_parse_options(const struct net *net, const struct sk_buff *skb,
 		       struct tcp_options_received *opt_rx,
 		       int estab, struct tcp_fastopen_cookie *foc);
-const u8 *tcp_parse_md5sig_option(const struct tcphdr *th);
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AUTHOPT)
+int tcp_parse_sig_options(const struct tcphdr *th,
+			  const u8 **md5ptr,
+			  const u8 **aoptr);
+#else
+static inline int tcp_parse_sig_options(const struct tcphdr *th,
+			  const u8 **md5ptr,
+			  const u8 **aoptr)
+{
+	*aoptr = NULL;
+	*md5ptr = NULL;
+	return 0;
+}
+#endif
+static inline const u8 *tcp_parse_md5sig_option(const struct tcphdr *th)
+{
+	const u8 *md5, *ao;
+	int ret;
+
+	ret = tcp_parse_sig_options(th, &md5, &ao);
+
+	return (md5 && !ao && !ret) ? md5 : NULL;
+}
 
 /*
  *	BPF SKB-less helpers
  */
 u16 tcp_v4_get_syncookie(struct sock *sk, struct iphdr *iph,
diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index 7d0a66fcde71..7096e3ad59a6 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -78,28 +78,164 @@ struct tcphdr_authopt {
 	u8 rnextkeyid;
 	u8 mac[0];
 };
 
 #ifdef CONFIG_TCP_AUTHOPT
+DECLARE_STATIC_KEY_FALSE(tcp_authopt_needed_key);
+#define tcp_authopt_needed (static_branch_unlikely(&tcp_authopt_needed_key))
+
+void tcp_authopt_free(struct sock *sk, struct tcp_authopt_info *info);
 void tcp_authopt_clear(struct sock *sk);
 int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen);
 int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *key);
 int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen);
+struct tcp_authopt_key_info *__tcp_authopt_select_key(
+		const struct sock *sk,
+		struct tcp_authopt_info *info,
+		const struct sock *addr_sk,
+		u8 *rnextkeyid);
+static inline struct tcp_authopt_key_info *tcp_authopt_select_key(
+		const struct sock *sk,
+		const struct sock *addr_sk,
+		struct tcp_authopt_info **info,
+		u8 *rnextkeyid)
+{
+	if (tcp_authopt_needed) {
+		*info = rcu_dereference(tcp_sk(sk)->authopt_info);
+
+		if (*info)
+			return __tcp_authopt_select_key(sk, *info, addr_sk, rnextkeyid);
+	}
+	return NULL;
+}
+int tcp_authopt_hash(
+		char *hash_location,
+		struct tcp_authopt_key_info *key,
+		struct tcp_authopt_info *info,
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
+void __tcp_authopt_finish_connect(struct sock *sk, struct sk_buff *skb,
+				  struct tcp_authopt_info *info);
+static inline void tcp_authopt_finish_connect(struct sock *sk, struct sk_buff *skb)
+{
+	struct tcp_authopt_info *info;
+
+	if (tcp_authopt_needed) {
+		info = rcu_dereference_protected(tcp_sk(sk)->authopt_info,
+						 lockdep_sock_is_held(sk));
+
+		if (info)
+			__tcp_authopt_finish_connect(sk, skb, info);
+	}
+}
+static inline void tcp_authopt_time_wait(
+		struct tcp_timewait_sock *tcptw,
+		struct tcp_sock *tp)
+{
+	if (tcp_authopt_needed) {
+		/* Transfer ownership of authopt_info to the twsk
+		 * This requires no other users of the origin sock.
+		 */
+		tcptw->tw_authopt_info = rcu_dereference_protected(
+				tp->authopt_info,
+				lockdep_sock_is_held((struct sock *)tp));
+		rcu_assign_pointer(tp->authopt_info, NULL);
+	} else {
+		tcptw->tw_authopt_info = NULL;
+	}
+}
+/** tcp_authopt_inbound_check - check for valid TCP-AO signature.
+ *
+ * Return negative ERRNO on error, 0 if not present and 1 if present and valid.
+ *
+ * If the AO signature is present and valid then caller skips MD5 check.
+ */
+int __tcp_authopt_inbound_check(
+		struct sock *sk,
+		struct sk_buff *skb,
+		struct tcp_authopt_info *info,
+		const u8 *opt);
+static inline int tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb, const u8 *opt)
+{
+	if (tcp_authopt_needed) {
+		struct tcp_authopt_info *info = rcu_dereference(tcp_sk(sk)->authopt_info);
+
+		if (info)
+			return __tcp_authopt_inbound_check(sk, skb, info, opt);
+	}
+	return 0;
+}
+static inline int tcp_authopt_inbound_check_req(struct request_sock *req, struct sk_buff *skb,
+						const u8 *opt)
+{
+	if (tcp_authopt_needed) {
+		struct sock *lsk = req->rsk_listener;
+		struct tcp_authopt_info *info = rcu_dereference(tcp_sk(lsk)->authopt_info);
+
+		if (info)
+			return __tcp_authopt_inbound_check((struct sock *)req, skb, info, opt);
+	}
+	return 0;
+}
 #else
 static inline int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
 {
 	return -ENOPROTOOPT;
 }
 static inline int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *key)
 {
 	return -ENOPROTOOPT;
 }
+static inline void tcp_authopt_free(struct sock *sk, struct tcp_authopt_info *info)
+{
+}
 static inline void tcp_authopt_clear(struct sock *sk)
 {
 }
 static inline int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 {
 	return -ENOPROTOOPT;
 }
+static inline int tcp_authopt_hash(
+		char *hash_location,
+		struct tcp_authopt_key_info *key,
+		struct tcp_authopt_key *info,
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
+static inline void tcp_authopt_finish_connect(struct sock *sk, struct sk_buff *skb)
+{
+}
+static inline void tcp_authopt_time_wait(
+		struct tcp_timewait_sock *tcptw,
+		struct tcp_sock *tp)
+{
+}
+static inline int tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb, const u8 *opt)
+{
+	return 0;
+}
+static inline int tcp_authopt_inbound_check_req(struct request_sock *sk, struct sk_buff *skb,
+						const u8 *opt)
+{
+	return 0;
+}
 #endif
 
 #endif /* _LINUX_TCP_AUTHOPT_H */
diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index 904909d020e2..1d96030889a1 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -290,10 +290,11 @@ enum
 	LINUX_MIB_TCPDUPLICATEDATAREHASH,	/* TCPDuplicateDataRehash */
 	LINUX_MIB_TCPDSACKRECVSEGS,		/* TCPDSACKRecvSegs */
 	LINUX_MIB_TCPDSACKIGNOREDDUBIOUS,	/* TCPDSACKIgnoredDubious */
 	LINUX_MIB_TCPMIGRATEREQSUCCESS,		/* TCPMigrateReqSuccess */
 	LINUX_MIB_TCPMIGRATEREQFAILURE,		/* TCPMigrateReqFailure */
+	LINUX_MIB_TCPAUTHOPTFAILURE,		/* TCPAuthOptFailure */
 	__LINUX_MIB_MAX
 };
 
 /* linux Xfrm mib definitions */
 enum
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index f30273afb539..70f7a8a47045 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -295,10 +295,11 @@ static const struct snmp_mib snmp4_net_list[] = {
 	SNMP_MIB_ITEM("TcpDuplicateDataRehash", LINUX_MIB_TCPDUPLICATEDATAREHASH),
 	SNMP_MIB_ITEM("TCPDSACKRecvSegs", LINUX_MIB_TCPDSACKRECVSEGS),
 	SNMP_MIB_ITEM("TCPDSACKIgnoredDubious", LINUX_MIB_TCPDSACKIGNOREDDUBIOUS),
 	SNMP_MIB_ITEM("TCPMigrateReqSuccess", LINUX_MIB_TCPMIGRATEREQSUCCESS),
 	SNMP_MIB_ITEM("TCPMigrateReqFailure", LINUX_MIB_TCPMIGRATEREQFAILURE),
+	SNMP_MIB_ITEM("TCPAuthOptFailure", LINUX_MIB_TCPAUTHOPTFAILURE),
 	SNMP_MIB_SENTINEL
 };
 
 static void icmpmsg_put_line(struct seq_file *seq, unsigned long *vals,
 			     unsigned short *type, int count)
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 06727b4f96e8..694dbc9f3a94 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -4,10 +4,14 @@
 #include <net/ipv6.h>
 #include <net/tcp.h>
 #include <linux/kref.h>
 #include <crypto/hash.h>
 
+/* This is enabled when first struct tcp_authopt_info is allocated and never released */
+DEFINE_STATIC_KEY_FALSE(tcp_authopt_needed_key);
+EXPORT_SYMBOL(tcp_authopt_needed_key);
+
 /* All current algorithms have a mac length of 12 but crypto API digestsize can be larger */
 #define TCP_AUTHOPT_MAXMACBUF			20
 #define TCP_AUTHOPT_MAX_TRAFFIC_KEY_LEN		20
 #define TCP_AUTHOPT_MACLEN			12
 
@@ -264,10 +268,57 @@ static bool tcp_authopt_key_match_exact(struct tcp_authopt_key_info *info,
 			return false;
 
 	return true;
 }
 
+static bool tcp_authopt_key_match_skb_addr(struct tcp_authopt_key_info *key,
+					   struct sk_buff *skb)
+{
+	u16 keyaf = key->addr.ss_family;
+	struct iphdr *iph = (struct iphdr *)skb_network_header(skb);
+
+	if (keyaf == AF_INET && iph->version == 4) {
+		struct sockaddr_in *key_addr = (struct sockaddr_in *)&key->addr;
+
+		return iph->saddr == key_addr->sin_addr.s_addr;
+	} else if (keyaf == AF_INET6 && iph->version == 6) {
+		struct ipv6hdr *ip6h = (struct ipv6hdr *)skb_network_header(skb);
+		struct sockaddr_in6 *key_addr = (struct sockaddr_in6 *)&key->addr;
+
+		return ipv6_addr_equal(&ip6h->saddr, &key_addr->sin6_addr);
+	}
+
+	/* This actually happens with ipv6-mapped-ipv4-addresses
+	 * IPv6 listen sockets will be asked to validate ipv4 packets.
+	 */
+	return false;
+}
+
+static bool tcp_authopt_key_match_sk_addr(struct tcp_authopt_key_info *key,
+					  const struct sock *addr_sk)
+{
+	u16 keyaf = key->addr.ss_family;
+
+	/* This probably can't happen even with ipv4-mapped-ipv6 */
+	if (keyaf != addr_sk->sk_family)
+		return false;
+
+	if (keyaf == AF_INET) {
+		struct sockaddr_in *key_addr = (struct sockaddr_in *)&key->addr;
+
+		return addr_sk->sk_daddr == key_addr->sin_addr.s_addr;
+#if IS_ENABLED(CONFIG_IPV6)
+	} else if (keyaf == AF_INET6) {
+		struct sockaddr_in6 *key_addr = (struct sockaddr_in6 *)&key->addr;
+
+		return ipv6_addr_equal(&addr_sk->sk_v6_daddr, &key_addr->sin6_addr);
+#endif
+	}
+
+	return false;
+}
+
 static struct tcp_authopt_key_info *tcp_authopt_key_lookup_exact(const struct sock *sk,
 								 struct netns_tcp_authopt *net,
 								 struct tcp_authopt_key *ukey)
 {
 	struct tcp_authopt_key_info *key_info;
@@ -277,10 +328,52 @@ static struct tcp_authopt_key_info *tcp_authopt_key_lookup_exact(const struct so
 			return key_info;
 
 	return NULL;
 }
 
+static struct tcp_authopt_key_info *tcp_authopt_lookup_send(struct netns_tcp_authopt *net,
+							    const struct sock *addr_sk,
+							    int send_id)
+{
+	struct tcp_authopt_key_info *result = NULL;
+	struct tcp_authopt_key_info *key;
+
+	hlist_for_each_entry_rcu(key, &net->head, node, 0) {
+		if (send_id >= 0 && key->send_id != send_id)
+			continue;
+		if (key->flags & TCP_AUTHOPT_KEY_ADDR_BIND)
+			if (!tcp_authopt_key_match_sk_addr(key, addr_sk))
+				continue;
+		if (result && net_ratelimit())
+			pr_warn("ambiguous tcp authentication keys configured for send\n");
+		result = key;
+	}
+
+	return result;
+}
+
+/**
+ * __tcp_authopt_select_key - select key for sending
+ *
+ * @sk: socket
+ * @info: socket's tcp_authopt_info
+ * @addr_sk: socket used for address lookup. Same as sk except for synack case
+ * @rnextkeyid: value of rnextkeyid caller should write in packet
+ *
+ * Result is protected by RCU and can't be stored, it may only be passed to
+ * tcp_authopt_hash and only under a single rcu_read_lock.
+ */
+struct tcp_authopt_key_info *__tcp_authopt_select_key(const struct sock *sk,
+						      struct tcp_authopt_info *info,
+						      const struct sock *addr_sk,
+						      u8 *rnextkeyid)
+{
+	struct netns_tcp_authopt *net = sock_net_tcp_authopt(sk);
+
+	return tcp_authopt_lookup_send(net, addr_sk, -1);
+}
+
 static struct tcp_authopt_info *__tcp_authopt_info_get_or_create(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_authopt_info *info;
 
@@ -290,10 +383,12 @@ static struct tcp_authopt_info *__tcp_authopt_info_get_or_create(struct sock *sk
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
 		return ERR_PTR(-ENOMEM);
 
+	/* Never released: */
+	static_branch_inc(&tcp_authopt_needed_key);
 	sk_gso_disable(sk);
 	rcu_assign_pointer(tp->authopt_info, info);
 
 	return info;
 }
@@ -542,10 +637,45 @@ static int crypto_ahash_buf(struct ahash_request *req, u8 *buf, uint len)
 	ahash_request_set_crypt(req, &sg, NULL, len);
 
 	return crypto_ahash_update(req);
 }
 
+/** Called to create accepted sockets.
+ *
+ *  Need to copy authopt info from listen socket.
+ */
+int __tcp_authopt_openreq(struct sock *newsk, const struct sock *oldsk, struct request_sock *req)
+{
+	struct tcp_authopt_info *old_info;
+	struct tcp_authopt_info *new_info;
+
+	old_info = rcu_dereference(tcp_sk(oldsk)->authopt_info);
+	if (!old_info)
+		return 0;
+
+	/* Clear value copies from oldsk: */
+	rcu_assign_pointer(tcp_sk(newsk)->authopt_info, NULL);
+
+	new_info = kzalloc(sizeof(*new_info), GFP_ATOMIC);
+	if (!new_info)
+		return -ENOMEM;
+
+	new_info->src_isn = tcp_rsk(req)->snt_isn;
+	new_info->dst_isn = tcp_rsk(req)->rcv_isn;
+	sk_gso_disable(newsk);
+	rcu_assign_pointer(tcp_sk(newsk)->authopt_info, new_info);
+
+	return 0;
+}
+
+void __tcp_authopt_finish_connect(struct sock *sk, struct sk_buff *skb,
+				  struct tcp_authopt_info *info)
+{
+	info->src_isn = ntohl(tcp_hdr(skb)->ack_seq) - 1;
+	info->dst_isn = ntohl(tcp_hdr(skb)->seq);
+}
+
 /* feed traffic key into ahash */
 static int tcp_authopt_ahash_traffic_key(struct tcp_authopt_alg_pool *pool,
 					 struct sock *sk,
 					 struct sk_buff *skb,
 					 struct tcp_authopt_info *info,
@@ -790,10 +920,11 @@ static int tcp_authopt_hash_opts(struct tcp_authopt_alg_pool *pool,
 
 static int tcp_authopt_hash_packet(struct tcp_authopt_alg_pool *pool,
 				   struct sock *sk,
 				   struct sk_buff *skb,
 				   struct tcphdr_authopt *aoptr,
+				   struct tcp_authopt_info *info,
 				   bool input,
 				   bool ipv6,
 				   bool include_options,
 				   u8 *macbuf)
 {
@@ -907,20 +1038,175 @@ static int __tcp_authopt_calc_mac(struct sock *sk,
 
 	err = tcp_authopt_hash_packet(mac_pool,
 				      sk,
 				      skb,
 				      aoptr,
+				      info,
 				      input,
 				      ipv6,
 				      !(key->flags & TCP_AUTHOPT_KEY_EXCLUDE_OPTS),
 				      macbuf);
 
 out:
 	tcp_authopt_put_mac_pool(key, mac_pool);
 	return err;
 }
 
+/* tcp_authopt_hash - fill in the mac
+ *
+ * The key must come from tcp_authopt_select_key.
+ */
+int tcp_authopt_hash(char *hash_location,
+		     struct tcp_authopt_key_info *key,
+		     struct tcp_authopt_info *info,
+		     struct sock *sk,
+		     struct sk_buff *skb)
+{
+	/* MAC inside option is truncated to 12 bytes but crypto API needs output
+	 * buffer to be large enough so we use a buffer on the stack.
+	 */
+	u8 macbuf[TCP_AUTHOPT_MAXMACBUF];
+	int err;
+	struct tcphdr_authopt *aoptr = (struct tcphdr_authopt *)(hash_location - 4);
+
+	err = __tcp_authopt_calc_mac(sk, skb, aoptr, key, info, false, macbuf);
+	if (err)
+		goto fail;
+	memcpy(hash_location, macbuf, TCP_AUTHOPT_MACLEN);
+
+	return 0;
+
+fail:
+	/* If mac calculation fails and caller doesn't handle the error
+	 * try to make it obvious inside the packet.
+	 */
+	memset(hash_location, 0, TCP_AUTHOPT_MACLEN);
+	return err;
+}
+
+/**
+ * tcp_authopt_lookup_recv - lookup key for receive
+ *
+ * @sk: Receive socket
+ * @skb: Packet, used to compare addr and iface
+ * @net: Per-namespace information containing keys
+ * @recv_id: Optional recv_id. If >= 0 then only return keys that match
+ * @anykey: Set to true if any keys are present for the peer
+ *
+ * If anykey is false then authentication is not expected from the peer so we
+ * should based on TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED
+ *
+ * If anykey is true then a valid key is required.
+ */
+static struct tcp_authopt_key_info *tcp_authopt_lookup_recv(struct sock *sk,
+							    struct sk_buff *skb,
+							    struct netns_tcp_authopt *net,
+							    int recv_id,
+							    bool *anykey)
+{
+	struct tcp_authopt_key_info *result = NULL;
+	struct tcp_authopt_key_info *key;
+
+	*anykey = false;
+	/* multiple matches will cause occasional failures */
+	hlist_for_each_entry_rcu(key, &net->head, node, 0) {
+		if (key->flags & TCP_AUTHOPT_KEY_ADDR_BIND &&
+		    !tcp_authopt_key_match_skb_addr(key, skb))
+			continue;
+		*anykey = true;
+		if (recv_id >= 0 && key->recv_id != recv_id)
+			continue;
+		if (!result)
+			result = key;
+		else if (result)
+			net_warn_ratelimited("ambiguous tcp authentication keys configured for recv\n");
+	}
+
+	return result;
+}
+
+/* Show a rate-limited message for authentication fail */
+static void print_tcpao_notice(const char *msg, struct sk_buff *skb)
+{
+	struct iphdr *iph = (struct iphdr *)skb_network_header(skb);
+	struct tcphdr *th = (struct tcphdr *)skb_transport_header(skb);
+
+	if (iph->version == 4) {
+		net_info_ratelimited("%s (%pI4, %d)->(%pI4, %d)\n", msg,
+				     &iph->saddr, ntohs(th->source),
+				     &iph->daddr, ntohs(th->dest));
+	} else if (iph->version == 6) {
+		struct ipv6hdr *ip6h = (struct ipv6hdr *)skb_network_header(skb);
+
+		net_info_ratelimited("%s (%pI6, %d)->(%pI6, %d)\n", msg,
+				     &ip6h->saddr, ntohs(th->source),
+				     &ip6h->daddr, ntohs(th->dest));
+	} else {
+		WARN_ONCE(1, "%s unknown IP version\n", msg);
+	}
+}
+
+int __tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb,
+				struct tcp_authopt_info *info, const u8 *_opt)
+{
+	struct netns_tcp_authopt *net = sock_net_tcp_authopt(sk);
+	struct tcphdr_authopt *opt = (struct tcphdr_authopt *)_opt;
+	struct tcp_authopt_key_info *key;
+	bool anykey;
+	u8 macbuf[TCP_AUTHOPT_MAXMACBUF];
+	int err;
+
+	key = tcp_authopt_lookup_recv(sk, skb, net, opt ? opt->keyid : -1, &anykey);
+
+	/* nothing found or expected */
+	if (!opt && !anykey)
+		return 0;
+	if (!opt && anykey) {
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAUTHOPTFAILURE);
+		print_tcpao_notice("TCP Authentication Missing", skb);
+		return -EINVAL;
+	}
+	if (opt && !anykey) {
+		/* RFC5925 Section 7.3:
+		 * A TCP-AO implementation MUST allow for configuration of the behavior
+		 * of segments with TCP-AO but that do not match an MKT. The initial
+		 * default of this configuration SHOULD be to silently accept such
+		 * connections.
+		 */
+		if (info->flags & TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED) {
+			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAUTHOPTFAILURE);
+			print_tcpao_notice("TCP Authentication Unexpected: Rejected", skb);
+			return -EINVAL;
+		}
+		print_tcpao_notice("TCP Authentication Unexpected: Accepted", skb);
+		return 0;
+	}
+	if (opt && !key) {
+		/* Keys are configured for peer but with different keyid than packet */
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAUTHOPTFAILURE);
+		print_tcpao_notice("TCP Authentication Failed", skb);
+		return -EINVAL;
+	}
+
+	/* bad inbound key len */
+	if (opt->len != TCPOLEN_AUTHOPT_OUTPUT)
+		return -EINVAL;
+
+	err = __tcp_authopt_calc_mac(sk, skb, opt, key, info, true, macbuf);
+	if (err)
+		return err;
+
+	if (memcmp(macbuf, opt->mac, TCP_AUTHOPT_MACLEN)) {
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAUTHOPTFAILURE);
+		print_tcpao_notice("TCP Authentication Failed", skb);
+		return -EINVAL;
+	}
+
+	return 1;
+}
+EXPORT_SYMBOL(__tcp_authopt_inbound_check);
+
 static int tcp_authopt_init_net(struct net *full_net)
 {
 	struct netns_tcp_authopt *net = &full_net->tcp_authopt;
 
 	mutex_init(&net->mutex);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index dc49a3d551eb..5bdb8c31b943 100644
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
@@ -4173,43 +4174,60 @@ static bool tcp_fast_parse_options(const struct net *net,
 		tp->rx_opt.rcv_tsecr -= tp->tsoffset;
 
 	return true;
 }
 
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AUTHOPT)
 /*
- * Parse MD5 Signature option
+ * Parse MD5 and AO options
+ *
+ * md5ptr: pointer to content of MD5 option (16-byte hash)
+ * aoptr: pointer to start of AO option (variable length)
  */
-const u8 *tcp_parse_md5sig_option(const struct tcphdr *th)
+int tcp_parse_sig_options(const struct tcphdr *th, const u8 **md5ptr, const u8 **aoptr)
 {
 	int length = (th->doff << 2) - sizeof(*th);
 	const u8 *ptr = (const u8 *)(th + 1);
 
+	*md5ptr = NULL;
+	*aoptr = NULL;
+
 	/* If not enough data remaining, we can short cut */
-	while (length >= TCPOLEN_MD5SIG) {
+	while (length >= 4) {
 		int opcode = *ptr++;
 		int opsize;
 
 		switch (opcode) {
 		case TCPOPT_EOL:
-			return NULL;
+			goto out;
 		case TCPOPT_NOP:
 			length--;
 			continue;
 		default:
 			opsize = *ptr++;
 			if (opsize < 2 || opsize > length)
-				return NULL;
-			if (opcode == TCPOPT_MD5SIG)
-				return opsize == TCPOLEN_MD5SIG ? ptr : NULL;
+				goto out;
+			if (opcode == TCPOPT_MD5SIG && opsize == TCPOLEN_MD5SIG)
+				*md5ptr = ptr;
+			if (opcode == TCPOPT_AUTHOPT)
+				*aoptr = ptr - 2;
 		}
 		ptr += opsize - 2;
 		length -= opsize;
 	}
-	return NULL;
+
+out:
+	/* RFC5925 2.2: An endpoint MUST NOT use TCP-AO for the same connection
+	 * in which TCP MD5 is used. When both options appear, TCP MUST silently
+	 * discard the segment.
+	 */
+	if (*md5ptr && *aoptr)
+		return -EINVAL;
+
+	return 0;
 }
-EXPORT_SYMBOL(tcp_parse_md5sig_option);
+EXPORT_SYMBOL(tcp_parse_sig_options);
 #endif
 
 /* Sorry, PAWS as specified is broken wrt. pure-ACKs -DaveM
  *
  * It is not fatal. If this ACK does _not_ change critical state (seqs, window)
@@ -5992,10 +6010,12 @@ void tcp_finish_connect(struct sock *sk, struct sk_buff *skb)
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
index 442c28e1c72a..5a7fe973bc4e 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1405,22 +1405,20 @@ EXPORT_SYMBOL(tcp_v4_md5_hash_skb);
 #endif
 
 /* Called with rcu_read_lock() */
 static bool tcp_v4_inbound_md5_hash(const struct sock *sk,
 				    const struct sk_buff *skb,
-				    int dif, int sdif)
+				    int dif, int sdif,
+				    const u8 *hash_location)
 {
 #ifdef CONFIG_TCP_MD5SIG
 	/*
-	 * This gets called for each TCP segment that arrives
-	 * so we want to be efficient.
 	 * We have 3 drop cases:
 	 * o No MD5 hash and one expected.
 	 * o MD5 hash and we're not expecting one.
 	 * o MD5 hash and its wrong.
 	 */
-	const __u8 *hash_location = NULL;
 	struct tcp_md5sig_key *hash_expected;
 	const struct iphdr *iph = ip_hdr(skb);
 	const struct tcphdr *th = tcp_hdr(skb);
 	const union tcp_md5_addr *addr;
 	unsigned char newhash[16];
@@ -1431,11 +1429,10 @@ static bool tcp_v4_inbound_md5_hash(const struct sock *sk,
 	 */
 	l3index = sdif ? dif : 0;
 
 	addr = (union tcp_md5_addr *)&iph->saddr;
 	hash_expected = tcp_md5_do_lookup(sk, l3index, addr, AF_INET);
-	hash_location = tcp_parse_md5sig_option(th);
 
 	/* We've parsed the options - do we have a hash? */
 	if (!hash_expected && !hash_location)
 		return false;
 
@@ -1957,10 +1954,49 @@ static void tcp_v4_fill_cb(struct sk_buff *skb, const struct iphdr *iph,
 	TCP_SKB_CB(skb)->sacked	 = 0;
 	TCP_SKB_CB(skb)->has_rxtstamp =
 			skb->tstamp || skb_hwtstamps(skb)->hwtstamp;
 }
 
+static int tcp_v4_sig_check(struct sock *sk,
+			    struct sk_buff *skb,
+			    int dif,
+			    int sdif)
+{
+	const u8 *md5, *ao;
+	int ret;
+
+	ret = tcp_parse_sig_options(tcp_hdr(skb), &md5, &ao);
+	if (ret)
+		return ret;
+	ret = tcp_authopt_inbound_check(sk, skb, ao);
+	if (ret < 0)
+		return ret;
+	if (ret == 1)
+		return 0;
+	return tcp_v4_inbound_md5_hash(sk, skb, dif, sdif, md5);
+}
+
+static int tcp_v4_sig_check_req(struct request_sock *req,
+				struct sk_buff *skb,
+				int dif,
+				int sdif)
+{
+	struct sock *lsk = req->rsk_listener;
+	const u8 *md5, *ao;
+	int ret;
+
+	ret = tcp_parse_sig_options(tcp_hdr(skb), &md5, &ao);
+	if (ret)
+		return ret;
+	ret = tcp_authopt_inbound_check_req(req, skb, ao);
+	if (ret < 0)
+		return ret;
+	if (ret == 1)
+		return 0;
+	return tcp_v4_inbound_md5_hash(lsk, skb, dif, sdif, md5);
+}
+
 /*
  *	From tcp_input.c
  */
 
 int tcp_v4_rcv(struct sk_buff *skb)
@@ -2018,11 +2054,11 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		struct request_sock *req = inet_reqsk(sk);
 		bool req_stolen = false;
 		struct sock *nsk;
 
 		sk = req->rsk_listener;
-		if (unlikely(tcp_v4_inbound_md5_hash(sk, skb, dif, sdif))) {
+		if (unlikely(tcp_v4_sig_check_req(req, skb, dif, sdif))) {
 			sk_drops_add(sk, skb);
 			reqsk_put(req);
 			goto discard_it;
 		}
 		if (tcp_checksum_complete(skb)) {
@@ -2088,11 +2124,11 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	}
 
 	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto discard_and_relse;
 
-	if (tcp_v4_inbound_md5_hash(sk, skb, dif, sdif))
+	if (tcp_v4_sig_check(sk, skb, dif, sdif))
 		goto discard_and_relse;
 
 	nf_reset_ct(skb);
 
 	if (tcp_filter(sk, skb)) {
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 7c2d3ac2363a..61b8fa671a8f 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -18,10 +18,11 @@
  *		Arnt Gulbrandsen, <agulbra@nvg.unit.no>
  *		Jorge Cwik, <jorge@laser.satlink.net>
  */
 
 #include <net/tcp.h>
+#include <net/tcp_authopt.h>
 #include <net/xfrm.h>
 #include <net/busy_poll.h>
 
 static bool tcp_in_window(u32 seq, u32 end_seq, u32 s_win, u32 e_win)
 {
@@ -300,10 +301,11 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
 					BUG_ON(tcptw->tw_md5_key && !tcp_alloc_md5sig_pool());
 				}
 			}
 		} while (0);
 #endif
+		tcp_authopt_time_wait(tcptw, tcp_sk(sk));
 
 		/* Get the TIME_WAIT timeout firing. */
 		if (timeo < rto)
 			timeo = rto;
 
@@ -342,10 +344,19 @@ void tcp_twsk_destructor(struct sock *sk)
 
 		if (twsk->tw_md5_key)
 			kfree_rcu(twsk->tw_md5_key, rcu);
 	}
 #endif
+#ifdef CONFIG_TCP_AUTHOPT
+	if (tcp_authopt_needed) {
+		struct tcp_timewait_sock *twsk = tcp_twsk(sk);
+
+		/* twsk only contains sock_common so pass NULL as sk. */
+		if (twsk->tw_authopt_info)
+			tcp_authopt_free(NULL, twsk->tw_authopt_info);
+	}
+#endif
 }
 EXPORT_SYMBOL_GPL(tcp_twsk_destructor);
 
 /* Warning : This function is called without sk_listener being locked.
  * Be sure to read socket fields once, as their value could change under us.
@@ -532,10 +543,11 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
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
index 5079832af5c1..b959e8b949b6 100644
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
@@ -410,10 +411,11 @@ static inline bool tcp_urg_mode(const struct tcp_sock *tp)
 
 #define OPTION_SACK_ADVERTISE	BIT(0)
 #define OPTION_TS		BIT(1)
 #define OPTION_MD5		BIT(2)
 #define OPTION_WSCALE		BIT(3)
+#define OPTION_AUTHOPT		BIT(4)
 #define OPTION_FAST_OPEN_COOKIE	BIT(8)
 #define OPTION_SMC		BIT(9)
 #define OPTION_MPTCP		BIT(10)
 
 static void smc_options_write(__be32 *ptr, u16 *options)
@@ -434,16 +436,22 @@ static void smc_options_write(__be32 *ptr, u16 *options)
 struct tcp_out_options {
 	u16 options;		/* bit field of OPTION_* */
 	u16 mss;		/* 0 to disable */
 	u8 ws;			/* window scale, 0 to disable */
 	u8 num_sack_blocks;	/* number of SACK blocks to include */
-	u8 hash_size;		/* bytes in hash_location */
 	u8 bpf_opt_len;		/* length of BPF hdr option */
+#ifdef CONFIG_TCP_AUTHOPT
+	u8 authopt_rnextkeyid;	/* rnextkey */
+#endif
 	__u8 *hash_location;	/* temporary pointer, overloaded */
 	__u32 tsval, tsecr;	/* need to include OPTION_TS */
 	struct tcp_fastopen_cookie *fastopen_cookie;	/* Fast open cookie */
 	struct mptcp_out_options mptcp;
+#ifdef CONFIG_TCP_AUTHOPT
+	struct tcp_authopt_info *authopt_info;
+	struct tcp_authopt_key_info *authopt_key;
+#endif
 };
 
 static void mptcp_options_write(__be32 *ptr, const struct tcp_sock *tp,
 				struct tcp_out_options *opts)
 {
@@ -616,10 +624,25 @@ static void tcp_options_write(__be32 *ptr, struct tcp_sock *tp,
 		/* overload cookie hash location */
 		opts->hash_location = (__u8 *)ptr;
 		ptr += 4;
 	}
 
+#ifdef CONFIG_TCP_AUTHOPT
+	if (unlikely(OPTION_AUTHOPT & options)) {
+		struct tcp_authopt_key_info *key = opts->authopt_key;
+
+		WARN_ON(!key);
+		*ptr = htonl((TCPOPT_AUTHOPT << 24) |
+			     (TCPOLEN_AUTHOPT_OUTPUT << 16) |
+			     (key->send_id << 8) |
+			     opts->authopt_rnextkeyid);
+		/* overload cookie hash location */
+		opts->hash_location = (__u8 *)(ptr + 1);
+		ptr += TCPOLEN_AUTHOPT_OUTPUT / 4;
+	}
+#endif
+
 	if (unlikely(opts->mss)) {
 		*ptr++ = htonl((TCPOPT_MSS << 24) |
 			       (TCPOLEN_MSS << 16) |
 			       opts->mss);
 	}
@@ -751,10 +774,28 @@ static void mptcp_set_option_cond(const struct request_sock *req,
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
+	key = tcp_authopt_select_key(sk, addr_sk, &opts->authopt_info, &opts->authopt_rnextkeyid);
+	if (key) {
+		opts->options |= OPTION_AUTHOPT;
+		opts->authopt_key = key;
+		return TCPOLEN_AUTHOPT_OUTPUT;
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
@@ -763,12 +804,15 @@ static unsigned int tcp_syn_options(struct sock *sk, struct sk_buff *skb,
 	struct tcp_sock *tp = tcp_sk(sk);
 	unsigned int remaining = MAX_TCP_OPTION_SPACE;
 	struct tcp_fastopen_request *fastopen = tp->fastopen_req;
 
 	*md5 = NULL;
+
+	remaining -= tcp_authopt_init_options(sk, sk, opts);
 #ifdef CONFIG_TCP_MD5SIG
 	if (static_branch_unlikely(&tcp_md5_needed) &&
+	    !(opts->options & OPTION_AUTHOPT) &&
 	    rcu_access_pointer(tp->md5sig_info)) {
 		*md5 = tp->af_specific->md5_lookup(sk, sk);
 		if (*md5) {
 			opts->options |= OPTION_MD5;
 			remaining -= TCPOLEN_MD5SIG_ALIGNED;
@@ -847,12 +891,13 @@ static unsigned int tcp_synack_options(const struct sock *sk,
 				       struct sk_buff *syn_skb)
 {
 	struct inet_request_sock *ireq = inet_rsk(req);
 	unsigned int remaining = MAX_TCP_OPTION_SPACE;
 
+	remaining -= tcp_authopt_init_options(sk, req_to_sk(req), opts);
 #ifdef CONFIG_TCP_MD5SIG
-	if (md5) {
+	if (md5 && !(opts->options & OPTION_AUTHOPT)) {
 		opts->options |= OPTION_MD5;
 		remaining -= TCPOLEN_MD5SIG_ALIGNED;
 
 		/* We can't fit any SACK blocks in a packet with MD5 + TS
 		 * options. There was discussion about disabling SACK
@@ -918,13 +963,15 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
 	unsigned int size = 0;
 	unsigned int eff_sacks;
 
 	opts->options = 0;
 
+	size += tcp_authopt_init_options(sk, sk, opts);
 	*md5 = NULL;
 #ifdef CONFIG_TCP_MD5SIG
 	if (static_branch_unlikely(&tcp_md5_needed) &&
+	    !(opts->options & OPTION_AUTHOPT) &&
 	    rcu_access_pointer(tp->md5sig_info)) {
 		*md5 = tp->af_specific->md5_lookup(sk, sk);
 		if (*md5) {
 			opts->options |= OPTION_MD5;
 			size += TCPOLEN_MD5SIG_ALIGNED;
@@ -1274,10 +1321,14 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 
 	inet = inet_sk(sk);
 	tcb = TCP_SKB_CB(skb);
 	memset(&opts, 0, sizeof(opts));
 
+#ifdef CONFIG_TCP_AUTHOPT
+	/* for tcp_authopt_init_options inside tcp_syn_options or tcp_established_options */
+	rcu_read_lock();
+#endif
 	if (unlikely(tcb->tcp_flags & TCPHDR_SYN)) {
 		tcp_options_size = tcp_syn_options(sk, skb, &opts, &md5);
 	} else {
 		tcp_options_size = tcp_established_options(sk, skb, &opts,
 							   &md5);
@@ -1362,10 +1413,17 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 		sk_gso_disable(sk);
 		tp->af_specific->calc_md5_hash(opts.hash_location,
 					       md5, sk, skb);
 	}
 #endif
+#ifdef CONFIG_TCP_AUTHOPT
+	if (opts.authopt_key) {
+		sk_gso_disable(sk);
+		tcp_authopt_hash(opts.hash_location, opts.authopt_key, opts.authopt_info, sk, skb);
+	}
+	rcu_read_unlock();
+#endif
 
 	/* BPF prog is the last one writing header option */
 	bpf_skops_write_hdr_opt(sk, skb, NULL, NULL, 0, &opts);
 
 	INDIRECT_CALL_INET(icsk->icsk_af_ops->send_check,
@@ -1831,12 +1889,21 @@ unsigned int tcp_current_mss(struct sock *sk)
 		u32 mtu = dst_mtu(dst);
 		if (mtu != inet_csk(sk)->icsk_pmtu_cookie)
 			mss_now = tcp_sync_mss(sk, mtu);
 	}
 
+#ifdef CONFIG_TCP_AUTHOPT
+	/* Even if the result is not used rcu_read_lock is required when scanning for
+	 * tcp authentication keys. Otherwise lockdep will complain.
+	 */
+	rcu_read_lock();
+#endif
 	header_len = tcp_established_options(sk, NULL, &opts, &md5) +
 		     sizeof(struct tcphdr);
+#ifdef CONFIG_TCP_AUTHOPT
+	rcu_read_unlock();
+#endif
 	/* The mss_cache is sized based on tp->tcp_header_len, which assumes
 	 * some common options. If this is an odd packet (because we have SACK
 	 * blocks etc) then our calculated header_len will be different, and
 	 * we have to adjust mss_now correspondingly */
 	if (header_len != tp->tcp_header_len) {
@@ -3551,10 +3618,14 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	}
 
 #ifdef CONFIG_TCP_MD5SIG
 	rcu_read_lock();
 	md5 = tcp_rsk(req)->af_specific->req_md5_lookup(sk, req_to_sk(req));
+#endif
+#ifdef CONFIG_TCP_AUTHOPT
+	/* for tcp_authopt_init_options inside tcp_synack_options */
+	rcu_read_lock();
 #endif
 	skb_set_hash(skb, tcp_rsk(req)->txhash, PKT_HASH_TYPE_L4);
 	/* bpf program will be interested in the tcp_flags */
 	TCP_SKB_CB(skb)->tcp_flags = TCPHDR_SYN | TCPHDR_ACK;
 	tcp_header_size = tcp_synack_options(sk, req, mss, skb, &opts, md5,
@@ -3588,10 +3659,20 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	if (md5)
 		tcp_rsk(req)->af_specific->calc_md5_hash(opts.hash_location,
 					       md5, req_to_sk(req), skb);
 	rcu_read_unlock();
 #endif
+#ifdef CONFIG_TCP_AUTHOPT
+	/* If signature fails we do nothing */
+	if (opts.authopt_key)
+		tcp_authopt_hash(opts.hash_location,
+				 opts.authopt_key,
+				 opts.authopt_info,
+				 req_to_sk(req),
+				 skb);
+	rcu_read_unlock();
+#endif
 
 	bpf_skops_write_hdr_opt((struct sock *)sk, skb, req, syn_skb,
 				synack_type, &opts);
 
 	skb->skb_mstamp_ns = now;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 7aed4cdfcd65..01c1c065decc 100644
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
@@ -772,14 +773,14 @@ static int tcp_v6_md5_hash_skb(char *md5_hash,
 
 #endif
 
 static bool tcp_v6_inbound_md5_hash(const struct sock *sk,
 				    const struct sk_buff *skb,
-				    int dif, int sdif)
+				    int dif, int sdif,
+				    const u8 *hash_location)
 {
 #ifdef CONFIG_TCP_MD5SIG
-	const __u8 *hash_location = NULL;
 	struct tcp_md5sig_key *hash_expected;
 	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
 	const struct tcphdr *th = tcp_hdr(skb);
 	int genhash, l3index;
 	u8 newhash[16];
@@ -788,11 +789,10 @@ static bool tcp_v6_inbound_md5_hash(const struct sock *sk,
 	 * in an L3 domain and dif is set to the l3mdev
 	 */
 	l3index = sdif ? dif : 0;
 
 	hash_expected = tcp_v6_md5_do_lookup(sk, &ip6h->saddr, l3index);
-	hash_location = tcp_parse_md5sig_option(th);
 
 	/* We've parsed the options - do we have a hash? */
 	if (!hash_expected && !hash_location)
 		return false;
 
@@ -1622,10 +1622,49 @@ static void tcp_v6_fill_cb(struct sk_buff *skb, const struct ipv6hdr *hdr,
 	TCP_SKB_CB(skb)->sacked = 0;
 	TCP_SKB_CB(skb)->has_rxtstamp =
 			skb->tstamp || skb_hwtstamps(skb)->hwtstamp;
 }
 
+static int tcp_v6_sig_check(struct sock *sk,
+			    struct sk_buff *skb,
+			    int dif,
+			    int sdif)
+{
+	const u8 *md5, *ao;
+	int ret;
+
+	ret = tcp_parse_sig_options(tcp_hdr(skb), &md5, &ao);
+	if (ret)
+		return ret;
+	ret = tcp_authopt_inbound_check(sk, skb, ao);
+	if (ret < 0)
+		return ret;
+	if (ret == 1)
+		return 0;
+	return tcp_v6_inbound_md5_hash(sk, skb, dif, sdif, md5);
+}
+
+static int tcp_v6_sig_check_req(struct request_sock *req,
+				struct sk_buff *skb,
+				int dif,
+				int sdif)
+{
+	struct sock *lsk = req->rsk_listener;
+	const u8 *md5, *ao;
+	int ret;
+
+	ret = tcp_parse_sig_options(tcp_hdr(skb), &md5, &ao);
+	if (ret)
+		return ret;
+	ret = tcp_authopt_inbound_check_req(req, skb, ao);
+	if (ret < 0)
+		return ret;
+	if (ret == 1)
+		return 0;
+	return tcp_v6_inbound_md5_hash(lsk, skb, dif, sdif, md5);
+}
+
 INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 {
 	int sdif = inet6_sdif(skb);
 	int dif = inet6_iif(skb);
 	const struct tcphdr *th;
@@ -1674,11 +1713,11 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		struct request_sock *req = inet_reqsk(sk);
 		bool req_stolen = false;
 		struct sock *nsk;
 
 		sk = req->rsk_listener;
-		if (tcp_v6_inbound_md5_hash(sk, skb, dif, sdif)) {
+		if (tcp_v6_sig_check_req(req, skb, dif, sdif)) {
 			sk_drops_add(sk, skb);
 			reqsk_put(req);
 			goto discard_it;
 		}
 		if (tcp_checksum_complete(skb)) {
@@ -1741,11 +1780,11 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	}
 
 	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto discard_and_relse;
 
-	if (tcp_v6_inbound_md5_hash(sk, skb, dif, sdif))
+	if (tcp_v6_sig_check(sk, skb, dif, sdif))
 		goto discard_and_relse;
 
 	if (tcp_filter(sk, skb))
 		goto discard_and_relse;
 	th = (const struct tcphdr *)skb->data;
-- 
2.25.1

