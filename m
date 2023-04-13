Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32BE36E1512
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 21:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjDMTRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 15:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjDMTR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 15:17:27 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30EB78A6C
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 12:17:08 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id w24so5647012wra.10
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 12:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681413426; x=1684005426;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2q0HQIUhPWAzcQCkg0eTFX++gXWvkSpk9XcUgGpc4nU=;
        b=l9Jr2aY2hOUlGEM9L/eEXLenSA3k/nBQWmzCjtebTFttB0xMi8KLQns4QjoC4socU5
         ALYohLa8HxcoMTnTRV6WayQGcuFVW6yKl3GSh8idkz1T54TEXh0Dm1gxkEc4t0XW1lX1
         7aZY92qt79Sh55j02fGZXI6uxBx4ftZSwF7/WXb4z0Z0OUp9HA55qMJ3VFQne2TF+tZ7
         CVTLy7FKltmebMWS560ctUeKYpVWYZQZiAXIqj3elpYbCTuqlTv9AYBGixrEL/+lNKaB
         F2yn6lU9ZSr+6a9I72gFrfbbD9V8iiscntYXTQ/uLSXjuB2qoIq9ROT/GWVxEe/qT83C
         tCcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681413426; x=1684005426;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2q0HQIUhPWAzcQCkg0eTFX++gXWvkSpk9XcUgGpc4nU=;
        b=ZRmmWD4eKNYqmGSEO6sevZqK/blR75vf41cB7PcDC28q3+DCfKNzdDyfoQ7UkPAQP6
         W9uKFbJx9me1PYqlm50zL8PniYPx3pZmfBuN0X0lL9BG0z39MrKn7+xiyjLqIg4+ckKN
         PwsNMKT7p7FiTB7RUm5RGrBfqEynHFvzViKUAGfEVu+OkkGfexFStD1792F+D5fltpVD
         77/w0Foma0tTEAXBVj6KH8jtuuV1hGot5lf/QKGeu9XrLOSR8M6OABrxbwCtuMxMOoJi
         w1dX8FMfdiGBKCOutLWptm8bRj/oHkv28Qep02SpSm4mqi6vYxYpUeOzPIckTQJSHU2F
         rlfA==
X-Gm-Message-State: AAQBX9cD1eAwKE1wLrvQSS97Kqh6ISoJM4oxD99RRKfhS36znAhSsX/i
        ACX1fY3UDpL7L4dnHFXwY7s=
X-Google-Smtp-Source: AKy350ane0GxrqlVI6m4nVR4t887/4StBUQbj/OR8q/Jl+3TvnQOQyhuLTJiwuQ0lXaAWZLw3ih5ig==
X-Received: by 2002:a5d:5284:0:b0:2f2:7906:7323 with SMTP id c4-20020a5d5284000000b002f279067323mr2423984wrv.42.1681413426405;
        Thu, 13 Apr 2023 12:17:06 -0700 (PDT)
Received: from ?IPV6:2a01:c22:738e:4400:f580:be04:1a64:fc5e? (dynamic-2a01-0c22-738e-4400-f580-be04-1a64-fc5e.c22.pool.telefonica.de. [2a01:c22:738e:4400:f580:be04:1a64:fc5e])
        by smtp.googlemail.com with ESMTPSA id c14-20020adfe74e000000b002cefcac0c62sm1919241wrn.9.2023.04.13.12.17.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Apr 2023 12:17:06 -0700 (PDT)
Message-ID: <16e51984-a539-24d4-a2d6-604c0b75f14b@gmail.com>
Date:   Thu, 13 Apr 2023 21:14:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: [PATCH net-next 1/3] net: add macro netif_subqueue_completed_wake
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <32e7eaf4-7e1c-04ce-eee5-a190349b31f9@gmail.com>
In-Reply-To: <32e7eaf4-7e1c-04ce-eee5-a190349b31f9@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add netif_subqueue_completed_wake, complementing the subqueue versions
netif_subqueue_try_stop and netif_subqueue_maybe_stop.

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


