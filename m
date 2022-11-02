Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45386616F5F
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 22:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbiKBVKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 17:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbiKBVKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 17:10:22 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069D3DFED
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 14:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667423419; x=1698959419;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lH28ApvQF8PVauQFWTKgpB5bXUu80kgLLL/9K1u8TO8=;
  b=dJwWHWQ9Q9WiUOnEP2h02AiWW7nqFldLpuq+NmBVo2p/ymwEhfJiYujG
   ps/ay9hmoD2OnFjGEvmPU2tcbl0MewE2U5xTmgKeAo2pXeswm2yjE/GI6
   hglqLKXJJDJ0N44na/kCnvk+eVotxtwT9xNAxNg9RUjo2dUmyZ09gGUXe
   BSgaKioz4riTSvkhgII+NOvUNBpF4Xs79gfgyRA+/FpL34/4rFxeBcIAQ
   pDhF/TEPrgC9NR4mfaR9VIm/s+AnCSQw8gxj6rM7LFQfczbn8anTmZgQ1
   N9bYOozySD5mJkpmken3vUJFUkWLw9vxj7SkUaj7rjh61EUMmt+6LjJvx
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="311245983"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="311245983"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 14:10:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="629102983"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="629102983"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 02 Nov 2022 14:10:18 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/7][pull request] Intel Wired LAN Driver Updates 2022-11-02 (i40e, iavf)
Date:   Wed,  2 Nov 2022 14:10:04 -0700
Message-Id: <20221102211011.2944983-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e and iavf drivers.

Joe Damato adds tracepoint information to i40e_napi_poll to expose helpful
debug information for users who'd like to get a better understanding of
how their NIC is performing as they adjust various parameters and tuning
knobs.

Note: this does not touch any XDP related code paths. This
tracepoint will only work when not using XDP. Care has been taken to avoid
changing control flow in i40e_napi_poll with this change.

Alicja adds error messaging for unsupported duplex settings for i40e.

Ye Xingchen replaces use of __FUNCTION__ with __func__ for iavf.

Bartosz changes tense of device removal message to be more clear on the
action for iavf.

The following are changes since commit ef2dd61af7366e5a42e828fff04932e32eb0eacc:
  Merge branch 'renesas-eswitch'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Alicja Kowalska (1):
  i40e: Add appropriate error message logged for incorrect duplex
    setting

Bartosz Staszewski (1):
  iavf: Change information about device removal in dmesg

Joe Damato (4):
  i40e: Store the irq number in i40e_q_vector
  i40e: Record number TXes cleaned during NAPI
  i40e: Record number of RXes cleaned during NAPI
  i40e: Add i40e_napi_poll tracepoint

ye xingchen (1):
  iavf: Replace __FUNCTION__ with __func__

 drivers/net/ethernet/intel/i40e/i40e.h        |  1 +
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |  4 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  1 +
 drivers/net/ethernet/intel/i40e/i40e_trace.h  | 49 +++++++++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 27 +++++++---
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  4 +-
 6 files changed, 77 insertions(+), 9 deletions(-)

-- 
2.35.1

