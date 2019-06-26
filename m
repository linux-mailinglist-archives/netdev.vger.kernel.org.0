Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79BB6571CA
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 21:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfFZTae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 15:30:34 -0400
Received: from mga14.intel.com ([192.55.52.115]:41403 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbfFZTae (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 15:30:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jun 2019 12:30:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,420,1557212400"; 
   d="scan'208";a="188762452"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga002.fm.intel.com with ESMTP; 26 Jun 2019 12:30:33 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/10][pull request] Intel Wired LAN Driver Updates 2019-06-26
Date:   Wed, 26 Jun 2019 12:30:53 -0700
Message-Id: <20190626193103.2169-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ixgbe and i40e only.

Mauro S. M. Rodrigues update the ixgbe driver to handle transceivers who
comply with SFF-8472 but do not implement the Digital Diagnostic
Monitoring (DOM) interface.  Update the driver to check the necessary
bits to see if DOM is implemented before trying to read the additional
256 bytes in the EEPROM for DOM data.

Young Xiao fixes a potential divide by zero issue in ixgbe driver.

Aleksandr fixes i40e to recognize 2.5 and 5.0 GbE link speeds so that it
is not reported as "Unknown bps".  Fixes the driver to read the firmware
LLDP agent status during DCB initialization, and to properly log the
LLDP agent status to help with debugging when DCB fails to initialize.

Martyna fixes i40e for the missing supported and advertised link modes
information in ethtool.

Jake fixes a function header comment that was incorrect for a PTP
function in i40e.

Maciej fixes an issue for i40e when a XDP program is loaded the
descriptor count gets reset to the default value, resolve the issue by
making the current descriptor count persistent across resets.

Alice corrects a copyright date which she found to be incorrect.

Piotr adds a log entry when the traffic class 0 is added or deleted, which
was not being logged previously.

Gustavo A. R. Silva updates i40e to use struct_size() where possible.

The following are changes since commit 3b525691529b01cbea03ce07e5df487da5e44a31:
  ipv6: fix suspicious RCU usage in rt6_dump_route()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 40GbE

Aleksandr Loktionov (2):
  i40e: fix 'Unknown bps' in dmesg for 2.5Gb/5Gb speeds
  i40e: missing priorities for any QoS traffic

Alice Michael (1):
  i40e: update copyright string

Gustavo A. R. Silva (1):
  i40e/i40e_virtchnl_pf: Use struct_size() in kzalloc()

Jacob Keller (1):
  i40e: fix incorrect function documentation comment

Maciej Fijalkowski (1):
  i40e: Fix descriptor count manipulation

Martyna Szapar (1):
  i40e: Fix for missing "link modes" info in ethtool

Mauro S. M. Rodrigues (1):
  ixgbe: Check DDM existence in transceiver before access

Piotr Kwapulinski (1):
  i40e: Add log entry while creating or deleting TC0

Young Xiao (1):
  ixgbevf: fix possible divide by zero in ixgbevf_update_itr

 drivers/net/ethernet/intel/i40e/i40e.h        |  3 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c |  3 +-
 .../net/ethernet/intel/i40e/i40e_debugfs.c    |  5 +-
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |  4 +
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 99 ++++++++++++++++---
 .../net/ethernet/intel/i40e/i40e_prototype.h  |  4 +
 drivers/net/ethernet/intel/i40e/i40e_ptp.c    |  3 +-
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 15 ++-
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  |  3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h  |  1 +
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  3 +
 include/linux/avf/virtchnl.h                  |  4 +
 12 files changed, 115 insertions(+), 32 deletions(-)

-- 
2.21.0

