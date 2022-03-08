Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1574D1E38
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 18:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348497AbiCHRMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 12:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345944AbiCHRMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 12:12:39 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33774C428
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 09:11:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646759502; x=1678295502;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GoD5QPS2j8Xh83a/Qw+kRiIfnElxokuIGXy8aJzdpEo=;
  b=JguPxE34A5SqKfH77MCiFGfcHyohc5T6Z62Ofu5QAAIVz25xgulEdLhO
   a34y7Cw6hXL7ZLYptyqh05wBLbjEctiWt7zKk0K8jXxsEdfmdt5ojBbwt
   icZnLeXb/7jOfXFvGID/MFLDXIZZ88bK52TH/sweJygXp5ntgy9alZbPm
   qGxQVluiva4dN7bT8y45KleFoRcM6E28Aoey/U2o3POsSjqvotkdgTpnj
   E6QvJrbIKrAGrEXNbkiz0S02EgV/XNRAiedBBUwn0WbAwvlccwPxpdsdb
   Skb7W41vUOkPc1tuvycUkRunZKI/GTGlDNiwCCgZYaaVYpLtko+adWOPc
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="317972879"
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="317972879"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 09:11:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="611069463"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 08 Mar 2022 09:11:42 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/3][pull request] 10GbE Intel Wired LAN Driver Updates 2022-03-08
Date:   Tue,  8 Mar 2022 09:11:52 -0800
Message-Id: <20220308171155.408896-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ixgbe and ixgbevf drivers.

Slawomir adds an implementation for ndo_set_vf_link_state() to allow
for disabling of VF link state as well a mailbox implementation so
the VF can query the state. Additionally, for 82599, the option to
disable a VF after receiving several malicious driver detection (MDD)
events are encountered is added. For ixgbevf, the corresponding
implementation to query and report a disabled state is added.

The following are changes since commit d307eab593b283849c13703ca3fd6a5b3908d6f8:
  Merge branch 'net-phy-lan87xx-use-genphy_read_master_slave-function'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 10GbE

Slawomir Mrozowicz (3):
  ixgbe: add the ability for the PF to disable VF link state
  ixgbe: add improvement for MDD response functionality
  ixgbevf: add disable link state

 drivers/net/ethernet/intel/ixgbe/ixgbe.h      |   6 +
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  |  21 ++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  39 +++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_mbx.h  |   2 +
 .../net/ethernet/intel/ixgbe/ixgbe_sriov.c    | 207 ++++++++++++++----
 .../net/ethernet/intel/ixgbe/ixgbe_sriov.h    |   4 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf.h  |   2 +
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  11 +-
 drivers/net/ethernet/intel/ixgbevf/mbx.h      |   2 +
 drivers/net/ethernet/intel/ixgbevf/vf.c       |  42 ++++
 drivers/net/ethernet/intel/ixgbevf/vf.h       |   1 +
 11 files changed, 291 insertions(+), 46 deletions(-)

-- 
2.31.1

