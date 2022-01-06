Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F679486BFB
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 22:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244304AbiAFVeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 16:34:07 -0500
Received: from mga11.intel.com ([192.55.52.93]:23581 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244305AbiAFVeB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 16:34:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641504841; x=1673040841;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JpH7R07Y/MI1hYEQ1If+7wWbVQq4YImWy4lGBx5CusA=;
  b=iRXxIg4Ycq9LxhlB4ZyDrphcz33UmlUXue3c8mGA4XaU+HjxZI09FUNg
   /049FnMhUoEABAD2KpMX4hYNaHhtF757aIC5gUzg9nhrLiExpFMmfQS87
   2WoL2BjPHC2UOu7ZUmdnaUEVPsJoOu6VZZLTFeijCrQQrDBy2SjTMsEDr
   DHsacsx/c2NLrAuzCWmTOuivsY+8umqVB2Mpo+x9NUZVzoKd9JWcxW3bV
   yp8L8EjGd6BLXtVvBReZUDPpXdgkQk14lReYAt6au4zozYEMI6Ar+HAdj
   K9XiQngJKmAgXPJyQIHu8Gqdiep/n3GbYH4u8v9wgho+AM82QHjR6nd+l
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="240296413"
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="240296413"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 13:33:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="611972916"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Jan 2022 13:33:42 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jason Wang <wangborong@cdjrlc.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com
Subject: [PATCH net-next 7/7] iavf: remove an unneeded variable
Date:   Thu,  6 Jan 2022 13:33:01 -0800
Message-Id: <20220106213301.11392-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220106213301.11392-1-anthony.l.nguyen@intel.com>
References: <20220106213301.11392-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Wang <wangborong@cdjrlc.com>

The variable `ret_code' used for returning is never changed in function
`iavf_shutdown_adminq'. So that it can be removed and just return its
initial value 0 at the end of `iavf_shutdown_adminq' function.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_adminq.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_adminq.c b/drivers/net/ethernet/intel/iavf/iavf_adminq.c
index 9fa3fa99b4c2..cd4e6a22d0f9 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_adminq.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_adminq.c
@@ -551,15 +551,13 @@ enum iavf_status iavf_init_adminq(struct iavf_hw *hw)
  **/
 enum iavf_status iavf_shutdown_adminq(struct iavf_hw *hw)
 {
-	enum iavf_status ret_code = 0;
-
 	if (iavf_check_asq_alive(hw))
 		iavf_aq_queue_shutdown(hw, true);
 
 	iavf_shutdown_asq(hw);
 	iavf_shutdown_arq(hw);
 
-	return ret_code;
+	return 0;
 }
 
 /**
-- 
2.31.1

