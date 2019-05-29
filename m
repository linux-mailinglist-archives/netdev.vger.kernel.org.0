Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C18C32D2C2
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 02:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfE2AR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 20:17:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:59372 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726601AbfE2AR0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 20:17:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 May 2019 17:17:26 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by FMSMGA003.fm.intel.com with ESMTP; 28 May 2019 17:17:26 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/10][pull request] 1GbE Intel Wired LAN Driver Updates 2019-05-28
Date:   Tue, 28 May 2019 17:17:16 -0700
Message-Id: <20190529001726.26097-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to e1000e, igb and igc.

Feng adds additional information on a warning message when a read of a
hardware register fails.

Gustavo A. R. Silva fixes up two "fall through" code comments so that
the checkers can actually determine that we did comment that the case
statement is falling through to the next case.

Sasha does some cleanup on the igc driver by removing duplicate
#defines and removing unused function pointers.  Also fixed up
white space and removed a unneeded workaround for igc.  Adds support for
flow control to the igc driver.

Konstantin Khlebnikov reverts a previous fix which was causing a false
positive for a hardware hang.  Provides a fix so that when link is lost
the packets in the transmit queue are flushed and wakes the transmit
queue when the NIC is ready to send packets.

The following are changes since commit c7ae09253cb8a11342d7d363591f6edf2a26552b:
  fsl/fman: include IPSEC SPI in the Keygen extraction
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Feng Tang (1):
  igb/igc: warn when fatal read failure happens

Gustavo A. R. Silva (2):
  igb: mark expected switch fall-through
  igb: mark expected switch fall-through

Konstantin Khlebnikov (2):
  Revert "e1000e: fix cyclic resets at link up with active tx"
  e1000e: start network tx queue only when link is up

Sasha Neftin (5):
  igc: Fix double definitions
  igc: Clean up unused pointers
  igc: Remove the obsolete workaround
  igc: Add flow control support
  igc: Cleanup the redundant code

 drivers/net/ethernet/intel/e1000e/netdev.c   | 21 +++++----
 drivers/net/ethernet/intel/igb/e1000_82575.c |  2 +-
 drivers/net/ethernet/intel/igb/igb_main.c    |  3 +-
 drivers/net/ethernet/intel/igc/igc_base.c    | 49 --------------------
 drivers/net/ethernet/intel/igc/igc_defines.h | 18 +++----
 drivers/net/ethernet/intel/igc/igc_hw.h      |  3 --
 drivers/net/ethernet/intel/igc/igc_mac.c     | 23 ++-------
 drivers/net/ethernet/intel/igc/igc_main.c    | 22 +++++++++
 8 files changed, 47 insertions(+), 94 deletions(-)

-- 
2.21.0

