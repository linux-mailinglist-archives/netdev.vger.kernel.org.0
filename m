Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1104C77E7
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 19:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbiB1Sfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 13:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240661AbiB1Sf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 13:35:28 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2411CFE4
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 10:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646072437; x=1677608437;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1EYT2ctLZAQmOgo8DTUO1Jn/p9ood/f1zT2aEE1roCw=;
  b=QeGw+lkIeGWczHQD9w6N/QqhwDQPc4JZr9ATZXjTTT209UMenBZwlzXY
   0QkfjeRZITkpJNdbLS7tH88Oenwq8YyxltwbnUE+JljxdmKT6LN32n8eS
   CUWdyKR19Lzcj/p4R+xfl1jz/W6e+ymRbHqJhq49i1IB6rkPaSCHJ2/2f
   Whg/UE33BBTfMqytFVqOGy+YKP8ltNe12dY64OMJkzZ1SzT3KeUUNlP/R
   U6mm7So5MqAH9cIEu2+psKYisCd6k2rV6BqMZV1/8P0iyMmU0mZf6v8RA
   MIG6+nXPcRfq5PVIYF7TwIbnL0ya37yDrDYyC9wWtmNt4zh3sqAwkMySq
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="316165875"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="316165875"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 10:20:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="575406549"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 28 Feb 2022 10:20:34 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com
Subject: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates 2022-02-28
Date:   Mon, 28 Feb 2022 10:20:41 -0800
Message-Id: <20220228182045.1562938-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

