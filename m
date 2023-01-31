Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 294356838C1
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 22:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbjAaVhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 16:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbjAaVhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 16:37:14 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 342914B898
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 13:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675201033; x=1706737033;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FJaoM499l/Qx0iN7HhY9mET9Rcf2DC6zK6QCXAeHL94=;
  b=IdM5QoFRtEsN+Iyil93O9QBVgwLu1mO9AnyZO0MQuqCZK4s9K6V2n318
   mVGsk2Oeho5WMZkaDnNkprj1v4a8kfB1QdPz9Cz6D2nwV6hQ7JcSH8rG4
   3LM+az9UgIKzSclS4JHO6kujqKD7DpylPnI6BKAtXtDv5kT04kbOamph5
   kTV0VmY5YVbNWbvIQ/knOfptOpxImtjlWGhAN0VikuRcrx+IbAoFl+wuG
   5RCbCt5xPuObM80tQKVCbf+OQhVj7umN8jnq5zFph+xa78S/Q3+n7KZAI
   RNB020YeuaO1utFww4Jb4/HOKPRH+Hj1QPrZpa9d0iOX4OuEGy6r+RMqA
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="327980264"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="327980264"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 13:37:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="910063002"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="910063002"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga006.fm.intel.com with ESMTP; 31 Jan 2023 13:37:12 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/6][pull request] Intel Wired LAN Driver Updates 2023-01-31 (ice)
Date:   Tue, 31 Jan 2023 13:36:57 -0800
Message-Id: <20230131213703.1347761-1-anthony.l.nguyen@intel.com>
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

This series contains updates to ice driver only.

Dave moves unplug of auxiliary device to service task to avoid deadlock
situations with RTNL lock.

Ani removes WQ_MEM_RECLAIM flag from workqueue to resolve
check_flush_dependency warning.

Michal fixes KASAN out-of-bounds warning.

Brett corrects behaviour for port VLAN Rx filters to prevent receiving
of unintended traffic.

Dan Carpenter fixes possible off by one issue.

Zhang Changzhong adjusts error path for switch recipe to prevent memory
leak.

The following are changes since commit de5ca4c3852f896cacac2bf259597aab5e17d9e3:
  net: sched: sch: Bounds check priority
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Anirudh Venkataramanan (1):
  ice: Do not use WQ_MEM_RECLAIM flag for workqueue

Brett Creeley (1):
  ice: Fix disabling Rx VLAN filtering with port VLAN enabled

Dan Carpenter (1):
  ice: Fix off by one in ice_tc_forward_to_queue()

Dave Ertman (1):
  ice: avoid bonding causing auxiliary plug/unplug under RTNL lock

Michal Swiatkowski (1):
  ice: fix out-of-bounds KASAN warning in virtchnl

Zhang Changzhong (1):
  ice: switch: fix potential memleak in ice_add_adv_recipe()

 drivers/net/ethernet/intel/ice/ice.h          | 14 +++++--------
 drivers/net/ethernet/intel/ice/ice_common.c   |  9 ++++----
 drivers/net/ethernet/intel/ice/ice_main.c     | 19 +++++++----------
 drivers/net/ethernet/intel/ice/ice_switch.c   |  2 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   |  2 +-
 drivers/net/ethernet/intel/ice/ice_vf_mbx.c   | 21 +++++++------------
 .../ethernet/intel/ice/ice_vf_vsi_vlan_ops.c  | 16 +++++++++++++-
 7 files changed, 42 insertions(+), 41 deletions(-)

-- 
2.38.1

