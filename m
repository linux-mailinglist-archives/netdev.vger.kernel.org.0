Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED0B65F1421
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 22:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiI3Utd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 16:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbiI3UtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 16:49:06 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 883B063FF4;
        Fri, 30 Sep 2022 13:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664570945; x=1696106945;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jDIVi1DtobmhbOEiB3twfsAQ2NDCM1tO+n5kwnrzHfk=;
  b=lxgOA7NvHFAqIil6hJ+ujbvbESJ/QAH7HSZNsP95++L8JQFOspKa2E1t
   XkIP6bCu1+m8nsnbWEEETkbe8tijhzsJftgpy/Y6J/447KR1NHLSDYH9b
   sz3h3K1RUfD1/LNQidfES4zcZDCFtbmL6Us5nj9wbpd0DAy8lIAHnBI/9
   pXyieI8qI4VCHJaq5tk0tHpsXVDwHxnzgRmzrDjt1fierVetBh1YX7ea5
   gIfrEc8J4YiE5vyfomsE0ksPi7QzYjWWKxAcVxVS6zuwSxFIv86rk7iuB
   U680AL0LF83EZ5M9+mq9/eaGFt2Cm32+XM4Z7Dt9lAqy43DfvtCRcgGV/
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="289446001"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="289446001"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 13:49:04 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="691383717"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="691383717"
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
        Lv Ruyi <lv.ruyi@zte.com.cn>, Arnd Bergmann <arnd@arndb.de>,
        linux-renesas-soc@vger.kernel.org
Subject: [net-next v2 8/9] ptp: ravb: convert to .adjfine and adjust_by_scaled_ppm
Date:   Fri, 30 Sep 2022 13:48:50 -0700
Message-Id: <20220930204851.1910059-9-jacob.e.keller@intel.com>
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
 drivers/net/ethernet/renesas/ravb_ptp.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_ptp.c b/drivers/net/ethernet/renesas/ravb_ptp.c
index 87c4306d66ec..6e4ef7af27bf 100644
--- a/drivers/net/ethernet/renesas/ravb_ptp.c
+++ b/drivers/net/ethernet/renesas/ravb_ptp.c
@@ -88,24 +88,17 @@ static int ravb_ptp_update_compare(struct ravb_private *priv, u32 ns)
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
-	addend = priv->ptp.default_addend;
-	diff = div_u64((u64)addend * ppb, NSEC_PER_SEC);
-
-	addend = neg_adj ? addend - diff : addend + diff;
+	addend = (u32)adjust_by_scaled_ppm(priv->ptp.default_addend,
+					   scaled_ppm);
 
 	spin_lock_irqsave(&priv->lock, flags);
 
@@ -295,7 +288,7 @@ static const struct ptp_clock_info ravb_ptp_info = {
 	.max_adj	= 50000000,
 	.n_ext_ts	= N_EXT_TS,
 	.n_per_out	= N_PER_OUT,
-	.adjfreq	= ravb_ptp_adjfreq,
+	.adjfine	= ravb_ptp_adjfine,
 	.adjtime	= ravb_ptp_adjtime,
 	.gettime64	= ravb_ptp_gettime64,
 	.settime64	= ravb_ptp_settime64,
-- 
2.37.1.394.gc50926e1f488

