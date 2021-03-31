Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D81350712
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 21:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235559AbhCaS76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 14:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235335AbhCaS7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 14:59:39 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFFCC061574;
        Wed, 31 Mar 2021 11:59:39 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id o66so22245166ybg.10;
        Wed, 31 Mar 2021 11:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HNKRmMDJ0kvnDvoOj/CCsz+qwaOi3OAp0sSF6SSBBwE=;
        b=V5HyIvcVQ+pi/bismrOytiQLYnDnSYyZcziTYNyKpUEURcwxXnEHcrgr+gJmFYJkB8
         OmXc9M6H6Tdhpx7gat1OHCT/WwSoOxKwJd04Vc8jWgmyhblht3Vel946c3wITL/oRRTM
         yiN/G6a4Zwj5iOYK4lqxj1zEaCSqAnz8IHCtcdXukIGJ9pNIGXIMrgQKZCV+ePmXA8oc
         vTbIEp7ComL+U5kPaVVqk6zwwVze1fae35jZ30el/8XQRRfni71n7H30pBgCYd4cRrrb
         q1a34kseSKavh9oObpnIubjay1t8raNBAxIzBhCScQcwMs3dRA+UARDHlNev28u2htWL
         nrFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HNKRmMDJ0kvnDvoOj/CCsz+qwaOi3OAp0sSF6SSBBwE=;
        b=qLrHpR2VqeMBx6qj/yfsuhV9tBnP9ujmZENHh7M5AdtAnPtxL/C+B+jJhFfi4cK4Wh
         OESuSh/L6y+R3KnCgMf2aXgCMC9auqTOmnmYqFMb9QLjLsMcj6bDUhvcwIZNc6kMrX+8
         C/Edmrpw7mzwvItAfGIjeMpCOCTvPvBDnioLR8tX1v2udnys3iTjz7Pe6pnyNVhT5MUL
         WXZEx9tozGaCLB7iUkjemsbo65SckgJhCh3zFpS4yBUu/qpY4gX6g2nWmlwAxaDpITHw
         r2i1M7z9JYlTVtRnlhacic1QjlMnM+22TBv80H5R0FXENdKvL4Qb0XZpndE2HMFHBDlm
         TogQ==
X-Gm-Message-State: AOAM533lmwzTYFkmhaHZ0+h6D70k95fVDOoMl+ixNiYyyXcd+McNgf4w
        zyZgtHFywRaqtsAzPRUsZZHLent3qMVFiV6PQrYDzdT2yZ8=
X-Google-Smtp-Source: ABdhPJxgwGlhRV9Tc2fFDhdbm4lE+5eb8GppQ4sb9FTdDyhCVNVn3hSGpMaXpJaUzD7eo0hpipcclhC+xkRd3u9uEsc=
X-Received: by 2002:a25:5b55:: with SMTP id p82mr6222226ybb.510.1617217178546;
 Wed, 31 Mar 2021 11:59:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210328161055.257504-1-pctammela@mojatatu.com>
 <20210328161055.257504-3-pctammela@mojatatu.com> <BCF68ADA-5114-4E61-87DE-D5E5C946BC6F@fb.com>
In-Reply-To: <BCF68ADA-5114-4E61-87DE-D5E5C946BC6F@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 31 Mar 2021 11:59:27 -0700
Message-ID: <CAEf4BzYWoczwZwG1qKhZc8jEfr4EQAwY76AaD_LuJsM1ohVJkQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Add '_wait()' and '_nowait()' macros for 'bpf_ring_buffer__poll()'
To:     Song Liu <songliubraving@fb.com>
Cc:     Pedro Tammela <pctammela@gmail.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 9:28 AM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Mar 28, 2021, at 9:10 AM, Pedro Tammela <pctammela@gmail.com> wrote:
> >
> > 'bpf_ring_buffer__poll()' abstracts the polling method, so abstract the
> > constants that make the implementation don't wait or wait indefinetly
> > for data.
> >
> > Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> > ---
> > tools/lib/bpf/libbpf.h                                 | 3 +++
> > tools/testing/selftests/bpf/benchs/bench_ringbufs.c    | 2 +-
> > tools/testing/selftests/bpf/prog_tests/ringbuf.c       | 6 +++---
> > tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c | 4 ++--
> > 4 files changed, 9 insertions(+), 6 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > index f500621d28e5..3817d84f91c6 100644
> > --- a/tools/lib/bpf/libbpf.h
> > +++ b/tools/lib/bpf/libbpf.h
> > @@ -540,6 +540,9 @@ LIBBPF_API int ring_buffer__poll(struct ring_buffer *rb, int timeout_ms);
> > LIBBPF_API int ring_buffer__consume(struct ring_buffer *rb);
> > LIBBPF_API int ring_buffer__epoll_fd(const struct ring_buffer *rb);
> >
> > +#define ring_buffer__poll_wait(rb) ring_buffer__poll(rb, -1)
> > +#define ring_buffer__poll_nowait(rb) ring_buffer__poll(rb, 0)
>
> I think we don't need ring_buffer__poll_wait() as ring_buffer__poll() already
> means "wait for timeout_ms".
>
> Actually, I think ring_buffer__poll() is enough. ring_buffer__poll_nowait()
> is not that useful either.
>

I agree. I think adding a comment to the API itself might be useful
specifying 0 and -1 as somewhat special cases.

> Thanks,
> Song
>
