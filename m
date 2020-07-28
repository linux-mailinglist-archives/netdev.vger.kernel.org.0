Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B66F6230A9C
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 14:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729856AbgG1Mte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 08:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729379AbgG1Mtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 08:49:33 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4935DC061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 05:49:33 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id dk23so8635721ejb.11
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 05:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cKlMwqLGbzpVRzxgI3qrhc7+IS7XuB+qiH/lVxV2HcU=;
        b=JAOH0ETFbqUVbOjbNkB1wA0kM9BuB5jHSmF3/ehudjKMDb1qNBnFBvovHjNUta/TtN
         X11DcnDbVlTT1mQyZ8ZG4yY/r1vtms8VrfH1S5lhLhq2EIoAlKp4J/wQgSF/7pAbO79O
         TJj+DZ1HAaxX5+kXdhKlx0u6OQuonLBD2NTr7s119MSPhLNgIq/vtChspS7+0NFQSz5x
         y1KQ25jWsJyzS1A9t2OIhYtDOtAM+j781awlfUBLq3FPP/6jZ5rKMlMAgWYVSVs234Ta
         GrcCNi8xgYLJm0Rbqb0Yr+hqfqw+dANmWM2AaJgigECXv03mcoka4Z6HWOn31dMACXr3
         08Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cKlMwqLGbzpVRzxgI3qrhc7+IS7XuB+qiH/lVxV2HcU=;
        b=nBcJLOeLYdkXboG3Lm/KdP7MCekfmwB8gqHO1PtVSPpA3sSZ7/pL9Mcw1E/L/G7Jxa
         BbE6gkpnv32xZElW+rU2gFo6Z3UZ1Wy10UlMzH6AsIV3JYj2oWql0qWYg2tNA/XMMM4F
         g6QXxCaf10PDQYMIGFTKoRJBUJk9icRJESouake6YvJa5yhXkbZOARTRShIR3+lEcrRq
         xCPGNw3toV+Bkw1ZhKJKom47SZmuTqZozgOPzSS1Sc1Xr4GpZmLWkJzTq/ZxmOYfIvq6
         g4qKxK5EGtG+QGnBtWjOERU57iIQSNjrV59MwQ4WSF8oXrp0WX0xWamg5OKPjcdCoFb6
         lQew==
X-Gm-Message-State: AOAM530AEinp0yh1cb/9MySnQj/gHI0fQlKCTtMxd5dPTIqruaRVYXyH
        keznxdDVS6tA10sp3YkFkGMhfmVzkdqkjtIzsKao/jiwhx4=
X-Google-Smtp-Source: ABdhPJzLXJDzTJbfCt3pdVEY0TaCulKFv9npLEtP4K1in5Or1gVUhhwB1M96oLpB4DIYLay2G2WgmmJCniTJC73TcEU=
X-Received: by 2002:a17:907:72cc:: with SMTP id du12mr25212497ejc.357.1595940571894;
 Tue, 28 Jul 2020 05:49:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200728090203.17313-1-bruno.thomsen@gmail.com> <CAOMZO5D3Hiybr8dPv2LZFrqp23=N1UGiy9Qea74ZSThoZALMbQ@mail.gmail.com>
In-Reply-To: <CAOMZO5D3Hiybr8dPv2LZFrqp23=N1UGiy9Qea74ZSThoZALMbQ@mail.gmail.com>
From:   Bruno Thomsen <bruno.thomsen@gmail.com>
Date:   Tue, 28 Jul 2020 14:49:16 +0200
Message-ID: <CAH+2xPCrMGzvbtjY14gEDf0EXdMmYP+3R1LX7fNZMUJg8WqMiQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: mdiobus: reset deassert delay
To:     Fabio Estevam <festevam@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lars Alex Pedersen <laa@kamstrup.com>,
        Bruno Thomsen <bth@kamstrup.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Fabio

Den tir. 28. jul. 2020 kl. 14.32 skrev Fabio Estevam <festevam@gmail.com>:
> On Tue, Jul 28, 2020 at 6:02 AM Bruno Thomsen <bruno.thomsen@gmail.com> wrote:
> >
> > The current reset logic only has a delay during assert.
> > This reuses the delay value as deassert delay to ensure
> > PHYs are ready for commands. Delays are typically needed
> > when external hardware slows down reset release with a
> > RC network. This solution does not need any new device
> > tree bindings.
> > It also improves handling of long delays (>20ms) by using
> > the generic fsleep() for selecting appropriate delay
> > function.
>
> It seems that this patch should be split in two:
>
> One that changes from udelay() to sleep()
> and another one that adds the delay after the reset line is de-asserted.

Okay, I will split it in version 2.

> >  drivers/net/phy/mdio_bus.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> > index 6ceee82b2839..84d5ab07fe16 100644
> > --- a/drivers/net/phy/mdio_bus.c
> > +++ b/drivers/net/phy/mdio_bus.c
> > @@ -627,8 +627,9 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
> >                 bus->reset_gpiod = gpiod;
> >
> >                 gpiod_set_value_cansleep(gpiod, 1);
> > -               udelay(bus->reset_delay_us);
> > +               fsleep(bus->reset_delay_us);
> >                 gpiod_set_value_cansleep(gpiod, 0);
> > +               fsleep(bus->reset_delay_us);
>
> Shouldn't it use the value passed in the reset-deassert-us property instead?

This place does not use the per PHY reset properties as they are only used
after auto type ID detection. When you need a reset before auto type
ID detection,
it can only be done using the MDIO reset, and it only has
"reset-delay-us" property.
It will be a rather big change if all PHY nodes can choose if reset
should happen
before or after type ID detection.

/Bruno
