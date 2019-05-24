Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47C3B29058
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 07:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387560AbfEXFYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 01:24:47 -0400
Received: from first.geanix.com ([116.203.34.67]:50982 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726601AbfEXFYr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 01:24:47 -0400
Received: from localhost (87-49-45-10-mobile.dk.customer.tdc.net [87.49.45.10])
        by first.geanix.com (Postfix) with ESMTPSA id D64061134;
        Fri, 24 May 2019 05:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1558675432; bh=bdQl35s2cuuWkN1UfvO+LGl5WOpmsTcZEQ4aijDY8w4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=LpIsdpkgKouTTv1nspseSd4pulyBCVbWv7f1peEdupHKAUQycikuoU78PO/Z35RFu
         Z+udO7Tl3EfVyZ0pXHAUGUcBSIJ9ZP2DH4RYSksWY7pZBHZDcNjDU8o5SNxjPfFKZ7
         9Uy1/w75KRnAkJMpgmWPSkXmvLeR2UflLQLQCRtUlco+VJMT38vmNtu1JJhhXe3PUa
         vubnh4BPDBKo+Thzd+n+mLnYpFN0Leorj+7BinV5GTFsIHU2CLEaVvcjwMXWs3EHtF
         0VYBMYUEii9P5Vt23k1sAsPwmtK0f+rd3YunB5RQI/mWydA8dfYsYA2kSTeZi+TTdI
         yOhEmt4B3qbag==
From:   Esben Haabendal <esben@geanix.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>,
        YueHaibing <yuehaibing@huawei.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: ll_temac: Fix compile error
Date:   Fri, 24 May 2019 07:24:42 +0200
Message-Id: <20190524052444.2983-1-esben@geanix.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190524094709.3f9830f2@canb.auug.org.au>
References: <20190524094709.3f9830f2@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 796779db2bec
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: 1b3fa5cf859b ("net: ll_temac: Cleanup multicast filter on change")
Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 22a52b884821..21c1b4322ea7 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -452,7 +452,7 @@ static void temac_set_multicast_list(struct net_device *ndev)
 {
 	struct temac_local *lp = netdev_priv(ndev);
 	u32 multi_addr_msw, multi_addr_lsw;
-	int i;
+	int i = 0;
 	unsigned long flags;
 	bool promisc_mode_disabled = false;
 
@@ -468,7 +468,6 @@ static void temac_set_multicast_list(struct net_device *ndev)
 	if (!netdev_mc_empty(ndev)) {
 		struct netdev_hw_addr *ha;
 
-		i = 0;
 		netdev_for_each_mc_addr(ha, ndev) {
 			if (WARN_ON(i >= MULTICAST_CAM_TABLE_NUM))
 				break;
-- 
2.21.0

