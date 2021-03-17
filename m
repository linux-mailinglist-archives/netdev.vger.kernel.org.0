Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF5233F39A
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 15:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbhCQOom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 10:44:42 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14079 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbhCQOoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 10:44:14 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F0tCs1gLFz19GZ3;
        Wed, 17 Mar 2021 22:42:17 +0800 (CST)
Received: from localhost.localdomain (10.175.102.38) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Wed, 17 Mar 2021 22:43:59 +0800
From:   'w00385741 <weiyongjun1@huawei.com>
To:     <weiyongjun1@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>, Chen Yu <yu.c.chen@intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] e1000e: Mark e1000e_pm_prepare() as __maybe_unused
Date:   Wed, 17 Mar 2021 14:52:34 +0000
Message-ID: <20210317145234.3171021-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.102.38]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

The function e1000e_pm_prepare() may have no callers depending
on configuration, so it must be marked __maybe_unused to avoid
harmless warning:

drivers/net/ethernet/intel/e1000e/netdev.c:6926:12:
 warning: 'e1000e_pm_prepare' defined but not used [-Wunused-function]
 6926 | static int e1000e_pm_prepare(struct device *dev)
      |            ^~~~~~~~~~~~~~~~~

Fixes: ccf8b940e5fd ("e1000e: Leverage direct_complete to speed up s2ram")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
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

