Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B481E3D254A
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbhGVNd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 09:33:26 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:15283 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232105AbhGVNdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 09:33:25 -0400
X-IronPort-AV: E=Sophos;i="5.84,261,1620658800"; 
   d="scan'208";a="88463911"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 22 Jul 2021 23:13:59 +0900
Received: from localhost.localdomain (unknown [10.226.92.164])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 65D6D401224D;
        Thu, 22 Jul 2021 23:13:55 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH net-next 00/18] Add Gigabit Ethernet driver support
Date:   Thu, 22 Jul 2021 15:13:33 +0100
Message-Id: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DMAC and EMAC blocks of Gigabit Ethernet IP is almost similar to Ethernet AVB.

The Gigabit Etherner IP consists of Ethernet controller (E-MAC), Internal TCP/IP Offload Engine (TOE) and Dedicated Direct memory access controller (DMAC).

With few changes in driver, we can support Gigabit ethernet driver as well.

This patch series is aims to support the same

RFC->V1
  * Incorporated feedback from Andrew, Sergei, Geert and Prabhakar
  * https://patchwork.kernel.org/project/linux-renesas-soc/list/?series=515525

Biju Das (18):
  dt-bindings: net: renesas,etheravb: Document Gigabit Ethernet IP
  drivers: clk: renesas: rzg2l-cpg: Add support to handle MUX clocks
  drivers: clk: renesas: r9a07g044-cpg: Add ethernet clock sources
  drivers: clk: renesas: r9a07g044-cpg: Add GbEthernet clock/reset
  ravb: Replace chip type with a structure for driver data
  ravb: Factorise ptp feature
  ravb: Add features specific to R-Car Gen3
  ravb: Add R-Car common features
  ravb: Factorise ravb_ring_free function
  ravb: Factorise ravb_ring_format function
  ravb: Factorise ravb_ring_init function
  ravb: Factorise {emac,dmac} init function
  ravb: Factorise ravb_rx function
  ravb: Factorise ravb_adjust_link function
  ravb: Factorise ravb_set_features
  ravb: Add reset support
  ravb: Add GbEthernet driver support
  arm64: dts: renesas: r9a07g044: Add GbEther nodes

 .../bindings/net/renesas,etheravb.yaml        |  57 +-
 arch/arm64/boot/dts/renesas/r9a07g044.dtsi    |  42 +
 drivers/clk/renesas/r9a07g044-cpg.c           |  27 +
 drivers/clk/renesas/rzg2l-cpg.c               |  24 +
 drivers/clk/renesas/rzg2l-cpg.h               |  15 +
 drivers/net/ethernet/renesas/ravb.h           | 112 ++-
 drivers/net/ethernet/renesas/ravb_main.c      | 922 +++++++++++++++---
 7 files changed, 1031 insertions(+), 168 deletions(-)

-- 
2.17.1

