Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1F5151436
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 03:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbgBDCaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 21:30:24 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10145 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726561AbgBDCaY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 21:30:24 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E46E62EEB371C5BD5695;
        Tue,  4 Feb 2020 10:30:21 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Tue, 4 Feb 2020 10:30:11 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     YueHaibing <yuehaibing@huawei.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] qed: Remove set but not used variable 'p_link'
Date:   Tue, 4 Feb 2020 02:24:41 +0000
Message-ID: <20200204022442.109809-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/ethernet/qlogic/qed/qed_cxt.c: In function 'qed_qm_init_pf':
drivers/net/ethernet/qlogic/qed/qed_cxt.c:1401:29: warning:
 variable 'p_link' set but not used [-Wunused-but-set-variable]

commit 92fae6fb231f ("qed: FW 8.42.2.0 Queue Manager changes")
leave behind this unused variable.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/qlogic/qed/qed_cxt.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.c b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
index fbfff2b1dc93..1a636bad717d 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
@@ -1398,14 +1398,11 @@ void qed_qm_init_pf(struct qed_hwfn *p_hwfn,
 {
 	struct qed_qm_info *qm_info = &p_hwfn->qm_info;
 	struct qed_qm_pf_rt_init_params params;
-	struct qed_mcp_link_state *p_link;
 	struct qed_qm_iids iids;
 
 	memset(&iids, 0, sizeof(iids));
 	qed_cxt_qm_iids(p_hwfn, &iids);
 
-	p_link = &QED_LEADING_HWFN(p_hwfn->cdev)->mcp_info->link_output;
-
 	memset(&params, 0, sizeof(params));
 	params.port_id = p_hwfn->port_id;
 	params.pf_id = p_hwfn->rel_pf_id;



