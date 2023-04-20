Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D28126EA04B
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 01:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbjDTXxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 19:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbjDTXxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 19:53:42 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3802430FC
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 16:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682034811; x=1713570811;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QSrizTxcBaRKo/Fa4Ck+454vIjvJlLBJj/XNuKWcZHg=;
  b=h0HTVKvY0iHegmv/WYrJUrdinstiFMlnUjeO54A/XGLGtNMt571wPzKn
   AkEjBM2JZyZyFOo1gf90fK+lmZ7KGgETsX4ggz8aBwv1OzASGygvU2j1R
   B6FqjSV90lKGaAO8sSoX85Uj3z2qIGG4NJjvsmb+58LdqpSdwZjWS55bl
   paTGHEx/pY1Bwd1S2IP/GOnGNvM8wYf7jl/z9z6SBsIF4xGGIGItOIhJY
   cNRbc0gPupwUpanSiEctwGmSZnMR7gIt/uw6lX/BItVxgeEJDsh5y7y2/
   fbr7+iEB7FoKGOim/HHdkw8Pe48ivLD5TvQnHqepiegwBz+PR1flmuagP
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="343368441"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="343368441"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 16:53:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="756714245"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="756714245"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga008.fm.intel.com with ESMTP; 20 Apr 2023 16:53:21 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Michal Schmidt <mschmidt@redhat.com>, anthony.l.nguyen@intel.com,
        johan@kernel.org, Simon Horman <simon.horman@corigine.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Sunitha Mekala <sunithax.d.mekala@intel.com>
Subject: [PATCH net-next 3/6] ice: remove ice_ctl_q_info::sq_cmd_timeout
Date:   Thu, 20 Apr 2023 16:50:30 -0700
Message-Id: <20230420235033.2971567-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230420235033.2971567-1-anthony.l.nguyen@intel.com>
References: <20230420235033.2971567-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Schmidt <mschmidt@redhat.com>

sq_cmd_timeout is initialized to ICE_CTL_Q_SQ_CMD_TIMEOUT and never
changed, so just use the constant directly.

Suggested-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c   | 2 +-
 drivers/net/ethernet/intel/ice/ice_controlq.c | 5 +----
 drivers/net/ethernet/intel/ice/ice_controlq.h | 1 -
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index c2fda4fa4188..f4c256563248 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -2000,7 +2000,7 @@ void ice_release_res(struct ice_hw *hw, enum ice_aq_res_ids res)
 	/* there are some rare cases when trying to release the resource
 	 * results in an admin queue timeout, so handle them correctly
 	 */
-	while ((status == -EIO) && (total_delay < hw->adminq.sq_cmd_timeout)) {
+	while ((status == -EIO) && (total_delay < ICE_CTL_Q_SQ_CMD_TIMEOUT)) {
 		mdelay(1);
 		status = ice_aq_release_res(hw, res, 0, NULL);
 		total_delay++;
diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.c b/drivers/net/ethernet/intel/ice/ice_controlq.c
index 6bcfee295991..c8fb10106ec3 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.c
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.c
@@ -637,9 +637,6 @@ static int ice_init_ctrlq(struct ice_hw *hw, enum ice_ctl_q q_type)
 		return -EIO;
 	}
 
-	/* setup SQ command write back timeout */
-	cq->sq_cmd_timeout = ICE_CTL_Q_SQ_CMD_TIMEOUT;
-
 	/* allocate the ATQ */
 	ret_code = ice_init_sq(hw, cq);
 	if (ret_code)
@@ -1066,7 +1063,7 @@ ice_sq_send_cmd(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 
 		udelay(ICE_CTL_Q_SQ_CMD_USEC);
 		total_delay++;
-	} while (total_delay < cq->sq_cmd_timeout);
+	} while (total_delay < ICE_CTL_Q_SQ_CMD_TIMEOUT);
 
 	/* if ready, copy the desc back to temp */
 	if (ice_sq_done(hw, cq)) {
diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.h b/drivers/net/ethernet/intel/ice/ice_controlq.h
index c07e9cc9fc6e..e790b2f4e437 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.h
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.h
@@ -87,7 +87,6 @@ struct ice_ctl_q_info {
 	enum ice_ctl_q qtype;
 	struct ice_ctl_q_ring rq;	/* receive queue */
 	struct ice_ctl_q_ring sq;	/* send queue */
-	u32 sq_cmd_timeout;		/* send queue cmd write back timeout */
 	u16 num_rq_entries;		/* receive queue depth */
 	u16 num_sq_entries;		/* send queue depth */
 	u16 rq_buf_size;		/* receive queue buffer size */
-- 
2.38.1

