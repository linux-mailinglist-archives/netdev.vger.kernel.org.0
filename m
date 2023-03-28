Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A0F6CC929
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 19:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbjC1RW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 13:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjC1RW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 13:22:57 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EEA12D5B
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 10:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680024176; x=1711560176;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dM3zX68y+P4sOxcXTHfMbOklc8xG2N9fOQ9l6WNBqEk=;
  b=a/vUFYhoQQbKnSnsRH0VSEj5Tklw62EnAD1YBQI05tDrdQJQ7hQhAopC
   IIyO4RzuBTrbM1PFz2zPSSKKc1XpTKa9ckIy2A++EwrfS22rctIfwhdgD
   AHNvk/TwVAuP9aH56jxBXAVDVCe7nuutTnDY7ezIdh30gi4TSdsrHPzRI
   yX8guJ4YCAucJeW+5BDZs3IhnHv+jx0MKzdxBUAe3piaI9gNOZDu/tzAU
   nBlH5ObyiXB2XHQz+D8TjQGuVoZpTJrOVGppFGyJFssVjigPIWI4Z+cv8
   bEXjGsu4v6xmvBa4eAKyoOoAwvWwmvMQ1bkkv1R5cldXDg6UktNUvT2cm
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="340658906"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="340658906"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 10:22:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="807906249"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="807906249"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga004.jf.intel.com with ESMTP; 28 Mar 2023 10:22:55 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates 2023-03-28 (ice)
Date:   Tue, 28 Mar 2023 10:20:31 -0700
Message-Id: <20230328172035.3904953-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Jesse fixes mismatched header documentation reported when building with
W=1.

Brett restricts setting of VSI context to only applicable fields for the
given ICE_AQ_VSI_PROP_Q_OPT_VALID bit.

Junfeng adds check when adding Flow Director filters that conflict with
existing filter rules.

Jakob Koschel adds interim variable for iterating to prevent possible
misuse after looping.

The following are changes since commit 917fd7d6cdda179fdced2ebb060a9cda517d76e0:
  Merge branch 'xen-netback-fix-issue-introduced-recently'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Brett Creeley (1):
  ice: Fix ice_cfg_rdma_fltr() to only update relevant fields

Jakob Koschel (1):
  ice: fix invalid check for empty list in ice_sched_assoc_vsi_to_agg()

Jesse Brandeburg (1):
  ice: fix W=1 headers mismatch

Junfeng Guo (1):
  ice: add profile conflict check for AVF FDIR

 drivers/net/ethernet/intel/ice/ice_sched.c    |  8 +-
 drivers/net/ethernet/intel/ice/ice_switch.c   | 26 ++++++-
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  2 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  1 +
 .../ethernet/intel/ice/ice_virtchnl_fdir.c    | 73 +++++++++++++++++++
 5 files changed, 102 insertions(+), 8 deletions(-)

-- 
2.38.1

