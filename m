Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE8A35EAAE
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 04:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345524AbhDNCQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 22:16:01 -0400
Received: from mga17.intel.com ([192.55.52.151]:22806 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230293AbhDNCP6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 22:15:58 -0400
IronPort-SDR: iBGhHrOMM173seUFcWik9CfZDbfvwwxaBJqe8ocDV1IXIgAhb46EquZ/vCGWvup2OWTEIOQZgb
 TtVxa3bPmqhQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9953"; a="174651024"
X-IronPort-AV: E=Sophos;i="5.82,221,1613462400"; 
   d="scan'208";a="174651024"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2021 19:15:36 -0700
IronPort-SDR: P1DQ0fl+MpjZxlCc7V/FKOWAJepwvX+3/F1Jp1hyJGWObOh1iGBWzWJYWqjA8NWErCShOklfGn
 FvlsVAKwI7vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,221,1613462400"; 
   d="scan'208";a="615134065"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 13 Apr 2021 19:15:35 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jostar Yang <jostar_yang@accton.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Guohan Lu <lguohan@gmail.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next v2 1/3] ixgbe: Support external GBE SerDes PHY BCM54616s
Date:   Tue, 13 Apr 2021 19:17:21 -0700
Message-Id: <20210414021723.3815255-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210414021723.3815255-1-anthony.l.nguyen@intel.com>
References: <20210414021723.3815255-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jostar Yang <jostar_yang@accton.com>

The Broadcom PHY is used in switches, so add the ID, and hook it up.

This upstreams the Linux kernel patch from the network operating system
SONiC from February 2020 [1].

[1]: https://github.com/Azure/sonic-linux-kernel/pull/122

Signed-off-by: Jostar Yang <jostar_yang@accton.com>
Signed-off-by: Guohan Lu <lguohan@gmail.com>
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c  | 3 +++
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
index 73bc170d1ae9..24aa97f993ca 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
@@ -380,6 +380,9 @@ static enum ixgbe_phy_type ixgbe_get_phy_type_from_id(u32 phy_id)
 	case X557_PHY_ID2:
 		phy_type = ixgbe_phy_x550em_ext_t;
 		break;
+	case BCM54616S_E_PHY_ID:
+		phy_type = ixgbe_phy_ext_1g_t;
+		break;
 	default:
 		phy_type = ixgbe_phy_unknown;
 		break;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
index 2be1c4c72435..4c317b0dbfd4 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
@@ -1407,6 +1407,7 @@ struct ixgbe_nvm_version {
 #define QT2022_PHY_ID    0x0043A400
 #define ATH_PHY_ID       0x03429050
 #define AQ_FW_REV        0x20
+#define BCM54616S_E_PHY_ID 0x03625D10
 
 /* Special PHY Init Routine */
 #define IXGBE_PHY_INIT_OFFSET_NL 0x002B
-- 
2.26.2

