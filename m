Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2A2233645
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 18:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728452AbgG3QFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 12:05:07 -0400
Received: from mga18.intel.com ([134.134.136.126]:55967 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726275AbgG3QFG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 12:05:06 -0400
IronPort-SDR: CJRgFEk7b9UyZJQivH/+VBrZNhuCSCb8HsuNrNcOzPppjV8QQtLh/ZeYn0lWtLboVMo4b7PudT
 p4+jkAFOtO9g==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="139174346"
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="139174346"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 09:04:54 -0700
IronPort-SDR: niPKoRCWIoj+kB+cB5TglIw9kSBHKDHW3oOmv1LBykkWTSNtqETq+AUzGIE5kTpslkFDnQ7N7X
 yU+7MeAm99xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="330788039"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 30 Jul 2020 09:04:52 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 1BF4C119; Thu, 30 Jul 2020 19:04:51 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] ice: devlink: use %*phD to print small buffer
Date:   Thu, 30 Jul 2020 19:04:51 +0300
Message-Id: <20200730160451.40810-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use %*phD format to print small buffer as hex string.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index dbbd8b6f9d1a..a9105ad5b983 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -13,9 +13,7 @@ static int ice_info_get_dsn(struct ice_pf *pf, char *buf, size_t len)
 	/* Copy the DSN into an array in Big Endian format */
 	put_unaligned_be64(pci_get_dsn(pf->pdev), dsn);
 
-	snprintf(buf, len, "%02x-%02x-%02x-%02x-%02x-%02x-%02x-%02x",
-		 dsn[0], dsn[1], dsn[2], dsn[3],
-		 dsn[4], dsn[5], dsn[6], dsn[7]);
+	snprintf(buf, len, "%8phD", dsn);
 
 	return 0;
 }
-- 
2.27.0

