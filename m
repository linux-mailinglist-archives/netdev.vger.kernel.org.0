Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7E12562513
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 23:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237402AbiF3VX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 17:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237536AbiF3VXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 17:23:16 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FCA1208B
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 14:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656624195; x=1688160195;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q0ChdmVDIh9dkVQFMzO9TKZDrcpsEaWlbpGblFBUJLs=;
  b=Tay7Bnkx2/QI8hggjU8IfXmBgg/iBjU8pI2YrwXCwLzYQjbly1gS8rWv
   DdPF0wemOhl3K3I6+r+WhmcZOV3r4Zn15qFVR3vB5bo5/S2GSuY2S3/5S
   36leb2AiFkWZtMbL+q7BL3slqIDJK4EfLDzZ6U8xpGs/kPDfW6VuuyucM
   I7UZYYpgP4GvkzE5T3yw9PpXd6bru2ygMccGJiJE9PqPRT+mfHBEpK4q2
   P/iHSoU6Q32NsqQJnXhdPWllsAVesJElDnGjvYVczPEbAX3Vqn4XSPKpY
   /b/1Gjkv40/v3liOqNjzaLeF4lIJZfUjH7dnSJOJhSqaTFj10Ohid6yVA
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="262274450"
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="262274450"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 14:23:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="837768340"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jun 2022 14:23:02 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Ziyang Xuan <william.xuanziyang@huawei.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 5/5] ice: Remove unnecessary NULL check before dev_put
Date:   Thu, 30 Jun 2022 14:20:00 -0700
Message-Id: <20220630212000.3006759-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220630212000.3006759-1-anthony.l.nguyen@intel.com>
References: <20220630212000.3006759-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

Since commit b37a46683739 ("netdevice: add the case if dev is NULL"),
dev_put(NULL) is safe, check NULL before dev_put() is not needed.

Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lag.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lag.c b/drivers/net/ethernet/intel/ice/ice_lag.c
index 4f954db01b92..c9f7393b783d 100644
--- a/drivers/net/ethernet/intel/ice/ice_lag.c
+++ b/drivers/net/ethernet/intel/ice/ice_lag.c
@@ -447,11 +447,9 @@ void ice_deinit_lag(struct ice_pf *pf)
 	if (lag->pf)
 		ice_unregister_lag_handler(lag);
 
-	if (lag->upper_netdev)
-		dev_put(lag->upper_netdev);
+	dev_put(lag->upper_netdev);
 
-	if (lag->peer_netdev)
-		dev_put(lag->peer_netdev);
+	dev_put(lag->peer_netdev);
 
 	kfree(lag);
 
-- 
2.35.1

