Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C25F270A09
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 04:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbgISC2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 22:28:03 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56034 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726009AbgISC2D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 22:28:03 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D98894FEECEAC69FCF14;
        Sat, 19 Sep 2020 10:28:00 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Sat, 19 Sep 2020 10:27:58 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: mventa: remove unused variable 'dummy' in mvneta_mib_counters_clear()
Date:   Sat, 19 Sep 2020 10:26:51 +0800
Message-ID: <1600482411-15559-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

drivers/net/ethernet/marvell/mvneta.c:754:6: warning:
 variable 'dummy' set but not used [-Wunused-but-set-variable]
  754 |  u32 dummy;
      |      ^~~~~

This variable is not used in function mvneta_mib_counters_clear(), so
remove it to avoid build warning.

Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index f75e05e..4694242 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -751,13 +751,12 @@ static void mvneta_txq_inc_put(struct mvneta_tx_queue *txq)
 static void mvneta_mib_counters_clear(struct mvneta_port *pp)
 {
 	int i;
-	u32 dummy;
 
 	/* Perform dummy reads from MIB counters */
 	for (i = 0; i < MVNETA_MIB_LATE_COLLISION; i += 4)
-		dummy = mvreg_read(pp, (MVNETA_MIB_COUNTERS_BASE + i));
-	dummy = mvreg_read(pp, MVNETA_RX_DISCARD_FRAME_COUNT);
-	dummy = mvreg_read(pp, MVNETA_OVERRUN_FRAME_COUNT);
+		mvreg_read(pp, (MVNETA_MIB_COUNTERS_BASE + i));
+	mvreg_read(pp, MVNETA_RX_DISCARD_FRAME_COUNT);
+	mvreg_read(pp, MVNETA_OVERRUN_FRAME_COUNT);
 }
 
 /* Get System Network Statistics */
-- 
2.9.5

