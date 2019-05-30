Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44B7C2F8D7
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 10:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbfE3IzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 04:55:11 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:25947 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726653AbfE3Iy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 04:54:58 -0400
X-UUID: 879c2a527d344a9984b1ac34210626f0-20190530
X-UUID: 879c2a527d344a9984b1ac34210626f0-20190530
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1648121932; Thu, 30 May 2019 16:54:51 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 30 May 2019 16:54:49 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 30 May 2019 16:54:48 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     Jose Abreu <joabreu@synopsys.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <yt.shen@mediatek.com>,
        <biao.huang@mediatek.com>, <jianguo.zhang@mediatek.com>,
        <boon.leong.ong@intel.com>, <andrew@lunn.ch>
Subject: [PATCH 2/4] net: stmmac: dwmac-mediatek: disable rx watchdog
Date:   Thu, 30 May 2019 16:54:42 +0800
Message-ID: <1559206484-1825-3-git-send-email-biao.huang@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1559206484-1825-1-git-send-email-biao.huang@mediatek.com>
References: <1559206484-1825-1-git-send-email-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 6BDEB72B246466E87AEFA38E556217A54BDD67FD1C070C393FC484201E3BDEE02000:8
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

disable rx watchdog for dwmac-mediatek, then the hw will
issue a rx interrupt once receiving a packet, so the responding time
for rx path will be reduced.

Signed-off-by: Biao Huang <biao.huang@mediatek.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-mediatek.c   |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
index 3c7a60f..38cd054 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
@@ -356,6 +356,7 @@ static int mediatek_dwmac_probe(struct platform_device *pdev)
 	plat_dat->has_gmac4 = 1;
 	plat_dat->has_gmac = 0;
 	plat_dat->pmt = 0;
+	plat_dat->riwt_off = 1;
 	plat_dat->maxmtu = ETH_DATA_LEN;
 	plat_dat->bsp_priv = priv_plat;
 	plat_dat->init = mediatek_dwmac_init;
-- 
1.7.9.5

