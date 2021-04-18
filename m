Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9136E363726
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 20:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbhDRS3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 14:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbhDRS3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 14:29:34 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51473C06174A
        for <netdev@vger.kernel.org>; Sun, 18 Apr 2021 11:29:04 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id j4so12991162lfp.0
        for <netdev@vger.kernel.org>; Sun, 18 Apr 2021 11:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s5hG5L8i2Cd9fR/Na6z9GigACne+AqN5PEsIeacfU/c=;
        b=XjTKjCaKdbA7vB6oNe4kQnouJxYQYxGFb6iSJQd3vcYBGENBSg3FRSzcX4A++ARmhv
         CFkJXdHNnlmroWS428m+4mS2A8CZY49BxNYcJhjYqp8XBttSqaNp2eRZhX64yKMbv4Ab
         KBqi61wjuuEGBVX4ro10lZw/m3a8GX9c0GfM6u6ogDXECSZh7SkOU0WXjibEOMakMeWs
         M3mLaIj9gXfj+d8eTQOscSGO+rv41KRlhGWnmlgwo2VfFdNnkfDe+kn9fJf4BrGpCSYa
         NJdRn0MqKgcw2SqaEb7Zyh75P9L5K1iXotiC6awDAThF2efBPHwYhV+oFxUPnC/2uIRH
         5kUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s5hG5L8i2Cd9fR/Na6z9GigACne+AqN5PEsIeacfU/c=;
        b=mvZYfAGuqU7hMQA1mLelWKcCDOoiB+oLX0z+TLcn/Z9YzvORdOnaeRPPFeUsb7EVbm
         mFVi13aiqnjNGf1WBNYIUdhrweQoFqQ5iTNNLV0B5McqbSGiodpjBn/d1pfXnnB5mrRp
         4MnKZmCjnBxZp/egL9sfNL9G0DEFTmm6LiJXuyn1ZkLAKPfezfV54bITf8w6UXo8uC5A
         hTDWAjOBX2D053Gy6vZj/J+MzjLuyPxw92bxssETc8PKiemKF+0shXBrF1aVk4AI9dvY
         10FVmZf/CWwSgSFtWuti27ST/0AO4uHGTjUFxCPcz1tm+1BlXZM8DynkhctZR/FyxCJC
         s3sA==
X-Gm-Message-State: AOAM531m58xkHVnP97/EsmcFlRkpeRyhYjto4ZKa6/k+xM5uo0hhMaAE
        m+8dnIWZE8Ibahzo7n1frqLMTctj+cuN0w==
X-Google-Smtp-Source: ABdhPJwsB91UUuNRzABSGCQpInLS3O0yJV3+QpxzJHEbz1nBCCzE4VsRrF+l25Zd/leY59B0Uo9ayQ==
X-Received: by 2002:a19:6558:: with SMTP id c24mr9933384lfj.313.1618770542407;
        Sun, 18 Apr 2021 11:29:02 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id w14sm1609594lfp.147.2021.04.18.11.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 11:29:02 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] net: ethernet: ixp4xx: Set the DMA masks explicitly
Date:   Sun, 18 Apr 2021 20:28:53 +0200
Message-Id: <20210418182853.1759584-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The former fix only papered over the actual problem: the
ethernet core expects the netdev .dev member to have the
proper DMA masks set, or there will be BUG_ON() triggered
in kernel/dma/mapping.c.

Fix this by simply copying dma_mask and dma_mask_coherent
from the parent device.

Fixes: e45d0fad4a5f ("net: ethernet: ixp4xx: Use parent dev for DMA pool")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index c5b80359124d..956f2b1ee0e4 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1084,7 +1084,7 @@ static int init_queues(struct port *port)
 	int i;
 
 	if (!ports_open) {
-		dma_pool = dma_pool_create(DRV_NAME, port->netdev->dev.parent,
+		dma_pool = dma_pool_create(DRV_NAME, &port->netdev->dev,
 					   POOL_ALLOC_SIZE, 32, 0);
 		if (!dma_pool)
 			return -ENOMEM;
@@ -1488,6 +1488,9 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	ndev->netdev_ops = &ixp4xx_netdev_ops;
 	ndev->ethtool_ops = &ixp4xx_ethtool_ops;
 	ndev->tx_queue_len = 100;
+	/* Inherit the DMA masks from the platform device */
+	ndev->dev.dma_mask = dev->dma_mask;
+	ndev->dev.coherent_dma_mask = dev->coherent_dma_mask;
 
 	netif_napi_add(ndev, &port->napi, eth_poll, NAPI_WEIGHT);
 
-- 
2.29.2

