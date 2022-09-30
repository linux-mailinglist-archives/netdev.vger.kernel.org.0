Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 328395F1418
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 22:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbiI3UtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 16:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbiI3Us7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 16:48:59 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D5263FF7
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 13:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664570937; x=1696106937;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Ut8BC77pf0Q/rBrHF5EtiJNeYgrsGDqkPbHRGpJFo+0=;
  b=RgvHvAOX8XU5vGbke45HOQun5gns0xTHJrPk7TSbuJaeo003+mVQM6pi
   2W8eOiL+2hO1g0lAMlabp5d89iL2dSo2mKP4Ig/NoBXU0HWo+5VL2BGQN
   9Cm7ReQ74RSDLFIYkl61KwhSQsYeP1v2LVASDt3c2k6Up0X3B42aHPab1
   FL25ikJQhPDIN1ldSh1p/uew3+IArVHXZAFcTF8EnUTHlHo4YGtYiw9uo
   XGBcFiF0awiZvYYStJ/AFeUJEWc+wV2Hy5wO4dzU4pnKTK6Tx2jvJu7Ra
   j4y/ffqGLKjP+jpBIKuu9R4VsvDkJhi4Y2gjwCbUvC2ulNgXGDk/5qRZe
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="289445984"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="289445984"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 13:48:57 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="691383675"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="691383675"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 13:48:55 -0700
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
Subject: [net-next v2 0/9] ptp: convert drivers to .adjfine
Date:   Fri, 30 Sep 2022 13:48:42 -0700
Message-Id: <20220930204851.1910059-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.37.1.394.gc50926e1f488
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

I previously submitted v1 of this series at [1], and got some feedback only
on a handful of drivers. In the interest of merging the changes which have
received feedback, I've dropped the following drivers out of this send:

 * ptp_phc
 * ptp_ipx46x
 * tg3
 * hclge
 * stmac
 * cpts

I plan to submit those drivers changes again at a later date. As before,
there are some drivers which are not trivial to convert to the new helper
functions. While they may be able to work, their implementation is different
and I lack the hardware or datasheets to determine what the correct
implementation would be.


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

My end goal is to drop the .adjfreq implementation entirely, and to that end
I plan on modifying these drivers in the future to directly use
scaled_ppm_to_ppb as the simplest method to convert them.

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

Jacob Keller (9):
  ptp: add missing documentation for parameters
  ptp: introduce helpers to adjust by scaled parts per million
  drivers: convert unsupported .adjfreq to .adjfine
  ptp: mlx4: convert to .adjfine and adjust_by_scaled_ppm
  ptp: mlx5: convert to .adjfine and adjust_by_scaled_ppm
  ptp: lan743x: remove .adjfreq implementation
  ptp: lan743x: use diff_by_scaled_ppm in .adjfine implementation
  ptp: ravb: convert to .adjfine and adjust_by_scaled_ppm
  ptp: xgbe: convert to .adjfine and adjust_by_scaled_ppm

 drivers/hv/hv_util.c                          |  4 +-
 drivers/net/ethernet/amd/xgbe/xgbe-ptp.c      | 20 ++-----
 drivers/net/ethernet/intel/e1000e/ptp.c       | 16 ++----
 drivers/net/ethernet/intel/i40e/i40e_ptp.c    | 17 ++----
 drivers/net/ethernet/intel/ice/ice_ptp.c      | 18 +------
 drivers/net/ethernet/intel/igb/igb_ptp.c      | 18 +------
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c  | 24 ++-------
 drivers/net/ethernet/mellanox/mlx4/en_clock.c | 29 ++++------
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 22 +++-----
 drivers/net/ethernet/microchip/lan743x_ptp.c  | 54 +++----------------
 drivers/net/ethernet/renesas/ravb_ptp.c       | 17 ++----
 drivers/ptp/ptp_kvm_common.c                  |  4 +-
 drivers/ptp/ptp_vmw.c                         |  4 +-
 include/linux/ptp_clock_kernel.h              | 53 ++++++++++++++++++
 14 files changed, 105 insertions(+), 195 deletions(-)


base-commit: 915b96c52763e2988e6368b538b487a7138b8fa4
-- 
2.37.1.394.gc50926e1f488

