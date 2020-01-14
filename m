Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3647D138EA9
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 11:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgAMKN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 05:13:26 -0500
Received: from mga03.intel.com ([134.134.136.65]:10161 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbgAMKNZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 05:13:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jan 2020 02:13:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,428,1571727600"; 
   d="scan'208";a="397116735"
Received: from bong5-hp-z440.png.intel.com ([10.221.118.136])
  by orsmga005.jf.intel.com with ESMTP; 13 Jan 2020 02:13:21 -0800
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 0/7] net: stmmac: general fixes for Ethernet functionality
Date:   Tue, 14 Jan 2020 10:01:09 +0800
Message-Id: <1578967276-55956-1-git-send-email-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch-series that fixes couple of issues in stmmac:-

1/7: It fixes the incorrect setting of Rx Tail Pointer. Rx Tail Pointer
     should points to the last valid descriptor that was replenished by
     stmmac_rx_refill().

2/7: It ensures that the real_num_rx|tx_queues are set in both driver
     probe() and resume(). So, move the netif_set_real_num_rx|tx_queues()
     into stmmac_hw_setup().

3/7: It fixes missing netdev->features = features update in
     stmmac_set_features().

4/7: It fixes incorrect MACRO function defininition for TX and RX user
     priority queue steering for queue > 3.

5/7: It ensures that the previous value of GMAC_VLAN_TAG register is
     read first before for updating the register.

6/7: It ensures the GMAC IP v4.xx and above behaves correctly to:-
      ip link set <devname> multicast off|on

7/7: It ensures PCI platform data is using plat->phy_interface.

Thanks,
Boon Leong

Aashish Verma (1):
  net: stmmac: Fix incorrect location to set real_num_rx|tx_queues

Ong Boon Leong (2):
  net: stmmac: fix error in updating rx tail pointer to last free entry
  net: stmmac: fix missing netdev->features in stmmac_set_features

Tan, Tee Min (1):
  net: stmmac: fix incorrect GMAC_VLAN_TAG register writting
    implementation

Verma, Aashish (1):
  net: stmmac: fix missing IFF_MULTICAST check in dwmac4_set_filter

Voon Weifeng (2):
  net: stmmac: Fix priority steering for tx/rx queue >3
  net: stmmac: update pci platform data to use phy_interface

 drivers/net/ethernet/stmicro/stmmac/dwmac4.h      | 10 ++++++----
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c |  9 +++++----
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 16 ++++++++++------
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c  | 14 ++++++++------
 4 files changed, 29 insertions(+), 20 deletions(-)

-- 
2.7.4

