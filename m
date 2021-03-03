Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A9532C463
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352980AbhCDANe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:13:34 -0500
Received: from mga01.intel.com ([192.55.52.88]:22650 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357558AbhCCPvA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 10:51:00 -0500
IronPort-SDR: U8hITZOeNMXxqfpY1nH4mSuQmIzcM9ajQnugQuvOooJ2mctHjspnC/6MY7irJpEPWIUj8UiKzX
 AoIkpVSQYItw==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="206909531"
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="206909531"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 07:49:34 -0800
IronPort-SDR: in3nRTn2+YeQaNshj2mAZcI8R7ZDaCgUCQvsV2v80B1t1MbHPzMGEbAh7syHPJYBUg71osMi9h
 VIRm4ehQTbww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="518322004"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga004.jf.intel.com with ESMTP; 03 Mar 2021 07:49:31 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, brouer@redhat.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH intel-net 0/3] intel: Rx headroom fixes
Date:   Wed,  3 Mar 2021 16:39:25 +0100
Message-Id: <20210303153928.11764-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix Rx headroom by calling *_rx_offset() after the build_skb Rx ring
flag is set.

It was reported by Jesper in [0] that XDP_REDIRECT stopped working after
[1] patch in i40e.

Thanks and sorry!
Maciej

[0]: https://lore.kernel.org/netdev/20210301131832.0d765179@carbon/
[1]: https://lore.kernel.org/bpf/20210118151318.12324-10-maciej.fijalkowski@intel.com/

Maciej Fijalkowski (3):
  i40e: move headroom initialization to i40e_configure_rx_ring
  ice: move headroom initialization to ice_setup_rx_ctx
  ixgbe: move headroom initialization to ixgbe_configure_rx_ring

 drivers/net/ethernet/intel/i40e/i40e_main.c   | 13 +++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 12 ------------
 drivers/net/ethernet/intel/ice/ice_base.c     | 18 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 17 -----------------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  3 ++-
 5 files changed, 33 insertions(+), 30 deletions(-)

-- 
2.20.1

