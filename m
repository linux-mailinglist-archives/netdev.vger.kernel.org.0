Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D2F3545D1
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 19:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbhDERIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 13:08:25 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:16340 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234028AbhDERIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 13:08:17 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FDcVs145Pz9wtm;
        Tue,  6 Apr 2021 01:05:57 +0800 (CST)
Received: from A190218597.china.huawei.com (10.47.69.183) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 6 Apr 2021 01:08:00 +0800
From:   Salil Mehta <salil.mehta@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <salil.mehta@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <linuxarm@openeuler.org>
Subject: [PATCH V2 net 1/2] net: hns3: Remove the left over redundant check & assignment
Date:   Mon, 5 Apr 2021 18:06:44 +0100
Message-ID: <20210405170645.29620-2-salil.mehta@huawei.com>
X-Mailer: git-send-email 2.8.3
In-Reply-To: <20210405170645.29620-1-salil.mehta@huawei.com>
References: <20210405170645.29620-1-salil.mehta@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.47.69.183]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This removes the left over check and assignment which is no longer used
anywhere in the function and should have been removed as part of the
below mentioned patch.

Fixes: 012fcb52f67c ("net: hns3: activate reset timer when calling reset_event")
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
--
V1->V2:
[1] Fixed comments from Leon Romanovsky
    Link: https://lkml.org/lkml/2021/4/4/14
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index e3f81c7e0ce7..58d210bbb311 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3966,7 +3966,6 @@ static void hclge_reset_event(struct pci_dev *pdev, struct hnae3_handle *handle)
 	 *    normalcy is to reset.
 	 * 2. A new reset request from the stack due to timeout
 	 *
-	 * For the first case,error event might not have ae handle available.
 	 * check if this is a new reset request and we are not here just because
 	 * last reset attempt did not succeed and watchdog hit us again. We will
 	 * know this if last reset request did not occur very recently (watchdog
@@ -3976,8 +3975,6 @@ static void hclge_reset_event(struct pci_dev *pdev, struct hnae3_handle *handle)
 	 * want to make sure we throttle the reset request. Therefore, we will
 	 * not allow it again before 3*HZ times.
 	 */
-	if (!handle)
-		handle = &hdev->vport[0].nic;
 
 	if (time_before(jiffies, (hdev->last_reset_time +
 				  HCLGE_RESET_INTERVAL))) {
-- 
2.17.1

