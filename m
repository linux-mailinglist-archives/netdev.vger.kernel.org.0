Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6342A59FFFE
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 19:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239749AbiHXRDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 13:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232679AbiHXRDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 13:03:50 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D5770E44
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 10:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661360629; x=1692896629;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fQaZCqvFcrBNHEnA1h9nPSN+rkKS3o47Om4ySBGZDsw=;
  b=MSm9hFlMOqcyrf4RmOAHENwaiiDEsMNZOS6IiK59bqYqVQqLnVwweDIT
   wW5dMo4+hC/OlyiBG0DYwqbxmeUeUDoH9qudvphpjfARThXD5PLsHbLZy
   mG29yMX9X0Lgdj4WzfD9I1ZrGH40u6w0Uvn9n6rLJGfNCzhCaaOi/wvPw
   TkesUP7yFlIM0oS9ljgZDBWUY0Iji4yVbVJuIfN5SYqxAzCB+XFEk6z/o
   ibxnqo9pyF9/pzucx1N5f/j/ey8Sf+jvJmjLmjvcdI7Dh1ZgWGDSLzfS0
   ouCDV1idv/dwRca1GiqQiNd2QOsCU/lU1kExkb2OJoCVvESTZgpb+ZZX/
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="280995442"
X-IronPort-AV: E=Sophos;i="5.93,260,1654585200"; 
   d="scan'208";a="280995442"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 10:03:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,260,1654585200"; 
   d="scan'208";a="937989082"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 24 Aug 2022 10:03:46 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/5][pull request] Intel Wired LAN Driver Updates 2022-08-24 (ice)
Date:   Wed, 24 Aug 2022 10:03:35 -0700
Message-Id: <20220824170340.207131-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Marcin adds support for TC parsing on TTL and ToS fields.

Anatolli adds support for devlink port split command to allow
configuration of various port configurations.

Jake allows for passing and writing an additional NVM write activate
field by expanding current cmd_flag.

Ani makes PHY debug output more readable.

The following are changes since commit 8357d67f5ec0a5d9e48a2e95c66f1afb2c75879f:
  Merge branch 'r8169-next'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Anatolii Gerasymenko (2):
  ice: Add port option admin queue commands
  ice: Implement devlink port split operations

Anirudh Venkataramanan (1):
  ice: Print human-friendly PHY types

Jacob Keller (1):
  ice: Add additional flags to ice_nvm_write_activate

Marcin Szycik (1):
  ice: Add support for ip TTL & ToS offload

 Documentation/networking/devlink/ice.rst      |  36 +++
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  60 ++++
 drivers/net/ethernet/intel/ice/ice_common.c   | 273 +++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_common.h   |   9 +
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 288 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_nvm.c      |  13 +-
 drivers/net/ethernet/intel/ice/ice_nvm.h      |   2 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   | 142 ++++++++-
 drivers/net/ethernet/intel/ice/ice_tc_lib.h   |   6 +
 drivers/net/ethernet/intel/ice/ice_type.h     |   2 +
 10 files changed, 804 insertions(+), 27 deletions(-)

-- 
2.35.1

