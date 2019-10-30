Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D03E5E95C8
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 05:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbfJ3Egf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 00:36:35 -0400
Received: from mga17.intel.com ([192.55.52.151]:15159 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725308AbfJ3Ege (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 00:36:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Oct 2019 21:36:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,246,1569308400"; 
   d="scan'208";a="211979425"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga002.jf.intel.com with ESMTP; 29 Oct 2019 21:36:34 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 0/8][pull request] 1GbE Intel Wired LAN Driver Updates 2019-10-29
Date:   Tue, 29 Oct 2019 21:36:25 -0700
Message-Id: <20191030043633.26249-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to e1000e, igb, ixgbe and i40e drivers.

Sasha adds support for Intel client platforms Comet Lake and Tiger Lake
to the e1000e driver.  Also adds a fix for a compiler warning that was
recently introduced, when CONFIG_PM_SLEEP is not defined, so wrap the
code that requires this kernel configuration to be defined.

Alex fixes a potential race condition between network configuration and
power management for e1000e, which is similar to a past issue in the igb
driver.  Also provided a bit of code cleanup since the driver no longer
checks for __E1000_DOWN.

Josh Hunt adds UDP segmentation offload support for igb, ixgbe and i40e.

The following are changes since commit 199f3ac319554f1ffddcc8e832448843f073d4c7:
  ionic: Remove set but not used variable 'sg_desc'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Alexander Duyck (2):
  e1000e: Use rtnl_lock to prevent race conditions between net and
    pci/pm
  e1000e: Drop unnecessary __E1000_DOWN bit twiddling

Josh Hunt (3):
  igb: Add UDP segmentation offload support
  ixgbe: Add UDP segmentation offload support
  i40e: Add UDP segmentation offload support

Sasha Neftin (3):
  e1000e: Add support for Comet Lake
  e1000e: Add support for Tiger Lake
  e1000e: Fix compiler warning when CONFIG_PM_SLEEP is not set

 drivers/net/ethernet/intel/e1000e/ethtool.c   |  4 +-
 drivers/net/ethernet/intel/e1000e/hw.h        | 12 +++
 drivers/net/ethernet/intel/e1000e/ich8lan.c   |  7 ++
 drivers/net/ethernet/intel/e1000e/netdev.c    | 91 +++++++++++--------
 drivers/net/ethernet/intel/e1000e/ptp.c       |  2 +
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  1 +
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 12 ++-
 drivers/net/ethernet/intel/igb/e1000_82575.h  |  1 +
 drivers/net/ethernet/intel/igb/igb_main.c     | 23 +++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 24 +++--
 10 files changed, 122 insertions(+), 55 deletions(-)

-- 
2.21.0

