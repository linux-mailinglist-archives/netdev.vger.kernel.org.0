Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E95042248E
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 13:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234278AbhJELIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 07:08:40 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:29930 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233449AbhJELIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 07:08:39 -0400
X-IronPort-AV: E=Sophos;i="5.85,348,1624287600"; 
   d="scan'208";a="96017410"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 05 Oct 2021 20:06:47 +0900
Received: from localhost.localdomain (unknown [10.226.93.104])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 1BAE040078B9;
        Tue,  5 Oct 2021 20:06:44 +0900 (JST)
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
Subject: [RFC 00/12] Add functional support for Gigabit Ethernet driver
Date:   Tue,  5 Oct 2021 12:06:30 +0100
Message-Id: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
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

This patch series is aims to add functional support for Gigabit Ethernet driver
by filling all the stubs.

Ref:-
https://lore.kernel.org/linux-renesas-soc/OS0PR01MB5922240F88E5E0FD989ECDF386AC9@OS0PR01MB5922.jpnprd01.prod.outlook.com/T/#m8dee0a1b14d505d4611cad8c10e4017a30db55d6

RFC changes:
 * used ALIGN macro for calculating the value for max_rx_len.
 * used rx_max_buf_size instead of rx_2k_buffers feature bit.
 * moved struct ravb_rx_desc *gbeth_rx_ring near to ravb_private::rx_ring
   and allocating it for 1 RX queue.
 * Started using gbeth_rx_ring instead of gbeth_rx_ring[q].
 * renamed ravb_alloc_rx_desc to ravb_alloc_rx_desc_rcar
 * renamed ravb_rx_ring_free to ravb_rx_ring_free_rcar
 * renamed ravb_rx_ring_format to ravb_rx_ring_format_rcar
 * renamed ravb_rcar_rx to ravb_rx_rcar
 * renamed "tsrq" variable
 * Updated the comments

Biju Das (12):
  ravb: Use ALIGN macro for max_rx_len
  ravb: Add rx_max_buf_size to struct ravb_hw_info
  ravb: Fillup ravb_set_features_gbeth() stub
  ravb: Fillup ravb_alloc_rx_desc_gbeth() stub
  ravb: Fillup ravb_rx_ring_free_gbeth() stub
  ravb: Fillup ravb_rx_ring_format_gbeth() stub
  ravb: Fillup ravb_rx_gbeth() stub
  ravb: Add carrier_counters to struct ravb_hw_info
  ravb: Add support to retrieve stats for GbEthernet
  ravb: Rename "tsrq" variable
  ravb: Optimize ravb_emac_init_gbeth function
  ravb: Update/Add comments

 drivers/net/ethernet/renesas/ravb.h      |  51 +++-
 drivers/net/ethernet/renesas/ravb_main.c | 349 +++++++++++++++++++++--
 2 files changed, 367 insertions(+), 33 deletions(-)

-- 
2.17.1

