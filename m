Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59FD41B9AD
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 23:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243000AbhI1Vzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 17:55:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:59509 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242958AbhI1Vzg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 17:55:36 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10121"; a="224851569"
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="224851569"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 14:53:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="486701078"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 28 Sep 2021 14:53:55 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jeff Guo <jia.guo@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Ting Xu <ting.xu@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 5/6] ice: Fix macro name for IPv4 fragment flag
Date:   Tue, 28 Sep 2021 14:57:56 -0700
Message-Id: <20210928215757.3378414-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210928215757.3378414-1-anthony.l.nguyen@intel.com>
References: <20210928215757.3378414-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Guo <jia.guo@intel.com>

In IPv4 header, fragment flags indicate whether the packet needs
to be fragmented or not. The value 0x20 represents MF (More Fragment); fix
the macro name to match this.

Signed-off-by: Ting Xu <ting.xu@intel.com>
Signed-off-by: Jeff Guo <jia.guo@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_fdir.c | 2 +-
 drivers/net/ethernet/intel/ice/ice_fdir.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_fdir.c b/drivers/net/ethernet/intel/ice/ice_fdir.c
index 59ef68f072c0..cbd8424631e3 100644
--- a/drivers/net/ethernet/intel/ice/ice_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_fdir.c
@@ -952,7 +952,7 @@ ice_fdir_get_gen_prgm_pkt(struct ice_hw *hw, struct ice_fdir_fltr *input,
 		ice_pkt_insert_u8(loc, ICE_IPV4_TTL_OFFSET, input->ip.v4.ttl);
 		ice_pkt_insert_mac_addr(loc, input->ext_data.dst_mac);
 		if (frag)
-			loc[20] = ICE_FDIR_IPV4_PKT_FLAG_DF;
+			loc[20] = ICE_FDIR_IPV4_PKT_FLAG_MF;
 		break;
 	case ICE_FLTR_PTYPE_NONF_IPV4_UDP:
 		ice_pkt_insert_u32(loc, ICE_IPV4_DST_ADDR_OFFSET,
diff --git a/drivers/net/ethernet/intel/ice/ice_fdir.h b/drivers/net/ethernet/intel/ice/ice_fdir.h
index d2d40e18ae8a..da4163856f4c 100644
--- a/drivers/net/ethernet/intel/ice/ice_fdir.h
+++ b/drivers/net/ethernet/intel/ice/ice_fdir.h
@@ -48,7 +48,7 @@
  * requests that the packet not be fragmented. MF indicates that a packet has
  * been fragmented.
  */
-#define ICE_FDIR_IPV4_PKT_FLAG_DF		0x20
+#define ICE_FDIR_IPV4_PKT_FLAG_MF		0x20
 
 enum ice_fltr_prgm_desc_dest {
 	ICE_FLTR_PRGM_DESC_DEST_DROP_PKT,
-- 
2.26.2

