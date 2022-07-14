Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3D8575465
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 20:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239924AbiGNSGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 14:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiGNSGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 14:06:13 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D55474DB
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 11:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657821972; x=1689357972;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LgYRyVklTpAA7YdBGwVaz0TUOkKb5TU7kA3CyiKk4BA=;
  b=PnihhZdXvrudbRF/LPW55/PZBL5AQuH0r9H8iJZEW0V4c3qwkOY46L7E
   MtCCCG1xtLQO5ZxlS0+fqolf43VImGUx7tpd/fTeFmrqjw65gE5gQuhFk
   xTAPsGlobp1+Lzm3JzWCnnjttvOJ7fraif63HoZn6CiStoPx9RS8GFtg6
   9zVPmSZEtz9sgeNvTqM9FvxeZLdZNQXA04VIkAVwvk72bx5HfUAU8fbJ3
   M39qVdbfrp6EVjMfIO5hp9jUVnyPg+IEicYeVUpuYKqPiLbfCTnqHxW2R
   RRv3gmopVwUIArHVg7vCcqBPtmQFC60xFXMEXHqtFcMO0LzTmEhKshvZK
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="286336082"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="286336082"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 11:06:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="685666819"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Jul 2022 11:06:11 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/3][pull request] 100GbE Intel Wired LAN Driver Updates 2022-07-14
Date:   Thu, 14 Jul 2022 11:03:08 -0700
Message-Id: <20220714180311.933648-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice.

Paul adds the option to use FEC disabled when auto FEC is set on
modules that do not advertise it.

Ani updates feature restriction for devices that don't support external
time stamping.

Zhuo Chen removes unnecessary call to pci_aer_clear_nonfatal_status().

The following are changes since commit b126047f43f11f61f1dd64802979765d71795dae:
  Merge branch 'xen-netfront-xsa-403-follow-on'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Anirudh Venkataramanan (1):
  ice: Add EXTTS feature to the feature bitmap

Paul Greenwalt (1):
  ice: add support for Auto FEC with FEC disabled

Zhuo Chen (1):
  ice: Remove pci_aer_clear_nonfatal_status() call

 drivers/net/ethernet/intel/ice/ice.h          |  2 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  1 +
 drivers/net/ethernet/intel/ice/ice_common.c   | 80 ++++++++++++-------
 drivers/net/ethernet/intel/ice/ice_common.h   |  1 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 40 +++++++++-
 drivers/net/ethernet/intel/ice/ice_lib.c      |  1 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 14 ++--
 drivers/net/ethernet/intel/ice/ice_ptp.c      | 18 +++--
 drivers/net/ethernet/intel/ice/ice_type.h     |  8 +-
 9 files changed, 120 insertions(+), 45 deletions(-)

-- 
2.35.1

