Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5B27610F4C
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 13:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiJ1LEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 07:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiJ1LEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 07:04:38 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FBD6159
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 04:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666955076; x=1698491076;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=piUmIf7gYnxlOx1OB5G2LH1RBYSPEoYcdbJYAm51vx8=;
  b=dHAqTctoX93Xf+x8oKiZGRl1Yim91Jru+ecJlWANSEzv5stHCSjJDWfZ
   qiujj3SsyWqGdSdcndrp16+C0sLJHePDqoJPSoHHCKNE9a0dowceI/zrj
   3theh2g9lELhMoN+j956oQfA9KAjXzvbLn58c+xa1IeC/uMLWy2N4K11v
   pMAvRlZj7CnojWc5ZC6SSqxZCzi27CEEJ7/vd437XRxJVhgYIKdnd1Lst
   AMv806EQrD+HmanXoXWrIetojHT8/BXx1UfUSroQ7Ay65aKY3dsY8LSIk
   gYjnA6Je905e7UdcxHv82HuBwv/UgvWee7mKVlJYyzYljwZh4sFPOgZfz
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="291766539"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="291766539"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 04:04:34 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="701698089"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="701698089"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.7])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 04:04:33 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Vivek Thampi <vithampi@vmware.com>
Subject: [PATCH net-next v3 3/9] drivers: convert unsupported .adjfreq to .adjfine
Date:   Fri, 28 Oct 2022 04:04:14 -0700
Message-Id: <20221028110420.3451088-4-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.38.0.83.gd420dda05763
In-Reply-To: <20221028110420.3451088-1-jacob.e.keller@intel.com>
References: <20221028110420.3451088-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A few PTP drivers implement a .adjfreq handler which indicates the
operation is not supported. Convert all of these to .adjfine.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Vivek Thampi <vithampi@vmware.com>
---
 drivers/hv/hv_util.c         | 4 ++--
 drivers/ptp/ptp_kvm_common.c | 4 ++--
 drivers/ptp/ptp_vmw.c        | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
index 835e6039c186..d776074b49cb 100644
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -706,7 +706,7 @@ static int hv_ptp_settime(struct ptp_clock_info *p, const struct timespec64 *ts)
 	return -EOPNOTSUPP;
 }
 
-static int hv_ptp_adjfreq(struct ptp_clock_info *ptp, s32 delta)
+static int hv_ptp_adjfine(struct ptp_clock_info *ptp, long delta)
 {
 	return -EOPNOTSUPP;
 }
@@ -724,7 +724,7 @@ static struct ptp_clock_info ptp_hyperv_info = {
 	.name		= "hyperv",
 	.enable         = hv_ptp_enable,
 	.adjtime        = hv_ptp_adjtime,
-	.adjfreq        = hv_ptp_adjfreq,
+	.adjfine        = hv_ptp_adjfine,
 	.gettime64      = hv_ptp_gettime,
 	.settime64      = hv_ptp_settime,
 	.owner		= THIS_MODULE,
diff --git a/drivers/ptp/ptp_kvm_common.c b/drivers/ptp/ptp_kvm_common.c
index fcae32f56f25..9141162c4237 100644
--- a/drivers/ptp/ptp_kvm_common.c
+++ b/drivers/ptp/ptp_kvm_common.c
@@ -66,7 +66,7 @@ static int ptp_kvm_getcrosststamp(struct ptp_clock_info *ptp,
  * PTP clock operations
  */
 
-static int ptp_kvm_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+static int ptp_kvm_adjfine(struct ptp_clock_info *ptp, long delta)
 {
 	return -EOPNOTSUPP;
 }
@@ -115,7 +115,7 @@ static const struct ptp_clock_info ptp_kvm_caps = {
 	.n_ext_ts	= 0,
 	.n_pins		= 0,
 	.pps		= 0,
-	.adjfreq	= ptp_kvm_adjfreq,
+	.adjfine	= ptp_kvm_adjfine,
 	.adjtime	= ptp_kvm_adjtime,
 	.gettime64	= ptp_kvm_gettime,
 	.settime64	= ptp_kvm_settime,
diff --git a/drivers/ptp/ptp_vmw.c b/drivers/ptp/ptp_vmw.c
index 5dca26e14bdc..d64eec5b1788 100644
--- a/drivers/ptp/ptp_vmw.c
+++ b/drivers/ptp/ptp_vmw.c
@@ -47,7 +47,7 @@ static int ptp_vmw_adjtime(struct ptp_clock_info *info, s64 delta)
 	return -EOPNOTSUPP;
 }
 
-static int ptp_vmw_adjfreq(struct ptp_clock_info *info, s32 delta)
+static int ptp_vmw_adjfine(struct ptp_clock_info *info, long delta)
 {
 	return -EOPNOTSUPP;
 }
@@ -79,7 +79,7 @@ static struct ptp_clock_info ptp_vmw_clock_info = {
 	.name		= "ptp_vmw",
 	.max_adj	= 0,
 	.adjtime	= ptp_vmw_adjtime,
-	.adjfreq	= ptp_vmw_adjfreq,
+	.adjfine	= ptp_vmw_adjfine,
 	.gettime64	= ptp_vmw_gettime,
 	.settime64	= ptp_vmw_settime,
 	.enable		= ptp_vmw_enable,
-- 
2.38.0.83.gd420dda05763

