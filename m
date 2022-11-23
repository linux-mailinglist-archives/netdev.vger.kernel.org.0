Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 832FC635BA5
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 12:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236398AbiKWL1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 06:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236659AbiKWL0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 06:26:43 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2C1F1D82
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 03:26:42 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oxntd-0003vb-HZ; Wed, 23 Nov 2022 12:26:29 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oxnta-0062RA-Os; Wed, 23 Nov 2022 12:26:27 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oxnta-008jqT-S8; Wed, 23 Nov 2022 12:26:26 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: [PATCH net-next v5 0/5] net: dsa: microchip: add MTU support for KSZ8 series 
Date:   Wed, 23 Nov 2022 12:26:20 +0100
Message-Id: <20221123112625.2082797-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

changes v4:
- add mtu normalization patch

changes v4:
- remove per port max_frame cache
- remove port variable for ksz88* variants
- add KSZ9563_CHIP_ID
- not start a new line with an operator

changes v3:
- rename KSZ8863_LEGAL_PACKET_SIZE -> KSZ8_LEGAL_PACKET_SIZE

changes v2:
- add ksz_rmw8() helper
- merge all max MTUs to one location

Oleksij Rempel (5):
  net: dsa: microchip: move max mtu to one location
  net: dsa: microchip: do not store max MTU for all ports
  net: dsa: microchip: add ksz_rmw8() function
  net: dsa: microchip: ksz8: add MTU configuration support
  net: dsa: microchip: enable MTU normalization for KSZ8795 and KSZ9477
    compatible switches

 drivers/net/dsa/microchip/ksz8.h        |  1 +
 drivers/net/dsa/microchip/ksz8795.c     | 55 ++++++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz8795_reg.h |  3 ++
 drivers/net/dsa/microchip/ksz9477.c     | 21 ++++------
 drivers/net/dsa/microchip/ksz9477.h     |  1 -
 drivers/net/dsa/microchip/ksz9477_reg.h |  2 -
 drivers/net/dsa/microchip/ksz_common.c  | 29 ++++++++++---
 drivers/net/dsa/microchip/ksz_common.h  | 13 +++++-
 8 files changed, 99 insertions(+), 26 deletions(-)

-- 
2.30.2

