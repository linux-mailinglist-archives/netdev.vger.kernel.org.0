Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1042323122C
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 21:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732575AbgG1TIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 15:08:51 -0400
Received: from mga05.intel.com ([192.55.52.43]:43602 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728978AbgG1TIu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 15:08:50 -0400
IronPort-SDR: p8l4UBDFoMsf7KFmm7r2bz7mpJtj/AOOwHA5ICoaPq3h/JC26ulESMGphls8LLnIzL85B2YfdO
 YKFF55fdQLcQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9696"; a="236163818"
X-IronPort-AV: E=Sophos;i="5.75,407,1589266800"; 
   d="scan'208";a="236163818"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 12:08:50 -0700
IronPort-SDR: hAOPlGDgLAyWAGc1eTyWDV90YDDvSXr9cFwCucZTxj7+fWePYOrxBm9GonVtsK9Fe2surFU3vA
 RO37rW9M9tyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,407,1589266800"; 
   d="scan'208";a="490006214"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga006.fm.intel.com with ESMTP; 28 Jul 2020 12:08:48 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com
Subject: [net-next 0/6][pull request] 40GbE Intel Wired LAN Driver Updates 2020-07-28
Date:   Tue, 28 Jul 2020 12:08:36 -0700
Message-Id: <20200728190842.1284145-1-anthony.l.nguyen@intel.com>
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
descriptors, using 16 byte descriptors, increasing budget for AF_XDP
receive, and moving buffer allocation out of Rx processing loop.

The following are changes since commit 5e619d73e6797ed9f2554a1bf996d52d8c91ca50:
  net/mlx4: Use fallthrough pseudo-keyword
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 40GbE

Björn Töpel (4):
  i40e, xsk: remove HW descriptor prefetch in AF_XDP path
  i40e: use 16B HW descriptors instead of 32B
  i40e, xsk: increase budget for AF_XDP path
  i40e, xsk: move buffer allocation out of the Rx processing loop

Li RongQing (2):
  i40e: not compute affinity_mask for IRQ
  i40e: prefetch struct page of Rx buffer conditionally

 drivers/net/ethernet/intel/i40e/i40e.h        |  2 +-
 .../net/ethernet/intel/i40e/i40e_debugfs.c    | 10 +++----
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 16 ++++-------
 drivers/net/ethernet/intel/i40e/i40e_trace.h  |  6 ++--
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 21 ++++++++++++--
 drivers/net/ethernet/intel/i40e/i40e_txrx.h   |  2 +-
 .../ethernet/intel/i40e/i40e_txrx_common.h    | 13 ---------
 drivers/net/ethernet/intel/i40e/i40e_type.h   |  5 +++-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 28 +++++++++++++------
 9 files changed, 55 insertions(+), 48 deletions(-)

-- 
2.26.2

