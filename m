Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0257251C9F3
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 22:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385579AbiEEUKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 16:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385572AbiEEUKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 16:10:40 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715F45E748
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 13:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651781220; x=1683317220;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TEUg/eJaNTO5HYodwwAioZOEcE1Yl6eX1kQ3UkR05aw=;
  b=DsmYeF8IOTVY7r9T2q9GG9NLw4kZwdnXLv6/VHFghgnRj0hHcmwXVaqU
   S7ydUwUG6w/ylAwe5Sb3WrnrUrYQEORVp3mmvIIpaEnIHoCdp94Wre8LZ
   SfErRedganXxm5AFgNcyJsHI12gwa2xK83Z6hKgfYz2jFlgAq5vSO6yJR
   m81/0gN3Z0WZu6USsrfYxdUNwADCi7Ai9q6XPOke5nGQxXx7mtCLQzXJa
   G5pAcIod6lln1h3HhXIR/8JHtPr0935xwDXWOVlwheXy6nhVSGSqGSKgo
   rTPhVwmZRAUNxXiTMFEGIV2Tk+fXuMrU+yNukKPJ1xMX3BDgANWQboucz
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248772033"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="248772033"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 13:06:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="735111711"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 05 May 2022 13:06:59 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Paul Menzel <pmenzel@molgen.mpg.de>
Subject: [PATCH net-next v2 05/10] ice: add newline to dev_dbg in ice_vf_fdir_dump_info
Date:   Thu,  5 May 2022 13:03:54 -0700
Message-Id: <20220505200359.3080110-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220505200359.3080110-1-anthony.l.nguyen@intel.com>
References: <20220505200359.3080110-1-anthony.l.nguyen@intel.com>
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

From: Jacob Keller <jacob.e.keller@intel.com>

The debug print in ice_vf_fdir_dump_info does not end in newlines. This can
look confusing when reading the kernel log, as the next print will
immediately continue on the same line.

Fix this by adding the forgotten newline.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
index 8e38ee2faf58..dbc1965c0609 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
@@ -1349,7 +1349,7 @@ static void ice_vf_fdir_dump_info(struct ice_vf *vf)
 
 	fd_size = rd32(hw, VSIQF_FD_SIZE(vsi_num));
 	fd_cnt = rd32(hw, VSIQF_FD_CNT(vsi_num));
-	dev_dbg(dev, "VF %d: space allocated: guar:0x%x, be:0x%x, space consumed: guar:0x%x, be:0x%x",
+	dev_dbg(dev, "VF %d: space allocated: guar:0x%x, be:0x%x, space consumed: guar:0x%x, be:0x%x\n",
 		vf->vf_id,
 		(fd_size & VSIQF_FD_CNT_FD_GCNT_M) >> VSIQF_FD_CNT_FD_GCNT_S,
 		(fd_size & VSIQF_FD_CNT_FD_BCNT_M) >> VSIQF_FD_CNT_FD_BCNT_S,
-- 
2.35.1

