Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC6B554725
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356359AbiFVJGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 05:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355950AbiFVJGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 05:06:03 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4329F13A;
        Wed, 22 Jun 2022 02:06:01 -0700 (PDT)
X-UUID: fba18e59ba1841958de182e8c3b4ad21-20220622
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.6,REQID:cb4b8dcb-b383-4b01-989b-73213bb80851,OB:10,L
        OB:10,IP:0,URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:100,FILE:0,RULE:Release_Ham
        ,ACTION:release,TS:95
X-CID-INFO: VERSION:1.1.6,REQID:cb4b8dcb-b383-4b01-989b-73213bb80851,OB:10,LOB
        :10,IP:0,URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:100,FILE:0,RULE:Spam_GS981B3D
        ,ACTION:quarantine,TS:95
X-CID-META: VersionHash:b14ad71,CLOUDID:d7512a38-5e4b-44d7-80b2-bb618cb09d29,C
        OID:bd337299e01f,Recheck:0,SF:28|17|19|48,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,QS:nil,BEC:nil,COL:0
X-UUID: fba18e59ba1841958de182e8c3b4ad21-20220622
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1481033714; Wed, 22 Jun 2022 17:05:56 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Wed, 22 Jun 2022 17:05:54 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.3 via Frontend
 Transport; Wed, 22 Jun 2022 17:05:53 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Fabien Parent <fparent@baylibre.com>
CC:     Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Biao Huang <biao.huang@mediatek.com>,
        Yinghua Pan <ot_yinghua.pan@mediatek.com>,
        <srv_heupstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>
Subject: [PATCH net-next v3 05/10] net: ethernet: mtk-star-emac: add clock pad selection for RMII
Date:   Wed, 22 Jun 2022 17:05:40 +0800
Message-ID: <20220622090545.23612-6-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220622090545.23612-1-biao.huang@mediatek.com>
References: <20220622090545.23612-1-biao.huang@mediatek.com>
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

This patch add a new dts property named "mediatek,rmii-rxc" parsing
in driver, which will configure MAC to select which pin the RMII reference
clock is connected to, TXC or RXC.

TXC pad is the default reference clock pin. If user wants to use RXC pad
instead, add "mediatek,rmii-rxc" to corresponding device node.

Signed-off-by: Biao Huang <biao.huang@mediatek.com>
Signed-off-by: Yinghua Pan <ot_yinghua.pan@mediatek.com>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index 3776af9ac1ff..b4d37728be69 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -188,6 +188,8 @@ static const char *const mtk_star_clk_names[] = { "core", "reg", "trans" };
 #define MTK_PERICFG_REG_NIC_CFG_CON_V2		0x0c10
 #define MTK_PERICFG_REG_NIC_CFG_CON_CFG_INTF	GENMASK(3, 0)
 #define MTK_PERICFG_BIT_NIC_CFG_CON_RMII	1
+#define MTK_PERICFG_BIT_NIC_CFG_CON_CLK		BIT(0)
+#define MTK_PERICFG_BIT_NIC_CFG_CON_CLK_V2	BIT(8)
 
 /* Represents the actual structure of descriptors used by the MAC. We can
  * reuse the same structure for both TX and RX - the layout is the same, only
@@ -264,6 +266,7 @@ struct mtk_star_priv {
 	int speed;
 	int duplex;
 	int pause;
+	bool rmii_rxc;
 
 	const struct mtk_star_compat *compat_data;
 
@@ -1527,6 +1530,8 @@ static int mtk_star_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	priv->rmii_rxc = of_property_read_bool(of_node, "mediatek,rmii-rxc");
+
 	if (priv->compat_data->set_interface_mode) {
 		ret = priv->compat_data->set_interface_mode(ndev);
 		if (ret) {
@@ -1571,17 +1576,25 @@ static int mt8516_set_interface_mode(struct net_device *ndev)
 {
 	struct mtk_star_priv *priv = netdev_priv(ndev);
 	struct device *dev = mtk_star_get_dev(priv);
-	unsigned int intf_val;
+	unsigned int intf_val, ret, rmii_rxc;
 
 	switch (priv->phy_intf) {
 	case PHY_INTERFACE_MODE_RMII:
 		intf_val = MTK_PERICFG_BIT_NIC_CFG_CON_RMII;
+		rmii_rxc = priv->rmii_rxc ? 0 : MTK_PERICFG_BIT_NIC_CFG_CON_CLK;
 		break;
 	default:
 		dev_err(dev, "This interface not supported\n");
 		return -EINVAL;
 	}
 
+	ret = regmap_update_bits(priv->pericfg,
+				 MTK_PERICFG_REG_NIC_CFG1_CON,
+				 MTK_PERICFG_BIT_NIC_CFG_CON_CLK,
+				 rmii_rxc);
+	if (ret)
+		return ret;
+
 	return regmap_update_bits(priv->pericfg,
 				  MTK_PERICFG_REG_NIC_CFG0_CON,
 				  MTK_PERICFG_REG_NIC_CFG_CON_CFG_INTF,
@@ -1597,6 +1610,7 @@ static int mt8365_set_interface_mode(struct net_device *ndev)
 	switch (priv->phy_intf) {
 	case PHY_INTERFACE_MODE_RMII:
 		intf_val = MTK_PERICFG_BIT_NIC_CFG_CON_RMII;
+		intf_val |= priv->rmii_rxc ? 0 : MTK_PERICFG_BIT_NIC_CFG_CON_CLK_V2;
 		break;
 	default:
 		dev_err(dev, "This interface not supported\n");
@@ -1605,7 +1619,8 @@ static int mt8365_set_interface_mode(struct net_device *ndev)
 
 	return regmap_update_bits(priv->pericfg,
 				  MTK_PERICFG_REG_NIC_CFG_CON_V2,
-				  MTK_PERICFG_REG_NIC_CFG_CON_CFG_INTF,
+				  MTK_PERICFG_REG_NIC_CFG_CON_CFG_INTF |
+				  MTK_PERICFG_BIT_NIC_CFG_CON_CLK_V2,
 				  intf_val);
 }
 
-- 
2.25.1

