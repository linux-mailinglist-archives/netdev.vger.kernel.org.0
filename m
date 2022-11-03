Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4804B6179F9
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 10:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiKCJ3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 05:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbiKCJ3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 05:29:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F88F5A9;
        Thu,  3 Nov 2022 02:28:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 535AE61DD9;
        Thu,  3 Nov 2022 09:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A7AC433D7;
        Thu,  3 Nov 2022 09:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667467738;
        bh=bwpSPAXWJjAa9BRDYk7NgD+Z9dfRWcLPuHKoPVIKSsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ssYalvImPiwGQ55BMJ8TBjr1r6tXq2VcaAoHTBpigy2FWit1bIumNqryPdlVr7ORi
         Bhzpp6R5/hMVUpSNvuhJUnMnFGYYfwrGs9qwX8McHeQ+2fRur8oK6QRvR/kJNib7Bw
         MQFXo0Ky1qOE3BRmGubwy8KTIf6/MfESMaMoRlwzWd82m1yW4JWz0gp/bbSlQR5Ydw
         VP0HL+u4uqfItOIceq9uhZ6SFnmZGykHfOazSMDOuROsNim0JghPG025r73dI9NIf5
         IBI664iNAtx6xkZgzOIy29I5M/TmDzVJqI6N1Lm7WV28CVOPj8P/B+jIIpXFi/TSGH
         UD1CEk4BeeRng==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        daniel@makrotopia.org, krzysztof.kozlowski+dt@linaro.org
Subject: [PATCH v3 net-next 5/8] net: ethernet: mtk_wed: rename tx_wdma array in rx_wdma
Date:   Thu,  3 Nov 2022 10:28:04 +0100
Message-Id: <44d32d973d8384fec91c85f177e84ba3c72a1dd4.1667466887.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1667466887.git.lorenzo@kernel.org>
References: <cover.1667466887.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename tx_wdma queue array in rx_wdma since this is rx side of wdma soc.
Moreover rename mtk_wed_wdma_ring_setup routine in
mtk_wed_wdma_rx_ring_setup()

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c | 16 ++++++++--------
 include/linux/soc/mediatek/mtk_wed.h    |  3 ++-
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 9c9dd17332b6..e904596e67de 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -253,8 +253,8 @@ mtk_wed_free_tx_rings(struct mtk_wed_device *dev)
 
 	for (i = 0; i < ARRAY_SIZE(dev->tx_ring); i++)
 		mtk_wed_free_ring(dev, &dev->tx_ring[i]);
-	for (i = 0; i < ARRAY_SIZE(dev->tx_wdma); i++)
-		mtk_wed_free_ring(dev, &dev->tx_wdma[i]);
+	for (i = 0; i < ARRAY_SIZE(dev->rx_wdma); i++)
+		mtk_wed_free_ring(dev, &dev->rx_wdma[i]);
 }
 
 static void
@@ -688,10 +688,10 @@ mtk_wed_ring_alloc(struct mtk_wed_device *dev, struct mtk_wed_ring *ring,
 }
 
 static int
-mtk_wed_wdma_ring_setup(struct mtk_wed_device *dev, int idx, int size)
+mtk_wed_wdma_rx_ring_setup(struct mtk_wed_device *dev, int idx, int size)
 {
 	u32 desc_size = sizeof(struct mtk_wdma_desc) * dev->hw->version;
-	struct mtk_wed_ring *wdma = &dev->tx_wdma[idx];
+	struct mtk_wed_ring *wdma = &dev->rx_wdma[idx];
 
 	if (mtk_wed_ring_alloc(dev, wdma, MTK_WED_WDMA_RING_SIZE, desc_size))
 		return -ENOMEM;
@@ -805,9 +805,9 @@ mtk_wed_start(struct mtk_wed_device *dev, u32 irq_mask)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(dev->tx_wdma); i++)
-		if (!dev->tx_wdma[i].desc)
-			mtk_wed_wdma_ring_setup(dev, i, 16);
+	for (i = 0; i < ARRAY_SIZE(dev->rx_wdma); i++)
+		if (!dev->rx_wdma[i].desc)
+			mtk_wed_wdma_rx_ring_setup(dev, i, 16);
 
 	mtk_wed_hw_init(dev);
 	mtk_wed_configure_irq(dev, irq_mask);
@@ -916,7 +916,7 @@ mtk_wed_tx_ring_setup(struct mtk_wed_device *dev, int idx, void __iomem *regs)
 			       sizeof(*ring->desc)))
 		return -ENOMEM;
 
-	if (mtk_wed_wdma_ring_setup(dev, idx, MTK_WED_WDMA_RING_SIZE))
+	if (mtk_wed_wdma_rx_ring_setup(dev, idx, MTK_WED_WDMA_RING_SIZE))
 		return -ENOMEM;
 
 	ring->reg_base = MTK_WED_RING_TX(idx);
diff --git a/include/linux/soc/mediatek/mtk_wed.h b/include/linux/soc/mediatek/mtk_wed.h
index 2cc2f1e43ba9..956978320f8b 100644
--- a/include/linux/soc/mediatek/mtk_wed.h
+++ b/include/linux/soc/mediatek/mtk_wed.h
@@ -7,6 +7,7 @@
 #include <linux/pci.h>
 
 #define MTK_WED_TX_QUEUES		2
+#define MTK_WED_RX_QUEUES		2
 
 struct mtk_wed_hw;
 struct mtk_wdma_desc;
@@ -66,7 +67,7 @@ struct mtk_wed_device {
 
 	struct mtk_wed_ring tx_ring[MTK_WED_TX_QUEUES];
 	struct mtk_wed_ring txfree_ring;
-	struct mtk_wed_ring tx_wdma[MTK_WED_TX_QUEUES];
+	struct mtk_wed_ring rx_wdma[MTK_WED_RX_QUEUES];
 
 	struct {
 		int size;
-- 
2.38.1

