Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B014E44FA24
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 20:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236178AbhKNT0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 14:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236153AbhKNT0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Nov 2021 14:26:54 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530B1C061746
        for <netdev@vger.kernel.org>; Sun, 14 Nov 2021 11:23:59 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id s186so40284253yba.12
        for <netdev@vger.kernel.org>; Sun, 14 Nov 2021 11:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6U3HI2L8FKbSjz7rw5IDvF8Xit/zG1CBcJEp+Nlge0k=;
        b=csQbimD9nZJdajo1bMEfiRVFciDm/2L+v6sL2+J4BsJhdcWBNFcs5c5crzlIVQG5Pb
         sKIUa5Y0CHVg4qzALaj6hG5gUs9Pj7JSd9RWjsncZsv4lPMqoYEjjiNZSzgZjg7njVZP
         aoKFx1Sd+TBFXpR5I3x9XYRlM4JuiDtN20r52TrrjOXRljwncgB/KjJh0onA/SoS/37U
         AHeGaSFn/qx7W0EiBbcuvjMeHmLeYUqoF0A+ukrFBbdLbZy9yoM3ajHw92r90ZsmtW3c
         nozHH8cFte8o2MCcg/kOngAGx1p/amrEFzE4OAY/Oe1gI0HsiHVkYSQXAuTn/tv60IbD
         RVJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6U3HI2L8FKbSjz7rw5IDvF8Xit/zG1CBcJEp+Nlge0k=;
        b=WGvjB4XYBVIP97mdNmZ8Su/Xfv89ukrSZWM2ZbDelWqxDxt/7k+zzkRyGOvFG4yxcq
         iikkDC+p9AqmpHnwb0CAmEdtp0A5z963vqL0fxuPxEllax0xYOjyRTUk3qiliD1EqXVC
         uwPyt1osRp0Nf4V3MgDNObMl03yTnEh8eaWh+Xi7W+8YjI6EO1lfdCqPnzUBmSSsV4ii
         eJMZSsPe3d1QcJ8aYpwoPRgZ6JdafTlpqLaYO5addupRSqCjcqplA6d0sBiyxu6F7rht
         A0Wv6V/MHPFfaSsgTa8EFz8MPVqFW3T9BWkRc0PbGXGGzmBtSbVxFbFFGq44EPdX7Z8p
         7y8A==
X-Gm-Message-State: AOAM5338xcrbEq+6ZG00P/CCO54qz+uqJUvzesOG7/heYPbBzMxNy+nJ
        7rVNUsRarZiytYfpArAMmVByh04s+PG/0cb5nhbEtKRyqbc=
X-Google-Smtp-Source: ABdhPJwu14CSzhzB3B6UN+TtaMTze6dsAVaDupv5xWbHIHf67Wmd95Xxfk4G6cQxXz/rYlMgwOvhvGrh1AG2FaDOYRU=
X-Received: by 2002:a25:2fd1:: with SMTP id v200mr34513376ybv.78.1636917838145;
 Sun, 14 Nov 2021 11:23:58 -0800 (PST)
MIME-Version: 1.0
References: <20211111181025.2139131-1-eric.dumazet@gmail.com>
 <CAKgT0UdmECakQTinbTagiG4PWfaniP_GP6T3rLvWdP+mVrB4xw@mail.gmail.com>
 <CANn89iJAakUCC6UuUHSozT9wz7_rrgrRq3dv+hXJ1FL_DCZHyA@mail.gmail.com>
 <226c88f6446d43afb6d9b5dffda5ab2a@AcuMS.aculab.com> <CANn89iJtqTGuJL6JgfOAuHxbkej9faURhj3yf2a9Y43Uh_4+Kg@mail.gmail.com>
 <31bd81df79c4488c92c6a149eeceee3c@AcuMS.aculab.com>
In-Reply-To: <31bd81df79c4488c92c6a149eeceee3c@AcuMS.aculab.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 14 Nov 2021 11:23:46 -0800
Message-ID: <CANn89iLJe-M65NGbbj=wYjCKSz35yg3rtWoi4Lh7DMNcXmKNZg@mail.gmail.com>
Subject: Re: [PATCH v1] x86/csum: rewrite csum_partial()
To:     David Laight <David.Laight@aculab.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 14, 2021 at 11:10 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Eric Dumazet
> > Sent: 14 November 2021 15:04
> >
> > On Sun, Nov 14, 2021 at 6:44 AM David Laight <David.Laight@aculab.com> wrote:
> > >
> > > From: Eric Dumazet
> > > > Sent: 11 November 2021 22:31
> > > ..
> > > > That requires an extra add32_with_carry(), which unfortunately made
> > > > the thing slower for me.
> > > >
> > > > I even hardcoded an inline fast_csum_40bytes() and got best results
> > > > with the 10+1 addl,
> > > > instead of
> > > >  (5 + 1) acql +  mov (needing one extra  register) + shift + addl + adcl
> > >
> > > Did you try something like:
> > >         sum = buf[0];
> > >         val = buf[1]:
> > >         asm(
> > >                 add64 sum, val
> > >                 adc64 sum, buf[2]
> > >                 adc64 sum, buf[3]
> > >                 adc64 sum, buf[4]
> > >                 adc64 sum, 0
> > >         }
> > >         sum_hi = sum >> 32;
> > >         asm(
> > >                 add32 sum, sum_hi
> > >                 adc32 sum, 0
> > >         )
> >
> > This is what I tried. but the last part was using add32_with_carry(),
> > and clang was adding stupid mov to temp variable on the stack,
> > killing the perf.
>
> Persuading the compile the generate the required assembler is an art!
>
> I also ended up using __builtin_bswap32(sum) when the alignment
> was 'odd' - the shift expression didn't always get converted
> to a rotate. Byteswap32 DTRT.
>
> I also noticed that any initial checksum was being added in at the end.
> The 64bit code can almost always handle a 32 bit (or maybe 56bit!)
> input value and add it in 'for free' into the code that does the
> initial alignment.

This has been fixed in V2 : initial csum is used instead of 0

>
> I don't remember testing misaligned buffers.
> But I think it doesn't matter (on cpu anyone cares about!).
> Even Sandy bridge can do two memory reads in one clock.
> So should be able to do a single misaligned read every clock.
> Which almost certainly means that aligning the addresses is pointless.
> (Given you're not trying to do the adcx/adox loop.)
> (Page spanning shouldn't matter.)
>
> For buffers that aren't a multiple of 8 bytes it might be best to
> read the last 8 bytes first and shift left to discard the ones that
> would get added in twice.
> This value can be added to the 32bit 'input' checksum.
> Something like:
>         sum_in += buf[length - 8] << (64 - (length & 7) * 8));
> Annoyingly a special case is needed for buffers shorter than 8 bytes
> to avoid falling off the start of a page.

Yep, Alexander/Peter proposed this already, and it is implemented in V2

>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
