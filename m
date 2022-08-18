Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7B6598D07
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 22:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345727AbiHRUBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 16:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345017AbiHRUA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 16:00:26 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62ABDD11CF;
        Thu, 18 Aug 2022 13:00:25 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id tl27so5215725ejc.1;
        Thu, 18 Aug 2022 13:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=wcjG3m982RLt6KaRv1a1gEgd8JSYghCB9RFcT+jPrQ8=;
        b=igqkhlSLrPUpcOdcaioX4U4ijK9FLa71jG/Z4050m2LXmGkAtvDNKmSUjT7wLN+WMk
         AI+RYr4BP156DYviSO/7p3V0KohaDMITjijwf1ghACguH69/7YAkzIAKwICM67m7ZKKG
         1dUqeL0Di5nCfbJtZMuELfxJdZWkqzdo8JCReo4hYQZW0TCldbr71tIXd4aQjS7J3wvV
         FLUeQbh0eZO/YRvHjl1A0ya2PJvQU/43APhVsKagBv7/bkwRschhoAVznP6WKeQm/Aw+
         7Qx9TYakJagRhMnNA+XDj7KjzfiWk7cIcrLvF4EfEzYKCtfjAtsNaJ9uOzP9QlC7AJKk
         kZEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=wcjG3m982RLt6KaRv1a1gEgd8JSYghCB9RFcT+jPrQ8=;
        b=N+yBvAjmnyOOn1zrZgmngZGm+FBy1Ij3hsAuSm5a1j3CpKj/i7zRQ/O/uHhHp7Nfgz
         JbgKg9N6AAiKyqok5hl2qy2jsgZrkxE5UFTZtm1lgmotN6vyZAp2lxAjSpnRbMoUabpv
         uvcU9z5I8eXaVk707GpEj6gLOSftzZketR4wWWN/Lsl8pAv7rM5WKXm7zxC32tfI3oKU
         fCAjJ1QYVT9tUloMLuiv0xrgUeMlC8tIxf+ET23Mu1kvQgSWLk+cEa7KJJPi1PHicC4S
         M+OxfndBL0vIB/+JuAEWf1jxujjrHboJbuk376LDa1ADX5zL/oD0DOEGrWRMjKWwlDMu
         9yyA==
X-Gm-Message-State: ACgBeo0T/bzctxpJBdP1ZCAMX2bHQh1Ogc/H2vIhlJcq8Stc/2ymADxY
        4IJWja2HO9lne85VI7seRKY=
X-Google-Smtp-Source: AA6agR5Qji/ar9vVxAOnvFBKNjLukbUcF1683r4dkoN3Gt7u+fVHDfaXGWjRlDRSn93MJU1eieb+8w==
X-Received: by 2002:a17:907:b02:b0:731:3f2d:f09 with SMTP id h2-20020a1709070b0200b007313f2d0f09mr2900919ejl.122.1660852823993;
        Thu, 18 Aug 2022 13:00:23 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:17c8:ba1c:b6f3:3fe0])
        by smtp.gmail.com with ESMTPSA id fw30-20020a170907501e00b00722e4bab163sm1215087ejc.200.2022.08.18.13.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 13:00:23 -0700 (PDT)
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
Subject: [PATCH v7 04/26] tcp: Refactor tcp_sig_hash_skb_data for AO
Date:   Thu, 18 Aug 2022 22:59:38 +0300
Message-Id: <1ec72c2b8d06cef533bc5fde79eae04a205e10ed.1660852705.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1660852705.git.cdleonard@gmail.com>
References: <cover.1660852705.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
index 9955a88faf9b..fbe18b5bf576 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1718,11 +1718,11 @@ struct tcp_md5sig_pool *tcp_get_md5sig_pool(void);
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
index 1e9eaf805e4c..4c61c32ccf49 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4508,16 +4508,19 @@ struct tcp_md5sig_pool *tcp_get_md5sig_pool(void)
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
@@ -4540,16 +4543,20 @@ int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *hp,
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
@@ -4636,11 +4643,11 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
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
index e8b2ab088828..46ba754afd2b 100644
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
index e54eee80ce5f..30dc9d4eec83 100644
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

