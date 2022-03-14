Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 841E14D8B67
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 19:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243653AbiCNSLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 14:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243617AbiCNSLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 14:11:13 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0BC13DE2
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 11:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647281401; x=1678817401;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gHukA6XcoaZlufRwnfq9dW5WXDMbH0chsfQm04aK+UM=;
  b=MuJ6uKO+SKu8g8DfPBqEnBIeyUyoXu2EsMSv4duo2S946Vemp2sSgo7A
   ZbzqsqGfHbJbqSPLyGxXfiL+UIzA8YhicrbHCEfqIAGC3P67t03z8GFQL
   M6T/KksHTSSXHAPqr2iErUU5mOE58oyo+Ud/QAioGrjg2sLILcjVVvX3h
   4kw0PLUK6kkwQh3h9ZEObT4YLJBNArGawqANvXYZffCOhUVxPZAlfOFY/
   gMd4AJqepkcBuQ8yi5JW7n0f87H7w1xuHDpdyX+92Dz6twq6OWZW0j2xZ
   BaGjnmHWO0yh/tmcDFuYgzYzzCotbrE5HY8AjUtgEL+6Ux7Kuz3rjfeAl
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="238275390"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="238275390"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 11:10:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="634297660"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Mar 2022 11:10:00 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 15/25] ice: fix a long line warning in ice_reset_vf
Date:   Mon, 14 Mar 2022 11:10:06 -0700
Message-Id: <20220314181016.1690595-16-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220314181016.1690595-1-anthony.l.nguyen@intel.com>
References: <20220314181016.1690595-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

We're about to move ice_reset_vf out of ice_sriov.c and into
ice_vf_lib.c

One of the dev_err statements has a checkpatch.pl violation due to
putting the vf->vf_id on the same line as the dev_err. Fix this style
issue first before moving the code.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index be6ec42f97c1..b2376e3b746e 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -1251,7 +1251,8 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 	ice_vf_pre_vsi_rebuild(vf);
 
 	if (vf->vf_ops->vsi_rebuild(vf)) {
-		dev_err(dev, "Failed to release and setup the VF%u's VSI\n", vf->vf_id);
+		dev_err(dev, "Failed to release and setup the VF%u's VSI\n",
+			vf->vf_id);
 		return false;
 	}
 
-- 
2.31.1

