Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE0B3F0C78
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 22:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbhHRUMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 16:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233436AbhHRUMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 16:12:24 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82B9C0613CF
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 13:11:49 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id u7so3533469ilk.7
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 13:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GB2QOLPEr0oCevSArC9evLctc77Bx8ujY/f87eZIG0s=;
        b=BdtyRocus3i5AwCOybCLYXa5G8BnNrRBuYDZwjGt9MLf2+Za03hg2xF4fFnTBOJJa/
         tcsVIjHo7xzkAczanOGeM8DK+GvgOCEKY/rd1wS3Uy8aKKSfii5lHc5kF6Z67Z+aQ7oE
         42qu+XM7sg8JUGE2L2NhG8UT9A0Lk6qbgF2k7UnnsVNxskVgOblUGgKkersTr9dKe+ya
         QPetL5JSh+hCsmDsBfEzGHjcTsKvkwxTKgkgRr2SDgjgtGi+xv0u0qAvGDPrH8nvFIbZ
         CFnBjjTQfRIK/od5EGteISElrsvNfPRTEkUfvq5iCHZDFImSEQQbmt9Fg9jl96RCN6+4
         +gkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GB2QOLPEr0oCevSArC9evLctc77Bx8ujY/f87eZIG0s=;
        b=oSwS0Uzqd7a419OPkrpaW0SmcbJQkr7H+zNvxhg8kW4lj7CzRviay4DnqcxEh2l+Bd
         SzPP9UDnmw4rWVqbaIePVDOCHqg6V5az1lzwmOv8e01KmiJjghsu42JYMr52XTva7amt
         3VjVLC0JfQF5fQYyKBeF2BJi3Zqs7f01BJ86CASijbZev2gN0KmeVrek8JoxkuFGnRF4
         JdEGDAjjKUdFKgwSolkAk75lYG3L8TYIPH5CH0yjAWzTi/IDfK1RgI9rS8XmZfmBc/De
         HaB05mQZgddNyYC69UNuSeqr6832PfG42bP1G0bKgDvLCrgc1q6RASXNIo5vd8pdMQd+
         M2fw==
X-Gm-Message-State: AOAM532HpzGFpFMdTUZkXd8hKIlB9bBw8gYCUshhtPzqlx2i+U48/Fy2
        IJx7Ye1b0lmA3kpfSKvnQdHisQdcWy7xtzdn7/Kvm8024lz+mGsMtJo=
X-Google-Smtp-Source: ABdhPJzMncsxdpeKLcYuuCgoXN9fNK1LwxRitH/DXbebdujj2OrWbD6zDPilJhrydSx+j5THjREJZ1ezmTSxqnp20ZM=
X-Received: by 2002:a92:dd88:: with SMTP id g8mr7657700iln.158.1629317509060;
 Wed, 18 Aug 2021 13:11:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210818122736.4877-1-gerhard@engleder-embedded.com>
 <20210818122736.4877-2-gerhard@engleder-embedded.com> <YR0hQ6UmtmGNg2AW@lunn.ch>
In-Reply-To: <YR0hQ6UmtmGNg2AW@lunn.ch>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Wed, 18 Aug 2021 22:11:37 +0200
Message-ID: <CANr-f5xL_H0GOQ7u6xsVxS--mKpM5zve6k-jcMKnqHBf+Bm9rg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: phy: Support set_loopback override
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 5:03 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Wed, Aug 18, 2021 at 02:27:35PM +0200, Gerhard Engleder wrote:
> > phy_read_status and various other PHY functions support PHY specific
> > overriding of driver functions by using a PHY specific pointer to the
> > PHY driver. Add support of PHY specific override to phy_loopback too.
> >
> > Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> > ---
> >  drivers/net/phy/phy_device.c | 9 ++++-----
> >  1 file changed, 4 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > index 107aa6d7bc6b..ba5ad86ec826 100644
> > --- a/drivers/net/phy/phy_device.c
> > +++ b/drivers/net/phy/phy_device.c
> > @@ -1821,11 +1821,10 @@ EXPORT_SYMBOL(phy_resume);
> >
> >  int phy_loopback(struct phy_device *phydev, bool enable)
> >  {
> > -     struct phy_driver *phydrv = to_phy_driver(phydev->mdio.dev.driver);
> >       int ret = 0;
> >
> > -     if (!phydrv)
> > -             return -ENODEV;
> > +     if (!phydev->drv)
> > +             return -EIO;
>
> Humm, we need to take a closer look at what uses to_phy_driver() and
> what uses phydev->drv. Do they need to be different? Can we make it
> uniform?
>
>         Andrew

I saw only 4 references for to_phy_driver():
- phy_loopback() of course
- phy_probe() which uses it to initialize phydev->drv 3 lines later
- mdio_bus_phy_may_suspend() which checks only for valid suspend function
  pointer, but later phy_suspend() uses phydev->drv, so this is at
least inconsistent
- phy_bus_match() which casts from struct device_driver to struct phy_driver

phydev->drv is used much more often and seems to be the right way. I suggest to
also fix mdio_bus_phy_may_suspend(). phy_probe() and phy_bus_match() are
valid uses, because phydev->drv is not available for them.

Do you agree?

Gerhard
