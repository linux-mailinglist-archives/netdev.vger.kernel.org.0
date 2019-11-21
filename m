Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC37F104CDA
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 08:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfKUHqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 02:46:35 -0500
Received: from mga12.intel.com ([192.55.52.136]:4522 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726869AbfKUHqU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 02:46:20 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Nov 2019 23:46:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,224,1571727600"; 
   d="scan'208";a="216077577"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga001.fm.intel.com with ESMTP; 20 Nov 2019 23:46:16 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 14/15] ice: remove pointless NULL check of port_info
Date:   Wed, 20 Nov 2019 23:46:11 -0800
Message-Id: <20191121074612.3055661-15-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191121074612.3055661-1-jeffrey.t.kirsher@intel.com>
References: <20191121074612.3055661-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The code in ice_sched_cleanup_all checks whether the port info is NULL
prior to calling ice_sched_clear_port. However, ice_sched_clear_port
already checks whether port info is non-NULL.

More importantly, it also checks whether the port structure has been
initialized by checking its port_state field as well.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sched.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 84f609996ed5..eae707ddf8e8 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -798,8 +798,7 @@ void ice_sched_cleanup_all(struct ice_hw *hw)
 		hw->layer_info = NULL;
 	}
 
-	if (hw->port_info)
-		ice_sched_clear_port(hw->port_info);
+	ice_sched_clear_port(hw->port_info);
 
 	hw->num_tx_sched_layers = 0;
 	hw->num_tx_sched_phys_layers = 0;
-- 
2.23.0

