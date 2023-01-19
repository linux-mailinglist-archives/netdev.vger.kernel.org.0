Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81156674519
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 22:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbjASVmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 16:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjASVji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 16:39:38 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CB99FDCC
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 13:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674163689; x=1705699689;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zNqG/gqXMQPrDWI0dBo390HruDZEH5CTcXln5c6AQ84=;
  b=haR2br8E4siDfRT3EBNYA4H9L0Nl4G6kz2cQwKZWQBidWuHJeXzDpmFX
   M/ziZDKj4+K0G1h+e2cB9YXkOkuxg4jaNeOqZ2rbGXTuHqPAM4UHkKJ8F
   KPTwGmOdUXsGaUkLTBjEZTlpBLD4wBYBdlXIc9HUTWleWcV/cov2Gxgl+
   ezdjx3IY6CG9kzkWAl2BCU00SwJC3BjbzeF404By83Ce4bRLRJD/2tngK
   MIWLwundd6KjGm2hRwlsadur00XQgNW1ofnuIZQOEwvTS4OGx8XQB0nP7
   q6dm0LY0xpIHrffGHmlus7XzUGFtGQtVTKZyTblxfoADfzAPEkcZ790Lk
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="323120664"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="323120664"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 13:27:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="692589910"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="692589910"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga001.jf.intel.com with ESMTP; 19 Jan 2023 13:27:28 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 14/15] ice: Introduce local var for readability
Date:   Thu, 19 Jan 2023 13:27:41 -0800
Message-Id: <20230119212742.2106833-15-anthony.l.nguyen@intel.com>
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

Based on previous feedback[1], introduce a local var to make things more
readable.

[1] https://lore.kernel.org/netdev/20220315203218.607f612b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
---
 drivers/net/ethernet/intel/ice/ice_main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c6d57f316429..cb870da5c317 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5046,8 +5046,11 @@ static void ice_setup_mc_magic_wake(struct ice_pf *pf)
 static void ice_remove(struct pci_dev *pdev)
 {
 	struct ice_pf *pf = pci_get_drvdata(pdev);
+	struct ice_hw *hw;
 	int i;
 
+	hw = &pf->hw;
+
 	ice_devlink_unregister(pf);
 	for (i = 0; i < ICE_MAX_RESET_WAIT; i++) {
 		if (!ice_is_reset_in_progress(pf->state))
@@ -5080,7 +5083,7 @@ static void ice_remove(struct pci_dev *pdev)
 		ice_remove_arfs(pf);
 	ice_setup_mc_magic_wake(pf);
 	ice_vsi_release_all(pf);
-	mutex_destroy(&(&pf->hw)->fdir_fltr_lock);
+	mutex_destroy(&hw->fdir_fltr_lock);
 	ice_set_wake(pf);
 	ice_free_irq_msix_misc(pf);
 	ice_for_each_vsi(pf, i) {
@@ -5092,13 +5095,13 @@ static void ice_remove(struct pci_dev *pdev)
 	pf->vsi_stats = NULL;
 	ice_deinit_pf(pf);
 	ice_devlink_destroy_regions(pf);
-	ice_deinit_hw(&pf->hw);
+	ice_deinit_hw(hw);
 
 	/* Issue a PFR as part of the prescribed driver unload flow.  Do not
 	 * do it via ice_schedule_reset() since there is no need to rebuild
 	 * and the service task is already stopped.
 	 */
-	ice_reset(&pf->hw, ICE_RESET_PFR);
+	ice_reset(hw, ICE_RESET_PFR);
 	pci_wait_for_pending_transaction(pdev);
 	ice_clear_interrupt_scheme(pf);
 	pci_disable_pcie_error_reporting(pdev);
-- 
2.38.1

