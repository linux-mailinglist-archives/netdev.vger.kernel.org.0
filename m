Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAE2599080
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 00:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244445AbiHRW2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 18:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241338AbiHRW15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 18:27:57 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA63DB7CD
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 15:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660861675; x=1692397675;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eXjbf9ryny7I1SbZzMkMH6glZQKDdt1r4sQrQiD4BJo=;
  b=N9t7Z08Lu3N9hgtreILqIv+dSNsIbUfmXQlVwh1hgcohTe8LFAQPKWse
   qnTVlYSp0Q/sfM/XgkMvlyEEMyA+ZjJstpVc8npuWe7Mw9NJ+7pZ1Ekao
   UVxhNbCgVNc8fKWF+FdTu2DRM7rXAVwb1JM+SDk/olTj8LNT3YKxHDU5L
   KH5pqSRbPPXMSVKnNG6VoeMLWZzjwkr6N1aYfyK8mtC6JuYo2VmNwvDwr
   m/ab1hxuSAyyFYK9u1XPTBZ+KPVjbyeGgK70+VKIMTZ8rLiBhMUfERGXE
   uVcaODbluAIAIEJb09AoyToFmccbAkSU0BEBAkvkFgICu+bUAOh/Di8mS
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="275928694"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="275928694"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 15:27:53 -0700
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="558717079"
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
        Lv Ruyi <lv.ruyi@zte.com.cn>, Arnd Bergmann <arnd@arndb.de>,
        Takahiro Shimizu <tshimizu818@gmail.com>
Subject: [net-next 04/14] ptp_phc: convert to .adjfine and ptp_adj_scaled_ppm
Date:   Thu, 18 Aug 2022 15:27:32 -0700
Message-Id: <20220818222742.1070935-5-jacob.e.keller@intel.com>
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

The ptp_phc implementation of .adjfreq is implemented in terms of a
straight forward "base * ppb / 1 billion" calculation.

Convert this driver to .adjfine and use the new ptp_adj_scaled_ppm function
to calculate the adjustment.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Takahiro Shimizu <tshimizu818@gmail.com>
Cc: Richard Cochran <richardcochran@gmail.com>
---

I do not have this hardware, and have only compile tested the change.

 drivers/ptp/ptp_pch.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
index 7d4da9e605ef..6bfe5c8eb61e 100644
--- a/drivers/ptp/ptp_pch.c
+++ b/drivers/ptp/ptp_pch.c
@@ -336,24 +336,13 @@ static irqreturn_t isr(int irq, void *priv)
  * PTP clock operations
  */
 
-static int ptp_pch_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+static int ptp_pch_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
-	u64 adj;
-	u32 diff, addend;
-	int neg_adj = 0;
+	u32 addend;
 	struct pch_dev *pch_dev = container_of(ptp, struct pch_dev, caps);
 	struct pch_ts_regs __iomem *regs = pch_dev->regs;
 
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
 
 	iowrite32(addend, &regs->addend);
 
@@ -440,7 +429,7 @@ static const struct ptp_clock_info ptp_pch_caps = {
 	.n_ext_ts	= N_EXT_TS,
 	.n_pins		= 0,
 	.pps		= 0,
-	.adjfreq	= ptp_pch_adjfreq,
+	.adjfine	= ptp_pch_adjfine,
 	.adjtime	= ptp_pch_adjtime,
 	.gettime64	= ptp_pch_gettime,
 	.settime64	= ptp_pch_settime,
-- 
2.37.1.208.ge72d93e88cb2

