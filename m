Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBC26CBE46
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 13:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbjC1L7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 07:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjC1L7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 07:59:49 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E4A199;
        Tue, 28 Mar 2023 04:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xdsfUu/qnsBP4IbjC/WCYy76g1YOySMvlcjwDWLo/i0=; b=dXMGbmJNOZCHGV/Lt3TyRQLm77
        C8ZFsE7r42xczo/t2ucxtlpphRrnPONWu6QdmmY2SYomQO4jAbzFK6Q8zg5E0dNsKiXl3fGrGNDpc
        DKuEOgRp6Cz+Pz0pM1DV/NPmu9r8RvzlrevPur+fbJMkb73PxiifwL2oIIybdFSWCqWg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ph7z8-008dk4-GB; Tue, 28 Mar 2023 13:59:30 +0200
Date:   Tue, 28 Mar 2023 13:59:30 +0200
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
Message-ID: <2e5c6dfb-5f55-416f-a934-6fa3997783b7@lunn.ch>
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
 <20230327141031.11904-17-ansuelsmth@gmail.com>
 <ZCKl1A9dZOIAdMY8@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCKl1A9dZOIAdMY8@duo.ucw.cz>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 10:31:16AM +0200, Pavel Machek wrote:
> On Mon 2023-03-27 16:10:31, Christian Marangi wrote:
> > From: Andrew Lunn <andrew@lunn.ch>
> > 
> > The WAN port of the 370-RD has a Marvell PHY, with one LED on
> > the front panel. List this LED in the device tree.
> 
> > @@ -135,6 +136,19 @@ &mdio {
> >  	pinctrl-names = "default";
> >  	phy0: ethernet-phy@0 {
> >  		reg = <0>;
> > +		leds {
> > +			#address-cells = <1>;
> > +			#size-cells = <0>;
> > +
> > +			led@0 {
> > +				reg = <0>;
> > +				label = "WAN";
> > +				color = <LED_COLOR_ID_WHITE>;
> > +				function = LED_FUNCTION_LAN;
> > +				function-enumerator = <1>;
> > +				linux,default-trigger = "netdev";
> > +			};
> 
> /sys/class/leds/WAN is not acceptable.

As i said here, that is not what it gets called:

https://lore.kernel.org/netdev/aa2d0a8b-b98b-4821-9413-158be578e8e0@lunn.ch/T/#m6c72bd355df3fcf8babc0d01dd6bf2697d069407

> It can be found in /sys/class/leds/f1072004.mdio-mii:00:WAN. But when
> we come to using it for ledtrig-netdev, the user is more likely to follow
> /sys/class/net/eth0/phydev/leds/f1072004.mdio-mii\:00\:WAN/

Is that acceptable?

What are the acceptance criteria?

     Andrew
