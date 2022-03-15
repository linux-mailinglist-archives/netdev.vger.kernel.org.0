Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD304DA45E
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 22:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351877AbiCOVNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 17:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234409AbiCOVNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 17:13:13 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019415B3C4
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 14:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647378720; x=1678914720;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HbWltACEdZDfRNUUsmFAXFzsn4no73DrGp8B0e+REgs=;
  b=WfYIldPzkdPaMN+jhrW+kSgGV+LWlWmQS7cYl1aE1EdQHL4IfWW/jl3c
   JP0XX+/x6i3KyMV8ubE5uzATTKpAKc5jr9a76/4Bj30RLqOoIIlEDYHAT
   hCu7JUd+JQD+5FQySU15Ts1BICvfpqs5nLZE1wvCaPndv5fFTIqSq9MrO
   gud6aQb8V3cgJK+LEPGZyWKgJqp05A3lNu2bHX5PZW58/6e9A5j/t42Tz
   D1ZQgCKU1EP0ayvB0Qbwrq72Jw+Zng4nbif7/+rnt0Ugd6OB6qUcVYjIZ
   8TqRb9vhEIxfzmG3SMKzdlFO+g5z08FIzMxNPnIv8unrAyX5uZFF7DwVL
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="236370468"
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="236370468"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 14:12:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="820113201"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 15 Mar 2022 14:12:00 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates 2022-03-15
Date:   Tue, 15 Mar 2022 14:12:22 -0700
Message-Id: <20220315211225.2923496-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice and iavf drivers.

Maciej adjusts null check logic on Tx ring to prevent possible NULL
pointer dereference for ice.

Sudheer moves destruction of Flow Director lock as it was being accessed
after destruction for ice.

Przemyslaw removes an excess mutex unlock as it was being double
unlocked for iavf.

The following are changes since commit e9c14b59ea2ec19afe22d60b07583b7e08c74290:
  Add Paolo Abeni to networking maintainers
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Maciej Fijalkowski (1):
  ice: fix NULL pointer dereference in ice_update_vsi_tx_ring_stats()

Przemyslaw Patynowski (1):
  iavf: Fix double free in iavf_reset_task

Sudheer Mogilappagari (1):
  ice: destroy flow director filter mutex after releasing VSIs

 drivers/net/ethernet/intel/iavf/iavf_main.c | 8 +++++++-
 drivers/net/ethernet/intel/ice/ice_main.c   | 7 ++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

-- 
2.31.1

