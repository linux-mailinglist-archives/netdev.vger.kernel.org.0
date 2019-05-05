Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB68513C8F
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 03:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbfEEBTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 21:19:12 -0400
Received: from mga18.intel.com ([134.134.136.126]:33074 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbfEEBTL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 21:19:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 May 2019 18:14:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,431,1549958400"; 
   d="scan'208";a="297102540"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 04 May 2019 18:14:10 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/12][pull request] 40GbE Intel Wired LAN Driver Updates 2019-05-04
Date:   Sat,  4 May 2019 18:13:57 -0700
Message-Id: <20190505011409.6771-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e only.

Grzegorz fixes a bug with promiscuous mode not being kept when the VF
switched to a new VLAN.  Fixed a typo in the link mode code, by using
the correct define.  Fixed truncation issue, which changed an function
argument to a smaller value that should have been a larger value.

Aleksandr adds support for new x710 devices and the speeds they support.

Sergey adds a check for the number of vectors against the number of MSIx
vectors to ensure one does not exceed the other.

Martyna adds additional input validation on VF messages handled by the
PF.  Fixed potential memory leaks in the driver where the error paths
were not freeing allocated memory.

Maciej reverts the double ShadowRAM checksum calculation change because
issues were found in the NVM downgrade situation.

Gustavo Silva changes the i40e driver to use struct_size() in kzalloc()
calls, to avoid type mistakes. 

The following are changes since commit a734d1f4c2fc962ef4daa179e216df84a8ec5f84:
  net: openvswitch: return an error instead of doing BUG_ON()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 40GbE

Aleksandr Loktionov (2):
  i40e: add new pci id for X710/XXV710 N3000 cards
  i40e: Add support for X710 B/P & SFP+ cards

Grzegorz Siwik (4):
  i40e: VF's promiscuous attribute is not kept
  i40e: Setting VF to VLAN 0 requires restart
  i40e: Fix the typo in adding 40GE KR4 mode
  i40e: Wrong truncation from u16 to u8

Gustavo A. R. Silva (1):
  i40e: Use struct_size() in kzalloc()

Maciej Paczkowski (1):
  i40e: Revert ShadowRAM checksum calculation change

Martyna Szapar (3):
  i40e: missing input validation on VF message handling by the PF
  i40e: Fix of memory leak and integer truncation in i40e_virtchnl.c
  i40e: Memory leak in i40e_config_iwarp_qvlist

Sergey Nemov (1):
  i40e: add num_vectors checker in iwarp handler

 .../net/ethernet/intel/i40e/i40e_adminq_cmd.h |  12 +-
 drivers/net/ethernet/intel/i40e/i40e_client.c |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c |   7 +
 drivers/net/ethernet/intel/i40e/i40e_devids.h |   5 +
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |  46 ++++++-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  14 +-
 drivers/net/ethernet/intel/i40e/i40e_nvm.c    |  28 +---
 drivers/net/ethernet/intel/i40e/i40e_type.h   |   6 +
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 130 ++++++++++++++----
 .../ethernet/intel/i40e/i40e_virtchnl_pf.h    |   2 +
 10 files changed, 193 insertions(+), 63 deletions(-)

-- 
2.20.1

