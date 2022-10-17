Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34070601C0E
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 00:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiJQWIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 18:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiJQWIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 18:08:13 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320657696A;
        Mon, 17 Oct 2022 15:08:12 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id bv10so20654177wrb.4;
        Mon, 17 Oct 2022 15:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=93riG9uu1J1WTisFoALpPiFgWUkyaVzYtCZ43mZ5yrg=;
        b=W1Ju2EFTJ2FGU2nPR7Z1V+8TcZq1Ap4M3E0lHq6CeBWtHnpy9A1bb9Vvb3dwfdM+Zs
         3AQcMDIvxGr0lAcpBxmAPpewJYFWAn9wV2kUJaTY81ySCT6jFrZql6F1ErIq7VDx2/pS
         Bdnc2PYpk+CoZTaOEeOdYY2k+LUh5WqME+9K9BQ42JnuJVedtLB+4J8engvQudegm0Oa
         LbB21AaF2p0dmAm3LM4hwnApeW47fsibZVmOzuKJA03BJp8ZpanpcOazZFYVkt2oaXm5
         doLPsmqdlDqow28TweCY9IkLeDht1lLsmp2K4lHqtigAPZAPzIizT4l3aYiwNyXKJM8K
         ab3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=93riG9uu1J1WTisFoALpPiFgWUkyaVzYtCZ43mZ5yrg=;
        b=OE0Kpn56EMZY6sPyqRIE/tG8OniWkpMn+wfbs16aVk1fg29hlTtlAqzUadm9uPEpbz
         nGl3nfZC2C7HH9nqcJYkF7dckCUSr291qIIUsUFELe9av9Oq8s3Ppji28Q+kBzGlS3uP
         CDQiZwsjjBYmDyh9RLWlu64v8r1YVXUsO62wRw4GJz6oDNGW/G79SqpE4B8lreuGpTw2
         Ud5HB0ZYHFuy7Pqz25yBVM1JagrH+jtPuNIYfWKH7/LQeGtCvUZ4s5F9GQwEhShlsNhR
         sohjcG+Vs/nI1A5HAGWgOq3/72ABsJCOJOOrvr9HB0NaJV6UcR+Wp1FBaNiAQ5D8W24C
         55rg==
X-Gm-Message-State: ACrzQf16gDs01XHujdVal/ozeeJsUtw6x0WOYtNnH8C2vAYlNEGLNu+P
        DhhYW9giADdCcABswSbRXwA=
X-Google-Smtp-Source: AMsMyM76liUy6+AG1ZVa7Bt9T4aylrBn/uEOHcjsY92xLWmGtL+0dn9b630t2UvUF6obEzAXi9OkUw==
X-Received: by 2002:a05:6000:168f:b0:22e:4c3:de09 with SMTP id y15-20020a056000168f00b0022e04c3de09mr7259250wrd.40.1666044490528;
        Mon, 17 Oct 2022 15:08:10 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id bd21-20020a05600c1f1500b003b95ed78275sm11754504wmb.20.2022.10.17.15.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 15:08:10 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] esp6: remove redundant variable err
Date:   Mon, 17 Oct 2022 23:08:09 +0100
Message-Id: <20221017220809.864495-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

Variable err is being assigned a value that is not read, the assignment
is redundant and so is the variable. Remove it.

Cleans up clang scan warning:
net/ipv6/esp6_offload.c:64:7: warning: Although the value stored to 'err'
is used in the enclosing expression, the value is never actually read
from 'err' [deadcode.DeadStores]

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 net/ipv6/esp6_offload.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 79d43548279c..97edf461bc72 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -56,12 +56,11 @@ static struct sk_buff *esp6_gro_receive(struct list_head *head,
 	__be32 seq;
 	__be32 spi;
 	int nhoff;
-	int err;
 
 	if (!pskb_pull(skb, offset))
 		return NULL;
 
-	if ((err = xfrm_parse_spi(skb, IPPROTO_ESP, &spi, &seq)) != 0)
+	if (xfrm_parse_spi(skb, IPPROTO_ESP, &spi, &seq) != 0)
 		goto out;
 
 	xo = xfrm_offload(skb);
-- 
2.37.3

