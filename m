Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDFB02B7482
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 04:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgKRDEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 22:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbgKRDEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 22:04:44 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE0BC0613D4;
        Tue, 17 Nov 2020 19:04:44 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id s8so266347yba.13;
        Tue, 17 Nov 2020 19:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iRbmAywHDNueRKdeuUhZNpbWAVgCvINl7dg2GFG1n3k=;
        b=E3trQV8wy/eNGvtmZimNtsCb8Dv4a5BKI6pPUAzg6OWXT9zgNA/K6HQ5qgQg868ggG
         oSDKj/ogNmCFr3Ffkx+IMKxCSdyr2Zh4YONqw4wDXKh7OC35zd8Drk5AlrprUVQuk9JB
         +0KerD6VpL80sGUEallKiSd+WrDGi+zDID52GLMaoyOw6a6/JdVbnYkbDz+gpXdb64xo
         7XEHzTtr1FXv04Y64clgJX2IbHMC88/ZVZ95TE56Jq8/YKFNETddkFKhbzmraM3KwAbx
         vIyFTI6LBzWAY6ewf16ufZGIOrIZwmi/u5Bto66L6O4bMHmf9IfMzSB/IZ5BC6W2b1/4
         2Usw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iRbmAywHDNueRKdeuUhZNpbWAVgCvINl7dg2GFG1n3k=;
        b=NbeQkq+yFkF1OwdkcQBcu5vHMTdIUHy2lr4MkhAt1ICw8v5BLgY2KU3X/aDY2c0v++
         vG0D3cqSASCXv04c7DNbvhm8Vc0q9ykk6GdxyQB6ECJ5FUM2TWBx75k/Q9cFH974dZ8M
         fJbYJwTsCfeJAhu3KQmrttsyrqytg1RH+tx/9bSBXqhsrdfQVtCQ+7V8+vhuitdGa9FG
         fQel9hzpZt1IbujwMIQlp7ZtzZR9CMPBCkieFXrXY9tWCLXXab8SgCtEfTRcsAwMVulg
         m4u6SapSXohdvAMH26/lQGwtyAxHVmTWhbeHDRZ0f+eurnIeAWEasNUW1Ke56wobQ+x4
         YOQQ==
X-Gm-Message-State: AOAM533FXYO4xlFkPgW3hoMPPwELymaiWdDdBn1SGOaTrV5wZwtZfIwS
        G+ERqxikg/2+NxSVD7644BkPi75hHKRQM5gpGOE=
X-Google-Smtp-Source: ABdhPJx4RNXYPYXjte+dwwOp5bqg7fUFgAyEAYuEnN8JdnVE5B5pZ1cLsEyAmUYtrKLZPlogeJUNIr5QRSc1j17kVME=
X-Received: by 2002:a25:df8e:: with SMTP id w136mr3553019ybg.230.1605668683391;
 Tue, 17 Nov 2020 19:04:43 -0800 (PST)
MIME-Version: 1.0
References: <20201117145644.1166255-1-danieltimlee@gmail.com>
 <20201117145644.1166255-2-danieltimlee@gmail.com> <CAEf4BzZ9Sr0PXvZAa74phnwm7um9AoN4ELGkNBMvyzvh7vYzRQ@mail.gmail.com>
 <CAEKGpzhCeRZct-zW_DG0Aj_PD1FvtUOzbF5c134wwoGgqgf6rA@mail.gmail.com>
In-Reply-To: <CAEKGpzhCeRZct-zW_DG0Aj_PD1FvtUOzbF5c134wwoGgqgf6rA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 17 Nov 2020 19:04:32 -0800
Message-ID: <CAEf4BzZTiMpjzhm1=t1OQB+b=JRakTKLxJd2Z3skwtqkY5y8sw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/9] selftests: bpf: move tracing helpers to trace_helper
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 6:55 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> On Wed, Nov 18, 2020 at 10:58 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Nov 17, 2020 at 6:57 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> > >
> > > Under the samples/bpf directory, similar tracing helpers are
> > > fragmented around. To keep consistent of tracing programs, this commit
> > > moves the helper and define locations to increase the reuse of each
> > > helper function.
> > >
> > > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > >
> > > ---
> > > [...]
> > > -static void read_trace_pipe2(void)
> >
> > This is used only in hbm.c, why move it into trace_helpers.c?
> >
>
> I think this function can be made into a helper that can be used in
> other programs. Which is basically same as 'read_trace_pipe' and
> also writes the content of that pipe to file either. Well, it's not used
> anywhere else, but I moved this function for the potential of reuse.

Let's not make premature extraction of helpers. We generally add
helpers when we have a repeated need for them. It's not currently the
case for read_trace_pipe2().

>
> Since these 'read_trace_pipe's are helpers that are only used
> under samples directory, what do you think about moving these
> helpers to something like samples/bpf/trace_pipe.h?

Nope, not yet. I'd just drop this patch for now (see my comments on
another patch regarding DEBUGFS).

>
> Thanks for your time and effort for the review.
>
> --
> Best,
> Daniel T. Lee
