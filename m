Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 163A84A903F
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 22:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355155AbiBCVvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 16:51:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:63985 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231545AbiBCVvv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 16:51:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643925111; x=1675461111;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7zyng+yD/MsgDzplVp1bKG6k14SAqpycv1yxEvz49/I=;
  b=bzJcyaHCnJ0Jl94VZ0IfZ0H6uiv/85t8IGjNPJr6B03Mgjl8cdZelLPG
   DJ8XwODNxXTJ6CrpJogzv/yBdN83mV1jSzd2s+a6ABOZ+Nmz33szMDHal
   nZuLD2KBud+zqlg22JKnnHZ7a2D90NdR3rRwlzXliWJnKJnPmCjnRBBTm
   xl6NCkyjJkG+ET5dOfWjkVEMvvswP+6sKHQFFIx8kUKOwQEKlYZaADKK7
   4xVzl0ArWYBebk95+EhemNuRcNxrF9ef5fyoMo4PMAYFJTRHNvOg7rO+z
   tdUuFTXH1Ie81tQfKLqx3ZKBr+x55yr+oooElkhF9RWqch9JK27yrNJ0i
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10247"; a="272760128"
X-IronPort-AV: E=Sophos;i="5.88,340,1635231600"; 
   d="scan'208";a="272760128"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2022 13:51:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,340,1635231600"; 
   d="scan'208";a="498295185"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 03 Feb 2022 13:51:51 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net-next 0/7][pull request] 40GbE Intel Wired LAN Driver Updates 2022-02-03
Date:   Thu,  3 Feb 2022 13:51:33 -0800
Message-Id: <20220203215140.969227-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to the i40e client header file and driver.

Mateusz disables HW TC offload by default.

Joe Damato removes a no longer used statistic.

Jakub Kicinski removes an unused enum from the client header file.

Jedrzej changes some admin queue commands to occur under atomic context
and adds new functions for admin queue MAC VLAN filters to avoid a
potential race that could occur due storing results in a structure that
could be overwritten by the next admin queue call.

The following are changes since commit 9c30918925d7992a6d812b3aa7e026839723c78a:
  Merge branch 'dsa-mv88e6xxx-phylink_generic_validate'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Jakub Kicinski (1):
  i40e: remove enum i40e_client_state

Jedrzej Jagielski (4):
  i40e: Add sending commands in atomic context
  i40e: Add new versions of send ASQ command functions
  i40e: Add new version of i40e_aq_add_macvlan function
  i40e: Fix race condition while adding/deleting MAC/VLAN filters

Joe Damato (1):
  i40e: Remove unused RX realloc stat

Mateusz Palczewski (1):
  i40e: Disable hw-tc-offload feature on driver load

 drivers/net/ethernet/intel/i40e/i40e_adminq.c |  92 ++++++++++-
 drivers/net/ethernet/intel/i40e/i40e_common.c | 155 +++++++++++++++---
 .../net/ethernet/intel/i40e/i40e_debugfs.c    |   3 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  29 ++--
 .../net/ethernet/intel/i40e/i40e_prototype.h  |  25 +++
 drivers/net/ethernet/intel/i40e/i40e_txrx.h   |   1 -
 include/linux/net/intel/i40e_client.h         |  10 --
 7 files changed, 255 insertions(+), 60 deletions(-)

-- 
2.31.1

