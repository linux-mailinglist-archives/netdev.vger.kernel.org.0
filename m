Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A63E337BC4
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbhCKSIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:08:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:47785 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229555AbhCKSH7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 13:07:59 -0500
IronPort-SDR: eB8oy/UsnZtZbpAXxlcizpPxEZ3R0SAD2Nbx0bykasG3lslET5P5t1SwjunNHw8uLUIvN+prrC
 p8R0+n2DiQcw==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="188809479"
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="188809479"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2021 10:07:58 -0800
IronPort-SDR: Nvshhq51yXjnmhwx2fjiunXamD7ffP8MHL33t9h73DhBI+T4RuHhODVX78Z+AC0A1JZ8z3WlNE
 osAAZROJJ63Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="409570549"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 11 Mar 2021 10:07:58 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com
Subject: [PATCH net 0/6][pull request] Intel Wired LAN Driver Updates 2021-03-11
Date:   Thu, 11 Mar 2021 10:09:09 -0800
Message-Id: <20210311180915.1489936-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igc and e1000e drivers.

Sasha adds locking to reset task to prevent race condition for igc.

Muhammad fixes reporting of supported pause frame as well as advertised
pause frame for Tx/Rx off for igc.

Andre fixes timestamp retrieval from the wrong timer for igc.

Vitaly adds locking to reset task to prevent race condition for e1000e.

Dinghao Liu adds a missed check to return on error in
e1000_set_d0_lplu_state_82571.

The following are changes since commit 47142ed6c34d544ae9f0463e58d482289cbe0d46:
  net: dsa: bcm_sf2: Qualify phydev->dev_flags based on port
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 1GbE

Andre Guedes (1):
  igc: Fix igc_ptp_rx_pktstamp()

Dinghao Liu (1):
  e1000e: Fix error handling in e1000_set_d0_lplu_state_82571

Muhammad Husaini Zulkifli (2):
  igc: Fix Pause Frame Advertising
  igc: Fix Supported Pause Frame Link Setting

Sasha Neftin (1):
  igc: reinit_locked() should be called with rtnl_lock

Vitaly Lifshits (1):
  e1000e: add rtnl_lock() to e1000_reset_task

 drivers/net/ethernet/intel/e1000e/82571.c    |  2 +
 drivers/net/ethernet/intel/e1000e/netdev.c   |  6 +-
 drivers/net/ethernet/intel/igc/igc.h         |  2 +-
 drivers/net/ethernet/intel/igc/igc_ethtool.c |  7 +-
 drivers/net/ethernet/intel/igc/igc_main.c    |  9 +++
 drivers/net/ethernet/intel/igc/igc_ptp.c     | 72 +++++++++++---------
 6 files changed, 61 insertions(+), 37 deletions(-)

-- 
2.26.2

