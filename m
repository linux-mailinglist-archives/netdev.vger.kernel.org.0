Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5116241B9A7
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 23:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242940AbhI1Vzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 17:55:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:59509 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242494AbhI1Vze (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 17:55:34 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10121"; a="224851562"
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="224851562"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 14:53:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="486701061"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 28 Sep 2021 14:53:54 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/6][pull request] 100GbE Intel Wired LAN Driver Updates 2021-09-28
Date:   Tue, 28 Sep 2021 14:57:51 -0700
Message-Id: <20210928215757.3378414-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Dave adds support for QoS DSCP allowing for DSCP to TC mapping via APP
TLVs.

Ani adds enforcement of DSCP to only supported devices with the
introduction of a feature bitmap and corrects messaging of unsupported
modules based on link mode.

Jake refactors devlink info functions to be void as the functions no
longer return errors.

Jeff fixes a macro name to properly reflect the value.

Len Baker converts a kzalloc allocation to, the preferred, kcalloc.

The following are changes since commit 1e0083bd0777e4a418a6710d9ee04b979cdbe5cc:
  gve: DQO: avoid unused variable warnings
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Anirudh Venkataramanan (2):
  ice: Add feature bitmap, helpers and a check for DSCP
  ice: Fix link mode handling

Dave Ertman (1):
  ice: Add DSCP support

Jacob Keller (1):
  ice: refactor devlink getter/fallback functions to void

Jeff Guo (1):
  ice: Fix macro name for IPv4 fragment flag

Len Baker (1):
  ice: Prefer kcalloc over open coded arithmetic

 drivers/net/ethernet/intel/ice/ice.h          |   6 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  15 ++
 drivers/net/ethernet/intel/ice/ice_arfs.c     |   2 +-
 drivers/net/ethernet/intel/ice/ice_dcb.c      | 225 ++++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_dcb.h      |  18 ++
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   7 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |  12 +
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c   | 192 ++++++++++++---
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 133 ++++-------
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   7 +
 drivers/net/ethernet/intel/ice/ice_fdir.c     |   2 +-
 drivers/net/ethernet/intel/ice/ice_fdir.h     |   2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      |  47 ++++
 drivers/net/ethernet/intel/ice/ice_lib.h      |   2 +
 drivers/net/ethernet/intel/ice/ice_main.c     |  11 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  34 +++
 drivers/net/ethernet/intel/ice/ice_txrx.h     |   3 +
 drivers/net/ethernet/intel/ice/ice_type.h     |  10 +-
 18 files changed, 584 insertions(+), 144 deletions(-)

-- 
2.26.2

