Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADEC030B538
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 03:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhBBCZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 21:25:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:11645 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231128AbhBBCZQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 21:25:16 -0500
IronPort-SDR: dJIAx0EtAWaaftS0wBZzKFpYjxWF8dLjwRC0xSxQG4RtqZngBn3DQdR3f6j0k1DnvUOtcUhFAp
 7+vAJsne/VNQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="180929262"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="180929262"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 18:23:38 -0800
IronPort-SDR: Ye67VDNnGspoMfMJkNU24Q1liQ6QAMbTxzsQRDaLCwrw/wRj6IKTEo65AJfj3VRzUxMnKgTzTk
 b4eQpaftOFfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="581782124"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 01 Feb 2021 18:23:37 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, bjorn.topel@intel.com,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com
Subject: [PATCH net-next 0/6][pull request] 40GbE Intel Wired LAN Driver Updates 2021-02-01
Date:   Mon,  1 Feb 2021 18:24:14 -0800
Message-Id: <20210202022420.1328397-1-anthony.l.nguyen@intel.com>
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

Arkadiusz adds a message to inform user of the need for XDP_REDIRECT
to match number of queue on both interfaces.

Eryk adds messages to inform the user when MTU is larger than supported
for an XDP program.

The following are changes since commit 14e8e0f6008865d823a8184a276702a6c3cbef3d:
  tcp: shrink inet_connection_sock icsk_mtup enabled and probe_size
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Arkadiusz Kubalewski (1):
  i40e: Add info trace at loading XDP program

Cristian Dumitrescu (4):
  i40e: remove unnecessary memory writes of the next to clean pointer
  i40e: remove unnecessary cleaned_count updates
  i40e: remove the redundant buffer info updates
  i40e: consolidate handling of XDP program actions

Eryk Rybak (1):
  i40e: Log error for oversized MTU on device

 drivers/net/ethernet/intel/i40e/i40e_main.c |  19 ++-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 149 +++++++++++---------
 2 files changed, 93 insertions(+), 75 deletions(-)

-- 
2.26.2

