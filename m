Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7A75149968
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 07:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgAZGHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 01:07:41 -0500
Received: from mga14.intel.com ([192.55.52.115]:18151 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbgAZGHk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 01:07:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jan 2020 22:07:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,364,1574150400"; 
   d="scan'208";a="230947202"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga006.jf.intel.com with ESMTP; 25 Jan 2020 22:07:40 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 0/8][pull request] 100GbE Intel Wired LAN Driver Updates 2020-01-25
Date:   Sat, 25 Jan 2020 22:07:29 -0800
Message-Id: <20200126060737.3238027-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to the ice driver to add support for RSS.

Henry and Tony enable the driver to write the filtering hardware tables
to allow for changing of RSS rules, also introduced and initialized the
structures for storing the configuration.  Then followed it up by
creating an extraction sequence based on the packet header protocols to
be programmed.  Next was storing the TCAM entry with the profile data
and VSI group in the respective software structures.

Md Fahad sets up the configuration to support RSS tables for the virtual
function (VF) driver (iavf).  Add support for flow types TCP4, TCP6,
UDP4, UDP6, SCTP4 and SCTP6 for RSS via ethtool.

The following are changes since commit 3333e50b64fe30b7e53cf02456a2f567f689ae4f:
  Merge branch 'mlxsw-Offload-TBF'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Md Fahad Iqbal Polash (2):
  ice: Initilialize VF RSS tables
  ice: Implement ethtool get/set rx-flow-hash

Tony Nguyen (6):
  ice: Enable writing hardware filtering tables
  ice: Allocate flow profile
  ice: Populate TCAM filter software structures
  ice: Enable writing filtering tables
  ice: Optimize table usage
  ice: Bump version

 drivers/net/ethernet/intel/ice/Makefile       |    3 +-
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |    8 +
 drivers/net/ethernet/intel/ice/ice_common.c   |  114 +-
 drivers/net/ethernet/intel/ice/ice_common.h   |    8 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  243 ++
 .../net/ethernet/intel/ice/ice_flex_pipe.c    | 2575 ++++++++++++++++-
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |    9 +
 .../net/ethernet/intel/ice/ice_flex_type.h    |  112 +
 drivers/net/ethernet/intel/ice/ice_flow.c     | 1275 ++++++++
 drivers/net/ethernet/intel/ice/ice_flow.h     |  207 ++
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |    8 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |  146 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |    2 +-
 .../ethernet/intel/ice/ice_protocol_type.h    |   25 +
 drivers/net/ethernet/intel/ice/ice_status.h   |    1 +
 drivers/net/ethernet/intel/ice/ice_switch.c   |   36 -
 drivers/net/ethernet/intel/ice/ice_type.h     |    6 +
 17 files changed, 4729 insertions(+), 49 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_flow.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_flow.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_protocol_type.h

-- 
2.24.1

