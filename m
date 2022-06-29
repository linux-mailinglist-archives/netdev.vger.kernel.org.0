Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61FDA560078
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 14:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233427AbiF2Mvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 08:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbiF2Mvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 08:51:39 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DD933344
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 05:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=KWK8sKKLFR+68SMkB5FGReiHrYFC6ByuHPtr0wPhHIU=; b=tN6QLzrLD0PGySaj1xXFrRUHrE
        S5luWpg906s9a6dxoMT6V/eTdga40ErgDq+GWMpJq1u7ZXDimDavWTEp15UDL0rVkSlIfjUYP4Tnw
        1o5qYRq4n6QXy9XAxCS1GLv5TcC1M2EI1yTG5bEFlGscZh/klMHDCBFcw5DybKc9sfwPBtSJbCDkL
        xT/dpF0jpSASeA7D5Yj+DF3pKXVAZi7h4AlJ8+pFG/N0h1ASIwSdMuogin6MNip+XnJsXH+3nagd0
        e+L2/FUyN/GkZeMseoUKJJDZZWR0Dk+7nwGHqdnc1srM2rajZjYWmRxfm9uepg7pqGYbwCrOwLp8b
        DphyPHGw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:35712 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1o6XAG-00036d-LJ; Wed, 29 Jun 2022 13:51:28 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1o6XAF-004pVi-Ue; Wed, 29 Jun 2022 13:51:27 +0100
In-Reply-To: <YrxKdVmBzeMsVjsH@shell.armlinux.org.uk>
References: <YrxKdVmBzeMsVjsH@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Alvin __ipraga" <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: [PATCH RFC net-next 2/6] net: dsa: mv88e6xxx: report the default
 interface mode for the port
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1o6XAF-004pVi-Ue@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 29 Jun 2022 13:51:27 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report the maximum speed interface mode for the port, or if we don't
have that information, the hardware configured interface mode for
the port.

This allows phylink to know which interface mode CPU and DSA ports
are operating, which will be necessary when we want to select the
maximum speed for the port (required for such ports without a PHY or
fixed-link specified in firmware.)

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index f98be98551ef..1c6b4b00d58d 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -823,6 +823,7 @@ static void mv88e6xxx_get_caps(struct dsa_switch *ds, int port,
 			       phy_interface_t *default_interface)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
+	u8 cmode = chip->ports[port].cmode;
 
 	chip->info->ops->phylink_get_caps(chip, port, config);
 
@@ -830,6 +831,14 @@ static void mv88e6xxx_get_caps(struct dsa_switch *ds, int port,
 	if (mv88e6xxx_phy_is_internal(ds, port))
 		__set_bit(PHY_INTERFACE_MODE_GMII,
 			  config->supported_interfaces);
+
+	if (chip->info->ops->port_max_speed_mode)
+		*default_interface = chip->info->ops->port_max_speed_mode(port);
+	else if (cmode < ARRAY_SIZE(mv88e6xxx_phy_interface_modes) &&
+		 mv88e6xxx_phy_interface_modes[cmode])
+		*default_interface = mv88e6xxx_phy_interface_modes[cmode];
+	else if (cmode == MV88E6XXX_PORT_STS_CMODE_RGMII)
+		*default_interface = PHY_INTERFACE_MODE_RGMII;
 }
 
 static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
-- 
2.30.2

