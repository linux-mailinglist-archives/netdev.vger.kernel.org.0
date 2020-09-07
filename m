Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C495525FAAF
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 14:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbgIGMso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 08:48:44 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:45070 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729301AbgIGMsk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 08:48:40 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id F35BBD5FA88D5E71FD9C;
        Mon,  7 Sep 2020 20:47:52 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 7 Sep 2020 20:47:51 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <mcoquelin.stm32@gmail.com>, <shawnguo@kernel.org>,
        <s.hauer@pengutronix.de>
CC:     <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: ethernet: dwmac: remove redundant null check before clk_disable_unprepare()
Date:   Mon, 7 Sep 2020 20:46:54 +0800
Message-ID: <1599482814-42552-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because clk_prepare_enable() and clk_disable_unprepare() already checked
NULL clock parameter, so the additional checks are unnecessary, just
remove them.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
index 3c5df5e..efef547 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
@@ -129,8 +129,7 @@ static void imx_dwmac_exit(struct platform_device *pdev, void *priv)
 {
 	struct imx_priv_data *dwmac = priv;
 
-	if (dwmac->clk_tx)
-		clk_disable_unprepare(dwmac->clk_tx);
+	clk_disable_unprepare(dwmac->clk_tx);
 	clk_disable_unprepare(dwmac->clk_mem);
 }
 
-- 
2.9.5

