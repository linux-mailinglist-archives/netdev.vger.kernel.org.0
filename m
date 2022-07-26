Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFF1580B23
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 08:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237696AbiGZGQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 02:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237591AbiGZGPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 02:15:50 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9957B845;
        Mon, 25 Jul 2022 23:15:48 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id z18so4176655edb.10;
        Mon, 25 Jul 2022 23:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ws+VbvHjw+TY5I46qGDXZAvdoD2Rg2Qpp30wjTYhs6o=;
        b=lzZvvrbqeNUj+Ko1Jsd2jej4nqDO3BEJw+2NwuHp+zhRR6Fk5Fxb0VUdwRZPSnyqLS
         x9UIKjAxVd1CYYavEyJ34zBmk2eFj1J9ZdMnSbDFp9viNu4qm/Ov4oSjwhOhIVPoG46l
         DsCfCmnPvLRloZtdDzAK3F5ofne1hcJXDWkYQvt6pqx/dQmVc6O+y8QXC1IKGApkPiPM
         wnACtOk2Bp8Sm6fyjYIrRZrNO1FFtxUkIB2rKUl8zqdHhza1x3aYpKJHe81YZUaRE6Ai
         1tQLhhASA+xzUAssW9PyVfeKbezrdgbpA3Ok/3GT0D+mCF1qA5kFjyFlROwcvC1HkL9m
         eU5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ws+VbvHjw+TY5I46qGDXZAvdoD2Rg2Qpp30wjTYhs6o=;
        b=gS3UbQyLIEBtH0P0lryxRwHIEPcesQa3YOadegM4pKY7J8S0Io6wrgi6lyOhxm9NFU
         HOS0wDaSnCDs3vUy7VQGhvS4/JHmAX+44ONcAB1oNrrwtqfm25M76rNUgUaBFtnAzyiY
         GgPteah7/Uh8YU2pdLx2epU2ehyzwlut1gwsNTju8y47pytvBLm3DpWjl7VvXojH991Q
         gl1LT68vYHym6LEUAaI1wyvhHRcpt6h4BoKJ16YhgvfcYFwQQK40+uuQzAiyNQc2LkcN
         pjIC0fOJoEI1RqzP6sfqRbX0loX7HGDrnoN0odJneD3bsXxkA6FgxjAHcXeLy7PBPeU2
         1+VA==
X-Gm-Message-State: AJIora/+h331yhKfJBa26nz+PDOzXRyC4DZf2/ZPtY3N6ketz6nsycQA
        0gHskZv1k4xFd1ZTbqr/WFU=
X-Google-Smtp-Source: AGRyM1urO8b9Y5B6A5IGIcVRIT2gt9u0xDqdq5yUfQxbvHKKVeC068HPwNyqrGHliMu0HoMiDZHLkA==
X-Received: by 2002:a05:6402:50d0:b0:43c:99e:3a71 with SMTP id h16-20020a05640250d000b0043c099e3a71mr7369887edb.89.1658816147413;
        Mon, 25 Jul 2022 23:15:47 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:2b68:36a:5a94:4ba1])
        by smtp.gmail.com with ESMTPSA id l23-20020a056402345700b0043ba7df7a42sm8133067edc.26.2022.07.25.23.15.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 23:15:47 -0700 (PDT)
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
Subject: [PATCH v6 05/26] tcp: Refactor tcp_sig_hash_skb_data for AO
Date:   Tue, 26 Jul 2022 09:15:07 +0300
Message-Id: <8b8e2d5db031795960b9c31ee30e3f2315bc6eda.1658815925.git.cdleonard@gmail.com>
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

This function feeds all SKB data into an ahash and this behavior is
identical between the TCP-MD5 and TCP-AO so rename and refactor.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/net/tcp.h   |  2 +-
 net/ipv4/tcp.c      | 17 ++++++++++++-----
 net/ipv4/tcp_ipv4.c |  2 +-
 net/ipv6/tcp_ipv6.c |  2 +-
 4 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 7d335f96238d..793e8802fef0 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1716,11 +1716,11 @@ struct tcp_md5sig_pool *tcp_get_md5sig_pool(void);
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
index 791f218b8c66..4cdc34200bcf 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4468,16 +4468,19 @@ struct tcp_md5sig_pool *tcp_get_md5sig_pool(void)
 	local_bh_enable();
 	return NULL;
 }
 EXPORT_SYMBOL(tcp_get_md5sig_pool);
 
-int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *hp,
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
@@ -4500,16 +4503,20 @@ int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *hp,
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
+
+#endif /* defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AUTHOPT) */
+
+#ifdef CONFIG_TCP_MD5SIG
 
 int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct tcp_md5sig_key *key)
 {
 	u8 keylen = READ_ONCE(key->keylen); /* paired with WRITE_ONCE() in tcp_md5_do_add */
 	struct scatterlist sg;
@@ -4587,11 +4594,11 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 	}
 	return SKB_NOT_DROPPED_YET;
 }
 EXPORT_SYMBOL(tcp_inbound_md5_hash);
 
-#endif
+#endif /* CONFIG_TCP_MD5SIG */
 
 void tcp_done(struct sock *sk)
 {
 	struct request_sock *req;
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index d011937b8785..5c13d3460ce1 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1388,11 +1388,11 @@ int tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
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
index 85b8b765dcb1..16e85ae4f029 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -751,11 +751,11 @@ static int tcp_v6_md5_hash_skb(char *md5_hash,
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

