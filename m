Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB33E1E750E
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 06:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgE2Eke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 00:40:34 -0400
Received: from mga03.intel.com ([134.134.136.65]:40329 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726533AbgE2EkT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 00:40:19 -0400
IronPort-SDR: o1wMalUXW+p4eyfGShn3oq76nEN0y2t2vGSglDJ4nWTdYlfK2yBLh6lMBIZbZelmgOOtqqWfFC
 IIehBL/2sMBg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 21:40:06 -0700
IronPort-SDR: 00j9v/M82XqKDlZ0/RhIAsTDQ2XZ0FO2WEE9zzMB79Yh/5EBahNJLsbl7NL4w8BtQu6l6TGQxu
 W+14Ind5PfZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="414850940"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 28 May 2020 21:40:05 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 16/17] igc: Fix wrong register name
Date:   Thu, 28 May 2020 21:40:03 -0700
Message-Id: <20200529044004.3725307-17-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529044004.3725307-1-jeffrey.t.kirsher@intel.com>
References: <20200529044004.3725307-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Accordance to the i225 datasheet this register address
used by Host Transmit Discarded Packet by MAC counter
and not by not applicable Carrier Extension Error counter.
This patch comes to fix this wrong definition.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_mac.c  | 2 +-
 drivers/net/ethernet/intel/igc/igc_regs.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_mac.c b/drivers/net/ethernet/intel/igc/igc_mac.c
index fb496617e8e1..410aeb01de5c 100644
--- a/drivers/net/ethernet/intel/igc/igc_mac.c
+++ b/drivers/net/ethernet/intel/igc/igc_mac.c
@@ -287,7 +287,7 @@ void igc_clear_hw_cntrs_base(struct igc_hw *hw)
 	rd32(IGC_ALGNERRC);
 	rd32(IGC_RXERRC);
 	rd32(IGC_TNCRS);
-	rd32(IGC_CEXTERR);
+	rd32(IGC_HTDPMC);
 	rd32(IGC_TSCTC);
 	rd32(IGC_TSCTFC);
 
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index 2b7a877dadac..232e82dec62e 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -137,7 +137,7 @@
 #define IGC_RERC	0x0402C  /* Receive Error Count - R/clr */
 #define IGC_DC		0x04030  /* Defer Count - R/clr */
 #define IGC_TNCRS	0x04034  /* Tx-No CRS - R/clr */
-#define IGC_CEXTERR	0x0403C  /* Carrier Extension Error Count - R/clr */
+#define IGC_HTDPMC	0x0403C  /* Host Transmit Discarded by MAC - R/clr */
 #define IGC_RLEC	0x04040  /* Receive Length Error Count - R/clr */
 #define IGC_XONRXC	0x04048  /* XON Rx Count - R/clr */
 #define IGC_XONTXC	0x0404C  /* XON Tx Count - R/clr */
-- 
2.26.2

