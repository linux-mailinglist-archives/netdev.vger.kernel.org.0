Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDE557CE11
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 16:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiGUOqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 10:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiGUOqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 10:46:50 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11946E2CE;
        Thu, 21 Jul 2022 07:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=bBJongGPmQbNDPL1C13va/wJFI4Dmus5YndL1Jp9674=; b=iEv354gEGUTIPBDIt6H6KZ701+
        gc5HiO3BSkjGhHrYyOBz0V0OvNeSrEHgSvOtLOVIwHsigLaMfLoUEutM4sYBkDoT3d4m2vsFsZBp0
        uAtJGMnq4Jq3a7EzCl0G8u4YpWzHRwdc29CFntUT62igGob0juaJSTqpDCFM0Rwd16e8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oEXRV-00B36m-L5; Thu, 21 Jul 2022 16:46:21 +0200
Date:   Thu, 21 Jul 2022 16:46:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
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
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH net-next 3/6] net: dsa: add support for retrieving the
 interface mode
Message-ID: <YtlmvWzrX/2YebGK@lunn.ch>
References: <20220715172444.yins4kb2b6b35aql@skbuf>
 <YtHcpf4otJQS9hTO@shell.armlinux.org.uk>
 <20220715222348.okmeyd55o5u3gkyi@skbuf>
 <YtHw0O5NB6kGkdwV@shell.armlinux.org.uk>
 <20220716105711.bjsh763smf6bfjy2@skbuf>
 <YtKdcxupT+INVAhR@shell.armlinux.org.uk>
 <20220716123608.chdzbvpinso546oh@skbuf>
 <YtUec3GTWTC59sky@shell.armlinux.org.uk>
 <20220720224447.ygoto4av7odsy2tj@skbuf>
 <20220721134618.axq3hmtckrumpoy6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721134618.axq3hmtckrumpoy6@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On the other hand I found arm64/boot/dts/marvell/cn9130-crb.dtsi, where
> the switch, a "marvell,mv88e6190"-compatible (can't determine going just
> by that what it actually is) has this:
> 
> 			port@a {
> 				reg = <10>;
> 				label = "cpu";
> 				ethernet = <&cp0_eth0>;
> 			};

Both CPU and DSA ports default to their maximum speed, if nothing else
is specified. If this is a 6393X, port 10 can do 10Gbps, and that is
how the port will be configured by the driver. It is undefined how it
actually implement this maximum speed, if there are multiple choices,
if in band is enabled or not etc. This is historical, the first
mv88e6xxx devices had a mixture of Fast and 1G ethernet interfaces,
and it was simply to choosing between MII and GMII. The platform data
at that time had no way to express link information, and this simple
default mechanism was enough to get boards of the time working.

> To illustrate how odd the situation is, I am able to follow the phandle
> to the CPU port and find a comment that it's a 88E6393X, and that the
> CPU port uses managed = "in-band-status":
> 
> &cp0_eth0 {
> 	/* This port is connected to 88E6393X switch */
> 	status = "okay";
> 	phy-mode = "10gbase-r";
> 	managed = "in-band-status";
> 	phys = <&cp0_comphy4 0>;
> };
> 
> Open question: is it sane to even do what we're trying here, to create a
> fixed-link for port@a (which makes the phylink instance use MLO_AN_FIXED)
> when &cp0_eth0 uses MLO_AN_INBAND? My simple mind thinks that if all
> involved drivers were to behave correctly

Define 'correctly', given that some of these drivers and devices have
been around much longer than device tree, etc.

     Andrew

