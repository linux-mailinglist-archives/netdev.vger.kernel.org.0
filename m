Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60305228DE5
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 04:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731804AbgGVCMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 22:12:01 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50846 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731621AbgGVCMA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 22:12:00 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id EA8AC2BF1FBB69F44CA1;
        Wed, 22 Jul 2020 10:11:58 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Wed, 22 Jul 2020
 10:11:56 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <aelior@marvell.com>, <GR-everest-linux-l2@marvell.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: qed: Remove unneeded cast from memory allocation
Date:   Wed, 22 Jul 2020 10:10:27 +0800
Message-ID: <20200722021027.12797-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove casting the values returned by memory allocation function.

Coccinelle emits WARNING: casting value returned by memory allocation
unction to (struct roce_destroy_qp_req_output_params *) is useless.

This issue was detected by using the Coccinelle software.

Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/ethernet/qlogic/qed/qed_roce.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_roce.c b/drivers/net/ethernet/qlogic/qed/qed_roce.c
index a1423ec0edf7..f16a157bb95a 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_roce.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_roce.c
@@ -757,8 +757,7 @@ static int qed_roce_sp_destroy_qp_requester(struct qed_hwfn *p_hwfn,
 	if (!qp->req_offloaded)
 		return 0;
 
-	p_ramrod_res = (struct roce_destroy_qp_req_output_params *)
-		       dma_alloc_coherent(&p_hwfn->cdev->pdev->dev,
+	p_ramrod_res = dma_alloc_coherent(&p_hwfn->cdev->pdev->dev,
 					  sizeof(*p_ramrod_res),
 					  &ramrod_res_phys, GFP_KERNEL);
 	if (!p_ramrod_res) {
-- 
2.17.1

