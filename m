Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2339E9CC
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 15:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbfH0NpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 09:45:13 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:60922 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726125AbfH0NpN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 09:45:13 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 710D265B4F12DA65DFD3;
        Tue, 27 Aug 2019 21:45:09 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Tue, 27 Aug 2019
 21:45:01 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <nbd@nbd.name>, <lorenzo.bianconi83@gmail.com>,
        <ryder.lee@mediatek.com>, <royluo@google.com>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <matthias.bgg@gmail.com>, <swboyd@chromium.org>,
        <yuehaibing@huawei.com>, <weiyongjun1@huawei.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] mt76: mt7603: use devm_platform_ioremap_resource() to simplify code
Date:   Tue, 27 Aug 2019 21:44:45 +0800
Message-ID: <20190827134445.14696-1-yuehaibing@huawei.com>
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
 drivers/net/wireless/mediatek/mt76/mt7603/soc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/soc.c b/drivers/net/wireless/mediatek/mt76/mt7603/soc.c
index c6c1ce6..c22715e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/soc.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/soc.c
@@ -9,7 +9,6 @@
 static int
 mt76_wmac_probe(struct platform_device *pdev)
 {
-	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	struct mt7603_dev *dev;
 	void __iomem *mem_base;
 	struct mt76_dev *mdev;
@@ -20,7 +19,7 @@ mt76_wmac_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
-	mem_base = devm_ioremap_resource(&pdev->dev, res);
+	mem_base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(mem_base)) {
 		dev_err(&pdev->dev, "Failed to get memory resource\n");
 		return PTR_ERR(mem_base);
-- 
2.7.4


