Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD54F6436D2
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 22:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbiLEV0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 16:26:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233828AbiLEV0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 16:26:22 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CFA12D1FF
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 13:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670275530; x=1701811530;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=s1oUdCPyZd14T9FerpT+IGBuQ8aOGhMElH5KlKQoanQ=;
  b=Lwth4ohfOWDExkvTEDWm47VolsmY1aEfxFEXeR5ESEiwTkTuuCyrj5eF
   NiPzFsgoPemoV6tGEGijnbhHUtuBKSeHG9NzDSX/t4QK3g4n0PxGdVrz6
   JQFVhM/IgTXWoTOp4Ypw2WxLB+Da7EcWOu1IgWOGLzNMOzj5SD+HxC9ZR
   mfS5nMKeZgbFfcdeymxT1w/lnvjhG9P6iURxaktV9uk1Wfwoq0zOQBRQ8
   95Wm79HMQqNUF9faF9+X8211c5+E/M9Um367mWE9Hp0E6OOBhbYoXHFoh
   eLWdPeX9wOHZp7FCjvWwc1w1G00XzU0eJsSqYPVVGNPzPpaDePLjNJNEA
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="317611102"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="317611102"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 13:25:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="752359269"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="752359269"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 05 Dec 2022 13:25:28 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates 2022-12-05 (i40e)
Date:   Mon,  5 Dec 2022 13:25:20 -0800
Message-Id: <20221205212523.3197565-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e driver only.

Michal clears XPS init flag on reset to allow for updated values to be
written.

Sylwester adds sleep to VF reset to resolve issue of VFs not getting
resources.

Przemyslaw rejects filters for raw IPv4 or IPv6 l4_4_bytes filters as they
 are not supported.

The following are changes since commit e8b4fc13900b8e8be48debffd0dfd391772501f7:
  net: mvneta: Prevent out of bounds read in mvneta_config_rss()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Michal Jaron (1):
  i40e: Fix not setting default xps_cpus after reset

Przemyslaw Patynowski (1):
  i40e: Disallow ip4 and ip6 l4_4_bytes

Sylwester Dziedziuch (1):
  i40e: Fix for VF MAC address 0

 .../net/ethernet/intel/i40e/i40e_ethtool.c    | 12 ++----------
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 19 ++++++++++++++++++-
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    |  2 ++
 3 files changed, 22 insertions(+), 11 deletions(-)

-- 
2.35.1

