Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 696D25BFF63
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 15:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiIUN7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 09:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiIUN6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 09:58:33 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A96680E91
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 06:58:33 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MXfyj3ttGzMp4j;
        Wed, 21 Sep 2022 21:53:49 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 21:58:31 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 21 Sep
 2022 21:58:30 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <f.fainelli@gmail.com>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <olteanv@gmail.com>,
        <kurt@linutronix.de>, <hauke@hauke-m.de>,
        <Woojung.Huh@microchip.com>, <sean.wang@mediatek.com>,
        <linus.walleij@linaro.org>, <clement.leger@bootlin.com>,
        <george.mccollister@gmail.com>
Subject: [PATCH net-next 10/18] net: dsa: mv88e6xxx: remove unnecessary dev_set_drvdata()
Date:   Wed, 21 Sep 2022 22:05:16 +0800
Message-ID: <20220921140524.3831101-11-yangyingliang@huawei.com>
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

Remove unnecessary dev_set_drvdata() in ->remove(), the driver_data will
be set to NULL in device_unbind_cleanup() after calling ->remove().

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 5f178faa110f..2479be3a1e35 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -7185,8 +7185,6 @@ static void mv88e6xxx_remove(struct mdio_device *mdiodev)
 		mv88e6xxx_g1_irq_free(chip);
 	else
 		mv88e6xxx_irq_poll_free(chip);
-
-	dev_set_drvdata(&mdiodev->dev, NULL);
 }
 
 static void mv88e6xxx_shutdown(struct mdio_device *mdiodev)
-- 
2.25.1

