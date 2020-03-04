Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF4C7179C46
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 00:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388600AbgCDXVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 18:21:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:48335 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388575AbgCDXVm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 18:21:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 15:21:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,515,1574150400"; 
   d="scan'208";a="244094648"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga006.jf.intel.com with ESMTP; 04 Mar 2020 15:21:38 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 13/16] ice: Fix format specifier
Date:   Wed,  4 Mar 2020 15:21:33 -0800
Message-Id: <20200304232136.4172118-14-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304232136.4172118-1-jeffrey.t.kirsher@intel.com>
References: <20200304232136.4172118-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>

Commit ed5a3f664c55 ("ice: Removing hung_queue variable to use txqueue
function parameter") began utilizing the txqueue variable over the
hung_queue variable. hung_queue was an int where txqueue is an unsigned
int. Update the format specifiers to reflect the new type.

Fixes: ed5a3f664c55 ("ice: Removing hung_queue variable to use txqueue function parameter")
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 30045a194215..a2d8f87e8924 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5119,13 +5119,13 @@ static void ice_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 		/* Read interrupt register */
 		val = rd32(hw, GLINT_DYN_CTL(tx_ring->q_vector->reg_idx));
 
-		netdev_info(netdev, "tx_timeout: VSI_num: %d, Q %d, NTC: 0x%x, HW_HEAD: 0x%x, NTU: 0x%x, INT: 0x%x\n",
+		netdev_info(netdev, "tx_timeout: VSI_num: %d, Q %u, NTC: 0x%x, HW_HEAD: 0x%x, NTU: 0x%x, INT: 0x%x\n",
 			    vsi->vsi_num, txqueue, tx_ring->next_to_clean,
 			    head, tx_ring->next_to_use, val);
 	}
 
 	pf->tx_timeout_last_recovery = jiffies;
-	netdev_info(netdev, "tx_timeout recovery level %d, txqueue %d\n",
+	netdev_info(netdev, "tx_timeout recovery level %d, txqueue %u\n",
 		    pf->tx_timeout_recovery_level, txqueue);
 
 	switch (pf->tx_timeout_recovery_level) {
-- 
2.24.1

