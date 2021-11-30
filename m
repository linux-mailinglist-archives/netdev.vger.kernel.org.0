Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D57463FDD
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 22:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344091AbhK3VZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 16:25:59 -0500
Received: from mga03.intel.com ([134.134.136.65]:13461 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344055AbhK3VYt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 16:24:49 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10184"; a="236264009"
X-IronPort-AV: E=Sophos;i="5.87,277,1631602800"; 
   d="scan'208";a="236264009"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 13:21:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,277,1631602800"; 
   d="scan'208";a="744895489"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 30 Nov 2021 13:21:18 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Karen Sornek <karen.sornek@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Subject: [PATCH net-next v2 09/10] iavf: Refactor string format to avoid static analysis warnings
Date:   Tue, 30 Nov 2021 13:20:03 -0800
Message-Id: <20211130212004.198898-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211130212004.198898-1-anthony.l.nguyen@intel.com>
References: <20211130212004.198898-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karen Sornek <karen.sornek@intel.com>

Change format to match variable type that is used in string.

Use %u format for unsigned variable and %d format for signed variable
to remove static analysis warnings.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@intel.com>
Signed-off-by: Karen Sornek <karen.sornek@intel.com>
Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c     | 6 +++---
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index a6f10d947d04..285c0e28ec98 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -463,14 +463,14 @@ iavf_request_traffic_irqs(struct iavf_adapter *adapter, char *basename)
 
 		if (q_vector->tx.ring && q_vector->rx.ring) {
 			snprintf(q_vector->name, sizeof(q_vector->name),
-				 "iavf-%s-TxRx-%d", basename, rx_int_idx++);
+				 "iavf-%s-TxRx-%u", basename, rx_int_idx++);
 			tx_int_idx++;
 		} else if (q_vector->rx.ring) {
 			snprintf(q_vector->name, sizeof(q_vector->name),
-				 "iavf-%s-rx-%d", basename, rx_int_idx++);
+				 "iavf-%s-rx-%u", basename, rx_int_idx++);
 		} else if (q_vector->tx.ring) {
 			snprintf(q_vector->name, sizeof(q_vector->name),
-				 "iavf-%s-tx-%d", basename, tx_int_idx++);
+				 "iavf-%s-tx-%u", basename, tx_int_idx++);
 		} else {
 			/* skip this unused q_vector */
 			continue;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index b902650aa594..cfa1f0e0e2fe 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -1025,7 +1025,7 @@ static void iavf_print_link_message(struct iavf_adapter *adapter)
 	} else if (link_speed_mbps == SPEED_UNKNOWN) {
 		snprintf(speed, IAVF_MAX_SPEED_STRLEN, "%s", "Unknown Mbps");
 	} else {
-		snprintf(speed, IAVF_MAX_SPEED_STRLEN, "%u %s",
+		snprintf(speed, IAVF_MAX_SPEED_STRLEN, "%d %s",
 			 link_speed_mbps, "Mbps");
 	}
 
-- 
2.31.1

