Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02F885764EA
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 18:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbiGOQBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 12:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233196AbiGOQBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 12:01:36 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62C374E1E;
        Fri, 15 Jul 2022 09:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gA3XVimnX7f3s6KgiLlFK+Po6cdJBSVv58Yny5mkLeQ=; b=g65/fd96gMfMyEVlEnBM0l5zaS
        I8j5swFEkAOUfVQgZd+936F4JHD28LjuG+g3eI+6VjNyCUz7vfuRdCQfplCtK34FM+EK8L3UxskA+
        qHR7vSNgLT/CODJlCB/TcIz0wxA5FOd1jT2FK7+lX8CeQvK1jtAaqAt4jErTzog8BGjmrEcLdnKaV
        Epbs313LqhkOjOz8PsRNN0ImTpyowJf2L7igwOcBxAhZcjV39uVx1PanTolqfobZ5uyRTFAmn9Zr/
        aczV3p9qTdb58iQuv1WDVITmuEzrDdqu2fyrPL4GYJ6pNLsBlCIf2WNwa4YEHta3PFoDDOxYFIERQ
        XlN/Wl4Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33358)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oCNkZ-0007C7-It; Fri, 15 Jul 2022 17:01:07 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oCNkR-0007g6-88; Fri, 15 Jul 2022 17:00:59 +0100
Date:   Fri, 15 Jul 2022 17:00:59 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Marek =?us-ascii?B?PT9pc28tODg1OS0xP1E/QmVoPUZBbj89?= 
        <kabel@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [PATCH net-next 0/6] net: dsa: always use phylink
Message-ID: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is a re-hash of the previous RFC series, this time using the
suggestion from Vladimir to create a swnode based fixed-link
specifier.

Most of the changes are to DSA and phylink code from the previous
series. I've tested on my Clearfog (which has just one Marvell DSA
switch) and it works there - also tested without the fixed-link
specified in DT.

 drivers/base/swnode.c                  |  14 ++-
 drivers/net/dsa/b53/b53_common.c       |   3 +-
 drivers/net/dsa/bcm_sf2.c              |   3 +-
 drivers/net/dsa/hirschmann/hellcreek.c |   3 +-
 drivers/net/dsa/lantiq_gswip.c         |   6 +-
 drivers/net/dsa/microchip/ksz_common.c |   3 +-
 drivers/net/dsa/mt7530.c               |   3 +-
 drivers/net/dsa/mv88e6xxx/chip.c       | 134 ++++++++++++-------------
 drivers/net/dsa/mv88e6xxx/chip.h       |   6 +-
 drivers/net/dsa/mv88e6xxx/port.c       |  32 ------
 drivers/net/dsa/mv88e6xxx/port.h       |   5 -
 drivers/net/dsa/ocelot/felix.c         |   3 +-
 drivers/net/dsa/qca/ar9331.c           |   3 +-
 drivers/net/dsa/qca8k.c                |   3 +-
 drivers/net/dsa/realtek/rtl8365mb.c    |   3 +-
 drivers/net/dsa/sja1105/sja1105_main.c |   3 +-
 drivers/net/dsa/xrs700x/xrs700x.c      |   3 +-
 drivers/net/phy/phylink.c              |  30 ++++--
 include/linux/phylink.h                |   1 +
 include/linux/property.h               |   4 +
 include/net/dsa.h                      |   3 +-
 net/dsa/port.c                         | 175 +++++++++++++++++++++++++++++----
 22 files changed, 290 insertions(+), 153 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
