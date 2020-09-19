Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE75270B85
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 09:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgISHoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 03:44:23 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13331 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726041AbgISHoX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 03:44:23 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 40A322C5E98B0BCB8539;
        Sat, 19 Sep 2020 15:44:20 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Sat, 19 Sep 2020
 15:44:14 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <michael.chan@broadcom.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <fenghua.yu@intel.com>, <netdev@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] net: b44: use true,false for bool variables
Date:   Sat, 19 Sep 2020 15:45:27 +0800
Message-ID: <20200919074527.3459788-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This addresses the following coccinelle warning:

drivers/net/ethernet/broadcom/b44.c:2213:6-20: WARNING: Assignment of
0/1 to bool variable
drivers/net/ethernet/broadcom/b44.c:2218:2-16: WARNING: Assignment of
0/1 to bool variable
drivers/net/ethernet/broadcom/b44.c:2226:3-17: WARNING: Assignment of
0/1 to bool variable
drivers/net/ethernet/broadcom/b44.c:2230:3-17: WARNING: Assignment of
0/1 to bool variable

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/ethernet/broadcom/b44.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index 6fb620e25208..74c1778d841e 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -2210,12 +2210,12 @@ static void b44_adjust_link(struct net_device *dev)
 {
 	struct b44 *bp = netdev_priv(dev);
 	struct phy_device *phydev = dev->phydev;
-	bool status_changed = 0;
+	bool status_changed = false;
 
 	BUG_ON(!phydev);
 
 	if (bp->old_link != phydev->link) {
-		status_changed = 1;
+		status_changed = true;
 		bp->old_link = phydev->link;
 	}
 
@@ -2223,11 +2223,11 @@ static void b44_adjust_link(struct net_device *dev)
 	if (phydev->link) {
 		if ((phydev->duplex == DUPLEX_HALF) &&
 		    (bp->flags & B44_FLAG_FULL_DUPLEX)) {
-			status_changed = 1;
+			status_changed = true;
 			bp->flags &= ~B44_FLAG_FULL_DUPLEX;
 		} else if ((phydev->duplex == DUPLEX_FULL) &&
 			   !(bp->flags & B44_FLAG_FULL_DUPLEX)) {
-			status_changed = 1;
+			status_changed = true;
 			bp->flags |= B44_FLAG_FULL_DUPLEX;
 		}
 	}
-- 
2.25.4

