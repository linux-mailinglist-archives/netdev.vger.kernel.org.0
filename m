Return-Path: <netdev+bounces-10924-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD741730B4C
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 01:15:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64A98281618
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 032AD156DC;
	Wed, 14 Jun 2023 23:10:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27CF18C24
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 23:10:36 +0000 (UTC)
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E68F2950
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:10:16 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f8d86db375so13316885e9.1
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1686784214; x=1689376214;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XvwaqEZXXpnJlnhXKHYEwW4OLTgiCZ0yae1hM5t3UEk=;
        b=JSukiI0jiUk3dBvJoriSoWAQ1j06rKqSV8vMr4E1gyy6gPKfILniSX+r90qPbA+bfy
         oPb5hX3U8Tu/xPZRm4OdV3gCnANPKH/v68GsftXPnqGGMnJZkJm/kbjsIRmH8+9pJcTf
         p97BNI03gXYMNxjvR/w3EFKA7Azbjrlb/ZgEYP/7xkulqV9wyXlFMMZIki0/RolPN8gE
         0aFNGKp3htOJGbC+aHmbO+gZFjWbSV+MuAFFZAK2AUrKAdJwWEq/wsXZ29he0s4SAJsF
         WqZsrVd4rsyeKCTjqB3fq5V7mjldP8Id2XElqBGXBWIH8NNyzZyGUGVa4kUjnTyJg8pP
         pyyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686784214; x=1689376214;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XvwaqEZXXpnJlnhXKHYEwW4OLTgiCZ0yae1hM5t3UEk=;
        b=BjsmyXs1ZBiZCCGFEYL6IcAeisA79ONGqEFae3/DclpetsnW4KVBsnFaFejKfHfWHN
         0G6SbT6SOhkFCFIYlvPE8mYxpoU2gN/rUmD2UWfwM6v1gotfrMgSEpsJVL1n1ik6vPxU
         YdhqQR2GfzlRjxVh/b5GpvJboPkjmB7wJil2aoCue0LfrvRB6PjyMr14EjhLnxtc2sTQ
         wphRSft7gIy82qyUKiyUq7Qh3OWrLt8lXJ3GO7VuTVIfEGSEIAN+XYBAdbtcCR3lvoPp
         XAecxdtejQQ13jHWmXXNaz7lMEKzsskRX/Tqr3Yy5WlvB92OThBYuva0bSg+ygx4s8Jf
         BLWA==
X-Gm-Message-State: AC+VfDzaREbjZ+EAfWY9QvLTw81Hd/EmBqCWzEirO9GJi8yn+LwiWd/8
	/bjKsMALHI2PsFib+s0A6CvP8w==
X-Google-Smtp-Source: ACHHUZ75ugEMjcKn187QftNV4tE49GJAHbfh6p/WdDB+2DXF6Nd66gXqydXqvOHNF5g+tKRtjbi1XA==
X-Received: by 2002:a05:600c:290:b0:3f7:f7d5:a07f with SMTP id 16-20020a05600c029000b003f7f7d5a07fmr13201564wmk.17.1686784214412;
        Wed, 14 Jun 2023 16:10:14 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id s12-20020a7bc38c000000b003f7ba52eeccsm18725261wmj.7.2023.06.14.16.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 16:10:14 -0700 (PDT)
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
Subject: [PATCH v7 12/22] net/tcp: Verify inbound TCP-AO signed segments
Date: Thu, 15 Jun 2023 00:09:37 +0100
Message-Id: <20230614230947.3954084-13-dima@arista.com>
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

Now there is a common function to verify signature on TCP segments:
tcp_inbound_hash(). It has checks for all possible cross-interactions
with MD5 signs as well as with unsigned segments.

The rules from RFC5925 are:
(1) Any TCP segment can have at max only one signature.
(2) TCP connections can't switch between using TCP-MD5 and TCP-AO.
(3) TCP-AO connections can't stop using AO, as well as unsigned
    connections can't suddenly start using AO.

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/dropreason-core.h |  17 ++++
 include/net/tcp.h             |  53 ++++++++++-
 include/net/tcp_ao.h          |  17 ++++
 net/ipv4/tcp.c                |  39 ++-------
 net/ipv4/tcp_ao.c             | 160 ++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_ipv4.c           |  10 +--
 net/ipv6/tcp_ao.c             |  13 +++
 net/ipv6/tcp_ipv6.c           |  11 +--
 8 files changed, 277 insertions(+), 43 deletions(-)

diff --git a/include/net/dropreason-core.h b/include/net/dropreason-core.h
index 383ac5215284..0ff272d3b680 100644
--- a/include/net/dropreason-core.h
+++ b/include/net/dropreason-core.h
@@ -24,6 +24,10 @@
 	FN(TCP_MD5NOTFOUND)		\
 	FN(TCP_MD5UNEXPECTED)		\
 	FN(TCP_MD5FAILURE)		\
+	FN(TCP_AONOTFOUND)		\
+	FN(TCP_AOUNEXPECTED)		\
+	FN(TCP_AOKEYNOTFOUND)		\
+	FN(TCP_AOFAILURE)		\
 	FN(SOCKET_BACKLOG)		\
 	FN(TCP_FLAGS)			\
 	FN(TCP_ZEROWINDOW)		\
@@ -160,6 +164,19 @@ enum skb_drop_reason {
 	 * to LINUX_MIB_TCPMD5FAILURE
 	 */
 	SKB_DROP_REASON_TCP_MD5FAILURE,
+	/**
+	 * @SKB_DROP_REASON_TCP_AONOTFOUND: no TCP-AO hash and one was expected
+	 */
+	SKB_DROP_REASON_TCP_AONOTFOUND,
+	/**
+	 * @SKB_DROP_REASON_TCP_AOUNEXPECTED: TCP-AO hash is present and it
+	 * was not expected.
+	 */
+	SKB_DROP_REASON_TCP_AOUNEXPECTED,
+	/** @SKB_DROP_REASON_TCP_AOKEYNOTFOUND: TCP-AO key is unknown */
+	SKB_DROP_REASON_TCP_AOKEYNOTFOUND,
+	/** @SKB_DROP_REASON_TCP_AOFAILURE: TCP-AO hash is wrong */
+	SKB_DROP_REASON_TCP_AOFAILURE,
 	/**
 	 * @SKB_DROP_REASON_SOCKET_BACKLOG: failed to add skb to socket backlog (
 	 * see LINUX_MIB_TCPBACKLOGDROP)
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 1d38ecac9b00..b3fa6aada5c7 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1738,7 +1738,7 @@ tcp_md5_do_lookup_any_l3index(const struct sock *sk,
 enum skb_drop_reason
 tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 		     const void *saddr, const void *daddr,
-		     int family, int dif, int sdif);
+		     int family, int l3index, const __u8 *hash_location);
 
 
 #define tcp_twsk_md5_key(twsk)	((twsk)->tw_md5_key)
@@ -1760,7 +1760,7 @@ tcp_md5_do_lookup_any_l3index(const struct sock *sk,
 static inline enum skb_drop_reason
 tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 		     const void *saddr, const void *daddr,
-		     int family, int dif, int sdif)
+		     int family, int l3index, const __u8 *hash_location)
 {
 	return SKB_NOT_DROPPED_YET;
 }
@@ -2597,4 +2597,53 @@ static inline bool tcp_ao_required(struct sock *sk, const void *saddr,
 	return false;
 }
 
+/* Called with rcu_read_lock() */
+static inline enum skb_drop_reason
+tcp_inbound_hash(struct sock *sk, const struct request_sock *req,
+		 const struct sk_buff *skb,
+		 const void *saddr, const void *daddr,
+		 int family, int dif, int sdif)
+{
+	const struct tcphdr *th = tcp_hdr(skb);
+	const struct tcp_ao_hdr *aoh;
+	const __u8 *md5_location;
+	int l3index;
+
+	/* Invalid option or two times meet any of auth options */
+	if (tcp_parse_auth_options(th, &md5_location, &aoh))
+		return SKB_DROP_REASON_TCP_AUTH_HDR;
+
+	if (req) {
+		if (tcp_rsk_used_ao(req) != !!aoh)
+			return SKB_DROP_REASON_TCP_AOFAILURE;
+	}
+
+	/* sdif set, means packet ingressed via a device
+	 * in an L3 domain and dif is set to the l3mdev
+	 */
+	l3index = sdif ? dif : 0;
+
+	/* Fast path: unsigned segments */
+	if (likely(!md5_location && !aoh)) {
+		/* Drop if there's TCP-MD5 or TCP-AO key with any rcvid/sndid
+		 * for the remote peer. On TCP-AO established connection
+		 * the last key is impossible to remove, so there's
+		 * always at least one current_key.
+		 */
+		if (tcp_ao_required(sk, saddr, family))
+			return SKB_DROP_REASON_TCP_AONOTFOUND;
+		if (unlikely(tcp_md5_do_lookup(sk, l3index, saddr, family))) {
+			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5NOTFOUND);
+			return SKB_DROP_REASON_TCP_MD5NOTFOUND;
+		}
+		return SKB_NOT_DROPPED_YET;
+	}
+
+	if (aoh)
+		return tcp_inbound_ao_hash(sk, skb, family, req, aoh);
+
+	return tcp_inbound_md5_hash(sk, skb, saddr, daddr, family,
+				    l3index, md5_location);
+}
+
 #endif	/* _TCP_H */
diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index 933b39445575..880eeee4a6b9 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -116,6 +116,9 @@ struct tcp6_ao_context {
 	__be32		disn;
 };
 
+#define TCP_AO_ESTABLISHED (TCPF_ESTABLISHED|TCPF_FIN_WAIT1|TCPF_FIN_WAIT2|\
+		TCPF_CLOSE|TCPF_CLOSE_WAIT|TCPF_LAST_ACK|TCPF_CLOSING)
+
 int tcp_ao_hash_skb(unsigned short int family,
 		    char *ao_hash, struct tcp_ao_key *key,
 		    const struct sock *sk, const struct sk_buff *skb,
@@ -132,6 +135,10 @@ int tcp_ao_calc_traffic_key(struct tcp_ao_key *mkt, u8 *key, void *ctx,
 void tcp_ao_destroy_sock(struct sock *sk, bool twsk);
 u32 tcp_ao_compute_sne(u32 sne, u32 seq, u32 new_seq);
 void tcp_ao_time_wait(struct tcp_timewait_sock *tcptw, struct tcp_sock *tp);
+enum skb_drop_reason tcp_inbound_ao_hash(struct sock *sk,
+			const struct sk_buff *skb, unsigned short int family,
+			const struct request_sock *req,
+			const struct tcp_ao_hdr *aoh);
 struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
 				    const union tcp_ao_addr *addr,
 				    int family, int sndid, int rcvid, u16 port);
@@ -168,6 +175,9 @@ struct tcp_sigpool;
 int tcp_v6_ao_hash_pseudoheader(struct tcp_sigpool *hp,
 				const struct in6_addr *daddr,
 				const struct in6_addr *saddr, int nbytes);
+int tcp_v6_ao_calc_key_skb(struct tcp_ao_key *mkt, u8 *key,
+			   const struct sk_buff *skb, __be32 sisn,
+			    __be32 disn);
 int tcp_v6_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
 				 const struct sock *sk, __be32 sisn,
 				 __be32 disn, bool send);
@@ -203,6 +213,13 @@ static inline void tcp_ao_syncookie(struct sock *sk, const struct sk_buff *skb,
 {
 }
 
+static inline enum skb_drop_reason tcp_inbound_ao_hash(struct sock *sk,
+		const struct sk_buff *skb, unsigned short int family,
+		const struct request_sock *req, const struct tcp_ao_hdr *aoh)
+{
+	return SKB_NOT_DROPPED_YET;
+}
+
 static inline struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
 		const union tcp_ao_addr *addr,
 		int family, int sndid, int rcvid, u16 port)
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 66e324b0364c..20e16ada8d5d 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4477,42 +4477,23 @@ EXPORT_SYMBOL(tcp_md5_hash_key);
 enum skb_drop_reason
 tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 		     const void *saddr, const void *daddr,
-		     int family, int dif, int sdif)
+		     int family, int l3index, const __u8 *hash_location)
 {
-	/*
-	 * This gets called for each TCP segment that arrives
-	 * so we want to be efficient.
+	/* This gets called for each TCP segment that has TCP-MD5 option.
 	 * We have 3 drop cases:
 	 * o No MD5 hash and one expected.
 	 * o MD5 hash and we're not expecting one.
 	 * o MD5 hash and its wrong.
 	 */
-	const __u8 *hash_location = NULL;
-	struct tcp_md5sig_key *hash_expected;
 	const struct tcphdr *th = tcp_hdr(skb);
 	const struct tcp_sock *tp = tcp_sk(sk);
-	int genhash, l3index;
+	struct tcp_md5sig_key *key;
+	int genhash;
 	u8 newhash[16];
 
-	/* sdif set, means packet ingressed via a device
-	 * in an L3 domain and dif is set to the l3mdev
-	 */
-	l3index = sdif ? dif : 0;
+	key = tcp_md5_do_lookup(sk, l3index, saddr, family);
 
-	hash_expected = tcp_md5_do_lookup(sk, l3index, saddr, family);
-	if (tcp_parse_auth_options(th, &hash_location, NULL))
-		return SKB_DROP_REASON_TCP_AUTH_HDR;
-
-	/* We've parsed the options - do we have a hash? */
-	if (!hash_expected && !hash_location)
-		return SKB_NOT_DROPPED_YET;
-
-	if (hash_expected && !hash_location) {
-		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5NOTFOUND);
-		return SKB_DROP_REASON_TCP_MD5NOTFOUND;
-	}
-
-	if (!hash_expected && hash_location) {
+	if (!key && hash_location) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5UNEXPECTED);
 		return SKB_DROP_REASON_TCP_MD5UNEXPECTED;
 	}
@@ -4522,14 +4503,10 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 	 * IPv4-mapped case.
 	 */
 	if (family == AF_INET)
-		genhash = tcp_v4_md5_hash_skb(newhash,
-					      hash_expected,
-					      NULL, skb);
+		genhash = tcp_v4_md5_hash_skb(newhash, key, NULL, skb);
 	else
-		genhash = tp->af_specific->calc_md5_hash(newhash,
-							 hash_expected,
+		genhash = tp->af_specific->calc_md5_hash(newhash, key,
 							 NULL, skb);
-
 	if (genhash || memcmp(hash_location, newhash, 16) != 0) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5FAILURE);
 		if (family == AF_INET) {
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index a22d6321bc81..3f405bf1fd82 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -322,6 +322,30 @@ int tcp_v4_ao_calc_key_rsk(struct tcp_ao_key *mkt, u8 *key,
 				  htonl(tcp_rsk(req)->rcv_isn));
 }
 
+static int tcp_v4_ao_calc_key_skb(struct tcp_ao_key *mkt, u8 *key,
+				  const struct sk_buff *skb,
+				  __be32 sisn, __be32 disn)
+{
+	const struct iphdr *iph = ip_hdr(skb);
+	const struct tcphdr *th = tcp_hdr(skb);
+
+	return tcp_v4_ao_calc_key(mkt, key, iph->saddr, iph->daddr,
+				     th->source, th->dest, sisn, disn);
+}
+
+static int tcp_ao_calc_key_skb(struct tcp_ao_key *mkt, u8 *key,
+			       const struct sk_buff *skb, __be32 sisn,
+			       __be32 disn, int family)
+{
+	if (family == AF_INET)
+		return tcp_v4_ao_calc_key_skb(mkt, key, skb, sisn, disn);
+#if IS_ENABLED(CONFIG_IPV6)
+	else if (family == AF_INET6)
+		return tcp_v6_ao_calc_key_skb(mkt, key, skb, sisn, disn);
+#endif
+	return -EAFNOSUPPORT;
+}
+
 static int tcp_v4_ao_hash_pseudoheader(struct tcp_sigpool *hp,
 				       __be32 daddr, __be32 saddr,
 				       int nbytes)
@@ -701,6 +725,142 @@ void tcp_ao_syncookie(struct sock *sk, const struct sk_buff *skb,
 }
 EXPORT_SYMBOL_GPL(tcp_ao_syncookie);
 
+static enum skb_drop_reason
+tcp_ao_verify_hash(const struct sock *sk, const struct sk_buff *skb,
+		   unsigned short int family, struct tcp_ao_info *info,
+		   const struct tcp_ao_hdr *aoh, struct tcp_ao_key *key,
+		   u8 *traffic_key, u8 *phash, u32 sne)
+{
+	unsigned char newhash[TCP_AO_MAX_HASH_SIZE] __tcp_ao_key_align;
+	u8 maclen = aoh->length - sizeof(struct tcp_ao_hdr);
+	const struct tcphdr *th = tcp_hdr(skb);
+
+	if (maclen != tcp_ao_maclen(key))
+		return SKB_DROP_REASON_TCP_AOFAILURE;
+
+	/* XXX: make it per-AF callback? */
+	tcp_ao_hash_skb(family, newhash, key, sk, skb, traffic_key,
+			(phash - (u8 *)th), sne);
+	if (memcmp(phash, newhash, maclen))
+		return SKB_DROP_REASON_TCP_AOFAILURE;
+	return SKB_NOT_DROPPED_YET;
+}
+
+enum skb_drop_reason
+tcp_inbound_ao_hash(struct sock *sk, const struct sk_buff *skb,
+		    unsigned short int family, const struct request_sock *req,
+		    const struct tcp_ao_hdr *aoh)
+{
+	u8 key_buf[TCP_AO_MAX_HASH_SIZE] __tcp_ao_key_align;
+	const struct tcphdr *th = tcp_hdr(skb);
+	u8 *phash = (u8 *)(aoh + 1); /* hash goes just after the header */
+	struct tcp_ao_info *info;
+	struct tcp_ao_key *key;
+	__be32 sisn, disn;
+	u8 *traffic_key;
+	u32 sne = 0;
+
+	info = rcu_dereference(tcp_sk(sk)->ao_info);
+	if (!info)
+		return SKB_DROP_REASON_TCP_AOUNEXPECTED;
+
+	if (unlikely(th->syn)) {
+		sisn = th->seq;
+		disn = 0;
+	}
+
+	/* Fast-path */
+	/* TODO: fix fastopen and simultaneous open (TCPF_SYN_RECV) */
+	if (likely((1 << sk->sk_state) & (TCP_AO_ESTABLISHED | TCPF_SYN_RECV))) {
+		enum skb_drop_reason err;
+		struct tcp_ao_key *current_key;
+
+		/* Check if this socket's rnext_key matches the keyid in the
+		 * packet. If not we lookup the key based on the keyid
+		 * matching the rcvid in the mkt.
+		 */
+		key = READ_ONCE(info->rnext_key);
+		if (key->rcvid != aoh->keyid) {
+			key = tcp_ao_established_key(info, -1, aoh->keyid);
+			if (!key)
+				goto key_not_found;
+		}
+
+		/* Delayed retransmitted SYN */
+		if (unlikely(th->syn && !th->ack))
+			goto verify_hash;
+
+		sne = tcp_ao_compute_sne(info->rcv_sne, info->rcv_sne_seq,
+					 ntohl(th->seq));
+		/* Established socket, traffic key are cached */
+		traffic_key = rcv_other_key(key);
+		err = tcp_ao_verify_hash(sk, skb, family, info, aoh, key,
+					 traffic_key, phash, sne);
+		if (err)
+			return err;
+		current_key = READ_ONCE(info->current_key);
+		/* Key rotation: the peer asks us to use new key (RNext) */
+		if (unlikely(aoh->rnext_keyid != current_key->sndid)) {
+			/* If the key is not found we do nothing. */
+			key = tcp_ao_established_key(info, aoh->rnext_keyid, -1);
+			if (key)
+				/* pairs with tcp_ao_del_cmd */
+				WRITE_ONCE(info->current_key, key);
+		}
+		return SKB_NOT_DROPPED_YET;
+	}
+
+	/* Lookup key based on peer address and keyid.
+	 * current_key and rnext_key must not be used on tcp listen
+	 * sockets as otherwise:
+	 * - request sockets would race on those key pointers
+	 * - tcp_ao_del_cmd() allows async key removal
+	 */
+	key = tcp_ao_inbound_lookup(family, sk, skb, -1, aoh->keyid);
+	if (!key)
+		goto key_not_found;
+
+	if (th->syn && !th->ack)
+		goto verify_hash;
+
+	if ((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_NEW_SYN_RECV)) {
+		/* Make the initial syn the likely case here */
+		if (unlikely(req)) {
+			sne = tcp_ao_compute_sne(0, tcp_rsk(req)->rcv_isn,
+						 ntohl(th->seq));
+			sisn = htonl(tcp_rsk(req)->rcv_isn);
+			disn = htonl(tcp_rsk(req)->snt_isn);
+		} else if (unlikely(th->ack && !th->syn)) {
+			/* Possible syncookie packet */
+			sisn = htonl(ntohl(th->seq) - 1);
+			disn = htonl(ntohl(th->ack_seq) - 1);
+			sne = tcp_ao_compute_sne(0, ntohl(sisn),
+						 ntohl(th->seq));
+		} else if (unlikely(!th->syn)) {
+			/* no way to figure out initial sisn/disn - drop */
+			return SKB_DROP_REASON_TCP_FLAGS;
+		}
+	} else if (sk->sk_state == TCP_SYN_SENT) {
+		disn = info->lisn;
+		if (th->syn || th->rst)
+			sisn = th->seq;
+		else
+			sisn = info->risn;
+	} else {
+		WARN_ONCE(1, "TCP-AO: Unexpected sk_state %d", sk->sk_state);
+		return SKB_DROP_REASON_TCP_AOFAILURE;
+	}
+verify_hash:
+	traffic_key = key_buf;
+	tcp_ao_calc_key_skb(key, traffic_key, skb, sisn, disn, family);
+	return tcp_ao_verify_hash(sk, skb, family, info, aoh, key,
+				  traffic_key, phash, sne);
+
+key_not_found:
+	return SKB_DROP_REASON_TCP_AOKEYNOTFOUND;
+}
+EXPORT_SYMBOL_GPL(tcp_inbound_ao_hash);
+
 static int tcp_ao_cache_traffic_keys(const struct sock *sk,
 				     struct tcp_ao_info *ao,
 				     struct tcp_ao_key *ao_key)
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 97712b954e2d..1a0c2f1485fa 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2195,9 +2195,9 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb))
 			drop_reason = SKB_DROP_REASON_XFRM_POLICY;
 		else
-			drop_reason = tcp_inbound_md5_hash(sk, skb,
-						   &iph->saddr, &iph->daddr,
-						   AF_INET, dif, sdif);
+			drop_reason = tcp_inbound_hash(sk, req, skb,
+						       &iph->saddr, &iph->daddr,
+						       AF_INET, dif, sdif);
 		if (unlikely(drop_reason)) {
 			sk_drops_add(sk, skb);
 			reqsk_put(req);
@@ -2274,8 +2274,8 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		goto discard_and_relse;
 	}
 
-	drop_reason = tcp_inbound_md5_hash(sk, skb, &iph->saddr,
-					   &iph->daddr, AF_INET, dif, sdif);
+	drop_reason = tcp_inbound_hash(sk, NULL, skb, &iph->saddr, &iph->daddr,
+				       AF_INET, dif, sdif);
 	if (drop_reason)
 		goto discard_and_relse;
 
diff --git a/net/ipv6/tcp_ao.c b/net/ipv6/tcp_ao.c
index bc032e441ef8..32e19b2dbda8 100644
--- a/net/ipv6/tcp_ao.c
+++ b/net/ipv6/tcp_ao.c
@@ -39,6 +39,18 @@ static int tcp_v6_ao_calc_key(struct tcp_ao_key *mkt, u8 *key,
 	return tcp_ao_calc_traffic_key(mkt, key, &tmp, sizeof(tmp));
 }
 
+int tcp_v6_ao_calc_key_skb(struct tcp_ao_key *mkt, u8 *key,
+			   const struct sk_buff *skb,
+			   __be32 sisn, __be32 disn)
+{
+	const struct ipv6hdr *iph = ipv6_hdr(skb);
+	const struct tcphdr *th = tcp_hdr(skb);
+
+	return tcp_v6_ao_calc_key(mkt, key, &iph->saddr,
+				  &iph->daddr, th->source,
+				  th->dest, sisn, disn);
+}
+
 int tcp_v6_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
 			  const struct sock *sk, __be32 sisn,
 			  __be32 disn, bool send)
@@ -52,6 +64,7 @@ int tcp_v6_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
 					  &sk->sk_v6_rcv_saddr, sk->sk_dport,
 					  htons(sk->sk_num), disn, sisn);
 }
+EXPORT_SYMBOL_GPL(tcp_v6_ao_calc_key_sk);
 
 int tcp_v6_ao_calc_key_rsk(struct tcp_ao_key *mkt, u8 *key,
 			   struct request_sock *req)
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 19f644970196..cd9b3714d8a6 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1784,9 +1784,9 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		struct sock *nsk;
 
 		sk = req->rsk_listener;
-		drop_reason = tcp_inbound_md5_hash(sk, skb,
-						   &hdr->saddr, &hdr->daddr,
-						   AF_INET6, dif, sdif);
+		drop_reason = tcp_inbound_hash(sk, req, skb,
+					       &hdr->saddr, &hdr->daddr,
+					       AF_INET6, dif, sdif);
 		if (drop_reason) {
 			sk_drops_add(sk, skb);
 			reqsk_put(req);
@@ -1859,8 +1859,8 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		goto discard_and_relse;
 	}
 
-	drop_reason = tcp_inbound_md5_hash(sk, skb, &hdr->saddr, &hdr->daddr,
-					   AF_INET6, dif, sdif);
+	drop_reason = tcp_inbound_hash(sk, NULL, skb, &hdr->saddr, &hdr->daddr,
+				       AF_INET6, dif, sdif);
 	if (drop_reason)
 		goto discard_and_relse;
 
@@ -2088,6 +2088,7 @@ static const struct tcp_sock_af_ops tcp_sock_ipv6_mapped_specific = {
 	.ao_lookup	=	tcp_v6_ao_lookup,
 	.calc_ao_hash	=	tcp_v4_ao_hash_skb,
 	.ao_parse	=	tcp_v6_parse_ao,
+	.ao_calc_key_sk	=	tcp_v4_ao_calc_key_sk,
 #endif
 };
 #endif
-- 
2.40.0


