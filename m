Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86BE149402D
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 19:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243099AbiASStw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 13:49:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356903AbiASStt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 13:49:49 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD46C061574;
        Wed, 19 Jan 2022 10:49:48 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id z19so4055474ioj.1;
        Wed, 19 Jan 2022 10:49:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nnuoU1KSe1lPzn+swqfrL4u+55EECpEPFhS5y1Mxsfk=;
        b=hVhm31jvNS5wbREEluftIXgbqwXvIohRdyCpSa3EM9DRnsOK9TpSEpDGIXwzHHyTJv
         /09mGm7RwutOmCCO0l63Lez0ehcH8Eo7jkJo29CaEFOZXEFG5GBwUoylHv1v7nSdw2wh
         6tw9lYCjELz0NwOti7hYRUix5EwufXhk9rtYHxvF68M6Sk5qfMALLMlaec6VALG2wJVq
         BU8AOcyZ5M3nxcM2ddse8hidhVflS/SWLC8Da2e9LxKOIdjR5wEXilqt4GivPi9FamKj
         Onbz97KUaY8gNBEwEin8Y69Dg9rI80LxRMQ2ozeST+Sr4XiiKYYTgMUqsHwErReAqIl1
         CaSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nnuoU1KSe1lPzn+swqfrL4u+55EECpEPFhS5y1Mxsfk=;
        b=wzDsvSCzw+B3eUW5BpKwb6ZeaTAj6jQ24L7K21IDM1V6VX3cHShzMOuPoKHBUIt4js
         1J0ngjvUAMa8kuIfamMmHkd7nR3EaxFTCmPDpejQoDlOdiSXotS5WyWpltCJmnvZBsWB
         R7Zf+PNSpGFJjeO5VEo3ZVs+fgswYxYFMMo5mj14cM1JjH4vQiEGf4UDwJAKWBVKXMe+
         5pQlNJG/6MYrCHQH9z/EBQsZrSnRl+FxLoL5vD/s87QWdtd8nApfP8Y+NZVeAlH5E4Dg
         j4mDpiCpdbemGxrTv0Y+U3GGvm9YKWo6mdM+V5Ff4ZzZOqU+3tPv+6ljdwGqwpHWPivs
         4gOg==
X-Gm-Message-State: AOAM531/yVYKPMAFNw0ZFk3qmpg4tHdZgOgvC4DI3rji0xKYQDZ1bcuf
        9DbGHEqJuoxNkV+XbCQ5V5dmtaxGAOqAgf0Ls7I=
X-Google-Smtp-Source: ABdhPJzaMUfYG1ePvmrS2kcmYD9SEmK+HrpPRpPvfM5v7/7VWMNLgfZrwrtR/LhXQHGuRyOk48BEoK82DkbfzOwcTK8=
X-Received: by 2002:a02:bb8d:: with SMTP id g13mr15231052jan.103.1642618187947;
 Wed, 19 Jan 2022 10:49:47 -0800 (PST)
MIME-Version: 1.0
References: <1642004329-23514-1-git-send-email-alan.maguire@oracle.com>
 <CAEf4BzYRLxzVHw00DUphqqdv2m_AU7Mu=S0JF0PZYN40hBvHgA@mail.gmail.com>
 <alpine.LRH.2.23.451.2201131025380.13423@localhost> <CAEf4BzaX70Ze2mdLuQvw8kNqCt7fQAOkO=Akm=T9Pjxf4eDpLA@mail.gmail.com>
 <alpine.LRH.2.23.451.2201191341380.10931@localhost>
In-Reply-To: <alpine.LRH.2.23.451.2201191341380.10931@localhost>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 19 Jan 2022 10:49:36 -0800
Message-ID: <CAEf4BzadgXvW_eDAG00a_hyFUKqyLFn=rNwGFgJqCpyRsLyNTw@mail.gmail.com>
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

On Wed, Jan 19, 2022 at 6:04 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> On Fri, 14 Jan 2022, Andrii Nakryiko wrote:
>
> > > The one piece that seems to be missing from my perspective - and this may
> > > be in more recent versions - is uprobe function attachment by name. Most of
> > > the work is  already done in libusdt so it's reasonably doable I think - at a
> > > minimum  it would require an equivalent to the find_elf_func_offset()
> > > function in my  patch 1. Now the name of the library libusdt suggests its
> > > focus is on USDT of course, but I think having userspace function attach
> > > by name too would be great. Is that part of your plans for this work?
> >
> > True, uprobes don't supprot attaching by function name, which is quite
> > annoying. It's certainly not a focus for libusdt (or whatever it will
> > end up being called when open-sources). But if it's not much code and
> > complexity we should probably just add that to libbpf directly for
> > uprobes.
> >
>
> I've been looking at this, and I've got the following cases working:
>
> - local symbols in a binary. This involves symbol table lookup and
>   relative offset calcuation.
> - shared object symbols in a shared object.  In this case, the symbol
>   table values suffice, no adjustment needed.
>
> The former works using the program headers (instead of /proc/pid/maps for
> offset computation), so can be run for all processes, lifting the
> limitation in the RFC which only supported name lookup for a specific
> process. Around a hundred lines for this makes it worthwhile I think.
>
> There is one more case, which is a shared library function in a binary -
> where I specify "malloc" as the function and /usr/bin/foo as the binary
> path.  In this case, for dynamic symbols we can't just look up the symbol
> table in the binary, since the associated values are 0.  Ideally it would
> be nice if the user could just specify "malloc" and not need to use libc
> as the binary path argument, but getting this working is proving to be
> trickier. I've tried making use of PLT section information but no luck
> yet (the idea being we try to use the trampoline address of malloc@@PLT
> instead, but I'm still trying to figure out how to extract that).
>
> So I'm wondering if we just fail lookup for that case, assuming the user
> will specify the shared library path if they want to trace a shared library
> function. What do you think? Thanks!

I think it all makes sense (but let's see the code as well ;) ). For
the latter, can you please double-check what sort of functionality BCC
provides? Also make sure that you support specifying absolute address
instead of function name as well (func+0x123 probably as well, just
like for kprobes?).

The annoying bit is libbpf's convention to use '/' as a separator in
SEC() definitions. I think bpftrace/dtrace's ':' makes more sense, but
it seems to disruptive to switch it now. Because of this, specifying
absolute path to the binary would look weird:

SEC("uprobe//usr/bin/bash/readline")

or something like that would consistent with current convention, but
super weird.

Did you run into this issue during your experiments?

I can see two improvements, more and less radical (short of switching
from / to : completely):

1. less radical is to use "custom" format for uprobe after the "uprobe/" part:

SEC("uprobe//usr/bin/bash:readline")

2. a bit more radical (but probably better long term) is to support
'/' and ':' interchangeably (but only one of them in any given SEC()
definition).  For existing definitions, we can say that both forms are
supported now:

SEC("kprobe/some_func") and SEC("kprobe:some_func")

For uprobe I'd probably combine #1 and #2 and say that these two forms
are supported:

SEC("uprobe//usr/bin/bash:readline") (so function separator is always ':')

and

SEC("uprobe:/usr/bin/bash:readline") (nicer and more consistent).


Thoughts?

BTW, as much as I like consistency, the proposal to switch to ':'
exclusively in libbpf 1.0 is a no-go, IMO, it's too much of a
disruption for tons of users.


>
> Alan
