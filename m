Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87A585F141E
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 22:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbiI3UtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 16:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232197AbiI3UtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 16:49:04 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A5963FD6
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 13:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664570942; x=1696106942;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yaZI98PzYiJWjAQu6NN9En/PwNyOg7Uoa43RmvHvDIU=;
  b=X2YNXUEsiELBmOkCVuZUeYSKeFevFeZEwZRP5reqR2cZAN6TA/bHO4CY
   ZgMIR+/ANKDkOiaBvYpKm1Fiji3RHpw0Py3QmFgaO316Gmm8vSvJrPEvy
   Q6gOJlMWmELtkSVzuMse2BoTs7J5N5EhlB5ApL4sXuKoxg1KDcRgmrtDe
   OFl53uMVo0WkuvvKbyaRZucl2GUEgN0u9DEONAA1uN7LirD4lVerg624x
   pOa655Kj6R9GKEAJXz2X+XXMPmVVjeZKjlrGNbLWq5SScXuLNThCaGTq+
   fD9OBH2JjzieFwVQr2VAzGiyAnGLs83vcwuuUbRDvhEKs5EeCvdmLjdNM
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="289445994"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="289445994"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 13:49:01 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="691383700"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="691383700"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 13:49:00 -0700
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
        Shirly Ohnona <shirlyo@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: [net-next v2 5/9] ptp: mlx5: convert to .adjfine and adjust_by_scaled_ppm
Date:   Fri, 30 Sep 2022 13:48:47 -0700
Message-Id: <20220930204851.1910059-6-jacob.e.keller@intel.com>
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

The mlx5 implementation of .adjfreq is implemented in terms of a
straight forward "base * ppb / 1 billion" calculation.

Convert this to the .adjfine interface and use adjust_by_scaled_ppm for the
calculation  of the new mult value.

Note that the mlx5_ptp_adjfreq_real_time function expects input in terms of
ppb, so use the scaled_ppm_to_ppb to convert before passing to this
function.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Shirly Ohnona <shirlyo@nvidia.com>
Cc: Gal Pressman <gal@nvidia.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Aya Levin <ayal@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 22 +++++--------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index d3a9ae80fd30..69cfe60c558a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -339,35 +339,25 @@ static int mlx5_ptp_adjfreq_real_time(struct mlx5_core_dev *mdev, s32 freq)
 	return mlx5_set_mtutc(mdev, in, sizeof(in));
 }
 
-static int mlx5_ptp_adjfreq(struct ptp_clock_info *ptp, s32 delta)
+static int mlx5_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct mlx5_clock *clock = container_of(ptp, struct mlx5_clock, ptp_info);
 	struct mlx5_timer *timer = &clock->timer;
 	struct mlx5_core_dev *mdev;
 	unsigned long flags;
-	int neg_adj = 0;
-	u32 diff;
-	u64 adj;
+	u32 mult;
 	int err;
 
 	mdev = container_of(clock, struct mlx5_core_dev, clock);
-	err = mlx5_ptp_adjfreq_real_time(mdev, delta);
+	err = mlx5_ptp_adjfreq_real_time(mdev, scaled_ppm_to_ppb(scaled_ppm));
 	if (err)
 		return err;
 
-	if (delta < 0) {
-		neg_adj = 1;
-		delta = -delta;
-	}
-
-	adj = timer->nominal_c_mult;
-	adj *= delta;
-	diff = div_u64(adj, 1000000000ULL);
+	mult = (u32)adjust_by_scaled_ppm(timer->nominal_c_mult, scaled_ppm);
 
 	write_seqlock_irqsave(&clock->lock, flags);
 	timecounter_read(&timer->tc);
-	timer->cycles.mult = neg_adj ? timer->nominal_c_mult - diff :
-				       timer->nominal_c_mult + diff;
+	timer->cycles.mult = mult;
 	mlx5_update_clock_info_page(mdev);
 	write_sequnlock_irqrestore(&clock->lock, flags);
 
@@ -697,7 +687,7 @@ static const struct ptp_clock_info mlx5_ptp_clock_info = {
 	.n_per_out	= 0,
 	.n_pins		= 0,
 	.pps		= 0,
-	.adjfreq	= mlx5_ptp_adjfreq,
+	.adjfine	= mlx5_ptp_adjfine,
 	.adjtime	= mlx5_ptp_adjtime,
 	.gettimex64	= mlx5_ptp_gettimex,
 	.settime64	= mlx5_ptp_settime,
-- 
2.37.1.394.gc50926e1f488

