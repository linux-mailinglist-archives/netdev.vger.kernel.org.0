Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B3B4869F3
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 19:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242863AbiAFSbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 13:31:06 -0500
Received: from mga03.intel.com ([134.134.136.65]:21736 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242860AbiAFSbG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 13:31:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641493866; x=1673029866;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=otHQmbZoQNc3QFe1G7ihbkQVFID97BMgV+Z4Zq+2ZRk=;
  b=Dpbdr1g+gsyZsQt4Z1OEmzfFfBFapgyOnwe4PY9h0BkeMd6iNC4hOr4Y
   MMzSd3hS69PuauyNj3v6wtKpJ4wQp9EXrPDQaY+e8PPFvCFtT9zrSbZ97
   AzISGuxjhJ8oVdO/4ASFWfLfmVnWFhPaM+GvIrpGDdmrVhlyCnkkEW67u
   30edbeDxqGtSVmbA7vF5Ves4rYQzxgTkbCOt1jmsxffx6lmD+RoXNNomJ
   Xs7o0ujoOx4BRiGpZUxdv0c1SrXRJzHVv/naeepyxfWAXWNhrDPGQGzaD
   gVgBd7w/fjie+Yz1bZCHpceH1TIv0tl7HUJl72bJwU5FIiSozqEUa+rrf
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="242666610"
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="242666610"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 10:30:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="489024730"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 06 Jan 2022 10:30:49 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/5][pull request] 100GbE Intel Wired LAN Driver Updates 2022-01-06
Date:   Thu,  6 Jan 2022 10:30:08 -0800
Message-Id: <20220106183013.3777622-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Victor adds restoring of advanced rules after reset.

Wojciech improves usage of switchdev control VSI by utilizing the
device's advanced rules for forwarding.

Christophe Jaillet removes some unneeded calls to zero bitmaps, changes
some bitmap operations that don't need to be atomic, and converts a
kfree() to a more appropriate bitmap_free().

The following are changes since commit 710ad98c363a66a0cd8526465426c5c5f8377ee0:
  veth: Do not record rx queue hint in veth_xmit
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Christophe JAILLET (3):
  ice: Slightly simply ice_find_free_recp_res_idx
  ice: Optimize a few bitmap operations
  ice: Use bitmap_free() to free bitmap

Victor Raj (1):
  ice: replay advanced rules after reset

Wojciech Drewek (1):
  ice: improve switchdev's slow-path

 drivers/net/ethernet/intel/ice/ice_common.c   |   2 +-
 drivers/net/ethernet/intel/ice/ice_eswitch.c  | 169 ++++++++++--------
 drivers/net/ethernet/intel/ice/ice_eswitch.h  |  25 +--
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |   6 +-
 drivers/net/ethernet/intel/ice/ice_fltr.c     |  80 ---------
 drivers/net/ethernet/intel/ice/ice_fltr.h     |   3 -
 drivers/net/ethernet/intel/ice/ice_main.c     |  24 +++
 drivers/net/ethernet/intel/ice/ice_ptp.c      |   2 +-
 drivers/net/ethernet/intel/ice/ice_repr.c     |  17 ++
 drivers/net/ethernet/intel/ice/ice_repr.h     |   5 +
 drivers/net/ethernet/intel/ice/ice_switch.c   |  96 +++++++++-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |   3 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  11 ++
 13 files changed, 263 insertions(+), 180 deletions(-)

-- 
2.31.1

