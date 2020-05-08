Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D778C1CA7E9
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 12:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgEHKH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 06:07:28 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4301 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726083AbgEHKH1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 06:07:27 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id AF96F2CEC951BF87FF06;
        Fri,  8 May 2020 18:07:25 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Fri, 8 May 2020 18:07:15 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] net: dsa: vsc73xx: convert to devm_platform_ioremap_resource
Date:   Fri, 8 May 2020 10:11:14 +0000
Message-ID: <20200508101114.2331-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the helper function that wraps the calls to platform_get_resource()
and devm_ioremap_resource() together.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/dsa/vitesse-vsc73xx-platform.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/dsa/vitesse-vsc73xx-platform.c b/drivers/net/dsa/vitesse-vsc73xx-platform.c
index 0541785f9fee..5e54a5726aa4 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-platform.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-platform.c
@@ -89,7 +89,6 @@ static int vsc73xx_platform_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct vsc73xx_platform *vsc_platform;
-	struct resource *res = NULL;
 	int ret;
 
 	vsc_platform = devm_kzalloc(dev, sizeof(*vsc_platform), GFP_KERNEL);
@@ -103,14 +102,7 @@ static int vsc73xx_platform_probe(struct platform_device *pdev)
 	vsc_platform->vsc.ops = &vsc73xx_platform_ops;
 
 	/* obtain I/O memory space */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "cannot obtain I/O memory space\n");
-		ret = -ENXIO;
-		return ret;
-	}
-
-	vsc_platform->base_addr = devm_ioremap_resource(&pdev->dev, res);
+	vsc_platform->base_addr = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(vsc_platform->base_addr)) {
 		dev_err(&pdev->dev, "cannot request I/O memory space\n");
 		ret = -ENXIO;





