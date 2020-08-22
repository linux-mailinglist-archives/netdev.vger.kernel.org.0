Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE8524E631
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 09:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgHVHzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 03:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727802AbgHVHzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 03:55:20 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D20C061573;
        Sat, 22 Aug 2020 00:55:20 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id u6so2303998ybf.1;
        Sat, 22 Aug 2020 00:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3FGIc23gIcAL+scd1gVHTER4ApVxnptisLCy0nOA3ec=;
        b=RSzSqkuk2hxMrHDgNEpuWCYiDfGZ3ACWe7ZA3ruJMeA/Y1jKDRp2N7eo+K+HWkuOhT
         NEcgA6U5EZ4g9jrmuDDYJ0DsiA7/FYDxn5Xb7wvxwT5aguFaEuF3VCxgfovw8q00cD1i
         V1hPb1wxj3LBqItsJYj0Rw7VzzMLfjgN48w9XQM33H3lzwL2rpXw4uA/JOzicBnQ1zyT
         5NzldIftdoAo9G3m/c9gFEBsTu0D4LTmeLNgYvb8etkJViKZvvJ3hmTeHq+I8Im5DxLJ
         a8teefzkh2SOisuAnh4eXkzwDO07XgfG1v996L6RAHFY94ECcBvIUHBQB00bIQDYqIdJ
         JT4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3FGIc23gIcAL+scd1gVHTER4ApVxnptisLCy0nOA3ec=;
        b=gVPLfIz4RPt+AjN5bPhwkZe2tFtjhc2VphtVUT2C5OScSTas1GwVOLyMDYefoq4iqJ
         ss5kQPEtYaFhHGqypHUnvJ0XIlIckZhtLImAprD96m5LwNdQh68n1Ui/Z06LJ7o+v/ht
         0liPYi5irNEWaM8PNEAXnhdAHdJZsGc/T4EUxXYLu+XHRIImpJRlOZg5pppy/49F5/as
         h10IHzK1iG5bL7mUl8ZxCpr/BTn9zRi5bd+WaTRAK36dOCg3eX7btHHOJz4LkCsNbFLX
         NS0Kd0uv1HomdZHVEzNGqTk5VhV3cgt6atiygTpOY8wbdrHo/39G+a1qeVMploQlpLyf
         xeJw==
X-Gm-Message-State: AOAM533cFpRr2doHB+ILD2Gsqf9hC+JSQBut+z++UqpqjWTiuXBitrmS
        ASLwd88UK8wDKcMub6HEzrd8c0DlmUqgsx2BC7U=
X-Google-Smtp-Source: ABdhPJwlkJniKwUnZRzObGLsXHNYy3Kczys5fZJbeSKZ6lFpfoqfikT6wmGUzFODlcdPWsMox3Zwhh+ziW5xQAAFHIo=
X-Received: by 2002:a25:bc50:: with SMTP id d16mr7987916ybk.230.1598082919371;
 Sat, 22 Aug 2020 00:55:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200819224030.1615203-1-haoluo@google.com> <20200819224030.1615203-7-haoluo@google.com>
 <CAEf4BzZY2LyJvF9HCdAzHM7WG26GO0qqX=Wc6EiXArks=kmazA@mail.gmail.com>
 <CAEf4BzZ+uqE73tM6W1vXyc-hu6fB8B9ZNniq-XHYhFDjhHg9gA@mail.gmail.com> <CA+khW7jQmdw-TZMnST_rBcQWmxZ_eVw4ja+nsrqCM9HSkeWaXQ@mail.gmail.com>
In-Reply-To: <CA+khW7jQmdw-TZMnST_rBcQWmxZ_eVw4ja+nsrqCM9HSkeWaXQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 22 Aug 2020 00:55:08 -0700
Message-ID: <CAEf4BzZwtpvBSE=00XyHGr2p2OD6X_rwnntwvSZBjGvZUEZKCA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 6/8] bpf: Introduce bpf_per_cpu_ptr()
To:     Hao Luo <haoluo@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Andrey Ignatov <rdna@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 22, 2020 at 12:49 AM Hao Luo <haoluo@google.com> wrote:
>
> On Fri, Aug 21, 2020 at 8:31 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Fri, Aug 21, 2020 at 8:26 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Wed, Aug 19, 2020 at 3:42 PM Hao Luo <haoluo@google.com> wrote:
> > > >
> > > > Add bpf_per_cpu_ptr() to help bpf programs access percpu vars.
> > > > bpf_per_cpu_ptr() has the same semantic as per_cpu_ptr() in the kernel
> > > > except that it may return NULL. This happens when the cpu parameter is
> > > > out of range. So the caller must check the returned value.
> > > >
> > > > Signed-off-by: Hao Luo <haoluo@google.com>
> > > > ---
> > >
> > > The logic looks correct, few naming nits, but otherwise:
> > >
> > > Acked-by: Andrii Nakryiko <andriin@fb.com>
> > >
> > > >  include/linux/bpf.h      |  3 ++
> > > >  include/linux/btf.h      | 11 +++++++
> > > >  include/uapi/linux/bpf.h | 14 +++++++++
> > > >  kernel/bpf/btf.c         | 10 -------
> > > >  kernel/bpf/verifier.c    | 64 ++++++++++++++++++++++++++++++++++++++--
> > > >  kernel/trace/bpf_trace.c | 18 +++++++++++
> > > >  6 files changed, 107 insertions(+), 13 deletions(-)
> [...]
> >
> > btw, having bpf_this_cpu_ptr(const void *ptr) seems worthwhile as well, WDYT?
> >
>
> It's probably not a good idea, IMHO. How does it interact with
> preemption? Should we treat it as __this_cpu_ptr()? If so, I feel it's
> easy to be misused, if the bpf program is called in a preemptible
> context.
>
> Btw, is bpf programs always called with preemption disabled? How about
> interrupts? I haven't thought about these questions before but I think
> they matter as we start to have more ways for bpf programs to interact
> with the kernel.

non-sleepable BPF is always disabling CPU migration, so there is no
problem with this_cpu_ptr. For sleepable not sure, but we can disable
this helper for sleepable BPF programs, if that's a problem.

>
> Best,
> Hao
