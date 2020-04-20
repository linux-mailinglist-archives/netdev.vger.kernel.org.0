Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6031B005F
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 06:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgDTEAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 00:00:51 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:48568 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725681AbgDTEAv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 00:00:51 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 969076B731E3092C4177;
        Mon, 20 Apr 2020 12:00:48 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Mon, 20 Apr 2020
 12:00:37 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <aelior@marvell.com>, <GR-everest-linux-l2@marvell.com>,
        <davem@davemloft.net>, <michal.kalderon@marvell.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] qed: use true,false for bool variables
Date:   Mon, 20 Apr 2020 12:27:20 +0800
Message-ID: <20200420042720.18815-1-yanaijie@huawei.com>
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

drivers/net/ethernet/qlogic/qed/qed_dev.c:4395:2-34: WARNING:
Assignment of 0/1 to bool variable
drivers/net/ethernet/qlogic/qed/qed_dev.c:1975:2-34: WARNING:
Assignment of 0/1 to bool variable

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index 38a65b984e47..7119a18af19e 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -1972,7 +1972,7 @@ static int qed_init_qm_sanity(struct qed_hwfn *p_hwfn)
 		return 0;
 
 	if (QED_IS_ROCE_PERSONALITY(p_hwfn)) {
-		p_hwfn->hw_info.multi_tc_roce_en = 0;
+		p_hwfn->hw_info.multi_tc_roce_en = false;
 		DP_NOTICE(p_hwfn,
 			  "multi-tc roce was disabled to reduce requested amount of pqs\n");
 		if (qed_init_qm_get_num_pqs(p_hwfn) <= RESC_NUM(p_hwfn, QED_PQ))
@@ -4392,7 +4392,7 @@ qed_get_hw_info(struct qed_hwfn *p_hwfn,
 	}
 
 	if (QED_IS_ROCE_PERSONALITY(p_hwfn))
-		p_hwfn->hw_info.multi_tc_roce_en = 1;
+		p_hwfn->hw_info.multi_tc_roce_en = true;
 
 	p_hwfn->hw_info.num_hw_tc = NUM_PHYS_TCS_4PORT_K2;
 	p_hwfn->hw_info.num_active_tc = 1;
-- 
2.21.1

