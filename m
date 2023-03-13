Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 267B36B806F
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbjCMS0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbjCMSZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:25:25 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5737D7DF91
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 11:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678731922; x=1710267922;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=305Tut3PK5OHBkGrZUpe3jc+d+0nzUyXAmpxnf3fdvg=;
  b=gIolJ0iLJ8l0ge7EjeuAFNzslIbEU7G5WXqD0GXne33s/DuhfvryBdol
   folUD1ya1NOY0mltJFQKy5T9EHgMgAKZcJr8lFY6ua61h0EpsUy4poayr
   30k+q6LcwwMQzPp8gCAkvULu8ErmiRGBQ2H7yyW7TLrEK2DOP11Ib4UUv
   tofTL/RKc4DQU+bDbZ7NzoeypiTbaaoVIIajphF2XNw0CrRMVCSkCb4tb
   mqPgtFEnqIKSeKL9OYQBI++UXQ3ZX7pLqGqpihL50cWYTy+IhgR1C2xyy
   f9Ip1QnAWHWew2/si4QWM5+77CVlRUMMqu1R83koFHoZqbS8PVS/f97rs
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="338772400"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="338772400"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 11:23:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="767809096"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="767809096"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Mar 2023 11:23:05 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        anthony.l.nguyen@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net-next 10/14] ice: remove unnecessary &array[0] and just use array
Date:   Mon, 13 Mar 2023 11:21:19 -0700
Message-Id: <20230313182123.483057-11-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230313182123.483057-1-anthony.l.nguyen@intel.com>
References: <20230313182123.483057-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

In ice_is_malicious_vf we print the VF MAC address using %pM by passing the
address of the first element of vf->dev_lan_addr. This is equivalent to
just passing vf->dev_lan_addr, so do that.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 185673afb781..938be486721e 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -1820,7 +1820,7 @@ ice_is_malicious_vf(struct ice_pf *pf, struct ice_rq_event_info *event,
 		u8 zero_addr[ETH_ALEN] = {};
 
 		dev_warn(dev, "VF MAC %pM on PF MAC %pM is generating asynchronous messages and may be overflowing the PF message queue. Please see the Adapter User Guide for more information\n",
-			 &vf->dev_lan_addr[0],
+			 vf->dev_lan_addr,
 			 pf_vsi ? pf_vsi->netdev->dev_addr : zero_addr);
 	}
 
-- 
2.38.1

