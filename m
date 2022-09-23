Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AABB65E832A
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 22:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbiIWUO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 16:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232562AbiIWUNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 16:13:49 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8437131F4B
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:13:44 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id bq9so1581397wrb.4
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=CdneRZzSSTn+It8LlzEn249zEIKqZeYFUnqX/FGDEP4=;
        b=f2IyiLX3ec+1235o4IHROhjF8LMa1b7ZsVM0vu8Mtf2xq70kYu4elTfCIGivkV9NXE
         IEqstiVMCaOsmTEltsueFUrCcs/wTjNrwOVgd30MeZdIhzjsDjZ8L99+yDPqCCPS+b6t
         edinM0MLe+L7OjFnK299fISgSMf1IqZ5InmVmmozAyTBofiBEc3yj2qm+n2Fpa8hG52O
         Fav+EFT7bHOwm52wukp+4MLi0d7uTC6foHmqpdsDMtQXVREqNrQY9yi6c+LmiXTWgaqZ
         cdtAWo3VgvrJHz/TDEd5gDV/b9c2uzeZh6yyh5iCkDrPD733SgvQ5kuaOcVFTIXYByF3
         ys2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=CdneRZzSSTn+It8LlzEn249zEIKqZeYFUnqX/FGDEP4=;
        b=O1q1XkVjc+0zZ4+a9meBZi1xejQtOq0wF90aJxmHj7OsisHwp81tZZXUiTcTgD0di3
         k3NI/ZOfECd8m4/98VnP7UXNF7Pw0kxwdusDlirOMChADuhS3UXq97NYW2voDInPhMlG
         D9BqTP9ou62HYeJttjFDnboj6ZomNdzOtw6mMgCl+gBP0Q3zVAMBaxKFq7iYkeBgRTC2
         E3c6C1gwXYWbildFaJb2DVqU7TbDSfnNvpYrfP4/KMWuEe2Hk06CRotflUWKLeJrfagK
         zGsne6yUPmyv4ksJhT/UaM9uKpQr5qsY44jFCSiJQG+heZTBNE2D/Z4Z3gfQhS9sMDMi
         N7Bg==
X-Gm-Message-State: ACrzQf1/cp5TOZCIlWl3IArzKT8gsS99SjCN/KVna+ZAVE+74F0R9F9I
        NvqUkvl7WGNlTcjPf6D71YGDiA==
X-Google-Smtp-Source: AMsMyM4lk/jZTZkZu8UZGIgKaHNOsk/QDbLFRzqWh/8ULlJxIJJ1FZ1XK7MLEhrF7c+BNNRStfTI9w==
X-Received: by 2002:a05:6000:1882:b0:22a:f402:c975 with SMTP id a2-20020a056000188200b0022af402c975mr6291772wri.532.1663964024128;
        Fri, 23 Sep 2022 13:13:44 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id k11-20020a05600c0b4b00b003b492753826sm3281056wmr.43.2022.09.23.13.13.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:13:43 -0700 (PDT)
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
Subject: [PATCH v2 11/35] net/tcp: Add TCP-AO sign to outgoing packets
Date:   Fri, 23 Sep 2022 21:12:55 +0100
Message-Id: <20220923201319.493208-12-dima@arista.com>
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
 include/net/tcp.h     |   8 ++
 include/net/tcp_ao.h  |  14 +++
 net/ipv4/tcp_ao.c     | 216 ++++++++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_ipv4.c   |   1 +
 net/ipv4/tcp_output.c | 118 ++++++++++++++++++++---
 net/ipv6/tcp_ao.c     |  27 ++++++
 net/ipv6/tcp_ipv6.c   |   2 +
 7 files changed, 375 insertions(+), 11 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index e140ae4fe653..d91a963f430d 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -26,6 +26,7 @@
 #include <linux/kref.h>
 #include <linux/ktime.h>
 #include <linux/indirect_call_wrapper.h>
+#include <crypto/pool.h>
 
 #include <net/inet_connection_sock.h>
 #include <net/inet_timewait_sock.h>
@@ -187,6 +188,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo);
 #define TCPOPT_SACK             5       /* SACK Block */
 #define TCPOPT_TIMESTAMP	8	/* Better RTT estimations/PAWS */
 #define TCPOPT_MD5SIG		19	/* MD5 Signature (RFC2385) */
+#define TCPOPT_AO		29	/* Authentication Option (RFC5925) */
 #define TCPOPT_MPTCP		30	/* Multipath TCP (RFC6824) */
 #define TCPOPT_FASTOPEN		34	/* Fast open (RFC7413) */
 #define TCPOPT_EXP		254	/* Experimental */
@@ -2078,6 +2080,12 @@ struct tcp_sock_af_ops {
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
index f83a4d09a4ce..f840b693d038 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -108,11 +108,16 @@ struct tcp6_ao_context {
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
 int tcp_ao_cache_traffic_keys(const struct sock *sk, struct tcp_ao_info *ao,
 			      struct tcp_ao_key *ao_key);
 struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
@@ -125,13 +130,22 @@ struct tcp_ao_key *tcp_v4_ao_lookup(const struct sock *sk, struct sock *addr_sk,
 int tcp_v4_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
 			  const struct sock *sk,
 			  __be32 sisn, __be32 disn, bool send);
+int tcp_v4_ao_hash_skb(char *ao_hash, struct tcp_ao_key *key,
+		       const struct sock *sk, const struct sk_buff *skb,
+		       const u8 *tkey, int hash_offset, u32 sne);
 /* ipv6 specific functions */
+int tcp_v6_ao_hash_pseudoheader(struct crypto_pool_ahash *hp,
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
index 841f5db7393b..74cbc13f62f4 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -258,6 +258,222 @@ int tcp_v4_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
 					  htons(sk->sk_num), disn, sisn);
 }
 
+static int tcp_v4_ao_hash_pseudoheader(struct crypto_pool_ahash *hp,
+				       __be32 daddr, __be32 saddr,
+				       int nbytes)
+{
+	struct tcp4_pseudohdr *bp;
+	struct scatterlist sg;
+
+	bp = hp->base.scratch;
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
+				    struct crypto_pool_ahash *hp, int nbytes)
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
+			return -EOPNOTSUPP;
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
+	return -EOPNOTSUPP;
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
+
+/* tcp_ao_hash_sne(struct crypto_pool_ahash *hp)
+ * @hp	- used for hashing
+ * @sne - sne value
+ */
+static int tcp_ao_hash_sne(struct crypto_pool_ahash *hp, u32 sne)
+{
+	struct scatterlist sg;
+	__be32 *bp;
+
+	bp = (__be32 *)hp->base.scratch;
+	*bp = htonl(sne);
+
+	sg_init_one(&sg, bp, sizeof(*bp));
+	ahash_request_set_crypt(hp->req, &sg, NULL, sizeof(*bp));
+	return crypto_ahash_update(hp->req);
+}
+
+static int tcp_ao_hash_header(struct crypto_pool_ahash *hp,
+			      const struct tcphdr *th,
+			      bool exclude_options, u8 *hash,
+			      int hash_offset, int hash_len)
+{
+	struct scatterlist sg;
+	u8 *hdr = hp->base.scratch;
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
+static int tcp_ao_hash_skb_data(struct crypto_pool_ahash *hp,
+				const struct sk_buff *skb,
+				unsigned int header_len)
+{
+	struct scatterlist sg;
+	const struct tcphdr *tp = tcp_hdr(skb);
+	struct ahash_request *req = hp->req;
+	unsigned int i;
+	const unsigned int head_data_len = skb_headlen(skb) > header_len ?
+					   skb_headlen(skb) - header_len : 0;
+	const struct skb_shared_info *shi = skb_shinfo(skb);
+	struct sk_buff *frag_iter;
+
+	WARN_ON(skb_headlen(skb) < header_len);
+
+	sg_init_table(&sg, 1);
+
+	sg_set_buf(&sg, ((u8 *)tp) + header_len, head_data_len);
+	ahash_request_set_crypt(req, &sg, NULL, head_data_len);
+	if (crypto_ahash_update(req))
+		return 1;
+
+	for (i = 0; i < shi->nr_frags; ++i) {
+		const skb_frag_t *f = &shi->frags[i];
+		unsigned int offset = skb_frag_off(f);
+		struct page *page = skb_frag_page(f) + (offset >> PAGE_SHIFT);
+
+		sg_set_page(&sg, page, skb_frag_size(f),
+			    offset_in_page(offset));
+		ahash_request_set_crypt(req, &sg, NULL, skb_frag_size(f));
+		if (crypto_ahash_update(req))
+			return 1;
+	}
+
+	skb_walk_frags(skb, frag_iter)
+		if (tcp_ao_hash_skb_data(hp, frag_iter, 0))
+			return 1;
+
+	return 0;
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
+	struct crypto_pool_ahash hp;
+
+	if (crypto_pool_get(key->crypto_pool_id, (struct crypto_pool *)&hp))
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
+	if (tcp_ao_hash_skb_data(&hp, skb, th->doff << 2))
+		goto clear_hash;
+	ahash_request_set_crypt(hp.req, NULL, tmp_hash, 0);
+	if (crypto_ahash_final(hp.req))
+		goto clear_hash;
+
+	memcpy(ao_hash, tmp_hash, tcp_ao_maclen(key));
+	crypto_pool_put();
+	return 0;
+
+clear_hash:
+	crypto_pool_put();
+clear_hash_noput:
+	memset(ao_hash, 0, tcp_ao_maclen(key));
+	return 1;
+}
+EXPORT_SYMBOL(tcp_ao_hash_skb);
+
+int tcp_v4_ao_hash_skb(char *ao_hash, struct tcp_ao_key *key,
+		       const struct sock *sk, const struct sk_buff *skb,
+		       const u8 *tkey, int hash_offset, u32 sne)
+{
+	return tcp_ao_hash_skb(AF_INET, ao_hash, key, sk, skb,
+			       tkey, hash_offset, sne);
+}
+
 struct tcp_ao_key *tcp_v4_ao_lookup(const struct sock *sk, struct sock *addr_sk,
 				    int sndid, int rcvid)
 {
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index e05bdad361c3..08db9e4a4784 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2250,6 +2250,7 @@ static const struct tcp_sock_af_ops tcp_sock_ipv4_specific = {
 #endif
 #ifdef CONFIG_TCP_AO
 	.ao_lookup		= tcp_v4_ao_lookup,
+	.calc_ao_hash		= tcp_v4_ao_hash_skb,
 	.ao_parse		= tcp_v4_parse_ao,
 	.ao_calc_key_sk		= tcp_v4_ao_calc_key_sk,
 #endif
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 23069a34dd47..5130e42e3dbf 100644
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
@@ -617,7 +619,29 @@ static void tcp_options_write(struct tcphdr *th, struct tcp_sock *tp,
 		opts->hash_location = (__u8 *)ptr;
 		ptr += 4;
 	}
-
+#ifdef CONFIG_TCP_AO
+	if (unlikely(OPTION_AO & options) && tp) {
+		struct tcp_ao_info *ao_info;
+		u8 maclen;
+
+		ao_info = rcu_dereference_check(tp->ao_info,
+				lockdep_sock_is_held(&tp->inet_conn.icsk_inet.sk));
+		if (WARN_ON_ONCE(!ao_key || !ao_info || !ao_info->rnext_key))
+			goto out_ao;
+		maclen = tcp_ao_maclen(ao_key);
+		*ptr++ = htonl((TCPOPT_AO << 24) |
+				(tcp_ao_len(ao_key) << 16) |
+				(ao_key->sndid << 8) |
+				(ao_info->rnext_key->rcvid));
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
@@ -758,7 +782,8 @@ static void mptcp_set_option_cond(const struct request_sock *req,
  */
 static unsigned int tcp_syn_options(struct sock *sk, struct sk_buff *skb,
 				struct tcp_out_options *opts,
-				struct tcp_md5sig_key **md5)
+				struct tcp_md5sig_key **md5,
+				struct tcp_ao_key *ao_key)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	unsigned int remaining = MAX_TCP_OPTION_SPACE;
@@ -775,6 +800,12 @@ static unsigned int tcp_syn_options(struct sock *sk, struct sk_buff *skb,
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
@@ -842,6 +873,7 @@ static unsigned int tcp_synack_options(const struct sock *sk,
 				       unsigned int mss, struct sk_buff *skb,
 				       struct tcp_out_options *opts,
 				       const struct tcp_md5sig_key *md5,
+				       const struct tcp_ao_key *ao,
 				       struct tcp_fastopen_cookie *foc,
 				       enum tcp_synack_type synack_type,
 				       struct sk_buff *syn_skb)
@@ -863,6 +895,14 @@ static unsigned int tcp_synack_options(const struct sock *sk,
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
@@ -912,7 +952,8 @@ static unsigned int tcp_synack_options(const struct sock *sk,
  */
 static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb,
 					struct tcp_out_options *opts,
-					struct tcp_md5sig_key **md5)
+					struct tcp_md5sig_key **md5,
+					struct tcp_ao_key *ao_key)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	unsigned int size = 0;
@@ -931,6 +972,12 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
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
@@ -1245,6 +1292,10 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
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
@@ -1276,11 +1327,17 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 	tcb = TCP_SKB_CB(skb);
 	memset(&opts, 0, sizeof(opts));
 
+#ifdef CONFIG_TCP_AO
+	ao = rcu_dereference_protected(tcp_sk(sk)->ao_info,
+				       lockdep_sock_is_held(sk));
+	if (ao)
+		ao_key = ao->current_key;
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
@@ -1354,7 +1411,7 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 		th->window	= htons(min(tp->rcv_wnd, 65535U));
 	}
 
-	tcp_options_write(th, tp, &opts);
+	tcp_options_write(th, tp, &opts, ao_key);
 
 #ifdef CONFIG_TCP_MD5SIG
 	/* Calculate the MD5 hash, as we have all we need now */
@@ -1364,6 +1421,32 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
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
@@ -1825,6 +1908,10 @@ unsigned int tcp_current_mss(struct sock *sk)
 	unsigned int header_len;
 	struct tcp_out_options opts;
 	struct tcp_md5sig_key *md5;
+	struct tcp_ao_key *ao_key = NULL;
+#ifdef CONFIG_TCP_AO
+	struct tcp_ao_info *ao_info;
+#endif
 
 	mss_now = tp->mss_cache;
 
@@ -1833,8 +1920,17 @@ unsigned int tcp_current_mss(struct sock *sk)
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
+		ao_key = ao_info->current_key;
+#endif
+	header_len = tcp_established_options(sk, NULL, &opts, &md5, ao_key) +
 		     sizeof(struct tcphdr);
 	/* The mss_cache is sized based on tp->tcp_header_len, which assumes
 	 * some common options. If this is an odd packet (because we have SACK
@@ -3580,7 +3676,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	/* bpf program will be interested in the tcp_flags */
 	TCP_SKB_CB(skb)->tcp_flags = TCPHDR_SYN | TCPHDR_ACK;
 	tcp_header_size = tcp_synack_options(sk, req, mss, skb, &opts, md5,
-					     foc, synack_type,
+					     NULL, foc, synack_type,
 					     syn_skb) + sizeof(*th);
 
 	skb_push(skb, tcp_header_size);
@@ -3601,7 +3697,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 
 	/* RFC1323: The window in SYN & SYN/ACK segments is never scaled. */
 	th->window = htons(min(req->rsk_rcv_wnd, 65535U));
-	tcp_options_write(th, NULL, &opts);
+	tcp_options_write(th, NULL, &opts, NULL);
 	th->doff = (tcp_header_size >> 2);
 	__TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);
 
diff --git a/net/ipv6/tcp_ao.c b/net/ipv6/tcp_ao.c
index 888ee6242334..7fd31c60488a 100644
--- a/net/ipv6/tcp_ao.c
+++ b/net/ipv6/tcp_ao.c
@@ -70,6 +70,33 @@ struct tcp_ao_key *tcp_v6_ao_lookup(const struct sock *sk,
 	return tcp_v6_ao_do_lookup(sk, addr, sndid, rcvid);
 }
 
+int tcp_v6_ao_hash_pseudoheader(struct crypto_pool_ahash *hp,
+				const struct in6_addr *daddr,
+				const struct in6_addr *saddr, int nbytes)
+{
+	struct tcp6_pseudohdr *bp;
+	struct scatterlist sg;
+
+	bp = hp->base.scratch;
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
+
 int tcp_v6_parse_ao(struct sock *sk, int cmd,
 		    sockptr_t optval, int optlen)
 {
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index c6d2389030f2..b5fa5ae53a47 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1904,6 +1904,7 @@ static const struct tcp_sock_af_ops tcp_sock_ipv6_specific = {
 #endif
 #ifdef CONFIG_TCP_AO
 	.ao_lookup	=	tcp_v6_ao_lookup,
+	.calc_ao_hash	=	tcp_v6_ao_hash_skb,
 	.ao_parse	=	tcp_v6_parse_ao,
 	.ao_calc_key_sk	=	tcp_v6_ao_calc_key_sk,
 #endif
@@ -1937,6 +1938,7 @@ static const struct tcp_sock_af_ops tcp_sock_ipv6_mapped_specific = {
 #endif
 #ifdef CONFIG_TCP_AO
 	.ao_lookup	=	tcp_v6_ao_lookup,
+	.calc_ao_hash	=	tcp_v6_ao_hash_skb,
 	.ao_parse	=	tcp_v6_parse_ao,
 #endif
 };
-- 
2.37.2

