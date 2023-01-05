Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91A7B65E23B
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 02:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbjAEBH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 20:07:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjAEBHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 20:07:47 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D61479C2;
        Wed,  4 Jan 2023 17:07:22 -0800 (PST)
X-UUID: 4c0ee232f52844a7bfd6df4ec49bfa14-20230105
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=/tajBNzIihAGN7nzWbirFSCOw1aUlX0N1cIhsjxveVg=;
        b=ingUcWZAeqfPszYqiKbaJn7kYrNOvuVQdn3k7VDlhkCvNF2N0ue8+k8Dd+VyWw0eC2dRjuh3GrYpfJ2nrPUDNOAYhxNGi21xtj51v7Hl1Bsrmnlhqy/UWt1puFoPPstqtcXNeHyXUbr5+LazRclv0iir/5OtxZaKoz2bWidaAWc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.16,REQID:13c6b6c4-bffe-45c5-a05a-11544e452c1e,IP:0,U
        RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-META: VersionHash:09771b1,CLOUDID:9bc6d3f4-ff42-4fb0-b929-626456a83c14,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0
X-CID-BVR: 0,NGT
X-UUID: 4c0ee232f52844a7bfd6df4ec49bfa14-20230105
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 924514787; Thu, 05 Jan 2023 09:07:17 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Thu, 5 Jan 2023 09:07:16 +0800
Received: from mhfsdcap04.gcn.mediatek.inc (10.17.3.154) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Thu, 5 Jan 2023 09:07:15 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Biao Huang <biao.huang@mediatek.com>,
        <macpaul.lin@mediatek.com>, <netdev@vger.kernel.org>
Subject: [PATCH v8 1/2] stmmac: dwmac-mediatek: remove the dwmac_fix_mac_speed
Date:   Thu, 5 Jan 2023 09:07:11 +0800
Message-ID: <20230105010712.10116-2-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230105010712.10116-1-biao.huang@mediatek.com>
References: <20230105010712.10116-1-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

In current driver, MAC will always enable 2ns delay in RGMII mode,
but that's not the correct usage.

Remove the dwmac_fix_mac_speed() in driver, and recommend "rgmii-id"
for phy-mode in device tree.

Fixes: f2d356a6ab71 ("stmmac: dwmac-mediatek: add support for mt8195")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Biao Huang <biao.huang@mediatek.com>
---
 .../ethernet/stmicro/stmmac/dwmac-mediatek.c  | 26 -------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
index d42e1afb6521..2f7d8e4561d9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
@@ -90,7 +90,6 @@ struct mediatek_dwmac_plat_data {
 struct mediatek_dwmac_variant {
 	int (*dwmac_set_phy_interface)(struct mediatek_dwmac_plat_data *plat);
 	int (*dwmac_set_delay)(struct mediatek_dwmac_plat_data *plat);
-	void (*dwmac_fix_mac_speed)(void *priv, unsigned int speed);
 
 	/* clock ids to be requested */
 	const char * const *clk_list;
@@ -443,32 +442,9 @@ static int mt8195_set_delay(struct mediatek_dwmac_plat_data *plat)
 	return 0;
 }
 
-static void mt8195_fix_mac_speed(void *priv, unsigned int speed)
-{
-	struct mediatek_dwmac_plat_data *priv_plat = priv;
-
-	if ((phy_interface_mode_is_rgmii(priv_plat->phy_mode))) {
-		/* prefer 2ns fixed delay which is controlled by TXC_PHASE_CTRL,
-		 * when link speed is 1Gbps with RGMII interface,
-		 * Fall back to delay macro circuit for 10/100Mbps link speed.
-		 */
-		if (speed == SPEED_1000)
-			regmap_update_bits(priv_plat->peri_regmap,
-					   MT8195_PERI_ETH_CTRL0,
-					   MT8195_RGMII_TXC_PHASE_CTRL |
-					   MT8195_DLY_GTXC_ENABLE |
-					   MT8195_DLY_GTXC_INV |
-					   MT8195_DLY_GTXC_STAGES,
-					   MT8195_RGMII_TXC_PHASE_CTRL);
-		else
-			mt8195_set_delay(priv_plat);
-	}
-}
-
 static const struct mediatek_dwmac_variant mt8195_gmac_variant = {
 	.dwmac_set_phy_interface = mt8195_set_interface,
 	.dwmac_set_delay = mt8195_set_delay,
-	.dwmac_fix_mac_speed = mt8195_fix_mac_speed,
 	.clk_list = mt8195_dwmac_clk_l,
 	.num_clks = ARRAY_SIZE(mt8195_dwmac_clk_l),
 	.dma_bit_mask = 35,
@@ -619,8 +595,6 @@ static int mediatek_dwmac_common_data(struct platform_device *pdev,
 	plat->bsp_priv = priv_plat;
 	plat->init = mediatek_dwmac_init;
 	plat->clks_config = mediatek_dwmac_clks_config;
-	if (priv_plat->variant->dwmac_fix_mac_speed)
-		plat->fix_mac_speed = priv_plat->variant->dwmac_fix_mac_speed;
 
 	plat->safety_feat_cfg = devm_kzalloc(&pdev->dev,
 					     sizeof(*plat->safety_feat_cfg),
-- 
2.25.1

