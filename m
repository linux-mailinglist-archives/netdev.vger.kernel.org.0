Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72F2856667D
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 11:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbiGEJrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 05:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbiGEJrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 05:47:21 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A70D6C
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 02:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=AuCnLo54ZsmJ5hRJDjfy44FX8jyKN1XHhtkIypP2GEE=; b=oSm9pn99HriCqZInk3t+tzo2vH
        Xuks7g/lH6oniIewRCkYcaxDzKxmIQZW+bUijxtjkNsQNTDm8LPtxLPmZsm6EqV1xBAAkJrXTZV0X
        n9kE2hkiUHyjfBehtG36H7b+01u+TKTsAX1OhP0SxfUIuGzTLJiRYvUeexPLevhhZQ/QRXRfEgbWA
        knitq+vy6I3NKgD8EDpi+cpIPqZ4t+wMxLXBbG755sli8ddqfktVoMJvtStERhx0FX5akC9su0FEo
        6m+4k2f0nDWWeM2nnd8DdRTZT5C1G4o6nXHF8OjTlMr8BUbnnxmwxUag9LsqrT7jwnuHWFCocVSZl
        aDIUGcnQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33184)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o8f92-00012f-9Z; Tue, 05 Jul 2022 10:47:00 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o8f8u-0003En-Sm; Tue, 05 Jul 2022 10:46:52 +0100
Date:   Tue, 5 Jul 2022 10:46:52 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
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
        Woojung Huh <woojung.huh@microchip.com>
Subject: [PATCH RFC net-next v2 0/5] net: dsa: always use phylink
Message-ID: <YsQIjC7UpcGWJovx@shell.armlinux.org.uk>
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

A new revision of the series which incorporates changes that Marek
suggested. Specifically, the changes are:

1. Patch 2 - use the phylink_get_caps method in mv88e6xxx to get the
   default interface rather than re-using port_max_speed_mode()

2. Patch 4 - if no default interface is provided, use the supported
   interface mask to search for the first interface that gives the
   fastest speed.

3. Patch 5 - now also removes the port_max_speed_mode() method

 drivers/net/dsa/b53/b53_common.c       |   3 +-
 drivers/net/dsa/bcm_sf2.c              |   3 +-
 drivers/net/dsa/hirschmann/hellcreek.c |   3 +-
 drivers/net/dsa/lantiq_gswip.c         |   6 +-
 drivers/net/dsa/microchip/ksz_common.c |   3 +-
 drivers/net/dsa/mt7530.c               |   3 +-
 drivers/net/dsa/mv88e6xxx/chip.c       | 136 +++++++++++++++---------------
 drivers/net/dsa/mv88e6xxx/chip.h       |   6 +-
 drivers/net/dsa/mv88e6xxx/port.c       |  32 -------
 drivers/net/dsa/mv88e6xxx/port.h       |   5 --
 drivers/net/dsa/ocelot/felix.c         |   3 +-
 drivers/net/dsa/qca/ar9331.c           |   3 +-
 drivers/net/dsa/qca8k.c                |   3 +-
 drivers/net/dsa/realtek/rtl8365mb.c    |   3 +-
 drivers/net/dsa/sja1105/sja1105_main.c |   3 +-
 drivers/net/dsa/xrs700x/xrs700x.c      |   3 +-
 drivers/net/phy/phylink.c              | 150 ++++++++++++++++++++++++++++++---
 include/linux/phylink.h                |   5 ++
 include/net/dsa.h                      |   3 +-
 net/dsa/port.c                         |  47 +++++++----
 20 files changed, 270 insertions(+), 153 deletions(-)

On Wed, Jun 29, 2022 at 01:49:57PM +0100, Russell King (Oracle) wrote:
> Mostly the same as the previous RFC, except:
> 
> 1) incldues the phylink_validate_mask_caps() function
> 2) has Marek's idea of searching the supported_interfaces bitmap for the
>    fastest interface we can use
> 3) includes a final patch to add a print which will be useful to hear
>    from people testing it.
> 
> Some of the questions from the original RFC remain though, so I've
> included that text below. I'm guessing as they remain unanswered that
> no one has any opinions on them?
> 
>  drivers/net/dsa/b53/b53_common.c       |   3 +-
>  drivers/net/dsa/bcm_sf2.c              |   3 +-
>  drivers/net/dsa/hirschmann/hellcreek.c |   3 +-
>  drivers/net/dsa/lantiq_gswip.c         |   6 +-
>  drivers/net/dsa/microchip/ksz_common.c |   3 +-
>  drivers/net/dsa/mt7530.c               |   3 +-
>  drivers/net/dsa/mv88e6xxx/chip.c       |  53 ++++--------
>  drivers/net/dsa/ocelot/felix.c         |   3 +-
>  drivers/net/dsa/qca/ar9331.c           |   3 +-
>  drivers/net/dsa/qca8k.c                |   3 +-
>  drivers/net/dsa/realtek/rtl8365mb.c    |   3 +-
>  drivers/net/dsa/sja1105/sja1105_main.c |   3 +-
>  drivers/net/dsa/xrs700x/xrs700x.c      |   3 +-
>  drivers/net/phy/phylink.c              | 148 ++++++++++++++++++++++++++++++---
>  include/linux/phylink.h                |   5 ++
>  include/net/dsa.h                      |   3 +-
>  net/dsa/port.c                         |  47 +++++++----
>  17 files changed, 215 insertions(+), 80 deletions(-)
> 
> On Fri, Jun 24, 2022 at 12:41:26PM +0100, Russell King (Oracle) wrote:
> > Hi,
> > 
> > Currently, the core DSA code conditionally uses phylink for CPU and DSA
> > ports depending on whether the firmware specifies a fixed-link or a PHY.
> > If either of these are specified, then phylink is used for these ports,
> > otherwise phylink is not, and we rely on the DSA drivers to "do the
> > right thing". However, this detail is not mentioned in the DT binding,
> > but Andrew has said that this behaviour has always something that DSA
> > wants.
> > 
> > mv88e6xxx has had support for this for a long time with its "SPEED_MAX"
> > thing, which I recently reworked to make use of the mac_capabilities in
> > preparation to solving this more fully.
> > 
> > This series is an experiment to solve this properly, and it does this
> > in two steps.
> > 
> > The first step consists of the first two patches. Phylink needs to
> > know the PHY interface mode that is being used so it can (a) pass the
> > right mode into the MAC/PCS etc and (b) know the properties of the
> > link and therefore which speeds can be supported across it.
> > 
> > In order to achieve this, the DSA phylink_get_caps() method has an
> > extra argument added to it so that DSA drivers can report the
> > interface mode that they will be using for this port back to the core
> > DSA code, thereby allowing phylink to be initialised with the correct
> > interface mode.
> > 
> > Note that this can only be used for CPU and DSA ports as "user" ports
> > need a different behaviour - they rely on getting the interface mode
> > from phylib, which will only happen if phylink is initialised with
> > PHY_INTERFACE_MODE_NA. Unfortunately, changing this behaviour is likely
> > to cause widespread regressions.
> > 
> > Obvious questions:
> > 1. Should phylink_get_caps() be augmented in this way, or should it be
> >    a separate method?
> > 
> > 2. DSA has traditionally used "interface mode for the maximum supported
> >    speed on this port" where the interface mode is programmable (via
> >    its internal port_max_speed_mode() method) but this is only present
> >    for a few of the sub-drivers. Is reporting the current interface
> >    mode correct where this method is not implemented?
> > 
> > The second step is to introduce a function that allows phylink to be
> > reconfigured after creation time to operate at max-speed fixed-link
> > mode for the PHY interface mode, also using the MAC capabilities to
> > determine the speed and duplex mode we should be using.
> > 
> > Obvious questions:
> > 1. Should we be allowing half-duplex for this?
> > 2. If we do allow half-duplex, should we prefer fastest speed over
> >    duplex setting, or should we prefer fastest full-duplex speed
> >    over any half-duplex?
> > 3. How do we sanely switch DSA from its current behaviour to always
> >    using phylink for these ports without breakage - this is the
> >    difficult one, because it's not obvious which drivers have been
> >    coded to either work around this quirk of the DSA implementation.
> >    For example, if we start forcing the link down before calling
> >    dsa_port_phylink_create(), and we then fail to set max-fixed-link,
> >    then the CPU/DSA port is going to fail, and we're going to have
> >    lots of regressions.
> > 
> > Please look at the patches and make suggestions on how we can proceed
> > to clean up this quirk of DSA.
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
