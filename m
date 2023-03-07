Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62AB16AF859
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjCGWPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjCGWO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:14:57 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3757580FD
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 14:14:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678227294; x=1709763294;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gcofydNM1ddXvwUqKYjFVpau5LDcbaNRxmeGzfc1uMc=;
  b=fy+qrGKNIBp6j7AkAVqcbTls3IcrZqftv1uo8VPlHYpqfKXlY9E+pnhl
   EtTtr470JBW6mAEX1KYQu4UXBkaYLDACjtOEE1GWC0uuaeD8CviAAwII6
   rd0k9U67qD4ckSlMhsDdeB1rQxXs5DegRS9zcyerm+uY3w+UPq6R46IL9
   EOlB2D6cULdefPpbTb6w49/Puv2Sq+0dZF/BWjsGLGuUz19JRKxeZ7fV+
   6qKNk0fld9bVY8Gjk6KvZ0fDprv5jPOVcZ6O0F3Vy4epw9njNtBxP1d1B
   2Xm99RPM5eor7eq/sMrpKzYpObmZxpELbLgqQ6l1t0qxKpG9sRjVjPFlf
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="338310784"
X-IronPort-AV: E=Sophos;i="5.98,242,1673942400"; 
   d="scan'208";a="338310784"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 14:14:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="626701493"
X-IronPort-AV: E=Sophos;i="5.98,242,1673942400"; 
   d="scan'208";a="626701493"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga003.jf.intel.com with ESMTP; 07 Mar 2023 14:14:54 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, sasha.neftin@intel.com,
        muhammad.husaini.zulkifli@intel.com
Subject: [PATCH net-next v2 0/3][pull request] Intel Wired LAN Driver Updates 2023-03-07 (igc)
Date:   Tue,  7 Mar 2023 14:13:29 -0800
Message-Id: <20230307221332.3997881-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igc driver only.

Muhammad adds tracking and reporting of QBV config errors.

Tan Tee adds support for configuring max SDU for each Tx queue.

Sasha removes check for alternate media as only one media type is
supported.
---
v2:
Patch 1:
- Add check so errors are not counted on setting new configuration
Patch 2:
- Add tracking of discard to txdrop
- Rework code to avoid extra return
- Reduce scope of max_sdu var

v1: https://lore.kernel.org/netdev/20230125212702.4030240-1-anthony.l.nguyen@intel.com/

The following are changes since commit 36e5e391a25af28dc1f4586f95d577b38ff4ed72:
  Merge tag 'for-netdev' of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Muhammad Husaini Zulkifli (1):
  igc: Add qbv_config_change_errors counter

Sasha Neftin (1):
  igc: Clean up and optimize watchdog task

Tan Tee Min (1):
  igc: offload queue max SDU from tc-taprio

 drivers/net/ethernet/intel/igc/igc.h         |  4 +-
 drivers/net/ethernet/intel/igc/igc_ethtool.c |  1 +
 drivers/net/ethernet/intel/igc/igc_hw.h      |  1 +
 drivers/net/ethernet/intel/igc/igc_main.c    | 51 ++++++++++++--------
 drivers/net/ethernet/intel/igc/igc_tsn.c     | 12 +++++
 5 files changed, 46 insertions(+), 23 deletions(-)

-- 
2.38.1

