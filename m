Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E272222E741
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 10:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgG0IFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 04:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbgG0IFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 04:05:17 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0186AC0619D4;
        Mon, 27 Jul 2020 01:05:16 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id s189so8993230pgc.13;
        Mon, 27 Jul 2020 01:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TckLjYCl3ZHc6WH0Io4YM2xM1w1BSOcuwRjb/jFrFu8=;
        b=uUWm7YbSw6kSCPGkd8zYVj+tz3Y1WzLm7iabNsBf/f2jAcIGUUNu7jRiuVcSkPhj/l
         SooQNg8jE9i5joPt4qRv+e3L+RRSyiGamh/sUTVNiy/05HBYP/Wgx9Fm0a1GwWDynYMl
         8RGIU2tkbNyxdehhTUld+0jdT5QyZE0LvhqF6uep1hkvFzzyRMpbNkpxI3dT1IL4qnv8
         Ib44lOp7++Wvpp3lIkmBF4X4jzIL030AOi+vbqUqjzwIhPzjFui5toN+UUUSvPkd52Y6
         xe0IKNw3GMH8mgcuaEEzCdvgmz6J+Do5eqCRqxTyrAT1cWkrW7eRXcLkMmxnNEmzlOg5
         l8cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TckLjYCl3ZHc6WH0Io4YM2xM1w1BSOcuwRjb/jFrFu8=;
        b=LrjZpqjEj6zW5Eoxan1rM+gfp4IFyv6XZGOTYzYd1bV95tZSwqoTImZrTQibxod/M6
         +3TI9EJnUlUDoN63OzfhsAdinbWvb1UkMtXQ9XwkjYSFrJxOrsIA1WlvktJfH/Cq/WV/
         IBax6ya1K5r8lam4T1mObEOQxatdQKhTf/U+0Wpai1T0x/oSdz4sSzAi6U++v4picD94
         D6W0IhW+AKV+vIQvSEE97/4ufjdx5OJINquNDn2K2jzUcgty9E62u5y1epYo8yWToQ7Y
         I9gmKZ4reho6zElXD9g8iD8Qe6TsyKEGqoRfmVXJ7sHVcFad9BIyFWFTo34XVmBMo8gW
         /7Ag==
X-Gm-Message-State: AOAM530eymGheVtfswNZs7/7OIqfKMdbJYZlelr6+Tv/PDifWq2Hgmjt
        NcZ0hXlHJD+3rXTilDMtooCMeB+FdAYOodC+OBI=
X-Google-Smtp-Source: ABdhPJwpD4Hp9GuBJVn1Vz04MUZ8WhRdu7W6lR0HY/v6uz+H/BjgC39W/xDhP1bCbkviZBuXvp4z0I5lBYEyr18C1fs=
X-Received: by 2002:a63:ce41:: with SMTP id r1mr19216079pgi.203.1595837115244;
 Mon, 27 Jul 2020 01:05:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200725150651.17029-1-vadym.kochan@plvision.eu>
 <20200725150651.17029-3-vadym.kochan@plvision.eu> <CAHp75VeLS+-QkHuee8oPP4TDQoQPGFHSVpzi0e4m3Xhy2K+d1g@mail.gmail.com>
 <20200726225545.GA11300@plvision.eu>
In-Reply-To: <20200726225545.GA11300@plvision.eu>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 27 Jul 2020 11:04:56 +0300
Message-ID: <CAHp75Vea6eWUqvXAKtu5Qv3Q0Oo=mxD+zf+zogZdcYOFtRe17g@mail.gmail.com>
Subject: Re: [net-next v3 2/6] net: marvell: prestera: Add PCI interface support
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mickey Rachamim <mickeyr@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 1:55 AM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
> On Sun, Jul 26, 2020 at 01:32:19PM +0300, Andy Shevchenko wrote:
> > On Sat, Jul 25, 2020 at 6:10 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:

...

For the non-commented I assume you are agree with. Correct?

...

> > > +config PRESTERA_PCI
> > > +       tristate "PCI interface driver for Marvell Prestera Switch ASICs family"
> > > +       depends on PCI && HAS_IOMEM && PRESTERA
> >
> > > +       default m
> >
> > Even if I have CONFIG_PRESTERA=y, why as a user I must have this as a module?
> > If it's a crucial feature, shouldn't it be rather
> >   default CONFIG_PRESTERA
> > ?
>
> The firmware image should be located on rootfs, and in case the rootfs
> should be mounted later the pci driver can't pick this up when
> statically compiled so I left it as 'm' by default.

We have for a long time to catch firmware blobs from initrd (initramfs).
default m is very unusual.

...

> > > +#define PRESTERA_FW_PATH \
> > > +       "mrvl/prestera/mvsw_prestera_fw-v" \
> > > +       __stringify(PRESTERA_SUPP_FW_MAJ_VER) \
> > > +       "." __stringify(PRESTERA_SUPP_FW_MIN_VER) ".img"
> >
> > Wouldn't it be better to see this in the C code?
>
> I have no strong opinion on this, but looks like macro is enough for
> this statically defined versioning.

The problem is that you have to bounce your editor to C code then to
macro then to another macro...
(in case you are looking for the code responsible for that)
In many drivers I saw either it's one static line (without those
__stringify(), etc) or done in C code dynamically near to
request_firmware() call.

Maybe you may replace __stringify by explicit characters / strings and
comment how the name was constructed?

#define FW_NAME "patch/to/it/fileX.Y.img"

...

> > > +static void prestera_pci_copy_to(u8 __iomem *dst, u8 *src, size_t len)
> > > +{
> > > +       u32 __iomem *dst32 = (u32 __iomem *)dst;
> > > +       u32 *src32 = (u32 *)src;
> > > +       int i;
> > > +
> > > +       for (i = 0; i < (len / 4); dst32++, src32++, i++)
> > > +               writel_relaxed(*src32, dst32);
> > > +}
> > > +
> > > +static void prestera_pci_copy_from(u8 *dst, u8 __iomem *src, size_t len)
> > > +{
> > > +       u32 __iomem *src32 = (u32 __iomem *)src;
> > > +       u32 *dst32 = (u32 *)dst;
> > > +       int i;
> > > +
> > > +       for (i = 0; i < (len / 4); dst32++, src32++, i++)
> > > +               *dst32 = readl_relaxed(src32);
> > > +}
> >
> > NIH of memcpy_fromio() / memcpy_toio() ?
> >
> I am not sure if there will be no issue with < 4 bytes transactions over
> PCI bus. I need to check it.

I didn't get it. You always do 4 byte chunks, so, supply aligned
length to memcpy and you will have the same.

...

> > > +static int prestera_fw_rev_check(struct prestera_fw *fw)
> > > +{
> > > +       struct prestera_fw_rev *rev = &fw->dev.fw_rev;
> > > +       u16 maj_supp = PRESTERA_SUPP_FW_MAJ_VER;
> > > +       u16 min_supp = PRESTERA_SUPP_FW_MIN_VER;
> > > +
> >
> > > +       if (rev->maj == maj_supp && rev->min >= min_supp)
> > > +               return 0;
> >
> > Why not traditional pattern
> >
> > if (err) {
> >  ...
> > }
>
> At least for me it looks simpler when to check which version is
> correct.

OK.

> > ...
> > return 0;
> >
> > ?
> >
> > > +       dev_err(fw->dev.dev, "Driver supports FW version only '%u.%u.x'",
> > > +               PRESTERA_SUPP_FW_MAJ_VER, PRESTERA_SUPP_FW_MIN_VER);
> > > +
> > > +       return -EINVAL;
> > > +}

...

> Thanks Andy for the comments, especially for pcim_ helpers.

You are welcome!

-- 
With Best Regards,
Andy Shevchenko
