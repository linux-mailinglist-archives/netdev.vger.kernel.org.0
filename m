Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 974475413AF
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 22:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357494AbiFGUEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 16:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357741AbiFGUDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 16:03:13 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F71EBAB9
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 11:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654626337; x=1686162337;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UlWWtTixyRHuYk/oVZxuTojCViL4/CX0skXNoHplpdA=;
  b=DUunGW8lZc4JfAAeP+k0mRUPsQb2/dW6xtKai2WnnLEF3npFxdTjE/Mn
   jpuz/0foyMl2f9MbgcZH3cpHvZlWrbQ5D/9T8476WyQyjeJkwnXmbo039
   ijoZWYJnHqdgg9K5Jlg42dnFelYq3oXo57wSJOYBXtrKy2tRNMtgmzw7x
   Novg/NvFIlgbmxjz3Zu2GQzFZ0Z/WWlgJ4Sou2SyBMX/OUOEGVrAF/Bwn
   X39g5zAM7RbVSnqy5zXp55A8FxHwbHpKN+ZIrvocNsw/4gMO+++dtLDtV
   29op2E3YNOuub7ZiKLUx79Dj+HIE3Nelj/nO5nnmG4ZPR9okAX6rpByPq
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="340629544"
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="340629544"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 10:58:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="579699387"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 07 Jun 2022 10:58:11 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net-next v2 0/2][pull request] 40GbE Intel Wired LAN Driver Updates 2022-06-07
Date:   Tue,  7 Jun 2022 10:55:04 -0700
Message-Id: <20220607175506.696671-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e and iavf drivers.

Mateusz adds implementation for setting VF VLAN pruning to allow user to
specify visibility of VLAN tagged traffic to VFs for i40e. He also adds
waiting for result from PF for setting MAC address in iavf.
---
v2: Rewrote some code to avoid passing a value as a condition (patch 2)

The following are changes since commit ba36c5b7ac9399a8dc521c44ece72db43d192f9b:
  Merge branch 'reorganize-the-code-of-the-enum-skb_drop_reason'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Mateusz Palczewski (2):
  i40e: Add VF VLAN pruning
  iavf: Add waiting for response from PF in set mac

 drivers/net/ethernet/intel/i40e/i40e.h        |   1 +
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |   9 ++
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 135 +++++++++++++++++-
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    |   8 +-
 drivers/net/ethernet/intel/iavf/iavf.h        |   7 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 127 +++++++++++++---
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  61 +++++++-
 7 files changed, 321 insertions(+), 27 deletions(-)

-- 
2.35.1

