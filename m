Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41FCA570DDF
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 01:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbiGKXGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 19:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbiGKXFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 19:05:51 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F8082468
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 16:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657580751; x=1689116751;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MfiTeKa/pGmKDOflO1ZK3YC0kMXbQRAw2LUpsn/hkcI=;
  b=Fa1pHT8errYN5jEQ5wMganYe+8zXEteKMpXtHndvKHSFp2wSkDz/ACxe
   So325iZvP8vmXG4x7qutwsbN+MurR4uLsiYQGgyKfo2WU1tHfbG0h/+A3
   jh22VzB4Rp9iaS3dOGcw4czMWSQLcl2m5gOpv/AmzdlnNIW83uNa9UDxx
   6OvObk8nHVDpoDzzuUNq125d7/b7wNxPfDyv4Oneg8uet5UUR4nRo/vKE
   bXxAkIpvvcBH9gwwR3SnAP8Qe7tjH12fSqyJVF4FoTRGeD0GYi8PVrtqk
   /i8V3frJFT3zXe4S9Kt0yBiI8k8/8BIg2C8rbyt4I0GQVV18jWecyH1jT
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="346473390"
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="346473390"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 16:05:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="599189405"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 11 Jul 2022 16:05:48 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Jun Zhang <xuejun.zhang@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 7/7] iavf: Fix missing state logs
Date:   Mon, 11 Jul 2022 16:02:43 -0700
Message-Id: <20220711230243.3123667-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220711230243.3123667-1-anthony.l.nguyen@intel.com>
References: <20220711230243.3123667-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>

Fix debug prints, by adding missing state prints.

Extend iavf_state_str by strings for __IAVF_INIT_EXTENDED_CAPS and
__IAVF_INIT_CONFIG_ADAPTER.

Without this patch, when enabling debug prints for iavf.h, user will
see:
iavf 0000:06:0e.0: state transition from:__IAVF_INIT_GET_RESOURCES to:__IAVF_UNKNOWN_STATE
iavf 0000:06:0e.0: state transition from:__IAVF_UNKNOWN_STATE to:__IAVF_UNKNOWN_STATE

Fixes: 605ca7c5c670 ("iavf: Fix kernel BUG in free_msi_irqs")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Jun Zhang <xuejun.zhang@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 2a7b3c085aa9..0ea0361cd86b 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -464,6 +464,10 @@ static inline const char *iavf_state_str(enum iavf_state_t state)
 		return "__IAVF_INIT_VERSION_CHECK";
 	case __IAVF_INIT_GET_RESOURCES:
 		return "__IAVF_INIT_GET_RESOURCES";
+	case __IAVF_INIT_EXTENDED_CAPS:
+		return "__IAVF_INIT_EXTENDED_CAPS";
+	case __IAVF_INIT_CONFIG_ADAPTER:
+		return "__IAVF_INIT_CONFIG_ADAPTER";
 	case __IAVF_INIT_SW:
 		return "__IAVF_INIT_SW";
 	case __IAVF_INIT_FAILED:
-- 
2.35.1

