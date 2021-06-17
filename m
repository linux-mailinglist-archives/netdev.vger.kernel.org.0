Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A322F3ABA23
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 18:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbhFQRB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 13:01:29 -0400
Received: from mga18.intel.com ([134.134.136.126]:63633 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231511AbhFQRBS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 13:01:18 -0400
IronPort-SDR: ywCf0RoIKzbBtNJ2ehQP9od2LfhFEQBI6TpGiesBzZcb+cPGDztwW3xTHRsgwXSGnVDx4A6clv
 7OwyduTIdreQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10018"; a="193723054"
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="193723054"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 09:59:05 -0700
IronPort-SDR: W48WtnjiiModTIlp775NZgofoTe+sQtTONXaKJ1bS9Y+Myj5fSeTPOaE+J5ZnVsxIzPoq8bmKq
 WCILpSV2EnOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="404706804"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 17 Jun 2021 09:59:04 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 4/8] ice: remove local variable
Date:   Thu, 17 Jun 2021 10:01:41 -0700
Message-Id: <20210617170145.4092904-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210617170145.4092904-1-anthony.l.nguyen@intel.com>
References: <20210617170145.4092904-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>

Remove the local variable since it's only used once. Instead, use it
directly.

Signed-off-by: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index dbf4a5493ea7..5ca6c0356499 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3078,7 +3078,6 @@ static void ice_set_netdev_features(struct net_device *netdev)
  */
 static int ice_cfg_netdev(struct ice_vsi *vsi)
 {
-	struct ice_pf *pf = vsi->back;
 	struct ice_netdev_priv *np;
 	struct net_device *netdev;
 	u8 mac_addr[ETH_ALEN];
@@ -3098,7 +3097,7 @@ static int ice_cfg_netdev(struct ice_vsi *vsi)
 	ice_set_ops(netdev);
 
 	if (vsi->type == ICE_VSI_PF) {
-		SET_NETDEV_DEV(netdev, ice_pf_to_dev(pf));
+		SET_NETDEV_DEV(netdev, ice_pf_to_dev(vsi->back));
 		ether_addr_copy(mac_addr, vsi->port_info->mac.perm_addr);
 		ether_addr_copy(netdev->dev_addr, mac_addr);
 		ether_addr_copy(netdev->perm_addr, mac_addr);
-- 
2.26.2

