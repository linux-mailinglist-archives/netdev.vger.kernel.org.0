Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06B3439E07
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbhJYR7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:59:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:30381 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232051AbhJYR7Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 13:59:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10148"; a="229575737"
X-IronPort-AV: E=Sophos;i="5.87,181,1631602800"; 
   d="scan'208";a="229575737"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2021 10:56:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,181,1631602800"; 
   d="scan'208";a="554291200"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 25 Oct 2021 10:56:53 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Yang Li <yang.lee@linux.alibaba.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH net-next 2/4] intel: Simplify bool conversion
Date:   Mon, 25 Oct 2021 10:55:06 -0700
Message-Id: <20211025175508.1461435-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211025175508.1461435-1-anthony.l.nguyen@intel.com>
References: <20211025175508.1461435-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

Fix the following coccicheck warning:
./drivers/net/ethernet/intel/i40e/i40e_xsk.c:229:35-40: WARNING:
conversion to bool not needed here
./drivers/net/ethernet/intel/ice/ice_xsk.c:399:35-40: WARNING:
conversion to bool not needed here

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 6f85879ba993..ea06e957393e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -226,7 +226,7 @@ bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count)
 	rx_desc->wb.qword1.status_error_len = 0;
 	i40e_release_rx_desc(rx_ring, ntu);
 
-	return count == nb_buffs ? true : false;
+	return count == nb_buffs;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index d9dfcfc2c6f9..ff55cb415b11 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -399,7 +399,7 @@ bool ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count)
 	rx_desc->wb.status_error0 = 0;
 	ice_release_rx_desc(rx_ring, ntu);
 
-	return count == nb_buffs ? true : false;
+	return count == nb_buffs;
 }
 
 /**
-- 
2.31.1

