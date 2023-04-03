Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452996D5392
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 23:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbjDCVfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 17:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233208AbjDCVex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 17:34:53 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7925C49DE
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 14:34:37 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id m2so30779758wrh.6
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 14:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1680557676;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/PH69krUjgQwDDtGWmB6D495325k9/HG5sOhr1Lnmjs=;
        b=Q90xsZTp4/lk92fICG9u0lkG/7v5z1wuMi3TgBLeD/+CsCygZc9S57sl6XXFtmWltS
         4mmNt5FasnvpGTsvYAheKmhSBtluQQRtWWKKKZdBigcGwNUOVk9jwoHbYULwsqlH5+zU
         PiTHhMp10zX9ccq99Vb3fBvbWZEn6Df0IcfaL/T1gufhmEUjTZ7Rd6wfHfOat8KPT1ZH
         GxZTDJmtkB3hA4vvZVsZnGEBHIl7X87D8vAxnLroOmUOAsoMayX6jKfblD+VPFocwtb9
         an3jvQddA6xp12SlwelCDTVLyjLqj2QEP6+aZbakG7DrZC4edZ33mGnScMAmTopvJ/LN
         Vx5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680557676;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/PH69krUjgQwDDtGWmB6D495325k9/HG5sOhr1Lnmjs=;
        b=yg9XaG+DFaiqStt2Hb0JdVA/tkVttEy8birmdA9PcBKgXxdF+xhHAQD3PFzW74iWKF
         Eyuxwbion1UuZmpcWKJsLOr1XgLPDiEinOO8GdnLVGXA9x1DyXMA0lhkmzWioOihnKuJ
         22XdcauRQlCB6on47nQ9SFnvAuLS2ASalGTUJ3MNMASw0vpfFxFxiJhkU8mYp23fry2/
         cEyB7kTuvW5CsJ0QATtsVZlS/dmwquAgAriaGxJd05jqz+GCFcZB/0gR47gxmEDRq0d7
         O/t2pxEojTBQ8CACZhK0wExobMt3vUS2y8tkyoFlepEGmOJxsrfaQ9mQ96k/p/CdfutH
         Ffmw==
X-Gm-Message-State: AAQBX9c+5EyEoHFBGNjb6B+d8yld0gofbsP1geh+xzpCwjHU/KLedPdQ
        eqoxZ9puCgSwjo5H3FtLWOuEHQ==
X-Google-Smtp-Source: AKy350bSob9CGp6VW6YrizJufy2dLjAegP40vGDNZ1fe4chuS28woML51klC82blNX/7bf+OWpX5Kw==
X-Received: by 2002:adf:f201:0:b0:2e4:34b:92ad with SMTP id p1-20020adff201000000b002e4034b92admr15193731wro.64.1680557675690;
        Mon, 03 Apr 2023 14:34:35 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id o5-20020a5d4a85000000b002c3f9404c45sm10682740wrq.7.2023.04.03.14.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 14:34:35 -0700 (PDT)
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
Subject: [PATCH v5 06/21] net/tcp: Add TCP-AO sign to outgoing packets
Date:   Mon,  3 Apr 2023 22:34:05 +0100
Message-Id: <20230403213420.1576559-7-dima@arista.com>
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

Using precalculated traffic keys, sign TCP segments as prescribed by
RFC5925. Per RFC, TCP header options are included in sign calculation:
"The TCP header, by default including options, and where the TCP
checksum and TCP-AO MAC fields are set to zero, all in network-
byte order." (5.1.3)

tcp_ao_hash_header() has exclude_options parameter to optionally exclude
TCP header from hash calculation, as described in RFC5925 (9.1), this is
needed for interaction with middleboxes that may change "some TCP
options". This is wired up to AO key flags and setsockopt() later.

Similarly to TCP-MD5 hash TCP segment fragments.

From this moment a user can start sending TCP-AO signed segments with
one of crypto ahash algorithms from supported by Linux kernel. It can
have a user-specified MAC length, to either save TCP option header space
or provide higher protection using a longer signature.
The inbound segments are not yet verified, TCP-AO option is ignored and
they are accepted.

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp.h     |   7 ++
 include/net/tcp_ao.h  |  15 ++++
 net/ipv4/tcp_ao.c     | 177 ++++++++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_ipv4.c   |   1 +
 net/ipv4/tcp_output.c | 120 +++++++++++++++++++++++++---
 net/ipv6/tcp_ao.c     |  29 +++++++
 net/ipv6/tcp_ipv6.c   |   2 +
 7 files changed, 341 insertions(+), 10 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 6d5ca08ab0c5..2625aa091296 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -187,6 +187,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo);
 #define TCPOPT_SACK             5       /* SACK Block */
 #define TCPOPT_TIMESTAMP	8	/* Better RTT estimations/PAWS */
 #define TCPOPT_MD5SIG		19	/* MD5 Signature (RFC2385) */
+#define TCPOPT_AO		29	/* Authentication Option (RFC5925) */
 #define TCPOPT_MPTCP		30	/* Multipath TCP (RFC6824) */
 #define TCPOPT_FASTOPEN		34	/* Fast open (RFC7413) */
 #define TCPOPT_EXP		254	/* Experimental */
@@ -2118,6 +2119,12 @@ struct tcp_sock_af_ops {
 	struct tcp_ao_key	*(*ao_lookup)(const struct sock *sk,
 					      struct sock  *addr_sk,
 					      int sndid, int rcvid);
+	int			(*calc_ao_hash)(char *location,
+						struct tcp_ao_key *ao,
+						const struct sock *sk,
+						const struct sk_buff *skb,
+						const u8 *tkey,
+						int hash_offset, u32 sne);
 	int			(*ao_calc_key_sk)(struct tcp_ao_key *mkt,
 						  u8 *key,
 						  const struct sock *sk,
diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index 1172d9d9517a..ee32af145bba 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -115,11 +115,16 @@ struct tcp6_ao_context {
 	__be32		disn;
 };
 
+int tcp_ao_hash_skb(unsigned short int family,
+		    char *ao_hash, struct tcp_ao_key *key,
+		    const struct sock *sk, const struct sk_buff *skb,
+		    const u8 *tkey, int hash_offset, u32 sne);
 int tcp_parse_ao(struct sock *sk, int cmd, unsigned short int family,
 		 sockptr_t optval, int optlen);
 int tcp_ao_calc_traffic_key(struct tcp_ao_key *mkt, u8 *key, void *ctx,
 			    unsigned int len);
 void tcp_ao_destroy_sock(struct sock *sk);
+u32 tcp_ao_compute_sne(u32 sne, u32 seq, u32 new_seq);
 struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
 				    const union tcp_ao_addr *addr,
 				    int family, int sndid, int rcvid, u16 port);
@@ -130,13 +135,23 @@ struct tcp_ao_key *tcp_v4_ao_lookup(const struct sock *sk, struct sock *addr_sk,
 int tcp_v4_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
 			  const struct sock *sk,
 			  __be32 sisn, __be32 disn, bool send);
+int tcp_v4_ao_hash_skb(char *ao_hash, struct tcp_ao_key *key,
+		       const struct sock *sk, const struct sk_buff *skb,
+		       const u8 *tkey, int hash_offset, u32 sne);
 /* ipv6 specific functions */
+struct tcp_sigpool;
+int tcp_v6_ao_hash_pseudoheader(struct tcp_sigpool *hp,
+				const struct in6_addr *daddr,
+				const struct in6_addr *saddr, int nbytes);
 int tcp_v6_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
 				 const struct sock *sk, __be32 sisn,
 				 __be32 disn, bool send);
 struct tcp_ao_key *tcp_v6_ao_lookup(const struct sock *sk,
 				    struct sock *addr_sk,
 				    int sndid, int rcvid);
+int tcp_v6_ao_hash_skb(char *ao_hash, struct tcp_ao_key *key,
+		       const struct sock *sk, const struct sk_buff *skb,
+		       const u8 *tkey, int hash_offset, u32 sne);
 int tcp_v6_parse_ao(struct sock *sk, int cmd,
 		    sockptr_t optval, int optlen);
 void tcp_ao_finish_connect(struct sock *sk, struct sk_buff *skb);
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index da0ff96fa3d5..56cebdfd07b8 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -264,6 +264,183 @@ static int tcp_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
 		return -EOPNOTSUPP;
 }
 
+static int tcp_v4_ao_hash_pseudoheader(struct tcp_sigpool *hp,
+				       __be32 daddr, __be32 saddr,
+				       int nbytes)
+{
+	struct tcp4_pseudohdr *bp;
+	struct scatterlist sg;
+
+	bp = hp->scratch;
+	bp->saddr = saddr;
+	bp->daddr = daddr;
+	bp->pad = 0;
+	bp->protocol = IPPROTO_TCP;
+	bp->len = cpu_to_be16(nbytes);
+
+	sg_init_one(&sg, bp, sizeof(*bp));
+	ahash_request_set_crypt(hp->req, &sg, NULL, sizeof(*bp));
+	return crypto_ahash_update(hp->req);
+}
+
+static int tcp_ao_hash_pseudoheader(unsigned short int family,
+				    const struct sock *sk,
+				    const struct sk_buff *skb,
+				    struct tcp_sigpool *hp, int nbytes)
+{
+	const struct tcphdr *th = tcp_hdr(skb);
+
+	/* TODO: Can we rely on checksum being zero to mean outbound pkt? */
+	if (!th->check) {
+		if (family == AF_INET)
+			return tcp_v4_ao_hash_pseudoheader(hp, sk->sk_daddr,
+					sk->sk_rcv_saddr, skb->len);
+#if IS_ENABLED(CONFIG_IPV6)
+		else if (family == AF_INET6)
+			return tcp_v6_ao_hash_pseudoheader(hp, &sk->sk_v6_daddr,
+					&sk->sk_v6_rcv_saddr, skb->len);
+#endif
+		else
+			return -EAFNOSUPPORT;
+	}
+
+	if (family == AF_INET) {
+		const struct iphdr *iph = ip_hdr(skb);
+
+		return tcp_v4_ao_hash_pseudoheader(hp, iph->daddr,
+				iph->saddr, skb->len);
+#if IS_ENABLED(CONFIG_IPV6)
+	} else if (family == AF_INET6) {
+		const struct ipv6hdr *iph = ipv6_hdr(skb);
+
+		return tcp_v6_ao_hash_pseudoheader(hp, &iph->daddr,
+				&iph->saddr, skb->len);
+#endif
+	}
+	return -EAFNOSUPPORT;
+}
+
+u32 tcp_ao_compute_sne(u32 prev_sne, u32 prev_seq, u32 seq)
+{
+	u32 sne = prev_sne;
+
+	if (before(seq, prev_seq)) {
+		if (seq > prev_seq)
+			sne--;
+	} else {
+		if (seq < prev_seq)
+			sne++;
+	}
+
+	return sne;
+}
+EXPORT_SYMBOL_GPL(tcp_ao_compute_sne);
+
+/* tcp_ao_hash_sne(struct tcp_sigpool *hp)
+ * @hp	- used for hashing
+ * @sne - sne value
+ */
+static int tcp_ao_hash_sne(struct tcp_sigpool *hp, u32 sne)
+{
+	struct scatterlist sg;
+	__be32 *bp;
+
+	bp = (__be32 *)hp->scratch;
+	*bp = htonl(sne);
+
+	sg_init_one(&sg, bp, sizeof(*bp));
+	ahash_request_set_crypt(hp->req, &sg, NULL, sizeof(*bp));
+	return crypto_ahash_update(hp->req);
+}
+
+static int tcp_ao_hash_header(struct tcp_sigpool *hp,
+			      const struct tcphdr *th,
+			      bool exclude_options, u8 *hash,
+			      int hash_offset, int hash_len)
+{
+	struct scatterlist sg;
+	u8 *hdr = hp->scratch;
+	int err, len = th->doff << 2;
+
+	/* We are not allowed to change tcphdr, make a local copy */
+	if (exclude_options) {
+		len = sizeof(*th) + sizeof(struct tcp_ao_hdr) + hash_len;
+		memcpy(hdr, th, sizeof(*th));
+		memcpy(hdr + sizeof(*th),
+		       (u8 *)th + hash_offset - sizeof(struct tcp_ao_hdr),
+		       sizeof(struct tcp_ao_hdr));
+		memset(hdr + sizeof(*th) + sizeof(struct tcp_ao_hdr),
+		       0, hash_len);
+		((struct tcphdr *)hdr)->check = 0;
+	} else {
+		len = th->doff << 2;
+		memcpy(hdr, th, len);
+		/* zero out tcp-ao hash */
+		((struct tcphdr *)hdr)->check = 0;
+		memset(hdr + hash_offset, 0, hash_len);
+	}
+
+	sg_init_one(&sg, hdr, len);
+	ahash_request_set_crypt(hp->req, &sg, NULL, len);
+	err = crypto_ahash_update(hp->req);
+	WARN_ON_ONCE(err != 0);
+	return err;
+}
+
+int tcp_ao_hash_skb(unsigned short int family,
+		    char *ao_hash, struct tcp_ao_key *key,
+		    const struct sock *sk, const struct sk_buff *skb,
+		    const u8 *tkey,  int hash_offset, u32 sne)
+{
+	const struct tcphdr *th = tcp_hdr(skb);
+	int tkey_len = tcp_ao_digest_size(key);
+	__u8 tmp_hash[TCP_AO_MAX_HASH_SIZE] __tcp_ao_key_align;
+	struct tcp_sigpool hp;
+
+	if (tcp_sigpool_start(key->tcp_sigpool_id, &hp))
+		goto clear_hash_noput;
+
+	if (crypto_ahash_setkey(crypto_ahash_reqtfm(hp.req), tkey, tkey_len))
+		goto clear_hash;
+
+	/* For now use sha1 by default. Depends on alg in tcp_ao_key */
+	if (crypto_ahash_init(hp.req))
+		goto clear_hash;
+
+	if (tcp_ao_hash_sne(&hp, sne))
+		goto clear_hash;
+	if (tcp_ao_hash_pseudoheader(family, sk, skb, &hp, skb->len))
+		goto clear_hash;
+	if (tcp_ao_hash_header(&hp, th, false,
+			       ao_hash, hash_offset, tcp_ao_maclen(key)))
+		goto clear_hash;
+	if (tcp_sigpool_hash_skb_data(&hp, skb, th->doff << 2))
+		goto clear_hash;
+	ahash_request_set_crypt(hp.req, NULL, tmp_hash, 0);
+	if (crypto_ahash_final(hp.req))
+		goto clear_hash;
+
+	memcpy(ao_hash, tmp_hash, tcp_ao_maclen(key));
+	tcp_sigpool_end();
+	return 0;
+
+clear_hash:
+	tcp_sigpool_end();
+clear_hash_noput:
+	memset(ao_hash, 0, tcp_ao_maclen(key));
+	return 1;
+}
+EXPORT_SYMBOL_GPL(tcp_ao_hash_skb);
+
+int tcp_v4_ao_hash_skb(char *ao_hash, struct tcp_ao_key *key,
+		       const struct sock *sk, const struct sk_buff *skb,
+		       const u8 *tkey, int hash_offset, u32 sne)
+{
+	return tcp_ao_hash_skb(AF_INET, ao_hash, key, sk, skb,
+			       tkey, hash_offset, sne);
+}
+EXPORT_SYMBOL_GPL(tcp_v4_ao_hash_skb);
+
 struct tcp_ao_key *tcp_v4_ao_lookup(const struct sock *sk, struct sock *addr_sk,
 				    int sndid, int rcvid)
 {
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index c03510a24ce0..516b46cdd604 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2277,6 +2277,7 @@ static const struct tcp_sock_af_ops tcp_sock_ipv4_specific = {
 #endif
 #ifdef CONFIG_TCP_AO
 	.ao_lookup		= tcp_v4_ao_lookup,
+	.calc_ao_hash		= tcp_v4_ao_hash_skb,
 	.ao_parse		= tcp_v4_parse_ao,
 	.ao_calc_key_sk		= tcp_v4_ao_calc_key_sk,
 #endif
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 260edb2a6b3c..53756aef7994 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -413,6 +413,7 @@ static inline bool tcp_urg_mode(const struct tcp_sock *tp)
 #define OPTION_FAST_OPEN_COOKIE	BIT(8)
 #define OPTION_SMC		BIT(9)
 #define OPTION_MPTCP		BIT(10)
+#define OPTION_AO		BIT(11)
 
 static void smc_options_write(__be32 *ptr, u16 *options)
 {
@@ -605,7 +606,8 @@ static void bpf_skops_write_hdr_opt(struct sock *sk, struct sk_buff *skb,
  * (but it may well be that other scenarios fail similarly).
  */
 static void tcp_options_write(struct tcphdr *th, struct tcp_sock *tp,
-			      struct tcp_out_options *opts)
+			      struct tcp_out_options *opts,
+			      struct tcp_ao_key *ao_key)
 {
 	__be32 *ptr = (__be32 *)(th + 1);
 	u16 options = opts->options;	/* mungable copy */
@@ -617,7 +619,33 @@ static void tcp_options_write(struct tcphdr *th, struct tcp_sock *tp,
 		opts->hash_location = (__u8 *)ptr;
 		ptr += 4;
 	}
+#ifdef CONFIG_TCP_AO
+	if (unlikely(OPTION_AO & options) && tp) {
+		struct tcp_ao_key *rnext_key;
+		struct tcp_ao_info *ao_info;
+		u8 maclen;
 
+		if (WARN_ON_ONCE(!ao_key))
+			goto out_ao;
+		ao_info = rcu_dereference_check(tp->ao_info,
+				lockdep_sock_is_held(&tp->inet_conn.icsk_inet.sk));
+		rnext_key = READ_ONCE(ao_info->rnext_key);
+		if (WARN_ON_ONCE(!rnext_key))
+			goto out_ao;
+		maclen = tcp_ao_maclen(ao_key);
+		*ptr++ = htonl((TCPOPT_AO << 24) |
+				(tcp_ao_len(ao_key) << 16) |
+				(ao_key->sndid << 8) |
+				(rnext_key->rcvid));
+		opts->hash_location = (__u8 *)ptr;
+		ptr += maclen / sizeof(*ptr);
+		if (unlikely(maclen % sizeof(*ptr))) {
+			memset(ptr, TCPOPT_NOP, sizeof(*ptr));
+			ptr++;
+		}
+	}
+out_ao:
+#endif
 	if (unlikely(opts->mss)) {
 		*ptr++ = htonl((TCPOPT_MSS << 24) |
 			       (TCPOLEN_MSS << 16) |
@@ -758,7 +786,8 @@ static void mptcp_set_option_cond(const struct request_sock *req,
  */
 static unsigned int tcp_syn_options(struct sock *sk, struct sk_buff *skb,
 				struct tcp_out_options *opts,
-				struct tcp_md5sig_key **md5)
+				struct tcp_md5sig_key **md5,
+				struct tcp_ao_key *ao_key)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	unsigned int remaining = MAX_TCP_OPTION_SPACE;
@@ -775,6 +804,12 @@ static unsigned int tcp_syn_options(struct sock *sk, struct sk_buff *skb,
 		}
 	}
 #endif
+#ifdef CONFIG_TCP_AO
+	if (ao_key) {
+		opts->options |= OPTION_AO;
+		remaining -= tcp_ao_len(ao_key);
+	}
+#endif
 
 	/* We always get an MSS option.  The option bytes which will be seen in
 	 * normal data packets should timestamps be used, must be in the MSS
@@ -842,6 +877,7 @@ static unsigned int tcp_synack_options(const struct sock *sk,
 				       unsigned int mss, struct sk_buff *skb,
 				       struct tcp_out_options *opts,
 				       const struct tcp_md5sig_key *md5,
+				       const struct tcp_ao_key *ao,
 				       struct tcp_fastopen_cookie *foc,
 				       enum tcp_synack_type synack_type,
 				       struct sk_buff *syn_skb)
@@ -863,6 +899,14 @@ static unsigned int tcp_synack_options(const struct sock *sk,
 			ireq->tstamp_ok &= !ireq->sack_ok;
 	}
 #endif
+#ifdef CONFIG_TCP_AO
+	if (ao) {
+		opts->options |= OPTION_AO;
+		remaining -= tcp_ao_len(ao);
+		ireq->tstamp_ok &= !ireq->sack_ok;
+	}
+#endif
+	WARN_ON_ONCE(md5 && ao);
 
 	/* We always send an MSS option. */
 	opts->mss = mss;
@@ -912,7 +956,8 @@ static unsigned int tcp_synack_options(const struct sock *sk,
  */
 static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb,
 					struct tcp_out_options *opts,
-					struct tcp_md5sig_key **md5)
+					struct tcp_md5sig_key **md5,
+					struct tcp_ao_key *ao_key)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	unsigned int size = 0;
@@ -931,6 +976,12 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
 		}
 	}
 #endif
+#ifdef CONFIG_TCP_AO
+	if (ao_key) {
+		opts->options |= OPTION_AO;
+		size += tcp_ao_len(ao_key);
+	}
+#endif
 
 	if (likely(tp->rx_opt.tstamp_ok)) {
 		opts->options |= OPTION_TS;
@@ -1242,6 +1293,10 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 	unsigned int tcp_options_size, tcp_header_size;
 	struct sk_buff *oskb = NULL;
 	struct tcp_md5sig_key *md5;
+#ifdef CONFIG_TCP_AO
+	struct tcp_ao_info *ao;
+#endif
+	struct tcp_ao_key *ao_key = NULL;
 	struct tcphdr *th;
 	u64 prior_wstamp;
 	int err;
@@ -1273,11 +1328,17 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 	tcb = TCP_SKB_CB(skb);
 	memset(&opts, 0, sizeof(opts));
 
+#ifdef CONFIG_TCP_AO
+	ao = rcu_dereference_protected(tcp_sk(sk)->ao_info,
+				       lockdep_sock_is_held(sk));
+	if (ao)
+		ao_key = READ_ONCE(ao->current_key);
+#endif
 	if (unlikely(tcb->tcp_flags & TCPHDR_SYN)) {
-		tcp_options_size = tcp_syn_options(sk, skb, &opts, &md5);
+		tcp_options_size = tcp_syn_options(sk, skb, &opts, &md5, ao_key);
 	} else {
 		tcp_options_size = tcp_established_options(sk, skb, &opts,
-							   &md5);
+							   &md5, ao_key);
 		/* Force a PSH flag on all (GSO) packets to expedite GRO flush
 		 * at receiver : This slightly improve GRO performance.
 		 * Note that we do not force the PSH flag for non GSO packets,
@@ -1351,7 +1412,7 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 		th->window	= htons(min(tp->rcv_wnd, 65535U));
 	}
 
-	tcp_options_write(th, tp, &opts);
+	tcp_options_write(th, tp, &opts, ao_key);
 
 #ifdef CONFIG_TCP_MD5SIG
 	/* Calculate the MD5 hash, as we have all we need now */
@@ -1361,6 +1422,32 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 					       md5, sk, skb);
 	}
 #endif
+#ifdef CONFIG_TCP_AO
+	if (ao) {
+		u8 *traffic_key;
+		u8 key_buf[TCP_AO_MAX_HASH_SIZE];
+		u32 sne;
+		__u32 disn;
+
+		sk_gso_disable(sk);
+		if (unlikely(tcb->tcp_flags & TCPHDR_SYN)) {
+			if (tcb->tcp_flags & TCPHDR_ACK)
+				disn = ao->risn;
+			else
+				disn = 0;
+			traffic_key = key_buf;
+			tp->af_specific->ao_calc_key_sk(ao_key, traffic_key,
+							sk, ao->lisn, disn, true);
+		} else {
+			traffic_key = snd_other_key(ao_key);
+		}
+		sne = tcp_ao_compute_sne(ao->snd_sne, ao->snd_sne_seq,
+					 ntohl(th->seq));
+		tp->af_specific->calc_ao_hash(opts.hash_location, ao_key, sk, skb,
+					      traffic_key,
+					      opts.hash_location - (u8 *)th, sne);
+	}
+#endif
 
 	/* BPF prog is the last one writing header option */
 	bpf_skops_write_hdr_opt(sk, skb, NULL, NULL, 0, &opts);
@@ -1822,6 +1909,10 @@ unsigned int tcp_current_mss(struct sock *sk)
 	unsigned int header_len;
 	struct tcp_out_options opts;
 	struct tcp_md5sig_key *md5;
+	struct tcp_ao_key *ao_key = NULL;
+#ifdef CONFIG_TCP_AO
+	struct tcp_ao_info *ao_info;
+#endif
 
 	mss_now = tp->mss_cache;
 
@@ -1830,8 +1921,17 @@ unsigned int tcp_current_mss(struct sock *sk)
 		if (mtu != inet_csk(sk)->icsk_pmtu_cookie)
 			mss_now = tcp_sync_mss(sk, mtu);
 	}
-
-	header_len = tcp_established_options(sk, NULL, &opts, &md5) +
+#ifdef CONFIG_TCP_AO
+	ao_info = rcu_dereference_check(tp->ao_info, lockdep_sock_is_held(sk));
+	if (ao_info)
+		/* TODO: verify if we can access current_key or we need to pass
+		 * it from every caller of tcp_current_mss instead. The reason
+		 * is that the current_key pointer can change asynchronously
+		 * from the rx path.
+		 */
+		ao_key = READ_ONCE(ao_info->current_key);
+#endif
+	header_len = tcp_established_options(sk, NULL, &opts, &md5, ao_key) +
 		     sizeof(struct tcphdr);
 	/* The mss_cache is sized based on tp->tcp_header_len, which assumes
 	 * some common options. If this is an odd packet (because we have SACK
@@ -3582,7 +3682,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	/* bpf program will be interested in the tcp_flags */
 	TCP_SKB_CB(skb)->tcp_flags = TCPHDR_SYN | TCPHDR_ACK;
 	tcp_header_size = tcp_synack_options(sk, req, mss, skb, &opts, md5,
-					     foc, synack_type,
+					     NULL, foc, synack_type,
 					     syn_skb) + sizeof(*th);
 
 	skb_push(skb, tcp_header_size);
@@ -3603,7 +3703,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 
 	/* RFC1323: The window in SYN & SYN/ACK segments is never scaled. */
 	th->window = htons(min(req->rsk_rcv_wnd, 65535U));
-	tcp_options_write(th, NULL, &opts);
+	tcp_options_write(th, NULL, &opts, NULL);
 	th->doff = (tcp_header_size >> 2);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);
 
diff --git a/net/ipv6/tcp_ao.c b/net/ipv6/tcp_ao.c
index 2be0103fc4f8..4a21bcab733c 100644
--- a/net/ipv6/tcp_ao.c
+++ b/net/ipv6/tcp_ao.c
@@ -7,6 +7,7 @@
  *		Francesco Ruggeri <fruggeri@arista.com>
  *		Salam Noureddine <noureddine@arista.com>
  */
+#include <crypto/hash.h>
 #include <linux/tcp.h>
 
 #include <net/tcp.h>
@@ -70,6 +71,34 @@ struct tcp_ao_key *tcp_v6_ao_lookup(const struct sock *sk,
 }
 EXPORT_SYMBOL_GPL(tcp_v6_ao_lookup);
 
+int tcp_v6_ao_hash_pseudoheader(struct tcp_sigpool *hp,
+				const struct in6_addr *daddr,
+				const struct in6_addr *saddr, int nbytes)
+{
+	struct tcp6_pseudohdr *bp;
+	struct scatterlist sg;
+
+	bp = hp->scratch;
+	/* 1. TCP pseudo-header (RFC2460) */
+	bp->saddr = *saddr;
+	bp->daddr = *daddr;
+	bp->len = cpu_to_be32(nbytes);
+	bp->protocol = cpu_to_be32(IPPROTO_TCP);
+
+	sg_init_one(&sg, bp, sizeof(*bp));
+	ahash_request_set_crypt(hp->req, &sg, NULL, sizeof(*bp));
+	return crypto_ahash_update(hp->req);
+}
+
+int tcp_v6_ao_hash_skb(char *ao_hash, struct tcp_ao_key *key,
+		       const struct sock *sk, const struct sk_buff *skb,
+		       const u8 *tkey, int hash_offset, u32 sne)
+{
+	return tcp_ao_hash_skb(AF_INET6, ao_hash, key, sk, skb, tkey,
+			hash_offset, sne);
+}
+EXPORT_SYMBOL_GPL(tcp_v6_ao_hash_skb);
+
 int tcp_v6_parse_ao(struct sock *sk, int cmd,
 		    sockptr_t optval, int optlen)
 {
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 4e48818c1821..eaf85f233362 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1917,6 +1917,7 @@ static const struct tcp_sock_af_ops tcp_sock_ipv6_specific = {
 #endif
 #ifdef CONFIG_TCP_AO
 	.ao_lookup	=	tcp_v6_ao_lookup,
+	.calc_ao_hash	=	tcp_v6_ao_hash_skb,
 	.ao_parse	=	tcp_v6_parse_ao,
 	.ao_calc_key_sk	=	tcp_v6_ao_calc_key_sk,
 #endif
@@ -1950,6 +1951,7 @@ static const struct tcp_sock_af_ops tcp_sock_ipv6_mapped_specific = {
 #endif
 #ifdef CONFIG_TCP_AO
 	.ao_lookup	=	tcp_v6_ao_lookup,
+	.calc_ao_hash	=	tcp_v4_ao_hash_skb,
 	.ao_parse	=	tcp_v6_parse_ao,
 #endif
 };
-- 
2.40.0

