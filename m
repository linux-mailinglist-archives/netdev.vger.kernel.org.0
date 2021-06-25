Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A262A3B4908
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 20:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbhFYS5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 14:57:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:14426 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229697AbhFYS5F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 14:57:05 -0400
IronPort-SDR: ZgOpU/wLHLPuBb356L/f7jThR19dHZ9inqWWMreVAo1uvhRd72xZnIrEp1mQI3jDLmSfLyhuIV
 Awb4FmCmDGsQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10026"; a="229326801"
X-IronPort-AV: E=Sophos;i="5.83,299,1616482800"; 
   d="scan'208";a="229326801"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 11:54:44 -0700
IronPort-SDR: zMBfHhOE3oFyRt/2V0c0epWx/IGNZ7Q34HMx0pPp72QgiNQEluACm85vnV4WMNxsuposbaFz2O
 3D2/7YSngebQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,299,1616482800"; 
   d="scan'208";a="491655933"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 25 Jun 2021 11:54:43 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 4/5] ice: remove unnecessary VSI assignment
Date:   Fri, 25 Jun 2021 11:57:32 -0700
Message-Id: <20210625185733.1848704-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210625185733.1848704-1-anthony.l.nguyen@intel.com>
References: <20210625185733.1848704-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ice_get_vf_vsi() is being called twice for the same VSI. Remove the
unnecessary call/assignment.

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 6392e0b31b90..2826570dab51 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1689,7 +1689,6 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 		else
 			promisc_m = ICE_UCAST_PROMISC_BITS;
 
-		vsi = ice_get_vf_vsi(vf);
 		if (ice_vf_set_vsi_promisc(vf, vsi, promisc_m, true))
 			dev_err(dev, "disabling promiscuous mode failed\n");
 	}
-- 
2.26.2

