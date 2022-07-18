Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78EBB5788CA
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 19:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbiGRRvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 13:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiGRRvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 13:51:09 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1322B608
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 10:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658166667; x=1689702667;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=h5sl9Y9nvwWiVXxJQu2cD+B34YnhrJTiCmYAWu15urg=;
  b=AjxOIBej5VIoklMGVy7Q56RyhEQvc0iWQPh3LH2A0NCN3d+rUjjh371v
   6KbMS9Wy6lpPwE/RNi7IhiHcrYuvMFjagfDjatZ+exWvg6yLFrF2Cra2q
   5ScYihVGBblGnS/bPVcN9sOok4mhECKp0HJTMe0Tx2fOCV3I6Q8rfplnA
   oQJu3jK85JG8r98Zun+BiH+Gj2Cz8zZ9Tfa9EXclQEiwztViPG/WLNmXA
   sJQbCGyMHVtMy9gskl13qO2VeZAOzYAQnVoQ4aMFgmt1z8NlSatxi79e1
   cDnMmB74uRGGEzDg7nDLln/xAp5w//u1148E5FTelBBtpDJZS/7QOKC6y
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="347970940"
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="347970940"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 10:51:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="624825872"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 18 Jul 2022 10:51:07 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net v2 0/4][pull request] Intel Wired LAN Driver Updates 2022-07-18
Date:   Mon, 18 Jul 2022 10:48:03 -0700
Message-Id: <20220718174807.4113582-1-anthony.l.nguyen@intel.com>
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

This series contains updates to iavf driver only.

Przemyslaw fixes handling of multiple VLAN requests to account for
individual errors instead of rejecting them all. He removes incorrect
implementations of ETHTOOL_COALESCE_MAX_FRAMES and
ETHTOOL_COALESCE_MAX_FRAMES_IRQ.

He also corrects an issue with NULL pointer caused by improper handling of
dummy receive descriptors. Finally, he corrects debug prints reporting an
unknown state.
---
v2: Dropped, previous, patches 3-5 for further testing after making
requested changes.

The following are changes since commit c32349f3257f329a01e776e02b577bf7af97f30b:
  Merge branch 'dsa-docs'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Przemyslaw Patynowski (4):
  iavf: Fix VLAN_V2 addition/rejection
  iavf: Disallow changing rx/tx-frames and rx/tx-frames-irq
  iavf: Fix handling of dummy receive descriptors
  iavf: Fix missing state logs

 drivers/net/ethernet/intel/iavf/iavf.h        | 14 +++-
 .../net/ethernet/intel/iavf/iavf_ethtool.c    | 10 ---
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 11 ++--
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   |  7 +-
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 65 ++++++++++++++++++-
 5 files changed, 81 insertions(+), 26 deletions(-)

-- 
2.35.1

