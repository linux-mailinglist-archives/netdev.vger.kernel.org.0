Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE9E47C976
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 00:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234684AbhLUXFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 18:05:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:30772 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231946AbhLUXFt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 18:05:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640127949; x=1671663949;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7JEQXRqhakQoYH1NLAJzMvdcHSrC5MswZCNjBVdbvMs=;
  b=R/q/TWTtTqcOlmMVYjcqOb3TaTaEiymvK6lfqc9Cimt3TRhozBNm4RwK
   9toPTQOlQguIM+naTdBQkCGxLZYJ0273v0Amef45h5bMiRfYrdc4Ic351
   otfgdS2PSsWJTNWGIj7n32ljn9uZHyWf5YgUoC3/0Rop0np0jzKBe1pth
   FoyydGPqlt8+2ULz1y6kxJVYq1nQyylhwcnuKG3zEvpLWgDW5O0k0LGYn
   JNW5DdcDmWNe10aD0KK/nwDjYIAg3kJ6yQwZ1Xe09oo+Yq42CYcTo2YG/
   WIr7kkxku6kwgk9DoWLEJHjIti97O6CAczz+4YFKRfVqV1LEGKdlIuy/h
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="227802478"
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="227802478"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 15:05:46 -0800
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="756005031"
Received: from jbrandeb-saw1.jf.intel.com ([10.166.28.56])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 15:05:46 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com
Subject: [PATCH net-next v1] ice: trivial: fix odd indenting
Date:   Tue, 21 Dec 2021 15:05:38 -0800
Message-Id: <20211221230538.2546315-1-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix an odd indent where some code was left indented, and causes smatch
to warn:
ice_log_pkg_init() warn: inconsistent indenting

While here, for consistency, add a break after the default case.

This commit has a Fixes: but we caught this while it was only in net-next.

Fixes: 247dd97d713c ("ice: Refactor status flow for DDP load")
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 865f2231bb24..661b59456742 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4123,13 +4123,14 @@ static void ice_log_pkg_init(struct ice_hw *hw, enum ice_ddp_state state)
 		break;
 	case ICE_DDP_PKG_LOAD_ERROR:
 		dev_err(dev, "An error occurred on the device while loading the DDP package.  The device will be reset.\n");
-			/* poll for reset to complete */
-			if (ice_check_reset(hw))
-				dev_err(dev, "Error resetting device. Please reload the driver\n");
+		/* poll for reset to complete */
+		if (ice_check_reset(hw))
+			dev_err(dev, "Error resetting device. Please reload the driver\n");
 		break;
 	case ICE_DDP_PKG_ERR:
 	default:
 		dev_err(dev, "An unknown error occurred when loading the DDP package.  Entering Safe Mode.\n");
+		break;
 	}
 }
 
-- 
2.33.1

