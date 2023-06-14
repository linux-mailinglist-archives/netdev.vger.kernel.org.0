Return-Path: <netdev+bounces-10933-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 71979730B5B
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 01:18:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9641D1C20E16
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:18:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D9A3168C6;
	Wed, 14 Jun 2023 23:11:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C12E1ACA2
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 23:11:28 +0000 (UTC)
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2918E2727
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:10:59 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f8d0e814dfso10994535e9.3
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1686784228; x=1689376228;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bcuuwR3ToLpGQOSozVPk4mnAqQBa3vwrWj9NV+E1Eog=;
        b=Vq3k5cPtqQj1DOxGML8jijeGZztpBQe2+FjIytRF52MVqMjZMkDJkK3U/8uF+VfGam
         T1H6qpCXbuzU+Z/bgYPW/cDylrSvtpnwbbkap9dKVgaVN9BzbcaqWSHSXgGRRTYp7BRd
         6NlBn9dNJrZjkWgOZvd0qB+QQccFXY8JSQrtA4u0CkW/sYHtDZU5RVwTE63oodVDnE1F
         0cHMIPS2BfY+TAE/gNYFnlkrc5AexdLkZLF7RztHCqOzDEbqo/CY5cuTlnk3Y99UKE73
         8YgrWEs4CjaDeSl2LIj9LB8HtD3UZu4L/bG517MqBOu9iwdfLqSjo0eznwAibVO3tuBM
         th/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686784228; x=1689376228;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bcuuwR3ToLpGQOSozVPk4mnAqQBa3vwrWj9NV+E1Eog=;
        b=VvECWpmff81V3Gsc3q27+2D6zDNqwng9Z0xl4SVc50wS611rRAINQf4WEUuwGvNP+l
         igDDuJToZX2+HtSc9veZw05vXe2GkgaDIYPWEIMSDVwNPAf1PyIKDS3ODaePRUp8v5Mz
         D+zelML/5N+Kdz61blT7Pf1/v3fJ7bn4Xh3yCkEYqvLDSxcP0EVKSSEOi7xmRzeeurTM
         RSCZIKwbfiusT8pjuBwKa4EEIpRI7FIbRgeD/FFiGoTwvqd4peUNj5GX5pPyQ7OjQwV0
         hcLh4UEbKNlcpzDp6AC0RC6b0I5AXF9SHboxURchTs2pbEx/8nWYrPEQnwBncovMXRNr
         BdeA==
X-Gm-Message-State: AC+VfDxV5xFYhyQx1lSn2z2KKGcCBwMi74X497gfjLrcvPJbhl7yH+KB
	mmfDBZ1+GHfrBmJLdIke/UPErA==
X-Google-Smtp-Source: ACHHUZ674Ltc7/HQpc+uHEjUUjEEE3DSrSHW7MEJLhngn+RixU0GIb18q6l8QwZ8zyEfADlSYQAP1A==
X-Received: by 2002:a05:600c:2103:b0:3f0:b1c9:25d4 with SMTP id u3-20020a05600c210300b003f0b1c925d4mr10967411wml.21.1686784228411;
        Wed, 14 Jun 2023 16:10:28 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id s12-20020a7bc38c000000b003f7ba52eeccsm18725261wmj.7.2023.06.14.16.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 16:10:27 -0700 (PDT)
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
Subject: [PATCH v7 21/22] net/tcp: Wire up l3index to TCP-AO
Date: Thu, 15 Jun 2023 00:09:46 +0100
Message-Id: <20230614230947.3954084-22-dima@arista.com>
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

Similarly how TCP_MD5SIG_FLAG_IFINDEX works for TCP-MD5,
TCP_AO_KEYF_IFINDEX is an AO-key flag that binds that MKT to a specified
by L3 ifinndex. Similarly, without this flag the key will work in
the default VRF l3index = 0 for connections.
To prevent AO-keys from overlapping, it's restricted to add key B for a
socket that has key A, which have the same sndid/rcvid and one of
the following is true:
- !(A.keyflags & TCP_AO_KEYF_IFINDEX) or !(B.keyflags & TCP_AO_KEYF_IFINDEX)
  so that any key is non-bound to a VRF
- A.l3index == B.l3index
  both want to work for the same VRF

Additionally, it's restricted to match TCP-MD5 keys for the same peer
the following way:
|--------------|--------------------|----------------|---------------|
|              | MD5 key without    |     MD5 key    |    MD5 key    |
|              |     l3index        |    l3index=0   |   l3index=N   |
|--------------|--------------------|----------------|---------------|
|  TCP-AO key  |                    |                |               |
|  without     |       reject       |    reject      |   reject      |
|  l3index     |                    |                |               |
|--------------|--------------------|----------------|---------------|
|  TCP-AO key  |                    |                |               |
|  l3index=0   |       reject       |    reject      |   allow       |
|--------------|--------------------|----------------|---------------|
|  TCP-AO key  |                    |                |               |
|  l3index=N   |       reject       |    allow       |   reject      |
|--------------|--------------------|----------------|---------------|

This is done with the help of tcp_md5_do_lookup_any_l3index() to reject
adding AO key without TCP_AO_KEYF_IFINDEX if there's TCP-MD5 in any VRF.
This is important for case where sysctl_tcp_l3mdev_accept = 1
Similarly, for TCP-AO lookups tcp_ao_do_lookup() may be used with
l3index < 0, so that __tcp_ao_key_cmp() will match TCP-AO key in any VRF.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp.h     |  11 +--
 include/net/tcp_ao.h  |  17 +++--
 net/ipv4/syncookies.c |   6 +-
 net/ipv4/tcp_ao.c     | 163 +++++++++++++++++++++++++++++++-----------
 net/ipv4/tcp_ipv4.c   |  13 ++--
 net/ipv6/syncookies.c |   5 +-
 net/ipv6/tcp_ao.c     |  20 +++---
 net/ipv6/tcp_ipv6.c   |  15 ++--
 8 files changed, 170 insertions(+), 80 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 6060513ab83d..e6c02517254a 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2579,7 +2579,7 @@ static inline int tcp_parse_auth_options(const struct tcphdr *th,
 }
 
 static inline bool tcp_ao_required(struct sock *sk, const void *saddr,
-				   int family, bool stat_inc)
+				   int family, int l3index, bool stat_inc)
 {
 #ifdef CONFIG_TCP_AO
 	struct tcp_ao_info *ao_info;
@@ -2593,7 +2593,7 @@ static inline bool tcp_ao_required(struct sock *sk, const void *saddr,
 	if (!ao_info)
 		return false;
 
-	ao_key = tcp_ao_do_lookup(sk, saddr, family, -1, -1, 0);
+	ao_key = tcp_ao_do_lookup(sk, l3index, saddr, family, -1, -1, 0);
 	if (ao_info->ao_required || ao_key) {
 		if (stat_inc) {
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOREQUIRED);
@@ -2646,21 +2646,22 @@ tcp_inbound_hash(struct sock *sk, const struct request_sock *req,
 		 * the last key is impossible to remove, so there's
 		 * always at least one current_key.
 		 */
-		if (tcp_ao_required(sk, saddr, family, true)) {
+		if (tcp_ao_required(sk, saddr, family, l3index, true)) {
 			tcp_hash_fail("AO hash is required, but not found",
 					family, skb, "L3 index %d", l3index);
 			return SKB_DROP_REASON_TCP_AONOTFOUND;
 		}
 		if (unlikely(tcp_md5_do_lookup(sk, l3index, saddr, family))) {
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5NOTFOUND);
-			tcp_hash_fail("MD5 Hash not found", family, skb, "");
+			tcp_hash_fail("MD5 Hash not found",
+				      family, skb, "L3 index %d", l3index);
 			return SKB_DROP_REASON_TCP_MD5NOTFOUND;
 		}
 		return SKB_NOT_DROPPED_YET;
 	}
 
 	if (aoh)
-		return tcp_inbound_ao_hash(sk, skb, family, req, aoh);
+		return tcp_inbound_ao_hash(sk, skb, family, req, l3index, aoh);
 
 	return tcp_inbound_md5_hash(sk, skb, saddr, daddr, family,
 				    l3index, md5_location);
diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index 714a46e30f3f..3449d093143e 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -33,6 +33,7 @@ struct tcp_ao_key {
 	union tcp_ao_addr	addr;
 	u8			key[TCP_AO_MAXKEYLEN] __tcp_ao_key_align;
 	unsigned int		tcp_sigpool_id;
+	int			l3index;
 	u16			port;
 	u8			prefixlen;
 	u8			family;
@@ -183,9 +184,9 @@ int tcp_ao_get_mkts(struct sock *sk, sockptr_t optval, sockptr_t optlen);
 int tcp_ao_get_sock_info(struct sock *sk, sockptr_t optval, sockptr_t optlen);
 enum skb_drop_reason tcp_inbound_ao_hash(struct sock *sk,
 			const struct sk_buff *skb, unsigned short int family,
-			const struct request_sock *req,
+			const struct request_sock *req, int l3index,
 			const struct tcp_ao_hdr *aoh);
-struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
+struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk, int l3index,
 				    const union tcp_ao_addr *addr,
 				    int family, int sndid, int rcvid, u16 port);
 int tcp_ao_hash_hdr(unsigned short family, char *ao_hash,
@@ -229,9 +230,6 @@ int tcp_v6_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
 				 __be32 disn, bool send);
 int tcp_v6_ao_calc_key_rsk(struct tcp_ao_key *mkt, u8 *key,
 			   struct request_sock *req);
-struct tcp_ao_key *tcp_v6_ao_do_lookup(const struct sock *sk,
-				       const struct in6_addr *addr,
-				       int sndid, int rcvid);
 struct tcp_ao_key *tcp_v6_ao_lookup(const struct sock *sk,
 				    struct sock *addr_sk,
 				    int sndid, int rcvid);
@@ -250,12 +248,12 @@ void tcp_ao_finish_connect(struct sock *sk, struct sk_buff *skb);
 void tcp_ao_connect_init(struct sock *sk);
 void tcp_ao_syncookie(struct sock *sk, const struct sk_buff *skb,
 		      struct tcp_request_sock *treq,
-		      unsigned short int family);
+		      unsigned short int family, int l3index);
 #else /* CONFIG_TCP_AO */
 
 static inline void tcp_ao_syncookie(struct sock *sk, const struct sk_buff *skb,
 		      struct tcp_request_sock *treq,
-		      unsigned short int family)
+		      unsigned short int family, int l3index)
 {
 }
 
@@ -266,13 +264,14 @@ static inline bool tcp_ao_ignore_icmp(struct sock *sk, int type, int code)
 
 static inline enum skb_drop_reason tcp_inbound_ao_hash(struct sock *sk,
 		const struct sk_buff *skb, unsigned short int family,
-		const struct request_sock *req, const struct tcp_ao_hdr *aoh)
+		const struct request_sock *req, int l3index,
+		const struct tcp_ao_hdr *aoh)
 {
 	return SKB_NOT_DROPPED_YET;
 }
 
 static inline struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
-		const union tcp_ao_addr *addr,
+		int l3index, const union tcp_ao_addr *addr,
 		int family, int sndid, int rcvid, u16 port)
 {
 	return NULL;
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 9e3d7083af7d..a994a3405a67 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -337,6 +337,7 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 	struct rtable *rt;
 	__u8 rcv_wscale;
 	struct flowi4 fl4;
+	int l3index;
 	u32 tsoff = 0;
 
 	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_syncookies) ||
@@ -394,13 +395,14 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 	treq->snt_synack	= 0;
 	treq->tfo_listener	= false;
 
-	tcp_ao_syncookie(sk, skb, treq, AF_INET);
-
 	if (IS_ENABLED(CONFIG_SMC))
 		ireq->smc_ok = 0;
 
 	ireq->ir_iif = inet_request_bound_dev_if(sk, skb);
 
+	l3index = l3mdev_master_ifindex_by_index(sock_net(sk), ireq->ir_iif);
+	tcp_ao_syncookie(sk, skb, treq, AF_INET, l3index);
+
 	/* We throwed the options of the initial SYN away, so we hope
 	 * the ACK carries the same options again (see RFC1122 4.2.3.8)
 	 */
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index 2c4a31d8f177..d8a02cf0ba3c 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -148,7 +148,7 @@ static inline int ipv4_prefix_cmp(const struct in_addr *addr1,
 	return ((addr1->s_addr & mask) > (addr2->s_addr & mask)) ? 1 : -1;
 }
 
-static int __tcp_ao_key_cmp(const struct tcp_ao_key *key,
+static int __tcp_ao_key_cmp(const struct tcp_ao_key *key, int l3index,
 			    const union tcp_ao_addr *addr, u8 prefixlen,
 			    int family, int sndid, int rcvid, u16 port)
 {
@@ -158,6 +158,10 @@ static int __tcp_ao_key_cmp(const struct tcp_ao_key *key,
 		return (key->rcvid > rcvid) ? 1 : -1;
 	if (port != 0 && key->port != 0 && port != key->port)
 		return (key->port > port) ? 1 : -1;
+	if (l3index >= 0 && (key->keyflags & TCP_AO_KEYF_IFINDEX)) {
+		if (key->l3index != l3index)
+			return (key->l3index > l3index) ? 1 : -1;
+	}
 
 	if (family == AF_UNSPEC)
 		return 0;
@@ -182,7 +186,7 @@ static int __tcp_ao_key_cmp(const struct tcp_ao_key *key,
 	return -1;
 }
 
-static int tcp_ao_key_cmp(const struct tcp_ao_key *key,
+static int tcp_ao_key_cmp(const struct tcp_ao_key *key, int l3index,
 			  const union tcp_ao_addr *addr, u8 prefixlen,
 			  int family, int sndid, int rcvid, u16 port)
 {
@@ -190,14 +194,16 @@ static int tcp_ao_key_cmp(const struct tcp_ao_key *key,
 	if (family == AF_INET6 && ipv6_addr_v4mapped(&addr->a6)) {
 		__be32 addr4 = addr->a6.s6_addr32[3];
 
-		return __tcp_ao_key_cmp(key, (union tcp_ao_addr *)&addr4,
+		return __tcp_ao_key_cmp(key, l3index,
+					(union tcp_ao_addr *)&addr4,
 					prefixlen, AF_INET, sndid, rcvid, port);
 	}
 #endif
-	return __tcp_ao_key_cmp(key, addr, prefixlen, family, sndid, rcvid, port);
+	return __tcp_ao_key_cmp(key, l3index, addr,
+				prefixlen, family, sndid, rcvid, port);
 }
 
-static struct tcp_ao_key *__tcp_ao_do_lookup(const struct sock *sk,
+static struct tcp_ao_key *__tcp_ao_do_lookup(const struct sock *sk, int l3index,
 		const union tcp_ao_addr *addr, int family, u8 prefix,
 		int sndid, int rcvid, u16 port)
 {
@@ -215,18 +221,18 @@ static struct tcp_ao_key *__tcp_ao_do_lookup(const struct sock *sk,
 	hlist_for_each_entry_rcu(key, &ao->head, node) {
 		u8 prefixlen = min(prefix, key->prefixlen);
 
-		if (!tcp_ao_key_cmp(key, addr, prefixlen,
+		if (!tcp_ao_key_cmp(key, l3index, addr, prefixlen,
 				    family, sndid, rcvid, port))
 			return key;
 	}
 	return NULL;
 }
 
-struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
+struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk, int l3index,
 				    const union tcp_ao_addr *addr,
 				    int family, int sndid, int rcvid, u16 port)
 {
-	return __tcp_ao_do_lookup(sk, addr, family, U8_MAX,
+	return __tcp_ao_do_lookup(sk, l3index, addr, family, U8_MAX,
 				  sndid, rcvid, port);
 }
 EXPORT_SYMBOL_GPL(tcp_ao_do_lookup);
@@ -669,18 +675,21 @@ struct tcp_ao_key *tcp_v4_ao_lookup_rsk(const struct sock *sk,
 					struct request_sock *req,
 					int sndid, int rcvid)
 {
-	union tcp_ao_addr *addr =
-			(union tcp_ao_addr *)&inet_rsk(req)->ir_rmt_addr;
+	struct inet_request_sock *ireq = inet_rsk(req);
+	union tcp_ao_addr *addr = (union tcp_ao_addr *)&ireq->ir_rmt_addr;
+	int l3index = l3mdev_master_ifindex_by_index(sock_net(sk), ireq->ir_iif);
 
-	return tcp_ao_do_lookup(sk, addr, AF_INET, sndid, rcvid, 0);
+	return tcp_ao_do_lookup(sk, l3index, addr, AF_INET, sndid, rcvid, 0);
 }
 
 struct tcp_ao_key *tcp_v4_ao_lookup(const struct sock *sk, struct sock *addr_sk,
 				    int sndid, int rcvid)
 {
 	union tcp_ao_addr *addr = (union tcp_ao_addr *)&addr_sk->sk_daddr;
+	int l3index = l3mdev_master_ifindex_by_index(sock_net(sk),
+						     addr_sk->sk_bound_dev_if);
 
-	return tcp_ao_do_lookup(sk, addr, AF_INET, sndid, rcvid, 0);
+	return tcp_ao_do_lookup(sk, l3index, addr, AF_INET, sndid, rcvid, 0);
 }
 
 int tcp_ao_prepare_reset(const struct sock *sk, struct sk_buff *skb,
@@ -755,24 +764,26 @@ int tcp_ao_prepare_reset(const struct sock *sk, struct sk_buff *skb,
 
 static struct tcp_ao_key *tcp_ao_inbound_lookup(unsigned short int family,
 		const struct sock *sk, const struct sk_buff *skb,
-		int sndid, int rcvid)
+		int sndid, int rcvid, int l3index)
 {
 	if (family == AF_INET) {
 		const struct iphdr *iph = ip_hdr(skb);
 
-		return tcp_ao_do_lookup(sk, (union tcp_ao_addr *)&iph->saddr,
-				AF_INET, sndid, rcvid, 0);
+		return tcp_ao_do_lookup(sk, l3index,
+					(union tcp_ao_addr *)&iph->saddr,
+					AF_INET, sndid, rcvid, 0);
 	} else {
 		const struct ipv6hdr *iph = ipv6_hdr(skb);
 
-		return tcp_ao_do_lookup(sk, (union tcp_ao_addr *)&iph->saddr,
-				AF_INET6, sndid, rcvid, 0);
+		return tcp_ao_do_lookup(sk, l3index,
+					(union tcp_ao_addr *)&iph->saddr,
+					AF_INET6, sndid, rcvid, 0);
 	}
 }
 
 void tcp_ao_syncookie(struct sock *sk, const struct sk_buff *skb,
 		      struct tcp_request_sock *treq,
-		      unsigned short int family)
+		      unsigned short int family, int l3index)
 {
 	const struct tcphdr *th = tcp_hdr(skb);
 	const struct tcp_ao_hdr *aoh;
@@ -787,7 +798,7 @@ void tcp_ao_syncookie(struct sock *sk, const struct sk_buff *skb,
 	if (!aoh)
 		return;
 
-	key = tcp_ao_inbound_lookup(family, sk, skb, -1, aoh->keyid);
+	key = tcp_ao_inbound_lookup(family, sk, skb, -1, aoh->keyid, l3index);
 	if (!key)
 		/* Key not found, continue without TCP-AO */
 		return;
@@ -802,7 +813,7 @@ static enum skb_drop_reason
 tcp_ao_verify_hash(const struct sock *sk, const struct sk_buff *skb,
 		   unsigned short int family, struct tcp_ao_info *info,
 		   const struct tcp_ao_hdr *aoh, struct tcp_ao_key *key,
-		   u8 *traffic_key, u8 *phash, u32 sne)
+		   u8 *traffic_key, u8 *phash, u32 sne, int l3index)
 {
 	unsigned char newhash[TCP_AO_MAX_HASH_SIZE] __tcp_ao_key_align;
 	u8 maclen = aoh->length - sizeof(struct tcp_ao_hdr);
@@ -813,7 +824,8 @@ tcp_ao_verify_hash(const struct sock *sk, const struct sk_buff *skb,
 		atomic64_inc(&info->counters.pkt_bad);
 		atomic64_inc(&key->pkt_bad);
 		tcp_hash_fail("AO hash wrong length", family, skb,
-			      "%u != %d", maclen, tcp_ao_maclen(key));
+			      "%u != %d L3index: %d", maclen,
+			      tcp_ao_maclen(key), l3index);
 		return SKB_DROP_REASON_TCP_AOFAILURE;
 	}
 
@@ -824,7 +836,8 @@ tcp_ao_verify_hash(const struct sock *sk, const struct sk_buff *skb,
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOBAD);
 		atomic64_inc(&info->counters.pkt_bad);
 		atomic64_inc(&key->pkt_bad);
-		tcp_hash_fail("AO hash mismatch", family, skb, "");
+		tcp_hash_fail("AO hash mismatch", family, skb,
+			      "L3index: %d", l3index);
 		return SKB_DROP_REASON_TCP_AOFAILURE;
 	}
 	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOGOOD);
@@ -836,7 +849,7 @@ tcp_ao_verify_hash(const struct sock *sk, const struct sk_buff *skb,
 enum skb_drop_reason
 tcp_inbound_ao_hash(struct sock *sk, const struct sk_buff *skb,
 		    unsigned short int family, const struct request_sock *req,
-		    const struct tcp_ao_hdr *aoh)
+		    int l3index, const struct tcp_ao_hdr *aoh)
 {
 	u8 key_buf[TCP_AO_MAX_HASH_SIZE] __tcp_ao_key_align;
 	const struct tcphdr *th = tcp_hdr(skb);
@@ -851,7 +864,7 @@ tcp_inbound_ao_hash(struct sock *sk, const struct sk_buff *skb,
 	if (!info) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOKEYNOTFOUND);
 		tcp_hash_fail("AO key not found", family, skb,
-			      "keyid: %u", aoh->keyid);
+			      "keyid: %u L3index: %d", aoh->keyid, l3index);
 		return SKB_DROP_REASON_TCP_AOUNEXPECTED;
 	}
 
@@ -886,7 +899,7 @@ tcp_inbound_ao_hash(struct sock *sk, const struct sk_buff *skb,
 		/* Established socket, traffic key are cached */
 		traffic_key = rcv_other_key(key);
 		err = tcp_ao_verify_hash(sk, skb, family, info, aoh, key,
-					 traffic_key, phash, sne);
+					 traffic_key, phash, sne, l3index);
 		if (err)
 			return err;
 		current_key = READ_ONCE(info->current_key);
@@ -907,7 +920,7 @@ tcp_inbound_ao_hash(struct sock *sk, const struct sk_buff *skb,
 	 * - request sockets would race on those key pointers
 	 * - tcp_ao_del_cmd() allows async key removal
 	 */
-	key = tcp_ao_inbound_lookup(family, sk, skb, -1, aoh->keyid);
+	key = tcp_ao_inbound_lookup(family, sk, skb, -1, aoh->keyid, l3index);
 	if (!key)
 		goto key_not_found;
 
@@ -945,13 +958,13 @@ tcp_inbound_ao_hash(struct sock *sk, const struct sk_buff *skb,
 	traffic_key = key_buf;
 	tcp_ao_calc_key_skb(key, traffic_key, skb, sisn, disn, family);
 	return tcp_ao_verify_hash(sk, skb, family, info, aoh, key,
-				  traffic_key, phash, sne);
+				  traffic_key, phash, sne, l3index);
 
 key_not_found:
 	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOKEYNOTFOUND);
 	atomic64_inc(&info->counters.key_not_found);
 	tcp_hash_fail("Requested by the peer AO key id not found",
-		      family, skb, "");
+		      family, skb, "L3index: %d", l3index);
 	return SKB_DROP_REASON_TCP_AOKEYNOTFOUND;
 }
 EXPORT_SYMBOL_GPL(tcp_inbound_ao_hash);
@@ -980,7 +993,7 @@ void tcp_ao_connect_init(struct sock *sk)
 	struct tcp_ao_key *key;
 	struct tcp_sock *tp = tcp_sk(sk);
 	union tcp_ao_addr *addr;
-	int family;
+	int family, l3index;
 
 	ao_info = rcu_dereference_protected(tp->ao_info,
 					    lockdep_sock_is_held(sk));
@@ -997,9 +1010,11 @@ void tcp_ao_connect_init(struct sock *sk)
 #endif
 	else
 		return;
+	l3index = l3mdev_master_ifindex_by_index(sock_net(sk),
+						 sk->sk_bound_dev_if);
 
 	hlist_for_each_entry_rcu(key, &ao_info->head, node) {
-		if (tcp_ao_key_cmp(key, addr, key->prefixlen, family,
+		if (tcp_ao_key_cmp(key, l3index, addr, key->prefixlen, family,
 				   -1, -1, sk->sk_dport) == 0)
 			continue;
 
@@ -1063,7 +1078,7 @@ int tcp_ao_copy_all_matching(const struct sock *sk, struct sock *newsk,
 	struct hlist_node *key_head;
 	union tcp_ao_addr *addr;
 	bool match = false;
-	int ret = -ENOMEM;
+	int l3index, ret = -ENOMEM;
 
 	ao = rcu_dereference(tcp_sk(sk)->ao_info);
 	if (!ao)
@@ -1091,9 +1106,11 @@ int tcp_ao_copy_all_matching(const struct sock *sk, struct sock *newsk,
 		ret = -EAFNOSUPPORT;
 		goto free_ao;
 	}
+	l3index = l3mdev_master_ifindex_by_index(sock_net(newsk),
+						 newsk->sk_bound_dev_if);
 
 	hlist_for_each_entry_rcu(key, &ao->head, node) {
-		if (tcp_ao_key_cmp(key, addr, key->prefixlen, family,
+		if (tcp_ao_key_cmp(key, l3index, addr, key->prefixlen, family,
 				   -1, -1, 0))
 			continue;
 
@@ -1435,17 +1452,18 @@ static struct tcp_ao_info *setsockopt_ao_info(struct sock *sk)
 	return ERR_PTR(-ESOCKTNOSUPPORT);
 }
 
-#define TCP_AO_KEYF_ALL		(TCP_AO_KEYF_EXCLUDE_OPT)
+#define TCP_AO_KEYF_ALL (TCP_AO_KEYF_IFINDEX | TCP_AO_KEYF_EXCLUDE_OPT)
+#define TCP_AO_GET_KEYF_VALID	(TCP_AO_KEYF_IFINDEX)
 
 static int tcp_ao_add_cmd(struct sock *sk, unsigned short int family,
 			  sockptr_t optval, int optlen)
 {
 	struct tcp_ao_info *ao_info;
+	int ret, size, l3index = 0;
 	union tcp_ao_addr *addr;
 	struct tcp_ao_key *key;
 	struct tcp_ao_add cmd;
 	bool first = false;
-	int ret, size;
 	u16 port;
 
 	if (optlen < sizeof(cmd))
@@ -1476,9 +1494,46 @@ static int tcp_ao_add_cmd(struct sock *sk, unsigned short int family,
 			return -EINVAL;
 	}
 
+	if (cmd.ifindex && !(cmd.keyflags & TCP_AO_KEYF_IFINDEX))
+		return -EINVAL;
+
+	/* For cmd.tcp_ifindex = 0 the key will apply to the default VRF */
+	if (cmd.keyflags & TCP_AO_KEYF_IFINDEX && cmd.ifindex) {
+		int bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
+		struct net_device *dev;
+
+		rcu_read_lock();
+		dev = dev_get_by_index_rcu(sock_net(sk), cmd.ifindex);
+		if (dev && netif_is_l3_master(dev))
+			l3index = dev->ifindex;
+		rcu_read_unlock();
+
+		if (!dev || !l3index)
+			return -EINVAL;
+
+		/* It's still possible to bind after adding keys or even
+		 * re-bind to a different dev (with CAP_NET_RAW).
+		 * So, no reason to return error here, rather try to be
+		 * nice and warn the user.
+		 */
+		if (bound_dev_if && bound_dev_if != cmd.ifindex)
+			net_warn_ratelimited("AO key ifindex %d != sk bound ifindex %d\n",
+					     cmd.ifindex, bound_dev_if);
+	}
+
 	/* Don't allow keys for peers that have a matching TCP-MD5 key */
-	if (tcp_md5_do_lookup_any_l3index(sk, addr, family))
-		return -EKEYREJECTED;
+	if (cmd.keyflags & TCP_AO_KEYF_IFINDEX) {
+		/* Non-_exact version of tcp_md5_do_lookup() will
+		 * as well match keys that aren't bound to a specific VRF
+		 * (that will make them match AO key with
+		 * sysctl_tcp_l3dev_accept = 1
+		 */
+		if (tcp_md5_do_lookup(sk, l3index, addr, family))
+			return -EKEYREJECTED;
+	} else {
+		if (tcp_md5_do_lookup_any_l3index(sk, addr, family))
+			return -EKEYREJECTED;
+	}
 
 	ao_info = setsockopt_ao_info(sk);
 	if (IS_ERR(ao_info))
@@ -1495,10 +1550,10 @@ static int tcp_ao_add_cmd(struct sock *sk, unsigned short int family,
 		 * > The IDs of MKTs MUST NOT overlap where their
 		 * > TCP connection identifiers overlap.
 		 */
-		if (__tcp_ao_do_lookup(sk, addr, family,
+		if (__tcp_ao_do_lookup(sk, l3index, addr, family,
 				       cmd.prefix, -1, cmd.rcvid, port))
 			return -EEXIST;
-		if (__tcp_ao_do_lookup(sk, addr, family,
+		if (__tcp_ao_do_lookup(sk, l3index, addr, family,
 				       cmd.prefix, cmd.sndid, -1, port))
 			return -EEXIST;
 	}
@@ -1523,6 +1578,7 @@ static int tcp_ao_add_cmd(struct sock *sk, unsigned short int family,
 	key->keyflags	= cmd.keyflags;
 	key->sndid	= cmd.sndid;
 	key->rcvid	= cmd.rcvid;
+	key->l3index	= l3index;
 	atomic64_set(&key->pkt_good, 0);
 	atomic64_set(&key->pkt_bad, 0);
 
@@ -1610,17 +1666,17 @@ static int tcp_ao_delete_key(struct sock *sk, struct tcp_ao_info *ao_info,
 	return err;
 }
 
+#define TCP_AO_DEL_KEYF_ALL (TCP_AO_KEYF_IFINDEX)
 static int tcp_ao_del_cmd(struct sock *sk, unsigned short int family,
 			  sockptr_t optval, int optlen)
 {
 	struct tcp_ao_key *key, *new_current = NULL, *new_rnext = NULL;
+	int err, addr_len, l3index = 0;
 	struct tcp_ao_info *ao_info;
 	union tcp_ao_addr *addr;
 	struct tcp_ao_del cmd;
-	int err;
 	__u8 prefix;
 	__be16 port;
-	int addr_len;
 
 	if (optlen < sizeof(cmd))
 		return -EINVAL;
@@ -1637,6 +1693,16 @@ static int tcp_ao_del_cmd(struct sock *sk, unsigned short int family,
 			return -EINVAL;
 	}
 
+	if (cmd.keyflags & ~TCP_AO_DEL_KEYF_ALL)
+		return -EINVAL;
+
+	/* No sanity check for TCP_AO_KEYF_IFINDEX as if a VRF
+	 * was destroyed, there still should be a way to delete keys,
+	 * that were bound to that l3intf. So, fail late at lookup stage
+	 * if there is no key for that ifindex.
+	 */
+	if (cmd.ifindex && !(cmd.keyflags & TCP_AO_KEYF_IFINDEX))
+		return -EINVAL;
 
 	ao_info = setsockopt_ao_info(sk);
 	if (IS_ERR(ao_info))
@@ -1702,6 +1768,13 @@ static int tcp_ao_del_cmd(struct sock *sk, unsigned short int family,
 		    memcmp(addr, &key->addr, addr_len))
 			continue;
 
+		if ((cmd.keyflags & TCP_AO_KEYF_IFINDEX) !=
+		    (key->keyflags & TCP_AO_KEYF_IFINDEX))
+			continue;
+
+		if (key->l3index != l3index)
+			continue;
+
 		if (key == new_current || key == new_rnext)
 			continue;
 
@@ -1887,10 +1960,10 @@ static int tcp_ao_copy_mkts_to_user(struct tcp_ao_info *ao_info,
 	struct tcp_ao_key *key, *current_key;
 	bool do_address_matching = true;
 	union tcp_ao_addr *addr = NULL;
+	int err, l3index, user_len;
 	unsigned int max_keys;	/* maximum number of keys to copy to user */
 	size_t out_offset = 0;
 	size_t bytes_to_write;	/* number of bytes to write to user level */
-	int err, user_len;
 	u32 matched_keys;	/* keys from ao_info matched so far */
 	int optlen_out;
 	u16 port = 0;
@@ -1909,11 +1982,16 @@ static int tcp_ao_copy_mkts_to_user(struct tcp_ao_info *ao_info,
 
 	if (opt_in.pkt_good || opt_in.pkt_bad)
 		return -EINVAL;
+	if (opt_in.keyflags & ~TCP_AO_GET_KEYF_VALID)
+		return -EINVAL;
+	if (opt_in.ifindex && !(opt_in.keyflags & TCP_AO_KEYF_IFINDEX))
+		return -EINVAL;
 
 	if (opt_in.reserved != 0)
 		return -EINVAL;
 
 	max_keys = opt_in.nkeys;
+	l3index = (opt_in.keyflags & TCP_AO_KEYF_IFINDEX) ? opt_in.ifindex : -1;
 
 	if (opt_in.get_all || opt_in.is_current || opt_in.is_rnext) {
 		if (opt_in.get_all && (opt_in.is_current || opt_in.is_rnext))
@@ -2015,7 +2093,7 @@ static int tcp_ao_copy_mkts_to_user(struct tcp_ao_info *ao_info,
 			continue;
 		}
 
-		if (tcp_ao_key_cmp(key, addr, opt_in.prefix,
+		if (tcp_ao_key_cmp(key, l3index, addr, opt_in.prefix,
 				   opt_in.addr.ss_family,
 				   opt_in.sndid, opt_in.rcvid, port) != 0)
 			continue;
@@ -2048,6 +2126,7 @@ static int tcp_ao_copy_mkts_to_user(struct tcp_ao_info *ao_info,
 		opt_out.nkeys = 0;
 		opt_out.maclen = key->maclen;
 		opt_out.keylen = key->keylen;
+		opt_out.ifindex = key->l3index;
 		opt_out.pkt_good = atomic64_read(&key->pkt_good);
 		opt_out.pkt_bad = atomic64_read(&key->pkt_bad);
 		memcpy(&opt_out.key, key->key, key->keylen);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index ee055d133e76..211d0edd6eea 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1073,6 +1073,7 @@ static void tcp_v4_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 	struct tcp_ao_key *ao_key = NULL;
 	const union tcp_md5_addr *addr;
 	u8 keyid = 0;
+	int l3index;
 #ifdef CONFIG_TCP_AO
 	u8 traffic_key[TCP_AO_MAX_HASH_SIZE] __tcp_ao_key_align;
 	const struct tcp_ao_hdr *aoh;
@@ -1086,6 +1087,7 @@ static void tcp_v4_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 	u32 seq = (sk->sk_state == TCP_LISTEN) ? tcp_rsk(req)->snt_isn + 1 :
 					     tcp_sk(sk)->snd_nxt;
 	addr = (union tcp_md5_addr *)&ip_hdr(skb)->saddr;
+	l3index = tcp_v4_sdif(skb) ? inet_iif(skb) : 0;
 
 	if (tcp_rsk_used_ao(req)) {
 #ifdef CONFIG_TCP_AO
@@ -1096,11 +1098,11 @@ static void tcp_v4_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 		if (!aoh)
 			return;
 
-		ao_key = tcp_ao_do_lookup(sk, addr, AF_INET,
+		ao_key = tcp_ao_do_lookup(sk, l3index, addr, AF_INET,
 					  aoh->rnext_keyid, -1, 0);
 		if (unlikely(!ao_key)) {
 			/* Send ACK with any matching MKT for the peer */
-			ao_key = tcp_ao_do_lookup(sk, addr,
+			ao_key = tcp_ao_do_lookup(sk, l3index, addr,
 						  AF_INET, -1, -1, 0);
 			/* Matching key disappeared (user removed the key?)
 			 * let the handshake timeout.
@@ -1119,9 +1121,6 @@ static void tcp_v4_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 		tcp_v4_ao_calc_key_rsk(ao_key, traffic_key, req);
 #endif
 	} else {
-		int l3index;
-
-		l3index = tcp_v4_sdif(skb) ? inet_iif(skb) : 0;
 		md5_key = tcp_md5_do_lookup(sk, l3index, addr, AF_INET);
 	}
 	/* RFC 7323 2.3
@@ -1479,6 +1478,7 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
 	const union tcp_md5_addr *addr;
 	u8 prefixlen = 32;
 	int l3index = 0;
+	bool l3flag;
 	u8 flags;
 
 	if (optlen < sizeof(cmd))
@@ -1491,6 +1491,7 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
 		return -EINVAL;
 
 	flags = cmd.tcpm_flags & TCP_MD5SIG_FLAG_IFINDEX;
+	l3flag = cmd.tcpm_flags & TCP_MD5SIG_FLAG_IFINDEX;
 
 	if (optname == TCP_MD5SIG_EXT &&
 	    cmd.tcpm_flags & TCP_MD5SIG_FLAG_PREFIX) {
@@ -1528,7 +1529,7 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
 	/* Don't allow keys for peers that have a matching TCP-AO key.
 	 * See the comment in tcp_ao_add_cmd()
 	 */
-	if (tcp_ao_required(sk, addr, AF_INET, false))
+	if (tcp_ao_required(sk, addr, AF_INET, l3flag ? l3index : -1, false))
 		return -EKEYREJECTED;
 
 	return tcp_md5_do_add(sk, addr, AF_INET, prefixlen, l3index, flags,
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index ad7a8caa7b2a..500f6ed3b8cf 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -140,6 +140,7 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 	struct dst_entry *dst;
 	__u8 rcv_wscale;
 	u32 tsoff = 0;
+	int l3index;
 
 	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_syncookies) ||
 	    !th->ack || th->rst)
@@ -214,7 +215,9 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 	treq->snt_isn = cookie;
 	treq->ts_off = 0;
 	treq->txhash = net_tx_rndhash();
-	tcp_ao_syncookie(sk, skb, treq, AF_INET6);
+
+	l3index = l3mdev_master_ifindex_by_index(sock_net(sk), ireq->ir_iif);
+	tcp_ao_syncookie(sk, skb, treq, AF_INET6, l3index);
 
 	if (IS_ENABLED(CONFIG_SMC))
 		ireq->smc_ok = 0;
diff --git a/net/ipv6/tcp_ao.c b/net/ipv6/tcp_ao.c
index 32e19b2dbda8..16e0fbc08c9f 100644
--- a/net/ipv6/tcp_ao.c
+++ b/net/ipv6/tcp_ao.c
@@ -79,21 +79,16 @@ int tcp_v6_ao_calc_key_rsk(struct tcp_ao_key *mkt, u8 *key,
 }
 EXPORT_SYMBOL_GPL(tcp_v6_ao_calc_key_rsk);
 
-struct tcp_ao_key *tcp_v6_ao_do_lookup(const struct sock *sk,
-				       const struct in6_addr *addr,
-				       int sndid, int rcvid)
-{
-	return tcp_ao_do_lookup(sk, (union tcp_ao_addr *)addr, AF_INET6,
-				sndid, rcvid, 0);
-}
-
 struct tcp_ao_key *tcp_v6_ao_lookup(const struct sock *sk,
 				    struct sock *addr_sk,
 				    int sndid, int rcvid)
 {
 	struct in6_addr *addr = &addr_sk->sk_v6_daddr;
+	int l3index = l3mdev_master_ifindex_by_index(sock_net(sk),
+						     addr_sk->sk_bound_dev_if);
 
-	return tcp_v6_ao_do_lookup(sk, addr, sndid, rcvid);
+	return tcp_ao_do_lookup(sk, l3index, (union tcp_ao_addr *)addr,
+				AF_INET6, sndid, rcvid, 0);
 }
 EXPORT_SYMBOL_GPL(tcp_v6_ao_lookup);
 
@@ -101,9 +96,12 @@ struct tcp_ao_key *tcp_v6_ao_lookup_rsk(const struct sock *sk,
 					struct request_sock *req,
 					int sndid, int rcvid)
 {
-	struct in6_addr *addr = &inet_rsk(req)->ir_v6_rmt_addr;
+	struct inet_request_sock *ireq = inet_rsk(req);
+	struct in6_addr *addr = &ireq->ir_v6_rmt_addr;
+	int l3index = l3mdev_master_ifindex_by_index(sock_net(sk), ireq->ir_iif);
 
-	return tcp_v6_ao_do_lookup(sk, addr, sndid, rcvid);
+	return tcp_ao_do_lookup(sk, l3index, (union tcp_ao_addr *)addr,
+				AF_INET6, sndid, rcvid, 0);
 }
 EXPORT_SYMBOL_GPL(tcp_v6_ao_lookup_rsk);
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 8831254e1b8c..6b39da6c477e 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -610,6 +610,7 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 	union tcp_ao_addr *addr;
 	int l3index = 0;
 	u8 prefixlen;
+	bool l3flag;
 	u8 flags;
 
 	if (optlen < sizeof(cmd))
@@ -622,6 +623,7 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 		return -EINVAL;
 
 	flags = cmd.tcpm_flags & TCP_MD5SIG_FLAG_IFINDEX;
+	l3flag = cmd.tcpm_flags & TCP_MD5SIG_FLAG_IFINDEX;
 
 	if (optname == TCP_MD5SIG_EXT &&
 	    cmd.tcpm_flags & TCP_MD5SIG_FLAG_PREFIX) {
@@ -668,7 +670,8 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 		/* Don't allow keys for peers that have a matching TCP-AO key.
 		 * See the comment in tcp_ao_add_cmd()
 		 */
-		if (tcp_ao_required(sk, addr, AF_INET, false))
+		if (tcp_ao_required(sk, addr, AF_INET,
+				    l3flag ? l3index : -1, false))
 			return -EKEYREJECTED;
 		return tcp_md5_do_add(sk, addr,
 				      AF_INET, prefixlen, l3index, flags,
@@ -680,7 +683,7 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 	/* Don't allow keys for peers that have a matching TCP-AO key.
 	 * See the comment in tcp_ao_add_cmd()
 	 */
-	if (tcp_ao_required(sk, addr, AF_INET6, false))
+	if (tcp_ao_required(sk, addr, AF_INET6, l3flag ? l3index : -1, false))
 		return -EKEYREJECTED;
 
 	return tcp_md5_do_add(sk, addr, AF_INET6, prefixlen, l3index, flags,
@@ -1231,10 +1234,14 @@ static void tcp_v6_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 			return;
 		if (!aoh)
 			return;
-		ao_key = tcp_v6_ao_do_lookup(sk, addr, aoh->rnext_keyid, -1);
+		ao_key = tcp_ao_do_lookup(sk, l3index,
+					  (union tcp_ao_addr *)addr, AF_INET6,
+					  aoh->rnext_keyid, -1, 0);
 		if (unlikely(!ao_key)) {
 			/* Send ACK with any matching MKT for the peer */
-			ao_key = tcp_v6_ao_do_lookup(sk, addr, -1, -1);
+			ao_key = tcp_ao_do_lookup(sk, l3index,
+						  (union tcp_ao_addr *)addr,
+						  AF_INET6, -1, -1, 0);
 			/* Matching key disappeared (user removed the key?)
 			 * let the handshake timeout.
 			 */
-- 
2.40.0


