Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 219485451EA
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 18:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237101AbiFIQ3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 12:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234492AbiFIQ3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 12:29:21 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714B718F2F7
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 09:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654792160; x=1686328160;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ByrNQfq2VBSW0ssd7U6QnUYwl2Cgv9jjQ89lFvhQLnM=;
  b=CyRlpvA8iBqdEm77Dzk0tTuSOSeI+vRYjBgRBjb99gtucD+Y5OC5nMa2
   K4gsXYS7pfc7h5fTneVJLJ6oPACsoc3Cxgl56nhVpP0ul9v7dFgSPsJEX
   bXgW7YEufIqbSIXHciWjEBWZrJMpSSBy7ecf7fsqPp3eCu5UdUh9MbXr6
   X+FDwm9lIoX9FnK6fwWP8HME6ZLQfBJgSCZhZBiGq26mltOFMbuZoYuoi
   SN6hoIcSqIZdMdukmZT7W5l0g9xjmR4pcYUXfc49LKlSVRSDejQqCoBXX
   ssSfEEtLPOnbX6AEYGYuGG77HSynTW3IZg7jb+x/cGoauiTGRijp0kb6s
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="278486077"
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="278486077"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 09:29:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="615975879"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 09 Jun 2022 09:29:20 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates 2022-06-09
Date:   Thu,  9 Jun 2022 09:26:16 -0700
Message-Id: <20220609162620.2619258-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e and iavf drivers.

Grzegorz prevents addition of TC flower filters to TC0 and fixes queue
iteration for VF ADQ to number of actual queues for i40e.

Aleksandr prevents running of ethtool tests when device is being reset
for i40e.

Michal resolves an issue where iavf does not report its MAC address
properly.

The following are changes since commit 647df0d41b6bd8f4987dde6e8d8d0aba5b082985:
  net: amd-xgbe: fix clang -Wformat warning
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Aleksandr Loktionov (1):
  i40e: Fix call trace in setup_tx_descriptors

Grzegorz Szczurek (2):
  i40e: Fix adding ADQ filter to TC0
  i40e: Fix calculating the number of queue pairs

Michal Wilczynski (1):
  iavf: Fix issue with MAC address of VF shown as zero

 .../net/ethernet/intel/i40e/i40e_ethtool.c    | 25 +++++++++++++------
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  5 ++++
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    |  2 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  2 +-
 4 files changed, 24 insertions(+), 10 deletions(-)

-- 
2.35.1

