Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531192B0406
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 12:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbgKLLiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 06:38:13 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7178 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727234AbgKLLiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 06:38:13 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CX02x1xRTz15TLn;
        Thu, 12 Nov 2020 19:38:01 +0800 (CST)
Received: from compute.localdomain (10.175.112.70) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Thu, 12 Nov 2020 19:38:08 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jakub.pawlak@intel.com>,
        <jeffrey.t.kirsher@intel.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] iavf: fix error return code in iavf_init_get_resources()
Date:   Thu, 12 Nov 2020 19:39:54 +0800
Message-ID: <1605181194-3093-1-git-send-email-zhangchangzhong@huawei.com>
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

Fixes: b66c7bc1cd4d ("iavf: Refactor init state machine")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 95543df..ff1102d 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1776,7 +1776,8 @@ static int iavf_init_get_resources(struct iavf_adapter *adapter)
 		goto err_alloc;
 	}
 
-	if (iavf_process_config(adapter))
+	err = iavf_process_config(adapter);
+	if (err)
 		goto err_alloc;
 	adapter->current_op = VIRTCHNL_OP_UNKNOWN;
 
-- 
2.9.5

