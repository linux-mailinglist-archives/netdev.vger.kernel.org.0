Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5A95EE6A4
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 22:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbiI1Uch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 16:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiI1Ucf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 16:32:35 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5380BCBAD6
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 13:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664397154; x=1695933154;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4UaV/AzYqFATSV1t+q0GyudgRqXLJ5RqhfitE+KbDbw=;
  b=Ee9I/r87y5m2F02JYMGfzkqfb/gseQ+vxLifPPKC7aOVPmLuMR4WGIww
   9JtqMYjIGlijUyE7PSp05HXHZEdFXr8DMoB8DuJb4bbkXHhlv8lOP+K1q
   kL0BNqSnZCYnnKz327tTech+b2fHZl+AfE8sIM9zwpcuHqlwKSNOJG8zi
   L4cozs4U0NzZfCvzH7IeFi7UD2TsWNNOuoB1rC4arISeMiYBXaFnjM5w/
   vYfv0gZG4WQ1rCNP+7KpZGmnVv6ofxvGUaqXHD142L7ehQLaQ/FZeQ6mQ
   RP8mXbxwh8J/xoRB/CHBPEn5LSuRjAVTwpuqhjs6ZpsRKnx1BUG8jEbUD
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="299308075"
X-IronPort-AV: E=Sophos;i="5.93,352,1654585200"; 
   d="scan'208";a="299308075"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 13:32:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="726099945"
X-IronPort-AV: E=Sophos;i="5.93,352,1654585200"; 
   d="scan'208";a="726099945"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 28 Sep 2022 13:32:24 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/3][pull request] Intel Wired LAN Driver Updates 2022-09-28 (ice)
Date:   Wed, 28 Sep 2022 13:32:14 -0700
Message-Id: <20220928203217.411078-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Arkadiusz implements a single pin initialization function, checking feature
bits, instead of having separate device functions and updates sub-device
IDs for recognizing E810T devices.

Martyna adds support for switchdev filters on VLAN priority field.

The following are changes since commit 929a6cdfaeac9de6a1004eb18999e1439527cfb4:
  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Arkadiusz Kubalewski (2):
  ice: Merge pin initialization of E810 and E810T adapters
  ice: support features on new E810T variants

Martyna Szapar-Mudlaw (1):
  ice: Add support for VLAN priority filters in switchdev

 drivers/net/ethernet/intel/ice/ice_common.c | 18 ++++-
 drivers/net/ethernet/intel/ice/ice_devids.h |  5 ++
 drivers/net/ethernet/intel/ice/ice_ptp.c    | 47 +++----------
 drivers/net/ethernet/intel/ice/ice_ptp.h    |  4 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c | 73 ++++++++++++++++-----
 drivers/net/ethernet/intel/ice/ice_tc_lib.h |  4 +-
 6 files changed, 93 insertions(+), 58 deletions(-)

-- 
2.35.1

