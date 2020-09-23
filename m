Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573B8275561
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 12:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgIWKPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 06:15:47 -0400
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:15905 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgIWKPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 06:15:47 -0400
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Sep 2020 06:15:44 EDT
Received: from spf.mail.chinamobile.com (unknown[172.16.121.3]) by rmmx-syy-dmz-app01-12001 (RichMail) with SMTP id 2ee15f6b1df2a4a-86392; Wed, 23 Sep 2020 18:05:40 +0800 (CST)
X-RM-TRANSID: 2ee15f6b1df2a4a-86392
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.112.105.130])
        by rmsmtp-syy-appsvr02-12002 (RichMail) with SMTP id 2ee25f6b1df1e3d-8f271;
        Wed, 23 Sep 2020 18:05:40 +0800 (CST)
X-RM-TRANSID: 2ee25f6b1df1e3d-8f271
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     davem@davemloft.net, andrew@lunn.ch, hkallweit1@gmail.com,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Subject: [PATCH] net: mdio: Remove redundant parameter and check
Date:   Wed, 23 Sep 2020 18:05:32 +0800
Message-Id: <20200923100532.18452-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the function ipq8064_mdio_probe(), of_mdiobus_register() might
returned zero, so the direct return can simplify code. Thus remove
redundant parameter and check.

Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
 drivers/net/mdio/mdio-ipq8064.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/mdio/mdio-ipq8064.c b/drivers/net/mdio/mdio-ipq8064.c
index 1bd1885..33cccce 100644
--- a/drivers/net/mdio/mdio-ipq8064.c
+++ b/drivers/net/mdio/mdio-ipq8064.c
@@ -102,7 +102,6 @@ ipq8064_mdio_probe(struct platform_device *pdev)
 	struct device_node *np = pdev->dev.of_node;
 	struct ipq8064_mdio *priv;
 	struct mii_bus *bus;
-	int ret;
 
 	bus = devm_mdiobus_alloc_size(&pdev->dev, sizeof(*priv));
 	if (!bus)
@@ -125,12 +124,9 @@ ipq8064_mdio_probe(struct platform_device *pdev)
 		return PTR_ERR(priv->base);
 	}
 
-	ret = of_mdiobus_register(bus, np);
-	if (ret)
-		return ret;
-
 	platform_set_drvdata(pdev, bus);
-	return 0;
+
+	return of_mdiobus_register(bus, np);
 }
 
 static int
-- 
2.20.1.windows.1



