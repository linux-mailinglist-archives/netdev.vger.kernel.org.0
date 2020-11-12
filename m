Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF2A2B0F15
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 21:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgKLUeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 15:34:18 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:50373 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727025AbgKLUeS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 15:34:18 -0500
Received: from localhost.localdomain (ip5f5af1d9.dynamic.kabel-deutschland.de [95.90.241.217])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 347A62064712A;
        Thu, 12 Nov 2020 21:34:15 +0100 (CET)
From:   Paul Menzel <pmenzel@molgen.mpg.de>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     Jostar Yang <jostar_yang@accton.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guohan Lu <lguohan@gmail.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Subject: [PATCH] ixgbe: Support external GBE SerDes PHY BCM54616s
Date:   Thu, 12 Nov 2020 21:33:56 +0100
Message-Id: <20201112203356.344748-1-pmenzel@molgen.mpg.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jostar Yang <jostar_yang@accton.com>

The Broadcom PHY is used in switches, so add the ID, and hook it up.

This upstreams the Linux kernel patch from the network operating system
SONiC from Februar 2020 [1].

[1]: https://github.com/Azure/sonic-linux-kernel/pull/122

Signed-off-by: Jostar Yang <jostar_yang@accton.com>
Signed-off-by: Guohan Lu <lguohan@gmail.com>
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c  | 3 +++
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
index fc389eecdd2b..cb685e917b0c 100644
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
2.29.2

