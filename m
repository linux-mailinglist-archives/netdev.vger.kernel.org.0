Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6124D19B2
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 14:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347231AbiCHNzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 08:55:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236514AbiCHNzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 08:55:41 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4526149C8F;
        Tue,  8 Mar 2022 05:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=uCy/gA56prUv6k177gbvGjRcg4ELHge9R0lbNx4U59E=; b=5O/+mGWxmoYFRJQHGGRYH62gbk
        ZEK2YyIw0yGG8Rr/BC62rihhJ2a/Vi9wxIeCtfoF6H4bDd4meOEsyjBzZVL3PYQ9M+G5wsWAgH2YE
        y2oe2qFW0kv8qFKiTZJxc2KYVyVzMB7GyRLNBe8O9bbslRND5ph7OD+bjeqkuh6uP5VU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nRaIP-009nsT-29; Tue, 08 Mar 2022 14:54:37 +0100
Date:   Tue, 8 Mar 2022 14:54:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Divya.Koppera@microchip.com
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        richardcochran@gmail.com, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Madhuri.Sripada@microchip.com,
        Manohar.Puri@microchip.com
Subject: Re: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Message-ID: <YidgHT8CLWrmhbTW@lunn.ch>
References: <20220304093418.31645-1-Divya.Koppera@microchip.com>
 <20220304093418.31645-3-Divya.Koppera@microchip.com>
 <YiILJ3tXs9Sba42B@lunn.ch>
 <CO1PR11MB4771237FE3F53EBE43B614F6E2089@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YiYD2kAFq5EZhU+q@lunn.ch>
 <CO1PR11MB4771F7C1819E033EC613E262E2099@CO1PR11MB4771.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB4771F7C1819E033EC613E262E2099@CO1PR11MB4771.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Thanks for the reply, but you did not answer my question:
> > 
> >   Does this mean the hardware itself cannot tell you it is missing the
> >   needed hardware?
> > 
> > Don't you have different IDs in register 2 and 3 for those devices with clock
> > register and those without?
> > 
> 

> The purpose of this option is, if both PHY and MAC supports
> timestamping then always timestamping is done in PHY.  If
> timestamping need to be done in MAC we need a way to stop PHY
> timestamping. If this flag is used then timestamping is taken care
> by MAC.

This is not a valid use of DT, since this is configuration, not
describing the hardware. There has been recent extension in the UAPI
to allow user space to do this configuration. Please look at that
work.

> Sorry I answered wrong. Latency values vary depending on the position of PHY in board. 
> We have used this PHY in different hardware's, where latency values differs based on PHY positioning. 
> So we used latency option in DTS file.
> If you have other ideas or I'm wrong please let me know?

So this is a function of the track length between the MAC and the PHY?
How do you determine these values? There is no point having
configuration values if you don't document how to determine what value
should be used.

       Andrew
