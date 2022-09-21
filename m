Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E65705BFF59
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 15:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbiIUN6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 09:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiIUN63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 09:58:29 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654F380E91
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 06:58:28 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MXg0m5j7xzpV4c;
        Wed, 21 Sep 2022 21:55:36 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 21:58:25 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 21 Sep
 2022 21:58:25 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <f.fainelli@gmail.com>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <olteanv@gmail.com>,
        <kurt@linutronix.de>, <hauke@hauke-m.de>,
        <Woojung.Huh@microchip.com>, <sean.wang@mediatek.com>,
        <linus.walleij@linaro.org>, <clement.leger@bootlin.com>,
        <george.mccollister@gmail.com>
Subject: [PATCH net-next 01/18] net: dsa: b53: remove unnecessary set_drvdata()
Date:   Wed, 21 Sep 2022 22:05:07 +0800
Message-ID: <20220921140524.3831101-2-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220921140524.3831101-1-yangyingliang@huawei.com>
References: <20220921140524.3831101-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unnecessary set_drvdata(NULL) function in ->remove(),
the driver_data will be set to NULL in device_unbind_cleanup()
after calling ->remove().

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/dsa/b53/b53_mdio.c | 2 --
 drivers/net/dsa/b53/b53_mmap.c | 2 --
 drivers/net/dsa/b53/b53_srab.c | 2 --
 3 files changed, 6 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_mdio.c b/drivers/net/dsa/b53/b53_mdio.c
index a7aeb3c132c9..6ddc03b58b28 100644
--- a/drivers/net/dsa/b53/b53_mdio.c
+++ b/drivers/net/dsa/b53/b53_mdio.c
@@ -356,8 +356,6 @@ static void b53_mdio_remove(struct mdio_device *mdiodev)
 		return;
 
 	b53_switch_remove(dev);
-
-	dev_set_drvdata(&mdiodev->dev, NULL);
 }
 
 static void b53_mdio_shutdown(struct mdio_device *mdiodev)
diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mmap.c
index ae4c79d39bc0..e968322dfbf0 100644
--- a/drivers/net/dsa/b53/b53_mmap.c
+++ b/drivers/net/dsa/b53/b53_mmap.c
@@ -316,8 +316,6 @@ static int b53_mmap_remove(struct platform_device *pdev)
 	if (dev)
 		b53_switch_remove(dev);
 
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
diff --git a/drivers/net/dsa/b53/b53_srab.c b/drivers/net/dsa/b53/b53_srab.c
index da0b889880f6..bcb44034404d 100644
--- a/drivers/net/dsa/b53/b53_srab.c
+++ b/drivers/net/dsa/b53/b53_srab.c
@@ -667,8 +667,6 @@ static int b53_srab_remove(struct platform_device *pdev)
 	b53_srab_intr_set(dev->priv, false);
 	b53_switch_remove(dev);
 
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
-- 
2.25.1

