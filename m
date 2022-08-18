Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9265359907B
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 00:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245116AbiHRW2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 18:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244748AbiHRW2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 18:28:06 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97970DB7E4
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 15:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660861682; x=1692397682;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fuVDK3sMUgX3j2OZCgfJ0rKID0sx+515Qo7cHMyPVFI=;
  b=P85J9UTr8QePDO2NXa6iZvn1sw51fBL1EgB/ZaKVN74RaIodIYC54iM4
   llzZ6qdZNcDno5uqP0xSZ1s9xjhJJA3GxZU/YNFhuuWMvncprXcYG2HVF
   Sujm0fo5P6qwkQMuhYlj5s0RsRd27p2tuq0eWIchUM2U54Eje0O0zMW+Y
   RrC7rQME4VeZxoswfgRPXPVeWKKcOgmdttH+/gyZ16n/DW6px08lxmqUU
   dBJQuRWp4DPln1bRWGokGYqKymHLR+K677vvRONTwSfVPs/xJ5hE56err
   TQkiz37K0O0QPDxC48ROjOnAOJTb83BiivZhQ+JLxvjDcPKaqadJgI3Na
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="292881609"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="292881609"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 15:27:55 -0700
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="558717111"
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
Subject: [net-next 14/14] ptp: xgbe: convert to .adjfine and adjust_by_scaled_ppm
Date:   Thu, 18 Aug 2022 15:27:42 -0700
Message-Id: <20220818222742.1070935-15-jacob.e.keller@intel.com>
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

The xgbe implementation of .adjfreq is implemented in terms of a
straight forward "base * ppb / 1 billion" calculation.

Convert this driver to .adjfine and use adjust_by_scaled_ppm to calculate
the new addend value.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
---

I do not have this hardware, and have only compile tested the change.

 drivers/net/ethernet/amd/xgbe/xgbe-ptp.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-ptp.c b/drivers/net/ethernet/amd/xgbe/xgbe-ptp.c
index d06d260cf1e2..7051bd7cf6dc 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-ptp.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-ptp.c
@@ -134,27 +134,15 @@ static u64 xgbe_cc_read(const struct cyclecounter *cc)
 	return nsec;
 }
 
-static int xgbe_adjfreq(struct ptp_clock_info *info, s32 delta)
+static int xgbe_adjfine(struct ptp_clock_info *info, long scaled_ppm)
 {
 	struct xgbe_prv_data *pdata = container_of(info,
 						   struct xgbe_prv_data,
 						   ptp_clock_info);
 	unsigned long flags;
-	u64 adjust;
-	u32 addend, diff;
-	unsigned int neg_adjust = 0;
+	u64 addend;
 
-	if (delta < 0) {
-		neg_adjust = 1;
-		delta = -delta;
-	}
-
-	adjust = pdata->tstamp_addend;
-	adjust *= delta;
-	diff = div_u64(adjust, 1000000000UL);
-
-	addend = (neg_adjust) ? pdata->tstamp_addend - diff :
-				pdata->tstamp_addend + diff;
+	addend = adjust_by_scaled_ppm(pdata->tstamp_addend, scaled_ppm);
 
 	spin_lock_irqsave(&pdata->tstamp_lock, flags);
 
@@ -235,7 +223,7 @@ void xgbe_ptp_register(struct xgbe_prv_data *pdata)
 		 netdev_name(pdata->netdev));
 	info->owner = THIS_MODULE;
 	info->max_adj = pdata->ptpclk_rate;
-	info->adjfreq = xgbe_adjfreq;
+	info->adjfine = xgbe_adjfine;
 	info->adjtime = xgbe_adjtime;
 	info->gettime64 = xgbe_gettime;
 	info->settime64 = xgbe_settime;
-- 
2.37.1.208.ge72d93e88cb2

