Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC33D269372
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 19:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgINRc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 13:32:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:61353 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbgINRci (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 13:32:38 -0400
IronPort-SDR: 6cakbeBw9izHUeRGP819DgQkn9958vIZNJ+jB0T0RFkBpsqVDKBU9e2faXDtvXKize8TK7Wv+b
 LAAo/6qTpM5Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="160056110"
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="160056110"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 10:32:31 -0700
IronPort-SDR: vCgNck1gV4po1b8ZlTzcAOwUDgBHLhgcUCSDTSCES9oA7WrNpMy+9DuPWS5P49yegjxp5INWDU
 h/1yHvsTSBUw==
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="319137308"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 10:32:31 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com
Subject: [net-next v2 0/5][pull request] 40GbE Intel Wired LAN Driver Updates 2020-09-14
Date:   Mon, 14 Sep 2020 10:32:19 -0700
Message-Id: <20200914173224.692707-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e driver only.

Li RongQing removes binding affinity mask to a fixed CPU and sets
prefetch of Rx buffer page to occur conditionally.

Björn provides AF_XDP performance improvements by not prefetching HW
descriptors, using 16 byte descriptors, and moving buffer allocation
out of Rx processing loop.

v2: Define prefetch_page_address in a common header for patch 2.
Dropped, previous, patch 5 as it is being reworked to be more
generalized.

The following are changes since commit e059c6f340f6fccadd3db9993f06d4cc51305804:
  tulip: switch from 'pci_' to 'dma_' API
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 40GbE

Björn Töpel (3):
  i40e, xsk: remove HW descriptor prefetch in AF_XDP path
  i40e: use 16B HW descriptors instead of 32B
  i40e, xsk: move buffer allocation out of the Rx processing loop

Li RongQing (2):
  i40e: not compute affinity_mask for IRQ
  i40e: optimise prefetch page refcount

 drivers/net/ethernet/intel/i40e/i40e.h        |  2 +-
 .../net/ethernet/intel/i40e/i40e_debugfs.c    | 10 ++++----
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 16 ++++---------
 drivers/net/ethernet/intel/i40e/i40e_trace.h  |  6 ++---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 21 ++++++++++++----
 drivers/net/ethernet/intel/i40e/i40e_txrx.h   |  2 +-
 .../ethernet/intel/i40e/i40e_txrx_common.h    | 13 ----------
 drivers/net/ethernet/intel/i40e/i40e_type.h   |  5 +++-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 24 ++++++++++++-------
 include/linux/prefetch.h                      |  8 +++++++
 10 files changed, 59 insertions(+), 48 deletions(-)

-- 
2.26.2

