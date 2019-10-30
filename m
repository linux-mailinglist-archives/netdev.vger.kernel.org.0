Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25D1DE9545
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 04:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfJ3D3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 23:29:12 -0400
Received: from mga03.intel.com ([134.134.136.65]:2937 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726714AbfJ3D3M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 23:29:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Oct 2019 20:29:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,245,1569308400"; 
   d="scan'208";a="205673632"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Oct 2019 20:29:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 0/9][pull request] 100GbE Intel Wired LAN Driver Updates 2019-10-29
Date:   Tue, 29 Oct 2019 20:29:01 -0700
Message-Id: <20191030032910.24261-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to the ice driver only.

Anirudh refactors the code to reduce the kernel configuration flags and
introduces ice_base.c file.

Maciej does additional refactoring on the configuring of transmit
rings so that we are not configuring per each traffic class flow.
Added support for XDP in the ice driver.  Provides additional
re-organizing of the code in preparation for adding build_skb() support
in the driver.  Adjusted the computational padding logic for headroom
and tailroom to better support build_skb(), which also aligns with the
logic in other Intel LAN drivers.  Added build_skb support and make use
of the XDP's data_meta.

Krzysztof refactors the driver to prepare for AF_XDP support in the
driver and then adds support for AF_XDP.

The following are changes since commit 199f3ac319554f1ffddcc8e832448843f073d4c7:
  ionic: Remove set but not used variable 'sg_desc'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Anirudh Venkataramanan (1):
  ice: Introduce ice_base.c

Krzysztof Kazimierczak (2):
  ice: Move common functions to ice_txrx_lib.c
  ice: Add support for AF_XDP

Maciej Fijalkowski (6):
  ice: get rid of per-tc flow in Tx queue configuration routines
  ice: Add support for XDP
  ice: introduce legacy Rx flag
  ice: introduce frame padding computation logic
  ice: add build_skb() support
  ice: allow 3k MTU for XDP

 drivers/net/ethernet/intel/ice/Makefile       |    3 +
 drivers/net/ethernet/intel/ice/ice.h          |   59 +-
 drivers/net/ethernet/intel/ice/ice_base.c     |  857 ++++++++++++
 drivers/net/ethernet/intel/ice/ice_base.h     |   31 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |    1 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   65 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      |  985 +++-----------
 drivers/net/ethernet/intel/ice/ice_lib.h      |   49 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |  345 +++++
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  578 ++++----
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  140 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  273 ++++
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h |   59 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |    1 +
 drivers/net/ethernet/intel/ice/ice_xsk.c      | 1181 +++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_xsk.h      |   72 +
 16 files changed, 3547 insertions(+), 1152 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_base.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_base.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_txrx_lib.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_txrx_lib.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_xsk.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_xsk.h

-- 
2.21.0

