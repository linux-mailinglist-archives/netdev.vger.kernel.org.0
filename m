Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC29497ED7
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 13:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239474AbiAXMOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 07:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239316AbiAXMNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 07:13:46 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2D1C061753;
        Mon, 24 Jan 2022 04:13:28 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id ah7so20713343ejc.4;
        Mon, 24 Jan 2022 04:13:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AMPqCdnNFCPgjykC3tQHWCtjCEcPXxgb6KBNsrkovkE=;
        b=q1upNFvwn9ruKDsiFAvzq7VtobcctCY/VWQFHly+PQRN2mbB7KOik5KNBKGyc6Ui3z
         /jdz0ft2IBZOvpZ5MoXyi+TRXws8qo2hzc7hkC4YBNHWcFvadtayHHDL3bsp4bHEMYQi
         JQM+F+JCJF1ih03SqtIluX9uHNBPc8Amq39eZs7mdPGkXCA2p2FMoSbn73WehjRJSduP
         Yv3i4vTuF3hvw5Rlw4k1pLlqYyN38VRZWK678x1MmdyZZXbF9XxaUNxNzuBLW7+ttnBr
         5miPno2hHcNuNAbLsKAWNtVqkppnalDciTaJ/QogaH4Cci0eqW3TXAUXSzS2JRvjOaYG
         zXZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AMPqCdnNFCPgjykC3tQHWCtjCEcPXxgb6KBNsrkovkE=;
        b=EE0zQKWry8UFsnocz/GUzoMzLNmT/Hqu9YTcmB2LZNxx5yBbCzy3CT7U1wYCKewkCq
         Z1iBmyfspqd5HzhH3pt5Sr7bc2DthAQlpwaQKhtSocGmbLUHd4wZRa11AR5tikA2Pbsx
         90AuNV8INW4nZVX5iZEWFy6AyN8qCbEpcG0SUsVLyI2ysNUCGdy5bWMG94/5Lw4hu6+k
         oHOBKvDV/3MCOW1SMm2rjcEYBANvpTvayYAprlMMqU6lVrgKGZ6xUNIJard9XnAOlPnr
         rFnFr9Bwb37Wo86r93y8kN+Mx7uWDTGjFZBM0JABqNJRYQKHwuVRIyHZZYhgXFCQw68B
         +qMw==
X-Gm-Message-State: AOAM530t9r+H2UJbQNx7fABKhLcP8xvuK6crjdyLkDjQf9euIwIw4a/H
        FOZg0S0nWdp4AJuR0a4Lc+Q=
X-Google-Smtp-Source: ABdhPJzXFq0dm5XwFwLg4kTBKBZD2vWwh4TI3FnJlJXqs1wFGFuXesSYvLRDVHjbvqm0SzlEILIdqA==
X-Received: by 2002:a17:907:a41e:: with SMTP id sg30mr717027ejc.600.1643026407522;
        Mon, 24 Jan 2022 04:13:27 -0800 (PST)
Received: from ponky.lan ([2a04:241e:502:a09c:a21f:7a9f:9158:4a40])
        by smtp.gmail.com with ESMTPSA id b16sm4847517eja.211.2022.01.24.04.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 04:13:27 -0800 (PST)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Shuah Khan <shuah@kernel.org>,
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
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 04/20] tcp: md5: Refactor tcp_sig_hash_skb_data for AO
Date:   Mon, 24 Jan 2022 14:12:50 +0200
Message-Id: <807215b61a7d2066da35f024252187de92a27b8f.1643026076.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1643026076.git.cdleonard@gmail.com>
References: <cover.1643026076.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This chunk of code is identical between the implementation of TCP-MD5
and TCP-AO so rename and refactor

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/net/tcp.h   |  2 +-
 net/ipv4/tcp.c      | 38 ++++++++++++++++++++------------------
 net/ipv4/tcp_ipv4.c |  2 +-
 net/ipv6/tcp_ipv6.c |  2 +-
 4 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 6cc2eeb45deb..1a0513b0ead0 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1688,11 +1688,11 @@ struct tcp_md5sig_pool *tcp_get_md5sig_pool(void);
 static inline void tcp_put_md5sig_pool(void)
 {
 	local_bh_enable();
 }
 
-int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *, const struct sk_buff *,
+int tcp_sig_hash_skb_data(struct ahash_request *, const struct sk_buff *,
 			  unsigned int header_len);
 int tcp_md5_hash_key(struct tcp_md5sig_pool *hp,
 		     const struct tcp_md5sig_key *key);
 
 /* From tcp_fastopen.c */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 3651a1e13a16..f00f67d1f2b0 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4399,16 +4399,31 @@ struct tcp_md5sig_pool *tcp_get_md5sig_pool(void)
 	local_bh_enable();
 	return NULL;
 }
 EXPORT_SYMBOL(tcp_get_md5sig_pool);
 
-int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *hp,
+int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct tcp_md5sig_key *key)
+{
+	u8 keylen = READ_ONCE(key->keylen); /* paired with WRITE_ONCE() in tcp_md5_do_add */
+	struct scatterlist sg;
+
+	sg_init_one(&sg, key->key, keylen);
+	ahash_request_set_crypt(hp->md5_req, &sg, NULL, keylen);
+
+	/* We use data_race() because tcp_md5_do_add() might change key->key under us */
+	return data_race(crypto_ahash_update(hp->md5_req));
+}
+EXPORT_SYMBOL(tcp_md5_hash_key);
+#endif /* CONFIG_TCP_MD5SIG */
+
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AUTHOPT)
+
+int tcp_sig_hash_skb_data(struct ahash_request *req,
 			  const struct sk_buff *skb, unsigned int header_len)
 {
 	struct scatterlist sg;
 	const struct tcphdr *tp = tcp_hdr(skb);
-	struct ahash_request *req = hp->md5_req;
 	unsigned int i;
 	const unsigned int head_data_len = skb_headlen(skb) > header_len ?
 					   skb_headlen(skb) - header_len : 0;
 	const struct skb_shared_info *shi = skb_shinfo(skb);
 	struct sk_buff *frag_iter;
@@ -4431,31 +4446,18 @@ int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *hp,
 		if (crypto_ahash_update(req))
 			return 1;
 	}
 
 	skb_walk_frags(skb, frag_iter)
-		if (tcp_md5_hash_skb_data(hp, frag_iter, 0))
+		if (tcp_sig_hash_skb_data(req, frag_iter, 0))
 			return 1;
 
 	return 0;
 }
-EXPORT_SYMBOL(tcp_md5_hash_skb_data);
+EXPORT_SYMBOL(tcp_sig_hash_skb_data);
 
-int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct tcp_md5sig_key *key)
-{
-	u8 keylen = READ_ONCE(key->keylen); /* paired with WRITE_ONCE() in tcp_md5_do_add */
-	struct scatterlist sg;
-
-	sg_init_one(&sg, key->key, keylen);
-	ahash_request_set_crypt(hp->md5_req, &sg, NULL, keylen);
-
-	/* We use data_race() because tcp_md5_do_add() might change key->key under us */
-	return data_race(crypto_ahash_update(hp->md5_req));
-}
-EXPORT_SYMBOL(tcp_md5_hash_key);
-
-#endif
+#endif /* defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AUTHOPT) */
 
 void tcp_done(struct sock *sk)
 {
 	struct request_sock *req;
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index f03d48e574c9..442c28e1c72a 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1381,11 +1381,11 @@ int tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
 	if (crypto_ahash_init(req))
 		goto clear_hash;
 
 	if (tcp_v4_md5_hash_headers(hp, daddr, saddr, th, skb->len))
 		goto clear_hash;
-	if (tcp_md5_hash_skb_data(hp, skb, th->doff << 2))
+	if (tcp_sig_hash_skb_data(hp->md5_req, skb, th->doff << 2))
 		goto clear_hash;
 	if (tcp_md5_hash_key(hp, key))
 		goto clear_hash;
 	ahash_request_set_crypt(req, NULL, md5_hash, 0);
 	if (crypto_ahash_final(req))
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 075ee8a2df3b..7aed4cdfcd65 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -750,11 +750,11 @@ static int tcp_v6_md5_hash_skb(char *md5_hash,
 	if (crypto_ahash_init(req))
 		goto clear_hash;
 
 	if (tcp_v6_md5_hash_headers(hp, daddr, saddr, th, skb->len))
 		goto clear_hash;
-	if (tcp_md5_hash_skb_data(hp, skb, th->doff << 2))
+	if (tcp_sig_hash_skb_data(hp->md5_req, skb, th->doff << 2))
 		goto clear_hash;
 	if (tcp_md5_hash_key(hp, key))
 		goto clear_hash;
 	ahash_request_set_crypt(req, NULL, md5_hash, 0);
 	if (crypto_ahash_final(req))
-- 
2.25.1

