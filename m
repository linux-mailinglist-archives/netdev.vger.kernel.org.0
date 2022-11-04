Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75CE61A2BA
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 21:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiKDUy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 16:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiKDUy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 16:54:26 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99AEDEE1
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 13:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667595265; x=1699131265;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EIjBfOB50m/d6kIAX6XNXUcQfWQjRoJZVhiY+JCZ8vc=;
  b=K3zO3kmZKxmZU1imB3e9vZM6c1EUlekedMGGoRlUyjhn3x9qzDLFZUFJ
   LDG+dbcY2L8uJLQMo9lr4ZIjPvXeunhXBIZA+FJ4xBMlfBG+uSjqLo+0j
   JbyEgoCJwRq+ouI+VeAmF2rkKs23oz1ptxj32WZ0gEWp91+MdfwREZXNT
   ESKfNwCkLONhVqcn9awSVdDMotTXdEyELC8RGna9KuDBpwGPIF0bdLE9f
   HfRpe/07bmWiy/G3mqCf6RQUqU8NK9GOR5l79jshoz3yEGwx1g/uczzG2
   6x07b8He7O6CNwytDJj/cQPoEcuP8RpFtD318q9GeaIk1Mt5/8Xpt1FL1
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="372177360"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="372177360"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 13:54:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="637716201"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="637716201"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 04 Nov 2022 13:54:24 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/6][pull request] Intel Wired LAN Driver Updates 2022-11-04 (ixgbe, ixgbevf, igb)
Date:   Fri,  4 Nov 2022 13:54:08 -0700
Message-Id: <20221104205414.2354973-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ixgbe, ixgbevf, and igb drivers.

Daniel Willenson adjusts descriptor buffer limits to be based on what
hardware supports instead of using a generic, least common value for
ixgbe.

Ani removes local variable for ixgbe, instead returning conditional result
directly.

Yang Li removes unneeded semicolon for ixgbe.

Jan adds error messaging when VLAN errors are encountered for ixgbevf.

Kees Cook prevents a potential use after free condition and explicitly
rounds up q_vector allocations so that allocations can be correctly
compared to ksize() for igb.

The following are changes since commit 95ec6bce2a0bb7ec9c76fe5c2a9db3b9e62c950d:
  Merge branch 'net-ipa-more-endpoints'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 10GbE

Anirudh Venkataramanan (1):
  ixgbe: Remove local variable

Daniel Willenson (1):
  ixgbe: change MAX_RXD/MAX_TXD based on adapter type

Jan Sokolowski (1):
  ixgbevf: Add error messages on vlan error

Kees Cook (2):
  igb: Do not free q_vector unless new one was allocated
  igb: Proactively round up to kmalloc bucket size

Yang Li (1):
  ixgbe: Remove unneeded semicolon

 drivers/net/ethernet/intel/igb/igb_main.c     | 10 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      | 10 +++-
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  | 53 +++++++++++++++----
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c  |  2 +-
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c | 17 ++++--
 5 files changed, 70 insertions(+), 22 deletions(-)

-- 
2.35.1

