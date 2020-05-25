Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD601E14AA
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 21:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389991AbgEYTMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 15:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388838AbgEYTMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 15:12:45 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0AEDC061A0E;
        Mon, 25 May 2020 12:12:43 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id c185so4213886qke.7;
        Mon, 25 May 2020 12:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NXSkDxtV+lKvCmdJqRAaVqtPNqFcq/NZVIC0rHJLbkw=;
        b=SFq0F8aaUZQ/iT7qRHjxDkG+VaWxeMEGQVaE98QSO2UveShwC/WGOLLruJYXNvC8Xv
         2FTVGwpBzyPs7TH79nktYAxrv1vfL9SIfyQ++Tdl5Gyoa5HTVvUeP9StTaCRpOTUQIYD
         RzVkZ55SmDaiI6kSwnRgIqbyphXJV/AYfAy9oMPJBkHPNyROYmufHyg38GhKFcgiTl23
         fBc3kFR71TtqLyrdo6/0DjjjDO+tBWQmFtjpRBkLhLSUfO7n7bCuAZG7R00vdMSbh/JG
         uEvgh4oGi4NAJX8GPziZKLGcsWojGwCH7YqU5EQsEztytiR9St7rZecCaKzPMCO8hE//
         hAcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NXSkDxtV+lKvCmdJqRAaVqtPNqFcq/NZVIC0rHJLbkw=;
        b=sHIbkq0vA8v2wFEN4p5PxWKqLxMOk/E/+1nPy2n5rll/zxqy/w6gVVGPCbjBk74Vuc
         IRKvWJ54Of/qea3fZKlHCVNNYBn8vCNymWXPwLyJmI6afEhAMS/ET5ws3qPwL+hTj/5f
         36rWZVaBe9Sw8pP/x2d7Jx/V99EUaCAF1vWN6LMVfuiUeSs8rWT29DVnz6Prr95R74ra
         iDUtsMleH9LhdjkM9q1kjbddiTaLUtCMdiOQfRHAn+S1pMjBh2F78XI/6nPNiNYtUOuk
         GvIpv4qQKztwY3GRsmwj1eRahf9xuodW2Zg4OxPldTJpuRC4lnj/qjlRqn3sXWw/ckv/
         C1tw==
X-Gm-Message-State: AOAM5315u6OwStzDeeHZC+c01HIvrtteMso+AtDowgChDwtOzdj44DrE
        Pw3Uxre66e82OB9ZLt7LtSjpA+tNR3dXqZJIzSg=
X-Google-Smtp-Source: ABdhPJymS3OokrQQQrHxw17NvmafwQ71YS5xv4a02PaRNEJQbBayUO2d3u+mshTSuoHk/vp/rHvnp56dbjX+m2NEXN0=
X-Received: by 2002:a37:a89:: with SMTP id 131mr10622430qkk.92.1590433962844;
 Mon, 25 May 2020 12:12:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200517195727.279322-1-andriin@fb.com> <20200517195727.279322-8-andriin@fb.com>
 <CAMXgnP424S5s-mrwFB_nuZNSuqLyi1K8r519WKVkyMBPtv1PMQ@mail.gmail.com>
In-Reply-To: <CAMXgnP424S5s-mrwFB_nuZNSuqLyi1K8r519WKVkyMBPtv1PMQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 25 May 2020 12:12:31 -0700
Message-ID: <CAEf4BzY3mt8puNgOwi5ZWnVbXksnsXK_beG+HhhZutyBG-BO7A@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 7/7] docs/bpf: add BPF ring buffer design notes
To:     Alban Crequy <alban.crequy@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Alban Crequy <alban@kinvolk.io>, mauricio@kinvolk.io,
        kai@kinvolk.io
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 3:00 AM Alban Crequy <alban.crequy@gmail.com> wrote:
>
> Hi,
>
> Thanks. Both motivators look very interesting to me:
>
> On Sun, 17 May 2020 at 21:58, Andrii Nakryiko <andriin@fb.com> wrote:
> [...]
> > +Motivation
> > +----------
> > +There are two distinctive motivators for this work, which are not satisfied by
> > +existing perf buffer, which prompted creation of a new ring buffer
> > +implementation.
> > +  - more efficient memory utilization by sharing ring buffer across CPUs;
>
> I have a use case with traceloop
> (https://github.com/kinvolk/traceloop) where I use one
> BPF_MAP_TYPE_PERF_EVENT_ARRAY per container, so when the number of
> containers times the number of CPU is high, it can use a lot of
> memory.
>
> > +  - preserving ordering of events that happen sequentially in time, even
> > +  across multiple CPUs (e.g., fork/exec/exit events for a task).
>
> I had the problem to keep track of TCP connections and when
> tcp-connect and tcp-close events can be on different CPUs, it makes it
> difficult to get the correct order.

Yep, in one of BPF applications I've written, handling out-of-order
events was major complication to the design of data structures, as
well as user-space implementation logic.

>
> [...]
> > +There are a bunch of similarities between perf buffer
> > +(BPF_MAP_TYPE_PERF_EVENT_ARRAY) and new BPF ring buffer semantics:
> > +  - variable-length records;
> > +  - if there is no more space left in ring buffer, reservation fails, no
> > +    blocking;
> [...]
>
> BPF_MAP_TYPE_PERF_EVENT_ARRAY can be set as both 'overwriteable' and
> 'backward': if there is no more space left in ring buffer, it would
> then overwrite the old events. For that, the buffer needs to be
> prepared with mmap(...PROT_READ) instead of mmap(...PROT_READ |
> PROT_WRITE), and set the write_backward flag. See details in commit
> 9ecda41acb97 ("perf/core: Add ::write_backward attribute to perf
> event"):
>
> struct perf_event_attr attr = {0,};
> attr.write_backward = 1; /* backward */
> fd = perf_event_open_map(&attr, ...);
> base = mmap(fd, 0, size, PROT_READ /* overwriteable */, MAP_SHARED);
>
> I use overwriteable and backward ring buffers in traceloop: buffers
> are continuously overwritten and are usually not read, except when a
> user explicitly asks for it (e.g. to inspect the last few events of an
> application after a crash). If BPF_MAP_TYPE_RINGBUF implements the
> same features, then I would be able to switch and use less memory.
>
> Do you think it will be possible to implement that in BPF_MAP_TYPE_RINGBUF?
>

I think it could be implemented similarly. Consumer_pos would be
ignored, producer_pos would point to the beginning of record and
decremented on new reservation. All the implementation and semantics
would stay. Extending ringbuf itself to enable this is also trivial,
it could be just extra map_flag passed when map is created,
consumer_pos page would become mmap()'able as R/O, of course.

But I fail to see how consumer can be 100% certain it's not reading
garbage data, especially on 32-bit architectures, where wrapping over
32-bit producer position is actually quite easy. Just checking
producer position before/after read isn't completely correct. Ignoring
that problem, the only sane way (IMO) to do this would mean copying
each record into a "stable" memory, before actually doing anything
with it, which is a pretty bad performance hit as well.

So all in all, such mode could be added, but certainly in a separate
patch set and after some good discussion :).

> Cheers,
> Alban
