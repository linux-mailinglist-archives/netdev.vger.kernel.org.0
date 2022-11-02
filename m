Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA93616F66
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 22:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbiKBVKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 17:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbiKBVK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 17:10:26 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199E8DFBA
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 14:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667423425; x=1698959425;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8PwXYXkH5BCsz2BIIzxHgmsK8vvRAxuop9AFy/IZkS8=;
  b=TIO6m4Wn5j0O6dQVvh+scsyZEEgQninsJfZhBwDfY4IM5rV21LaTnG3y
   RZhewTmSc9pTZriMqM10u2WG+JBdHZDzofRVp+sQeYE266cAqLSWMRSWl
   evdEPoXb0s/PD5aicHWcI/VvXcxuUlHQJayAGfka3FYSLmtWPLkv3sms2
   RZF8F015nd3qCSRlT4npVLMzcKlhGcFNLIBZJ+8UBUdVUE/1+FLEskbqQ
   rUZKcT7+eZUeeJhSBX0IscKbtzNPobNvM4QbXTjZEq/mT2Gv0HRk8wxO1
   udlLckVHvmkh9XkwUlkOf7Ndc8yEXvYSpHk2W/pJ4T4Zp9X0OwTTY2yw3
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="311245994"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="311245994"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 14:10:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="629103010"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="629103010"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 02 Nov 2022 14:10:19 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Bartosz Staszewski <bartoszx.staszewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Kamil Maziarz <kamil.maziarz@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 7/7] iavf: Change information about device removal in dmesg
Date:   Wed,  2 Nov 2022 14:10:11 -0700
Message-Id: <20221102211011.2944983-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221102211011.2944983-1-anthony.l.nguyen@intel.com>
References: <20221102211011.2944983-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Staszewski <bartoszx.staszewski@intel.com>

Changed information about device removal in dmesg.
In function iavf_remove changed printed message from
"Remove" to "Removing" after hot vf plug/unplug.
Reason for this change is that, that "Removing" word
is better because it is clearer for the user that
the device is already being removed rather than implying
that the user should remove this device.

Signed-off-by: Bartosz Staszewski <bartoszx.staszewski@intel.com>
Signed-off-by: Kamil Maziarz <kamil.maziarz@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index efa2692af577..258bdf8906dd 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -5083,7 +5083,7 @@ static void iavf_remove(struct pci_dev *pdev)
 	}
 
 	mutex_lock(&adapter->crit_lock);
-	dev_info(&adapter->pdev->dev, "Remove device\n");
+	dev_info(&adapter->pdev->dev, "Removing device\n");
 	iavf_change_state(adapter, __IAVF_REMOVE);
 
 	iavf_request_reset(adapter);
-- 
2.35.1

