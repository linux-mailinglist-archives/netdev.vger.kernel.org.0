Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC5D3CBE5E
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 23:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235304AbhGPVYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 17:24:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:9331 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229846AbhGPVYS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 17:24:18 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10047"; a="197980596"
X-IronPort-AV: E=Sophos;i="5.84,246,1620716400"; 
   d="scan'208";a="197980596"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2021 14:21:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,246,1620716400"; 
   d="scan'208";a="574434555"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 16 Jul 2021 14:21:22 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        vinicius.gomes@intel.com
Subject: [PATCH net-next 0/5][pull request] 1GbE Intel Wired LAN Driver Updates 2021-07-16
Date:   Fri, 16 Jul 2021 14:24:22 -0700
Message-Id: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vinicius Costa Gomes says:

Add support for steering traffic to specific RX queues using Flex Filters.

As the name implies, Flex Filters are more flexible than using
Layer-2, VLAN or MAC address filters, one of the reasons is that they
allow "AND" operations more easily, e.g. when the user wants to steer
some traffic based on the source MAC address and the packet ethertype.

Future work include adding support for offloading tc-u32 filters to
the hardware.

The series is divided as follows:

Patch 1/5, add the low level primitives for configuring Flex filters.

Patch 2/5 and 3/5, allow ethtool to manage Flex filters.

Patch 4/5, when specifying filters that have multiple predicates, use
Flex filters.

Patch 5/5, Adds support for exposing the i225 LEDs using the LED subsystem.

The following are changes since commit 919d527956daa3e7ad03a23ba661beb8a46cacf4:
  bnx2x: remove unused variable 'cur_data_offset'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Kurt Kanzenbach (4):
  igc: Add possibility to add flex filter
  igc: Integrate flex filter into ethtool ops
  igc: Make flex filter more flexible
  igc: Export LEDs

Vinicius Costa Gomes (1):
  igc: Allow for Flex Filters to be installed

 drivers/net/ethernet/intel/Kconfig           |   1 +
 drivers/net/ethernet/intel/igc/igc.h         |  48 +-
 drivers/net/ethernet/intel/igc/igc_defines.h |  62 ++-
 drivers/net/ethernet/intel/igc/igc_ethtool.c |  41 +-
 drivers/net/ethernet/intel/igc/igc_main.c    | 448 ++++++++++++++++++-
 drivers/net/ethernet/intel/igc/igc_regs.h    |  19 +
 6 files changed, 595 insertions(+), 24 deletions(-)

-- 
2.26.2

