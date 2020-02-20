Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A39631653E8
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 01:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbgBTA5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 19:57:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:33266 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727020AbgBTA5R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 19:57:17 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 16:57:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,462,1574150400"; 
   d="scan'208";a="408621338"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.76])
  by orsmga005.jf.intel.com with ESMTP; 19 Feb 2020 16:57:14 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/12][pull request] 1GbE Intel Wired LAN Driver Updates 2020-02-19
Date:   Wed, 19 Feb 2020 16:57:01 -0800
Message-Id: <20200220005713.682605-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to e1000e and igc drivers.

Ben Dooks adds a missing cpu_to_le64() in the e1000e transmit ring flush
function.

Jia-Ju Bai replaces a couple of udelay() with usleep_range() where we
could sleep while holding a spinlock in e1000e.

Chen Zhou make 2 functions static in igc,

Sasha finishes the legacy power management support in igc by adding
resume and schedule suspend requests.  Also added register dump
functionality in the igc driver.  Added device id support for the next
generation of i219 devices in e1000e.  Fixed a typo in the igc driver
that referenced a device that is not support in the driver.  Added the
missing PTP support when suspending now that igc has legacy power
management support.  Added PCIe error detection, slot reset and resume
capability in igc.  Added WoL support for igc as well.  Lastly, added a
code comment to distinguish between interrupt and flag definitions.

Vitaly adds device id support for Tiger Lake platforms, which has
another next generation of i219 device in e1000e.

The following are changes since commit 7d51a01599d5285fc94fa4fcea10afabfa9ca5a4:
  net: mvneta: align xdp stats naming scheme to mlx5 driver
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Ben Dooks (Codethink) (1):
  e1000e: fix missing cpu_to_le64 on buffer_addr

Chen Zhou (1):
  igc: make non-global functions static

Jia-Ju Bai (1):
  net: intel: e1000e: fix possible sleep-in-atomic-context bugs in
    e1000e_get_hw_semaphore()

Sasha Neftin (8):
  igc: Complete to commit Add legacy power management support
  igc: Add dump options
  e1000e: Add support for Alder Lake
  igc: Fix the typo in comment
  igc: Complete to commit Add basic skeleton for PTP
  igc: Add pcie error handler support
  igc: Add WOL support
  igc: Add comment

Vitaly Lifshits (1):
  e1000e: Add support for Tiger Lake device

 drivers/net/ethernet/intel/e1000e/ethtool.c  |   2 +
 drivers/net/ethernet/intel/e1000e/hw.h       |   6 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c  |   7 +
 drivers/net/ethernet/intel/e1000e/mac.c      |   4 +-
 drivers/net/ethernet/intel/e1000e/netdev.c   |   9 +-
 drivers/net/ethernet/intel/e1000e/ptp.c      |   1 +
 drivers/net/ethernet/intel/igc/Makefile      |   2 +-
 drivers/net/ethernet/intel/igc/igc.h         |  10 +-
 drivers/net/ethernet/intel/igc/igc_defines.h |   6 +
 drivers/net/ethernet/intel/igc/igc_dump.c    | 323 +++++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_ethtool.c |  61 ++++
 drivers/net/ethernet/intel/igc/igc_main.c    | 144 +++++++++
 drivers/net/ethernet/intel/igc/igc_ptp.c     |   2 +-
 drivers/net/ethernet/intel/igc/igc_regs.h    |   5 +
 14 files changed, 576 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/igc/igc_dump.c

-- 
2.24.1

