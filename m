Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37EFD55F3D4
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 05:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbiF2DSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 23:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbiF2DSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 23:18:20 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CAF64CC;
        Tue, 28 Jun 2022 20:18:09 -0700 (PDT)
X-UUID: 42e57ae5806344f8842774a67a63645b-20220629
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.7,REQID:4870107f-3d59-4094-9c42-2e5a6848842b,OB:20,L
        OB:20,IP:0,URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:100,FILE:0,RULE:Release_Ham
        ,ACTION:release,TS:95
X-CID-INFO: VERSION:1.1.7,REQID:4870107f-3d59-4094-9c42-2e5a6848842b,OB:20,LOB
        :20,IP:0,URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:100,FILE:0,RULE:Spam_GS981B3D
        ,ACTION:quarantine,TS:95
X-CID-META: VersionHash:87442a2,CLOUDID:7aace862-0b3f-4b2c-b3a6-ed5c044366a0,C
        OID:3142f75e81e3,Recheck:0,SF:28|17|19|48,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,QS:nil,BEC:nil,COL:0
X-UUID: 42e57ae5806344f8842774a67a63645b-20220629
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 864791453; Wed, 29 Jun 2022 11:18:06 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Wed, 29 Jun 2022 11:18:04 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.3 via Frontend
 Transport; Wed, 29 Jun 2022 11:18:03 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Rob Herring" <robh+dt@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        "Fabien Parent" <fparent@baylibre.com>
CC:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Biao Huang <biao.huang@mediatek.com>,
        Yinghua Pan <ot_yinghua.pan@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>
Subject: [PATCH net-next v5 08/10] net: ethernet: mtk-star-emac: add support for MII interface
Date:   Wed, 29 Jun 2022 11:17:41 +0800
Message-ID: <20220629031743.22115-9-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220629031743.22115-1-biao.huang@mediatek.com>
References: <20220629031743.22115-1-biao.huang@mediatek.com>
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

Add support for MII interface.
If user wants to use MII, assign "MII" to "phy-mode" property in dts.

Signed-off-by: Biao Huang <biao.huang@mediatek.com>
Signed-off-by: Yinghua Pan <ot_yinghua.pan@mediatek.com>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index 05ce62202180..a1165f293494 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -192,6 +192,7 @@ static const char *const mtk_star_clk_names[] = { "core", "reg", "trans" };
 #define MTK_PERICFG_REG_NIC_CFG1_CON		0x03c8
 #define MTK_PERICFG_REG_NIC_CFG_CON_V2		0x0c10
 #define MTK_PERICFG_REG_NIC_CFG_CON_CFG_INTF	GENMASK(3, 0)
+#define MTK_PERICFG_BIT_NIC_CFG_CON_MII		0
 #define MTK_PERICFG_BIT_NIC_CFG_CON_RMII	1
 #define MTK_PERICFG_BIT_NIC_CFG_CON_CLK		BIT(0)
 #define MTK_PERICFG_BIT_NIC_CFG_CON_CLK_V2	BIT(8)
@@ -1462,6 +1463,7 @@ static int mtk_star_set_timing(struct mtk_star_priv *priv)
 	unsigned int delay_val = 0;
 
 	switch (priv->phy_intf) {
+	case PHY_INTERFACE_MODE_MII:
 	case PHY_INTERFACE_MODE_RMII:
 		delay_val |= FIELD_PREP(MTK_STAR_BIT_INV_RX_CLK, priv->rx_inv);
 		delay_val |= FIELD_PREP(MTK_STAR_BIT_INV_TX_CLK, priv->tx_inv);
@@ -1543,7 +1545,8 @@ static int mtk_star_probe(struct platform_device *pdev)
 	ret = of_get_phy_mode(of_node, &priv->phy_intf);
 	if (ret) {
 		return ret;
-	} else if (priv->phy_intf != PHY_INTERFACE_MODE_RMII) {
+	} else if (priv->phy_intf != PHY_INTERFACE_MODE_RMII &&
+		   priv->phy_intf != PHY_INTERFACE_MODE_MII) {
 		dev_err(dev, "unsupported phy mode: %s\n",
 			phy_modes(priv->phy_intf));
 		return -EINVAL;
@@ -1612,6 +1615,10 @@ static int mt8516_set_interface_mode(struct net_device *ndev)
 	unsigned int intf_val, ret, rmii_rxc;
 
 	switch (priv->phy_intf) {
+	case PHY_INTERFACE_MODE_MII:
+		intf_val = MTK_PERICFG_BIT_NIC_CFG_CON_MII;
+		rmii_rxc = 0;
+		break;
 	case PHY_INTERFACE_MODE_RMII:
 		intf_val = MTK_PERICFG_BIT_NIC_CFG_CON_RMII;
 		rmii_rxc = priv->rmii_rxc ? 0 : MTK_PERICFG_BIT_NIC_CFG_CON_CLK;
@@ -1641,6 +1648,9 @@ static int mt8365_set_interface_mode(struct net_device *ndev)
 	unsigned int intf_val;
 
 	switch (priv->phy_intf) {
+	case PHY_INTERFACE_MODE_MII:
+		intf_val = MTK_PERICFG_BIT_NIC_CFG_CON_MII;
+		break;
 	case PHY_INTERFACE_MODE_RMII:
 		intf_val = MTK_PERICFG_BIT_NIC_CFG_CON_RMII;
 		intf_val |= priv->rmii_rxc ? 0 : MTK_PERICFG_BIT_NIC_CFG_CON_CLK_V2;
-- 
2.25.1

