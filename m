Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED0656A827
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 18:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235510AbiGGQd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 12:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235202AbiGGQd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 12:33:28 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056A41114
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 09:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=W1luyxt6XqoqNG1cOwcZcNryytjX2axh+qChWLTs2RA=; b=N/UN3+bi39NJCUQzYPqEOzHjMx
        a7WrcFu5Z7e+Q940v0ahh8EWaOvTIsTHAa15FPHTOTXxepvjmlI07CLFq1e1CacbY8j6u4h4G3K73
        R4HHmqkSMA2z/TcbA8S1qN0FkFedfGFm5nce6pv4RTUD7PnHIEZa5QGzJHQtKriivsSNAZw7qy0aK
        n1LfOowZaH/NxnMDlhJJG6GeHKUGBQx02rj92fSihJSd2KdHWUGhnqSrXnL3KGGY+wakFbj2gV2Fo
        v9DYTp3u2PPoxW21IU4DzFUB0Zp5d4N138/YyAki16pmNYuMCHrtRGqcZBYr8fHUHDTvh2TMpHgvi
        agbgIp0g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33230)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o9UR4-00047L-Je; Thu, 07 Jul 2022 17:33:02 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o9UQz-0005PK-4Z; Thu, 07 Jul 2022 17:32:57 +0100
Date:   Thu, 7 Jul 2022 17:32:57 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
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
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH RFC net-next 5/5] net: dsa: always use phylink for CPU
 and DSA ports
Message-ID: <YscKuTXeXFX0tCap@shell.armlinux.org.uk>
References: <YsQIjC7UpcGWJovx@shell.armlinux.org.uk>
 <E1o8fA7-0059aO-K8@rmk-PC.armlinux.org.uk>
 <20220706102621.hfubvn3wa6wlw735@skbuf>
 <Ysa85mJIUfo5m4dJ@shell.armlinux.org.uk>
 <20220707154303.236xaeape7isracw@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707154303.236xaeape7isracw@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 07, 2022 at 06:43:03PM +0300, Vladimir Oltean wrote:
> On Thu, Jul 07, 2022 at 12:00:54PM +0100, Russell King (Oracle) wrote:
> > More importantly, we need your input on Ocelot, which you are listed as
> > a maintainer for, and Ocelot is the only DSA driver that does stuff
> > differently (due to the rate adapting PCS). It doesn't set
> > mac_capabilities, and therefore phylink_set_max_fixed_link() will not
> > work here.
> > 
> > Has Ocelot ever made use of this DSA feature where, when nothing is
> > specified for a CPU or DSA port, we use an effective fixed-link setup
> > with an interface mode that gives the highest speed? Or does this not
> > apply to this DSA driver?
> > 
> > Thanks.
> 
> I'm fine with both the ocelot and sja1105 drivers.
> 
> The ocelot driver has 3 users:
> 
> - felix_vsc9959 (arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi) on NXP
>   LS1028A, where the CPU ports have and have always had a fixed-link
>   node in the SoC dtsi. LS1028A based boards should include the SoC
>   dtsi. If other board DT writers don't do that or if they delete the
>   fixed-link node from the CPU ports, that's not my problem and I don't
>   really want to help them.
> 
> - seville_vsc9953 (arch/powerpc/boot/dts/fsl/t1040si-post.dtsi) on NXP
>   T1040. Same thing, embedded switch, not my fault if the fixed-link
>   disappears from the SoC dtsi.

Great, so I'll mark ocelot is safe.

> - Colin Foster's SPI-controlled VSC7512 (still downstream). He has an
>   Ethernet cable connecting the CPU port to a Beaglebone Black, so he
>   has a phy-handle on the CPU port, so definitely not nothing. I believe
>   his work hasn't made it to production in any case, so enforcing
>   validation now shouldn't bother him too much if at all.

Ok, thanks.

> As for sja1105, there is DT validation that checks for the presence of
> all required properties in sja1105_parse_ports_node().

Looking at those, it requires all of:

- a phy mode to be specified (as determined by of_get_phy_mode())
- a phy-handle or of_phy_is_fixed_link() to return true

otherwise it errors out.

> There is some DT validation in felix_parse_ports_node() too, but it
> doesn't check that all specifiers that phylink might use are there.

Phylink (correction, fwnode_get_phy_node() which is not part of phylink
anymore) will look for phy-handle, phy, or phy-device. This is I don't
see that there's any incompatibility between what the driver is doing
and what phylink does.

If there's a fixed-link property, then sja1105_parse_ports_node() is
happy, and so will phylink. If there's a phy-handle, the same is true.
If there's a "phy" or "phy-device" then sja1105_parse_ports_node()
errors out. That's completely fine.

"phy" and "phy-device" are the backwards compatibility for DT - I
believe one of them is the ePAPR specified property that we in Linux
have decided to only fall back on if there's not our more modern
"phy-handle" property.

It seems We have a lot of users of "phy" in DT today, so we can't drop
that from generic code such as phylink, but I haven't found any users
of "phy-device".

> I'd really like to add some validation before I gain any involuntary
> users, but all open-coded constructs I can come up with are clumsy.
> What would you suggest, if I explicitly don't want to rely on
> context-specific phylink interpretation of empty OF nodes, and rather
> error out?

So I also don't see a problem - sja1105 rejects DTs that fail to
describe a port using at least one of a phy-handle, a fixed-link, or
a managed in-band link, and I don't think it needs to do further
validation, certainly not for the phy describing properties that
the kernel has chosen to deprecate for new implementations.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
