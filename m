Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB95A59907C
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 00:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344546AbiHRW2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 18:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243279AbiHRW2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 18:28:01 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E99DB7DC
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 15:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660861677; x=1692397677;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LXS3mqU5Cy4jtqEFU2fNU51Edunywo4W7t5oxTsSHMQ=;
  b=gf5DsDqkpB9D2i2fx200ywyouDfOJI8Xqm/JbGcNmQ+hlg0v9GK+GjEA
   ozESA4aeewRtWy6Wl583eG77O1zGdYKX0IWml9vp7a8GhYw0XxhBHpkYj
   AXaiRYE/a1Pq0GeTEJjlId3wXf+AQWuRe5o262T9oAtp7a2blZO4jDXw/
   ZLn5FTgwbugsrV0UFL2O3hknYm6hkLQdYOLq3Z5pCpU5a3/HGKojJFSSD
   6WR8MxNXwbFgANwLjGu+DawrTu7CMvvCYaS8UBt5+BYI9McaY5DHO4PlT
   I17ReHXWhFLdvnVFYBlGxZwQd5PvMhqlqGoD4IU132G3VXqnADqohGLkC
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="292881607"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="292881607"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 15:27:54 -0700
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="558717105"
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
Subject: [net-next 12/14] ptp: stmac: convert to .adjfine and adjust_by_scaled_ppm
Date:   Thu, 18 Aug 2022 15:27:40 -0700
Message-Id: <20220818222742.1070935-13-jacob.e.keller@intel.com>
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

The stmac implementation of .adjfreq is implemented in terms of a
straight forward "base * ppb / 1 billion" calculation.

Convert this driver to .adjfine and use the adjust_by_scaled_ppm helper
function to perform the calculation of the new addend.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
---

I do not have this hardware, and have only compile tested the change.

 .../net/ethernet/stmicro/stmmac/stmmac_ptp.c  | 23 ++++++-------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index 4d11980dcd64..0d5e6819ee5d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -15,29 +15,20 @@
  * stmmac_adjust_freq
  *
  * @ptp: pointer to ptp_clock_info structure
- * @ppb: desired period change in parts ber billion
+ * @scaled_ppm: desired period change in scaled parts per million
  *
  * Description: this function will adjust the frequency of hardware clock.
+ *
+ * Scaled parts per million is ppm with a 16-bit binary fractional field.
  */
-static int stmmac_adjust_freq(struct ptp_clock_info *ptp, s32 ppb)
+static int stmmac_adjust_freq(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct stmmac_priv *priv =
 	    container_of(ptp, struct stmmac_priv, ptp_clock_ops);
 	unsigned long flags;
-	u32 diff, addend;
-	int neg_adj = 0;
-	u64 adj;
+	u32 addend;
 
-	if (ppb < 0) {
-		neg_adj = 1;
-		ppb = -ppb;
-	}
-
-	addend = priv->default_addend;
-	adj = addend;
-	adj *= ppb;
-	diff = div_u64(adj, 1000000000ULL);
-	addend = neg_adj ? (addend - diff) : (addend + diff);
+	addend = (u32)adjust_by_scaled_ppm(priv->default_addend, scaled_ppm);
 
 	write_lock_irqsave(&priv->ptp_lock, flags);
 	stmmac_config_addend(priv, priv->ptpaddr, addend);
@@ -269,7 +260,7 @@ static struct ptp_clock_info stmmac_ptp_clock_ops = {
 	.n_per_out = 0, /* will be overwritten in stmmac_ptp_register */
 	.n_pins = 0,
 	.pps = 0,
-	.adjfreq = stmmac_adjust_freq,
+	.adjfine = stmmac_adjust_freq,
 	.adjtime = stmmac_adjust_time,
 	.gettime64 = stmmac_get_time,
 	.settime64 = stmmac_set_time,
-- 
2.37.1.208.ge72d93e88cb2

