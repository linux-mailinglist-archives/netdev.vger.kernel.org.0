Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC68A60D119
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 17:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbiJYP5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 11:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbiJYP5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 11:57:09 -0400
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD55F17D86C;
        Tue, 25 Oct 2022 08:57:06 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.95,212,1661785200"; 
   d="scan'208";a="140317228"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 26 Oct 2022 00:57:05 +0900
Received: from localhost.localdomain (unknown [10.226.92.152])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 2409540083F9;
        Wed, 26 Oct 2022 00:56:59 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Rob Herring <robh@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 0/3] R-Car CANFD fixes
Date:   Tue, 25 Oct 2022 16:56:54 +0100
Message-Id: <20221025155657.1426948-1-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.4 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series fixes the below issues in R-Car CAN FD driver.

 1) Race condition in CAN driver under heavy CAN load condition
    with both channels enabled results in IRQ storm on global fifo
    receive irq line.
 2) Add channel specific tx interrupts handling for RZ/G2L SoC as it has
    separate IRQ lines for each tx.
 3) Remove unnecessary SoC specific checks in probe.

v1->v2:
 * Added check for irq active and enabled before handling the irq on a
   particular channel.

Biju Das (3):
  can: rcar_canfd: Fix IRQ storm on global fifo receive
  can: rcar_canfd: Fix channel specific IRQ handling for RZ/G2L
  can: rcar_canfd: Use devm_reset_control_get_optional_exclusive

 drivers/net/can/rcar/rcar_canfd.c | 46 +++++++++++++++----------------
 1 file changed, 22 insertions(+), 24 deletions(-)

-- 
2.25.1

