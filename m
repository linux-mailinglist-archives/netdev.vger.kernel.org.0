Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6550D6A5D16
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 17:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjB1Q2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 11:28:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjB1Q2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 11:28:10 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BF232E4E
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 08:27:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=u5sKNAitcMtv2RKOJN6eYLOnItxpd2ND8/JSXpwzxqQ=; b=r2qDN+YffU7ztJvlXdDRZf9q6f
        5haEhcedBrhQwrqivqAPrdQVwMFdDG70+OQMh/iayCDYwS0iW0Qc6yJYpETxF7x09ElzVJ6B+BQ7w
        jPrLd+G930QbdzM3X5ts6gTagSwaiMVuiVdDPK5Uu8ey9ySTNH8WRRiWZMYkPkwpzRPoGxRQhs48l
        vFRYx1jMS/ZE424/sOHw+wwtYGQnsna25FBbZ4VBRFRwUrQnFyJorR350PnICbtXWpzmUjjBAxSuz
        xK+kXi711Zy57kwXsdBv9/GGAfHLL6ilAnceGvMdQNVXSYIp4GVRmqQDxnj3whBEtxxmCEbLFmsca
        Is0/hNzA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47416)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pX2oq-00050K-Kx; Tue, 28 Feb 2023 16:27:12 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pX2oo-0002rq-Cx; Tue, 28 Feb 2023 16:27:10 +0000
Date:   Tue, 28 Feb 2023 16:27:10 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
        andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <Y/4rXpPBbCbLqJLY@shell.armlinux.org.uk>
References: <20200730124730.GY1605@shell.armlinux.org.uk>
 <20230227154037.7c775d4c@kmaincent-XPS-13-7390>
 <Y/zKJUHUhEgXjKFG@shell.armlinux.org.uk>
 <Y/0Idkhy27TObawi@hoboy.vegasvil.org>
 <Y/0N4ZcUl8pG7awc@shell.armlinux.org.uk>
 <Y/0QSphmMGXP5gYy@hoboy.vegasvil.org>
 <Y/3ubSj5+2C5xbZu@shell.armlinux.org.uk>
 <20230228141630.64d5ef63@kmaincent-XPS-13-7390>
 <Y/4ayPsZuYh+13eI@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y/4ayPsZuYh+13eI@hoboy.vegasvil.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 07:16:24AM -0800, Richard Cochran wrote:
> On Tue, Feb 28, 2023 at 02:16:30PM +0100, Köry Maincent wrote:
> > On Tue, 28 Feb 2023 12:07:09 +0000
> > "Russell King (Oracle)" <linux@armlinux.org.uk> wrote:
> > > So yes, it's a nice idea to support multiple hardware timestamps, but
> > > I think that's an entirely separate problem to solving the current
> > > issue, which is a blocking issue to adding support for PTP on some
> > > platforms.
> > 
> > Alright, Richard can I continue your work on it and send new revisions of your
> > patch series or do you prefer to continue on your own?
> 
> If you can work this, please do.  I can help review and test.
> 
> > Also your series rise the question of which timestamping should be the default,
> > MAC or PHY, without breaking any past or future compatibilities.
> > There is question of using Kconfig or devicetree but each of them seems to have
> > drawbacks:
> > https://lore.kernel.org/netdev/ad4a8d3efbeaacf241a19bfbca5976f9@walle.cc/ 
> > 
> > Do you or Russell have any new thought about it?
> 
> The overall default must be PHY, because that is the legacy condition.
> The options to change the default are:
> 
> 1. device tree: Bad because the default is a configuration and does
>    not describe the hardware.

I'm quite sure the DT maintainers will frown upon that.

> 2. Kconfig: Override PHY default at compile time.

That doesn't work for Arm (32 or 64 bit) kernels as we want a single
kernel image that will work correctly on any platform, so as soon as
we have two platforms that needs the Kconfig set differently, this
becomes a problem.

> 3. Module Param: Configure default on kernel command line.

I understand module parameters are frowned upon by netdev.

> 4. Letting drivers override PHY at run time.

I think this is the only sensible solution - we know for example that
mvpp2 will prefer its PTP implementation as it is (a) higher resolution
and (b) has more flexibility than what can be provided by the Marvell
PHYs that it is often used with.

> 5. other?

Another possible solution to this would be to introduce a rating for
each PTP clock in a similar way that we do for the kernel's
clocksources, and the one with the highest rating becomes the default. 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
