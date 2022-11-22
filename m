Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC17633336
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 03:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbiKVCVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 21:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbiKVCVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 21:21:25 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14FE72036D;
        Mon, 21 Nov 2022 18:17:40 -0800 (PST)
X-UUID: 53452f68fdd5447cb992ece0fd039a80-20221122
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=VDymyQAetc3WEtO27z94FAZO4pTlwjOlBCBrAhSOXn4=;
        b=NEcBQQVaHh/gqjO9PGuVjtNL/5Gwlfbfv/P+3CF5uuwh3xiqtej0/Zd0N/IcoRAT39vJJn3t+v/wB+vJavJEN/dOEc/NUmuBJiKaDRV2FtNtkamFNFlc7+nGu31tSCG5YUhisM+T2/GZASQsATXGO6g0yKkE4mvXjCNDZGaF2OE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.12,REQID:db0bf781-6641-4807-860b-75e724fdbe99,IP:0,U
        RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:100,FILE:0,BULK:0,RULE:Release_Ham,ACTI
        ON:release,TS:95
X-CID-INFO: VERSION:1.1.12,REQID:db0bf781-6641-4807-860b-75e724fdbe99,IP:0,URL
        :0,TC:0,Content:-5,EDM:0,RT:0,SF:100,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTI
        ON:quarantine,TS:95
X-CID-META: VersionHash:62cd327,CLOUDID:9acb6e2f-2938-482e-aafd-98d66723b8a9,B
        ulkID:221121105616SQ0WFPLA,BulkQuantity:4,Recheck:0,SF:28|17|19|48,TC:nil,
        Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:41,QS:nil,BEC:nil,COL:0
X-UUID: 53452f68fdd5447cb992ece0fd039a80-20221122
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <sujuan.chen@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1697112962; Tue, 22 Nov 2022 10:17:34 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Tue, 22 Nov 2022 10:17:33 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Tue, 22 Nov 2022 10:17:31 +0800
From:   Sujuan Chen <sujuan.chen@mediatek.com>
To:     <netdev@vger.kernel.org>
CC:     Felix Fietkau <nbd@nbd.name>, <linux-kernel@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Evelyn Tsai <evelyn.tsai@mediatek.com>,
        Bo Jiao <bo.jiao@mediatek.com>,
        linux-mediatek <linux-mediatek@lists.infradead.org>,
        Sujuan Chen <sujuan.chen@mediatek.com>
Subject: [PATCH,RESEND] net: ethernet: mtk_wed: add wcid overwritten support for wed v1
Date:   Tue, 22 Nov 2022 10:17:29 +0800
Message-ID: <217932f091aa9d9cb5e876a2e958ca25f80f80b2.1668997816.git.sujuan.chen@mediatek.com>
X-Mailer: git-send-email 2.17.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All wed versions should enable wcid overwritten feature,
since the wcid size is controlled by the wlan driver.

Tested-by: Sujuan Chen <sujuan.chen@mediatek.com>
Co-developed-by: Bo Jiao <bo.jiao@mediatek.com>
Signed-off-by: Bo Jiao <bo.jiao@mediatek.com>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
---
 drivers/net/ethernet/mediatek/mtk_wed.c      | 9 ++++++---
 drivers/net/ethernet/mediatek/mtk_wed_regs.h | 2 ++
 include/linux/soc/mediatek/mtk_wed.h         | 3 +++
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 7d8842378c2b..a20093803e04 100644
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
@@ -1338,6 +1339,8 @@ mtk_wed_attach(struct mtk_wed_device *dev)
 	dev->irq = hw->irq;
 	dev->wdma_idx = hw->index;
 	dev->version = hw->version;
+	if (hw->version != 1)
+		dev->rev_id = wed_r32(dev, MTK_WED_REV_ID);
 
 	if (hw->eth->dma_dev == hw->eth->dev &&
 	    of_dma_is_coherent(hw->eth->dev->of_node))
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

