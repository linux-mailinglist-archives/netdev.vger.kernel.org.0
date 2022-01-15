Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F47648F3BB
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 02:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbiAOBCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 20:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiAOBCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 20:02:43 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B5DC061574;
        Fri, 14 Jan 2022 17:02:43 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id p7so14478222iod.2;
        Fri, 14 Jan 2022 17:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cV/KQAdoixRP2Jc7kX5ih1D3aR41cK+Dy/TFv78IhVY=;
        b=C9xJVmTctCuMQKEqz+zvBi80svHjeyHO3AEwdTJnlo2VOzcWk6K+C7ldCp9MdKG/W3
         0qf7XbyPheYQkoaqB+gW2MWvghElD4sNNg6c/PFptSBioKcBuimTseYrwXj5sqczvlfy
         EX6V1eIjGYpxRDu7iZkn3NulGT19/d+ZEoXtuRkiZ3mpZjdHCJy8fRgPmJoDopuIprS4
         7mwdCDDWf/ID/o01w/c2/2YNe0N8/SG/FxOLOXnSrigkvPlSE2hs7fvbQuBfuh2iXcuz
         d9GYg7KLbPgb9AoD6iANKWGZMnUHu54onqQvWTcp6mWueDAWvwHhQGtd/gCni3V+Rni5
         vOeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cV/KQAdoixRP2Jc7kX5ih1D3aR41cK+Dy/TFv78IhVY=;
        b=kyET35kpy/KbUcxv+lrTXXIJGUSbnFbG3IPFaNVNwz4llfRTdCvLSEAbLi607iYGqO
         zIgfqU7/jE7QnPHIqreF5MTaON+qiCXkVSPjw1QqddEfEJSp7n0ArqWJ/PQ8DG/LyMkO
         vM3ZEvdixlziHxRWkt/RHDNYcaE8PmOcOE1shQ5lsrtXbRkC6qqBw+btfUvcmHyBhiQY
         ZDLj9woA1RYcrLe3xs/E0eORhg/u94nwTrmuZ/znpDa7V6vd2MoSveL8zXlwCBrC61i+
         MKTDRVBcGrsFy+3lFbNl5spj0jr72ssc750phIiFD8ROemfZWnGJmgEvH60gmMbyaZY4
         UkQg==
X-Gm-Message-State: AOAM531ZIuSK428TMizggvYEe94YEVKUow+pGFIePVNCJf0FYigWMCos
        ChnId5vK7wY5bgBxcZUPmW+9EQAXvafNolRB110=
X-Google-Smtp-Source: ABdhPJw+oat9TzFfSTgsYFB+Vf4ZqawwlYwdDnyJTgKJSotBO+zfX9B5XK3HUrtyeQSvu5BZU8LGaw5S/kZxqYu/E+Y=
X-Received: by 2002:a02:bb8d:: with SMTP id g13mr5383663jan.103.1642208562404;
 Fri, 14 Jan 2022 17:02:42 -0800 (PST)
MIME-Version: 1.0
References: <164199616622.1247129.783024987490980883.stgit@devnote2>
 <Yd77SYWgtrkhFIYz@krava> <YeAatqQTKsrxmUkS@krava> <20220114234704.41f28e8b5e63368c655d848e@kernel.org>
 <YeGSeGVnBnEHXTtj@krava>
In-Reply-To: <YeGSeGVnBnEHXTtj@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 14 Jan 2022 17:02:31 -0800
Message-ID: <CAEf4Bza01kwiKPyXqDD17grVw9WAQT_MztoTsd0tMd2XuuGteQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/8] fprobe: Introduce fprobe function entry/exit probe
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 7:10 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Fri, Jan 14, 2022 at 11:47:04PM +0900, Masami Hiramatsu wrote:
> > Hi Jiri and Alexei,
> >
> > On Thu, 13 Jan 2022 13:27:34 +0100
> > Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > > On Wed, Jan 12, 2022 at 05:01:15PM +0100, Jiri Olsa wrote:
> > > > On Wed, Jan 12, 2022 at 11:02:46PM +0900, Masami Hiramatsu wrote:
> > > > > Hi Jiri and Alexei,
> > > > >
> > > > > Here is the 2nd version of fprobe. This version uses the
> > > > > ftrace_set_filter_ips() for reducing the registering overhead.
> > > > > Note that this also drops per-probe point private data, which
> > > > > is not used anyway.
> > > > >
> > > > > This introduces the fprobe, the function entry/exit probe with
> > > > > multiple probe point support. This also introduces the rethook
> > > > > for hooking function return as same as kretprobe does. This
> > > >
> > > > nice, I was going through the multi-user-graph support
> > > > and was wondering that this might be a better way
> > > >
> > > > > abstraction will help us to generalize the fgraph tracer,
> > > > > because we can just switch it from rethook in fprobe, depending
> > > > > on the kernel configuration.
> > > > >
> > > > > The patch [1/8] and [7/8] are from your series[1]. Other libbpf
> > > > > patches will not be affected by this change.
> > > >
> > > > I'll try the bpf selftests on top of this
> > >
> > > I'm getting crash and stall when running bpf selftests,
> > > the fprobe sample module works fine, I'll check on that
> >
> > I've tried to build tools/testing/selftests/bpf on my machine,
> > but I got below errors. Would you know how I can setup to build
> > the bpf selftests correctly? (I tried "make M=samples/bpf", but same result)
>
> what's your clang version? your distro might be behind,

If you have very recent Clang, decently recent pahole, and qemu, try
using vmtest.sh. That should build the kernel with all the necessary
kernel config options and start qemu image with that latest image and
build selftests. And even run selftests automatically.

> I'm using clang 14 compiled from sources:
>
>         $ /opt/clang/bin/clang --version
>         clang version 14.0.0 (https://github.com/llvm/llvm-project.git 9f8ffaaa0bddcefeec15a3df9858fd50b05fcbae)
>         Target: x86_64-unknown-linux-gnu
>         Thread model: posix
>         InstalledDir: /opt/clang/bin
>
> and compiling bpf selftests with:
>
>         $ CLANG=/opt/clang/bin/clang make
>
> jirka
>
>
> >

[...]

> >
> > Thank you,
> >
> > --
> > Masami Hiramatsu <mhiramat@kernel.org>
> >
>
