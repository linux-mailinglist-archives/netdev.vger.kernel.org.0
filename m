Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBA76C38DE
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 19:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbjCUSEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 14:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbjCUSEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 14:04:31 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ECAE2A999;
        Tue, 21 Mar 2023 11:04:21 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id l16so8673978ybe.6;
        Tue, 21 Mar 2023 11:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679421861;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sBdvXh/c3I/U5M/2ybbvcKctKEFyFqgkWliPpnVIxQk=;
        b=SipYV3YA0zrzvmEAe30qwziS5hscxDJcXBtvyGPKiDeS/a5/78Y7ULbxZFIuUEPGOX
         o7P1hkar9PNEHRl5tBd9K+osE590hpor8PAiD7JrbmkJE9n1mWxdIwI+Wwd8VN3DF5Vp
         WAGj21Yr2UbQbY8WMWxHMbrPA8dc7tWU5QK6IBJ8lnIsqa4b+aIdNjot3/h9Igoe/KzE
         ZEv9jkmTrVhgzLBw4Sop/BEf/FQBKiIGXJiNiJgsL/yWnculcNGigGaHFcTb0EdyGmBY
         rUj/5gqadi4kmXFa+AseUOgBrta/UoyqMmo29rn8uePcc730y+0kwNDMYzlYC0P79Zri
         9tBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679421861;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sBdvXh/c3I/U5M/2ybbvcKctKEFyFqgkWliPpnVIxQk=;
        b=cjaQzcf8DHUUQ50zfpMTEsImGEXz5GhHFE9wtaqrZ22aRc5I2rEa3TfWoOhJp2P227
         qSH0eC2iZFxJpE0ybLjy7+ev7iG2Be4wE1K9QPw2l0ZmSE75GtUh0ChR/dAyFg5PStjA
         NRaehLM5XYmr6VeH8AvFoudA49ynev28neqHucZoaucst3cmQW6+4L9vO5yJrPVr1D2G
         AdhYe+tPdoOTOe/nEJTuuN0PZLhpI7JVJ/yK6hIqQ1ZSazRwmUpdEqbVsCXtdnYwY4xG
         z1olXUsc1Je4kS8wtzGsQ159vU848OFGMJdC7XtqdPyrHYVtqFhh6aUkFaxKAi0sJuyw
         I/1A==
X-Gm-Message-State: AAQBX9fkovDlsZY611WaLvd9W132xI68opCh7w6J8/nvuR3IZE4pfbRp
        9EqFuwVnwuFWBqF7AvC9UGkVqE7011m0W+5Ynhc=
X-Google-Smtp-Source: AKy350aqIu+5LqJWWDRZJb8jTAYnVYgUsIoJ1tMqb9Gfunl4Czz5IhEZHTP2GhG3bVR36wQJXrhdapaVcqBc+g7x62Q=
X-Received: by 2002:a05:6902:1109:b0:b6d:fc53:c5c0 with SMTP id
 o9-20020a056902110900b00b6dfc53c5c0mr2338157ybu.1.1679421860715; Tue, 21 Mar
 2023 11:04:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230320182813.963508-1-noltari@gmail.com> <CAOiHx=nKVWfa1-_VAf3bz+6PPz0uWMHyEtoVVOysFf0srZorBA@mail.gmail.com>
In-Reply-To: <CAOiHx=nKVWfa1-_VAf3bz+6PPz0uWMHyEtoVVOysFf0srZorBA@mail.gmail.com>
From:   =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Date:   Tue, 21 Mar 2023 19:04:09 +0100
Message-ID: <CAKR-sGdpck1GPMpqM3M-H6Bz_mp+xiV-o6ZuR6QZATNA_=Xa0A@mail.gmail.com>
Subject: Re: [RFC PATCH] drivers: net: dsa: b53: mmap: add phy ops
To:     Jonas Gorski <jonas.gorski@gmail.com>
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jonas,

El mar, 21 mar 2023 a las 11:36, Jonas Gorski
(<jonas.gorski@gmail.com>) escribi=C3=B3:
>
> On Mon, 20 Mar 2023 at 19:28, =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@g=
mail.com> wrote:
> >
> > Currently, B53 MMAP BCM63xx devices with an external switch hang when
> > performing PHY read and write operations due to invalid registers acces=
s.
> > This adds support for PHY ops by using the internal bus from mdio-mux-b=
cm6368
> > when probed by device tree and also falls back to direct MDIO registers=
 if not.
> >
> > This is an alternative to:
> > - https://patchwork.kernel.org/project/netdevbpf/cover/20230317113427.3=
02162-1-noltari@gmail.com/
> > - https://patchwork.kernel.org/project/netdevbpf/patch/20230317113427.3=
02162-2-noltari@gmail.com/
> > - https://patchwork.kernel.org/project/netdevbpf/patch/20230317113427.3=
02162-3-noltari@gmail.com/
> > - https://patchwork.kernel.org/project/netdevbpf/patch/20230317113427.3=
02162-4-noltari@gmail.com/
> > As discussed, it was an ABI break and not the correct way of fixing the=
 issue.
> >
> > Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
> > ---
> >  drivers/net/dsa/b53/b53_mmap.c    | 86 +++++++++++++++++++++++++++++++
> >  include/linux/platform_data/b53.h |  1 +
> >  2 files changed, 87 insertions(+)
> >
> > diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_m=
map.c
> > index 706df04b6cee..7deca1c557c5 100644
> > --- a/drivers/net/dsa/b53/b53_mmap.c
> > +++ b/drivers/net/dsa/b53/b53_mmap.c
> > @@ -19,14 +19,25 @@
> >  #include <linux/bits.h>
> >  #include <linux/kernel.h>
> >  #include <linux/module.h>
> > +#include <linux/of_mdio.h>
> >  #include <linux/io.h>
> >  #include <linux/platform_device.h>
> >  #include <linux/platform_data/b53.h>
> >
> >  #include "b53_priv.h"
> >
> > +#define REG_MDIOC              0xb0
> > +#define  REG_MDIOC_EXT_MASK    BIT(16)
> > +#define  REG_MDIOC_REG_SHIFT   20
> > +#define  REG_MDIOC_PHYID_SHIFT 25
> > +#define  REG_MDIOC_RD_MASK     BIT(30)
> > +#define  REG_MDIOC_WR_MASK     BIT(31)
> > +
> > +#define REG_MDIOD              0xb4
> > +
> >  struct b53_mmap_priv {
> >         void __iomem *regs;
> > +       struct mii_bus *bus;
> >  };
> >
> >  static int b53_mmap_read8(struct b53_device *dev, u8 page, u8 reg, u8 =
*val)
> > @@ -216,6 +227,69 @@ static int b53_mmap_write64(struct b53_device *dev=
, u8 page, u8 reg,
> >         return 0;
> >  }
> >
> > +static inline void b53_mmap_mdio_read(struct b53_device *dev, int phy_=
id,
> > +                                     int loc, u16 *val)
> > +{
> > +       uint32_t reg;
> > +
> > +       b53_mmap_write32(dev, 0, REG_MDIOC, 0);
> > +
> > +       reg =3D REG_MDIOC_RD_MASK |
> > +             (phy_id << REG_MDIOC_PHYID_SHIFT) |
> > +             (loc << REG_MDIOC_REG_SHIFT);
> > +
> > +       b53_mmap_write32(dev, 0, REG_MDIOC, reg);
> > +       udelay(50);
> > +       b53_mmap_read16(dev, 0, REG_MDIOD, val);
> > +}
> > +
> > +static inline int b53_mmap_mdio_write(struct b53_device *dev, int phy_=
id,
> > +                                     int loc, u16 val)
>
> On nitpick here: AFACT, what you are actually getting there as phy_id
> isn't the phy_id but the port_id, it just happens to be identical for
> internal ports.
>
> So in theory you would first need to convert this to the appropriate
> phy_id (+ which bus) first, else you risk reading from the wrong
> device (and/or bus).

I agree with you and your suggestion gave me an idea, what if
phy_read/phy_write wasn't set in b53 dsa_switch_ops for mmap?

So I implemented the following patch:
https://gist.github.com/Noltari/cfecb29d6401d06b9cb5dd199607918b#file-net-d=
sa-b53-mmap-disable-phy-read-write-patch

And this is the result:
https://gist.github.com/Noltari/cfecb29d6401d06b9cb5dd199607918b#file-net-d=
sa-b53-mmap-disable-phy-read-write-log

As you can see, bcm6368-mdio-mux is now used for every mii access as
it should have been from the beginning...
So I guess that the correct way of fixing the issue would be to
disable phy read/write from b53 mmap. However, I don't know if the
patch that I provided is correct, or if I should remove those from
dsa_switch_ops in any other way (I'm open to suggestions).

>
> See how the phys_mii_mask is based on the indexes of the user ports,
> not their actual phy_ids. [1] [2]
>
> [1] https://elixir.bootlin.com/linux/latest/source/net/dsa/dsa.c#L660
> [2] https://elixir.bootlin.com/linux/latest/source/include/net/dsa.h#L596
>
> Regards
> Jonas

--
Best regards,
=C3=81lvaro
