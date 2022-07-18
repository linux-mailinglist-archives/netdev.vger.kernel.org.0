Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB868577DF2
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 10:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233746AbiGRItj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 04:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233159AbiGRIti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 04:49:38 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762C56337;
        Mon, 18 Jul 2022 01:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FjFL3Ngh7BaQgnn0nFfHRJwcquVGbPNjf58pM6ZtWcc=; b=zhuBorQxLIFlSzTMHxwxHzwed0
        uGpnlsSWmzyC63HCEfQJbCHHzhuT7N+WvwQqxZPbe6/qDVzM6T1D7Np+EXkTAsNYa+l7j4Oue/CAd
        +ggpBNcnRXYPwxuTd5KL/lio9fIiovMY10T4M4WYRx+woFZZTLf/2Er/YfJdJWGi5BnQNG+ev74wp
        KpNGHtUywKibShhThgpT8otgtn7qiMlKbXsCMXEWK3KRimqjb423L9zkwc410hIF8/mZxhsZCivoO
        EkBWEb9jj9BQu5hxFjfPVUqLa+iuyzK1KWUZRmvOCUAuhQDfVY/mTPNjwnYeWR8ycOUNGTn0XW0pZ
        gutZJI3Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33398)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oDMR0-0001I0-5Q; Mon, 18 Jul 2022 09:48:58 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oDMQt-0001po-V9; Mon, 18 Jul 2022 09:48:51 +0100
Date:   Mon, 18 Jul 2022 09:48:51 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
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
Message-ID: <YtUec3GTWTC59sky@shell.armlinux.org.uk>
References: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
 <E1oCNl3-006e3n-PT@rmk-PC.armlinux.org.uk>
 <E1oCNl3-006e3n-PT@rmk-PC.armlinux.org.uk>
 <20220715172444.yins4kb2b6b35aql@skbuf>
 <YtHcpf4otJQS9hTO@shell.armlinux.org.uk>
 <20220715222348.okmeyd55o5u3gkyi@skbuf>
 <YtHw0O5NB6kGkdwV@shell.armlinux.org.uk>
 <20220716105711.bjsh763smf6bfjy2@skbuf>
 <YtKdcxupT+INVAhR@shell.armlinux.org.uk>
 <20220716123608.chdzbvpinso546oh@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220716123608.chdzbvpinso546oh@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 16, 2022 at 03:36:08PM +0300, Vladimir Oltean wrote:
> On Sat, Jul 16, 2022 at 12:13:55PM +0100, Russell King (Oracle) wrote:
> > > > and is exactly what I'm trying to get rid of, so we have _consistency_
> > > > in the implementation, to prevent fuckups like I've created by
> > > > converting many DSA drivers to use phylink_pcs. Any DSA driver that
> > > > used a PCS for the DSA or CPu port and has been converted to
> > > > phylink_pcs support has been broken in the last few kernel cycles. I'm
> > > > trying to address that breakage before converting the Marvell DSA
> > > > driver - which is the driver that highlighted the problem.
> > > 
> > > You are essentially saying that it's of no use to keep in DSA the
> > > fallback logic of not registering with phylink, because the phylink_pcs
> > > conversions have broken the defaulting functionality already in all
> > > other drivers.
> > 
> > Correct, and I don't want these exceptions precisely because it creates
> > stupid mistakes like the one I've highlighted. If we have one way of
> > doing something, then development becomes much easier. When we have
> > multiple different ways, mistakes happen, stuff breaks.
> 
> Agree that when we have multiple different ways, mistakes happen and
> stuff breaks. This is also why I want to avoid the proliferation of the
> default_interface reporting when most of the drivers were just fine
> without it. It needs to be opt-in, and checking for the presence of a
> dedicated function is an easy way to check for that opt-in.
> 
> > > I may have missed something, but this is new information to me.
> > > Specifically, before you've said that it is *this* patch set which would
> > > risk introducing breakage (by forcing a link down + a phylink creation).
> > > https://lore.kernel.org/netdev/YsCqFM8qM1h1MKu%2F@shell.armlinux.org.uk/
> > > What you're saying now directly contradicts that.
> > 
> > No, it is not contradictory at all.
> > 
> > There is previous breakage caused by converting DSA drivers to
> > phylink_pcs - because the PCS code will *not* be called where a driver
> > makes use of the "default-to-fastest-speed" mechanism, so is likely
> > broken. Some drivers work around this by doing things manually.
> 
> Marvell conversion to phylink_pcs doesn't count as "previous" breakage
> if it's not in net-next.

Thank you for stating the obvious. I never claimed it was.

> > This series *also* risks breakage, because it means phylink gets used
> > in more situations which could confuse drivers - such as those which
> > have manually brought stuff up and are not expecting phylink to also
> > do it. Or those which do not fill in the mac_capabilities but do
> > default to this "fastest-speed" mechanism. Or some other unforseen
> > scenario.
> 
> I don't exactly understand the mechanics through which a phylink_pcs
> conversion would break a driver that used defaulting behavior,
> but I can only imagine it involves moving code that didn't depend on
> phylink, to phylink callbacks. It's hard to say whether that happened
> for any of the phylink_pcs conversions in net-next.

Situation before phylink_pcs conversion:
- code paths that configure the PCS are integrated with the rest of the
  driver and would be called where appropriate.

Situation after phylink_pcs conversion:
- code paths that configure the PCS are no longer integrated with the
  rest of the driver and are now dependent on phylink being used for
  them to be called.

If there is no problem with doing this conversion, then why has the
proposed conversion of mv88e6xxx caused breakage when it was working
fine previously - it's because of exactly the above.

> But drivers could also have their CPU port working simply because those
> are internal to an SoC and don't need any software configuration to pass
> traffic. In their case, there is no breakage caused by the phylink_pcs
> conversion, but breakage caused by sudden registration of phylink is
> plausible, if phylink doesn't get the link parameters right.
> 
> And that breakage is preventable. Gradually more drivers could be
> converted to create a fixed-link software node by printing a warning
> that they should, and still keep the logic to avoid phylink registration
> and putting the respective port down. Driver authors might not be very
> responsive to RFC patch sets, but they do look at new warnings in dmesg
> and try to see what they're about.

Are you going to do that conversion then? Good luck trying to find all
the drivers, sending out series of patches, trying to get people to test
the changes.

> What I'm missing is the proof that the phylink_pcs conversion has broken
> those kinds of switches, and that it's therefore pointless to keep the
> existing logic for them. Sorry, but you didn't provide it.

I don't have evidence that existing drivers have broken because I don't
have the hardware to test. I only have Marvell DSA switch hardware and
that is it.

Everything else has to be based on theory because no one bothers to
respond to my patches, so for 99% of the DSA drivers I'm working in the
dark - and that makes development an utter shitpile of poo in hell.

As I've said many times, we have NO CLUE which DSA drivers make use of
this defaulting behaviour - the only one I'm aware of that does is
mv88e6xxx. It all depends on the firmware description, driver behaviour
and hardware behaviour. There is not enough information in the kernel 
to be able to derive this.

If there was a reported regression, then I would be looking to get this
into the NET tree not the NET-NEXT tree.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
