Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4F655FCE2
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 12:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbiF2KKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 06:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiF2KKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 06:10:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E6B22B06
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 03:10:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B256661ED4
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 10:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFEF3C34114;
        Wed, 29 Jun 2022 10:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656497429;
        bh=gumbGasP0T/XEgPCejFFb3EYwfVesF4bIVPFRQ3YSN8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VdOsgqg+RS0Ue5vKZjp9OLNtY8fNDwj8+ERoCCon3jm+WRMH3w4o3HGhst8x8Y+13
         BoUfpZ3GStSsD3sgeAoc+EhVdYpi6Y5yavqeFNY/JOoptTR3fnKMsbhOdaK6o8Wxkl
         PIOtTjg2cDd+f2FE0TroCywxwOf4ueVSA+XiXe8ri8+AVF2JochONNwSJpghPYujBk
         lw2tV8ON9hAhmfvcreLyfwAGZcKE1zSthSaFQC8at2g0mwqD2IDe9zNbVy2+xafeGy
         OFuCinYQQ6u7FfnCsv78UpaF7bm04xZIW33N0RedubgVMsnPsRxGtn3h4Nue1nkgn0
         XoGgH85eABDog==
Date:   Wed, 29 Jun 2022 12:10:20 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin =?UTF-8?B?xaBp?= =?UTF-8?B?cHJhZ2E=?= 
        <alsi@bang-olufsen.dk>, Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH RFC net-next 0/4] net: dsa: always use phylink
Message-ID: <20220629121020.583144a5@thinkpad>
In-Reply-To: <YrweuzL2LYNbfvAY@shell.armlinux.org.uk>
References: <YrWi5oBFn7vR15BH@shell.armlinux.org.uk>
        <YrtvoRhUK+4BneYC@shell.armlinux.org.uk>
        <Yrv8snvIChmoNPwh@lunn.ch>
        <YrweuzL2LYNbfvAY@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jun 2022 10:43:23 +0100
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Wed, Jun 29, 2022 at 09:18:10AM +0200, Andrew Lunn wrote:
> > > I should point out that if a DSA port can be programmed in software to
> > > support both SGMII and 1000baseX, this will end up selecting SGMII
> > > irrespective of what the hardware was wire-strapped to and how it was
> > > initially configured. Do we believe that would be acceptable?  
> > 
> > I'm pretty sure the devel b board has 1000BaseX DSA links between its
> > two switches. Since both should end up SGMII that should be O.K.  
> 
> Would such a port have a programmable C_Mode, and would it specify that
> it supports both SGMII and 1000BaseX ? Without going through a lot of
> boards and documentation for every switch, I can't say.
> 
> I don't think we can come to any conclusion on what the right way to
> deal with this actually is - we don't have enough information about how
> this is used across all the platforms we have. I think we can only try
> something, get it merged into net-next, and wait to see whether anyone
> complains.
> 
> When we have a CPU or DSA port without a fixed-link, phy or sfp specified,
> I think we should:
> (a) use the phy-mode property if present, otherwise,
> (b,i) have the DSA driver return the interface mode that it wants to use
> for max speed for CPU and DSA ports.
> (b,ii) in the absence of the DSA driver returning a valid interface mode,
> we use the supported_interfaces to find an interface which gives the
> maximum speed (irrespective of duplex?) that falls within the
> mac capabilities.
> 
> If all those fail, then things will break, and we will have to wait for
> people to report that breakage. Does this sound a sane approach, or
> does anyone have any other suggestions how to solve this?

It is a sane approach. But in the future I think we should get rid of
(b,i): I always considered the max_speed_interface() method a temporary
solution, until the drivers report what a specific port support and the
subsystem can then choose whichever mode it wants that is wired and
supported by hardware. Then we could also make it possible to change
the CPU interface mode via ethtool, which would be cool...

Marek
