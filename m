Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3FAF369747
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 18:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243127AbhDWQlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 12:41:35 -0400
Received: from mga17.intel.com ([192.55.52.151]:13567 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236900AbhDWQl3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 12:41:29 -0400
IronPort-SDR: POVVkDIre0roJhJRa8e0/97I1w52Gfs0mdNGpqe0Me6AFupGvXgB2rmXy5kuPXQrbzOMARlHMu
 xjo17CjcSqNQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9963"; a="176218638"
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="176218638"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2021 09:40:52 -0700
IronPort-SDR: z4Ac208dWs4Vv0qzwGg/9GNFIvSQod1de6F8CMp9UbYlqeHvI4ghYHZvLKHSd0GN8KG56nAx2H
 mmC3wlPyw7dQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="456285971"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 23 Apr 2021 09:40:52 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Stefan Assmann <sassmann@kpanic.de>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com
Subject: [PATCH net-next 5/8] iavf: remove duplicate free resources calls
Date:   Fri, 23 Apr 2021 09:42:44 -0700
Message-Id: <20210423164247.3252913-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210423164247.3252913-1-anthony.l.nguyen@intel.com>
References: <20210423164247.3252913-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Assmann <sassmann@kpanic.de>

Both iavf_free_all_tx_resources() and iavf_free_all_rx_resources() have
already been called in the very same function.
Remove the duplicate calls.

Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 7a81e7ceea65..e612c24fa384 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3940,8 +3940,6 @@ static void iavf_remove(struct pci_dev *pdev)
 
 	iounmap(hw->hw_addr);
 	pci_release_regions(pdev);
-	iavf_free_all_tx_resources(adapter);
-	iavf_free_all_rx_resources(adapter);
 	iavf_free_queues(adapter);
 	kfree(adapter->vf_res);
 	spin_lock_bh(&adapter->mac_vlan_list_lock);
-- 
2.26.2

