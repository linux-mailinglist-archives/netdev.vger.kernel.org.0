Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F30A47C628
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 19:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241119AbhLUSQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 13:16:26 -0500
Received: from mga14.intel.com ([192.55.52.115]:10321 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241021AbhLUSQX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 13:16:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640110583; x=1671646583;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dwg9Fj9TweaH+vCrKhwQBDIHW1eQ/r2XC4N5hByiJZA=;
  b=a2yCQC+e4k6ATYhbRilSXhNgj5uckVK7oCMXz1XdNXzJBlqRD95mfRKj
   +FguiOhk3tAiCl5LWFWn52iK9/FILR+cy0l4t7DrKO9tq+1v9FSGHz25u
   Jq6g+viTeYSepEm5n6PODmRhejXO8VN4ww2+tnuNDemHve4BJ+6hdPY2j
   ZUwiNxh0hdzT4Tf4gl3s/QpejGted9+IN7RSmPKjI3nS3FwDaCUQYTfTT
   vqJPlMiRUaeXb6J2vBEQB4mVYc8P1PE5eUklOjrccXYfKHplCXX5d03fG
   hMR+bmIAt/+Xp7t/9g7+vzsJwwxlphiRQluGZfdFQ/8PFId+JTM37hm0i
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="240684220"
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="240684220"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 10:02:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="613557854"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 21 Dec 2021 10:02:53 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jason Wang <wangborong@cdjrlc.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 6/8] igb: remove never changed variable `ret_val'
Date:   Tue, 21 Dec 2021 10:01:58 -0800
Message-Id: <20211221180200.3176851-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211221180200.3176851-1-anthony.l.nguyen@intel.com>
References: <20211221180200.3176851-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Wang <wangborong@cdjrlc.com>

The variable used for return status in `igb_write_xmdio_reg' function
is never changed  and this function is just need return 0. Thus, the
`ret_val' can be removed and return 0 at the end of the
`igb_write_xmdio_reg' function.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
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
2.31.1

