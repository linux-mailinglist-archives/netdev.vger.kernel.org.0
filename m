Return-Path: <netdev+bounces-3716-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DBEA70867D
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 19:14:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83EB11C21077
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 17:14:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C485124E95;
	Thu, 18 May 2023 17:14:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FE623C90
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 17:14:03 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0B410D4
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 10:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684430038; x=1715966038;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=f3hKeqxDxrO+zR8zpoOttN/wk1DXlEsKlvi8jZorKy4=;
  b=TanktPPILuCkI7L59fNyDybKM9/UgxFjGrXCcVCWmof1jH27bxhAi/nF
   QZHEysef91A5Aa6NfRzXPdRUg6cpA6MWFiOWhinARsIlWh3YQ+H9sZ2AJ
   fEcq/aemiFGMjtQ13La/vSHdDqTtfdBSQ5ERLP2960qWPOsdLk8OW3YNn
   o98/6GN+wHXWomtBXw9+ELYrbtGVvZvas3runl+SOyeXsu17bMuQL7lcw
   tRNZceexsa8D6AAR42mYEboCSVAeO5UIqmtzcs4rrA8l8GOcMLgf5rkKe
   7nqvbTFcMRFbzlT9/ejCj4H0SUQGG8QYKJRpZSDQPRqY4YndGM/HEcXtB
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="354468728"
X-IronPort-AV: E=Sophos;i="6.00,174,1681196400"; 
   d="scan'208";a="354468728"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 10:13:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="702207864"
X-IronPort-AV: E=Sophos;i="6.00,174,1681196400"; 
   d="scan'208";a="702207864"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga002.jf.intel.com with ESMTP; 18 May 2023 10:13:29 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH net-next 0/3][pull request] Intel Wired LAN Driver Updates 2023-05-18 (igc, igb, e1000e)
Date: Thu, 18 May 2023 10:09:39 -0700
Message-Id: <20230518170942.418109-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This series contains updates to igc, igb, and e1000e drivers.

Kurt Kanzenbach adds calls to txq_trans_cond_update() for XDP transmit
on igc.

Tom Rix makes definition of igb_pm_ops conditional on CONFIG_PM for igb.

Baozhu Ni adds a missing kdoc description on e1000e.

The following are changes since commit 02f8fc1a67c160b2faab2c9e9439026deb076971:
  Merge branch 'net-lan966x-add-support-for-pcp-dei-dscp'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Baozhu Ni (1):
  e1000e: Add @adapter description to kdoc

Kurt Kanzenbach (1):
  igc: Avoid transmit queue timeout for XDP

Tom Rix (1):
  igb: Define igb_pm_ops conditionally on CONFIG_PM

 drivers/net/ethernet/intel/e1000e/netdev.c | 2 +-
 drivers/net/ethernet/intel/igb/igb_main.c  | 2 ++
 drivers/net/ethernet/intel/igc/igc_main.c  | 8 ++++++++
 3 files changed, 11 insertions(+), 1 deletion(-)

-- 
2.38.1


