Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E0239BC9A
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 18:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhFDQMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 12:12:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:21972 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229667AbhFDQMP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 12:12:15 -0400
IronPort-SDR: yNGMgfIkWubhhGNiwoRADocpzHePMNxfkAThhlBiKBLdhb41yOqsNqTQci9sNMPYRkzFZBkPbB
 gRn9Nmh3vULQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10005"; a="201299728"
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="201299728"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 09:06:02 -0700
IronPort-SDR: pz9q0zuhpSjxrggBFMp8XUvlDKuZ4PdxaOGuskaftXnR2WdDfWud6qXO+DrQX2dXyhGEa7If6r
 5gvQe3aqaEFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="475511682"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Jun 2021 09:05:49 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net 0/6][pull request] Intel Wired LAN Driver Updates 2021-06-04
Date:   Fri,  4 Jun 2021 09:08:10 -0700
Message-Id: <20210604160816.3391716-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to virtchnl header file and ice driver.

Brett fixes VF being unable to request a different number of queues then
allocated and adds clearing of VF_MBX_ATQLEN register for VF reset.

Haiyue handles error of rebuilding VF VSI during reset.

Paul fixes reporting of autoneg to use the PHY capabilities.

Dave allows LLDP packets without priority of TC_PRIO_CONTROL to be
transmitted.

Geert Uytterhoeven adds explicit padding to virtchnl_proto_hdrs
structure in the virtchnl header file.

The following are changes since commit 1a8024239dacf53fcf39c0f07fbf2712af22864f:
  virtio-net: fix for skb_over_panic inside big mode
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Brett Creeley (2):
  ice: Fix allowing VF to request more/less queues via virtchnl
  ice: Fix VFR issues for AVF drivers that expect ATQLEN cleared

Dave Ertman (1):
  ice: Allow all LLDP packets from PF to Tx

Geert Uytterhoeven (1):
  virtchnl: Add missing padding to virtchnl_proto_hdrs

Haiyue Wang (1):
  ice: handle the VF VSI rebuild failure

Paul Greenwalt (1):
  ice: report supported and advertised autoneg using PHY capabilities

 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 51 +++----------------
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |  1 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |  2 +
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  5 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 19 ++++---
 include/linux/avf/virtchnl.h                  |  1 +
 6 files changed, 27 insertions(+), 52 deletions(-)

-- 
2.26.2

