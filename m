Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2E06623837
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 01:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbiKJAhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 19:37:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiKJAhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 19:37:54 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886012733
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 16:37:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668040673; x=1699576673;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uSroB0ZaxxXS6fCBvn7VRffMP23KfZvbT96gWE93wG8=;
  b=czzmaA7+VCiPvjtIr0/hJyZCT5JOpOd7eBPYd72JwzMTO8w69tsbELz/
   OeYekPZOK8wRW3rezIlSh0puQzWxvzXpJc4AlXjn+c+LQQ3C/NWTDNbUw
   hqmoEBKCzFDzU4HGe9v+Sly4Av8kNDet+uxfC+Br0ba0kcRqYrZbd362w
   Js+z532oN+XfajdKnNH+40xKz5KPiP2PPFIWCuKh9I9W+WHG3gURr6oia
   KeHSNA4AsxNN02OfKA+j/Wn2jyw7vbpDhO9ZSzItOyb2ehqW2SuCk84Y4
   Bs6a4SmkP8ay7+uaVjNrCnaiqctvBIAdM2T2aPihIrVkyYt7VWDBY/x4u
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="291560344"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="291560344"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 16:37:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="587969647"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="587969647"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 09 Nov 2022 16:37:52 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net v2 0/2][pull request] Intel Wired LAN Driver Updates 2022-11-09 (ice, iavf)
Date:   Wed,  9 Nov 2022 16:37:42 -0800
Message-Id: <20221110003744.201414-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
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

This series contains updates to ice and iavf drivers.

Norbert stops disabling VF queues that are not enabled for ice driver.

Michal stops accounting of VLAN 0 filter to match expectations of PF
driver for iavf.
---
v2: Drop, previous, patch 2; type change for signedness.

The following are changes since commit 27c064ae14d1a80c790ce019759500c95a2a9551:
  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Michal Jaron (1):
  iavf: Fix VF driver counting VLAN 0 filters

Norbert Zulinski (1):
  ice: Fix spurious interrupt during removal of trusted VF

 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  2 ++
 drivers/net/ethernet/intel/ice/ice_base.c     |  2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      | 25 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_lib.h      |  1 +
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   |  5 +++-
 5 files changed, 33 insertions(+), 2 deletions(-)

-- 
2.35.1

