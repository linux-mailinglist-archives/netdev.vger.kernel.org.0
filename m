Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAAC755F040
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 23:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiF1VRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 17:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbiF1VQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 17:16:50 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D8FD3192A
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 14:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NyE8w3edwjwlV36rhpQI0Sz3ptBDM17y7YTiMNDQWDc=; b=MNt0tptleZITR1wXktfokCL4xY
        p0IRE5clZ80y4XxBNVYNT0y2g1ifGd2N7jM69w6ctrlJPNLpOVnwEy7oajcnqJobBLxhaypP8UZ3f
        kMLu7CaJxrj9wh6AwROXGZ6Kfu9CKPJCrslCfeeHMRrjcNiNNojFHq3eFA+QPSreRDk5Ip2qKkH0F
        jCy+3YGFajDQCeC2GwuJKnNNrjI4b//+XokhG6SN8qC28U3DcbDd6wcErJU6XkE/v4/9tx+E/LKP7
        R1YguZg5jxgdqRyETVxgavmWD2wjXGAtDiTPbYi7aaQ6W2pG72owg/2X+scjGeA2y2wqD9S9ywZ7e
        Kuct/lNg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33078)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o6IZM-000276-Q9; Tue, 28 Jun 2022 22:16:24 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o6IZF-0005DW-Tk; Tue, 28 Jun 2022 22:16:17 +0100
Date:   Tue, 28 Jun 2022 22:16:17 +0100
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
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH RFC net-next 0/4] net: dsa: always use phylink
Message-ID: <YrtvoRhUK+4BneYC@shell.armlinux.org.uk>
References: <YrWi5oBFn7vR15BH@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrWi5oBFn7vR15BH@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 12:41:26PM +0100, Russell King (Oracle) wrote:
> Hi,
> 
> Currently, the core DSA code conditionally uses phylink for CPU and DSA
> ports depending on whether the firmware specifies a fixed-link or a PHY.
> If either of these are specified, then phylink is used for these ports,
> otherwise phylink is not, and we rely on the DSA drivers to "do the
> right thing". However, this detail is not mentioned in the DT binding,
> but Andrew has said that this behaviour has always something that DSA
> wants.
> 
> mv88e6xxx has had support for this for a long time with its "SPEED_MAX"
> thing, which I recently reworked to make use of the mac_capabilities in
> preparation to solving this more fully.
> 
> This series is an experiment to solve this properly, and it does this
> in two steps.
> 
> The first step consists of the first two patches. Phylink needs to
> know the PHY interface mode that is being used so it can (a) pass the
> right mode into the MAC/PCS etc and (b) know the properties of the
> link and therefore which speeds can be supported across it.
> 
> In order to achieve this, the DSA phylink_get_caps() method has an
> extra argument added to it so that DSA drivers can report the
> interface mode that they will be using for this port back to the core
> DSA code, thereby allowing phylink to be initialised with the correct
> interface mode.
> 
> Note that this can only be used for CPU and DSA ports as "user" ports
> need a different behaviour - they rely on getting the interface mode
> from phylib, which will only happen if phylink is initialised with
> PHY_INTERFACE_MODE_NA. Unfortunately, changing this behaviour is likely
> to cause widespread regressions.
> 
> Obvious questions:
> 1. Should phylink_get_caps() be augmented in this way, or should it be
>    a separate method?
> 
> 2. DSA has traditionally used "interface mode for the maximum supported
>    speed on this port" where the interface mode is programmable (via
>    its internal port_max_speed_mode() method) but this is only present
>    for a few of the sub-drivers. Is reporting the current interface
>    mode correct where this method is not implemented?
> 
> The second step is to introduce a function that allows phylink to be
> reconfigured after creation time to operate at max-speed fixed-link
> mode for the PHY interface mode, also using the MAC capabilities to
> determine the speed and duplex mode we should be using.
> 
> Obvious questions:
> 1. Should we be allowing half-duplex for this?
> 2. If we do allow half-duplex, should we prefer fastest speed over
>    duplex setting, or should we prefer fastest full-duplex speed
>    over any half-duplex?
> 3. How do we sanely switch DSA from its current behaviour to always
>    using phylink for these ports without breakage - this is the
>    difficult one, because it's not obvious which drivers have been
>    coded to either work around this quirk of the DSA implementation.
>    For example, if we start forcing the link down before calling
>    dsa_port_phylink_create(), and we then fail to set max-fixed-link,
>    then the CPU/DSA port is going to fail, and we're going to have
>    lots of regressions.
> 
> Please look at the patches and make suggestions on how we can proceed
> to clean up this quirk of DSA.

An alternative idea has been put forward by Marek on how to solve this
without involving changes to DSA drivers, but everyone would have to
fill in the supported_interfaces and mac_capabilities.

The suggestion is that DSA calls phylink_set_max_fixed_link(), which
looks at the above two fields, and finds an interface which gives the
maximum link speed if the interface mode has not been specified. In
other words, something like this for phylink_set_max_fixed_link():

        interface = pl->link_interface;
        if (interface != PHY_INTERFACE_MODE_NA) {
                /* Get the speed/duplex capabilities and reduce according to the
                 * specified interface mode.
                 */
                caps = pl->config->mac_capabilities;
                caps &= phylink_interface_to_caps(interface);
        } else {
                interfaces = pl->config->supported_interfaces;
                max_caps = 0;

                /* Find the supported interface mode which gives the maximum
                 * speed.
                 */
                for (intf = 0; intf < PHY_INTERFACE_MODE_MAX; intf++) {
                        if (test_bit(intf, interfaces)) {
                                caps = pl->config->mac_capabilities;
                                caps &= phylink_interface_to_caps(intf);
                                if (caps > max_caps) {
                                        max_caps = caps;
                                        interface = intf;
                                }
                        }
                }

                caps = max_caps;
        }

        caps &= ~(MAC_SYM_PAUSE | MAC_ASYM_PAUSE);

        /* If there are no capabilities, then we are not using this default. */
        if (!caps)
                return -EINVAL;

        /* Decode to fastest speed and duplex */
        duplex = DUPLEX_UNKNOWN;
        speed = SPEED_UNKNOWN;
        for (i = 0; i < ARRAY_SIZE(phylink_caps_speeds); i++) {
                if (caps & phylink_caps_speeds[i].fd_mask) {
                        duplex = DUPLEX_FULL;
                        speed = phylink_caps_speeds[i].speed;
                        break;
                } else if (caps & phylink_caps_speeds[i].hd_mask) {
                        duplex = DUPLEX_HALF;
                        speed = phylink_caps_speeds[i].speed;
                        break;
                }
        }

        /* If we didn't find anything, bail. */
        if (speed == SPEED_UNKNOWN)
                return -EINVAL;

        pl->link_interface = interface;
        pl->link_config.interface = interface;
        pl->link_config.speed = speed;
        pl->link_config.duplex = duplex;
        pl->link_config.link = 1;
        pl->cfg_link_an_mode = MLO_AN_FIXED;
        pl->cur_link_an_mode = MLO_AN_FIXED;

This would have the effect of selecting the first interface mode in
numerical order that gives us the fastest link speed.

I should point out that if a DSA port can be programmed in software to
support both SGMII and 1000baseX, this will end up selecting SGMII
irrespective of what the hardware was wire-strapped to and how it was
initially configured. Do we believe that would be acceptable?

Some comments would be really useful on this.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
