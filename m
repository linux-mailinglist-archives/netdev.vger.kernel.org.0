Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8B73599089
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 00:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344564AbiHRW2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 18:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243429AbiHRW2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 18:28:01 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13370DB7DF
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 15:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660861678; x=1692397678;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VKsLiLCzajuuCA/rEPLQOHww5fmbTmDF04PnhPq0buc=;
  b=NZjKtZN0uq0PdHcusPT3iTFPKEcbvnKjHpNnfvaBsnWBSBr6F0Resvjr
   fJ20/1vE29ADldutpsaGkgXPdJV4/89OByJPk/mId8l2vwjKVSE4l3DBj
   bUPAGfdKJhRx4PQAQaPlLCekUseqsBDDSddP3pbhQuvlPIfZmrPDhlAp9
   lkW9uisacSx2gUIHfX65YoibAA3NfWWU/i8fnfVKoukXt3JifT8lwx5Fj
   R9QvKCZG8X1WuDFlL5Da4w9Q3Z+pYZyoYxvy3QZw+sql3QGf2WK7zAtYm
   WN+uNoACjPwAewVavz/rkLHkxO6Dd1bBffKCLnM/QACcBqrym98p0IKiy
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="275928713"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="275928713"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 15:27:54 -0700
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="558717092"
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
Subject: [net-next 08/14] ptp: mlx4: convert to .adjfine and adjust_by_scaled_ppm
Date:   Thu, 18 Aug 2022 15:27:36 -0700
Message-Id: <20220818222742.1070935-9-jacob.e.keller@intel.com>
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

The mlx4 implementation of .adjfreq is implemented in terms of a
straight forward "base * ppb / 1 billion" calculation.

Convert this driver to .adjfine and use adjust_by_scaled_ppm to perform the
calculation.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Tariq Toukan <tariqt@nvidia.com>
---

I do not have this hardware, and have only compile tested the change.

 drivers/net/ethernet/mellanox/mlx4/en_clock.c | 25 +++++++------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_clock.c b/drivers/net/ethernet/mellanox/mlx4/en_clock.c
index 024788549c25..bea75392087d 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_clock.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_clock.c
@@ -111,34 +111,27 @@ void mlx4_en_ptp_overflow_check(struct mlx4_en_dev *mdev)
 }
 
 /**
- * mlx4_en_phc_adjfreq - adjust the frequency of the hardware clock
+ * mlx4_en_phc_adjfine - adjust the frequency of the hardware clock
  * @ptp: ptp clock structure
- * @delta: Desired frequency change in parts per billion
+ * @delta: Desired frequency change in scaled parts per million
  *
  * Adjust the frequency of the PHC cycle counter by the indicated delta from
  * the base frequency.
+ *
+ * Scaled parts per million is ppm with a 16-bit binary fractional field.
  **/
-static int mlx4_en_phc_adjfreq(struct ptp_clock_info *ptp, s32 delta)
+static int mlx4_en_phc_adjfine(struct ptp_clock_info *ptp, long delta)
 {
-	u64 adj;
-	u32 diff, mult;
-	int neg_adj = 0;
+	u32 mult;
 	unsigned long flags;
 	struct mlx4_en_dev *mdev = container_of(ptp, struct mlx4_en_dev,
 						ptp_clock_info);
 
-	if (delta < 0) {
-		neg_adj = 1;
-		delta = -delta;
-	}
-	mult = mdev->nominal_c_mult;
-	adj = mult;
-	adj *= delta;
-	diff = div_u64(adj, 1000000000ULL);
+	mult = (u32)adjust_by_scaled_ppm(mdev->nominal_c_mult, delta);
 
 	write_seqlock_irqsave(&mdev->clock_lock, flags);
 	timecounter_read(&mdev->clock);
-	mdev->cycles.mult = neg_adj ? mult - diff : mult + diff;
+	mdev->cycles.mult = mult;
 	write_sequnlock_irqrestore(&mdev->clock_lock, flags);
 
 	return 0;
@@ -237,7 +230,7 @@ static const struct ptp_clock_info mlx4_en_ptp_clock_info = {
 	.n_per_out	= 0,
 	.n_pins		= 0,
 	.pps		= 0,
-	.adjfreq	= mlx4_en_phc_adjfreq,
+	.adjfine	= mlx4_en_phc_adjfine,
 	.adjtime	= mlx4_en_phc_adjtime,
 	.gettime64	= mlx4_en_phc_gettime,
 	.settime64	= mlx4_en_phc_settime,
-- 
2.37.1.208.ge72d93e88cb2

