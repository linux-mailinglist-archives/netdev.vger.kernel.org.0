Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B96F6349D5
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 23:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235071AbiKVWLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 17:11:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234920AbiKVWK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 17:10:59 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BDB286CC
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 14:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669155057; x=1700691057;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bI1uEiAjRQOJ7ZaCESNNL4ZR59Sisco88juTR70KLSM=;
  b=ktKs6y62ZaUqcapCU1YKyDjJdorFVUbb+aZT/eZ08laYnq3xYZOXYzmb
   WQcodWNoaWT1VFtUUVs4rtZ/kH6Co0fmLqiWZc6yiT7+L0TsCkTH25AqQ
   oMwvHY3TBbI53zPswWqLhks+65rovnZUwzti64J8BXke9Y+VKqa9oxqZ8
   1paqnaVmsMbN02WoPEtr3wkTno25hbmqBKcNh6x7q6myVukwgyiyVMlN9
   nvjMJA35yOmWX8TwObtAtGKLsc+1pgia6kkTh2bESj56x8COeL3Kk1U7F
   0DmPjZn5Up1j9fn7IKucTClABcjGgDg1VMldtYtpY5r2K5b651VKir1DJ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="378182935"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="378182935"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 14:10:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="705127027"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="705127027"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 22 Nov 2022 14:10:56 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next v2 7/7] ice: Use ICE_RLAN_BASE_S instead of magic number
Date:   Tue, 22 Nov 2022 14:10:47 -0800
Message-Id: <20221122221047.3095231-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221122221047.3095231-1-anthony.l.nguyen@intel.com>
References: <20221122221047.3095231-1-anthony.l.nguyen@intel.com>
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

From: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>

Commit 72adf2421d9b ("ice: Move common functions out of ice_main.c part
2/7") moved an older version of ice_setup_rx_ctx() function with
usage of magic number 7.
Reimplement the commit 5ab522443bd1 ("ice: Cleanup magic number") to use
ICE_RLAN_BASE_S instead of magic number.

Signed-off-by: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index e864634d66bc..554095b25f44 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -389,7 +389,7 @@ static int ice_setup_rx_ctx(struct ice_rx_ring *ring)
 	 * Indicates the starting address of the descriptor queue defined in
 	 * 128 Byte units.
 	 */
-	rlan_ctx.base = ring->dma >> 7;
+	rlan_ctx.base = ring->dma >> ICE_RLAN_BASE_S;
 
 	rlan_ctx.qlen = ring->count;
 
-- 
2.35.1

