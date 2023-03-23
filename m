Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75676C6E57
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 18:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbjCWRDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 13:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbjCWRC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 13:02:58 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0BB3EC;
        Thu, 23 Mar 2023 10:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=EtUf/kME4TTvbhGEmdUh+hcyhm5L0g/SNih4ASarj5A=; b=AF0+Azsrs80rxSKR9Dlg0HUjbE
        bm+6k+G9gGa1Gci8rzMmgG56qWZVsuyNbqX6OUckEHLm5KssGt0XHggerAG/qcAXBZrbIgZ7Pr4YY
        nm3soUITXlwTiqWCP5EqTa3czeBNCkWp51ApWTKBvOey56oW8mhx81aGSdAEMaYHYLWo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pfOKh-008Dm8-6N; Thu, 23 Mar 2023 18:02:35 +0100
Date:   Thu, 23 Mar 2023 18:02:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Lee Jones <lee@kernel.org>, John Crispin <john@phrozen.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v5 15/15] arm: mvebu: dt: Add PHY LED support
 for 370-rd WAN port
Message-ID: <318f65ef-fd63-446d-bd08-1ba51b1d1f72@lunn.ch>
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
 <20230319191814.22067-16-ansuelsmth@gmail.com>
 <ZBxAZRcEBg4to132@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBxAZRcEBg4to132@duo.ucw.cz>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 01:04:53PM +0100, Pavel Machek wrote:
> Hi!
> 
> > From: Andrew Lunn <andrew@lunn.ch>
> > 
> > The WAN port of the 370-RD has a Marvell PHY, with one LED on
> > the front panel. List this LED in the device tree.
> > 
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
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
> > +		};
> >  	};
> >  
> 
> How will this end up looking in sysfs?

Hi Pavel

It is just a plain boring LED, so it will look like all other LEDs.
There is nothing special here.

> Should documentation be added to Documentation/leds/leds-blinkm.rst
>  ?

This has nothing to do with blinkm, which appears to be an i2c LED
driver.

	Andrew
