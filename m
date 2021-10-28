Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F5043E7FB
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 20:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbhJ1SLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 14:11:10 -0400
Received: from mga03.intel.com ([134.134.136.65]:46220 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229645AbhJ1SLJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 14:11:09 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10151"; a="230427771"
X-IronPort-AV: E=Sophos;i="5.87,190,1631602800"; 
   d="scan'208";a="230427771"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2021 11:08:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,190,1631602800"; 
   d="scan'208";a="725849062"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 28 Oct 2021 11:08:41 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/9][pull request] 100GbE Intel Wired LAN Driver Updates 2021-10-28
Date:   Thu, 28 Oct 2021 11:06:50 -0700
Message-Id: <20211028180659.218912-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Michal adds support for eswitch drop and redirect filters from and to
tunnel devices. From meaning from uplink to VF and to means from VF to
uplink. This is accomplished by adding support for indirect TC tunnel
notifications and adding appropriate training packets and match fields
for UDP tunnel headers. He also adds returning virtchannel responses for
blocked operations as returning a response is still needed.

Marcin sets netdev min and max MTU values on port representors to allow
for MTU changes over default values.

Brett adds detecting and reporting of PHY firmware load issues for devices
which support this.

Nathan Chancellor fixes a clang warning for implicit fallthrough.

Wang Hai fixes a return value for failed allocation.

The following are changes since commit f2edaa4ad5d51371709196f2c258fbe875962dee:
  net: virtio: use eth_hw_addr_set()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Brett Creeley (1):
  ice: Add support to print error on PHY FW load failure

Marcin Szycik (1):
  ice: Add support for changing MTU on PR in switchdev mode

Michal Swiatkowski (5):
  ice: support for indirect notification
  ice: VXLAN and Geneve TC support
  ice: low level support for tunnels
  ice: support for GRE in eswitch
  ice: send correct vc status in switchdev

Nathan Chancellor (1):
  ice: Fix clang -Wimplicit-fallthrough in ice_pull_qvec_from_rc()

Wang Hai (1):
  ice: fix error return code in ice_get_recp_frm_fw()

 drivers/net/ethernet/intel/ice/ice.h          |   9 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   2 +
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |  30 +-
 .../net/ethernet/intel/ice/ice_flex_type.h    |   4 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |   1 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 242 ++++++++++-
 .../ethernet/intel/ice/ice_protocol_type.h    |  35 ++
 drivers/net/ethernet/intel/ice/ice_repr.c     |   3 +
 drivers/net/ethernet/intel/ice/ice_switch.c   | 389 ++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_switch.h   |   3 +
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   | 401 ++++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_tc_lib.h   |  10 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  63 ++-
 13 files changed, 1110 insertions(+), 82 deletions(-)

-- 
2.31.1

