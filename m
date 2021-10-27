Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC7243C5E3
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 11:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239778AbhJ0JC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 05:02:26 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:60524 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236174AbhJ0JC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 05:02:26 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R991e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0Uts4mKA_1635325196;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0Uts4mKA_1635325196)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 27 Oct 2021 16:59:59 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     andrew@lunn.ch
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, lgirdwood@gmail.com, broonie@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] net: phy: Fix unsigned comparison with less than zero
Date:   Wed, 27 Oct 2021 16:59:51 +0800
Message-Id: <1635325191-101815-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

./drivers/net/phy/at803x.c:493:5-10: WARNING: Unsigned expression
compared with zero: value < 0.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Fixes: ea13c9ee855c ("drivers: net: phy: at803x: separate wol specific code to wol standard apis")
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/phy/at803x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index f1cbe1f..dae95d9 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -484,7 +484,7 @@ static int at803x_set_wol(struct phy_device *phydev,
 static void at803x_get_wol(struct phy_device *phydev,
 			   struct ethtool_wolinfo *wol)
 {
-	u32 value;
+	int value;
 
 	wol->supported = WAKE_MAGIC;
 	wol->wolopts = 0;
-- 
1.8.3.1

