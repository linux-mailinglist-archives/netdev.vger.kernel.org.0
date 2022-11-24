Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D28286370E4
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 04:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiKXDS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 22:18:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiKXDS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 22:18:27 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5E8CB680;
        Wed, 23 Nov 2022 19:18:21 -0800 (PST)
X-UUID: 9a08e972898247dea47641fafa7c5869-20221124
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=u5+pFYua6/l1kuQGRysiQMlUlfivreEacbkKmrw9oA4=;
        b=lL37L19ishtpHa1/javh0ehkX4mte53sVDScT12cq5UzUP8WALtEmGtuJdgo3Id/QyyHO/4/mdGj6Hj1vQArbIHsUzYC8Wa0poaBmZ1BAPDqF4mTvBnSaZUNsQloiz09KR3tsjA8/rewWx21piTRBdifs3sVEmvJec7NjdzyrbE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.13,REQID:8fa159ea-1209-4567-8176-d266b5b5984e,IP:0,U
        RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:100,FILE:0,BULK:0,RULE:Release_Ham,ACTI
        ON:release,TS:95
X-CID-INFO: VERSION:1.1.13,REQID:8fa159ea-1209-4567-8176-d266b5b5984e,IP:0,URL
        :0,TC:0,Content:-5,EDM:0,RT:0,SF:100,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTI
        ON:quarantine,TS:95
X-CID-META: VersionHash:d12e911,CLOUDID:c6ee27f9-3a34-4838-abcf-dfedf9dd068e,B
        ulkID:22112311232651OBQXJC,BulkQuantity:5,Recheck:0,SF:28|17|19|48,TC:nil,
        Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:40,QS:nil,BEC:nil,COL:0
X-UUID: 9a08e972898247dea47641fafa7c5869-20221124
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <sujuan.chen@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1476388266; Thu, 24 Nov 2022 11:18:18 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Thu, 24 Nov 2022 11:18:17 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Thu, 24 Nov 2022 11:18:16 +0800
From:   Sujuan Chen <sujuan.chen@mediatek.com>
To:     <netdev@vger.kernel.org>
CC:     Felix Fietkau <nbd@nbd.name>, <linux-kernel@vger.kernel.org>,
        "Lorenzo Bianconi" <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "Evelyn Tsai" <evelyn.tsai@mediatek.com>,
        Bo Jiao <bo.jiao@mediatek.com>,
        linux-mediatek <linux-mediatek@lists.infradead.org>,
        Sujuan Chen <sujuan.chen@mediatek.com>
Subject: [PATCH,v2] net: ethernet: mtk_wed: add wcid overwritten support for wed v1
Date:   Thu, 24 Nov 2022 11:18:14 +0800
Message-ID: <36d6cf34361ba648ad307affb0371d94663c108d.1669259807.git.sujuan.chen@mediatek.com>
X-Mailer: git-send-email 2.17.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All wed versions should enable the wcid overwritten feature,
since the wcid size is controlled by the wlan driver.

Tested-by: Sujuan Chen <sujuan.chen@mediatek.com>
Co-developed-by: Bo Jiao <bo.jiao@mediatek.com>
Signed-off-by: Bo Jiao <bo.jiao@mediatek.com>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
---
v2: get rid of the unnecessary if condition
---
 drivers/net/ethernet/mediatek/mtk_wed.c      | 13 ++++++++-----
 drivers/net/ethernet/mediatek/mtk_wed_regs.h |  2 ++
 include/linux/soc/mediatek/mtk_wed.h         |  3 +++
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 7d8842378c2b..16d7af88bbac 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -526,9 +526,9 @@ mtk_wed_dma_disable(struct mtk_wed_device *dev)
 			MTK_WED_WPDMA_RX_D_RX_DRV_EN);
 		wed_clr(dev, MTK_WED_WDMA_GLO_CFG,
 			MTK_WED_WDMA_GLO_CFG_TX_DDONE_CHK);
-
-		mtk_wed_set_512_support(dev, false);
 	}
+
+	mtk_wed_set_512_support(dev, false);
 }
 
 static void
@@ -1290,9 +1290,10 @@ mtk_wed_start(struct mtk_wed_device *dev, u32 irq_mask)
 		if (mtk_wed_rro_cfg(dev))
 			return;
 
-		mtk_wed_set_512_support(dev, dev->wlan.wcid_512);
 	}
 
+	mtk_wed_set_512_support(dev, dev->wlan.wcid_512);
+
 	mtk_wed_dma_enable(dev);
 	dev->running = true;
 }
@@ -1358,11 +1359,13 @@ mtk_wed_attach(struct mtk_wed_device *dev)
 	}
 
 	mtk_wed_hw_init_early(dev);
-	if (hw->version == 1)
+	if (hw->version == 1) {
 		regmap_update_bits(hw->hifsys, HIFSYS_DMA_AG_MAP,
 				   BIT(hw->index), 0);
-	else
+	} else {
+		dev->rev_id = wed_r32(dev, MTK_WED_REV_ID);
 		ret = mtk_wed_wo_init(hw);
+	}
 out:
 	if (ret)
 		mtk_wed_detach(dev);
diff --git a/drivers/net/ethernet/mediatek/mtk_wed_regs.h b/drivers/net/ethernet/mediatek/mtk_wed_regs.h
index 9e39dace95eb..873d50b9a6e6 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_regs.h
+++ b/drivers/net/ethernet/mediatek/mtk_wed_regs.h
@@ -20,6 +20,8 @@ struct mtk_wdma_desc {
 	__le32 info;
 } __packed __aligned(4);
 
+#define MTK_WED_REV_ID					0x004
+
 #define MTK_WED_RESET					0x008
 #define MTK_WED_RESET_TX_BM				BIT(0)
 #define MTK_WED_RESET_TX_FREE_AGENT			BIT(4)
diff --git a/include/linux/soc/mediatek/mtk_wed.h b/include/linux/soc/mediatek/mtk_wed.h
index 8294978f4bca..1b1ef57609f7 100644
--- a/include/linux/soc/mediatek/mtk_wed.h
+++ b/include/linux/soc/mediatek/mtk_wed.h
@@ -85,6 +85,9 @@ struct mtk_wed_device {
 	int irq;
 	u8 version;
 
+	/* used by wlan driver */
+	u32 rev_id;
+
 	struct mtk_wed_ring tx_ring[MTK_WED_TX_QUEUES];
 	struct mtk_wed_ring rx_ring[MTK_WED_RX_QUEUES];
 	struct mtk_wed_ring txfree_ring;
-- 
2.18.0

