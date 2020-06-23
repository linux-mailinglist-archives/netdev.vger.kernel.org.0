Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19F9204E58
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 11:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732226AbgFWJq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 05:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731947AbgFWJq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 05:46:27 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B00BC061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 02:46:27 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id b4so18155012qkn.11
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 02:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iKggRcdI7sNyyhDISy98npbymMoyRZSfT0QAAU3f0vQ=;
        b=U17lT7CYSTuj99Giu1FBaV/h/RoCGn6W4PdXk6wPMyfnVLBaDjbbmbHfzEZiY7S4Vi
         tnDzK+DKhIloPX6fpBJtIgaKmAcLfydO+MMim0fJuCA4BncKQxsg9Y+V14P1st5bRZXP
         SHgrm+X4d72dYIhkZI1ZX5NSsaD7WNqCgKp5bQ34+ZjA8jHjmdT5pA4i9DRLtRL89VcE
         dKrF4MGW180DAVJv3UTu9ezZ2Nrsa3PnypMstE9T7+fHxA7hW8VmhIDjBFdGXfoadKj6
         /ITX/9TP3LTwlhbdBFb4EFZm5WM88wT7UDfA8AaqyGNCTR2dKJwF8lmUZs5xYIDLU35P
         si0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iKggRcdI7sNyyhDISy98npbymMoyRZSfT0QAAU3f0vQ=;
        b=ePrDVK4bcdZrrb8/L4Bl7/fL9aIJ5rHb0F5XibrxjRDuQ/3TjuRMjHPXXQzbqtu1cN
         uBL7IFUbmUiXFhf1c1jFCgdTBUBus+RT8XUoOcorRxmgVW/j1SqPxwA/eJUZhAn6j03Z
         y+WyYfTAu8H3LR19Qu/FZv7pA41irzOOZX5J7wpw1ii20nqemEL6gwPbkkVi+mKQXiFe
         xZLsx5ils6prXVfxmH65nzM60EBmcErBWg/RmWh3hEjUZLUEIo9//czGtbsp9enTnwks
         TaEvjAbIbxy4+e/494iGNcgwvO0PNvkeUTPiL3EXkiVxOmnOf0qG9ZDNKqtSs5JvxfLi
         4P0w==
X-Gm-Message-State: AOAM531iIKxZ8Zrly8VyD9xo0AmcjzGZahMLLR1qK/FQV4I2Trb22d1g
        en3J4tnkanvyZidmJ+vZjrpOiBwZWkh4NiPiEfQJSapr
X-Google-Smtp-Source: ABdhPJwyWdHZ4XdUvdS8ekiHqvBAN7BrvA8GjUgSArJnwIzAA7OWpuKEoaMTjixO0yB7ajA2SNSzKSwztsSa0ZQ4yK8=
X-Received: by 2002:a37:aac4:: with SMTP id t187mr17690729qke.263.1592905586254;
 Tue, 23 Jun 2020 02:46:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200622093744.13685-1-brgl@bgdev.pl> <20200622093744.13685-15-brgl@bgdev.pl>
 <20200622132921.GI1551@shell.armlinux.org.uk> <CAMRc=Me1r3Mzfg3-gTsGk4rEtvB=P9ESkn9q=c7z0Q=YQDsw2A@mail.gmail.com>
 <20200623094252.GS1551@shell.armlinux.org.uk>
In-Reply-To: <20200623094252.GS1551@shell.armlinux.org.uk>
From:   Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Tue, 23 Jun 2020 11:46:15 +0200
Message-ID: <CAMpxmJVP9db-4-AA4e1JkEfrajvJ4s0T6zo5+oFzpJHRBcuSsg@mail.gmail.com>
Subject: Re: [PATCH 14/15] net: phy: add PHY regulator support
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>, Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        devicetree <devicetree@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fabien Parent <fparent@baylibre.com>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wt., 23 cze 2020 o 11:43 Russell King - ARM Linux admin
<linux@armlinux.org.uk> napisa=C5=82(a):
>
> On Tue, Jun 23, 2020 at 11:41:11AM +0200, Bartosz Golaszewski wrote:
> > pon., 22 cze 2020 o 15:29 Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> napisa=C5=82(a):
> > >
> >
> > [snip!]
> >
> > >
> > > This is likely to cause issues for some PHY drivers.  Note that we ha=
ve
> > > some PHY drivers which register a temperature sensor in the probe
> > > function, which means they can be accessed independently of the lifet=
ime
> > > of the PHY bound to the network driver (which may only be while the
> > > network device is "up".)  We certainly do not want hwmon failing just
> > > because the network device is down.
> > >
> > > That's kind of worked around for the reset stuff, because there are t=
wo
> > > layers to that: the mdio device layer reset support which knows nothi=
ng
> > > of the PHY binding state to the network driver, and the phylib reset
> > > support, but it is not nice.
> > >
> >
> > Regulators are reference counted so if the hwmon driver enables it
> > using mdio_device_power_on() it will stay on even after the PHY driver
> > calls phy_device_power_off(), right? Am I missing something?
>
> If that is true, you will need to audit the PHY drivers to add that.
>

This change doesn't have any effect on devices which don't have a
regulator assigned in DT though. The one I'm adding in the last patch
is the first to use this.

Bart
