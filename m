Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 724ECF9427
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 16:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfKLP07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 10:26:59 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:47042 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbfKLP07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 10:26:59 -0500
Received: by mail-ed1-f65.google.com with SMTP id x11so15209098eds.13
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 07:26:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sUWqlS/hsfJI0XEDo9+MSkPMXxBqmTHV9p1epkPFouI=;
        b=oU6BpSteCf2L1YoR4VvpUy0f04YMHmP/K+7JpuBQjPpT6gELzCEP95nz7M1IPc7pbE
         jiXuAzu4lp06vyJjYv6p296rz09pHxZ3KFuwKmLK/m9OJOYIHhUuRSEtiWk07f9oPQy3
         OQnPB64Wq3R6X/qSosAgCPH9MADD4ihJqVPIbt3Pv6ckeOoxCGksXAuXsfV6O1vPwsFG
         hPV23t4Kf9DzZmMrsXBAI1BhBg/gkqlTov0OUs6Gal5ECCKiIMBQIo3SulOa/bISe8WM
         2NJNMoLiVghC3gZgexNFv6Dhd2xO85NpzkJvFBJ8xFxRJqtAreVcCAo+UQyMSyiMruhA
         GEvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sUWqlS/hsfJI0XEDo9+MSkPMXxBqmTHV9p1epkPFouI=;
        b=Amd6AoWOs3hY5qoajQu3x1Tl5T+q49lIoY+OXqPE+/zHggLe50B3TAmmgtEYH3B5j9
         VrLxuNlWDaopwuFg1hDRSu72fC4BkFJQrq0s2hpqPYwFvhWQAjPOcdqhR5wekB/UnCFv
         MCvk0+VHc1EK7C+3U/pecgQI1jvAIZ0F7KoXNIgCQznDdT2W7HhDprXLu7MMAvN8IIWC
         YU9a4vQMEiV9sSLZMsuoMJPv7mt9+cqBU1tz5kV/2orKeY8ej5WuSy9E2DsnSKZWDDOM
         S/qZzPcOwElppcejumqOyvcfkn3GOBSd+q+nBKeNcfIZ52S5/j+F9+TdSL1p7u4PxqIB
         wfeQ==
X-Gm-Message-State: APjAAAWG5ZO+NEcaxDsyvH8FqBpq1bBCpZ82Yx6tFXGlMstEbhExEz/S
        sRkaOfuZnxOEXNfuVB0pRGN+vmFJI2K6o+qUNB0=
X-Google-Smtp-Source: APXvYqzWQ+/x4efOg3xsfabE6PEOfdFz2/ELRyxANP/du2VXfvrpsmgIUP0cgoVGROvbtSQkK9xS6CKBx2Q/epcflQg=
X-Received: by 2002:aa7:d44c:: with SMTP id q12mr33338720edr.108.1573572417510;
 Tue, 12 Nov 2019 07:26:57 -0800 (PST)
MIME-Version: 1.0
References: <20191112124420.6225-1-olteanv@gmail.com> <20191112124420.6225-11-olteanv@gmail.com>
 <20191112130947.GE3572@piout.net> <CA+h21hqYynoGwfd=g3rZFgYSKNxsv8PXstD+6btopykweEi1dw@mail.gmail.com>
 <20191112143346.3pzshxapotwdbzpg@lx-anielsen.microsemi.net>
 <20191112145054.GG10875@lunn.ch> <20191112145732.o7pkbitrvrr2bb7j@lx-anielsen.microsemi.net>
In-Reply-To: <20191112145732.o7pkbitrvrr2bb7j@lx-anielsen.microsemi.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 12 Nov 2019 17:26:46 +0200
Message-ID: <CA+h21hrc-vb412iK+hp20K6huFPBABx6xYQjgi7Ew7ET8ryK+g@mail.gmail.com>
Subject: Re: [PATCH net-next 10/12] net: dsa: vitesse: move vsc73xx driver to
 a separate folder
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Nov 2019 at 16:57, Allan W. Nielsen
<allan.nielsen@microchip.com> wrote:
>
> The 11/12/2019 15:50, Andrew Lunn wrote:
> > External E-Mail
> >
> >
> > > > > As there are no commonalities between the vsc73xx and felix drivers,
> > > > > shouldn't you simply leave that one out and have felix in the existing
> > > > > microchip folder?
> > > > >
> > > >
> > > > I don't have a strong preference, although where I come from, all new
> > > > NXP networking drivers are still labeled as "freescale" even though
> > > > there is no code reuse. There are even less commonalities with
> > > > Microchip (ex-Micrel, if I am not mistaken) KSZ switches than with the
> > > > old vsc73xx. I'll let the ex-Vitesse people decide.
> > > I'm on the same page as Alexandre here.
> >
> > Leaving them where they are makes maintenance easier. Fixes are easier
> > to backport if things don't move around.
> >
> > > I think we should leave vsc73xx where it is already, and put the felix driver in
> > > the drivers/net/ethernet/mscc/ folder where ocelot is already.
> >
> > Currently, all DSA drivers are in drivers/net/dsa. We do occasionally
> > make changes over all DSA drivers at once, so it is nice they are all
> > together. So i would prefer the DSA part of Felix is also there. But
> > the core can be in drivers/net/ethernet/mscc/.
> Ahh, my bad.
>
> In that case I do not have any strong feelings on this either.
>
> I should say that we are discussing to add support for a Ocelot VSC7511 as a DSA
> driver. This one does not have an internal MIPS CPU.
>
> The vsc73xx, felix and the drivers in dsa/microchip does not share any
> functionallity. Not in SW and not in HW.
>
> Maybe felix should just go directly into drivers/net/dsa/, and then if we add
> support for VSC7511 then they can both live in drivers/net/dsa/ocelot/
>
> /Allan

When the felix driver is going to support the vsc7511 ocelot switch
through the ocelot core, it will be naming chaos. Maybe we need to
clarify what "felix" means (at the moment it means VSC9959). What if
we just make it mean "DSA driver for Ocelot", and it supports both the
VSC751x (Ocelot) and the VSC9959 (Felix) families? Is anybody else
instantiating the VSC9959 core, or close derivatives, except NXP
LS1028A? If the answer is yes, are those other instantiations PCI
devices, or something else? I would appreciate if you could take a
look through the probing part of patch 11/12 (the "felix_instance_tbl"
part and felix-regs.c) and see if there are any naming changes I can
make that would make it easier for you to fit in one more device. Of
course, I don't expect to make radical changes, you'd still need to do
some refactoring if you decide to add your vsc7511, I just care that
the refactoring doesn't change any current semantics.

Regards,
-Vladimir
