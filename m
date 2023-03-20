Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 005526C2212
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 20:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjCTT6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 15:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbjCTT6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 15:58:53 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C367234C8;
        Mon, 20 Mar 2023 12:58:45 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id l16so5048425ybe.6;
        Mon, 20 Mar 2023 12:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679342324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zBybbIP1ZIep/Xag1gH0yWaOUYHUoiApZF58mzTvpoQ=;
        b=jfDYGuEJ7Sk9BUlWQQWsY8a84vHVcuqzZ/wlxPbrtzCkpdp//LzrXSSBMG0n/5k8g4
         zs4RYJByuhulZPyGdb2mRZ0+iEBo95Af/XiDPTN9j2g7FtYqKp+11g0gKx7lyzf8hRvo
         dGFIM8cCxSfqOiLmkJ+5q6mxFti+V5oV3Q67Eo5M3USLcQW6/gKyy7Zde/nwjwRynXSC
         xNQIskhvLEMIMssFsL2w+AfxXQwuoogFfHBh0yjIkek8g0WZ9vaGrsMSHPYAKpJJp8c3
         YAdY2em6Seuj83l/xz/o8uSrJ+7WVRYgEDn6ZiRkmJogBnZ7Wfoq6ROpPiSNEOB3OL0Z
         QB4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679342324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zBybbIP1ZIep/Xag1gH0yWaOUYHUoiApZF58mzTvpoQ=;
        b=jfXTI6l6R7kWgpvslwmjcXPGfdvIrTZzNZcIY+mWvGk+hZDSQC+PFPm6uy1ozFvFIL
         h4L8VGiaRLxywgXDpIlEj7qedK4VX71flMsvSbP0z5VSSV7q3pchkReUfGi6Csv0KWcH
         ovO0dV/b6xEcBH16QXECbuxc8kpUJswal4933Hm/qj8pWg4RbtC1OFT5f7xcp504qOZu
         O4SGHYv8XZJDTkFA20EX0L3+GHH8qHzgMQ1lmYI5uKcSDw8g3/T0VR0bJ8cOK4T18kRa
         lsd18CrAN4j0qIy6eJlMXHTO+e8fcKA7mpaKhkDPd3dpEnooMUCIqPrwCGp5MGErXFfS
         Iehw==
X-Gm-Message-State: AAQBX9cpcggKJFkHYFgYuxKytxoT7vq+vITP5H6MH8SldColtIphn7f8
        Q/3mUVYgeS/sBi1MBwQFGKptgcsuk4FbCPFkCKA=
X-Google-Smtp-Source: AKy350bYqvlm/IXOASpeOVYsJca1qwOldz8palom9n2LnTNgYKmcjLXMqDj48xAeHMF9G4aNt20aEcLBQj5rGEo8Csc=
X-Received: by 2002:a25:ab11:0:b0:b6b:79a2:8cff with SMTP id
 u17-20020a25ab11000000b00b6b79a28cffmr290575ybi.9.1679342324028; Mon, 20 Mar
 2023 12:58:44 -0700 (PDT)
MIME-Version: 1.0
References: <20230320182813.963508-1-noltari@gmail.com> <95e106fd-d1ce-b9d4-a4f7-03fb69bd4aaa@gmail.com>
In-Reply-To: <95e106fd-d1ce-b9d4-a4f7-03fb69bd4aaa@gmail.com>
From:   =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Date:   Mon, 20 Mar 2023 20:58:32 +0100
Message-ID: <CAKR-sGcxa06mJbcN4jRyVEO6sGQpvCA6BHjBmzu4fehSpFrfwQ@mail.gmail.com>
Subject: Re: [RFC PATCH] drivers: net: dsa: b53: mmap: add phy ops
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     jonas.gorski@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

El lun, 20 mar 2023 a las 20:06, Florian Fainelli
(<f.fainelli@gmail.com>) escribi=C3=B3:
>
> On 3/20/23 11:28, =C3=81lvaro Fern=C3=A1ndez Rojas wrote:
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
>
> Looks good for the most part, just a few questions below.
>
> >
> > Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
> > ---
> >   drivers/net/dsa/b53/b53_mmap.c    | 86 ++++++++++++++++++++++++++++++=
+
> >   include/linux/platform_data/b53.h |  1 +
> >   2 files changed, 87 insertions(+)
> >
> > diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_m=
map.c
> > index 706df04b6cee..7deca1c557c5 100644
> > --- a/drivers/net/dsa/b53/b53_mmap.c
> > +++ b/drivers/net/dsa/b53/b53_mmap.c
> > @@ -19,14 +19,25 @@
> >   #include <linux/bits.h>
> >   #include <linux/kernel.h>
> >   #include <linux/module.h>
> > +#include <linux/of_mdio.h>
> >   #include <linux/io.h>
> >   #include <linux/platform_device.h>
> >   #include <linux/platform_data/b53.h>
> >
> >   #include "b53_priv.h"
> >
> > +#define REG_MDIOC            0xb0
> > +#define  REG_MDIOC_EXT_MASK  BIT(16)
> > +#define  REG_MDIOC_REG_SHIFT 20
> > +#define  REG_MDIOC_PHYID_SHIFT       25
> > +#define  REG_MDIOC_RD_MASK   BIT(30)
> > +#define  REG_MDIOC_WR_MASK   BIT(31)
>
> For some reason, there was no bit introduced to tell us when a
> transaction has finished, so we have to poll after a certain delay has
> elapsed...

Yeah... :(

>
> > +
> > +#define REG_MDIOD            0xb4
> > +
> >   struct b53_mmap_priv {
> >       void __iomem *regs;
> > +     struct mii_bus *bus;
> >   };
> >
> >   static int b53_mmap_read8(struct b53_device *dev, u8 page, u8 reg, u8=
 *val)
> > @@ -216,6 +227,69 @@ static int b53_mmap_write64(struct b53_device *dev=
, u8 page, u8 reg,
> >       return 0;
> >   }
> >
> > +static inline void b53_mmap_mdio_read(struct b53_device *dev, int phy_=
id,
> > +                                   int loc, u16 *val)
> > +{
> > +     uint32_t reg;
> > +
> > +     b53_mmap_write32(dev, 0, REG_MDIOC, 0);
> > +
> > +     reg =3D REG_MDIOC_RD_MASK |
> > +           (phy_id << REG_MDIOC_PHYID_SHIFT) |
> > +           (loc << REG_MDIOC_REG_SHIFT);
> > +
> > +     b53_mmap_write32(dev, 0, REG_MDIOC, reg);
> > +     udelay(50);
> > +     b53_mmap_read16(dev, 0, REG_MDIOD, val);
> > +}
> > +
> > +static inline int b53_mmap_mdio_write(struct b53_device *dev, int phy_=
id,
> > +                                   int loc, u16 val)
> > +{
> > +     uint32_t reg;
> > +
> > +     b53_mmap_write32(dev, 0, REG_MDIOC, 0);
> > +
> > +     reg =3D REG_MDIOC_WR_MASK |
> > +           (phy_id << REG_MDIOC_PHYID_SHIFT) |
> > +           (loc << REG_MDIOC_REG_SHIFT) |
> > +           val;
> > +
> > +     b53_mmap_write32(dev, 0, REG_MDIOC, reg);
> > +     udelay(50);
> > +
> > +     return 0;
> > +}
> > +
> > +static int b53_mmap_phy_read16(struct b53_device *dev, int addr, int r=
eg,
> > +                            u16 *value)
> > +{
> > +     struct b53_mmap_priv *priv =3D dev->priv;
> > +     struct mii_bus *bus =3D priv->bus;
> > +
> > +     if (bus)
> > +             *value =3D mdiobus_read_nested(bus, addr, reg);
>
> Since you make the 'mii-bus' property and 'priv->bus' necessary
> prerequisites for the driver to finish probing successfully, when shall
> we not have valid priv->bus reference to work with? Do we end-up taking
> the other path at all?

Yes, but only if the driver is probed from platform data and not from
device tree.

> --
> Florian
>

--
=C3=81lvaro.
