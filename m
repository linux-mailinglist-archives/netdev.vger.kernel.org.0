Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E3F6C3946
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 19:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjCUSic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 14:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjCUSib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 14:38:31 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D468CC22
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 11:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679423910; x=1710959910;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SBPFD0g5Mi8rZE4RKXDtLcHAxW9gNONZi96JLGLB+6E=;
  b=dhbuSCluF/3kz/JxfR15BMwT8IHeDjQjdnHWaye7r8gvX8rFpgOOQlXL
   V//QksO4buZUK27Vf3H/Gp17qbRosrqJ4jTPBTU+m+yRDd+rs9s74KCAz
   EmulpNmyoBP4Hvv6ck3QCiD3c1XtLhLZkjwiekAvL4zdoMgPHyx7BDps0
   qZRMTncVWdlwDzbXQRLqwCgznsTeEMh2Wc63rSv1uqcPa88WxMfalskaE
   74nWeaLeTeWoUp+nK6dn23hp4UDn1Cn7BtaNLalJpYNfrTWVD8FcodQag
   lytuER2coyqvxBXI0Pr058H03L4rUGCxhgz56M0BW3qqIovipwMuwN7Xr
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="339067622"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="339067622"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 11:38:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="684001755"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="684001755"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga007.fm.intel.com with ESMTP; 21 Mar 2023 11:38:29 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates 2023-03-21 (ice)
Date:   Tue, 21 Mar 2023 11:36:38 -0700
Message-Id: <20230321183641.2849726-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Piotr sets first_desc field for proper handling of Flow Director
packets.

Michal moves error checking for VF earlier in function to properly return
error before other checks/reporting; he also corrects VSI filter removal to
be done during VSI removal and not rebuild.

The following are changes since commit f038f3917baf04835ba2b7bcf2a04ac93fbf8a9c:
  octeontx2-vf: Add missing free for alloc_percpu
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Michal Swiatkowski (2):
  ice: check if VF exists before mode check
  ice: remove filters only if VSI is deleted

Piotr Raczynski (1):
  ice: fix rx buffers handling for flow director packets

 drivers/net/ethernet/intel/ice/ice_lib.c   | 2 +-
 drivers/net/ethernet/intel/ice/ice_main.c  | 8 +++++++-
 drivers/net/ethernet/intel/ice/ice_sriov.c | 8 ++++----
 drivers/net/ethernet/intel/ice/ice_txrx.c  | 1 +
 4 files changed, 13 insertions(+), 6 deletions(-)

-- 
2.38.1

