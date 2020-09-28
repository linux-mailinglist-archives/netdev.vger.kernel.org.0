Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A629727B3CA
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 19:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbgI1R7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 13:59:35 -0400
Received: from mga18.intel.com ([134.134.136.126]:32958 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726661AbgI1R72 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 13:59:28 -0400
IronPort-SDR: xqo3r0dRvalUrxItNvaW0NwMmVHJjWiHmu+30gpdPLKq2mpWQb+TB/g+B/7yv6gKGvtTlmCfJs
 Y4ZsQO4L9C5g==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="149810265"
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="149810265"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 10:59:22 -0700
IronPort-SDR: z7YXYN5I11VGn6Rz8epbgit8ejp9+4bfPqwfW7TMVnOgb8n8S9tAqBaJV53CDMOobIaPI24+0s
 eE2id0Zv/9Vw==
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="340505379"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 10:59:21 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 04/15] igc: Rename IGC_TSYNCTXCTL_VALID macro
Date:   Mon, 28 Sep 2020 10:58:57 -0700
Message-Id: <20200928175908.318502-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200928175908.318502-1-anthony.l.nguyen@intel.com>
References: <20200928175908.318502-1-anthony.l.nguyen@intel.com>
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

