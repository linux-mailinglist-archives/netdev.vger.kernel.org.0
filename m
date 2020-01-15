Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDBB313BA31
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 08:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgAOHKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 02:10:38 -0500
Received: from mga06.intel.com ([134.134.136.31]:16006 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbgAOHKi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 02:10:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jan 2020 23:10:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,321,1574150400"; 
   d="scan'208";a="256643646"
Received: from bong5-hp-z440.png.intel.com ([10.221.118.136])
  by fmsmga002.fm.intel.com with ESMTP; 14 Jan 2020 23:10:34 -0800
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kubakici@wp.pl>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2 0/4] net: stmmac: general fixes for Ethernet functionality
Date:   Wed, 15 Jan 2020 15:09:59 +0800
Message-Id: <20200115071003.42820-1-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks to all feedbacks from community.

We updated the patch-series to below:-

1/4: It ensures that the real_num_rx|tx_queues are set in both driver
     probe() and resume(). So, move the netif_set_real_num_rx|tx_queues()
     into stmmac_hw_setup().

2/4: It ensures that the previous value of GMAC_VLAN_TAG register is
     read first before for updating the register.

3/4: It ensures the GMAC IP v4.xx and above behaves correctly to:-
       ip link set <devname> multicast off|on

4/4: It ensures PCI platform data is using plat->phy_interface.

Rgds,
Boon Leong

Changes from v1:-
 - Drop v1 patches (1/7, 3/7 & 4/7) that are not valid.

Aashish Verma (1):
  net: stmmac: Fix incorrect location to set real_num_rx|tx_queues

Tan, Tee Min (1):
  net: stmmac: fix incorrect GMAC_VLAN_TAG register writting
    implementation

Verma, Aashish (1):
  net: stmmac: fix missing IFF_MULTICAST check in dwmac4_set_filter

Voon Weifeng (1):
  net: stmmac: update pci platform data to use phy_interface

 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c |  9 +++++----
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  8 ++++----
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c  | 14 ++++++++------
 3 files changed, 17 insertions(+), 14 deletions(-)

-- 
2.17.1

