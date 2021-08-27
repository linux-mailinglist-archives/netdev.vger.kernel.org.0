Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167CA3F9DC3
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 19:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241235AbhH0RWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 13:22:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:32992 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240154AbhH0RWU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 13:22:20 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10089"; a="214870012"
X-IronPort-AV: E=Sophos;i="5.84,357,1620716400"; 
   d="scan'208";a="214870012"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 10:21:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,357,1620716400"; 
   d="scan'208";a="427178963"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 27 Aug 2021 10:21:30 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        aravindhan.gunasekaran@intel.com
Subject: [PATCH net-next 0/3][pull request] 1GbE Intel Wired LAN Driver Updates 2021-08-27
Date:   Fri, 27 Aug 2021 10:25:10 -0700
Message-Id: <20210827172513.224045-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aravindhan Gunasekaran says:

This adds support for Credit-based shaper qdisc offload from
Traffic Control system. It enables traffic prioritization and
bandwidth reservation via the Credit-Based Shaper which is
implemented in hardware by i225 controller.

Patch 1/3 adds a default cycle-time for TSN mode to be configured.

Patch 2/3 helps to separate TSN mode programming on the fly and
during reset sequence. It also simplifies handling features flags
for various TSN modes supported by i225 in the driver.

Patch 3/3 adds support for IEEE802.1Qav(CBS) standard
implemented in i225 HW. Two sets of CBS HW shapers are present
in i225 and driver enables them in the two high priority queues.

The following are changes since commit 4baf0e0b329874ec5e85480f53851b5f05a7ae58:
  um: vector: adjust to coalesce API changes
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Aravindhan Gunasekaran (1):
  igc: Add support for CBS offloading

Vinicius Costa Gomes (2):
  igc: Use default cycle 'start' and 'end' values for queues
  igc: Simplify TSN flags handling

 drivers/net/ethernet/intel/igc/igc.h         |  11 ++
 drivers/net/ethernet/intel/igc/igc_defines.h |   8 +
 drivers/net/ethernet/intel/igc/igc_main.c    | 110 ++++++++++--
 drivers/net/ethernet/intel/igc/igc_regs.h    |   3 +
 drivers/net/ethernet/intel/igc/igc_tsn.c     | 174 +++++++++++++++----
 drivers/net/ethernet/intel/igc/igc_tsn.h     |   1 +
 6 files changed, 258 insertions(+), 49 deletions(-)

-- 
2.26.2

