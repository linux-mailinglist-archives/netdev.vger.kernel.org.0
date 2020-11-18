Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A642F2B7D7F
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 13:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbgKRMQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 07:16:00 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7950 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbgKRMQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 07:16:00 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Cbhbh5hYfzhb8N;
        Wed, 18 Nov 2020 20:15:44 +0800 (CST)
Received: from compute.localdomain (10.175.112.70) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Wed, 18 Nov 2020 20:15:50 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <michael.chan@broadcom.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] bnxt_en: fix error return code in bnxt_init_one()
Date:   Wed, 18 Nov 2020 20:17:31 +0800
Message-ID: <1605701851-20270-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: c213eae8d3cd ("bnxt_en: Improve VF/PF link change logic.")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 7c21aaa8..092775e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12674,6 +12674,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 				create_singlethread_workqueue("bnxt_pf_wq");
 			if (!bnxt_pf_wq) {
 				dev_err(&pdev->dev, "Unable to create workqueue.\n");
+				rc = -ENOMEM;
 				goto init_err_pci_clean;
 			}
 		}
-- 
2.9.5

