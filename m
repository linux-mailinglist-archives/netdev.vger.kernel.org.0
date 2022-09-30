Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 627A45F1422
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 22:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbiI3Utg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 16:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232281AbiI3UtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 16:49:07 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105B118F404
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 13:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664570946; x=1696106946;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mS17KU1tv7c4dRqjT5YX3FrNDeWBnCAjm0HRZRNFe2c=;
  b=aaFBKqGEgcXicHQNmUx9U8X8HB9bH/O/LCEEvK0v0RadfbP1Q3mdfL6k
   JeqB15KtfB9EUvU42d20vaTHsw0MdOKMcCwYtSinybHZD9iUkRqu/RHJT
   jd3HjpRd923Ha4OFGylPAPWYDxDHmv77epi3SUlNuw4AdwwUjDfgwQ2mo
   UHmteRM93F8D6RTBOElzt6HjpThp8UpZ14yA3jBV4E5AozcG1H1tf+nUB
   AMl8CA+ATFSDT8FrN+pjViqw1A4xcHVxMmIeCG1UOxuZmkJJuKMhYZlwc
   odJJ4SDujCgo86h4inG1g6X0/uaGuXy/85uxYyp63lc5adJRMIbAZdp2t
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="289446003"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="289446003"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 13:49:04 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="691383724"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="691383724"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 13:49:03 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vivek Thampi <vithampi@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Aya Levin <ayal@nvidia.com>,
        Cai Huoqing <cai.huoqing@linux.dev>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Lv Ruyi <lv.ruyi@zte.com.cn>, Arnd Bergmann <arnd@arndb.de>
Subject: [net-next v2 9/9] ptp: xgbe: convert to .adjfine and adjust_by_scaled_ppm
Date:   Fri, 30 Sep 2022 13:48:51 -0700
Message-Id: <20220930204851.1910059-10-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.37.1.394.gc50926e1f488
In-Reply-To: <20220930204851.1910059-1-jacob.e.keller@intel.com>
References: <20220930204851.1910059-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The xgbe implementation of .adjfreq is implemented in terms of a
straight forward "base * ppb / 1 billion" calculation.

Convert this driver to .adjfine and use adjust_by_scaled_ppm to calculate
the new addend value.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-ptp.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-ptp.c b/drivers/net/ethernet/amd/xgbe/xgbe-ptp.c
index d06d260cf1e2..7051bd7cf6dc 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-ptp.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-ptp.c
@@ -134,27 +134,15 @@ static u64 xgbe_cc_read(const struct cyclecounter *cc)
 	return nsec;
 }
 
-static int xgbe_adjfreq(struct ptp_clock_info *info, s32 delta)
+static int xgbe_adjfine(struct ptp_clock_info *info, long scaled_ppm)
 {
 	struct xgbe_prv_data *pdata = container_of(info,
 						   struct xgbe_prv_data,
 						   ptp_clock_info);
 	unsigned long flags;
-	u64 adjust;
-	u32 addend, diff;
-	unsigned int neg_adjust = 0;
+	u64 addend;
 
-	if (delta < 0) {
-		neg_adjust = 1;
-		delta = -delta;
-	}
-
-	adjust = pdata->tstamp_addend;
-	adjust *= delta;
-	diff = div_u64(adjust, 1000000000UL);
-
-	addend = (neg_adjust) ? pdata->tstamp_addend - diff :
-				pdata->tstamp_addend + diff;
+	addend = adjust_by_scaled_ppm(pdata->tstamp_addend, scaled_ppm);
 
 	spin_lock_irqsave(&pdata->tstamp_lock, flags);
 
@@ -235,7 +223,7 @@ void xgbe_ptp_register(struct xgbe_prv_data *pdata)
 		 netdev_name(pdata->netdev));
 	info->owner = THIS_MODULE;
 	info->max_adj = pdata->ptpclk_rate;
-	info->adjfreq = xgbe_adjfreq;
+	info->adjfine = xgbe_adjfine;
 	info->adjtime = xgbe_adjtime;
 	info->gettime64 = xgbe_gettime;
 	info->settime64 = xgbe_settime;
-- 
2.37.1.394.gc50926e1f488

