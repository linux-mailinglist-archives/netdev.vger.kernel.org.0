Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84BD0376255
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 10:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236560AbhEGItM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 04:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236500AbhEGItC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 04:49:02 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC83C06138F;
        Fri,  7 May 2021 01:48:00 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id b25so12397454eju.5;
        Fri, 07 May 2021 01:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vDw2m1sRzoN0ZM/nLdYZm+yiOw/zvM+XfqkDAnVcm9Q=;
        b=uGnZe5moroaIe+5Ys0l4Ej0Fc7404idioP9vj0Ny8am93vxnoKk2Wy3D/8txoMosEI
         KSY4Afoul8yVQYK8HYQ2HXZs5hYehsZIEeG1XQJn5iuWrV+G0jyYzfyYJGp8dz1WGVIV
         CXXRARHkojItMaGXCK/NScKngCVwtsVHRddkQ6zjjapnFOmbtmnT778DUoDhXNvmbNa4
         Is0P2S39aYUwoHbZgBQR5sHICksE0kwDol3XAj6PZKzWqMXF0meHbT/zNT683Zx3aND4
         PzxH9lvStFnw7W4hiPMPra0TQrQw6jzFd1LtsG7yPPHKxp+oABd4UtpvBfWsBqZSqPh/
         MdVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vDw2m1sRzoN0ZM/nLdYZm+yiOw/zvM+XfqkDAnVcm9Q=;
        b=ST/IlGQuKwSgchGOmznm6jVY9qb/xvhUZv3HZeFXqbWcE7qS+iCo09MlrsXtoHkZNR
         44riqnfDCCDRWcRzEyo/uu6EfKXxH+plL3kPbCJJgke1PaKd2VwiWzWMJgH3e2hYrGcp
         mtIrpqbbNHERHNF00dP2zSng/UczA21VkfpTg5Nle5FHOHulGY7PAGOu3A924yjpoWCw
         +atHHpTOuRAgNGcNPZ+Repx6fVV70tLQfMsVAfzFfnXLHLrA0yTsKdxBRa5d8kP42aBt
         s5UpWRdz1k9zT9USTRqq32M+tCRlBmJ62GtVKIR35DyoswTvd2M2z8isuwCNMAMuAHh8
         haYw==
X-Gm-Message-State: AOAM531sOuVg15e2CDyNElG+w8AF+Pej+2Tw7L4j9Km5FV0eQVmkpJSs
        V+IfBrHdhzEM1DQIF2KwtOg=
X-Google-Smtp-Source: ABdhPJwrVWJUUVEwI+iiXXHporE2LH2KBWnoHUPFFN1J4F0RViULmB2Twl5J9t08Z3GOwu39O3mCyA==
X-Received: by 2002:a17:906:a295:: with SMTP id i21mr8753834ejz.160.1620377278982;
        Fri, 07 May 2021 01:47:58 -0700 (PDT)
Received: from skbuf ([86.127.41.210])
        by smtp.gmail.com with ESMTPSA id p22sm3628243edr.4.2021.05.07.01.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 01:47:58 -0700 (PDT)
Date:   Fri, 7 May 2021 11:47:57 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "supporter:OCELOT ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:OCELOT ETHERNET SWITCH DRIVER" <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH vN net-next 2/2] net: mscc: ocelot: add support for
 VSC75XX SPI control
Message-ID: <20210507084757.eau5camvi26ub2i3@skbuf>
References: <20210504051130.1207550-1-colin.foster@in-advantage.com>
 <20210504051130.1207550-2-colin.foster@in-advantage.com>
 <20210506102204.wuwwnoarn5r5cun2@skbuf>
 <20210506183418.GA10838@MSI.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506183418.GA10838@MSI.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 06, 2021 at 11:34:18AM -0700, Colin Foster wrote:
> Vladimir, Thank you very much for the feedback. I appreciate your time
> and your patience when dealing with my many blunders. This is a large
> learning experience for me.

You haven't seen mine...

> On Thu, May 06, 2021 at 01:22:04PM +0300, Vladimir Oltean wrote:
> > On Mon, May 03, 2021 at 10:11:27PM -0700, Colin Foster wrote:
> > > Add support for control for VSC75XX chips over SPI control. Starting with the
> > > VSC9959 code, this will utilize a spi bus instead of PCIe or memory-mapped IO to
> > > control the chip.
> > > 
> > > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > > ---
> > >  arch/arm/boot/dts/rpi-vsc7512-spi-overlay.dts |  124 ++
> > >  drivers/net/dsa/ocelot/Kconfig                |   11 +
> > >  drivers/net/dsa/ocelot/Makefile               |    5 +
> > >  drivers/net/dsa/ocelot/felix_vsc7512_spi.c    | 1214 +++++++++++++++++
> > >  include/soc/mscc/ocelot.h                     |   15 +
> > >  5 files changed, 1369 insertions(+)
> > >  create mode 100644 arch/arm/boot/dts/rpi-vsc7512-spi-overlay.dts
> > >  create mode 100644 drivers/net/dsa/ocelot/felix_vsc7512_spi.c
> > > 
> > > diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
> > > index 932b6b6fe817..2db147ce9fe7 100644
> > > --- a/drivers/net/dsa/ocelot/Kconfig
> > > +++ b/drivers/net/dsa/ocelot/Kconfig
> > > @@ -14,6 +14,17 @@ config NET_DSA_MSCC_FELIX
> > >  	  This driver supports the VSC9959 (Felix) switch, which is embedded as
> > >  	  a PCIe function of the NXP LS1028A ENETC RCiEP.
> > >  
> > > +config NET_DSA_MSCC_FELIX_SPI
> > > +	tristate "Ocelot / Felix Ethernet SPI switch support"
> > > +	depends on NET_DSA && SPI
> > > +	depends on NET_VENDOR_MICROSEMI
> > > +	select MSCC_OCELOT_SWITCH_LIB
> > > +	select NET_DSA_TAG_OCELOT_8021Q
> > > +	select NET_DSA_TAG_OCELOT
> > > +	select PCS_LYNX
> > 
> > You most probably don't need to select PCS_LYNX (that's an NXP thing).
> > For that reason, you might want to call your module NET_DSA_MSCC_OCELOT_SPI.
> > The "felix" name is just the name of the common DSA driver and of the
> > VSC9959 chip. VSC7512 is probably called Ocelot-1 according to Microchip
> > marketing.
> 
> Thank you. I couldn't find where "Felix" and "Seville" actually came
> from. My next RFC submission will include these changes.

felix = code name for the VSC9959 from NXP LS1028A, derivative of Ocelot-1
seville = code name for the VSC9953 from NXP T1040, derivative of Serval-1

The common DSA driver layer is called felix because felix was the first
switch it supported. But since probing is now handled individually and
the PCIe probing of felix is done in a different driver compared to the
platform device probing of seville, you can name your VSC7512 driver in
any way you feel appropriate.

> > I'm surprised that the reset procedure for VSC7512 is different than
> > what is implemented in ocelot_reset() for VSC7514.
> 
> I will look more into this and repair as needed. I'm also considering
> the ability to use a GPIO as an external reset, which might negate any
> reset procedure the MIPS would be doing.

I think some memories need to be initialized too, not sure if you can
achieve that with a reset pin only.

> > You must be working on an old kernel or something. There's also a
> > watermark decode function which you can reuse from ocelot (ocelot_wm_dec).
> 
> Yes, my proof-of-concept was from a 5.10 kernel. I brought it up to
> mainline before submitting the patch and must have missed this. Per the
> documentation, I'll base my next submission entirely on the latest 5.12
> release.

What you actually mean when you set the patch subject prefix to
"PATCH net-next" is that your patches can be applied to the current
master branch of this tree, not on any release tree:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/

The official kernel tag v5.12 has just been released, and kernel v5.13
entered release candidate status (starting with rc1 and ending with rc7
or rc8, depending on how many fixes it gets). The development process
happens simultaneously with the release candidates for the official
v5.13 release, but new development is done for v5.14 only (that's why it
is called "next"). When Linus decides that the v5.13 release candidates
are mature enough to print the v5.13 final release tag, development for
v5.14 stops too, the maintainers stop accepting development patches for
a little while, everybody prepares a pull request, there is a "memory
barrier" until the official v5.14 rc1 is released which contains all
pull requests with new features from the maintainers' development trees,
and then these "next" trees reopen for development that will be included
in v5.15.

This is a bit oversimplified, but hopefully it should give you an idea
why sometimes you are told to rebase on a different tree, or why you
can't send patches right now, etc.

> > > +static int felix_spi_remove(struct spi_device *pdev)
> > > +{
> > > +	struct felix *felix;
> > > +
> > > +	felix = spi_get_drvdata(pdev);
> > > +
> > > +	return 0;
> > > +}
> > 
> > You got bored of writing code here? :)
> 
> A bad habit of mine. I'm trying to test the code as I'm writing it.
> Communication doesn't work, so I can't get past probe. I'm excited for
> the day I can see this memory leak in action.
> 
> I'll repair this for RFC V2, regardless of whether I can test it.

By testing, you mean this?

echo spiN.M > /sys/bus/spi/drivers/vsc7512/unbind
echo spiN.M > /sys/bus/spi/drivers/vsc7512/bind

(where of course, N is the bus number and M is the chip select)
