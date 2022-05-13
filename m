Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3F9526967
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 20:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383346AbiEMSe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 14:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383345AbiEMSeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 14:34:25 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83215F8FF
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:34:21 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id s14so8748735plk.8
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4mCUiYHwTe1k2DvRUcqVgRV+hPCBIC0DZOn3oTaUIRk=;
        b=HJkGQQNpfdl0O39fi+/P0H7bQOiwgF2oYqb07pb+AfLx21tLKS/NMr8QTbl9FtyB7Y
         FRq4RKBpAdfA60/B1BeyzI5I81l02t2CbBoQCYT3bH+6TD1eyxyjadAetOYziGSTMqDz
         evliorCzxonoEgEIoyPjf1908GeHX2F5ktCvoqvF3pVGgKVzrGa5Trmzo7aiHTADBKCi
         WNyAN+eAyEWD9Qf8KjnBE1//D8my7EhUGpQsWNiamSpbJtrfPdNolAXyo/yXSsDDkJYr
         aHOFXYRYJM91jbj+lYYwefJlO/HfCN+O/N6VljTT2MtOcXxXXVImMw/NVRYLtgLt6W3G
         wckQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4mCUiYHwTe1k2DvRUcqVgRV+hPCBIC0DZOn3oTaUIRk=;
        b=KzU83wGvViiFVgr211HkUgNSpcTxKPcAC2zguyZS9lWCJwZsRd+9XX35oslonLtpSV
         L62+qWJKPpdsPe16cD2GojozXe0eWGF8HsTNVZDedfB2QmEqPwQhfhQb1cA/LNX4qc/G
         DZVn0O0B04J92IoQM5WrL+ojVX+pzjvcjOVqUTjkuS0UbLAGBtWxiExB3dSDv+oDWrGp
         Ud590bkXAXdeyqLXJtE5Pdy3ka7Q4g+TEzw82dw9Mgg1Aib2C7r06XOfdoV3AZaVDR1N
         f80cdSqMzGQbZvYbV/LtBEw3NECf/EH8e6M8BCgBwXCfFMB3QdQ1XCDP6jicZbOuCm2H
         gNjA==
X-Gm-Message-State: AOAM5302G31OecYFe19iskFueAolHDVukMYENCsCBMBtLsGYlBTI2TsT
        TTnajmXoWfyqNUoasCBqWao=
X-Google-Smtp-Source: ABdhPJzNpPnBh7fRXm6XM2DcaYER5tUa4Z+jRgt/sC6T7KW2lj8UMPn/aVzEWVo1xkVbbCJsXKOqZQ==
X-Received: by 2002:a17:90b:350d:b0:1dc:6680:6f1d with SMTP id ls13-20020a17090b350d00b001dc66806f1dmr17446570pjb.27.1652466861340;
        Fri, 13 May 2022 11:34:21 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c436:3fa3:479f:a7a])
        by smtp.gmail.com with ESMTPSA id q13-20020aa7842d000000b0050dc76281cesm2053566pfn.168.2022.05.13.11.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 11:34:21 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v7 net-next 04/13] tcp_cubic: make hystart_ack_delay() aware of BIG TCP
Date:   Fri, 13 May 2022 11:33:59 -0700
Message-Id: <20220513183408.686447-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
In-Reply-To: <20220513183408.686447-1-eric.dumazet@gmail.com>
References: <20220513183408.686447-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet <edumazet@google.com>

hystart_ack_delay() had the assumption that a TSO packet
would not be bigger than GSO_MAX_SIZE.

This will no longer be true.

We should use sk->sk_gso_max_size instead.

This reduces chances of spurious Hystart ACK train detections.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Alexander Duyck <alexanderduyck@fb.com>
---
 net/ipv4/tcp_cubic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index b0918839bee7cf0264ec3bbcdfc1417daa86d197..68178e7280ce24c26a48e48a51518d759e4d1718 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -372,7 +372,7 @@ static void cubictcp_state(struct sock *sk, u8 new_state)
  * We apply another 100% factor because @rate is doubled at this point.
  * We cap the cushion to 1ms.
  */
-static u32 hystart_ack_delay(struct sock *sk)
+static u32 hystart_ack_delay(const struct sock *sk)
 {
 	unsigned long rate;
 
@@ -380,7 +380,7 @@ static u32 hystart_ack_delay(struct sock *sk)
 	if (!rate)
 		return 0;
 	return min_t(u64, USEC_PER_MSEC,
-		     div64_ul((u64)GSO_MAX_SIZE * 4 * USEC_PER_SEC, rate));
+		     div64_ul((u64)sk->sk_gso_max_size * 4 * USEC_PER_SEC, rate));
 }
 
 static void hystart_update(struct sock *sk, u32 delay)
-- 
2.36.0.550.gb090851708-goog

