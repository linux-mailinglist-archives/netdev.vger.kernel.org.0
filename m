Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5FDA5989B1
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344703AbiHRRDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345437AbiHRRAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:00:48 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B72C993D
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:00:39 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ba1so2425938wrb.5
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=O62Wiqg8kKBA1iTPKC033PpVfS8OPxrE1Vk4Mbe3bnQ=;
        b=KTbr/a//oLCrzeM4NST2v0Tb+QuZs0Tj+lPqG7jjGr5J9EQTx7iXJ3GNrV+XuAhyf0
         KV7ol7lEsopkqUs5UKnAz844fMKg8lx+u3x9iVRxx4zftRdRwIqN6vQJQCBCzFEAU8Pd
         hOLOYXOPnBWpySSpxss/qcQ0hKczX9i22H1k8XEiGawR7/ig4Ri5aPbOkxfnDopS/8cd
         6kcwaOyQoRwtuVPMbP14/tM2ZoAegZtkQBKIqRjWNReOBl1bF4mOIazSl8jF7lVOPF5R
         /kq9nHOFTQBszYnpLFy8QAi+x3RXp2zIBEDXeYelYvWj9iHMJqJJ/4xJPQEFGvTnMXWt
         YrLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=O62Wiqg8kKBA1iTPKC033PpVfS8OPxrE1Vk4Mbe3bnQ=;
        b=YyLXkeAqFjFf8zVqvKLQ7Tod7Lc6XmU4vu32NkQpK5rEe+/djtigdUArXemc6A+D/Y
         7AcllZRmYG2XzTCMNqG8lwNL5k7BV98FpeyFjLdZNLCHpgDfu2Dzh29Xk/r8RWB6YQUb
         F+NzVUx4/9UhYg+ghF0wtIKORbgmcUpL+VAa4HWzC/3oSwg3Uyua1DK7tSbau2sll0CQ
         2ofRltgVxqmp94TuFbHp9v7i/aull6NxohP970s2Mn6tByWwxOPy9d4uF6wae7s/FZS4
         TbH1kAIgFCFJpXpckzGLYmH7ZDe0dbKlFErUUlxCllbW+CIm2K3Z7QqYKkE6mD16Vmoq
         DYQQ==
X-Gm-Message-State: ACgBeo3+g4N9FvLXo9ouKTjSQNJzMIIi4YzKLlDHyyC+88LdREDd0HRu
        IA+Y2tAcWLfUHhm+VZW/S/D2mg==
X-Google-Smtp-Source: AA6agR6baxbzTbsv2Q/YuiAjUR+hdiDT8zqEI/xsFqtQhPZpSiQSGOG3eeDrH7K4GNQw7NBvMLX00w==
X-Received: by 2002:a05:6000:22e:b0:225:33a9:3aa8 with SMTP id l14-20020a056000022e00b0022533a93aa8mr729598wrz.6.1660842038787;
        Thu, 18 Aug 2022 10:00:38 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id be13-20020a05600c1e8d00b003a511e92abcsm2662169wmb.34.2022.08.18.10.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 10:00:38 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
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
Subject: [PATCH 17/31] net/tcp: Verify inbound TCP-AO signed segments
Date:   Thu, 18 Aug 2022 17:59:51 +0100
Message-Id: <20220818170005.747015-18-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220818170005.747015-1-dima@arista.com>
References: <20220818170005.747015-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
 include/net/dropreason.h |  18 +++++
 include/net/tcp.h        |  59 +++++++++++++++-
 include/net/tcp_ao.h     |  21 ++++++
 net/ipv4/tcp.c           |  39 +++--------
 net/ipv4/tcp_ao.c        | 148 +++++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_ipv4.c      |  11 +--
 net/ipv6/tcp_ao.c        |  12 ++++
 net/ipv6/tcp_ipv6.c      |  11 +--
 8 files changed, 276 insertions(+), 43 deletions(-)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index fae9b40e54fa..b4906323b9a7 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -60,6 +60,11 @@ enum skb_drop_reason {
 	 * drop out of udp_memory_allocated.
 	 */
 	SKB_DROP_REASON_PROTO_MEM,
+	/**
+	 * @SKB_DROP_REASON_TCP_AUTH_HDR: TCP-MD5 or TCP-AO hashes are met
+	 * twice or set incorrectly.
+	 */
+	SKB_DROP_REASON_TCP_AUTH_HDR,
 	/**
 	 * @SKB_DROP_REASON_TCP_MD5NOTFOUND: no MD5 hash and one expected,
 	 * corresponding to LINUX_MIB_TCPMD5NOTFOUND
@@ -75,6 +80,19 @@ enum skb_drop_reason {
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
index 19549be29265..2e75c542e7ed 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1693,7 +1693,7 @@ tcp_md5_do_lookup_any_l3index(const struct sock *sk,
 enum skb_drop_reason
 tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 		     const void *saddr, const void *daddr,
-		     int family, int dif, int sdif);
+		     int family, int l3index, const __u8 *hash_location);
 
 
 #define tcp_twsk_md5_key(twsk)	((twsk)->tw_md5_key)
@@ -1715,7 +1715,7 @@ tcp_md5_do_lookup_any_l3index(const struct sock *sk,
 static inline enum skb_drop_reason
 tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 		     const void *saddr, const void *daddr,
-		     int family, int dif, int sdif)
+		     int family, int l3index, const __u8 *hash_location)
 {
 	return SKB_NOT_DROPPED_YET;
 }
@@ -2090,6 +2090,10 @@ struct tcp_sock_af_ops {
 						  const struct sock *sk,
 						  __be32 sisn, __be32 disn,
 						  bool send);
+	int			(*ao_calc_key_skb)(struct tcp_ao_key *mkt,
+						   u8 *key,
+						   const struct sk_buff *skb,
+						   __be32 sisn, __be32 disn);
 #endif
 };
 
@@ -2500,4 +2504,55 @@ static inline int tcp_parse_auth_options(const struct tcphdr *th,
 	return 0;
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
+#ifdef CONFIG_TCP_AO
+		if (unlikely(tcp_ao_do_lookup(sk, saddr, family, -1, -1, 0)))
+			return SKB_DROP_REASON_TCP_AONOTFOUND;
+#endif
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
index cc3f6686d5c9..7cb802de49ba 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -112,6 +112,9 @@ struct tcp6_ao_context {
 	__be32		disn;
 };
 
+#define TCP_AO_ESTABLISHED (TCPF_ESTABLISHED|TCPF_FIN_WAIT1|TCPF_FIN_WAIT2|\
+		TCPF_CLOSE|TCPF_CLOSE_WAIT|TCPF_LAST_ACK|TCPF_CLOSING)
+
 int tcp_ao_hash_skb(unsigned short int family,
 		    char *ao_hash, struct tcp_ao_key *key,
 		    const struct sock *sk, const struct sk_buff *skb,
@@ -129,6 +132,10 @@ u32 tcp_ao_compute_sne(u32 sne, u32 seq, u32 new_seq);
 void tcp_ao_time_wait(struct tcp_timewait_sock *tcptw, struct tcp_sock *tp);
 int tcp_ao_cache_traffic_keys(const struct sock *sk, struct tcp_ao_info *ao,
 			      struct tcp_ao_key *ao_key);
+enum skb_drop_reason tcp_inbound_ao_hash(struct sock *sk,
+			const struct sk_buff *skb, unsigned short int family,
+			const struct request_sock *req,
+			const struct tcp_ao_hdr *aoh);
 struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
 				    const union tcp_ao_addr *addr,
 				    int family, int sndid, int rcvid, u16 port);
@@ -150,9 +157,14 @@ int tcp_v4_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
 			  __be32 sisn, __be32 disn, bool send);
 int tcp_v4_ao_calc_key_rsk(struct tcp_ao_key *mkt, u8 *key,
 			   struct request_sock *req);
+int tcp_v4_ao_calc_key_skb(struct tcp_ao_key *mkt, u8 *key,
+			   const struct sk_buff *skb, __be32 sisn, __be32 disn);
 struct tcp_ao_key *tcp_v4_ao_lookup_rsk(const struct sock *sk,
 					struct request_sock *req,
 					int sndid, int rcvid);
+bool tcp_v4_inbound_ao_hash(struct sock *sk,
+			    struct request_sock *req,
+			    const struct sk_buff *skb);
 int tcp_v4_ao_hash_skb(char *ao_hash, struct tcp_ao_key *key,
 		       const struct sock *sk, const struct sk_buff *skb,
 		       const u8 *tkey, int hash_offset, u32 sne);
@@ -160,6 +172,9 @@ int tcp_v4_ao_hash_skb(char *ao_hash, struct tcp_ao_key *key,
 int tcp_v6_ao_hash_pseudoheader(struct crypto_pool_ahash *hp,
 				const struct in6_addr *daddr,
 				const struct in6_addr *saddr, int nbytes);
+int tcp_v6_ao_calc_key_skb(struct tcp_ao_key *mkt, u8 *key,
+			   const struct sk_buff *skb, __be32 sisn,
+			    __be32 disn);
 int tcp_v6_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
 				 const struct sock *sk, __be32 sisn,
 				 __be32 disn, bool send);
@@ -187,6 +202,12 @@ void tcp_ao_connect_init(struct sock *sk);
 
 #else /* CONFIG_TCP_AO */
 
+static inline enum skb_drop_reason tcp_inbound_ao_hash(struct sock *sk,
+		const struct sk_buff *skb, unsigned short int family,
+		const struct request_sock *req, const struct tcp_ao_hdr *aoh)
+{
+	return SKB_NOT_DROPPED_YET;
+}
 static inline struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
 		const union tcp_ao_addr *addr,
 		int family, int sndid, int rcvid, u16 port)
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index a5e94d8e8450..8df03d456ebb 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4503,42 +4503,23 @@ EXPORT_SYMBOL(tcp_md5_hash_key);
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
 	struct tcp_sock *tp = tcp_sk(sk);
-	int genhash, l3index;
+	struct tcp_md5sig_key *key;
+	int genhash;
 	u8 newhash[16];
 
-	/* sdif set, means packet ingressed via a device
-	 * in an L3 domain and dif is set to the l3mdev
-	 */
-	l3index = sdif ? dif : 0;
-
-	hash_expected = tcp_md5_do_lookup(sk, l3index, saddr, family);
-	if (tcp_parse_auth_options(th, &hash_location, NULL))
-		return true;
-
-	/* We've parsed the options - do we have a hash? */
-	if (!hash_expected && !hash_location)
-		return SKB_NOT_DROPPED_YET;
-
-	if (hash_expected && !hash_location) {
-		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5NOTFOUND);
-		return SKB_DROP_REASON_TCP_MD5NOTFOUND;
-	}
+	key = tcp_md5_do_lookup(sk, l3index, saddr, family);
 
-	if (!hash_expected && hash_location) {
+	if (!key && hash_location) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5UNEXPECTED);
 		return SKB_DROP_REASON_TCP_MD5UNEXPECTED;
 	}
@@ -4548,14 +4529,10 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
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
index 78c24ade9a03..10cd6af3c45f 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -329,6 +329,17 @@ int tcp_v4_ao_calc_key_rsk(struct tcp_ao_key *mkt, u8 *key,
 				  htonl(tcp_rsk(req)->rcv_isn));
 }
 
+int tcp_v4_ao_calc_key_skb(struct tcp_ao_key *mkt, u8 *key,
+			   const struct sk_buff *skb, __be32 sisn,
+			   __be32 disn)
+{
+	const struct iphdr *iph = ip_hdr(skb);
+	const struct tcphdr *th = tcp_hdr(skb);
+
+	return tcp_v4_ao_calc_key(mkt, key, iph->saddr, iph->daddr,
+				     th->source, th->dest, sisn, disn);
+}
+
 static int tcp_v4_ao_hash_pseudoheader(struct crypto_pool_ahash *hp,
 				       __be32 daddr, __be32 saddr,
 				       int nbytes)
@@ -618,6 +629,143 @@ struct tcp_ao_key *tcp_v4_ao_lookup(const struct sock *sk, struct sock *addr_sk,
 	return tcp_ao_do_lookup(sk, addr, AF_INET, sndid, rcvid, 0);
 }
 
+static struct tcp_ao_key *tcp_ao_inbound_lookup(unsigned short int family,
+		const struct sock *sk, const struct sk_buff *skb,
+		int sndid, int rcvid)
+{
+	if (family == AF_INET) {
+		const struct iphdr *iph = ip_hdr(skb);
+
+		return tcp_ao_do_lookup(sk, (union tcp_md5_addr *)&iph->saddr,
+				AF_INET, sndid, rcvid, 0);
+	} else {
+		const struct ipv6hdr *iph = ipv6_hdr(skb);
+
+		return tcp_ao_do_lookup(sk, (union tcp_md5_addr *)&iph->saddr,
+				AF_INET6, sndid, rcvid, 0);
+	}
+}
+
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
+	const struct tcp_sock_af_ops *ops = tcp_sk(sk)->af_specific;
+	u8 key_buf[TCP_AO_MAX_HASH_SIZE] __tcp_ao_key_align;
+	const struct tcphdr *th = tcp_hdr(skb);
+	u8 *phash = (u8 *)(aoh + 1); /* hash goes just after the header */
+	struct tcp_ao_info *info;
+	struct tcp_ao_key *key;
+	__be32 sisn, disn;
+	u8 *traffic_key;
+	u32 sne;
+
+	info = rcu_dereference(tcp_sk(sk)->ao_info);
+	if (!info)
+		return SKB_DROP_REASON_TCP_AOUNEXPECTED;
+
+	/* Fast-path */
+	/* TODO: fix fastopen and simultaneous open (TCPF_SYN_RECV) */
+	if (likely((1 << sk->sk_state) & (TCP_AO_ESTABLISHED | TCPF_SYN_RECV))) {
+		enum skb_drop_reason err;
+
+		/* Check if this socket's rnext_key matches the keyid in the
+		 * packet. If not we lookup the key based on the keyid
+		 * matching the rcvid in the mkt.
+		 */
+		key = info->rnext_key;
+		if (key->rcvid != aoh->keyid) {
+			key = tcp_ao_do_lookup_rcvid(sk, aoh->keyid);
+			if (!key)
+				goto key_not_found;
+		}
+		sne = tcp_ao_compute_sne(info->rcv_sne, info->rcv_sne_seq,
+					 ntohl(th->seq));
+		/* Established socket, traffic key are cached */
+		traffic_key = rcv_other_key(key);
+		err = tcp_ao_verify_hash(sk, skb, family, info, aoh, key,
+					 traffic_key, phash, sne);
+		if (err)
+			return err;
+		/* Key rotation: the peer asks us to use new key (RNext) */
+		if (unlikely(aoh->rnext_keyid != info->current_key->sndid)) {
+			/* If the key is not found we do nothing. */
+			key = tcp_ao_do_lookup_sndid(sk, aoh->rnext_keyid);
+			if (key)
+				/* pairs with tcp_ao_del_cmd */
+				WRITE_ONCE(info->current_key, key);
+		}
+		return SKB_NOT_DROPPED_YET;
+	}
+
+	sne = 0;
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
+	if (sk->sk_state == TCP_LISTEN) {
+		/* Make the initial syn the likely case here */
+		if (unlikely(req)) {
+			sne = tcp_ao_compute_sne(0, tcp_rsk(req)->rcv_isn,
+						 ntohl(th->seq));
+			sisn = htonl(tcp_rsk(req)->rcv_isn);
+			disn = htonl(tcp_rsk(req)->snt_isn);
+		} else {
+			sisn = th->seq;
+			disn = 0;
+		}
+	} else if (sk->sk_state == TCP_SYN_SENT) {
+		disn = info->lisn;
+		if (th->syn) {
+			sisn = th->seq;
+			if (!th->ack) {
+				/* Simultaneous connect */
+				disn = 0;
+			}
+		} else {
+			sisn = info->risn;
+		}
+	} else {
+		WARN_ONCE(1, "TCP-AO: Unknown sk_state %d", sk->sk_state);
+		return SKB_DROP_REASON_TCP_AOFAILURE;
+	}
+	traffic_key = key_buf;
+	ops->ao_calc_key_skb(key, traffic_key, skb, sisn, disn);
+	return tcp_ao_verify_hash(sk, skb, family, info, aoh, key,
+				  traffic_key, phash, sne);
+
+key_not_found:
+	return SKB_DROP_REASON_TCP_AOKEYNOTFOUND;
+}
+
 int tcp_ao_cache_traffic_keys(const struct sock *sk, struct tcp_ao_info *ao,
 			      struct tcp_ao_key *ao_key)
 {
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 02ab94461e86..a1e1a23abfea 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2172,9 +2172,9 @@ int tcp_v4_rcv(struct sk_buff *skb)
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
@@ -2250,8 +2250,8 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		goto discard_and_relse;
 	}
 
-	drop_reason = tcp_inbound_md5_hash(sk, skb, &iph->saddr,
-					   &iph->daddr, AF_INET, dif, sdif);
+	drop_reason = tcp_inbound_hash(sk, NULL, skb, &iph->saddr, &iph->daddr,
+				       AF_INET, dif, sdif);
 	if (drop_reason)
 		goto discard_and_relse;
 
@@ -2410,6 +2410,7 @@ static const struct tcp_sock_af_ops tcp_sock_ipv4_specific = {
 	.calc_ao_hash		= tcp_v4_ao_hash_skb,
 	.ao_parse		= tcp_v4_parse_ao,
 	.ao_calc_key_sk		= tcp_v4_ao_calc_key_sk,
+	.ao_calc_key_skb	= tcp_v4_ao_calc_key_skb,
 #endif
 };
 #endif
diff --git a/net/ipv6/tcp_ao.c b/net/ipv6/tcp_ao.c
index 526bbe232a64..f23c817166bb 100644
--- a/net/ipv6/tcp_ao.c
+++ b/net/ipv6/tcp_ao.c
@@ -39,6 +39,18 @@ int tcp_v6_ao_calc_key(struct tcp_ao_key *mkt, u8 *key,
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
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 16cea7de0851..8a27408549cd 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1808,9 +1808,9 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
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
@@ -1882,8 +1882,8 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		goto discard_and_relse;
 	}
 
-	drop_reason = tcp_inbound_md5_hash(sk, skb, &hdr->saddr, &hdr->daddr,
-					   AF_INET6, dif, sdif);
+	drop_reason = tcp_inbound_hash(sk, NULL, skb, &hdr->saddr, &hdr->daddr,
+				       AF_INET6, dif, sdif);
 	if (drop_reason)
 		goto discard_and_relse;
 
@@ -2075,6 +2075,7 @@ static const struct tcp_sock_af_ops tcp_sock_ipv6_specific = {
 	.calc_ao_hash	=	tcp_v6_ao_hash_skb,
 	.ao_parse	=	tcp_v6_parse_ao,
 	.ao_calc_key_sk	=	tcp_v6_ao_calc_key_sk,
+	.ao_calc_key_skb =	tcp_v6_ao_calc_key_skb,
 #endif
 };
 #endif
-- 
2.37.2

