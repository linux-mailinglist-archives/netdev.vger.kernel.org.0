Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918DD2709BE
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 03:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgISBtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 21:49:35 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13268 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726009AbgISBte (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 21:49:34 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 84F359BA2C670F7431DF;
        Sat, 19 Sep 2020 09:49:33 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Sat, 19 Sep 2020 09:49:26 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <jeffrey.t.kirsher@intel.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <intel-wired-lan@lists.osuosl.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: e1000: Remove set but not used variable
Date:   Sat, 19 Sep 2020 09:50:20 +0800
Message-ID: <20200919015020.22963-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/ethernet/intel/e1000/e1000_hw.c: In function e1000_phy_init_script:
drivers/net/ethernet/intel/e1000/e1000_hw.c:132:6: warning: variable ‘ret_val’ set but not used [-Wunused-but-set-variable]

`ret_val` is never used, so remove it.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/intel/e1000/e1000_hw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_hw.c b/drivers/net/ethernet/intel/e1000/e1000_hw.c
index 4e7a0810eaeb..f1dbd7b8ee32 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_hw.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_hw.c
@@ -129,7 +129,6 @@ static s32 e1000_set_phy_type(struct e1000_hw *hw)
  */
 static void e1000_phy_init_script(struct e1000_hw *hw)
 {
-	u32 ret_val;
 	u16 phy_saved_data;
 
 	if (hw->phy_init_script) {
@@ -138,7 +137,7 @@ static void e1000_phy_init_script(struct e1000_hw *hw)
 		/* Save off the current value of register 0x2F5B to be restored
 		 * at the end of this routine.
 		 */
-		ret_val = e1000_read_phy_reg(hw, 0x2F5B, &phy_saved_data);
+		e1000_read_phy_reg(hw, 0x2F5B, &phy_saved_data);
 
 		/* Disabled the PHY transmitter */
 		e1000_write_phy_reg(hw, 0x2F5B, 0x0003);
-- 
2.17.1

