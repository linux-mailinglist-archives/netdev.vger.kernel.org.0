Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB893598D2E
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 22:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345639AbiHRUBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 16:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345461AbiHRUAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 16:00:33 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5B4D11C6;
        Thu, 18 Aug 2022 13:00:31 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id e13so3176703edj.12;
        Thu, 18 Aug 2022 13:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=B/yvhkBlQiQaCKlOYzxugiD4Iqjih1lP4Hm6HqQkNXU=;
        b=NzWxXx6SLLk5mbU9bFD1kJSt+N8hCjApDn/9uO4en2O7NxNlOcV67eh1cQfyL6ZziD
         sWJdf8uLt5WrAohYnjldE7YM8PWs387PS5OJGAw4cL7axYjLQBf5akHt8PhNK6XYdcRE
         ixUaCRzbsUtdpRvjU1zdgcacSTR39RIsIPRj1HsW6mch5G4UEEby5DUruBBu9x7DJYzx
         1kRSTa9NQvxJdeRI/JpBlQqEvvL8LAhyANob6nz/J1OdwO+2c4GTcQi2Ambw2lLHZew/
         9EnNdSbc3PgKDXhL7qLJvbgDJsLMdDzXpeFYtLdNnTuVWhTmPAF6EDJP2Vb/Lr5wdVXB
         AxvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=B/yvhkBlQiQaCKlOYzxugiD4Iqjih1lP4Hm6HqQkNXU=;
        b=HcYI6pavt/DgqN2AvJNr09IFOJdQZ/4iMm9VSOeQ6X2QJEpoZK7e8L7sukBzI5aCwS
         CZ+NDmEzlKlRglhL8es0wbqYnC8t/HIGVz9Qf0NFmN+6EyCeihRwBVjJP9XWuOkGZlCC
         ohXMuPtJE+TtNvUy9W3Vxpds1Yc7cOZMOxuyGapbgVx4YoLOHTU+lKW4vjhXpZwOCjym
         QzGUIpo+wnLddmlcCdOOr9Rav/W2mBCrgo1KiXHwZ0CroBNOR0O2mMsiFt+j8YPiAx7G
         AeL0ol4stq88M14nYtmbziYcCSv1kvfo3Ie1TQKEbxJJfu+yqwEG17N2rU2ow1ooclIE
         6QFQ==
X-Gm-Message-State: ACgBeo2rz1beuRB4P5pmXwFIRPjMG0g4euErJM/Pz4GxszvxC4FQk4Zx
        EIC/TXt58jCL15miaF3TUAE=
X-Google-Smtp-Source: AA6agR6SWBYjDs550dy2guEyjPUKHnfN6km/sXCG+0UGIm0FLQCvQkXEU3SUd1o/9LL9+Lf9Uw6Zig==
X-Received: by 2002:a05:6402:e98:b0:441:a982:45bc with SMTP id h24-20020a0564020e9800b00441a98245bcmr3361207eda.239.1660852829685;
        Thu, 18 Aug 2022 13:00:29 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:17c8:ba1c:b6f3:3fe0])
        by smtp.gmail.com with ESMTPSA id fw30-20020a170907501e00b00722e4bab163sm1215087ejc.200.2022.08.18.13.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 13:00:29 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
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
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 07/26] tcp: authopt: Hook into tcp core
Date:   Thu, 18 Aug 2022 22:59:41 +0300
Message-Id: <887a4cd26bbf7dd792def034cf6d8b40fd11c43d.1660852705.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1660852705.git.cdleonard@gmail.com>
References: <cover.1660852705.git.cdleonard@gmail.com>
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

The tcp_authopt features exposes a minimal interface to the rest of the
TCP stack. Only a few functions are exposed and if the feature is
disabled they return neutral values, avoiding ifdefs in the rest of the
code. This approach is different from MD5.

Add calls into tcp authopt from send, receive, accept, close code.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/net/dropreason.h  |  12 ++
 include/net/tcp_authopt.h |  85 +++++++++++
 include/uapi/linux/snmp.h |   1 +
 net/ipv4/proc.c           |   1 +
 net/ipv4/tcp.c            |  17 +++
 net/ipv4/tcp_authopt.c    | 302 +++++++++++++++++++++++++++++++++++++-
 net/ipv4/tcp_input.c      |   3 +
 net/ipv4/tcp_minisocks.c  |  12 ++
 net/ipv4/tcp_output.c     |  85 ++++++++++-
 9 files changed, 515 insertions(+), 3 deletions(-)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index c5397c24296c..d5dd92affde8 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -233,10 +233,22 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_PKT_TOO_BIG,
 	/**
 	 * @SKB_DROP_REASON_TCP_BOTHAOMD5: Both AO and MD5 found in packet.
 	 */
 	SKB_DROP_REASON_TCP_BOTHAOMD5,
+	/**
+	 * @SKB_DROP_REASON_TCP_AONOTFOUND: No AO signature and one expected.
+	 */
+	SKB_DROP_REASON_TCP_AONOTFOUND,
+	/**
+	 * @SKB_DROP_REASON_TCP_AOUNEXPECTED: AO hash and we're not expecting
+	 */
+	SKB_DROP_REASON_TCP_AOUNEXPECTED,
+	/**
+	 * @SKB_DROP_REASON_TCP_AOFAILURE: AO hash incorrect
+	 */
+	SKB_DROP_REASON_TCP_AOFAILURE,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of drop reason, which shouldn't be
 	 * used as a real 'reason'
 	 */
 	SKB_DROP_REASON_MAX,
diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index e303ef53e1a3..7ad34a6987ec 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -80,16 +80,101 @@ struct tcphdr_authopt {
 };
 
 #ifdef CONFIG_TCP_AUTHOPT
 DECLARE_STATIC_KEY_FALSE(tcp_authopt_needed_key);
 #define tcp_authopt_needed (static_branch_unlikely(&tcp_authopt_needed_key))
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
+	if (skb && tcp_authopt_needed) {
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
+int __tcp_authopt_inbound_check(
+		struct sock *sk,
+		struct sk_buff *skb,
+		struct tcp_authopt_info *info,
+		const u8 *opt);
 #else
 static inline void tcp_authopt_clear(struct sock *sk)
 {
 }
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
 #endif
 
 #endif /* _LINUX_TCP_AUTHOPT_H */
diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index 4d7470036a8b..ae2738a7992b 100644
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
index 0088a4c64d77..e48c7245c571 100644
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
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 0611a2160b63..205534d501ec 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4664,10 +4664,27 @@ tcp_inbound_sig_hash(const struct sock *sk, const struct sk_buff *skb,
 
 	ret = tcp_parse_sig_options(tcp_hdr(skb), &md5, &ao);
 	if (ret)
 		return ret;
 
+#if defined(CONFIG_TCP_AUTHOPT)
+	if (tcp_authopt_needed) {
+		struct tcp_authopt_info *info = rcu_dereference(tcp_sk(parent_sk)->authopt_info);
+		int aoret;
+
+		if (info) {
+			aoret = __tcp_authopt_inbound_check((struct sock *)sk,
+							    (struct sk_buff *)skb,
+							    info, ao);
+			/* Don't do MD5 lookup if AO found */
+			if (aoret == 1)
+				return SKB_NOT_DROPPED_YET;
+			if (aoret < 0)
+				return -aoret;
+		}
+	}
+#endif
 #ifdef CONFIG_TCP_MD5SIG
 	return tcp_inbound_md5_hash(parent_sk, skb, saddr, daddr, family, dif, sdif, md5);
 #else
 	return SKB_NOT_DROPPED_YET;
 #endif
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 440d329b52f4..9215a8377e4d 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -268,10 +268,57 @@ static bool tcp_authopt_key_match_exact(struct tcp_authopt_key_info *info,
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
@@ -281,10 +328,63 @@ static struct tcp_authopt_key_info *tcp_authopt_key_lookup_exact(const struct so
 			return key_info;
 
 	return NULL;
 }
 
+/**
+ * tcp_authopt_lookup_send - lookup key for sending
+ *
+ * @net: Per-namespace information containing keys
+ * @addr_sk: Socket used for destination address lookup
+ * @send_id: Optional send_id. If >= 0 then only return keys that match
+ *
+ * If anykey is false then authentication is not required for peer.
+ *
+ * If anykey is true but no key was found then all our keys must be expired and sending should fail.
+ */
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
 
@@ -548,10 +648,45 @@ static int crypto_ahash_buf(struct ahash_request *req, u8 *buf, uint len)
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
@@ -880,11 +1015,10 @@ static int tcp_authopt_hash_packet(struct tcp_authopt_alg_pool *pool,
  *
  * The macbuf output buffer must be large enough to fit the digestsize of the
  * underlying transform before truncation.
  * This means TCP_AUTHOPT_MAXMACBUF, not TCP_AUTHOPT_MACLEN
  */
-__always_unused
 static int __tcp_authopt_calc_mac(struct sock *sk,
 				  struct sk_buff *skb,
 				  struct tcphdr_authopt *aoptr,
 				  struct tcp_authopt_key_info *key,
 				  struct tcp_authopt_info *info,
@@ -926,10 +1060,176 @@ static int __tcp_authopt_calc_mac(struct sock *sk,
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
+ * If anykey is false then authentication is not expected from peer.
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
+/**
+ * __tcp_authopt_inbound_check - Check inbound TCP authentication option
+ *
+ * @sk: Receive socket. For the SYN_RECV state this must be the request_sock, not the listener
+ * @skb: Input Packet
+ * @info: TCP authentication option information
+ * @_opt: Pointer to TCP authentication option inside the skb
+ *
+ * Return:
+ *  0: Nothing found or expected
+ *  1: Found and verified
+ *  <0: Error, negative skb_drop_reason
+ */
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
+		return -SKB_DROP_REASON_TCP_AONOTFOUND;
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
+			return -SKB_DROP_REASON_TCP_AOUNEXPECTED;
+		}
+		print_tcpao_notice("TCP Authentication Unexpected: Accepted", skb);
+		return 0;
+	}
+	if (opt && !key) {
+		/* Keys are configured for peer but with different keyid than packet */
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAUTHOPTFAILURE);
+		print_tcpao_notice("TCP Authentication Failed", skb);
+		return -SKB_DROP_REASON_TCP_AOFAILURE;
+	}
+
+	/* bad inbound key len */
+	if (opt->len != TCPOLEN_AUTHOPT_OUTPUT)
+		return -SKB_DROP_REASON_TCP_AOFAILURE;
+
+	err = __tcp_authopt_calc_mac(sk, skb, opt, key, info, true, macbuf);
+	if (err)
+		return -SKB_DROP_REASON_TCP_AOFAILURE;
+
+	if (memcmp(macbuf, opt->mac, TCP_AUTHOPT_MACLEN)) {
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAUTHOPTFAILURE);
+		print_tcpao_notice("TCP Authentication Failed", skb);
+		return -SKB_DROP_REASON_TCP_AOFAILURE;
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
index fa20afd15248..b0c883521b1a 100644
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
@@ -6059,10 +6060,12 @@ void tcp_finish_connect(struct sock *sk, struct sk_buff *skb)
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
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index cb95d88497ae..64357bf5ede2 100644
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
 	if (treq->af_specific->req_md5_lookup(sk, req_to_sk(req)))
 		newtp->tcp_header_len += TCPOLEN_MD5SIG_ALIGNED;
 #endif
+	tcp_authopt_openreq(newsk, sk, req);
 	if (skb->len >= TCP_MSS_DEFAULT + newtp->tcp_header_len)
 		newicsk->icsk_ack.last_seg_size = skb->len - newtp->tcp_header_len;
 	newtp->rx_opt.mss_clamp = req->mss;
 	tcp_ecn_openreq_child(newtp, req);
 	newtp->fastopen_req = NULL;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 78b654ff421b..ae69936947f3 100644
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
@@ -408,10 +409,11 @@ static inline bool tcp_urg_mode(const struct tcp_sock *tp)
 
 #define OPTION_SACK_ADVERTISE	BIT(0)
 #define OPTION_TS		BIT(1)
 #define OPTION_MD5		BIT(2)
 #define OPTION_WSCALE		BIT(3)
+#define OPTION_AUTHOPT		BIT(4)
 #define OPTION_FAST_OPEN_COOKIE	BIT(8)
 #define OPTION_SMC		BIT(9)
 #define OPTION_MPTCP		BIT(10)
 
 static void smc_options_write(__be32 *ptr, u16 *options)
@@ -432,16 +434,22 @@ static void smc_options_write(__be32 *ptr, u16 *options)
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
 
 static void mptcp_options_write(struct tcphdr *th, __be32 *ptr,
 				struct tcp_sock *tp,
 				struct tcp_out_options *opts)
@@ -616,10 +624,25 @@ static void tcp_options_write(struct tcphdr *th, struct tcp_sock *tp,
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
@@ -1832,12 +1890,21 @@ unsigned int tcp_current_mss(struct sock *sk)
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
@@ -3573,10 +3640,14 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
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
@@ -3610,10 +3681,20 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
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
 
 	skb_set_delivery_time(skb, now, true);
-- 
2.25.1

