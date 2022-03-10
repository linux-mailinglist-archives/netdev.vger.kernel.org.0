Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0228D4D5524
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 00:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241872AbiCJXNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 18:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234999AbiCJXNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 18:13:21 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E41119ABC9
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 15:12:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646953939; x=1678489939;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QYzmHNFiUuw5MIZGD/WEvGRC61gaj3Y74aadx0q7sVY=;
  b=SIoPRRjDCNsiiAF4w9rXoWiwjRZ0Ij3bArBHISdSE7hRunY2n0S+vRiV
   zZ9Q92UT9xC39DH1wVviW4QOCDdFWdQoWQfG85cBFQS2zzAchGGLlWSlK
   gonzpP/+l9WuzeTGS8FhxBnzKAUl/BZwq1YGrAO7E1ZG1/0RjRtGHl5rR
   6633ejY/Om/SAd7rpPKMn/Sv3gssBAoHFB92OfgLoirejKjm1Twi0FIZB
   BaCnqCiQLyTuFASzbsYNqI57ferh4tp9HvDTvCmT/cAGnP27OQ8F8BtzM
   tIgZOcqILO+QaHMwTV1+L4xTr8LloNNf8cjUH+p+fIba6TNxdgr+q916T
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10282"; a="255141738"
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="255141738"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 15:12:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="644652731"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 10 Mar 2022 15:12:18 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sudheer.mogilappagari@intel.com, sridhar.samudrala@intel.com,
        amritha.nambiar@intel.com, jiri@nvidia.com, leonro@nvidia.com
Subject: [PATCH net-next 0/2][pull request] 10GbE Intel Wired LAN Driver Updates 2022-03-10
Date:   Thu, 10 Mar 2022 15:12:33 -0800
Message-Id: <20220310231235.2721368-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sudheer Mogilappagari says:

Add support to enable inline flow director which allows uniform
distribution of flows among queues of a TC. This is configured
on a per TC basis using devlink interface.

Devlink params are registered/unregistered during TC creation
at runtime. To allow that commit 7a690ad499e7 ("devlink: Clean
not-executed param notifications") needs to be reverted.

The following are changes since commit 3126b731ceb168b3a780427873c417f2abdd5527:
  net: dsa: tag_rtl8_4: fix typo in modalias name
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 10GbE

Kiran Patil (1):
  ice: Add inline flow director support for channels

Sridhar Samudrala (1):
  devlink: Allow parameter registration/unregistration during runtime

 drivers/net/ethernet/intel/ice/ice.h          |  83 +++++
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  12 +
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 130 ++++++++
 drivers/net/ethernet/intel/ice/ice_devlink.h  |   2 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   1 +
 drivers/net/ethernet/intel/ice/ice_fdir.c     |  25 +-
 drivers/net/ethernet/intel/ice/ice_fdir.h     |   5 +
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   1 +
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |   3 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 173 ++++++++++-
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 294 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_txrx.h     |   8 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |   1 +
 net/core/devlink.c                            |  14 +-
 14 files changed, 734 insertions(+), 18 deletions(-)

-- 
2.31.1

