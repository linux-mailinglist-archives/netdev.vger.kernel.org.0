Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6E3429502
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 18:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbhJKRBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 13:01:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:61105 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232535AbhJKRBk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 13:01:40 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10134"; a="224335699"
X-IronPort-AV: E=Sophos;i="5.85,365,1624345200"; 
   d="scan'208";a="224335699"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2021 09:59:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,365,1624345200"; 
   d="scan'208";a="591405441"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 11 Oct 2021 09:59:40 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        jiri@resnulli.us, ivecera@redhat.com,
        michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        grzegorz.nitka@intel.com
Subject: [PATCH net-next 0/9][pull request] 100GbE Intel Wired LAN Driver Updates 2021-10-11
Date:   Mon, 11 Oct 2021 09:57:33 -0700
Message-Id: <20211011165742.1144861-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wojciech Drewek says:

This series adds support for adding/removing advanced switch filters
in ice driver. Advanced filters are building blocks for HW acceleration
of TC orchestration. Add ndo_setup_tc callback implementation for PF and
VF port representors (when device is configured in switchdev mode).

Define dummy packet headers to allow adding advanced rules in HW.
Supported headers, and thus filters, are:
- MAC + IPv4 + UDP
- MAC + VLAN + IPv4 + UDP
- MAC + IPv4 + TCP
- MAC + VLAN + IPv4 + TCP
- MAC + IPv6 + UDP
- MAC + VLAN + IPv6 + UDP
- MAC + IPv6 + TCP
- MAC + VLAN + IPv6 + TCP

The following are changes since commit ce8bd03c47fc8328e82a48d332fba69fd538e9bf:
  ethernet: sun: add missing semicolon, fix build
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Dan Nowlin (2):
  ice: manage profiles and field vectors
  ice: create advanced switch recipe

Grishma Kotecha (2):
  ice: implement low level recipes functions
  ice: allow adding advanced rules

Kiran Patil (1):
  ice: ndo_setup_tc implementation for PF

Michal Swiatkowski (2):
  ice: Allow changing lan_en and lb_en on all kinds of filters
  ice: ndo_setup_tc implementation for PR

Shivanshu Shukla (1):
  ice: allow deleting advanced rules

Victor Raj (1):
  ice: cleanup rules info

 drivers/net/ethernet/intel/ice/Makefile       |    3 +-
 drivers/net/ethernet/intel/ice/ice.h          |    4 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   57 +
 drivers/net/ethernet/intel/ice/ice_common.c   |   42 +-
 drivers/net/ethernet/intel/ice/ice_eswitch.c  |    3 +
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |  275 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |   14 +
 .../net/ethernet/intel/ice/ice_flex_type.h    |   13 +
 drivers/net/ethernet/intel/ice/ice_fltr.c     |  127 +
 drivers/net/ethernet/intel/ice/ice_main.c     |   71 +
 .../ethernet/intel/ice/ice_protocol_type.h    |  169 ++
 drivers/net/ethernet/intel/ice/ice_repr.c     |   53 +
 drivers/net/ethernet/intel/ice/ice_switch.c   | 2481 ++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_switch.h   |  130 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   |  855 ++++++
 drivers/net/ethernet/intel/ice/ice_tc_lib.h   |  130 +
 drivers/net/ethernet/intel/ice/ice_type.h     |    4 +
 17 files changed, 4334 insertions(+), 97 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_tc_lib.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_tc_lib.h

-- 
2.31.1

