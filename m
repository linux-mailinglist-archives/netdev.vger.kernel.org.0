Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45DE848077F
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 09:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232741AbhL1Isp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 03:48:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbhL1Iso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 03:48:44 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85FCC061574
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 00:48:43 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id s1so13953620pga.5
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 00:48:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KsNNp/9c0opBwcU3tUA4IJzt/6Pp8rViM4HfxwArXBg=;
        b=lHOPwyQnT7CIs4wVeIhggXaLhnLGYorCxWZadI1bPevuKKgxVUMmEvb8eJ7MSrwmpx
         uz6w8eLdIg+5TuY3/qRHQ7RJB1hqnsWXyWdzEo7HahhzxynyvYRBBnd+Ri6kVT3eqtfm
         Z/ooS3cNIDOuNI96OK4Feuai8hXciUIXaeoW/FJbbvaf/WvlojH0D/ESjqC66ecM1sU/
         Kv0kYlUVji6cEvOIZRS+/OpQWjEzgMPJvOclZtbqgOHXsIL3OgJtHf7JRHctVS+dHjlk
         9RGZWQ5uUvT/+DiCS/rnAYKuBXDuotE0ETy0ddjStZlZxIddK8OKl8Qo8UT769WU8pHh
         HH1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KsNNp/9c0opBwcU3tUA4IJzt/6Pp8rViM4HfxwArXBg=;
        b=QfhZz+EB0XVUmFsWlbcrCYQlymijkrZZi9sZeY+RoAJEXm5GTtBeqqkh0Bl5YsnsbJ
         oae1t+NoqnMS/LnWb5rRdJpVSiANkOJIK57U+i80ivFIg9aHr7p1ZORh1KbNZytA37FZ
         SsAluGh8Y/qDEWdJlgx0iNyJKVclpnmbh7mJzxHNTjLIMStVUCLFGH4oJkaELyjRvrcc
         4ABOsX0+MRevOUwnFzaYXFnFLYqDUkMikf4/imQxiLBo1p4r+v5HtfD/3kinP/hOXNkV
         P9CimpjOSa0t/yxtJhdZBB+7e1itYU6HrUCwTM9c1Nxisxq9i+fwaf8KyBFrehF0kJWy
         BGWA==
X-Gm-Message-State: AOAM533bu/DzL1+QQ/Vahx0yQC+hIybfctHoEvQlkvYO46QdxYBxcHfi
        +fumQpsYcrLtbAuvWD2F1TDwxilXP2NibEmvVpk=
X-Google-Smtp-Source: ABdhPJyGzUBEZO5YEjGPgFqwkDih5+IjDIMljcnfz8EdFrx9lUDkvY9lDHB7fvC073WxH33Mt8XQzT7yDohWGrIKyko=
X-Received: by 2002:a63:461c:: with SMTP id t28mr18531736pga.547.1640681323274;
 Tue, 28 Dec 2021 00:48:43 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211218081425.18722-1-luizluca@gmail.com>
 <20211218081425.18722-12-luizluca@gmail.com> <20211219221913.c7hxslrvkj6cyrle@skbuf>
 <464bd9da-16ab-793d-972d-dff8967bdc50@bang-olufsen.dk>
In-Reply-To: <464bd9da-16ab-793d-972d-dff8967bdc50@bang-olufsen.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Tue, 28 Dec 2021 05:48:32 -0300
Message-ID: <CAJq09z5RZ8Y8EoF5xuET_oEay36fW=akUNH1A2=xA_pw0TuhWw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 11/13] net: dsa: realtek: rtl8365mb: use DSA
 CPU port
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 12/19/21 23:19, Vladimir Oltean wrote:
> > On Sat, Dec 18, 2021 at 05:14:23AM -0300, Luiz Angelo Daros de Luca wro=
te:
> >> Instead of a fixed CPU port, assume that DSA is correct.
> >>
> >> Tested-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> >> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> >> ---
> >
> > I don't necessarily see the value added by this change. Since (I think)
> > only a single port can be a CPU port, a sanity check seems to be missin=
g
> > that the CPU port in the device tree is the expected one. This seems to
> > be missing with or without your patch. You are unnaturally splitting th=
e
> > initialization of a data structure between rtl8365mb_setup() and
> > rtl8365mb_detect(). Maybe what you should do is keep everything in
> > rtl8365mb_detect() where it is right now, and check in rtl8365mb_setup
> > that the cpu_dp->index is equal to priv->cpu_port?
>
> I'm quite sure the switch family does actually support multiple CPU
> ports. If you have a cascaded switch, CPU-tagged frames may pass between
> the external ports of the switches. Any port can be configured to parse
> CPU-tagged frames. And the CPU port configuration register allows for a
> mask of EXT ports to be configured for trapping.

Yes, you could have multiple CPU ports (it is a mask) and multiple
external ports (which might or not be a CPU port). Even a user port
can be defined as a CPU port, delegating the flow control to an
external device connected via ethernet ports. I don't want to assume
that the CPU port is always an external port, although it is almost
always the case.

Even though external ports are normally used as CPU ports, they might
also be used to connect to other switches or not connected at all. I
cannot assume that all Realtek external ports are CPU ports. Before
this patch, the CPU port was hardcoded. It will not work with any
dual-external port chip variant.

>
> However, this change requires a more thorough explanation of what it is
> trying to achieve. I already see that Vladimir is confused. The control
> flow also looks rather strange.
>
> If I am to guess what deficiency you are trying to address, it's that
> the driver assumes that the CPU port is the EXT port; since there is
> only one possible EXT port, this is hardcoded with
> RTL8365MB_CPU_PORT_NUM_8365MB_VC =3D 6. But now your new switch actually
> has _two_ EXT ports. Which of those is the CPU port is configured by
> setting the realtek,ext-int property in the device tree node of the CPU
> port. But that means that the CPU port cannot be hardcoded. So you want
> to get this information from DSA instead.

Instead of using a new custom property to define if a port should be
configured as a Realtek CPU port, I'm just assuming that the only port
that should be configured as a (Realtek) CPU port is the DSA CPU port.
I just added an extra property to map external port to port number as
I don't know if there is a general rule for mapping between these two
values like number_of_user_ports (2..7)+ext_number (0,1,2).

>
> Similar to my comment to another patch in your series, I think it's
> worth making the driver support multiple EXT interfaces. Then it should
> be clearer in the series why you are making these changes.

I didn't change a driver limitation of only configuring an ext port if
it is a CPU port. However, I think it might just need to drop the
check. I'm not confident to implement any new feature that I cannot
test in real HW. This is also the case for SGMII. My chip does have
multiple external ports but the SGMII is not connected.

>
> Please consider also Vladimir's point about unnaturally splitting code.
> I can see it elsewhere in the series a little bit too. It is nice to
> keep the structure of the driver consistent - at least while it is still
> young and innocent. :-)

If I'm using DSA CPU information to define the Realtek CPU port I
either need to read that information walking DSA device-tree nodes or
doing that after DSA has already parsed it. That's why it went to
setup instead of detect, where DSA info is already available and where
the CPU settings are actually used. I could even drop rtl8365mb_cpu
from priv->chip_data as it is used only at that step. I could go even
further and drop cpu_port value from priv as all other users of cpu
information are based on the false assumption that ext port =3D=3D cpu
port.

We do need a way to tell if a port number is an external port and
which one it is. It would also be nice to warn the user their DSA is
mentioning a non-existing port.

>
> >
> >>   drivers/net/dsa/realtek/rtl8365mb.c | 23 ++++++++++++++---------
> >>   1 file changed, 14 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/rea=
ltek/rtl8365mb.c
> >> index a8f44538a87a..b79a4639b283 100644
> >> --- a/drivers/net/dsa/realtek/rtl8365mb.c
> >> +++ b/drivers/net/dsa/realtek/rtl8365mb.c
> >> @@ -103,14 +103,13 @@
> >>
> >>   /* Chip-specific data and limits */
> >>   #define RTL8365MB_CHIP_ID_8365MB_VC                0x6367
> >> -#define RTL8365MB_CPU_PORT_NUM_8365MB_VC    6
> >>   #define RTL8365MB_LEARN_LIMIT_MAX_8365MB_VC        2112
> >>
> >>   /* Family-specific data and limits */
> >>   #define RTL8365MB_PHYADDRMAX       7
> >>   #define RTL8365MB_NUM_PHYREGS      32
> >>   #define RTL8365MB_PHYREGMAX        (RTL8365MB_NUM_PHYREGS - 1)
> >> -#define RTL8365MB_MAX_NUM_PORTS     (RTL8365MB_CPU_PORT_NUM_8365MB_VC=
 + 1)
> >> +#define RTL8365MB_MAX_NUM_PORTS  7
> >>
> >>   /* Chip identification registers */
> >>   #define RTL8365MB_CHIP_ID_REG              0x1300
> >> @@ -1827,9 +1826,18 @@ static int rtl8365mb_setup(struct dsa_switch *d=
s)
> >>              dev_info(priv->dev, "no interrupt support\n");
> >>
> >>      /* Configure CPU tagging */
> >> -    ret =3D rtl8365mb_cpu_config(priv);
> >> -    if (ret)
> >> -            goto out_teardown_irq;
> >> +    for (i =3D 0; i < priv->num_ports; i++) {
> >> +            if (!(dsa_is_cpu_port(priv->ds, i)))
> >> +                    continue;
> >
> > dsa_switch_for_each_cpu_port(cpu_dp, ds)
> >
> >> +            priv->cpu_port =3D i;
> >> +            mb->cpu.mask =3D BIT(priv->cpu_port);
> >> +            mb->cpu.trap_port =3D priv->cpu_port;
> >> +            ret =3D rtl8365mb_cpu_config(priv);
> >> +            if (ret)
> >> +                    goto out_teardown_irq;
> >> +
> >> +            break;
> >> +    }
> >>
> >>      /* Configure ports */
> >>      for (i =3D 0; i < priv->num_ports; i++) {
> >> @@ -1960,8 +1968,7 @@ static int rtl8365mb_detect(struct realtek_priv =
*priv)
> >>                       "found an RTL8365MB-VC switch (ver=3D0x%04x)\n",
> >>                       chip_ver);
> >>
> >> -            priv->cpu_port =3D RTL8365MB_CPU_PORT_NUM_8365MB_VC;
> >> -            priv->num_ports =3D priv->cpu_port + 1;
> >> +            priv->num_ports =3D RTL8365MB_MAX_NUM_PORTS;
> >>
> >>              mb->priv =3D priv;
> >>              mb->chip_id =3D chip_id;
> >> @@ -1972,8 +1979,6 @@ static int rtl8365mb_detect(struct realtek_priv =
*priv)
> >>              mb->jam_size =3D ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc)=
;
> >>
> >>              mb->cpu.enable =3D 1;
> >> -            mb->cpu.mask =3D BIT(priv->cpu_port);
> >> -            mb->cpu.trap_port =3D priv->cpu_port;
> >>              mb->cpu.insert =3D RTL8365MB_CPU_INSERT_TO_ALL;
> >>              mb->cpu.position =3D RTL8365MB_CPU_POS_AFTER_SA;
> >>              mb->cpu.rx_length =3D RTL8365MB_CPU_RXLEN_64BYTES;
> >> --
> >> 2.34.0
> >>
>
