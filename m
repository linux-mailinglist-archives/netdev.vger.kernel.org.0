Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C7B478548
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 07:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbhLQGuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 01:50:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbhLQGux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 01:50:53 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE9AC061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 22:50:53 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id w24so1041198ply.12
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 22:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WjBrR0ZxgVEvUu6zb9yA2nQyU94PNeZBCgiNvWnId+U=;
        b=DUuiOgWKVDQ2QK934v0PnyNCfJDFq289V4n8/hxtetQMZNHbGwOWoXALKHcUhg1Co0
         c7p5v19hOwA46QTz1B2GOhbw2uRb0RRT5MEo0qzHIPd7dJ3SoYn2hO3n8XYmfNEkGIqe
         Xb2wkAykrVyzK3q95xfGMfJcYqGBz4vzZ1Oqi47NQgzRErL9WmvB10Ffc+69KUPcKiRt
         AYLlh8kT2mqlhSnjNNR6VsKNmV2plDz5jlxZoevWbYHad4d+2UO3zeyUkqsyOI2QV0QX
         lv5llGe8uuZO2sqPrr7iEplITnqlbcbSFC/KXADerr0gIh/2oeBtTvDAZzQwr8lhwipn
         JUKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WjBrR0ZxgVEvUu6zb9yA2nQyU94PNeZBCgiNvWnId+U=;
        b=wfnyWf0RF6ST0DR5HnIcSTM0/LCsNLt6FRkQwTJ07E4ASL0Ks2PVUky66iGvPsv6Cp
         QpDRfhsUi8Ru+964uuQgzSl5IjCXgJwaR7F2tZLMDbOketUb1ydA0nv/yHuKHRXdIW/v
         PeeDMV5f0+eOgdYg36+jTIyTI/4PVu+R0AdfsmsudU4p26k+Nc+FDNO39aJtFmkZgqf5
         KRilQKBN6h2VVtumLfQQOpV+EJHzsgCbR73xjxx8TNj3kRqdPtkf5ZKH57gHaVZTK0zn
         iyxropU+vciqXBLwcQFlFTVSIT+sbfwt2i/RsWmnOnhZMf3ctVrRPJl2qDEnhA+YNiji
         bNhg==
X-Gm-Message-State: AOAM532ku4hi+ogP3WLsnqbGjIhzztikC7rWRp7WQ3N/LhtdD5dIi9Dp
        fWGffjYDp16BNYe9N2PEa6wzii7WqibWKu79Exg=
X-Google-Smtp-Source: ABdhPJxvfdkQQLHDApM8uNHcg4lAYLgPrzJ2cOEluHYtSiAGU52vZOl5D3ulJnnoAn4zrs71qVVXwd4Zb8BE5A21swg=
X-Received: by 2002:a17:902:a60e:b0:148:ad72:f8e8 with SMTP id
 u14-20020a170902a60e00b00148ad72f8e8mr1948619plq.143.1639723852919; Thu, 16
 Dec 2021 22:50:52 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211216201342.25587-5-luizluca@gmail.com>
 <04fab19f-36c6-4db0-e0f2-6f69f3a190ec@bang-olufsen.dk>
In-Reply-To: <04fab19f-36c6-4db0-e0f2-6f69f3a190ec@bang-olufsen.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Fri, 17 Dec 2021 03:50:41 -0300
Message-ID: <CAJq09z7mBRwCuXEjV1SBuDAPy70R5c07_8=LBVJPQZQczK=RoA@mail.gmail.com>
Subject: Re: [PATCH net-next 04/13] net: dsa: realtek: convert subdrivers into modules
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em qui., 16 de dez. de 2021 =C3=A0s 20:29, Alvin =C5=A0ipraga
<ALSI@bang-olufsen.dk> escreveu:
>
> On 12/16/21 21:13, luizluca@gmail.com wrote:
> > From: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> >
> > Preparing for multiple interfaces support, the drivers
> > must be independent of realtek-smi.
> >
> > Tested-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> > Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> > ---
> >   drivers/net/dsa/realtek/Kconfig               | 20 +++++++++++++++++-=
-
> >   drivers/net/dsa/realtek/Makefile              |  4 +++-
> >   .../{realtek-smi-core.c =3D> realtek-smi.c}     | 15 ++++++++++----
> >   drivers/net/dsa/realtek/rtl8365mb.c           |  2 ++
> >   .../dsa/realtek/{rtl8366.c =3D> rtl8366-core.c} |  0
> >   drivers/net/dsa/realtek/rtl8366rb.c           |  2 ++
> >   6 files changed, 36 insertions(+), 7 deletions(-)
> >   rename drivers/net/dsa/realtek/{realtek-smi-core.c =3D> realtek-smi.c=
} (96%)
> >   rename drivers/net/dsa/realtek/{rtl8366.c =3D> rtl8366-core.c} (100%)
> >
> > diff --git a/drivers/net/dsa/realtek/Kconfig b/drivers/net/dsa/realtek/=
Kconfig
> > index bbc6e918baa6..c002a84a00f5 100644
> > --- a/drivers/net/dsa/realtek/Kconfig
> > +++ b/drivers/net/dsa/realtek/Kconfig
> > @@ -2,8 +2,6 @@
> >   menuconfig NET_DSA_REALTEK
> >       tristate "Realtek Ethernet switch family support"
> >       depends on NET_DSA
> > -     select NET_DSA_TAG_RTL4_A
> > -     select NET_DSA_TAG_RTL8_4
> >       select FIXED_PHY
> >       select IRQ_DOMAIN
> >       select REALTEK_PHY
> > @@ -17,3 +15,21 @@ config NET_DSA_REALTEK_SMI
> >       default y
> >       help
> >         Select to enable support for registering switches connected thr=
ough SMI.
> > +
> > +config NET_DSA_REALTEK_RTL8365MB
> > +     tristate "Realtek RTL8365MB switch subdriver"
> > +     default y
> > +     depends on NET_DSA_REALTEK
> > +     depends on NET_DSA_REALTEK_SMI
> > +     select NET_DSA_TAG_RTL8_4
> > +     help
> > +       Select to enable support for Realtek RTL8365MB
> > +
> > +config NET_DSA_REALTEK_RTL8366RB
> > +     tristate "Realtek RTL8366RB switch subdriver"
> > +     default y
> > +     depends on NET_DSA_REALTEK
> > +     depends on NET_DSA_REALTEK_SMI
> > +     select NET_DSA_TAG_RTL4_A
> > +     help
> > +       Select to enable support for Realtek RTL8366RB
> > diff --git a/drivers/net/dsa/realtek/Makefile b/drivers/net/dsa/realtek=
/Makefile
> > index 323b921bfce0..8b5a4abcedd3 100644
> > --- a/drivers/net/dsa/realtek/Makefile
> > +++ b/drivers/net/dsa/realtek/Makefile
> > @@ -1,3 +1,5 @@
> >   # SPDX-License-Identifier: GPL-2.0
> >   obj-$(CONFIG_NET_DSA_REALTEK_SMI)   +=3D realtek-smi.o
> > -realtek-smi-objs                     :=3D realtek-smi-core.o rtl8366.o=
 rtl8366rb.o rtl8365mb.o
> > +obj-$(CONFIG_NET_DSA_REALTEK_RTL8366RB) +=3D rtl8366.o
>
> Maybe this should be CONFIG_NET_DSA_REALTEK_RTL8366 (no RB)? Not that I
> put my faith in Realtek's naming scheme...
>

Let's discuss this one in the rename patch. Unfortunately, I think
that there is no perfect name.

> > +rtl8366-objs                                 :=3D rtl8366-core.o rtl83=
66rb.o
> > +obj-$(CONFIG_NET_DSA_REALTEK_RTL8365MB) +=3D rtl8365mb.o
> > diff --git a/drivers/net/dsa/realtek/realtek-smi-core.c b/drivers/net/d=
sa/realtek/realtek-smi.c
> > similarity index 96%
> > rename from drivers/net/dsa/realtek/realtek-smi-core.c
> > rename to drivers/net/dsa/realtek/realtek-smi.c
> > index 2c78eb5c0bdc..11447096c8dc 100644
> > --- a/drivers/net/dsa/realtek/realtek-smi-core.c
> > +++ b/drivers/net/dsa/realtek/realtek-smi.c
> > @@ -297,7 +297,6 @@ int realtek_smi_write_reg_noack(struct realtek_priv=
 *priv, u32 addr,
> >   {
> >       return realtek_smi_write_reg(priv, addr, data, false);
> >   }
> > -EXPORT_SYMBOL_GPL(realtek_smi_write_reg_noack);
> >
> >   /* Regmap accessors */
> >
> > @@ -342,8 +341,9 @@ static int realtek_smi_mdio_write(struct mii_bus *b=
us, int addr, int regnum,
> >       return priv->ops->phy_write(priv, addr, regnum, val);
> >   }
> >
> > -int realtek_smi_setup_mdio(struct realtek_priv *priv)
> > +int realtek_smi_setup_mdio(struct dsa_switch *ds)
> >   {
> > +     struct realtek_priv *priv =3D  (struct realtek_priv *)ds->priv;
> >       struct device_node *mdio_np;
> >       int ret;
> >
> > @@ -363,10 +363,10 @@ int realtek_smi_setup_mdio(struct realtek_priv *p=
riv)
> >       priv->slave_mii_bus->read =3D realtek_smi_mdio_read;
> >       priv->slave_mii_bus->write =3D realtek_smi_mdio_write;
> >       snprintf(priv->slave_mii_bus->id, MII_BUS_ID_SIZE, "SMI-%d",
> > -              priv->ds->index);
> > +              ds->index);
> >       priv->slave_mii_bus->dev.of_node =3D mdio_np;
> >       priv->slave_mii_bus->parent =3D priv->dev;
> > -     priv->ds->slave_mii_bus =3D priv->slave_mii_bus;
> > +     ds->slave_mii_bus =3D priv->slave_mii_bus;
> >
> >       ret =3D devm_of_mdiobus_register(priv->dev, priv->slave_mii_bus, =
mdio_np);
> >       if (ret) {
> > @@ -413,6 +413,9 @@ static int realtek_smi_probe(struct platform_device=
 *pdev)
> >       priv->cmd_write =3D var->cmd_write;
> >       priv->ops =3D var->ops;
> >
> > +     priv->setup_interface=3Drealtek_smi_setup_mdio;
> > +     priv->write_reg_noack=3Drealtek_smi_write_reg_noack;
>
> Formatting: a =3D b, not a=3Db.
>

Check patch also got it. Thanks.

> > +
> >       dev_set_drvdata(dev, priv);
> >       spin_lock_init(&priv->lock);
> >
> > @@ -492,19 +495,23 @@ static void realtek_smi_shutdown(struct platform_=
device *pdev)
> >   }
> >
> >   static const struct of_device_id realtek_smi_of_match[] =3D {
> > +#if IS_ENABLED(CONFIG_NET_DSA_REALTEK_RTL8366RB)
> >       {
> >               .compatible =3D "realtek,rtl8366rb",
> >               .data =3D &rtl8366rb_variant,
> >       },
> > +#endif
> >       {
> >               /* FIXME: add support for RTL8366S and more */
> >               .compatible =3D "realtek,rtl8366s",
> >               .data =3D NULL,
> >       },
> > +#if IS_ENABLED(CONFIG_NET_DSA_REALTEK_RTL8365MB)
> >       {
> >               .compatible =3D "realtek,rtl8365mb",
> >               .data =3D &rtl8365mb_variant,
> >       },
> > +#endif
> >       { /* sentinel */ },
> >   };
> >   MODULE_DEVICE_TABLE(of, realtek_smi_of_match);
> > diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/real=
tek/rtl8365mb.c
> > index f562a6efb574..d6054f63f204 100644
> > --- a/drivers/net/dsa/realtek/rtl8365mb.c
> > +++ b/drivers/net/dsa/realtek/rtl8365mb.c
> > @@ -1987,3 +1987,5 @@ const struct realtek_variant rtl8365mb_variant =
=3D {
> >       .chip_data_sz =3D sizeof(struct rtl8365mb),
> >   };
> >   EXPORT_SYMBOL_GPL(rtl8365mb_variant);
> > +
> > +MODULE_LICENSE("GPL");
>
> You could also add MODULE_DESCRIPTION/MODULE_AUTHORs to these subdrivers
> now that they are free from the core.

realtek-smi also didn't have them. I'll add as well from the author of
the first commit in git log.
It might not be fair with other authors. If anyone sees a problem, I
can add/remove names.
Also, I'm not sure if I should name the authors without their ok

>
> > diff --git a/drivers/net/dsa/realtek/rtl8366.c b/drivers/net/dsa/realte=
k/rtl8366-core.c
> > similarity index 100%
> > rename from drivers/net/dsa/realtek/rtl8366.c
> > rename to drivers/net/dsa/realtek/rtl8366-core.c
> > diff --git a/drivers/net/dsa/realtek/rtl8366rb.c b/drivers/net/dsa/real=
tek/rtl8366rb.c
> > index b1635c20276b..31f1a949c8e7 100644
> > --- a/drivers/net/dsa/realtek/rtl8366rb.c
> > +++ b/drivers/net/dsa/realtek/rtl8366rb.c
> > @@ -1812,3 +1812,5 @@ const struct realtek_variant rtl8366rb_variant =
=3D {
> >       .chip_data_sz =3D sizeof(struct rtl8366rb),
> >   };
> >   EXPORT_SYMBOL_GPL(rtl8366rb_variant);
> > +
> > +MODULE_LICENSE("GPL");
>
