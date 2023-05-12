Return-Path: <netdev+bounces-2273-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58CB3700FB4
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 22:26:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01436281D68
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 20:26:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DC79200A1;
	Fri, 12 May 2023 20:23:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8BC1F95D
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 20:23:34 +0000 (UTC)
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04625B8F
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 13:23:31 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-307d58b3efbso1005441f8f.0
        for <netdev@vger.kernel.org>; Fri, 12 May 2023 13:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1683923010; x=1686515010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iGLTbtfJG2YBS89eNsMlmCFY4GDm/SHDv6kwkD9qMAc=;
        b=IANjyqGx0QtkLbJTD+1x5P/O8BzOtOKE79k66V4ILce3k6kcYtQQU9kfj7c4h5ihie
         HXVMQVXgUyVtplMIU7YsTQ9UPzl6YhKVt7ev/9pvmcNaESU5zxEhnB0jkYxzB3zaIJ7N
         0QGKP3ooyJ+TCKrPKyFujTGmKg9oneAAu7ShG4Otd0VUJYs+pH+Ic6SWbmOOsXEk/8PS
         WG0qZKOKCCAOG6MEZOWKRu5AfQBFWOSqSY2Siwr6DDwWn5oBMkrUMJ4SYskDA41RFWMU
         Av8KoLdP08tk87bN+peW7xFp/0oWk+8ScdPCro9ZSmVzFSLdlgo+sLhM/bLjjm7/Uxe0
         gRYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683923010; x=1686515010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iGLTbtfJG2YBS89eNsMlmCFY4GDm/SHDv6kwkD9qMAc=;
        b=WOo8wpXusXdF1vqpFfZeT1hZy2/tA08g7VIuif5CqHNxOdyVyBHGlTHHbT4PdQvuje
         uJNb2A6HND+OLqTI/gGONYh+uINvPnhp5/6n1zbJoOJfZBhwWeQaBNQ6RVdomAphusXK
         pjZez4aS7NrYML/CitHCw1AjlEdZvDa1YiWLTl05cTb79SQVi8LPsQnw0xGr/h5Is6hx
         CVwlpbaOPqZeMWGdQFWWwvdJivsCDQswoogbR93TpOYwihVO+9Lu5HT2kI0QJQpENAxp
         hlYjA3L4d0sqwpU8f9HPNEU/iB+4RTk60o0MASbezXEph/32bUvlxlv+cyllnPtPwQks
         R0gQ==
X-Gm-Message-State: AC+VfDzWud2RAkJmv9VFSoRhlrI0g6zcGdzrrPEqWWgt9Eth5C5SKnGp
	0NUSoErBy1PBoLq3Amazh+Tm9w==
X-Google-Smtp-Source: ACHHUZ6QjMC6rQVWCWL5q1BlJiPkblBsxdYM+96fRG+nYo1MtD81WUGQ0fy79ntAKrT4aGeou/tfgw==
X-Received: by 2002:a5d:4c85:0:b0:307:904b:29e1 with SMTP id z5-20020a5d4c85000000b00307904b29e1mr13748300wrs.20.1683923010192;
        Fri, 12 May 2023 13:23:30 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n9-20020a05600c294900b003f423508c6bsm17304527wmd.44.2023.05.12.13.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 13:23:29 -0700 (PDT)
From: Dmitry Safonov <dima@arista.com>
To: linux-kernel@vger.kernel.org,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Cc: Dmitry Safonov <dima@arista.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Bob Gilligan <gilligan@arista.com>,
	Dan Carpenter <error27@gmail.com>,
	David Laight <David.Laight@aculab.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Francesco Ruggeri <fruggeri05@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Ivan Delalande <colona@arista.com>,
	Leonard Crestez <cdleonard@gmail.com>,
	Salam Noureddine <noureddine@arista.com>,
	netdev@vger.kernel.org
Subject: [PATCH v6 08/21] net/tcp: Add AO sign to RST packets
Date: Fri, 12 May 2023 21:22:58 +0100
Message-Id: <20230512202311.2845526-9-dima@arista.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230512202311.2845526-1-dima@arista.com>
References: <20230512202311.2845526-1-dima@arista.com>
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
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Wire up sending resets to TCP-AO hashing.

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp_ao.h |   8 ++++
 net/ipv4/tcp_ao.c    |  60 ++++++++++++++++++++++++-
 net/ipv4/tcp_ipv4.c  |  82 +++++++++++++++++++++++++++++-----
 net/ipv6/tcp_ipv6.c  | 102 +++++++++++++++++++++++++++++++++++++------
 4 files changed, 227 insertions(+), 25 deletions(-)

diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index 72fc87cf58bf..5b85ecd7024a 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -121,6 +121,8 @@ int tcp_ao_hash_skb(unsigned short int family,
 		    const u8 *tkey, int hash_offset, u32 sne);
 int tcp_parse_ao(struct sock *sk, int cmd, unsigned short int family,
 		 sockptr_t optval, int optlen);
+struct tcp_ao_key *tcp_ao_established_key(struct tcp_ao_info *ao,
+					  int sndid, int rcvid);
 int tcp_ao_calc_traffic_key(struct tcp_ao_key *mkt, u8 *key, void *ctx,
 			    unsigned int len);
 void tcp_ao_destroy_sock(struct sock *sk);
@@ -128,6 +130,12 @@ u32 tcp_ao_compute_sne(u32 sne, u32 seq, u32 new_seq);
 struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
 				    const union tcp_ao_addr *addr,
 				    int family, int sndid, int rcvid, u16 port);
+int tcp_ao_hash_hdr(unsigned short family, char *ao_hash,
+		struct tcp_ao_key *key, const u8 *tkey,
+		const union tcp_ao_addr *daddr,
+		const union tcp_ao_addr *saddr,
+		const struct tcphdr *th, u32 sne);
+
 /* ipv4 specific functions */
 int tcp_v4_parse_ao(struct sock *sk, int optname, sockptr_t optval, int optlen);
 struct tcp_ao_key *tcp_v4_ao_lookup(const struct sock *sk, struct sock *addr_sk,
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index 7708c994ff45..61f26e9c3fc0 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -56,8 +56,8 @@ int tcp_ao_calc_traffic_key(struct tcp_ao_key *mkt, u8 *key, void *ctx,
  * it's known that the keys in ao_info are matching peer's
  * family/address/port/VRF/etc.
  */
-static struct tcp_ao_key *tcp_ao_established_key(struct tcp_ao_info *ao,
-						 int sndid, int rcvid)
+struct tcp_ao_key *tcp_ao_established_key(struct tcp_ao_info *ao,
+					  int sndid, int rcvid)
 {
 	struct tcp_ao_key *key;
 
@@ -70,6 +70,7 @@ static struct tcp_ao_key *tcp_ao_established_key(struct tcp_ao_info *ao,
 
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(tcp_ao_established_key);
 
 static inline int ipv4_prefix_cmp(const struct in_addr *addr1,
 				  const struct in_addr *addr2,
@@ -387,6 +388,61 @@ static int tcp_ao_hash_header(struct tcp_sigpool *hp,
 	return err;
 }
 
+int tcp_ao_hash_hdr(unsigned short int family, char *ao_hash,
+		    struct tcp_ao_key *key, const u8 *tkey,
+		    const union tcp_ao_addr *daddr,
+		    const union tcp_ao_addr *saddr,
+		    const struct tcphdr *th, u32 sne)
+{
+	__u8 tmp_hash[TCP_AO_MAX_HASH_SIZE] __tcp_ao_key_align;
+	int tkey_len = tcp_ao_digest_size(key);
+	int hash_offset = ao_hash - (char *)th;
+	struct tcp_sigpool hp;
+
+	if (tcp_sigpool_start(key->tcp_sigpool_id, &hp))
+		goto clear_hash_noput;
+
+	if (crypto_ahash_setkey(crypto_ahash_reqtfm(hp.req), tkey, tkey_len))
+		goto clear_hash;
+
+	if (crypto_ahash_init(hp.req))
+		goto clear_hash;
+
+	if (tcp_ao_hash_sne(&hp, sne))
+		goto clear_hash;
+	if (family == AF_INET) {
+		if (tcp_v4_ao_hash_pseudoheader(&hp, daddr->a4.s_addr,
+						saddr->a4.s_addr, th->doff * 4))
+			goto clear_hash;
+#if IS_ENABLED(CONFIG_IPV6)
+	} else if (family == AF_INET6) {
+		if (tcp_v6_ao_hash_pseudoheader(&hp, &daddr->a6,
+						&saddr->a6, th->doff * 4))
+			goto clear_hash;
+#endif
+	} else {
+		WARN_ON_ONCE(1);
+		goto clear_hash;
+	}
+	if (tcp_ao_hash_header(&hp, th, false,
+			       ao_hash, hash_offset, tcp_ao_maclen(key)))
+		goto clear_hash;
+	ahash_request_set_crypt(hp.req, NULL, tmp_hash, 0);
+	if (crypto_ahash_final(hp.req))
+		goto clear_hash;
+
+	memcpy(ao_hash, tmp_hash, tcp_ao_maclen(key));
+	tcp_sigpool_end(&hp);
+	return 0;
+
+clear_hash:
+	tcp_sigpool_end(&hp);
+clear_hash_noput:
+	memset(ao_hash, 0, tcp_ao_maclen(key));
+	return 1;
+}
+EXPORT_SYMBOL_GPL(tcp_ao_hash_hdr);
+
 int tcp_ao_hash_skb(unsigned short int family,
 		    char *ao_hash, struct tcp_ao_key *key,
 		    const struct sock *sk, const struct sk_buff *skb,
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index a88465ed5d39..1e30161c7a09 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -684,16 +684,19 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 		__be32 opt[OPTION_BYTES / sizeof(__be32)];
 	} rep;
 	struct ip_reply_arg arg;
-#ifdef CONFIG_TCP_MD5SIG
-	struct tcp_md5sig_key *key = NULL;
-	const __u8 *md5_hash_location = NULL;
-	unsigned char newhash[16];
-	int genhash;
-	struct sock *sk1 = NULL;
-#endif
 	u64 transmit_time = 0;
 	struct sock *ctl_sk;
 	struct net *net;
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
+	const __u8 *md5_hash_location = NULL;
+	const struct tcp_ao_hdr *aoh;
+#ifdef CONFIG_TCP_MD5SIG
+	struct tcp_md5sig_key *key = NULL;
+	unsigned char newhash[16];
+	struct sock *sk1 = NULL;
+	int genhash;
+#endif
+#endif
 
 	/* Never send a reset in response to a reset. */
 	if (th->rst)
@@ -725,12 +728,14 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	arg.iov[0].iov_len  = sizeof(rep.th);
 
 	net = sk ? sock_net(sk) : dev_net(skb_dst(skb)->dev);
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 	/* Invalid TCP option size or twice included auth */
-	if (tcp_parse_auth_options(tcp_hdr(skb), &md5_hash_location, NULL))
+	if (tcp_parse_auth_options(tcp_hdr(skb), &md5_hash_location, &aoh))
 		return;
 
 	rcu_read_lock();
+#endif
+#ifdef CONFIG_TCP_MD5SIG
 	if (sk && sk_fullsock(sk)) {
 		const union tcp_md5_addr *addr;
 		int l3index;
@@ -791,6 +796,63 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 				     key, ip_hdr(skb)->saddr,
 				     ip_hdr(skb)->daddr, &rep.th);
 	}
+#endif
+#ifdef CONFIG_TCP_AO
+	/* if (!sk || sk->sk_state == TCP_LISTEN) then the initial sisn/disn
+	 * are unknown. Skip TCP-AO signing.
+	 * Contrary to TCP-MD5 unsigned RST will be sent if there was AO sign
+	 * in segment, but TCP-AO signing isn't possible for reply.
+	 */
+	if (sk && aoh && sk->sk_state != TCP_LISTEN) {
+		char traffic_key[TCP_AO_MAX_HASH_SIZE] __tcp_ao_key_align;
+		struct tcp_ao_key *ao_key, *rnext_key;
+		struct tcp_ao_info *ao_info;
+		u32 ao_sne;
+		u8 keyid;
+
+		/* TODO: reqsk support */
+		if (sk->sk_state == TCP_NEW_SYN_RECV)
+			goto skip_ao_sign;
+
+		ao_info = rcu_dereference(tcp_sk(sk)->ao_info);
+
+		if (!ao_info)
+			goto skip_ao_sign;
+
+		ao_key = tcp_ao_established_key(ao_info, aoh->rnext_keyid, -1);
+		if (!ao_key)
+			goto skip_ao_sign;
+
+		/* XXX: optimize by using cached traffic key depending
+		 * on socket state
+		 */
+		if (tcp_v4_ao_calc_key_sk(ao_key, traffic_key, sk,
+					  ao_info->lisn, ao_info->risn, true))
+			goto out;
+
+		/* rcv_next holds the rcv_next of the peer, make keyid
+		 * hold our rcv_next
+		 */
+		rnext_key = READ_ONCE(ao_info->rnext_key);
+		keyid = rnext_key->rcvid;
+		ao_sne = tcp_ao_compute_sne(ao_info->snd_sne,
+					    ao_info->snd_sne_seq,
+					    ntohl(rep.th.seq));
+
+		rep.opt[0] = htonl((TCPOPT_AO << 24) |
+				(tcp_ao_len(ao_key) << 16) |
+				(aoh->rnext_keyid << 8) | keyid);
+		arg.iov[0].iov_len += round_up(tcp_ao_len(ao_key), 4);
+		rep.th.doff = arg.iov[0].iov_len / 4;
+
+		if (tcp_ao_hash_hdr(AF_INET, (char *)&rep.opt[1],
+				    ao_key, traffic_key,
+				    (union tcp_ao_addr *)&ip_hdr(skb)->saddr,
+				    (union tcp_ao_addr *)&ip_hdr(skb)->daddr,
+				    &rep.th, ao_sne))
+			goto out;
+	}
+skip_ao_sign:
 #endif
 	/* Can't co-exist with TCPMD5, hence check rep.opt[0] */
 	if (rep.opt[0] == 0) {
@@ -848,7 +910,7 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	__TCP_INC_STATS(net, TCP_MIB_OUTRSTS);
 	local_bh_enable();
 
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 out:
 	rcu_read_unlock();
 #endif
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 0074d1f1f8a5..99ce31ef13b8 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -858,7 +858,9 @@ const struct tcp_request_sock_ops tcp_request_sock_ipv6_ops = {
 static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32 seq,
 				 u32 ack, u32 win, u32 tsval, u32 tsecr,
 				 int oif, struct tcp_md5sig_key *key, int rst,
-				 u8 tclass, __be32 label, u32 priority, u32 txhash)
+				 u8 tclass, __be32 label, u32 priority, u32 txhash,
+				 struct tcp_ao_key *ao_key, char *tkey,
+				 u8 rcv_next, u32 ao_sne)
 {
 	const struct tcphdr *th = tcp_hdr(skb);
 	struct tcphdr *t1;
@@ -877,6 +879,13 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 	if (key)
 		tot_len += TCPOLEN_MD5SIG_ALIGNED;
 #endif
+#ifdef CONFIG_TCP_AO
+	if (ao_key)
+		tot_len += tcp_ao_len(ao_key);
+#endif
+#if defined(CONFIG_TCP_MD5SIG) && defined(CONFIG_TCP_AO)
+	WARN_ON_ONCE(key && ao_key);
+#endif
 
 #ifdef CONFIG_MPTCP
 	if (rst && !key) {
@@ -928,6 +937,21 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 				    &ipv6_hdr(skb)->daddr, t1);
 	}
 #endif
+#ifdef CONFIG_TCP_AO
+	if (ao_key) {
+		*topt++ = htonl((TCPOPT_AO << 24) | (tcp_ao_len(ao_key) << 16) |
+				(ao_key->sndid << 8) | (rcv_next));
+
+		/* TODO: this is right now not going to work for listening
+		 * sockets since the socket won't have the needed ipv6
+		 * addresses
+		 */
+		tcp_ao_hash_hdr(AF_INET6, (char *)topt, ao_key, tkey,
+				(union tcp_ao_addr *)&ipv6_hdr(skb)->saddr,
+				(union tcp_ao_addr *)&ipv6_hdr(skb)->daddr,
+				t1, ao_sne);
+	}
+#endif
 
 	memset(&fl6, 0, sizeof(fl6));
 	fl6.daddr = ipv6_hdr(skb)->saddr;
@@ -992,17 +1016,28 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
 	u32 seq = 0, ack_seq = 0;
 	struct tcp_md5sig_key *key = NULL;
-#ifdef CONFIG_TCP_MD5SIG
+	__be32 label = 0;
+	u32 priority = 0;
+	struct net *net;
+	struct tcp_ao_key *ao_key = NULL;
+	u8 rcv_next = 0;
+	u32 ao_sne = 0;
+	u32 txhash = 0;
+	int oif = 0;
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 	const __u8 *md5_hash_location = NULL;
+	const struct tcp_ao_hdr *aoh;
+#endif
+#ifdef CONFIG_TCP_MD5SIG
 	unsigned char newhash[16];
 	int genhash;
 	struct sock *sk1 = NULL;
 #endif
-	__be32 label = 0;
-	u32 priority = 0;
-	struct net *net;
-	u32 txhash = 0;
-	int oif = 0;
+#ifdef CONFIG_TCP_AO
+	char traffic_key[TCP_AO_MAX_HASH_SIZE] __tcp_ao_key_align;
+#else
+	u8 *traffic_key = NULL;
+#endif
 
 	if (th->rst)
 		return;
@@ -1014,12 +1049,13 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 		return;
 
 	net = sk ? sock_net(sk) : dev_net(skb_dst(skb)->dev);
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 	/* Invalid TCP option size or twice included auth */
-	if (tcp_parse_auth_options(th, &md5_hash_location, NULL))
+	if (tcp_parse_auth_options(th, &md5_hash_location, &aoh))
 		return;
-
 	rcu_read_lock();
+#endif
+#ifdef CONFIG_TCP_MD5SIG
 	if (sk && sk_fullsock(sk)) {
 		int l3index;
 
@@ -1068,6 +1104,45 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 		ack_seq = ntohl(th->seq) + th->syn + th->fin + skb->len -
 			  (th->doff << 2);
 
+#ifdef CONFIG_TCP_AO
+	/* if (!sk || sk->sk_state == TCP_LISTEN) then the initial sisn/disn
+	 * are unknown. Skip TCP-AO signing.
+	 * Contrary to TCP-MD5 unsigned RST will be sent if there was AO sign
+	 * in segment, but TCP-AO signing isn't possible for reply.
+	 */
+	if (sk && aoh && sk->sk_state != TCP_LISTEN) {
+		struct tcp_ao_info *ao_info;
+		struct tcp_ao_key *rnext_key;
+
+		/* TODO: reqsk support */
+		if (sk->sk_state == TCP_NEW_SYN_RECV)
+			goto skip_ao_sign;
+
+		ao_info = rcu_dereference(tcp_sk(sk)->ao_info);
+		if (!ao_info)
+			goto skip_ao_sign;
+
+		/* rcv_next is the peer's here */
+		ao_key = tcp_ao_established_key(ao_info, aoh->rnext_keyid, -1);
+		if (!ao_key)
+			goto skip_ao_sign;
+
+		/* XXX: optimize by using cached traffic key depending
+		 * on socket state
+		 */
+		if (tcp_v6_ao_calc_key_sk(ao_key, traffic_key, sk,
+					  ao_info->lisn, ao_info->risn, true))
+			goto out;
+
+		/* rcv_next switches to our rcv_next */
+		rnext_key = READ_ONCE(ao_info->rnext_key);
+		rcv_next = rnext_key->rcvid;
+		ao_sne = tcp_ao_compute_sne(ao_info->snd_sne,
+					    ao_info->snd_sne_seq, seq);
+	}
+skip_ao_sign:
+#endif
+
 	if (sk) {
 		oif = sk->sk_bound_dev_if;
 		if (sk_fullsock(sk)) {
@@ -1090,9 +1165,10 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 	}
 
 	tcp_v6_send_response(sk, skb, seq, ack_seq, 0, 0, 0, oif, key, 1,
-			     ipv6_get_dsfield(ipv6h), label, priority, txhash);
+			     ipv6_get_dsfield(ipv6h), label, priority, txhash,
+			     ao_key, traffic_key, rcv_next, ao_sne);
 
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 out:
 	rcu_read_unlock();
 #endif
@@ -1104,7 +1180,7 @@ static void tcp_v6_send_ack(const struct sock *sk, struct sk_buff *skb, u32 seq,
 			    __be32 label, u32 priority, u32 txhash)
 {
 	tcp_v6_send_response(sk, skb, seq, ack, win, tsval, tsecr, oif, key, 0,
-			     tclass, label, priority, txhash);
+			     tclass, label, priority, txhash, NULL, NULL, 0, 0);
 }
 
 static void tcp_v6_timewait_ack(struct sock *sk, struct sk_buff *skb)
-- 
2.40.0


