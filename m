Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709A9646314
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 22:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiLGVLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 16:11:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiLGVL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 16:11:29 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33818139D
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 13:10:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670447459; x=1701983459;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ukJKSR+idT28LSwyE+rYwA5B8OXnooFilWZICdStoRo=;
  b=Oe/+1kF1qfDS+qGk/K3v2MvXiistav9CaGjO6xS18uM0/nyqed4yBJzB
   EJiSSxEAiosQcq2pEBUv/1u1CkksfwLviMtzrGReBrjWa++w1hKRXggBC
   h02ZojTQcRsdTFpqlHJQaUaqHTvU0C2thYQ7Yj+iW+j5ZqKeXpENYvxZV
   OIDRp8/6Ip7xE57BV5xa+97ng3fWiPqT/Zhcz+MybT9Tf7tebbWMp6nwJ
   VRWAR6Cr3O1MvE4bh6zKSwj7NUUjjM5bDkzApJc69OY26tNOp5KrmCYC6
   xWMYMOp3/Spdt3wRp9FWxlCTpdBbgJi3rzvkZm8wg0xKFooYMa6yENPEk
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="344047287"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="344047287"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 13:10:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="679280188"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="679280188"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 07 Dec 2022 13:10:52 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates 2022-12-07 (ice)
Date:   Wed,  7 Dec 2022 13:10:36 -0800
Message-Id: <20221207211040.1099708-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Anatolii adds an additional kthread worker for extended timestamp work as
AdminQ calls are disrupting timestamp work.

Dave adds replugging of aux device when channels are reconfigured so
updated resources can be redistributed.

Mateusz replaces unregister_netdev() call with call to clear rings as
there can be a deadlock with the former call.

Michal fixes a broken URL.

The following are changes since commit 87a39882b5ab3127700ac4b9277608075f98eda2:
  net: dsa: mv88e6xxx: accept phy-mode = "internal" for internal PHY ports
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Anatolii Gerasymenko (1):
  ice: Create a separate kthread to handle ptp extts work

Dave Ertman (1):
  ice: Correctly handle aux device when num channels change

Mateusz Palczewski (1):
  ice: Fix deadlock on the rtnl_mutex

Michal Wilczynski (1):
  ice: Fix broken link in ice NAPI doc

 .../device_drivers/ethernet/intel/ice.rst         |  2 +-
 drivers/net/ethernet/intel/ice/ice.h              |  2 ++
 drivers/net/ethernet/intel/ice/ice_ethtool.c      |  6 ++++++
 drivers/net/ethernet/intel/ice/ice_idc.c          |  3 +++
 drivers/net/ethernet/intel/ice/ice_lib.c          | 10 ++++------
 drivers/net/ethernet/intel/ice/ice_main.c         |  8 +++++++-
 drivers/net/ethernet/intel/ice/ice_ptp.c          | 15 ++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_ptp.h          |  2 ++
 8 files changed, 39 insertions(+), 9 deletions(-)

-- 
2.35.1

