Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA1EA636E14
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 00:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbiKWXGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 18:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiKWXGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 18:06:35 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C07D14FECF
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 15:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669244790; x=1700780790;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9px5K1CWSb/VUFmv3oFN8H6YH8dBafr23DNshDJc0gQ=;
  b=XL/jF3uf5oedYSFN3W/ayG2dfhS6Ocpuc80ypc6tYFolQO8/PzaLr9kP
   r5oCnmTFsbAHwZJMvL83UKWX18jKuAHIkPBr+KfeX26QUAfGzXkS6KPp1
   SF2kPqbT6UeBJHuycr2P85A6XvpqAwjjyC9V1jhaqgUDdq1VAGr7iFMt4
   CaOMOaARkVIxc9L9LIt37ttkC2i5Yzb937d1aSdF3fHJqB2dHRdVtjnQI
   uSX7sASp4iyRGjcd6EZoMY/g2xbGGacTYSZTuJd5SBm2LnDGlM1iiLwI+
   qow4vx0Ej+9k1xwelEWzc5zkH7Kuw4mbYYkoigeD62C7SeaXakPClP4i5
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="376318622"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="376318622"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 15:06:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="705531252"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="705531252"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 23 Nov 2022 15:06:28 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 0/6][pull request] Intel Wired LAN Driver Updates 2022-11-23 (ice)
Date:   Wed, 23 Nov 2022 15:06:15 -0800
Message-Id: <20221123230621.3562805-1-anthony.l.nguyen@intel.com>
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

Brett removes use of driver defined link speed; instead using the values
from ethtool.h, utilizing static tables for indexing.

Ben adds tracking of stats in order to accumulate reported statistics that
were previously reset by hardware.

Marcin fixes issues setting RXDID when queues are asymmetric.

Anatolii re-introduces use of define over magic number; ICE_RLAN_BASE_S.
---
v3:
 - Dropped, previous, patch 2
v2:
Patch 5
 - Convert some allocations to non-managed
 - Remove combined error checking; add error checks for each call
 - Remove excess NULL checks
 - Remove unnecessary NULL sets and newlines

The following are changes since commit e80bd08fd75a644e2337fb535c1afdb6417357ff:
  sfc: ensure type is valid before updating seen_gen
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Anatolii Gerasymenko (1):
  ice: Use ICE_RLAN_BASE_S instead of magic number

Benjamin Mikailenko (2):
  ice: Accumulate HW and Netdev statistics over reset
  ice: Accumulate ring statistics over reset

Brett Creeley (1):
  ice: Remove and replace ice speed defines with ethtool.h versions

Karol Kolacinski (1):
  ice: Check for PTP HW lock more frequently

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
 drivers/net/ethernet/intel/ice/ice_lib.c      | 272 +++++++++++++++---
 drivers/net/ethernet/intel/ice/ice_main.c     |  96 +++++--
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c   |  12 +-
 drivers/net/ethernet/intel/ice/ice_repr.c     |  10 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  40 ++-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  18 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |   2 +-
 drivers/net/ethernet/intel/ice/ice_vf_mbx.c   |  92 ++----
 drivers/net/ethernet/intel/ice/ice_virtchnl.c |  37 ++-
 drivers/net/ethernet/intel/ice/ice_xsk.c      |  25 +-
 17 files changed, 482 insertions(+), 200 deletions(-)

-- 
2.35.1

