Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C612D5EB221
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 22:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiIZUcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 16:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiIZUcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 16:32:22 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2558DA486C
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 13:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664224341; x=1695760341;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xPxyTcGW9tfNfK6ZOTLZyX8mUG8VnYsOgNCH+GQHsx8=;
  b=guvc621el+1PAnygTLzYD19V4rXkLN+cnNOh0+57oKdkYqS8kSmu4YZs
   1E3eGs2I9p7dMSG9vbUQyP/mcoQZdBWcQMJrCSAkFlTddg9/sqjolsVGD
   7ue9IP/YZWrD8BrLj5KmoJXQR46sGxzlLOMy57OdKUCRNqXfpjxsHzv80
   hLYa3nEgFOswqfwhBltVxoHUACqutvcsD2bcPHxL8nr2tOrsLcBAvCJtS
   Pf9d+a4GaTVvDOtFTJsbDOwo6CKWz7lzP9BAY2CxZ99qaB/fnz534X+NR
   RmdZ5Dwct3GZotW647+U4jVk0kbnvlswbMXPBmj252HSyTsr3iC3zMT09
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="281508583"
X-IronPort-AV: E=Sophos;i="5.93,347,1654585200"; 
   d="scan'208";a="281508583"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 13:32:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="616547437"
X-IronPort-AV: E=Sophos;i="5.93,347,1654585200"; 
   d="scan'208";a="616547437"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 26 Sep 2022 13:32:19 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates 2022-09-26 (i40e)
Date:   Mon, 26 Sep 2022 13:32:11 -0700
Message-Id: <20220926203214.3678419-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e driver only.

Slawomir fixes using incorrect register masks on X722 devices.

Michal saves then restores XPS settings after reset.

Jan fixes memory leak of DMA memory due to incorrect freeing of rx_buf.

The following are changes since commit b7ca8d5f56e6c57b671ceb8de1361d2a5a495087:
  sfc: correct filter_table_remove method for EF10 PFs
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Jan Sokolowski (1):
  i40e: Fix DMA mappings leak

Michal Jaron (1):
  i40e: Fix not setting xps_cpus after reset

Slawomir Laba (1):
  i40e: Fix ethtool rx-flow-hash setting for X722

 drivers/net/ethernet/intel/i40e/i40e.h        |   6 +
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |  34 +++--
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 122 +++++++++++++++++-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  13 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.h   |   1 -
 drivers/net/ethernet/intel/i40e/i40e_type.h   |   4 +
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    |  67 ++++++++--
 drivers/net/ethernet/intel/i40e/i40e_xsk.h    |   2 +-
 8 files changed, 213 insertions(+), 36 deletions(-)

-- 
2.35.1

