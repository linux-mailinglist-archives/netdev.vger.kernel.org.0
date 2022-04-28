Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA70513AE4
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 19:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240232AbiD1Rau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 13:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350500AbiD1Rai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 13:30:38 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 650853EBBF
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 10:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651166838; x=1682702838;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V0dR3DntbSz7TRWzyWVX9JS6+4aQlBxh2ROw+Q1oHtA=;
  b=RiND8o/DLwOunWvqPZM4UX01au+N1QghGcyB4Vn2pMbsNF6NWs2RxCPM
   r+sohOVRVc9aPoVswE+fZ70k7/KrzgZk2MskfbOZCA1lbjY676OWRHKsE
   nEfjRm81AGrawpLFw6BUcteJDU31eFbj9WhmQnw7pCQdId5FZ2WmS4Qs7
   pJVxn9zfONlVDluqAc7/myh/Tmf8wL2pSBksNKKes2i0UhBL3v1et64Aw
   WtgWd32MagptY3ZF2K/q+nVf81Eo6UUS1Btgc1BvP41Xv0Tv3SyPhTR/v
   Krhrdznm5GtkxT4VcSfydMhxa5wBH/vl904S6wSGsXhc6GxULSVc4ovcB
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="329306366"
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="329306366"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 10:27:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="581497053"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 28 Apr 2022 10:27:13 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next 08/11] ice: remove return value comment for ice_reset_all_vfs
Date:   Thu, 28 Apr 2022 10:24:27 -0700
Message-Id: <20220428172430.1004528-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220428172430.1004528-1-anthony.l.nguyen@intel.com>
References: <20220428172430.1004528-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Since commit fe99d1c06c16 ("ice: make ice_reset_all_vfs void"), the
ice_reset_all_vfs function has not returned anything. The function comment
still indicated it did. Fix this.

While here, also add a line to clarify the function resets all VFs at once
in response to hardware resets such as a PF reset.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_vf_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index aefd66a4db80..24cf6a5b49fe 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -359,12 +359,12 @@ ice_vf_clear_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m)
  * ice_reset_all_vfs - reset all allocated VFs in one go
  * @pf: pointer to the PF structure
  *
+ * Reset all VFs at once, in response to a PF or other device reset.
+ *
  * First, tell the hardware to reset each VF, then do all the waiting in one
  * chunk, and finally finish restoring each VF after the wait. This is useful
  * during PF routines which need to reset all VFs, as otherwise it must perform
  * these resets in a serialized fashion.
- *
- * Returns true if any VFs were reset, and false otherwise.
  */
 void ice_reset_all_vfs(struct ice_pf *pf)
 {
-- 
2.31.1

