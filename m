Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E58D47E593
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 16:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349050AbhLWPk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 10:40:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349036AbhLWPkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 10:40:46 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB47CC061757;
        Thu, 23 Dec 2021 07:40:45 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id b13so22889502edd.8;
        Thu, 23 Dec 2021 07:40:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zwg/3jXbHrDqLr7GxjKESPVOjZiPbN+/TXSEuiw/m4o=;
        b=OFeSHr8AnD7N7PpPg/gICmxN4HGNzZzmdm4MbcZd+x6sBOd80fc2e7t+VHT1a4IwOc
         pIemen5CdWuUwZmRI/4JQG7zriVnHmLQT491xhDZkau1698At5uWLlR2ZNat6/228BaU
         Ek6+aIlLHCoy3219OCvrPn10Y4+jxdTM7ymhMnJoqjF/OPNSyqBD24vMJCw9EgA9MDd5
         p/02LitdqCIZsVZzBZxenKrHmHSTDados7TFtvseT0LydVKtZvIY0gPczyCz4BvNimq7
         dA5cA2IgIu+6YnMR40eGV7fBIvJp6QurqbO142iwUjOFcucEuVEhGtLu8zK0jYbQ6vep
         I5qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zwg/3jXbHrDqLr7GxjKESPVOjZiPbN+/TXSEuiw/m4o=;
        b=x3/9h6GFKlheMQaX6gg8IQH1Qn3DzRqrPOhMPIyvdhZuqNU3/8oHImvQPlUIt8WKk1
         UuhhCXY5jmHdkhkEtzAjST97Jc8XEZ7WpG9+jQ9HdtAVvPEy8cTpYslRYQEpb8R2qsPN
         a4Ga734ghdvBFafMfkArdhGXb3VBIPUtRtY01vAow/4j3pT4eXEVpo9X+uop+9UDk6mC
         w8H1yUbN7Iu0HQi6bVxSoCbRVB7paLxj1IYDNZQh4H7hYKyhUvXBXkUnQ/qXs4MtGthm
         dexD3f5/4ueFidOEe36Py95TIHxx3rgOghX2HDjm1+VD0VLZ86DRQFeOaOxMwrA2ptr+
         ML5Q==
X-Gm-Message-State: AOAM533VF1T/aGHFkABv7wR1n38eupf8f6O7Jx4h6t0PKyV9GD/T+afo
        D5n6JfqL8rZKP6nIitLKQ5M=
X-Google-Smtp-Source: ABdhPJwNri+jUZzFpH/ekr+dHNBINae4hbDJIN6g6FF0ArkXPaCCcihKmjy/KEjTStqdrPL+dXJUEA==
X-Received: by 2002:aa7:dc05:: with SMTP id b5mr2443480edu.46.1640274043875;
        Thu, 23 Dec 2021 07:40:43 -0800 (PST)
Received: from ponky.lan ([2a04:241e:501:3870:7c02:dfc6:b554:ab10])
        by smtp.gmail.com with ESMTPSA id bx6sm2088617edb.78.2021.12.23.07.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 07:40:43 -0800 (PST)
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
Subject: [PATCH v4 04/19] tcp: md5: Refactor tcp_sig_hash_skb_data for AO
Date:   Thu, 23 Dec 2021 17:39:59 +0200
Message-Id: <b0e9349ff9c068937ba73e1783c967be4e921f24.1640273966.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1640273966.git.cdleonard@gmail.com>
References: <cover.1640273966.git.cdleonard@gmail.com>
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
index 022811dd705d..8e6cbb5a1da7 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4400,16 +4400,31 @@ struct tcp_md5sig_pool *tcp_get_md5sig_pool(void)
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
@@ -4432,31 +4447,18 @@ int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *hp,
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
index 0aa5122b29e0..91cad11db32e 100644
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
index 3b7d6ede1364..e98fc6f12c61 100644
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

