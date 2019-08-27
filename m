Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 113CC9E9D8
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 15:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729726AbfH0Nq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 09:46:57 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5670 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725825AbfH0Nq5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 09:46:57 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4E9F1FE82E5AD00B06AC;
        Tue, 27 Aug 2019 21:46:54 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Tue, 27 Aug 2019
 21:46:45 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <rjui@broadcom.com>, <sbranden@broadcom.com>
CC:     <bcm-kernel-feedback-list@broadcom.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] phy: mdio-bcm-iproc: use devm_platform_ioremap_resource() to simplify code
Date:   Tue, 27 Aug 2019 21:46:16 +0800
Message-ID: <20190827134616.11396-1-yuehaibing@huawei.com>
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
 drivers/net/phy/mdio-bcm-iproc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/phy/mdio-bcm-iproc.c b/drivers/net/phy/mdio-bcm-iproc.c
index 7d0f388..7e9975d 100644
--- a/drivers/net/phy/mdio-bcm-iproc.c
+++ b/drivers/net/phy/mdio-bcm-iproc.c
@@ -123,15 +123,13 @@ static int iproc_mdio_probe(struct platform_device *pdev)
 {
 	struct iproc_mdio_priv *priv;
 	struct mii_bus *bus;
-	struct resource *res;
 	int rc;
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	priv->base = devm_ioremap_resource(&pdev->dev, res);
+	priv->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(priv->base)) {
 		dev_err(&pdev->dev, "failed to ioremap register\n");
 		return PTR_ERR(priv->base);
-- 
2.7.4


