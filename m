Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED69635A39E
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 18:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234163AbhDIQm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 12:42:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:9785 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233577AbhDIQm0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 12:42:26 -0400
IronPort-SDR: MfgmgGTO6d8+0CTH2iLgfkunBIwi8ilSBmAKQcEVdTVjU9vfkmmXeI6jwhH/szbiDQZ2Fn8eJ8
 TJayfyDA57uA==
X-IronPort-AV: E=McAfee;i="6000,8403,9949"; a="214235090"
X-IronPort-AV: E=Sophos;i="5.82,209,1613462400"; 
   d="scan'208";a="214235090"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2021 09:42:12 -0700
IronPort-SDR: SyqMpnShnVogW+MuguUzZcGddmmfaXlVz77Y7fUoTGp/JewowYRaA0SD17QgXF/jnvqiTHTS9u
 nHP1EppT6QgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,209,1613462400"; 
   d="scan'208";a="531055053"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 09 Apr 2021 09:42:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        jithu.joseph@intel.com
Subject: [PATCH net-next 0/9][pull request] 1GbE Intel Wired LAN Driver Updates 2021-04-09
Date:   Fri,  9 Apr 2021 09:43:42 -0700
Message-Id: <20210409164351.188953-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igc driver only.

Andre Guedes says:

This series adds AF_XDP zero-copy feature to igc driver.

The initial patches do some code refactoring, preparing the code base to
land the AF_XDP zero-copy feature, avoiding code duplications. The last
patches of the series are the ones implementing the feature.

The last patch which indeed implements AF_XDP zero-copy support was
originally way too lengthy so, for the sake of code review, I broke it
up into two patches: one adding support for the RX functionality and the
other one adding TX support.

The following are changes since commit 4438669eb703d1a7416c2b19a8a15b0400b36738:
  Merge tag 'for-net-next-2021-04-08' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Andre Guedes (9):
  igc: Move igc_xdp_is_enabled()
  igc: Refactor __igc_xdp_run_prog()
  igc: Refactor igc_clean_rx_ring()
  igc: Refactor XDP rxq info registration
  igc: Introduce TX/RX stats helpers
  igc: Introduce igc_unmap_tx_buffer() helper
  igc: Replace IGC_TX_FLAGS_XDP flag by an enum
  igc: Enable RX via AF_XDP zero-copy
  igc: Enable TX via AF_XDP zero-copy

 drivers/net/ethernet/intel/igc/igc.h      |  33 +-
 drivers/net/ethernet/intel/igc/igc_base.h |   2 +
 drivers/net/ethernet/intel/igc/igc_main.c | 650 ++++++++++++++++++----
 drivers/net/ethernet/intel/igc/igc_xdp.c  | 107 +++-
 drivers/net/ethernet/intel/igc/igc_xdp.h  |   8 +-
 5 files changed, 673 insertions(+), 127 deletions(-)

-- 
2.26.2

