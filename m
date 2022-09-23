Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 759FB5E8331
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 22:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbiIWUOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 16:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbiIWUOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 16:14:14 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A660913198D
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:13:47 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id c11so1517998wrp.11
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Gwk7y6+9fQedspq4kAQ4fViP5C+CzjacyJd2i7Ofklc=;
        b=RcVHIumYEjNXerGAWH7MzSE+KDkuom8trki08Mvzc/EGMlIgC+kd2TtLqyKonksZVs
         IhfzhDYhp1SpgWf7ssDD9wvmsrm6C02HE3j7f8U+jjNgtE4/h17ocyDqETHs0Ir9S2Ss
         wZ5OEcStzi2fKQlB0THHhfNETfTtauSBn81XQrkLVChH3pnGu835OFU06UQ60XTGqL3K
         VysXXlxJGhY0bZLoJGMeirAaDRkE3EIcj56I8vC+UFD693c9hfGcOrS2bvsRSYuh7NO0
         lq1XeaHVE9yqTDlhX4mT3Zl2czP2phG14Bss+e2FoL5GEZjXXJUO5mJpBKQtC5kOMzl0
         168w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Gwk7y6+9fQedspq4kAQ4fViP5C+CzjacyJd2i7Ofklc=;
        b=qroua6z+7kGy+W5CaYAN3Xg9p7G1IkVelUsvJ5zI+bdAaKTlLuVBKNbqw68jlqA67z
         gDXTvCVf+9fRM3PJMceQJi0XsDRh9aKuiT43JpbhLHREJ7j/1b6LEABYCYch3BehEcEe
         LWoWeXSmJSi7JsifNNVh5hoopzcU8eO1kN3eTLpTYGercudVuEue0T7Fd8YC8KZkieo0
         HmkAOB/9NIJ3l5YEwmCMyZVWYrroaOqewFaavgKJR7bQ+HNtZK/MRAJ6AvXK47IN3es+
         TzprEx0tYeSf8dQ/X2KcLFWtvCFxW2YQzhIwnkjbtLIhjBPddiX92lEp3xvTEPbtXWuy
         DiMQ==
X-Gm-Message-State: ACrzQf201z/QdIWg8/IiKaBhn1LNiQBNgFLaHSK7Umd5hIcKrj94ICFR
        9uR8y9olbff5MEGrI/mwvuhqag==
X-Google-Smtp-Source: AMsMyM5r4PXH954yOnvI2ve4VrBK9CENdToMKhlZfyn4n2tcC4qp9SB8cwvl0ojoXC/6cG5WYwS1BA==
X-Received: by 2002:a05:6000:144a:b0:229:b76f:86f9 with SMTP id v10-20020a056000144a00b00229b76f86f9mr6419109wrx.613.1663964027100;
        Fri, 23 Sep 2022 13:13:47 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id k11-20020a05600c0b4b00b003b492753826sm3281056wmr.43.2022.09.23.13.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:13:46 -0700 (PDT)
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
Subject: [PATCH v2 13/35] net/tcp: Add AO sign to RST packets
Date:   Fri, 23 Sep 2022 21:12:57 +0100
Message-Id: <20220923201319.493208-14-dima@arista.com>
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

Wire up sending resets to TCP-AO hashing.

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp_ao.h |  7 ++++
 net/ipv4/tcp_ao.c    | 53 ++++++++++++++++++++++++++++++
 net/ipv4/tcp_ipv4.c  | 48 ++++++++++++++++++++++++++-
 net/ipv6/tcp_ipv6.c  | 77 ++++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 181 insertions(+), 4 deletions(-)

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
index 74cbc13f62f4..1fd7d3499d7a 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -421,6 +421,59 @@ static int tcp_ao_hash_skb_data(struct crypto_pool_ahash *hp,
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
index b54a2017b84f..32cff30c4455 100644
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

