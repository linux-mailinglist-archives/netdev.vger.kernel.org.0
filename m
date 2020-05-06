Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B111C6860
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgEFGTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:19:25 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3856 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726863AbgEFGTZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 02:19:25 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 6348CA83649E26CF3A34;
        Wed,  6 May 2020 14:19:23 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Wed, 6 May 2020
 14:19:13 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <jeffrey.t.kirsher@intel.com>, <davem@davemloft.net>,
        <piotr.azarewicz@intel.com>, <intel-wired-lan@lists.osuosl.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH net-next] i40e: Make i40e_shutdown_adminq() return void
Date:   Wed, 6 May 2020 14:18:35 +0800
Message-ID: <20200506061835.19662-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

drivers/net/ethernet/intel/i40e/i40e_adminq.c:699:13-21: Unneeded
variable: "ret_code". Return "0" on line 710

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/ethernet/intel/i40e/i40e_adminq.c    | 6 +-----
 drivers/net/ethernet/intel/i40e/i40e_prototype.h | 2 +-
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq.c b/drivers/net/ethernet/intel/i40e/i40e_adminq.c
index 37514a75f928..6a089848c857 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq.c
@@ -694,10 +694,8 @@ i40e_status i40e_init_adminq(struct i40e_hw *hw)
  *  i40e_shutdown_adminq - shutdown routine for the Admin Queue
  *  @hw: pointer to the hardware structure
  **/
-i40e_status i40e_shutdown_adminq(struct i40e_hw *hw)
+void i40e_shutdown_adminq(struct i40e_hw *hw)
 {
-	i40e_status ret_code = 0;
-
 	if (i40e_check_asq_alive(hw))
 		i40e_aq_queue_shutdown(hw, true);
 
@@ -706,8 +704,6 @@ i40e_status i40e_shutdown_adminq(struct i40e_hw *hw)
 
 	if (hw->nvm_buff.va)
 		i40e_free_virt_mem(hw, &hw->nvm_buff);
-
-	return ret_code;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/i40e/i40e_prototype.h b/drivers/net/ethernet/intel/i40e/i40e_prototype.h
index bbb478f09093..5c1378641b3b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_prototype.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_prototype.h
@@ -17,7 +17,7 @@
 
 /* adminq functions */
 i40e_status i40e_init_adminq(struct i40e_hw *hw);
-i40e_status i40e_shutdown_adminq(struct i40e_hw *hw);
+void i40e_shutdown_adminq(struct i40e_hw *hw);
 void i40e_adminq_init_ring_data(struct i40e_hw *hw);
 i40e_status i40e_clean_arq_element(struct i40e_hw *hw,
 					     struct i40e_arq_event_info *e,
-- 
2.21.1

