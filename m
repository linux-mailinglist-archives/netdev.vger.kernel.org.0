Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6AD027B886
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbgI1Xzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:55:44 -0400
Received: from mga17.intel.com ([192.55.52.151]:45599 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726522AbgI1Xzn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 19:55:43 -0400
IronPort-SDR: qukPfcPQ8w5U0Kej/yuVlfQCdP0Z0523y0U7B+C4C/qNikcPbyOiHfT9QjKm1ld5i/R+EbJZvA
 dgZh9aLbJU+g==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="142086322"
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="142086322"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 14:50:29 -0700
IronPort-SDR: hCgVex17gY0eM71+rRmrfq4rDqoZpeIXRDzTlKlk9XZIPWqa6zsWxpRW95zLiqT8PHTZwA2HrQ
 2V75mIOtOD8w==
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="311962104"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 14:50:28 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next v2 04/15] igc: Rename IGC_TSYNCTXCTL_VALID macro
Date:   Mon, 28 Sep 2020 14:50:07 -0700
Message-Id: <20200928215018.952991-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200928215018.952991-1-anthony.l.nguyen@intel.com>
References: <20200928215018.952991-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

Rename the IGC_TSYNCTXCTL_VALID macro to IGC_TSYNCTXCTL_TXTT_0 so it
matches the datasheet.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h | 2 +-
 drivers/net/ethernet/intel/igc/igc_ptp.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index f1f464967f87..3f5a201bda89 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -409,7 +409,7 @@
 #define IGC_IMIREXT_SIZE_BP	0x00001000  /* Packet size bypass */
 
 /* Time Sync Transmit Control bit definitions */
-#define IGC_TSYNCTXCTL_VALID			0x00000001  /* Tx timestamp valid */
+#define IGC_TSYNCTXCTL_TXTT_0			0x00000001  /* Tx timestamp reg 0 valid */
 #define IGC_TSYNCTXCTL_ENABLED			0x00000010  /* enable Tx timestamping */
 #define IGC_TSYNCTXCTL_MAX_ALLOWED_DLY_MASK	0x0000F000  /* max delay */
 #define IGC_TSYNCTXCTL_SYNC_COMP_ERR		0x20000000  /* sync err */
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index e4b8f312f97c..dbe0776a7f2f 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -429,7 +429,7 @@ static void igc_ptp_tx_work(struct work_struct *work)
 	}
 
 	tsynctxctl = rd32(IGC_TSYNCTXCTL);
-	if (tsynctxctl & IGC_TSYNCTXCTL_VALID)
+	if (tsynctxctl & IGC_TSYNCTXCTL_TXTT_0)
 		igc_ptp_tx_hwtstamp(adapter);
 	else
 		/* reschedule to check later */
-- 
2.26.2

