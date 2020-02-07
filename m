Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4791552F7
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 08:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbgBGHbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 02:31:46 -0500
Received: from mga07.intel.com ([134.134.136.100]:16042 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgBGHbp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Feb 2020 02:31:45 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 23:31:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,412,1574150400"; 
   d="scan'208";a="311956325"
Received: from unknown (HELO bong5-HP-Z440.png.intel.com) ([10.221.118.166])
  by orsmga001.jf.intel.com with ESMTP; 06 Feb 2020 23:31:42 -0800
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     netdev@vger.kernel.org
Cc:     Tan Tee Min <tee.min.tan@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v5 0/5] net: stmmac: general fixes for Ethernet functionality
Date:   Fri,  7 Feb 2020 15:31:05 +0800
Message-Id: <20200207073105.9286-1-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks to all feedbacks from community so far.

We updated the patch-series to below:-

1/5: It ensures that the previous value of GMAC_VLAN_TAG register is
     read first before for updating the register.

2/5: Similar to 2/6 patch but it is a fix for XGMAC_VLAN_TAG register
     as requested by Jose Abreu.

3/5: It ensures the GMAC IP v4.xx and above behaves correctly to:-
       ip link set <devname> multicast off|on

4/5: Added similar IFF_MULTICAST flag for xgmac2, similar to 4/6.

5/5: It ensures PCI platform data is using plat->phy_interface.

Rgds,
Boon Leong

Changes from v4:-
   patch 1/6 - this patch is dropped now and will take the input on
               handling return value from netif_set_real_num_rx|
               tx_queues() in future patch series.

v3:-
   patch 1/6 - add rtnl_lock() and rtnl_unlock() for stmmac_hw_setup()
               called inside stmmac_resume()
   patch 3/6 - Added new patch to fix XGMAC_VLAN_TAG register writting

v2:-
   patch 1/5 - added control for rtnl_lock() & rtnl_unlock() to ensure
               they are used forstmmac_resume()
   patch 4/5 - added IFF_MULTICAST flag check for xgmac to ensure
               multicast works correctly.

v1:-
 - Drop v1 patches (1/7, 3/7 & 4/7) that are not valid.

Ong Boon Leong (1):
  net: stmmac: xgmac: fix incorrect XGMAC_VLAN_TAG register writting

Tan, Tee Min (2):
  net: stmmac: fix incorrect GMAC_VLAN_TAG register writting in GMAC4+
  net: stmmac: xgmac: fix missing IFF_MULTICAST checki in
    dwxgmac2_set_filter

Verma, Aashish (1):
  net: stmmac: fix missing IFF_MULTICAST check in dwmac4_set_filter

Voon Weifeng (1):
  net: stmmac: update pci platform data to use phy_interface

 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |  9 +++++----
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    | 10 +++++++---
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c   | 14 ++++++++------
 3 files changed, 20 insertions(+), 13 deletions(-)

-- 
2.17.1

