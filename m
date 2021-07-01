Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605C43B95C9
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 20:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbhGASD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 14:03:59 -0400
Received: from mga12.intel.com ([192.55.52.136]:63745 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233038AbhGASD5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 14:03:57 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10032"; a="188272881"
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="188272881"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 11:01:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="409018392"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 01 Jul 2021 11:01:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 00/11][pull request] Intel Wired LAN Driver Updates 2021-07-01
Date:   Thu,  1 Jul 2021 11:04:09 -0700
Message-Id: <20210701180420.346126-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igb, igc, ixgbe, e1000e, fm10k, and iavf
drivers.

Vinicius fixes a use-after-free issue present in igc and igb.

Tom Rix fixes the return value for igc_read_phy_reg() when the
operation is not supported for igc.

Christophe Jaillet fixes unrolling of PCIe error reporting for ixgbe,
igc, igb, fm10k, e10000e, and iavf.

Alex ensures that q_vector array is not accessed beyond its bounds for
igb.

Jedrzej moves ring assignment to occur after bounds have been checked in
igb.

The following are changes since commit dbe69e43372212527abf48609aba7fc39a6daa27:
  Merge tag 'net-next-5.14' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 1GbE

Aleksandr Loktionov (1):
  igb: Check if num of q_vectors is smaller than max before array access

Christophe JAILLET (6):
  ixgbe: Fix an error handling path in 'ixgbe_probe()'
  igc: Fix an error handling path in 'igc_probe()'
  igb: Fix an error handling path in 'igb_probe()'
  fm10k: Fix an error handling path in 'fm10k_probe()'
  e1000e: Fix an error handling path in 'e1000_probe()'
  iavf: Fix an error handling path in 'iavf_probe()'

Jedrzej Jagielski (1):
  igb: Fix position of assignment to *ring

Tom Rix (1):
  igc: change default return of igc_read_phy_reg()

Vinicius Costa Gomes (2):
  igc: Fix use-after-free error during reset
  igb: Fix use-after-free error during reset

 drivers/net/ethernet/intel/e1000e/netdev.c    |  1 +
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c  |  1 +
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  1 +
 drivers/net/ethernet/intel/igb/igb_main.c     | 15 +++++++++++++--
 drivers/net/ethernet/intel/igc/igc.h          |  2 +-
 drivers/net/ethernet/intel/igc/igc_main.c     |  3 +++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  1 +
 7 files changed, 21 insertions(+), 3 deletions(-)

-- 
2.26.2

