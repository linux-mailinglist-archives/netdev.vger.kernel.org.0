Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11341576932
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 23:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbiGOVuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 17:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiGOVuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 17:50:00 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2F94F197
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 14:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657921799; x=1689457799;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+4YB69O7DZMH8gTlDOXlFwqTArgcohEPW8pckmr2O6E=;
  b=UzfQN8UJSaT2cx7gR3+wA2YAxdBzuxIq2Fq5og2v90CvY73IfjPEGOO+
   bdxzBLA1GkePLlnzLJnrTfSwLSmvzDxjSgMa0JY4QQP16F4tK2eqMe9Vp
   kD1u2RklFRQA/+4jxuN313zaNvRMC2UpoPOjxWJctZ1gAyWmJgWs0VSs9
   w8gDNUnVBbRtDmUSrNB74mGEiDVrZsC/yxFTbK9JxVLEcSiZ/FMyKsjhL
   Zj3hqECwu6rQ4J/GridzMIMftyYF/teC1k4StQAUtb1XTc3rWY+dMi72t
   mSF5ecQUuqAuxzjN1UTvhjeX5p22m1rw22uKdjteeknLmRVLJobCK0xXX
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10409"; a="283467141"
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="283467141"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 14:49:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="571693446"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 15 Jul 2022 14:49:43 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Zhuo Chen <chenzhuo.1@bytedance.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Muchun Song <songmuchun@bytedance.com>,
        Sen Wang <wangsen.harry@bytedance.com>,
        Wenliang Wang <wangwenliang.1995@bytedance.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next v2 2/2] ice: Remove pci_aer_clear_nonfatal_status() call
Date:   Fri, 15 Jul 2022 14:46:42 -0700
Message-Id: <20220715214642.2968799-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220715214642.2968799-1-anthony.l.nguyen@intel.com>
References: <20220715214642.2968799-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhuo Chen <chenzhuo.1@bytedance.com>

After commit 62b36c3ea664 ("PCI/AER: Remove
pci_cleanup_aer_uncorrect_error_status() calls"), calls to
pci_cleanup_aer_uncorrect_error_status() have already been removed. But in
commit 5995b6d0c6fc ("ice: Implement pci_error_handler ops")
pci_cleanup_aer_uncorrect_error_status  was used again, so remove it in
this patch.

Signed-off-by: Zhuo Chen <chenzhuo.1@bytedance.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Sen Wang <wangsen.harry@bytedance.com>
Cc: Wenliang Wang <wangwenliang.1995@bytedance.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index ff2eac2f8c64..313716615e98 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5313,12 +5313,6 @@ static pci_ers_result_t ice_pci_err_slot_reset(struct pci_dev *pdev)
 			result = PCI_ERS_RESULT_DISCONNECT;
 	}
 
-	err = pci_aer_clear_nonfatal_status(pdev);
-	if (err)
-		dev_dbg(&pdev->dev, "pci_aer_clear_nonfatal_status() failed, error %d\n",
-			err);
-		/* non-fatal, continue */
-
 	return result;
 }
 
-- 
2.35.1

