Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD4E31F302
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 00:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhBRXZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 18:25:31 -0500
Received: from mga12.intel.com ([192.55.52.136]:20043 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230100AbhBRXZX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 18:25:23 -0500
IronPort-SDR: 9f61p6J4+Y8oDE7o58dZzP2XztgdEprPrKxL/npJCtR4p09wV7iREwa/nfXNp9M93A9emkHI+B
 gL3WWTwiUiOg==
X-IronPort-AV: E=McAfee;i="6000,8403,9899"; a="162823063"
X-IronPort-AV: E=Sophos;i="5.81,187,1610438400"; 
   d="scan'208";a="162823063"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2021 15:24:07 -0800
IronPort-SDR: 6182QPhgC/Y2YAMOkSklgipEJrJq1jnwKm/R+fhDKfHraiDERnVgTS4LLfNI9TIHz4zKzHqJeS
 aZxvI3XF73Cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,187,1610438400"; 
   d="scan'208";a="581457628"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 18 Feb 2021 15:24:07 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net 0/8][pull request] Intel Wired LAN Driver Updates 2021-02-18
Date:   Thu, 18 Feb 2021 15:24:56 -0800
Message-Id: <20210218232504.2422834-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e driver only.

Slawomir resolves an issue with the IPv6 extension headers being
processed incorrectly.

Keita Suzuki fixes a memory leak on probe failure.

Mateusz initializes AQ command structures to zero to comply with
spec, fixes FW flow control settings being overwritten and resolves an
issue with adding VLAN filters after enabling FW LLDP. He also adds
an additional check when adding TC filter as the current check doesn't
properly distinguish between IPv4 and IPv6.

Sylwester removes setting disabled bit when syncing filters as this
prevents VFs from completing setup.

Norbert cleans up sparse warnings.

The following are changes since commit 3af409ca278d4a8d50e91f9f7c4c33b175645cf3:
  net: enetc: fix destroyed phylink dereference during unbind
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Keita Suzuki (1):
  i40e: Fix memory leak in i40e_probe

Mateusz Palczewski (4):
  i40e: Add zero-initialization of AQ command structures
  i40e: Fix overwriting flow control settings during driver loading
  i40e: Fix addition of RX filters after enabling FW LLDP agent
  i40e: Fix add TC filter for IPv6

Norbert Ciosek (1):
  i40e: Fix endianness conversions

Slawomir Laba (1):
  i40e: Fix flow for IPv6 next header (extension header)

Sylwester Dziedziuch (1):
  i40e: Fix VFs not created

 .../net/ethernet/intel/i40e/i40e_ethtool.c    | 16 +++--
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 64 +++++++------------
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 11 ++--
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    |  2 +-
 4 files changed, 39 insertions(+), 54 deletions(-)

-- 
2.26.2

