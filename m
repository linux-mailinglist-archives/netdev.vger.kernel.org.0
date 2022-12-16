Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76D9264EFC7
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 17:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbiLPQw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 11:52:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbiLPQwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 11:52:17 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AE7DFAC;
        Fri, 16 Dec 2022 08:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8951IwQXDwezIFfuE4x8rlkg+QlEDpYrWM0TEkzABwY=; b=os1lxoQnJ/FgOhbm9lnOQ366gf
        OvE/CZFMFe9nNIuIOMEOtxWGfZOfGGL4t+1hI1vAN/jywV1dusglwtoSZRaNwQgRTNrHJqbEuN005
        ivWfk78PuQIfjyycn03Ru193lpTOqCc7NbtqleOW+1L394v/S3sf6cWqT3mo+y20QCDrkeKoNDRLL
        WpZG9l8zCXqEayoiAO8sU0BfWAwFJKbHt8XvzGeEIsiIQ+1RCU66aBPLYd/CfbTcYlMf1cqmkD+hY
        geIGvFaa+Z0k3ihuPejMBYOl/rj9EsgjjdhmgOiw9pY2sSHZZd/LGYZjOqhRei48ATAzBOP+RHg15
        MhYSwuow==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35744)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p6DwI-00089K-IK; Fri, 16 Dec 2022 16:52:02 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p6DwE-00012J-OM; Fri, 16 Dec 2022 16:51:58 +0000
Date:   Fri, 16 Dec 2022 16:51:58 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH v7 01/11] leds: add support for hardware driven LEDs
Message-ID: <Y5yiLhTt2+AV1G0N@shell.armlinux.org.uk>
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
 <20221214235438.30271-2-ansuelsmth@gmail.com>
 <Y5tHjwx1Boj3xMok@shell.armlinux.org.uk>
 <639ca0a4.050a0220.99395.8fd3@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <639ca0a4.050a0220.99395.8fd3@mx.google.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 16, 2022 at 05:45:25PM +0100, Christian Marangi wrote:
> On Thu, Dec 15, 2022 at 04:13:03PM +0000, Russell King (Oracle) wrote:
> > Hi Christian,
> > 
> > Thanks for the patch.
> > 
> > I think Andrew's email is offline at the moment.
> >
> 
> Notice by gmail spamming me "I CAN'T SEND IT AHHHHH"
> Holidy times I guess?

Sadly, Andrew's email has done this a number of times - and Andrew
used to be on IRC so I could prod him about it, but it seems he
doesn't hang out on IRC anymore. It's been like it a few days now.

> > On Thu, Dec 15, 2022 at 12:54:28AM +0100, Christian Marangi wrote:
> > > @@ -188,6 +213,10 @@ int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
> > >  		led_set_brightness(led_cdev, LED_OFF);
> > >  	}
> > >  	if (trig) {
> > > +		/* Make sure the trigger support the LED blink mode */
> > > +		if (!led_trigger_is_supported(led_cdev, trig))
> > > +			return -EINVAL;
> > 
> > Shouldn't validation happen before we start taking any actions? In other
> > words, before we remove the previous trigger?
> > 
> 
> trigger_set first remove any trigger and set the led off. Then apply the
> new trigger. So the validation is done only when a trigger is actually
> applied. Think we should understand the best case here.

I think this is a question that needs to be answered by the LEDs folk,
as it's an interface behaviour / quality of implementation issue.

> > > @@ -350,12 +381,26 @@ static inline bool led_sysfs_is_disabled(struct led_classdev *led_cdev)
> > >  
> > >  #define TRIG_NAME_MAX 50
> > >  
> > > +enum led_trigger_blink_supported_modes {
> > > +	SOFTWARE_ONLY = SOFTWARE_CONTROLLED,
> > > +	HARDWARE_ONLY = HARDWARE_CONTROLLED,
> > > +	SOFTWARE_HARDWARE = SOFTWARE_HARDWARE_CONTROLLED,
> > 
> > I suspect all these generic names are asking for eventual namespace
> > clashes. Maybe prefix them with LED_ ?
> 
> Agree they are pretty generic so I can see why... My only concern was
> making them too long... Maybe reduce them to SW or HW? LEDS_SW_ONLY...
> LEDS_SW_CONTROLLED?

Seems sensible to me - and as a bonus they get shorter than the above!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
