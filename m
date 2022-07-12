Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D69B572166
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 18:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbiGLQve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 12:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233598AbiGLQvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 12:51:31 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5A0CC00B
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 09:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657644691; x=1689180691;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cdNKzVa3FbxPrfCHtQKfjsjjgLrrPPs15Am+wnLTNbo=;
  b=SVeefuxDxoLhRfHnl0XkT5Cp45FhVmHimsoh0bUlgn9TdXpTukaXbXX2
   8mnnLe/tyCzAb967ZNz/bp3/XgxXGhSaTGVRCxzwrE74mWA7MXnLyA8JG
   tbcHhdTVDptA38AUQKJdGLQOB0Ampu37jwdvTa7/0eTwPdQWSLwOXNIa7
   dTpKRYYyPTxRmRTCwQ2qf8BxHQO5jFhic+NUWlTh/5cXlzM0pTh2VjdCV
   QSl9CNZwYdIrVsG/eVUQ3CkR3H6eC+JYu9wj0Bsw8sx4eDSYCP7EHsOvq
   3FRb6nqmw1oiF0ckijaqG51x65CRluK7EUC8GAtL1mIYtM+1DesMPa89h
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="285014499"
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="285014499"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 09:51:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="841447048"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 12 Jul 2022 09:51:30 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates 2022-07-12
Date:   Tue, 12 Jul 2022 09:48:27 -0700
Message-Id: <20220712164829.7275-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Paul fixes detection of E822 devices for firmware update and changes NVM
read for snapshot creation to be done in chunks as some systems cannot
read the entire NVM in the allotted time.

The following are changes since commit f946964a9f79f8dcb5a6329265281eebfc23aee5:
  net: marvell: prestera: fix missed deinit sequence
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Paul M Stillwell Jr (2):
  ice: handle E822 generic device ID in PLDM header
  ice: change devlink code to read NVM in blocks

 drivers/net/ethernet/intel/ice/ice_devids.h   |  1 +
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 59 ++++++++----
 .../net/ethernet/intel/ice/ice_fw_update.c    | 96 ++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_main.c     |  1 +
 4 files changed, 136 insertions(+), 21 deletions(-)

-- 
2.35.1

