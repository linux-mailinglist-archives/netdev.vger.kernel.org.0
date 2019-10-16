Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42A70DA274
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 01:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406808AbfJPXrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 19:47:13 -0400
Received: from mga05.intel.com ([192.55.52.43]:41139 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729333AbfJPXrN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 19:47:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 16:47:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,305,1566889200"; 
   d="scan'208";a="202220671"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Oct 2019 16:47:12 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 0/7][pull request] 1GbE Intel Wired LAN Driver Updates 2019-10-16
Date:   Wed, 16 Oct 2019 16:47:04 -0700
Message-Id: <20191016234711.21823-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to e1000e, igc and igb.

Lyude Paul fixes a warning that was occurring during a fatal read error
while the device is still present.

Robert Beckett adds receive drop enable support via ehttool private flag
for igb.

Sasha adds stream control transmission protocol (SCTP) CRC checksum
support for igc.  Also added S0ix support to the e1000e driver.  Then
added multicast support by adding the address list to the MTA table and
providing the option for IPv6 address for igc.  In addition, added
receive checksum support to igc as well.  Lastly, cleaned up some code
that was not fully implemented yet for the VLAN filter table array.

The following are changes since commit d9f45ab9e671166004b75427f10389e1f70cfc30:
  net: bcmgenet: Add a shutdown callback
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Lyude Paul (1):
  igb/igc: Don't warn on fatal read failures when the device is removed

Robert Beckett (1):
  igb: add rx drop enable attribute

Sasha Neftin (5):
  igc: Add SCTP CRC checksumming functionality
  e1000e: Add support for S0ix
  igc: Add set_rx_mode support
  igc: Add Rx checksum support
  igc: Clean up unused shadow_vfta pointer

 drivers/net/ethernet/intel/e1000e/netdev.c   | 186 +++++++++++++++
 drivers/net/ethernet/intel/e1000e/regs.h     |   4 +
 drivers/net/ethernet/intel/igb/igb.h         |   1 +
 drivers/net/ethernet/intel/igb/igb_ethtool.c |   8 +
 drivers/net/ethernet/intel/igb/igb_main.c    |  14 +-
 drivers/net/ethernet/intel/igc/igc.h         |   1 -
 drivers/net/ethernet/intel/igc/igc_defines.h |   8 +-
 drivers/net/ethernet/intel/igc/igc_hw.h      |   1 +
 drivers/net/ethernet/intel/igc/igc_mac.c     | 104 +++++++++
 drivers/net/ethernet/intel/igc/igc_mac.h     |   2 +
 drivers/net/ethernet/intel/igc/igc_main.c    | 229 ++++++++++++++++++-
 11 files changed, 551 insertions(+), 7 deletions(-)

-- 
2.21.0

