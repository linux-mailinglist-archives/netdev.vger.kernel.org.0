Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60EFA622078
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 00:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiKHXwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 18:52:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKHXv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 18:51:59 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C0E5E3E9
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 15:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667951519; x=1699487519;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/TVyr/+UUAexTLvLg2YfATYMEpyVW0KV1BcfSLWK5m0=;
  b=PV98RocfKWK+ICzQ5oWa98JeArRCXJf5fRuyh/lZjny2VCyrKX3DJVha
   T+qcnDk7+JqEpGUfdQTChBVitWB89hN0WJKky24+9U9Ym9hbYmpESMsCn
   bLCDYNdXhf426Xls9qpjY4SBJjNT2Non8LRhD0ShQWOZV0sVo3jkQsbRi
   xoHv87YmZv4FfVi8CVRASL7otavgYxzPge8WwvbVSlNqXSp7F6wr70lmt
   dbz51K+eaL90UGGfSrZaiXcCKvXrTxkXDqguixZGcq1YsalTNmVPCIT99
   j5CFl9LhwC6RGM6wW1T9NGAI/GtVBVRT+mDOv5/SSlm1CjM3Dl4a+oNHJ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="290556984"
X-IronPort-AV: E=Sophos;i="5.96,149,1665471600"; 
   d="scan'208";a="290556984"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 15:51:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="667777831"
X-IronPort-AV: E=Sophos;i="5.96,149,1665471600"; 
   d="scan'208";a="667777831"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 08 Nov 2022 15:51:58 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates 2022-11-08 (ice, iavf)
Date:   Tue,  8 Nov 2022 15:51:13 -0800
Message-Id: <20221108235116.3522941-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice and iavf drivers.

Norbert stops disabling VF queues that are not enabled for ice driver.

Jake fixes type for looping variables to resolve signedness issue for
ice.

Michal stops accounting of VLAN 0 filter to match expectations of PF
driver for iavf.

The following are changes since commit ce9e57feeed81d17d5e80ed86f516ff0d39c3867:
  drivers: net: xgene: disable napi when register irq failed in xgene_enet_open()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Jacob Keller (1):
  ice: use int for n_per_out loop

Michal Jaron (1):
  iavf: Fix VF driver counting VLAN 0 filters

Norbert Zulinski (1):
  ice: Fix spurious interrupt during removal of trusted VF

 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  2 ++
 drivers/net/ethernet/intel/ice/ice_base.c     |  2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      | 25 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_lib.h      |  1 +
 drivers/net/ethernet/intel/ice/ice_ptp.c      |  4 +--
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   |  5 +++-
 6 files changed, 35 insertions(+), 4 deletions(-)

-- 
2.35.1

