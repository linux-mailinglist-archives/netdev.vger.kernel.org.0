Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A03C05FE5F1
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 01:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiJMXnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 19:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiJMXnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 19:43:53 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F4018C432;
        Thu, 13 Oct 2022 16:43:52 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id s3so2747816qtn.12;
        Thu, 13 Oct 2022 16:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G18TrD4h2uU6xMEPcn2BmBrOSK5xUMCgwUorehbNn3E=;
        b=hV7m+NkbyGPgklf1+F/DT1pwowFUEIzGPV+HojphrU4JWEjDGD77e3CsoEfEsEGpD3
         sGMgx0IUVx48mJwTNlN9xSwqnLG/YgHLLNgkpkKjlvkBP1UzcVx9yn/Niu3xCzFo6k+9
         FR/ZKm9Ks+ycqm6iSlE4yWFmzBTTdSr0FI/B2CAqdQGBpZ3CgApBQbbBd4c0OeFS+ZgN
         lmmk0Jv/294mbF08MjFXuMNrPqvR283fWg58K2IgwilDxCdWIvWYoL3C3VMTQVC0/Lcd
         rV5lwKq9Db87iL/DplecX/Dz9fd8H4sgL85ks0oOwh8XrWeguXT6zNqfVDK7Dbvze5c0
         EjaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G18TrD4h2uU6xMEPcn2BmBrOSK5xUMCgwUorehbNn3E=;
        b=4xCkm0B+kY5UUz02lY58D0aF5H9OjjLOBQeuhGUFPWjXgGvDSgHA3Zw08X8tbUDAA+
         XM4gkNMoGqmRRUqQJ2KnMEQg92N2UMp5UDEMqPzfe5U03q+wQWlpB7iie6eys5VcqfbL
         TAx6AQ9qzQM+ZUsNMN6r0KFORFtNoxBHBCTxLZxWrk9A003PJjhj831nam1FZUOsKEcp
         M5zwhARk2loyWBJPP4WbaSijOO0VgFiAPAOVBtUJt9JV1bO2hxbooScLz3z2o08wV/L7
         /h2C1Nae+rjGs9ZyE9zHKmhKLxtAzPeuA/8d2Tgo6nn4mxZlaROsgSmGbxKqPHorC2AF
         8Idg==
X-Gm-Message-State: ACrzQf22yKEczTthuYLgpe/EEcsgRXen5zteUUhOntjP7BB82mfDim9Z
        EInLhfE8FCe8/eqnFz5AkVdWBnG1jVI=
X-Google-Smtp-Source: AMsMyM4/+TX3wlhpVD7Bfm5EEEjy0nM9y8rYWjsJy8B/2eaSUzza3HspCgI9qGM+2fzB/PW+9cgabg==
X-Received: by 2002:a05:622a:10a:b0:39c:c4fd:4c6e with SMTP id u10-20020a05622a010a00b0039cc4fd4c6emr2032962qtw.441.1665704631669;
        Thu, 13 Oct 2022 16:43:51 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:ec49:7545:4026:a70a])
        by smtp.gmail.com with ESMTPSA id o16-20020a05620a2a1000b006e6a7c2a269sm1106212qkp.22.2022.10.13.16.43.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 16:43:51 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
Cc:     Yury Norov <yury.norov@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] net: move setup code out of mutex in __netif_set_xps_queue()
Date:   Thu, 13 Oct 2022 16:43:45 -0700
Message-Id: <20221013234349.1165689-2-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221013234349.1165689-1-yury.norov@gmail.com>
References: <20221013234349.1165689-1-yury.norov@gmail.com>
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

maps_sz, nr_ids and online_mask may be set out of the mutex.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 net/core/dev.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index fa53830d0683..70fa12c6551c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2563,9 +2563,6 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 			return -EINVAL;
 	}
 
-	mutex_lock(&xps_map_mutex);
-
-	dev_maps = xmap_dereference(dev->xps_maps[type]);
 	if (type == XPS_RXQS) {
 		maps_sz = XPS_RXQ_DEV_MAPS_SIZE(num_tc, dev->num_rx_queues);
 		nr_ids = dev->num_rx_queues;
@@ -2579,6 +2576,10 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 	if (maps_sz < L1_CACHE_BYTES)
 		maps_sz = L1_CACHE_BYTES;
 
+	mutex_lock(&xps_map_mutex);
+
+	dev_maps = xmap_dereference(dev->xps_maps[type]);
+
 	/* The old dev_maps could be larger or smaller than the one we're
 	 * setting up now, as dev->num_tc or nr_ids could have been updated in
 	 * between. We could try to be smart, but let's be safe instead and only
-- 
2.34.1

