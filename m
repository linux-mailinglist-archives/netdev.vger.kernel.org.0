Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE6D167CC6
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 12:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgBULxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 06:53:08 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:47810 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbgBULxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 06:53:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Y7RbabUMIDfHWd7Ngw4xz5H4W9/l5MseELv5WZtFTE0=; b=ahBR5381IZD9MUKbH2u1z1WLC
        KL5VezEwjBFD4BdxEJuOcvM2Uzlr7WUVzm1Zon4Zi4oOSzk9IEOipABaycY28AmAn0b+MbkrNT1tt
        30JKFO/P/E1DbXZlnDobJuqLzEJGYPhiwXmNqM1lpYtAvad6nJxHWTkgLxG3w1bYXakOie9v1OpYy
        t1FhKZX0rVOKhRZnSRlC/5RydWxIi7iwGpikJpElXjEC8lTdoL9IfukeZ7x7Isz6IlffpC9nxhHrs
        P1NcVdaN0Wfz1TPM1RJigTHfn9N5EsnwMXtKYqYiC7INe8OWJD+Va3SFaq5n2RfjPKM/+6as7+ECk
        K7J4JFjlA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:50816)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j56rU-00011f-Lm; Fri, 21 Feb 2020 11:52:52 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j56rQ-0003Tj-P3; Fri, 21 Feb 2020 11:52:48 +0000
Date:   Fri, 21 Feb 2020 11:52:48 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     ansuelsmth@gmail.com
Cc:     'Andy Gross' <agross@kernel.org>,
        'Bjorn Andersson' <bjorn.andersson@linaro.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        'Rob Herring' <robh+dt@kernel.org>,
        'Mark Rutland' <mark.rutland@arm.com>,
        'Andrew Lunn' <andrew@lunn.ch>,
        'Florian Fainelli' <f.fainelli@gmail.com>,
        'Heiner Kallweit' <hkallweit1@gmail.com>,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: R: [PATCH v3 1/2] net: mdio: add ipq8064 mdio driver
Message-ID: <20200221115248.GH25745@shell.armlinux.org.uk>
References: <20200220232624.7001-1-ansuelsmth@gmail.com>
 <20200221004013.GF25745@shell.armlinux.org.uk>
 <000601d5e850$c0161cc0$40425640$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000601d5e850$c0161cc0$40425640$@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 21, 2020 at 01:49:17AM +0100, ansuelsmth@gmail.com wrote:
> > On Fri, Feb 21, 2020 at 12:26:21AM +0100, Ansuel Smith wrote:
> > > +static int
> > > +ipq8064_mdio_probe(struct platform_device *pdev)
> > > +{
> > > +	struct device_node *np = pdev->dev.of_node;
> > > +	struct ipq8064_mdio *priv;
> > > +	struct mii_bus *bus;
> > > +	int ret;
> > > +
> > > +	bus = devm_mdiobus_alloc_size(&pdev->dev, sizeof(*priv));
> > > +	if (!bus)
> > > +		return -ENOMEM;
> > > +
> > > +	bus->name = "ipq8064_mdio_bus";
> > > +	bus->read = ipq8064_mdio_read;
> > > +	bus->write = ipq8064_mdio_write;
> > > +	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-mii", dev_name(&pdev-
> > >dev));
> > > +	bus->parent = &pdev->dev;
> > > +
> > > +	priv = bus->priv;
> > > +	priv->base = syscon_node_to_regmap(np);
> > > +	if (IS_ERR_OR_NULL(priv->base)) {
> > > +		priv->base = syscon_regmap_lookup_by_phandle(np,
> > "master");
> > > +		if (IS_ERR_OR_NULL(priv->base)) {
> > > +			dev_err(&pdev->dev, "master phandle not
> > found\n");
> > > +			return -EINVAL;
> > > +		}
> > > +	}
> > 
> > I'm curious why you've kept this as-is given my comments?
> > 
> > If you don't agree with them, it would be helpful to reply to the
> > review email giving the reasons why.
>
> I read your command and now I understand what you mean. Since they both
> never return NULL the IS_ERR_OR_NULL is wrong and only IS_ERR should be
> used. Correct me if I'm wrong.
> About the error propagation, should I return the
> syscon_regmap_lookup_by_phandle
> error or I can keep the EINVAL error? 

Hi,

You probably want something like:

	priv->base = syscon_node_to_regmap(np);
	if (IS_ERR(priv->base) && priv->base != ERR_PTR(-EPROBE_DEFER))
		priv->base = syscon_regmap_lookup_by_phandle(np, "master");

	if (priv->base == ERR_PTR(-EPROBE_DEFER)) {
		return -EPROBE_DEFER;
	} else if (IS_ERR(priv->base)) {
		dev_err(&pdev->dev, "error getting syscon regmap, error=%pe\n",
			priv->base);
		return PTR_ERR(priv->base);
	}

Please ensure that you test the above, including the case where you
should fall through to syscon_regmap_lookup_by_phandle().

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
