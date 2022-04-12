Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB214FE820
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 20:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358748AbiDLSlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 14:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358743AbiDLSlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 14:41:49 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E9F28E23
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 11:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649788770; x=1681324770;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gsYKeANYPYn1yXtdk1xODQklniwSTfWI6tMyMmbQjiw=;
  b=TOysiOoalxbcqpjd0oBaSAePiblkwTF+di69hrShVi40QTPCb4pKLRlZ
   j1tQSR/Oj5pep9qdr2LwJDxBJRS06MPXatXro3zBSH39wkURwZjI2SxuR
   GZUgvxOcHUC9oyq+OcTDDs0kzDRXuhJkDTRmJt1OxqCldrteuID59vH10
   cH6pW+K+/DLyS9oDxoqY1F4gpxBMSUTuihIZblrh2f8vRtU/i8PgGZ/bv
   2o2/huu+NwXAAeBhFi/EwNl2YhpwnNwczpKiyg2JHAIeFWQEbcWm2kvMq
   d5fJQX/+nEKBMCX9kyQYuy1PrBfAUti/GPoMSLtMvz/kfzBk8WITt5dCn
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="322919260"
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="322919260"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 11:39:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="590453075"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 12 Apr 2022 11:39:29 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net-next 0/5][pull request] 40GbE Intel Wired LAN Driver Updates 2022-04-12
Date:   Tue, 12 Apr 2022 11:36:31 -0700
Message-Id: <20220412183636.1408915-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e and ice drivers.

Joe Damato adds TSO support for MPLS packets on i40e and ice drivers. He
also adds tracking and reporting of tx_stopped statistic for i40e.

Nabil S. Alramli adds reporting of tx_restart to ethtool for i40e.

Mateusz adds new device id support for i40e.

The following are changes since commit 590032a4d2133ecc10d3078a8db1d85a4842f12c:
  page_pool: Add recycle stats to page_pool_put_page_bulk
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Joe Damato (3):
  i40e: Add support for MPLS + TSO
  ice: Add mpls+tso support
  i40e: Add tx_stopped stat

Mateusz Palczewski (1):
  i40e: Add Ethernet Connection X722 for 10GbE SFP+ support

Nabil S. Alramli (1):
  i40e: Add vsi.tx_restart to i40e ethtool stats

 drivers/net/ethernet/intel/i40e/i40e.h        |  1 +
 drivers/net/ethernet/intel/i40e/i40e_common.c |  1 +
 .../net/ethernet/intel/i40e/i40e_debugfs.c    |  5 +-
 drivers/net/ethernet/intel/i40e/i40e_devids.h |  1 +
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |  2 +
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 25 +++++++++-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 49 ++++++++++++-------
 drivers/net/ethernet/intel/i40e/i40e_txrx.h   |  1 +
 drivers/net/ethernet/intel/ice/ice_main.c     |  4 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 29 ++++++++---
 10 files changed, 88 insertions(+), 30 deletions(-)

-- 
2.31.1

