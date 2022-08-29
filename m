Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAEC5A569A
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 00:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiH2WBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 18:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiH2WBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 18:01:02 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C39C6D568
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 15:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661810461; x=1693346461;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qyjciZLLzuaSJmy3EOl4Qb3LmCfYexXAkFkWzG9SHHA=;
  b=an66jFNDc0Euoq1Qr+DyCZMOiR6r1+yyYZ+CI/CMP7mUwGMTJ6FfwYI6
   GvxoeYBwPYLfy6p5U4dHDC5pf/rPRiid8vJobEjZuoLwJmPuJQR52gjvr
   KJpUlXWj+xuSSYS5v/R9pHZhqfZa0tigDfVhskrENSmy2OAYyikT/5Fox
   H5pk58Zbc5N56lWsegOEdIFjDBbRPf5EsAdm+qWDwa7mqUcJcZAdungXV
   rGjOcgYqYdsgrp6WT5KdBvWpKcFhAtpFoxJ4G/b1EiNSl5k+gXAPAE31R
   hHxjjKSWibXdpriXDhCa3nTxgZOiv90HDj6Qljj+eb2je7ZwXKwCb2h+O
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="356726828"
X-IronPort-AV: E=Sophos;i="5.93,273,1654585200"; 
   d="scan'208";a="356726828"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2022 15:01:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,273,1654585200"; 
   d="scan'208";a="672551153"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 29 Aug 2022 15:00:59 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates 2022-08-29 (ice)
Date:   Mon, 29 Aug 2022 15:00:46 -0700
Message-Id: <20220829220049.333434-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Przemyslaw fixes memory leak of DMA memory due to incorrect freeing of
rx_buf.

Michal S corrects incorrect call to free memory.

Michal M adds mock implementation for set_termios to allow operation on
tools that require it.

The following are changes since commit cb10b0f91c5f76de981ef927e7dadec60c5a5d96:
  Merge branch 'u64_stats-fixups'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Michal Michalik (1):
  ice: Add set_termios tty operations handle to GNSS

Michal Swiatkowski (1):
  ice: use bitmap_free instead of devm_kfree

Przemyslaw Patynowski (1):
  ice: Fix DMA mappings leak

 drivers/net/ethernet/intel/ice/ice_base.c | 17 ------
 drivers/net/ethernet/intel/ice/ice_gnss.c | 15 ++++++
 drivers/net/ethernet/intel/ice/ice_main.c | 10 +++-
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 63 +++++++++++++++++++++++
 drivers/net/ethernet/l/ice/ice_xsk.h  |  8 +++
 5 files changed, 95 insertions(+), 18 deletions(-)

-- 
2.35.1
