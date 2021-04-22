Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A472367855
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 06:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235000AbhDVEKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 00:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234670AbhDVEKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 00:10:21 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AA1C061347;
        Wed, 21 Apr 2021 21:09:46 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id nm3-20020a17090b19c3b029014e1bbf6c60so240563pjb.4;
        Wed, 21 Apr 2021 21:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Smtj4gwdxb0ZLZIeEWGZNPNrgYDMaUuIXb1nAA+jADw=;
        b=m2/PbzI84d6d9OgipdUa6ooqlmZ1yTJHHypRkqQkG2bpVUy3ScKdKsanBUcLcxPxe1
         49Kl7GHhccN4bfMUvm5TbmHyZOKAy0qg1/Lkgd4NpuXTRdVO447y3T1pUIZNBFe+LkVB
         X2sHi/hwQvHU3pJJ8ahjC6omiel2gEdz77r1GYe90YLzLabr0xm7vqS7hBAison6UqOv
         1BUr3umNN7qJe3cJGP4m7zsIIndBNxgYdCrODgwC1Lwzkt4BXbwzaPs9/jhbmsg2+mM8
         0dH7Ab68oGanlDKPvEZLj18t06rr10OH3gBzdHJghF7LbzlSlKd2MXyLZtPiVMow5lUH
         T4dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Smtj4gwdxb0ZLZIeEWGZNPNrgYDMaUuIXb1nAA+jADw=;
        b=dWwCPWHPZC+zVB/Cfy0uZq2+3/Iz/4eCadYp1ImiHq++ElecbPXYpCLRNnTH7D5r1H
         zk4LXHIBWsE6lmwKfg/IKZ4DpLr/MrQOOjan/wWHnxlJJcY1J6vF4EdAvS5B46+HIVPH
         qvyNQEUnoXXPaqP139sH9w5JscTZqN+g5+jMvWHzxM+ah4zpZGQlwZCIHtLFtTgqeKat
         xG+skpY3qwC0Lgk4CKjWBvprA/Ty/IFsEcGm5TosF3X2ihb0rA5prW/7zbehMWEfWyzb
         lhQFBCnXJ104BUqnqGI9IHO1sQgOMmwuWiUiJQlLJN9LRIBx7twsRNCoVfl9/ortA/3f
         0csg==
X-Gm-Message-State: AOAM532jhHNAvJBqUYROVFw4jhcESLBct+7HCo4uBOiMdIqKJ+Fcapc9
        1OajAhwFV8JGAo3J0AY7aOY=
X-Google-Smtp-Source: ABdhPJw/RJBg5z72O0mNnzutjMCrzGHJDTgHgizsfQ9xv1oCCJjoF/x/bDrceXqjOabCBFD3JsC4ew==
X-Received: by 2002:a17:902:edc4:b029:eb:159f:32b7 with SMTP id q4-20020a170902edc4b02900eb159f32b7mr1461172plk.11.1619064585968;
        Wed, 21 Apr 2021 21:09:45 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id i17sm635354pfd.84.2021.04.21.21.09.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 21:09:45 -0700 (PDT)
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
Subject: [PATCH net-next 10/14] net: ethernet: mtk_eth_soc: cache HW pointer of last freed TX descriptor
Date:   Wed, 21 Apr 2021 21:09:10 -0700
Message-Id: <20210422040914.47788-11-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
References: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

The value is only updated by the CPU, so it is cheaper to access from the
ring data structure than from a hardware register.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 8 ++++----
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 2 ++
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 043ab5446524..01ad10c76d53 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1362,7 +1362,7 @@ static int mtk_poll_tx_qdma(struct mtk_eth *eth, int budget,
 	struct mtk_tx_buf *tx_buf;
 	u32 cpu, dma;
 
-	cpu = mtk_r32(eth, MTK_QTX_CRX_PTR);
+	cpu = ring->last_free_ptr;
 	dma = mtk_r32(eth, MTK_QTX_DRX_PTR);
 
 	desc = mtk_qdma_phys_to_virt(ring, cpu);
@@ -1396,6 +1396,7 @@ static int mtk_poll_tx_qdma(struct mtk_eth *eth, int budget,
 		cpu = next_cpu;
 	}
 
+	ring->last_free_ptr = cpu;
 	mtk_w32(eth, cpu, MTK_QTX_CRX_PTR);
 
 	return budget;
@@ -1596,6 +1597,7 @@ static int mtk_tx_alloc(struct mtk_eth *eth)
 	atomic_set(&ring->free_count, MTK_DMA_SIZE - 2);
 	ring->next_free = &ring->dma[0];
 	ring->last_free = &ring->dma[MTK_DMA_SIZE - 1];
+	ring->last_free_ptr = (u32)(ring->phys + ((MTK_DMA_SIZE - 1) * sz));
 	ring->thresh = MAX_SKB_FRAGS;
 
 	/* make sure that all changes to the dma ring are flushed before we
@@ -1609,9 +1611,7 @@ static int mtk_tx_alloc(struct mtk_eth *eth)
 		mtk_w32(eth,
 			ring->phys + ((MTK_DMA_SIZE - 1) * sz),
 			MTK_QTX_CRX_PTR);
-		mtk_w32(eth,
-			ring->phys + ((MTK_DMA_SIZE - 1) * sz),
-			MTK_QTX_DRX_PTR);
+		mtk_w32(eth, ring->last_free_ptr, MTK_QTX_DRX_PTR);
 		mtk_w32(eth, (QDMA_RES_THRES << 8) | QDMA_RES_THRES,
 			MTK_QTX_CFG(0));
 	} else {
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index a8d388b02558..214da569e869 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -642,6 +642,7 @@ struct mtk_tx_buf {
  * @phys:		The physical addr of tx_buf
  * @next_free:		Pointer to the next free descriptor
  * @last_free:		Pointer to the last free descriptor
+ * @last_free_ptr:	Hardware pointer value of the last free descriptor
  * @thresh:		The threshold of minimum amount of free descriptors
  * @free_count:		QDMA uses a linked list. Track how many free descriptors
  *			are present
@@ -652,6 +653,7 @@ struct mtk_tx_ring {
 	dma_addr_t phys;
 	struct mtk_tx_dma *next_free;
 	struct mtk_tx_dma *last_free;
+	u32 last_free_ptr;
 	u16 thresh;
 	atomic_t free_count;
 	int dma_size;
-- 
2.31.1

