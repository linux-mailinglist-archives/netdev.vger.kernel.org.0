Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED3031A8D4
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhBMAh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:37:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhBMAhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 19:37:25 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36B5C061574
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:36:44 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id t5so1780353eds.12
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=a5xI+nZpqBNRqRp13eVNUZef8sxzhGaTd7js2pAroLw=;
        b=iIng7U6+yWyA+Tr5/60nJM4JMdDuzGToTW6yFDX0HA0yU/ELMpNbCluybTg6xcXVDG
         tCUBOVNtZzFyuBGusfkVX0OMcjtztXr1EyYHGsytcitSzW39fWcy586T4bEpN5QCdaN+
         pq4Ba/sf5UHDLjktD3Nkj+lqj1ed2QF3evig2fJ0MHWaAvxOBIyeA8j0Ph/7F4+oO7RC
         Q7AtwBwv1S0TvjZyoqoaUyc7pLp7a+rqDkPWqVSikOqRmJrjLu6ylOcZez4oHA1riL26
         7RuLA3pJA+XYf5RcwHHkPH1rQRfphyXY7QdzFbln22KxB2BlZX56WwkOsxCaQQfcZkzo
         FZig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=a5xI+nZpqBNRqRp13eVNUZef8sxzhGaTd7js2pAroLw=;
        b=B/u+J1/ARxLxZn/lOWznnIfqBD3GJ040iIaB1dwI1GpMCJXxRcmNZ62Mkpp8boBx8M
         LvndAENDPBj6Anc3eycbh3nm8Z0fiZiAd7HPH31ODFgeOQOz7gcus4ATyfk9KcqCisS0
         5L/RhsjpA/TVsh7wwg0M2KPNPkJYzUo53OyXG8Vdo+p3MHb7aDFZp9/8PcksQ/Us9a1w
         vKRdVcQVXSLmA9E62ysZvVe13PhuOuVQn4CcTLAwsrasgrc//PU31i6aczm3rvKVYMxO
         TEXeK2rgUDaQB0gY1clMiyrmsNbCmKuZ4O5UUS8Hw9fy5ZBvBx3Xw4E7dr9/zerI+IPQ
         eogQ==
X-Gm-Message-State: AOAM531s7y7r7e/iOgfBN/l2J8uMg0XN17IA7ndvF784WNpQFCIMmBT9
        EvS603XArPu5sPj1yp7HjXI=
X-Google-Smtp-Source: ABdhPJzk32VlVD8r/B0etvg9z/tB0/KCh6AgmupRO7wS9rZ2gwe7PVUhNhVpcKgP6DempDEpm5JC3Q==
X-Received: by 2002:a05:6402:310a:: with SMTP id dc10mr6102645edb.258.1613176603541;
        Fri, 12 Feb 2021 16:36:43 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id q9sm7042812ejd.113.2021.02.12.16.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 16:36:43 -0800 (PST)
Date:   Sat, 13 Feb 2021 02:36:41 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 1/2] net: phylink: explicitly configure in-band
 autoneg for PHYs that support it
Message-ID: <20210213003641.gybb6gstjpkcwr6z@skbuf>
References: <20210212172341.3489046-1-olteanv@gmail.com>
 <20210212172341.3489046-2-olteanv@gmail.com>
 <eb7b911f4fe008e1412058f219623ee2@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb7b911f4fe008e1412058f219623ee2@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 11:40:59PM +0100, Michael Walle wrote:
> Am 2021-02-12 18:23, schrieb Vladimir Oltean:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > Currently Linux has no control over whether a MAC-to-PHY interface uses
> > in-band signaling or not, even though phylink has the
> > 	managed = "in-band-status";
> > property which denotes that the MAC expects in-band signaling to be
> > used.
> > 
> > The problem is really that if the in-band signaling is configurable in
> > both the PHY and the MAC, there is a risk that they are out of sync
> > unless phylink manages them both. Most if not all in-band autoneg state
> > machines follow IEEE 802.3 clause 37, which means that they will not
> > change the operating mode of the SERDES lane from control to data mode
> > unless in-band AN completed successfully. Therefore traffic will not
> > work.
> > 
> > It is particularly unpleasant that currently, we assume that PHYs which
> > have configurable in-band AN come pre-configured from a prior boot stage
> > such as U-Boot, because once the bootloader changes, all bets are off.
> 
> Fun fact, now it may be the other way around. If the bootloader doesn't
> configure it and the PHY isn't reset by the hardware, it won't work in
> the bootloader after a reboot ;)

My understanding is that this is precisely the reason why the U-Boot
people don't want to support booting from RAM, and want to assume that
the nothing else ran between Power On Reset and the bootloader:
https://www.denx.de/wiki/view/DULG/CanUBootBeConfiguredSuchThatItCanBeStartedInRAM
[ that does make me wonder what they think about ARM TF-A ]

> > Let's introduce a new PHY driver method for configuring in-band autoneg,
> > and make phylink be its first user. The main PHY library does not call
> > phy_config_inband_autoneg, because it does not know what to configure it
> > to. Presumably, non-phylink drivers can also call
> > phy_config_inband_autoneg
> > individually.
> 
> If you disable aneg between MAC and PHY, what would be the actual speed
> setting/duplex mode then? I guess it have to match the external speed?
> 
> I'm trying this on the AT8031. I've removed 'managed = "in-band-status";'
> for the PHY. Confirmed that it won't work and then I've implemented your
> new callback. That will disable the SGMII aneg (which is done via the
> BMCR of fiber page if I'm not entirely mistaken); ethernet will then
> work again. But only for gigabit. I presume because the speed setting
> of the SGMII link is set to gigabit.

Which MAC driver are you testing on? Are you saying that it doesn't
force the link to the speed resolved over MDIO and passed to
.phylink_mac_link_up, or that the speed communicated to it is incorrect?
