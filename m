Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE516D5D02
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 12:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbjDDKTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 06:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234426AbjDDKTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 06:19:33 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B73D3AA2
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 03:18:53 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pjdkT-00008D-Uk; Tue, 04 Apr 2023 12:18:45 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pjdkT-008tRs-8O; Tue, 04 Apr 2023 12:18:45 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pjdkR-005nml-Jm; Tue, 04 Apr 2023 12:18:43 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next v1 0/7] net: dsa: microchip: ksz8: Enhance static MAC table operations and error handling 
Date:   Tue,  4 Apr 2023 12:18:35 +0200
Message-Id: <20230404101842.1382986-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series improves the Microchip ksz8 driver by refactoring
static MAC table operations for code reuse, implementing add/del_fdb
functions, and making better use of error values in
ksz8_r_sta_mac_table() and ksz8_w_sta_mac_table(). The changes aim to
provide a more robust and maintainable driver with improved error
handling.

Oleksij Rempel (7):
  net: dsa: microchip: ksz8: Separate static MAC table operations for
    code reuse
  net: dsa: microchip: ksz8: Implement add/del_fdb and use static MAC
    table operations
  net: dsa: microchip: ksz8: Make ksz8_r_sta_mac_table() static
  net: dsa: microchip: ksz8_r_sta_mac_table(): Avoid using error code
    for empty entries
  net: dsa: microchip: ksz8_r_sta_mac_table(): Utilize error values from
    read/write functions
  net: dsa: microchip: Make ksz8_w_sta_mac_table() static
  net: dsa: microchip: Utilize error values in ksz8_w_sta_mac_table()

 drivers/net/dsa/microchip/ksz8.h       |   8 +-
 drivers/net/dsa/microchip/ksz8795.c    | 179 ++++++++++++++++---------
 drivers/net/dsa/microchip/ksz_common.c |   2 +
 3 files changed, 121 insertions(+), 68 deletions(-)

-- 
2.39.2

