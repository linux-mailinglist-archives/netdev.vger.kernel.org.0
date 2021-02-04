Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F5830E8C0
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 01:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234404AbhBDAnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:43:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:40026 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234286AbhBDAm4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 19:42:56 -0500
IronPort-SDR: pbvVuhks6m3EtndE3J0cSSDo67nc7J5T/efl3fmlqNhL+9P2nJkgWx+rNSQ7Q1mL6tvNgSyBL/
 hr4wbyucUo3w==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="177638224"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="177638224"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 16:42:12 -0800
IronPort-SDR: bLCbmHN01+U3/K/u1lViYl7Yx7a8IJcR9oPWABeIQdISCnZXFtzfYGq8GclKrz2Ic/HLhLYAil
 KKA83JdW34hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="579687481"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 03 Feb 2021 16:42:12 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net-next 00/15][pull request] 1GbE Intel Wired LAN Driver Updates 2021-02-03
Date:   Wed,  3 Feb 2021 16:42:44 -0800
Message-Id: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igc, igb, e1000e, and e1000 drivers.

Sasha adds counting of good transmit packets and reporting of NVM version
and gPHY version in ethtool firmware version. Replaces the use of strlcpy
to the preferred strscpy. Fixes a typo that caused the wrong register to be
output. He also removes an unused function pointer, some unneeded defines,
and a non-applicable comment. All changes for igc.

Gal Hammer fixes a typo which caused the RDBAL register values to be
shown instead of TDBAL for igb.

Nick Lowe enables RSS support for i211 devices for igb.

Tom Rix fixes checkpatch warning by removing h from printk format
specifier for igb.

Kaixu Xia removes setting of a variable that is overwritten before next
use for e1000e.

Sudip Mukherjee removes an unneeded assignment for e1000.

Note: Most patches only compile tested.

The following are changes since commit 32d1bbb1d609f5a78b0c95e2189f398a52a3fbf7:
  net: fec: Silence M5272 build warnings
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Gal Hammer (1):
  igb: fix TDBAL register show incorrect value

Kaixu Xia (1):
  e1000e: remove the redundant value assignment in
    e1000_update_nvm_checksum_spt

Nick Lowe (1):
  igb: Enable RSS for Intel I211 Ethernet Controller

Sasha Neftin (10):
  igc: Clean up nvm_operations structure
  igc: Remove igc_set_fw_version comment
  igc: Remove MULR mask define
  igc: Add Host Good Packets Transmitted Count
  igc: Expose the NVM version
  igc: Expose the gPHY firmware version
  igc: Prefer strscpy over strlcpy
  igc: Remove unused local receiver mask
  igc: Remove unused FUNC_1 mask
  igc: Fix TDBAL register show incorrect value

Sudip Mukherjee (1):
  e1000: drop unneeded assignment in e1000_set_itr()

Tom Rix (1):
  igb: remove h from printk format specifier

 drivers/net/ethernet/intel/e1000/e1000_main.c |  1 -
 drivers/net/ethernet/intel/e1000e/ich8lan.c   |  7 ------
 drivers/net/ethernet/intel/igb/igb_main.c     |  7 +++---
 drivers/net/ethernet/intel/igc/igc.h          |  2 ++
 drivers/net/ethernet/intel/igc/igc_defines.h  |  4 +---
 drivers/net/ethernet/intel/igc/igc_dump.c     |  2 +-
 drivers/net/ethernet/intel/igc/igc_ethtool.c  | 24 +++++++++++++++----
 drivers/net/ethernet/intel/igc/igc_hw.h       |  1 -
 drivers/net/ethernet/intel/igc/igc_main.c     |  1 +
 drivers/net/ethernet/intel/igc/igc_phy.c      | 18 ++++++++++++++
 drivers/net/ethernet/intel/igc/igc_phy.h      |  1 +
 drivers/net/ethernet/intel/igc/igc_regs.h     |  1 +
 12 files changed, 48 insertions(+), 21 deletions(-)

-- 
2.26.2

