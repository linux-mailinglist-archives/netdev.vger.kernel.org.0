Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C83657E93C
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 23:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235591AbiGVVyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 17:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiGVVyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 17:54:23 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C33F2A43B;
        Fri, 22 Jul 2022 14:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9ul5HRwjM7WDUxRSXRBNR66kxi05F3aeIEeMEbXyF3k=; b=PDN/3e30eHLs8BtaLZ0T8TMOyN
        N2HcfxKuYaTro4pIBdbot118lnyGcp4WCsIp6ajuJ6Re71SWmWgaYRfmrLC82jB15SXOQTPKLLYNs
        XsLQ0dEg5gllyf/TMUKfxhTKKM30CKfds4fGXZzIb8Jw2ZlT9Rxg6YRhqh0h3L/HVMKY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oF0ai-00BBNY-9v; Fri, 22 Jul 2022 23:53:48 +0200
Date:   Fri, 22 Jul 2022 23:53:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
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
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH net-next 3/6] net: dsa: add support for retrieving the
 interface mode
Message-ID: <YtscbCH923vA6E2T@lunn.ch>
References: <20220721182216.z4vdaj4zfb6w3emo@skbuf>
 <YtnBmFm8Jhokgp7Q@shell.armlinux.org.uk>
 <20220721213645.57ne2jf7f6try4ec@skbuf>
 <YtpfmF37FmfY6BV5@shell.armlinux.org.uk>
 <20220722105238.qhfq5myqa4ixkvy4@skbuf>
 <YtqNkSDLRDtuooy/@shell.armlinux.org.uk>
 <20220722124629.7y3p7nt6jmm5hecq@skbuf>
 <YtqjFKUTsH4CK0L+@shell.armlinux.org.uk>
 <20220722165600.lldukpdflv7cjp4j@skbuf>
 <YtsUhdg3a2rT3NJC@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtsUhdg3a2rT3NJC@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I still don't understand your point - because you seem to be conflating
> two different things (at least as I understand it.)
> 
> We have this:
> 
> 		port@N {
> 			reg = <N>;
> 			label = "cpu";
> 			ethernet = <&ethX>;
> 		};
> 
> This specifies that the port operates at whatever interface mode and
> settings gives the maximum speed. There is no mention of a "managed"
> property, and therefore (Andrew, correct me if I'm wrong) in-band
> negotiation is not expected to be used.

I would actually say it is undefined if in-band is expected or
not. Pretty much everything is undefined, expect 'maximum speed'.

If you can choose between SGMII and 1000BaseX, GMII or RGMII, it is
not defined which you should pick. However generally, *MII and a
SERDES are mutually exclusive in hardware, except for the 6352 which
have some ports with both. The switches do have strapping pins which
can configure most ports into specific modes, which is probably want
most boards do, and the "maximum speed" probably does not in fact
adjust the port mode unless really required. It does however configure
the MAC to fixed speed. There is a degree of separation between the
MAC and the internal PHY/PCS. So the MAC could be fixed, and the PCS
is probably using its power up defaults which could be to perform
in-band signalling. And it is very likely the results from that in
band signalling is ignored by the MAC.

So this is all pretty fragile, but that is the way this has all
evolved over time for the mv88e6xxx driver. And so far, boards
continue to work, or at least, we are not going reports they are
broken. That however does not mean it will not all implode sometime in
the future, and we probably should be asking new submissions to always
use a fixed-link and a phy-mode, even if it is not strictly needed.

	Andrew
