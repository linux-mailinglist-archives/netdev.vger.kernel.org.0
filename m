Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276FD1D9508
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 13:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbgESLQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 07:16:11 -0400
Received: from cmccmta2.chinamobile.com ([221.176.66.80]:50476 "EHLO
        cmccmta2.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbgESLQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 07:16:11 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.5]) by rmmx-syy-dmz-app06-12006 (RichMail) with SMTP id 2ee65ec3bff496d-50d87; Tue, 19 May 2020 19:16:05 +0800 (CST)
X-RM-TRANSID: 2ee65ec3bff496d-50d87
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[112.25.154.146])
        by rmsmtp-syy-appsvr03-12003 (RichMail) with SMTP id 2ee35ec3bff229f-980e4;
        Tue, 19 May 2020 19:16:05 +0800 (CST)
X-RM-TRANSID: 2ee35ec3bff229f-980e4
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Subject: [PATCH] net/amd: Fix unused assignment in au1000_probe()
Date:   Tue, 19 May 2020 19:16:50 +0800
Message-Id: <20200519111650.17008-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete unused initialized value of 'err', because it will
be assigned by the function mdiobus_register(). And the
variable 'err = -ENODEV' is duplicate, so remove redundant
one.

Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
 drivers/net/ethernet/amd/au1000_eth.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/au1000_eth.c b/drivers/net/ethernet/amd/au1000_eth.c
index 5f91e717b..76ac3a752 100644
--- a/drivers/net/ethernet/amd/au1000_eth.c
+++ b/drivers/net/ethernet/amd/au1000_eth.c
@@ -1064,7 +1064,7 @@ static int au1000_probe(struct platform_device *pdev)
 	struct au1000_eth_platform_data *pd;
 	struct net_device *dev = NULL;
 	struct db_dest *pDB, *pDBfree;
-	int irq, i, err = 0;
+	int irq, i, err;
 	struct resource *base, *macen, *macdma;
 
 	base = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -1252,7 +1252,6 @@ static int au1000_probe(struct platform_device *pdev)
 		aup->rx_db_inuse[i] = pDB;
 	}
 
-	err = -ENODEV;
 	for (i = 0; i < NUM_TX_DMA; i++) {
 		pDB = au1000_GetFreeDB(aup);
 		if (!pDB)
-- 
2.20.1.windows.1



