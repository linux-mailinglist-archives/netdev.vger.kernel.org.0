Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55DEA51C475
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 18:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381567AbiEEQDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 12:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381597AbiEEQDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 12:03:33 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C4B5AA4C
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 08:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651766392; x=1683302392;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U9qragd4k21LsXO4eKfqr8GiRNtOZHdErIy4jTkX5jg=;
  b=nErGQ9gPc5tF6WnxELjb2AJPt2npKYhbLq5To6rFBEYovG4qd1maOnDU
   LaWpR13MPBeMW/jzeZSJikGKGBNxwFQpdo22zBv50TfKy3KQz/8D3fuVL
   Q2rzdJqixEVZ6hc4z350/gq69g+TVEzBG/yrr7mbwwPlVK2BQi/Tq1IGX
   L+F/RIW++FwHDERYszoAGOi7lS20NkMckxHpfbkEtKDB1JC5fAIF4oHJ0
   A1igbvZh9n0QSKypx2llfNEdExYJjMm/BZlB65whKmMROkuxsprhWnqq7
   Y6HejRT2vsO7uj0cXE0bkiRrn6/yMnBshkmmW93De579mqaCinxiIjqNL
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248696917"
X-IronPort-AV: E=Sophos;i="5.91,201,1647327600"; 
   d="scan'208";a="248696917"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 08:59:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,201,1647327600"; 
   d="scan'208";a="811682472"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 05 May 2022 08:59:50 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jeff Daly <jeffd@silicom-usa.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 1/2] ixgbe: Fix module_param allow_unsupported_sfp type
Date:   Thu,  5 May 2022 08:56:50 -0700
Message-Id: <20220505155651.2606195-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220505155651.2606195-1-anthony.l.nguyen@intel.com>
References: <20220505155651.2606195-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Daly <jeffd@silicom-usa.com>

The module_param allow_unsupported_sfp should be a boolean to match the
type in the ixgbe_hw struct.

Signed-off-by: Jeff Daly <jeffd@silicom-usa.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index c4a4954aa317..e5732a058bec 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -151,8 +151,8 @@ MODULE_PARM_DESC(max_vfs,
 		 "Maximum number of virtual functions to allocate per physical function - default is zero and maximum value is 63. (Deprecated)");
 #endif /* CONFIG_PCI_IOV */
 
-static unsigned int allow_unsupported_sfp;
-module_param(allow_unsupported_sfp, uint, 0);
+static bool allow_unsupported_sfp;
+module_param(allow_unsupported_sfp, bool, 0);
 MODULE_PARM_DESC(allow_unsupported_sfp,
 		 "Allow unsupported and untested SFP+ modules on 82599-based adapters");
 
-- 
2.35.1

