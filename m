Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3F96750BE
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 10:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbjATJVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 04:21:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbjATJVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 04:21:34 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855A09DCBD
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 01:21:11 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pIna3-0002yM-Dc; Fri, 20 Jan 2023 10:21:03 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pIna2-007L96-9H; Fri, 20 Jan 2023 10:21:02 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pIna0-001STZ-TB; Fri, 20 Jan 2023 10:21:00 +0100
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
Subject: [PATCH net-next v2 0/4] net: add EEE support for KSZ9477 switch series
Date:   Fri, 20 Jan 2023 10:20:55 +0100
Message-Id: <20230120092059.347734-1-o.rempel@pengutronix.de>
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

changes v2:
- use phydev->supported instead of reading MII_BMSR regiaster
- fix @get_eee > @set_eee

With this patch series we provide EEE support for KSZ9477 family of switches.
According to my tests, on a system with KSZ8563 switch and 100Mbit idle link,
we consume 0,192W less power per port if EEE is enabled.

Oleksij Rempel (4):
  net: phy: add driver specific get/set_eee support
  net: phy: micrel: add EEE configuration support for KSZ9477 variants
    of PHYs
  net: phy: micrel: disable 1000Mbit EEE support if 1000Mbit is not
    supported
  net: dsa: microchip: enable EEE support

 drivers/net/dsa/microchip/ksz_common.c |  35 +++++++++
 drivers/net/phy/micrel.c               | 102 ++++++++++++++++++++++++-
 drivers/net/phy/phy.c                  |   6 ++
 include/linux/phy.h                    |   5 ++
 4 files changed, 147 insertions(+), 1 deletion(-)

-- 
2.30.2

