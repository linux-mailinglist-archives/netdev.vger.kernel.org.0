Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB7B34D8EC
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbhC2USA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:18:00 -0400
Received: from mga18.intel.com ([134.134.136.126]:19968 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230294AbhC2UR1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 16:17:27 -0400
IronPort-SDR: Vn1gAVQrwMkNvv1GR+deomriktqhhMa/JndthNfHMnYq81Lh+e9SAxSUtXAR80PxMdsXrQsJbn
 wAIMoGZVVZ8A==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="179160814"
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="179160814"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 13:17:26 -0700
IronPort-SDR: VHQ+C5Kj/iyudzLhfGGMCMaFKtmy54vtqasx0ZID1mSkRl+8gGxsZOAy3A88s+1ULzWYZHi7cc
 O/8k4cfUMKOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="454700531"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 29 Mar 2021 13:17:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net 0/9][pull request] Intel Wired LAN Driver Updates 2021-03-29
Date:   Mon, 29 Mar 2021 13:18:48 -0700
Message-Id: <20210329201857.3509461-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Ani does not fail on link/PHY errors during probe as this is not a fatal
error to prevent the user from remedying the problem. He also corrects
checking Wake on LAN support to be port number, not PF ID.

Fabio increases the AdminQ timeout as some commands can take longer than
the current value.

Chinh fixes iSCSI to use be able to use port 860 by using information
from DCBx and other QoS configuration info.

Krzysztof fixes a possible race between ice_open() and ice_stop().

Bruce corrects the ordering of arguments in a memory allocation call.

Dave removes DCBNL device reset bit which is blocking changes coming
from DCBNL interface.

Jacek adds error handling for filter allocation failure.

Robert ensures memory is freed if VSI filter list issues are
encountered.

The following are changes since commit 1b479fb801602b22512f53c19b1f93a4fc5d5d9d:
  drivers/net/wan/hdlc_fr: Fix a double free in pvc_xmit
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Anirudh Venkataramanan (2):
  ice: Continue probe on link/PHY errors
  ice: Use port number instead of PF ID for WoL

Bruce Allan (1):
  ice: fix memory allocation call

Chinh T Cao (1):
  ice: Recognize 860 as iSCSI port in CEE mode

Dave Ertman (1):
  ice: remove DCBNL_DEVRESET bit from PF state

Fabio Pricoco (1):
  ice: Increase control queue timeout

Jacek Bułatek (1):
  ice: Fix for dereference of NULL pointer

Krzysztof Goreczny (1):
  ice: prevent ice_open and ice_stop during reset

Robert Malz (1):
  ice: Cleanup fltr list in case of allocation issues

 drivers/net/ethernet/intel/ice/ice.h          |  4 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |  2 +-
 drivers/net/ethernet/intel/ice/ice_controlq.h |  4 +-
 drivers/net/ethernet/intel/ice/ice_dcb.c      | 38 ++++++++++----
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c   |  2 -
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  4 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      |  5 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 52 ++++++++++++++-----
 drivers/net/ethernet/intel/ice/ice_switch.c   | 15 +++---
 drivers/net/ethernet/intel/ice/ice_type.h     |  1 +
 10 files changed, 86 insertions(+), 41 deletions(-)

-- 
2.26.2

