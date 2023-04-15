Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6CB6E2F75
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 09:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjDOHYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 03:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjDOHYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 03:24:20 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FDD3A9C
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 00:24:17 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id qb20so50775745ejc.6
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 00:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681543456; x=1684135456;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+VAYy4x1VW7GQjpcDHqlJKO18XulsfdzrpJC5dPxENk=;
        b=Uwe82IP25ZLJx6RcMRjmaz4B00nH2WVSEXxHCbeToeyWsOXYjpvRNq3ZYUg34HMDT8
         df1aTl+zMh4df9g4OtZ/pEf+iVbo6D8fr+lYfuEdvdL/bJ2RQzpfJZ5xA5RBK96D41P+
         CPwEfb7EY20mW4RX887jDB1Srcxc2HksfxNTSifEIOBXwfrE06G5y1mnON6Fi68GoOAi
         znVgDD6x5EnoTdPu6MfP3KJkP1yw/YGWJIovu/yg9KzrZgzZncNWLsxgRw+2wXoe3y3Z
         amhF9uIgEW/qt6je4LWO0B/FaGeUQ7rxwuYA0QIjdHmqEh4XBsSC1QuwgnoJwUiVxiQS
         camQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681543456; x=1684135456;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+VAYy4x1VW7GQjpcDHqlJKO18XulsfdzrpJC5dPxENk=;
        b=B5DgmA36P6DdFrnf2yx+N19Zy2KiXBW3G7Cynlk6FbrTqnpZL52p75FPGMLiDw0C1w
         0uK1OtQJqSS6cYalKoHcThljjLXbbOOch7P3C37axiZTIVJuV/yW3q0QqHx86/CC0Rvr
         Bs6gYP8waZkfW6DGBMGZYPUTC1LEHltsjs5e46olLwavyNhjp/XoXhK9cTpOTbt0sK9l
         kLH7Gd8vFOOLxltq8jF9e0LLtoxeKeYhr/DQJEobAR29kXqokEE44cKEXCqj28UP/g0c
         cGnV9gMSMK1fD+yhBsipJSKAyawKH9hdVqk85IbGpVyqrhSjuv7q4WRVSdTSIQxnI2yK
         mBrQ==
X-Gm-Message-State: AAQBX9ew2UxzD/azY6DLanMn0VPqwIt6rz3c4B/vYNUdscfQKyC3YDZk
        tKy9Tzgh3D/nlBteTTcN9pYIHFjTU/U=
X-Google-Smtp-Source: AKy350aYqCggtcWKslreX6ui5iJrWISf3kMbMjakjgzSJfDk/WpVf+6Tijk6kF6owubhIEn3fBt4OQ==
X-Received: by 2002:a17:907:3ad1:b0:933:868:413a with SMTP id fi17-20020a1709073ad100b009330868413amr1247444ejc.15.1681543456095;
        Sat, 15 Apr 2023 00:24:16 -0700 (PDT)
Received: from ?IPV6:2a01:c22:76c9:5300:c449:604e:39a7:3bce? (dynamic-2a01-0c22-76c9-5300-c449-604e-39a7-3bce.c22.pool.telefonica.de. [2a01:c22:76c9:5300:c449:604e:39a7:3bce])
        by smtp.googlemail.com with ESMTPSA id u11-20020aa7d98b000000b004ad601533a3sm2980846eds.55.2023.04.15.00.24.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Apr 2023 00:24:15 -0700 (PDT)
Message-ID: <85e0616f-76ac-26c0-b650-11bb7f0b9824@gmail.com>
Date:   Sat, 15 Apr 2023 09:20:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: [PATCH net-next v2 1/3] net: add macro netif_subqueue_completed_wake
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <f07fd01b-b431-6d8d-bd14-d447dffd8e64@gmail.com>
In-Reply-To: <f07fd01b-b431-6d8d-bd14-d447dffd8e64@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add netif_subqueue_completed_wake, complementing the subqueue versions
netif_subqueue_try_stop and netif_subqueue_maybe_stop.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 include/net/netdev_queues.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
index b26fdb441..d68b0a483 100644
--- a/include/net/netdev_queues.h
+++ b/include/net/netdev_queues.h
@@ -160,4 +160,14 @@ netdev_txq_completed_mb(struct netdev_queue *dev_queue,
 		netif_txq_maybe_stop(txq, get_desc, stop_thrs, start_thrs); \
 	})
 
+#define netif_subqueue_completed_wake(dev, idx, pkts, bytes,		\
+				      get_desc, start_thrs)		\
+	({								\
+		struct netdev_queue *txq;				\
+									\
+		txq = netdev_get_tx_queue(dev, idx);			\
+		netif_txq_completed_wake(txq, pkts, bytes,		\
+					 get_desc, start_thrs);		\
+	})
+
 #endif
-- 
2.40.0



