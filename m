Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1587756A183
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235239AbiGGLvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234803AbiGGLvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:51:51 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D564F4507D;
        Thu,  7 Jul 2022 04:51:49 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id d16so19626195wrv.10;
        Thu, 07 Jul 2022 04:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aRSWPFJdUal4sFDyAFcRSHQQ/M3F+xYGlhF06C7Lf5E=;
        b=GMs/RhN8qUMfPGBs4yo+sSPeIeKLafGXETcG+w4RWJBYHzK8hsztfbzT6JKFKgPgJ1
         3R2wDQ9Xrnd0oaObDr0yyhD89Xl+ZqwnnaPqB2jqF2k4hq2ma2c1KJBky6XI9Z8CPFAi
         tTPVPYThTF2p00DcfNOlhmvPn0CFcbxYNgWdKBpfWgmyTvRd3l0WVB2OzQ5LbOfb0yKa
         IeYmi57QoUBJ20PoxQkWZFTpULc/XhWBK6/+Fb+cv2KWtBGTNqnPmqtPigUv0L9Ip/d2
         0EUcdcP59POGgMgufO7jMX+tHUhLsv2lr7VZzShByWv8Ck9U1aCvUL56aKYbotvQPGW+
         55iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aRSWPFJdUal4sFDyAFcRSHQQ/M3F+xYGlhF06C7Lf5E=;
        b=jlllIr/ax5rz7yjmm0MbSztjR8ZgEfp3ycIE3p4UBax/RwXgnow8/KkqAh9RLo2sWL
         1iaIitHjpEPHmnp19rSqMM6kxNm9H7I8jsorZz/8Y24amYHaDAANDohnN8wTpdSYm9X9
         husH+RudY41YUjYy6G6ntI9K5TRIJMxxmujyY7rEHmqgE1v64HYOtOsVyQQCuQglupvm
         hiqKG4LSbeNtNMsAkhPnUjeRxa7M5mnRf6DslJbBC5JDEWxyOOUdXdc5kwnaSeRseFGf
         P465mf0u1ClwDU61d3YA+92f0/nmhk6MGZnqtr5mXaAISbc0TQLMp49DFnGc6Vvlib+6
         4eqw==
X-Gm-Message-State: AJIora/xZ3CjJ1bNRsKbpIxV+j0ETume1enZuO4LN/3oeUPdRtKwlApo
        A9TzOjuAegSTCWrBw/ZQlrqxj8ltsw5aSB7mYlQ=
X-Google-Smtp-Source: AGRyM1uxlRBXgmEexZel6mtArbY3Szz4Y8NjgueyWbmhHTDmaxbayaLLP/y6jHPuvF6XWwn1Fq2o8Q==
X-Received: by 2002:a5d:6b81:0:b0:21d:72a8:73c9 with SMTP id n1-20020a5d6b81000000b0021d72a873c9mr13024174wrx.630.1657194708086;
        Thu, 07 Jul 2022 04:51:48 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a5d5142000000b0021b966abc19sm37982131wrt.19.2022.07.07.04.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 04:51:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v4 01/27] ipv4: avoid partial copy for zc
Date:   Thu,  7 Jul 2022 12:49:32 +0100
Message-Id: <0eb1cb5746e9ac938a7ba7848b33ccf680d30030.1657194434.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1657194434.git.asml.silence@gmail.com>
References: <cover.1657194434.git.asml.silence@gmail.com>
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

Even when zerocopy transmission is requested and possible,
__ip_append_data() will still copy a small chunk of data just because it
allocated some extra linear space (e.g. 148 bytes). It wastes CPU cycles
on copy and iter manipulations and also misalignes potentially aligned
data. Avoid such coies. And as a bonus we can allocate smaller skb.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv4/ip_output.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 00b4bf26fd93..581d1e233260 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -969,7 +969,6 @@ static int __ip_append_data(struct sock *sk,
 	struct inet_sock *inet = inet_sk(sk);
 	struct ubuf_info *uarg = NULL;
 	struct sk_buff *skb;
-
 	struct ip_options *opt = cork->opt;
 	int hh_len;
 	int exthdrlen;
@@ -977,6 +976,7 @@ static int __ip_append_data(struct sock *sk,
 	int copy;
 	int err;
 	int offset = 0;
+	bool zc = false;
 	unsigned int maxfraglen, fragheaderlen, maxnonfragsize;
 	int csummode = CHECKSUM_NONE;
 	struct rtable *rt = (struct rtable *)cork->dst;
@@ -1025,6 +1025,7 @@ static int __ip_append_data(struct sock *sk,
 		if (rt->dst.dev->features & NETIF_F_SG &&
 		    csummode == CHECKSUM_PARTIAL) {
 			paged = true;
+			zc = true;
 		} else {
 			uarg->zerocopy = 0;
 			skb_zcopy_set(skb, uarg, &extra_uref);
@@ -1091,9 +1092,12 @@ static int __ip_append_data(struct sock *sk,
 				 (fraglen + alloc_extra < SKB_MAX_ALLOC ||
 				  !(rt->dst.dev->features & NETIF_F_SG)))
 				alloclen = fraglen;
-			else {
+			else if (!zc) {
 				alloclen = min_t(int, fraglen, MAX_HEADER);
 				pagedlen = fraglen - alloclen;
+			} else {
+				alloclen = fragheaderlen + transhdrlen;
+				pagedlen = datalen - transhdrlen;
 			}
 
 			alloclen += alloc_extra;
-- 
2.36.1

