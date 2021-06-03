Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBAC739A66E
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 18:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhFCQ6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 12:58:44 -0400
Received: from mga06.intel.com ([134.134.136.31]:13144 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229955AbhFCQ6l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 12:58:41 -0400
IronPort-SDR: 5LXb9CG4ugzBLrAElb0cAOdJUwrOkH1NLwVRy3lY0aIUPx3qAe5UrsOMsoXxOdW0wzKS5vdjdb
 gdj3C4sgILTQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="265260910"
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="265260910"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 09:56:55 -0700
IronPort-SDR: G1r66cB4HYGlGA1Y0YOu2+0qCcLQUeO2WkmayvimoXFSyJxobiWJ1n48Epl7h3UbiqyLcOWKKY
 0Vs3HxcQKlBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="550239132"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 03 Jun 2021 09:56:55 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com
Subject: [PATCH net 0/8][pull request] Intel Wired LAN Driver Updates 2021-06-03
Date:   Thu,  3 Jun 2021 09:59:15 -0700
Message-Id: <20210603165923.1918030-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igb, igc, ixgbe, ixgbevf, i40e and ice
drivers.

Kurt Kanzenbach fixes XDP for igb when PTP is enabled by pulling the
timestamp and adjusting appropriate values prior to XDP operations.

Magnus adds missing exception tracing for XDP on igb, igc, ixgbe,
ixgbevf, i40e and ice drivers.

Maciej adds tracking of AF_XDP zero copy enabled queues to resolve an
issue with copy mode Tx for the ice driver.

Note: Patch 7 will conflict when merged with net-next. Please carry
these changes forward. IGC_XDP_TX and IGC_XDP_REDIRECT will need to be
changed to return to conform with the net-next changes. Let me know if
you have issues.

The following are changes since commit ab00f3e051e851a8458f0d0eb1bb426deadb6619:
  net: stmmac: fix issue where clk is being unprepared twice
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 1GbE

Kurt Kanzenbach (1):
  igb: Fix XDP with PTP enabled

Maciej Fijalkowski (1):
  ice: track AF_XDP ZC enabled queues in bitmap

Magnus Karlsson (6):
  i40e: add correct exception tracing for XDP
  ice: add correct exception tracing for XDP
  ixgbe: add correct exception tracing for XDP
  igb: add correct exception tracing for XDP
  ixgbevf: add correct exception tracing for XDP
  igc: add correct exception tracing for XDP

 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  7 ++-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    |  8 ++-
 drivers/net/ethernet/intel/ice/ice.h          |  8 ++-
 drivers/net/ethernet/intel/ice/ice_lib.c      | 10 ++++
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 12 +++-
 drivers/net/ethernet/intel/ice/ice_xsk.c      | 11 +++-
 drivers/net/ethernet/intel/igb/igb.h          |  2 +-
 drivers/net/ethernet/intel/igb/igb_main.c     | 55 +++++++++++--------
 drivers/net/ethernet/intel/igb/igb_ptp.c      | 23 ++++----
 drivers/net/ethernet/intel/igc/igc_main.c     | 11 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 16 +++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 14 +++--
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  3 +
 13 files changed, 112 insertions(+), 68 deletions(-)

-- 
2.26.2

