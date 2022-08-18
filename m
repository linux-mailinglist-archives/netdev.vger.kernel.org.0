Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2D1599086
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 00:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344086AbiHRW2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 18:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242563AbiHRW16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 18:27:58 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5402DDB7D1
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 15:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660861677; x=1692397677;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=29sMKDgdOw0G+a9mXLZQMmoVXZ37wpTh6gAl+2/CrOU=;
  b=PX7SS5kAWTpjKp2e0KPJfiYai9u56/kw7/h7xWt5janycOM6QVIFxA0D
   Zh+ndFyTq2W6jyxZJHnVhqtjjYxBT4uuG0PEqCAn6Y+mquuF3cOYmOye2
   lbJ2JvHfVflEAwIxONZsAYTF1zBz4nDl1WWe+W17opSZjH4/pE0p4zDcR
   DNHdbx8brISF1CUqw5+7dzrsl+1isxkG4bqfRhl3t866+TeVF8YkgGy+u
   CpFrSzXDi18n2aOjq0uYtN0IZAJzjCLkZ6tUBV/kSgMFZDFqcukd/ld8w
   eTftvUujCU30PNvYl/VjwPevUvgqVi0v5O+qPSHooHcB6Q4+bfbzeJdLh
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="275928708"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="275928708"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 15:27:53 -0700
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="558717089"
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
Subject: [net-next 07/14] ptp: hclge: convert to .adjfine and adjust_by_scaled_ppm
Date:   Thu, 18 Aug 2022 15:27:35 -0700
Message-Id: <20220818222742.1070935-8-jacob.e.keller@intel.com>
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

The hclge implementation of .adjfreq is implemented in terms of a
straight forward "base * ppb / 1 billion" calculation.

Convert this driver to the .adjfine implementation and use
adjust_by_scaled_ppm to calculate the new adjustment value.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Yisen Zhuang <yisen.zhuang@huawei.com>
Cc: Salil Mehta <salil.mehta@huawei.com>
Cc: Jie Wang <wangjie125@huawei.com>
---

I do not have this hardware, and have only compile tested the change.

 .../hisilicon/hns3/hns3pf/hclge_ptp.c         | 22 +++++--------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
index a40b1583f114..80a2a0073d97 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
@@ -22,28 +22,16 @@ static int hclge_ptp_get_cycle(struct hclge_dev *hdev)
 	return 0;
 }
 
-static int hclge_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+static int hclge_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct hclge_dev *hdev = hclge_ptp_get_hdev(ptp);
 	struct hclge_ptp_cycle *cycle = &hdev->ptp->cycle;
-	u64 adj_val, adj_base, diff;
+	u64 adj_val, adj_base;
 	unsigned long flags;
-	bool is_neg = false;
 	u32 quo, numerator;
 
-	if (ppb < 0) {
-		ppb = -ppb;
-		is_neg = true;
-	}
-
 	adj_base = (u64)cycle->quo * (u64)cycle->den + (u64)cycle->numer;
-	adj_val = adj_base * ppb;
-	diff = div_u64(adj_val, 1000000000ULL);
-
-	if (is_neg)
-		adj_val = adj_base - diff;
-	else
-		adj_val = adj_base + diff;
+	adj_val = adjust_by_scaled_ppm(adj_base, scaled_ppm);
 
 	/* This clock cycle is defined by three part: quotient, numerator
 	 * and denominator. For example, 2.5ns, the quotient is 2,
@@ -446,7 +434,7 @@ static int hclge_ptp_create_clock(struct hclge_dev *hdev)
 	ptp->info.max_adj = HCLGE_PTP_CYCLE_ADJ_MAX;
 	ptp->info.n_ext_ts = 0;
 	ptp->info.pps = 0;
-	ptp->info.adjfreq = hclge_ptp_adjfreq;
+	ptp->info.adjfine = hclge_ptp_adjfine;
 	ptp->info.adjtime = hclge_ptp_adjtime;
 	ptp->info.gettimex64 = hclge_ptp_gettimex;
 	ptp->info.settime64 = hclge_ptp_settime;
@@ -504,7 +492,7 @@ int hclge_ptp_init(struct hclge_dev *hdev)
 		goto out;
 
 	set_bit(HCLGE_PTP_FLAG_EN, &hdev->ptp->flags);
-	ret = hclge_ptp_adjfreq(&hdev->ptp->info, 0);
+	ret = hclge_ptp_adjfine(&hdev->ptp->info, 0);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"failed to init freq, ret = %d\n", ret);
-- 
2.37.1.208.ge72d93e88cb2

