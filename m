Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3CD11C0A3
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 04:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbfENC3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 22:29:22 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:39626 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726773AbfENC3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 22:29:15 -0400
X-UUID: 21afe73e6c544b5c99de6875a6d6919c-20190514
X-UUID: 21afe73e6c544b5c99de6875a6d6919c-20190514
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 453747894; Tue, 14 May 2019 10:29:07 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 14 May 2019 10:29:02 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 14 May 2019 10:29:01 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     Jose Abreu <joabreu@synopsys.com>, <davem@davemloft.net>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <yt.shen@mediatek.com>,
        <biao.huang@mediatek.com>, <jianguo.zhang@mediatek.com>
Subject: [v2, PATCH 4/4] net: stmmac: dwmac-mediatek: modify csr_clk value to fix mdio read/write fail
Date:   Tue, 14 May 2019 10:28:53 +0800
Message-ID: <1557800933-30759-5-git-send-email-biao.huang@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1557800933-30759-1-git-send-email-biao.huang@mediatek.com>
References: <1557800933-30759-1-git-send-email-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: CE7E223FA5729AE41C9E6851E0C385031421ACF4489A781D3D3D42801D17CA8F2000:8
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. the frequency of csr clock is 66.5MHz, so the csr_clk value should
be 0 other than 5.
2. the csr_clk can be got from device tree, so remove initialization here.

Change-Id: I3cd92fe380150fec6daa2d3acaab69a6d58344c0
Signed-off-by: Biao Huang <biao.huang@mediatek.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-mediatek.c   |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
index bf25629..126b66b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
@@ -346,8 +346,6 @@ static int mediatek_dwmac_probe(struct platform_device *pdev)
 		return PTR_ERR(plat_dat);
 
 	plat_dat->interface = priv_plat->phy_mode;
-	/* clk_csr_i = 250-300MHz & MDC = clk_csr_i/124 */
-	plat_dat->clk_csr = 5;
 	plat_dat->has_gmac4 = 1;
 	plat_dat->has_gmac = 0;
 	plat_dat->pmt = 0;
-- 
1.7.9.5

