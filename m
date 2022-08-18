Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9FED598820
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344469AbiHRPy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344458AbiHRPy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:54:28 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DC0C650B
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 08:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660837981; x=1692373981;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/37Je0jl20X6Q8KlFqQO3ma76nRrJC/yQsA4xBxYtcE=;
  b=Cn14H8uB0r8cMYu9U/++Xls6eLgfS/Ur0vlPGryxP3Zl5GXilPvafJ66
   crrR+D5BJHra3+Fl8SIB5YNxV5w6jlXfwq52tnFd06pULmc59ZwUusF7Z
   xBm5bgQ8bAFd6B6H3iv/iFyagObRz3s1kvoTMvPtiJuwBTVd6lbrS5TLq
   5IpDhN3ZoFu0DMUyaae1ORy1OAwAHePMoDIRrvWAh9djZ17a7K7ivLPi1
   37aYA5JncoW34xlZXwRQCJ8NoKcB2xSGIA51zU9usyZdF/xS8j9mxhLGa
   EXnCFdqx727yDQmZsaMsR4LFm4pBH5M25U48zGArnALKd4MIc7fkcmpcU
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="318817377"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="318817377"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 08:52:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="676104295"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 18 Aug 2022 08:52:11 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/5][pull request] Intel Wired LAN Driver Updates 2022-08-18 (ice)
Date:   Thu, 18 Aug 2022 08:52:02 -0700
Message-Id: <20220818155207.996297-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Jesse and Anatolii add support for controlling FCS/CRC stripping via
ethtool.

Anirudh allows for 100M speeds on devices which support it.

Sylwester removes ucast_shared field and the associated dead code related
to it.

Mikael removes non-inclusive language from the driver.

The following are changes since commit e34cfee65ec891a319ce79797dda18083af33a76:
  stmmac: intel: remove unused 'has_crossts' flag
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Anatolii Gerasymenko (1):
  ice: Implement FCS/CRC and VLAN stripping co-existence policy

Anirudh Venkataramanan (1):
  ice: Allow 100M speeds for some devices

Jesse Brandeburg (1):
  ice: Implement control of FCS/CRC stripping

Mikael Barsehyan (1):
  ice: remove non-inclusive language

Sylwester Dziedziuch (1):
  ice: Remove ucast_shared

 drivers/net/ethernet/intel/ice/ice.h         |   1 +
 drivers/net/ethernet/intel/ice/ice_base.c    |   2 +-
 drivers/net/ethernet/intel/ice/ice_common.c  |  20 +++
 drivers/net/ethernet/intel/ice/ice_common.h  |   1 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c |  16 +-
 drivers/net/ethernet/intel/ice/ice_lag.c     |  16 +-
 drivers/net/ethernet/intel/ice/ice_lag.h     |   2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c     |  22 +++
 drivers/net/ethernet/intel/ice/ice_lib.h     |   2 +
 drivers/net/ethernet/intel/ice/ice_main.c    |  67 +++++++-
 drivers/net/ethernet/intel/ice/ice_switch.c  | 166 +------------------
 drivers/net/ethernet/intel/ice/ice_txrx.h    |   3 +-
 drivers/net/ethernet/intel/ice/ice_type.h    |   2 -
 13 files changed, 136 insertions(+), 184 deletions(-)

-- 
2.35.1

