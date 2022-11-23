Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B883636E06
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 00:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiKWXEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 18:04:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiKWXEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 18:04:13 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B3311606C
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 15:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669244652; x=1700780652;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=69RQs+q8AdKiK0ZmuMXyy7TXsymlkiTPUQ1ThwFyJCc=;
  b=a/yv7949tDJEBcf9bPDLTVWxLUqjLL0FW+pcaNq6u5zXMPZCrYO5h584
   NrcwzR2sry/9g1G/cXqaHNpECS+sdXkhD7Uw3k2hWFs0MvquZUda4oVMQ
   9HZBUGubDLjtjW3535Gcn9arxc+gddSPzWcpzg/qalVn8RfcPj7irZOK3
   qKX+3CXxp4B6SmHLlCYwcFrAlVPAAI642SFHWRGW03LuuFinKSHvxed6u
   EQg1N+wcnr4jyy4fYkqFGkHAiCy5GB6B/OhsF+M3yDezMz7+bnDtWZoPE
   rPGpjuLj9UOuZaPIuHq3WaP1QB8ufNEapMs/h94k3k+p5pu/odJKk0Emo
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="297533732"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="297533732"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 15:04:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="887124309"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="887124309"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 23 Nov 2022 15:04:11 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/5][pull request] Intel Wired LAN Driver Updates 2022-11-23 (ixgbevf, i40e, fm10k, iavf, e100)
Date:   Wed, 23 Nov 2022 15:04:01 -0800
Message-Id: <20221123230406.3562753-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to various Intel drivers.

Shang XiaoJing fixes init module error path stop to resource leaks for
ixgbevf and i40e.

Yuan Can also does the same for fm10k and iavf.

Wang Hai stops freeing of skb as it was causing use after free error for
e100.

The following are changes since commit 748064b54c99418f615aabff5755996cd9816969:
  net/cdc_ncm: Fix multicast RX support for CDC NCM devices with ZLP
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 10GbE

Shang XiaoJing (2):
  ixgbevf: Fix resource leak in ixgbevf_init_module()
  i40e: Fix error handling in i40e_init_module()

Wang Hai (1):
  e100: Fix possible use after free in e100_xmit_prepare

Yuan Can (2):
  fm10k: Fix error handling in fm10k_init_module()
  iavf: Fix error handling in iavf_init_module()

 drivers/net/ethernet/intel/e100.c                 |  5 +----
 drivers/net/ethernet/intel/fm10k/fm10k_main.c     | 10 +++++++++-
 drivers/net/ethernet/intel/i40e/i40e_main.c       | 11 ++++++++++-
 drivers/net/ethernet/intel/iavf/iavf_main.c       |  9 ++++++++-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 10 +++++++++-
 5 files changed, 37 insertions(+), 8 deletions(-)

-- 
2.35.1

