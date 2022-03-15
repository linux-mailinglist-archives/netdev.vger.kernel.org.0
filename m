Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C65A54D920C
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 02:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243476AbiCOBMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 21:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243525AbiCOBMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 21:12:49 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A5446678
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 18:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647306698; x=1678842698;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3PGpDqtILKV3gshNPgXhv0uY7QRlGrWnXs/dYg/QaTU=;
  b=HKu9bPs69xmVBJCbCy4SWF7MU8NACV4fQT00MRb9ImVfw1wECotUVov/
   NZQg1xzfVw+L7ogPhaVS5wCw6uYWcj0Xd4kWJw+YUOq7wCrcuM6ZZJfxk
   CIcBN+WmfYKo2JA7PJJbQjcyk677IxxYFOINyva0BWr0YCizQ8vkY0naC
   2nwZTJ/TcpY7QGReU/sWzU94/olpWQo5rvAZ0hbn+fjiM9IOvpeMd+yUg
   WvkgJ3R2KZ5mFfyS/Jp9HAcUOBJ3mgVpsP+oScHjuZ9EySxvfaka8zGWi
   mfPRaeWksanuOag3KGJ0sjwRZqsTQqUbrsgdtcIX1urqMgX1AMD1UHkht
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="236790464"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="236790464"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 18:11:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="540222892"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 14 Mar 2022 18:11:33 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next v2 06/11] ice: rename ICE_MAX_VF_COUNT to avoid confusion
Date:   Mon, 14 Mar 2022 18:11:50 -0700
Message-Id: <20220315011155.2166817-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220315011155.2166817-1-anthony.l.nguyen@intel.com>
References: <20220315011155.2166817-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ICE_MAX_VF_COUNT field is defined in ice_sriov.h. This count is true
for SR-IOV but will not be true for all VF implementations, such as when
the ice driver supports Scalable IOV.

Rename this definition to clearly indicate ICE_MAX_SRIOV_VFS.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c  | 2 +-
 drivers/net/ethernet/intel/ice/ice_sriov.c | 8 ++++----
 drivers/net/ethernet/intel/ice/ice_sriov.h | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 61ea670c5cfe..416914452ece 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3754,7 +3754,7 @@ static void ice_set_pf_caps(struct ice_pf *pf)
 	if (func_caps->common_cap.sr_iov_1_1) {
 		set_bit(ICE_FLAG_SRIOV_CAPABLE, pf->flags);
 		pf->vfs.num_supported = min_t(int, func_caps->num_allocd_vfs,
-					      ICE_MAX_VF_COUNT);
+					      ICE_MAX_SRIOV_VFS);
 	}
 	clear_bit(ICE_FLAG_RSS_ENA, pf->flags);
 	if (func_caps->common_cap.rss_table_size)
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 205d7e5003d8..7cd910bb7a7a 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -661,7 +661,7 @@ void ice_free_vfs(struct ice_pf *pf)
 
 		/* clear malicious info since the VF is getting released */
 		if (ice_mbx_clear_malvf(&hw->mbx_snapshot, pf->vfs.malvfs,
-					ICE_MAX_VF_COUNT, vf->vf_id))
+					ICE_MAX_SRIOV_VFS, vf->vf_id))
 			dev_dbg(dev, "failed to clear malicious VF state for VF %u\n",
 				vf->vf_id);
 
@@ -1591,7 +1591,7 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 	/* clear all malicious info if the VFs are getting reset */
 	ice_for_each_vf(pf, bkt, vf)
 		if (ice_mbx_clear_malvf(&hw->mbx_snapshot, pf->vfs.malvfs,
-					ICE_MAX_VF_COUNT, vf->vf_id))
+					ICE_MAX_SRIOV_VFS, vf->vf_id))
 			dev_dbg(dev, "failed to clear malicious VF state for VF %u\n",
 				vf->vf_id);
 
@@ -1805,7 +1805,7 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 
 	/* if the VF has been reset allow it to come up again */
 	if (ice_mbx_clear_malvf(&hw->mbx_snapshot, pf->vfs.malvfs,
-				ICE_MAX_VF_COUNT, vf->vf_id))
+				ICE_MAX_SRIOV_VFS, vf->vf_id))
 		dev_dbg(dev, "failed to clear malicious VF state for VF %u\n", i);
 
 	return true;
@@ -6624,7 +6624,7 @@ ice_is_malicious_vf(struct ice_pf *pf, struct ice_rq_event_info *event,
 		 * know about it, then let them know now
 		 */
 		status = ice_mbx_report_malvf(&pf->hw, pf->vfs.malvfs,
-					      ICE_MAX_VF_COUNT, vf_id,
+					      ICE_MAX_SRIOV_VFS, vf_id,
 					      &report_vf);
 		if (status)
 			dev_dbg(dev, "Error reporting malicious VF\n");
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.h b/drivers/net/ethernet/intel/ice/ice_sriov.h
index 699690c1f6a0..b40e74cfb694 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.h
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.h
@@ -22,7 +22,7 @@
 #define ICE_PCI_CIAD_WAIT_DELAY_US	1
 
 /* VF resource constraints */
-#define ICE_MAX_VF_COUNT		256
+#define ICE_MAX_SRIOV_VFS		256
 #define ICE_MIN_QS_PER_VF		1
 #define ICE_NONQ_VECS_VF		1
 #define ICE_MAX_RSS_QS_PER_VF		16
@@ -147,7 +147,7 @@ struct ice_vfs {
 	u16 num_qps_per;		/* number of queue pairs per VF */
 	u16 num_msix_per;		/* number of MSI-X vectors per VF */
 	unsigned long last_printed_mdd_jiffies;	/* MDD message rate limit */
-	DECLARE_BITMAP(malvfs, ICE_MAX_VF_COUNT); /* malicious VF indicator */
+	DECLARE_BITMAP(malvfs, ICE_MAX_SRIOV_VFS); /* malicious VF indicator */
 };
 
 /* VF information structure */
-- 
2.31.1

