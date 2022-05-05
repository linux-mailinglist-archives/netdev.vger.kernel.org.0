Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC8D51C03F
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378891AbiEENJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378766AbiEENIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:08:47 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F4B56425;
        Thu,  5 May 2022 06:05:06 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A04AD60017;
        Thu,  5 May 2022 13:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1651755905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AiujlfoIRvGrufRRXdpTmkdQRZg0L/jgVK7rFYQ9oos=;
        b=DAt0uupYGjyZUZhWiAog41K1Gc6Xaxnjq37AGUk8DEH+7VmPs/EVTyG7naFqP68zK/1US2
        NxzQiyMH6UwL/feEvi7dVh+OBzRdzfryPRTzOtQYqzsqbxjD90SzEzxvyASu4k3HAD6IQs
        j7mRgrjTYBMfxJ4mZKonuXBMBJ0eNfJXyP/Skb3ZHcGlfgmzxLFnTY07ZiQ9W/ulXb/iGI
        ZsCC3JZohz2O0be3Tuyc/taH/DY2hafiQXM20mNnVro1gISZrfEdn9arJs0VUuBsUa0Kq9
        26ne/H8pbhWwNcM/n5khjbhFkleuATMme1J8Sw8/Xi9xRgCtiNAdkdO+/8Z1PQ==
Date:   Thu, 5 May 2022 15:03:43 +0200
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
Message-ID: <20220505150343.7bcd198a@fixe.home>
In-Reply-To: <CAMuHMdU1DZeigT1ES4FMrtLpnRA0fMp6k4ZhDs7U0=CvAuOxgA@mail.gmail.com>
References: <20220504093000.132579-1-clement.leger@bootlin.com>
        <20220504093000.132579-5-clement.leger@bootlin.com>
        <CAMuHMdU1dF25eKeihBO3xRarW-acG0vUSggWfKOwG3v=7eN+bg@mail.gmail.com>
        <20220505143236.31fc6b58@fixe.home>
        <CAMuHMdU1DZeigT1ES4FMrtLpnRA0fMp6k4ZhDs7U0=CvAuOxgA@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Thu, 5 May 2022 15:00:28 +0200,
Geert Uytterhoeven <geert@linux-m68k.org> a =C3=A9crit :

> Hi Cl=C3=A9ment,
>=20
> On Thu, May 5, 2022 at 2:33 PM Cl=C3=A9ment L=C3=A9ger <clement.leger@boo=
tlin.com> wrote:
> > Le Thu, 5 May 2022 09:16:38 +0200,
> > Geert Uytterhoeven <geert@linux-m68k.org> a =C3=A9crit : =20
> > > On Wed, May 4, 2022 at 11:31 AM Cl=C3=A9ment L=C3=A9ger <clement.lege=
r@bootlin.com> wrote: =20
> > > > Add a PCS driver for the MII converter that is present on the Renes=
as
> > > > RZ/N1 SoC. This MII converter is reponsible for converting MII to
> > > > RMII/RGMII or act as a MII pass-trough. Exposing it as a PCS allows=
 to
> > > > reuse it in both the switch driver and the stmmac driver. Currently,
> > > > this driver only allows the PCS to be used by the dual Cortex-A7
> > > > subsystem since the register locking system is not used.
> > > >
> > > > Signed-off-by: Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com> =
=20
> > >
> > > Thanks for your patch!
> > > =20
> > > > --- /dev/null
> > > > +++ b/drivers/net/pcs/pcs-rzn1-miic.c =20
> > > =20
> > > > +static int miic_probe(struct platform_device *pdev)
> > > > +{
> > > > +       struct device *dev =3D &pdev->dev;
> > > > +       struct miic *miic;
> > > > +       u32 mode_cfg;
> > > > +       int ret;
> > > > +
> > > > +       ret =3D miic_parse_dt(dev, &mode_cfg);
> > > > +       if (ret < 0)
> > > > +               return -EINVAL;
> > > > +
> > > > +       miic =3D devm_kzalloc(dev, sizeof(*miic), GFP_KERNEL);
> > > > +       if (!miic)
> > > > +               return -ENOMEM;
> > > > +
> > > > +       spin_lock_init(&miic->lock);
> > > > +       miic->dev =3D dev;
> > > > +       miic->base =3D devm_platform_ioremap_resource(pdev, 0);
> > > > +       if (!miic->base)
> > > > +               return -EINVAL;
> > > > +
> > > > +       pm_runtime_enable(dev);
> > > > +       ret =3D pm_runtime_resume_and_get(dev);
> > > > +       if (ret < 0) =20
> > >
> > > Missing pm_runtime_disable(dev). =20
> >
> > Maybe using devm_pm_runtime_enable() would be sufficient and avoid such
> > calls. =20
>=20
> That's an option.
> Note that that still won't allow you to get rid of the .remove() callback,
> as you still have to call pm_runtime_put() manually.

Yes, of course :) I'll do the modifications.

Thanks,

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
