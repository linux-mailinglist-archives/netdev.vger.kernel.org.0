Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9309AAD1A
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 22:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404009AbfIEUeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 16:34:31 -0400
Received: from mga06.intel.com ([134.134.136.31]:45336 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391665AbfIEUeP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 16:34:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 13:34:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,471,1559545200"; 
   d="scan'208";a="267136563"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga001.jf.intel.com with ESMTP; 05 Sep 2019 13:34:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Ashish Shah <ashish.n.shah@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 12/16] ice: update Tx context struct
Date:   Thu,  5 Sep 2019 13:34:02 -0700
Message-Id: <20190905203406.4152-13-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190905203406.4152-1-jeffrey.t.kirsher@intel.com>
References: <20190905203406.4152-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ashish Shah <ashish.n.shah@intel.com>

Add internal usage flag, bit 91 as described in spec.
Update width of internal queue state to 122 also as described in spec.

Signed-off-by: Ashish Shah <ashish.n.shah@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c    | 3 ++-
 drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 9492cd34b09d..e8397e5b6267 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1132,6 +1132,7 @@ const struct ice_ctx_ele ice_tlan_ctx_info[] = {
 	ICE_CTX_STORE(ice_tlan_ctx, vmvf_type,			2,	78),
 	ICE_CTX_STORE(ice_tlan_ctx, src_vsi,			10,	80),
 	ICE_CTX_STORE(ice_tlan_ctx, tsyn_ena,			1,	90),
+	ICE_CTX_STORE(ice_tlan_ctx, internal_usage_flag,	1,	91),
 	ICE_CTX_STORE(ice_tlan_ctx, alt_vlan,			1,	92),
 	ICE_CTX_STORE(ice_tlan_ctx, cpuid,			8,	93),
 	ICE_CTX_STORE(ice_tlan_ctx, wb_mode,			1,	101),
@@ -1150,7 +1151,7 @@ const struct ice_ctx_ele ice_tlan_ctx_info[] = {
 	ICE_CTX_STORE(ice_tlan_ctx, drop_ena,			1,	165),
 	ICE_CTX_STORE(ice_tlan_ctx, cache_prof_idx,		2,	166),
 	ICE_CTX_STORE(ice_tlan_ctx, pkt_shaper_prof_idx,	3,	168),
-	ICE_CTX_STORE(ice_tlan_ctx, int_q_state,		110,	171),
+	ICE_CTX_STORE(ice_tlan_ctx, int_q_state,		122,	171),
 	{ 0 }
 };
 
diff --git a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
index 57ea6811fe2c..2aac8f13daeb 100644
--- a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
+++ b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
@@ -428,6 +428,7 @@ struct ice_tlan_ctx {
 #define ICE_TLAN_CTX_VMVF_TYPE_PF	2
 	u16 src_vsi;
 	u8 tsyn_ena;
+	u8 internal_usage_flag;
 	u8 alt_vlan;
 	u16 cpuid;		/* bigger than needed, see above for reason */
 	u8 wb_mode;
-- 
2.21.0

