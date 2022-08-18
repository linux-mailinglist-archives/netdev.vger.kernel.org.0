Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5641A599087
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 00:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344508AbiHRW2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 18:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242629AbiHRW17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 18:27:59 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D62DB7DB;
        Thu, 18 Aug 2022 15:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660861677; x=1692397677;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gze0YxKCusqgNfKoiL93qLcI04RmJIw/YD+nbLgFGZM=;
  b=Q17Dg6n89Ro1zRim7wF1JhFG0oBRxCrIY4vVyoVu7jDFM7x/T4q3S4Og
   JTNhgSKsx2FVM5qt66h+buAHFLtqmpJeXcF0OdNHqreOlQKuWT1KwkAlL
   s/DZV39KuazSt8wurVvtLmmXuWMblfo3jkaJkDmUF1F99RUIzsx7Gk4GT
   ZWlgUzzoG1MRm0UjhmKwrVV4VQ759wuNkExb15lItuQIMvj8r8xRsE+hB
   BD+6ziav8SjqCMpp9oiZSM/Z5oGiLJSvDI5daol/2zF2vUaaHC+v/Bo/B
   rGKSZ0gO/GOnmAfJtXa98ioOaKx2VnHDGgc1CiaoDAS4Ij5I76G4Ifccp
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="292881602"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="292881602"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 15:27:54 -0700
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="558717102"
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
        Lv Ruyi <lv.ruyi@zte.com.cn>, Arnd Bergmann <arnd@arndb.de>,
        linux-renesas-soc@vger.kernel.org
Subject: [net-next 11/14] ptp: ravb: convert to .adjfine and adjust_by_scaled_ppm
Date:   Thu, 18 Aug 2022 15:27:39 -0700
Message-Id: <20220818222742.1070935-12-jacob.e.keller@intel.com>
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

The ravb implementation of .adjfreq is implemented in terms of a
straight forward "base * ppb / 1 billion" calculation.

Convert this driver to .adjfine and use the adjust_by_scaled_ppm helper
function to calculate the new addend.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Sergey Shtylyov <s.shtylyov@omp.ru>
Cc: Biju Das <biju.das.jz@bp.renesas.com>
Cc: Phil Edworthy <phil.edworthy@renesas.com>
Cc: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc: linux-renesas-soc@vger.kernel.org
---

I do not have this hardware, and have only compile tested the change.

 drivers/net/ethernet/renesas/ravb_ptp.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_ptp.c b/drivers/net/ethernet/renesas/ravb_ptp.c
index 87c4306d66ec..941aa3b0e8a0 100644
--- a/drivers/net/ethernet/renesas/ravb_ptp.c
+++ b/drivers/net/ethernet/renesas/ravb_ptp.c
@@ -88,24 +88,18 @@ static int ravb_ptp_update_compare(struct ravb_private *priv, u32 ns)
 }
 
 /* PTP clock operations */
-static int ravb_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+static int ravb_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct ravb_private *priv = container_of(ptp, struct ravb_private,
 						 ptp.info);
 	struct net_device *ndev = priv->ndev;
 	unsigned long flags;
-	u32 diff, addend;
-	bool neg_adj = false;
+	u32 addend;
 	u32 gccr;
 
-	if (ppb < 0) {
-		neg_adj = true;
-		ppb = -ppb;
-	}
 	addend = priv->ptp.default_addend;
-	diff = div_u64((u64)addend * ppb, NSEC_PER_SEC);
-
-	addend = neg_adj ? addend - diff : addend + diff;
+	addend = (u32)adjust_by_scaled_ppm(priv->ptp.default_addend,
+					   scaled_ppm);
 
 	spin_lock_irqsave(&priv->lock, flags);
 
@@ -295,7 +289,7 @@ static const struct ptp_clock_info ravb_ptp_info = {
 	.max_adj	= 50000000,
 	.n_ext_ts	= N_EXT_TS,
 	.n_per_out	= N_PER_OUT,
-	.adjfreq	= ravb_ptp_adjfreq,
+	.adjfine	= ravb_ptp_adjfine,
 	.adjtime	= ravb_ptp_adjtime,
 	.gettime64	= ravb_ptp_gettime64,
 	.settime64	= ravb_ptp_settime64,
-- 
2.37.1.208.ge72d93e88cb2

