Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C13145CAF5
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 18:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243342AbhKXR2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 12:28:48 -0500
Received: from mga07.intel.com ([134.134.136.100]:35653 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243080AbhKXR2o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 12:28:44 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="298734823"
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="298734823"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 09:18:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="597738893"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 24 Nov 2021 09:18:10 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 06/12] iavf: Add trace while removing device
Date:   Wed, 24 Nov 2021 09:16:46 -0800
Message-Id: <20211124171652.831184-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211124171652.831184-1-anthony.l.nguyen@intel.com>
References: <20211124171652.831184-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

Add kernel trace that device was removed.
Currently there is no such information.
I.e. Host admin removes a PCI device from a VM,
than on VM shall be info about the event.

This patch adds info log to iavf_remove function.

Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index bb2e91cb9cd4..4019191e6b0c 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3987,6 +3987,7 @@ static void iavf_remove(struct pci_dev *pdev)
 	if (iavf_lock_timeout(&adapter->crit_lock, 5000))
 		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n", __FUNCTION__);
 
+	dev_info(&adapter->pdev->dev, "Removing device\n");
 	/* Shut down all the garbage mashers on the detention level */
 	iavf_change_state(adapter, __IAVF_REMOVE);
 	adapter->aq_required = 0;
-- 
2.31.1

