Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A792D5FE5EE
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 01:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiJMXn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 19:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiJMXnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 19:43:55 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA0818C434;
        Thu, 13 Oct 2022 16:43:54 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id i9so2334060qvo.0;
        Thu, 13 Oct 2022 16:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kwG+9wq4H/ajQFHnHol/XkFDuB13Bjyau0OIo4dYrHg=;
        b=CMIHpFdUR5W6pPnxGWURT78iCHQoH6PUNtbjbZYwupfb38uVFND/cuhtNztdDo8kJ4
         +5D0M69jODJpBkPsZs6GC0ChV6mzglk9MdkVdqjs2iMUSgqrpRrRk/0EnyfulQtqBUrK
         4gBvyNT+XTNha8hIp9vT+Jwl0gcl23OEymTG2vp+wQF3tC3HC/tYLMGT7FKmhxSz+s3R
         9LxTdZU0pFCkF+V/ymL3HomjKs3d9hLWBAeUx70yp2EUKZTlvfAdyLKFRi4snRMUzq07
         ArWW15Y43sDZGFzCG1KpW5F0pzOWQHazvSmFebjutnHNwIggm/uJ6Q4LNyze8keS1IWK
         mNzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kwG+9wq4H/ajQFHnHol/XkFDuB13Bjyau0OIo4dYrHg=;
        b=ayhZ5WynPYwXRXwbU173SGbOGOJS3y5SNVHw6r8/FIByydoHf/m71gaF4i7ietccKa
         945Y/A9aie2Josc2wBDZw+YnfcZobPnLyKRzSphmsF83fcMFt9P8Z9OWYNZ7a9+gRtag
         eDFIgtDVhZ6ojt3fPVVkeb1BIfnDLxDVptsNtRaLDbH/Nr2Ke5Dv9I2yQPFo04jC0cQR
         c4LwhQIYV/Wk3fVg4BD1tA+LUjthVvB1yLctiqf8P5SjvFAt15Fvp75A6mHdIDSNL3jY
         nooaGtitK+uMZ2GUSGvnqUIoJ07aux0OL8+KT5dhIcQzZGkvFvfX0nwgOkVUR6KqSsyP
         0T6A==
X-Gm-Message-State: ACrzQf0Xq4eHxk7j9DTFd96LwlnTpKPWWf1Svf3/n3FxDQLh0C+BHcpw
        VAxr85nnNtgxkTlCwNaOhEz3nEu5lcM=
X-Google-Smtp-Source: AMsMyM6RWZXGuOmTYl6sh6I373ubmMMijLvqy5KP8ESaMTvM9bRYfXRjennY8uhiLfjX94H5w96Gsg==
X-Received: by 2002:ad4:5dee:0:b0:4b4:b8a:78db with SMTP id jn14-20020ad45dee000000b004b40b8a78dbmr1976060qvb.12.1665704633224;
        Thu, 13 Oct 2022 16:43:53 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:ec49:7545:4026:a70a])
        by smtp.gmail.com with ESMTPSA id x5-20020ac84a05000000b0039a08c0a594sm952928qtq.82.2022.10.13.16.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 16:43:53 -0700 (PDT)
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
Subject: [PATCH v2 3/4] net: initialize online_mask unconditionally in __netif_set_xps_queue()
Date:   Thu, 13 Oct 2022 16:43:47 -0700
Message-Id: <20221013234349.1165689-4-yury.norov@gmail.com>
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

If the mask is initialized unconditionally, it's possible to use bitmap
API to traverse it, which is done in the following patch.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 net/core/dev.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 9dc6fcb0d48a..8049e2ff11a5 100644
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
@@ -2565,9 +2565,12 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 
 	if (type == XPS_RXQS) {
 		nr_ids = dev->num_rx_queues;
+		online_mask = bitmap_alloc(nr_ids, GFP_KERNEL);
+		if (!online_mask)
+			return -ENOMEM;
+		bitmap_fill(online_mask, nr_ids);
 	} else {
-		if (num_possible_cpus() > 1)
-			online_mask = cpumask_bits(cpu_online_mask);
+		online_mask = cpumask_bits(cpu_online_mask);
 		nr_ids = nr_cpu_ids;
 	}
 
@@ -2593,10 +2596,8 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
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
@@ -2718,7 +2719,8 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 
 out_no_maps:
 	mutex_unlock(&xps_map_mutex);
-
+	if (type == XPS_RXQS)
+		bitmap_free(online_mask);
 	return 0;
 error:
 	/* remove any maps that we added */
@@ -2733,8 +2735,10 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
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

