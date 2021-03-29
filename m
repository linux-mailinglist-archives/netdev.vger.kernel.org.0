Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF45D34D5B7
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 19:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbhC2RIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 13:08:02 -0400
Received: from mga02.intel.com ([134.134.136.20]:51878 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230323AbhC2RH7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 13:07:59 -0400
IronPort-SDR: JZPVtubKc5JhaIqpjz31VQSF3iQPXjT/u44fUaEgiTw7c5O7xH5GAt4TPHb/MJOKZtWH2XgHR1
 +BA0OMnGweGg==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="178720122"
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="178720122"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 10:07:58 -0700
IronPort-SDR: k0gN/AywzWnYFN5l7HTEx4gH2uhXpnTngPyECy/XCuXtvpjMOk3csmVYU+lVQT6/NHbpDR5I0g
 kXTSdyTBqEYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="606447250"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 29 Mar 2021 10:07:58 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        jithu.joseph@intel.com
Subject: [PATCH net-next 0/8][pull request] 1GbE Intel Wired LAN Driver Updates 2021-03-29
Date:   Mon, 29 Mar 2021 10:09:23 -0700
Message-Id: <20210329170931.2356162-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igc driver only.

Andre Guedes says:

Add XDP support for the igc driver. The approach implemented by this
series follows the same approach implemented in other Intel drivers as
much as possible for the sake of consistency.

The series is organized in two parts. In the first part, i.e. patches
from 1 to 4, igc_main.c and igc_ptp.c code is refactored in preparation
for landing the XDP support, which is introduced in the second part
(patches from 5 to 8).

As far as code organization is concerned, XDP-related helpers are
defined in a new file, igc_xdp.c, and are called by igc_main.c.

The features added by this series have been tested with the samples
provided in samples/bpf/: xdp1, xdp2, xdp_redirect_cpu, and
xdp_redirect_map.

Upcoming series will add support of UMEM and zero-copy features from
AF_XDP.

The following are changes since commit 9d0365448b5b954bba1b551ade5b273d629446bb:
  net: moxa: remove redundant dev_err call in moxart_mac_probe()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Andre Guedes (8):
  igc: Remove unused argument from igc_tx_cmd_type()
  igc: Introduce igc_rx_buffer_flip() helper
  igc: Introduce igc_get_rx_frame_truesize() helper
  igc: Refactor Rx timestamp handling
  igc: Add set/clear large buffer helpers
  igc: Add initial XDP support
  igc: Add support for XDP_TX action
  igc: Add support for XDP_REDIRECT action

 drivers/net/ethernet/intel/igc/Makefile   |   2 +-
 drivers/net/ethernet/intel/igc/igc.h      |  18 +-
 drivers/net/ethernet/intel/igc/igc_main.c | 458 +++++++++++++++++++---
 drivers/net/ethernet/intel/igc/igc_ptp.c  |  25 +-
 drivers/net/ethernet/intel/igc/igc_xdp.c  |  60 +++
 drivers/net/ethernet/intel/igc/igc_xdp.h  |  13 +
 6 files changed, 496 insertions(+), 80 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/igc/igc_xdp.c
 create mode 100644 drivers/net/ethernet/intel/igc/igc_xdp.h

-- 
2.26.2

