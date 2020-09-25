Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D699279416
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 00:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgIYWY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 18:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgIYWY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 18:24:59 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F0AC0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 15:24:58 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id q4so209780pjh.5
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 15:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h+Q8oFyfs4WUGKzvg1la32HUha2+K3bNYVpsVhmE6bk=;
        b=hZB/Q/btxXcZVqG6WumfqzCve+wdvXUa+nYWiY6uvDqsF6PQ3TCpG+jFLQI6ib2dq1
         nPWz9aj/tw+L4nRoZpQCyueFc+gO6hik23Sg9tes1cpK7xl8Bz/bTjifp60wXIKRaM1Q
         VpVPxjI9XxnJFHU9+t7hx5DeymC/HYSjeS9nEY2ubmHaZX6tUm0gUL/VDyPEsUN+dlst
         Yqh+Utc+TeS3/WPk8hGRWFhYLzJkVst89LLPNq6kcgeVa/RfBP7VxKOo8cZvVlVn3KMo
         cVJbmkYkdwIxIoo+S3DxlnLYLPwkFRHRiXDz6Sn7s6eTqLNxAWlK3f1mLT7S0R48pLvH
         xiDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h+Q8oFyfs4WUGKzvg1la32HUha2+K3bNYVpsVhmE6bk=;
        b=BjhDFXZDLFDP6YyCJfpZW3gBxErTSpPRTrhoctKRK+6Fo+FU4UKS7k+GNs7vjwIaQ+
         ERRYscYbUdeWHdOtw9NuucAhfIm4sEdd9VsIydN5MVfmJgXhBdPu9myxjfLKZV1WqblO
         XZraDq2hCCPBET8v8uKhvVsI6/7cuVJjshgK0rEuFhEmprTuKttWcO+Fq5mCMV2/gW0e
         yU4Rvh1tUx0nAhcQVixlAqAiuJBoX3WazS710P+u5QOdzG/2BgyGZL3i/CvOEUiIsrD1
         CvxoAzOa6QahstQl2ipUnlq89+jSb5B7DUrzUQfNMpnPYVcNkVJUD4GYMFWO+Gp3YA9m
         fBWg==
X-Gm-Message-State: AOAM531tmnERoBfn9tyGqnSvx/gRvMKd98W99m6+Tb08JItRaI3qZWvW
        J+UYW1CSmOZvgSFl9uHOXPuTueuUwBL4dQeN
X-Google-Smtp-Source: ABdhPJyDptgmyc9AkeaAhMq7tNkSjwPH/1Sm5Uiaq8s93J1scv1PJwuMr1HIGgkCAJd+kO3CaKd/uA==
X-Received: by 2002:a17:90a:b118:: with SMTP id z24mr590231pjq.220.1601072697889;
        Fri, 25 Sep 2020 15:24:57 -0700 (PDT)
Received: from jesse-ThinkPad-T570.lan (50-39-107-76.bvtn.or.frontiernet.net. [50.39.107.76])
        by smtp.gmail.com with ESMTPSA id q15sm169343pje.29.2020.09.25.15.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 15:24:57 -0700 (PDT)
From:   Jesse Brandeburg <jesse.brandeburg@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@gmail.com>,
        intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>
Subject: [PATCH net-next v3 0/9] make drivers/net/ethernet W=1 clean
Date:   Fri, 25 Sep 2020 15:24:36 -0700
Message-Id: <20200925222445.74531-1-jesse.brandeburg@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The Goal: move to W=1 being default for drivers/net/ethernet, and
then use automation to catch more code issues (warnings) being
introduced.
The status: Getting much closer but not quite done for all
architectures.

After applying the patches below, the drivers/net/ethernet
directory can be built as modules with W=1 with no warnings (so
far on x64_64 arch only!). As Jakub pointed out, there is much
more work to do to clean up C=1, but that will be another series
of changes.

This series removes 1,247 warnings and hopefully allows the
ethernet directory to move forward from here without more
warnings being added. There is only one objtool warning now.

This version drops one of the Intel patches, as I couldn't
reproduce the original issue to document the warning.

Some of these patches are already sent and tested on Intel Wired
Lan, but the rest of the series titled drivers/net/ethernet
affects other drivers. The changes are all pretty
straightforward.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Saeed Mahameed <saeed@kernel.org>
---

DaveM: if you want to apply all the intel driver changes
       directly please go ahead.

As part of testing this series I realized that I have ~1,500 more
kdoc warnings to fix due to being in other arch or not compiled
with my x86_64 .config. Feel free to run
$ git ls-files *.[ch] | grep drivers/net/ethernet | xargs scripts/kernel-doc -none
to see the remaining issues.

changes in v3:
	- addressed comments, updated commit messages with
	  warnings noted, updated 9/9 with a few extras that
	  snuck in while I was working, dropped a patch that
	  I couldn't identify the original warning for.
changes in v2:
	- non-rfc
	- addressed list comments from Edward Cree, Jacob Keller and
	  Vinicius Costa Gomes
	- re-split the Intel patches into functional and kdoc only
	- split out the sfc changes that generated discussion to
	  a single patch.


Jesse Brandeburg (9):
  intel-ethernet: clean up W=1 warnings in kdoc
  intel: handle unused assignments
  drivers/net/ethernet: clean up unused assignments
  drivers/net/ethernet: rid ethernet of no-prototype warnings
  drivers/net/ethernet: handle one warning explicitly
  drivers/net/ethernet: add some basic kdoc tags
  drivers/net/ethernet: remove incorrectly formatted doc
  sfc: fix kdoc warning
  drivers/net/ethernet: clean up mis-targeted comments

 drivers/net/ethernet/amazon/ena/ena_com.c     |   2 +-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |   2 +-
 drivers/net/ethernet/arc/emac_arc.c           |   2 +-
 .../net/ethernet/atheros/atl1c/atl1c_main.c   |   6 +-
 .../net/ethernet/atheros/atl1e/atl1e_main.c   |   7 +-
 drivers/net/ethernet/atheros/atlx/atl1.c      |   2 +-
 drivers/net/ethernet/atheros/atlx/atl2.c      |   6 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |   2 +
 .../ethernet/broadcom/bnx2x/bnx2x_ethtool.c   |   6 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  12 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_sp.c    |  98 ++---
 drivers/net/ethernet/brocade/bna/bfa_cee.c    |  20 +-
 drivers/net/ethernet/brocade/bna/bfa_ioc.c    |   8 +-
 drivers/net/ethernet/brocade/bna/bnad.c       |   7 +-
 drivers/net/ethernet/cadence/macb_main.c      |   6 +-
 drivers/net/ethernet/cadence/macb_pci.c       |   2 +-
 drivers/net/ethernet/calxeda/xgmac.c          |   2 +
 .../ethernet/cavium/liquidio/cn68xx_device.c  |   1 +
 .../net/ethernet/cavium/liquidio/lio_core.c   |  92 ++---
 .../net/ethernet/cavium/liquidio/lio_main.c   | 351 +++++++++---------
 .../ethernet/cavium/liquidio/lio_vf_main.c    | 158 ++++----
 .../ethernet/cavium/liquidio/octeon_console.c |  12 +-
 .../ethernet/cavium/liquidio/octeon_device.c  |   4 +-
 .../ethernet/cavium/liquidio/octeon_droq.c    |   2 +-
 .../ethernet/cavium/liquidio/octeon_mailbox.c |   5 +-
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |   8 +-
 drivers/net/ethernet/chelsio/cxgb3/sge.c      |  24 +-
 drivers/net/ethernet/chelsio/cxgb3/t3_hw.c    |   5 +-
 drivers/net/ethernet/cisco/enic/enic_api.c    |   2 +-
 .../net/ethernet/cisco/enic/enic_ethtool.c    |   2 +-
 drivers/net/ethernet/cortina/gemini.c         |   2 +
 drivers/net/ethernet/dec/tulip/de4x5.c        |   4 +-
 drivers/net/ethernet/dec/tulip/media.c        |   5 -
 drivers/net/ethernet/dnet.c                   |   2 +-
 drivers/net/ethernet/ethoc.c                  |   6 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   2 +-
 drivers/net/ethernet/freescale/fec_ptp.c      |   5 +-
 drivers/net/ethernet/freescale/fman/fman.c    |  14 +-
 .../net/ethernet/freescale/fman/fman_muram.c  |   6 +-
 .../net/ethernet/freescale/fman/fman_port.c   |  23 +-
 drivers/net/ethernet/freescale/fman/mac.c     |   4 +-
 drivers/net/ethernet/hisilicon/hns/hnae.c     |   2 +-
 .../net/ethernet/hisilicon/hns/hns_dsaf_mac.c |  34 +-
 .../ethernet/hisilicon/hns/hns_dsaf_main.c    | 148 ++++----
 .../ethernet/hisilicon/hns/hns_dsaf_misc.c    |   9 +-
 .../net/ethernet/hisilicon/hns/hns_dsaf_ppe.c |  17 +-
 .../net/ethernet/hisilicon/hns/hns_dsaf_rcb.c |   7 +-
 .../ethernet/hisilicon/hns/hns_dsaf_xgmac.c   |   3 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |   4 +-
 .../net/ethernet/hisilicon/hns/hns_ethtool.c  |   8 +-
 .../hisilicon/hns3/hns3pf/hclge_dcb.c         |   1 +
 drivers/net/ethernet/hisilicon/hns_mdio.c     |   3 +-
 drivers/net/ethernet/intel/e100.c             |   8 +-
 drivers/net/ethernet/intel/e1000/e1000_hw.c   | 146 ++++----
 drivers/net/ethernet/intel/e1000/e1000_main.c |  39 +-
 .../net/ethernet/intel/e1000e/80003es2lan.c   |   1 -
 drivers/net/ethernet/intel/e1000e/ich8lan.c   |  16 +-
 drivers/net/ethernet/intel/e1000e/netdev.c    |  50 ++-
 drivers/net/ethernet/intel/e1000e/phy.c       |   3 +
 drivers/net/ethernet/intel/e1000e/ptp.c       |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_adminq.h |   4 +-
 drivers/net/ethernet/intel/i40e/i40e_client.c |   2 -
 drivers/net/ethernet/intel/i40e/i40e_common.c |   4 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  17 +-
 drivers/net/ethernet/intel/i40e/i40e_ptp.c    |   1 -
 drivers/net/ethernet/intel/i40e/i40e_trace.h  |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |   7 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.h   |   1 -
 .../ethernet/intel/i40e/i40e_txrx_common.h    |   6 +-
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    |   9 +-
 drivers/net/ethernet/intel/iavf/iavf_adminq.h |   4 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  20 +-
 drivers/net/ethernet/intel/iavf/iavf_trace.h  |   2 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.h   |   2 +-
 drivers/net/ethernet/intel/ice/ice.h          |   2 +-
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   6 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |   2 +-
 drivers/net/ethernet/intel/igb/e1000_82575.c  |   6 +-
 drivers/net/ethernet/intel/igb/e1000_i210.c   |   5 +-
 drivers/net/ethernet/intel/igb/e1000_mac.c    |   1 +
 drivers/net/ethernet/intel/igb/e1000_mbx.c    |   1 +
 drivers/net/ethernet/intel/igb/igb_main.c     |  28 +-
 drivers/net/ethernet/intel/igb/igb_ptp.c      |   8 +-
 drivers/net/ethernet/intel/igbvf/netdev.c     |  17 +-
 drivers/net/ethernet/intel/igc/igc_main.c     |   2 +-
 drivers/net/ethernet/intel/igc/igc_ptp.c      |   4 +-
 drivers/net/ethernet/intel/ixgb/ixgb_hw.c     | 135 ++++---
 drivers/net/ethernet/intel/ixgb/ixgb_main.c   |  17 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c  |   8 +-
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |   3 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c    |   2 +-
 drivers/net/ethernet/micrel/ksz884x.c         |  49 +--
 .../ethernet/microchip/encx24j600-regmap.c    |   2 +-
 drivers/net/ethernet/microchip/lan743x_main.c |   6 +-
 drivers/net/ethernet/natsemi/ns83820.c        |   4 +-
 drivers/net/ethernet/neterion/s2io.c          |  91 ++---
 .../net/ethernet/neterion/vxge/vxge-config.c  |   5 +-
 .../net/ethernet/neterion/vxge/vxge-ethtool.c |   2 +-
 .../net/ethernet/neterion/vxge/vxge-main.c    |  10 +-
 .../net/ethernet/neterion/vxge/vxge-traffic.c |  72 ++--
 .../oki-semi/pch_gbe/pch_gbe_ethtool.c        |   4 +-
 .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  |   5 +-
 .../ethernet/oki-semi/pch_gbe/pch_gbe_param.c |  14 +-
 .../net/ethernet/packetengines/yellowfin.c    |   2 +-
 .../net/ethernet/qlogic/netxen/netxen_nic.h   |   3 -
 .../qlogic/netxen/netxen_nic_ethtool.c        |   3 +
 drivers/net/ethernet/qualcomm/emac/emac.c     |   1 +
 drivers/net/ethernet/renesas/sh_eth.c         |  10 +
 .../net/ethernet/samsung/sxgbe/sxgbe_main.c   |  17 +-
 drivers/net/ethernet/sfc/falcon/farch.c       |  29 +-
 drivers/net/ethernet/sfc/falcon/rx.c          |   2 +
 drivers/net/ethernet/sfc/falcon/selftest.c    |   2 +-
 drivers/net/ethernet/sfc/mcdi.h               |   1 +
 drivers/net/ethernet/sfc/net_driver.h         |   2 +-
 drivers/net/ethernet/sfc/ptp.c                |   7 +-
 drivers/net/ethernet/sis/sis900.c             |   8 +-
 .../net/ethernet/stmicro/stmmac/dwmac-rk.c    |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  14 +-
 .../ethernet/stmicro/stmmac/stmmac_platform.c |   3 +-
 drivers/net/ethernet/sun/cassini.c            |   4 +-
 .../net/ethernet/synopsys/dwc-xlgmac-common.c |   2 +-
 drivers/net/ethernet/tehuti/tehuti.c          |  17 +-
 drivers/net/ethernet/ti/cpsw_new.c            |   2 -
 drivers/net/ethernet/ti/davinci_cpdma.c       |   2 +-
 drivers/net/ethernet/ti/davinci_emac.c        |  10 +-
 drivers/net/ethernet/ti/tlan.c                |   4 +-
 drivers/net/ethernet/via/via-rhine.c          |   2 +-
 drivers/net/ethernet/via/via-velocity.c       |  40 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c   |  26 +-
 130 files changed, 1178 insertions(+), 1062 deletions(-)


base-commit: 3fc826f121d89c5aa4afd7b3408b07e0ff59466b
-- 
2.25.4

