Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67EE544BCD3
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 09:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhKJIaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 03:30:16 -0500
Received: from mail-ua1-f43.google.com ([209.85.222.43]:39553 "EHLO
        mail-ua1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbhKJIaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 03:30:15 -0500
Received: by mail-ua1-f43.google.com with SMTP id i6so3166198uae.6;
        Wed, 10 Nov 2021 00:27:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uQGLy9TSy7z4CUPPpyYTSpZf9gYsNWWhiopCAQfwV3s=;
        b=m66vYe0WPCZ/eokMg00ZW764pKyFAp56/ZXfp14EBaU2hqV0nombvvTvu0UQh8ZYjQ
         yVpDFPq6pdH8G+QxFW0qgUbv+EYx28WUzA67ZU6762owcDOQowzIi/k+ZnTLIBM0htz5
         P6oJMMIFlrNZDmre4ubemvmbXNYfmT6wpsAPCZcIkWxH9purkb+XKf88QPE7DR8KA1zK
         1iId7PoXKhmoCUowbZmKXGY00FE7fGcEUl0RB0nug+N03bgCmFpeAXz82SlpuVK2iFY+
         WmqkhuTbJwPJr25EpW2UThdowBBbN9ACYvHC/VjiGgxRquyiGBGIJmHFbTxRRiuGZSqL
         6VkA==
X-Gm-Message-State: AOAM5333x9oq8ojXkp9DBNFbBAUh34ZEYqFqLocss8QdHI9r6KTabTIS
        FkhLgeSaB+XyB1qXGITQmig6bJI/pWdjtQ==
X-Google-Smtp-Source: ABdhPJzK4bWMqyN0aZXo6H4T3fio0qM8a+t1Ktk9AuD4jLSEwZWtx97ZVa/dYnBhVLZcHzjkn1fTBQ==
X-Received: by 2002:ab0:298c:: with SMTP id u12mr19555157uap.64.1636532847951;
        Wed, 10 Nov 2021 00:27:27 -0800 (PST)
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com. [209.85.222.50])
        by smtp.gmail.com with ESMTPSA id y2sm2913968vke.43.2021.11.10.00.27.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 00:27:27 -0800 (PST)
Received: by mail-ua1-f50.google.com with SMTP id p2so3111111uad.11;
        Wed, 10 Nov 2021 00:27:27 -0800 (PST)
X-Received: by 2002:a9f:2431:: with SMTP id 46mr10283360uaq.114.1636532847452;
 Wed, 10 Nov 2021 00:27:27 -0800 (PST)
MIME-Version: 1.0
References: <20211109040242.11615-1-schmitzmic@gmail.com> <20211109040242.11615-4-schmitzmic@gmail.com>
 <3d4c9e98-f004-755c-2f30-45b951ede6a6@infradead.org> <d5fa96b6-a351-1195-7967-25c26d9a04fb@gmail.com>
 <c7ab4109-9abf-dfe8-0325-7d3e113aa66c@infradead.org> <1ed3a71a-e57b-0754-b719-36ac862413da@gmail.com>
 <f5fb3808-b658-abfb-3b33-4ded8cd8ba57@infradead.org> <bcf2265d-cbd3-83dd-0131-a72efa97fd99@gmail.com>
In-Reply-To: <bcf2265d-cbd3-83dd-0131-a72efa97fd99@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 10 Nov 2021 09:27:16 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVjZxVmLp5Vg=Ks_vQpoJ_7D9JYoELhQM4zbKqvQMybDQ@mail.gmail.com>
Message-ID: <CAMuHMdVjZxVmLp5Vg=Ks_vQpoJ_7D9JYoELhQM4zbKqvQMybDQ@mail.gmail.com>
Subject: Re: [PATCH net v9 3/3] net/8390: apne.c - add 100 Mbit support to
 apne.c driver
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        ALeX Kazik <alex@kazik.de>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Tue, Nov 9, 2021 at 8:39 PM Michael Schmitz <schmitzmic@gmail.com> wrote:
> On 10/11/21 08:25, Randy Dunlap wrote:
> >>>>> There are no other drivers that "select PCCARD" or
> >>>>> "select PCMCIA" in the entire kernel tree.
> >>>>> I don't see any good justification to allow it here.
> >>>>
> >>>> Amiga doesn't use anything from the core PCMCIA code, instead
> >>>> providing its own basic PCMCIA support code.
> >>>>
> >>>> I had initially duplicated some of the cis tuple parser code, but
> >>>> decided to use what's already there instead.
> >>>>
> >>>> I can drop these selects, and add instructions to manually select
> >>>> these options in the Kconfig help section. Seemed a little error prone
> >>>> to me.
> >>>
> >>> Just make it the same as other drivers in this respect, please.
> >>
> >> "depends on PCMCIA" is what I've seen for other drivers. That is not
> >> really appropriate for the APNE driver (8 bit cards work fine with
> >> just the support code from arch/m68k/amiga/pcmcia.c).
> >>
> >> Please confirm that "depends on PCMCIA" is what you want me to use?
> >
> > Hi Michael,
> >
> > I don't want to see this driver using 'select', so that probably only
> > leaves "depends on".
> > But if you or Geert tell me that I am bonkers, so be it. :)
>
> Are you OK with adding CONFIG_PCCARD=y and CONFIG_PCMCIA=y to
> amiga_defconfig to allow APNE to still be built when changed to depend
> on PCMCIA?

Sure.  When they become dependencies for APNE, I will update them in
the next defconfig refresh.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
