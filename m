Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F51920EAE2
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbgF3B14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:27:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:7475 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728397AbgF3B1y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 21:27:54 -0400
IronPort-SDR: PmJtE3nHlaS6bZFlP3pv4XtTzUsxq0DyTICGjQktPZR0bIysIvnjV10Tg/oqvRiN7WumG9SWLk
 cFNQg8mNA/3w==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="134413751"
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="134413751"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 18:27:51 -0700
IronPort-SDR: 5qx1sdnMVq267webf25E+3BvB26/GvMxzxsMEdxhtHqNHn2Bnw5/Do4NaP2PiVS/dEbpTrHhGp
 a8f8ljFv/tOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="425017719"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 29 Jun 2020 18:27:50 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 09/13] igc: Add LPI counters
Date:   Mon, 29 Jun 2020 18:27:44 -0700
Message-Id: <20200630012748.518705-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200630012748.518705-1-jeffrey.t.kirsher@intel.com>
References: <20200630012748.518705-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Add EEE TX LPI and EEE RX LPI counters. A EEE TX LPI event
occurs when the transmitter enters EEE (IEEE 802.3az) LPI
state. A EEE RX LPI event occurs when the receiver detect
link partner entry into EEE(IEEE 802.3az) LPI state.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_mac.c  | 2 ++
 drivers/net/ethernet/intel/igc/igc_regs.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_mac.c b/drivers/net/ethernet/intel/igc/igc_mac.c
index bc077f230f17..f3f7717b6233 100644
--- a/drivers/net/ethernet/intel/igc/igc_mac.c
+++ b/drivers/net/ethernet/intel/igc/igc_mac.c
@@ -307,6 +307,8 @@ void igc_clear_hw_cntrs_base(struct igc_hw *hw)
 	rd32(IGC_ICRXDMTC);
 
 	rd32(IGC_RPTHC);
+	rd32(IGC_TLPIC);
+	rd32(IGC_RLPIC);
 	rd32(IGC_HGPTC);
 	rd32(IGC_HGORCL);
 	rd32(IGC_HGORCH);
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index d53f49833db5..eb3e8e70501d 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -188,6 +188,8 @@
 #define IGC_ICTXQEC	0x04118  /* Interrupt Cause Tx Queue Empty Count */
 #define IGC_ICTXQMTC	0x0411C  /* Interrupt Cause Tx Queue Min Thresh Count */
 #define IGC_RPTHC	0x04104  /* Rx Packets To Host */
+#define IGC_TLPIC	0x04148  /* EEE Tx LPI Count */
+#define IGC_RLPIC	0x0414C  /* EEE Rx LPI Count */
 #define IGC_HGPTC	0x04118  /* Host Good Packets Tx Count */
 #define IGC_RXDMTC	0x04120  /* Rx Descriptor Minimum Threshold Count */
 #define IGC_HGORCL	0x04128  /* Host Good Octets Received Count Low */
-- 
2.26.2

