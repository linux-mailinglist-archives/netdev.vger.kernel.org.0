Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B482C314629
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 03:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhBICX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 21:23:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:15909 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229704AbhBICX2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 21:23:28 -0500
IronPort-SDR: GxDcJUl3skv3DsBsS6AJhQg9n1PYuVh2cwThVHjvNnNZtGsKQmHjcNqsALxjGFqlWZZHDqyan5
 iAQ5UW6QpayQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="181960298"
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="181960298"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 18:22:48 -0800
IronPort-SDR: gXUEJKo6KMSZ7r6m8rPBewG+ETfrXD4UKBLSpjAEgEaXTDtc/KCOAHQQfrf8iAV+dvOC7ydoXA
 90i1wcq0oKfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="359003687"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 08 Feb 2021 18:22:45 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, bjorn.topel@intel.com,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com
Subject: [PATCH net-next v2 0/5][pull request] 40GbE Intel Wired LAN Driver Updates 2021-02-08
Date:   Mon,  8 Feb 2021 18:23:18 -0800
Message-Id: <20210209022323.2440775-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e driver only.

Cristian makes improvements to driver XDP path. Avoids writing
next-to-clean pointer on every update, removes redundant updates of
cleaned_count and buffer info, creates a helper function to consolidate
XDP actions and simplifies some of the behavior.

Eryk adds messages to inform the user when MTU is larger than supported

v2:
- Drop XDP_REDIRECT messaging patch (previously patch 5)
- Use only extack for XDP MTU error

The following are changes since commit 08cbabb77e9098ec6c4a35911effac53e943c331:
  Merge tag 'mlx5-updates-2021-02-04' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Cristian Dumitrescu (4):
  i40e: remove unnecessary memory writes of the next to clean pointer
  i40e: remove unnecessary cleaned_count updates
  i40e: remove the redundant buffer info updates
  i40e: consolidate handling of XDP program actions

Eryk Rybak (1):
  i40e: Log error for oversized MTU on device

 drivers/net/ethernet/intel/i40e/i40e_main.c |  11 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 149 +++++++++++---------
 2 files changed, 86 insertions(+), 74 deletions(-)

-- 
2.26.2

