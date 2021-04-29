Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9510136E8F3
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 12:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240449AbhD2KjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 06:39:19 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:37071 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233219AbhD2KjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 06:39:17 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R771e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0UXA-6oz_1619692707;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UXA-6oz_1619692707)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 29 Apr 2021 18:38:29 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     aelior@marvell.com
Cc:     skalluru@marvell.com, GR-everest-linux-l2@marvell.com,
        davem@davemloft.net, kuba@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] bnx2x: Remove redundant assignment to err
Date:   Thu, 29 Apr 2021 18:38:25 +0800
Message-Id: <1619692705-100691-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable 'err' is set to -EIO but this value is never read as it is
overwritten with a new value later on, hence it is a redundant
assignment and can be removed.

Clean up the following clang-analyzer warning:
drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c:1195:2: warning: Value
stored to 'err' is never read [clang-analyzer-deadcode.DeadStores]

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
index 9c2f51f..d21f085 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
@@ -1192,7 +1192,6 @@ int bnx2x_iov_init_one(struct bnx2x *bp, int int_mode_param,
 		return 0;
 	}
 
-	err = -EIO;
 	/* verify ari is enabled */
 	if (!pci_ari_enabled(bp->pdev->bus)) {
 		BNX2X_ERR("ARI not supported (check pci bridge ARI forwarding), SRIOV can not be enabled\n");
-- 
1.8.3.1

