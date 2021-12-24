Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 366D547EDA1
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 10:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240325AbhLXJMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 04:12:20 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:34854 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233798AbhLXJMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 04:12:20 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0V.c4Ma1_1640337136;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0V.c4Ma1_1640337136)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 24 Dec 2021 17:12:17 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] net: phy: micrel: use min() macro instead of doing it manually
Date:   Fri, 24 Dec 2021 17:12:08 +0800
Message-Id: <20211224091208.32274-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix following coccicheck warning:
./drivers/net/phy/micrel.c:1482:12-13: WARNING opportunity for min()

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/phy/micrel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index c6a97fcca0e6..dda426596445 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1479,7 +1479,7 @@ static int ksz886x_cable_test_wait_for_completion(struct phy_device *phydev)
 				    !(val & KSZ8081_LMD_ENABLE_TEST),
 				    30000, 100000, true);
 
-	return ret < 0 ? ret : 0;
+	return min(ret, 0);
 }
 
 static int ksz886x_cable_test_one_pair(struct phy_device *phydev, int pair)
-- 
2.20.1.7.g153144c

