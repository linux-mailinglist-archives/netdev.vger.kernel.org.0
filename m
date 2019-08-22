Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2815A98B5E
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 08:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731695AbfHVG06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 02:26:58 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:47390 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729284AbfHVG05 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 02:26:57 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 28306DB23BC640D10BF3;
        Thu, 22 Aug 2019 14:26:49 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Thu, 22 Aug 2019 14:26:42 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <nbd@openwrt.org>, <john@phrozen.org>, <sean.wang@mediatek.com>,
        <nelson.chang@mediatek.com>, <davem@davemloft.net>,
        <matthias.bgg@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Mao Wenan <maowenan@huawei.com>
Subject: [PATCH -next] net: mediatek: remove set but not used variable 'status'
Date:   Thu, 22 Aug 2019 14:30:26 +0800
Message-ID: <20190822063026.70044-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:
drivers/net/ethernet/mediatek/mtk_eth_soc.c: In function mtk_handle_irq:
drivers/net/ethernet/mediatek/mtk_eth_soc.c:1951:6: warning: variable status set but not used [-Wunused-but-set-variable]

It is not used since commit 296c9120752b ("net: ethernet: mediatek: Add MT7628/88 SoC support")
Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 8ddbb8d..bb7d623 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1948,9 +1948,7 @@ static irqreturn_t mtk_handle_irq_tx(int irq, void *_eth)
 static irqreturn_t mtk_handle_irq(int irq, void *_eth)
 {
 	struct mtk_eth *eth = _eth;
-	u32 status;
 
-	status = mtk_r32(eth, MTK_PDMA_INT_STATUS);
 	if (mtk_r32(eth, MTK_PDMA_INT_MASK) & MTK_RX_DONE_INT) {
 		if (mtk_r32(eth, MTK_PDMA_INT_STATUS) & MTK_RX_DONE_INT)
 			mtk_handle_irq_rx(irq, _eth);
-- 
2.7.4

