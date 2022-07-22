Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11EE457E618
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 19:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236158AbiGVR4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 13:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236267AbiGVR4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 13:56:18 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB2B2A407
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 10:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658512577; x=1690048577;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=M1yFgExLXNV7MwMUFXg4NRVW9Yr2Wl+Cc4bMrv1v8WQ=;
  b=AF7v9E+wUwrSx569xo/5R/yRFSmYTX19m6tPCh/dF2iB4LltC0x+tf7P
   JKTnJrGy9Ga5D2imyqD6f2zooSOqlrXTuEvtZ6fbUArVQAiqkSJ/T0D6Q
   rXHJ2wssd29KVd7jIpf6vVo/uQJB4vsvozIUO58/Z+ld+UhJ4WSZtbTiS
   h4Rrigm6adgp+O9oDaQexd0JTVIAJYOBUL8F0kvSzxctn9G5DrfiGS91b
   Lmuj54SdU1jeOT9+UOwrZ8K2tTDSPn5DXW6z/uecIshOGAY4tjCYz4v80
   y9dqmhjxI3Tnx4+indOqUttR9SFzKQwNw1Rr/M7cEkHhkSZBv1csAFGAI
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10416"; a="267769826"
X-IronPort-AV: E=Sophos;i="5.93,186,1654585200"; 
   d="scan'208";a="267769826"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 10:56:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,186,1654585200"; 
   d="scan'208";a="596042566"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 22 Jul 2022 10:56:16 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/2][pull request] 40GbE Intel Wired LAN Driver Updates 2022-07-22
Date:   Fri, 22 Jul 2022 10:53:11 -0700
Message-Id: <20220722175313.112518-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e and iavf drivers.

Przemyslaw adds a helper function for determining whether TC MQPRIO is
enabled for i40e.

Avinash utilizes the driver's bookkeeping of filters to check for
duplicate filter before sending the request to the PF for iavf.

The following are changes since commit 949d6b405e6160ae44baea39192d67b39cb7eeac:
  net: add missing includes and forward declarations under net/
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Avinash Dayanand (1):
  iavf: Check for duplicate TC flower filter before parsing

Przemyslaw Patynowski (1):
  i40e: Refactor tc mqprio checks

 drivers/net/ethernet/intel/i40e/i40e.h        | 14 +++++
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 20 +++----
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 55 +++++++++++--------
 4 files changed, 58 insertions(+), 33 deletions(-)

-- 
2.35.1

