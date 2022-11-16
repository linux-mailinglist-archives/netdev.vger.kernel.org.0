Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9CEE62BDDB
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 13:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238909AbiKPMab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 07:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238911AbiKPMaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 07:30:06 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6D81CE
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 04:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668601786; x=1700137786;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hMRemBd9Z0hxgWDLG1Z8eWMrFzJx3kAuquUpZCYu7WM=;
  b=Kvu6KhUBkUuAXVH6ujlogTAjuS5j/g7e6imKgGTddtGqa0g4w7NOX2+/
   /SqGG6uwLpNujppHItQE2Tq5l2voqM24LMpslR9zcyub7GCy955/ztfz/
   GcuC/xyYM12tVGQgNF9y356RHjmE5Cc5eS/a/bSAbKMUq5JTiFRzohUzS
   Cpo7vlI9o0wPh71YlbOPySdC3Zopopz1O6riDxMocx7gHsLe1OJdA+69H
   hm8FwlHs1yp8s9Bss8czUojFl3TTdNoTpMIBa9mQmxDrQ2wRbDGQlc7dF
   Cv9w9vs3MsHsCYvylWrATFcYDqoE0LycLKSjAQ+xe3oTgDjWdIqR+tQPo
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="311238515"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="311238515"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 04:29:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="641626856"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="641626856"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga007.fm.intel.com with ESMTP; 16 Nov 2022 04:29:44 -0800
Received: from vecna.. (vecna.igk.intel.com [10.123.220.17])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AGCThCB025791;
        Wed, 16 Nov 2022 12:29:44 GMT
From:   Przemek Kitszel <przemyslaw.kitszel@intel.com>
To:     intel-wired-lan@osuosl.org
Cc:     netdev@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Przemek Kitszel <przemyslaw.kitszel@intel.com>
Subject: [PATCH net-next] ice: remove redundant non-null check in ice_setup_pf_sw()
Date:   Wed, 16 Nov 2022 13:20:32 +0100
Message-Id: <20221116122032.969666-1-przemyslaw.kitszel@intel.com>
X-Mailer: git-send-email 2.34.3
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
---
 drivers/net/ethernet/intel/ice/ice_main.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 962b791e3ac7..b2d35d7e9d49 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3786,13 +3786,11 @@ static int ice_setup_pf_sw(struct ice_pf *pf)
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
2.34.3

