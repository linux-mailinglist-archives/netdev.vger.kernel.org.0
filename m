Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF12341F07B
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354919AbhJAPIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:08:30 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:6324 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1354827AbhJAPI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 11:08:28 -0400
X-IronPort-AV: E=Sophos;i="5.85,339,1624287600"; 
   d="scan'208";a="95822181"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 02 Oct 2021 00:06:42 +0900
Received: from localhost.localdomain (unknown [10.226.92.36])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 986254405283;
        Sat,  2 Oct 2021 00:06:39 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: [PATCH 00/10] Add Gigabit Ethernet driver support
Date:   Fri,  1 Oct 2021 16:06:26 +0100
Message-Id: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DMAC and EMAC blocks of Gigabit Ethernet IP found on RZ/G2L SoC are
similar to the R-Car Ethernet AVB IP.

The Gigabit Ethernet IP consists of Ethernet controller (E-MAC), Internal
TCP/IP Offload Engine (TOE)  and Dedicated Direct memory access controller
(DMAC).

With a few changes in the driver we can support both IPs.

This patch series is in preparation for adding Gigabit ethernet driver support to RZ/G2L SoC.

The number of patches after incorporatng RFC review comments is 19.
So splitting the patches into 2 patchsets (10 + 9).

The series is the first patchset which aims to add RZ/G2L SoC with
compatible strings, E-MAC and D-MAC initialization.

Second patchset basically fillup all the stubs for the full Gigabit
Ethernet functionality.

RFC->V1:
 * Added Rb tags of patch#1 and patch #9
 * Renamed "rgeth" to gbeth
 * Renamed the variable "no_ptp_cfg_active" with "gptp" and
   "ptp_cfg_active" with "ccc_gac
 * Handled NC queue only for R-Car.
 * Removed RIC3 initialization from DMAC init, as it is 
   same as reset value.
 * moved stubs function to patch#4.
 * Added tsrq variable instead of multi_tsrq feature bit.
 * moved CSR0 initialization from E-MAC init to later patch.
 * started using ravb_modify for initializing link registers.

Ref:-
https://lore.kernel.org/linux-renesas-soc/20210923140813.13541-1-biju.das.jz@bp.renesas.com/T/#m5c007b42d6c334de7b2224f2b219f52efc712fe9


Biju Das (10):
  ravb: Rename "ravb_set_features_rx_csum" function to
    "ravb_set_features_rcar"
  ravb: Rename "no_ptp_cfg_active" and "ptp_cfg_active" variables
  ravb: Add nc_queue to struct ravb_hw_info
  ravb: Add support for RZ/G2L SoC
  ravb: Initialize GbEthernet DMAC
  ravb: Exclude gPTP feature support for RZ/G2L
  ravb: Add tsrq to struct ravb_hw_info
  ravb: Add magic_pkt to struct ravb_hw_info
  ravb: Add half_duplex to struct ravb_hw_info
  ravb: Initialize GbEthernet E-MAC

 drivers/net/ethernet/renesas/ravb.h      |  39 +-
 drivers/net/ethernet/renesas/ravb_main.c | 452 +++++++++++++++++------
 2 files changed, 362 insertions(+), 129 deletions(-)

-- 
2.17.1

