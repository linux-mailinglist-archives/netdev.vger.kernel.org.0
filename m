Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A4A317447
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 00:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbhBJXYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 18:24:00 -0500
Received: from mga01.intel.com ([192.55.52.88]:20916 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231547AbhBJXX6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 18:23:58 -0500
IronPort-SDR: mu6UPU8v2cWmIpiX7V0+QZGwXFRdGIvWpqB7mKh35ZJRLa0Royvpbxk3En8Xd5r42+MigT4YEW
 01sHlWTBD0fA==
X-IronPort-AV: E=McAfee;i="6000,8403,9891"; a="201287981"
X-IronPort-AV: E=Sophos;i="5.81,169,1610438400"; 
   d="scan'208";a="201287981"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2021 15:23:42 -0800
IronPort-SDR: R3cklj0YZtcfOBXmcBjRZtDsgGcQdusqMDjeRzncZro2U2EiyWwlJz90brDu9gBIClNBlsfaRa
 ++phPs3QMw0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,169,1610438400"; 
   d="scan'208";a="361512334"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 10 Feb 2021 15:23:42 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net-next 0/7][pull request] 40GbE Intel Wired LAN Driver Updates 2021-02-10
Date:   Wed, 10 Feb 2021 15:24:29 -0800
Message-Id: <20210210232436.4084373-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e driver only.

Arkadiusz adds support for software controlled DCB. Upon disabling of the
firmware LLDP agent, the driver configures DCB with default values
(only one Traffic Class). At the same time, it allows a software based
LLDP agent - userspace application i.e. lldpad) to receive DCB TLVs
and set desired DCB configuration through DCB related netlink callbacks.

Aleksandr implements get and set ethtool ops for Energy Efficient
Ethernet.

Przemyslaw extends support for ntuple filters allowing for Flow Director
IPv6 and VLAN filters.

Kaixu Xia removes an unneeded assignment.

The following are changes since commit dc9d87581d464e7b7d38853d6904b70b6c920d99:
  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Aleksandr Loktionov (1):
  i40e: Add EEE status getting & setting implementation

Arkadiusz Kubalewski (3):
  i40e: Add hardware configuration for software based DCB
  i40e: Add init and default config of software based DCB
  i40e: Add netlink callbacks support for software based DCB

Kaixu Xia (1):
  i40e: remove the useless value assignment in i40e_clean_adminq_subtask

Przemyslaw Patynowski (2):
  i40e: Add flow director support for IPv6
  i40e: VLAN field for flow director

 drivers/net/ethernet/intel/i40e/i40e.h        |  26 +-
 .../net/ethernet/intel/i40e/i40e_adminq_cmd.h |  11 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c |  65 +-
 drivers/net/ethernet/intel/i40e/i40e_dcb.c    | 949 +++++++++++++++++-
 drivers/net/ethernet/intel/i40e/i40e_dcb.h    | 169 +++-
 drivers/net/ethernet/intel/i40e/i40e_dcb_nl.c | 752 +++++++++++++-
 .../net/ethernet/intel/i40e/i40e_ethtool.c    | 382 ++++++-
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 601 ++++++++++-
 .../net/ethernet/intel/i40e/i40e_prototype.h  |   9 +-
 .../net/ethernet/intel/i40e/i40e_register.h   | 174 +++-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 534 ++++++----
 drivers/net/ethernet/intel/i40e/i40e_type.h   |   5 +-
 12 files changed, 3378 insertions(+), 299 deletions(-)

-- 
2.26.2

