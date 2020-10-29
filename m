Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3032429E285
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404429AbgJ2CSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:18:49 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6705 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgJ2CSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 22:18:24 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CM8Hh6yMNzkb6j;
        Thu, 29 Oct 2020 10:18:24 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Thu, 29 Oct 2020 10:18:15 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <rain.1986.08.12@gmail.com>, <zyjzyj2000@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zou Wei <zou_wei@huawei.com>
Subject: [PATCH -next] net: nvidia: forcedeth: remove useless if/else
Date:   Thu, 29 Oct 2020 10:30:14 +0800
Message-ID: <1603938614-53589-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccinelle report:

./drivers/net/ethernet/nvidia/forcedeth.c:3479:8-10:
WARNING: possible condition with no effect (if == else)

Both branches are the same, so remove the else if/else altogether.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 drivers/net/ethernet/nvidia/forcedeth.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 2fc10a3..87ed7e1 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -3476,9 +3476,6 @@ static int nv_update_linkspeed(struct net_device *dev)
 	} else if (adv_lpa & LPA_10FULL) {
 		newls = NVREG_LINKSPEED_FORCE|NVREG_LINKSPEED_10;
 		newdup = 1;
-	} else if (adv_lpa & LPA_10HALF) {
-		newls = NVREG_LINKSPEED_FORCE|NVREG_LINKSPEED_10;
-		newdup = 0;
 	} else {
 		newls = NVREG_LINKSPEED_FORCE|NVREG_LINKSPEED_10;
 		newdup = 0;
-- 
2.6.2

