Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEA5797A4D
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 15:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728700AbfHUNFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 09:05:32 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:56542 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726372AbfHUNFb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 09:05:31 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E95078B02D24C510BD64;
        Wed, 21 Aug 2019 21:05:20 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Wed, 21 Aug 2019
 21:05:14 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <ynezz@true.cz>, <tglx@linutronix.de>,
        <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] ezchip: nps_enet: use devm_platform_ioremap_resource() to simplify code
Date:   Wed, 21 Aug 2019 21:05:09 +0800
Message-ID: <20190821130509.71916-1-yuehaibing@huawei.com>
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
 drivers/net/ethernet/ezchip/nps_enet.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ezchip/nps_enet.c b/drivers/net/ethernet/ezchip/nps_enet.c
index 027225e..815fb62 100644
--- a/drivers/net/ethernet/ezchip/nps_enet.c
+++ b/drivers/net/ethernet/ezchip/nps_enet.c
@@ -576,7 +576,6 @@ static s32 nps_enet_probe(struct platform_device *pdev)
 	struct nps_enet_priv *priv;
 	s32 err = 0;
 	const char *mac_addr;
-	struct resource *res_regs;
 
 	if (!dev->of_node)
 		return -ENODEV;
@@ -595,8 +594,7 @@ static s32 nps_enet_probe(struct platform_device *pdev)
 	/* FIXME :: no multicast support yet */
 	ndev->flags &= ~IFF_MULTICAST;
 
-	res_regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	priv->regs_base = devm_ioremap_resource(dev, res_regs);
+	priv->regs_base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(priv->regs_base)) {
 		err = PTR_ERR(priv->regs_base);
 		goto out_netdev;
-- 
2.7.4


