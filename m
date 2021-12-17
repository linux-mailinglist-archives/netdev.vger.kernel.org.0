Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4B74796D5
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 23:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbhLQWHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 17:07:43 -0500
Received: from mga03.intel.com ([134.134.136.65]:43080 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229449AbhLQWHm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 17:07:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639778862; x=1671314862;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RyOM9GNJJBKQDLp+NodlC9N/NWUhrphQK2SlOuwWf+0=;
  b=RjDjExwNbiLMnjbpeQulfSR0er65/JqS+fg3o7RJVaTFACIJougLcvZt
   exstUxRG5QR+IrNLFbqBJcABDNyrfQjpkuaBUrd6dpVwgviox6VrUQkIV
   6YpsTFCPumK+UO4AQ4EA/YyDVDsWwjwuuQdeE2qJ9GoCL9yikW5Q4wxq5
   6nuUr5VWBhavUpyS7F2s1olFiLXSlIMRa/xQcZVLrsYB9duTUoohHm7Oz
   UcePW++7/pQ3MmTo2dJr3WGbpCscTARmLQvFy1Kd93L1WEvdMeaJ6VpqK
   Zhem7kol3Rkq4RoE6oWRSEb/MhclzR6P3nMN+869dkNjiviV8gb4jdn6z
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10201"; a="239794448"
X-IronPort-AV: E=Sophos;i="5.88,214,1635231600"; 
   d="scan'208";a="239794448"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 14:07:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,214,1635231600"; 
   d="scan'208";a="519922243"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 17 Dec 2021 14:07:42 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net-next 0/6][pull request] 40GbE Intel Wired LAN Driver Updates 2021-12-17
Date:   Fri, 17 Dec 2021 14:06:41 -0800
Message-Id: <20211217220647.875246-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Brett Creeley says:

This patch series adds support in the iavf driver for communicating and
using VIRTCHNL_VF_OFFLOAD_VLAN_V2. The current VIRTCHNL_VF_OFFLOAD_VLAN
is very limited and covers all 802.1Q VLAN offloads and filtering with
no granularity.

The new VIRTCHNL_VF_OFFLOAD_VLAN_V2 adds more granularity, flexibility,
and support for 802.1ad offloads and filtering. This includes the VF
negotiating which VLAN offloads/filtering it's allowed, where VLAN tags
should be inserted and/or stripped into and from descriptors, and the
supported VLAN protocols.

The following are changes since commit f75c1d55ecbadce027fd650d3ca79e357afae0d9:
  Merge tag 'wireless-drivers-next-2021-12-17' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Brett Creeley (6):
  virtchnl: Add support for new VLAN capabilities
  iavf: Add support for VIRTCHNL_VF_OFFLOAD_VLAN_V2 negotiation
  iavf: Add support VIRTCHNL_VF_OFFLOAD_VLAN_V2 during netdev config
  iavf: Add support for VIRTCHNL_VF_OFFLOAD_VLAN_V2 hotpath
  iavf: Add support for VIRTCHNL_VF_OFFLOAD_VLAN_V2 offload
    enable/disable
  iavf: Restrict maximum VLAN filters for VIRTCHNL_VF_OFFLOAD_VLAN_V2

 drivers/net/ethernet/intel/iavf/iavf.h        | 105 ++-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 767 +++++++++++++++---
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   |  71 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.h   |  30 +-
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 534 ++++++++++--
 include/linux/avf/virtchnl.h                  | 377 +++++++++
 6 files changed, 1637 insertions(+), 247 deletions(-)

-- 
2.31.1

