Return-Path: <netdev+bounces-10917-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A63B3730B39
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 01:11:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA9741C20DD3
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:11:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80E90168C4;
	Wed, 14 Jun 2023 23:10:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB8D168BE
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 23:10:07 +0000 (UTC)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E844268B
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:10:03 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f8d5262dc8so1351645e9.0
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1686784201; x=1689376201;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t/M3K+7FO+AubvG1BFopojAihkytzUfMq+udZ4tJae8=;
        b=HEC2YSc/QA1sIFQgrxFtsWEuwcy5e/ZHYe4ioWJF+tG5xsuqyv65vQ7s53Y6qdmDdb
         IDrihmCjv0s3BDAx6H8dZktbdMNfNyIoXveDZwsDUd7edYUtl30LwFdXFn1I7c8NPmLs
         ObkZoIg0ACZV6uiPuTQe9geiz3H5OWEY86D9M6TaIYnXuVZ7Ggx6Ew0tcnQRHZXRzxCp
         uCGmT9kRbje5C9hcJMy4K9SCfKgBD4aNRLnUBQvQAclqtRMaa0V/udN7A/zJLeQHrFGD
         MH1F03RSdo0kzCmYYYn+/EcuW9urA2/zoxLZNosuINIMZGA5DQB5oOcLtXK4jqTsO4ds
         pQrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686784202; x=1689376202;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t/M3K+7FO+AubvG1BFopojAihkytzUfMq+udZ4tJae8=;
        b=F1EmwkT/8ZXm0m2+jnoevsLOGw7I05m0aXeAcJEmDir/QzFze6giD3ppTk1xd2Qz+p
         eHJB+5uXmsLjD9DWnjeWz5P1mzQ5jxxlIsJz8IUNEF4IJh9VbsGBk+5sBJ7DL47rVIyn
         NEVUuLINtjecztNuvFuOHVG6oe9yggM9ZJVMcNC+PCgzoS0CEt6naRAnTFNwQZtjasAb
         YSoK2vC0mCAsbQoiJVGzQYlEeShCh4mAU7aZapWp7h8SgKeo+GYNYyTpdprXSKB5XjUb
         unq7EYf4ObrGh8xdnMp2mDgDaMLZcoCLFxI2h8mID8TIZ4HBO5+VkGtW2GaFGGzGAKSB
         8Evw==
X-Gm-Message-State: AC+VfDzZ98xVBjs5jpwoPZquCW2FJQl0Rfhii+e/pAnSVS+ozNrXftAi
	x6y+Ln4YmOBPG5euZOMpLCcd+w==
X-Google-Smtp-Source: ACHHUZ7xdeVdmjh5WFfxxqfx4xjixkKXsrQ+42z8b+IEk46KIr96aGHIhaLAxrh2H4jhaXzE1ycanQ==
X-Received: by 2002:a05:600c:19cb:b0:3f7:e559:ddf5 with SMTP id u11-20020a05600c19cb00b003f7e559ddf5mr2466712wmq.17.1686784201597;
        Wed, 14 Jun 2023 16:10:01 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id s12-20020a7bc38c000000b003f7ba52eeccsm18725261wmj.7.2023.06.14.16.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 16:10:01 -0700 (PDT)
From: Dmitry Safonov <dima@arista.com>
To: David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org,
	Dmitry Safonov <dima@arista.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Bob Gilligan <gilligan@arista.com>,
	Dan Carpenter <error27@gmail.com>,
	David Laight <David.Laight@aculab.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Donald Cassidy <dcassidy@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Francesco Ruggeri <fruggeri05@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Ivan Delalande <colona@arista.com>,
	Leonard Crestez <cdleonard@gmail.com>,
	Salam Noureddine <noureddine@arista.com>,
	netdev@vger.kernel.org
Subject: [PATCH v7 04/22] net/tcp: Prevent TCP-MD5 with TCP-AO being set
Date: Thu, 15 Jun 2023 00:09:29 +0100
Message-Id: <20230614230947.3954084-5-dima@arista.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230614230947.3954084-1-dima@arista.com>
References: <20230614230947.3954084-1-dima@arista.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Be as conservative as possible: if there is TCP-MD5 key for a given peer
regardless of L3 interface - don't allow setting TCP-AO key for the same
peer. According to RFC5925, TCP-AO is supposed to replace TCP-MD5 and
there can't be any switch between both on any connected tuple.
Later it can be relaxed, if there's a use, but in the beginning restrict
any intersection.

Note: it's still should be possible to set both TCP-MD5 and TCP-AO keys
on a listening socket for *different* peers.

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp.h     | 43 +++++++++++++++++++++++++++++++++++++--
 include/net/tcp_ao.h  | 15 ++++++++++++++
 net/ipv4/tcp_ao.c     | 40 ++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_ipv4.c   | 14 ++++++++++---
 net/ipv4/tcp_output.c | 47 +++++++++++++++++++++++++++++++++++++++++++
 net/ipv6/tcp_ao.c     | 18 +++++++++++++++++
 net/ipv6/tcp_ipv6.c   | 26 ++++++++++++++++++++----
 7 files changed, 194 insertions(+), 9 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 511514e59772..219604c8ae6e 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1707,6 +1707,7 @@ int tcp_md5_key_copy(struct sock *sk, const union tcp_md5_addr *addr,
 
 int tcp_md5_do_del(struct sock *sk, const union tcp_md5_addr *addr,
 		   int family, u8 prefixlen, int l3index, u8 flags);
+void tcp_clear_md5_list(struct sock *sk);
 struct tcp_md5sig_key *tcp_v4_md5_lookup(const struct sock *sk,
 					 const struct sock *addr_sk);
 
@@ -1715,14 +1716,23 @@ struct tcp_md5sig_key *tcp_v4_md5_lookup(const struct sock *sk,
 extern struct static_key_false_deferred tcp_md5_needed;
 struct tcp_md5sig_key *__tcp_md5_do_lookup(const struct sock *sk, int l3index,
 					   const union tcp_md5_addr *addr,
-					   int family);
+					   int family, bool any_l3index);
 static inline struct tcp_md5sig_key *
 tcp_md5_do_lookup(const struct sock *sk, int l3index,
 		  const union tcp_md5_addr *addr, int family)
 {
 	if (!static_branch_unlikely(&tcp_md5_needed.key))
 		return NULL;
-	return __tcp_md5_do_lookup(sk, l3index, addr, family);
+	return __tcp_md5_do_lookup(sk, l3index, addr, family, false);
+}
+
+static inline struct tcp_md5sig_key *
+tcp_md5_do_lookup_any_l3index(const struct sock *sk,
+			      const union tcp_md5_addr *addr, int family)
+{
+	if (!static_branch_unlikely(&tcp_md5_needed.key))
+		return NULL;
+	return __tcp_md5_do_lookup(sk, 0, addr, family, true);
 }
 
 enum skb_drop_reason
@@ -1740,6 +1750,13 @@ tcp_md5_do_lookup(const struct sock *sk, int l3index,
 	return NULL;
 }
 
+static inline struct tcp_md5sig_key *
+tcp_md5_do_lookup_any_l3index(const struct sock *sk,
+			      const union tcp_md5_addr *addr, int family)
+{
+	return NULL;
+}
+
 static inline enum skb_drop_reason
 tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 		     const void *saddr, const void *daddr,
@@ -2101,6 +2118,9 @@ struct tcp_sock_af_ops {
 					    int optname,
 					    sockptr_t optval,
 					    int optlen);
+	struct tcp_ao_key	*(*ao_lookup)(const struct sock *sk,
+					      struct sock  *addr_sk,
+					      int sndid, int rcvid);
 #endif
 };
 
@@ -2513,4 +2533,23 @@ static inline u64 tcp_transmit_time(const struct sock *sk)
 	return 0;
 }
 
+static inline bool tcp_ao_required(struct sock *sk, const void *saddr,
+				   int family)
+{
+#ifdef CONFIG_TCP_AO
+	struct tcp_ao_info *ao_info;
+	struct tcp_ao_key *ao_key;
+
+	ao_info = rcu_dereference_check(tcp_sk(sk)->ao_info,
+					lockdep_sock_is_held(sk));
+	if (!ao_info)
+		return false;
+
+	ao_key = tcp_ao_do_lookup(sk, saddr, family, -1, -1, 0);
+	if (ao_info->ao_required || ao_key)
+		return true;
+#endif
+	return false;
+}
+
 #endif	/* _TCP_H */
diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index 916df79450e0..73f584b499f6 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -98,12 +98,27 @@ struct tcp_ao_info {
 int tcp_parse_ao(struct sock *sk, int cmd, unsigned short int family,
 		 sockptr_t optval, int optlen);
 void tcp_ao_destroy_sock(struct sock *sk);
+struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
+				    const union tcp_ao_addr *addr,
+				    int family, int sndid, int rcvid, u16 port);
 /* ipv4 specific functions */
 int tcp_v4_parse_ao(struct sock *sk, int optname, sockptr_t optval, int optlen);
+struct tcp_ao_key *tcp_v4_ao_lookup(const struct sock *sk, struct sock *addr_sk,
+				    int sndid, int rcvid);
 /* ipv6 specific functions */
+struct tcp_ao_key *tcp_v6_ao_lookup(const struct sock *sk,
+				    struct sock *addr_sk,
+				    int sndid, int rcvid);
 int tcp_v6_parse_ao(struct sock *sk, int cmd,
 		    sockptr_t optval, int optlen);
 #else
+static inline struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
+		const union tcp_ao_addr *addr,
+		int family, int sndid, int rcvid, u16 port)
+{
+	return NULL;
+}
+
 static inline void tcp_ao_destroy_sock(struct sock *sk)
 {
 }
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index 356747d064e8..b4d0b9f9e10a 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -172,6 +172,14 @@ void tcp_ao_destroy_sock(struct sock *sk)
 	kfree_rcu(ao, rcu);
 }
 
+struct tcp_ao_key *tcp_v4_ao_lookup(const struct sock *sk, struct sock *addr_sk,
+				    int sndid, int rcvid)
+{
+	union tcp_ao_addr *addr = (union tcp_ao_addr *)&addr_sk->sk_daddr;
+
+	return tcp_ao_do_lookup(sk, addr, AF_INET, sndid, rcvid, 0);
+}
+
 static bool tcp_ao_can_set_current_rnext(struct sock *sk)
 {
 	/* There aren't current/rnext keys on TCP_LISTEN sockets */
@@ -486,6 +494,10 @@ static int tcp_ao_add_cmd(struct sock *sk, unsigned short int family,
 			return -EINVAL;
 	}
 
+	/* Don't allow keys for peers that have a matching TCP-MD5 key */
+	if (tcp_md5_do_lookup_any_l3index(sk, addr, family))
+		return -EKEYREJECTED;
+
 	ao_info = setsockopt_ao_info(sk);
 	if (IS_ERR(ao_info))
 		return PTR_ERR(ao_info);
@@ -690,6 +702,31 @@ static int tcp_ao_del_cmd(struct sock *sk, unsigned short int family,
 	return -ENOENT;
 }
 
+/* cmd.ao_required makes a socket TCP-AO only.
+ * Don't allow any md5 keys for any l3intf on the socket together with it.
+ * Restricting it early in setsockopt() removes a check for
+ * ao_info->ao_required on inbound tcp segment fast-path.
+ */
+static inline int tcp_ao_required_verify(struct sock *sk)
+{
+#ifdef CONFIG_TCP_MD5SIG
+	const struct tcp_md5sig_info *md5sig;
+
+	if (!static_branch_unlikely(&tcp_md5_needed.key))
+		return 0;
+
+	md5sig = rcu_dereference_check(tcp_sk(sk)->md5sig_info,
+				       lockdep_sock_is_held(sk));
+	if (!md5sig)
+		return 0;
+
+	if (rcu_dereference_check(hlist_first_rcu(&md5sig->head),
+				  lockdep_sock_is_held(sk)))
+		return 1;
+#endif
+	return 0;
+}
+
 static int tcp_ao_info_cmd(struct sock *sk, unsigned short int family,
 			   sockptr_t optval, int optlen)
 {
@@ -724,6 +761,9 @@ static int tcp_ao_info_cmd(struct sock *sk, unsigned short int family,
 		first = true;
 	}
 
+	if (cmd.ao_required && tcp_ao_required_verify(sk))
+		return -EKEYREJECTED;
+
 	/* For sockets in TCP_CLOSED it's possible set keys that aren't
 	 * matching the future peer (address/port/VRF/etc),
 	 * tcp_ao_connect_init() will choose a correct matching MKT
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 6248af483b67..b06b286f9ec2 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1074,7 +1074,7 @@ static bool better_md5_match(struct tcp_md5sig_key *old, struct tcp_md5sig_key *
 /* Find the Key structure for an address.  */
 struct tcp_md5sig_key *__tcp_md5_do_lookup(const struct sock *sk, int l3index,
 					   const union tcp_md5_addr *addr,
-					   int family)
+					   int family, bool any_l3index)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_md5sig_key *key;
@@ -1093,7 +1093,8 @@ struct tcp_md5sig_key *__tcp_md5_do_lookup(const struct sock *sk, int l3index,
 				 lockdep_sock_is_held(sk)) {
 		if (key->family != family)
 			continue;
-		if (key->flags & TCP_MD5SIG_FLAG_IFINDEX && key->l3index != l3index)
+		if (!any_l3index && key->flags & TCP_MD5SIG_FLAG_IFINDEX &&
+		    key->l3index != l3index)
 			continue;
 		if (family == AF_INET) {
 			mask = inet_make_mask(key->prefixlen);
@@ -1305,7 +1306,7 @@ int tcp_md5_do_del(struct sock *sk, const union tcp_md5_addr *addr, int family,
 }
 EXPORT_SYMBOL(tcp_md5_do_del);
 
-static void tcp_clear_md5_list(struct sock *sk)
+void tcp_clear_md5_list(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_md5sig_key *key;
@@ -1375,6 +1376,12 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
 	if (cmd.tcpm_keylen > TCP_MD5SIG_MAXKEYLEN)
 		return -EINVAL;
 
+	/* Don't allow keys for peers that have a matching TCP-AO key.
+	 * See the comment in tcp_ao_add_cmd()
+	 */
+	if (tcp_ao_required(sk, addr, AF_INET))
+		return -EKEYREJECTED;
+
 	return tcp_md5_do_add(sk, addr, AF_INET, prefixlen, l3index, flags,
 			      cmd.tcpm_key, cmd.tcpm_keylen);
 }
@@ -2270,6 +2277,7 @@ static const struct tcp_sock_af_ops tcp_sock_ipv4_specific = {
 	.md5_parse		= tcp_v4_parse_md5_keys,
 #endif
 #ifdef CONFIG_TCP_AO
+	.ao_lookup		= tcp_v4_ao_lookup,
 	.ao_parse		= tcp_v4_parse_ao,
 #endif
 };
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index cfe128b81a01..324b241e95bc 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3839,6 +3839,53 @@ int tcp_connect(struct sock *sk)
 
 	tcp_call_bpf(sk, BPF_SOCK_OPS_TCP_CONNECT_CB, 0, NULL);
 
+#if defined(CONFIG_TCP_MD5SIG) && defined(CONFIG_TCP_AO)
+	/* Has to be checked late, after setting daddr/saddr/ops.
+	 * Return error if the peer has both a md5 and a tcp-ao key
+	 * configured as this is ambiguous.
+	 */
+	if (unlikely(rcu_dereference_protected(tp->md5sig_info,
+					       lockdep_sock_is_held(sk)))) {
+		bool needs_md5 = !!tp->af_specific->md5_lookup(sk, sk);
+		bool needs_ao = !!tp->af_specific->ao_lookup(sk, sk, -1, -1);
+		struct tcp_ao_info *ao_info;
+
+		ao_info = rcu_dereference_check(tp->ao_info,
+						lockdep_sock_is_held(sk));
+		if (ao_info) {
+			/* This is an extra check: tcp_ao_required() in
+			 * tcp_v{4,6}_parse_md5_keys() should prevent adding
+			 * md5 keys on ao_required socket.
+			 */
+			needs_ao |= ao_info->ao_required;
+			WARN_ON_ONCE(ao_info->ao_required && needs_md5);
+		}
+		if (needs_md5 && needs_ao)
+			return -EKEYREJECTED;
+
+		/* If we have a matching md5 key and no matching tcp-ao key
+		 * then free up ao_info if allocated.
+		 */
+		if (needs_md5) {
+			tcp_ao_destroy_sock(sk);
+		} else if (needs_ao) {
+			tcp_clear_md5_list(sk);
+			kfree(rcu_replace_pointer(tp->md5sig_info, NULL,
+						  lockdep_sock_is_held(sk)));
+		}
+	}
+#endif
+#ifdef CONFIG_TCP_AO
+	if (unlikely(rcu_dereference_protected(tp->ao_info,
+					       lockdep_sock_is_held(sk)))) {
+		/* Don't allow connecting if ao is configured but no
+		 * matching key is found.
+		 */
+		if (!tp->af_specific->ao_lookup(sk, sk, -1, -1))
+			return -EKEYREJECTED;
+	}
+#endif
+
 	if (inet_csk(sk)->icsk_af_ops->rebuild_header(sk))
 		return -EHOSTUNREACH; /* Routing failure or similar. */
 
diff --git a/net/ipv6/tcp_ao.c b/net/ipv6/tcp_ao.c
index d0aa6414b7d9..3d2be5f73cf0 100644
--- a/net/ipv6/tcp_ao.c
+++ b/net/ipv6/tcp_ao.c
@@ -12,6 +12,24 @@
 #include <net/tcp.h>
 #include <net/ipv6.h>
 
+struct tcp_ao_key *tcp_v6_ao_do_lookup(const struct sock *sk,
+				       const struct in6_addr *addr,
+				       int sndid, int rcvid)
+{
+	return tcp_ao_do_lookup(sk, (union tcp_ao_addr *)addr, AF_INET6,
+				sndid, rcvid, 0);
+}
+
+struct tcp_ao_key *tcp_v6_ao_lookup(const struct sock *sk,
+				    struct sock *addr_sk,
+				    int sndid, int rcvid)
+{
+	struct in6_addr *addr = &addr_sk->sk_v6_daddr;
+
+	return tcp_v6_ao_do_lookup(sk, addr, sndid, rcvid);
+}
+EXPORT_SYMBOL_GPL(tcp_v6_ao_lookup);
+
 int tcp_v6_parse_ao(struct sock *sk, int cmd,
 		    sockptr_t optval, int optlen)
 {
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 84e69d5f2f81..a946a3a66a92 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -603,6 +603,7 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 {
 	struct tcp_md5sig cmd;
 	struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)&cmd.tcpm_addr;
+	union tcp_ao_addr *addr;
 	int l3index = 0;
 	u8 prefixlen;
 	u8 flags;
@@ -657,13 +658,28 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 	if (cmd.tcpm_keylen > TCP_MD5SIG_MAXKEYLEN)
 		return -EINVAL;
 
-	if (ipv6_addr_v4mapped(&sin6->sin6_addr))
-		return tcp_md5_do_add(sk, (union tcp_md5_addr *)&sin6->sin6_addr.s6_addr32[3],
+	if (ipv6_addr_v4mapped(&sin6->sin6_addr)) {
+		addr = (union tcp_md5_addr *)&sin6->sin6_addr.s6_addr32[3];
+
+		/* Don't allow keys for peers that have a matching TCP-AO key.
+		 * See the comment in tcp_ao_add_cmd()
+		 */
+		if (tcp_ao_required(sk, addr, AF_INET))
+			return -EKEYREJECTED;
+		return tcp_md5_do_add(sk, addr,
 				      AF_INET, prefixlen, l3index, flags,
 				      cmd.tcpm_key, cmd.tcpm_keylen);
+	}
 
-	return tcp_md5_do_add(sk, (union tcp_md5_addr *)&sin6->sin6_addr,
-			      AF_INET6, prefixlen, l3index, flags,
+	addr = (union tcp_md5_addr *)&sin6->sin6_addr;
+
+	/* Don't allow keys for peers that have a matching TCP-AO key.
+	 * See the comment in tcp_ao_add_cmd()
+	 */
+	if (tcp_ao_required(sk, addr, AF_INET6))
+		return -EKEYREJECTED;
+
+	return tcp_md5_do_add(sk, addr, AF_INET6, prefixlen, l3index, flags,
 			      cmd.tcpm_key, cmd.tcpm_keylen);
 }
 
@@ -1903,6 +1919,7 @@ static const struct tcp_sock_af_ops tcp_sock_ipv6_specific = {
 	.md5_parse	=	tcp_v6_parse_md5_keys,
 #endif
 #ifdef CONFIG_TCP_AO
+	.ao_lookup	=	tcp_v6_ao_lookup,
 	.ao_parse	=	tcp_v6_parse_ao,
 #endif
 };
@@ -1934,6 +1951,7 @@ static const struct tcp_sock_af_ops tcp_sock_ipv6_mapped_specific = {
 	.md5_parse	=	tcp_v6_parse_md5_keys,
 #endif
 #ifdef CONFIG_TCP_AO
+	.ao_lookup	=	tcp_v6_ao_lookup,
 	.ao_parse	=	tcp_v6_parse_ao,
 #endif
 };
-- 
2.40.0


