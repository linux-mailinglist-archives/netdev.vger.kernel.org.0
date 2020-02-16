Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6F6160197
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 04:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgBPDpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 22:45:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:33370 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727833AbgBPDo7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Feb 2020 22:44:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Feb 2020 19:44:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,447,1574150400"; 
   d="scan'208";a="257916612"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga004.fm.intel.com with ESMTP; 15 Feb 2020 19:44:58 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 12/15] ice: replace "fallthrough" comments with fallthrough reserved word
Date:   Sat, 15 Feb 2020 19:44:49 -0800
Message-Id: <20200216034452.1251706-13-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200216034452.1251706-1-jeffrey.t.kirsher@intel.com>
References: <20200216034452.1251706-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

"fallthrough" comments are used in switch case statements to explicitly
indicate the code is intended to fall through to the following statement.
Different variants of "fallthough" are acceptable, e.g. "fall through",
"fallthrough", "Fall-through".  The GCC compiler has an optional warning
(-Wimplicit-fallthrough[=n]) to warn when such a comment is not present;
the default version of which is enabled when compiling the Linux kernel.

There have been recent discussions in kernel mailing lists regarding
replacing non-standardized "fallthrough" comments with the pseudo-reserved
word 'fallthrough' which will be defined as __attribute__ ((fallthrough))
for versions of gcc that support it (i.e. gcc 7 and newer) or as a nop
for versions that do not.  Replace "fallthrough" comments with fallthrough
reserved word.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 4 ++--
 drivers/net/ethernet/intel/ice/ice_main.c   | 2 +-
 drivers/net/ethernet/intel/ice/ice_switch.c | 4 ++--
 drivers/net/ethernet/intel/ice/ice_txrx.c   | 4 ++--
 drivers/net/ethernet/intel/ice/ice_xsk.c    | 4 ++--
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 04d5db0a25bf..5587e9eb4cd0 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1181,7 +1181,7 @@ ice_aq_send_cmd(struct ice_hw *hw, struct ice_aq_desc *desc, void *buf,
 	case ice_aqc_opc_release_res:
 		if (le16_to_cpu(cmd->res_id) == ICE_AQC_RES_ID_GLBL_LOCK)
 			break;
-		/* fall-through */
+		fallthrough;
 	default:
 		mutex_lock(&ice_global_cfg_lock_sw);
 		lock_acquired = true;
@@ -2703,7 +2703,7 @@ __ice_aq_get_set_rss_lut(struct ice_hw *hw, u16 vsi_id, u8 lut_type, u8 *lut,
 				 ICE_AQC_GSET_RSS_LUT_TABLE_SIZE_M;
 			break;
 		}
-		/* fall-through */
+		fallthrough;
 	default:
 		status = ICE_ERR_PARAM;
 		goto ice_aq_get_set_rss_lut_exit;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index ce5397d18219..160328cd0d7e 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2985,7 +2985,7 @@ ice_log_pkg_init(struct ice_hw *hw, enum ice_status *status)
 		default:
 			break;
 		}
-		/* fall-through */
+		fallthrough;
 	default:
 		dev_err(dev, "An unknown error (%d) occurred when loading the DDP package.  Entering Safe Mode.\n",
 			*status);
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 431266081a80..4d96abfd05d6 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -760,7 +760,7 @@ ice_fill_sw_rule(struct ice_hw *hw, struct ice_fltr_info *f_info,
 		break;
 	case ICE_SW_LKUP_ETHERTYPE_MAC:
 		daddr = f_info->l_data.ethertype_mac.mac_addr;
-		/* fall-through */
+		fallthrough;
 	case ICE_SW_LKUP_ETHERTYPE:
 		off = (__force __be16 *)(eth_hdr + ICE_ETH_ETHTYPE_OFFSET);
 		*off = cpu_to_be16(f_info->l_data.ethertype_mac.ethertype);
@@ -771,7 +771,7 @@ ice_fill_sw_rule(struct ice_hw *hw, struct ice_fltr_info *f_info,
 		break;
 	case ICE_SW_LKUP_PROMISC_VLAN:
 		vlan_id = f_info->l_data.mac_vlan.vlan_id;
-		/* fall-through */
+		fallthrough;
 	case ICE_SW_LKUP_PROMISC:
 		daddr = f_info->l_data.mac_vlan.mac_addr;
 		break;
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 0c08ab0462df..f67e8362958c 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -453,10 +453,10 @@ ice_run_xdp(struct ice_ring *rx_ring, struct xdp_buff *xdp,
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
-		/* fallthrough -- not supported action */
+		fallthrough;
 	case XDP_ABORTED:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
-		/* fallthrough -- handle aborts by dropping frame */
+		fallthrough;
 	case XDP_DROP:
 		result = ICE_XDP_CONSUMED;
 		break;
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index fd96301e59bb..4adb8a3ba06e 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -816,10 +816,10 @@ ice_run_xdp_zc(struct ice_ring *rx_ring, struct xdp_buff *xdp)
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
-		/* fallthrough -- not supported action */
+		fallthrough;
 	case XDP_ABORTED:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
-		/* fallthrough -- handle aborts by dropping frame */
+		fallthrough;
 	case XDP_DROP:
 		result = ICE_XDP_CONSUMED;
 		break;
-- 
2.24.1

