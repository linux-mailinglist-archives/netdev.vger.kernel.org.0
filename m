Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFFE562511
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 23:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237509AbiF3VXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 17:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236413AbiF3VXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 17:23:10 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1075594
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 14:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656624187; x=1688160187;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nUtxtyLXHhTh+tRuYCmPLQxC2CLIEd+79yEJh8Brjxg=;
  b=Ebb8JNV5RfGAsJW089RsXovuHTQlw1CkVcTdQecgPifMz7oAyr8ODxhN
   e3YhV2srNUxhYTAt1rZkVLqxlyBAbLgLXAklET7plaoOtjURgmbX8OHlC
   LY4UtZXHQMJgkx/wSdDIvi3a9IMz4v/vxWniUXZXT0QUNt94lOUWUL+tA
   MJ+dbwwXdLDwUzl7rR10/qKydVJF9hPZwHxyB/VD/IO80Wri1m7OfY1wJ
   RaVkiAK1n7J0VMUQcJ3ysokNMLHdbxtoYVPGi5BocwMw0MMcV8bOsrdAP
   Ld6VZsSzF3cpyso6O7cRqf0lZG/HvmH6KoGnR5aCqZOMe9NgaLV1Zlj7H
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="262274435"
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="262274435"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 14:23:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="837768306"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jun 2022 14:23:00 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/5][pull request] 100GbE Intel Wired LAN Driver Updates 2022-06-30
Date:   Thu, 30 Jun 2022 14:19:55 -0700
Message-Id: <20220630212000.3006759-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Martyna adds support for VLAN related TC switchdev filters and reworks
dummy packet implementation of VLANs to enable dynamic header insertion to
allow for more rule types.

Lu Wei utilizes eth_broadcast_addr() helper over an open coded version.

Ziyang Xuan removes unneeded NULL checks.

The following are changes since commit bf48c3fae6d78d6418f62bd3259cd62dd16f83ec:
  Merge branch 'net-neigh-introduce-interval_probe_time-for-periodic-probe'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Lu Wei (1):
  ice: use eth_broadcast_addr() to set broadcast address

Martyna Szapar-Mudlaw (3):
  ice: Add support for double VLAN in switchdev
  ice: Add support for VLAN TPID filters in switchdev
  ice: switch: dynamically add VLAN headers to dummy packets

Ziyang Xuan (1):
  ice: Remove unnecessary NULL check before dev_put

 drivers/net/ethernet/intel/ice/ice_lag.c      |   6 +-
 .../ethernet/intel/ice/ice_protocol_type.h    |   9 +-
 drivers/net/ethernet/intel/ice/ice_switch.c   | 386 ++++++++++--------
 drivers/net/ethernet/intel/ice/ice_switch.h   |   1 +
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   |  66 ++-
 drivers/net/ethernet/intel/ice/ice_tc_lib.h   |   3 +
 .../net/ethernet/intel/ice/ice_vlan_mode.c    |   1 -
 7 files changed, 283 insertions(+), 189 deletions(-)

-- 
2.35.1

