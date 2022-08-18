Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55CF659907D
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 00:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344485AbiHRW2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 18:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbiHRW17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 18:27:59 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549CEDB7DA
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 15:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660861677; x=1692397677;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N3xYETlH/lk4y+Qv74GWZa9UPoyeeG6r6TJ/CzgH7DM=;
  b=E5MMIjy42BBlAoQEAwxmzyiIlc6IMb5QQjGPslRV70RxxC7CVEI7diba
   YoKv2aWfFdJ2F0MPXI58fBtlJe5PJdcw9PffiPeGXRYYWWvG/GKGy4fWJ
   Kwqiv/f8rnfkBDcxjmQzrI08Q0w0UUHmpgeCjv2tjAXe4MYlbo5u/EYlh
   EmblZ9pXTdKzLuICJDmrWlb+1UNxTHgIDm2c/V9ItiQHuJUry1ym93Lps
   YgqqJrS5MCf761Bbi4AdpIx1bGug565W7s3QcxEZTpV1pZGzv6vjHnJhu
   qurBqzmkf2qHKvfVewt3erTGUgiHhQPVQb3o2+h9WhToJg72sGludDaDu
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="275928705"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="275928705"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 15:27:53 -0700
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="558717086"
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
Subject: [net-next 06/14] ptp: tg3: convert to .adjfine and diff_by_scaled_ppm
Date:   Thu, 18 Aug 2022 15:27:34 -0700
Message-Id: <20220818222742.1070935-7-jacob.e.keller@intel.com>
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

The tg3 implementation of .adjfreq is implemented in terms of a
straight forward "base * ppb / 1 billion" calculation.

Convert this driver to the .adjfine implementation, and use
diff_by_scaled_ppm to calculate the correction value.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Siva Reddy Kallam <siva.kallam@broadcom.com>
Cc: Prashant Sreedharan <prashant@broadcom.com>
Cc: Michael Chan <mchan@broadcom.com>
---

I do not have this hardware, and have only compile tested this change.

 drivers/net/ethernet/broadcom/tg3.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index db1e9d810b41..c5dcbd83ae66 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -6179,27 +6179,23 @@ static int tg3_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
 	return 0;
 }
 
-static int tg3_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+static int tg3_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct tg3 *tp = container_of(ptp, struct tg3, ptp_info);
-	bool neg_adj = false;
-	u32 correction = 0;
-
-	if (ppb < 0) {
-		neg_adj = true;
-		ppb = -ppb;
-	}
+	u32 correction;
+	bool neg_adj;
+	u64 diff;
 
 	/* Frequency adjustment is performed using hardware with a 24 bit
 	 * accumulator and a programmable correction value. On each clk, the
 	 * correction value gets added to the accumulator and when it
 	 * overflows, the time counter is incremented/decremented.
 	 *
-	 * So conversion from ppb to correction value is
-	 *		ppb * (1 << 24) / 1000000000
+	 * So conversion from scaled_ppm to correction value is
+	 *		(1 << 24) * scaled_ppm / (1000000 << 16)
 	 */
-	correction = div_u64((u64)ppb * (1 << 24), 1000000000ULL) &
-		     TG3_EAV_REF_CLK_CORRECT_MASK;
+	neg_adj = diff_by_scaled_ppm(1 << 24, scaled_ppm, &diff);
+	correction = diff & TG3_EAV_REF_CLK_CORRECT_MASK;
 
 	tg3_full_lock(tp, 0);
 
@@ -6330,7 +6326,7 @@ static const struct ptp_clock_info tg3_ptp_caps = {
 	.n_per_out	= 1,
 	.n_pins		= 0,
 	.pps		= 0,
-	.adjfreq	= tg3_ptp_adjfreq,
+	.adjfine	= tg3_ptp_adjfine,
 	.adjtime	= tg3_ptp_adjtime,
 	.gettimex64	= tg3_ptp_gettimex,
 	.settime64	= tg3_ptp_settime,
-- 
2.37.1.208.ge72d93e88cb2

