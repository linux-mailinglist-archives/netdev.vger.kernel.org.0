Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245CF299A46
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 00:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403983AbgJZXQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 19:16:01 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:39778 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403923AbgJZXQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 19:16:00 -0400
Received: by mail-yb1-f196.google.com with SMTP id 67so9114929ybt.6;
        Mon, 26 Oct 2020 16:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LiJKb3rNHBHV0g7paRfDUdXaN166fPs4Ik4Tz+yATK0=;
        b=iURVlDor88SLf82CltlomOnUANa+7QQb3IeWZOQvArzvXKS229Il58ujiKPOCJzNQ3
         AESC8KWJZtAyXQENZ5M2/jvbHfQ817NtQTj4WBO9aCWxbDCbx1IyuDt+H1WBZaV/M2Ja
         FpGmFHfOUv2S7dPGzX/NkcYpd+mAm92+SzC45oE675rvnkCwbTxgp200ylm+5v6tW2f/
         ZwrrL25tXkSPRji5KKpj9U4+ZiXl8O/kI4ylE1k+xW+7dxpakudibl3VCij5SCK38sSI
         CBaQvReoQc1+emo/5a2VO7X/oV0ROg7K+/WCO3cXF5K3mRUkIYwPZSMUUrgEad3hHG4D
         w1bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LiJKb3rNHBHV0g7paRfDUdXaN166fPs4Ik4Tz+yATK0=;
        b=q6VF8nra0+WfemfWE1Ylqwj7IX4sfKS2X+smkCRE14zTWL5XnWDPgZYQLZl/38FQr7
         k3Ts64zEsM9JkOVhoKAlybs66PolLg1Cfl1m3x2KGEsIICzvBqYvbYIQ6qku6M/P7/34
         q/XKhj3upeEEhMskjo7dZup4bW0gL7fQCBdMKDlSCRaRdTkHNtF59Dv+il+dvytzJX0T
         YRszJYkL5E+QzYdkIeSJclbkWv+v4eC5a/v5Y4412bXDrMRXOo7eSFsbtpT36mPhfPSi
         uk/U1QqxeI0zo3OP0nJdBKUlRme3wV6RZZ4whj7MOAq0+G+PHqh+wpKGzKD8OW5Crv0n
         Yjdw==
X-Gm-Message-State: AOAM531SAWzGGgVqfQgD56pacKiyAooWd9xJWf0BsJLu3FD3ZkDd80HX
        RYC8ry/+Va/26dNqVA6aZKxuQO18bour2zvKJQI=
X-Google-Smtp-Source: ABdhPJwN7RDFpaAh7FEHa6HVCTg6ng/kDVHVGpnw5GRCqCNrGhGaEiMVvDfF1S6aCS3TSxWqtRXue5ByGiXwSgGxSyI=
X-Received: by 2002:a25:cb10:: with SMTP id b16mr24100302ybg.459.1603754158866;
 Mon, 26 Oct 2020 16:15:58 -0700 (PDT)
MIME-Version: 1.0
References: <20201022082138.2322434-1-jolsa@kernel.org> <20201022082138.2322434-14-jolsa@kernel.org>
 <CAEf4Bzbch2SGNwG-tTUT6pPdDCsFyGPbS1Zkx4f6-nLmcv+wOA@mail.gmail.com> <20201025191147.GC2681365@krava>
In-Reply-To: <20201025191147.GC2681365@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 26 Oct 2020 16:15:48 -0700
Message-ID: <CAEf4BzaJByux3tJ=r47pj4SSzbDEShTW6yBVJg+g1sWsLerdbQ@mail.gmail.com>
Subject: Re: [RFC bpf-next 13/16] libbpf: Add trampoline batch attach support
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jesper Brouer <jbrouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 25, 2020 at 12:12 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Fri, Oct 23, 2020 at 01:09:26PM -0700, Andrii Nakryiko wrote:
> > On Thu, Oct 22, 2020 at 2:03 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > Adding trampoline batch attach support so it's possible to use
> > > batch mode to load tracing programs.
> > >
> > > Adding trampoline_attach_batch bool to struct bpf_object_open_opts.
> > > When set to true the bpf_object__attach_skeleton will try to load
> > > all tracing programs via batch mode.
> > >
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> >
> > Assuming we go with the current kernel API for batch-attach, why can't
> > libbpf just detect kernel support for it and just use it always,
> > without requiring users to opt into anything?
>
> yea, it's rfc ;-) I wanted some simple usage of the
> interface so it's obvious how it works
>
> if we'll end up with some batch interface I agree
> we should use it as you suggested
>
> >
> > But I'm also confused a bit how this is supposed to be used with BPF
> > skeleton. You use case described in a cover letter (bpftrace glob
> > attach, right?) would have a single BPF program attached to many
> > different functions. While here you are trying to collect different
> > programs and attach each one to its respective kernel function. Do you
> > expect users to have hundreds of BPF programs in their skeletons? If
> > not, I don't really see why adding this complexity. What am I missing?
>
> AFAIU when you use trampoline program you declare the attach point
> at the load time, so you actually can't use same program for different
> kernel functions - which would be great speed up actually, because
> that's where the rest of the cycles in bpftrace is spent (in that cover
> letter example) - load/verifier check of all those programs

Ah, I see, you are right. And yes, I agree, it would be nice to not
have to clone the BPF program many times to attach to fentry/fexit, if
the program itself doesn't really change.

>
> it's different for kprobe where you hook single kprobe via multiple
> kprobe perf events to different kernel function
>
> >
> > Now it also seems weird to me for the kernel API to allow attaching
> > many-to-many BPF programs-to-attach points. One BPF program-to-many
> > attach points seems like a more sane and common requirement, no?
>
> right, but that's the consequence of what I wrote above

Well, maybe we should get rid of that limitation first ;)

>
> jirka
>
> >
> >
> > >  tools/lib/bpf/bpf.c      | 12 +++++++
> > >  tools/lib/bpf/bpf.h      |  1 +
> > >  tools/lib/bpf/libbpf.c   | 76 +++++++++++++++++++++++++++++++++++++++-
> > >  tools/lib/bpf/libbpf.h   |  5 ++-
> > >  tools/lib/bpf/libbpf.map |  1 +
> > >  5 files changed, 93 insertions(+), 2 deletions(-)
> > >
> >
> > [...]
> >
>
