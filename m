Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA82570DDA
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 01:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbiGKXFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 19:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbiGKXFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 19:05:48 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C6A8688C
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 16:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657580747; x=1689116747;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+mUiSXbEsRdk3Pne/TZu66zdGOGUEGugF0QIxRVqsuw=;
  b=D1DlWcjUcVFuBfyft6AqRH0Va2jTrdN+8uLIrM050TGF3dADyCFF3woj
   eKsrzg9RJab/cboGqCNS0Fo9XSkhTjd21e9ImF/V4rwl4PAedfGH2xTg/
   Bx9KMB4V42rWR/WS5VxUM9P+qQe0O7jo3oHzjgac0MxMHUyPX5sDFKuoJ
   +0IiuMoZWULe8fmgKtJVoij9zZZ7Vmfjw5CulV7PeO2KjQzAHIssU0XM7
   v/Tmzw4F9/ByPJoPljiLsM/4NDhgyl7ElHGIe0ri4iVQ+S0nudyN3lUFK
   eLEpIS8tCRSlwElWq76UCsm6byENguL52mCsvCvltibxu6T9mzweO83r3
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="346473368"
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="346473368"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 16:05:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="599189363"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 11 Jul 2022 16:05:45 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/7][pull request] Intel Wired LAN Driver Updates 2022-07-11
Date:   Mon, 11 Jul 2022 16:02:36 -0700
Message-Id: <20220711230243.3123667-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to iavf driver only.

Przemyslaw fixes handling of multiple VLAN requests to account for
individual errors instead of rejecting them all. He removes incorrect
implementations of ETHTOOL_COALESCE_MAX_FRAMES and
ETHTOOL_COALESCE_MAX_FRAMES_IRQ.

He also corrects issues such as memory leaks, NULL pointer
dereferences, etc in various error paths. Finally, he corrects debug
prints reporting an unknown state.

The following are changes since commit e45955766b4300e7bbeeaa1c31e0001fe16383e7:
  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Przemyslaw Patynowski (7):
  iavf: Fix VLAN_V2 addition/rejection
  iavf: Disallow changing rx/tx-frames and rx/tx-frames-irq
  iavf: Fix reset error handling
  iavf: Fix NULL pointer dereference in iavf_get_link_ksettings
  iavf: Fix adminq error handling
  iavf: Fix handling of dummy receive descriptors
  iavf: Fix missing state logs

 drivers/net/ethernet/intel/iavf/iavf.h        | 14 +++-
 drivers/net/ethernet/intel/iavf/iavf_adminq.c | 15 ++++-
 .../net/ethernet/intel/iavf/iavf_ethtool.c    | 16 ++---
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 22 +++----
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   |  7 +-
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 65 ++++++++++++++++++-
 6 files changed, 107 insertions(+), 32 deletions(-)

-- 
2.35.1

