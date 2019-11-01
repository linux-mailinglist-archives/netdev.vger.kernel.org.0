Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 733D0EC991
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 21:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbfKAUZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 16:25:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:47883 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726701AbfKAUZl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 16:25:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Nov 2019 13:25:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,256,1569308400"; 
   d="scan'208";a="375669933"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga005.jf.intel.com with ESMTP; 01 Nov 2019 13:25:40 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net v2 0/7][pull request] Intel Wired LAN Driver Updates 2019-11-01
Date:   Fri,  1 Nov 2019 13:25:31 -0700
Message-Id: <20191101202538.665-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to e1000, igb, igc, ixgbe, i40e and driver
documentation.

Lyude Paul fixes an issue where a fatal read error occurs when the
device is unplugged from the machine.  So change the read error into a
warn while the device is still present.

Manfred Rudigier found that the i350 device was not apart of the "Media
Auto Sense" feature, yet the device supports it.  So add the missing
i350 device to the check and fix an issue where the media auto sense
would flip/flop when no cable was connected to the port causing spurious
kernel log messages.

I fixed an issue where the fix to resolve receive buffer starvation was
applied in more than one place in the driver, one being the incorrect
location in the i40e driver.

Wenwen Wang fixes a potential memory leak in e1000 where allocated
memory is not properly cleaned up in one of the error paths.

Jonathan Neuschäfer cleans up the driver documentation to be consistent
and remove the footnote reference, since the footnote no longer exists in
the documentation.

Igor Pylypiv cleans up a duplicate clearing of a bit, no need to clear
it twice.

v2: Fixed alignment issue in patch 3 of the series based on community
    feedback.

The following are changes since commit 6d6f0383b697f004c65823c2b64240912f18515d:
  netdevsim: Fix use-after-free during device dismantle
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/net-queue 1GbE

Igor Pylypiv (1):
  ixgbe: Remove duplicate clear_bit() call

Jeff Kirsher (1):
  i40e: Fix receive buffer starvation for AF_XDP

Jonathan Neuschäfer (1):
  Documentation: networking: device drivers: Remove stray asterisks

Lyude Paul (1):
  igb/igc: Don't warn on fatal read failures when the device is removed

Manfred Rudigier (2):
  igb: Enable media autosense for the i350.
  igb: Fix constant media auto sense switching when no cable is
    connected

Wenwen Wang (1):
  e1000: fix memory leaks

 .../networking/device_drivers/intel/e100.rst       | 14 +++++++-------
 .../networking/device_drivers/intel/e1000.rst      | 12 ++++++------
 .../networking/device_drivers/intel/e1000e.rst     | 14 +++++++-------
 .../networking/device_drivers/intel/fm10k.rst      | 10 +++++-----
 .../networking/device_drivers/intel/i40e.rst       |  8 ++++----
 .../networking/device_drivers/intel/iavf.rst       |  8 ++++----
 .../networking/device_drivers/intel/ice.rst        |  6 +++---
 .../networking/device_drivers/intel/igb.rst        | 12 ++++++------
 .../networking/device_drivers/intel/igbvf.rst      |  6 +++---
 .../networking/device_drivers/intel/ixgbe.rst      | 10 +++++-----
 .../networking/device_drivers/intel/ixgbevf.rst    |  6 +++---
 .../networking/device_drivers/pensando/ionic.rst   |  6 +++---
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c   |  7 +++----
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |  5 -----
 drivers/net/ethernet/intel/igb/e1000_82575.c       |  2 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |  8 +++++---
 drivers/net/ethernet/intel/igc/igc_main.c          |  3 ++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  1 -
 18 files changed, 67 insertions(+), 71 deletions(-)

-- 
2.21.0

