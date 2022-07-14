Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D66575458
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 20:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238859AbiGNSCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 14:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiGNSCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 14:02:09 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE63675B6
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 11:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657821728; x=1689357728;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VT0Ijbqng4OzusSeNaXDrtu+sy5F+W5zhbM2A8l8Lqo=;
  b=CAS6oIDaCgU+DpvKxcV96MPAO0erorH7fFXUE1exRCYaRixPd5tBDfv8
   aWX8zP+YClVLbgA/dlJkKwc8Cnm6aDK8gLe8fjEs8E1M2VHqMa2ctQMq/
   jwkeNv5fDSLjGvIXNXHK4DybDD3nrhDlOiwYVhX0/WqUTP9NGDlQYeExB
   joIGr2M2kO4rIOqy3vTLyRWSBY2apHcpgjfM7R6CSww3wp5CXbb/R46H8
   4ZeqnNjbt9hvgum/2OOfvbXEz6i3bqAWkI1TqmZkU5WWpfZTJ/3dxMz7h
   aRkAl8afgqWxSRIyFIrv6BdSjYRKrbRk1Q5Z8X9uEKzxYkCbpX71Jt2GO
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="283151243"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="283151243"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 11:01:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="842235639"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 14 Jul 2022 11:01:56 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sasha.neftin@intel.com
Subject: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates 2022-07-14
Date:   Thu, 14 Jul 2022 10:58:54 -0700
Message-Id: <20220714175857.933537-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to e1000e and igc drivers.

Sasha re-enables GPT clock when exiting s0ix to prevent hardware unit
hang and reverts a workaround for this issue on e1000e.

Lennert Buytenhek restores checks for removed device while accessing
registers to prevent NULL pointer dereferences for igc.

The following are changes since commit cd72e61bad145a0968df85193dcf1261cb66c4c6:
  selftests/net: test nexthop without gw
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 1GbE

Lennert Buytenhek (1):
  igc: Reinstate IGC_REMOVED logic and implement it properly

Sasha Neftin (2):
  e1000e: Enable GPT clock before sending message to CSME
  Revert "e1000e: Fix possible HW unit hang after an s0ix exit"

 drivers/net/ethernet/intel/e1000e/hw.h      |  1 -
 drivers/net/ethernet/intel/e1000e/ich8lan.c |  4 ---
 drivers/net/ethernet/intel/e1000e/ich8lan.h |  1 -
 drivers/net/ethernet/intel/e1000e/netdev.c  | 30 +++------------------
 drivers/net/ethernet/intel/igc/igc_main.c   |  3 +++
 drivers/net/ethernet/intel/igc/igc_regs.h   |  5 +++-
 6 files changed, 11 insertions(+), 33 deletions(-)

-- 
2.35.1

