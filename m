Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 693144C93B1
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 19:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237125AbiCATAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 14:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234562AbiCATAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 14:00:08 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B8110D1
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 10:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646161167; x=1677697167;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GmZ3g+qQXsZzJ9RHZb5bBkpf5M67IFHJA/AdqgqJeZc=;
  b=QEGjoFn3hmPopScyKyTqLzXelpZCTnVQFR5Dwjeq+wyfUT+XCjc56OAm
   2qsKT09GP0x8Z/Yce/1OALr62JdH9DtXSyPhtVxZmlQLTHGTYQR0HkfTL
   kfIxjz/shmIHUb9KAP5d9PocCeylTrtNbuNvMALuFpV3GSeR8dlrbDFJK
   l5Erm5T+GcZab//912WdM21IFBxXw/Ng821yATpgOn4BCYnK4czx6W7Vy
   LJrhearqa8B3EDxs4a91fi4CNPrsb1ElTbewwbmtNePy4MYuPOPe461X6
   FCsrrWUxatwpKqpleE8wAG0dmDZ4qN8QV90nUWlpMt63lPBOASXKH9QZt
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10273"; a="252042314"
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="252042314"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 10:59:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="507908253"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 01 Mar 2022 10:59:26 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net-next 0/7][pull request] 40GbE Intel Wired LAN Driver Updates 2022-03-01
Date:   Tue,  1 Mar 2022 10:59:32 -0800
Message-Id: <20220301185939.3005116-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to iavf driver only.

Mateusz adds support for interrupt moderation for 50G and 100G speeds
as well as support for the driver to specify a request as its primary
MAC address. He also refactors VLAN V2 capability exchange into more
generic extended capabilities to ease the addition of future
capabilities. Finally, he corrects the incorrect return of iavf_status
values and removes non-inclusive language.

Minghao Chi removes unneeded variables, instead returning values
directly.

The following are changes since commit 7282c126f7688f697d33f3b965c29bba67fb4eba:
  Merge branch 'smc-datapath-opts'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Mateusz Palczewski (6):
  iavf: Add support for 50G/100G in AIM algorithm
  iavf: refactor processing of VLAN V2 capability message
  iavf: Add usage of new virtchnl format to set default MAC
  iavf: stop leaking iavf_status as "errno" values
  iavf: Fix incorrect use of assigning iavf_status to int
  iavf: Remove non-inclusive language

Minghao Chi (1):
  iavf: remove redundant ret variable

 drivers/net/ethernet/intel/iavf/iavf.h        |  22 +-
 drivers/net/ethernet/intel/iavf/iavf_common.c |   4 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 302 ++++++++++++++----
 drivers/net/ethernet/intel/iavf/iavf_status.h |   2 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   |  62 +++-
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 194 ++++++-----
 6 files changed, 397 insertions(+), 189 deletions(-)

-- 
2.31.1

