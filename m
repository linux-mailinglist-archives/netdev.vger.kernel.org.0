Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89CE31322CC
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 10:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbgAGJqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 04:46:42 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36167 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgAGJqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 04:46:42 -0500
Received: by mail-ed1-f66.google.com with SMTP id j17so49839169edp.3
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 01:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gYelitEP+u7jO1w3Owd2/Poz2vG4KxnwXEr16WpKPLk=;
        b=ZKjiK3wZHYFWowgjxfY52NHWeGc+CFLEgllLCixO/SAQLnA43SMeWJt2fnqkh/UwNW
         CvWG7blGvUm/6jlAbFMLw1Xr0ENG2IO5xi3+TEPnnWINA/fT1m2E9aT8SDD1lnpeXXvL
         5nNHG5r/W55arKHvb8QBW5z1hqKbWyW2prVkkw+BLDGdLX/qGyOOZo1Y6BCwydBT00/X
         aYjewbOy1cns2gIAtTAy207T9770nhZtoZPezEfcC01vgIofS9Zn0/km5Mk6KHbF9410
         dGbSrZEBhVUxfkNwzE0BtxCGdHq4PqN4ve/aZi1uNidhPwBLw+nu+dCKttnronJhx5Fa
         6ogA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gYelitEP+u7jO1w3Owd2/Poz2vG4KxnwXEr16WpKPLk=;
        b=IYwIIwqjbGmMKTjYBM5txg+CgEg2Y52W95SSo3lmRohcv6hbDCdsCSvEKBQVHdU6bn
         3L8C8k/7LLPm1MQf0gaYuPsrIkJTwfrXFJyiVZbtj0vvsx2z0hhB573EoxPYWWaD+6Yl
         d2H0DbHzbRz8BpT2lPbcFGdGm5MxOkaIfJadlSw2JfqniBM/KzAR65qLShvTOxuQ5Oh9
         DL6MKEnnlX8MUqQC/iTI80xWuPmVzpfIm1aEHmQmc+L9nC7zaFMlIoQM9d5Ig+F6Vy5S
         yU1YVfqJ4Rv2xoONi6rhx3r9hTcOlz5zW04EF1buEl+OuzNtMx/cMlN4RTGgArkkScBm
         3wcg==
X-Gm-Message-State: APjAAAWF7RXJiY++PcLvJPkbmr4wPLsSbULA01sIX2eeOdQ1hkdgt0iF
        5/TuaTonuy2KTmisjoB5ARpr8jTZsYdzmQMwyFU=
X-Google-Smtp-Source: APXvYqwtnYYXoRJiz9nY7KODNAaIXBFCcMKif5gC6PEUpRqiS+0BcPXBxJX98K0GNQVVQu+CnL4jFz5DwfjEy93oats=
X-Received: by 2002:aa7:cccf:: with SMTP id y15mr7144759edt.108.1578390399493;
 Tue, 07 Jan 2020 01:46:39 -0800 (PST)
MIME-Version: 1.0
References: <20200106013417.12154-1-olteanv@gmail.com> <20200106013417.12154-6-olteanv@gmail.com>
 <8718ea22-d1aa-fe58-bd69-521eeee5190a@gmail.com> <CA+h21hotFQ9UbxbsQRk2TvTb4H27hfqYK+mX=3urqOoTnaLMDg@mail.gmail.com>
 <86c9b320-bed5-a00b-24aa-494a1d7f91d0@gmail.com>
In-Reply-To: <86c9b320-bed5-a00b-24aa-494a1d7f91d0@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 7 Jan 2020 11:46:28 +0200
Message-ID: <CA+h21hqMtH12W8ZWw9iFdCJFsX2RCv4hO=9nfa0SDKCHar8i9Q@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 5/9] enetc: Make MDIO accessors more generic
 and export to include/linux/fsl
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>, netdev <netdev@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Jan 2020 at 06:56, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 1/6/2020 3:00 PM, Vladimir Oltean wrote:
> > Hi Florian,
> >
> > On Mon, 6 Jan 2020 at 21:35, Florian Fainelli <f.fainelli@gmail.com> wrote:
> >>
> >> On 1/5/20 5:34 PM, Vladimir Oltean wrote:
> >>> From: Claudiu Manoil <claudiu.manoil@nxp.com>
> >>>
> >>> Within the LS1028A SoC, the register map for the ENETC MDIO controller
> >>> is instantiated a few times: for the central (external) MDIO controller,
> >>> for the internal bus of each standalone ENETC port, and for the internal
> >>> bus of the Felix switch.
> >>>
> >>> Refactoring is needed to support multiple MDIO buses from multiple
> >>> drivers. The enetc_hw structure is made an opaque type and a smaller
> >>> enetc_mdio_priv is created.
> >>>
> >>> 'mdio_base' - MDIO registers base address - is being parameterized, to
> >>> be able to work with different MDIO register bases.
> >>>
> >>> The ENETC MDIO bus operations are exported from the fsl-enetc-mdio
> >>> kernel object, the same that registers the central MDIO controller (the
> >>> dedicated PF). The ENETC main driver has been changed to select it, and
> >>> use its exported helpers to further register its private MDIO bus. The
> >>> DSA Felix driver will do the same.
> >>
> >> This series has already been applied so this may be food for thought at
> >> this point, but why was not the solution to create a standalone mii_bus
> >> driver and have all consumers be pointed it?
> >>
> >
> > I have no real opinion on this.
> >
> > To be honest, the reason is that the existing "culture" of Freescale
> > MDIO drivers wasn't to put them in drivers/net/phy/mdio-*.c, and I
> > just didn't look past the fence.
> >
> > But what is the benefit? What gets passed between bcmgenet and
> > mdio-bcm-unimac with struct bcmgenet_platform_data is equivalent with
> > what gets passed between vsc9959 and enetc_mdio with the manual
> > population of struct mii_bus and struct enetc_mdio_priv, no? I'm not
> > even sure there is a net reduction in code size. And I am not really
> > sure that I want an of_node for the MDIO bus platform device anyway.
> > Whereas genet seems to be instantiating a port-private MDIO bus for
> > the _real_ (but nonetheless embedded) PHY, the MDIO bus we have here
> > is for the MAC PCS, which is more akin to the custom device tree
> > binding "pcsphy-handle" that the DPAA1 driver is using (see
> > arch/arm64/boot/dts/qoriq-fman3-0-10g-0.dtsi for example). So there is
> > no requirement to run the PHY state machine on it, it's just locally
> > driven, so I don't want to add a dependency on device tree where it's
> > really not needed. (By the way I am further confused by the
> > undocumented/unused "brcm,40nm-ephy" compatible string that these
> > device tree bindings for genet have).
>
> That compatibility string should not have been defined, but the DTS were
> imported from our Device Tree auto-generation tool that did produce
> those, when my TODO list empty, I might send an update to remove those,
> unless someone thinks it's ABI and it would break something (which I can
> swear won't).
>
> >
> >> It is not uncommon for MDIO controllers to be re-used and integrated
> >> within a larger block and when that happens whoever owns the largest
> >> address space, say the Ethernet MAC can request the large resource
> >> region and the MDIO bus controler can work on that premise, that's what
> >> we did with genet/bcmmii.c and mdio-bcm-unimac.c for instance (so we
> >> only do an ioremap, not request_mem_region + ioremap).
> >>
> >
> > I don't really understand this. In arch/mips/boot/dts, for all of
> > bcm73xx and bcm74xx SoCs, you have a single Ethernet port DT node, and
> > a single MDIO bus as a child beneath it, where is this reuse that you
> > mention?
> > And because I don't really understand what you've said, my following
> > comment maybe makes no sense, but I think what you mean by "MDIO
> > controller reuse" is that there are multiple instantiations of the
> > register map, but ultimately every transaction ends up on the same
> > MDIO/MDC pair of wires and the same electrical bus.
> > We do have some of that with the ENETC, but not with the switch, whose
> > internal MDIO bus has no connection to the outside world, it just
> > holds the PCS front-ends for the SerDes.
> > I also don't understand the reference to request_mem_region, perhaps
> > it would help if you could show some code.
>
> What I forgot telling you about is that the same MDIO bus controller is
> used internally by each GENET instance to "talk" to both external and
> internal PHYs, but also by the bcm_sf2.c driver which is why it made
> sense to have a standalone MDIO bus driver that could either be
> instantiated on its own (as is the case with bcm_sf2) or as part of a
> larger block within GENET. The request_mem_region() + ioremap() comment
> is because you cannot have two resources that overlap be used with
> request_mem_region(), since the MDIO bus driver is embedded into a
> larger block, it simply does an ioremap. If that confused you, then you
> can just discard that comment, is it not particularly relevant.
>

So we don't typically have the external MDIO controller be part of the
memory map of an Ethernet port, it has its own region in the SoC. But
this is not an external MDIO controller, and it's a completely
separate hardware instance with its own memory region not shared with
anybody else.

And I think your need for registering the slave MDIO bus in the
Starfighter 2 switch driver, on top of the same memory region as the
GENET's MDIO bus, is just to work around the fact that the switch
pseudo-PHY MDIO address is fixed at 30 on some chips, and you need to
intercept those transactions by wrapping the mii_bus->read and
mii_bus->write methods of the master, otherwise none of this would
have been needed.
If I understand correctly, couldn't you have just overridden the
mii_bus->read and mii_bus->write ops of the master MDIO bus, without
registering another one?

> >
> >> Your commit message does not provide a justification for why this
> >> abstraction (mii_bus) was not suitable or considered here. Do you think
> >> that could be changed?
> >>
> >
> > I'm sorry, was the mii_bus abstraction really not considered here?
> > Based on the stuff exported in this patch, an mii_bus is exactly what
> > I'm registering in 9/9, no?
>
> I meat in the commit message, there is no justification why this was not
> considered or used, by asking you ended up providing one, that is
> typically what one would expect to find to explain why something was/was
> not considered. It's fine, the code is merge, I won't object or require
> you to use a mii_bus abstraction.

So I answered your question? If so, it was by mistake, because I still
don't exactly understand your point (although I would like to).
The difference is that we don't register a new platform device for the
mii_bus (we use mii_bus->dev = ocelot->dev), and that it's not in
drivers/net/phy/mdio-fsl-enetc.c, although it could be, but I don't
see a clear benefit.

> --
> Florian

Regards,
-Vladimir
