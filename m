Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 204555642B4
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 22:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiGBU1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 16:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGBU1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 16:27:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2FFBC0C
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 13:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WWRpsl5ggL/SCJkSQDZVOouYeoKfRcbKaFLWJ7eZmeM=; b=G0YYxPX+RBUvgZDPW64RQO0MAl
        yUOL7+KruWwkIkhhqd16BunpjaFwYSqhToh6EQotU39rRP/5IIU0kQZbtxf0k5+K6HlxNnm2GP4zp
        I2/vhTawk/OUyDk/TqA1bGPYjTMgrqiGXAuIAE9vz2O0pHm2FIPa6xn8NREaT7lyB8VtEbRyGT6OP
        1VxsAuHQARL26Kfjv2bc242sLpLqsTN0e4wt16A/6MwheHDlz0NRKnlDC0wf1Nxfe5gDW77jybqXr
        TDilDkrBpwFGyhyS+Dn8ZDRVTod2t3Nol9f9PZSdkbTphOW2KWrhXXxrKct4SgFas9eLZuxrEsZhU
        ajTzTnJQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33142)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o7jhs-0006zt-Dq; Sat, 02 Jul 2022 21:27:08 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o7jhk-0000X2-7R; Sat, 02 Jul 2022 21:27:00 +0100
Date:   Sat, 2 Jul 2022 21:27:00 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
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
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH RFC net-next 5/6] net: dsa: always use phylink for CPU
 and DSA ports
Message-ID: <YsCqFM8qM1h1MKu/@shell.armlinux.org.uk>
References: <YrxKdVmBzeMsVjsH@shell.armlinux.org.uk>
 <E1o6XAV-004pW2-Ct@rmk-PC.armlinux.org.uk>
 <20220701213435.53ecdd70@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220701213435.53ecdd70@thinkpad>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 09:34:35PM +0200, Marek Behún wrote:
> On Wed, 29 Jun 2022 13:51:43 +0100
> "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk> wrote:
> 
> > Currently, we only use phylink for CPU and DSA ports if there is a
> > fixed-link specification, or a PHY specified. The reason for this
> > behaviour is that when neither is specified, there was no way for
> > phylink to know the link parameters.
> > 
> > Now that we have phylink_set_max_link_speed() (which has become
> > possible through the addition of mac_capabilities) we now have the
> > ability to know the maximum link speed for a specific link, and can
> > now use phylink for this case as well.
> > 
> > However, we need DSA drivers to report the interface mode being used
> > on these ports so that we can select a maximum speed appropriate for
> > the interface mode that hardware may have configured for the port.
> > 
> > This is especially important with the conversion of DSA drivers to
> > phylink_pcs, as the PCS code only gets called if we are using
> > phylink for the port.
> > 
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> 
> Reviewed-by: Marek Behún <kabel@kernel.org>
> 
> So this is the one that may break other drivers?

It's the one that I'm most concerned about breakage happening, because
the other drivers won't be setting the default interface for the port,
which means if they're taking advantage of this "defaulting" feature,
this patch will break them.

The original code just did nothing when this "defaulting" feature was
used - it didn't call the DSA phylink_mac_link_down() op, and didn't
register with phylink. The phylink_mac_link_down() there was to ensure
that the ports are in a link-down state prior to setting up phylink,
because that's what phylink expects.

The problem comes is that once we've called phylink_mac_link_down(),
there isn't a way to back out of that without knowing the interface
mode, speed, duplex etc - which is the problem with this defaulting
feature, none of that is specified in DT, it can only come from the
drivers.

Note that the mv88e6xxx series I posted earlier depends on getting this
problem sorted - if we don't, I can't send the mv88e6xxx pcs conversion
because mv88e6xxx boards that _do_ make use of this defaulting feature
will break (and there are a number that do make use of it.)

If I send this RFC series (minus the top patch) then all the drivers
that make use of this defualting feature that aren't mv88e6xxx will
probably break - but I've no idea which make use of this feature
because it's not documented. It's not really documented in the DT
binding either, it's just something that Andrew "knows about",
mv88e6xxx makes use of, and Andrew has suggested to some other DSA
driver authors.

This absolutely needs Andrew's involvement.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
