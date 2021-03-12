Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFF5339561
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbhCLRrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 12:47:14 -0500
Received: from mga06.intel.com ([134.134.136.31]:9116 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232342AbhCLRqi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 12:46:38 -0500
IronPort-SDR: u2V6Lk8nrM8snBmkg4Wa/1RrBB6yztQ6bvVmMl6XqJd0Butq/CbzE8vunMwz34j17YFjOc74Yq
 bHRrti8IJvDA==
X-IronPort-AV: E=McAfee;i="6000,8403,9921"; a="250232653"
X-IronPort-AV: E=Sophos;i="5.81,244,1610438400"; 
   d="scan'208";a="250232653"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 09:46:38 -0800
IronPort-SDR: LcPSBAFLrep3oRcKHlPC4Y7D03oIXwCnEd1pwH7IpmX1ZhZrE1EnHBb58zpfY0+CQXvLErczvY
 5YcwFeMftWFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,244,1610438400"; 
   d="scan'208";a="589615843"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 12 Mar 2021 09:46:37 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com
Subject: [PATCH net 0/5][pull request] Intel Wired LAN Driver Updates 2021-03-12
Date:   Fri, 12 Mar 2021 09:47:50 -0800
Message-Id: <20210312174755.2103336-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice, i40e, ixgbe and igb drivers.

Magnus adjusts the return value for xsk allocation for ice. This fixes
reporting of napi work done and matches the behavior of other Intel NIC
drivers for xsk allocations.

Maciej moves storing of the rx_offset value to after the build_skb flag
is set as this flag affects the offset value for ice, i40e, and ixgbe.

Li RongQing resolves an issue where an Rx buffer can be reused
prematurely with XDP redirect for igb.

The following are changes since commit 7a1468ba0e02eee24ae1353e8933793a27198e20:
  net: phy: broadcom: Add power down exit reset state delay
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Li RongQing (1):
  igb: avoid premature Rx buffer reuse

Maciej Fijalkowski (3):
  i40e: move headroom initialization to i40e_configure_rx_ring
  ice: move headroom initialization to ice_setup_rx_ctx
  ixgbe: move headroom initialization to ixgbe_configure_rx_ring

Magnus Karlsson (1):
  ice: fix napi work done reporting in xsk path

 drivers/net/ethernet/intel/i40e/i40e_main.c   | 13 ++++++++++
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 12 ----------
 drivers/net/ethernet/intel/ice/ice_base.c     | 24 +++++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 17 -------------
 drivers/net/ethernet/intel/ice/ice_xsk.c      | 10 ++++----
 drivers/net/ethernet/intel/igb/igb_main.c     | 22 +++++++++++------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  3 ++-
 7 files changed, 57 insertions(+), 44 deletions(-)

-- 
2.26.2

