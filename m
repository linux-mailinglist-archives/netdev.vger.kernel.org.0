Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 869FE67451F
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 22:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbjASVn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 16:43:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbjASVjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 16:39:36 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A949B9373F
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 13:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674163684; x=1705699684;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=07XoigMrHQIVuUlvwLEYDvScLBgfGkTcpXWHo4EoQvs=;
  b=dIuQ4Xk1JC6L4vQJ1RxhXj7GTQGcU9ZD+WctBe/mB7bsISICBo90h9rb
   DcJYnO3IDZw3QwRC9Ctm23PWwvQBrVG0l7Z3O5GCIibh2lEBvMtGh4DQA
   sD32vSlOVHaSpAIxFuSstGr71tdG+wwrLFiA74s4dGZ7xyGUWo7lC9lO3
   nwnsFQNoncMnIeWFJbsvsU6hritSAhYrTdRLYAlCFd1vgHxxewFHv3Gqx
   e4AltO416zonwLbzMQUd5B4cZSeeYh3qpnpPIhsLZ+ZHk7qRXDChf8E98
   dzFvxrK2YRghqcOarJ5h95Bl0CED8PQDGA3NOZKerfm4dnjN8xBP0zuEZ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="323120588"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="323120588"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 13:27:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="692589863"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="692589863"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga001.jf.intel.com with ESMTP; 19 Jan 2023 13:27:26 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 00/15][pull request] Intel Wired LAN Driver Updates 2023-01-19 (ice)
Date:   Thu, 19 Jan 2023 13:27:27 -0800
Message-Id: <20230119212742.2106833-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Tsotne and Anatolii implement new handling, and AdminQ command, for
firmware LLDP, adding a pending notification to allow for proper
cleanup between TC changes.

Amritha extends support for drop action outside of switchdev.

Siddaraju adjusts restriction for PTP HW clock adjustments.

Ani removes an unneeded non-null check and improves reporting of some link
modes to utilize more appropriate values.

Jesse adds checks to ensure PF VSI type.

Przemek combines duplicate checks of the same condition into one check.

Tony makes various cleanups to code: removes comments for cppcheck
suppressions, reduces scope of some variables, changes some return
statements to reflect an explicit 0 return, matches naming for function
declaration and definition, adds local variable for readability, and
fixes indenting.

Sergey separates DDP (Dynamic Device Personalization) code into its own
file.

The following are changes since commit 3ef4a8c8963b29813170177899f84ffb93f1a8f1:
  Merge branch 'net-phy-remove-probe_capabilities'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Amritha Nambiar (1):
  ice: Support drop action

Anatolii Gerasymenko (1):
  ice: Handle LLDP MIB Pending change

Anirudh Venkataramanan (2):
  ice: remove redundant non-null check in ice_setup_pf_sw()
  ice: Add support for 100G KR2/CR2/SR2 link reporting

Jesse Brandeburg (1):
  ice: add missing checks for PF vsi type

Przemek Kitszel (1):
  ice: combine cases in ice_ksettings_find_adv_link_speed()

Sergey Temerkhanov (1):
  ice: Move support DDP code out of ice_flex_pipe.c

Siddaraju DH (1):
  ice: restrict PTP HW clock freq adjustments to 100, 000, 000 PPB

Tony Nguyen (6):
  ice: Remove cppcheck suppressions
  ice: Reduce scope of variables
  ice: Explicitly return 0
  ice: Match parameter name for ice_cfg_phy_fc()
  ice: Introduce local var for readability
  ice: Remove excess space

Tsotne Chakhvadze (1):
  ice: Add 'Execute Pending LLDP MIB' Admin Queue command

 drivers/net/ethernet/intel/ice/Makefile       |    1 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   18 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |   13 +
 drivers/net/ethernet/intel/ice/ice_common.h   |    3 +-
 drivers/net/ethernet/intel/ice/ice_dcb.c      |   39 +
 drivers/net/ethernet/intel/ice/ice_dcb.h      |    2 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   70 +-
 drivers/net/ethernet/intel/ice/ice_ddp.c      | 1897 ++++++++++++++
 drivers/net/ethernet/intel/ice/ice_ddp.h      |  445 ++++
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   63 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.c    | 2258 ++---------------
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |   69 -
 .../net/ethernet/intel/ice/ice_flex_type.h    |  328 +--
 drivers/net/ethernet/intel/ice/ice_lib.c      |    2 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |   38 +-
 drivers/net/ethernet/intel/ice/ice_nvm.c      |    1 -
 drivers/net/ethernet/intel/ice/ice_ptp.c      |    2 +-
 drivers/net/ethernet/intel/ice/ice_sched.c    |    7 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   |   50 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.h   |   10 +
 drivers/net/ethernet/intel/ice/ice_txrx.c     |    3 -
 21 files changed, 2753 insertions(+), 2566 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_ddp.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_ddp.h

-- 
2.38.1

