Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 230776A1FEF
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 17:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjBXQpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 11:45:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjBXQpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 11:45:38 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6E61A66B
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 08:45:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gizQFLDWlqeEi6mqdoGc8Xu4jnp/ZZcn0OLQphwdT4M=; b=1COMSNpk1qZQT8dWd0kKm+sXh+
        FCdNyVep40+MnqH17Xb+67QcFKV14jbytm822P1n8DMsomDjU02qI32zpEyey9mi8yzr9kYTFyTR2
        ubBpZATaABIILqao5fXP8ME/6SmhGlPjZXdcgV44icvg/7ur0bj8NgC8bREltAKlyfWG6xdPa7MQG
        OQPFM5P5YrnmoamaB3gL/VeCiDWFiiHb1wqod8WQgjeBQbgy7xMWJ7SEwAKxcyOoPFDThryEeZULg
        T2JyD8W1Jru6C6S+WjVfs+ZMgvEjO+Zo8RJ9N3OuNqjNa4MBJLvu0+zelezX55Z4jNxGxlltq+PsY
        ATbci5bA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44976)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pVbCR-0000vr-3N; Fri, 24 Feb 2023 16:45:35 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pVbCP-0005ZN-5C; Fri, 24 Feb 2023 16:45:33 +0000
Date:   Fri, 24 Feb 2023 16:45:33 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Lee Jones <lee@kernel.org>,
        Maksim Kiselev <bigunclemax@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net 3/3] net: mscc: ocelot: fix duplicate driver name
 error
Message-ID: <Y/jprbUJseOEDsHe@shell.armlinux.org.uk>
References: <20230224155235.512695-1-vladimir.oltean@nxp.com>
 <20230224155235.512695-4-vladimir.oltean@nxp.com>
 <Y/jel+aPo4PkWc1g@shell.armlinux.org.uk>
 <20230224160920.cjia4n7zn3jm4nyd@skbuf>
 <Y/jiYdNjaeqPAfO9@shell.armlinux.org.uk>
 <20230224161629.w7onocrzlokqmglh@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224161629.w7onocrzlokqmglh@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 06:16:29PM +0200, Vladimir Oltean wrote:
> On Fri, Feb 24, 2023 at 04:14:25PM +0000, Russell King (Oracle) wrote:
> > On Fri, Feb 24, 2023 at 06:09:20PM +0200, Vladimir Oltean wrote:
> > > On Fri, Feb 24, 2023 at 03:58:15PM +0000, Russell King (Oracle) wrote:
> > > > I'll also send another patch to delete linux/phylink.h from
> > > > ocelot_ext.c - seems that wasn't removed when the phylink instance
> > > > was removed during review.
> > > 
> > > Good point. I suppose that would be on net-next, after the 6th of March?
> > > I just hope we'll remember by then.
> > 
> > Yep - however, I'm facing challenges to build-testing it at the moment
> > as net-next is broken:
> > 
> > kernel/bpf/core.c: In function '___bpf_prog_run':
> > kernel/bpf/core.c:1914:3: error: implicit declaration of function 'barrier_nospec' [-Werror=implicit-function-declaration]
> >  1914 |   barrier_nospec();
> >       |   ^~~~~~~~~~~~~~
> > cc1: some warnings being treated as errors
> > 
> > ... so I'm going to send the patch as untested.
> > 
> > -- 
> > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
> 
> https://github.com/torvalds/linux/commit/f3dd0c53370e70c0f9b7e931bbec12916f3bb8cc
> 
> Can't deny it would be great to have this on net.git ASAP :)

Agreed, and thanks for the patch, my build-test on net.git succeeded
with that.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
