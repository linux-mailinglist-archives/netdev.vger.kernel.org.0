Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFA23768EE
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 18:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238333AbhEGQk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 12:40:58 -0400
Received: from mga04.intel.com ([192.55.52.120]:29740 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238304AbhEGQk4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 12:40:56 -0400
IronPort-SDR: dI0WyPbietc+hMfUsF+ag6j1Cm2bNlI+QnYG2YabinvIBLJLzSVS+8Wd2bkmjIUkkVnhD0McHp
 NWxqD8Pm+8UQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9977"; a="196748692"
X-IronPort-AV: E=Sophos;i="5.82,281,1613462400"; 
   d="scan'208";a="196748692"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2021 09:39:54 -0700
IronPort-SDR: 6QJgm+p06mqlsXZHu0eEdqr6HimKFR/+GgwQtYuECeC/HHoZlhXMSpK4Fh869M5JNU6wC/D/k6
 bZpwAUhDjTDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,281,1613462400"; 
   d="scan'208";a="620267962"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 07 May 2021 09:39:54 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net 0/5][pull request] Intel Wired LAN Driver Updates 2021-05-07
Date:   Fri,  7 May 2021 09:41:46 -0700
Message-Id: <20210507164151.2878147-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e driver only.

Magnus fixes XDP by adding and correcting checks that were caused by a
previous commit which introduced a new variable but did not account for
it in all paths.

Yunjian Wang adds a return in an error path to prevent reading a freed
pointer.

Jaroslaw forces link reset when changing FEC so that changes take
affect.

Mateusz fixes PHY types for 2.5G and 5G as there is a differentiation on
PHY identifiers based on operation.

Arkadiusz removes filtering of LLDP frames for software DCB as this is
preventing them from being properly transmitted.

The following are changes since commit a6f8ee58a8e35f7e4380a5efce312e2a5bc27497:
  tcp: Specify cmsgbuf is user pointer for receive zerocopy.
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Arkadiusz Kubalewski (1):
  i40e: Remove LLDP frame filters

Jaroslaw Gawin (1):
  i40e: fix the restart auto-negotiation after FEC modified

Magnus Karlsson (1):
  i40e: fix broken XDP support

Mateusz Palczewski (1):
  i40e: Fix PHY type identifiers for 2.5G and 5G adapters

Yunjian Wang (1):
  i40e: Fix use-after-free in i40e_client_subtask()

 drivers/net/ethernet/intel/i40e/i40e.h        |  1 -
 .../net/ethernet/intel/i40e/i40e_adminq_cmd.h |  6 ++-
 drivers/net/ethernet/intel/i40e/i40e_client.c |  1 +
 drivers/net/ethernet/intel/i40e/i40e_common.c |  4 +-
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |  8 ++--
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 42 -------------------
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  8 +---
 drivers/net/ethernet/intel/i40e/i40e_type.h   |  7 +---
 8 files changed, 15 insertions(+), 62 deletions(-)

-- 
2.26.2

