Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03D7EF9A24
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 21:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfKLUBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 15:01:40 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35241 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfKLUBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 15:01:39 -0500
Received: by mail-ed1-f68.google.com with SMTP id r16so16066073edq.2
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 12:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VCjpXDi0o+CjPh7Lsc/CgK+2RJ4n7mek2rPWCDuj2mM=;
        b=lvnAIQu4RuzVba15dSY5w7R7T7HCB4MbEdAA59Ci/Uxbysb0/DIhSnwCgmmfy3DWnX
         ESvSS6x9A6N8HN9j/qpaOW1TdUXDn6zSlSk3AZGj9Kv/2kQRS0QHEVROwxqgIvrEMYF0
         Z9AytlKz+nAXVXCNi67RThgYmEuODgBliVyk4TsEdEf3lIcH+PNRFBk+M9OmnuHBrBGc
         w6SYCrhmaI61IJC+4UuyBfPOxelAlONM1J1c9WwQTtvxew9bNRKm0mgWLGLJs2xJX3th
         Lh9d/UVvvnP0rUMvYqT1KGYjZQvwti8pLWacmQQs6iA9hwIMmFfwrNDoEB8ukshnZswG
         jLfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VCjpXDi0o+CjPh7Lsc/CgK+2RJ4n7mek2rPWCDuj2mM=;
        b=bthLFv8/KW6wks1B0+J8v6tRhdpzb+E8eShLVWh9Bf9ZKCN36u08jQ9zkbylYbJKJd
         +zqPpIS3TWB3axkdnktmzhckO9379LMk5YQdgNuydpaVvhv10jLp8wC3qLflwZP7Qjgk
         WWDxE2NdR+cUY7vcieKXn4abnuLggA9ET0glAkn8pKAe64Rheb+pGEDiFQcbmpRbNWuz
         zv7j7An609n7phIrnFLTtmHvnVp+faCdC9Z8g6QpyZJjRQ3tTf26ZLts8bxIQ3RdfKvd
         7mRu3ZkcjY/WjLyfmAX9uGRe/kRfel5gphFlDatdxyb/IJtJqJqZQxwWSnFXxmyU40IR
         /I4A==
X-Gm-Message-State: APjAAAXeVl17NuPG77poYXmX0cg2HUD/iQGDFEkoVosD6S7nKMCT1keR
        xAAtfCc1rLgAU7diQ78KXQmEpHc7hOk/l1GJTT0=
X-Google-Smtp-Source: APXvYqw4mUG6mKbbB0LNRLxX7uG6uynpCm0LAgf7AVIB4QV3nrLHGo/icRm+M+xQVwLU44nhnig7FIK2fNm29JOAUaQ=
X-Received: by 2002:a17:906:3450:: with SMTP id d16mr17084021ejb.216.1573588896622;
 Tue, 12 Nov 2019 12:01:36 -0800 (PST)
MIME-Version: 1.0
References: <20191112124420.6225-1-olteanv@gmail.com> <20191112124420.6225-11-olteanv@gmail.com>
 <20191112130947.GE3572@piout.net> <CA+h21hqYynoGwfd=g3rZFgYSKNxsv8PXstD+6btopykweEi1dw@mail.gmail.com>
 <20191112143346.3pzshxapotwdbzpg@lx-anielsen.microsemi.net>
 <20191112145054.GG10875@lunn.ch> <20191112145732.o7pkbitrvrr2bb7j@lx-anielsen.microsemi.net>
 <CA+h21hrc-vb412iK+hp20K6huFPBABx6xYQjgi7Ew7ET8ryK+g@mail.gmail.com>
 <20191112190957.nbfb6g2bxiipjnbi@lx-anielsen.microsemi.net>
 <CA+h21hqo9dWct-068pGv2YhzACp5ooaDKzeh92jHNTYyBvgmqw@mail.gmail.com> <20191112194814.gmenwbje3dg52s6l@lx-anielsen.microsemi.net>
In-Reply-To: <20191112194814.gmenwbje3dg52s6l@lx-anielsen.microsemi.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 12 Nov 2019 22:01:25 +0200
Message-ID: <CA+h21hrh4oYs3j3cOz4Afe2GSbU9ME+nzoRaZ4D22mu9_jkO=g@mail.gmail.com>
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

On Tue, 12 Nov 2019 at 21:48, Allan W. Nielsen
<allan.nielsen@microchip.com> wrote:
>
> The 11/12/2019 21:26, Vladimir Oltean wrote:
> > External E-Mail
> >
> >
> > On Tue, 12 Nov 2019 at 21:10, Allan W. Nielsen
> > <allan.nielsen@microchip.com> wrote:
> > >
> > > The 11/12/2019 17:26, Vladimir Oltean wrote:
> > > > External E-Mail
> > > >
> > > >
> > > > On Tue, 12 Nov 2019 at 16:57, Allan W. Nielsen
> > > > <allan.nielsen@microchip.com> wrote:
> > > > >
> > > > > The 11/12/2019 15:50, Andrew Lunn wrote:
> > > > > > External E-Mail
> > > > > >
> > > > > >
> > > > > > > > > As there are no commonalities between the vsc73xx and felix drivers,
> > > > > > > > > shouldn't you simply leave that one out and have felix in the existing
> > > > > > > > > microchip folder?
> > > > > > > > >
> > > > > > > >
> > > > > > > > I don't have a strong preference, although where I come from, all new
> > > > > > > > NXP networking drivers are still labeled as "freescale" even though
> > > > > > > > there is no code reuse. There are even less commonalities with
> > > > > > > > Microchip (ex-Micrel, if I am not mistaken) KSZ switches than with the
> > > > > > > > old vsc73xx. I'll let the ex-Vitesse people decide.
> > > > > > > I'm on the same page as Alexandre here.
> > > > > >
> > > > > > Leaving them where they are makes maintenance easier. Fixes are easier
> > > > > > to backport if things don't move around.
> > > > > >
> > > > > > > I think we should leave vsc73xx where it is already, and put the felix driver in
> > > > > > > the drivers/net/ethernet/mscc/ folder where ocelot is already.
> > > > > >
> > > > > > Currently, all DSA drivers are in drivers/net/dsa. We do occasionally
> > > > > > make changes over all DSA drivers at once, so it is nice they are all
> > > > > > together. So i would prefer the DSA part of Felix is also there. But
> > > > > > the core can be in drivers/net/ethernet/mscc/.
> > > > > Ahh, my bad.
> > > > >
> > > > > In that case I do not have any strong feelings on this either.
> > > > >
> > > > > I should say that we are discussing to add support for a Ocelot VSC7511 as a DSA
> > > > > driver. This one does not have an internal MIPS CPU.
> > > > >
> > > > > The vsc73xx, felix and the drivers in dsa/microchip does not share any
> > > > > functionallity. Not in SW and not in HW.
> > > > >
> > > > > Maybe felix should just go directly into drivers/net/dsa/, and then if we add
> > > > > support for VSC7511 then they can both live in drivers/net/dsa/ocelot/
> > >
> > >
> > > A bit of background such that people outside NXP/MCHP has a better change to
> > > follow and add to the discussion.
> > >
> > > Ocelot is a family name covering 4 VSC parts (VSC7511-14), and a IP used by NXP
> > > (VSC9959).
> > >
> > > VSC7511-14 are all register compatible, it uses the same serdes etc.
> > >
> > > VSC7511/12 are "unmanaged" meaning that they do not have an embedded CPU.
> > >
> > > VSC7513/14 has an embedded MIPS CPU.
> > >
> > > VSC9959 not the same core as VSC7511-14, it is a newer generation with more
> > > features, it is not register compatible, but all the basic functionallity is
> > > very similar VSC7511-14 which is why it can call into the
> > > drivers/net/ethernet/mscc/ocelot.c file.
> > >
> > > It is likely that NXP want to add more features in felix/VSC9959 which does not
> > > exists in VSC7511-14.
> > >
> > > > When the felix driver is going to support the vsc7511 ocelot switch
> > > > through the ocelot core, it will be naming chaos.
> > > I do not think a VSC7511 will be based on Felix, but it will relay on the
> > > refacturing/restructuring you have done in Ocelot.
> > >
> > > VSC7511 will use the same PCS and serdes settings as Ocelot (VSC7513/VSC7514)
> > >
> > > > Maybe we need to clarify what "felix" means (at the moment it means VSC9959).
> > > Yes.
> > >
> > > > What if we just make it mean "DSA driver for Ocelot", and it supports both the
> > > > VSC751x (Ocelot) and the VSC9959 (Felix) families?
> > > I'm not too keen on using the felix name for that.
> > >
> > > Here is my suggestion:
> > >
> > > Drop the felix name and put it in drivers/net/dsa/ocelot_vsc9959* (this would be
> > > my preference)
> > >
> >
> > This has one big issue: the name is very long! I can't see myself
> > prefixing all function and structure names with ocelot_vsc9959_*.
> > Felix is just 5 letters. And I can't use "ocelot" either, since that
> > is taken :)
> > So the DSA driver needs its own (short) name.
> I certainly agree that ocelot_vsc9959_* is too long a prefix.
>
> If you put it in drivers/net/dsa/ocelot_felix* or drivers/net/dsa/ocelot/felix*
> then you can prefix with 'felix_'.
>
> If you put it in drivers/net/dsa/ocelot_vsc9959* or drivers/net/dsa/ocelot/vsc9959*
> then you can prefix with 'vsc9959_'.
>
> The one thing all of this parts has in common is that they are all based on the
> Ocelot family, which is why I suggest to include this into the path. It will
> provide more information than putting it in the vitesse/microchip folders.
>
> > > Or if you want the felix name put it in drivers/net/dsa/ocelot_felix*
> > >
> > > Or if we want folders put it in drivers/net/dsa/ocelot/vsc9959*
> > >
> >
> > The way I see an Ocelot DSA driver, it would be done a la mv88e6xxx,
> > aka a single struct dsa_switch_ops registered for the entire family,
> > and function pointers where the implementation differs. You're not
> > proposing that here, but rather that each switch driver works in
> > parallel with each other, and they all call into the Ocelot core. That
> > would produce a lot more boilerplate, I think.
> > And if the DSA driver for Ocelot ends up supporting more than 1
> > device, its name should better not contain "vsc9959" since that's
> > rather specific.
> A vsc7511/12 will not share code with felix/vsc9959. I do not expect any other
> IP/chip will be register compatible with vsc9959.
>

I don't exactly understand this comment. Register-incompatible in a
logical sense, or in a layout sense? Judging from the attachment in
chapter 6 of the VSC7511 datasheet [1], at least the basic
functionality appears to be almost the same. And for the rest, there's
regmap magic.

> A vsc7511/12 will use the ocelot DSA tagger, but other from that it will call into the
> ocelot driver (I think).
>
> But to be honest, I do not think we should spend too much energy on vsc7511/12
> now. When/if it comes, we will see how it fit best.
>
> /Allan

Ok. So the driver will still be called "felix", it will instantiate a
struct felix_info_vsc9959 instead of the current felix_info_ls1028a,
but will live in the root drivers/net/dsa folder. Then, when/if you
add support for vsc7511, you'll move both into an "ocelot" folder and
figure out how much of the driver minus the tagger is worth reusing
(aka instantiate a struct felix_info_vsc7511). Agree?

[1]: http://ww1.microchip.com/downloads/en/DeviceDoc/VMDS-10488.pdf

-Vladimir
