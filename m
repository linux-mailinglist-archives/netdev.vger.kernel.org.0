Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBFB24DC01
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 18:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbgHUQvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 12:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728619AbgHUQvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 12:51:42 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098BAC061573;
        Fri, 21 Aug 2020 09:51:42 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id e187so1370730ybc.5;
        Fri, 21 Aug 2020 09:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H4dAFLlprWaBYEmTTmuTiGKpaxj4Q19Vfz3BuRHCB/Y=;
        b=Zj1io0bLawEt7wCZnAO3lr6ZzeKgLjOWHCrhv4k8tWTa4hqXOlGPuQnn1XkZs0K1Mz
         eDLnkxMc4Q3RzGRqNTwTRavSdV5YmD/WNlBU/26Yp1FAQi/glZUM0jx8BcGLZmisdDnF
         mqitRmx8kj1d5JUETzemk+Jf4RUUpimdf84CesexCB6CXLkWJEw309gID3FUhp3ejGJ9
         VT2WJ/Auqkloq3rwdEV6adbXXS5q0HRNR+HUbQPEGp8vonJgbckEEp3ipUY0I6UwJZkt
         kieNUPmK+58Sq39/J5IfmmVszJCYt5kSyoClZRJLeq44HB/a5ZJHeaIclfMOfKZ6GgzX
         H8Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H4dAFLlprWaBYEmTTmuTiGKpaxj4Q19Vfz3BuRHCB/Y=;
        b=cwTBM2FXkSev6+tuhBIEnOOkKoWNgdUC0KodvgnitrPT9Acbu65TeMRpSjrcUDomVQ
         3DdIww8s7JMkSfnRTtwRTFgeWEn3XYi+cFUnt5aqRkhuA4LiyIhDi8rZKVZi+TmDhtnC
         QFkSBk3qI7cYL7oLc05LMt4fc+gstifVDBSz2WyEfAq4OE/wS+STMIdzwUsFeeZMoNpl
         WPb8edW90wj6ldXZvLHq+y5rTY8HAV0Hye+DlgmHIadVZ/OzOfJQFHpgoj2Il6MjbBkG
         Jmz2tI5K2LMY71WDsuMgkbNlmWakO4grhCiJkgpEDk/Xt1zkDgZWerfU078UN+qYDHlq
         2I2A==
X-Gm-Message-State: AOAM530Hq9vO2bjmhd8wfL1Vu5ZB5+h/pubzpGxYHWEwnsnWFPwByCPv
        IJTIICFdtLxiAtSZ+3HaT/6908ry7wEHOUCcpOc=
X-Google-Smtp-Source: ABdhPJyZ1mumQvNsR5h7NeLiddrY7u3a/1TjQ5FWGf3MsiKaPHffF7CnZZYlpcllPOCwN055E3jUCH6kzxdIWUsk8lk=
X-Received: by 2002:a25:84cd:: with SMTP id x13mr4753679ybm.425.1598028701207;
 Fri, 21 Aug 2020 09:51:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200821025448.2087055-1-andriin@fb.com> <alpine.LRH.2.21.2008211149530.9620@localhost>
In-Reply-To: <alpine.LRH.2.21.2008211149530.9620@localhost>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 21 Aug 2020 09:51:30 -0700
Message-ID: <CAEf4BzZiZufcE7r=3qkM76x5jd0da804kcyfaW+jOXR2Ky=i-g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: add perf_buffer APIs for better
 integration with outside epoll loop
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 5:51 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> On Thu, 20 Aug 2020, Andrii Nakryiko wrote:
>
> > Add a set of APIs to perf_buffer manage to allow applications to integrate
> > perf buffer polling into existing epoll-based infrastructure. One example is
> > applications using libevent already and wanting to plug perf_buffer polling,
> > instead of relying on perf_buffer__poll() and waste an extra thread to do it.
> > But perf_buffer is still extremely useful to set up and consume perf buffer
> > rings even for such use cases.
> >
> > So to accomodate such new use cases, add three new APIs:
> >   - perf_buffer__buffer_cnt() returns number of per-CPU buffers maintained by
> >     given instance of perf_buffer manager;
> >   - perf_buffer__buffer_fd() returns FD of perf_event corresponding to
> >     a specified per-CPU buffer; this FD is then polled independently;
> >   - perf_buffer__consume_buffer() consumes data from single per-CPU buffer,
> >     identified by its slot index.
> >
> > These APIs allow for great flexiblity, but do not sacrifice general usability
> > of perf_buffer.
> >
>
> This is great! If I understand correctly, you're supporting the
> retrieval and ultimately insertion of the individual per-cpu buffer fds
> into another epoll()ed fd.  I've been exploring another possibility -

yes, exactly

> hierarchical epoll, where the top-level perf_buffer epoll_fd field is used
> rather than the individual per-cpu buffers.  In that context, would an
> interface to return the perf_buffer epoll_fd make sense too? i.e.
>
> int perf_buffer__fd(const struct perf_buffer *pb);
>
> ?
>
> When events occur for the perf_buffer__fd, we can simply call
> perf_buffer__poll(perf_buffer__fd(pb), ...) to handle them it seems.
> That approach _appears_ to work, though I do see occasional event loss.
> Is that method legit too or am I missing something?

Yes, this would also work, but it's less efficient because you either
need to do unnecessary epoll_wait() syscall to know which buffers to
process, or you need to call perf_buffer__consume(), which will
iterate over *all* available buffers, even those that don't have new
information.

But I can add a way to get epoll FD as well, if that's more convenient
for some less performance-conscious cases. I'll add:

int perf_buffer__epoll_fd(const struct perf_buffer *pb)

just __fd() is too ambiguous.

>
> > Also exercise and check new APIs in perf_buffer selftest.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> A few question around the test below, but
>
> Reviewed-by: Alan Maguire <alan.maguire@oracle.com>
>
>
> > ---
> >  tools/lib/bpf/libbpf.c                        | 51 ++++++++++++++-
> >  tools/lib/bpf/libbpf.h                        |  3 +
> >  tools/lib/bpf/libbpf.map                      |  7 +++
> >  .../selftests/bpf/prog_tests/perf_buffer.c    | 62 +++++++++++++++----
> >  4 files changed, 111 insertions(+), 12 deletions(-)
> >

[...]

please trim next time

> > +     for (i = 0; i < nr_cpus; i++) {
> > +             if (i >= on_len || !online[i])
> > +                     continue;
> > +
> > +             fd = perf_buffer__buffer_fd(pb, i);
> > +             CHECK(last_fd == fd, "fd_check", "last fd %d == fd %d\n", last_fd, fd);
> > +             last_fd = fd;
> > +
>
> I'm not sure why you're testing this way - shouldn't it just be a
> verification of whether we get an unexpected error code rather
> than a valid fd?

My goal was to test that I do get different buffer fd for each CPU,
but you are right, I should also check that I get valid FD here. Will
fix in v2.


>
> > +             err = perf_buffer__consume_buffer(pb, i);
> > +             if (CHECK(err, "drain_buf", "cpu %d, err %d\n", i, err))
> > +                     goto out_close;
> > +
>
> I think I'm a bit lost in what processes what here. The first
> perf_buffer__poll() should handle the processing of the records
> associated with the first set of per-cpu triggering I think.
> Is the above perf_buffer__consume_buffer() checking the
> "no data, return success" case? If that's right should we do
> something to explicitly check it indeed was a no-op, like CHECK()ing
> CPU_ISSET(i, &cpu_seen) to ensure the on_sample() handler wasn't
> called? The  "drain_buf" description makes me think I'm misreading
> this and we're draining additional events, so I wanted to check
> what's going on here to make sure.

We can't make sure that there are no extra samples, because samples
are produced for any syscall (we don't filter by thread or process).
The idea here is to drain any remaining samples before I trigger
another round. Then check that at least one sample was emitted on the
desired CPU. It could be a spurious event, of course, but I didn't
think it's important enough to make sure just one sample can be
emitted.

>
> Thanks!
>
> Alan
