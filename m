Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E104DEAB6
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 21:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbfD2TOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 15:14:11 -0400
Received: from mga17.intel.com ([192.55.52.151]:61541 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729200AbfD2TOJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 15:14:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Apr 2019 12:14:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,410,1549958400"; 
   d="scan'208";a="341867041"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga005.fm.intel.com with ESMTP; 29 Apr 2019 12:14:08 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Adam Ludkiewicz <adam.ludkiewicz@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 06/12] i40e: Report advertised link modes on 40GBase_LR4, CR4 and fibre
Date:   Mon, 29 Apr 2019 12:16:22 -0700
Message-Id: <20190429191628.31212-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190429191628.31212-1-jeffrey.t.kirsher@intel.com>
References: <20190429191628.31212-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Adam Ludkiewicz <adam.ludkiewicz@intel.com>

Add assignments for advertising 40GBase_LR4, 40GBase_CR4 and fibre

Signed-off-by: Adam Ludkiewicz <adam.ludkiewicz@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 9eaea1bee4a1..0d923c13c9a1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -541,9 +541,12 @@ static void i40e_phy_type_to_ethtool(struct i40e_pf *pf,
 		ethtool_link_ksettings_add_link_mode(ks, advertising,
 						     40000baseSR4_Full);
 	}
-	if (phy_types & I40E_CAP_PHY_TYPE_40GBASE_LR4)
+	if (phy_types & I40E_CAP_PHY_TYPE_40GBASE_LR4) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     40000baseLR4_Full);
+		ethtool_link_ksettings_add_link_mode(ks, advertising,
+						     40000baseLR4_Full);
+	}
 	if (phy_types & I40E_CAP_PHY_TYPE_40GBASE_KR4) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     40000baseLR4_Full);
@@ -723,6 +726,8 @@ static void i40e_get_settings_link_up(struct i40e_hw *hw,
 	case I40E_PHY_TYPE_40GBASE_AOC:
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     40000baseCR4_Full);
+		ethtool_link_ksettings_add_link_mode(ks, advertising,
+						     40000baseCR4_Full);
 		break;
 	case I40E_PHY_TYPE_40GBASE_SR4:
 		ethtool_link_ksettings_add_link_mode(ks, supported,
@@ -733,6 +738,8 @@ static void i40e_get_settings_link_up(struct i40e_hw *hw,
 	case I40E_PHY_TYPE_40GBASE_LR4:
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     40000baseLR4_Full);
+		ethtool_link_ksettings_add_link_mode(ks, advertising,
+						     40000baseLR4_Full);
 		break;
 	case I40E_PHY_TYPE_25GBASE_SR:
 	case I40E_PHY_TYPE_25GBASE_LR:
@@ -1038,6 +1045,7 @@ static int i40e_get_link_ksettings(struct net_device *netdev,
 		break;
 	case I40E_MEDIA_TYPE_FIBER:
 		ethtool_link_ksettings_add_link_mode(ks, supported, FIBRE);
+		ethtool_link_ksettings_add_link_mode(ks, advertising, FIBRE);
 		ks->base.port = PORT_FIBRE;
 		break;
 	case I40E_MEDIA_TYPE_UNKNOWN:
-- 
2.20.1

