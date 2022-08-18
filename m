Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E26A59908A
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 00:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244729AbiHRW2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 18:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbiHRW15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 18:27:57 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE93DB7D8
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 15:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660861675; x=1692397675;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UlDC8+4FWhHq/k0QzZnS68NRTjoSRcw0yJR5+rkKiw4=;
  b=N462yT6Y4YKrpNE+MYzm6CY+U+xjn+ly+Sd5ez4/xTvptrm0utOFwch5
   5x0FQTdKhUJxAWgc5VdGcbJv8FFUya4t+O4VnUm2sMSJYlKUZS2GMM/I/
   v9+l+CHba+IzZW+5qKl+ugY/lnkxDgq8x4oHqqxHalSoYtsIbKC5Xf6p7
   xx/y+c11e2964ACyQo3r3DAxZWCAUGkvXvmAkk1ORe7KMi/PBnC7/1KeZ
   umyagUwbFYEZpejdFOHEq11CemusXH8+XMTxDhu5DwnjFji3qU+ui8iBT
   1ZfbFJoJdl65xXgou2fGZD+wpe2yvFBNRXd+Q+/o2VBpSHXZJ/1C9tSFZ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="275928691"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="275928691"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 15:27:53 -0700
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="558717076"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 15:27:52 -0700
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
Subject: [net-next 03/14] drivers: convert unsupported .adjfreq to .adjfine
Date:   Thu, 18 Aug 2022 15:27:31 -0700
Message-Id: <20220818222742.1070935-4-jacob.e.keller@intel.com>
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

A few PTP drivers implement a .adjfreq handler which indicates the
operation is not supported. Convert all of these to .adjfine.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Vivek Thampi <vithampi@vmware.com>
---

I've only compile tested these changes, but its a very straight forward
conversion because they all just return -EOPNOTUSPP.

 drivers/hv/hv_util.c         | 4 ++--
 drivers/ptp/ptp_kvm_common.c | 4 ++--
 drivers/ptp/ptp_vmw.c        | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
index 835e6039c186..d776074b49cb 100644
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -706,7 +706,7 @@ static int hv_ptp_settime(struct ptp_clock_info *p, const struct timespec64 *ts)
 	return -EOPNOTSUPP;
 }
 
-static int hv_ptp_adjfreq(struct ptp_clock_info *ptp, s32 delta)
+static int hv_ptp_adjfine(struct ptp_clock_info *ptp, long delta)
 {
 	return -EOPNOTSUPP;
 }
@@ -724,7 +724,7 @@ static struct ptp_clock_info ptp_hyperv_info = {
 	.name		= "hyperv",
 	.enable         = hv_ptp_enable,
 	.adjtime        = hv_ptp_adjtime,
-	.adjfreq        = hv_ptp_adjfreq,
+	.adjfine        = hv_ptp_adjfine,
 	.gettime64      = hv_ptp_gettime,
 	.settime64      = hv_ptp_settime,
 	.owner		= THIS_MODULE,
diff --git a/drivers/ptp/ptp_kvm_common.c b/drivers/ptp/ptp_kvm_common.c
index fcae32f56f25..9141162c4237 100644
--- a/drivers/ptp/ptp_kvm_common.c
+++ b/drivers/ptp/ptp_kvm_common.c
@@ -66,7 +66,7 @@ static int ptp_kvm_getcrosststamp(struct ptp_clock_info *ptp,
  * PTP clock operations
  */
 
-static int ptp_kvm_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+static int ptp_kvm_adjfine(struct ptp_clock_info *ptp, long delta)
 {
 	return -EOPNOTSUPP;
 }
@@ -115,7 +115,7 @@ static const struct ptp_clock_info ptp_kvm_caps = {
 	.n_ext_ts	= 0,
 	.n_pins		= 0,
 	.pps		= 0,
-	.adjfreq	= ptp_kvm_adjfreq,
+	.adjfine	= ptp_kvm_adjfine,
 	.adjtime	= ptp_kvm_adjtime,
 	.gettime64	= ptp_kvm_gettime,
 	.settime64	= ptp_kvm_settime,
diff --git a/drivers/ptp/ptp_vmw.c b/drivers/ptp/ptp_vmw.c
index 5dca26e14bdc..d64eec5b1788 100644
--- a/drivers/ptp/ptp_vmw.c
+++ b/drivers/ptp/ptp_vmw.c
@@ -47,7 +47,7 @@ static int ptp_vmw_adjtime(struct ptp_clock_info *info, s64 delta)
 	return -EOPNOTSUPP;
 }
 
-static int ptp_vmw_adjfreq(struct ptp_clock_info *info, s32 delta)
+static int ptp_vmw_adjfine(struct ptp_clock_info *info, long delta)
 {
 	return -EOPNOTSUPP;
 }
@@ -79,7 +79,7 @@ static struct ptp_clock_info ptp_vmw_clock_info = {
 	.name		= "ptp_vmw",
 	.max_adj	= 0,
 	.adjtime	= ptp_vmw_adjtime,
-	.adjfreq	= ptp_vmw_adjfreq,
+	.adjfine	= ptp_vmw_adjfine,
 	.gettime64	= ptp_vmw_gettime,
 	.settime64	= ptp_vmw_settime,
 	.enable		= ptp_vmw_enable,
-- 
2.37.1.208.ge72d93e88cb2

