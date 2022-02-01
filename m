Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A714A65A8
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 21:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235672AbiBAU2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 15:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235324AbiBAU2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 15:28:43 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 025DCC061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 12:28:43 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id i186so14428236pfe.0
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 12:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lZCavQiLxcQ3MFz6ypEi3cjAjHA5JuYNVJ64uURs1W8=;
        b=X8ZLOaGsq7z/Mak67fZaRCM1jO2c7xJ9XxPz+xdtSeAd7UkfetIlD9oeQlrOpSwyJd
         vqCV+wjQVIsJ9R2Img8Yj6I8JCZtTDz568kaDeGi9iiio1IbeamUvj9wz1dpHGvxrm6T
         viAJs8qQ+NnTbLMJrUepEXoNsqwIWYr2XnoStbTCB61kXyNsxoZyMrgejErntPZnlWpn
         xUS7CBVD0L/EFV/isG9PnJtoBbDgb9zDInYKQmDxPL943jrFEmb2yEBYIWpk4XuXaAsM
         2vZUSy7aEwEJGuKjruMGchoL5uIN9hdZxyc8u0h/LuH3xDMVJttYkNEoeYsesf5aEAHu
         b6Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lZCavQiLxcQ3MFz6ypEi3cjAjHA5JuYNVJ64uURs1W8=;
        b=ptEFvLwhh9+b/fXAfrcZsUqvG/savEvUnVppI9k7nWUXGW0RJMyuplwbgPqTnLFvMQ
         tGuYiIcNzAL+QPONzXC3t7Y3G63W4lhhfgwUnaOdurcm2XwJGcDWBw0SlkigMTO6SE4g
         Zz9CF1bLpJG/MJg4/cdppwCxbfO/lL1ChoYy9EX1kTtL+Vt12mB7QbzqrYMcI5V1gXM+
         75OKrlci7x/7G/lcjUh0J7ip//pz7T8WsHHUNuNWbsBsjfxL1a6TDKsYP4BvlwqcZjOO
         avt6coKEyTg6tk61hbE3FQKYgVGCnp8eI6lN2wVmi6fXDJNZ9gyamDkXI18E+RLHtfWZ
         h9rA==
X-Gm-Message-State: AOAM533xe6FbKYrfaU0FmLXEo5w1t240UsLt7opgWdEcgaBq14SyeQj5
        KzQfKDg6uBCSmK/gNp038XVo5psXXI1x4haW6P0e8A==
X-Google-Smtp-Source: ABdhPJwzXjWJU3xLJEav1LZ4qFQQzgqDWfrW9IO58fRCskMADbzQL/mgR+osZF+ff7Ju+0gU1kwd1YvqJ7kTZ4oTTY0=
X-Received: by 2002:a05:6a00:728:: with SMTP id 8mr26552400pfm.27.1643747322379;
 Tue, 01 Feb 2022 12:28:42 -0800 (PST)
MIME-Version: 1.0
References: <20210719082756.15733-1-ms@dev.tdt.de> <CAJ+vNU3_8Gk8Mj_uCudMz0=MdN3B9T9pUOvYtP7H_B0fnTfZmg@mail.gmail.com>
 <94120968908a8ab073fa2fc0dd56b17d@dev.tdt.de> <CAJ+vNU2Bn_eks03g191KKLx5uuuekdqovx000aqcT5=f_6Zq=w@mail.gmail.com>
 <Yd7bsbvLyIquY5jn@shell.armlinux.org.uk> <CAJ+vNU1R8fGssHjfoz-jN1zjBLPz4Kg8XEUsy4z4bByKS1PqQA@mail.gmail.com>
 <81cce37d4222bbbd941fcc78ff9cacca@dev.tdt.de>
In-Reply-To: <81cce37d4222bbbd941fcc78ff9cacca@dev.tdt.de>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Tue, 1 Feb 2022 12:28:31 -0800
Message-ID: <CAJ+vNU3NXAgfJ4t3c8RBsZVLLY_OXkZLFDhro8X84x0DAuNEdw@mail.gmail.com>
Subject: Re: [PATCH net-next v6] net: phy: intel-xway: Add RGMII internal
 delay configuration
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        martin.blumenstingl@googlemail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, hkallweit1@gmail.com,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 10:32 PM Martin Schiller <ms@dev.tdt.de> wrote:
>
> On 2022-01-12 19:25, Tim Harvey wrote:
> > On Wed, Jan 12, 2022 at 5:46 AM Russell King (Oracle)
> > <linux@armlinux.org.uk> wrote:
> >>
> >> On Tue, Jan 11, 2022 at 11:12:33AM -0800, Tim Harvey wrote:
> >> > I added a debug statement in xway_gphy_rgmii_init and here you can see
> >> > it gets called 'before' the link comes up from the NIC on a board that
> >> > has a cable plugged in at power-on. I can tell from testing that the
> >> > rx_delay/tx_delay set in xway_gphy_rgmii_init does not actually take
> >> > effect unless I then bring the link down and up again manually as you
> >> > indicate.
> >> >
> >> > # dmesg | egrep "xway|nicvf"
> >> > [    6.855971] xway_gphy_rgmii_init mdio_thunder MDI_MIICTRL:0xb100
> >> > rx_delay=1500 tx_delay=500
> >> > [    6.999651] nicvf, ver 1.0
> >> > [    7.002478] nicvf 0000:05:00.1: Adding to iommu group 7
> >> > [    7.007785] nicvf 0000:05:00.1: enabling device (0004 -> 0006)
> >> > [    7.053189] nicvf 0000:05:00.2: Adding to iommu group 8
> >> > [    7.058511] nicvf 0000:05:00.2: enabling device (0004 -> 0006)
> >> > [   11.044616] nicvf 0000:05:00.2 eth1: Link is Up 1000 Mbps Full duplex
> >>
> >> Does the kernel message about the link coming up reflect what is going
> >> on physically with the link though?
> >>
> >> If a network interface is down, it's entirely possible that the link
> >> is
> >> already established at the hardware level, buit the "Link is Up"
> >> message
> >> gets reported when the network interface is later brought up. So,
> >> debugging this by looking at the kernel messages is unreliable.
> >>
> >
> > Russell,
> >
> > You are correct... the link doesn't come up at that point its already
> > linked. So we need to force a reset or an auto negotiation reset after
> > modifying the delays.
> >
> > Tim
>
> Setting BMCR_ANRESTART would work, but only if BMCR_ANENABLE is also or
> already set. Otherwise BMCR_ANRESTART has no effect (see the note in the
> datasheet).
>
> This is the reason why I came up with the idea of BMCR_PDOWN.
>
> Personally I would have no problem with setting BMCR_ANRESTART and
> BMCR_ANENABLE, but it would possibly change the existing configuration
> if (e.g. by the bootloader) aneg should be disabled.
>

Martin,

Sorry for the silence - I've been trying to figure out if and how I
can deal with some very nasty errata on this particular PHY that can
cause the link to not be stable and/or excessive errors in packets
sent to the MAC.

I do like the idea of BMCR_PDOWN. With my board its pretty obvious if
the pin-strapped rx/tx delays are being used rather than the ones
configured in the phy driver, so I'll have to do some testing when I
find some time. However, I don't at all like the fact that this
particular patch defaults the delays to 2ns if 'rx-internal-delay-ps'
and 'tx-internal-delay-ps' is missing from the dt.

These properties were added via Dan Murphy's series 'RGMII Internal
delay common property' which was merged into v5.9:
8095295292b5 ("net: phy: DP83822: Add setting the fixed internal delay")
736b25afe284 ("net: dp83869: Add RGMII internal delay configuration")
2fb305c37d5b ("dt-bindings: net: Add RGMII internal delay for DP83869")
92252eec913b ("net: phy: Add a helper to return the index for of the
internal delay")
9150069bf5fc dt-bindings: net: Add tx and rx internal delays

The issue I have here is that if dt's have not been updated to add the
common delay properties this code will override what the boot firmware
may have configured them to. I feel that if these common delay
properties are not found in the device tree, then no changes to the
delays should be made at all.

Best Regards,

Tim
