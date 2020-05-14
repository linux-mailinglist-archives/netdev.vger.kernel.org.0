Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C2D1D4067
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 23:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgENV4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 17:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbgENV4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 17:56:13 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76447C05BD43
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 14:56:13 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id v15so93081qvr.8
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 14:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zEKdvxuRmynEGy16bF3LGoDg2yM0IjC5jEtajMBXRXU=;
        b=KB7yctVWS5p1sSRjtheM/VI3+4vOa63NKZshvviq8GMTWRpxw3rMiC0PS7nMyrnra2
         tcZfKyY7vdsxeoepVOs2VvRIgQYLMc4tvmweb6+/D2fNIgmPmfA67ETzjz397o5AX/4x
         PQsoFlLQa4pDsPlw3tVZYj6yTwqhrXyBhWyp63WSa3rrFvJeEfeLSwOUIUK9RrRZCiuL
         QA2oggyK4128T43XR+fb7wP8WGgTBWmUXtsHuRMh1vlnmIz63iquIw9TDgwEFLifFRU3
         QvRh/SCxrRoTzJcTcVbMP4BMKHsmOcHrkql6styuM8IuLXRDsUqnH9wQaW9m1rkfxweK
         92FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zEKdvxuRmynEGy16bF3LGoDg2yM0IjC5jEtajMBXRXU=;
        b=sj0SnUYG8nOcXo+zcUtuNweK3mUomoGBqrB7W1bZEfVRdq8QzJyQDZkAHwOUcjnOdg
         AnadjZCTceqbo56v0PtfiR3R9n81+CNyFi6Enxvnt1nFYDCWm8H8vaZGD857dVpON1Ft
         LqnculYfe0WrT4YXsl/o1IXK5AyIP4gy9UvJGMZPks+8wUevRvOkOJsW1h8wsalRm3Cn
         5zDhUDcG7mw+9zFbUwTf/iLIc+WtLl3Ubn6JUEuBY5WoY/W+K9M8GP4I+0z6qmt2fABm
         V3bX9Rtttunm2eaGnep3GyXpz1n2F8Keox2QzrurPnyrWprYF/qlzGIKCdYebZR6dbiF
         nImw==
X-Gm-Message-State: AOAM533sw9d43Obk6H53jGx/0Ss7zAxu3LCIIUN6LeBbKCF+Z3+AJOm8
        20WZRIKXNJrNo/CopodsmidOxjyepQt9lw47IsxKIg==
X-Google-Smtp-Source: ABdhPJyD6MVawv3z3jyeAQBD8Ff8rxbsGSC3aCoUwzaMG8c1THeirI1WuwIqIC5L23u6eIfiphEVGAryqJA2gUxaUSc=
X-Received: by 2002:a0c:b58a:: with SMTP id g10mr540616qve.225.1589493372191;
 Thu, 14 May 2020 14:56:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200513192532.4058934-1-andriin@fb.com> <20200513192532.4058934-2-andriin@fb.com>
 <20200514173338.GA161830@google.com> <CAEf4BzbhqQB61JTmmp5999bbEFeHEMdvnE9vpV3tHCHm12cf-Q@mail.gmail.com>
 <20200514205348.GB161830@google.com> <CAEf4BzbvjQy+8T43e91OXDaLgWsy5_1RSr278=uAVUGOT0LgZw@mail.gmail.com>
In-Reply-To: <CAEf4BzbvjQy+8T43e91OXDaLgWsy5_1RSr278=uAVUGOT0LgZw@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 14 May 2020 14:56:01 -0700
Message-ID: <CAKH8qBsy_DLhwie+g6o7yHEv_tBT5K2YCdjsn1j4KkhVvRSr5A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/6] bpf: implement BPF ring buffer and verifier
 support for it
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Thu, May 14, 2020 at 2:13 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, May 14, 2020 at 1:53 PM <sdf@google.com> wrote:
> >
> > On 05/14, Andrii Nakryiko wrote:
> > > On Thu, May 14, 2020 at 10:33 AM <sdf@google.com> wrote:
> > > >
> > > > On 05/13, Andrii Nakryiko wrote:
> >
> > [...]
> >
> > > > > + * void bpf_ringbuf_submit(void *data)
> > > > > + *   Description
> > > > > + *           Submit reserved ring buffer sample, pointed to by
> > > *data*.
> > > > > + *   Return
> > > > > + *           Nothing.
> > > > Even though you mention self-pacing properties, would it still
> > > > make sense to add some argument to bpf_ringbuf_submit/bpf_ringbuf_output
> > > > to indicate whether to wake up userspace or not? Maybe something like
> > > > a threshold of number of outstanding events in the ringbuf after which
> > > > we do the wakeup? The default 0/1 preserve the existing behavior.
> > > >
> > > > The example I can give is a control plane userspace thread that
> > > > once a second aggregates the events, it doesn't care about millisecond
> > > > resolution. With the current scheme, I suppose, if BPF generates events
> > > > every 1ms, the userspace will be woken up 1000 times (if it can keep
> > > > up). Most of the time, we don't really care and some buffering
> > > > properties are desired.
> >
> > > perf buffer has setting like this, and believe me, it's so confusing
> > > and dangerous, that I wouldn't want this to be exposed. Even though I
> > > was aware of this behavior, I still had to debug and work-around this
> > > lack on wakeup few times, it's really-really confusing feature.
> >
> > > In your case, though, why wouldn't user-space poll data just once a
> > > second, if it's not interested in getting data as fast as possible?
> > If I poll once per second I might lose the events if, for some reason,
> > there is a spike. I really want to have something like: "wakeup
> > userspace if the ringbuffer fill is over some threshold or
> > the last wakeup was too long ago". We currently do this via a percpu
> > cache map. IIRC, you've shared on lsfmmbpf that you do something like
> > that as well.
>
> Hm... don't remember such use case on our side. All applications I
> know of use default perf_buffer settings with no sampling.
Nevermind, I might have misunderstood :-)

> > So I was thinking how I can use new ringbuff to remove the unneeded
> > copies and help with the reordering, but I'm a bit concerned about
> > regressing on the number of wakeups.
> >
> > Maybe having a flag like RINGBUF_NO_WAKEUP in bpf_ringbuf_submit()
> > will suffice? And if there is a helper or some way to obtain a
> > number of unconsumed items, I can implement my own flushing policy.
>
> Ok, I guess giving application control at each discard/commit makes
> for ultimate flexibility. Let me add flags argument to commit/discard
> and allow to specify NO_WAKEUP flag. As for count of unconsumed events
> -- that would be a bit expensive to maintain. How about amount of data
> that's not consumed? It's obviously going to be racy, but returning
> (producer_pos - consumer_pos) should be sufficient enough for such
> smart and best-effort heuristics? WDYT?
Awesome, SGTM! Racy is fine (I don't see how we can make it non-racy
as well). The amount of data instead of the number of items is also fine
since I know the size of the buffer.
