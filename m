Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1334F5E8326
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 22:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbiIWUOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 16:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232552AbiIWUNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 16:13:49 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14B01319A8
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:13:43 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id c11so1517605wrp.11
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=h0FL56uVulhtmbbpiJvus6IuL783SBLLt8TwMSra3Eg=;
        b=a9MxjaTz+q7biV8XRtiomlva8Y7RCXzQH1SHhUCz2QHBf8BBDFzVzlnGIMVbtdDYab
         6JcpVWqMtdV5TudlIC1E2UNH9D55D5DYrU+CBGHZlT/RlRlrIRavR/UhptSoniJo/+17
         vvDbEiKPeWnGHDs64+7VdX0BfJMB9PitrKajZrMKpUG5X2IaPqOphF+Ly3QOHHf8wxv/
         cKRCCbC7PfNdL3K3YwoqETP2P0MlcxoqA4WbsZ2+hCTAP3PjvhzAjn2F/jyJWpKC35xI
         c/0Wr6t/XeBcnpb0AOwlKSYvSF0jqQiZz95qRr1yfcGEUndPN4Dp4iHfmgAom2lK8jF+
         VIGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=h0FL56uVulhtmbbpiJvus6IuL783SBLLt8TwMSra3Eg=;
        b=FTCh95o5SRKOcvLef1x5CifObY9dxUifOGBTQ/Hf+YGcW8+lbRpW/2npbKqxUSSshC
         ME6WDtRLiU+47GNjEqiMszX8XjbG01QvBGG4G3/EEoK7/Y4HAu60iIG8DMLEWbMFMvO4
         c/HgHURmES9JNmw63pR4RInbnRDdqP0V3FBNrGrIBitXNkPftTTFf+tCkFBynBZsNqwS
         THIw9Lzwe/yIAGAaWKpE8JCC896KM8xN+Jjkrhf3hCWWyRWHEPHejhM07s1E2OYYOi4s
         VGl35fs5CvUzwsjATcIlJVKHb0KoiztbwLWSoUWcV3eYNjQhDizdZMWtgfWFAm6ZOC9X
         Fd6g==
X-Gm-Message-State: ACrzQf01BonFGGwfdleiVQdUcYnZrwY6CevXI58wekWkf+/P9QtFsDpq
        aycIRiJMUTuuHhsgTELKHl1MQA==
X-Google-Smtp-Source: AMsMyM4dYAWVYQvQUtzz2fvqhQ9Y7BSgj47G9NJJ9yMxjKa9qUrY/e/6xVdr3X/cRt3ipVNS/doSkQ==
X-Received: by 2002:adf:d1cc:0:b0:22a:450c:6208 with SMTP id b12-20020adfd1cc000000b0022a450c6208mr6519505wrd.696.1663964022227;
        Fri, 23 Sep 2022 13:13:42 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id k11-20020a05600c0b4b00b003b492753826sm3281056wmr.43.2022.09.23.13.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:13:41 -0700 (PDT)
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
Subject: [PATCH v2 10/35] net/tcp: Calculate TCP-AO traffic keys
Date:   Fri, 23 Sep 2022 21:12:54 +0100
Message-Id: <20220923201319.493208-11-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220923201319.493208-1-dima@arista.com>
References: <20220923201319.493208-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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
 include/net/tcp_ao.h  |  44 ++++++++++-
 net/ipv4/tcp_ao.c     | 180 ++++++++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_input.c  |   1 +
 net/ipv4/tcp_ipv4.c   |   1 +
 net/ipv4/tcp_output.c |   1 +
 net/ipv6/tcp_ao.c     |  40 ++++++++++
 net/ipv6/tcp_ipv6.c   |   1 +
 8 files changed, 272 insertions(+), 1 deletion(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 9c71f48cc99c..e140ae4fe653 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2078,6 +2078,11 @@ struct tcp_sock_af_ops {
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
index c550f1a6f5fd..f83a4d09a4ce 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -88,9 +88,33 @@ struct tcp_ao_info {
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
+int tcp_ao_cache_traffic_keys(const struct sock *sk, struct tcp_ao_info *ao,
+			      struct tcp_ao_key *ao_key);
 struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
 				    const union tcp_ao_addr *addr,
 				    int family, int sndid, int rcvid, u16 port);
@@ -98,13 +122,23 @@ struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
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
@@ -115,6 +149,14 @@ static inline struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
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
index 2e90b5a7b941..841f5db7393b 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -16,6 +16,42 @@
 #include <net/tcp.h>
 #include <net/ipv6.h>
 
+int tcp_ao_calc_traffic_key(struct tcp_ao_key *mkt, u8 *key, void *ctx,
+			    unsigned int len)
+{
+	struct crypto_pool_ahash hp;
+	struct scatterlist sg;
+	int ret;
+
+	if (crypto_pool_get(mkt->crypto_pool_id, (struct crypto_pool *)&hp))
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
+	crypto_pool_put();
+	return 0;
+clear_hash:
+	crypto_pool_put();
+clear_hash_noput:
+	memset(key, 0, tcp_ao_digest_size(mkt));
+	return 1;
+}
+
 static struct tcp_ao_key *tcp_ao_do_lookup_rcvid(struct sock *sk, u8 keyid)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
@@ -181,6 +217,47 @@ void tcp_ao_destroy_sock(struct sock *sk)
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
+
 struct tcp_ao_key *tcp_v4_ao_lookup(const struct sock *sk, struct sock *addr_sk,
 				    int sndid, int rcvid)
 {
@@ -189,6 +266,103 @@ struct tcp_ao_key *tcp_v4_ao_lookup(const struct sock *sk, struct sock *addr_sk,
 	return tcp_ao_do_lookup(sk, addr, AF_INET, sndid, rcvid, 0);
 }
 
+int tcp_ao_cache_traffic_keys(const struct sock *sk, struct tcp_ao_info *ao,
+			      struct tcp_ao_key *ao_key)
+{
+	u8 *traffic_key = snd_other_key(ao_key);
+	int ret;
+
+	ret = tcp_sk(sk)->af_specific->ao_calc_key_sk(ao_key, traffic_key, sk,
+						      ao->lisn, ao->risn, true);
+	if (ret)
+		return ret;
+
+	traffic_key = rcv_other_key(ao_key);
+	return tcp_sk(sk)->af_specific->ao_calc_key_sk(ao_key, traffic_key, sk,
+						       ao->lisn, ao->risn,
+						       false);
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
+		    -1, -1, sk->sk_dport) == 0)
+			continue;
+
+		if (key == ao_info->current_key)
+			ao_info->current_key = NULL;
+		if (key == ao_info->rnext_key)
+			ao_info->rnext_key = NULL;
+		hlist_del_rcu(&key->node);
+		crypto_pool_release(key->crypto_pool_id);
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
+		WARN_ON_ONCE(1);
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
 static int tcp_ao_current_rnext(struct sock *sk, u16 tcpa_flags,
 				u8 tcpa_sndid, u8 tcpa_rcvid)
 {
@@ -681,6 +855,12 @@ static int tcp_ao_add_cmd(struct sock *sk, unsigned short int family,
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
index bc2ea12221f9..ad9ced317768 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6051,6 +6051,7 @@ void tcp_finish_connect(struct sock *sk, struct sk_buff *skb)
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
 
+	tcp_ao_finish_connect(sk, skb);
 	tcp_set_state(sk, TCP_ESTABLISHED);
 	icsk->icsk_ack.lrcvtime = tcp_jiffies32;
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index f3d183be2595..e05bdad361c3 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2251,6 +2251,7 @@ static const struct tcp_sock_af_ops tcp_sock_ipv4_specific = {
 #ifdef CONFIG_TCP_AO
 	.ao_lookup		= tcp_v4_ao_lookup,
 	.ao_parse		= tcp_v4_parse_ao,
+	.ao_calc_key_sk		= tcp_v4_ao_calc_key_sk,
 #endif
 };
 #endif
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 4b9ffd6b901d..23069a34dd47 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3661,6 +3661,7 @@ static void tcp_connect_init(struct sock *sk)
 	if (tp->af_specific->md5_lookup(sk, sk))
 		tp->tcp_header_len += TCPOLEN_MD5SIG_ALIGNED;
 #endif
+	tcp_ao_connect_init(sk);
 
 	/* If user gave his TCP_MAXSEG, record it to clamp */
 	if (tp->rx_opt.user_mss)
diff --git a/net/ipv6/tcp_ao.c b/net/ipv6/tcp_ao.c
index 221b8adb4f73..888ee6242334 100644
--- a/net/ipv6/tcp_ao.c
+++ b/net/ipv6/tcp_ao.c
@@ -13,6 +13,46 @@
 #include <net/tcp.h>
 #include <net/ipv6.h>
 
+int tcp_v6_ao_calc_key(struct tcp_ao_key *mkt, u8 *key,
+		       const struct in6_addr *saddr,
+		       const struct in6_addr *daddr,
+		       __be16 sport, __be16 dport,
+		       __be32 sisn, __be32 disn)
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
index f5780a3fbd1b..c6d2389030f2 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1905,6 +1905,7 @@ static const struct tcp_sock_af_ops tcp_sock_ipv6_specific = {
 #ifdef CONFIG_TCP_AO
 	.ao_lookup	=	tcp_v6_ao_lookup,
 	.ao_parse	=	tcp_v6_parse_ao,
+	.ao_calc_key_sk	=	tcp_v6_ao_calc_key_sk,
 #endif
 };
 #endif
-- 
2.37.2

