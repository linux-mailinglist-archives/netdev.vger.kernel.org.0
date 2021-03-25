Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC8A349C42
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 23:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbhCYWaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 18:30:19 -0400
Received: from mga03.intel.com ([134.134.136.65]:49800 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231148AbhCYW3x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 18:29:53 -0400
IronPort-SDR: pgmf6MXTjQew/3+HBBdBkSHjUgvkqYDSErVe4hT0Uj2XmW/I/862ruCnVMlNMtXPqzps82JL3K
 gFTFy8jUTf+w==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="191063402"
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="191063402"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 15:29:51 -0700
IronPort-SDR: lIEYK2Dc7VCgk1mQDb6f4FwYo8GVbJrX+fv+jwj0qWbrJWS/MOJeDMBcXqVM5UkzFM0riu5KNC
 FwWmGuGhMoJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="375246723"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 25 Mar 2021 15:29:51 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Dawid Lukwinski <dawid.lukwinski@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 2/4] i40e: Added Asym_Pause to supported link modes
Date:   Thu, 25 Mar 2021 15:31:17 -0700
Message-Id: <20210325223119.3991796-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210325223119.3991796-1-anthony.l.nguyen@intel.com>
References: <20210325223119.3991796-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

Add Asym_Pause to supported link modes (it is supported by HW).
Lack of Asym_Pause in supported modes can cause several problems,
i.e. it won't be possible to turn the autonegotiation on
with asymmetric pause settings (i.e. Tx on, Rx off).

Fixes: 4e91bcd5d47a ("i40e: Finish implementation of ethtool get settings")
Signed-off-by: Dawid Lukwinski <dawid.lukwinski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index c70dec65a572..2c637a5678b3 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -1101,6 +1101,7 @@ static int i40e_get_link_ksettings(struct net_device *netdev,
 
 	/* Set flow control settings */
 	ethtool_link_ksettings_add_link_mode(ks, supported, Pause);
+	ethtool_link_ksettings_add_link_mode(ks, supported, Asym_Pause);
 
 	switch (hw->fc.requested_mode) {
 	case I40E_FC_FULL:
-- 
2.26.2

