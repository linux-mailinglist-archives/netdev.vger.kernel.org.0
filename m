Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92FFF214D1
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 09:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbfEQHvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 03:51:12 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:36797 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727800AbfEQHvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 03:51:12 -0400
Received: by mail-ot1-f66.google.com with SMTP id c3so5929195otr.3;
        Fri, 17 May 2019 00:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=U9oH5zgqh3zpp40PKo4eEAEpI7FgiHZimUGddStME5M=;
        b=MPwh2JP86Vz+CsDB/z0A51HXXpQqde+3lt2paGtNQ2TVlVYmFbumUP/KpTb1q1Gn1y
         AApL87ZAnutDLndWe2/25fah0qkLE5Ya2igtHKPl2cNj1y18IF3EWYaLuNXGGOL7LSv/
         yGP60oBHuExVKw+IZvb+6g6P039UMSXm3PqslaH7PtQdUCZ4ffmGOPXrDFplbERMVlb8
         STFv+rH2SMvmolRzls73fphwpfiytyo5HxvwXRD/wIypBJ6TY4L+63yk1OMZStyUjDqW
         O6UmU6m+tzF89wvthPJK7uIF6kiY97/NzlH0YNgnVv50JzElhQT3BiWP/qe6iePr6JRs
         vmvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=U9oH5zgqh3zpp40PKo4eEAEpI7FgiHZimUGddStME5M=;
        b=lw4Nw6Y8BTxouiko3rkTnVVfxaNyjlLu84GDTEk3PhoukxWdv2UeUQ/DGLPqf5s81r
         VxYwfpkjZ+gi/1ETNGo32n5y64t/OXm9V0QbF0FTO/QIL+lJ52MHUCSaEkYE56PqxO5/
         CYyNHttkXVWYc4pID0aP+McTRL41C0OFXZpsw8U3lUeN/ko/akRbtkF9OyhS2KwgrRyu
         7RBDhQgd1HYThWv47TS84gRbyKAR1m+q1UGNje82/ZNnhpmvuVHzdtmHBxPVly0YoaRU
         P/5EFlBBf5n10gTqUwyVnru0STCVaY9cntgQDXD8TMsZ3gvBDID1S44nhX/kG+3ZTJ8N
         GjGA==
X-Gm-Message-State: APjAAAVXdO0wU47zxJGqBcMXm9qhL5uX5RogiJdBm5Rcyh1ZLPVxhn+b
        Ifzl1G6W9yFfeqOJECi6uXjHDAzzrPRFQ5/mV0o=
X-Google-Smtp-Source: APXvYqwARXsHpa4DXXxSbDjzRx6Itj5+X24TyVPJBV8ARCraJWUC1c3KXIRHDcrarHVIAiDnrKpyJciTdZ9vHIHahio=
X-Received: by 2002:a9d:30d3:: with SMTP id r19mr22022165otg.39.1558079471048;
 Fri, 17 May 2019 00:51:11 -0700 (PDT)
MIME-Version: 1.0
References: <1556786363-28743-1-git-send-email-magnus.karlsson@intel.com>
 <20190506163135.blyqrxitmk5yrw7c@ast-mbp> <CAJ8uoz2MFtoXwuhAp5A0teMmwU2v623pHf2k0WSFi0kovJYjtw@mail.gmail.com>
 <20190507182435.6f2toprk7jus6jid@ast-mbp> <CAJ8uoz24HWGfGBNhz4c-kZjYELJQ+G3FcELVEo205xd1CirpqQ@mail.gmail.com>
 <CAJ8uoz1i72MOk711wLX18zmgo9JS+ztzSYAx0YS0VKxkbvod-w@mail.gmail.com> <6ce758d1-e646-c7c2-bc02-6911c9b7d6ce@intel.com>
In-Reply-To: <6ce758d1-e646-c7c2-bc02-6911c9b7d6ce@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 17 May 2019 09:50:59 +0200
Message-ID: <CAJ8uoz1qTNe66XJMLSr4y91zKwysXEJY0odZzJCLwFN2b-B+gw@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/7] busy poll support for AF_XDP sockets
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf@vger.kernel.org, Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jonathan Lemon <bsd@fb.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 17, 2019 at 1:50 AM Samudrala, Sridhar
<sridhar.samudrala@intel.com> wrote:
>
> On 5/16/2019 5:37 AM, Magnus Karlsson wrote:
> >
> > After a number of surprises and issues in the driver here are now the
> > first set of results. 64 byte packets at 40Gbit/s line rate. All
> > results in Mpps. Note that I just used my local system and kernel build
> > for these numbers so they are not performance tuned. Jesper would
> > likely get better results on his setup :-). Explanation follows after
> > the table.
> >
> >                                        Applications
> > method  cores  irqs        txpush        rxdrop      l2fwd
> > ---------------------------------------------------------------
> > r-t-c     2     y           35.9          11.2        8.6
> > poll      2     y           34.2           9.4        8.3
> > r-t-c     1     y           18.1           N/A        6.2
> > poll      1     y           14.6           8.4        5.9
> > busypoll  2     y           31.9          10.5        7.9
> > busypoll  1     y           21.5           8.7        6.2
> > busypoll  1     n           22.0          10.3        7.3
> >
> > r-t-c =3D Run-to-completion, the mode where we in Rx uses no syscalls
> >          and only spin on the pointers in the ring.
> > poll =3D Use the regular syscall poll()
> > busypoll =3D Use the regular syscall poll() in busy-poll mode. The RFC =
I
> >             sent out.
> >
> > cores =3D=3D 2 means that softirq/ksoftirqd is one a different core fro=
m
> >             the application. 2 cores are consumed in total.
> > cores =3D=3D 1 means that both softirq/ksoftirqd and the application ru=
ns
> >             on the same core. Only 1 core is used in total.
> >
> > irqs =3D=3D 'y' is the normal case. irqs =3D=3D 'n' means that I have c=
reated a
> >          new napi context with the AF_XDP queues inside that does not
> >          have any interrupts associated with it. No other traffic goes
> >          to this napi context.
> >
> > N/A =3D This combination does not make sense since the application will
> >        not yield due to run-to-completion without any syscalls
> >        whatsoever. It works, but it crawls in the 30 Kpps
> >        range. Creating huge rings would help, but did not do that.
> >
> > The applications are the ones from the xdpsock sample application in
> > samples/bpf/.
> >
> > Some things I had to do to get these results:
> >
> > * The current buffer allocation scheme in i40e where we continuously
> >    try to access the fill queue until we find some entries, is not
> >    effective if we are on a single core. Instead, we try once and call
> >    a function that sets a flag. This flag is then checked in the xsk
> >    poll code, and if it is set we schedule napi so that it can try to
> >    allocate some buffers from the fill ring again. Note that this flag
> >    has to propagate all the way to user space so that the application
> >    knows that it has to call poll(). I currently set a flag in the Rx
> >    ring to indicate that the application should call poll() to resume
> >    the driver. This is similar to what the io_uring in the storage
> >    subsystem does. It is not enough to return POLLERR from poll() as
> >    that will only work for the case when we are using poll(). But I do
> >    that as well.
> >
> > * Implemented Sridhar's suggestion on adding busy_loop_end callbacks
> >    that terminate the busy poll loop if the Rx queue is empty or the Tx
> >    queue is full.
> >
> > * There is a race in the setup code in i40e when it is used with
> >    busy-poll. The fact that busy-poll calls the napi_busy_loop code
> >    before interrupts have been registered and enabled seems to trigger
> >    some bug where nothing gets transmitted. This only happens for
> >    busy-poll. Poll and run-to-completion only enters the napi loop of
> >    i40e by interrupts and only then after interrupts have been enabled,
> >    which is the last thing that is done after setup. I have just worked
> >    around it by introducing a sleep(1) in the application for these
> >    experiments. Ugly, but should not impact the numbers, I believe.
> >
> > * The 1 core case is sensitive to the amount of work done reported
> >    from the driver. This was not correct in the XDP code of i40e and
> >    let to bad performance. Now it reports the correct values for
> >    Rx. Note that i40e does not honor the napi budget on Tx and sets
> >    that to 256, and these are not reported back to the napi
> >    library.
> >
> > Some observations:
> >
> > * Cannot really explain the drop in performance for txpush when going
> >    from 2 cores to 1. As stated before, the reporting of Tx work is not
> >    really propagated to the napi infrastructure. Tried reporting this
> >    in a correct manner (completely ignoring Rx for this experiment) but
> >    the results were the same. Will dig deeper into this to screen out
> >    any stupid mistakes.
> >
> > * With the fixes above, all my driver processing is in softirq for 1
> >    core. It never goes over to ksoftirqd. Previously when work was
> >    reported incorrectly, this was the case. I would have liked
> >    ksoftirqd to take over as that would have been more like a separate
> >    thread. How to accomplish this? There might still be some reporting
> >    problem in the driver that hinders this, but actually think it is
> >    more correct now.
> >
> > * Looking at the current results for a single core, busy poll provides
> >    a 40% boost for Tx but only 5% for Rx. But if I instead create a
> >    napi context without any interrupt associated with it and drive that
> >    from busy-poll, I get a 15% - 20% performance improvement for Rx. Tx
> >    increases only marginally from the 40% improvement as there are few
> >    interrupts on Tx due to the completion interrupt bit being set quite
> >    infrequently. One question I have is: what am I breaking by creating
> >    a napi context not used by anyone else, only AF_XDP, that does not
> >    have an interrupt associated with it?
> >
> > Todo:
> >
> > * Explain the drop in Tx push when going from 2 cores to 1.
> >
> > * Really run a separate thread for kernel processing instead of softirq=
.
> >
> > * What other experiments would you like to see?
>
> Thanks for sharing the results.
> For busypoll tests, i guess you may have increased the busypoll budget
> to 64.

Yes, I am using a batch size of 64 for all experiments as the
NAPI_POLL_WEIGHT is also 64. Note that the i40e driver batches 256
packets on Tx as it does not care what the budget parameter is in the
NAPI function. Rx is according to budget though.

> What is the busypoll timeout you are using?

0, as I am slamming the system as hard as I can with packets. The CPU
is always at close to 100% due to this and there is always something
to do. With a busy-poll timeout value of 100, I see a performance
degradation between 2% (slowest rx) - 7% (fastest tx). But any other
value than 0 for the busy-poll timeout does not make much sense when I
am running the driver and the application on the same core. I am
better off trying to get into softirq/ksoftirqd quicker to get some
new packets and/or send my Tx ones.

Regular poll() has a timeout value in the poll() syscall of 1000, as
it needs to yield to the driver processing. With 0 there are, to my
surprise, some performance improvements of a couple of percent.
Looking at the code, the code path for a 0 timeout is shorter which
might explain this.

> Can you try a test that skips calling bpf program for queues that are
> associated with af-xdp socket? I remember seeing a significant bump in
> rxdrop performance with this change.

Bj=C3=B6rn is working on this. This should improve performance much more
than busy-poll in my mind.

> The other overhead i saw was with the dma_sync_single calls in the driver=
.

I will do a "perf top" and check out the bottlenecks in more detail.

Thanks: Magnus

> Thanks
> Sridhar
