Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C6E3421A3
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 17:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhCSQTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 12:19:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:48297 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230051AbhCSQSf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 12:18:35 -0400
IronPort-SDR: luIkyixFOuAB2r10KFo069YHDeGL+fxClwbbQu08+flH/EEmCN9/yVDSqVohd0ZD60DN5ceHPO
 +Bx/h0vx5yzA==
X-IronPort-AV: E=McAfee;i="6000,8403,9928"; a="190014467"
X-IronPort-AV: E=Sophos;i="5.81,262,1610438400"; 
   d="scan'208";a="190014467"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 09:18:34 -0700
IronPort-SDR: 6JHWhX0vjiUmjCUdseIpIyejQClV3tjvsemnXBDalt6agRPZSYVggNP3T6LsxmV8pAYeXX+ZgK
 YQLJ8y+YUgvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,262,1610438400"; 
   d="scan'208";a="450915175"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 19 Mar 2021 09:18:34 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tom Seewald <tseewald@gmail.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH net 2/3] igb: Fix duplicate include guard
Date:   Fri, 19 Mar 2021 09:19:56 -0700
Message-Id: <20210319161957.784610-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210319161957.784610-1-anthony.l.nguyen@intel.com>
References: <20210319161957.784610-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Seewald <tseewald@gmail.com>

The include guard "_E1000_HW_H_" is used by two separate header files in
two different drivers (e1000/e1000_hw.h and igb/e1000_hw.h). Using the
same include guard macro in more than one header file may cause
unexpected behavior from the compiler. Fix this by renaming the
duplicate guard in the igb driver.

Fixes: 9d5c824399de ("igb: PCI-Express 82575 Gigabit Ethernet driver")
Signed-off-by: Tom Seewald <tseewald@gmail.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/e1000_hw.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/e1000_hw.h b/drivers/net/ethernet/intel/igb/e1000_hw.h
index 5d87957b2627..44111f65afc7 100644
--- a/drivers/net/ethernet/intel/igb/e1000_hw.h
+++ b/drivers/net/ethernet/intel/igb/e1000_hw.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright(c) 2007 - 2018 Intel Corporation. */
 
-#ifndef _E1000_HW_H_
-#define _E1000_HW_H_
+#ifndef _E1000_IGB_HW_H_
+#define _E1000_IGB_HW_H_
 
 #include <linux/types.h>
 #include <linux/delay.h>
@@ -551,4 +551,4 @@ s32 igb_write_pcie_cap_reg(struct e1000_hw *hw, u32 reg, u16 *value);
 
 void igb_read_pci_cfg(struct e1000_hw *hw, u32 reg, u16 *value);
 void igb_write_pci_cfg(struct e1000_hw *hw, u32 reg, u16 *value);
-#endif /* _E1000_HW_H_ */
+#endif /* _E1000_IGB_HW_H_ */
-- 
2.26.2

