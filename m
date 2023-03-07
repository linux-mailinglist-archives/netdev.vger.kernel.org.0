Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6E1B6AD73F
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 07:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbjCGGWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 01:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjCGGWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 01:22:19 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B314ECC7
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 22:22:18 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id n18so10397615ybm.10
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 22:22:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1678170138;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EaSnFGmlXYYH+Q53OUMN+nooRRxRgXo+Rj1EGLh7BXE=;
        b=e39kQHzPq61xZXrHCCRx5wzPsl+DNDOj14y/gbA5uu3QsgKfs1JhCd4WTBAm0qXRsg
         IxYWKg4KdgKWLzzzmGuyPMEoTVeZyz569FSpsW27dZIZTxGW6v9/P1aUdMDhbvpzISiU
         T/+jpvmug2LFYDCST4bVlilFqPe20gxepbmPc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678170138;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EaSnFGmlXYYH+Q53OUMN+nooRRxRgXo+Rj1EGLh7BXE=;
        b=Dr3rdbpFWBvIOH9B3QkzBtIlxm5rme6IJL6jKnyDOpLjGo7rboXCNabKCDTbhMCmsi
         vrq3T3vEVYZ+Mjf2TvOtU0r+RBO4VWpVugN8JwFgnKFQaUY9I51zCnXnLz6VuFpvQLDN
         Q/Txk/BV7E+0svCzoCFLQ2wF5bEroU3/8hatnHYahruc0ADcOT6ES/bZP32fOkiblHXq
         NO3ZV02gBwYiKUOlwpYd92oG91h9YqPXGXmSF+ES6yTTCj4CJdpxLsi/d9r6PI5P0SJP
         coL03Wr6gNsHXA0xjuEl9Qi0RapRQXCjEQwv5J082LVqFknRo2UqOj4bWfvsrVpKzUk2
         nIFw==
X-Gm-Message-State: AO0yUKUsS42aYbgOuURQWUedzAQTQEmPhPbIRVmaF/lN0sNDYPYkyB7A
        d9zdgBZSAMDKykAuBlZBWXk20mk46fIrbR2C696C2A==
X-Google-Smtp-Source: AK7set+F+Pcc0eSbCKkbTUKR5YIJRMFhmeW7jrOJf9aYnrzl/OVvhdtnBPaP7JgxREgftPYco/D/q2cpUSMwkQ0KmsQ=
X-Received: by 2002:a5b:1cb:0:b0:aa2:475c:2982 with SMTP id
 f11-20020a5b01cb000000b00aa2475c2982mr6325272ybp.1.1678170137720; Mon, 06 Mar
 2023 22:22:17 -0800 (PST)
MIME-Version: 1.0
References: <20230307005028.2065800-1-grundler@chromium.org> <84094771-7f98-0d8d-fe79-7c22e15a602d@gmail.com>
In-Reply-To: <84094771-7f98-0d8d-fe79-7c22e15a602d@gmail.com>
From:   Grant Grundler <grundler@chromium.org>
Date:   Mon, 6 Mar 2023 22:22:06 -0800
Message-ID: <CANEJEGsYkxsbCj5O-O=QN8O0MEB-WY6FRJO6GFR0qt2sp4J8SA@mail.gmail.com>
Subject: Re: [PATCH] net: asix: fix modprobe "sysfs: cannot create duplicate filename"
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Grant Grundler <grundler@chromium.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Eizan Miyamoto <eizan@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
        USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[dropping Aton Lundin <glance@...> since it's bouncing ... and
replying in "text only"]

On Mon, Mar 6, 2023 at 7:46=E2=80=AFPM Florian Fainelli <f.fainelli@gmail.c=
om> wrote:
>
>
>
> On 3/6/2023 4:50 PM, Grant Grundler wrote:
> > "modprobe asix ; rmmod asix ; modprobe asix" fails with:
> >     sysfs: cannot create duplicate filename \
> >       '/devices/virtual/mdio_bus/usb-003:004'
> >
> > Issue was originally reported by Anton Lundin on 2022-06-22 14:16 UTC:
> >     https://lore.kernel.org/netdev/20220623063649.GD23685@pengutronix.d=
e/T/
> >
> > Chrome OS team hit the same issue in Feb, 2023 when trying to find
> > work arounds for other issues with AX88172 devices.
> >
> > The use of devm_mdiobus_register() with usbnet devices results in the
> > MDIO data being associated with the USB device. When the asix driver
> > is unloaded, the USB device continues to exist and the corresponding
> > "mdiobus_unregister()" is NOT called until the USB device is unplugged
> > or unauthorized. So the next "modprobe asix" will fail because the MDIO
> > phy sysfs attributes still exist.
> >
> > The 'easy' (from a design PoV) fix is to use the non-devm variants of
> > mdiobus_* functions and explicitly manage this use in the asix_bind
> > and asix_unbind function calls. I've not explored trying to fix usbnet
> > initialization so devm_* stuff will work.
> >
> > Reported-by: Anton Lundin <glance@acc.umu.se>
> > Tested-by: Eizan Miyamoto <eizan@chromium.org>
> > Signed-off-by: Grant Grundler <grundler@chromium.org>
>
> Should we have a Fixes: tag here? One more question below

I have no idea which change/patch caused this problem. I'm happy to
add whatever Fixes: tag folks suggest.

Looking at git blame, looks like the devm_mdiobus_* usage was
introduced with e532a096be0e5:

commit e532a096be0e5e570b383e71d4560e7f04384e0f
Author: Oleksij Rempel <linux@rempel-privat.de>
Date:   Mon Jun 7 10:27:23 2021 +0200

    net: usb: asix: ax88772: add phylib support

>
> > ---
> >   drivers/net/usb/asix_devices.c | 32 ++++++++++++++++++++++++--------
> >   1 file changed, 24 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devi=
ces.c
> > index 30e87389aefa1..f0a87b933062a 100644
> > --- a/drivers/net/usb/asix_devices.c
> > +++ b/drivers/net/usb/asix_devices.c
> > @@ -640,8 +640,9 @@ static int asix_resume(struct usb_interface *intf)
> >   static int ax88772_init_mdio(struct usbnet *dev)
> >   {
> >       struct asix_common_private *priv =3D dev->driver_priv;
> > +     int ret;
> >
> > -     priv->mdio =3D devm_mdiobus_alloc(&dev->udev->dev);
> > +     priv->mdio =3D mdiobus_alloc();
> >       if (!priv->mdio)
> >               return -ENOMEM;
> >
> > @@ -653,7 +654,27 @@ static int ax88772_init_mdio(struct usbnet *dev)
> >       snprintf(priv->mdio->id, MII_BUS_ID_SIZE, "usb-%03d:%03d",
> >                dev->udev->bus->busnum, dev->udev->devnum);
> >
> > -     return devm_mdiobus_register(&dev->udev->dev, priv->mdio);
> > +     ret =3D mdiobus_register(priv->mdio);
> > +     if (ret) {
> > +             netdev_err(dev->net, "Could not register MDIO bus (err %d=
)\n", ret);
> > +             goto mdio_regerr;
> > +     }
> > +
> > +     priv->phydev =3D mdiobus_get_phy(priv->mdio, priv->phy_addr);
> > +     if (priv->phydev)
> > +             return 0;
>
> This was in ax88772_init_phy() before, why is this being moved here now?

1) To be consistent with other drivers (e.g. tg3 and r8169) which call
 mdiobus from one function.
2) So the functions called from ax88172_bind and ax88172_unbind are
"symmetric".  I am now thinking the two functions should be renamed to
ax88172_mdio_register and ..._unregister.

Thanks for looking Florian!

cheers,
grant

>
> > +
> > +     netdev_err(dev->net, "Could not find PHY\n");
> > +     mdiobus_unregister(priv->mdio);
> > +mdio_regerr:
> > +     mdiobus_free(priv->mdio);
> > +     return ret;
> > +}
> > +
> > +static void ax88772_release_mdio(struct asix_common_private *priv)
> > +{
> > +     mdiobus_unregister(priv->mdio);
> > +     mdiobus_free(priv->mdio);
> >   }
> >
> >   static int ax88772_init_phy(struct usbnet *dev)
> > @@ -661,12 +682,6 @@ static int ax88772_init_phy(struct usbnet *dev)
> >       struct asix_common_private *priv =3D dev->driver_priv;
> >       int ret;
> >
> > -     priv->phydev =3D mdiobus_get_phy(priv->mdio, priv->phy_addr);
> > -     if (!priv->phydev) {
> > -             netdev_err(dev->net, "Could not find PHY\n");
> > -             return -ENODEV;
> > -     }
> > -
> >       ret =3D phy_connect_direct(dev->net, priv->phydev, &asix_adjust_l=
ink,
> >                                PHY_INTERFACE_MODE_INTERNAL);
> >       if (ret) {
> > @@ -805,6 +820,7 @@ static void ax88772_unbind(struct usbnet *dev, stru=
ct usb_interface *intf)
> >       struct asix_common_private *priv =3D dev->driver_priv;
> >
> >       phy_disconnect(priv->phydev);
> > +     ax88772_release_mdio(priv);
> >       asix_rx_fixup_common_free(dev->driver_priv);
> >   }
> >
>
> --
> Florian
