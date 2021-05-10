Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7298D37900E
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 16:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235941AbhEJOCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 10:02:14 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:2437 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243751AbhEJN61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 09:58:27 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Ff2bt1rl4zCrCt;
        Mon, 10 May 2021 21:54:34 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Mon, 10 May 2021 21:57:07 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Rain River <rain.1986.08.12@gmail.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] forcedeth: Delete a redundant condition branch
Date:   Mon, 10 May 2021 21:56:56 +0800
Message-ID: <20210510135656.3960-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The statement of the last "if (adv_lpa & LPA_10HALF)" branch is the same
as the "else" branch. Delete it to simplify code.

No functional change.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/net/ethernet/nvidia/forcedeth.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 8724d6a9ed020a7..5c2c9c5d330b65f 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -3471,9 +3471,6 @@ static int nv_update_linkspeed(struct net_device *dev)
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
2.26.0.106.g9fadedd


