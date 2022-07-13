Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85551573861
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 16:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236543AbiGMOH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 10:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236511AbiGMOHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 10:07:50 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F39E326D2;
        Wed, 13 Jul 2022 07:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gA3XVimnX7f3s6KgiLlFK+Po6cdJBSVv58Yny5mkLeQ=; b=DeAZz/u08LyY66av49LSBj404F
        Z1pv+JxyNxpbyQNSBtLumt6bq99DUgUOvJELIyRwoLQEXcthrEo0yZ9nVAAtX1tKSgxuH2dMmB+jA
        RU4NQAi+mSAy8faMSx/seFqS6ytNIgYr2tQx/OJxiMNdEA0fckOScgYQZCR7QV5N+Ql4iLxVW7u5t
        YVEhA4gpDss/Fp1O9Yy6+X/53bDV+oM4Zinq344vPFpPcwUDc86YHQnhaNBfwgjreihJ0oQO8qC3V
        BEx2OXyizzoqih3kUFui4oDFzaID0qEjlas5NmT78Mb2+auyWkNQYZzUSmWHX1O4ueEJ9TKBzA6LP
        YXum0aZw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33316)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oBd0u-0004Zy-Vu; Wed, 13 Jul 2022 15:06:53 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oBd0p-0005gm-9r; Wed, 13 Jul 2022 15:06:47 +0100
Date:   Wed, 13 Jul 2022 15:06:47 +0100
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
Subject: [PATCH RFC v2 0/6] net: dsa: always use phylink
Message-ID: <Ys7RdzGgHbYiPyB1@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
