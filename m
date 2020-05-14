Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497601D3E73
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 22:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729185AbgENUGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 16:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726076AbgENUGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 16:06:52 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699EEC061A0C;
        Thu, 14 May 2020 13:06:52 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id t25so10350qtc.0;
        Thu, 14 May 2020 13:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VYKbY03i3w8+WuCiIuniVrgUwRQNDEWvtrpaupQLl9I=;
        b=gvLyANHqhlhMeKCcovZINL4chr/11CBYhVetU9Cs4XDxsYrNbvHU3pStsbOcjkZYjL
         j3KzaDVtRBtHN5GmjWRxSBzznacXrWp0ZywV/R7XHREMrSOyESoRprcp7WJgwn9XJbVF
         32SeBYPRWL7VbOTIXqG0OzEJIIzt+aHlLbSP7pAIkc8MielU6pZECpdoIZYAiaXYbeqD
         G7n8cIzsIo6bDatxoc/12ctDiHWO9vHfp+K5dIhXQPeXD+CJ9CghI6sSRRO8T/dLPpTO
         Bx4X9YHc7dvFms7hci4/f40Qp3FyZPKGUYrGvaV7SAF6jvCS7pGN5PViYJJun8WJDDOE
         LDFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VYKbY03i3w8+WuCiIuniVrgUwRQNDEWvtrpaupQLl9I=;
        b=IKxIuMQxyzGnJTmbM28jIdY+J5x49LE+80fkEEg1lmLGpXSMgGEXFWEFj9Q7akjkFo
         RJ4l2FowVf6vs43m6vs2dJv920enSu93U8Wfs46oqnejZmQm/8l+J/NtWK8JZjQZ12fg
         8xyHabNFLIuzab3WOoOcwRxzDoih2nSYdN80Cc8SedE0sDVSeD/VqnxWM2rhGqYrsj9X
         PRDqj9Qb9HVVkiFyn8kjqtxu1cVgEhLdGZHqymCUu99NKkT77VNic1G8S3xqAUl20vAp
         FqU222Tf37ESMEAxNMR78+klYhw/p6McyzEtkd8O3xYsBg2lJGIFu9oRC+fW3R0Z/Le5
         Lo9Q==
X-Gm-Message-State: AOAM533a1eWd0yUSJyanuy/+Ug1h8+ltWxFno767zXX2jF7LWsiTUnTu
        S8tuPI7G0fa2mHvoKxJ28B5z0SL4E+HrIP6saj0=
X-Google-Smtp-Source: ABdhPJxYI047RMQeLIBFv4tBhpfzU/r+915kwe7BBJT1zGDPWfpCdgU33Bk/vk303+NdRS3JKUAM9fbnUZ9HXk8jweY=
X-Received: by 2002:ac8:424b:: with SMTP id r11mr6432317qtm.171.1589486811566;
 Thu, 14 May 2020 13:06:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200513192532.4058934-1-andriin@fb.com> <20200513224927.643hszw3q3cgx7e6@bsd-mbp.dhcp.thefacebook.com>
 <CAEf4BzaSEPNyBvXBduH2Bkr64=MbzFiR9hJ9DYwXwk4D2AtcDw@mail.gmail.com> <20200514163037.oijxmoemkg47ujft@bsd-mbp>
In-Reply-To: <20200514163037.oijxmoemkg47ujft@bsd-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 14 May 2020 13:06:39 -0700
Message-ID: <CAEf4BzYmA14Ddq+1wwNtoNO9eG5ULxdL65D7Y1FSaO5U9ZuVtQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/6] BPF ring buffer
To:     Jonathan Lemon <bsd@fb.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 9:30 AM Jonathan Lemon <bsd@fb.com> wrote:
>
> On Wed, May 13, 2020 at 11:08:46PM -0700, Andrii Nakryiko wrote:
> > On Wed, May 13, 2020 at 3:49 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> > >
> > > On Wed, May 13, 2020 at 12:25:26PM -0700, Andrii Nakryiko wrote:
> > > > Implement a new BPF ring buffer, as presented at BPF virtual conference ([0]).
> > > > It presents an alternative to perf buffer, following its semantics closely,
> > > > but allowing sharing same instance of ring buffer across multiple CPUs
> > > > efficiently.
> > > >
> > > > Most patches have extensive commentary explaining various aspects, so I'll
> > > > keep cover letter short. Overall structure of the patch set:
> > > > - patch #1 adds BPF ring buffer implementation to kernel and necessary
> > > >   verifier support;
> > > > - patch #2 adds litmus tests validating all the memory orderings and locking
> > > >   is correct;
> > > > - patch #3 is an optional patch that generalizes verifier's reference tracking
> > > >   machinery to capture type of reference;
> > > > - patch #4 adds libbpf consumer implementation for BPF ringbuf;
> > > > - path #5 adds selftest, both for single BPF ring buf use case, as well as
> > > >   using it with array/hash of maps;
> > > > - patch #6 adds extensive benchmarks and provide some analysis in commit
> > > >   message, it build upon selftests/bpf's bench runner.
> > > >
> > > >   [0] https://docs.google.com/presentation/d/18ITdg77Bj6YDOH2LghxrnFxiPWe0fAqcmJY95t_qr0w
> > > >
> > > > Cc: Paul E. McKenney <paulmck@kernel.org>
> > > > Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
> > >
> > > Looks very nice!  A few random questions:
> > >
> > > 1) Why not use a structure for the header, instead of 2 32bit ints?
> >
> > hm... no reason, just never occurred to me it's necessary :)
>
> It might be clearer to do this.  Something like:
>
> struct ringbuf_record {
>     union {
>         struct {
>             u32 size:30;
>             bool busy:1;
>             bool discard:1;
>         };
>         u32 word1;
>     };
>     union {
>         u32 pgoff;
>         u32 word2;
>     };
> };
>
> While perhaps a bit overkill, makes it clear what is going on.

I really want to avoid specifying bitfields, because that gets into
endianness territory, and I don't want to do different order of
bitfields depending on endianness of the platform. I can do


struct ringbuf_record_header {
    u32 len;
    u32 pgoff;
};

But that will be useful for kernel only and shouldn't be part of UAPI,
because pgoff makes sense only inside the kernel. For user-space,
first 4 bytes is length + busy&discard bits, second 4 bytes are
reserved and shouldn't be used (at least yet).

I guess I should put RINGBUF_META_SZ, RINGBUF_BUSY_BIT,
RINGBUF_DISCARD_BIT from patch #1 into include/uapi/linux/bpf.h to
make it a stable API, I suppose?

>
>
> > > 2) Would it make sense to reserve X bytes, but only commit Y?
> > >    the offset field could be used to write the record length.
> > >
> > >    E.g.:
> > >       reserve 512 bytes    [BUSYBIT | 512][PG OFFSET]
> > >       commit  400 bytes    [ 512 ] [ 400 ]
> >
> > It could be done, though I had tentative plans to use those second 4
> > bytes for something useful eventually.
> >
> > But what's the use case? From ring buffer's perspective, X bytes were
> > reserved and are gone already and subsequent writers might have
> > already advanced producer counter with the assumption that all X bytes
> > are going to be used. So there are no space savings, even if record is
> > discarded or only portion of it is submitted. I can only see a bit of
> > added convenience for an application, because it doesn't have to track
> > amount of actual data in its record. But this doesn't seem to be a
> > common case either, so not sure how it's worth supporting... Is there
> > a particular case where this is extremely useful and extra 4 bytes in
> > record payload is too much?
>
> Not off the top of my head - it was just the first thing that came to
> mind when reading about the commit/discard paradigm.  I was thinking
> about variable records, where the maximum is reserved, but less data
> is written.  But there's no particular reason for the ringbuffer to
> track this either, it could be part of the application framing.

Yeah, I'd defer to application doing that. People were asking about
using reserve with variable-sized records, but I don't think it's
possible to do. That what bpf_ringbuf_output() helper was added for:
prepare variable-sized data outside of ringbuf, then reserve exact
amount and copy over. Less performant, but allows to use ring buffer
space more efficiently.

>
>
> > > 3) Why have 2 separate pages for producer/consumer, instead of
> > >    just aligning to a smp cache line (or even 1/2 page?)
> >
> > Access rights restrictions. Consumer page is readable/writable,
> > producer page is read-only for user-space. If user-space had ability
> > to write producer position, it could wreck a huge havoc for the
> > ringbuf algorithm.
>
> Ah, thanks, that makes sense.  Might want to add a comment to
> that effect, as it's different from other implementations.

Yep, definitely, I knew I forgot to document something :)

> --
> Jonathan
