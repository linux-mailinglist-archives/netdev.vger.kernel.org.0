Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB3D4A903B
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 22:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355327AbiBCVvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 16:51:53 -0500
Received: from mga01.intel.com ([192.55.52.88]:63985 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355092AbiBCVvw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 16:51:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643925112; x=1675461112;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f9/RQFh7MPRlyW60tvcGoyjyXCprj6oYzJY3vQ3em90=;
  b=l1irt/1ccqlsG7wLGLYycmpsQkEsK/6IzKoUu+Vw57ckY29+Ib8GdSJH
   /skD9CGVTdavZuOBrO3nXL+0EFIx/qId+OcM6neFvIiJSFmWlp352vHXm
   7Ai7R4qiH08iMhHUYOLa75TA2vmli8q+KWTmPOgEPQBinD6LT4KbYNms4
   PJDam+yPp+s7CzBZYRfEXTmRq/A2FKC/VlMfZI3oi9a/1ZB9WQo9m4yLy
   gEOKFwrw7O+wR47aT13rLLM3QDVdX3YdAhk/u5YbMxeYK09m9X0Psx4KU
   NbKnAF8UuQx1NnK2aPyzqCoFV8FvSny2I74uwUrUweHmtu5dMDgcTt9ut
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10247"; a="272760131"
X-IronPort-AV: E=Sophos;i="5.88,340,1635231600"; 
   d="scan'208";a="272760131"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2022 13:51:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,340,1635231600"; 
   d="scan'208";a="498295195"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 03 Feb 2022 13:51:51 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Joe Damato <jdamato@fastly.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 2/7] i40e: Remove unused RX realloc stat
Date:   Thu,  3 Feb 2022 13:51:35 -0800
Message-Id: <20220203215140.969227-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220203215140.969227-1-anthony.l.nguyen@intel.com>
References: <20220203215140.969227-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Damato <jdamato@fastly.com>

After commit 1a557afc4dd5 ("i40e: Refactor receive routine"),
rx_stats.realloc_count is no longer being incremented, so remove it.

The debugfs string was left, but hardcoded to 0. This is intended to
prevent breaking any existing code / scripts that are parsing debugfs
for i40e.

Signed-off-by: Joe Damato <jdamato@fastly.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c | 3 +--
 drivers/net/ethernet/intel/i40e/i40e_txrx.h    | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
index 1e57cc8c47d7..90fff05fbd2b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
@@ -275,9 +275,8 @@ static void i40e_dbg_dump_vsi_seid(struct i40e_pf *pf, int seid)
 			 rx_ring->rx_stats.alloc_page_failed,
 			 rx_ring->rx_stats.alloc_buff_failed);
 		dev_info(&pf->pdev->dev,
-			 "    rx_rings[%i]: rx_stats: realloc_count = %lld, page_reuse_count = %lld\n",
+			 "    rx_rings[%i]: rx_stats: realloc_count = 0, page_reuse_count = %lld\n",
 			 i,
-			 rx_ring->rx_stats.realloc_count,
 			 rx_ring->rx_stats.page_reuse_count);
 		dev_info(&pf->pdev->dev,
 			 "    rx_rings[%i]: size = %i\n",
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index bfc2845c99d1..88387a644cc3 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -298,7 +298,6 @@ struct i40e_rx_queue_stats {
 	u64 alloc_page_failed;
 	u64 alloc_buff_failed;
 	u64 page_reuse_count;
-	u64 realloc_count;
 };
 
 enum i40e_ring_state_t {
-- 
2.31.1

