Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77BD0317457
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 00:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbhBJX0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 18:26:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:20916 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234079AbhBJXZL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 18:25:11 -0500
IronPort-SDR: pUgLt3sh6bJC3q8WMulLmv2h0GxW5aOEmSHasxiViAZXdWV4L1/FiqeRKkoqWX2ZtN1pMjQ0fV
 Uktxa0DLYJAw==
X-IronPort-AV: E=McAfee;i="6000,8403,9891"; a="201287991"
X-IronPort-AV: E=Sophos;i="5.81,169,1610438400"; 
   d="scan'208";a="201287991"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2021 15:23:45 -0800
IronPort-SDR: mmEn9ybtKILAVnuFdR2OHfeZxazIwMbtcCeXWLU879bC4ZlGDii7qunPlPzLHPgvnjkI+I5qKc
 J+Dlxyd1l8MA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,169,1610438400"; 
   d="scan'208";a="361512359"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 10 Feb 2021 15:23:45 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Kaixu Xia <kaixuxia@tencent.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tosk Robot <tencent_os_robot@tencent.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 7/7] i40e: remove the useless value assignment in i40e_clean_adminq_subtask
Date:   Wed, 10 Feb 2021 15:24:36 -0800
Message-Id: <20210210232436.4084373-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210210232436.4084373-1-anthony.l.nguyen@intel.com>
References: <20210210232436.4084373-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The variable ret is overwritten by the following call
i40e_clean_arq_element() and the assignment is useless, so remove it.

Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index ccddf5ca0644..63e19d2e3301 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -9842,7 +9842,7 @@ static void i40e_clean_adminq_subtask(struct i40e_pf *pf)
 			dev_dbg(&pf->pdev->dev, "ARQ: Update LLDP MIB event received\n");
 #ifdef CONFIG_I40E_DCB
 			rtnl_lock();
-			ret = i40e_handle_lldp_event(pf, &event);
+			i40e_handle_lldp_event(pf, &event);
 			rtnl_unlock();
 #endif /* CONFIG_I40E_DCB */
 			break;
-- 
2.26.2

