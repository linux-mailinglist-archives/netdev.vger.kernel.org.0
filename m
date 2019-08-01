Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAFAC7E599
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 00:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732331AbfHAW0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 18:26:04 -0400
Received: from mga07.intel.com ([134.134.136.100]:14639 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731850AbfHAWZ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 18:25:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Aug 2019 15:25:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,335,1559545200"; 
   d="scan'208";a="324384895"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 01 Aug 2019 15:25:50 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 11/11] fm10k: reduce scope of the ring variable
Date:   Thu,  1 Aug 2019 15:25:48 -0700
Message-Id: <20190801222548.15975-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190801222548.15975-1-jeffrey.t.kirsher@intel.com>
References: <20190801222548.15975-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Reduce the scope of the ring local variable in the fm10k_assign_l2_accel
function.

This was detected by cppcheck and resolves the following warning
produced by that tool:

[fm10k_netdev.c:1447]: (style) The scope of the variable 'ring' can be
reduced.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/fm10k/fm10k_netdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
index c73fb38be678..259da075093f 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -1444,11 +1444,11 @@ static int __fm10k_setup_tc(struct net_device *dev, enum tc_setup_type type,
 static void fm10k_assign_l2_accel(struct fm10k_intfc *interface,
 				  struct fm10k_l2_accel *l2_accel)
 {
-	struct fm10k_ring *ring;
 	int i;
 
 	for (i = 0; i < interface->num_rx_queues; i++) {
-		ring = interface->rx_ring[i];
+		struct fm10k_ring *ring = interface->rx_ring[i];
+
 		rcu_assign_pointer(ring->l2_accel, l2_accel);
 	}
 
-- 
2.21.0

