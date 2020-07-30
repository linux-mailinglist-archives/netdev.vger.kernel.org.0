Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C001233511
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 17:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729732AbgG3PJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 11:09:10 -0400
Received: from mga07.intel.com ([134.134.136.100]:21843 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727966AbgG3PJI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 11:09:08 -0400
IronPort-SDR: 5ryQP/AO4cl38yW5P4dP/OZtp1gEUuthy3DlJliXwgrXSlZg1ghd7IvHwO+/rCah5Scz4ck+UI
 9qTskrKJqi9g==
X-IronPort-AV: E=McAfee;i="6000,8403,9697"; a="216088343"
X-IronPort-AV: E=Sophos;i="5.75,414,1589266800"; 
   d="scan'208";a="216088343"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 08:09:07 -0700
IronPort-SDR: wTghw5mJ1yhgoRyR57L1hQdU3fm63IKZZgUE/odhXHpMEh+nKmUde6OpQzeyGo7u0P2eypRU9p
 /bKLWfDCDIog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,414,1589266800"; 
   d="scan'208";a="272947239"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga007.fm.intel.com with ESMTP; 30 Jul 2020 08:09:06 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 2E84E119; Thu, 30 Jul 2020 18:09:04 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] hsr: Use %pM format specifier for MAC addresses
Date:   Thu, 30 Jul 2020 18:09:04 +0300
Message-Id: <20200730150904.38588-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert to %pM instead of using custom code.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 net/hsr/hsr_debugfs.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/hsr/hsr_debugfs.c b/net/hsr/hsr_debugfs.c
index 772af706c528..a8e435021935 100644
--- a/net/hsr/hsr_debugfs.c
+++ b/net/hsr/hsr_debugfs.c
@@ -22,12 +22,6 @@
 
 static struct dentry *hsr_debugfs_root_dir;
 
-static void print_mac_address(struct seq_file *sfp, unsigned char *mac)
-{
-	seq_printf(sfp, "%02x:%02x:%02x:%02x:%02x:%02x ",
-		   mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
-}
-
 /* hsr_node_table_show - Formats and prints node_table entries */
 static int
 hsr_node_table_show(struct seq_file *sfp, void *data)
@@ -49,8 +43,8 @@ hsr_node_table_show(struct seq_file *sfp, void *data)
 		/* skip self node */
 		if (hsr_addr_is_self(priv, node->macaddress_A))
 			continue;
-		print_mac_address(sfp, &node->macaddress_A[0]);
-		print_mac_address(sfp, &node->macaddress_B[0]);
+		seq_printf(sfp, "%pM ", &node->macaddress_A[0]);
+		seq_printf(sfp, "%pM ", &node->macaddress_B[0]);
 		seq_printf(sfp, "%10lx, ", node->time_in[HSR_PT_SLAVE_A]);
 		seq_printf(sfp, "%10lx, ", node->time_in[HSR_PT_SLAVE_B]);
 		seq_printf(sfp, "%14x, ", node->addr_B_port);
-- 
2.27.0

