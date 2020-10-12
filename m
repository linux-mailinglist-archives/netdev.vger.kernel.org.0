Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5FDF28B387
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 13:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387846AbgJLLNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 07:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387617AbgJLLNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 07:13:17 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974E3C0613CE;
        Mon, 12 Oct 2020 04:13:17 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id h2so8372742pll.11;
        Mon, 12 Oct 2020 04:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rok51bY+NMXfkjLmUBndlaSQ/c2xOHkH9dRY9zUWboE=;
        b=IjY66wsvGA+ET6maXXrbN1BNnZUz2ACAJoitP0jQqsn4/S6o+n8UiFgkCS0ok5XbAv
         m4B8SIrOWY96kT8qBzu8KA21lVC16HY1+NPEWhD1OA2JEs84hle57VMGeonYKa5kNfYV
         L8X5WhfWCjEjB4YA6mlM4lr/K0JM2TR5mfbMqcn/2QD9/FXUbsUZDB8PIwLagyIRSB2B
         QJ7acbV+T40pVpgDANBL6kDCAelyaVYO3RVW8SEqPXDBR7r01md7Z/oqlw2sOGlaX9sm
         ZSwAJsn6R/j8oXEd2fByK8Dj27SnxBOM9OQujfYXf6+EGgHTOWUjU5hPDQsuhE3zvE88
         8Zbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rok51bY+NMXfkjLmUBndlaSQ/c2xOHkH9dRY9zUWboE=;
        b=YCK5rzxwiq3YKMEiMg3s1zOHpDTMr3JpG7d5Cj6on99SyiVhLyXoAbrvlH7fDdq9rj
         1qDiDlOCFyYWJdSAqFwszPrkhv1kKhA96ru+JYUjgIuyLTgw83x7E2q7/3b2VP6a5L36
         7rOO197dDbVbFWy+T/qE00alwFLs8i2QA7M4wWUwghKIjyCgRbu7y32+34wvkuiJ8lfO
         KOIFDk0M2bEGk/ip+GpJ5H/VBi5JxBXcYRLYhWug+KEQjFVp/rijAJRnx67LMddYk/yl
         AWq1zuLKYM+aSGzm/AxY3Gb3UP0qP1cH+EvqnQfNkngDQqwoevggSBAl7gXG7IxgJvWP
         Ki+g==
X-Gm-Message-State: AOAM533wkEQbUhcaw4VAGm1dGGH3KLwPj9mDjFoQ+P30lSkYDqAGk+rt
        ssOf8S4GAT4vDW+m5jiH7ji+ylfzVn3uDzXhLlo=
X-Google-Smtp-Source: ABdhPJxlZdqKKf+fBXCOVJ7a5bT9ADdOXWCpRcWaKwnHDPaGo5VGtuQabCss1HawU9wK4tjmGul7f4VkFkOlRXNWkH0=
X-Received: by 2002:a17:902:d211:b029:d3:c8b3:4aa4 with SMTP id
 t17-20020a170902d211b02900d3c8b34aa4mr23828142ply.43.1602501196998; Mon, 12
 Oct 2020 04:13:16 -0700 (PDT)
MIME-Version: 1.0
References: <1602166338-21378-1-git-send-email-magnus.karlsson@gmail.com>
 <43b0605d-f0c9-b81c-4d16-344a7832e083@iogearbox.net> <CAJ8uoz3nfDe0a9Vp0NmnHVv5qM+kvqR-f6Yd0keKSqctNzi6=g@mail.gmail.com>
 <CAJ8uoz1Z4dpaoK5th092gid+xbcp1Rz1wkPXZuuceh5y0wvKYw@mail.gmail.com>
In-Reply-To: <CAJ8uoz1Z4dpaoK5th092gid+xbcp1Rz1wkPXZuuceh5y0wvKYw@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 12 Oct 2020 13:13:06 +0200
Message-ID: <CAJ8uoz0V+nLc7KVe9NjZJ6FpKxJUcubm7K699g1C70+tLuWJpQ@mail.gmail.com>
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

On Mon, Oct 12, 2020 at 11:37 AM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> On Mon, Oct 12, 2020 at 10:37 AM Magnus Karlsson
> <magnus.karlsson@gmail.com> wrote:
> >
> > On Fri, Oct 9, 2020 at 5:03 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > >
> > > On 10/8/20 4:12 PM, Magnus Karlsson wrote:
> > > > From: Magnus Karlsson <magnus.karlsson@intel.com>
> > > >
> > > > Introduce one cache line worth of padding between the producer and
> > > > consumer pointers in all the lockless rings. This so that the HW
> > > > adjacency prefetcher will not prefetch the consumer pointer when the
> > > > producer pointer is used and vice versa. This improves throughput
> > > > performance for the l2fwd sample app with 2% on my machine with HW
> > > > prefetching turned on.
> > > >
> > > > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > >
> > > Applied, thanks!
> > >
> > > >   net/xdp/xsk_queue.h | 4 ++++
> > > >   1 file changed, 4 insertions(+)
> > > >
> > > > diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> > > > index dc1dd5e..3c235d2 100644
> > > > --- a/net/xdp/xsk_queue.h
> > > > +++ b/net/xdp/xsk_queue.h
> > > > @@ -15,6 +15,10 @@
> > > >
> > > >   struct xdp_ring {
> > > >       u32 producer ____cacheline_aligned_in_smp;
> > > > +     /* Hinder the adjacent cache prefetcher to prefetch the consumer pointer if the producer
> > > > +      * pointer is touched and vice versa.
> > > > +      */
> > > > +     u32 pad ____cacheline_aligned_in_smp;
> > > >       u32 consumer ____cacheline_aligned_in_smp;
> > > >       u32 flags;
> > > >   };
> > > >
> > >
> > > I was wondering whether we should even generalize this further for reuse
> > > elsewhere e.g. ...
> > >
> > > diff --git a/include/linux/cache.h b/include/linux/cache.h
> > > index 1aa8009f6d06..5521dab01649 100644
> > > --- a/include/linux/cache.h
> > > +++ b/include/linux/cache.h
> > > @@ -85,4 +85,17 @@
> > >   #define cache_line_size()      L1_CACHE_BYTES
> > >   #endif
> > >
> > > +/*
> > > + * Dummy element for use in structs in order to pad a cacheline
> > > + * aligned element with an extra cacheline to hinder the adjacent
> > > + * cache prefetcher to prefetch the subsequent struct element.
> > > + */
> > > +#ifndef ____cacheline_padding_in_smp
> > > +# ifdef CONFIG_SMP
> > > +#  define ____cacheline_padding_in_smp u8 :8 ____cacheline_aligned_in_smp
> > > +# else
> > > +#  define ____cacheline_padding_in_smp
> > > +# endif /* CONFIG_SMP */
> > > +#endif
> > > +
> > >   #endif /* __LINUX_CACHE_H */
> > > diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> > > index cdb9cf3cd136..1da36423e779 100644
> > > --- a/net/xdp/xsk_queue.h
> > > +++ b/net/xdp/xsk_queue.h
> > > @@ -15,11 +15,9 @@
> > >
> > >   struct xdp_ring {
> > >          u32 producer ____cacheline_aligned_in_smp;
> > > -       /* Hinder the adjacent cache prefetcher to prefetch the consumer
> > > -        * pointer if the producer pointer is touched and vice versa.
> > > -        */
> > > -       u32 pad ____cacheline_aligned_in_smp;
> > > +       ____cacheline_padding_in_smp;
> > >          u32 consumer ____cacheline_aligned_in_smp;
> > > +       ____cacheline_padding_in_smp;
> > >          u32 flags;
> > >   };
> >
> > This should be beneficial in theory, though I could not measure any
> > statistically significant improvement. Though, the flags variable is
> > touched much less frequently than the producer and consumer pointers,
> > so that might explain it. We also need to make the compiler allocate
> > flags to a cache line 128 bytes (2 cache lines) from the consumer
> > pointer like this:
> >
> > u32 consumer ____cacheline_aligned_in_smp;
> > ____cacheline_padding_in_smp;
> > u32 flags ____cacheline_aligned_in_smp;
> >
> > > ... was there any improvement to also pad after the consumer given the struct
> > > xdp_ring is also embedded into other structs?
> >
> > Good idea. Yes, I do believe I see another ~0.4% increase and more
> > stable high numbers when trying this out. The xdp_ring is followed by
> > the ring descriptors themselves in both the rt/tx rings and the umem
> > rings. And these rings are quite large, 2K in the sample app, so
> > accessed less frequently (1/8th of the time with a batch size of 256
> > and ring size 2K) which might explain the lower increase. In the end,
> > I ended up with the following struct:
> >
> > u32 producer ____cacheline_aligned_in_smp;
> > ____cacheline_padding_in_smp;
> > u32 consumer ____cacheline_aligned_in_smp;
> > ____cacheline_padding_in_smp;
> > u32 flags ____cacheline_aligned_in_smp;
> > ____cacheline_padding_in_smp;
>
> Actually, this might make more sense and save some memory:
>
> u32 producer ____cacheline_aligned_in_smp;
> ____cacheline_padding_in_smp;
> u32 consumer ____cacheline_aligned_in_smp;
> u32 flags;
> ____cacheline_padding_in_smp;
>
> So keep the flags colocated with the consumer on the same cache line.
> The reason I put it there to start with was that it is usually set in
> conjunction with the consumer pointer being updated. This might also
> explain why I did not see any performance improvement by putting it on
> its own 128-byte cache line. In summary, we make sure producer and
> consumer are separated with 128 bytes as well as consumer and the
> start of the descriptor ring.

Nope, that was a bad idea. After measuring, this one produces worse
performance than the original suggestion with padding in between all
members. Cannot explain why at the moment, but the numbers are
convincing and above noise level for sure. So let us keep this one:

u32 producer ____cacheline_aligned_in_smp;
____cacheline_padding_in_smp;
u32 consumer ____cacheline_aligned_in_smp;
____cacheline_padding_in_smp;
u32 flags ____cacheline_aligned_in_smp;
____cacheline_padding_in_smp;

> > Do you want to submit a patch, or shall I do it? I like your
> > ____cacheline_padding_in_smp better than my explicit "padN" member.
> >
> > Thanks: Magnus
> >
> > > Thanks,
> > > Daniel
