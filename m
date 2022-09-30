Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980205F141D
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 22:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbiI3UtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 16:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232161AbiI3UtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 16:49:04 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D7063FF2
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 13:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664570942; x=1696106942;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3Hu+Gtt6+LmYGSMBBIPhfanU4zssRd6VKNRzdFzK7jo=;
  b=aBCeXt7GptP1uKetx4mLuvEkXqZTN5Y04bm1XcdCs5bwsXmF6eDX4sOO
   6GVukHwrBMSI4eX7DvjVn69ykKSdOPt32EjndvF9wgwvsK/1FZ7SyXzuB
   OGzF36A+p3Q8lcft4/PQX+53QFoDZjDZ+BztHGnjsyIwet5NeLb/zrau/
   7VYHojV4PFQFuiozHhzIKubW6MJJYiIEcjIqxiaaIYSApff+a6LLYcWF3
   v/kBFIrteM6tEAA/jCSNpPyfT26CLM2XbD/rG0pNBtmN6IpvtvuMy9ken
   EgcrhccUY8At8RiqpCnOxW1ChajDZJLMdXxTMGAglli9DGGzbBgnC0mD9
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="289445997"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="289445997"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 13:49:02 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="691383704"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="691383704"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 13:49:01 -0700
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
        UNGLinuxDriver@microchip.com
Subject: [net-next v2 6/9] ptp: lan743x: remove .adjfreq implementation
Date:   Fri, 30 Sep 2022 13:48:48 -0700
Message-Id: <20220930204851.1910059-7-jacob.e.keller@intel.com>
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

The lan743x driver implements both .adjfreq and .adjfine, but the core PTP
subsystem prefers .adjfine if implemented. There is no reason to carry a
.adjfreq implementation, so we can remove it.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Bryan Whitehead <bryan.whitehead@microchip.com>
Cc: UNGLinuxDriver@microchip.com
---
 drivers/net/ethernet/microchip/lan743x_ptp.c | 35 --------------------
 1 file changed, 35 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.c b/drivers/net/ethernet/microchip/lan743x_ptp.c
index 6a11e2ceb013..130f88b77cfe 100644
--- a/drivers/net/ethernet/microchip/lan743x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan743x_ptp.c
@@ -365,40 +365,6 @@ static int lan743x_ptpci_adjfine(struct ptp_clock_info *ptpci, long scaled_ppm)
 	return 0;
 }
 
-static int lan743x_ptpci_adjfreq(struct ptp_clock_info *ptpci, s32 delta_ppb)
-{
-	struct lan743x_ptp *ptp =
-		container_of(ptpci, struct lan743x_ptp, ptp_clock_info);
-	struct lan743x_adapter *adapter =
-		container_of(ptp, struct lan743x_adapter, ptp);
-	u32 lan743x_rate_adj = 0;
-	bool positive = true;
-	u32 u32_delta = 0;
-	u64 u64_delta = 0;
-
-	if ((delta_ppb < (-LAN743X_PTP_MAX_FREQ_ADJ_IN_PPB)) ||
-	    delta_ppb > LAN743X_PTP_MAX_FREQ_ADJ_IN_PPB) {
-		return -EINVAL;
-	}
-	if (delta_ppb > 0) {
-		u32_delta = (u32)delta_ppb;
-		positive = true;
-	} else {
-		u32_delta = (u32)(-delta_ppb);
-		positive = false;
-	}
-	u64_delta = (((u64)u32_delta) << 35);
-	lan743x_rate_adj = div_u64(u64_delta, 1000000000);
-
-	if (positive)
-		lan743x_rate_adj |= PTP_CLOCK_RATE_ADJ_DIR_;
-
-	lan743x_csr_write(adapter, PTP_CLOCK_RATE_ADJ,
-			  lan743x_rate_adj);
-
-	return 0;
-}
-
 static int lan743x_ptpci_adjtime(struct ptp_clock_info *ptpci, s64 delta)
 {
 	struct lan743x_ptp *ptp =
@@ -1576,7 +1542,6 @@ int lan743x_ptp_open(struct lan743x_adapter *adapter)
 	ptp->ptp_clock_info.pps = LAN743X_PTP_N_PPS;
 	ptp->ptp_clock_info.pin_config = ptp->pin_config;
 	ptp->ptp_clock_info.adjfine = lan743x_ptpci_adjfine;
-	ptp->ptp_clock_info.adjfreq = lan743x_ptpci_adjfreq;
 	ptp->ptp_clock_info.adjtime = lan743x_ptpci_adjtime;
 	ptp->ptp_clock_info.gettime64 = lan743x_ptpci_gettime64;
 	ptp->ptp_clock_info.getcrosststamp = NULL;
-- 
2.37.1.394.gc50926e1f488

