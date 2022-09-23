Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69AE45E831E
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 22:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbiIWUN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 16:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbiIWUNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 16:13:48 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCB012AEC3
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:13:41 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id c11so1517494wrp.11
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=yZPp7ctB/Sb32CVgSwmuqChHwq9twylaz1gBB01Uj2E=;
        b=UvLGkYyz5uE6J0+CsBn/Bhzi/HuTyc269skmxyYC7ZUm47EZSdSSJyK/QRRSQrwBVa
         lJZBfn5A/PkRwYOodM0M8Y7TmRMweQmfpiEM4wNH5RLsWfx4T1WQ8A3PDSlVOiObBcXs
         VdP44/cqOUwjG+YtrvxwweT5laSfaXbr8N3yY2GkZgCNM8MM6Z3byPijjjdGfwfJwsQ0
         p02UazkbxRx9FsQYSBGg96WRGxvU8Bqxv0oA02U4Qde1yYtAPHGu2VVa9cUlp98XxrdO
         eRBKeOnmuMCYH0Uvy9nX67EzewNqikRnF6j6U3/f2VYJjZzPKqtcWEKfFooHRGGlTdxS
         wxYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=yZPp7ctB/Sb32CVgSwmuqChHwq9twylaz1gBB01Uj2E=;
        b=OMX/xwclC1GW4NG4ZE/61IysBXfiVi/oSYBPYsEDBybUfqJpI4VQLZKlnRTdvS20uU
         LThtcmqFLGjySdHFw70XecQsMTVdDAi1QqMcoKeuBoFBpVIwZijGCtUTYZXIBxa9scPU
         Xkw75owq9ptIQ5DBv37qu6+cSNRUNxL/HW8EKrDxgw/CwYAlbNblzE0RKcqI5u/bOB8d
         COTniQuNHV4bCJAslBdx2b7hG+lhOQ1JUR3BYfzE9tl6WpRiJesPfTkQNRlnClaYTHMY
         tiZVyZf7vMQEOsrt5cTm+bCj1U4D8nIjqUYxteuJ1Q5B6ApzjwtgcDgWLFucIH4qobzg
         AOVw==
X-Gm-Message-State: ACrzQf2amcsEl4blWJbFnj2iQLx6fTQ6Z22MERWo2Svfm5xkZjOfcOtz
        GjartKsGv4sDPV7fhgNcacrKXQ==
X-Google-Smtp-Source: AMsMyM55JGa0an0dun6ygNUi1IudKy+mGCKbgIrO336bLmlGpSQZMbJvGiCTK0nGfz0gAzBVApx4Bw==
X-Received: by 2002:a05:6000:1a8d:b0:22a:44e9:831e with SMTP id f13-20020a0560001a8d00b0022a44e9831emr6451113wry.575.1663964020575;
        Fri, 23 Sep 2022 13:13:40 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id k11-20020a05600c0b4b00b003b492753826sm3281056wmr.43.2022.09.23.13.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:13:40 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 09/35] net/tcp: Prevent TCP-MD5 with TCP-AO being set
Date:   Fri, 23 Sep 2022 21:12:53 +0100
Message-Id: <20220923201319.493208-10-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220923201319.493208-1-dima@arista.com>
References: <20220923201319.493208-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
 include/net/tcp.h     | 23 +++++++++++++++++++++--
 include/net/tcp_ao.h  | 15 +++++++++++++++
 net/ipv4/tcp_ao.c     | 12 ++++++++++++
 net/ipv4/tcp_ipv4.c   | 10 ++++++++--
 net/ipv4/tcp_output.c | 22 ++++++++++++++++++++++
 net/ipv6/tcp_ao.c     | 17 +++++++++++++++++
 net/ipv6/tcp_ipv6.c   | 22 ++++++++++++++++++----
 7 files changed, 113 insertions(+), 8 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 278d0ab81796..9c71f48cc99c 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1670,14 +1670,23 @@ struct tcp_md5sig_key *tcp_v4_md5_lookup(const struct sock *sk,
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
@@ -1695,6 +1704,13 @@ tcp_md5_do_lookup(const struct sock *sk, int l3index,
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
@@ -2059,6 +2075,9 @@ struct tcp_sock_af_ops {
 					    int optname,
 					    sockptr_t optval,
 					    int optlen);
+	struct tcp_ao_key	*(*ao_lookup)(const struct sock *sk,
+					      struct sock  *addr_sk,
+					      int sndid, int rcvid);
 #endif
 };
 
diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index 6d0d30e5542b..c550f1a6f5fd 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -91,12 +91,27 @@ struct tcp_ao_info {
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
index bf3612afc751..2e90b5a7b941 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -181,6 +181,14 @@ void tcp_ao_destroy_sock(struct sock *sk)
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
 static int tcp_ao_current_rnext(struct sock *sk, u16 tcpa_flags,
 				u8 tcpa_sndid, u8 tcpa_rcvid)
 {
@@ -626,6 +634,10 @@ static int tcp_ao_add_cmd(struct sock *sk, unsigned short int family,
 	if (cmd.tcpa_keyflags & ~TCP_AO_KEYF_ALL)
 		return -EINVAL;
 
+	/* Don't allow keys for peers that have a matching TCP-MD5 key */
+	if (tcp_md5_do_lookup_any_l3index(sk, addr, family))
+		return -EKEYREJECTED;
+
 	ao_info = rcu_dereference_protected(tcp_sk(sk)->ao_info,
 					    lockdep_sock_is_held(sk));
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 3d9ee73b7ca6..f3d183be2595 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1065,7 +1065,7 @@ static bool better_md5_match(struct tcp_md5sig_key *old, struct tcp_md5sig_key *
 /* Find the Key structure for an address.  */
 struct tcp_md5sig_key *__tcp_md5_do_lookup(const struct sock *sk, int l3index,
 					   const union tcp_md5_addr *addr,
-					   int family)
+					   int family, bool any_l3index)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_md5sig_key *key;
@@ -1084,7 +1084,8 @@ struct tcp_md5sig_key *__tcp_md5_do_lookup(const struct sock *sk, int l3index,
 				 lockdep_sock_is_held(sk)) {
 		if (key->family != family)
 			continue;
-		if (key->flags & TCP_MD5SIG_FLAG_IFINDEX && key->l3index != l3index)
+		if (!any_l3index && key->flags & TCP_MD5SIG_FLAG_IFINDEX &&
+		    key->l3index != l3index)
 			continue;
 		if (family == AF_INET) {
 			mask = inet_make_mask(key->prefixlen);
@@ -1349,6 +1350,10 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
 	if (cmd.tcpm_keylen > TCP_MD5SIG_MAXKEYLEN)
 		return -EINVAL;
 
+	/* Don't allow keys for peers that have a matching TCP-AO key */
+	if (tcp_ao_do_lookup(sk, addr, AF_INET, -1, -1, 0))
+		return -EKEYREJECTED;
+
 	return tcp_md5_do_add(sk, addr, AF_INET, prefixlen, l3index, flags,
 			      cmd.tcpm_key, cmd.tcpm_keylen);
 }
@@ -2244,6 +2249,7 @@ static const struct tcp_sock_af_ops tcp_sock_ipv4_specific = {
 	.md5_parse		= tcp_v4_parse_md5_keys,
 #endif
 #ifdef CONFIG_TCP_AO
+	.ao_lookup		= tcp_v4_ao_lookup,
 	.ao_parse		= tcp_v4_parse_ao,
 #endif
 };
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 688d527c8398..4b9ffd6b901d 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3837,6 +3837,28 @@ int tcp_connect(struct sock *sk)
 
 	tcp_call_bpf(sk, BPF_SOCK_OPS_TCP_CONNECT_CB, 0, NULL);
 
+#if defined(CONFIG_TCP_MD5SIG) && defined(CONFIG_TCP_AO)
+	/* Has to be checked late, after setting daddr/saddr/ops */
+	if (unlikely(rcu_dereference_protected(tp->md5sig_info,
+					       lockdep_sock_is_held(sk)))) {
+		bool needs_md5 = !!tp->af_specific->md5_lookup(sk, sk);
+		bool needs_ao = !!tp->af_specific->ao_lookup(sk, sk, -1, -1);
+
+		if (needs_md5 && needs_ao)
+			return -EKEYREJECTED;
+	}
+#endif
+#ifdef CONFIG_TCP_AO
+	if (unlikely(rcu_dereference_protected(tp->ao_info,
+					       lockdep_sock_is_held(sk)))) {
+		/* Don't allow connecting if ao is configured but no
+		 * matching key is found.
+		 */
+		if (tp->af_specific->ao_lookup(sk, sk, -1, -1) == NULL)
+			return -EKEYREJECTED;
+	}
+#endif
+
 	if (inet_csk(sk)->icsk_af_ops->rebuild_header(sk))
 		return -EHOSTUNREACH; /* Routing failure or similar. */
 
diff --git a/net/ipv6/tcp_ao.c b/net/ipv6/tcp_ao.c
index f9f242a7e0f2..221b8adb4f73 100644
--- a/net/ipv6/tcp_ao.c
+++ b/net/ipv6/tcp_ao.c
@@ -13,6 +13,23 @@
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
+
 int tcp_v6_parse_ao(struct sock *sk, int cmd,
 		    sockptr_t optval, int optlen)
 {
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 741cbeb52117..f5780a3fbd1b 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -602,6 +602,7 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 {
 	struct tcp_md5sig cmd;
 	struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)&cmd.tcpm_addr;
+	union tcp_ao_addr *addr;
 	int l3index = 0;
 	u8 prefixlen;
 	u8 flags;
@@ -656,13 +657,24 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 	if (cmd.tcpm_keylen > TCP_MD5SIG_MAXKEYLEN)
 		return -EINVAL;
 
-	if (ipv6_addr_v4mapped(&sin6->sin6_addr))
-		return tcp_md5_do_add(sk, (union tcp_md5_addr *)&sin6->sin6_addr.s6_addr32[3],
+	if (ipv6_addr_v4mapped(&sin6->sin6_addr)) {
+		addr = (union tcp_md5_addr *)&sin6->sin6_addr.s6_addr32[3];
+
+		/* Don't allow keys for peers that have a matching TCP-AO key */
+		if (tcp_ao_do_lookup(sk, addr, AF_INET, -1, -1, 0))
+			return -EKEYREJECTED;
+		return tcp_md5_do_add(sk, addr,
 				      AF_INET, prefixlen, l3index, flags,
 				      cmd.tcpm_key, cmd.tcpm_keylen);
+	}
+
+	addr = (union tcp_md5_addr *)&sin6->sin6_addr;
+
+	/* Don't allow keys for peers that have a matching TCP-AO key */
+	if (tcp_ao_do_lookup(sk, addr, AF_INET6, -1, -1, 0))
+		return -EKEYREJECTED;
 
-	return tcp_md5_do_add(sk, (union tcp_md5_addr *)&sin6->sin6_addr,
-			      AF_INET6, prefixlen, l3index, flags,
+	return tcp_md5_do_add(sk, addr, AF_INET6, prefixlen, l3index, flags,
 			      cmd.tcpm_key, cmd.tcpm_keylen);
 }
 
@@ -1891,6 +1903,7 @@ static const struct tcp_sock_af_ops tcp_sock_ipv6_specific = {
 	.md5_parse	=	tcp_v6_parse_md5_keys,
 #endif
 #ifdef CONFIG_TCP_AO
+	.ao_lookup	=	tcp_v6_ao_lookup,
 	.ao_parse	=	tcp_v6_parse_ao,
 #endif
 };
@@ -1922,6 +1935,7 @@ static const struct tcp_sock_af_ops tcp_sock_ipv6_mapped_specific = {
 	.md5_parse	=	tcp_v6_parse_md5_keys,
 #endif
 #ifdef CONFIG_TCP_AO
+	.ao_lookup	=	tcp_v6_ao_lookup,
 	.ao_parse	=	tcp_v6_parse_ao,
 #endif
 };
-- 
2.37.2

