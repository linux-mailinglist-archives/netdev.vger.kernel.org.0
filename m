Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3831D8813
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 21:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgERTSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 15:18:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:32208 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727812AbgERTSf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 15:18:35 -0400
IronPort-SDR: cIuFLBNmG83SySwSDrPKj/1DyVTLTx/QafklDx8VbFrWbROU9Upn6h7qE9vMIUILsJFRSuiaGC
 Qeu6nASuLyXQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2020 12:18:35 -0700
IronPort-SDR: gHD0xE6toGSRqKTYfl/xpldRf2w4lyMsIMCselvYl+OYsyqBLNeNP2HXe1X8rLEaeUDWsMSKNr
 oFLYLyi/ZIvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,407,1583222400"; 
   d="scan'208";a="299327669"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 18 May 2020 12:18:33 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 36C5679; Mon, 18 May 2020 22:18:31 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Vishal Kulkarni <vishal@chelsio.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] cxgb4: Use %pM format specifier for MAC addresses
Date:   Mon, 18 May 2020 22:18:31 +0300
Message-Id: <20200518191831.72534-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert to %pM instead of using custom code.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    | 20 ++++++-------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index 7818c392da50..c3dd50b45c48 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -1813,12 +1813,8 @@ static int mps_tcam_show(struct seq_file *seq, void *v)
 			/* Inner header lookup */
 			if (lookup_type && (lookup_type != DATALKPTYPE_M)) {
 				seq_printf(seq,
-					   "%3u %02x:%02x:%02x:%02x:%02x:%02x "
-					   "%012llx %06x %06x    -    -   %3c"
-					   "      'I'  %4x   "
-					   "%3c   %#x%4u%4d", idx, addr[0],
-					   addr[1], addr[2], addr[3],
-					   addr[4], addr[5],
+					   "%3u %pM %012llx %06x %06x    -    -   %3c      'I'  %4x   %3c   %#x%4u%4d",
+					   idx, addr,
 					   (unsigned long long)mask,
 					   vniy, (vnix | vniy),
 					   dip_hit ? 'Y' : 'N',
@@ -1830,10 +1826,8 @@ static int mps_tcam_show(struct seq_file *seq, void *v)
 					   T6_VF_G(cls_lo) : -1);
 			} else {
 				seq_printf(seq,
-					   "%3u %02x:%02x:%02x:%02x:%02x:%02x "
-					   "%012llx    -       -   ",
-					   idx, addr[0], addr[1], addr[2],
-					   addr[3], addr[4], addr[5],
+					   "%3u %pM %012llx    -       -   ",
+					   idx, addr,
 					   (unsigned long long)mask);
 
 				if (vlan_vld)
@@ -1851,10 +1845,8 @@ static int mps_tcam_show(struct seq_file *seq, void *v)
 					   T6_VF_G(cls_lo) : -1);
 			}
 		} else
-			seq_printf(seq, "%3u %02x:%02x:%02x:%02x:%02x:%02x "
-				   "%012llx%3c   %#x%4u%4d",
-				   idx, addr[0], addr[1], addr[2], addr[3],
-				   addr[4], addr[5], (unsigned long long)mask,
+			seq_printf(seq, "%3u %pM %012llx%3c   %#x%4u%4d",
+				   idx, addr, (unsigned long long)mask,
 				   (cls_lo & SRAM_VLD_F) ? 'Y' : 'N',
 				   PORTMAP_G(cls_hi),
 				   PF_G(cls_lo),
-- 
2.26.2

