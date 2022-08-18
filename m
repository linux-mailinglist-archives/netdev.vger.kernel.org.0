Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C76A35989E8
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345035AbiHRRCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345415AbiHRRAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:00:45 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B493C12E2
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:00:33 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id i129-20020a1c3b87000000b003a62f19b453so348581wma.3
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=bzvAjIxqsbuSWxvVQYwB/ai2bQg4sPuUV1WP6zstQl0=;
        b=cwNvhXU7InYzfNASws0ay4KNDcuppRcdF5xpDLQ2qIZga5uP8NYThnyjYeeOG2G6Im
         7Axen5bPQPzh1pqDft1fU5ixmy+i0yXGzQqBVIMR7MGHLUThFRJ09MXfwBnSAPzb7Vkq
         x5U9hXnwbcK+F/VPE0rdWJvRQNMn35a6vfdiBzoRKlIcd9+I9Z98w+SxZLqnxDKMYoX8
         lBfaje/9mwPFGBP3lPsa7PRFvKdc7AaTMncrAFwH7dNEN6hWQmNX/0S4GCq4v/j/4ffe
         tlLcDSJdzqAiElRpxHHnswRD9MSp72uenMUM4JmjsAzEz/1Ah9IrtB63jpoDEDCaW+n+
         +WlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=bzvAjIxqsbuSWxvVQYwB/ai2bQg4sPuUV1WP6zstQl0=;
        b=q1cpU3P4dMnvh8YlGDTzQf1RqGkSRO9g+Xq1f19H8jLNjm1gJSAqvykimNC5FRNumP
         bWzRD0oj6/fd7HD5AB3Uu1ebXnf5CBv81wWuT9xothDIO8cm3ABkIAl6Q3PrcJh1Ycyl
         NvDt7Emy3qN6LVQn3OXTmYVCUYIqKYjkV/1xUzHseNdRjNIReWTuKLjHPIYDACmhuxDW
         Ma8d1ZArxP7Z6nEDC0c6SIffE+0VQaT2/uJmjzI4ACTIdWkLITP2yolZqTCilcKAUmxY
         ytt8AcnomzCRXCjrvf22lQCRq86sRAqHSrYiJ777wfRlVM8gGkcO9MgBNMsURRILvLmF
         nHUQ==
X-Gm-Message-State: ACgBeo3BEsSfjXrGGDw+cZ6T7fzbOFejC7iawnSSN3x3nOu2OuzxnILa
        luQIy0xLfbmUy0Jhayg206YlvQ==
X-Google-Smtp-Source: AA6agR4ikO3e5wFLelRRA7cWBk7gL71dDmsR/8QX7hoiJu8u3X7tc1SpgiF59wdyD5s1GgU3jgzIFQ==
X-Received: by 2002:a05:600c:3c90:b0:3a3:8606:2df3 with SMTP id bg16-20020a05600c3c9000b003a386062df3mr5665462wmb.132.1660842032621;
        Thu, 18 Aug 2022 10:00:32 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id be13-20020a05600c1e8d00b003a511e92abcsm2662169wmb.34.2022.08.18.10.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 10:00:32 -0700 (PDT)
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
Subject: [PATCH 13/31] net/tcp: Add AO sign to RST packets
Date:   Thu, 18 Aug 2022 17:59:47 +0100
Message-Id: <20220818170005.747015-14-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220818170005.747015-1-dima@arista.com>
References: <20220818170005.747015-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
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
 include/net/tcp_ao.h |  7 ++++
 net/ipv4/tcp_ao.c    | 48 +++++++++++++++++++++++++++
 net/ipv4/tcp_ipv4.c  | 48 ++++++++++++++++++++++++++-
 net/ipv6/tcp_ipv6.c  | 77 ++++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 176 insertions(+), 4 deletions(-)

diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index b5516c83e489..35c33f7e9c27 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -117,6 +117,7 @@ int tcp_ao_hash_skb(unsigned short int family,
 		    const u8 *tkey, int hash_offset, u32 sne);
 int tcp_parse_ao(struct sock *sk, int cmd, unsigned short int family,
 		 sockptr_t optval, int optlen);
+struct tcp_ao_key *tcp_ao_do_lookup_sndid(const struct sock *sk, u8 keyid);
 int tcp_ao_calc_traffic_key(struct tcp_ao_key *mkt, u8 *key, void *ctx,
 			    unsigned int len);
 void tcp_ao_destroy_sock(struct sock *sk);
@@ -126,6 +127,12 @@ int tcp_ao_cache_traffic_keys(const struct sock *sk, struct tcp_ao_info *ao,
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
index ec3ab0c3dc77..4bdd97536610 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -409,6 +409,54 @@ static int tcp_ao_hash_skb_data(struct crypto_pool_ahash *hp,
 	return 0;
 }
 
+int tcp_ao_hash_hdr(unsigned short int family, char *ao_hash,
+		    struct tcp_ao_key *key, const u8 *tkey,
+		    const union tcp_ao_addr *daddr,
+		    const union tcp_ao_addr *saddr,
+		    const struct tcphdr *th, u32 sne)
+{
+	struct crypto_pool_ahash hp;
+	int tkey_len = tcp_ao_digest_size(key);
+	int hash_offset = ao_hash - (char *)th;
+
+	if (crypto_pool_get(key->crypto_pool_id, (struct crypto_pool *)&hp))
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
+	} else if (family == AF_INET6) {
+		if (tcp_v6_ao_hash_pseudoheader(&hp, &daddr->a6,
+						&saddr->a6, th->doff * 4))
+			goto clear_hash;
+	}
+	if (tcp_ao_hash_header(&hp, th, false,
+			       ao_hash, hash_offset, tcp_ao_maclen(key)))
+		goto clear_hash;
+	ahash_request_set_crypt(hp.req, NULL, ao_hash, 0);
+	if (crypto_ahash_final(hp.req))
+		goto clear_hash;
+
+	crypto_pool_put();
+	return 0;
+
+clear_hash:
+	crypto_pool_put();
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
index 034549c73beb..c0add782d7af 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -679,11 +679,17 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 #ifdef CONFIG_TCP_MD5SIG
 	struct tcp_md5sig_key *key = NULL;
 	const __u8 *md5_hash_location = NULL;
+	const struct tcp_ao_hdr *aoh;
 	unsigned char newhash[16];
 	int genhash;
 	struct sock *sk1 = NULL;
 #endif
 	u64 transmit_time = 0;
+#ifdef CONFIG_TCP_AO
+	struct tcp_ao_key *ao_key = NULL;
+	char traffic_key[TCP_AO_MAX_HASH_SIZE] __tcp_ao_key_align;
+	u32 ao_sne;
+#endif
 	struct sock *ctl_sk;
 	struct net *net;
 
@@ -719,7 +725,7 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	net = sk ? sock_net(sk) : dev_net(skb_dst(skb)->dev);
 #if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 	/* Invalid TCP option size or twice included auth */
-	if (tcp_parse_auth_options(tcp_hdr(skb), &md5_hash_location, NULL))
+	if (tcp_parse_auth_options(tcp_hdr(skb), &md5_hash_location, &aoh))
 		return;
 
 	rcu_read_lock();
@@ -785,6 +791,46 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 				     key, ip_hdr(skb)->saddr,
 				     ip_hdr(skb)->daddr, &rep.th);
 	}
+#endif
+#ifdef CONFIG_TCP_AO
+	if (sk && aoh && sk->sk_state != TCP_LISTEN) {
+		/* lookup key based on peer address and rcv_next*/
+		ao_key = tcp_ao_do_lookup_sndid(sk, aoh->rnext_keyid);
+
+		if (ao_key) {
+			struct tcp_ao_info *ao_info;
+			u8 keyid;
+
+			ao_info = rcu_dereference(tcp_sk(sk)->ao_info);
+
+			/* XXX: optimize by using cached traffic key depending
+			 * on socket state
+			 */
+			tcp_v4_ao_calc_key_sk(ao_key, traffic_key, sk,
+					      ao_info->lisn, ao_info->risn,
+					      true);
+
+			/* rcv_next holds the rcv_next of the peer, make keyid
+			 * hold our rcv_next
+			 */
+			keyid = ao_info->rnext_key->rcvid;
+			ao_sne = tcp_ao_compute_sne(ao_info->snd_sne,
+						    ao_info->snd_sne_seq,
+						    ntohl(rep.th.seq));
+
+			rep.opt[0] = htonl((TCPOPT_AO << 24) |
+					   (tcp_ao_len(ao_key) << 16) |
+					   (aoh->rnext_keyid << 8) | keyid);
+			arg.iov[0].iov_len += round_up(tcp_ao_len(ao_key), 4);
+			rep.th.doff = arg.iov[0].iov_len / 4;
+
+			tcp_ao_hash_hdr(AF_INET, (char *)&rep.opt[1],
+					ao_key, traffic_key,
+					(union tcp_ao_addr *)&ip_hdr(skb)->saddr,
+					(union tcp_ao_addr *)&ip_hdr(skb)->daddr,
+					&rep.th, ao_sne);
+		}
+	}
 #endif
 	/* Can't co-exist with TCPMD5, hence check rep.opt[0] */
 	if (rep.opt[0] == 0) {
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index ba968e856ca9..f5d339d5291a 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -847,7 +847,9 @@ const struct tcp_request_sock_ops tcp_request_sock_ipv6_ops = {
 static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32 seq,
 				 u32 ack, u32 win, u32 tsval, u32 tsecr,
 				 int oif, struct tcp_md5sig_key *key, int rst,
-				 u8 tclass, __be32 label, u32 priority)
+				 u8 tclass, __be32 label, u32 priority,
+				 struct tcp_ao_key *ao_key, char *tkey,
+				 u8 rcv_next, u32 ao_sne)
 {
 	const struct tcphdr *th = tcp_hdr(skb);
 	struct tcphdr *t1;
@@ -866,6 +868,13 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
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
@@ -917,6 +926,21 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
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
@@ -990,6 +1014,15 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 	__be32 label = 0;
 	u32 priority = 0;
 	struct net *net;
+	struct tcp_ao_key *ao_key = NULL;
+	u8 rcv_next = 0;
+	u32 ao_sne = 0;
+#ifdef CONFIG_TCP_AO
+	char traffic_key[TCP_AO_MAX_HASH_SIZE] __tcp_ao_key_align;
+	const struct tcp_ao_hdr *aoh;
+#else
+	u8 *traffic_key = NULL;
+#endif
 	int oif = 0;
 
 	if (th->rst)
@@ -1004,8 +1037,13 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 	net = sk ? sock_net(sk) : dev_net(skb_dst(skb)->dev);
 #if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 	/* Invalid TCP option size or twice included auth */
+#if defined(CONFIG_TCP_AO)
+	if (tcp_parse_auth_options(th, &md5_hash_location, &aoh))
+		return;
+#else
 	if (tcp_parse_auth_options(th, &md5_hash_location, NULL))
 		return;
+#endif
 
 	rcu_read_lock();
 #endif
@@ -1059,6 +1097,38 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 		ack_seq = ntohl(th->seq) + th->syn + th->fin + skb->len -
 			  (th->doff << 2);
 
+#ifdef CONFIG_TCP_AO
+	/* XXX: Not implemented for listening sockets yet. How do we
+	 * get the initial sequence numbers? Might need to pass in
+	 * the request socket.
+	 */
+	if (sk && aoh && sk->sk_state != TCP_LISTEN) {
+		struct tcp_ao_info *ao_info;
+
+		if (WARN_ON_ONCE(sk->sk_state == TCP_NEW_SYN_RECV))
+			goto out;
+
+		/* rcv_next is the peer's here */
+		ao_key = tcp_ao_do_lookup_sndid(sk, aoh->rnext_keyid);
+
+		if (ao_key) {
+			ao_info = rcu_dereference(tcp_sk(sk)->ao_info);
+
+			/* XXX: optimize by using cached traffic key depending
+			 * on socket state
+			 */
+			tcp_v6_ao_calc_key_sk(ao_key, traffic_key, sk,
+					      ao_info->lisn, ao_info->risn,
+					      true);
+
+			/* rcv_next switches to our rcv_next */
+			rcv_next = ao_info->rnext_key->rcvid;
+			ao_sne = tcp_ao_compute_sne(ao_info->snd_sne,
+						    ao_info->snd_sne_seq, seq);
+		}
+	}
+#endif
+
 	if (sk) {
 		oif = sk->sk_bound_dev_if;
 		if (sk_fullsock(sk)) {
@@ -1079,7 +1149,8 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 	}
 
 	tcp_v6_send_response(sk, skb, seq, ack_seq, 0, 0, 0, oif, key, 1,
-			     ipv6_get_dsfield(ipv6h), label, priority);
+			     ipv6_get_dsfield(ipv6h), label, priority,
+			     ao_key, traffic_key, rcv_next, ao_sne);
 
 #if  defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 out:
@@ -1093,7 +1164,7 @@ static void tcp_v6_send_ack(const struct sock *sk, struct sk_buff *skb, u32 seq,
 			    __be32 label, u32 priority)
 {
 	tcp_v6_send_response(sk, skb, seq, ack, win, tsval, tsecr, oif, key, 0,
-			     tclass, label, priority);
+			     tclass, label, priority, NULL, NULL, 0, 0);
 }
 
 static void tcp_v6_timewait_ack(struct sock *sk, struct sk_buff *skb)
-- 
2.37.2

