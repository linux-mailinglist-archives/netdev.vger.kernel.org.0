Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7DFD1C4F65
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 09:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbgEEHos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 03:44:48 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3788 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725915AbgEEHos (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 03:44:48 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 1B733FA706249862D333;
        Tue,  5 May 2020 15:44:46 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Tue, 5 May 2020
 15:44:38 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <aelior@marvell.com>, <skalluru@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <davem@davemloft.net>,
        <yanaijie@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] bnx2x: Remove Comparison to bool in bnx2x_dcb.c
Date:   Tue, 5 May 2020 15:44:00 +0800
Message-ID: <20200505074400.21658-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c:1548:17-31: WARNING:
Comparison to bool
drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c:1148:16-24: WARNING:
Comparison to bool
drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c:1158:30-38: WARNING:
Comparison to bool

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c
index 2c6ba046d2a8..17ae6df90723 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c
@@ -1145,7 +1145,7 @@ static void bnx2x_dcbx_get_num_pg_traf_type(struct bnx2x *bp,
 					break;
 				}
 			}
-			if (false == pg_found) {
+			if (!pg_found) {
 				data[help_data->num_of_pg].pg = add_pg;
 				data[help_data->num_of_pg].pg_priority =
 						(1 << ttp[add_traf_type]);
@@ -1155,7 +1155,7 @@ static void bnx2x_dcbx_get_num_pg_traf_type(struct bnx2x *bp,
 		}
 		DP(BNX2X_MSG_DCB,
 		   "add_traf_type %d pg_found %s num_of_pg %d\n",
-		   add_traf_type, (false == pg_found) ? "NO" : "YES",
+		   add_traf_type, !pg_found ? "NO" : "YES",
 		   help_data->num_of_pg);
 	}
 }
@@ -1544,8 +1544,7 @@ static void bnx2x_dcbx_2cos_limit_cee_three_pg_to_cos_params(
 			if (pg_entry < DCBX_MAX_NUM_PG_BW_ENTRIES) {
 				entry = 0;
 
-				if (i == (num_of_pri-1) &&
-				    false == b_found_strict)
+				if (i == (num_of_pri-1) && !b_found_strict)
 					/* last entry will be handled separately
 					 * If no priority is strict than last
 					 * entry goes to last queue.
-- 
2.21.1

