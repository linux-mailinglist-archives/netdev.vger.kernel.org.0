Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9A6599079
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 00:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242218AbiHRW16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 18:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbiHRW1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 18:27:55 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1159EDB7CD
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 15:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660861673; x=1692397673;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=z/s7tnImYCK9cprMTx8lSX/Oh2K0in8yqJOs4TsEGNw=;
  b=QkGN4+Q1Vr59btiiu7mKdj/pXk6Ac85Ydht3qf69vTNp7bnRifawwz4T
   b0TDHGjmOD/ta3Dl5gOnA62+GyvNhnDZZHf+vrmj26owOZQinOlIwMDDT
   i+sRXbk4lm9EVVL0VuPXP+IpKON+akCqUIFwdUBhZxqKkARrPFsZ4ErWE
   l5EI+S2IM8i4eoNPga94+MVznslxsLZ4snfjm695SYFL4KwlEiQz35SBo
   RXKdtLzEnpSCChYA6J+0klPTtP1FmKAYSQAs5JOVE5t3v6R0X1GP9CauI
   RCr358mtGQKRzAj+fMbcpCDKSuJ/eIR5wrzPvaEyDJfWligmK9GxIsf1t
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="275928681"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="275928681"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 15:27:52 -0700
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="558717066"
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
Subject: [net-next 00/14] ptp: convert drivers to .adjfine
Date:   Thu, 18 Aug 2022 15:27:28 -0700
Message-Id: <20220818222742.1070935-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.37.1.394.gc50926e1f488
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

Many drivers implementing PTP have not yet migrated to the new .adjfine
frequency adjustment implementation.

A handful of these drivers use hardware with a simple increment value which
is adjusted by multiplying by the adjustment factor and then dividing by
1 billion. This calculation is very easy to convert to .adjfine, by simply
updating the divisor.

Introduce new helper functions, diff_by_scaled_ppm and adjust_by_scaled_ppm
which perform the most common calculations used by drivers for this purpose.

The adjust_by_scaled_ppm takes the base increment and scaled PPM value, and
calculates the new increment to use.

A few drivers need the difference and direction rather than a raw increment
value. The diff_by_scaled_ppm calculates the difference and returns true if
it should be a subtraction, false otherwise. This most closely aligns with
existing driver implementations.

I recently updated all of the Intel drivers to the same calculation which is
now factored out into the two helper functions. These drivers are all
migrated in one change with the introduction of the helper functions.

The other driver changes are separated out. I do not have access to the
hardware necessary to test these, so they've only been compile tested. The
conversion is straight forward, but I expect driver maintainers will want to
test these changes appropriately. I've done my best to Cc relevant
maintainers on the cover letter and the appropriate change.

With this applied, there are still a handful of remaining drivers which are
not yet converted including:

 * drivers/net/ethernet/broadcom/bnx2x
 * drivers/net/ethernet/broadcom/bnxt
 * drivers/net/ethernet/cavium/liquidio
 * drivers/net/ethernet/chelsio/cxgb4
 * drivers/net/ethernet/freescale
 * drivers/net/ethernet/qlogic/qed
 * drivers/net/ethernet/qlogic/qede
 * drivers/net/ethernet/sfc
 * drivers/net/ethernet/sfc/siena
 * drivers/net/ethernet/ti/am65-cpts.c
 * drivers/ptp/ptp_dte.c

These drivers use varying calculation methods which are not directly
compatible with the adjust_by_scaled_ppm method. I lack access to the
hardware and knowledge of its implementation to convert them directly to
using scaled parts per million. Instead, I plan to follow up this series
with one which converts the remaining drivers to .adjfine by using
scaled_ppm_to_ppb in their .adjfine implementation. This will then allow
dropping the .adjfreq interface from the ptp_clock_info interface.

Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Siva Reddy Kallam <siva.kallam@broadcom.com>
Cc: Prashant Sreedharan <prashant@broadcom.com>
Cc: Michael Chan <mchan@broadcom.com>
Cc: Yisen Zhuang <yisen.zhuang@huawei.com>
Cc: Salil Mehta <salil.mehta@huawei.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: Tariq Toukan <tariqt@nvidia.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Bryan Whitehead <bryan.whitehead@microchip.com>
Cc: Sergey Shtylyov <s.shtylyov@omp.ru>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Vivek Thampi <vithampi@vmware.com>
Cc: VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Cc: Jie Wang <wangjie125@huawei.com>
Cc: Jacob Keller <jacob.e.keller@intel.com>
Cc: Guangbin Huang <huangguangbin2@huawei.com>
Cc: Eran Ben Elisha <eranbe@nvidia.com>
Cc: Aya Levin <ayal@nvidia.com>
Cc: Cai Huoqing <cai.huoqing@linux.dev>
Cc: Biju Das <biju.das.jz@bp.renesas.com>
Cc: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc: Phil Edworthy <phil.edworthy@renesas.com>
Cc: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Wan Jiabing <wanjiabing@vivo.com>
Cc: Lv Ruyi <lv.ruyi@zte.com.cn>
Cc: Arnd Bergmann <arnd@arndb.de>

Jacob Keller (14):
  ptp: add missing documentation for parameters
  ptp: introduce helpers to adjust by scaled parts per million
  drivers: convert unsupported .adjfreq to .adjfine
  ptp_phc: convert to .adjfine and ptp_adj_scaled_ppm
  ptp_ixp46x: convert to .adjfine and adjust_by_scaled_ppm
  ptp: tg3: convert to .adjfine and diff_by_scaled_ppm
  ptp: hclge: convert to .adjfine and adjust_by_scaled_ppm
  ptp: mlx4: convert to .adjfine and adjust_by_scaled_ppm
  ptp: mlx5: convert to .adjfine and adjust_by_scaled_ppm
  ptp: lan743x: convert to .adjfine and diff_by_scaled_ppm
  ptp: ravb: convert to .adjfine and adjust_by_scaled_ppm
  ptp: stmac: convert to .adjfine and adjust_by_scaled_ppm
  ptp: cpts: convert to .adjfine and adjust_by_scaled_ppm
  ptp: xgbe: convert to .adjfine and adjust_by_scaled_ppm

 drivers/hv/hv_util.c                          |  4 +-
 drivers/net/ethernet/amd/xgbe/xgbe-ptp.c      | 20 ++-----
 drivers/net/ethernet/broadcom/tg3.c           | 22 ++++----
 .../hisilicon/hns3/hns3pf/hclge_ptp.c         | 22 ++------
 drivers/net/ethernet/intel/e1000e/ptp.c       | 16 ++----
 drivers/net/ethernet/intel/i40e/i40e_ptp.c    | 17 ++----
 drivers/net/ethernet/intel/ice/ice_ptp.c      | 18 +------
 drivers/net/ethernet/intel/igb/igb_ptp.c      | 18 +------
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c  | 24 ++-------
 drivers/net/ethernet/mellanox/mlx4/en_clock.c | 25 ++++-----
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 22 +++-----
 drivers/net/ethernet/microchip/lan743x_ptp.c  | 28 ++++------
 drivers/net/ethernet/renesas/ravb_ptp.c       | 16 ++----
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.c  | 23 +++-----
 drivers/net/ethernet/ti/cpts.c                | 21 +++-----
 drivers/net/ethernet/xscale/ptp_ixp46x.c      | 19 ++-----
 drivers/ptp/ptp_kvm_common.c                  |  4 +-
 drivers/ptp/ptp_pch.c                         | 19 ++-----
 drivers/ptp/ptp_vmw.c                         |  4 +-
 include/linux/ptp_clock_kernel.h              | 53 +++++++++++++++++++
 20 files changed, 143 insertions(+), 252 deletions(-)


base-commit: 9017462f006c4b686cb1e1e1a3a52ea8363076e6
-- 
2.37.1.208.ge72d93e88cb2

