Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CED0D4C7CBA
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 23:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiB1WEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 17:04:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiB1WEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 17:04:41 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C117C4B44
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 14:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646085841; x=1677621841;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OWyBOnkGpTTiZDG5hTI9ZSJadFFkomHu+AE8COJKXKU=;
  b=kE+goV1y1OP5H6NaOpkI1x9euMYxDnB6ubJbXmFTZom+5+4XuO4aAenv
   BQMlbm4y+yLyyvcI/ORCZD8XWQV9aGYIwYm+EqvOjNlcnT6X3Jy2nR1Oo
   IWI8zNUqwiTLY6F3Pwc5jNLrPZbIvMaT6p8aV8yFsrRwwzskHZUJs2Q0b
   5tgNvQvT0RLH6VZBFF/lTPL9EcsxVSNxnkKPNYxu5p/4aiIkH4Eeg9JoR
   WQf9ZNbDCN4g+NMhEZKZJkQrwS4eEUkGsmJKcw2hVW1HXn9tf/15BHtrc
   dcqN1wmMW8GbJpCndZA3OtKFo8ha3lY4i4zj0n0+P0PSl7CQp14uzJwqt
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="236506445"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="236506445"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 14:04:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="575476136"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 28 Feb 2022 14:04:00 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com
Subject: [PATCH net v2 0/4][pull request] Intel Wired LAN Driver Updates 2022-02-28
Date:   Mon, 28 Feb 2022 14:04:08 -0800
Message-Id: <20220228220412.2129191-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igc and e1000e drivers.

Corinna Vinschen ensures release of hardware sempahore on failed
register read in igc_read_phy_reg_gpy().

Sasha does the same for the write variant, igc_write_phy_reg_gpy(). On
e1000e, he resolves an issue with hardware unit hang on s0ix exit
by disabling some bits and LAN connected device reset during power
management flows. Lastly, he allows for TGP platforms to correct its
NVM checksum.

v2: Fix Fixes tag on patch 3

The following are changes since commit caef14b7530c065fb85d54492768fa48fdb5093e:
  net: ipa: fix a build dependency
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 1GbE

Corinna Vinschen (1):
  igc: igc_read_phy_reg_gpy: drop premature return

Sasha Neftin (3):
  igc: igc_write_phy_reg_gpy: drop premature return
  e1000e: Fix possible HW unit hang after an s0ix exit
  e1000e: Correct NVM checksum verification flow

 drivers/net/ethernet/intel/e1000e/hw.h      |  1 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c |  8 +++++--
 drivers/net/ethernet/intel/e1000e/ich8lan.h |  1 +
 drivers/net/ethernet/intel/e1000e/netdev.c  | 26 +++++++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_phy.c    |  4 ----
 5 files changed, 34 insertions(+), 6 deletions(-)

-- 
2.31.1

