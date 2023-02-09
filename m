Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82689690F1D
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 18:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjBIR0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 12:26:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjBIR0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 12:26:03 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C9431E33
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 09:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675963562; x=1707499562;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SBSZ7E+J8GSroAv3qP07X+75LOVmy3ZKRI5h/7xAuqg=;
  b=ktnudOqxyfbLiT0gTxgYYagpZjMktBbmit1VPXb6TY9XyEkT9fNHs1eY
   lju/DQsu4xozddU2dztnoQCPljoSnb7DaMrfaEmKzqAtlqj61iA8BwWeJ
   iJ2fBfRZR1DeXTljrMfWdZq/N3sYGW8G4uDvMj3yTUZCb4ULWkaZKnrDA
   cIm22bDHSk2lVxoHfRrapjMsmHPjyDRbkIdFsVIrkut7PpY1iNtCh3RhG
   ul8/wClziPD04wzLB9sY+1nziRtFusPd8cnZ8Lny90dZiRYb64mHmVNEO
   se2YKd3AgfLRfk2YXCtn9BIdoOcjY6qXdzCELbuNfzi8xuQBLdsy5J3iP
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="328816275"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="328816275"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 09:26:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="756491258"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="756491258"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Feb 2023 09:26:02 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 0/5][pull request] Intel Wired LAN Driver Updates 2023-02-09 (i40e)
Date:   Thu,  9 Feb 2023 09:25:31 -0800
Message-Id: <20230209172536.3595838-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e driver only.

Jan removes i40e_status from the driver; replacing them with standard
kernel error codes.

Kees Cook replaces 0-length array with flexible array.
----
v2:
- Dropped, previous, patch 1

v1: https://lore.kernel.org/netdev/20230206235635.662263-1-anthony.l.nguyen@intel.com/

The following are changes since commit 5131a053f2927158fb42880c69b5dc0d2e28ddee:
  Merge tag 'linux-can-next-for-6.3-20230208' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Jan Sokolowski (4):
  i40e: Remove unused i40e status codes
  i40e: Remove string printing for i40e_status
  i40e: use int for i40e_status
  i40e: use ERR_PTR error print in i40e messages

Kees Cook (1):
  net/i40e: Replace 0-length array with flexible array

 drivers/net/ethernet/intel/i40e/i40e.h        |    8 +-
 drivers/net/ethernet/intel/i40e/i40e_adminq.c |   68 +-
 drivers/net/ethernet/intel/i40e/i40e_alloc.h  |   22 +-
 drivers/net/ethernet/intel/i40e/i40e_client.c |   12 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c | 1038 +++++++----------
 drivers/net/ethernet/intel/i40e/i40e_dcb.c    |   60 +-
 drivers/net/ethernet/intel/i40e/i40e_dcb.h    |   28 +-
 drivers/net/ethernet/intel/i40e/i40e_dcb_nl.c |   16 +-
 drivers/net/ethernet/intel/i40e/i40e_ddp.c    |   14 +-
 .../net/ethernet/intel/i40e/i40e_debugfs.c    |    8 +-
 drivers/net/ethernet/intel/i40e/i40e_diag.c   |   12 +-
 drivers/net/ethernet/intel/i40e/i40e_diag.h   |    4 +-
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |   65 +-
 drivers/net/ethernet/intel/i40e/i40e_hmc.c    |   56 +-
 drivers/net/ethernet/intel/i40e/i40e_hmc.h    |   46 +-
 .../net/ethernet/intel/i40e/i40e_lan_hmc.c    |   94 +-
 .../net/ethernet/intel/i40e/i40e_lan_hmc.h    |   34 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  405 +++----
 drivers/net/ethernet/intel/i40e/i40e_nvm.c    |  252 ++--
 drivers/net/ethernet/intel/i40e/i40e_osdep.h  |    1 -
 .../net/ethernet/intel/i40e/i40e_prototype.h  |  643 +++++-----
 drivers/net/ethernet/intel/i40e/i40e_status.h |   35 -
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    |   94 +-
 23 files changed, 1424 insertions(+), 1591 deletions(-)

-- 
2.38.1

