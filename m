Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF7F28664C
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 19:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbgJGRzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 13:55:01 -0400
Received: from mga17.intel.com ([192.55.52.151]:18440 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727697AbgJGRy7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 13:54:59 -0400
IronPort-SDR: lYYhRHXqgYP8HXHGJlhVLcKzxrDl3V6Wxg9vRxH4y0E4WBtV2+lzoIsrQAQ1QOrFQC+jNBOmM4
 8e9HGaSasOxQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="144957650"
X-IronPort-AV: E=Sophos;i="5.77,347,1596524400"; 
   d="scan'208";a="144957650"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 10:54:59 -0700
IronPort-SDR: yXyCThFwyJ/yPecivY3culJ/mWCWNETQAJbzeMwq1LKn40pKasrsoNm5n8jrErv0nvPI4qBzG1
 JlBJMY9zEc9g==
X-IronPort-AV: E=Sophos;i="5.77,347,1596524400"; 
   d="scan'208";a="518935773"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 10:54:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next 1/8] ice: devlink: use %*phD to print small buffer
Date:   Wed,  7 Oct 2020 10:54:40 -0700
Message-Id: <20201007175447.647867-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201007175447.647867-1-anthony.l.nguyen@intel.com>
References: <20201007175447.647867-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Use %*phD format to print small buffer as hex string.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index e17b44059eae..29b88643b99a 100644
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
2.26.2

