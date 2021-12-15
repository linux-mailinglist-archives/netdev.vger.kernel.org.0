Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18AA4761D3
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 20:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbhLOTfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 14:35:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:59490 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232050AbhLOTft (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 14:35:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639596949; x=1671132949;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rcp55iefqDb7uA0qJNHDt+UrNIpnbJBkHlkSz9FPd6o=;
  b=lTPOGJRt79RCQHdc5VLjLXOem1AhUIliBfPkYXUn4VDL9c0ZQ+k0jQtC
   BfDVVzxx0kCO2L8/XScnIbKp1SsikCfjdNuJTT92wL+ObjNrlbvACxVB6
   tdYZrSnXDIQ4ba0ym4SNq7bEzWgmS+PVs4nmCTwb8EvkZqPN0DphYf1s6
   Tpwe3bVFuW4PKD+hQaFwnjlM1R0oST+OF48JaLHlekWa4TpGkKfts4P8s
   r9He2/jsaJ7l9odgQPlMnaVRAkGV6Ew9/eA81PFl3sR3JKRXYuoEiKCmv
   v2VoM4YxK9b6b5tsXUzi2bb3Vw4Hj+EvktovL5F/CKSJEXZ6mcXh+tfxZ
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="236856412"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="236856412"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 11:35:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="465746702"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 15 Dec 2021 11:35:30 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Robert Schlabbach <robert_s@gmx.net>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH net 4/5] ixgbe: Document how to enable NBASE-T support
Date:   Wed, 15 Dec 2021 11:34:33 -0800
Message-Id: <20211215193434.3253664-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211215193434.3253664-1-anthony.l.nguyen@intel.com>
References: <20211215193434.3253664-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert Schlabbach <robert_s@gmx.net>

Commit a296d665eae1 ("ixgbe: Add ethtool support to enable 2.5 and 5.0
Gbps support") introduced suppression of the advertisement of NBASE-T
speeds by default, according to Todd Fujinaka to accommodate customers
with network switches which could not cope with advertised NBASE-T
speeds, as posted in the E1000-devel mailing list:

https://sourceforge.net/p/e1000/mailman/message/37106269/

However, the suppression was not documented at all, nor was how to
enable NBASE-T support.

Properly document the NBASE-T suppression and how to enable NBASE-T
support.

Fixes: a296d665eae1 ("ixgbe: Add ethtool support to enable 2.5 and 5.0 Gbps support")
Reported-by: Robert Schlabbach <robert_s@gmx.net>
Signed-off-by: Robert Schlabbach <robert_s@gmx.net>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../device_drivers/ethernet/intel/ixgbe.rst      | 16 ++++++++++++++++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c    |  4 ++++
 2 files changed, 20 insertions(+)

diff --git a/Documentation/networking/device_drivers/ethernet/intel/ixgbe.rst b/Documentation/networking/device_drivers/ethernet/intel/ixgbe.rst
index f1d5233e5e51..0a233b17c664 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/ixgbe.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/ixgbe.rst
@@ -440,6 +440,22 @@ NOTE: For 82599-based network connections, if you are enabling jumbo frames in
 a virtual function (VF), jumbo frames must first be enabled in the physical
 function (PF). The VF MTU setting cannot be larger than the PF MTU.
 
+NBASE-T Support
+---------------
+The ixgbe driver supports NBASE-T on some devices. However, the advertisement
+of NBASE-T speeds is suppressed by default, to accommodate broken network
+switches which cannot cope with advertised NBASE-T speeds. Use the ethtool
+command to enable advertising NBASE-T speeds on devices which support it::
+
+  ethtool -s eth? advertise 0x1800000001028
+
+On Linux systems with INTERFACES(5), this can be specified as a pre-up command
+in /etc/network/interfaces so that the interface is always brought up with
+NBASE-T support, e.g.::
+
+  iface eth? inet dhcp
+       pre-up ethtool -s eth? advertise 0x1800000001028 || true
+
 Generic Receive Offload, aka GRO
 --------------------------------
 The driver supports the in-kernel software implementation of GRO. GRO has
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 0f9f022260d7..45e2ec4d264d 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -5531,6 +5531,10 @@ static int ixgbe_non_sfp_link_config(struct ixgbe_hw *hw)
 	if (!speed && hw->mac.ops.get_link_capabilities) {
 		ret = hw->mac.ops.get_link_capabilities(hw, &speed,
 							&autoneg);
+		/* remove NBASE-T speeds from default autonegotiation
+		 * to accommodate broken network switches in the field
+		 * which cannot cope with advertised NBASE-T speeds
+		 */
 		speed &= ~(IXGBE_LINK_SPEED_5GB_FULL |
 			   IXGBE_LINK_SPEED_2_5GB_FULL);
 	}
-- 
2.31.1

