Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF8A6436C7
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 22:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbiLEVYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 16:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233438AbiLEVYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 16:24:33 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6F82CC83
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 13:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670275471; x=1701811471;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yxTo3LWRkkew5OjHYsb4XFlCDWVvaYHA3ER0YL6Ejqs=;
  b=WKacBpjTp11uR/xwVRwZWDnnCrR74Mds1oxRFq7t1X4fRsEse7IDCjJz
   NtwFTpofL3IbI0q5zkIjwTGH0dg8IrH42ICGLyaDMJEqFo9amCj4IaC2P
   NJFEas7OVAxaVvJ6QTK+9wNLJ1zZsNKTseZZ7ggsj4GnXzm18DT/rD1Aa
   M934DFlNUSTMF710KI61p75CI/eNHo05E+/LfO+mc2a2C96Aigfn/zJfe
   tdjxwnFisrCLxCk26Ir6HSt8zQhwx1WHriQgrFrYWY9SPTh83UlTQ7co6
   MNeSowHn0Q26CxGnAR3EOaANOG6qW4VlMIQ3McINdsiXNfPnOBHZ6Vgvu
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="296157793"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="296157793"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 13:24:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="734744940"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="734744940"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Dec 2022 13:24:27 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tan Tee Min <tee.min.tan@linux.intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sasha.neftin@intel.com,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net-next 1/8] igc: allow BaseTime 0 enrollment for Qbv
Date:   Mon,  5 Dec 2022 13:24:07 -0800
Message-Id: <20221205212414.3197525-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221205212414.3197525-1-anthony.l.nguyen@intel.com>
References: <20221205212414.3197525-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tan Tee Min <tee.min.tan@linux.intel.com>

Introduce qbv_enable flag in igc_adapter struct to store the Qbv on/off.
So this allow the BaseTime to enroll with zero value.

Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h      | 1 +
 drivers/net/ethernet/intel/igc/igc_main.c | 2 ++
 drivers/net/ethernet/intel/igc/igc_tsn.c  | 2 +-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 1e7e7071f64d..c816623dc521 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -182,6 +182,7 @@ struct igc_adapter {
 
 	ktime_t base_time;
 	ktime_t cycle_time;
+	bool qbv_enable;
 
 	/* OS defined structs */
 	struct pci_dev *pdev;
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 1586e1e435c6..140d96dc475c 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5926,6 +5926,8 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 	u32 start_time = 0, end_time = 0;
 	size_t n;
 
+	adapter->qbv_enable = qopt->enable;
+
 	if (!qopt->enable)
 		return igc_tsn_clear_schedule(adapter);
 
diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index f975ed807da1..b63736176709 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -36,7 +36,7 @@ static unsigned int igc_tsn_new_flags(struct igc_adapter *adapter)
 {
 	unsigned int new_flags = adapter->flags & ~IGC_FLAG_TSN_ANY_ENABLED;
 
-	if (adapter->base_time)
+	if (adapter->qbv_enable)
 		new_flags |= IGC_FLAG_TSN_QBV_ENABLED;
 
 	if (is_any_launchtime(adapter))
-- 
2.35.1

