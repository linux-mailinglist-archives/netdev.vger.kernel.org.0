Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3D17580B27
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 08:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237715AbiGZGQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 02:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237627AbiGZGPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 02:15:51 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1C565D8;
        Mon, 25 Jul 2022 23:15:49 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id z23so24091249eju.8;
        Mon, 25 Jul 2022 23:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hp+MtdTdEL/6/AJldab1K/zbmBCvlbTy806PFFcSB94=;
        b=MUFsBLnEHuEP4vSYJ5vok8oOKbU8ZFZMIdTn04XU0Lmk3qncgFhHZ0yaIDdvga9NtJ
         Yt1+c/H3WnN6Kq3yqZxgRYUyEhrehxsZoB2SIwPc8fXssMiQT8y+cxQWoUk+FPH4hWV/
         tCWJENm5N2oArx3T5Z+UL/tCIGZn/WCkF7L/v2GfGh63/kcYjZ8Um8C/bUJtATV5Ja3E
         CTDitcikdtMUJrKPHnP0PtimCwjpkY5P57u4bJAiCqgDsIQS4gsRplBn2hWIK6E9z3+8
         sGpKbvAciQZQ7Z3jb69+NEmaOuSb+OQymRwHd06n5W/uqQRY297XY5muepoXsTikKftd
         TyCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hp+MtdTdEL/6/AJldab1K/zbmBCvlbTy806PFFcSB94=;
        b=BXvY0GCrj3RbzTK8PoVxiLCGeYpRzjgqlHieVfMCo1XfJ2gb6bUdWK1CYrX01Ms90H
         GkoCdWgz/C1N4OlQpihZTMU5uEjrlRyeL0B8A4rgL1nDWcqIcd5IAst43Jik5gyNM2lG
         h2K3RaabGEBkT5FcJ21m63t2+/yK4UL+sQxkOE4YLkOJCM4TqH/XQnMfPjbIaFvGW3Of
         DuW22FMQYIjLdraP5GKCUP3uqxg2jaafH1bifBLcSpMXbralB4M5ezDmkDdZJREwVQ0z
         oRSOSIM3u5U+eu9iGAUtW3KzlTg8H7uuMQqQXJln+fA9GtDWFRReJMPU7/2OjAaqtAfd
         AVFQ==
X-Gm-Message-State: AJIora+0BZgB7Ptu3eeJUV2kR53LsBC4aGOfHXk1Us7b5JD5u21BEF94
        GSzTLIqi/RDzO8gu4akMUsk=
X-Google-Smtp-Source: AGRyM1tWl278PSC31zFymAeOaI8BzQAAdBDn9OPcDgTGhxfSzzJxG57lLQ3P3beN5xVECf6bH4hNWg==
X-Received: by 2002:a17:906:7007:b0:6ff:8028:42e with SMTP id n7-20020a170906700700b006ff8028042emr13149342ejj.278.1658816149291;
        Mon, 25 Jul 2022 23:15:49 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:2b68:36a:5a94:4ba1])
        by smtp.gmail.com with ESMTPSA id l23-20020a056402345700b0043ba7df7a42sm8133067edc.26.2022.07.25.23.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 23:15:48 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 06/26] tcp: authopt: Compute packet signatures
Date:   Tue, 26 Jul 2022 09:15:08 +0300
Message-Id: <497c16a13c1feb11e1a536f87fe59dd27f48dd2d.1658815925.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1658815925.git.cdleonard@gmail.com>
References: <cover.1658815925.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Computing tcp authopt packet signatures is a two step process:

* traffic key is computed based on tcp 4-tuple, initial sequence numbers
and the secret key.
* packet mac is computed based on traffic key and content of individual
packets.

The traffic key could be cached for established sockets but it is not.

A single code path exists for ipv4/ipv6 and input/output. This keeps the
code short but slightly slower due to lots of conditionals.

On output we read remote IP address from socket members on output, we
can't use skb network header because it's computed after TCP options.

On input we read remote IP address from skb network headers, we can't
use socket binding members because those are not available for SYN.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/net/tcp_authopt.h |   9 +
 net/ipv4/tcp_authopt.c    | 460 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 465 insertions(+), 4 deletions(-)

diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index ed9995c8d486..e303ef53e1a3 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -68,10 +68,19 @@ struct tcp_authopt_info {
 	u32 src_isn;
 	/** @dst_isn: Remote Initial Sequence Number */
 	u32 dst_isn;
 };
 
+/* TCP authopt as found in header */
+struct tcphdr_authopt {
+	u8 num;
+	u8 len;
+	u8 keyid;
+	u8 rnextkeyid;
+	u8 mac[0];
+};
+
 #ifdef CONFIG_TCP_AUTHOPT
 DECLARE_STATIC_KEY_FALSE(tcp_authopt_needed_key);
 #define tcp_authopt_needed (static_branch_unlikely(&tcp_authopt_needed_key))
 void tcp_authopt_clear(struct sock *sk);
 int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen);
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 005fac36760b..440d329b52f4 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -167,30 +167,26 @@ static void tcp_authopt_alg_put_pool(struct tcp_authopt_alg_imp *alg,
 {
 	WARN_ON(pool != this_cpu_ptr(alg->pool));
 	local_bh_enable();
 }
 
-__always_unused
 static struct tcp_authopt_alg_pool *tcp_authopt_get_kdf_pool(struct tcp_authopt_key_info *key)
 {
 	return tcp_authopt_alg_get_pool(key->alg);
 }
 
-__always_unused
 static void tcp_authopt_put_kdf_pool(struct tcp_authopt_key_info *key,
 				     struct tcp_authopt_alg_pool *pool)
 {
 	return tcp_authopt_alg_put_pool(key->alg, pool);
 }
 
-__always_unused
 static struct tcp_authopt_alg_pool *tcp_authopt_get_mac_pool(struct tcp_authopt_key_info *key)
 {
 	return tcp_authopt_alg_get_pool(key->alg);
 }
 
-__always_unused
 static void tcp_authopt_put_mac_pool(struct tcp_authopt_key_info *key,
 				     struct tcp_authopt_alg_pool *pool)
 {
 	return tcp_authopt_alg_put_pool(key->alg, pool);
 }
@@ -474,10 +470,466 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 	mutex_unlock(&net->mutex);
 
 	return 0;
 }
 
+static int tcp_authopt_get_isn(struct sock *sk,
+			       struct tcp_authopt_info *info,
+			       struct sk_buff *skb,
+			       int input,
+			       __be32 *sisn,
+			       __be32 *disn)
+{
+	struct tcphdr *th = tcp_hdr(skb);
+
+	/* Special cases for SYN and SYN/ACK */
+	if (th->syn && !th->ack) {
+		*sisn = th->seq;
+		*disn = 0;
+		return 0;
+	}
+	if (th->syn && th->ack) {
+		*sisn = th->seq;
+		*disn = htonl(ntohl(th->ack_seq) - 1);
+		return 0;
+	}
+
+	if (sk->sk_state == TCP_NEW_SYN_RECV) {
+		struct tcp_request_sock *rsk = (struct tcp_request_sock *)sk;
+
+		if (WARN_ONCE(!input, "Caller passed wrong socket"))
+			return -EINVAL;
+		*sisn = htonl(rsk->rcv_isn);
+		*disn = htonl(rsk->snt_isn);
+		return 0;
+	} else if (sk->sk_state == TCP_LISTEN) {
+		/* Signature computation for non-syn packet on a listen
+		 * socket is not possible because we lack the initial
+		 * sequence numbers.
+		 *
+		 * Input segments that are not matched by any request,
+		 * established or timewait socket will get here. These
+		 * are not normally sent by peers.
+		 *
+		 * Their signature might be valid but we don't have
+		 * enough state to determine that. TCP-MD5 can attempt
+		 * to validate and reply with a signed RST because it
+		 * doesn't care about ISNs.
+		 *
+		 * Reporting an error from signature code causes the
+		 * packet to be discarded which is good.
+		 */
+		if (WARN_ONCE(!input, "Caller passed wrong socket"))
+			return -EINVAL;
+		*sisn = 0;
+		*disn = 0;
+		return 0;
+	}
+	if (WARN_ONCE(!info, "caller did not pass tcp_authopt_info\n"))
+		return -EINVAL;
+	/* Initial sequence numbers for ESTABLISHED connections from info */
+	if (input) {
+		*sisn = htonl(info->dst_isn);
+		*disn = htonl(info->src_isn);
+	} else {
+		*sisn = htonl(info->src_isn);
+		*disn = htonl(info->dst_isn);
+	}
+	return 0;
+}
+
+/* Feed one buffer into ahash
+ * The buffer is assumed to be DMA-able
+ */
+static int crypto_ahash_buf(struct ahash_request *req, u8 *buf, uint len)
+{
+	struct scatterlist sg;
+
+	sg_init_one(&sg, buf, len);
+	ahash_request_set_crypt(req, &sg, NULL, len);
+
+	return crypto_ahash_update(req);
+}
+
+/* feed traffic key into ahash */
+static int tcp_authopt_ahash_traffic_key(struct tcp_authopt_alg_pool *pool,
+					 struct sock *sk,
+					 struct sk_buff *skb,
+					 struct tcp_authopt_info *info,
+					 bool input,
+					 bool ipv6)
+{
+	struct tcphdr *th = tcp_hdr(skb);
+	int err;
+	__be32 sisn, disn;
+	__be16 digestbits = htons(crypto_ahash_digestsize(pool->tfm) * 8);
+	/* For ahash const data buffers don't work so ensure header is on stack */
+	char traffic_key_context_header[7] = "\x01TCP-AO";
+
+	// RFC5926 section 3.1.1.1
+	err = crypto_ahash_buf(pool->req, traffic_key_context_header, 7);
+	if (err)
+		return err;
+
+	/* Addresses from packet on input and from sk_common on output
+	 * This is because on output MAC is computed before prepending IP header
+	 */
+	if (input) {
+		if (ipv6)
+			err = crypto_ahash_buf(pool->req, (u8 *)&ipv6_hdr(skb)->saddr, 32);
+		else
+			err = crypto_ahash_buf(pool->req, (u8 *)&ip_hdr(skb)->saddr, 8);
+		if (err)
+			return err;
+	} else {
+		if (ipv6) {
+#if IS_ENABLED(CONFIG_IPV6)
+			err = crypto_ahash_buf(pool->req, (u8 *)&sk->sk_v6_rcv_saddr, 16);
+			if (err)
+				return err;
+			err = crypto_ahash_buf(pool->req, (u8 *)&sk->sk_v6_daddr, 16);
+			if (err)
+				return err;
+#else
+			return -EINVAL;
+#endif
+		} else {
+			err = crypto_ahash_buf(pool->req, (u8 *)&sk->sk_rcv_saddr, 4);
+			if (err)
+				return err;
+			err = crypto_ahash_buf(pool->req, (u8 *)&sk->sk_daddr, 4);
+			if (err)
+				return err;
+		}
+	}
+
+	/* TCP ports from header */
+	err = crypto_ahash_buf(pool->req, (u8 *)&th->source, 4);
+	if (err)
+		return err;
+	err = tcp_authopt_get_isn(sk, info, skb, input, &sisn, &disn);
+	if (err)
+		return err;
+	err = crypto_ahash_buf(pool->req, (u8 *)&sisn, 4);
+	if (err)
+		return err;
+	err = crypto_ahash_buf(pool->req, (u8 *)&disn, 4);
+	if (err)
+		return err;
+	err = crypto_ahash_buf(pool->req, (u8 *)&digestbits, 2);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+/* Convert a variable-length key to a 16-byte fixed-length key for AES-CMAC
+ * This is described in RFC5926 section 3.1.1.2
+ */
+static int aes_setkey_derived(struct crypto_ahash *tfm, struct ahash_request *req,
+			      u8 *key, size_t keylen)
+{
+	static const u8 zeros[16] = {0};
+	struct scatterlist sg;
+	u8 derived_key[16];
+	int err;
+
+	if (WARN_ON_ONCE(crypto_ahash_digestsize(tfm) != sizeof(derived_key)))
+		return -EINVAL;
+	err = crypto_ahash_setkey(tfm, zeros, sizeof(zeros));
+	if (err)
+		return err;
+	err = crypto_ahash_init(req);
+	if (err)
+		return err;
+	sg_init_one(&sg, key, keylen);
+	ahash_request_set_crypt(req, &sg, derived_key, keylen);
+	err = crypto_ahash_digest(req);
+	if (err)
+		return err;
+	return crypto_ahash_setkey(tfm, derived_key, sizeof(derived_key));
+}
+
+static int tcp_authopt_setkey(struct tcp_authopt_alg_pool *pool, struct tcp_authopt_key_info *key)
+{
+	if (key->alg_id == TCP_AUTHOPT_ALG_AES_128_CMAC_96 && key->keylen != 16)
+		return aes_setkey_derived(pool->tfm, pool->req, key->key, key->keylen);
+	else
+		return crypto_ahash_setkey(pool->tfm, key->key, key->keylen);
+}
+
+static int tcp_authopt_get_traffic_key(struct sock *sk,
+				       struct sk_buff *skb,
+				       struct tcp_authopt_key_info *key,
+				       struct tcp_authopt_info *info,
+				       bool input,
+				       bool ipv6,
+				       u8 *traffic_key)
+{
+	struct tcp_authopt_alg_pool *pool;
+	int err;
+
+	pool = tcp_authopt_get_kdf_pool(key);
+	if (IS_ERR(pool))
+		return PTR_ERR(pool);
+
+	err = tcp_authopt_setkey(pool, key);
+	if (err)
+		goto out;
+	err = crypto_ahash_init(pool->req);
+	if (err)
+		goto out;
+
+	err = tcp_authopt_ahash_traffic_key(pool, sk, skb, info, input, ipv6);
+	if (err)
+		goto out;
+
+	ahash_request_set_crypt(pool->req, NULL, traffic_key, 0);
+	err = crypto_ahash_final(pool->req);
+	if (err)
+		return err;
+
+out:
+	tcp_authopt_put_kdf_pool(key, pool);
+	return err;
+}
+
+static int crypto_ahash_buf_zero(struct ahash_request *req, int len)
+{
+	u8 zeros[TCP_AUTHOPT_MACLEN] = {0};
+	int buflen, err;
+
+	/* In practice this is always called with len exactly 12.
+	 * Even on input we drop unusual signature sizes early.
+	 */
+	while (len) {
+		buflen = min_t(int, len, sizeof(zeros));
+		err = crypto_ahash_buf(req, zeros, buflen);
+		if (err)
+			return err;
+		len -= buflen;
+	}
+
+	return 0;
+}
+
+static int tcp_authopt_hash_tcp4_pseudoheader(struct tcp_authopt_alg_pool *pool,
+					      __be32 saddr,
+					      __be32 daddr,
+					      int nbytes)
+{
+	struct tcp4_pseudohdr phdr = {
+		.saddr = saddr,
+		.daddr = daddr,
+		.pad = 0,
+		.protocol = IPPROTO_TCP,
+		.len = htons(nbytes)
+	};
+	return crypto_ahash_buf(pool->req, (u8 *)&phdr, sizeof(phdr));
+}
+
+#if IS_ENABLED(CONFIG_IPV6)
+static int tcp_authopt_hash_tcp6_pseudoheader(struct tcp_authopt_alg_pool *pool,
+					      struct in6_addr *saddr,
+					      struct in6_addr *daddr,
+					      u32 plen)
+{
+	int err;
+	__be32 buf[2];
+
+	buf[0] = htonl(plen);
+	buf[1] = htonl(IPPROTO_TCP);
+
+	err = crypto_ahash_buf(pool->req, (u8 *)saddr, sizeof(*saddr));
+	if (err)
+		return err;
+	err = crypto_ahash_buf(pool->req, (u8 *)daddr, sizeof(*daddr));
+	if (err)
+		return err;
+	return crypto_ahash_buf(pool->req, (u8 *)&buf, sizeof(buf));
+}
+#endif
+
+/** Hash tcphdr options.
+ *
+ * If include_options is false then only the TCPOPT_AUTHOPT option itself is hashed
+ * Point to AO inside TH is passed by the caller
+ */
+static int tcp_authopt_hash_opts(struct tcp_authopt_alg_pool *pool,
+				 struct tcphdr *th,
+				 struct tcphdr_authopt *aoptr,
+				 bool include_options)
+{
+	int err;
+	/* start of options */
+	u8 *tcp_opts = (u8 *)(th + 1);
+	/* start of options */
+	u8 *aobuf = (u8 *)aoptr;
+	u8 aolen = aoptr->len;
+
+	if (WARN_ONCE(aoptr->num != TCPOPT_AUTHOPT, "Bad aoptr\n"))
+		return -EINVAL;
+
+	if (include_options) {
+		/* end of options */
+		u8 *tcp_data = ((u8 *)th) + th->doff * 4;
+
+		err = crypto_ahash_buf(pool->req, tcp_opts, aobuf - tcp_opts + 4);
+		if (err)
+			return err;
+		err = crypto_ahash_buf_zero(pool->req, aolen - 4);
+		if (err)
+			return err;
+		err = crypto_ahash_buf(pool->req, aobuf + aolen, tcp_data - (aobuf + aolen));
+		if (err)
+			return err;
+	} else {
+		err = crypto_ahash_buf(pool->req, aobuf, 4);
+		if (err)
+			return err;
+		err = crypto_ahash_buf_zero(pool->req, aolen - 4);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int tcp_authopt_hash_packet(struct tcp_authopt_alg_pool *pool,
+				   struct sock *sk,
+				   struct sk_buff *skb,
+				   struct tcphdr_authopt *aoptr,
+				   struct tcp_authopt_info *info,
+				   bool input,
+				   bool ipv6,
+				   bool include_options,
+				   u8 *macbuf)
+{
+	struct tcphdr *th = tcp_hdr(skb);
+	int err;
+
+	/* NOTE: SNE unimplemented */
+	__be32 sne = 0;
+
+	err = crypto_ahash_init(pool->req);
+	if (err)
+		return err;
+
+	err = crypto_ahash_buf(pool->req, (u8 *)&sne, 4);
+	if (err)
+		return err;
+
+	if (ipv6) {
+#if IS_ENABLED(CONFIG_IPV6)
+		struct in6_addr *saddr;
+		struct in6_addr *daddr;
+
+		if (input) {
+			saddr = &ipv6_hdr(skb)->saddr;
+			daddr = &ipv6_hdr(skb)->daddr;
+		} else {
+			saddr = &sk->sk_v6_rcv_saddr;
+			daddr = &sk->sk_v6_daddr;
+		}
+		err = tcp_authopt_hash_tcp6_pseudoheader(pool, saddr, daddr, skb->len);
+		if (err)
+			return err;
+#else
+		return -EINVAL;
+#endif
+	} else {
+		__be32 saddr;
+		__be32 daddr;
+
+		if (input) {
+			saddr = ip_hdr(skb)->saddr;
+			daddr = ip_hdr(skb)->daddr;
+		} else {
+			saddr = sk->sk_rcv_saddr;
+			daddr = sk->sk_daddr;
+		}
+		err = tcp_authopt_hash_tcp4_pseudoheader(pool, saddr, daddr, skb->len);
+		if (err)
+			return err;
+	}
+
+	// TCP header with checksum set to zero
+	{
+		struct tcphdr hashed_th = *th;
+
+		hashed_th.check = 0;
+		err = crypto_ahash_buf(pool->req, (u8 *)&hashed_th, sizeof(hashed_th));
+		if (err)
+			return err;
+	}
+
+	// TCP options
+	err = tcp_authopt_hash_opts(pool, th, aoptr, include_options);
+	if (err)
+		return err;
+
+	// Rest of SKB->data
+	err = tcp_sig_hash_skb_data(pool->req, skb, th->doff << 2);
+	if (err)
+		return err;
+
+	ahash_request_set_crypt(pool->req, NULL, macbuf, 0);
+	return crypto_ahash_final(pool->req);
+}
+
+/* __tcp_authopt_calc_mac - Compute packet MAC using key
+ *
+ * The macbuf output buffer must be large enough to fit the digestsize of the
+ * underlying transform before truncation.
+ * This means TCP_AUTHOPT_MAXMACBUF, not TCP_AUTHOPT_MACLEN
+ */
+__always_unused
+static int __tcp_authopt_calc_mac(struct sock *sk,
+				  struct sk_buff *skb,
+				  struct tcphdr_authopt *aoptr,
+				  struct tcp_authopt_key_info *key,
+				  struct tcp_authopt_info *info,
+				  bool input,
+				  char *macbuf)
+{
+	struct tcp_authopt_alg_pool *mac_pool;
+	u8 traffic_key[TCP_AUTHOPT_MAX_TRAFFIC_KEY_LEN];
+	int err;
+	bool ipv6 = (sk->sk_family != AF_INET);
+
+	if (sk->sk_family != AF_INET && sk->sk_family != AF_INET6)
+		return -EINVAL;
+
+	err = tcp_authopt_get_traffic_key(sk, skb, key, info, input, ipv6, traffic_key);
+	if (err)
+		return err;
+
+	mac_pool = tcp_authopt_get_mac_pool(key);
+	if (IS_ERR(mac_pool))
+		return PTR_ERR(mac_pool);
+	err = crypto_ahash_setkey(mac_pool->tfm, traffic_key, key->alg->traffic_key_len);
+	if (err)
+		goto out;
+	err = crypto_ahash_init(mac_pool->req);
+	if (err)
+		return err;
+
+	err = tcp_authopt_hash_packet(mac_pool,
+				      sk,
+				      skb,
+				      aoptr,
+				      info,
+				      input,
+				      ipv6,
+				      !(key->flags & TCP_AUTHOPT_KEY_EXCLUDE_OPTS),
+				      macbuf);
+
+out:
+	tcp_authopt_put_mac_pool(key, mac_pool);
+	return err;
+}
+
 static int tcp_authopt_init_net(struct net *full_net)
 {
 	struct netns_tcp_authopt *net = &full_net->tcp_authopt;
 
 	mutex_init(&net->mutex);
-- 
2.25.1

