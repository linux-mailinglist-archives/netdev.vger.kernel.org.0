Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 631FD7DB81
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 14:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730926AbfHAMaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 08:30:21 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34940 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729506AbfHAMaV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 08:30:21 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 44C8151969F35F57FFE2;
        Thu,  1 Aug 2019 20:30:18 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 1 Aug 2019
 20:30:09 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: dsa: bcm_sf2: use devm_platform_ioremap_resource() to simplify code
Date:   Thu, 1 Aug 2019 20:29:11 +0800
Message-ID: <20190801122911.30992-1-yuehaibing@huawei.com>
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
 drivers/net/dsa/bcm_sf2.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 3811fdb..49f9943 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -1041,7 +1041,6 @@ static int bcm_sf2_sw_probe(struct platform_device *pdev)
 	struct b53_device *dev;
 	struct dsa_switch *ds;
 	void __iomem **base;
-	struct resource *r;
 	unsigned int i;
 	u32 reg, rev;
 	int ret;
@@ -1107,8 +1106,7 @@ static int bcm_sf2_sw_probe(struct platform_device *pdev)
 
 	base = &priv->core;
 	for (i = 0; i < BCM_SF2_REGS_NUM; i++) {
-		r = platform_get_resource(pdev, IORESOURCE_MEM, i);
-		*base = devm_ioremap_resource(&pdev->dev, r);
+		*base = devm_platform_ioremap_resource(pdev, i);
 		if (IS_ERR(*base)) {
 			pr_err("unable to find register: %s\n", reg_names[i]);
 			return PTR_ERR(*base);
-- 
2.7.4


