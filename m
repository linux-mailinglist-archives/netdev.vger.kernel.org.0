Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40C8A51BF75
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 14:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbiEEMho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 08:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377144AbiEEMhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 08:37:41 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1655534C;
        Thu,  5 May 2022 05:33:58 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A51051BF20F;
        Thu,  5 May 2022 12:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1651754037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZFe2ZY9FQx5Ezydgd9Q7wDAdfI7tiNM83wC4+zn6rkM=;
        b=VHxRxArVfXp+1gB9L33hpO6ioHHOGaKYLY2LvrQwXfuRDadq25vF4Aa8EmZYCfpg+7gOiA
        lX6lenHGx/G//hUZb2ogqe5fzGIG/n1s9B/rdy7vyWr2A3f1n+6XI0LoVw4dLRkRWdJClp
        HL/ck3D1Q3M4vvY5U/OSSgl93FVoyv+VK1xCDBJHe/XAqwky23WCX9DMwcbAFM2y5p+Kdl
        VAAvvoFasV7Ba5vbOZwSElFpEJ+ZnnQB3Zpy3pN5ASMAtkbrxb0Z/Y0zFLO6kP1lFRw5so
        RmevqV6iqYgh5tIjNYfaBwldSLjDa1NO848GIBBBfnlgRgFfzdlF6mZdhRWO7g==
Date:   Thu, 5 May 2022 14:32:36 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v3 04/12] net: pcs: add Renesas MII converter
 driver
Message-ID: <20220505143236.31fc6b58@fixe.home>
In-Reply-To: <CAMuHMdU1dF25eKeihBO3xRarW-acG0vUSggWfKOwG3v=7eN+bg@mail.gmail.com>
References: <20220504093000.132579-1-clement.leger@bootlin.com>
        <20220504093000.132579-5-clement.leger@bootlin.com>
        <CAMuHMdU1dF25eKeihBO3xRarW-acG0vUSggWfKOwG3v=7eN+bg@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Thu, 5 May 2022 09:16:38 +0200,
Geert Uytterhoeven <geert@linux-m68k.org> a =C3=A9crit :

> Hi Cl=C3=A9ment,
>=20
> On Wed, May 4, 2022 at 11:31 AM Cl=C3=A9ment L=C3=A9ger <clement.leger@bo=
otlin.com> wrote:
> > Add a PCS driver for the MII converter that is present on the Renesas
> > RZ/N1 SoC. This MII converter is reponsible for converting MII to
> > RMII/RGMII or act as a MII pass-trough. Exposing it as a PCS allows to
> > reuse it in both the switch driver and the stmmac driver. Currently,
> > this driver only allows the PCS to be used by the dual Cortex-A7
> > subsystem since the register locking system is not used.
> >
> > Signed-off-by: Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com> =20
>=20
> Thanks for your patch!
>=20
> > --- /dev/null
> > +++ b/drivers/net/pcs/pcs-rzn1-miic.c =20
>=20
> > +static int miic_probe(struct platform_device *pdev)
> > +{
> > +       struct device *dev =3D &pdev->dev;
> > +       struct miic *miic;
> > +       u32 mode_cfg;
> > +       int ret;
> > +
> > +       ret =3D miic_parse_dt(dev, &mode_cfg);
> > +       if (ret < 0)
> > +               return -EINVAL;
> > +
> > +       miic =3D devm_kzalloc(dev, sizeof(*miic), GFP_KERNEL);
> > +       if (!miic)
> > +               return -ENOMEM;
> > +
> > +       spin_lock_init(&miic->lock);
> > +       miic->dev =3D dev;
> > +       miic->base =3D devm_platform_ioremap_resource(pdev, 0);
> > +       if (!miic->base)
> > +               return -EINVAL;
> > +
> > +       pm_runtime_enable(dev);
> > +       ret =3D pm_runtime_resume_and_get(dev);
> > +       if (ret < 0) =20
>=20
> Missing pm_runtime_disable(dev).

Maybe using devm_pm_runtime_enable() would be sufficient and avoid such
calls.

>=20
> > +               return ret;
> > +
> > +       ret =3D miic_init_hw(miic, mode_cfg);
> > +       if (ret)
> > +               goto disable_runtime_pm;
> > +
> > +       /* miic_create() relies on that fact that data are attached to =
the
> > +        * platform device to determine if the driver is ready so this =
needs to
> > +        * be the last thing to be done after everything is initialized
> > +        * properly.
> > +        */
> > +       platform_set_drvdata(pdev, miic);
> > +
> > +       return 0;
> > +
> > +disable_runtime_pm:
> > +       pm_runtime_put(dev); =20
>=20
> Missing pm_runtime_disable(dev).
>=20
> > +
> > +       return ret;
> > +}
> > +
> > +static int miic_remove(struct platform_device *pdev)
> > +{
> > +       pm_runtime_put(&pdev->dev); =20
>=20
> Missing pm_runtime_disable(dev).
>=20
> > +
> > +       return 0;
> > +} =20
>=20
> Gr{oetje,eeting}s,
>=20
>                         Geert
>=20
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m6=
8k.org
>=20
> In personal conversations with technical people, I call myself a hacker. =
But
> when I'm talking to journalists I just say "programmer" or something like=
 that.
>                                 -- Linus Torvalds



--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
