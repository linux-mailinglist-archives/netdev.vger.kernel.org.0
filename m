Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8D2DD0ED
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 23:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406515AbfJRVNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 17:13:43 -0400
Received: from mga07.intel.com ([134.134.136.100]:17946 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729529AbfJRVNn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 17:13:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Oct 2019 14:13:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,313,1566889200"; 
   d="scan'208";a="208752597"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga002.jf.intel.com with ESMTP; 18 Oct 2019 14:13:42 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 5/5] igc: Clean up unused shadow_vfta pointer
Date:   Fri, 18 Oct 2019 14:13:40 -0700
Message-Id: <20191018211340.31885-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191018211340.31885-1-jeffrey.t.kirsher@intel.com>
References: <20191018211340.31885-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

VLAN filter table array not implemented yet and shadow_vfta pointer
not used. Clean up the code and remove the unused shadow_vfta pointer.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h      | 1 -
 drivers/net/ethernet/intel/igc/igc_main.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 7e16345d836e..0868677d43ed 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -411,7 +411,6 @@ struct igc_adapter {
 	u32 tx_hwtstamp_timeouts;
 	u32 tx_hwtstamp_skipped;
 	u32 rx_hwtstamp_cleared;
-	u32 *shadow_vfta;
 
 	u32 rss_queues;
 	u32 rss_indir_tbl_init;
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index c1aa2762dc87..c9a6707a2d8d 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4573,7 +4573,6 @@ static void igc_remove(struct pci_dev *pdev)
 	pci_release_mem_regions(pdev);
 
 	kfree(adapter->mac_table);
-	kfree(adapter->shadow_vfta);
 	free_netdev(netdev);
 
 	pci_disable_pcie_error_reporting(pdev);
-- 
2.21.0

