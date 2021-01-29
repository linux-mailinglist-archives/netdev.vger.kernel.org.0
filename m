Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF46B3082B1
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 01:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbhA2Auy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 19:50:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:27200 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231593AbhA2AtW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 19:49:22 -0500
IronPort-SDR: ca+/givQbUtFYZ+Jrlk9I5dC7AGEBbmavoxehLNiySVSI0tpqp+fhGNldgChbttIrFSlqTd+OG
 GdO28CdOvfyQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="167438976"
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="167438976"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 16:42:53 -0800
IronPort-SDR: P/hI9I0QpOqHn40BlFWN513f34v5N7nKWi/jXq+5Ngglb+HsLoIszvmhcxQSLImOdUax5AJBiF
 IepASHcmfulg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="430778723"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 28 Jan 2021 16:42:52 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Dave Ertman <david.m.ertman@intel.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 15/15] ice: remove dead code
Date:   Thu, 28 Jan 2021 16:43:32 -0800
Message-Id: <20210129004332.3004826-16-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
References: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

The check for a NULL pf pointer is moot since the earlier declaration and
assignment of struct device *dev already de-referenced the pointer.  Also,
the only caller of ice_set_dflt_mib() already ensures pf is not NULL.

Cc: Dave Ertman <david.m.ertman@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index ff6190bffff6..3ff4f0d2ff1b 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -785,15 +785,9 @@ static void ice_set_dflt_mib(struct ice_pf *pf)
 	u8 mib_type, *buf, *lldpmib = NULL;
 	u16 len, typelen, offset = 0;
 	struct ice_lldp_org_tlv *tlv;
-	struct ice_hw *hw;
+	struct ice_hw *hw = &pf->hw;
 	u32 ouisubtype;
 
-	if (!pf) {
-		dev_dbg(dev, "%s NULL pf pointer\n", __func__);
-		return;
-	}
-
-	hw = &pf->hw;
 	mib_type = SET_LOCAL_MIB_TYPE_LOCAL_MIB;
 	lldpmib = kzalloc(ICE_LLDPDU_SIZE, GFP_KERNEL);
 	if (!lldpmib) {
-- 
2.26.2

