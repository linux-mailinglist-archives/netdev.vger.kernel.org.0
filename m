Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3978B1AFDD8
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 21:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgDSTvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 15:51:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:45111 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgDSTvd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 15:51:33 -0400
IronPort-SDR: ca8GZOK44RcRuhSFtYC/l6YasB8GAAo6nA6+2k+Y9aNkwWbFLyuvry0k1xH80AusPJf63UoTni
 e45JyXQ3BI8Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2020 12:51:32 -0700
IronPort-SDR: Z+hz8Yq+rjaQuhkv4OhcGse6W8W/qPXXF7sO5M7q3saYUlOcFge1DLsspBIDimhoDIal3kSc2f
 gZh1JAvQTlOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,404,1580803200"; 
   d="scan'208";a="279034390"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 19 Apr 2020 12:51:32 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/14][pull request] 1GbE Intel Wired LAN Driver Updates 2020-04-19
Date:   Sun, 19 Apr 2020 12:51:17 -0700
Message-Id: <20200419195131.1068144-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to e1000e and igc only.

Sasha adds new device IDs supported by the igc driver.

Vitaly fixes the S0ix entry and exit flows in e1000e for TGP and newer
MAC types when a cable is connected.

Andre has the remaining changes in the series, starting with cleanup of
the igc driver of duplicate code.  Added a check for
IGC_MAC_STATE_SRC_ADDR flag which is unsupported for MAC filters in igc.
Cleaned up the return values for igc_add_mac_filter(), where the return
value was not being used, so update the function to only return success
or failure.  Fix the return value of igc_uc_unsync() as well.  Refactor
the igc driver in several functions to help reduce the convoluted logic
and simplify the driver filtering mechanisms.  Improve the MAC address
checks when adding a MAC filter.  Lastly, improve the log messages
related to MAC address filtering to ease debugging.

The following are changes since commit 0fde6e3b55a15a13f3b5aa484a79fe5298c1ed40:
  Merge branch 'r8169-series-with-improvements'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Andre Guedes (12):
  igc: Remove duplicate code in MAC filtering logic
  igc: Check unsupported flag in igc_add_mac_filter()
  igc: Change igc_add_mac_filter() returning value
  igc: Fix igc_uc_unsync()
  igc: Refactor igc_rar_set_index()
  igc: Improve address check in igc_del_mac_filter()
  igc: Remove 'queue' check in igc_del_mac_filter()
  igc: Remove IGC_MAC_STATE_QUEUE_STEERING
  igc: Remove igc_*_mac_steering_filter() wrappers
  igc: Refactor igc_mac_entry_can_be_used()
  igc: Refactor igc_del_mac_filter()
  igc: Add debug messages to MAC filter code

Sasha Neftin (1):
  igc: Add new device IDs for i225 part

Vitaly Lifshits (1):
  e1000e: fix S0ix flows for cable connected case

 drivers/net/ethernet/intel/e1000e/netdev.c   |  54 +++
 drivers/net/ethernet/intel/e1000e/regs.h     |   3 +
 drivers/net/ethernet/intel/igc/igc.h         |  11 +-
 drivers/net/ethernet/intel/igc/igc_base.c    |   3 +
 drivers/net/ethernet/intel/igc/igc_ethtool.c |  22 +-
 drivers/net/ethernet/intel/igc/igc_hw.h      |   3 +
 drivers/net/ethernet/intel/igc/igc_main.c    | 371 ++++++++-----------
 7 files changed, 233 insertions(+), 234 deletions(-)

-- 
2.25.2

