Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB32168F2AB
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 17:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbjBHQCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 11:02:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBHQCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 11:02:44 -0500
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6E34ABC9;
        Wed,  8 Feb 2023 08:02:42 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 6A87EE0005;
        Wed,  8 Feb 2023 16:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675872161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=4nUYbtsLt+veEgQI6xwynluDHXKugHNm7VF61na3Lpc=;
        b=YE08zyF3kO1ggQH4YJyBKDNoLsqq4GntatCIgS8Z2Eag+91x+7+pA3PjlKrqF++G8cG+Gf
        Bc6Yza/BKH7rLI+9Qxs0A8dgPrmjjt+jevIHWPk7rtQMP6rl++bO2FM3uqY1nkvn5o4D8H
        C21q1HVPjxTssikc3OXj2MU2k+TgYE4FlSeZoJQyEeN2Y88syb7doWrZhWlkBk7gKQ8HqP
        BbN8F9171lIjHEA+0/Sk3HlneDkYTLeiamZR5xMS2YXOXerymSouFjf3shYMHbhse84e4K
        KVKPeGsn3Ud6CGID/qbn90/0D5Z0RDpJJJsHtiRIpLEVGVtOF1GgztOT+/nRfg==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Arun Ramadoss <Arun.Ramadoss@microchip.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] net: dsa: rzn1-a5psw: add supoport for vlan and .port_bridge_flags
Date:   Wed,  8 Feb 2023 17:04:50 +0100
Message-Id: <20230208160453.325783-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While adding support for VLAN, bridge_vlan_unaware.sh and
bridge_vlan_aware.sh were executed and requires .port_bridge_flags
to disable flooding on some specific port. Thus, this series adds
both vlan support and .port_bridge_flags.

----
V2:
 - Fixed a few formatting errors
 - Add .port_bridge_flags implementation

Clément Léger (3):
  net: dsa: rzn1-a5psw: use a5psw_reg_rmw() to modify flooding
    resolution
  net: dsa: rzn1-a5psw: add support for .port_bridge_flags
  net: dsa: rzn1-a5psw: add vlan support

 drivers/net/dsa/rzn1_a5psw.c | 224 ++++++++++++++++++++++++++++++++++-
 drivers/net/dsa/rzn1_a5psw.h |   8 +-
 2 files changed, 223 insertions(+), 9 deletions(-)

-- 
2.39.0

