Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F921D3EE4
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 22:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgENUTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 16:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726035AbgENUTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 16:19:03 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711F7C061A0C;
        Thu, 14 May 2020 13:19:03 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id f83so186467qke.13;
        Thu, 14 May 2020 13:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0qPGLtDgg64hEHavdFXIGVUhLSueYKhEr1Epd05KMXw=;
        b=CWVvjQbgpxXX6XPcJcesRdBPpmXoYR2mrITb8lq/h19UY634KiA/mF4Q81ur0c5CXT
         uQbjSe4pgtgQCh6xzVgYBs2iamTGH2zZ/ZczRhSUvN/g0N6NiLL2M5nNsgX17ZI6M3nK
         Oxlq1Erp6v90wPdRW/19Wm21o/9KAR1brAdpFZYuXomwcdn1L0BMhirjYvLZJ9FtEFhw
         rx+G4T9pwa7ObhSWHMf20eRd0L37PvJgC/RN0Gkjt1htmhIaf62S+CXkPD/g8wS1r9dQ
         mprsCJr/sWkJpfYrLYbsTHRHwMVboTLeoOCHP/AYRmHBiN3nXyw1ef1Pol9vZ2W4kn97
         xofQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0qPGLtDgg64hEHavdFXIGVUhLSueYKhEr1Epd05KMXw=;
        b=d4919z+A5iEYcpyP6SyCVjvm1plOl7QkcPchqMQl+0L6BEKyRuvi2vidVIrpU1oDoq
         68qgM2xlHikzveKVbyBiz5gnQAmZsaF5AfBF4CyoiS7aAwgdsQp2eFIO4MfJ4ylfN69n
         FQ7xTiukE7kncEC5C3uPXbQVlHe5DSH/EAfvCjmws3000JGoRDtkmYMjqXjxqOk7648u
         t7+gxJwM0UvoJTrnrKXAAUitp1KYDoGsenu+00/1nRd/iNxF4TEw2SfwK1tO0vfoDAq6
         khRveNxakXLn/MIPKmk0cNfec8Pu7yXpYrYv3Jfr+gdOmGBbA1fH3he5P8au81/jAyfu
         +Eug==
X-Gm-Message-State: AOAM533WPs9+PSG54LBwLSsVfhOUN/I6vOJD/dO6LHP+Hueo7vsecAFj
        AohVaDDeJiRrNDkiPku7OMpo2LjJWbyhhOTa1gE=
X-Google-Smtp-Source: ABdhPJzSQsZoSRkNSyg2mjd0uoITrTTBAiKwuATz/Z7xRuf6PYh7gcB+bBMkRMJorgRoNw937pvPBRbN9N2PtcGn+RE=
X-Received: by 2002:a05:620a:14a1:: with SMTP id x1mr146578qkj.92.1589487542553;
 Thu, 14 May 2020 13:19:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200513192532.4058934-1-andriin@fb.com> <20200513192532.4058934-2-andriin@fb.com>
 <20200514173338.GA161830@google.com>
In-Reply-To: <20200514173338.GA161830@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 14 May 2020 13:18:50 -0700
Message-ID: <CAEf4BzbhqQB61JTmmp5999bbEFeHEMdvnE9vpV3tHCHm12cf-Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/6] bpf: implement BPF ring buffer and verifier
 support for it
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 10:33 AM <sdf@google.com> wrote:
>
> On 05/13, Andrii Nakryiko wrote:
> > This commits adds a new MPSC ring buffer implementation into BPF
> > ecosystem,
> > which allows multiple CPUs to submit data to a single shared ring buffer.
> > On
> > the consumption side, only single consumer is assumed.
>

[...]

> > Comparison to alternatives
> > --------------------------
> > Before considering implementing BPF ring buffer from scratch existing
> > alternatives in kernel were evaluated, but didn't seem to meet the needs.
> > They
> > largely fell into few categores:
> >    - per-CPU buffers (perf, ftrace, etc), which don't satisfy two
> > motivations
> >      outlined above (ordering and memory consumption);
> >    - linked list-based implementations; while some were multi-producer
> > designs,
> >      consuming these from user-space would be very complicated and most
> >      probably not performant; memory-mapping contiguous piece of memory is
> >      simpler and more performant for user-space consumers;
> >    - io_uring is SPSC, but also requires fixed-sized elements. Naively
> > turning
> >      SPSC queue into MPSC w/ lock would have subpar performance compared to
> >      locked reserve + lockless commit, as with BPF ring buffer. Fixed sized
> >      elements would be too limiting for BPF programs, given existing BPF
> >      programs heavily rely on variable-sized perf buffer already;
> >    - specialized implementations (like a new printk ring buffer, [0]) with
> > lots
> >      of printk-specific limitations and implications, that didn't seem to
> > fit
> >      well for intended use with BPF programs.
> That's a very nice write up! Does it make sense to put most of it
> under Documentation/bpf? We were discussing socket storage with KP
> recently and I mentioned that commit 6ac99e8f23d4 has a really nice
> description of the architecture with ascii diagrams/etc. Sometimes
> it's really hard to chase down the commit history to find out
> these sorts of details.

Sure, can do that. And thanks :)

>
> >    [0] https://lwn.net/Articles/779550/
>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >   include/linux/bpf.h            |  12 +
> >   include/linux/bpf_types.h      |   1 +
> >   include/linux/bpf_verifier.h   |   4 +
> >   include/uapi/linux/bpf.h       |  33 ++-
> >   kernel/bpf/Makefile            |   2 +-
> >   kernel/bpf/helpers.c           |   8 +
> >   kernel/bpf/ringbuf.c           | 409 +++++++++++++++++++++++++++++++++
> >   kernel/bpf/syscall.c           |  12 +
> >   kernel/bpf/verifier.c          | 156 ++++++++++---
> >   kernel/trace/bpf_trace.c       |   8 +
> >   tools/include/uapi/linux/bpf.h |  33 ++-
> >   11 files changed, 643 insertions(+), 35 deletions(-)
> >   create mode 100644 kernel/bpf/ringbuf.c
>

[...]

> > + * void bpf_ringbuf_submit(void *data)
> > + *   Description
> > + *           Submit reserved ring buffer sample, pointed to by *data*.
> > + *   Return
> > + *           Nothing.
> Even though you mention self-pacing properties, would it still
> make sense to add some argument to bpf_ringbuf_submit/bpf_ringbuf_output
> to indicate whether to wake up userspace or not? Maybe something like
> a threshold of number of outstanding events in the ringbuf after which
> we do the wakeup? The default 0/1 preserve the existing behavior.
>
> The example I can give is a control plane userspace thread that
> once a second aggregates the events, it doesn't care about millisecond
> resolution. With the current scheme, I suppose, if BPF generates events
> every 1ms, the userspace will be woken up 1000 times (if it can keep
> up). Most of the time, we don't really care and some buffering
> properties are desired.

perf buffer has setting like this, and believe me, it's so confusing
and dangerous, that I wouldn't want this to be exposed. Even though I
was aware of this behavior, I still had to debug and work-around this
lack on wakeup few times, it's really-really confusing feature.

In your case, though, why wouldn't user-space poll data just once a
second, if it's not interested in getting data as fast as possible?

[...]

> > +struct bpf_ringbuf {
> > +     wait_queue_head_t waitq;
> > +     u64 mask;
> > +     spinlock_t spinlock ____cacheline_aligned_in_smp;
> > +     u64 consumer_pos __aligned(PAGE_SIZE);
> > +     u64 producer_pos __aligned(PAGE_SIZE);
> > +     char data[] __aligned(PAGE_SIZE);
> > +};
> > +
> > +struct bpf_ringbuf_map {
> > +     struct bpf_map map;
> > +     struct bpf_map_memory memory;
> > +     struct bpf_ringbuf *rb;
> > +};
> > +
> > +static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int
> > numa_node)
> > +{
> > +     const gfp_t flags = GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_NOWARN |
> > +                         __GFP_ZERO;
> > +     int nr_meta_pages = 2 + BPF_RINGBUF_PGOFF;
> There is a bunch of magic '2's scattered around. Would it make sense
> to use a proper define (with a comment) instead?

Yep, it's consumer + producer counter pages, I'll add a constant.

>
> > +     int nr_data_pages = data_sz >> PAGE_SHIFT;
> > +     int nr_pages = nr_meta_pages + nr_data_pages;
> > +     struct page **pages, *page;
> > +     size_t array_size;
> > +     void *addr;
> > +     int i;
> > +

[...]

Please trim. I do love my code of course, but scrolling through it so
many times gets old still ;)
