Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6F04B13CC
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 18:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245020AbiBJRFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 12:05:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244901AbiBJRFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 12:05:30 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2449AC12
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 09:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644512731; x=1676048731;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gQn2xUUajFEdERczONa1u1sb29mZeumEMz/zj9+Rmbo=;
  b=LY5+mEq4ICf4ZVjR4NV4eVAOTY/4mlb9LjuAoGOkPoxbSLYpfd9kW0hl
   eQmVwyN7GIGKDXYWRV5Qk7q2Q7W7snlealtOCxbAa8ZZgrr64R1UU1WZV
   eBXuEAULkBBdTE2B74osz/d1Ia9XrSdF5ZKSidrWg3mtsbBRWF1qEq2i6
   cBIVbXvzlNWVq0TiL0FrRATCnmRPpRzqLaJtNnJNS3PnI3x1UAywv/LL4
   wu9lyCbS40l2j/imrWmAOk/o5/3rzSkjRVqxX0PFwaCB/3o4eZujSjZwo
   R5jNU1ozCqPxlsT4c6bXlE4wDtPHre18QtBdywMdOCu9gkIrmoQdD2+Gt
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10254"; a="312825100"
X-IronPort-AV: E=Sophos;i="5.88,359,1635231600"; 
   d="scan'208";a="312825100"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 09:05:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,359,1635231600"; 
   d="scan'208";a="622742922"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Feb 2022 09:05:20 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates 2022-02-10
Date:   Thu, 10 Feb 2022 09:05:11 -0800
Message-Id: <20220210170515.2609656-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Dan Carpenter propagates an error in FEC configuration.

Jesse fixes TSO offloads of IPIP and SIT frames.

Dave adds a dedicated LAG unregister function to resolve a KASAN error
and moves auxiliary device re-creation after LAG removal to the service
task to avoid issues with RTNL lock.

The following are changes since commit c4416f5c2eb3ed48dfba265e628a6e52da962f03:
  net: mpls: Fix GCC 12 warning
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Dan Carpenter (1):
  ice: fix an error code in ice_cfg_phy_fec()

Dave Ertman (2):
  ice: Fix KASAN error in LAG NETDEV_UNREGISTER handler
  ice: Avoid RTNL lock when re-creating auxiliary device

Jesse Brandeburg (1):
  ice: fix IPIP and SIT TSO offload

 drivers/net/ethernet/intel/ice/ice.h          |  3 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |  3 +-
 drivers/net/ethernet/intel/ice/ice_lag.c      | 34 +++++++++++++++----
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |  1 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 28 ++++++++++-----
 5 files changed, 53 insertions(+), 16 deletions(-)

-- 
2.31.1

