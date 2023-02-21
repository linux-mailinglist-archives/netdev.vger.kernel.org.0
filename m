Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBB169DA3D
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 06:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbjBUFDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 00:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbjBUFDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 00:03:52 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05B618AAC
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 21:03:51 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pUKoU-0002zs-4E; Tue, 21 Feb 2023 06:03:38 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pUKoR-006PyO-8y; Tue, 21 Feb 2023 06:03:36 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pUKoR-002QNj-O0; Tue, 21 Feb 2023 06:03:35 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next v2 0/4] net: phy: EEE fixes
Date:   Tue, 21 Feb 2023 06:03:30 +0100
Message-Id: <20230221050334.578012-1-o.rempel@pengutronix.de>
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
- restore previous ethtool set logic for the case where advertisements
  are not provided by user space.
- use ethtool_convert_legacy_u32_to_link_mode() where possible
- genphy_c45_an_config_eee_aneg(): move adv initialization in to the if
  scope.

Different EEE related fixes.

Oleksij Rempel (4):
  net: phy: c45: use "supported_eee" instead of supported for access
    validation
  net: phy: c45: add genphy_c45_an_config_eee_aneg() function
  net: phy: do not force EEE support
  net: phy: c45: genphy_c45_ethtool_set_eee: validate EEE link modes

 drivers/net/phy/phy-c45.c    | 55 ++++++++++++++++++++++++++++--------
 drivers/net/phy/phy_device.c | 21 +++++++++++++-
 include/linux/phy.h          |  6 ++++
 3 files changed, 69 insertions(+), 13 deletions(-)

-- 
2.30.2

