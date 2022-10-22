Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93A1D608C95
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 13:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiJVL2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 07:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiJVL1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 07:27:55 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6F0FD2751A9;
        Sat, 22 Oct 2022 04:02:45 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.95,205,1661785200"; 
   d="scan'208";a="137542090"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 22 Oct 2022 20:02:44 +0900
Received: from localhost.localdomain (unknown [10.226.92.14])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id BAD9740078D3;
        Sat, 22 Oct 2022 20:02:38 +0900 (JST)
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
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH 0/6] R-Can CAN FD driver enhancements
Date:   Sat, 22 Oct 2022 11:43:51 +0100
Message-Id: <20221022104357.1276740-1-biju.das.jz@bp.renesas.com>
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

The CAN FD IP found on RZ/G2L SoC has some HW features different to that
of R-Car. For example, it has multiple resets and multiple IRQs for global
and channel interrupts. Also, it does not have ECC error flag registers
and clk post divider present on R-Car. Similarly, R-Car V3U has 8 channels
whereas other SoCs has only 2 channels.

Currently all the differences are taken by comparing chip_id enum.
This patch series aims to replace chip_id with struct rcar_canfd_hw_info
to take care of the HW feature differences and driver data present
on both IPs.

The changes are trivial and tested on RZ/G2L SMARC EVK.

This patch series depend upon[1]
[1] https://lore.kernel.org/linux-renesas-soc/20221022081503.1051257-1-biju.das.jz@bp.renesas.com/T/#t

Biju Das (6):
  can: rcar_canfd: rcar_canfd_probe: Add struct rcar_canfd_hw_info to
    driver data
  can: rcar_canfd: Add max_channels to struct rcar_canfd_hw_info
  can: rcar_canfd: Add multi_global_irqs to struct rcar_canfd_hw_info
  can: rcar_canfd: Add clk_postdiv to struct rcar_canfd_hw_info
  can: rcar_canfd: Add multi_channel_irqs to struct rcar_canfd_hw_info
  can: rcar_canfd: Add has_gerfl_eef to struct rcar_canfd_hw_info

 drivers/net/can/rcar/rcar_canfd.c | 89 +++++++++++++++++++------------
 1 file changed, 54 insertions(+), 35 deletions(-)

-- 
2.25.1

