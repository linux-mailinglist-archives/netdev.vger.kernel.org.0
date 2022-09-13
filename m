Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9D35B7904
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 20:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbiIMSA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 14:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbiIMSAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 14:00:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29525AB40E;
        Tue, 13 Sep 2022 10:02:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C700BB80EFC;
        Tue, 13 Sep 2022 17:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA9DC433D7;
        Tue, 13 Sep 2022 17:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663088523;
        bh=b79gxAGo/3/7ht6y1pJ+KEuYpGyQY3VF4J+joPURoo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ie6rI99WYFEY3daVkYdtM6hYLNzfDjf0jc0coK3ODlMg00NMwu6iqgficDAKO0e5i
         M9D7GHIQ2uVm6/hylS18OcvGeMwxtmQNrchDpV7fvsTI+0qem3zDWj+DQo1bLPMB/s
         hZV0K97rSp8KBvd4TNv9OVaGrL3C0Im1pdEIhgH51tiiiW3SDmtaV1XjSIGdQdGKxW
         fWAShy2NfLufCiVrEs5U8kogk7tqoGvgWR5vkwufwS7xvLaHH75TIUbEhRG5AxsRLG
         9sHcMAZj0TtKuSCLPRc/orI8i71MTerZ9N+iIqRTCjoioNvJeMb8PrL11J/wLeU/sC
         MnU4gYhIwmd7Q==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh@kernel.org, daniel@makrotopia.org
Subject: [PATCH v2 net-next 06/11] net: ethernet: mtk_eth_soc: move wdma_base definitions in mtk register map
Date:   Tue, 13 Sep 2022 19:00:56 +0200
Message-Id: <8e9fe9537373aa0dde270cab73590db6be53e215.1663087836.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1663087836.git.lorenzo@kernel.org>
References: <cover.1663087836.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a preliminary patch to introduce mt7986 wed support.

Tested-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 16 ++++++++++------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  4 +---
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index bbafe5598b14..f289b994e7d5 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -75,6 +75,10 @@ static const struct mtk_reg_map mtk_reg_map = {
 	.gdm1_cnt		= 0x2400,
 	.gdma_to_ppe		= 0x4444,
 	.ppe_base		= 0x0c00,
+	.wdma_base = {
+		[0]		= 0x2800,
+		[1]		= 0x2c00,
+	},
 };
 
 static const struct mtk_reg_map mt7628_reg_map = {
@@ -130,6 +134,10 @@ static const struct mtk_reg_map mt7986_reg_map = {
 	.gdm1_cnt		= 0x1c00,
 	.gdma_to_ppe		= 0x3333,
 	.ppe_base		= 0x2000,
+	.wdma_base = {
+		[0]		= 0x4800,
+		[1]		= 0x4c00,
+	},
 };
 
 /* strings used by ethtool */
@@ -4019,16 +4027,12 @@ static int mtk_probe(struct platform_device *pdev)
 	for (i = 0;; i++) {
 		struct device_node *np = of_parse_phandle(pdev->dev.of_node,
 							  "mediatek,wed", i);
-		static const u32 wdma_regs[] = {
-			MTK_WDMA0_BASE,
-			MTK_WDMA1_BASE
-		};
 		void __iomem *wdma;
 
-		if (!np || i >= ARRAY_SIZE(wdma_regs))
+		if (!np || i >= ARRAY_SIZE(eth->soc->reg_map->wdma_base))
 			break;
 
-		wdma = eth->base + wdma_regs[i];
+		wdma = eth->base + eth->soc->reg_map->wdma_base[i];
 		mtk_wed_add_hw(np, eth, wdma, i);
 	}
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 54448795159d..39a0361ca989 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -268,9 +268,6 @@
 #define TX_DMA_FPORT_MASK_V2	0xf
 #define TX_DMA_SWC_V2		BIT(30)
 
-#define MTK_WDMA0_BASE		0x2800
-#define MTK_WDMA1_BASE		0x2c00
-
 /* QDMA descriptor txd4 */
 #define TX_DMA_CHKSUM		(0x7 << 29)
 #define TX_DMA_TSO		BIT(28)
@@ -956,6 +953,7 @@ struct mtk_reg_map {
 	u32	gdm1_cnt;
 	u32	gdma_to_ppe;
 	u32	ppe_base;
+	u32	wdma_base[2];
 };
 
 /* struct mtk_eth_data -	This is the structure holding all differences
-- 
2.37.3

