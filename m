Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8474B97B57
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 15:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbfHUNy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 09:54:27 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:42176 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727696AbfHUNy0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 09:54:26 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 832E3FF73DB123757664;
        Wed, 21 Aug 2019 21:54:21 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 21 Aug 2019
 21:54:12 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@st.com>, <joabreu@synopsys.com>,
        <khilman@baylibre.com>, <mcoquelin.stm32@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-amlogic@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: stmmac: dwmac-meson: use devm_platform_ioremap_resource() to simplify code
Date:   Wed, 21 Aug 2019 21:54:06 +0800
Message-ID: <20190821135406.26200-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devm_platform_ioremap_resource() to simplify the code a bit.
This is detected by coccinelle.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c
index 88eb169..bbc16b5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c
@@ -46,7 +46,6 @@ static int meson6_dwmac_probe(struct platform_device *pdev)
 	struct plat_stmmacenet_data *plat_dat;
 	struct stmmac_resources stmmac_res;
 	struct meson_dwmac *dwmac;
-	struct resource *res;
 	int ret;
 
 	ret = stmmac_get_platform_resources(pdev, &stmmac_res);
@@ -63,8 +62,7 @@ static int meson6_dwmac_probe(struct platform_device *pdev)
 		goto err_remove_config_dt;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	dwmac->reg = devm_ioremap_resource(&pdev->dev, res);
+	dwmac->reg = devm_platform_ioremap_resource(pdev, 1);
 	if (IS_ERR(dwmac->reg)) {
 		ret = PTR_ERR(dwmac->reg);
 		goto err_remove_config_dt;
-- 
2.7.4


