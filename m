Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADEFE46C76A
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 23:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242156AbhLGWaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 17:30:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:6596 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242147AbhLGWaR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 17:30:17 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10191"; a="237508425"
X-IronPort-AV: E=Sophos;i="5.87,295,1631602800"; 
   d="scan'208";a="237508425"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 14:26:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,295,1631602800"; 
   d="scan'208";a="605889069"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 07 Dec 2021 14:26:46 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/7][pull request] Intel Wired LAN Driver Updates 2021-12-07
Date:   Tue,  7 Dec 2021 14:25:37 -0800
Message-Id: <20211207222544.977843-1-anthony.l.nguyen@intel.com>
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

The following are changes since commit d17b9737c2bc09b4ac6caf469826e5a7ce3ffab7:
  net/qla3xxx: fix an error code in ql_adapter_up()
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

 drivers/net/ethernet/intel/ice/ice_dcb_nl.c   | 18 ++++++----
 .../net/ethernet/intel/ice/ice_ethtool_fdir.c |  4 +--
 drivers/net/ethernet/intel/ice/ice_fdir.c     |  2 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |  7 ++--
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |  3 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 34 +++++++++++++------
 drivers/net/ethernet/intel/ice/ice_switch.c   | 19 +++++++----
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   | 30 +++++++---------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  6 ++++
 9 files changed, 76 insertions(+), 47 deletions(-)

-- 
2.31.1

