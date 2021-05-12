Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7917437BA13
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 12:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbhELKLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 06:11:03 -0400
Received: from cmccmta2.chinamobile.com ([221.176.66.80]:4381 "EHLO
        cmccmta2.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbhELKLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 06:11:03 -0400
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 May 2021 06:11:02 EDT
Received: from spf.mail.chinamobile.com (unknown[172.16.121.15]) by rmmx-syy-dmz-app06-12006 (RichMail) with SMTP id 2ee6609ba735ca6-1c68e; Wed, 12 May 2021 18:00:21 +0800 (CST)
X-RM-TRANSID: 2ee6609ba735ca6-1c68e
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.112.105.130])
        by rmsmtp-syy-appsvr08-12008 (RichMail) with SMTP id 2ee8609ba731b1e-3b3c3;
        Wed, 12 May 2021 18:00:21 +0800 (CST)
X-RM-TRANSID: 2ee8609ba731b1e-3b3c3
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>
Subject: [PATCH] net: hns: Fix unnecessary check in hns_mdio_probe()
Date:   Wed, 12 May 2021 18:01:00 +0800
Message-Id: <20210512100100.12516-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function hns_mdio_probe() is only called with an openfirmware
platform device. Therefore there is no need to check that the passed
in device is NULL.

Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
 drivers/net/ethernet/hisilicon/hns_mdio.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns_mdio.c b/drivers/net/ethernet/hisilicon/hns_mdio.c
index 7df5d7d21..9e1d460c6 100644
--- a/drivers/net/ethernet/hisilicon/hns_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns_mdio.c
@@ -423,11 +423,6 @@ static int hns_mdio_probe(struct platform_device *pdev)
 	struct mii_bus *new_bus;
 	int ret = -ENODEV;
 
-	if (!pdev) {
-		dev_err(NULL, "pdev is NULL!\r\n");
-		return -ENODEV;
-	}
-
 	mdio_dev = devm_kzalloc(&pdev->dev, sizeof(*mdio_dev), GFP_KERNEL);
 	if (!mdio_dev)
 		return -ENOMEM;
-- 
2.20.1.windows.1



