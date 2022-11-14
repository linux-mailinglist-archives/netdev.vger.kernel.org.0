Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48BF1628DA4
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 00:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237534AbiKNXnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 18:43:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbiKNXm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 18:42:56 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633A212778
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 15:42:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668469376; x=1700005376;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=aeCdDph0tNqlzcT76UEgxCTyoh0lZK4QQqLwjOfviEg=;
  b=nxqrIjLZUdZJuzjmLUQgxIPZ4+vav5zd7vETcKcjRasPBzPINsStJnn+
   GfSPRM0Uz6gD6uJc0WgZioVPtyta/S9l2/pQ1VjUbEC97mawrP0lZI7fr
   pQokvwc942OAkWaJ0MGEDheqr2iZfjFIxp8YriDwX9bL7yZXplCIL4ssg
   rxA1zpA+nSYnZ4dru8zoDLnjmA3KuqliZ/UIq3ylzr56PrV/AgwHYJWzW
   wN77MukX899/dVfGnyamTpHhLS3h04mzdK1E0xJYZwO7lsVy+dbXKsHP/
   YfDvgQznSL/CBpMC18nWp1otAltzbmiasYzc9t2rtJXet+Z1hbyRpfL6j
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="310821175"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="310821175"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 15:42:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="702208660"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="702208660"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 14 Nov 2022 15:42:55 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/7][pull request] 100GbE Intel Wired LAN Driver Updates 2022-11-14 (ice)
Date:   Mon, 14 Nov 2022 15:42:43 -0800
Message-Id: <20221114234250.3039889-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Karol adjusts check of PTP hardware to wait longer but check more often.
He also removes waiting for PTP lock when getting time values.

Brett removes use of driver defined link speed; instead using the values
from ethtool.h, utilizing static tables for indexing.

Ben adds tracking of stats in order to accumulate reported statistics that
were previously reset by hardware.

Marcin fixes issues setting RXDID when queues are asymmetric.

Anatolii re-introduces use of define over magic number; ICE_RLAN_BASE_S.

The following are changes since commit f12ed9c04804eec4f1819097a0fd0b4800adac2f:
  Merge tag 'mlx5-updates-2022-11-12' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Anatolii Gerasymenko (1):
  ice: Use ICE_RLAN_BASE_S instead of magic number

Benjamin Mikailenko (2):
  ice: Accumulate HW and Netdev statistics over reset
  ice: Accumulate ring statistics over reset

Brett Creeley (1):
  ice: Remove and replace ice speed defines with ethtool.h versions

Karol Kolacinski (2):
  ice: Check for PTP HW lock more frequently
  ice: Remove gettime HW semaphore

Marcin Szycik (1):
  ice: Fix configuring VIRTCHNL_OP_CONFIG_VSI_QUEUES with unbalanced
    queues

 drivers/net/ethernet/intel/ice/ice.h          |   7 +
 drivers/net/ethernet/intel/ice/ice_base.c     |   2 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |  41 ++-
 drivers/net/ethernet/intel/ice/ice_common.h   |   1 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   3 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  12 +-
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |  12 -
 drivers/net/ethernet/intel/ice/ice_lib.c      | 295 +++++++++++++++---
 drivers/net/ethernet/intel/ice/ice_main.c     |  98 ++++--
 drivers/net/ethernet/intel/ice/ice_ptp.c      |  31 +-
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c   |  12 +-
 drivers/net/ethernet/intel/ice/ice_repr.c     |  10 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  40 ++-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  18 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |   2 +-
 drivers/net/ethernet/intel/ice/ice_vf_mbx.c   |  92 ++----
 drivers/net/ethernet/intel/ice/ice_virtchnl.c |  37 +--
 drivers/net/ethernet/intel/ice/ice_xsk.c      |  25 +-
 18 files changed, 511 insertions(+), 227 deletions(-)

-- 
2.35.1

