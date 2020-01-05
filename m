Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2165913066D
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 08:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgAEHO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 02:14:27 -0500
Received: from mga07.intel.com ([134.134.136.100]:63627 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgAEHOZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jan 2020 02:14:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jan 2020 23:14:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,397,1571727600"; 
   d="scan'208";a="302607375"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga001.jf.intel.com with ESMTP; 04 Jan 2020 23:14:21 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 11/15] igc: Remove no need declaration of the igc_free_q_vectors
Date:   Sat,  4 Jan 2020 23:14:16 -0800
Message-Id: <20200105071420.3778982-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200105071420.3778982-1-jeffrey.t.kirsher@intel.com>
References: <20200105071420.3778982-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

We want to avoid forward-declarations of function if possible.
Rearrange the igc_free_q_vectors function implementation.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 27 +++++++++++------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 4cfb9856ee13..58347135b0fc 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -56,7 +56,6 @@ static int igc_sw_init(struct igc_adapter *);
 static void igc_write_itr(struct igc_q_vector *q_vector);
 static void igc_assign_vector(struct igc_q_vector *q_vector, int msix_vector);
 static void igc_free_q_vector(struct igc_adapter *adapter, int v_idx);
-static void igc_free_q_vectors(struct igc_adapter *adapter);
 
 enum latency_range {
 	lowest_latency = 0,
@@ -3118,19 +3117,6 @@ static void igc_set_interrupt_capability(struct igc_adapter *adapter,
 		adapter->flags |= IGC_FLAG_HAS_MSI;
 }
 
-/**
- * igc_clear_interrupt_scheme - reset the device to a state of no interrupts
- * @adapter: Pointer to adapter structure
- *
- * This function resets the device so that it has 0 rx queues, tx queues, and
- * MSI-X interrupts allocated.
- */
-static void igc_clear_interrupt_scheme(struct igc_adapter *adapter)
-{
-	igc_free_q_vectors(adapter);
-	igc_reset_interrupt_capability(adapter);
-}
-
 /**
  * igc_free_q_vectors - Free memory allocated for interrupt vectors
  * @adapter: board private structure to initialize
@@ -3153,6 +3139,19 @@ static void igc_free_q_vectors(struct igc_adapter *adapter)
 	}
 }
 
+/**
+ * igc_clear_interrupt_scheme - reset the device to a state of no interrupts
+ * @adapter: Pointer to adapter structure
+ *
+ * This function resets the device so that it has 0 rx queues, tx queues, and
+ * MSI-X interrupts allocated.
+ */
+static void igc_clear_interrupt_scheme(struct igc_adapter *adapter)
+{
+	igc_free_q_vectors(adapter);
+	igc_reset_interrupt_capability(adapter);
+}
+
 /**
  * igc_free_q_vector - Free memory allocated for specific interrupt vector
  * @adapter: board private structure to initialize
-- 
2.24.1

