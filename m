Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D90D396DFE
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 09:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233248AbhFAHgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 03:36:15 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2926 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233096AbhFAHgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 03:36:14 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FvP3q0Tpsz67H4;
        Tue,  1 Jun 2021 15:31:35 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 1 Jun 2021 15:34:30 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] igb: Declare the function igb_init_nvm_params_i210 as void
Date:   Tue, 1 Jun 2021 15:48:10 +0800
Message-ID: <20210601074810.4079573-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

variable 'ret_val' is unneeded and it's noneed to check the
return value of function igb_init_nvm_params_i210, so
declare it as void.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/intel/igb/e1000_82575.c | 2 +-
 drivers/net/ethernet/intel/igb/e1000_i210.c  | 4 +---
 drivers/net/ethernet/intel/igb/e1000_i210.h  | 2 +-
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/e1000_82575.c b/drivers/net/ethernet/intel/igb/e1000_82575.c
index 50863fd87d53..967aa20f4cc6 100644
--- a/drivers/net/ethernet/intel/igb/e1000_82575.c
+++ b/drivers/net/ethernet/intel/igb/e1000_82575.c
@@ -682,7 +682,7 @@ static s32 igb_get_invariants_82575(struct e1000_hw *hw)
 	switch (hw->mac.type) {
 	case e1000_i210:
 	case e1000_i211:
-		ret_val = igb_init_nvm_params_i210(hw);
+		igb_init_nvm_params_i210(hw);
 		break;
 	default:
 		break;
diff --git a/drivers/net/ethernet/intel/igb/e1000_i210.c b/drivers/net/ethernet/intel/igb/e1000_i210.c
index 9265901455cd..986e86ab7978 100644
--- a/drivers/net/ethernet/intel/igb/e1000_i210.c
+++ b/drivers/net/ethernet/intel/igb/e1000_i210.c
@@ -790,9 +790,8 @@ s32 igb_write_xmdio_reg(struct e1000_hw *hw, u16 addr, u8 dev_addr, u16 data)
  *  igb_init_nvm_params_i210 - Init NVM func ptrs.
  *  @hw: pointer to the HW structure
  **/
-s32 igb_init_nvm_params_i210(struct e1000_hw *hw)
+void igb_init_nvm_params_i210(struct e1000_hw *hw)
 {
-	s32 ret_val = 0;
 	struct e1000_nvm_info *nvm = &hw->nvm;
 
 	nvm->ops.acquire = igb_acquire_nvm_i210;
@@ -813,7 +812,6 @@ s32 igb_init_nvm_params_i210(struct e1000_hw *hw)
 		nvm->ops.validate = NULL;
 		nvm->ops.update   = NULL;
 	}
-	return ret_val;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/igb/e1000_i210.h b/drivers/net/ethernet/intel/igb/e1000_i210.h
index 5c437fdc49ee..2a436da0be69 100644
--- a/drivers/net/ethernet/intel/igb/e1000_i210.h
+++ b/drivers/net/ethernet/intel/igb/e1000_i210.h
@@ -11,7 +11,7 @@ s32 igb_read_invm_version(struct e1000_hw *hw,
 			  struct e1000_fw_version *invm_ver);
 s32 igb_read_xmdio_reg(struct e1000_hw *hw, u16 addr, u8 dev_addr, u16 *data);
 s32 igb_write_xmdio_reg(struct e1000_hw *hw, u16 addr, u8 dev_addr, u16 data);
-s32 igb_init_nvm_params_i210(struct e1000_hw *hw);
+void igb_init_nvm_params_i210(struct e1000_hw *hw);
 bool igb_get_flash_presence_i210(struct e1000_hw *hw);
 s32 igb_pll_workaround_i210(struct e1000_hw *hw);
 s32 igb_get_cfg_done_i210(struct e1000_hw *hw);
-- 
2.25.1

