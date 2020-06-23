Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1519520572D
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 18:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732406AbgFWQ1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 12:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732155AbgFWQ1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 12:27:19 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5786C061755
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 09:27:17 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id x9so6133095ila.3
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 09:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2HfYUl27ws6rzUdD3KtQEV+gfmF8af8Ah+cfE/GhpU0=;
        b=rNfsLC2jhNPskzrBCvMUiHmMQhtgQHZRNee+zxTRxsUSJ9sABsKMttIhODtAJEKc5Y
         ScZo4QlGKQZWPhsJ/n02X2L/URyh8JSsNhSmkT+OCYBiRLamvRZ7wCorHduH4pbUKmPC
         XgZGwZJ+VAIxJCX9rAlvnABk2Sv/XTe4g/vAiINxGvKjqaJ+msVJ4gQzyECvqGdXct7I
         GzYmJjf7Q0KbSU7qxIYlDOO+KRq/iZqe2yOmCpyN5uKCkmyTEUqY2Ler9C7PSVWe8JNP
         mEX2+5Ff4/qzcIN96B5xb5NyyEHc8oiHh8tuiDCAQQMVHvM04XX+j8WGQLMHSGs3O7HS
         2ldQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2HfYUl27ws6rzUdD3KtQEV+gfmF8af8Ah+cfE/GhpU0=;
        b=ToI7WbC1tnzDCFIiP+CHDWWG1wynnzzBm7dACWWoEopW8xRpoRpSlZfuwpVh/VtE1F
         EzBWLE6ut2VNo0Vf3SM9hW7VVT0Vr94X23khVPrZgwKyHbjFGZZJJV5s/d7giXNfKap6
         /CdxjqyZaqLcygaI5fuJJmHnYBjdI09x4UBoFSA6Oz83fU0bYJ1rmEr2lszO4xyyHU6p
         oodcJ5uQLrRmwS6kG/qfooRPQmvHAyZAMyMIz6RXL+6VQVy5X6Y5D++gozy1AvSRi9q0
         1BhuDJfkNtOT8b+Ju9wAQiKqtn1d/UNI9UmP7yh6QTZ0uHD+G+79nNZaYQUEZLvO1ivH
         33Bg==
X-Gm-Message-State: AOAM530iFDjHOywgRiJvjl84+HHEp28wHEzSMV9y/xLjsPASPqZf/55n
        Bv5i0eAGIskSF7DOcykZ3ZK+bNtxJ6/y53lHO+PUjQ==
X-Google-Smtp-Source: ABdhPJxuRp1kY0Pjp+MMdWj5T/28lVrk2yLNcq6IbmjVHcQQMX5N/hsJ+Bg1RgVxEBhjOZebPX9QJrWrcsZrxc0i0U4=
X-Received: by 2002:a92:c509:: with SMTP id r9mr22887128ilg.189.1592929637036;
 Tue, 23 Jun 2020 09:27:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200622093744.13685-1-brgl@bgdev.pl> <20200622093744.13685-15-brgl@bgdev.pl>
 <20200622132921.GI1551@shell.armlinux.org.uk> <CAMRc=Me1r3Mzfg3-gTsGk4rEtvB=P9ESkn9q=c7z0Q=YQDsw2A@mail.gmail.com>
 <20200623094252.GS1551@shell.armlinux.org.uk> <CAMpxmJVP9db-4-AA4e1JkEfrajvJ4s0T6zo5+oFzpJHRBcuSsg@mail.gmail.com>
 <20200623095646.GT1551@shell.armlinux.org.uk>
In-Reply-To: <20200623095646.GT1551@shell.armlinux.org.uk>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Tue, 23 Jun 2020 18:27:06 +0200
Message-ID: <CAMRc=MeKE12sXZycyGA7vmjNai0JfDhRX+XDTp3r3YtrmLQj3A@mail.gmail.com>
Subject: Re: [PATCH 14/15] net: phy: add PHY regulator support
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Andrew Lunn <andrew@lunn.ch>,
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

wt., 23 cze 2020 o 11:56 Russell King - ARM Linux admin
<linux@armlinux.org.uk> napisa=C5=82(a):
>
> On Tue, Jun 23, 2020 at 11:46:15AM +0200, Bartosz Golaszewski wrote:
> > wt., 23 cze 2020 o 11:43 Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> napisa=C5=82(a):
> > >
> > > On Tue, Jun 23, 2020 at 11:41:11AM +0200, Bartosz Golaszewski wrote:
> > > > pon., 22 cze 2020 o 15:29 Russell King - ARM Linux admin
> > > > <linux@armlinux.org.uk> napisa=C5=82(a):
> > > > >
> > > >
> > > > [snip!]
> > > >
> > > > >
> > > > > This is likely to cause issues for some PHY drivers.  Note that w=
e have
> > > > > some PHY drivers which register a temperature sensor in the probe
> > > > > function, which means they can be accessed independently of the l=
ifetime
> > > > > of the PHY bound to the network driver (which may only be while t=
he
> > > > > network device is "up".)  We certainly do not want hwmon failing =
just
> > > > > because the network device is down.
> > > > >
> > > > > That's kind of worked around for the reset stuff, because there a=
re two
> > > > > layers to that: the mdio device layer reset support which knows n=
othing
> > > > > of the PHY binding state to the network driver, and the phylib re=
set
> > > > > support, but it is not nice.
> > > > >
> > > >
> > > > Regulators are reference counted so if the hwmon driver enables it
> > > > using mdio_device_power_on() it will stay on even after the PHY dri=
ver
> > > > calls phy_device_power_off(), right? Am I missing something?
> > >
> > > If that is true, you will need to audit the PHY drivers to add that.
> > >
> >
> > This change doesn't have any effect on devices which don't have a
> > regulator assigned in DT though. The one I'm adding in the last patch
> > is the first to use this.
>
> It's quality of implementation.
>
> Should we wait for someone else to make use of the new regulator
> support that has been added with a PHY that uses hwmon, and they
> don't realise that it breaks hwmon on it, and several kernel versions
> go by without it being noticed.  It will only be a noticable issue
> when the associated network device is down, and that network device
> driver detaches from the PHY, so _is_ likely not to be noticed.
>
> Or should we do a small amount of work now to properly implement
> regulator support, which includes a trivial grep for "hwmon" amongst
> the PHY drivers, and add the necessary call to avoid the regulator
> being shut off.
>

I'm not sure what the correct approach is here. Provide some helper
that, when called, would increase the regulator's reference count even
more to keep it enabled from the moment hwmon is registered to when
the driver is detached?

Bart
