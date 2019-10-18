Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC82DD0EE
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 23:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408213AbfJRVNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 17:13:44 -0400
Received: from mga07.intel.com ([134.134.136.100]:17946 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394230AbfJRVNn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 17:13:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Oct 2019 14:13:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,313,1566889200"; 
   d="scan'208";a="208752585"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga002.jf.intel.com with ESMTP; 18 Oct 2019 14:13:42 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next v2 0/5][pull request] 1GbE Intel Wired LAN Driver Updates 2019-10-18
Date:   Fri, 18 Oct 2019 14:13:35 -0700
Message-Id: <20191018211340.31885-1-jeffrey.t.kirsher@intel.com>
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

The following are changes since commit 3858a6451efa795c5a97c33c2735974ac9ec9d6a:
  Merge branch 'selftests-mlxsw-Add-scale-tests-for-Spectrum-2'
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

