Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBB15F23CF
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 17:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiJBPRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 11:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiJBPRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 11:17:12 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B991333366;
        Sun,  2 Oct 2022 08:17:11 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id i17so5423363qkk.12;
        Sun, 02 Oct 2022 08:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Cdmdvt4PzUIP4O/wQczynlHDCFpHnvAILdyowmLgLfQ=;
        b=KE4v1rHkhqaIYZH0QZ8JwRyjiiYgTu/A5lcPsR/qEthJVBUcNJepq24wY+8eCJt6Bi
         TW/c647QIlbIOVVOrvJTcUdke4iKdqqyIrRSacWwVCmqqQr1Ej4H/da4NXd+pa30FOAT
         KTsfZ36+Yr/Vwz/T+bRevORqABCI5aZT0PMEDZ/GKstX9uDl5IH5DW9OXzO2HDzIPL2u
         CXHDV1YOtg/0tvVAYw62J5tF4yALebbJhzm2IEjIT227VflqGI9wAW9r0QHUPYlJWh0D
         8ELrjEJGO/XBSAubLZH2iUYFGQmKlfoWEy+4zYyaEQbAioB8qtEWzXi28cB2jKkYsLhW
         syNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Cdmdvt4PzUIP4O/wQczynlHDCFpHnvAILdyowmLgLfQ=;
        b=KQtG+ELWaALQsBdutv/D+AEuAEadipgaVTyUq7EjwnG+LK+NeoGaFW3U+e1Mb6Guuw
         k8MhZ+L0MVsPq3UVyXPLEbpPUSVIritLQ2FDILU8FHGqT/EtlfXVdiCAJ8HpijFBPsjI
         aWBA0MMinXEGlq1GLLyzDB1j+EzMr+jZfd7UKoVp2lmi5pBI0eC51WQa/KKM+pUXPNua
         v+imSJo2rK1rIl7lTUFakF/KruK7Z1zF/IjtNB2CDvQAQzKv5XwbSWfUVpSp9C1cs533
         HVTBuAIK8ZnsgRVOf/8Pz9LOvXkYXu0SQeVglAbGNagQSLMXSybF1djMeOY63EEefb67
         ou3g==
X-Gm-Message-State: ACrzQf3TWCbuAKujQtV0VjtgKurcX2HNPNApxSnbkscEYi51FfR+eTjg
        wUztlPacdkZOPXjSPcd5JtssBkaRhn8=
X-Google-Smtp-Source: AMsMyM7uqw9j4c0A1Zszx7WqKUWTUZifHxOIE/pSsQn6jKy8zvFgFRgTZbMI+fBWsp3LyRXzQDaakw==
X-Received: by 2002:a05:620a:38a:b0:6cd:ecc8:e84 with SMTP id q10-20020a05620a038a00b006cdecc80e84mr11380724qkm.692.1664723830719;
        Sun, 02 Oct 2022 08:17:10 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:ec09:fca7:de7a:72aa])
        by smtp.gmail.com with ESMTPSA id z13-20020ac8454d000000b0035a7070e909sm6918358qtn.38.2022.10.02.08.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Oct 2022 08:17:10 -0700 (PDT)
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
Subject: [PATCH 2/4] net: merge XPS_CPU_DEV_MAPS_SIZE and XPS_RXQ_DEV_MAPS_SIZE macros
Date:   Sun,  2 Oct 2022 08:17:00 -0700
Message-Id: <20221002151702.3932770-3-yury.norov@gmail.com>
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

The macros are used in a single place, and merging them
would simplify the code.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/netdevice.h | 7 ++-----
 net/core/dev.c            | 3 +--
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 4d6d5a2dd82e..6f8cdd5c7908 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -819,11 +819,8 @@ struct xps_dev_maps {
 	struct xps_map __rcu *attr_map[]; /* Either CPUs map or RXQs map */
 };
 
-#define XPS_CPU_DEV_MAPS_SIZE(_tcs) (sizeof(struct xps_dev_maps) +	\
-	(nr_cpu_ids * (_tcs) * sizeof(struct xps_map *)))
-
-#define XPS_RXQ_DEV_MAPS_SIZE(_tcs, _rxqs) (sizeof(struct xps_dev_maps) +\
-	(_rxqs * (_tcs) * sizeof(struct xps_map *)))
+#define XPS_DEV_MAPS_SIZE(_tcs, nr) (sizeof(struct xps_dev_maps) +\
+	((nr) * (_tcs) * sizeof(struct xps_map *)))
 
 #endif /* CONFIG_XPS */
 
diff --git a/net/core/dev.c b/net/core/dev.c
index b848a75026c4..39a4cc7b3a06 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2564,15 +2564,14 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 	}
 
 	if (type == XPS_RXQS) {
-		maps_sz = XPS_RXQ_DEV_MAPS_SIZE(num_tc, dev->num_rx_queues);
 		nr_ids = dev->num_rx_queues;
 	} else {
-		maps_sz = XPS_CPU_DEV_MAPS_SIZE(num_tc);
 		if (num_possible_cpus() > 1)
 			online_mask = cpumask_bits(cpu_online_mask);
 		nr_ids = nr_cpu_ids;
 	}
 
+	maps_sz = XPS_DEV_MAPS_SIZE(num_tc, nr_ids);
 	if (maps_sz < L1_CACHE_BYTES)
 		maps_sz = L1_CACHE_BYTES;
 
-- 
2.34.1

