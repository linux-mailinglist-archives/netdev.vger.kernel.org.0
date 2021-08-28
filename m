Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B103FA79D
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 23:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234583AbhH1V3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 17:29:14 -0400
Received: from mga06.intel.com ([134.134.136.31]:33138 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232060AbhH1V3N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Aug 2021 17:29:13 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10090"; a="279133487"
X-IronPort-AV: E=Sophos;i="5.84,359,1620716400"; 
   d="scan'208";a="279133487"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2021 14:28:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,359,1620716400"; 
   d="scan'208";a="688086357"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.22.231])
  by fmsmga005.fm.intel.com with ESMTP; 28 Aug 2021 14:28:19 -0700
From:   Maciej Machnikowski <maciej.machnikowski@intel.com>
To:     maciej.machnikowski@intel.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
Cc:     richardcochran@gmail.com, abyagowi@fb.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [RFC net-next 0/2] Add RTNL interface for SyncE
Date:   Sat, 28 Aug 2021 23:12:46 +0200
Message-Id: <20210828211248.3337476-1-maciej.machnikowski@intel.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Synchronous Ethernet networks use a physical layer clock to syntonize
the frequency across different network elements.

Multiple reference clock sources can be used. Clocks recovered from 
PHY ports on the RX side or external sources like 1PPS GPS, etc.

This patch series introduces basic interface for reading the DPLL
state on a SyncE capable device. This state gives us information
about the source of the syntonization signal and whether the DPLL
circuit is tuned to the incoming signal.

Next steps:
 - add interface to enable recovered clocks and get information
   about them

Maciej Machnikowski (2):
  rtnetlink: Add new RTM_GETSYNCESTATE message to get SyncE status
  ice: add support for reading SyncE DPLL state

 drivers/net/ethernet/intel/ice/ice.h          |  5 ++
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   | 34 ++++++++
 drivers/net/ethernet/intel/ice/ice_common.c   | 62 +++++++++++++++
 drivers/net/ethernet/intel/ice/ice_common.h   |  4 +
 drivers/net/ethernet/intel/ice/ice_devids.h   |  3 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 55 +++++++++++++
 drivers/net/ethernet/intel/ice/ice_ptp.c      | 35 +++++++++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c   | 44 +++++++++++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h   | 22 ++++++
 include/linux/netdevice.h                     |  6 ++
 include/uapi/linux/if_link.h                  | 43 +++++++++++
 include/uapi/linux/rtnetlink.h                | 11 ++-
 net/core/rtnetlink.c                          | 77 +++++++++++++++++++
 security/selinux/nlmsgtab.c                   |  3 +-
 14 files changed, 399 insertions(+), 5 deletions(-)

-- 
2.26.3

