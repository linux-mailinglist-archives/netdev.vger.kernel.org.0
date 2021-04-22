Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C218136785B
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 06:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234885AbhDVELN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 00:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234797AbhDVEKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 00:10:25 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7388C06138E;
        Wed, 21 Apr 2021 21:09:49 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so247012pjh.1;
        Wed, 21 Apr 2021 21:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gTam4Dh4Exrox41UjgsTUAzDdF7hSjfRPYT1wQxzNIA=;
        b=h4Ws/FzzrLMIqrmOr0IySyYw5sQpcKQebJ4fr52tIz8OeJS0J18r+Kk3Yby02VwCZb
         lB0VnuYreH0/WBg432DwfJyANbzRXjq+RyqMjMV91avjh7P6AVWyD36N3taxcUivyk81
         gRifTzGqz56xEmn2k6jtorxqr5N1vLDH+pPNDe+b83J928uzB0K9oz/QkVW18/V0NOEm
         PmNXRP4p7ocJ3OqSd75VYOZ622O3F6Tb2dKbCXDirHHasEkzg3neP8XRcwVvl6xSnCcV
         p6+FpUvxCPmYMV8eIuZjKOIvK1JtK9l7z/eVW37FaQEAOnPMN480/2GGvYDW3XruZYWi
         OurQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gTam4Dh4Exrox41UjgsTUAzDdF7hSjfRPYT1wQxzNIA=;
        b=YOJ22B4TCoKas1FzeX/4/E690QhwjseauqICd3gUSM0zIvkBcJI3uKSCeOLFK29rj3
         n1nt4nG+4FtjZOUEoeBuGScC+6GjUl7yBRispxzKzgg4RxtqfKqZxMCIZVEwuWSJZgzl
         Ev2dparxe05HCv/uf8kV9TaU0ocq6H76Wn+I1t6q+0r4tyhmaJwmiMfb08kBIFOQY+6H
         nJa5niR8EOErHmNIm2N1bo4bEdfEiuJXahdMrWcUlhok79/tu9GPEgnwAYVhAcO/TqGs
         cBborCt/2onD38n/QtIaO8Tu1LdifW9PJb+2LBssUa6A1rnUlLlC+FXcrdnJKXtBAPWI
         PgVg==
X-Gm-Message-State: AOAM530r0VAXqhwACUovjchccKIkwV4bznkRDEwrRgXc9hThFaTKlWKC
        fFqiDvad+PvW3FDjikAVdYU=
X-Google-Smtp-Source: ABdhPJzmrEjvXUJJGC9Se3LcQu04Mdkl0aXOfVWFnghAJi2orXke+l4GVOKEPwHkQQLbn8xZTwi3fw==
X-Received: by 2002:a17:902:778f:b029:ec:d04d:4556 with SMTP id o15-20020a170902778fb02900ecd04d4556mr1407386pll.43.1619064589415;
        Wed, 21 Apr 2021 21:09:49 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id i17sm635354pfd.84.2021.04.21.21.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 21:09:49 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH net-next 14/14] net: ethernet: mtk_eth_soc: use iopoll.h macro for DMA init
Date:   Wed, 21 Apr 2021 21:09:14 -0700
Message-Id: <20210422040914.47788-15-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
References: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace a tight busy-wait loop without a pause with a standard
readx_poll_timeout_atomic routine with a 5 us poll period.

Tested by booting a MT7621 device to ensure the driver initializes
properly.

Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 29 +++++++++------------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  2 +-
 2 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 8c863322587e..720d73d0c007 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2037,25 +2037,22 @@ static int mtk_set_features(struct net_device *dev, netdev_features_t features)
 /* wait for DMA to finish whatever it is doing before we start using it again */
 static int mtk_dma_busy_wait(struct mtk_eth *eth)
 {
-	unsigned long t_start = jiffies;
+	u32 val;
+	int ret;
+	unsigned int reg;
 
-	while (1) {
-		if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA)) {
-			if (!(mtk_r32(eth, MTK_QDMA_GLO_CFG) &
-			      (MTK_RX_DMA_BUSY | MTK_TX_DMA_BUSY)))
-				return 0;
-		} else {
-			if (!(mtk_r32(eth, MTK_PDMA_GLO_CFG) &
-			      (MTK_RX_DMA_BUSY | MTK_TX_DMA_BUSY)))
-				return 0;
-		}
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA))
+		reg = MTK_QDMA_GLO_CFG;
+	else
+		reg = MTK_PDMA_GLO_CFG;
 
-		if (time_after(jiffies, t_start + MTK_DMA_BUSY_TIMEOUT))
-			break;
-	}
+	ret = readx_poll_timeout_atomic(__raw_readl, eth->base + reg, val,
+					!(val & (MTK_RX_DMA_BUSY | MTK_TX_DMA_BUSY)),
+					5, MTK_DMA_BUSY_TIMEOUT_US);
+	if (ret)
+		dev_err(eth->dev, "DMA init timeout\n");
 
-	dev_err(eth->dev, "DMA init timeout\n");
-	return -1;
+	return ret;
 }
 
 static int mtk_dma_init(struct mtk_eth *eth)
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 214da569e869..2e4356ccf778 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -214,7 +214,7 @@
 #define MTK_TX_DMA_BUSY		BIT(1)
 #define MTK_RX_DMA_EN		BIT(2)
 #define MTK_TX_DMA_EN		BIT(0)
-#define MTK_DMA_BUSY_TIMEOUT	HZ
+#define MTK_DMA_BUSY_TIMEOUT_US	1000000
 
 /* QDMA Reset Index Register */
 #define MTK_QDMA_RST_IDX	0x1A08
-- 
2.31.1

