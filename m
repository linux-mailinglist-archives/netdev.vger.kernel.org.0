Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74CD4D25D8
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 02:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbiCIBHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 20:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbiCIBHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 20:07:15 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06F5D2240;
        Tue,  8 Mar 2022 16:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=PXnF7xsg0OHmYSnSkaojnPw+kchBbwd7FnMF7nPOl9U=; b=hxwj8ZfHgideD0FeK4cxhmnIKt
        CcfdqsPVOJh+YEuqUrIx25ppVNhTORh3V3ZxpkhD0b6V83+Op77NqDLRHo+35Cr6swl0+/doQY6Y3
        ukV059i3641PXzTfxJpy0ycHHiNelFPQ+5lw5kL+fwxYK6pYAa464nFXn1qjsLoNxB1I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nRjNu-009sFO-3G; Wed, 09 Mar 2022 00:36:54 +0100
Date:   Wed, 9 Mar 2022 00:36:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Divya.Koppera@microchip.com, netdev@vger.kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, devicetree@vger.kernel.org,
        richardcochran@gmail.com, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Madhuri.Sripada@microchip.com,
        Manohar.Puri@microchip.com
Subject: Re: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Message-ID: <YifoltDp4/Fs+9op@lunn.ch>
References: <20220304093418.31645-1-Divya.Koppera@microchip.com>
 <20220304093418.31645-3-Divya.Koppera@microchip.com>
 <YiILJ3tXs9Sba42B@lunn.ch>
 <CO1PR11MB4771237FE3F53EBE43B614F6E2089@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YiYD2kAFq5EZhU+q@lunn.ch>
 <CO1PR11MB4771F7C1819E033EC613E262E2099@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YidgHT8CLWrmhbTW@lunn.ch>
 <20220308154345.l4mk2oab4u5ydn5r@soft-dev3-1.localhost>
 <YiecBKGhVui1Gtb/@lunn.ch>
 <20220308221404.bwhujvsdp253t4g3@soft-dev3-1.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308221404.bwhujvsdp253t4g3@soft-dev3-1.localhost>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 11:14:04PM +0100, Horatiu Vultur wrote:
> The 03/08/2022 19:10, Andrew Lunn wrote:
> > 
> > > > So this is a function of the track length between the MAC and the PHY?
> > >
> > > Nope.
> > > This latency represents the time it takes for the frame to travel from RJ45
> > > module to the timestamping unit inside the PHY. To be more precisely,
> > > the timestamping unit will do the timestamp when it detects the end of
> > > the start of the frame. So it represents the time from when the frame
> > > reaches the RJ45 to when the end of start of the frame reaches the
> > > timestamping unit inside the PHY.
> > 
> > I must be missing something here. How do you measure the latency
> > difference for a 1 meter cable vs a 100m cable?
> 
> In the same way because the end result will be the same.

The latency from the RJ45 to the PHY will be the same. But the latency
from the link peer PHY to the local PHY will be much more, 500ns. In
order for this RJ45 to PHY delay to be meaningful, don't you also need
to know the length of the cable? Is there a configuration knob
somewhere for the cable length?

I'm assuming the ptp protocol does not try to measure the cable delay,
since if it did, there would be no need to know the RJ45-PHY delay, it
would be part of that.

> > Isn't this error all just in the noise?
> 
> I am not sure I follow this question.

At minimum, you expect to have a 1m cable. The RJ45-PHY track length
is maybe 2cm? So 2% of the overall length. So you are trying to
correct the error this 2% causes. If you have a 100m cable, 0.02% is
RJ45-PHY part that you are trying to correct the error on. These
numbers seem so small, it seems pointless. It only seems to make sense
if you know the length of the cable, and to an accuracy of a few cm.

   Andrew
