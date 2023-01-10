Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93A0F664ED7
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 23:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232492AbjAJWhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 17:37:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbjAJWhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 17:37:51 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFB05585D
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 14:37:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673390270; x=1704926270;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Uu3cDbTr8/EvbkzYe5BOpR2xpzvv/khUhaUIcWzVy4A=;
  b=OZOyQ3GGiAy6KoD5BDTQH+Q3Tln2WPjERlEqQFxw3hYXcn+dGnxemKYs
   TfG/T/ZxBLGUI7L4SHf5CNQOB6B54lm5uEN3hxhttk4ps9VmhwVeWz1gZ
   RClyEM9qnEG6MYbAhmRlyBgipZBayghf9SsgPgBihPfMl6LsxD6kRrfMq
   tnNdhtsHQXkza8HQBu+2NTxyMOq9CPlJS4ibW8LddlN/o5zlS42BUjtWG
   59boAh7NhOH05NYvvmwndEpW3poxMDRo7Hzzl2x9Isf7M8i5FhVjDZy9W
   gIWREyBEM/h2wHKP/4ZOFKsW5hAlh/6lQSwnn+b/yjYwARuUo6f0oHRQn
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="320962771"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="320962771"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 14:37:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="650512936"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="650512936"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga007.jf.intel.com with ESMTP; 10 Jan 2023 14:37:49 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates 2023-01-10 (ixgbe, igc, iavf)
Date:   Tue, 10 Jan 2023 14:38:22 -0800
Message-Id: <20230110223825.648544-1-anthony.l.nguyen@intel.com>
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

This series contains updates to ixgbe, igc, and iavf drivers.

Yang Yingliang adds calls to pci_dev_put() for proper ref count tracking
on ixgbe.

Christopher adds setting of Toggle on Target Time bits for proper
pulse per second (PPS) synchronization for igc.

Daniil Tatianin fixes, likely, copy/paste issue that misreported
destination instead of source for IP mask for iavf error.

The following are changes since commit 53da7aec32982f5ee775b69dce06d63992ce4af3:
  octeontx2-pf: Fix resource leakage in VF driver unbind
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 10GbE

Christopher S Hall (1):
  igc: Fix PPS delta between two synchronized end-points

Daniil Tatianin (1):
  iavf/iavf_main: actually log ->src mask when talking about it

Yang Yingliang (1):
  ixgbe: fix pci device refcount leak

 drivers/net/ethernet/intel/iavf/iavf_main.c  |  2 +-
 drivers/net/ethernet/intel/igc/igc_defines.h |  2 ++
 drivers/net/ethernet/intel/igc/igc_ptp.c     | 10 ++++++----
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c | 14 +++++++++-----
 4 files changed, 18 insertions(+), 10 deletions(-)

-- 
2.38.1

