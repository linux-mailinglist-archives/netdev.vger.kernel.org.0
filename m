Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAE7599088
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 00:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245508AbiHRW2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 18:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241901AbiHRW15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 18:27:57 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE7EDB7CE
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 15:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660861676; x=1692397676;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Rq9K54UJpIrZjGBz1cxVb8wBx724sgGtVrCELKjaoVc=;
  b=baUVggJL6fPT2uRaFcL6nr3nWSmP09O7/RNIsuVndLeDiRAjDlzHoM0l
   r6vzYifsq1r4hfykPc0F2sBqtKZJxQaezshCaemVJQLPlOHtCTBugYvFl
   Mr70T6Uay1yTr74G2OAZhMUH1Z9n27SD7vZRYF7cG9KGlt3VeIm7AChHJ
   C7u8A8ykx3ZLua7SLZ3zAd4pOvbSlp8LuUOS2h6bPmaB5ZzKRjWU1iWF2
   LZlIaVheKfRybEXRuJ+HouPOGoX69kYnhCnHEkit1IBP+wJ6Sl3E/p4IC
   obc2sA8/NDoV6hj2X12f3PXsdAwq8qCioz5cfAcTJD7LpZ5iuTv/9Y5SW
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="275928701"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="275928701"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 15:27:53 -0700
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="558717082"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 15:27:53 -0700
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
Subject: [net-next 05/14] ptp_ixp46x: convert to .adjfine and adjust_by_scaled_ppm
Date:   Thu, 18 Aug 2022 15:27:33 -0700
Message-Id: <20220818222742.1070935-6-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.37.1.394.gc50926e1f488
In-Reply-To: <20220818222742.1070935-1-jacob.e.keller@intel.com>
References: <20220818222742.1070935-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ptp_ixp46x implementation of .adjfreq is implemented in terms of a
straight forward "base * ppb / 1 billion" calculation.

Convert this driver to .adjfine and use the adjust_by_scaled_ppm helper
function.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Wan Jiabing <wanjiabing@vivo.com>
---

I do not have this hardware, and have only compile tested this change.

 drivers/net/ethernet/xscale/ptp_ixp46x.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ptp_ixp46x.c b/drivers/net/ethernet/xscale/ptp_ixp46x.c
index 9abbdb71e629..dcdfd6e69d42 100644
--- a/drivers/net/ethernet/xscale/ptp_ixp46x.c
+++ b/drivers/net/ethernet/xscale/ptp_ixp46x.c
@@ -120,24 +120,13 @@ static irqreturn_t isr(int irq, void *priv)
  * PTP clock operations
  */
 
-static int ptp_ixp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+static int ptp_ixp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
-	u64 adj;
-	u32 diff, addend;
-	int neg_adj = 0;
+	u32 addend;
 	struct ixp_clock *ixp_clock = container_of(ptp, struct ixp_clock, caps);
 	struct ixp46x_ts_regs *regs = ixp_clock->regs;
 
-	if (ppb < 0) {
-		neg_adj = 1;
-		ppb = -ppb;
-	}
-	addend = DEFAULT_ADDEND;
-	adj = addend;
-	adj *= ppb;
-	diff = div_u64(adj, 1000000000ULL);
-
-	addend = neg_adj ? addend - diff : addend + diff;
+	addend = (u32)adjust_by_scaled_ppm(DEFAULT_ADDEND, scaled_ppm);
 
 	__raw_writel(addend, &regs->addend);
 
@@ -230,7 +219,7 @@ static const struct ptp_clock_info ptp_ixp_caps = {
 	.n_ext_ts	= N_EXT_TS,
 	.n_pins		= 0,
 	.pps		= 0,
-	.adjfreq	= ptp_ixp_adjfreq,
+	.adjfine	= ptp_ixp_adjfine,
 	.adjtime	= ptp_ixp_adjtime,
 	.gettime64	= ptp_ixp_gettime,
 	.settime64	= ptp_ixp_settime,
-- 
2.37.1.208.ge72d93e88cb2

