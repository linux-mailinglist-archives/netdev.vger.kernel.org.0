Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F8B581B50
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 22:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239784AbiGZUtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 16:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232216AbiGZUtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 16:49:49 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D1A1CFF6
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 13:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658868588; x=1690404588;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=f3jSIskqWvKWNNBnh41GhDGKrsC1v7AKfSigw4wY86Y=;
  b=bUxPOLI8T+HWh/rK5AVBjJFnhZ5SZ4MwvQMpn8yVzNjBn7mPSehqTZdC
   aOPYIwT2X5RC0gqiyf2eHVZ+5/V6xlBEX9y/3fQo6UORQ5CkJk751PimM
   b3eQ6BVB2RRLTMzUNNBHM8qkFIiPLryBE0Mohuu/yfWfmWccSvzglsjjI
   eZMornGk4VUPS76aH+dM4SWu/HoQSLXXU7zId9Bgc2HCdfOBaAv+DYLfG
   Ht1Vq6dnAZwKWu2GrRQ1yutbBHoCpNhyZdh4Ul5PWlY46d6OKTuz0SPa0
   /58Ru9mCKTYN6LvrwnvGO6izkY8LTu1J08N5lxunHG5+LMj625ev/Uv77
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="268440953"
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="268440953"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 13:49:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="575654568"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 26 Jul 2022 13:49:48 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/5][pull request] Intel Wired LAN Driver Updates 2022-07-26
Date:   Tue, 26 Jul 2022 13:46:41 -0700
Message-Id: <20220726204646.2171589-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Przemyslaw corrects accounting for VF VLANs to allow for correct number
of VLANs for untrusted VF. He also correct issue with checksum offload
on VXLAN tunnels.

Ani allows for two VSIs to share the same MAC address.

Maciej corrects checked bits for descriptor completion of loopback

The following are changes since commit 9b134b1694ec8926926ba6b7b80884ea829245a0:
  bridge: Do not send empty IFLA_AF_SPEC attribute
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Anirudh Venkataramanan (1):
  ice: Fix VSIs unable to share unicast MAC

Maciej Fijalkowski (2):
  ice: check (DD | EOF) bits on Rx descriptor rather than (EOP | RS)
  ice: do not setup vlan for loopback VSI

Przemyslaw Patynowski (2):
  ice: Fix max VLANs available for VF
  ice: Fix tunnel checksum offload with fragmented traffic

 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  3 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 10 +++--
 drivers/net/ethernet/intel/ice/ice_sriov.c    | 40 -------------------
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  8 ++--
 drivers/net/ethernet/intel/ice/ice_virtchnl.c |  3 +-
 5 files changed, 16 insertions(+), 48 deletions(-)

-- 
2.35.1

