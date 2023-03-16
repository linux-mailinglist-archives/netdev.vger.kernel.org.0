Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 848226BD468
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 16:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjCPPy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 11:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCPPy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 11:54:57 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B44840E3
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678982096; x=1710518096;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=y0qb4cvEOv8flplDdHm0wHFe5NkH8mJ1D26m/29QTq4=;
  b=HrChGttD4DrO8Tgav8Lcz6pByiZLafVAHbYxIRqgABXwXIhLPwyMVnAW
   TtCBDaBeP+4k8VYTjfwjrZqDM0J0Ho1V8cFYquAA/XxguEuC5WhPNoEkS
   l2zabbyhIXstl1O81FxiYR53IKdZgZhNHE2AU8f3DMu1Ausb1Dhi6BrCW
   6eY/u+aguFEWTzYi7a/hh25nTb4BqMmYmHso9bISbRHIat4gPyvHZd39F
   oH67QU1AVdwyo8sLjEiXYuKtnx1ySpbaJR8aQdNbzXP9xRaKOyqsnKXOn
   tPt4oriaxVmTX4CCug+w5gSnHowKcVMvbJ76LjKURPuAScD8tDAQJLEze
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="340406417"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="340406417"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 08:54:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="769010286"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="769010286"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Mar 2023 08:54:55 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, leonro@nvidia.com
Subject: [PATCH net v2 0/3][pull request] Intel Wired LAN Driver Updates 2023-03-16 (iavf)
Date:   Thu, 16 Mar 2023 08:53:13 -0700
Message-Id: <20230316155316.1554931-1-anthony.l.nguyen@intel.com>
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

This series contains updates to iavf driver only.

Alex fixes incorrect check against Rx hash feature and corrects payload
value for IPv6 UDP packet.

Ahmed removes bookkeeping of VLAN 0 filter as it always exists and can
cause a false max filter error message.
---
v2:
- Add VLAN 0 check to iavf_vlan_rx_kill_vid()

v1: https://lore.kernel.org/netdev/20230314174423.1048526-1-anthony.l.nguyen@intel.com/

The following are changes since commit cd356010ce4c69ac7e1a40586112df24d22c6a4b:
  net: phy: mscc: fix deadlock in phy_ethtool_{get,set}_wol()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Ahmed Zaki (1):
  iavf: do not track VLAN 0 filters

Alexander Lobakin (2):
  iavf: fix inverted Rx hash condition leading to disabled hash
  iavf: fix non-tunneled IPv6 UDP packet type and hashing

 drivers/net/ethernet/intel/iavf/iavf_common.c   | 2 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c     | 8 ++++++++
 drivers/net/ethernet/intel/iavf/iavf_txrx.c     | 2 +-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c | 2 --
 4 files changed, 10 insertions(+), 4 deletions(-)

-- 
2.38.1

