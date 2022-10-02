Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC8C5F23CE
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 17:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiJBPRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 11:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiJBPRN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 11:17:13 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5F433A2C;
        Sun,  2 Oct 2022 08:17:12 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id d17so5416950qko.13;
        Sun, 02 Oct 2022 08:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=v6a6DRCa6+7GM1dDKtrznVaScx2fxL9jqYJ4uc5IddA=;
        b=RcWIsHwbHxpmzTE+KuiP/b0RY9NMf27VkavA4Rv3fr7af1bLt5nBX2fG7uZZ15qaO/
         O1ZkGZHqy4Ae6CdCkkLlWDTyyvBylKcAJRs7Q+TJByCBusNaEJXxkGqw3FZFX9SmuGkb
         RbXHq+AkRaxz1JN7F5QHqCncmclDeX9qHKdTWTu40qX6WkRXFktVxky0xbCPuDpJ/bLD
         vHspnAez93fmMLhhbBK7E+SQGRwbSheChk+jEGqU1nzLGNPUOV3015O6yABgzseD8//g
         nbsHNNSd72NKuTXR5R7sTe8DUROVbzrLu4+L58UWG9siriLyY/JcPr9xC5mgUbY+jRjC
         j+oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=v6a6DRCa6+7GM1dDKtrznVaScx2fxL9jqYJ4uc5IddA=;
        b=Ekb6W8IvXmeIjXcA3NFyT5xJQVDgryUKXyRwcD0+KEzpoyen979LJpPzYvtIFr9Svt
         sMUBzS3v7FTFJCAbsaBu3des91xIqKNo6KTzbZAlJVJ66NeOleOGKYz7kspxhC9UoY7A
         g3HPTyg+k4PzQn9pc3kamUOYfV98ffkx8wB2GgVo3WTQIZBijyQUPOwoUdsIPUxz34Ho
         Tg7x0jtztR3tk9ikcl7+lKhWFdlM1J93TQU6aoQzqtACl1LNJ4J2vVnYl0T8JzmaYhLs
         RT5qPNyj0EGtq5WvVQfI4ZjU8MSshP7nGgDM255/rRcoTjf03LUUTH5QTzpZLroIPd7X
         FYMg==
X-Gm-Message-State: ACrzQf08FnlqzI+OQ3EriVSwtULXNJEobu+GaQalr8uqehBIhFXhz2uM
        TiyI0rkTcS9q14gua8BKa3g31DirZZk=
X-Google-Smtp-Source: AMsMyM41WmNcD7britNlLCIoBnkou7CqstNQEqZR7Erqo+NgLl9MMqhqml4WA++cSo+kr92o0Vufqg==
X-Received: by 2002:a05:620a:4143:b0:6ce:87a7:77cb with SMTP id k3-20020a05620a414300b006ce87a777cbmr11715660qko.230.1664723831746;
        Sun, 02 Oct 2022 08:17:11 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:ec09:fca7:de7a:72aa])
        by smtp.gmail.com with ESMTPSA id fc20-20020a05622a489400b00346414a0ca1sm7263250qtb.1.2022.10.02.08.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Oct 2022 08:17:11 -0700 (PDT)
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
Subject: [PATCH 3/4] net: initialize online_mask unconditionally in __netif_set_xps_queue()
Date:   Sun,  2 Oct 2022 08:17:01 -0700
Message-Id: <20221002151702.3932770-4-yury.norov@gmail.com>
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

If the mask is initialized unconditionally, it's possible to use bitmap
API to traverse it, which is done in the following patch.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 net/core/dev.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 39a4cc7b3a06..266378ad1cf1 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2542,7 +2542,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 			  u16 index, enum xps_map_type type)
 {
 	struct xps_dev_maps *dev_maps, *new_dev_maps = NULL, *old_dev_maps = NULL;
-	const unsigned long *online_mask = NULL;
+	const unsigned long *online_mask;
 	bool active = false, copy = false;
 	int i, j, tci, numa_node_id = -2;
 	int maps_sz, num_tc = 1, tc = 0;
@@ -2565,9 +2565,11 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 
 	if (type == XPS_RXQS) {
 		nr_ids = dev->num_rx_queues;
+		online_mask = bitmap_alloc(nr_ids, GFP_KERNEL);
+		if (!online_mask)
+			return -ENOMEM;
 	} else {
-		if (num_possible_cpus() > 1)
-			online_mask = cpumask_bits(cpu_online_mask);
+		online_mask = cpumask_bits(cpu_online_mask);
 		nr_ids = nr_cpu_ids;
 	}
 
@@ -2593,10 +2595,8 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 	     j < nr_ids;) {
 		if (!new_dev_maps) {
 			new_dev_maps = kzalloc(maps_sz, GFP_KERNEL);
-			if (!new_dev_maps) {
-				mutex_unlock(&xps_map_mutex);
-				return -ENOMEM;
-			}
+			if (!new_dev_maps)
+				goto err_out;
 
 			new_dev_maps->nr_ids = nr_ids;
 			new_dev_maps->num_tc = num_tc;
@@ -2718,7 +2718,8 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 
 out_no_maps:
 	mutex_unlock(&xps_map_mutex);
-
+	if (type == XPS_RXQS)
+		bitmap_free(online_mask);
 	return 0;
 error:
 	/* remove any maps that we added */
@@ -2733,8 +2734,10 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 		}
 	}
 
+err_out:
 	mutex_unlock(&xps_map_mutex);
-
+	if (type == XPS_RXQS)
+		bitmap_free(online_mask);
 	kfree(new_dev_maps);
 	return -ENOMEM;
 }
-- 
2.34.1

