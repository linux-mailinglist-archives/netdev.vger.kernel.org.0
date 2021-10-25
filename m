Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2931439E09
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbhJYR7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:59:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:30388 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232977AbhJYR7R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 13:59:17 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10148"; a="229575742"
X-IronPort-AV: E=Sophos;i="5.87,181,1631602800"; 
   d="scan'208";a="229575742"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2021 10:56:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,181,1631602800"; 
   d="scan'208";a="554291214"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 25 Oct 2021 10:56:54 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next 4/4] net: ixgbevf: Remove redundant initialization of variable ret_val
Date:   Mon, 25 Oct 2021 10:55:08 -0700
Message-Id: <20211025175508.1461435-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211025175508.1461435-1-anthony.l.nguyen@intel.com>
References: <20211025175508.1461435-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable ret_val is being initialized with a value that is never
read, it is being updated later on. The assignment is redundant and
can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbevf/vf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/vf.c b/drivers/net/ethernet/intel/ixgbevf/vf.c
index 5fc347abab3c..d459f5c8e98f 100644
--- a/drivers/net/ethernet/intel/ixgbevf/vf.c
+++ b/drivers/net/ethernet/intel/ixgbevf/vf.c
@@ -66,9 +66,9 @@ static s32 ixgbevf_reset_hw_vf(struct ixgbe_hw *hw)
 {
 	struct ixgbe_mbx_info *mbx = &hw->mbx;
 	u32 timeout = IXGBE_VF_INIT_TIMEOUT;
-	s32 ret_val = IXGBE_ERR_INVALID_MAC_ADDR;
 	u32 msgbuf[IXGBE_VF_PERMADDR_MSG_LEN];
 	u8 *addr = (u8 *)(&msgbuf[1]);
+	s32 ret_val;
 
 	/* Call adapter stop to disable tx/rx and clear interrupts */
 	hw->mac.ops.stop_adapter(hw);
-- 
2.31.1

