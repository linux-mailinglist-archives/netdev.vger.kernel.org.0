Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAAE0675F78
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 22:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjATVMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 16:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjATVMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 16:12:14 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4906E8BA8F
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 13:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674249133; x=1705785133;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=J39nKyU/sRPVo96hC+fLxaR4Y50xRwudsHlP4oLOqHI=;
  b=LqPnkeTNvesscEBZy+5vOOWpaIeNEn64Qnk6od3v5Fz21+4MuZQpb4GG
   TlG8adgULbTrFKYRJ+uu+umJHJFLViXUJnx9t+tHwM2e6Gd+n639Kak0a
   XYw07Bl8Xm8oUEgJjIxFqV4ftxQK7dw6NeAK51P/eiGv89YHgwvIPfXaH
   nGLDmjL2lU7KU3+JbohCDuHxeFXOIA/FPIGreyF/P3PRUPMbbOk+YycFK
   RYZRLYJPsdfT5Yq93yHfbRAgLRESiaom1S9JMi95Uk3X/MbIdr1j/WB0r
   wWo1ifzeugYBAWsQ4vlA5iU650YwP/WIMj718MQX8z75bAfgzapEqSqko
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="324383370"
X-IronPort-AV: E=Sophos;i="5.97,233,1669104000"; 
   d="scan'208";a="324383370"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2023 13:12:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="653921168"
X-IronPort-AV: E=Sophos;i="5.97,233,1669104000"; 
   d="scan'208";a="653921168"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga007.jf.intel.com with ESMTP; 20 Jan 2023 13:12:12 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net v3 0/2][pull request] Intel Wired LAN Driver Updates 2023-01-20 (ice)
Date:   Fri, 20 Jan 2023 13:12:29 -0800
Message-Id: <20230120211231.431147-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
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

This series contains updates to ice driver only.

Dave prevents modifying channels when RDMA is active as this will break
RDMA traffic.

Michal fixes a broken URL.
---
v3:
- Reduced scope of lock in patch 1 to avoid double lock
- Dropped, previous, patch 2

v2: https://lore.kernel.org/netdev/20230103230738.1102585-1-anthony.l.nguyen@intel.com/
- Dropped, previous, patch 1.
- Replace RDMA patch to disallow change instead of replugging aux device

v1: https://lore.kernel.org/netdev/20221207211040.1099708-1-anthony.l.nguyen@intel.com/

The following are changes since commit 45a919bbb21c642e0c34dac483d1e003560159dc:
  Revert "Merge branch 'octeontx2-af-CPT'"
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Dave Ertman (1):
  ice: Prevent set_channel from changing queues while RDMA active

Michal Wilczynski (1):
  ice: Fix broken link in ice NAPI doc

 .../networking/device_drivers/ethernet/intel/ice.rst      | 2 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c              | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

-- 
2.38.1

