Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2B035A686
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 21:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234876AbhDITCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 15:02:01 -0400
Received: from mga04.intel.com ([192.55.52.120]:13022 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234695AbhDITBz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 15:01:55 -0400
IronPort-SDR: RpzbNUrMMTDf8om4PLlmJ/ZudToplOT8516R8EGCiZjnmJi+chVkqdajh+XRuli7qtCIvnifJt
 x0MUTF8KvT+A==
X-IronPort-AV: E=McAfee;i="6000,8403,9949"; a="191674935"
X-IronPort-AV: E=Sophos;i="5.82,210,1613462400"; 
   d="scan'208";a="191674935"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2021 12:01:32 -0700
IronPort-SDR: QF6fsNGEsSn5eTv33FH62dl6/GSqzBCGCE+kakre7zjAQ5YBLLaJhe4qFPqdEbqzz7gWIxtJ/G
 q1rLeXu8VfCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,210,1613462400"; 
   d="scan'208";a="449181588"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Apr 2021 12:01:32 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jostar Yang <jostar_yang@accton.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Guohan Lu <lguohan@gmail.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 1/4] ixgbe: Support external GBE SerDes PHY BCM54616s
Date:   Fri,  9 Apr 2021 12:03:11 -0700
Message-Id: <20210409190314.946192-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210409190314.946192-1-anthony.l.nguyen@intel.com>
References: <20210409190314.946192-1-anthony.l.nguyen@intel.com>
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

