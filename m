Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF8B2116D7
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 01:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbgGAXxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 19:53:32 -0400
Received: from mga12.intel.com ([192.55.52.136]:5613 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727048AbgGAXxb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 19:53:31 -0400
IronPort-SDR: uTnwxBRG4mCpjR78BLjhbvep9zCQzj7D0zc4axCxElx3X/5RwBA3VnGa9jVnIV0O48Ai8BhcD9
 aVwOXg9/Yaaw==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="126365938"
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="126365938"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 16:53:31 -0700
IronPort-SDR: fwCEvXWVvi6uWnLeBQAFxZis+28+BZTbcBKFfCqkDqhnIbA6LxDwka2MipuBTwwdqhJI94Htrg
 vtY8BVei8rbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="481785436"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga005.fm.intel.com with ESMTP; 01 Jul 2020 16:53:31 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.nguyen@intel.com
Subject: [net-next 0/3][pull request] 100GbE Intel Wired LAN Driver Updates 2020-07-01
Date:   Wed,  1 Jul 2020 16:53:23 -0700
Message-Id: <20200701235326.3176037-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to the ice driver only.

Jacob implements a devlink region for device capabilities.

Bruce removes structs containing only one-element arrays that are either
unused or only used for indexing. Instead, use pointer arithmetic or
other indexing to access the elements. Converts "C struct hack"
variable-length types to the preferred C99 flexible array member.

The following are changes since commit 2b04a66156159592156a97553057e8c36de2ee70:
  Merge branch 'cxgb4-add-mirror-action-support-for-TC-MATCHALL'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Bruce Allan (2):
  ice: avoid unnecessary single-member variable-length structs
  ice: replace single-element array used for C struct hack

Jacob Keller (1):
  ice: implement snapshot for device capabilities

 drivers/net/ethernet/intel/ice/ice.h          |   1 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  62 ++-----
 drivers/net/ethernet/intel/ice/ice_base.c     |   2 +-
 drivers/net/ethernet/intel/ice/ice_common.c   | 167 +++++++++++-------
 drivers/net/ethernet/intel/ice/ice_common.h   |   5 +-
 drivers/net/ethernet/intel/ice/ice_dcb.c      |   4 +-
 drivers/net/ethernet/intel/ice/ice_dcb.h      |   4 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c  |  59 +++++++
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |  35 ++--
 .../net/ethernet/intel/ice/ice_flex_type.h    |  39 ++--
 drivers/net/ethernet/intel/ice/ice_lib.c      |   2 +-
 drivers/net/ethernet/intel/ice/ice_sched.c    |  65 +++----
 drivers/net/ethernet/intel/ice/ice_sched.h    |   2 +-
 drivers/net/ethernet/intel/ice/ice_switch.c   |  50 +++---
 drivers/net/ethernet/intel/ice/ice_xsk.c      |   6 +-
 15 files changed, 276 insertions(+), 227 deletions(-)

-- 
2.26.2

