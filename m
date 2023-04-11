Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7BD6DE272
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 19:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjDKRZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 13:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbjDKRZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 13:25:14 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472941A7
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 10:25:12 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pmHjp-0001yl-9Q; Tue, 11 Apr 2023 19:25:01 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pmHjm-00AYPs-TP; Tue, 11 Apr 2023 19:24:58 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pmHjm-00CbDx-7V; Tue, 11 Apr 2023 19:24:58 +0200
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
Subject: [PATCH net-next v1 0/2] net: dsa: microchip: Rework ksz_prmw8 and add partial ACL support
Date:   Tue, 11 Apr 2023 19:24:53 +0200
Message-Id: <20230411172456.3003003-1-o.rempel@pengutronix.de>
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

This patch set introduces a rework of the ksz_prmw8 function and adds
partial Access Control List (ACL) support for the ksz9477 family of
switches in the net: dsa: microchip subsystem. The changes provide
support for layer 2 matching and prioritization of matched packets. The
second patch utilizes the refactored ksz_prmw8 function.

Oleksij Rempel (2):
  net: dsa: microchip: rework ksz_prmw8
  net: dsa: microchip: Add partial ACL support for ksz9477 switches

 drivers/net/dsa/microchip/Makefile      |   2 +-
 drivers/net/dsa/microchip/ksz9477.c     |   7 +
 drivers/net/dsa/microchip/ksz9477.h     |   7 +
 drivers/net/dsa/microchip/ksz9477_acl.c | 950 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.c  |  40 +
 drivers/net/dsa/microchip/ksz_common.h  |   8 +-
 6 files changed, 1009 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/dsa/microchip/ksz9477_acl.c

-- 
2.39.2

