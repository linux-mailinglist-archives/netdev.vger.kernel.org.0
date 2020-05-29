Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10031E74FF
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 06:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgE2EkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 00:40:06 -0400
Received: from mga03.intel.com ([134.134.136.65]:40323 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgE2EkF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 00:40:05 -0400
IronPort-SDR: Rf74eTW9sc+x/tzD7SvDk9FdOC6bfHcodNorGzwMjjVhbGbpqMdjXetdPQRuqXDowZeC7kga1g
 en1doV7z2HXg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 21:40:05 -0700
IronPort-SDR: lhIlSsI1a3ySA2/TAOmWu6ZZZT7QL94LdDHAsFm36U/715kdDrXm1BwnjR0D2Xg9U+6b6Sn+ai
 CNIShdN8JKlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="414850892"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 28 May 2020 21:40:05 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/17][pull request] Intel Wired LAN Driver Updates 2020-05-28
Date:   Thu, 28 May 2020 21:39:47 -0700
Message-Id: <20200529044004.3725307-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to e1000, e1000e, igc, igb, ixgbe and i40e.

Takashi Iwai, from SUSE, replaces some uses of snprintf() with
scnprintf() since the succeeding calls may go beyond the given buffer
limit in i40e.

Jesper Dangaard Brouer fixes up code comments in i40e_xsk.c

Xie XiuQi, from Huawei, fixes a signed-integer-overflow warning ixgbe
driver.

Jason Yan, from Huawei, converts '==' expression to bool to resolve
warnings, also fixed a warning for assigning 0/1 to a bool variable in
the ixgbe driver.  Converts functions that always return 0 to void in the
igb and i40e drivers.

YueHaibing, from Hauwei, cleans up dead code in ixgbe driver.

Sasha cleans up more dead code which is not used in the igc driver.
Added receive error counter to reflect the total number of non-filtered
packets received with errors.  Fixed a register define name to properly
reflect the register address being used.

Andre updates the igc driver to reject NFC rules that have multiple
matches, which is not supported in i225 devices.  Updates the total
number of NFC rules supported and added a code comment to explain what
is supported.

Punit Agrawal, from Toshiba, relaxes the condition to trigger a reset
for ME, which was leading to inconsistency between the state of the
hardware as expected by the driver in e1000e.

Hari, from the Linux community, cleaned up a code comment in the e1000
driver.

The following are changes since commit 394f9ebf92c899b42207d4e71465869656981ba1:
  Merge branch 'hns3-next'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 10GbE

Andre Guedes (2):
  igc: Reject NFC rules with multiple matches
  igc: Fix IGC_MAX_RXNFC_RULES

Hari (1):
  e1000: Fix typo in the comment

Jason Yan (4):
  ixgbe: Remove conversion to bool in ixgbe_device_supports_autoneg_fc()
  ixgbe: Use true, false for bool variable in __ixgbe_enable_sriov()
  igb: make igb_set_fc_watermarks() return void
  i40e: Make i40e_shutdown_adminq() return void

Jesper Dangaard Brouer (1):
  i40e: trivial fixup of comments in i40e_xsk.c

Punit Agrawal (1):
  e1000e: Relax condition to trigger reset for ME workaround

Sasha Neftin (5):
  igc: Remove unused flags
  igc: Remove symbol error counter
  igc: Add Receive Error Counter
  igc: Remove Sequence Error Counter
  igc: Fix wrong register name

Takashi Iwai (1):
  i40e: Use scnprintf() for avoiding potential buffer overflow

Xie XiuQi (1):
  ixgbe: fix signed-integer-overflow warning

YueHaibing (1):
  ixgbe: Remove unused inline function ixgbe_irq_disable_queues

 drivers/net/ethernet/intel/e1000/e1000_hw.c   |  2 +-
 drivers/net/ethernet/intel/e1000e/e1000.h     |  1 -
 drivers/net/ethernet/intel/e1000e/netdev.c    | 12 ++++----
 drivers/net/ethernet/intel/i40e/i40e_adminq.c |  6 +---
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 24 +++++++--------
 .../net/ethernet/intel/i40e/i40e_prototype.h  |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    |  4 +--
 drivers/net/ethernet/intel/igb/e1000_mac.c    |  9 ++----
 drivers/net/ethernet/intel/igc/igc.h          |  5 +++-
 drivers/net/ethernet/intel/igc/igc_defines.h  |  4 ---
 drivers/net/ethernet/intel/igc/igc_ethtool.c  |  9 +++---
 drivers/net/ethernet/intel/igc/igc_mac.c      |  5 ++--
 drivers/net/ethernet/intel/igc/igc_main.c     |  3 +-
 drivers/net/ethernet/intel/igc/igc_regs.h     |  5 ++--
 .../net/ethernet/intel/ixgbe/ixgbe_common.c   |  5 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 29 -------------------
 .../net/ethernet/intel/ixgbe/ixgbe_sriov.c    |  2 +-
 17 files changed, 40 insertions(+), 87 deletions(-)

-- 
2.26.2

