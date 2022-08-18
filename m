Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E845059907F
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 00:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343980AbiHRW2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 18:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241578AbiHRW15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 18:27:57 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C66BDB7D7
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 15:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660861675; x=1692397675;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w6/IiuU+lXWgLNBK1Ibywnsaa0VckO8jW8eCsQKns7k=;
  b=ffoGB2nbpe0Zgop0DGKURyd8uZc1FeQkMW8z49HvODRNVt4sW3LBLEr9
   qcJYPd8yB0WmgzRPkp+MuPWbWdw1IC/DUgp63SVy/AxdB2UDE0e5K9JSb
   0O6ItDT53NTcz+9f/KMMHE8SofWqJ2nN1IRONWF0B1gswQ//Yh+RQQXyD
   2howauGEtEgqeDDz+cM8UJnbdpvJ3Xb6DSAC7RYLCmn3UElF6/RsJf0Gw
   CuSJsghfgfcoI6pkkxto3BpT4zA9dSwZ7D0jI2TA70p+9WQT1hzXjJ5q8
   c+2mK1AhyL3jpI5O3M0EH2X+eJtNel+gSoRLKTlDfnBRb9fv78ZY5OTip
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="292881599"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="292881599"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 15:27:54 -0700
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="558717098"
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
        UNGLinuxDriver@microchip.com
Subject: [net-next 10/14] ptp: lan743x: convert to .adjfine and diff_by_scaled_ppm
Date:   Thu, 18 Aug 2022 15:27:38 -0700
Message-Id: <20220818222742.1070935-11-jacob.e.keller@intel.com>
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

The lan743x implementation of .adjfreq is implemented in terms of a
straight forward "base * ppb / 1 billion" calculation.

Convert this driver to .adjfine and use diff_by_scaled_ppm to calculate the
difference value for the PTP_CLOCK_RATE_ADJ csr.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Bryan Whitehead <bryan.whitehead@microchip.com>
Cc: UNGLinuxDriver@microchip.com
---

I do not have this hardware, and have only compile tested the change.

 drivers/net/ethernet/microchip/lan743x_ptp.c | 28 ++++++++------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.c b/drivers/net/ethernet/microchip/lan743x_ptp.c
index 6a11e2ceb013..a88606236710 100644
--- a/drivers/net/ethernet/microchip/lan743x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan743x_ptp.c
@@ -365,33 +365,27 @@ static int lan743x_ptpci_adjfine(struct ptp_clock_info *ptpci, long scaled_ppm)
 	return 0;
 }
 
-static int lan743x_ptpci_adjfreq(struct ptp_clock_info *ptpci, s32 delta_ppb)
+static int lan743x_ptpci_adjfine(struct ptp_clock_info *ptpci, long delta)
 {
 	struct lan743x_ptp *ptp =
 		container_of(ptpci, struct lan743x_ptp, ptp_clock_info);
 	struct lan743x_adapter *adapter =
 		container_of(ptp, struct lan743x_adapter, ptp);
-	u32 lan743x_rate_adj = 0;
-	bool positive = true;
-	u32 u32_delta = 0;
-	u64 u64_delta = 0;
+	u64 lan743x_rate_adj;
+	s32 delta_ppb;
+	u64 diff;
 
+	delta_ppb = scaled_ppm_to_ppb(delta);
 	if ((delta_ppb < (-LAN743X_PTP_MAX_FREQ_ADJ_IN_PPB)) ||
 	    delta_ppb > LAN743X_PTP_MAX_FREQ_ADJ_IN_PPB) {
 		return -EINVAL;
 	}
-	if (delta_ppb > 0) {
-		u32_delta = (u32)delta_ppb;
-		positive = true;
-	} else {
-		u32_delta = (u32)(-delta_ppb);
-		positive = false;
-	}
-	u64_delta = (((u64)u32_delta) << 35);
-	lan743x_rate_adj = div_u64(u64_delta, 1000000000);
 
-	if (positive)
-		lan743x_rate_adj |= PTP_CLOCK_RATE_ADJ_DIR_;
+	/* diff_by_scaled_ppm returns true if the difference is negative */
+	if (diff_by_scaled_ppm(1ULL << 35, delta, &diff))
+		lan743_rate_adj = (u32)diff;
+	else
+		lan74e_rage_adj = (u32)diff | PTP_CLOCK_RATE_ADJ_DIR_;
 
 	lan743x_csr_write(adapter, PTP_CLOCK_RATE_ADJ,
 			  lan743x_rate_adj);
@@ -1576,7 +1570,7 @@ int lan743x_ptp_open(struct lan743x_adapter *adapter)
 	ptp->ptp_clock_info.pps = LAN743X_PTP_N_PPS;
 	ptp->ptp_clock_info.pin_config = ptp->pin_config;
 	ptp->ptp_clock_info.adjfine = lan743x_ptpci_adjfine;
-	ptp->ptp_clock_info.adjfreq = lan743x_ptpci_adjfreq;
+	ptp->ptp_clock_info.adjfine = lan743x_ptpci_adjfine;
 	ptp->ptp_clock_info.adjtime = lan743x_ptpci_adjtime;
 	ptp->ptp_clock_info.gettime64 = lan743x_ptpci_gettime64;
 	ptp->ptp_clock_info.getcrosststamp = NULL;
-- 
2.37.1.208.ge72d93e88cb2

