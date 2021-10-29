Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B24B440451
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 22:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhJ2Utt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 16:49:49 -0400
Received: from mga06.intel.com ([134.134.136.31]:9536 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229897AbhJ2Uts (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 16:49:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10152"; a="291587511"
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="291587511"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2021 13:47:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="448483284"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 29 Oct 2021 13:47:17 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/7][pull request] 100GbE Intel Wired LAN Driver Updates 2021-10-29
Date:   Fri, 29 Oct 2021 13:45:33 -0700
Message-Id: <20211029204540.3390007-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice and iavf drivers and virtchnl header
file.

Brett removes vlan_promisc argument from a function call for ice driver.
In the virtchnl header file he removes an unused, reserved define and
converts raw value defines to instead use the BIT macro.

Marcin adds syncing of MAC addresses when creating switchdev VFs to
remove error messages on link up and stops showing buffer information
for port representors to remove duplicated entries being displayed for
ice driver.

Karen introduces a helper to go from pci_dev to iavf_adapter in the
iavf driver.

Przemyslaw fixes an issue where iavf was attempting to free IRQs before
calling disable.

The following are changes since commit 28131d896d6d316bc1f6f305d1a9ed6d96c3f2a1:
  Merge tag 'wireless-drivers-next-2021-10-29' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Brett Creeley (3):
  ice: Remove boolean vlan_promisc flag from function
  virtchnl: Remove unused VIRTCHNL_VF_OFFLOAD_RSVD define
  virtchnl: Use the BIT() macro for capability/offload flags

Karen Sornek (1):
  iavf: Add helper function to go from pci_dev to adapter

Marcin Szycik (2):
  ice: Clear synchronized addrs when adding VFs in switchdev mode
  ice: Hide bus-info in ethtool for PRs in switchdev mode

Przemyslaw Patynowski (1):
  iavf: Fix kernel BUG in free_msi_irqs

 drivers/net/ethernet/intel/iavf/iavf.h        | 36 +++++++++++++++
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 44 ++++++++++++++++---
 drivers/net/ethernet/intel/ice/ice_eswitch.c  |  6 +++
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  7 +--
 drivers/net/ethernet/intel/ice/ice_lib.c      |  7 +--
 drivers/net/ethernet/intel/ice/ice_lib.h      |  2 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 12 ++---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  9 ++--
 include/linux/avf/virtchnl.h                  | 41 +++++++++--------
 9 files changed, 118 insertions(+), 46 deletions(-)

-- 
2.31.1

