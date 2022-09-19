Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7655BC3E1
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 10:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiISIEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 04:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiISIEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 04:04:33 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D40104;
        Mon, 19 Sep 2022 01:04:29 -0700 (PDT)
X-UUID: 8ec33ae61fd54ed3bf47c54c27c41e84-20220919
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=D6BsuexwRwhOZe8OGcnm44TLSArfjuO8d8MCgdCmbcQ=;
        b=o3dKkxs8y4TI9proGzJ7H59yvowhMv06a9pPoVMB7Z1aPJRph+ZpqYgfJw3NMegzsSiI63GX8nUe8RJ227lMSy4gcimnNIpeQ/Tg4euw233iRl2RaXAlMwqx2RdavPD/Cp/2dpXMNYTaFAyAa1aQZR+FaNKOUTTMhccvfhAiPZk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.11,REQID:a6b41bbf-99bc-416b-be81-0c868922583f,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:39a5ff1,CLOUDID:5398dff6-6e85-48d9-afd8-0504bbfe04cb,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 8ec33ae61fd54ed3bf47c54c27c41e84-20220919
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
        (envelope-from <jianguo.zhang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1475237270; Mon, 19 Sep 2022 16:04:22 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Mon, 19 Sep 2022 16:04:20 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 19 Sep 2022 16:04:19 +0800
From:   Jianguo Zhang <jianguo.zhang@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
CC:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Biao Huang" <biao.huang@mediatek.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Jianguo Zhang <jianguo.zhang@mediatek.com>
Subject: [PATCH 1/2] stmmac: dwmac-mediatek: add support for mt8188
Date:   Mon, 19 Sep 2022 16:04:09 +0800
Message-ID: <20220919080410.11270-2-jianguo.zhang@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220919080410.11270-1-jianguo.zhang@mediatek.com>
References: <20220919080410.11270-1-jianguo.zhang@mediatek.com>
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

Add ethernet support for MediaTek SoCs from mt8188 family.
As mt8188 and mt8195 have same ethernet design, so private data
"mt8195_gmac_variant" can be reused for mt8188.

Signed-off-by: Jianguo Zhang <jianguo.zhang@mediatek.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
index d42e1afb6521..f45be440b6d0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
@@ -720,6 +720,8 @@ static const struct of_device_id mediatek_dwmac_match[] = {
 	  .data = &mt2712_gmac_variant },
 	{ .compatible = "mediatek,mt8195-gmac",
 	  .data = &mt8195_gmac_variant },
+	{ .compatible = "mediatek,mt8188-gmac",
+	  .data = &mt8195_gmac_variant },
 	{ }
 };
 
-- 
2.25.1

