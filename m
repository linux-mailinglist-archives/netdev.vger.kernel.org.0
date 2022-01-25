Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC18049BF6A
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 00:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234260AbiAYXKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 18:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234246AbiAYXKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 18:10:13 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CA1C06161C;
        Tue, 25 Jan 2022 15:10:12 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id g2so19562801pgo.9;
        Tue, 25 Jan 2022 15:10:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o8ok+yx3CpNyWAo+hZwQcGMusI+MSV0R31Eo88H3Tvs=;
        b=DWuVhOqmYpDgPLQ0wkQ3FpovddbNqP/WIHh2XJo5TBIS8qyWUaCfNF8Bue6lseS+d/
         SCVTQGpoW+5Yl8O9oMl/JQXSE1NmlkoaxYemxt7FSMNVlzF+aZ4ZChVjAIWeaTFjOyzk
         kfLdHf26tKjfw5zbOoSqL6imDmUbhy6ysvDE/J8MuNA4Z5MydfyEIaRg+iUBnVVVUwqu
         /I3l2YfSrRG5iZGKyltz8yeNZYXmCJfS/FKFKJ0zcuO07zcbBO8UZ/QVZJlWNAoMemDK
         QypAoyidvOpWKHEBc4Ssje2dhGPGoeQy4hU5ZJjI6LK3jIE4XjK3LJhlKj0GpgdzUoww
         qHCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o8ok+yx3CpNyWAo+hZwQcGMusI+MSV0R31Eo88H3Tvs=;
        b=aPmEYOo0WgD+tdogRztEdNpHICSxKWTPgFyh/Iw1ydXTi6XVY8YrYELcqVnMwfHZH4
         c662hznSJGndXKcew/NenmBmnxtHRBNl0JSTA/3NCe/WvPqyMeBHQQJV0+7JjK3qLGhe
         K5afDoFM67qEmhoaPWbax9676PBHqKJN7OibIF6Sy3/oxY2AG6xZaF8NtrAxUEl2kpne
         uvVmj6BemfHNDgoHIeWmqiWcn54+VdiTfWODWYPpIhUnKRd0nDmoo0zD+YB2jwH5PB9G
         JNSlzf8HrCb0g57EsuIb6x8Uqb4nDOGBq9/gdmyo7cXF94iXNrh0SoeJFamsoh1xAHTj
         8f+Q==
X-Gm-Message-State: AOAM531+GBQpWgN/KPAo0oNl9fdh4WFSw1OQi8Yrimycx815V2D0pkvP
        AC0Ixjxzz1QxdaYAanwVCjeGiJ9E6whZ5z3P9QU=
X-Google-Smtp-Source: ABdhPJxR622cpR+WywO3DNEzc/o4P3BzlZ/AkRmMfxl9mZTaODqCnlBJ0CfTvCxrfoCtINGCMoU3h5pem/IkGQOWEL8=
X-Received: by 2002:a63:91c4:: with SMTP id l187mr16702237pge.513.1643152212326;
 Tue, 25 Jan 2022 15:10:12 -0800 (PST)
MIME-Version: 1.0
References: <20220123183925.1052919-1-yury.norov@gmail.com>
 <20220123183925.1052919-11-yury.norov@gmail.com> <Ye6bUC1GyLLUV37p@smile.fi.intel.com>
 <CAAH8bW_u6oNOkMsA_jRyWFHkzjMi0CB7gXmvLYAdjNMSqrrY7w@mail.gmail.com> <58c222c15b2d43689f43d31afb5cb914@AcuMS.aculab.com>
In-Reply-To: <58c222c15b2d43689f43d31afb5cb914@AcuMS.aculab.com>
From:   Yury Norov <yury.norov@gmail.com>
Date:   Tue, 25 Jan 2022 15:10:00 -0800
Message-ID: <CAAH8bW8f5vGB33fwzehJHeMRi7-Z1vgO5TLCiTUXfZB1DJ_xCQ@mail.gmail.com>
Subject: Re: [PATCH 10/54] net: ethernet: replace bitmap_weight with
 bitmap_empty for qlogic
To:     David Laight <David.Laight@aculab.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Joe Perches <joe@perches.com>, Dennis Zhou <dennis@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Nicholas Piggin <npiggin@gmail.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Alexey Klimov <aklimov@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 2:15 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: Yury Norov
> > Sent: 25 January 2022 21:10
> > On Mon, Jan 24, 2022 at 4:29 AM Andy Shevchenko
> > <andriy.shevchenko@linux.intel.com> wrote:
> > >
> > > On Sun, Jan 23, 2022 at 10:38:41AM -0800, Yury Norov wrote:
> > > > qlogic/qed code calls bitmap_weight() to check if any bit of a given
> > > > bitmap is set. It's better to use bitmap_empty() in that case because
> > > > bitmap_empty() stops traversing the bitmap as soon as it finds first
> > > > set bit, while bitmap_weight() counts all bits unconditionally.
> > >
> > > > -             if (bitmap_weight((unsigned long *)&pmap[item], 64 * 8))
> > > > +             if (!bitmap_empty((unsigned long *)&pmap[item], 64 * 8))
> > >
> > > > -         (bitmap_weight((unsigned long *)&pmap[item],
> > > > +         (!bitmap_empty((unsigned long *)&pmap[item],
> > >
> > > Side note, these castings reminds me previous discussion and I'm wondering
> > > if you have this kind of potentially problematic places in your TODO as
> > > subject to fix.
> >
> > In the discussion you mentioned above, the u32* was cast to u64*,
> > which is wrong. The code
> > here is safe because in the worst case, it casts u64* to u32*. This
> > would be OK wrt
> >  -Werror=array-bounds.
> >
> > The function itself looks like doing this unsigned long <-> u64
> > conversions just for printing
> > purpose. I'm not a qlogic expert, so let's wait what people say?
>
> It'll be wrong on BE systems.

The bitmap_weigh() result will be correct. As you can see, the address
is 64-bit aligned anyways. The array boundary violation will never happen
as well.

DP_NOTICE() may be wrong, or may not. It depends on how important
the absolute position of the bit in the printed bitmap is. Nevertheless,
printk("%pb") is better and should be used.

This whole concern may be simply irrelevant if QED is not supported
on 32-bit BE machines. From what I can see, at least Infiniband requires
64BIT.

Thanks,
Yury

> You just can't cast the argument it has to be long[].
>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
