Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD2546D260
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 12:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbhLHLlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 06:41:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232603AbhLHLlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 06:41:37 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA278C061D5F;
        Wed,  8 Dec 2021 03:38:05 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id x6so7417574edr.5;
        Wed, 08 Dec 2021 03:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zwg/3jXbHrDqLr7GxjKESPVOjZiPbN+/TXSEuiw/m4o=;
        b=DRIfx9VyPx3PPierHsehZT72JONUdDPL6xMnNNdoxd8QZrsg4nggfqYrqmXierk5Sw
         wOw2DrrpTnEUr+368nYhKM1RADiZxeZBF/ieodEcdPoxyixBjGt6SRdJfIWcU3bC4SgZ
         bJk39M3qfeeArcHKHr+J4kITgLieRgEKi/4aPhWkinDjvlrzJWvmcpRgA2VBK26chgHS
         8RTq3nr1IKEsN5jACdGOxvCHwaOFkQudxIbcJDkJC0G/3NqPFzAUUsT2AaGdY12cBUO9
         s4WqiseykcNSV3+jHkhFRAd1rUrN7H1Fnprk8eZf2m3ZfWmMB3pPtbE9UrZ/Vg7CgJ9H
         zK6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zwg/3jXbHrDqLr7GxjKESPVOjZiPbN+/TXSEuiw/m4o=;
        b=IlDk5x7hmx9w3PLskPG3YU3gurP+70a219v8LwvK3BT+ATEIVOmnQRNHjWHusBNoub
         WNQgbE3VsmShJ+Wx5VZVlPGX6iSipHr81cmdyqP5s70qLsNq+h7Kiy4WqB1dV9vg8dL8
         LU1qkzSVIkZ0sUjomTUTEwm7ACoGldILUpiJFb2bXPm+r7lc4AY1cn2TTld/L6/4Z37S
         1uwBGZIZeJD74N/crTZQqlcPFvz3LuP/TUghaPzGkVa1VTxBE0+/5nrWWgRe5bERldtF
         HkknQJ4CHS4CeIf2SUvq/eKVRiRYi6QfaE11rtc3Mw4OGyTMpvZ9FxTVbQQ8ZyXA2LjE
         bLtw==
X-Gm-Message-State: AOAM532tkfIAjFXO0jualC6vlhfO6yf3MiQty/gzNzKhkt0W0U1L+BJV
        VpA0/0ZqdCAq1RbwN//5t4Q=
X-Google-Smtp-Source: ABdhPJwt63BDI/tVWBgZiJuF8Ge5LwXsx0bVbHMtuJ4w0nreBd7GDWTDG/6V0lSNlXAsX/p8KnUUHQ==
X-Received: by 2002:a05:6402:2026:: with SMTP id ay6mr18499488edb.202.1638963484371;
        Wed, 08 Dec 2021 03:38:04 -0800 (PST)
Received: from ponky.lan ([2a04:241e:501:3870:3c9f:e05b:4dff:43ba])
        by smtp.gmail.com with ESMTPSA id g11sm1883810edz.53.2021.12.08.03.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 03:38:03 -0800 (PST)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Francesco Ruggeri <fruggeri@arista.com>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 04/18] tcp: md5: Refactor tcp_sig_hash_skb_data for AO
Date:   Wed,  8 Dec 2021 13:37:19 +0200
Message-Id: <b0abffd47667dd777738929505019a67779edb8b.1638962992.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1638962992.git.cdleonard@gmail.com>
References: <cover.1638962992.git.cdleonard@gmail.com>
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

