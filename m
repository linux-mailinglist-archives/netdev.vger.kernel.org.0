Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3214651A2B5
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 16:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351526AbiEDO7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 10:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351595AbiEDO7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 10:59:08 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BC676222B6;
        Wed,  4 May 2022 07:55:29 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.91,198,1647270000"; 
   d="scan'208";a="118714991"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 04 May 2022 23:55:28 +0900
Received: from localhost.localdomain (unknown [10.226.93.27])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id BCA1F4250F05;
        Wed,  4 May 2022 23:55:22 +0900 (JST)
From:   Phil Edworthy <phil.edworthy@renesas.com>
To:     Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Phil Edworthy <phil.edworthy@renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-clk@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH 0/9] Add Renesas RZ/V2M Ethernet support
Date:   Wed,  4 May 2022 15:54:45 +0100
Message-Id: <20220504145454.71287-1-phil.edworthy@renesas.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RZ/V2M Ethernet is very similar to R-Car Gen3 Ethernet-AVB, though
some small parts are the same as R-Car Gen2.
Other differences are:
* It has separate data (DI), error (Line 1) and management (Line 2) irqs
  rather than one irq for all three.
* Instead of using the High-speed peripheral bus clock for gPTP, it has
  a separate gPTP reference clock.

The dts patches depend on v4 of the following patch set:
"Add new Renesas RZ/V2M SoC and Renesas RZ/V2M EVK support"

Phil Edworthy (9):
  clk: renesas: r9a09g011: Add eth clock and reset entries
  dt-bindings: net: renesas,etheravb: Document RZ/V2M SoC
  ravb: Separate use of GIC reg for PTME from multi_irqs
  ravb: Separate handling of irq enable/disable regs into feature
  ravb: Support separate Line0 (Desc), Line1 (Err) and Line2 (Mgmt) irqs
  ravb: Use separate clock for gPTP
  ravb: Add support for RZ/V2M
  arm64: dts: renesas: r9a09g011: Add ethernet nodes
  arm64: dts: renesas: rzv2m evk: Enable ethernet

 .../bindings/net/renesas,etheravb.yaml        | 82 ++++++++++++-----
 .../boot/dts/renesas/r9a09g011-v2mevk2.dts    | 14 +++
 arch/arm64/boot/dts/renesas/r9a09g011.dtsi    | 51 +++++++++++
 drivers/clk/renesas/r9a09g011-cpg.c           | 14 +--
 drivers/net/ethernet/renesas/ravb.h           |  7 ++
 drivers/net/ethernet/renesas/ravb_main.c      | 89 +++++++++++++++++--
 drivers/net/ethernet/renesas/ravb_ptp.c       |  4 +-
 7 files changed, 228 insertions(+), 33 deletions(-)

-- 
2.32.0

