Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8983E1AE506
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 20:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729959AbgDQSnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 14:43:00 -0400
Received: from mga03.intel.com ([134.134.136.65]:31349 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729828AbgDQSm5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 14:42:57 -0400
IronPort-SDR: tgI5qpuQJTgfz/vOkLR+Wl8fwQMFBBCVdksGRljjdV4QLLTNnbXQjj7eMzVnAu0BlWJjQaI8PD
 q+3k0SbVNE+w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 11:42:53 -0700
IronPort-SDR: DOtW3ohQJPV08nwYWvxTiIZrCqq+mN3w91hNvDtWt7G8TEqy8Gp2V8/O0fTIB8SaY9ip7qu1JP
 1ChcSN+b68JA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="254294394"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga003.jf.intel.com with ESMTP; 17 Apr 2020 11:42:52 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 13/14] igc: Remove dead code related to flower filter
Date:   Fri, 17 Apr 2020 11:42:50 -0700
Message-Id: <20200417184251.1962762-14-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200417184251.1962762-1-jeffrey.t.kirsher@intel.com>
References: <20200417184251.1962762-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

IGC driver has no support for tc-flower filters so this patch removes
some leftover code, probably copied from IGB driver by mistake.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h      | 1 -
 drivers/net/ethernet/intel/igc/igc_main.c | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 4643f358b843..5f21dcfe99ce 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -185,7 +185,6 @@ struct igc_adapter {
 
 	/* RX network flow classification support */
 	struct hlist_head nfc_filter_list;
-	struct hlist_head cls_flower_list;
 	unsigned int nfc_filter_count;
 
 	/* lock for RX network flow classification filter */
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 85df9366e172..6acb85842d0a 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -3487,9 +3487,6 @@ static void igc_nfc_filter_exit(struct igc_adapter *adapter)
 	hlist_for_each_entry(rule, &adapter->nfc_filter_list, nfc_node)
 		igc_erase_filter(adapter, rule);
 
-	hlist_for_each_entry(rule, &adapter->cls_flower_list, nfc_node)
-		igc_erase_filter(adapter, rule);
-
 	spin_unlock(&adapter->nfc_lock);
 }
 
-- 
2.25.2

