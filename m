Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B56ADF4A6
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 20:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbfJUSBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 14:01:45 -0400
Received: from mga17.intel.com ([192.55.52.151]:30872 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727110AbfJUSBp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 14:01:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 11:01:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,324,1566889200"; 
   d="scan'208";a="196186035"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2019 11:01:44 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next v3 0/5][pull request] 1GbE Intel Wired LAN Driver Updates 2019-10-21
Date:   Mon, 21 Oct 2019 11:01:38 -0700
Message-Id: <20191021180143.11775-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to e1000e and igc only.

Sasha adds stream control transmission protocol (SCTP) CRC checksum
support for igc.  Also added S0ix support to the e1000e driver.  Then
added multicast support by adding the address list to the MTA table and
providing the option for IPv6 address for igc.  In addition, added
receive checksum support to igc as well.  Lastly, cleaned up some code
that was not fully implemented yet for the VLAN filter table array.

v2: Dropped patch 1 & 2 from the original series.  Patch 1 is being sent
    to 'net' tree as a fix and patch 2 implementation needs to be
    re-worked.  Updated the patch to add support for S0ix to fix the
    reverse Xmas tree issues and made the entry/exit functions void
    since they constantly returned success.  All based on community
    feedback.
v3: Cleaned up patch 4 of the series based on feedback from the
    community.  Cleaned up a stray comma in a code comment and removed
    the 'inline' of a function that would be inlined by the compiler
    anyways.

The following are changes since commit 13faf77185225a1383f6f5a072383771ccfe456b:
  Merge branch 'hns3-next'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Sasha Neftin (5):
  igc: Add SCTP CRC checksumming functionality
  e1000e: Add support for S0ix
  igc: Add set_rx_mode support
  igc: Add Rx checksum support
  igc: Clean up unused shadow_vfta pointer

 drivers/net/ethernet/intel/e1000e/netdev.c   | 182 +++++++++++++++
 drivers/net/ethernet/intel/e1000e/regs.h     |   4 +
 drivers/net/ethernet/intel/igc/igc.h         |   1 -
 drivers/net/ethernet/intel/igc/igc_defines.h |   8 +-
 drivers/net/ethernet/intel/igc/igc_hw.h      |   1 +
 drivers/net/ethernet/intel/igc/igc_mac.c     | 104 +++++++++
 drivers/net/ethernet/intel/igc/igc_mac.h     |   2 +
 drivers/net/ethernet/intel/igc/igc_main.c    | 226 ++++++++++++++++++-
 8 files changed, 525 insertions(+), 3 deletions(-)

-- 
2.21.0

