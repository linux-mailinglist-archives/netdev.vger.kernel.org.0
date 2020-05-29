Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1961E785E
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 10:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbgE2Ia4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 04:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgE2Iaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 04:30:55 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8C6C03E969
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 01:30:55 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id l27so1273604ejc.1
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 01:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4drjY3GtswmXUpynwtnC1DxxRb68vUXPtN4B0R+zr5E=;
        b=JD5xqc3aYEFA8GAHldSxgy4X/eynKmFSbnJKv1m+gUnYBBGliwA/dMsdmslNhj/Hdw
         EGVrMjXtYaEILrE8+heyWQjHGA6jybDKGu9KPl2MfnDb+53hVsdv4/2egiUxavDT3tHc
         5/Zzg3GoToT0fkkCBFVF7kym5XmCPqfbbhhfO3GQh6adO9z1fSqwWszetAiJwAzc7ymE
         lBQQ7hQvF74GTW0iU4WIl6sOOuc9Sw+23czRXMSYgLMZDyW7JuFAZsipqR6fdtNPoWE3
         RCXnjCmce9xf+PgfDQjjnh6EN49XQ6n+gOzQ0pvJHNKzckJEUQ8e3F0pGtrLNcVg78yt
         JE/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4drjY3GtswmXUpynwtnC1DxxRb68vUXPtN4B0R+zr5E=;
        b=idDVmP6ia7azr7wQYqwWeWUc7I2+VeMWcTJ7FVs8MkacRbTDOVh7KgXN+gKRv0m+mE
         Nrtpdf1rJ1TbauBot8ewnpJrEy2++h1H3lTmIqeaF5CjikGs9Ou+IDiDQ3fcH+JGNxGe
         nKuCkoTVBTsEZeqdxdxVYBxqv8n03TpVLQl907MyQOpg/bgv1qI+P162K9GyTDPeUQbD
         U70tOP60Eg0jgCaRc2TC0cqZyLcXwAfsjkYCvjIk6StEq168umHN79rX5S+pJxgpDjG0
         0Sb+bjYQL4bv07WMSjtyAu3Aeq5IMRMFA2AC8619Lfmg1nXB73b1gQvCWIf5wTVRLU8I
         dTrg==
X-Gm-Message-State: AOAM532C9EuXT0GyvEvHBF96re4CQ62I3w8/5swbKGxmC/762h13yiii
        BzCS46Phmt9jLoAMFLBl1RW9SOBau8DyaFsIwxwFwQ==
X-Google-Smtp-Source: ABdhPJyqY/GdvmTF0kQElUycwN0nbs2ywtMt9I9KQ0lNUkR6qV8TS4XuYbJXgfYM7da42dl+Qmtzj1IZhA03JseWYIg=
X-Received: by 2002:a17:906:a843:: with SMTP id dx3mr6310876ejb.396.1590741054010;
 Fri, 29 May 2020 01:30:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200527234113.2491988-1-olteanv@gmail.com> <20200527234113.2491988-12-olteanv@gmail.com>
 <20200528215618.GA853774@lunn.ch> <CA+h21hoVQPVJiYDQV7j+d7Vt8o5rK+Z8APO2Hp85Dt8cOU7e4w@mail.gmail.com>
 <20200529081441.GW3972@piout.net>
In-Reply-To: <20200529081441.GW3972@piout.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 29 May 2020 11:30:43 +0300
Message-ID: <CA+h21hpqf720YO84QJ6vBbF7chZkgnv_ow2-mRmP9OaOC_Ho1g@mail.gmail.com>
Subject: Re: [PATCH net-next 11/11] net: dsa: ocelot: introduce driver for
 Seville VSC9953 switch
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexandre,

On Fri, 29 May 2020 at 11:14, Alexandre Belloni
<alexandre.belloni@bootlin.com> wrote:
>
> On 29/05/2020 01:09:16+0300, Vladimir Oltean wrote:
> > On Fri, 29 May 2020 at 00:56, Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > > Extending the Felix driver to probe a PCI as well as a platform device
> > > > would have introduced unnecessary complexity. The 'meat' of both drivers
> > > > is in drivers/net/ethernet/mscc/ocelot*.c anyway, so let's just
> > > > duplicate the Felix driver, s/Felix/Seville/, and define the low-level
> > > > bits in seville_vsc9953.c.
> > >
> > > Hi Vladimir
> > >
> > > That has resulted in a lot of duplicated code.
> > >
> > > Is there an overall family name for these switch?
> > >
> > > Could you add foo_set_ageing_time() with both felix and saville share?
> > >
> > >       Andrew
> >
> > Yes, it looks like I can. I can move Felix PCI probing to
> > felix_vsc9959.c, Seville platform device probing to seville_vsc9953.c,
> > and remove seville.c.
> > I would not be in a position to know whether there's any larger family
> > name which should be used here. According to
> > https://media.digikey.com/pdf/Data%20Sheets/Microsemi%20PDFs/Ocelot_Family_of_Ethernet_Switches_Dec2016.pdf,
> > "Ocelot is a low port count, small form factor Ethernet switch family
> > for the Industrial IoT market". Seville would not qualify as part of
> > the Ocelot family (high port count, no 1588) but that doesn't mean it
> > can't use the Ocelot driver. As confusing as it might be for the
> > people at Microchip, I would tend to call anything that probes as pure
> > switchdev "ocelot" and anything that probes as DSA "felix", since
>
> As ocelot can be used in a DSA configuration (even if it is not
> implemented yet), I don't think this would be correct. From my point of
> view, felix and seville are part of the ocelot family.
>

In this case, there would be a third driver in
drivers/net/dsa/ocelot/ocelot_vsc7511.c which uses the intermediate
felix_switch_ops from felix.c to access the ocelot core
implementation. Unless you have better naming suggestions?

> > these were the first 2 drivers that entered mainline. Under this
> > working model, Seville would reuse the struct dsa_switch_ops
> > felix_switch_ops, while having its own low-level seville_vsc9953.c
> > that deals with platform integration specific stuff (probing, internal
> > MDIO, register map, etc), and the felix_switch_ops would call into
> > ocelot for the common functionalities.
> > What do you think?
> >
> > -Vladimir
>
> --
> Alexandre Belloni, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com

Thanks,
-Vladimir
