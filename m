Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01AEA26315F
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730923AbgIIQKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:10:39 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11328 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730598AbgIIQJH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 12:09:07 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9FCAB752330418B7CE20;
        Wed,  9 Sep 2020 22:10:05 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Wed, 9 Sep 2020 22:10:01 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <mcoquelin.stm32@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: stmmac: dwmac-intel-plat: remove redundant null check before clk_disable_unprepare()
Date:   Wed, 9 Sep 2020 22:09:00 +0800
Message-ID: <1599660540-25295-1-git-send-email-zhangchangzhong@huawei.com>
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
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
index ccac7bf..b1323d5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
@@ -149,9 +149,7 @@ static int intel_eth_plat_probe(struct platform_device *pdev)
 
 	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
 	if (ret) {
-		if (dwmac->tx_clk)
-			clk_disable_unprepare(dwmac->tx_clk);
-
+		clk_disable_unprepare(dwmac->tx_clk);
 		goto err_remove_config_dt;
 	}
 
@@ -169,9 +167,7 @@ static int intel_eth_plat_remove(struct platform_device *pdev)
 	int ret;
 
 	ret = stmmac_pltfr_remove(pdev);
-
-	if (dwmac->tx_clk)
-		clk_disable_unprepare(dwmac->tx_clk);
+	clk_disable_unprepare(dwmac->tx_clk);
 
 	return ret;
 }
-- 
2.9.5

