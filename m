Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10B19381686
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 09:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbhEOHRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 03:17:31 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3691 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbhEOHRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 03:17:31 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FhxSt4vq2z16QCw;
        Sat, 15 May 2021 15:13:34 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Sat, 15 May 2021 15:16:10 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Rasesh Mody <rmody@marvell.com>,
        GR-Linux-NIC-Dev <GR-Linux-NIC-Dev@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <mchan@broadcom.com>,
        netdev <netdev@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] net: bnx2: Fix error return code in bnx2_init_board()
Date:   Sat, 15 May 2021 15:16:05 +0800
Message-ID: <20210515071605.7098-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return -EPERM from the error handling case instead of 0, as done
elsewhere in this function.

Fixes: b6016b767397 ("[BNX2]: New Broadcom gigabit network driver.")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/net/ethernet/broadcom/bnx2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index c0986096c701d36..5bace8a93d73be5 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -8247,9 +8247,9 @@ bnx2_init_board(struct pci_dev *pdev, struct net_device *dev)
 		BNX2_WR(bp, PCI_COMMAND, reg);
 	} else if ((BNX2_CHIP_ID(bp) == BNX2_CHIP_ID_5706_A1) &&
 		!(bp->flags & BNX2_FLAG_PCIX)) {
-
 		dev_err(&pdev->dev,
 			"5706 A1 can only be used in a PCIX bus, aborting\n");
+		rc = -EPERM;
 		goto err_out_unmap;
 	}
 
-- 
2.26.0.106.g9fadedd


