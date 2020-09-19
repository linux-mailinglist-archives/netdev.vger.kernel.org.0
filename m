Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931DC270B87
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 09:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgISHow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 03:44:52 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13766 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726041AbgISHow (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 03:44:52 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 00C39A9BF6338C50E7BE;
        Sat, 19 Sep 2020 15:44:51 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Sat, 19 Sep 2020
 15:44:43 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <aelior@marvell.com>, <skalluru@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] bnx2x: use true,false for bool variables
Date:   Sat, 19 Sep 2020 15:45:56 +0800
Message-ID: <20200919074556.3460236-1-yanaijie@huawei.com>
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

drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:15415:1-26: WARNING:
Assignment of 0/1 to bool variable
drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:12393:2-17: WARNING:
Assignment of 0/1 to bool variable
drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:15497:2-27: WARNING:
Assignment of 0/1 to bool variable

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 3c543dd7a8f3..35f659310084 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -12390,7 +12390,7 @@ static int bnx2x_init_bp(struct bnx2x *bp)
 	}
 
 	if (CHIP_IS_E1(bp))
-		bp->dropless_fc = 0;
+		bp->dropless_fc = false;
 	else
 		bp->dropless_fc = dropless_fc | bnx2x_get_dropless_info(bp);
 
@@ -15412,7 +15412,7 @@ static int bnx2x_hwtstamp_ioctl(struct bnx2x *bp, struct ifreq *ifr)
 		return -EINVAL;
 	}
 
-	bp->hwtstamp_ioctl_called = 1;
+	bp->hwtstamp_ioctl_called = true;
 	bp->tx_type = config.tx_type;
 	bp->rx_filter = config.rx_filter;
 
@@ -15494,7 +15494,7 @@ void bnx2x_init_ptp(struct bnx2x *bp)
 		bnx2x_init_cyclecounter(bp);
 		timecounter_init(&bp->timecounter, &bp->cyclecounter,
 				 ktime_to_ns(ktime_get_real()));
-		bp->timecounter_init_done = 1;
+		bp->timecounter_init_done = true;
 	}
 
 	DP(BNX2X_MSG_PTP, "PTP initialization ended successfully\n");
-- 
2.25.4

