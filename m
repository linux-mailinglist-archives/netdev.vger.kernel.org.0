Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4A844F6FC
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 07:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbhKNGFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 01:05:52 -0500
Received: from smtpbg604.qq.com ([59.36.128.82]:55737 "EHLO smtpbg604.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229537AbhKNGFv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Nov 2021 01:05:51 -0500
X-QQ-mid: bizesmtp43t1636869746t2squ0kq
Received: from localhost.localdomain (unknown [125.69.41.88])
        by esmtp6.qq.com (ESMTP) with 
        id ; Sun, 14 Nov 2021 14:02:24 +0800 (CST)
X-QQ-SSF: 01000000002000C0F000B00A0000000
X-QQ-FEAT: Mzskoac49OiIv0KUitNHgBb3kgXFZxiGEiqTBvjSiDqRqg3yXuxl3T342JbHl
        4g++JaVU0TN+1b89QYqwytK3N9VD2AwPd06cj/sJiTrh6+60krhMot3ZJ7ymCx6/+F1OQoW
        vg5EyYg3eJ7FmovozeHiTiDTeUwxOMz8fVLeCpAsAzCThmgiXgbQX7rvUZ4OnTE2zU74AWM
        fUyxv9ekDP9hjT0NxJLqDgA5fsGB60s6SWgr8FHYORSJqwr4YZQj1q66/FIX3kWuuoM/2tN
        7TxQFoFFI+szTmwDjybybDhSCrExiaOtrOKHym0pTan0iEhXewZPMiIzLqkQTaoOPCKC4vS
        ePvi43zoXYdPWJy5AFO16G6e9ICmkjWiOEvgBLl
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] igb: remove never changed variable `ret_val'
Date:   Sun, 14 Nov 2021 14:02:22 +0800
Message-Id: <20211114060222.231075-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable used for return status in `igb_write_xmdio_reg' function
is never changed  and this function is just need return 0. Thus, the
`ret_val' can be removed and return 0 at the end of the
`igb_write_xmdio_reg' function.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/net/ethernet/intel/igb/e1000_i210.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/e1000_i210.c b/drivers/net/ethernet/intel/igb/e1000_i210.c
index 9265901455cd..b9b9d35494d2 100644
--- a/drivers/net/ethernet/intel/igb/e1000_i210.c
+++ b/drivers/net/ethernet/intel/igb/e1000_i210.c
@@ -792,7 +792,6 @@ s32 igb_write_xmdio_reg(struct e1000_hw *hw, u16 addr, u8 dev_addr, u16 data)
  **/
 s32 igb_init_nvm_params_i210(struct e1000_hw *hw)
 {
-	s32 ret_val = 0;
 	struct e1000_nvm_info *nvm = &hw->nvm;
 
 	nvm->ops.acquire = igb_acquire_nvm_i210;
@@ -813,7 +812,7 @@ s32 igb_init_nvm_params_i210(struct e1000_hw *hw)
 		nvm->ops.validate = NULL;
 		nvm->ops.update   = NULL;
 	}
-	return ret_val;
+	return 0;
 }
 
 /**
-- 
2.33.0

