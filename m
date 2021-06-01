Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80FB2396DF8
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 09:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233195AbhFAHe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 03:34:57 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2813 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbhFAHe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 03:34:57 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FvP0J4bRLzWpsH;
        Tue,  1 Jun 2021 15:28:32 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 1 Jun 2021 15:33:12 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] iavf: Declare the function iavf_shutdown_adminq as void
Date:   Tue, 1 Jun 2021 15:46:50 +0800
Message-ID: <20210601074650.4078830-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

variable 'ret_code' is unneeded and it's noneed to check the
return value of function iavf_shutdown_adminq,so declare
it as void.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/intel/iavf/iavf_adminq.c    | 6 +-----
 drivers/net/ethernet/intel/iavf/iavf_prototype.h | 2 +-
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_adminq.c b/drivers/net/ethernet/intel/iavf/iavf_adminq.c
index 9fa3fa99b4c2..23612c15b111 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_adminq.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_adminq.c
@@ -549,17 +549,13 @@ enum iavf_status iavf_init_adminq(struct iavf_hw *hw)
  *  iavf_shutdown_adminq - shutdown routine for the Admin Queue
  *  @hw: pointer to the hardware structure
  **/
-enum iavf_status iavf_shutdown_adminq(struct iavf_hw *hw)
+void iavf_shutdown_adminq(struct iavf_hw *hw)
 {
-	enum iavf_status ret_code = 0;
-
 	if (iavf_check_asq_alive(hw))
 		iavf_aq_queue_shutdown(hw, true);
 
 	iavf_shutdown_asq(hw);
 	iavf_shutdown_arq(hw);
-
-	return ret_code;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/iavf/iavf_prototype.h b/drivers/net/ethernet/intel/iavf/iavf_prototype.h
index edebfbbcffdc..29486aaad116 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_prototype.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_prototype.h
@@ -17,7 +17,7 @@
 
 /* adminq functions */
 enum iavf_status iavf_init_adminq(struct iavf_hw *hw);
-enum iavf_status iavf_shutdown_adminq(struct iavf_hw *hw);
+void iavf_shutdown_adminq(struct iavf_hw *hw);
 void iavf_adminq_init_ring_data(struct iavf_hw *hw);
 enum iavf_status iavf_clean_arq_element(struct iavf_hw *hw,
 					struct iavf_arq_event_info *e,
-- 
2.25.1

