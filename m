Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5707674521
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 22:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbjASVnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 16:43:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjASVjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 16:39:36 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB13249564
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 13:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674163686; x=1705699686;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/TMv1U+4pDkiPWrC+Ej8xblL92yo5WKv5vVPthao4CQ=;
  b=Tjv4lGJhFxkxgexAVYMVOfSIWvHhe4z/PKMQAegEEWYs1PDOH8h2HRNS
   Wf0utpyBGaRL61pIVmoUhWpXhE4QUgZ2jPDRFL7HSsEm7P6zdqwzaBVW5
   bVujSH+4BnH275anLZvmZW6L0mNecxGb1vX4edCOpumjvKTCDllDUOkgL
   FuH3d1xr97RJ8IDAhvO2mnyOtyz0C8snH/UU+5rQeMPJRGUHHyNCJnPdx
   bfsrnuOWBP9g54nG805tVXAwgd+fIwolOkHa6j2e1R46ztDrdkIvLIQJR
   k5HesSWHmhh9oLlC0AK5f3ZtkNBHMB4uCC+Qvg1GN9HOCXfB5rKjBbifs
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="323120614"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="323120614"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 13:27:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="692589880"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="692589880"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga001.jf.intel.com with ESMTP; 19 Jan 2023 13:27:27 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Przemek Kitszel <przemyslaw.kitszel@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 05/15] ice: remove redundant non-null check in ice_setup_pf_sw()
Date:   Thu, 19 Jan 2023 13:27:32 -0800
Message-Id: <20230119212742.2106833-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230119212742.2106833-1-anthony.l.nguyen@intel.com>
References: <20230119212742.2106833-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

Remove a redundant null check, as vsi could not be null at this point.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a9a7f8b52140..d3ebfaf5a04b 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3780,13 +3780,11 @@ static int ice_setup_pf_sw(struct ice_pf *pf)
 unroll_napi_add:
 	ice_tc_indir_block_unregister(vsi);
 unroll_cfg_netdev:
-	if (vsi) {
-		ice_napi_del(vsi);
-		if (vsi->netdev) {
-			clear_bit(ICE_VSI_NETDEV_ALLOCD, vsi->state);
-			free_netdev(vsi->netdev);
-			vsi->netdev = NULL;
-		}
+	ice_napi_del(vsi);
+	if (vsi->netdev) {
+		clear_bit(ICE_VSI_NETDEV_ALLOCD, vsi->state);
+		free_netdev(vsi->netdev);
+		vsi->netdev = NULL;
 	}
 
 unroll_vsi_setup:
-- 
2.38.1

