Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37BFC1E97A6
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 14:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgEaMgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 08:36:51 -0400
Received: from mga12.intel.com ([192.55.52.136]:12468 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726555AbgEaMgY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 May 2020 08:36:24 -0400
IronPort-SDR: 6H0ArQa6efQCVIsoOUW4Ch7RVpHGX83nn2JCiB9vfPBOxwewjfxQzPC5pzlBYN36Ljzmd1vXO2
 0bzhleuBEWFQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2020 05:36:22 -0700
IronPort-SDR: ETPT4vM7EFsXsO4YQwlpnc0sxg2CXoe6Ll+X0uGzp3gFf83JPEW7Rwikt5uU3M67xLCgHlEms3
 NgOs6mBY7HZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,456,1583222400"; 
   d="scan'208";a="303345419"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 31 May 2020 05:36:21 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Paul Greenwalt <paul.greenwalt@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 02/14] ice: support adding 16 unicast/multicast filter on untrusted VF
Date:   Sun, 31 May 2020 05:36:07 -0700
Message-Id: <20200531123619.2887469-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
References: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Greenwalt <paul.greenwalt@intel.com>

Allow untrusted VF to add 16 unicast/multicast filters. VF uses 1 filter
for the default/perm_addr/LAA MAC, 1 for broadcast, and 16 additional
unicast/multicast filters.

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 0adff89a6749..67aa9110fdd1 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -7,7 +7,10 @@
 
 /* Restrict number of MAC Addr and VLAN that non-trusted VF can programmed */
 #define ICE_MAX_VLAN_PER_VF		8
-#define ICE_MAX_MACADDR_PER_VF		12
+/* MAC filters: 1 is reserved for the VF's default/perm_addr/LAA MAC, 1 for
+ * broadcast, and 16 for additional unicast/multicast filters
+ */
+#define ICE_MAX_MACADDR_PER_VF		18
 
 /* Malicious Driver Detection */
 #define ICE_DFLT_NUM_INVAL_MSGS_ALLOWED		10
-- 
2.26.2

