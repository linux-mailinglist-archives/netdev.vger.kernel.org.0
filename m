Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE433CD6D2
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 16:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241157AbhGSN7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 09:59:07 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:4499 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232395AbhGSN7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 09:59:05 -0400
X-IronPort-AV: E=Sophos;i="5.84,252,1620658800"; 
   d="scan'208";a="88086566"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 19 Jul 2021 23:39:43 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 0C4694003EC3;
        Mon, 19 Jul 2021 23:39:39 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH v2 0/5] Renesas RZ/G2L CANFD support
Date:   Mon, 19 Jul 2021 15:38:06 +0100
Message-Id: <20210719143811.2135-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

This patch series adds CANFD support to Renesas RZ/G2L family.

CANFD block on RZ/G2L SoC is almost identical to one found on
R-Car Gen3 SoC's. On RZ/G2L SoC interrupt sources for each channel
are split into individual sources.

Cheers,
Prabhakar

Changes for v2:
* Added interrupt-names property and marked it as required for 
  RZ/G2L family
* Added descriptions for reset property
* Re-used irq handlers on RZ/G2L SoC
* Added new enum for chip_id
* Dropped R9A07G044_LAST_CORE_CLK
* Dropped patch (clk: renesas: r9a07g044-cpg: Add clock and reset
  entries for CANFD) as its been merged into renesas tree

Lad Prabhakar (5):
  dt-bindings: net: can: renesas,rcar-canfd: Document RZ/G2L SoC
  can: rcar_canfd: Add support for RZ/G2L family
  dt-bindings: clk: r9a07g044-cpg: Add entry for P0_DIV2 core clock
  clk: renesas: r9a07g044-cpg: Add entry for fixed clock P0_DIV2
  arm64: dts: renesas: r9a07g044: Add CANFD node

 .../bindings/net/can/renesas,rcar-canfd.yaml  |  66 ++++++-
 arch/arm64/boot/dts/renesas/r9a07g044.dtsi    |  42 +++++
 drivers/clk/renesas/r9a07g044-cpg.c           |   3 +-
 drivers/net/can/rcar/rcar_canfd.c             | 178 +++++++++++++++---
 include/dt-bindings/clock/r9a07g044-cpg.h     |   1 +
 5 files changed, 252 insertions(+), 38 deletions(-)


base-commit: 2734d6c1b1a089fb593ef6a23d4b70903526fe0c
-- 
2.17.1

