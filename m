Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D72F96D98AB
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 15:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238257AbjDFNzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 09:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238363AbjDFNyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 09:54:41 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5D09777;
        Thu,  6 Apr 2023 06:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=eCyDhIIH7zROrQHs1/YiKAKEaRN5MqlP/rzgVydjPvI=; b=T8qx3rQouZ7XvU4SiE9YvRbYYJ
        eZ/TIFFWd6LmzPMmlepLNKX294cnNsz5NBy1K0lf6uyD5yo8cEVMMD66JAuSKt2jdTgaf6+EumK2y
        H3+38xMvHD4Jz1kfvnOmzRVGQzMEvPTeRioo/AiUb+xhnlOoHJmBpes1tBDESCRP7XFs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pkQ46-009dDs-Gr; Thu, 06 Apr 2023 15:54:14 +0200
Date:   Thu, 6 Apr 2023 15:54:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [net-next PATCH v6 16/16] arm: mvebu: dt: Add PHY LED support
 for 370-rd WAN port
Message-ID: <ebaedccc-a73b-48fc-8735-c0567d899d5c@lunn.ch>
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
 <20230327141031.11904-17-ansuelsmth@gmail.com>
 <ZCKl1A9dZOIAdMY8@duo.ucw.cz>
 <2e5c6dfb-5f55-416f-a934-6fa3997783b7@lunn.ch>
 <ZCsu4qD8k947kN7v@duo.ucw.cz>
 <7cadf888-8d6e-4b7d-8f94-7e869fd49ee2@lunn.ch>
 <ZC6OZ2f/NLJxZgle@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZC6OZ2f/NLJxZgle@duo.ucw.cz>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I don't think basing stuff on position is reasonable. (And am not sure
> if making difference between MAC and PHY leds is good idea).
> 
> Normally, there's ethernet port with two LEDs, one is usually green
> and indicates link, second being yellow and indicates activity,
> correct?

Nope. I have machines with 1, 2 or 3 LEDs. I have green, yellow, white
and red LEDs.

Part of the problem is 802.3 says absolutely nothing about LEDs. So
every vendor is free to do whatever why want. There is no
standardisation at all. So we have to assume every vendor does
something different.

> On devices like ADSL modems, there is one LED per port, typically on
> with link and blinking with activity.  
> 
> Could we use that distinction instead? (id):green:link,
> (id):yellow:activity, (id):?:linkact -- for combined LED as it seems.
> 
> Are there any other common leds? I seem to remember "100mbps" lights
> from time where 100mbit was fast...?

But what about 2.5G, 5G, 10G, 40G... And 10Mbps for automotive. And
collision for 1/2 duplex, which is making a bit of a comeback in
automotive.

Plus, we are using ledtrig-netdev. A wifi device is a netdev. A CAN
bus devices is a netdev. Link speed has a totally different meaning
for 802.11 and CAN.

You are also assuming the LEDs have fixed meaning. But they are not
fixed, they mean whatever the ledtrig-netdev is configured to make
them blink.  I even have one of my boxes blinking heartbeat, because
if has a habit of crashing... And i think for Linux LEDs in general,
we should not really tie an LED to a meaning. Maybe tie it to a label
on the case, but the meaning of an LED is all about software, what
ledtrig- is controlling it.

As to differentiating MAC and PHY, we need to, because as i said, both
could offer LEDs. Generally, Ethernet switches have LED controllers
per MAC port. Most switches have internal PHYs, and those PHYs don't
have LED controllers. However, not all ports have internal PHYs, there
can be external PHYs with its own LED controller. So in that case,
both the MAC and the PHY could register an LED controller for the same
netdev. It comes down to DT to indicate what LED controllers are
actually wired to an LED.

	 Andrew
