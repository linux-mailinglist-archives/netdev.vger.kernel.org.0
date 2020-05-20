Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0571DA60B
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 02:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbgETAEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 20:04:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:15430 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727915AbgETAEb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 20:04:31 -0400
IronPort-SDR: UOj637MHGJMQJugaeYZ53jq/X0dKHA4CJlDttTReOg0Jb08/ldoqR4J1/hIUXUXcDW0fHAgLxA
 PO2ynXeJxf4w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 17:04:22 -0700
IronPort-SDR: NBgulgXSthJIpB4uLXd6YgoIG18jSDVyskHTMdACg2ZH0KgYoUxQ3kakOTfiy8li0FIzgjyZSt
 K3hAjWCw+x/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,411,1583222400"; 
   d="scan'208";a="466324762"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga006.fm.intel.com with ESMTP; 19 May 2020 17:04:21 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 04/14] igc: Rename IGC_VLAPQF macro
Date:   Tue, 19 May 2020 17:04:09 -0700
Message-Id: <20200520000419.1595788-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200520000419.1595788-1-jeffrey.t.kirsher@intel.com>
References: <20200520000419.1595788-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

This patch renames the IGC_VLAPQF macro to IGC_VLANPQF as well as
related macros so they match the register name and fields described in
the data sheet.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h |  6 ++---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 23 ++++++++++----------
 drivers/net/ethernet/intel/igc/igc_regs.h    |  2 +-
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 0ecc63d423b8..f1bb5414f99f 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -508,9 +508,9 @@
 #define IGC_MAX_MAC_HDR_LEN	127
 #define IGC_MAX_NETWORK_HDR_LEN	511
 
-#define IGC_VLAPQF_QUEUE_SEL(_n, q_idx) ((q_idx) << ((_n) * 4))
-#define IGC_VLAPQF_P_VALID(_n)	(0x1 << (3 + (_n) * 4))
-#define IGC_VLAPQF_QUEUE_MASK	0x03
+#define IGC_VLANPQF_QSEL(_n, q_idx) ((q_idx) << ((_n) * 4))
+#define IGC_VLANPQF_VALID(_n)	(0x1 << (3 + (_n) * 4))
+#define IGC_VLANPQF_QUEUE_MASK	0x03
 
 #define IGC_ADVTXD_MACLEN_SHIFT		9  /* Adv ctxt desc mac len shift */
 #define IGC_ADVTXD_TUCMD_IPV4		0x00000400  /* IP Packet Type:1=IPv4 */
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index a05d7abee524..c21971b40cb2 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1229,23 +1229,23 @@ static int igc_rxnfc_write_vlan_prio_filter(struct igc_adapter *adapter,
 	u16 queue_index;
 	u32 vlapqf;
 
-	vlapqf = rd32(IGC_VLAPQF);
+	vlapqf = rd32(IGC_VLANPQF);
 	vlan_priority = (ntohs(input->filter.vlan_tci) & VLAN_PRIO_MASK)
 				>> VLAN_PRIO_SHIFT;
-	queue_index = (vlapqf >> (vlan_priority * 4)) & IGC_VLAPQF_QUEUE_MASK;
+	queue_index = (vlapqf >> (vlan_priority * 4)) & IGC_VLANPQF_QUEUE_MASK;
 
-	/* check whether this vlan prio is already set */
-	if (vlapqf & IGC_VLAPQF_P_VALID(vlan_priority) &&
+	/* check whether this VLAN prio is already set */
+	if (vlapqf & IGC_VLANPQF_VALID(vlan_priority) &&
 	    queue_index != input->action) {
 		netdev_err(adapter->netdev,
 			   "ethtool rxnfc set VLAN prio filter failed\n");
 		return -EEXIST;
 	}
 
-	vlapqf |= IGC_VLAPQF_P_VALID(vlan_priority);
-	vlapqf |= IGC_VLAPQF_QUEUE_SEL(vlan_priority, input->action);
+	vlapqf |= IGC_VLANPQF_VALID(vlan_priority);
+	vlapqf |= IGC_VLANPQF_QSEL(vlan_priority, input->action);
 
-	wr32(IGC_VLAPQF, vlapqf);
+	wr32(IGC_VLANPQF, vlapqf);
 
 	return 0;
 }
@@ -1313,12 +1313,11 @@ static void igc_clear_vlan_prio_filter(struct igc_adapter *adapter,
 
 	vlan_priority = (vlan_tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
 
-	vlapqf = rd32(IGC_VLAPQF);
-	vlapqf &= ~IGC_VLAPQF_P_VALID(vlan_priority);
-	vlapqf &= ~IGC_VLAPQF_QUEUE_SEL(vlan_priority,
-						IGC_VLAPQF_QUEUE_MASK);
+	vlapqf = rd32(IGC_VLANPQF);
+	vlapqf &= ~IGC_VLANPQF_VALID(vlan_priority);
+	vlapqf &= ~IGC_VLANPQF_QSEL(vlan_priority, IGC_VLANPQF_QUEUE_MASK);
 
-	wr32(IGC_VLAPQF, vlapqf);
+	wr32(IGC_VLANPQF, vlapqf);
 }
 
 int igc_erase_filter(struct igc_adapter *adapter, struct igc_nfc_filter *input)
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index f101bfbf52e6..851ff19af703 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -120,7 +120,7 @@
 #define IGC_UTA			0x0A000  /* Unicast Table Array - RW */
 #define IGC_RAL(_n)		(0x05400 + ((_n) * 0x08))
 #define IGC_RAH(_n)		(0x05404 + ((_n) * 0x08))
-#define IGC_VLAPQF		0x055B0  /* VLAN Priority Queue Filter VLAPQF */
+#define IGC_VLANPQF		0x055B0  /* VLAN Priority Queue Filter - RW */
 
 /* Transmit Register Descriptions */
 #define IGC_TCTL		0x00400  /* Tx Control - RW */
-- 
2.26.2

