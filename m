Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B271D2121E7
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 13:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgGBLOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 07:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgGBLOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 07:14:04 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE73C08C5C1;
        Thu,  2 Jul 2020 04:14:04 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id o4so13618702ybp.0;
        Thu, 02 Jul 2020 04:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eNvvTDpk4HWu29heGzOFchBAHnDIkOKQa3sXxkbmF+w=;
        b=MkyKPBZsRw+l7HS1mxyE6nHXMKCx6+1jDsKhYBJ80MPzouH7gE+R5B0XqHNOicBohn
         amvUzsaM+gv3yXW2eubQRRygqo9EXHJxmNesj/H24qZ+51M9wTOsgH8sblT8JhEL1sCH
         PHT/IKoVli8ZipD6eJGZItJKPvPOQP5CzfpgstVJjhhI7CbKwnIKb6k68ETE1NakEHMd
         J2B9VFzCWseq7m3ns7BlJjt2vcGU7sbIdg99ylv9LZRaDH0ZCQkXPv4sEnAmaDhsZMqI
         qG5F/NxIqo7pI6RmaKgsbk+4hpnXzymOBSqFn8qKBv0DLXPjPSbrg5VQ3tcUnnepOK/G
         kClA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eNvvTDpk4HWu29heGzOFchBAHnDIkOKQa3sXxkbmF+w=;
        b=LS6oGgLM6kjeuJD5Bonk6i6dwL7x6Zq+sZofKNBuV490jHCvMFcAypQcSZwMWA1f3x
         AkbKetu3WHFsweyTGQjpqqwohzxUGX7MaXlXSebuAdKb4uIOYNowFzy5NiUmzwU2CMdN
         1f6ih0AKWGgadFSYb2to9ALGMt+yyd/s9388pVNg9BV+Ts37GDj3iZiT8Pv1aUxe9QI2
         l3UMP3Fk4hpXP3qcdTphA/kbPNSuCVALBYMRzuYFuLsZmHGCD08u7dcQfXJ/cS8Wbt5q
         sCiqL/MRq/GcbFSMdYmatpMCigwM13oGVKEzcS/OMCtnCZlGgwNx9EPUtNwDIQlmGCX/
         YWDA==
X-Gm-Message-State: AOAM5339sBpWStlyXKvwf80XY3SG6NeH4PkzXbGNJ3PokLpmfFPJJW+5
        DoXSpDVNQWNn/hmdc9QujI5xtijPvKfPIoOkhA==
X-Google-Smtp-Source: ABdhPJyLCuTCqLQ8C6dUzBAU31+jgZvFtvJpIelHa7KG4qOEVqH3GeFVe4z6WRkT7RTtLLbh0FCoKWbLDMQ+xMx0rik=
X-Received: by 2002:a05:6902:1021:: with SMTP id x1mr49046792ybt.464.1593688443451;
 Thu, 02 Jul 2020 04:14:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200702021646.90347-1-danieltimlee@gmail.com>
 <20200702021646.90347-2-danieltimlee@gmail.com> <c4061b5f-b42e-4ecc-e3fb-7a70206da417@fb.com>
In-Reply-To: <c4061b5f-b42e-4ecc-e3fb-7a70206da417@fb.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Thu, 2 Jul 2020 20:13:47 +0900
Message-ID: <CAEKGpzhU31p=i=xbD3Fk2vJh_btrk73CgkJXMXDgM1umsEaEpg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] samples: bpf: fix bpf programs with
 kprobe/sys_connect event
To:     Yonghong Song <yhs@fb.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 2:13 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 7/1/20 7:16 PM, Daniel T. Lee wrote:
> > Currently, BPF programs with kprobe/sys_connect does not work properly.
> >
> > Commit 34745aed515c ("samples/bpf: fix kprobe attachment issue on x64")
> > This commit modifies the bpf_load behavior of kprobe events in the x64
> > architecture. If the current kprobe event target starts with "sys_*",
> > add the prefix "__x64_" to the front of the event.
> >
> > Appending "__x64_" prefix with kprobe/sys_* event was appropriate as a
> > solution to most of the problems caused by the commit below.
> >
> >      commit d5a00528b58c ("syscalls/core, syscalls/x86: Rename struct
> >      pt_regs-based sys_*() to __x64_sys_*()")
> >
> > However, there is a problem with the sys_connect kprobe event that does
> > not work properly. For __sys_connect event, parameters can be fetched
> > normally, but for __x64_sys_connect, parameters cannot be fetched.
> >
> > Because of this problem, this commit fixes the sys_connect event by
> > specifying the __sys_connect directly and this will bypass the
> > "__x64_" appending rule of bpf_load.
>
> In the kernel code, we have
>
> SYSCALL_DEFINE3(connect, int, fd, struct sockaddr __user *, uservaddr,
>                  int, addrlen)
> {
>          return __sys_connect(fd, uservaddr, addrlen);
> }
>
> Depending on compiler, there is no guarantee that __sys_connect will
> not be inlined. I would prefer to still use the entry point
> __x64_sys_* e.g.,
>     SEC("kprobe/" SYSCALL(sys_write))
>

As you mentioned, there is clearly a possibility that problems may arise
because the symbol does not exist according to the compiler.

However, in x64, when using Kprobe for __x64_sys_connect event, the
tests are not working properly because the parameters cannot be fetched,
and the test under selftests/bpf is using "kprobe/_sys_connect" directly.

I'm not sure how to deal with this problem. Any advice and suggestions
will be greatly appreciated.

Thanks for your time and effort for the review.
Daniel

> >
> > Fixes: 34745aed515c ("samples/bpf: fix kprobe attachment issue on x64")
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
> >   samples/bpf/map_perf_test_kern.c         | 2 +-
> >   samples/bpf/test_map_in_map_kern.c       | 2 +-
> >   samples/bpf/test_probe_write_user_kern.c | 2 +-
> >   3 files changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/samples/bpf/map_perf_test_kern.c b/samples/bpf/map_perf_test_kern.c
> > index 12e91ae64d4d..cebe2098bb24 100644
> > --- a/samples/bpf/map_perf_test_kern.c
> > +++ b/samples/bpf/map_perf_test_kern.c
> > @@ -154,7 +154,7 @@ int stress_percpu_hmap_alloc(struct pt_regs *ctx)
> >       return 0;
> >   }
> >
> > -SEC("kprobe/sys_connect")
> > +SEC("kprobe/__sys_connect")
> >   int stress_lru_hmap_alloc(struct pt_regs *ctx)
> >   {
> >       char fmt[] = "Failed at stress_lru_hmap_alloc. ret:%dn";
> > diff --git a/samples/bpf/test_map_in_map_kern.c b/samples/bpf/test_map_in_map_kern.c
> > index 6cee61e8ce9b..b1562ba2f025 100644
> > --- a/samples/bpf/test_map_in_map_kern.c
> > +++ b/samples/bpf/test_map_in_map_kern.c
> > @@ -102,7 +102,7 @@ static __always_inline int do_inline_hash_lookup(void *inner_map, u32 port)
> >       return result ? *result : -ENOENT;
> >   }
> >
> > -SEC("kprobe/sys_connect")
> > +SEC("kprobe/__sys_connect")
> >   int trace_sys_connect(struct pt_regs *ctx)
> >   {
> >       struct sockaddr_in6 *in6;
> > diff --git a/samples/bpf/test_probe_write_user_kern.c b/samples/bpf/test_probe_write_user_kern.c
> > index 6579639a83b2..9b3c3918c37d 100644
> > --- a/samples/bpf/test_probe_write_user_kern.c
> > +++ b/samples/bpf/test_probe_write_user_kern.c
> > @@ -26,7 +26,7 @@ struct {
> >    * This example sits on a syscall, and the syscall ABI is relatively stable
> >    * of course, across platforms, and over time, the ABI may change.
> >    */
> > -SEC("kprobe/sys_connect")
> > +SEC("kprobe/__sys_connect")
> >   int bpf_prog1(struct pt_regs *ctx)
> >   {
> >       struct sockaddr_in new_addr, orig_addr = {};
> >
