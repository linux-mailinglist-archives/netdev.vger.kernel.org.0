Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78713D052B
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 01:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbhGTWh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 18:37:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:50224 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229726AbhGTWhU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 18:37:20 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10051"; a="211341470"
X-IronPort-AV: E=Sophos;i="5.84,256,1620716400"; 
   d="scan'208";a="211341470"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2021 16:17:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,256,1620716400"; 
   d="scan'208";a="415407121"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 20 Jul 2021 16:17:53 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com
Subject: [PATCH net-next 00/12][pull request] 1GbE Intel Wired LAN Driver Updates 2021-07-20
Date:   Tue, 20 Jul 2021 16:20:49 -0700
Message-Id: <20210720232101.3087589-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to e1000e and igc drivers.

Sasha adds initial S0ix support for devices with CSME and adds polling
for exiting of DPG. He sets the PHY to low power idle when in S0ix. He
also adds support for new device IDs for and adds a space to debug
messaging to help with readability for e1000e.

For igc, he ensures that q_vector array is not accessed beyond its
bounds and removes unneeded PHY related checks.

Tree Davies corrects a spelling mistake in e1000e.

Muhammad corrects the value written when there is no TSN offloading
and adjusts timeout value to avoid possible Tx hang for igc.

The following are changes since commit 8887ca5474bd9ddb56cabc88856bb035774e0041:
  net: phy: at803x: simplify custom phy id matching
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Muhammad Husaini Zulkifli (2):
  igc: Set QBVCYCLET_S to 0 for TSN Basic Scheduling
  igc: Increase timeout value for Speed 100/1000/2500

Sasha Neftin (9):
  e1000e: Add handshake with the CSME to support S0ix
  e1000e: Add polling mechanism to indicate CSME DPG exit
  e1000e: Additional PHY power saving in S0ix
  e1000e: Add support for Lunar Lake
  e1000e: Add support for the next LOM generation
  e1000e: Add space to the debug print
  igc: Check if num of q_vectors is smaller than max before array access
  igc: Remove _I_PHY_ID checking
  igc: Remove phy->type checking

Tree Davies (1):
  net/e1000e: Fix spelling mistake "The" -> "This"

 drivers/net/ethernet/intel/e1000e/ethtool.c |   2 +
 drivers/net/ethernet/intel/e1000e/hw.h      |   9 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c |  13 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.h |   3 +
 drivers/net/ethernet/intel/e1000e/netdev.c  | 370 ++++++++++++--------
 drivers/net/ethernet/intel/e1000e/ptp.c     |   1 +
 drivers/net/ethernet/intel/e1000e/regs.h    |   1 +
 drivers/net/ethernet/intel/igc/igc_base.c   |  10 +-
 drivers/net/ethernet/intel/igc/igc_main.c   |  31 +-
 drivers/net/ethernet/intel/igc/igc_phy.c    |   6 +-
 drivers/net/ethernet/intel/igc/igc_tsn.c    |   2 +-
 11 files changed, 262 insertions(+), 186 deletions(-)

-- 
2.26.2

