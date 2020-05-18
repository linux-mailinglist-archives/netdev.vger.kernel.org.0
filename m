Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2F91D74C8
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 12:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgERKKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 06:10:25 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:42086 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbgERKKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 06:10:24 -0400
Received: by mail-oi1-f194.google.com with SMTP id l6so2622638oic.9;
        Mon, 18 May 2020 03:10:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OUWwAW1tiZj2X0S32FYVRQZMXC7D2eYX5NkiVFQhWuM=;
        b=jHTzn0kZ2WgWP9ll68PeWpOYW0SEYTSqGrXDFO8PGseYmiIfoWTSpXlLyYJy29CYQW
         dNTCM+K5gIbTai1adyeqFkkIUyK6mzuwE+jH/ePsJML9KoSW0vxr+fIC++q68ovb4/00
         8kqWB5arem5HInZB92P9a92Qj0JRRNkbgmXDRodzeQiHzCdAADtw63Z+ok2mBV6RQkM8
         e8VieaBLvO150B/p2z0MWWNTGRBBekAxuY3bPm5TshYCw5Hw16GpgDLgXcQ6uXINA4JQ
         u2ou/Ffsot0kaRARMOuGS6vqLAMx4yh2PpNrmTW4MAqIjRKoCH9FCFQH9+uo//o1vmaL
         c0mg==
X-Gm-Message-State: AOAM532JzgILyyQvEpVz1AHJaQQhr5gOPcJ7DhZc82wPHXEqNs3k1lPq
        839j7oyD3Uk8nSgXatxWR08i2UanzBUJBKeOfwQ=
X-Google-Smtp-Source: ABdhPJyBWPgZF8Nef5VFnPwIMZCFFtRvCnBOgZddEawH+Whlxj+gaH+OLdK5CmIFCwYF6ugC0lIB1QUdlxdAkaabczY=
X-Received: by 2002:aca:cd93:: with SMTP id d141mr9870659oig.148.1589796621997;
 Mon, 18 May 2020 03:10:21 -0700 (PDT)
MIME-Version: 1.0
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-4-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20200515171031.GB19423@ninjato> <CA+V-a8t6rPs4s8uMCpBQEAUvwsVn7Cte-vX3z2atWRhy_RFLQw@mail.gmail.com>
 <20200518092601.GA3268@ninjato>
In-Reply-To: <20200518092601.GA3268@ninjato>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 18 May 2020 12:10:05 +0200
Message-ID: <CAMuHMdVWe1EEAtP64VW+0zXNingM1LiENv_Rfz5qTQ+C0dtGSw@mail.gmail.com>
Subject: Re: [PATCH 03/17] ARM: dts: r8a7742: Add I2C and IIC support
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Jens Axboe <axboe@kernel.dk>, Rob Herring <robh+dt@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-ide@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wolfram,

On Mon, May 18, 2020 at 11:26 AM Wolfram Sang
<wsa+renesas@sang-engineering.com> wrote:
> > > However, both versions (with and without automatic transmission) are
> > > described with the same "renesas,iic-r8a7742" compatible. Is it possible
> > > to detect the reduced variant at runtime somehow?
> > >
> > I couldn't find anything the manual that would be useful to detect at runtime.

Hence if we really need that (see below), we need a quirk based on compatible
value + base address.

> > > My concern is that the peculiarity of this SoC might be forgotten if we
> > > describe it like this and ever add "automatic transmissions" somewhen.
> > >
> > Agreed.
>
> Well, I guess reading from a register which is supposed to not be there
> on the modified IP core is too hackish.

According to the Hardware User's Manual Rev. 1.00, the registers do exist
on all RZ/G1, except for RZ/G1E (see below).

   "(automatic transmission can be used as a hardware function, but this is
    not meaningful for actual use cases)."

(whatever that comment may mean?)

> Leaves us with a seperate compatible entry for it?

On R-Car E3 and RZ/G2E, which have a single IIC instance, we
handled that by:

        The r8a77990 (R-Car E3) and r8a774c0 (RZ/G2E)
        controllers are not considered compatible with
        "renesas,rcar-gen3-iic" or "renesas,rmobile-iic"
        due to the absence of automatic transmission registers.

On R-Car E2 and RZ/G1E, we forgot, and used both SoC-specific and
family-specific compatible values.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
