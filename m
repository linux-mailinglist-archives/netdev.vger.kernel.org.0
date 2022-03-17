Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFD64DC8EC
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 15:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbiCQOkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 10:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbiCQOkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 10:40:16 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6C19BBB5;
        Thu, 17 Mar 2022 07:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3BjrWGGgkjncg1vv4hpLcIKPNXLL2cC/NQLziuZZzq8=; b=hWbM1WLnHM6lFw9Ow5rZcX0rnJ
        MSRllKS/gf4g9piFchBENM5IHcjQ5WC0lphudbq5CeaUFttiugpATROUV+8CzNO4Ei3ttEev2yUIr
        xHkhd7S1MZMNVnWnteqccGJE+OZgla9J69luKPTVQL/41Go/Xa90OnSG+miDc8tMIs7k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nUrH8-00BQOW-R3; Thu, 17 Mar 2022 15:38:50 +0100
Date:   Thu, 17 Mar 2022 15:38:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Michael Walle <michael@walle.cc>,
        patchwork-bot+netdevbpf@kernel.org, Divya.Koppera@microchip.com,
        UNGLinuxDriver@microchip.com, davem@davemloft.net,
        devicetree@vger.kernel.org, hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        madhuri.sripada@microchip.com, manohar.puri@microchip.com,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        robh+dt@kernel.org
Subject: Re: [PATCH net-next 0/3] Add support for 1588 in LAN8814
Message-ID: <YjNH+jahuTwDyVso@lunn.ch>
References: <164639821168.27302.1826304809342359025.git-patchwork-notify@kernel.org>
 <20220317121650.934899-1-michael@walle.cc>
 <20220317140559.f52cuvw6gswyrfn6@den-dk-m31684h>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317140559.f52cuvw6gswyrfn6@den-dk-m31684h>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 03:05:59PM +0100, Allan W. Nielsen wrote:
> Hi,
> 
> On Thu, Mar 17, 2022 at 01:16:50PM +0100, Michael Walle wrote:
> > From: patchwork-bot+netdevbpf@kernel.org
> > > Here is the summary with links:
> > >   - [net-next,1/3] net: phy: micrel: Fix concurrent register access
> > >     https://git.kernel.org/netdev/net-next/c/4488f6b61480
> > >   - [net-next,2/3] dt-bindings: net: micrel: Configure latency values and timestamping check for LAN8814 phy
> > >     https://git.kernel.org/netdev/net-next/c/2358dd3fd325
> > >   - [net-next,3/3] net: phy: micrel: 1588 support for LAN8814 phy
> > >     https://git.kernel.org/netdev/net-next/c/ece19502834d
> > 
> > I'm almost afraid to ask.. but will this series be reverted (or
> > the device tree bindings patch)? There were quite a few remarks, even
> > about the naming of the properties. So, will it be part of the next
> > kernel release or will it be reverted?
> Thanks for bringing this up - was about to ask myself.
> 
> Not sure what is the normal procedure here.

I assume this is in net-next. So we have two weeks of the merge window
followed by around 7 weeks of the -rc in order to clean this up. It is
only when the code is released in a final kernel does it become an
ABI.

> If not reverted, we can do a patch to remove the dt-bindings (and also
> the code in the driver using them). Also, a few other minor comments was
> given and we can fix those.

Patches would be good. Ideally the patches would be posted in the next
couple of weeks, even if we do have a lot longer.

> The elefant in the room is the 'lan8814_latencies' structure containing
> the default latency values in the driver, which Richard is unhappy with.

The important thing is getting the ABI fixed. So the DT properties
need to be removed, etc.

To some extend the corrections are ABI. If the corrections change the
user space configuration also needs to change when trying to get the
best out of the hardware. So depending on how long the elefant is
around, it might make sense to actually do a revert, or at minimum
disabling PTP, so time can be spent implementing new APIs or whatever
is decided.

So i would suggest a two pronged attach:

Fixup patchs
Try to bring the discussion to a close and implement whatever is decided.

   Andrew
