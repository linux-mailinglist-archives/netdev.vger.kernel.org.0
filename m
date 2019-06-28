Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACDA45A72A
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfF1WtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:49:20 -0400
Received: from mga12.intel.com ([192.55.52.136]:42186 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726835AbfF1WtH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 18:49:07 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jun 2019 15:49:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,429,1557212400"; 
   d="scan'208";a="338039147"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga005.jf.intel.com with ESMTP; 28 Jun 2019 15:49:05 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 09/15] igb: minor ethool regdump amendment
Date:   Fri, 28 Jun 2019 15:49:26 -0700
Message-Id: <20190628224932.3389-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190628224932.3389-1-jeffrey.t.kirsher@intel.com>
References: <20190628224932.3389-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

This patch has no functional impact and it is just a preparation
for the following patch. It removes an early return from the
'igb_get_regs()' function by moving the 82576-only registers
dump into an "if" block. With this preparation, we can dump more
non-82576 registers at the end of this function.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_ethtool.c | 70 ++++++++++----------
 1 file changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index c645d9e648e0..401bc2bd6b21 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -675,41 +675,41 @@ static void igb_get_regs(struct net_device *netdev,
 		regs_buff[554] = adapter->stats.b2ogprc;
 	}
 
-	if (hw->mac.type != e1000_82576)
-		return;
-	for (i = 0; i < 12; i++)
-		regs_buff[555 + i] = rd32(E1000_SRRCTL(i + 4));
-	for (i = 0; i < 4; i++)
-		regs_buff[567 + i] = rd32(E1000_PSRTYPE(i + 4));
-	for (i = 0; i < 12; i++)
-		regs_buff[571 + i] = rd32(E1000_RDBAL(i + 4));
-	for (i = 0; i < 12; i++)
-		regs_buff[583 + i] = rd32(E1000_RDBAH(i + 4));
-	for (i = 0; i < 12; i++)
-		regs_buff[595 + i] = rd32(E1000_RDLEN(i + 4));
-	for (i = 0; i < 12; i++)
-		regs_buff[607 + i] = rd32(E1000_RDH(i + 4));
-	for (i = 0; i < 12; i++)
-		regs_buff[619 + i] = rd32(E1000_RDT(i + 4));
-	for (i = 0; i < 12; i++)
-		regs_buff[631 + i] = rd32(E1000_RXDCTL(i + 4));
-
-	for (i = 0; i < 12; i++)
-		regs_buff[643 + i] = rd32(E1000_TDBAL(i + 4));
-	for (i = 0; i < 12; i++)
-		regs_buff[655 + i] = rd32(E1000_TDBAH(i + 4));
-	for (i = 0; i < 12; i++)
-		regs_buff[667 + i] = rd32(E1000_TDLEN(i + 4));
-	for (i = 0; i < 12; i++)
-		regs_buff[679 + i] = rd32(E1000_TDH(i + 4));
-	for (i = 0; i < 12; i++)
-		regs_buff[691 + i] = rd32(E1000_TDT(i + 4));
-	for (i = 0; i < 12; i++)
-		regs_buff[703 + i] = rd32(E1000_TXDCTL(i + 4));
-	for (i = 0; i < 12; i++)
-		regs_buff[715 + i] = rd32(E1000_TDWBAL(i + 4));
-	for (i = 0; i < 12; i++)
-		regs_buff[727 + i] = rd32(E1000_TDWBAH(i + 4));
+	if (hw->mac.type == e1000_82576) {
+		for (i = 0; i < 12; i++)
+			regs_buff[555 + i] = rd32(E1000_SRRCTL(i + 4));
+		for (i = 0; i < 4; i++)
+			regs_buff[567 + i] = rd32(E1000_PSRTYPE(i + 4));
+		for (i = 0; i < 12; i++)
+			regs_buff[571 + i] = rd32(E1000_RDBAL(i + 4));
+		for (i = 0; i < 12; i++)
+			regs_buff[583 + i] = rd32(E1000_RDBAH(i + 4));
+		for (i = 0; i < 12; i++)
+			regs_buff[595 + i] = rd32(E1000_RDLEN(i + 4));
+		for (i = 0; i < 12; i++)
+			regs_buff[607 + i] = rd32(E1000_RDH(i + 4));
+		for (i = 0; i < 12; i++)
+			regs_buff[619 + i] = rd32(E1000_RDT(i + 4));
+		for (i = 0; i < 12; i++)
+			regs_buff[631 + i] = rd32(E1000_RXDCTL(i + 4));
+
+		for (i = 0; i < 12; i++)
+			regs_buff[643 + i] = rd32(E1000_TDBAL(i + 4));
+		for (i = 0; i < 12; i++)
+			regs_buff[655 + i] = rd32(E1000_TDBAH(i + 4));
+		for (i = 0; i < 12; i++)
+			regs_buff[667 + i] = rd32(E1000_TDLEN(i + 4));
+		for (i = 0; i < 12; i++)
+			regs_buff[679 + i] = rd32(E1000_TDH(i + 4));
+		for (i = 0; i < 12; i++)
+			regs_buff[691 + i] = rd32(E1000_TDT(i + 4));
+		for (i = 0; i < 12; i++)
+			regs_buff[703 + i] = rd32(E1000_TXDCTL(i + 4));
+		for (i = 0; i < 12; i++)
+			regs_buff[715 + i] = rd32(E1000_TDWBAL(i + 4));
+		for (i = 0; i < 12; i++)
+			regs_buff[727 + i] = rd32(E1000_TDWBAH(i + 4));
+	}
 }
 
 static int igb_get_eeprom_len(struct net_device *netdev)
-- 
2.21.0

