Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7E669836E
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 19:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbjBOSee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 13:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjBOSeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 13:34:25 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B073CE3E
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:33:59 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id s13so2388421wrw.3
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:33:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8JzIKRwKriezzDbbBZ20A5iBMf1tEJLY0xwadbyPsvA=;
        b=RZ1LWtr+R0w12qksUFK6fYpmIi883+6nnaKZdnSq5ED0YIq5lLCia0xfNU0oOQ97Bx
         Iv4MrJ7QlUx5pQ5h/0oLMxBkys42649bDF4v9PnxjD9+Q6Ongxp1hIqkAX6oj1BAFhJX
         mVXWbRuBcQ9ABw0lb2ivNhdQXnAEtyE1K+rDYEwGCC08IDcCfqqgQr7smjgE/Ibhafzc
         xiwWeuc1X6nqcqLElMsX+59tVMfx9wbfxN7kgYzTaG50Copmjrq99+CiF7JNPB45GXKy
         OieD+eiHq/r/kUjoJ+2Wpdz8LxHoBVSBPeQQJc5iOrEq20Fl6PU02HLrJZmCcL8uH6Lc
         ABYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8JzIKRwKriezzDbbBZ20A5iBMf1tEJLY0xwadbyPsvA=;
        b=lS6pFxIMLu6mAk1wJnDl5sW8/pAwnH3C9KkQgxNXzcqSq/xtE2htXTVg0qriG5AaOe
         0/bbPCSD8OzVLNBzh8epJI6QwJKB9wO0yr3srh7d1i5s76wCdImQO51R+PxfcbLthfIL
         9qQ8EEsmzDKcAiCuaAlUFYmbHgbVVyiDYnSuzKIXzuPD/qGzJvAyTC1JuBK0EFm2Tj09
         /jeaSv4b1eh0Yz0+2qFuvfvuaSck5wXz5wre6RKZ33SBoz3pERIldF5/58o8ow+IxvJJ
         Cy9sPzeAwTgIMOvRcWxJLpywkabcHx7mHVgFuQcxKIYHgRBR/tqCWGGh8tYFkYpRBEia
         vUmw==
X-Gm-Message-State: AO0yUKWIduOtGA1eaMreGhEOgiFg00FsTPBa4RrSubcdUblQ4uG0kxAd
        lPHLHXwd1Sy3MpHwEkAAHit+mg==
X-Google-Smtp-Source: AK7set9XeKq0Hs+xypvtfqAzmqYP59k+AEG1xw/woVGjdMYt1Kdd3lYjPnXh8WAji/4V2UkmUolCEQ==
X-Received: by 2002:adf:f145:0:b0:2bf:c518:b060 with SMTP id y5-20020adff145000000b002bfc518b060mr2136174wro.20.1676486038203;
        Wed, 15 Feb 2023 10:33:58 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id s9-20020a05600c45c900b003e00c9888besm3196306wmo.30.2023.02.15.10.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 10:33:57 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
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
        netdev@vger.kernel.org, Francesco Ruggeri <fruggeri@arista.com>
Subject: [PATCH v4 08/21] net/tcp: Add AO sign to RST packets
Date:   Wed, 15 Feb 2023 18:33:22 +0000
Message-Id: <20230215183335.800122-9-dima@arista.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230215183335.800122-1-dima@arista.com>
References: <20230215183335.800122-1-dima@arista.com>
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

Wire up sending resets to TCP-AO hashing.

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp_ao.h |   8 ++++
 net/ipv4/tcp_ao.c    |  53 +++++++++++++++++++++++
 net/ipv4/tcp_ipv4.c  |  77 +++++++++++++++++++++++++++++----
 net/ipv6/tcp_ipv6.c  | 101 +++++++++++++++++++++++++++++++++++++------
 4 files changed, 218 insertions(+), 21 deletions(-)

diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index e600064379ae..22330ca8e58b 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -114,6 +114,8 @@ int tcp_ao_hash_skb(unsigned short int family,
 		    const u8 *tkey, int hash_offset, u32 sne);
 int tcp_parse_ao(struct sock *sk, int cmd, unsigned short int family,
 		 sockptr_t optval, int optlen);
+struct tcp_ao_key *tcp_ao_matched_key(struct tcp_ao_info *ao,
+				      int sndid, int rcvid);
 int tcp_ao_calc_traffic_key(struct tcp_ao_key *mkt, u8 *key, void *ctx,
 			    unsigned int len);
 void tcp_ao_destroy_sock(struct sock *sk);
@@ -123,6 +125,12 @@ int tcp_ao_cache_traffic_keys(const struct sock *sk, struct tcp_ao_info *ao,
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
index e8823f851bc9..f553b115c828 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -416,6 +416,59 @@ static int tcp_ao_hash_skb_data(struct tcp_sigpool *hp,
 	return 0;
 }
 
+int tcp_ao_hash_hdr(unsigned short int family, char *ao_hash,
+		    struct tcp_ao_key *key, const u8 *tkey,
+		    const union tcp_ao_addr *daddr,
+		    const union tcp_ao_addr *saddr,
+		    const struct tcphdr *th, u32 sne)
+{
+	struct tcp_sigpool hp;
+	int tkey_len = tcp_ao_digest_size(key);
+	int hash_offset = ao_hash - (char *)th;
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
+	ahash_request_set_crypt(hp.req, NULL, ao_hash, 0);
+	if (crypto_ahash_final(hp.req))
+		goto clear_hash;
+
+	tcp_sigpool_end();
+	return 0;
+
+clear_hash:
+	tcp_sigpool_end();
+clear_hash_noput:
+	memset(ao_hash, 0, tcp_ao_maclen(key));
+	return 1;
+}
+EXPORT_SYMBOL(tcp_ao_hash_hdr);
+
 int tcp_ao_hash_skb(unsigned short int family,
 		    char *ao_hash, struct tcp_ao_key *key,
 		    const struct sock *sk, const struct sk_buff *skb,
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index bda371f8c055..32001b722319 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -684,16 +684,19 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 		__be32 opt[OPTION_BYTES / sizeof(__be32)];
 	} rep;
 	struct ip_reply_arg arg;
+	u64 transmit_time = 0;
+	struct sock *ctl_sk;
+	struct net *net;
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
+	const __u8 *md5_hash_location = NULL;
+	const struct tcp_ao_hdr *aoh;
 #ifdef CONFIG_TCP_MD5SIG
 	struct tcp_md5sig_key *key = NULL;
-	const __u8 *md5_hash_location = NULL;
 	unsigned char newhash[16];
-	int genhash;
 	struct sock *sk1 = NULL;
+	int genhash;
+#endif
 #endif
-	u64 transmit_time = 0;
-	struct sock *ctl_sk;
-	struct net *net;
 
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
@@ -791,6 +796,62 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
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
+		struct tcp_ao_info *ao_info;
+		struct tcp_ao_key *ao_key;
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
+		ao_key = tcp_ao_matched_key(ao_info, aoh->rnext_keyid, -1);
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
+		keyid = ao_info->rnext_key->rcvid;
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
@@ -848,7 +909,7 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	__TCP_INC_STATS(net, TCP_MIB_OUTRSTS);
 	local_bh_enable();
 
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 out:
 	rcu_read_unlock();
 #endif
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 2970c195c917..6fcaadb9cefe 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -852,7 +852,9 @@ const struct tcp_request_sock_ops tcp_request_sock_ipv6_ops = {
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
@@ -871,6 +873,13 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
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
@@ -922,6 +931,21 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
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
@@ -986,17 +1010,28 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
 	u32 seq = 0, ack_seq = 0;
 	struct tcp_md5sig_key *key = NULL;
-#ifdef CONFIG_TCP_MD5SIG
-	const __u8 *md5_hash_location = NULL;
-	unsigned char newhash[16];
-	int genhash;
-	struct sock *sk1 = NULL;
-#endif
 	__be32 label = 0;
 	u32 priority = 0;
 	struct net *net;
+	struct tcp_ao_key *ao_key = NULL;
+	u8 rcv_next = 0;
+	u32 ao_sne = 0;
 	u32 txhash = 0;
 	int oif = 0;
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
+	const __u8 *md5_hash_location = NULL;
+	const struct tcp_ao_hdr *aoh;
+#endif
+#ifdef CONFIG_TCP_MD5SIG
+	unsigned char newhash[16];
+	int genhash;
+	struct sock *sk1 = NULL;
+#endif
+#ifdef CONFIG_TCP_AO
+	char traffic_key[TCP_AO_MAX_HASH_SIZE] __tcp_ao_key_align;
+#else
+	u8 *traffic_key = NULL;
+#endif
 
 	if (th->rst)
 		return;
@@ -1008,12 +1043,13 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
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
 
@@ -1062,6 +1098,44 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
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
+		ao_key = tcp_ao_matched_key(ao_info, aoh->rnext_keyid, -1);
+		if (!ao_key)
+			goto skip_ao_sign;
+
+
+		/* XXX: optimize by using cached traffic key depending
+		 * on socket state
+		 */
+		if (tcp_v6_ao_calc_key_sk(ao_key, traffic_key, sk,
+					  ao_info->lisn, ao_info->risn, true))
+			goto out;
+
+		/* rcv_next switches to our rcv_next */
+		rcv_next = ao_info->rnext_key->rcvid;
+		ao_sne = tcp_ao_compute_sne(ao_info->snd_sne,
+					    ao_info->snd_sne_seq, seq);
+	}
+skip_ao_sign:
+#endif
+
 	if (sk) {
 		oif = sk->sk_bound_dev_if;
 		if (sk_fullsock(sk)) {
@@ -1084,9 +1158,10 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
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
@@ -1098,7 +1173,7 @@ static void tcp_v6_send_ack(const struct sock *sk, struct sk_buff *skb, u32 seq,
 			    __be32 label, u32 priority, u32 txhash)
 {
 	tcp_v6_send_response(sk, skb, seq, ack, win, tsval, tsecr, oif, key, 0,
-			     tclass, label, priority, txhash);
+			     tclass, label, priority, txhash, NULL, NULL, 0, 0);
 }
 
 static void tcp_v6_timewait_ack(struct sock *sk, struct sk_buff *skb)
-- 
2.39.1

