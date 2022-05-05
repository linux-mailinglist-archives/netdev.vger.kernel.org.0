Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C24E151B7FB
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 08:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244503AbiEEGhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 02:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244473AbiEEGhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 02:37:11 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730D218E08
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 23:33:33 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nmV3B-00047P-E5; Thu, 05 May 2022 08:33:21 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nmV3A-000SRp-VC; Thu, 05 May 2022 08:33:19 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nmV38-001F5i-Pf; Thu, 05 May 2022 08:33:18 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v3 0/7] add ti dp83td510 support
Date:   Thu,  5 May 2022 08:33:11 +0200
Message-Id: <20220505063318.296280-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

changes v3:
- export reusable code snippets and make use of it in the dp83td510
  driver

changes v2:
- rewrite the driver reduce usage of common code and to reduce amount of
  quirks.
- add genphy_c45_baset1_an_config_aneg fix

Oleksij Rempel (7):
  net: phy: genphy_c45_baset1_an_config_aneg: do no set unknown
    configuration
  net: phy: introduce genphy_c45_pma_base1_setup_master_slave()
  net: phy: genphy_c45_pma_base1_setup_master_slave: do no set unknown
    configuration
  net: phy: introduce genphy_c45_pma_baset1_read_master_slave()
  net: phy: genphy_c45_pma_baset1_read_master_slave: read actual
    configuration
  net: phy: export genphy_c45_baset1_read_status()
  net: phy: dp83td510: Add support for the DP83TD510 Ethernet PHY

 drivers/net/phy/Kconfig     |   6 ++
 drivers/net/phy/Makefile    |   1 +
 drivers/net/phy/dp83td510.c | 210 ++++++++++++++++++++++++++++++++++++
 drivers/net/phy/phy-c45.c   |  93 +++++++++++-----
 include/linux/phy.h         |   3 +
 5 files changed, 286 insertions(+), 27 deletions(-)
 create mode 100644 drivers/net/phy/dp83td510.c

-- 
2.30.2

