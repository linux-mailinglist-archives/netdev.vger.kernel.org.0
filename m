Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6BC85BFF67
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 15:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiIUN7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 09:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbiIUN6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 09:58:38 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58FAF7F084
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 06:58:37 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MXfzS30gLzlWxQ;
        Wed, 21 Sep 2022 21:54:28 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 21:58:35 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 21 Sep
 2022 21:58:35 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <f.fainelli@gmail.com>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <olteanv@gmail.com>,
        <kurt@linutronix.de>, <hauke@hauke-m.de>,
        <Woojung.Huh@microchip.com>, <sean.wang@mediatek.com>,
        <linus.walleij@linaro.org>, <clement.leger@bootlin.com>,
        <george.mccollister@gmail.com>
Subject: [PATCH net-next 17/18] net: dsa: vitesse-vsc73xx: remove unnecessary set_drvdata()
Date:   Wed, 21 Sep 2022 22:05:23 +0800
Message-ID: <20220921140524.3831101-18-yangyingliang@huawei.com>
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
 drivers/net/dsa/vitesse-vsc73xx-platform.c | 2 --
 drivers/net/dsa/vitesse-vsc73xx-spi.c      | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/dsa/vitesse-vsc73xx-platform.c b/drivers/net/dsa/vitesse-vsc73xx-platform.c
index fe4b154a0a57..bd4206e8f9af 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-platform.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-platform.c
@@ -121,8 +121,6 @@ static int vsc73xx_platform_remove(struct platform_device *pdev)
 
 	vsc73xx_remove(&vsc_platform->vsc);
 
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
diff --git a/drivers/net/dsa/vitesse-vsc73xx-spi.c b/drivers/net/dsa/vitesse-vsc73xx-spi.c
index 97a92e6da60d..85b9a0f51dd8 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-spi.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-spi.c
@@ -167,8 +167,6 @@ static void vsc73xx_spi_remove(struct spi_device *spi)
 		return;
 
 	vsc73xx_remove(&vsc_spi->vsc);
-
-	spi_set_drvdata(spi, NULL);
 }
 
 static void vsc73xx_spi_shutdown(struct spi_device *spi)
-- 
2.25.1

