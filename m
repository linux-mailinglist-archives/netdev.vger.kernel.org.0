Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB5E286652
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 19:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbgJGRzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 13:55:11 -0400
Received: from mga17.intel.com ([192.55.52.151]:18444 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728763AbgJGRzA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 13:55:00 -0400
IronPort-SDR: YlB/5Bt5i5uDgDUiZWaywnTevIrUQMJ9FaWiqRqiU56w0XMFrqWV6G7cg5oCcCE1j4ukjDnFyk
 CsBFldk0p/vQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="144957652"
X-IronPort-AV: E=Sophos;i="5.77,347,1596524400"; 
   d="scan'208";a="144957652"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 10:54:59 -0700
IronPort-SDR: Gj2ZrMDzcn2yEAbfulFvtb55p0V3zO10/8Kn8jKqMfHFpsizHKrQkuM1LZcIB+UztgHGjscANX
 4HPzLSE3rHWA==
X-IronPort-AV: E=Sophos;i="5.77,347,1596524400"; 
   d="scan'208";a="518935781"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 10:54:58 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 3/8] ice: Change ice_info_get_dsn to be void
Date:   Wed,  7 Oct 2020 10:54:42 -0700
Message-Id: <20201007175447.647867-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201007175447.647867-1-anthony.l.nguyen@intel.com>
References: <20201007175447.647867-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

ice_info_get_dsn always returns 0, so just make it void.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 29b88643b99a..ed04bae36f00 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -6,7 +6,7 @@
 #include "ice_devlink.h"
 #include "ice_fw_update.h"
 
-static int ice_info_get_dsn(struct ice_pf *pf, char *buf, size_t len)
+static void ice_info_get_dsn(struct ice_pf *pf, char *buf, size_t len)
 {
 	u8 dsn[8];
 
@@ -14,8 +14,6 @@ static int ice_info_get_dsn(struct ice_pf *pf, char *buf, size_t len)
 	put_unaligned_be64(pci_get_dsn(pf->pdev), dsn);
 
 	snprintf(buf, len, "%8phD", dsn);
-
-	return 0;
 }
 
 static int ice_info_pba(struct ice_pf *pf, char *buf, size_t len)
@@ -178,11 +176,7 @@ static int ice_devlink_info_get(struct devlink *devlink,
 		return err;
 	}
 
-	err = ice_info_get_dsn(pf, buf, sizeof(buf));
-	if (err) {
-		NL_SET_ERR_MSG_MOD(extack, "Unable to obtain serial number");
-		return err;
-	}
+	ice_info_get_dsn(pf, buf, sizeof(buf));
 
 	err = devlink_info_serial_number_put(req, buf);
 	if (err) {
-- 
2.26.2

