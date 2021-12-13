Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00179471F7F
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 04:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbhLMDLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 22:11:23 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:60079 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231378AbhLMDLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 22:11:22 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R691e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0V-MsODL_1639365069;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0V-MsODL_1639365069)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 13 Dec 2021 11:11:10 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, nathan@kernel.org,
        ndesaulniers@google.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] i40e: remove variables set but not used
Date:   Mon, 13 Dec 2021 11:11:07 +0800
Message-Id: <20211213031107.52438-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code that uses variables pe_cntx_size and pe_filt_size 
has been removed, so they should be removed as well.

Eliminate the following clang warnings:
drivers/net/ethernet/intel/i40e/i40e_common.c:4139:20:
warning: variable 'pe_filt_size' set but not used.
drivers/net/ethernet/intel/i40e/i40e_common.c:4139:6:
warning: variable 'pe_cntx_size' set but not used.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Fixes: 467d729abb72 ("i40e/i40evf: Fix code to accommodate i40e_register.h changes")
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/ethernet/intel/i40e/i40e_common.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index b4d3fed0d2f2..a775e55ae8bc 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -4136,7 +4136,6 @@ static i40e_status i40e_validate_filter_settings(struct i40e_hw *hw,
 				struct i40e_filter_control_settings *settings)
 {
 	u32 fcoe_cntx_size, fcoe_filt_size;
-	u32 pe_cntx_size, pe_filt_size;
 	u32 fcoe_fmax;
 	u32 val;
 
@@ -4180,8 +4179,6 @@ static i40e_status i40e_validate_filter_settings(struct i40e_hw *hw,
 	case I40E_HASH_FILTER_SIZE_256K:
 	case I40E_HASH_FILTER_SIZE_512K:
 	case I40E_HASH_FILTER_SIZE_1M:
-		pe_filt_size = I40E_HASH_FILTER_BASE_SIZE;
-		pe_filt_size <<= (u32)settings->pe_filt_num;
 		break;
 	default:
 		return I40E_ERR_PARAM;
@@ -4198,8 +4195,6 @@ static i40e_status i40e_validate_filter_settings(struct i40e_hw *hw,
 	case I40E_DMA_CNTX_SIZE_64K:
 	case I40E_DMA_CNTX_SIZE_128K:
 	case I40E_DMA_CNTX_SIZE_256K:
-		pe_cntx_size = I40E_DMA_CNTX_BASE_SIZE;
-		pe_cntx_size <<= (u32)settings->pe_cntx_num;
 		break;
 	default:
 		return I40E_ERR_PARAM;
-- 
2.20.1.7.g153144c

