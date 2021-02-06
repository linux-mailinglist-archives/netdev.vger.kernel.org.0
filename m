Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D70311B25
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 05:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbhBFEvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 23:51:40 -0500
Received: from mga18.intel.com ([134.134.136.126]:21610 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231406AbhBFEtG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 23:49:06 -0500
IronPort-SDR: vJeKaeBS2OKP3Dy8x5LDDW89/QmPiRzNxeoC5x7B0iDVNYtI4ipc7rjMOntx0huNAilFizBZoq
 kM4BWPCtAaAw==
X-IronPort-AV: E=McAfee;i="6000,8403,9886"; a="169194698"
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="169194698"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 20:40:12 -0800
IronPort-SDR: d3vl8DF1bhXIkLSETQ+KGqvEjhTqxxWwxdU3PQBacgKE/wM53DBst1qj0DYcqokUbVsH2i9wEI
 JaS1z2syVZZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="434751073"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 05 Feb 2021 20:40:12 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Dave Ertman <david.m.ertman@intel.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next v2 11/11] ice: remove dead code
Date:   Fri,  5 Feb 2021 20:41:01 -0800
Message-Id: <20210206044101.636242-12-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210206044101.636242-1-anthony.l.nguyen@intel.com>
References: <20210206044101.636242-1-anthony.l.nguyen@intel.com>
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
index f6177591978d..98cd44a3ccf7 100644
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

