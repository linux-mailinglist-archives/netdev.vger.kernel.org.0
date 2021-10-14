Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 902C342DE44
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 17:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbhJNPjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 11:39:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:31404 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231432AbhJNPjw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 11:39:52 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10137"; a="227599602"
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="227599602"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 08:37:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="592642516"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 14 Oct 2021 08:37:23 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        maciej.machnikowski@intel.com, richardcochran@gmail.com
Subject: [PATCH net-next v2 0/4][pull request] 100GbE Intel Wired LAN Driver Updates 2021-10-14
Date:   Thu, 14 Oct 2021 08:35:27 -0700
Message-Id: <20211014153531.2908804-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Machnikowski says:

Extend the driver implementation to support PTP pins on E810-T and
derivative devices.

E810-T adapters are equipped with:
- 2 external bidirectional SMA connectors
- 1 internal TX U.FL shared with SMA1
- 1 internal RX U.FL shared with SMA2

The SMA and U.FL configuration is controlled by the external
multiplexer.

E810-T Derivatives are equipped with:
- 2 1PPS outputs on SDP20 and SDP22
- 2 1PPS inputs on SDP21 and SDP23
---
v2:
- Remove defensive programming check and simplify return statement
  (Patch 3)
- Remove unnecessary parentheses (Patch 4)

The following are changes since commit 9974cb5c879048f5144d0660c4932d98176213c4:
  net: delete redundant function declaration
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Maciej Machnikowski (4):
  ice: Refactor ice_aqc_link_topo_addr
  ice: Implement functions for reading and setting GPIO pins
  ice: Add support for SMA control multiplexer
  ice: Implement support for SMA and U.FL on E810-T

 drivers/net/ethernet/intel/ice/ice.h          |   1 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  20 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |  87 +++-
 drivers/net/ethernet/intel/ice/ice_common.h   |   7 +
 drivers/net/ethernet/intel/ice/ice_devids.h   |   2 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |  15 +
 drivers/net/ethernet/intel/ice/ice_lib.h      |   1 +
 drivers/net/ethernet/intel/ice/ice_ptp.c      | 370 +++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_ptp.h      |  20 +-
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c   | 151 +++++++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h   |  22 ++
 drivers/net/ethernet/intel/ice/ice_type.h     |   1 +
 12 files changed, 683 insertions(+), 14 deletions(-)

-- 
2.31.1

