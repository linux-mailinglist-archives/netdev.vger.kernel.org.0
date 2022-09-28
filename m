Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B1B5EE691
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 22:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbiI1UVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 16:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbiI1UVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 16:21:46 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAF370E60
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 13:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664396505; x=1695932505;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qY89sGMVK70AAJz/Dv3UWeSYrr2XAspp+JojLdNk198=;
  b=V64Xyhrd4wcUEyRj5tr4HXbK+/CGGHa3w6ZBfPcSgQTjN5K6D56WmV6W
   1jLkskrqprF3Mc91nMrQHasC6t5K+7sHu2nLfvx4lS2Ht/WF5fwtc1/ej
   aqLkMOd77yoco3BJpQsybusXv71BCtEN9yfluQL9GvlVkqK1cejfgbivD
   5/46kw1g1T4LoheyN845ZgPBzBN2SiBiMh5k9qYwyydzSg6pHtX2GE6lx
   c9FtaLCQrI9XWLHmIsotv04sVXLNCwQHBeOt2YpywYbzIxScGGxy6eaRS
   VQXSplaC6fDnAOvKdeTTAjCkbc79DryBNmGrxEwIhY+fNfLZ4SG968vlr
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="299306426"
X-IronPort-AV: E=Sophos;i="5.93,352,1654585200"; 
   d="scan'208";a="299306426"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 13:21:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="655265494"
X-IronPort-AV: E=Sophos;i="5.93,352,1654585200"; 
   d="scan'208";a="655265494"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 28 Sep 2022 13:21:43 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net v2 0/2][pull request] Intel Wired LAN Driver Updates 2022-09-28 (i40e)
Date:   Wed, 28 Sep 2022 13:21:36 -0700
Message-Id: <20220928202138.409759-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e driver only.

Slawomir fixes using incorrect register masks on X722 devices.

Jan fixes memory leak of DMA memory due to incorrect freeing of rx_buf.
---
v2: Drop XPS patch, previously patch 2.

The following are changes since commit 44d70bb561dac9363f45787aa93dfca36877ee01:
  Merge tag 'wireless-2022-09-27' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Jan Sokolowski (1):
  i40e: Fix DMA mappings leak

Slawomir Laba (1):
  i40e: Fix ethtool rx-flow-hash setting for X722

 .../net/ethernet/intel/i40e/i40e_ethtool.c    | 34 +++++++---
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 13 ++--
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 13 ++--
 drivers/net/ethernet/intel/i40e/i40e_txrx.h   |  1 -
 drivers/net/ethernet/intel/i40e/i40e_type.h   |  4 ++
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 67 ++++++++++++++++---
 drivers/net/ethernet/intel/i40e/i40e_xsk.h    |  2 +-
 7 files changed, 98 insertions(+), 36 deletions(-)

-- 
2.35.1

