Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66F475914BB
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 19:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237852AbiHLRXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 13:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbiHLRXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 13:23:17 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117ACB248F
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 10:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660324997; x=1691860997;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=I8gH66coesTC9O27swyC+HP59ds6Wrvh3s0m3CR7w/U=;
  b=Edx1lVDiiCaUjTdQs4y+neDnsEbFJW44V4pO0u9MbFgl6JfiMsxaRzlW
   HT/t1F5p3bOu1yHmcZ3OXVLTvt/0+fahD0zCVHZFD3aXm4y1wDm7skNc3
   6Xdol9LxwtQxB91XKsn30Wmj4Je3wChZL4oO6bwuoOxGwTJtGccRQVr4F
   K0sqK5X+O9MWl6ANUlr9L45g+75xSV8CKVr7Fs77GN1GeyK7hol1yaGPv
   EonTIAgQ7kO6KoWXoq46yN6WFJ4OrlHK0nGokEP3V0NAwuLgaX1kXVpDL
   AxxOgF3aDQJzDJTE277SnJWf48XHC+akgyDAr+9AVpj1L4j2/tKpV7AjD
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10437"; a="290396029"
X-IronPort-AV: E=Sophos;i="5.93,233,1654585200"; 
   d="scan'208";a="290396029"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 10:23:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,233,1654585200"; 
   d="scan'208";a="634716848"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 12 Aug 2022 10:23:16 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates 2022-08-12 (iavf)
Date:   Fri, 12 Aug 2022 10:23:05 -0700
Message-Id: <20220812172309.853230-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to iavf driver only.

Przemyslaw frees memory for admin queues in initialization error paths,
prevents freeing of vf_res which is causing null pointer dereference,
and adjusts calls in error path of reset to avoid iavf_close() which
could cause deadlock.

Ivan Vecera avoids deadlock that can occur when driver if part of
failover.

The following are changes since commit 40b4ac880e21d917da7f3752332fa57564a4c202:
  net: lan966x: fix checking for return value of platform_get_irq_byname()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Ivan Vecera (1):
  iavf: Fix deadlock in initialization

Przemyslaw Patynowski (3):
  iavf: Fix adminq error handling
  iavf: Fix NULL pointer dereference in iavf_get_link_ksettings
  iavf: Fix reset error handling

 drivers/net/ethernet/intel/iavf/iavf_adminq.c | 15 +++++++++++--
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 22 ++++++++++++++-----
 2 files changed, 30 insertions(+), 7 deletions(-)

-- 
2.35.1

