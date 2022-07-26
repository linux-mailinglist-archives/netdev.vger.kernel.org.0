Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13F49580B1A
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 08:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237632AbiGZGPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 02:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232249AbiGZGPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 02:15:44 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667F46544;
        Mon, 25 Jul 2022 23:15:43 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id tk8so24303916ejc.7;
        Mon, 25 Jul 2022 23:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0RXkQWhI6FalGH+vkJ1F8eLYup7JvLS+HfjBxGyq+oc=;
        b=DAmd8cHdrrhqNXurP0GhyZoE/7jpD7YuticDgcU3eKUJzv1AekkfNGVxeQp4zxBTSi
         7QYDOFvXQDPyhi53tiHcsgsGnqUWvK9NZhSY6TRFyBucjtNJt+C3Sb+emux+h2Cao7T0
         +eJMfw5zW6/C4noQEQhXmFtM2nb/lTJDkM9OFZXLO1yj4TYo3bpGXNbrcENIHLuYLDwp
         zCNpe7ZgZCQZvvKL+s/U/TEFNftsLGdYII1g6n31Z7dori0UQNdFkyve0gsGgzw1XFQ7
         NROg6FsBwpl+xrQxbYT8MANtQ9mamNOMbGTDRaYOTAMQl56zPbyPQchaYkV0LMu47VCJ
         LwTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0RXkQWhI6FalGH+vkJ1F8eLYup7JvLS+HfjBxGyq+oc=;
        b=mPGJJs2lkEl3RJIuYjSYIDBffDzTLL0NPj4MkUG4uRZBsUxZs+6bjbaGgofot2Vwb8
         M0b6Cd4SIxweD38U0bkA8sSFKKcOlZQ6SlhNn6xDcWeCctvhlWMTcLyzPKeLhg86Omyg
         VZ5KRbUfsq2vKxoXl2qUL9c6LwDaYrsStLa3vR/XpAN+IrX3eyHm0JNehLHKthfkgVOh
         ZGNKDyVNBDjTuTgeQHcN8JLE+M/sFjnpY5U5NHjasUhT1uGKbZ0dZloofZSeBlTqP1UA
         3m0zm0ViOFCxvpUgxnOIfGAPPwGpQQao3VDpFuF5KPFPOFSdICVRHEsjzepcTvwsHjbA
         szXg==
X-Gm-Message-State: AJIora/TYVQ6Tda8aW83x8tiNwrkiFprQHSWBlcCNlo+EzT/z14zV6mQ
        fUaUP36P2Nk4KVn4dCbKOus=
X-Google-Smtp-Source: AGRyM1sis0k5xTzqDLk+5Ym37Fn6crrx/5A+bvKvTrFRHICIvkdL8lHnjKooRo0nBunLhV+WR0RtIA==
X-Received: by 2002:a17:907:763b:b0:72f:309d:d2c0 with SMTP id jy27-20020a170907763b00b0072f309dd2c0mr12850813ejc.434.1658816141830;
        Mon, 25 Jul 2022 23:15:41 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:2b68:36a:5a94:4ba1])
        by smtp.gmail.com with ESMTPSA id l23-20020a056402345700b0043ba7df7a42sm8133067edc.26.2022.07.25.23.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 23:15:41 -0700 (PDT)
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
Subject: [PATCH v6 02/26] tcp: authopt: Remove more unused noops
Date:   Tue, 26 Jul 2022 09:15:04 +0300
Message-Id: <2e9007e2f536ef2b8e3dfdaa1dd44dcc6bfc125f.1658815925.git.cdleonard@gmail.com>
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

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/net/tcp_authopt.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index adf325c260d5..bc2cff82830d 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -60,14 +60,10 @@ DECLARE_STATIC_KEY_FALSE(tcp_authopt_needed_key);
 void tcp_authopt_clear(struct sock *sk);
 int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen);
 int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *key);
 int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen);
 #else
-static inline int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *key)
-{
-	return -ENOPROTOOPT;
-}
 static inline void tcp_authopt_clear(struct sock *sk)
 {
 }
 #endif
 
-- 
2.25.1

