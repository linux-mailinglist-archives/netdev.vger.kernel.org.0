Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886AA497160
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 12:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236271AbiAWL4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 06:56:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbiAWL4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 06:56:34 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D450CC06173B;
        Sun, 23 Jan 2022 03:56:33 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id s61-20020a17090a69c300b001b4d0427ea2so17647818pjj.4;
        Sun, 23 Jan 2022 03:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c57q6A0FIP4IDjy6YM47YIIs0GLG8LtYvDjNRte3Llw=;
        b=fFlj0LcbPkFliHP92jkU+DlBHAdQPePh1gwbYro3KuoMi48AENtp9PIF6dR0sGMDVf
         tzE7tHzb9+Ht+F1FkT1ZldGmbu2P5A8DADT8MFSqZT/xRWKmVds/t+dfgQxLzf4knBbj
         APfEJHiJCXtY21FSLRb/wxssAX+qgYDB093MSEEvQKuOq39zOiPiSsUTGcU2WyVJwWt3
         jUIH0zx+Sg0/2YAWL4BZkUGn5I9phHZGbHuFf7bmW3F8o8lCj3xbxOZjBlBUB8djxSs/
         RY3vtG7STVbsVKz16PuxfAf+o3yG0dX1JTaPt4falnehIquCq3WOaidMTC5pUuu9crQV
         Up7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c57q6A0FIP4IDjy6YM47YIIs0GLG8LtYvDjNRte3Llw=;
        b=CJNI6qwXXSW+rvrU9dRorwKVPW/8sqj1NSsvNDhWnmFN64XNG7em48g71zvp99+aeG
         uMX4alXnubVLzqoYhFUKFwXJ1/ba9kmI0zTS5KGvnB1nAcOQtaFDVsvMCmsRSbUmdTd4
         sTmip1vQbJWjS8O6Ggw3JXDofeH/P5K0KQr6BCca9XAGcE2uClyeH916VRLaX4EcirKC
         /CRxGN1ONMBNgNm7IugU/Nyna+5jUUiJDCAy1i6BPbyIFNpgQCvEzCBtBhpg2csVv9uR
         tAXSwLVv3ttpJOydzmIlVxyKMCMxU2Pu8H5igh8SpzSv0mt3i/x+OU2Zy+QUocRio+Hw
         DBXQ==
X-Gm-Message-State: AOAM533zDuG5CPZ8FcrCfx1sjGVZeHUj7Jc+8MsXW6V+JxI6eaUugrol
        P9ZD550B8y202naCrnjdgfM65aZhT1S+8Q==
X-Google-Smtp-Source: ABdhPJx1yJaUFpC4SyrxKvZFlomih7qLjiV86h/CdFHxAbyflioGRR3xNGybZz//l+jXWPFkfDKZoA==
X-Received: by 2002:a17:903:1107:b0:149:98f7:9629 with SMTP id n7-20020a170903110700b0014998f79629mr10705685plh.160.1642938992789;
        Sun, 23 Jan 2022 03:56:32 -0800 (PST)
Received: from ip-172-31-19-208.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id d1sm12808152pfj.179.2022.01.23.03.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 03:56:32 -0800 (PST)
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sameeh Jubran <sameehj@amazon.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-kernel@vger.kernel.org, Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: [PATCH] net: ena: Do not waste napi skb cache
Date:   Sun, 23 Jan 2022 11:56:23 +0000
Message-Id: <20220123115623.94843-1-42.hyeyoo@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By profiling, discovered that ena device driver allocates skb by
build_skb() and frees by napi_skb_cache_put(). Because the driver
does not use napi skb cache in allocation path, napi skb cache is
periodically filled and flushed. This is waste of napi skb cache.

As ena_alloc_skb() is called only in napi, Use napi_build_skb()
instead of build_skb() to when allocating skb.

This patch was tested on aws a1.metal instance.

Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index c72f0c7ff4aa..2c67fb1703c5 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1407,7 +1407,7 @@ static struct sk_buff *ena_alloc_skb(struct ena_ring *rx_ring, void *first_frag)
 		skb = netdev_alloc_skb_ip_align(rx_ring->netdev,
 						rx_ring->rx_copybreak);
 	else
-		skb = build_skb(first_frag, ENA_PAGE_SIZE);
+		skb = napi_build_skb(first_frag, ENA_PAGE_SIZE);
 
 	if (unlikely(!skb)) {
 		ena_increase_stat(&rx_ring->rx_stats.skb_alloc_fail, 1,
-- 
2.33.1

