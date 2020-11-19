Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E952B93AF
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 14:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgKSN2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 08:28:48 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7955 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727322AbgKSN2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 08:28:48 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CcL9F28kFzhYjP;
        Thu, 19 Nov 2020 21:28:33 +0800 (CST)
Received: from compute.localdomain (10.175.112.70) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Thu, 19 Nov 2020 21:28:41 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <michael.chan@broadcom.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <prashant@broadcom.com>, <huangjw@broadcom.com>,
        <eddie.wai@broadcom.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] bnxt_en: fix error return code in bnxt_init_board()
Date:   Thu, 19 Nov 2020 21:30:21 +0800
Message-ID: <1605792621-6268-1-git-send-email-zhangchangzhong@huawei.com>
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

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 7c21aaa8..11d0542 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11590,6 +11590,7 @@ static int bnxt_init_board(struct pci_dev *pdev, struct net_device *dev)
 	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) != 0 &&
 	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)) != 0) {
 		dev_err(&pdev->dev, "System does not support DMA, aborting\n");
+		rc = -EIO;
 		goto init_err_disable;
 	}
 
-- 
2.9.5

