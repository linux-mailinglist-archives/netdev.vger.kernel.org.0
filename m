Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4768827D
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407529AbfHISb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:31:58 -0400
Received: from mga17.intel.com ([192.55.52.151]:55696 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436729AbfHISbq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 14:31:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Aug 2019 11:31:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,366,1559545200"; 
   d="scan'208";a="175229933"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga008.fm.intel.com with ESMTP; 09 Aug 2019 11:31:45 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 13/15] ice: Move VF resources definition to SR-IOV specific file
Date:   Fri,  9 Aug 2019 11:31:37 -0700
Message-Id: <20190809183139.30871-14-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190809183139.30871-1-jeffrey.t.kirsher@intel.com>
References: <20190809183139.30871-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>

In order to use some of the VF resources definition in the SR-IOV specific
virtchnl header file, this patch moves applicable code to
ice_virtchnl_pf.h file accordingly... and they should have been defined in
the destination file originally.

Signed-off-by: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h             | 10 ----------
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h | 13 +++++++++++++
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 36a8ee873ae1..8398dd45a8a2 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -87,16 +87,6 @@ extern const char ice_drv_ver[];
 #define ICE_RES_MISC_VEC_ID	(ICE_RES_VALID_BIT - 1)
 #define ICE_INVAL_Q_INDEX	0xffff
 #define ICE_INVAL_VFID		256
-#define ICE_MAX_VF_COUNT	256
-#define ICE_MAX_QS_PER_VF		256
-#define ICE_MIN_QS_PER_VF		1
-#define ICE_DFLT_QS_PER_VF		4
-#define ICE_NONQ_VECS_VF		1
-#define ICE_MAX_SCATTER_QS_PER_VF	16
-#define ICE_MAX_BASE_QS_PER_VF		16
-#define ICE_MAX_INTR_PER_VF		65
-#define ICE_MIN_INTR_PER_VF		(ICE_MIN_QS_PER_VF + 1)
-#define ICE_DFLT_INTR_PER_VF		(ICE_DFLT_QS_PER_VF + 1)
 
 #define ICE_MAX_RESET_WAIT		20
 
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 79bb47f73879..4d94853f119a 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -26,6 +26,19 @@
 #define ICE_PCI_CIAD_WAIT_COUNT		100
 #define ICE_PCI_CIAD_WAIT_DELAY_US	1
 
+/* VF resources default values and limitation */
+#define ICE_MAX_VF_COUNT		256
+#define ICE_MAX_QS_PER_VF		256
+#define ICE_MIN_QS_PER_VF		1
+#define ICE_DFLT_QS_PER_VF		4
+#define ICE_NONQ_VECS_VF		1
+#define ICE_MAX_SCATTER_QS_PER_VF	16
+#define ICE_MAX_BASE_QS_PER_VF		16
+#define ICE_MAX_INTR_PER_VF		65
+#define ICE_MAX_POLICY_INTR_PER_VF	33
+#define ICE_MIN_INTR_PER_VF		(ICE_MIN_QS_PER_VF + 1)
+#define ICE_DFLT_INTR_PER_VF		(ICE_DFLT_QS_PER_VF + 1)
+
 /* Specific VF states */
 enum ice_vf_states {
 	ICE_VF_STATE_INIT = 0,
-- 
2.21.0

