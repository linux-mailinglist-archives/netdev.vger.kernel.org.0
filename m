Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC9611607
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 11:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfEBJGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 05:06:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:47594 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbfEBJG0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 05:06:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 02:06:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,421,1549958400"; 
   d="scan'208";a="147615371"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 02 May 2019 02:06:25 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 13/15] ice: Add missing PHY type to link settings
Date:   Thu,  2 May 2019 02:06:18 -0700
Message-Id: <20190502090620.21281-14-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190502090620.21281-1-jeffrey.t.kirsher@intel.com>
References: <20190502090620.21281-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>

The PHY type ICE_PHY_TYPE_LOW_25G_AUI_C2C is missing from
ice_get_settings_link_up() which is causing a warning
message for unrecognized PHY.  Add the PHY type to
correctly set the settings and avoid the warning message.

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index f995ed599cd9..0bfe696d8077 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1034,6 +1034,7 @@ ice_get_settings_link_up(struct ethtool_link_ksettings *ks,
 						     25000baseCR_Full);
 		break;
 	case ICE_PHY_TYPE_LOW_25G_AUI_AOC_ACC:
+	case ICE_PHY_TYPE_LOW_25G_AUI_C2C:
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     25000baseCR_Full);
 		break;
-- 
2.20.1

