Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47098463DD5
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 19:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245489AbhK3Sdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 13:33:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:53991 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239522AbhK3Sdp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 13:33:45 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10184"; a="260251840"
X-IronPort-AV: E=Sophos;i="5.87,276,1631602800"; 
   d="scan'208";a="260251840"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 10:14:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,276,1631602800"; 
   d="scan'208";a="499878826"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 30 Nov 2021 10:14:00 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Shiraz Saleem <shiraz.saleem@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, linux-rdma@vger.kernel.org,
        mustafa.ismail@intel.com, jacob.e.keller@intel.com,
        parav@nvidia.com, jiri@nvidia.com
Subject: [PATCH net-next 1/2] net/ice: Fix boolean assignment
Date:   Tue, 30 Nov 2021 10:12:42 -0800
Message-Id: <20211130181243.3707618-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211130181243.3707618-1-anthony.l.nguyen@intel.com>
References: <20211130181243.3707618-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem@intel.com>

vbool in ice_devlink_enable_roce_get can be assigned to a
non-0/1 constant.

Fix this assignment of vbool to be 0/1.

Fixes: e523af4ee560 ("net/ice: Add support for enable_iwarp and enable_roce devlink param")
Suggested-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 478412b28a76..1cfe918db8b9 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -436,7 +436,7 @@ ice_devlink_enable_roce_get(struct devlink *devlink, u32 id,
 {
 	struct ice_pf *pf = devlink_priv(devlink);
 
-	ctx->val.vbool = pf->rdma_mode & IIDC_RDMA_PROTOCOL_ROCEV2;
+	ctx->val.vbool = pf->rdma_mode & IIDC_RDMA_PROTOCOL_ROCEV2 ? true : false;
 
 	return 0;
 }
-- 
2.31.1

