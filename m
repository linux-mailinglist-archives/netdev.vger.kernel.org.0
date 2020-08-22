Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABFB24E629
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 09:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgHVHtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 03:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbgHVHtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 03:49:35 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B7C5C061574
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 00:49:34 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id l23so3448854edv.11
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 00:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ucDpivhSHRtEV7HP6/CuGlE8yRxOlZBKt8o/Etn070o=;
        b=RzJpaGeivfYrZB6/8QpMgePNgXSZgxvjjCmNdgzLkTFuK2BCrKzDyGmo+dCwY81gUe
         KQfdvuLcJF3/ThhUGTD10KOF053iWUDlb5u8fvCSmrbtUEX4U5Y7DT4o9QiVvGFQzBjU
         UlWqeq+aPsyqwtVdAvBmnSYOoqVQIMiLzu6+4D8IxS/7UYEefiVANyf/vc4G1ZaY4cpt
         5xywE/sKNUurpiR0fiYcKqPZ/n550px8T14eAy0ayieaDNz73uPwLXVdQ2iAyCw3wjPR
         PfAjnJrCU+g4zGt49Zeb60V/97lXpHYWNnhaiGSdhJAP0IsHgv+7E1Mim6Bc8V3Cfr/w
         W87Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ucDpivhSHRtEV7HP6/CuGlE8yRxOlZBKt8o/Etn070o=;
        b=AZg/VqERRtDatWPPiU0mcXPy+LzkLZ0w7aDK/S40h5wfUezWcApaGziqSoOAybafYU
         yPP/9ouZ97hdL08V9G4QI7IUp+euEhTYBcUc0V/KB5O+SniS3SHT48qIjdo56qKdi+mN
         5YZg50N6nxG7qhmzJo90Iu6xPQjvAWgaCf8h8r9jj98mBdco2C64/YEfcJPH6eK/8D3N
         QqqRBwZ/TNpOmJteIu8Z1AfKpg7/yD2uJya2UtL1dzxtIOMrR7N+N/dcBvb8V78qBmoD
         Ada22UxQHqCNLDDagHovZJovWs8c/kHQmu1pcYxelFjJ6ktFFgBZBiV5ndpZ53aJKLvN
         7gFA==
X-Gm-Message-State: AOAM5327Ks+YAhE4ukZTEgVnO2hfRjiPhyRUVnMewslvJq2mndaseMng
        D+cJIJXE4Vj+oygQ6OkFd5V4E2nBC47DykqK3IDUGQ==
X-Google-Smtp-Source: ABdhPJwqwAO/SL6HH42pxzeRrtcM5ZSQQfJUp6NLAqYG4J83zPQVz9Wv76Syj3KgDpY3O1DUFaNHz5KBZJUmwY2rmSo=
X-Received: by 2002:a50:ee92:: with SMTP id f18mr6367467edr.80.1598082572822;
 Sat, 22 Aug 2020 00:49:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200819224030.1615203-1-haoluo@google.com> <20200819224030.1615203-7-haoluo@google.com>
 <CAEf4BzZY2LyJvF9HCdAzHM7WG26GO0qqX=Wc6EiXArks=kmazA@mail.gmail.com> <CAEf4BzZ+uqE73tM6W1vXyc-hu6fB8B9ZNniq-XHYhFDjhHg9gA@mail.gmail.com>
In-Reply-To: <CAEf4BzZ+uqE73tM6W1vXyc-hu6fB8B9ZNniq-XHYhFDjhHg9gA@mail.gmail.com>
From:   Hao Luo <haoluo@google.com>
Date:   Sat, 22 Aug 2020 00:49:21 -0700
Message-ID: <CA+khW7jQmdw-TZMnST_rBcQWmxZ_eVw4ja+nsrqCM9HSkeWaXQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 6/8] bpf: Introduce bpf_per_cpu_ptr()
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Fri, Aug 21, 2020 at 8:31 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Aug 21, 2020 at 8:26 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Aug 19, 2020 at 3:42 PM Hao Luo <haoluo@google.com> wrote:
> > >
> > > Add bpf_per_cpu_ptr() to help bpf programs access percpu vars.
> > > bpf_per_cpu_ptr() has the same semantic as per_cpu_ptr() in the kernel
> > > except that it may return NULL. This happens when the cpu parameter is
> > > out of range. So the caller must check the returned value.
> > >
> > > Signed-off-by: Hao Luo <haoluo@google.com>
> > > ---
> >
> > The logic looks correct, few naming nits, but otherwise:
> >
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> >
> > >  include/linux/bpf.h      |  3 ++
> > >  include/linux/btf.h      | 11 +++++++
> > >  include/uapi/linux/bpf.h | 14 +++++++++
> > >  kernel/bpf/btf.c         | 10 -------
> > >  kernel/bpf/verifier.c    | 64 ++++++++++++++++++++++++++++++++++++++--
> > >  kernel/trace/bpf_trace.c | 18 +++++++++++
> > >  6 files changed, 107 insertions(+), 13 deletions(-)
[...]
>
> btw, having bpf_this_cpu_ptr(const void *ptr) seems worthwhile as well, WDYT?
>

It's probably not a good idea, IMHO. How does it interact with
preemption? Should we treat it as __this_cpu_ptr()? If so, I feel it's
easy to be misused, if the bpf program is called in a preemptible
context.

Btw, is bpf programs always called with preemption disabled? How about
interrupts? I haven't thought about these questions before but I think
they matter as we start to have more ways for bpf programs to interact
with the kernel.

Best,
Hao
