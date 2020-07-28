Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441312305C0
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 10:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgG1Ivi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 04:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbgG1Ivi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 04:51:38 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86ECC061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 01:51:37 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id dk23so7965400ejb.11
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 01:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yM88eX1m/o4LfV9jrdzykGuscZ4kzP2JURg8G2c7T4g=;
        b=lNAsKoBh22uhOgZw8hbhlEuOSTKJLc+NU0RXXUYQe1TodoKWyHckmko8knLfcZf8eZ
         0eEHfeAwQt55KPJg0LJnmAnuM7I4d8gd+KUAuuLq8Vql678AMrOICf6/Sx1OQAH3NRDy
         LSdhjt8JEjJwOGqG1UUg51U4/Adee4tMu8DK7ln5IBjsy314wCiNBQY9FMdtk+GaT2oq
         6ZRX0fIOyHy7EBfoSdIPCF5HvbgubDSbmctsgXoen6f/CG+bisuAA+zdPxt0rxR1xqe+
         hDft7t7SAu855pZUtLPTTHjQOHEDiKntzBk1rWqzk9qoqQc99mg7+W9vpFqhgKNoT4lV
         cQrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yM88eX1m/o4LfV9jrdzykGuscZ4kzP2JURg8G2c7T4g=;
        b=Li0xutChlvpxp4u/yd4lEwYff+x2yNYfQLHS7bLGBh9G6MpgJca6Mw0H5ugRvKvuD9
         6bAo6ZOh4iHmib25uQUFNs1LdRpx2cHDHg00l435erwU+PKJQERYkc/upbHNgDYmQ7TA
         yB5GqKlepkGaGr2Mub4u2zkHT2iVGfn1EJ/MDmDtd/9uNCvDV3lMKovXSqXtuVhjXkMX
         1cPDFL/3yrnPEmtQCLbPBtL0w8M+hxCri6twQZiIMexI/HTh9l6S+KYZKfwX4b1P0nVq
         0vNLKjbXg/i4Afvxxfggis9Mwm6B1FJ85HeO1HhgayZQfpDEVOD7I++2SvdpTvMoqf8o
         smnQ==
X-Gm-Message-State: AOAM532jhDj4yE5D0Z4Ha1e+DKROdxInqbWilwXO2PGWFAzzGmEGxzp7
        6/TFQXgpPA5cxuKPjHJJaX2D06FRqptnSPmBabbQbU2jfD+7qA==
X-Google-Smtp-Source: ABdhPJx3TwGOdVL8RCqYUj+F/TV6VXssWv7xSI327n/8/oh+eYtjZML07pKJd4ZYqh2EdK8Ca7bfpCxk4Itxfd1veUI=
X-Received: by 2002:a17:906:f8d5:: with SMTP id lh21mr16319755ejb.360.1595926296493;
 Tue, 28 Jul 2020 01:51:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAH+2xPCzrBgngz5cY9DDDjnFUBNa=NSH3VMchFcnoVbjSm3rEw@mail.gmail.com>
 <CAOMZO5DtYDomD8FDCZDwYCSr2AwNT81Ay4==aDxXyBxtyvPiJA@mail.gmail.com>
 <20200717163441.GA1339445@lunn.ch> <AM0PR04MB697747DD5CFED332E6729122DC780@AM0PR04MB6977.eurprd04.prod.outlook.com>
 <20200722132608.GX1339445@lunn.ch>
In-Reply-To: <20200722132608.GX1339445@lunn.ch>
From:   Bruno Thomsen <bruno.thomsen@gmail.com>
Date:   Tue, 28 Jul 2020 10:51:19 +0200
Message-ID: <CAH+2xPCyiE561XjgKvU6cM-AMm3ayJG7GYzvzGCOOe127wJwsg@mail.gmail.com>
Subject: Re: fec: micrel: Ethernet PHY type ID auto-detection issue
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Bruno Thomsen <bth@kamstrup.com>,
        Fabio Estevam <festevam@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lars Alex Pedersen <laa@kamstrup.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Den ons. 22. jul. 2020 kl. 15.26 skrev Andrew Lunn <andrew@lunn.ch>:
> Is it held in reset, and the reset is released, or is the reset line
> toggled active and then inactive?

When the kernel boots PHY reset is not active (gpio level low).
The device needs a reset pulse.

> > if (d)
> >       if (d > 20000)
> >               msleep(d / 1000);
> >       else
> >               usleep_range(d, d + max_t(unsigned int, d / 10, 100));
>
> Patch welcome.

I will put together a patch with fsleep as suggested by Heiner.

> > So my current conclusion is that using generic mdio phy handling does
> > not work with Micrel PHYs unless 3 issues has been resolved.
> > - Reset PHY before auto type detection.
>
> This has been raised recently. Look back in the mail archive about a
> month. For GPIOs this is easier to solve. But regulators pose a
> problem.
>
> Part of the problem is the history of this code. It originated from a
> PHY which needed to be reset after probe and configuration to make its
> clock stable, if i remember correctly. So the PHY would already probe,
> without the reset. Something similar was needed for another PHY so the
> code got pulled out of the driver and into the PHY core. But the
> assumption remained, the PHY will probe, the reset is used after the
> probe. This code now needs to be made more generic.
>
> There is one other option, depending on your board design. The PHY
> core supports two different resets. There is a per PHY reset, which is
> what you are using. And then there is a reset for all devices on the
> bus. That is used when multiple PHYs are connected to one reset GPIO.
> You might be able to use that reset instead. But you might need to fix
> up the sleep code in that case as well.

Resetting all PHYs does not work out-of-the box for my case as there
is no delay after reset release. I have a small patch that fixes my case
by reusing the mdio reset-delay-us device tree property as both the
reset assert delay and reset deassert delay. That way we don't need
to rename or add more dt properties. Just update existing help text.
Otherwise I think the current reset-delay-us should be rename and
follow phy naming with reset-{assert,deassert}-us.

/Bruno
