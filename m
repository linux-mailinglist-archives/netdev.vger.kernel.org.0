Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A40148F1A9
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 21:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240383AbiANUs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 15:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239837AbiANUs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 15:48:58 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E9EC06161C;
        Fri, 14 Jan 2022 12:48:58 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id o9so3502068iob.3;
        Fri, 14 Jan 2022 12:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BjIjIR3O/aMwfzpSELOHemGOc92BG3Ca1Aasq6OqpyQ=;
        b=APQLfvU8YneYcaw46EopJ8mYidGSET8o+KOGFMBlniVUnDMVi16yS1X6ZVkt1pAbuK
         PN5mpfLOzOXAdEaKOQcyVGuNrnc8K9XYl5JKnvU6A+aiIQZgxgBndMq0rUNeiYEX6TX1
         Y6kSP6AbvF71tKx7DtZIPBjxjGQQM1w70T9tWndJz4xCiNGzEmpFAH4bKrrT6Jb0dKX4
         iJi+ZwSiyWoRI7qj9jWo83W0sxeBqF/xtlszpBYcqJTHRMZHKULnDEb3cz/iAouoAKQm
         CgKF1m7cFuuPCrnlRvb1tk9MlazCeRJwOQ6hlO6MqLctTNZ3BT+Svch2UqOaFKpTam+a
         SNUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BjIjIR3O/aMwfzpSELOHemGOc92BG3Ca1Aasq6OqpyQ=;
        b=0ctXB6PAiEr+cJO+PvXiM3hvrNdtvjA5STCBdvou9zdpkdYhyqx7ZCapvUuWnOE/Hn
         zVHQLmlhERS2FuIQk3dKKnYMs1VIs3FdFcfd0EbHQ/fZ84LVQZzV0SkX7kozOQNSxT2V
         JkuLVHwEFsllHczBs88xc9J71pFQd79h5MKZIIjK8jMlIGP2P8zstKa/2I4dP3/3G3IN
         lU4vYfUQ/EsvxC+xa/XuWD87L20gz18BH1gxs061Wk51kOas8v9+miR8qMwA8Le6foj3
         rTXJKvn/d+uaZ2d2XxDY+TPoFkINGiSzKZZwZV7yuWK+8ZsxFq0YoI6aHBBa64dp6dD9
         CqAQ==
X-Gm-Message-State: AOAM5339nmE9vG+sgbAD0bgMWfvP9++6olHb/87CRDuhiqSDw6nkrvtg
        oKN4P52g9yoFxXKHBHaVaD5VnLK3eEQD2cojVOg=
X-Google-Smtp-Source: ABdhPJyuXm5hho9b64LCYB9uy/EFXuNyAabeQsvAA07LruGWjgghLhS2O/EQZV0u5uXiXRftlrEICx6/UfmcuRmuVxY=
X-Received: by 2002:a5d:9155:: with SMTP id y21mr5076316ioq.112.1642193337386;
 Fri, 14 Jan 2022 12:48:57 -0800 (PST)
MIME-Version: 1.0
References: <1642004329-23514-1-git-send-email-alan.maguire@oracle.com>
 <CAEf4BzYRLxzVHw00DUphqqdv2m_AU7Mu=S0JF0PZYN40hBvHgA@mail.gmail.com> <alpine.LRH.2.23.451.2201131025380.13423@localhost>
In-Reply-To: <alpine.LRH.2.23.451.2201131025380.13423@localhost>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 14 Jan 2022 12:48:46 -0800
Message-ID: <CAEf4BzaX70Ze2mdLuQvw8kNqCt7fQAOkO=Akm=T9Pjxf4eDpLA@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/4] libbpf: userspace attach by name
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Yucong Sun <sunyucong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 13, 2022 at 2:30 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> On Wed, 12 Jan 2022, Andrii Nakryiko wrote:
>
> > On Wed, Jan 12, 2022 at 8:19 AM Alan Maguire <alan.maguire@oracle.com> wrote:
> > >
> > > This patch series is a rough attempt to support attach by name for
> > > uprobes and USDT (Userland Static Defined Tracing) probes.
> > > Currently attach for such probes is done by determining the offset
> > > manually, so the aim is to try and mimic the simplicity of kprobe
> > > attach, making use of uprobe opts.
> > >
> > > One restriction applies: uprobe attach supports system-wide probing
> > > by specifying "-1" for the pid.  That functionality is not supported,
> > > since we need a running process to determine the base address to
> > > subtract to get the uprobe-friendly offset.  There may be a way
> > > to do this without a running process, so any suggestions would
> > > be greatly appreciated.
> > >
> > > There are probably a bunch of subtleties missing here; the aim
> > > is to see if this is useful and if so hopefully we can refine
> > > it to deal with more complex cases.  I tried to handle one case
> > > that came to mind - weak library symbols - but there are probably
> > > other issues when determining which address to use I haven't
> > > thought of.
> > >
> > > Alan Maguire (4):
> > >   libbpf: support function name-based attach for uprobes
> > >   libbpf: support usdt provider/probe name-based attach for uprobes
> > >   selftests/bpf: add tests for u[ret]probe attach by name
> > >   selftests/bpf: add test for USDT uprobe attach by name
> > >
> >
> > Hey Alan,
> >
> > I've been working on USDT support last year. It's considerably more
> > code than in this RFC, but it handles not just finding a location of
> > USDT probe(s), but also fetching its arguments based on argument
> > location specification and more usability focused BPF-side APIs to
> > work with USDTs.
> >
> > I don't remember how up to date it is, but the last "open source"
> > version of it can be found at [0]. I currently have the latest
> > debugged and tested version internally in the process of being
> > integrated into our profiling solution here at Meta. So far it seems
> > to be working fine and covers our production use cases well.
> >
>
> This looks great Andrii! I really like the argument access work, and the
> global tracing part is solved too by using the ELF segment info instead
> of the process maps to get the relative offset, with (I think?) use of
> BPF cookies to disambiguate between different user attachments.

BPF cookies are mandatory for when attaching to a shared library *and*
NOT specifying PID. This is actually the mode that BCC doesn't seem to
support. In all other cases BPF cookie shouldn't be mandatory.

>
> The one piece that seems to be missing from my perspective - and this may
> be in more recent versions - is uprobe function attachment by name. Most of
> the work is  already done in libusdt so it's reasonably doable I think - at a
> minimum  it would require an equivalent to the find_elf_func_offset()
> function in my  patch 1. Now the name of the library libusdt suggests its
> focus is on USDT of course, but I think having userspace function attach
> by name too would be great. Is that part of your plans for this work?

True, uprobes don't supprot attaching by function name, which is quite
annoying. It's certainly not a focus for libusdt (or whatever it will
end up being called when open-sources). But if it's not much code and
complexity we should probably just add that to libbpf directly for
uprobes.


>
> Thanks!
>
> Alan
