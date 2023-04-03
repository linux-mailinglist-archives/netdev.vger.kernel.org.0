Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1B046D5391
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 23:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbjDCVfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 17:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233455AbjDCVew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 17:34:52 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B3F46AB
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 14:34:35 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id m2so30779701wrh.6
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 14:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1680557674;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gv2yYhhTsJPUrivO+k3LyiqizAXoZRwEd23dTrBvE1M=;
        b=UV3e4vfghnPp9MJvS2wFH42sQSDv/dKIMGf7zr3StV1hsNzkXaoKQHAJrJQSkFYnLT
         SjP8IB2omYic/iTeehUPpsuUkLj553LpCYMXEaNH9w9eK9yAAR5OtCTc1N8Y/+0SRT1R
         gNbmqIahl2z9PAgF5JMgCEmRor5/2N726X16nvad2doLksFgdgbEvA+HcjO53SOSQVhb
         B7uz0+90unzVUh6ktok7OP3/nlCP/y+lFF9jHlwL41Z/jJCiMllpuKB3tZrYHO3komPJ
         5926D3QU7scN158M+UORFl3nWNQl0uA4r66NRoZQzNgbD/BunxWbkm4IgfJYRIbyUbBa
         zBDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680557674;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gv2yYhhTsJPUrivO+k3LyiqizAXoZRwEd23dTrBvE1M=;
        b=xDEfgOj1uP6SDPSf9Dwqqrb169LI7gv6BAsrJCnjeAiiolLECFVLaE9PcM7PYpYdgA
         SogxKfxkPthA6ZhMcCxC9228dYIqS9TnTXloZ891T4K3Ilp7vE1A5OpDdjS81vNKGQ2h
         P1xVi2qiyIMZawldT9yZdIheFsLZEab8tTm2KImouJYqlrWjLkzSRTPNDw5Qhv1cJLC/
         rATD+Wlu68PVq7t/hbseh/iyIDFVm8luC23bC6mrmIrGT7f2oAILtbDkeNQGGOwKBEdH
         JrtlJqdaNjJn1UkKDLYx0aNrRMmpjmrZXtMmKPxGlHKBjwRV7uIhSSewu42YXL7X7y7E
         55eg==
X-Gm-Message-State: AAQBX9cmnx1jEIrppapueTDmybm7ajb7upXiOge2sMqRq1Imw6WrMlDc
        X1NxDySr1ko3zW33B1NCl+NjAw==
X-Google-Smtp-Source: AKy350bLJ1/DKdcbcN92FS9Q3tU+iXAalyr6wBQS58elcnBQ69KKSQhL0DSQ6oACFVeRxUvHv/QMig==
X-Received: by 2002:a5d:6b91:0:b0:2e5:9101:e3af with SMTP id n17-20020a5d6b91000000b002e59101e3afmr830wrx.31.1680557674310;
        Mon, 03 Apr 2023 14:34:34 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id o5-20020a5d4a85000000b002c3f9404c45sm10682740wrq.7.2023.04.03.14.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 14:34:33 -0700 (PDT)
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
        netdev@vger.kernel.org, Francesco Ruggeri <fruggeri@arista.com>
Subject: [PATCH v5 05/21] net/tcp: Calculate TCP-AO traffic keys
Date:   Mon,  3 Apr 2023 22:34:04 +0100
Message-Id: <20230403213420.1576559-6-dima@arista.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403213420.1576559-1-dima@arista.com>
References: <20230403213420.1576559-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add traffic key calculation the way it's described in RFC5926.
Wire it up to tcp_finish_connect() and cache the new keys straight away
on already established TCP connections.

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp.h     |   5 ++
 include/net/tcp_ao.h  |  42 ++++++++-
 net/ipv4/tcp_ao.c     | 196 ++++++++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_input.c  |   1 +
 net/ipv4/tcp_ipv4.c   |   1 +
 net/ipv4/tcp_output.c |   1 +
 net/ipv6/tcp_ao.c     |  40 +++++++++
 net/ipv6/tcp_ipv6.c   |   1 +
 8 files changed, 286 insertions(+), 1 deletion(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index fe3c0366db56..6d5ca08ab0c5 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2118,6 +2118,11 @@ struct tcp_sock_af_ops {
 	struct tcp_ao_key	*(*ao_lookup)(const struct sock *sk,
 					      struct sock  *addr_sk,
 					      int sndid, int rcvid);
+	int			(*ao_calc_key_sk)(struct tcp_ao_key *mkt,
+						  u8 *key,
+						  const struct sock *sk,
+						  __be32 sisn, __be32 disn,
+						  bool send);
 #endif
 };
 
diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index 73f584b499f6..1172d9d9517a 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -95,8 +95,30 @@ struct tcp_ao_info {
 };
 
 #ifdef CONFIG_TCP_AO
+/* TCP-AO structures and functions */
+
+struct tcp4_ao_context {
+	__be32		saddr;
+	__be32		daddr;
+	__be16		sport;
+	__be16		dport;
+	__be32		sisn;
+	__be32		disn;
+};
+
+struct tcp6_ao_context {
+	struct in6_addr	saddr;
+	struct in6_addr	daddr;
+	__be16		sport;
+	__be16		dport;
+	__be32		sisn;
+	__be32		disn;
+};
+
 int tcp_parse_ao(struct sock *sk, int cmd, unsigned short int family,
 		 sockptr_t optval, int optlen);
+int tcp_ao_calc_traffic_key(struct tcp_ao_key *mkt, u8 *key, void *ctx,
+			    unsigned int len);
 void tcp_ao_destroy_sock(struct sock *sk);
 struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
 				    const union tcp_ao_addr *addr,
@@ -105,13 +127,23 @@ struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
 int tcp_v4_parse_ao(struct sock *sk, int optname, sockptr_t optval, int optlen);
 struct tcp_ao_key *tcp_v4_ao_lookup(const struct sock *sk, struct sock *addr_sk,
 				    int sndid, int rcvid);
+int tcp_v4_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
+			  const struct sock *sk,
+			  __be32 sisn, __be32 disn, bool send);
 /* ipv6 specific functions */
+int tcp_v6_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
+				 const struct sock *sk, __be32 sisn,
+				 __be32 disn, bool send);
 struct tcp_ao_key *tcp_v6_ao_lookup(const struct sock *sk,
 				    struct sock *addr_sk,
 				    int sndid, int rcvid);
 int tcp_v6_parse_ao(struct sock *sk, int cmd,
 		    sockptr_t optval, int optlen);
-#else
+void tcp_ao_finish_connect(struct sock *sk, struct sk_buff *skb);
+void tcp_ao_connect_init(struct sock *sk);
+
+#else /* CONFIG_TCP_AO */
+
 static inline struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
 		const union tcp_ao_addr *addr,
 		int family, int sndid, int rcvid, u16 port)
@@ -122,6 +154,14 @@ static inline struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
 static inline void tcp_ao_destroy_sock(struct sock *sk)
 {
 }
+
+static inline void tcp_ao_finish_connect(struct sock *sk, struct sk_buff *skb)
+{
+}
+
+static inline void tcp_ao_connect_init(struct sock *sk)
+{
+}
 #endif
 
 #endif /* _TCP_AO_H */
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index f12937436377..da0ff96fa3d5 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -16,6 +16,42 @@
 #include <net/tcp.h>
 #include <net/ipv6.h>
 
+int tcp_ao_calc_traffic_key(struct tcp_ao_key *mkt, u8 *key, void *ctx,
+			    unsigned int len)
+{
+	struct tcp_sigpool hp;
+	struct scatterlist sg;
+	int ret;
+
+	if (tcp_sigpool_start(mkt->tcp_sigpool_id, &hp))
+		goto clear_hash_noput;
+
+	if (crypto_ahash_setkey(crypto_ahash_reqtfm(hp.req),
+				mkt->key, mkt->keylen))
+		goto clear_hash;
+
+	ret = crypto_ahash_init(hp.req);
+	if (ret)
+		goto clear_hash;
+
+	sg_init_one(&sg, ctx, len);
+	ahash_request_set_crypt(hp.req, &sg, key, len);
+	crypto_ahash_update(hp.req);
+
+	/* TODO: Revisit on how to get different output length */
+	ret = crypto_ahash_final(hp.req);
+	if (ret)
+		goto clear_hash;
+
+	tcp_sigpool_end();
+	return 0;
+clear_hash:
+	tcp_sigpool_end();
+clear_hash_noput:
+	memset(key, 0, tcp_ao_digest_size(mkt));
+	return 1;
+}
+
 /* Optimized version of tcp_ao_do_lookup(): only for sockets for which
  * it's known that the keys in ao_info are matching peer's
  * family/address/port/VRF/etc.
@@ -172,6 +208,62 @@ void tcp_ao_destroy_sock(struct sock *sk)
 	kfree_rcu(ao, rcu);
 }
 
+/* 4 tuple and ISNs are expected in NBO */
+static int tcp_v4_ao_calc_key(struct tcp_ao_key *mkt, u8 *key,
+			      __be32 saddr, __be32 daddr,
+			      __be16 sport, __be16 dport,
+			      __be32 sisn,  __be32 disn)
+{
+	/* See RFC5926 3.1.1 */
+	struct kdf_input_block {
+		u8                      counter;
+		u8                      label[6];
+		struct tcp4_ao_context	ctx;
+		__be16                  outlen;
+	} __packed tmp;
+
+	tmp.counter	= 1;
+	memcpy(tmp.label, "TCP-AO", 6);
+	tmp.ctx.saddr	= saddr;
+	tmp.ctx.daddr	= daddr;
+	tmp.ctx.sport	= sport;
+	tmp.ctx.dport	= dport;
+	tmp.ctx.sisn	= sisn;
+	tmp.ctx.disn	= disn;
+	tmp.outlen	= htons(tcp_ao_digest_size(mkt) * 8); /* in bits */
+
+	return tcp_ao_calc_traffic_key(mkt, key, &tmp, sizeof(tmp));
+}
+
+int tcp_v4_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
+			  const struct sock *sk,
+			  __be32 sisn, __be32 disn, bool send)
+{
+	if (send)
+		return tcp_v4_ao_calc_key(mkt, key, sk->sk_rcv_saddr,
+					  sk->sk_daddr, htons(sk->sk_num),
+					  sk->sk_dport, sisn, disn);
+	else
+		return tcp_v4_ao_calc_key(mkt, key, sk->sk_daddr,
+					  sk->sk_rcv_saddr, sk->sk_dport,
+					  htons(sk->sk_num), disn, sisn);
+}
+EXPORT_SYMBOL_GPL(tcp_v4_ao_calc_key_sk);
+
+static int tcp_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
+			      const struct sock *sk,
+			      __be32 sisn, __be32 disn, bool send)
+{
+	if (mkt->family == AF_INET)
+		return tcp_v4_ao_calc_key_sk(mkt, key, sk, sisn, disn, send);
+#if IS_ENABLED(CONFIG_IPV6)
+	else if (mkt->family == AF_INET6)
+		return tcp_v6_ao_calc_key_sk(mkt, key, sk, sisn, disn, send);
+#endif
+	else
+		return -EOPNOTSUPP;
+}
+
 struct tcp_ao_key *tcp_v4_ao_lookup(const struct sock *sk, struct sock *addr_sk,
 				    int sndid, int rcvid)
 {
@@ -180,6 +272,104 @@ struct tcp_ao_key *tcp_v4_ao_lookup(const struct sock *sk, struct sock *addr_sk,
 	return tcp_ao_do_lookup(sk, addr, AF_INET, sndid, rcvid, 0);
 }
 
+static int tcp_ao_cache_traffic_keys(const struct sock *sk,
+				     struct tcp_ao_info *ao,
+				     struct tcp_ao_key *ao_key)
+{
+	u8 *traffic_key = snd_other_key(ao_key);
+	int ret;
+
+	ret = tcp_ao_calc_key_sk(ao_key, traffic_key, sk,
+				 ao->lisn, ao->risn, true);
+	if (ret)
+		return ret;
+
+	traffic_key = rcv_other_key(ao_key);
+	ret = tcp_ao_calc_key_sk(ao_key, traffic_key, sk,
+				 ao->lisn, ao->risn, false);
+	return ret;
+}
+
+void tcp_ao_connect_init(struct sock *sk)
+{
+	struct tcp_ao_info *ao_info;
+	struct tcp_ao_key *key;
+	struct tcp_sock *tp = tcp_sk(sk);
+	union tcp_ao_addr *addr;
+	int family;
+
+	ao_info = rcu_dereference_protected(tp->ao_info,
+					    lockdep_sock_is_held(sk));
+	if (!ao_info)
+		return;
+
+	/* Remove all keys that don't match the peer */
+	family = sk->sk_family;
+	if (family == AF_INET)
+		addr = (union tcp_ao_addr *)&sk->sk_daddr;
+#if IS_ENABLED(CONFIG_IPV6)
+	else if (family == AF_INET6)
+		addr = (union tcp_ao_addr *)&sk->sk_v6_daddr;
+#endif
+	else
+		return;
+
+	hlist_for_each_entry_rcu(key, &ao_info->head, node) {
+		if (tcp_ao_key_cmp(key, addr, key->prefixlen, family,
+				   -1, -1, sk->sk_dport) == 0)
+			continue;
+
+		if (key == ao_info->current_key)
+			ao_info->current_key = NULL;
+		if (key == ao_info->rnext_key)
+			ao_info->rnext_key = NULL;
+		hlist_del_rcu(&key->node);
+		tcp_sigpool_release(key->tcp_sigpool_id);
+		atomic_sub(tcp_ao_sizeof_key(key), &sk->sk_omem_alloc);
+		kfree_rcu(key, rcu);
+	}
+
+	key = tp->af_specific->ao_lookup(sk, sk, -1, -1);
+	if (key) {
+		/* if current_key or rnext_key were not provided,
+		 * use the first key matching the peer
+		 */
+		if (!ao_info->current_key)
+			ao_info->current_key = key;
+		if (!ao_info->rnext_key)
+			ao_info->rnext_key = key;
+		tp->tcp_header_len += tcp_ao_len(key);
+
+		ao_info->lisn = htonl(tp->write_seq);
+		ao_info->snd_sne = 0;
+		ao_info->snd_sne_seq = tp->write_seq;
+	} else {
+		/* TODO: probably, it should fail to connect() here */
+		rcu_assign_pointer(tp->ao_info, NULL);
+		kfree(ao_info);
+	}
+}
+
+void tcp_ao_finish_connect(struct sock *sk, struct sk_buff *skb)
+{
+	struct tcp_ao_info *ao;
+	struct tcp_ao_key *key;
+
+	ao = rcu_dereference_protected(tcp_sk(sk)->ao_info,
+				       lockdep_sock_is_held(sk));
+	if (!ao)
+		return;
+
+	ao->risn = tcp_hdr(skb)->seq;
+
+	ao->rcv_sne = 0;
+	ao->rcv_sne_seq = ntohl(tcp_hdr(skb)->seq);
+
+	hlist_for_each_entry_rcu(key, &ao->head, node) {
+		tcp_ao_cache_traffic_keys(sk, ao, key);
+	}
+}
+
 static bool tcp_ao_can_set_current_rnext(struct sock *sk)
 {
 	struct tcp_ao_info *ao_info;
@@ -540,6 +730,12 @@ static int tcp_ao_add_cmd(struct sock *sk, unsigned short int family,
 	if (ret < 0)
 		goto err_free_sock;
 
+	/* Change this condition if we allow adding keys in states
+	 * like close_wait, syn_sent or fin_wait...
+	 */
+	if (sk->sk_state == TCP_ESTABLISHED)
+		tcp_ao_cache_traffic_keys(sk, ao_info, key);
+
 	tcp_ao_link_mkt(ao_info, key);
 	if (first) {
 		sk_gso_disable(sk);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index cc072d2cfcd8..6baeb3fe4352 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6064,6 +6064,7 @@ void tcp_finish_connect(struct sock *sk, struct sk_buff *skb)
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
 
+	tcp_ao_finish_connect(sk, skb);
 	tcp_set_state(sk, TCP_ESTABLISHED);
 	icsk->icsk_ack.lrcvtime = tcp_jiffies32;
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index e40baf3e8e29..c03510a24ce0 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2278,6 +2278,7 @@ static const struct tcp_sock_af_ops tcp_sock_ipv4_specific = {
 #ifdef CONFIG_TCP_AO
 	.ao_lookup		= tcp_v4_ao_lookup,
 	.ao_parse		= tcp_v4_parse_ao,
+	.ao_calc_key_sk		= tcp_v4_ao_calc_key_sk,
 #endif
 };
 #endif
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 9977e58a5587..260edb2a6b3c 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3663,6 +3663,7 @@ static void tcp_connect_init(struct sock *sk)
 	if (tp->af_specific->md5_lookup(sk, sk))
 		tp->tcp_header_len += TCPOLEN_MD5SIG_ALIGNED;
 #endif
+	tcp_ao_connect_init(sk);
 
 	/* If user gave his TCP_MAXSEG, record it to clamp */
 	if (tp->rx_opt.user_mss)
diff --git a/net/ipv6/tcp_ao.c b/net/ipv6/tcp_ao.c
index 3d2be5f73cf0..2be0103fc4f8 100644
--- a/net/ipv6/tcp_ao.c
+++ b/net/ipv6/tcp_ao.c
@@ -12,6 +12,46 @@
 #include <net/tcp.h>
 #include <net/ipv6.h>
 
+static int tcp_v6_ao_calc_key(struct tcp_ao_key *mkt, u8 *key,
+			      const struct in6_addr *saddr,
+			      const struct in6_addr *daddr,
+			      __be16 sport, __be16 dport,
+			      __be32 sisn, __be32 disn)
+{
+	struct kdf_input_block {
+		u8			counter;
+		u8			label[6];
+		struct tcp6_ao_context	ctx;
+		__be16			outlen;
+	} __packed tmp;
+
+	tmp.counter	= 1;
+	memcpy(tmp.label, "TCP-AO", 6);
+	tmp.ctx.saddr	= *saddr;
+	tmp.ctx.daddr	= *daddr;
+	tmp.ctx.sport	= sport;
+	tmp.ctx.dport	= dport;
+	tmp.ctx.sisn	= sisn;
+	tmp.ctx.disn	= disn;
+	tmp.outlen	= htons(tcp_ao_digest_size(mkt) * 8); /* in bits */
+
+	return tcp_ao_calc_traffic_key(mkt, key, &tmp, sizeof(tmp));
+}
+
+int tcp_v6_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
+			  const struct sock *sk, __be32 sisn,
+			  __be32 disn, bool send)
+{
+	if (send)
+		return tcp_v6_ao_calc_key(mkt, key, &sk->sk_v6_rcv_saddr,
+					  &sk->sk_v6_daddr, htons(sk->sk_num),
+					  sk->sk_dport, sisn, disn);
+	else
+		return tcp_v6_ao_calc_key(mkt, key, &sk->sk_v6_daddr,
+					  &sk->sk_v6_rcv_saddr, sk->sk_dport,
+					  htons(sk->sk_num), disn, sisn);
+}
+
 struct tcp_ao_key *tcp_v6_ao_do_lookup(const struct sock *sk,
 				       const struct in6_addr *addr,
 				       int sndid, int rcvid)
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 93ee479814bb..4e48818c1821 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1918,6 +1918,7 @@ static const struct tcp_sock_af_ops tcp_sock_ipv6_specific = {
 #ifdef CONFIG_TCP_AO
 	.ao_lookup	=	tcp_v6_ao_lookup,
 	.ao_parse	=	tcp_v6_parse_ao,
+	.ao_calc_key_sk	=	tcp_v6_ao_calc_key_sk,
 #endif
 };
 #endif
-- 
2.40.0

