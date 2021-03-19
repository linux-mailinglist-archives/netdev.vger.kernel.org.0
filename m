Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA4C8341696
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 08:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbhCSH1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 03:27:17 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13205 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234213AbhCSH1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 03:27:10 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F1wQ13nZRzmZc0;
        Fri, 19 Mar 2021 15:24:41 +0800 (CST)
Received: from huawei.com (10.174.28.241) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.498.0; Fri, 19 Mar 2021
 15:26:59 +0800
From:   Bixuan Cui <cuibixuan@huawei.com>
To:     <davem@davemloft.net>, <jesse.brandeburg@intel.com>,
        <anthony.l.nguyen@intel.com>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <john.wanghui@huawei.com>
Subject: [PATCH -next] e1000e: Fix 'defined but not used' warning
Date:   Fri, 19 Mar 2021 15:26:55 +0800
Message-ID: <20210319072655.66545-1-cuibixuan@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.28.241]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the warning while disable CONFIG_PM_SLEEP:

drivers/net/ethernet/intel/e1000e/netdev.c:6926:12: warning:
    ‘e1000e_pm_prepare’ defined but not used [-Wunused-function]
static int e1000e_pm_prepare(struct device *dev)
            ^~~~~~~~~~~~~~~~~

Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index f1c9debd9f3b..d2e4653536c5 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6923,7 +6923,7 @@ static int __e1000_resume(struct pci_dev *pdev)
 	return 0;
 }
 
-static int e1000e_pm_prepare(struct device *dev)
+static __maybe_unused int e1000e_pm_prepare(struct device *dev)
 {
 	return pm_runtime_suspended(dev) &&
 		pm_suspend_via_firmware();
-- 
2.17.1

