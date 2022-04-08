Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C56894F9AAA
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 18:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbiDHQfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 12:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiDHQfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 12:35:33 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAF683B05
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 09:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649435609; x=1680971609;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bIuMHqReyS6592+LrJHNaAyEJiKR+2HwOjl/Dt4AyVo=;
  b=ZAFk3mG0QQpIikL7FLtM7g6I5WFEc6eqE4PxD/X5YTmZCtL3RyEvhrM6
   2ZUwvXPNOYleuDxmIDm6KDExr6OQtBynKROyd6d6lKNHaEJ0WS7mSkOpJ
   LwOCOP1G2A93WHN5ftMELvEw712zPp6goOC5rR/RIdpKcjDOtBbo0zGe8
   0PtxX2RQSrz4/1XwP1vAMwMo+rq+kZhwOX4Bj9WBqHCPcrzx847JhLD3m
   8cPFplAvbXyibXhSjAT50+yPMZQLNDcmzRlMs0VhcAkweBR4Hd2ROcTFZ
   NJHDqImXaUv+/VePkkV+XUlbDr7fxvrEvPNDPhOOimJztfknt6qM0d8+S
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="261321985"
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="261321985"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 09:33:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="642957821"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Apr 2022 09:33:28 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates 2022-04-08
Date:   Fri,  8 Apr 2022 09:34:09 -0700
Message-Id: <20220408163411.2415552-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice and iavf drivers.

Alexander fixes a use after free issue with aRFS for ice driver.

Mateusz reverts a commit that introduced issues related to device
resets for iavf driver.

The following are changes since commit 7cea5560bf656b84f9ed01c0cc829d4eecd0640b:
  vxlan: fix error return code in vxlan_fdb_append
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Alexander Lobakin (1):
  ice: arfs: fix use-after-free when freeing @rx_cpu_rmap

Mateusz Palczewski (1):
  Revert "iavf: Fix deadlock occurrence during resetting VF interface"

 drivers/net/ethernet/intel/iavf/iavf_main.c |  7 ++-----
 drivers/net/ethernet/intel/ice/ice_arfs.c   |  9 ++-------
 drivers/net/ethernet/intel/ice/ice_lib.c    |  5 ++++-
 drivers/net/ethernet/intel/ice/ice_main.c   | 18 ++++++++----------
 4 files changed, 16 insertions(+), 23 deletions(-)

-- 
2.31.1

