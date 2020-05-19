Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C751D950F
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 13:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbgESLRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 07:17:18 -0400
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:4393 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgESLRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 07:17:17 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.17]) by rmmx-syy-dmz-app02-12002 (RichMail) with SMTP id 2ee25ec3c039bee-51310; Tue, 19 May 2020 19:17:13 +0800 (CST)
X-RM-TRANSID: 2ee25ec3c039bee-51310
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[112.25.154.146])
        by rmsmtp-syy-appsvr09-12009 (RichMail) with SMTP id 2ee95ec3c036399-0aa79;
        Tue, 19 May 2020 19:17:13 +0800 (CST)
X-RM-TRANSID: 2ee95ec3c036399-0aa79
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Subject: [PATCH] net/amd: Simplify assertions
Date:   Tue, 19 May 2020 19:17:58 +0800
Message-Id: <20200519111758.4676-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplifies assertions for errors.

Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
 drivers/net/ethernet/amd/au1000_eth.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amd/au1000_eth.c b/drivers/net/ethernet/amd/au1000_eth.c
index 76ac3a752..328c0ddba 100644
--- a/drivers/net/ethernet/amd/au1000_eth.c
+++ b/drivers/net/ethernet/amd/au1000_eth.c
@@ -1201,7 +1201,7 @@ static int au1000_probe(struct platform_device *pdev)
 	}
 
 	aup->mii_bus = mdiobus_alloc();
-	if (aup->mii_bus == NULL) {
+	if (!aup->mii_bus) {
 		dev_err(&pdev->dev, "failed to allocate mdiobus structure\n");
 		err = -ENOMEM;
 		goto err_mdiobus_alloc;
@@ -1227,7 +1227,7 @@ static int au1000_probe(struct platform_device *pdev)
 	}
 
 	err = au1000_mii_probe(dev);
-	if (err != 0)
+	if (err)
 		goto err_out;
 
 	pDBfree = NULL;
@@ -1288,7 +1288,7 @@ static int au1000_probe(struct platform_device *pdev)
 	return 0;
 
 err_out:
-	if (aup->mii_bus != NULL)
+	if (aup->mii_bus)
 		mdiobus_unregister(aup->mii_bus);
 
 	/* here we should have a valid dev plus aup-> register addresses
-- 
2.20.1.windows.1



