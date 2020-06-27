Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0BD20BDA0
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 03:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgF0Byh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 21:54:37 -0400
Received: from mga03.intel.com ([134.134.136.65]:29242 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726146AbgF0Byg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 21:54:36 -0400
IronPort-SDR: uJoINJ3W/0+LVB7mxo9P7UQXhZF37smsgQ7/JrxBBJ4tuLD1GJy6wwDX8hLzZk0Y69MP+4MWZO
 TU4ePZ6mLpWA==
X-IronPort-AV: E=McAfee;i="6000,8403,9664"; a="145588569"
X-IronPort-AV: E=Sophos;i="5.75,285,1589266800"; 
   d="scan'208";a="145588569"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 18:54:36 -0700
IronPort-SDR: ZtFSvh5A2UbU9SuI3RpmCYM+PwPpD/yCDItqSxKbU2iefOQaJ4oAqb+JMQQpNL9JIx+IIe7fhj
 wxOzKI/QHESQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,285,1589266800"; 
   d="scan'208";a="312495094"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 26 Jun 2020 18:54:36 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/13][pull request] 1GbE Intel Wired LAN Driver Updates 2020-06-26
Date:   Fri, 26 Jun 2020 18:54:18 -0700
Message-Id: <20200627015431.3579234-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to only the igc driver.

Sasha added Energy Efficient Ethernet (EEE) support and Latency Tolerance
Reporting (LTR) support for the igc driver. Added Low Power Idle (LPI)
counters and cleaned up unused TCP segmentation counters. Removed
igc_power_down_link() and call igc_power_down_phy_copper_base()
directly. Removed unneeded copper media check. 

Andre cleaned up timestamping by removing un-supported features and
duplicate code for i225. Fixed the timestamp check on the proper flag
instead of the skb for pending transmit timestamps. Refactored
igc_ptp_set_timestamp_mode() to simply the flow.


The following are changes since commit 61b5cc20c877f9703fa46b24c273cbb5affb26e9:
  net: mvneta: speed down the PHY, if WoL used, to save energy
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Andre Guedes (6):
  igc: Clean up Rx timestamping logic
  igc: Remove duplicate code in Tx timestamp handling
  igc: Check __IGC_PTP_TX_IN_PROGRESS instead of ptp_tx_skb
  igc: Remove UDP filter setup in PTP code
  igc: Refactor igc_ptp_set_timestamp_mode()
  igc: Fix Rx timestamp disabling

Sasha Neftin (7):
  igc: Add initial EEE support
  igc: Add initial LTR support
  igc: Add LPI counters
  igc: Remove TCP segmentation TX fail counter
  igc: Refactor the igc_power_down_link()
  igc: Remove unneeded check for copper media type
  igc: Remove checking media type during MAC initialization

 drivers/net/ethernet/intel/igc/igc.h         |   7 +-
 drivers/net/ethernet/intel/igc/igc_defines.h |  39 ++-
 drivers/net/ethernet/intel/igc/igc_ethtool.c |  97 +++++++
 drivers/net/ethernet/intel/igc/igc_hw.h      |   1 +
 drivers/net/ethernet/intel/igc/igc_i225.c    | 156 +++++++++++
 drivers/net/ethernet/intel/igc/igc_i225.h    |   3 +
 drivers/net/ethernet/intel/igc/igc_mac.c     |  16 +-
 drivers/net/ethernet/intel/igc/igc_main.c    |  48 ++--
 drivers/net/ethernet/intel/igc/igc_ptp.c     | 256 +++++--------------
 drivers/net/ethernet/intel/igc/igc_regs.h    |  16 +-
 10 files changed, 416 insertions(+), 223 deletions(-)

-- 
2.26.2

