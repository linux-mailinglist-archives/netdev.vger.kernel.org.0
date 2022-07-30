Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 748B3585859
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 05:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238817AbiG3Dyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 23:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiG3Dyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 23:54:31 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B36DD743E0;
        Fri, 29 Jul 2022 20:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7YiLpMaw2/hxuRrEztHHabGbkHQasdt3WXqJtG/B6gw=; b=h6XBNvyFKzvxULfonXBLLWfWS1
        u9687BHCigWyaGq0EikFteQpmPwoy8uAPviM+sB/X0ZJwLLz9hwfpz16IHQIHlzwof6+0WTpJaYXZ
        Nxbblkknonx6RC6kIZs9z72+xkZScI3Qloyrs+nV+Uo6u/RCpyrRCUdCiwh21Zhtc8kk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oHdYR-00BzQN-P6; Sat, 30 Jul 2022 05:54:19 +0200
Date:   Sat, 30 Jul 2022 05:54:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Richard Cochran <richardcochran@gmail.com>,
        Horatiu.Vultur@microchip.com, Allan.Nielsen@microchip.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v3 3/4] net: phy: Add helper to derive the
 number of ports from a phy mode
Message-ID: <YuSra19Sm0VAM9T9@lunn.ch>
References: <20220729153356.581444-1-maxime.chevallier@bootlin.com>
 <20220729153356.581444-4-maxime.chevallier@bootlin.com>
 <056164ec-3525-479b-3b71-834af48d323c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <056164ec-3525-479b-3b71-834af48d323c@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +int phy_interface_num_ports(phy_interface_t interface)
> > +{
> > +	switch (interface) {
> > +	case PHY_INTERFACE_MODE_NA:
> > +		return 0;
> > +	case PHY_INTERFACE_MODE_INTERNAL:
> 

> Maybe this was covered in the previous iteration, but cannot the
> default case return 1, and all of the cases that need an explicit
> non-1 return value are handled? Enumeration all of those that do
> need to return 1 does not really scale.

It is a trade off. In the current form, when somebody adds a new enum
value, gcc will give a warning if they forget to add it here. If we
default to 1, new values are probably going to be missed here, and
could end up with the incorrect return value.

I think the compiler warning actually does make it scale. And the
generated code probably very similar either way.

	  Andrew
