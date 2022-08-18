Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8716F599081
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 00:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345614AbiHRW21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 18:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244246AbiHRW2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 18:28:06 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977A2DB7E1
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 15:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660861682; x=1692397682;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zKub8VlQXxP+HqcqTWtHsADaJysk4FG2rFaFOhd16pQ=;
  b=ZwJ+7mmHn0RYvgcyhS9YR+ZOYT263uUKb0DowW6Lj/om/c/gFpSJgjGw
   B+UjC0msUZAy/D2XXu+e24NWjmgEMoyVuLihJEXlhRtzZPVn6YdK10Yly
   TUuNrVTsZs4JVpz5THd1Gg21CFfkkXqNefuylXsaLz71UQ+t1S6BNH95p
   3MfeH3/h2uvvF0QcJtzhlrwsd0e6GHdrvehJF+agy+GYO6vaisDAMmoKj
   hEDRQQnov91OWxMkeKXn/+HsCdgRs2p5R6/RbK2o3ckVbZJRYvMfZf90+
   uITXDv2mdQ8h+b9PdIat9sOivR304EbDwnhr+AQhKVWssrzSRlFc//qxn
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="292881608"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="292881608"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 15:27:55 -0700
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="558717108"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 15:27:54 -0700
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
Subject: [net-next 13/14] ptp: cpts: convert to .adjfine and adjust_by_scaled_ppm
Date:   Thu, 18 Aug 2022 15:27:41 -0700
Message-Id: <20220818222742.1070935-14-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.37.1.394.gc50926e1f488
In-Reply-To: <20220818222742.1070935-1-jacob.e.keller@intel.com>
References: <20220818222742.1070935-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cpts implementation of .adjfreq is implemented in terms of a
straight forward "base * ppb / 1 billion" calculation.

Convert this driver to .adjfine and use the adjust_by_scaled_ppm helper
function.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---

I do not have this hardware, and have only compile tested the change.

 drivers/net/ethernet/ti/cpts.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index 92ca739fac01..ea3a10576d03 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -213,25 +213,16 @@ static void cpts_update_cur_time(struct cpts *cpts, int match,
 
 /* PTP clock operations */
 
-static int cpts_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+static int cpts_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct cpts *cpts = container_of(ptp, struct cpts, info);
-	int neg_adj = 0;
-	u32 diff, mult;
-	u64 adj;
+	u32 mult;
 
-	if (ppb < 0) {
-		neg_adj = 1;
-		ppb = -ppb;
-	}
-	mult = cpts->cc_mult;
-	adj = mult;
-	adj *= ppb;
-	diff = div_u64(adj, 1000000000ULL);
+	mult = (u32)adjust_by_scaled_ppm(cpts->cc_mult, scaled_ppm);
 
 	mutex_lock(&cpts->ptp_clk_mutex);
 
-	cpts->mult_new = neg_adj ? mult - diff : mult + diff;
+	cpts->mult_new = mult;
 
 	cpts_update_cur_time(cpts, CPTS_EV_PUSH, NULL);
 
@@ -435,7 +426,7 @@ static const struct ptp_clock_info cpts_info = {
 	.n_ext_ts	= 0,
 	.n_pins		= 0,
 	.pps		= 0,
-	.adjfreq	= cpts_ptp_adjfreq,
+	.adjfine	= cpts_ptp_adjfine,
 	.adjtime	= cpts_ptp_adjtime,
 	.gettimex64	= cpts_ptp_gettimeex,
 	.settime64	= cpts_ptp_settime,
@@ -794,7 +785,7 @@ struct cpts *cpts_create(struct device *dev, void __iomem *regs,
 
 	cpts_calc_mult_shift(cpts);
 	/* save cc.mult original value as it can be modified
-	 * by cpts_ptp_adjfreq().
+	 * by cpts_ptp_adjfine().
 	 */
 	cpts->cc_mult = cpts->cc.mult;
 
-- 
2.37.1.208.ge72d93e88cb2

