Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315F1226EA0
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 21:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbgGTTBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 15:01:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:13967 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgGTTBg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 15:01:36 -0400
IronPort-SDR: JHHqfMbVK6jhVR+1QHvX+wPALr3rDl5oFXZ5lASsXq3CnlW/SDizsUHkPQ/s/MZIJ7mPw1hZlg
 603LboLfcA/w==
X-IronPort-AV: E=McAfee;i="6000,8403,9688"; a="138089132"
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="138089132"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 12:00:57 -0700
IronPort-SDR: NSlolG9n3axCEUo09H8b/Em4YqhaDHPcPqjaCROtoJgbX0+OaONurKO3tbXeV8yngYFxsT41zY
 IdCq5b/9NEvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="319635033"
Received: from jrmontoy-mobl.amr.corp.intel.com ([10.209.71.203])
  by fmsmga002.fm.intel.com with ESMTP; 20 Jul 2020 12:00:55 -0700
From:   Andre Guedes <andre.guedes@intel.com>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz
Subject: [PATCH ethtool] igc: Fix output values case
Date:   Mon, 20 Jul 2020 12:00:38 -0700
Message-Id: <20200720190038.11193-1-andre.guedes@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch changes the output values to be lowercase and replaces
"True"/"False" by "yes"/"no" so the output from the IGC driver is
consistent with other Intel drivers.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
---
 igc.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/igc.c b/igc.c
index 9c0a750..2c4abce 100644
--- a/igc.c
+++ b/igc.c
@@ -81,17 +81,17 @@
 
 static const char *bit_to_boolean(u32 val)
 {
-	return val ? "True" : "False";
+	return val ? "yes" : "no";
 }
 
 static const char *bit_to_enable(u32 val)
 {
-	return val ? "Enabled" : "Disabled";
+	return val ? "enabled" : "disabled";
 }
 
 static const char *bit_to_prio(u32 val)
 {
-	return val ? "Low" : "High";
+	return val ? "low" : "high";
 }
 
 int igc_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
@@ -138,23 +138,23 @@ int igc_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
 	       bit_to_enable(reg & RCTL_LPE),
 	       (reg & RCTL_LBM) == RCTL_LBM_PHY ? "PHY" :
 	       (reg & RCTL_LBM) == RCTL_LBM_MAC ? "MAC" :
-	       "Undefined",
-	       (reg & RCTL_HSEL) == RCTL_HSEL_MULTICAST ? "Multicast Only" :
-	       (reg & RCTL_HSEL) == RCTL_HSEL_UNICAST ? "Unicast Only" :
-	       (reg & RCTL_HSEL) == RCTL_HSEL_BOTH ? "Multicast and Unicast" :
-	       "Reserved",
-	       (reg & RCTL_MO) == RCTL_MO_47_36 ? "Bits [47:36]" :
-	       (reg & RCTL_MO) == RCTL_MO_43_32 ? "Bits [43:32]" :
-	       (reg & RCTL_MO) == RCTL_MO_39_28 ? "Bits [39:28]" :
-	       "Bits [35:24]",
+	       "undefined",
+	       (reg & RCTL_HSEL) == RCTL_HSEL_MULTICAST ? "multicast only" :
+	       (reg & RCTL_HSEL) == RCTL_HSEL_UNICAST ? "unicast only" :
+	       (reg & RCTL_HSEL) == RCTL_HSEL_BOTH ? "multicast and unicast" :
+	       "reserved",
+	       (reg & RCTL_MO) == RCTL_MO_47_36 ? "bits [47:36]" :
+	       (reg & RCTL_MO) == RCTL_MO_43_32 ? "bits [43:32]" :
+	       (reg & RCTL_MO) == RCTL_MO_39_28 ? "bits [39:28]" :
+	       "bits [35:24]",
 	       bit_to_enable(reg & RCTL_BAM),
-	       (reg & RCTL_BSIZE) == RCTL_BSIZE_2048 ? "2048 Bytes" :
-	       (reg & RCTL_BSIZE) == RCTL_BSIZE_1024 ? "1024 Bytes" :
-	       (reg & RCTL_BSIZE) == RCTL_BSIZE_512 ? "512 Bytes" :
-	       "256 Bytes",
+	       (reg & RCTL_BSIZE) == RCTL_BSIZE_2048 ? "2048 bytes" :
+	       (reg & RCTL_BSIZE) == RCTL_BSIZE_1024 ? "1024 bytes" :
+	       (reg & RCTL_BSIZE) == RCTL_BSIZE_512 ? "512 bytes" :
+	       "256 bytes",
 	       bit_to_enable(reg & RCTL_VFE),
 	       bit_to_enable(reg & RCTL_CFIEN),
-	       reg & RCTL_CFI ? "Discarded" : "Accepted",
+	       reg & RCTL_CFI ? "discarded" : "accepted",
 	       bit_to_enable(reg & RCTL_PSP),
 	       bit_to_enable(reg & RCTL_DPF),
 	       bit_to_enable(reg & RCTL_PMCF),
@@ -187,7 +187,7 @@ int igc_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
 		       "    Address Valid:                             %s\n",
 		       offset + i, i,
 		       reg & RAH_RAH,
-		       reg & RAH_ASEL ? "Source" : "Destination",
+		       reg & RAH_ASEL ? "source" : "destination",
 		       (reg & RAH_QSEL) >> RAH_QSEL_SHIFT,
 		       bit_to_boolean(reg & RAH_QSEL_EN),
 		       bit_to_boolean(reg & RAH_AV));
-- 
2.26.2

