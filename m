Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B409608B71
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 12:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbiJVKVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 06:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbiJVKUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 06:20:38 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EDD6E14001;
        Sat, 22 Oct 2022 02:37:29 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.95,204,1661785200"; 
   d="scan'208";a="137536287"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 22 Oct 2022 17:33:55 +0900
Received: from localhost.localdomain (unknown [10.226.92.14])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 1A33F4006185;
        Sat, 22 Oct 2022 17:33:49 +0900 (JST)
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
        Chris Paterson <Chris.Paterson2@renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH 0/3] R-Car CANFD fixes
Date:   Sat, 22 Oct 2022 09:15:00 +0100
Message-Id: <20221022081503.1051257-1-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.9 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series fixes the below issues in R-Car CAN FD driver.

 1) Race condition in CAN driver under heavy CAN load condition
    with both channels enabled results in IRQ stom on global fifo
    receive irq line.
 2) Add channel specific tx interrupts handling for RZ/G2L SoC as it has
    separate IRQ lines for each tx.
 3) Remove unnecessary SoC specific checks in probe.

Biju Das (3):
  can: rcar_canfd: Fix IRQ storm on global fifo receive
  can: rcar_canfd: Fix channel specific IRQ handling for RZ/G2L
  can: rcar_canfd: Use devm_reset_control_get_optional_exclusive

 drivers/net/can/rcar/rcar_canfd.c | 50 +++++++++++++++++--------------
 1 file changed, 27 insertions(+), 23 deletions(-)

-- 
2.25.1

