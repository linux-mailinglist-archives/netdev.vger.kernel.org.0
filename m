Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39CE2362993
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 22:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241597AbhDPUny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 16:43:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:45469 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236729AbhDPUnj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 16:43:39 -0400
IronPort-SDR: pfujopGwlzrQqp7nJkOj/tLCvicz6FpLUQxG2DR7Rhh6nUUEJUAq943GW/hUsglBt/YPIpMWJM
 +RCMbfAOVmlA==
X-IronPort-AV: E=McAfee;i="6200,9189,9956"; a="182234172"
X-IronPort-AV: E=Sophos;i="5.82,228,1613462400"; 
   d="scan'208";a="182234172"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 13:43:12 -0700
IronPort-SDR: twSqnst1EyEX5K3PqougHple/qWuOo5qKq1uEEyLkbdueDkEbvy+qw2he5cusqdQqp012G7Dcs
 5v9zCh2l7vEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,228,1613462400"; 
   d="scan'208";a="384425598"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 16 Apr 2021 13:43:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net-next 0/6][pull request] 1GbE Intel Wired LAN Driver Updates 2021-04-16
Date:   Fri, 16 Apr 2021 13:44:54 -0700
Message-Id: <20210416204500.2012073-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igb and igc drivers.

Ederson adjusts Tx buffer distributions in Qav mode to improve
TSN-aware traffic for igb. He also enable PPS support and auxiliary PHC
functions for igc.

Grzegorz checks that the MTA register was properly written and
retries if not for igb.

Sasha adds reporting of EEE low power idle counters to ethtool and fixes
a return value being overwritten through looping for igc.

The following are changes since commit 392c36e5be1dee19ffce8c8ba8f07f90f5aa3f7c:
  Merge branch 'ehtool-fec-stats'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Ederson de Souza (3):
  igb: Redistribute memory for transmit packet buffers when in Qav mode
  igc: Enable internal i225 PPS
  igc: enable auxiliary PHC functions for the i225

Grzegorz Siwik (1):
  igb: Add double-check MTA_REGISTER for i210 and i211

Sasha Neftin (2):
  igc: Fix overwrites return value
  igc: Expose LPI counters

 .../net/ethernet/intel/igb/e1000_defines.h    |   8 +-
 drivers/net/ethernet/intel/igb/e1000_mac.c    |  27 ++
 drivers/net/ethernet/intel/igb/igb_main.c     |   4 +-
 drivers/net/ethernet/intel/igc/igc.h          |  13 +
 drivers/net/ethernet/intel/igc/igc_defines.h  |  63 ++++
 drivers/net/ethernet/intel/igc/igc_ethtool.c  |   2 +
 drivers/net/ethernet/intel/igc/igc_i225.c     |   4 +-
 drivers/net/ethernet/intel/igc/igc_main.c     |  63 +++-
 drivers/net/ethernet/intel/igc/igc_ptp.c      | 295 +++++++++++++++++-
 drivers/net/ethernet/intel/igc/igc_regs.h     |  10 +
 10 files changed, 478 insertions(+), 11 deletions(-)

-- 
2.26.2

