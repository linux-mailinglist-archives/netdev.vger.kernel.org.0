Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990481E9799
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 14:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728207AbgEaMg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 08:36:28 -0400
Received: from mga12.intel.com ([192.55.52.136]:12463 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728160AbgEaMg0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 May 2020 08:36:26 -0400
IronPort-SDR: isHV3B1AVGmgs9+fKnTMRlykXi3tc6zDOSXH4gMiSwFXHjm3fAdb0majhgSntqvWrtI9yN1R+K
 MmdI5SRGRSeA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2020 05:36:24 -0700
IronPort-SDR: gQHKBFGxa3rgkVFxtnsA1xmM1YYIvQ5vj2RyeUUaOyRsDrv9ljBZSf/aoqMgmcO8EgJeDqNCWO
 Z2myehmCLmWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,456,1583222400"; 
   d="scan'208";a="303345447"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 31 May 2020 05:36:24 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 11/14] ice: fix PCI device serial number to be lowercase values
Date:   Sun, 31 May 2020 05:36:16 -0700
Message-Id: <20200531123619.2887469-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
References: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>

Commit ceb2f00707f9 ("ice: Use pci_get_dsn()") changed the code to
use a new function to get the Device Serial Number. It also changed
the case of the filename for loading a package on a specific NIC
from lowercase to uppercase. Change the filename back to
lowercase since that is what we specified.

Fixes: ceb2f00707f9 ("ice: Use pci_get_dsn()")
Signed-off-by: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index bbf92d2f1ac1..cb72ff32a29b 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3248,7 +3248,7 @@ static char *ice_get_opt_fw_name(struct ice_pf *pf)
 	if (!opt_fw_filename)
 		return NULL;
 
-	snprintf(opt_fw_filename, NAME_MAX, "%sice-%016llX.pkg",
+	snprintf(opt_fw_filename, NAME_MAX, "%sice-%016llx.pkg",
 		 ICE_DDP_PKG_PATH, dsn);
 
 	return opt_fw_filename;
-- 
2.26.2

