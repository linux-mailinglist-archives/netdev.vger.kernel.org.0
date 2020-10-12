Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF6728B1B1
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 11:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387466AbgJLJhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 05:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387449AbgJLJhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 05:37:40 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E416EC0613CE;
        Mon, 12 Oct 2020 02:37:39 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id a200so12971757pfa.10;
        Mon, 12 Oct 2020 02:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sBJswRHufzrvTn9Rx651SvBk6xaZinvE+Qr5f9sU5ZA=;
        b=DJVQ61cXVjQsr5/+g80bkEWeJRZIF/aj7xNSEbz34npaT7pnHu6ha5DAy+aol0d2+S
         tJe/EJyDdliI+civwzvJmlxECZcq+PVwhgPuALfcSi6MfMPp+cl/XkMACjNNb1z1f423
         tnwGfgDSztDO3QR6/okJ8ckdFkY67M9cCQGeBAcmr0C2cu+HOL8mjaDYoJ2E/hIvU5n+
         2q+J2M0gn1T/PFMAJ9bX6wo4MJencyMda4DiqwfgKzt7p2cHRc4WGi7hMYtZ7zAK/BU/
         v1mDOJZHIEgGUeIpcS36SPbb0QB7xu6FVwSzQuNmpfTQT03Cv68n9LGSilxZ3KrD1xZK
         vIPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sBJswRHufzrvTn9Rx651SvBk6xaZinvE+Qr5f9sU5ZA=;
        b=AsWZKyUy1YpqjFaCLAc40vDT8uyocTHDDZVraDzqtBV6zEedkgsWEPLgmS8MCIAQT4
         kcgqrcOdkFvmOw4JXqN085jPYKPIqJ6uF4Qc1zYLDFLp5nIkYiAoAsZL6aQdEkX7eBfi
         rLVtlsDswXew+wU2ziqlvGMrCruEt2d6lXplD2hO87yKbqmBjpL29J0AVMv4snVkTowl
         Ms9CNOMEReGXgmVE5S3jwFWGVZljYeELyE525gl+LMaQmERFQjg3hAYfH3LVv3HZxBy1
         HFyXdkp7hGvpw7vHG34BV1g6tqfZxQ6uwbMsqB1Rg/yKUqN0ssK3ReQWz3L29JczFlzb
         8s5A==
X-Gm-Message-State: AOAM533E+IRpjDoVdfgCGB+/zw3bWE4ZFzSXfksXh7xXXjDBjSvVvEiM
        y6LI42t3HSibddbsVwGr4GppZu9wVpkmFXt3NKU=
X-Google-Smtp-Source: ABdhPJwcpuoXXJUhWYpaiCU8TvkHcyQ0W1eEHQ6V0vNnTrxcNu2Lw1VgW3TBGm4i2mcaEoT+U64PfDKt+/XBOmqKslw=
X-Received: by 2002:a17:90a:ab81:: with SMTP id n1mr20123392pjq.117.1602495459341;
 Mon, 12 Oct 2020 02:37:39 -0700 (PDT)
MIME-Version: 1.0
References: <1602166338-21378-1-git-send-email-magnus.karlsson@gmail.com>
 <43b0605d-f0c9-b81c-4d16-344a7832e083@iogearbox.net> <CAJ8uoz3nfDe0a9Vp0NmnHVv5qM+kvqR-f6Yd0keKSqctNzi6=g@mail.gmail.com>
In-Reply-To: <CAJ8uoz3nfDe0a9Vp0NmnHVv5qM+kvqR-f6Yd0keKSqctNzi6=g@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 12 Oct 2020 11:37:28 +0200
Message-ID: <CAJ8uoz1Z4dpaoK5th092gid+xbcp1Rz1wkPXZuuceh5y0wvKYw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] xsk: introduce padding between ring pointers
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 12, 2020 at 10:37 AM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> On Fri, Oct 9, 2020 at 5:03 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > On 10/8/20 4:12 PM, Magnus Karlsson wrote:
> > > From: Magnus Karlsson <magnus.karlsson@intel.com>
> > >
> > > Introduce one cache line worth of padding between the producer and
> > > consumer pointers in all the lockless rings. This so that the HW
> > > adjacency prefetcher will not prefetch the consumer pointer when the
> > > producer pointer is used and vice versa. This improves throughput
> > > performance for the l2fwd sample app with 2% on my machine with HW
> > > prefetching turned on.
> > >
> > > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Applied, thanks!
> >
> > >   net/xdp/xsk_queue.h | 4 ++++
> > >   1 file changed, 4 insertions(+)
> > >
> > > diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> > > index dc1dd5e..3c235d2 100644
> > > --- a/net/xdp/xsk_queue.h
> > > +++ b/net/xdp/xsk_queue.h
> > > @@ -15,6 +15,10 @@
> > >
> > >   struct xdp_ring {
> > >       u32 producer ____cacheline_aligned_in_smp;
> > > +     /* Hinder the adjacent cache prefetcher to prefetch the consumer pointer if the producer
> > > +      * pointer is touched and vice versa.
> > > +      */
> > > +     u32 pad ____cacheline_aligned_in_smp;
> > >       u32 consumer ____cacheline_aligned_in_smp;
> > >       u32 flags;
> > >   };
> > >
> >
> > I was wondering whether we should even generalize this further for reuse
> > elsewhere e.g. ...
> >
> > diff --git a/include/linux/cache.h b/include/linux/cache.h
> > index 1aa8009f6d06..5521dab01649 100644
> > --- a/include/linux/cache.h
> > +++ b/include/linux/cache.h
> > @@ -85,4 +85,17 @@
> >   #define cache_line_size()      L1_CACHE_BYTES
> >   #endif
> >
> > +/*
> > + * Dummy element for use in structs in order to pad a cacheline
> > + * aligned element with an extra cacheline to hinder the adjacent
> > + * cache prefetcher to prefetch the subsequent struct element.
> > + */
> > +#ifndef ____cacheline_padding_in_smp
> > +# ifdef CONFIG_SMP
> > +#  define ____cacheline_padding_in_smp u8 :8 ____cacheline_aligned_in_smp
> > +# else
> > +#  define ____cacheline_padding_in_smp
> > +# endif /* CONFIG_SMP */
> > +#endif
> > +
> >   #endif /* __LINUX_CACHE_H */
> > diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> > index cdb9cf3cd136..1da36423e779 100644
> > --- a/net/xdp/xsk_queue.h
> > +++ b/net/xdp/xsk_queue.h
> > @@ -15,11 +15,9 @@
> >
> >   struct xdp_ring {
> >          u32 producer ____cacheline_aligned_in_smp;
> > -       /* Hinder the adjacent cache prefetcher to prefetch the consumer
> > -        * pointer if the producer pointer is touched and vice versa.
> > -        */
> > -       u32 pad ____cacheline_aligned_in_smp;
> > +       ____cacheline_padding_in_smp;
> >          u32 consumer ____cacheline_aligned_in_smp;
> > +       ____cacheline_padding_in_smp;
> >          u32 flags;
> >   };
>
> This should be beneficial in theory, though I could not measure any
> statistically significant improvement. Though, the flags variable is
> touched much less frequently than the producer and consumer pointers,
> so that might explain it. We also need to make the compiler allocate
> flags to a cache line 128 bytes (2 cache lines) from the consumer
> pointer like this:
>
> u32 consumer ____cacheline_aligned_in_smp;
> ____cacheline_padding_in_smp;
> u32 flags ____cacheline_aligned_in_smp;
>
> > ... was there any improvement to also pad after the consumer given the struct
> > xdp_ring is also embedded into other structs?
>
> Good idea. Yes, I do believe I see another ~0.4% increase and more
> stable high numbers when trying this out. The xdp_ring is followed by
> the ring descriptors themselves in both the rt/tx rings and the umem
> rings. And these rings are quite large, 2K in the sample app, so
> accessed less frequently (1/8th of the time with a batch size of 256
> and ring size 2K) which might explain the lower increase. In the end,
> I ended up with the following struct:
>
> u32 producer ____cacheline_aligned_in_smp;
> ____cacheline_padding_in_smp;
> u32 consumer ____cacheline_aligned_in_smp;
> ____cacheline_padding_in_smp;
> u32 flags ____cacheline_aligned_in_smp;
> ____cacheline_padding_in_smp;

Actually, this might make more sense and save some memory:

u32 producer ____cacheline_aligned_in_smp;
____cacheline_padding_in_smp;
u32 consumer ____cacheline_aligned_in_smp;
u32 flags;
____cacheline_padding_in_smp;

So keep the flags colocated with the consumer on the same cache line.
The reason I put it there to start with was that it is usually set in
conjunction with the consumer pointer being updated. This might also
explain why I did not see any performance improvement by putting it on
its own 128-byte cache line. In summary, we make sure producer and
consumer are separated with 128 bytes as well as consumer and the
start of the descriptor ring.

> Do you want to submit a patch, or shall I do it? I like your
> ____cacheline_padding_in_smp better than my explicit "padN" member.
>
> Thanks: Magnus
>
> > Thanks,
> > Daniel
