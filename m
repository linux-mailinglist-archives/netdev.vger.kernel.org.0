Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9E5B4B4282
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 08:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241255AbiBNHHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 02:07:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241251AbiBNHHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 02:07:50 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA405839A
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 23:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644822462; x=1676358462;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q7OR1YzRcT8E8CLxMwg0rSxb27SP6B3vno/We1jGHWo=;
  b=mTqNMFRzp3Xx5eReOqrHAUCUFUUZLowcLc0FaC8SpOGIN9o5xJZbbYVs
   5ciNZosIgYYdbFELTjTTf0LMKpaPoOS0vPQG32ToP7TruTaRYzbD2QAB0
   IUp2yxlFo+2Y75ek9xg37NCJq3Z7B0T32LSc9PzH9Txj8/JAzveQK0BeS
   sSBQQ2YWXQ9od6PpMiEdonBN1gCQQFmmyKZNvoG+rNZhAAOyVAB+VQ8cp
   b/a3bIvwyX2dlGRWXFWbD8vTsiyyU/C67+fLKrIXJnC5zr6Pwn/QngvRM
   Yjq5jrKGRjs7khSWaEeNHHuQn7pKBwoIMpgr4q+iGAOrQLD6IAq+OQZeG
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10257"; a="248862574"
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="248862574"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 23:07:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="680286243"
Received: from ccgwwan-desktop15.iind.intel.com (HELO BSWCG005.iind.intel.com) ([10.224.174.19])
  by fmsmga001.fm.intel.com with ESMTP; 13 Feb 2022 23:07:40 -0800
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        m.chetan.kumar@linux.intel.com, linuxwwan@intel.com
Subject: [PATCH net-next 2/2] net: wwan: iosm: drop debugfs dev reference
Date:   Mon, 14 Feb 2022 12:46:53 +0530
Message-Id: <20220214071653.813010-3-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220214071653.813010-1-m.chetan.kumar@linux.intel.com>
References: <20220214071653.813010-1-m.chetan.kumar@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Post debugfs use call wwan_put_debugfs_dir()to drop
debugfs dev reference.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_debugfs.c | 5 +++--
 drivers/net/wwan/iosm/iosm_ipc_imem.h    | 2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_debugfs.c b/drivers/net/wwan/iosm/iosm_ipc_debugfs.c
index f2f57751a7d2..e916139b8cd4 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_debugfs.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_debugfs.c
@@ -12,10 +12,10 @@
 
 void ipc_debugfs_init(struct iosm_imem *ipc_imem)
 {
-	struct dentry *debugfs_pdev = wwan_get_debugfs_dir(ipc_imem->dev);
+	ipc_imem->debugfs_wwan_dir = wwan_get_debugfs_dir(ipc_imem->dev);
 
 	ipc_imem->debugfs_dir = debugfs_create_dir(KBUILD_MODNAME,
-						   debugfs_pdev);
+						   ipc_imem->debugfs_wwan_dir);
 
 	ipc_imem->trace = ipc_trace_init(ipc_imem);
 	if (!ipc_imem->trace)
@@ -26,4 +26,5 @@ void ipc_debugfs_deinit(struct iosm_imem *ipc_imem)
 {
 	ipc_trace_deinit(ipc_imem->trace);
 	debugfs_remove_recursive(ipc_imem->debugfs_dir);
+	wwan_put_debugfs_dir(ipc_imem->debugfs_wwan_dir);
 }
diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.h b/drivers/net/wwan/iosm/iosm_ipc_imem.h
index 5682e8d6be7b..e700dc8bfe0a 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.h
@@ -341,6 +341,7 @@ enum ipc_phase {
  * @ev_mux_net_transmit_pending:0 means inform the IPC tasklet to pass
  * @reset_det_n:		Reset detect flag
  * @pcie_wake_n:		Pcie wake flag
+ * @debugfs_wwan_dir:		WWAN Debug FS directory entry
  * @debugfs_dir:		Debug FS directory for driver-specific entries
  */
 struct iosm_imem {
@@ -384,6 +385,7 @@ struct iosm_imem {
 	   reset_det_n:1,
 	   pcie_wake_n:1;
 #ifdef CONFIG_WWAN_DEBUGFS
+	struct dentry *debugfs_wwan_dir;
 	struct dentry *debugfs_dir;
 #endif
 };
-- 
2.25.1

