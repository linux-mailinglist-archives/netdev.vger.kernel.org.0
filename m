Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D39CD55F396
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 04:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiF2Cvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 22:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiF2Cvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 22:51:31 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E44E22506;
        Tue, 28 Jun 2022 19:51:26 -0700 (PDT)
X-UUID: d6b75f53a3c24b80a7c830a318f1a85d-20220629
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.7,REQID:da2255b7-b196-4816-9f1b-52880c5cfc85,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:100,FILE:0,RULE:Release_Ham,A
        CTION:release,TS:95
X-CID-INFO: VERSION:1.1.7,REQID:da2255b7-b196-4816-9f1b-52880c5cfc85,OB:0,LOB:
        0,IP:0,URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:100,FILE:0,RULE:Spam_GS981B3D,A
        CTION:quarantine,TS:95
X-CID-META: VersionHash:87442a2,CLOUDID:6c7b0a86-57f0-47ca-ba27-fe8c57fbf305,C
        OID:130e33f6107c,Recheck:0,SF:28|17|19|48,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,QS:nil,BEC:nil,COL:0
X-UUID: d6b75f53a3c24b80a7c830a318f1a85d-20220629
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1810323639; Wed, 29 Jun 2022 10:51:15 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Wed, 29 Jun 2022 10:51:14 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.3 via Frontend
 Transport; Wed, 29 Jun 2022 10:51:13 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Fabien Parent <fparent@baylibre.com>
CC:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Biao Huang <biao.huang@mediatek.com>,
        Yinghua Pan <ot_yinghua.pan@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>
Subject: [PATCH net-next v4 01/10] net: ethernet: mtk-star-emac: store bit_clk_div in compat structure
Date:   Wed, 29 Jun 2022 10:51:00 +0800
Message-ID: <20220629025109.21933-2-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220629025109.21933-1-biao.huang@mediatek.com>
References: <20220629025109.21933-1-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not all the SoC are using the same clock divider. Move the divider into
a compat structure specific to the SoCs.

Signed-off-by: Biao Huang <biao.huang@mediatek.com>
Signed-off-by: Fabien Parent <fparent@baylibre.com>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 23 +++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index 95839fd84dab..9c54043f7866 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include <linux/platform_device.h>
@@ -231,6 +232,10 @@ struct mtk_star_ring {
 	unsigned int tail;
 };
 
+struct mtk_star_compat {
+	unsigned char bit_clk_div;
+};
+
 struct mtk_star_priv {
 	struct net_device *ndev;
 
@@ -256,6 +261,8 @@ struct mtk_star_priv {
 	int duplex;
 	int pause;
 
+	const struct mtk_star_compat *compat_data;
+
 	/* Protects against concurrent descriptor access. */
 	spinlock_t lock;
 
@@ -898,7 +905,7 @@ static void mtk_star_init_config(struct mtk_star_priv *priv)
 	regmap_write(priv->regs, MTK_STAR_REG_SYS_CONF, val);
 	regmap_update_bits(priv->regs, MTK_STAR_REG_MAC_CLK_CONF,
 			   MTK_STAR_MSK_MAC_CLK_CONF,
-			   MTK_STAR_BIT_CLK_DIV_10);
+			   priv->compat_data->bit_clk_div);
 }
 
 static void mtk_star_set_mode_rmii(struct mtk_star_priv *priv)
@@ -1460,6 +1467,7 @@ static int mtk_star_probe(struct platform_device *pdev)
 
 	priv = netdev_priv(ndev);
 	priv->ndev = ndev;
+	priv->compat_data = of_device_get_match_data(&pdev->dev);
 	SET_NETDEV_DEV(ndev, dev);
 	platform_set_drvdata(pdev, ndev);
 
@@ -1556,10 +1564,17 @@ static int mtk_star_probe(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_OF
+static const struct mtk_star_compat mtk_star_mt8516_compat = {
+	.bit_clk_div = MTK_STAR_BIT_CLK_DIV_10,
+};
+
 static const struct of_device_id mtk_star_of_match[] = {
-	{ .compatible = "mediatek,mt8516-eth", },
-	{ .compatible = "mediatek,mt8518-eth", },
-	{ .compatible = "mediatek,mt8175-eth", },
+	{ .compatible = "mediatek,mt8516-eth",
+	  .data = &mtk_star_mt8516_compat },
+	{ .compatible = "mediatek,mt8518-eth",
+	  .data = &mtk_star_mt8516_compat },
+	{ .compatible = "mediatek,mt8175-eth",
+	  .data = &mtk_star_mt8516_compat },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, mtk_star_of_match);
-- 
2.25.1

