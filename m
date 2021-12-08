Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B6046DDBD
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 22:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238741AbhLHVoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 16:44:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:15036 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238697AbhLHVod (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 16:44:33 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10192"; a="237757853"
X-IronPort-AV: E=Sophos;i="5.88,190,1635231600"; 
   d="scan'208";a="237757853"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2021 13:12:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,190,1635231600"; 
   d="scan'208";a="606528264"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 08 Dec 2021 13:12:48 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net v2 0/7][pull request] Intel Wired LAN Driver Updates 2021-12-08
Date:   Wed,  8 Dec 2021 13:11:37 -0800
Message-Id: <20211208211144.2629867-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Yahui adds re-initialization of Flow Director for VF reset.

Paul restores interrupts when enabling VFs.

Dave re-adds bandwidth check for DCBNL and moves DSCP mode check
earlier in the function.

Jesse prevents reporting of dropped packets that occur during
initialization and fixes reporting of statistics which could occur with
frequent reads.

Michal corrects setting of protocol type for UDP header and fixes lack
of differentiation when adding filters for tunnels.
---
v2:
- Remove newline changes in patch 7

The following are changes since commit b5bd95d17102b6719e3531d627875b9690371383:
  net: fec: only clear interrupt of handling queue in fec_enet_rx_queue()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Dave Ertman (1):
  ice: Fix problems with DSCP QoS implementation

Jesse Brandeburg (2):
  ice: ignore dropped packets during init
  ice: safer stats processing

Michal Swiatkowski (2):
  ice: fix choosing UDP header type
  ice: fix adding different tunnels

Paul Greenwalt (1):
  ice: rearm other interrupt cause register after enabling VFs

Yahui Cao (1):
  ice: fix FDIR init missing when reset VF

 drivers/net/ethernet/intel/ice/ice_dcb_nl.c   | 18 +++++++----
 .../net/ethernet/intel/ice/ice_ethtool_fdir.c |  4 +--
 drivers/net/ethernet/intel/ice/ice_fdir.c     |  2 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |  7 ++--
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |  3 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 32 ++++++++++++-------
 drivers/net/ethernet/intel/ice/ice_switch.c   | 19 +++++++----
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   | 30 +++++++----------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  6 ++++
 9 files changed, 74 insertions(+), 47 deletions(-)

-- 
2.31.1

