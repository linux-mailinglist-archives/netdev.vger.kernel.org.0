Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0CFE5AB865
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 20:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiIBSjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 14:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiIBSjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 14:39:01 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F77988DD0
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 11:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662143941; x=1693679941;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=15Se6pwoC10dBld5rcNssCrEowBrB2mBZ5SNZ0SEnxk=;
  b=DSEQba6b+Fpj5GCSZHBr00+T3SC67lpAet4cndW5yx0e0E68/VklTguN
   vx0L9cPCLQ2eIGBmX+mxHi4D6JYMfCSZK8elip26aWWxGYiwlgrix2RXy
   pUGfci+XVFprzvJZYHTRcZH2cvBQ3N7ecqT+WcwXv6ZzF2cZ7T1CJX0J0
   vkelJQSvQSgwEmQ5T8t3R2MP+4kX5/BWe7ysqLtkBi7Xf7R+WlsSrVxkO
   i6xh2r9bNZQ9qrJ1k6BN2XYsmYh9gLfMkyVble8dcViDzTSHARp9W4vGy
   aL1IBy7YluRaUreHjmSEQVwyT9moXKsvpxNZmEZNhShZv+zaDK3EAPkeK
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10458"; a="357768798"
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="357768798"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 11:39:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="590170949"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 02 Sep 2022 11:39:00 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates 2022-09-02 (i40e, iavf)
Date:   Fri,  2 Sep 2022 11:38:54 -0700
Message-Id: <20220902183857.1252065-1-anthony.l.nguyen@intel.com>
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

This series contains updates to i40e and iavf drivers.

Przemyslaw adds reset to ADQ configuration to allow for setting of rate
limit beyond TC0 for i40e.

Ivan Vecera does not free client on failure to open which could cause
NULL pointer dereference to occur on i40e. He also detaches device
during reset to prevent NDO calls with could cause races for iavf.

The following are changes since commit e7506d344bf180096a86ec393515861fb5245915:
  Merge tag 'rxrpc-fixes-20220901' of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Ivan Vecera (2):
  i40e: Fix kernel crash during module removal
  iavf: Detach device during reset task

Przemyslaw Patynowski (1):
  i40e: Fix ADQ rate limiting for PF

 drivers/net/ethernet/intel/i40e/i40e_client.c |  5 ++++-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  3 +++
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  3 ++-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 14 +++++++++++---
 4 files changed, 20 insertions(+), 5 deletions(-)

-- 
2.35.1

