Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 967F05F23CB
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 17:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbiJBPRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 11:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiJBPRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 11:17:11 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AAB733864;
        Sun,  2 Oct 2022 08:17:10 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id s9so5436090qkg.4;
        Sun, 02 Oct 2022 08:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=fV1Ona2rkqeX6csTC7RYzdntmz4GfbK8LbfIp3z1Fs8=;
        b=G/zMplfp0K57ITzf+XaN07ra+ZH4RZPd7WO+CnXqFCTTQjpL5UlSLRhShBj+tnkwRo
         FE3VkiOiXCvg3FCqVhN1Dvo9VFkbBDSR1OT0xx9iQHU2jUrn7ur+b9etPVAOXt/6QplM
         /O5ablA+T0kDaB+sMx2xoB6pNolB2ITeayWBHRU2iQmn/qVoXMnSB1btQpcxhVGUIw0M
         vD2WvRxmw1OWVHV5gRvH1NG+mPkOrq0XREDNqT0+bpPtz/LwyqlV62tFBNxrJtgVJD4/
         sWhCXwqzJiclBV2Ybi256f5S/+w0HWc/7Y8D1Mdnw/SHVS46bbQqe8EPAkoHLEPxpvU2
         0d2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=fV1Ona2rkqeX6csTC7RYzdntmz4GfbK8LbfIp3z1Fs8=;
        b=xOv5T7YBW9JwqzADQ2QQMC0dMrN8aI/9AR3vbzSNlkjhj9Y0EugYOHY8V7dmfDj1K2
         9EKN7DHg6ODWpJ8GXcJIcQ45dubHREeQV5uTOql4cDBV/BrZFrDXMPPPPbeuThcR82H6
         lr8LcmXJJONlvhn08CazIiiFcXKoJ1uDq8t6cDR5mK5iS5FVCNb5Y3GpIHdFvTUVyOlU
         YMFr6I1c0sfQVNFlOKx7uIjUkO8rCTMqar9WjsF7EcywSQg70tSaxfuCh8tbC0sF7xU+
         e3gGZ8riyDFLNRIBjtZuHRpKc6JrK1xdkztt4cuZedvoS1XeMQMnr27/J59AujAbMlt5
         WAkQ==
X-Gm-Message-State: ACrzQf3JJfFSODiuIGaS32QZ5MS+m0XFg1CLr0pQzjHu10TszquTuBL9
        rOaqO7yDYfdNKDkQbvfdnpPRx7Vv+rw=
X-Google-Smtp-Source: AMsMyM4xA5XUE9ryqOCcdY+Mc/qGE6Qf5J1Txjl2rd7wequShwf/kPe8S+zdfbEGEhidQL7Ib638Xg==
X-Received: by 2002:a37:e116:0:b0:6cf:4dbd:18f1 with SMTP id c22-20020a37e116000000b006cf4dbd18f1mr11500782qkm.120.1664723829575;
        Sun, 02 Oct 2022 08:17:09 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:ec09:fca7:de7a:72aa])
        by smtp.gmail.com with ESMTPSA id q34-20020a05620a2a6200b006b8d1914504sm8865459qkp.22.2022.10.02.08.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Oct 2022 08:17:09 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>, linux-kernel@vger.kernel.org
Cc:     Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 1/4] net: move setup code out of mutex in __netif_set_xps_queue()
Date:   Sun,  2 Oct 2022 08:16:59 -0700
Message-Id: <20221002151702.3932770-2-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221002151702.3932770-1-yury.norov@gmail.com>
References: <20221002151702.3932770-1-yury.norov@gmail.com>
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
index 56c8b0921c9f..b848a75026c4 100644
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

