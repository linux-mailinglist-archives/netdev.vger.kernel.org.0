Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A35063769C
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 11:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbiKXKiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 05:38:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiKXKiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 05:38:19 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC9524BED
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 02:38:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669286297; x=1700822297;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xNsnGsArlsExxKFda04bwU7zhM+RVjgJNREPsBG45lU=;
  b=f8p+Nj+19TZJ2xgcJ6AWqdnwLcGF0boHAUE+iu/L+Cahv4d6g8c/f5I+
   p70UaFn0+bM9R14CPU8AaTuINuIiFY/lJrbWajtrTOi/cQgMfpK8b+4Do
   Pw1Ez8I+iC07QPVshPwMilbKb8TZmkeFm+owv5iX8zeVLt4fSZTl0ESSj
   MI4YDZnIdfExSOGE0VjqN0Jv11pWCOFgCE2D6+u5YISQ+US6HMBaIEa7P
   wXnY/FHNn6KqJHS/NROQN5QiMv8TN596mk4iDrl3MbXjR9O3daOsDCmck
   FwyGPGu1bHj83hWXmtK5J3I7aykdFE9MJn8FE7KrXHX+zALxZlyWT3s5U
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="312974982"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="312974982"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 02:38:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="971207486"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="971207486"
Received: from bswcg005.iind.intel.com ([10.224.174.166])
  by fmsmga005.fm.intel.com with ESMTP; 24 Nov 2022 02:38:09 -0800
From:   m.chetan.kumar@linux.intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, linuxwwan@intel.com, edumazet@google.com,
        pabeni@redhat.com, didi.debian@cknow.org,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        Bonaccorso Salvatore <carnil@debian.org>
Subject: [PATCH v2 net 2/4] net: wwan: iosm: fix dma_alloc_coherent incompatible pointer type
Date:   Thu, 24 Nov 2022 16:08:03 +0530
Message-Id: <20221124103803.1446000-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

Fix build error reported on armhf while preparing 6.1-rc5
for Debian.

iosm_ipc_protocol.c:244:36: error: passing argument 3 of
'dma_alloc_coherent' from incompatible pointer type.

Change phy_ap_shm type from phys_addr_t to dma_addr_t.

Fixes: faed4c6f6f48 ("net: iosm: shared memory protocol")
Reported-by: Bonaccorso Salvatore <carnil@debian.org>
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
--
v2: No Change.
---
 drivers/net/wwan/iosm/iosm_ipc_protocol.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_protocol.h b/drivers/net/wwan/iosm/iosm_ipc_protocol.h
index 9b3a6d86ece7..289397c4ea6c 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_protocol.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_protocol.h
@@ -122,7 +122,7 @@ struct iosm_protocol {
 	struct iosm_imem *imem;
 	struct ipc_rsp *rsp_ring[IPC_MEM_MSG_ENTRIES];
 	struct device *dev;
-	phys_addr_t phy_ap_shm;
+	dma_addr_t phy_ap_shm;
 	u32 old_msg_tail;
 };
 
-- 
2.34.1

