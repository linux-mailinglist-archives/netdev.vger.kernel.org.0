Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237EE67BE8A
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 22:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236608AbjAYV3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 16:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236724AbjAYV3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 16:29:41 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D55E385
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 13:29:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674682150; x=1706218150;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QDpYpPBQS+brH/1saUbH4P9XfHAP9/rF6T4z8JwO5QI=;
  b=hWAozJBe2+dEx8hOEU5SUzd1qRGBRqmQUTzumc1RLYUek0Wn3DiGNtP/
   meQg4SDuBIAK7Db5iqrKHpt2QNQissDH4BesEaHtfEABf7SzT5ZTxjRG+
   LRz/IHaeLihsFtOkfZor7i7Siq/irKFFW39z/MUnEF9ISbHVntZAqgCLm
   EacqYwZ9e8yW/5WS6MaAZUDg+3NfceeRxb07RnYoHZs5hiNsQXuQxhZk1
   ckTZ71nvnIDPBE9ZwQWmuItFwixQan5ZJQL7RjrLgADvPD1kHalmb0/Wo
   qm7Y9GXd7V2nkgLvVJmTzfDVcuiiygF9OC3KDtluqFEtNqa0V9+Y9HVH/
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10601"; a="310261527"
X-IronPort-AV: E=Sophos;i="5.97,246,1669104000"; 
   d="scan'208";a="310261527"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 13:26:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10601"; a="731189725"
X-IronPort-AV: E=Sophos;i="5.97,246,1669104000"; 
   d="scan'208";a="731189725"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga004.fm.intel.com with ESMTP; 25 Jan 2023 13:26:56 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sasha.neftin@intel.com
Subject: [PATCH net-next 0/3][pull request] Intel Wired LAN Driver Updates 2023-01-25 (igc)
Date:   Wed, 25 Jan 2023 13:26:59 -0800
Message-Id: <20230125212702.4030240-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
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

This series contains updates to igc driver only.

Muhammad adds tracking and reporting of QBV config errors.

Tan adds support for configuring max SDU for each Tx queue.

Sasha removes check for alternate media as only one media type is
supported.

The following are changes since commit f5be9caf7bf022ab550f62ea68f1c1bb8f5287ee:
  net: ethtool: fix NULL pointer dereference in pause_prepare_data()
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
 drivers/net/ethernet/intel/igc/igc_main.c    | 62 ++++++++++++++------
 drivers/net/ethernet/intel/igc/igc_tsn.c     |  6 ++
 4 files changed, 54 insertions(+), 19 deletions(-)

-- 
2.38.1

