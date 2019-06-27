Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE35258D4C
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 23:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfF0Vpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 17:45:36 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44040 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfF0Vpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 17:45:36 -0400
Received: by mail-qt1-f194.google.com with SMTP id x47so4134475qtk.11;
        Thu, 27 Jun 2019 14:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jphukpALHG+A7dF/8UASvtwzDRSg4eK/rWijfRXiGlg=;
        b=cbhcO1GY1Mpsx08+VCJvg9ZvuKy12AMm34GROU8AOLXQViNPyawYO5emx6QKy0y9c4
         evIaasF+WU41c7BxYXSR4Hr/E+qXpNvwmuQq55r6SjaNeOQinJaS/70QwRAERQOO21cF
         wF/LcD429QdqGjtlaOzYlslnkdQ5o746pxD5jRZl0tKm+vcKSkqi+hVTQLPrUaTKtySI
         0+AEpLZlO5zmxiO/VuMravu4eAXybheumSMaQ3gYMkbRtSMA0uEuWoB8OL0ysYP3FzXC
         uQUwW2EQFRPWoYQWzNnltzVobWg5NftodXmhkrL09M/xmRrCsmtY6y5PN5qedDQrYTy7
         ke/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jphukpALHG+A7dF/8UASvtwzDRSg4eK/rWijfRXiGlg=;
        b=Otxmgr+cadRAxXZ78AYIF6UqHo3qT9/UnolLmjxjKPSl+WreUUJ9ToVt/6sZXYSqpg
         TS+8IS3OkHrncAFskJI8mDJa/iKm0NyXbuOKobeJ9PLMAsu0AVP1s69sxSU70+yR7KZV
         fbdCoysCOcUtVEP+JYYvuaiS7FN548fUDCAsCFqsvJtjauqIpttSFwosy0/c2ppWPS4m
         xOtK9T90Kn4YHbEqBRKJim34o9aJiBxIgfSMm8CgmuFFaMCsVic51IwWeU5sx1kZ4r8M
         SyajGBT4o8dCzHr/v4rl+JO68ki+nCRe4LShRT2zRHIkYe0gykmtCALTc65317auMr9I
         ePDw==
X-Gm-Message-State: APjAAAUAK9zt2yuvfe0ynFHpWAM82jA259BWL0REQRzbnd7HXFHAdpti
        2nhrnIiJ3hhdhH59wRsYP5PeKEnWs1tfFjp2Lw/VpMW7
X-Google-Smtp-Source: APXvYqwTiUwuQNfBOjo83grt+xYoUHQJop+iie9lkveawwqBLO4ZlwbneNLOmBntZVtr9zrWj+trX0hL/9zEPBodqc8=
X-Received: by 2002:a0c:d0fc:: with SMTP id b57mr5418739qvh.78.1561671935032;
 Thu, 27 Jun 2019 14:45:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190626061235.602633-1-andriin@fb.com> <20190626061235.602633-2-andriin@fb.com>
 <7de14b2b-a663-eed9-8f70-fb6bd5ea84d8@iogearbox.net>
In-Reply-To: <7de14b2b-a663-eed9-8f70-fb6bd5ea84d8@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 27 Jun 2019 14:45:24 -0700
Message-ID: <CAEf4Bzb4U73jb80eCv+JoFGFd2ACXK4j6d=ZeVOoRH1d0f-dPg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] libbpf: add perf buffer API
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 2:04 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 06/26/2019 08:12 AM, Andrii Nakryiko wrote:
> > BPF_MAP_TYPE_PERF_EVENT_ARRAY map is often used to send data from BPF program
> > to user space for additional processing. libbpf already has very low-level API
> > to read single CPU perf buffer, bpf_perf_event_read_simple(), but it's hard to
> > use and requires a lot of code to set everything up. This patch adds
> > perf_buffer abstraction on top of it, abstracting setting up and polling
> > per-CPU logic into simple and convenient API, similar to what BCC provides.
> >
> > perf_buffer__new() sets up per-CPU ring buffers and updates corresponding BPF
> > map entries. It accepts two user-provided callbacks: one for handling raw
> > samples and one for get notifications of lost samples due to buffer overflow.
> >
> > perf_buffer__poll() is used to fetch ring buffer data across all CPUs,
> > utilizing epoll instance.
> >
> > perf_buffer__free() does corresponding clean up and unsets FDs from BPF map.
> >
> > All APIs are not thread-safe. User should ensure proper locking/coordination if
> > used in multi-threaded set up.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Aside from current feedback, this series generally looks great! Two small things:
>
> > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > index 2382fbda4cbb..10f48103110a 100644
> > --- a/tools/lib/bpf/libbpf.map
> > +++ b/tools/lib/bpf/libbpf.map
> > @@ -170,13 +170,16 @@ LIBBPF_0.0.4 {
> >               btf_dump__dump_type;
> >               btf_dump__free;
> >               btf_dump__new;
> > -             btf__parse_elf;
> >               bpf_object__load_xattr;
> >               bpf_program__attach_kprobe;
> >               bpf_program__attach_perf_event;
> >               bpf_program__attach_raw_tracepoint;
> >               bpf_program__attach_tracepoint;
> >               bpf_program__attach_uprobe;
> > +             btf__parse_elf;
> >               libbpf_num_possible_cpus;
> >               libbpf_perf_event_disable_and_close;
> > +             perf_buffer__free;
> > +             perf_buffer__new;
> > +             perf_buffer__poll;
>
> We should prefix with libbpf_* given it's not strictly BPF-only and rather
> helper function.

Well, perf_buffer is an object similar to `struct btf`, `struct
bpf_program`, etc. So it seems appropriate to follow this
"<object>__<method>" convention. Also, `struct libbpf_perf_buffer` and
`libbpf_perf_buffer__new` looks verbose and pretty ugly, IMO.

>
> Also, we should convert bpftool (tools/bpf/bpftool/map_perf_ring.c) to make
> use of these new helpers instead of open-coding there.

Yep, absolutely, will do that as well, thanks for pointing me there!

>
> Thanks,
> Daniel
