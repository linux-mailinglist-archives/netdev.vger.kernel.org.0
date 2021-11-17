Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8B04544A1
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 11:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233814AbhKQKI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 05:08:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236156AbhKQKIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 05:08:22 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07628C061764
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 02:05:24 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id z1-20020a05600c220100b00337f97d2464so3415719wml.1
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 02:05:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VQSmnrBQRiI16GECdp3OMat4LBaKuciGyFg9M/kRhI0=;
        b=YRKMawAlDAdbPct1axOr+wCi5Y1IoNDjuSIbznBUciYscqJxnjSw85+cR2DV4Dx32h
         TNrDd89YPteJcS3oehgIh2TH9wuev38tG46LDIw4TG/p2tJZQh9WDZuMYcMON2ILTXlW
         rmTY+YZN0VCJiKGscFRYsHrHE6jEg7DcznVrofAPSpxTbf3VAkcSVRKE+Ha7GkENOtmp
         g3UPY1mqqixImzDnT+r5vcPqGqSMTN15vKN7c19uIugIQj9gEYrICmZvlyoUmF1rQXI1
         V7an0BFNZh6UmTjGUY4D2OpIi13Hu29jxu5V08Cs1+IiZPa6l+GP+gwxZsVrOLRNWYHZ
         aHgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VQSmnrBQRiI16GECdp3OMat4LBaKuciGyFg9M/kRhI0=;
        b=lBAeBEmXNYFwpyZK55VCl4pGOw7+8pp8wVeKf86GkhnZ0CzRQ2xkWz6JeCULdFbjOy
         h5oAHoET944HcqIfW6RZ2XGjmUtMaqP8arJOFPNn2AUttGkOR4hy1pFe1O7jQoMCtt8a
         Boboq8LpG/SFxF9xdP0ldCIhNvO6D8lWKFL4cl1TUt73MWgSJSmgteHSc9k5L/Vd4deZ
         PeJenlYfXFMSbemmggvaybNUEg3CnBvxpDQaVtUY4set8h9O0qmYYPpL4sFsn+jTVHT8
         XugmUis95Ijum6Oo+oOSDXp/jS9kK1D2uZSJ/GJz9SdTWxmfgrT6xS9elhBYIrONFMyP
         DK1g==
X-Gm-Message-State: AOAM533CyNoU15B+CyJofxkAzZNsDK0PeFhvh+HezRBe7FCtjXqvrUwE
        JiMJ2NIIH0ZB2dxF55iiS1LBxMKxzHn5ne6nX/xObQ==
X-Google-Smtp-Source: ABdhPJzbweNJ6QacPF52EsYUUxHPjTj3yJ14xpN256fN9457zzgorL/EKsqp5E88oUZl3szfCJdm8hFjfoSg7Wpvc8A=
X-Received: by 2002:a05:600c:3ba3:: with SMTP id n35mr16775637wms.88.1637143521923;
 Wed, 17 Nov 2021 02:05:21 -0800 (PST)
MIME-Version: 1.0
References: <20211117135800.0b7072cd@canb.auug.org.au> <268ae204-efae-3081-a5dd-44fc07d048ba@infradead.org>
 <CAMuHMdUdA6cJkWWKypvn7nGQw+u=gW_oRNWB-=G8g2T3VixJFQ@mail.gmail.com>
 <CANn89iLXQWR_F6v39guPftY=jhs4XHsERifhZPOTjR3zDNkJyg@mail.gmail.com>
 <CAMuHMdXHo5boecN7Y81auC0y=_xWyNXO6tq8+U4AJq-z17F1nw@mail.gmail.com>
 <CANn89iKSZKvySL6+-gk7UGCowRoApJQmvUpYfiKChSSbxr=LYw@mail.gmail.com>
 <CANn89iLAu9QAgqS_qzZYSHLmmPdL_2uD0RSmtrq4mPgkWzV8hQ@mail.gmail.com> <CAMuHMdUy1ua+KB4XKh89huRg7a5CoNbZNZWbBRmQhzWsYF+FrA@mail.gmail.com>
In-Reply-To: <CAMuHMdUy1ua+KB4XKh89huRg7a5CoNbZNZWbBRmQhzWsYF+FrA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 17 Nov 2021 02:05:09 -0800
Message-ID: <CANn89iJ4+LPyKZbrnic=YWi=10pcO+2UipdCDP-Q6VOWa1b0Fw@mail.gmail.com>
Subject: Re: linux-next: Tree for Nov 17 (uml, no IPV6)
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 2:04 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Eric,
>
> On Wed, Nov 17, 2021 at 10:56 AM Eric Dumazet <edumazet@google.com> wrote:
> > On Wed, Nov 17, 2021 at 1:50 AM Eric Dumazet <edumazet@google.com> wrote:
> > > I don't know, apparently on UM, csum_ipv6_magic() is only found in
> > > arch/x86/um/asm/checksum_32.h,
> > > no idea why...
> > >
> >
> > Oh, maybe this is the missing part :
> >
> > diff --git a/include/net/gro.h b/include/net/gro.h
> > index d0e7df691a807410049508355230a4523af590a1..9c22a010369cb89f9511d78cc322be56170d7b20
> > 100644
> > --- a/include/net/gro.h
> > +++ b/include/net/gro.h
> > @@ -6,6 +6,7 @@
> >  #include <linux/indirect_call_wrapper.h>
> >  #include <linux/ip.h>
> >  #include <linux/ipv6.h>
> > +#include <net/ip6_checksum.h>
> >  #include <linux/skbuff.h>
> >  #include <net/udp.h>
>
> Thanks, that fixes the ARCH=m68k m5272c3_defconfig issue for me.
>
> Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

Great, can you carry your Tested-by: on the submission itself ?

Thanks !

https://patchwork.kernel.org/project/netdevbpf/patch/20211117100130.2368319-1-eric.dumazet@gmail.com/


>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
