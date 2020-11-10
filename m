Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC5F42AE46D
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 00:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732213AbgKJXxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 18:53:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726737AbgKJXx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 18:53:26 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE85EC0613D1;
        Tue, 10 Nov 2020 15:53:25 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id k65so206566ybk.5;
        Tue, 10 Nov 2020 15:53:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CFVjI9psbv9SrzXA1Z8O+LAI56KyAI/6Hccpp2X9J78=;
        b=rljrBIcmDdroOs928+6LLb6K14EhQ0lZGw7kK+dXUCcRaWUCugcNIvpuzg3qSh5WFp
         7FM1Got/8sgN0VQGvaNuu8hI57MOoyeBXFPjYHhz+xALSTzyTTAjmtYBt++P75z4Lf3q
         Dn+CQdZxKstAhlZ311nbTPpCLLAZZCURfY3Pqyy+Fv2p57CH+uiBAlye/cngUGkIlIWA
         RDQkC032eDZj6cBP1yQpaGsgqntfMtfov67DT8YHIauWeidsoa6tl9pOLLkgwDPFcIy4
         k6315fm8vkjryQMAP5yPArFzJvqySHpxU8ivQxZ74/oqkweWQ9Fs38VwPHxAQSnnKIVj
         xfTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CFVjI9psbv9SrzXA1Z8O+LAI56KyAI/6Hccpp2X9J78=;
        b=AHiXng7ZOmXZRdfD7Qrs08N22unHEp7y63Q6p5GjwDtiIeKZ+a87xTqjL+6WV9wQ+l
         5/nOU3jTzCGeqG04lc7WO37TmClc99MXn9dLh2IfSE1CWk0OThe4BXYhLN3p5AGFmJHz
         vVPEgdr5R3V9hpq9526FrpyGIh70Fy7OJG1TivBqCH3AaEm2dIaDGjqSUBgYjDykjaKu
         HCkSRNvunfEarYzdOgltChxGhA8cPTLHrDGRiM82dcSfWLXsOPlF9nMjkKkbp5uokoQs
         fXU12o0p2vbj6vNbRN0NBjrI05YTpIV6I/YU8wR0rNcZ6zIDXOowPWCfnjQB6+nGXBPk
         3V8w==
X-Gm-Message-State: AOAM5307g8P/VtEipUDvNunb3+hlpyRkjzd6hSY0uuSsSUu0382GmFO5
        n1uVnUkPxar+T6oCGnZ3Xr9K9Sf9bwib+oCJJUE=
X-Google-Smtp-Source: ABdhPJx5ABjySl8kwKH9doRd8ngaoiFp7Uwv6Sw9o6Yu3RSyvq/+hixsozk1Lxd4yjs64E9VrWVNBA0hMcdZe0pS8YY=
X-Received: by 2002:a25:bd7:: with SMTP id 206mr17035485ybl.84.1605052404999;
 Tue, 10 Nov 2020 15:53:24 -0800 (PST)
MIME-Version: 1.0
References: <20201106220750.3949423-1-kafai@fb.com> <20201106220803.3950648-1-kafai@fb.com>
 <CAEf4BzaQMcnALQ3rPErQJxVjL-Mi8zB8aSBkL8bkR8mtivro+g@mail.gmail.com>
 <20201107015225.o7hm7oxpndqueae4@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzbRXvWdEXC3GdT4Q_dYe6=VPymyDws5QV8wLkdnSONghQ@mail.gmail.com>
 <5fa9a741dc362_8c0e20827@john-XPS-13-9370.notmuch> <CACYkzJ4Jdabs5ot7TnHmeq2x+ULhuPuw8wwbR2gQzi22c3N_7A@mail.gmail.com>
 <20201110234325.kk7twlyu5ejvde6e@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201110234325.kk7twlyu5ejvde6e@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 10 Nov 2020 15:53:13 -0800
Message-ID: <CAEf4BzZs+5xdA0ZEct6cXSgF294RATnn8TmAfaJrBX+kvc6Gxg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] bpf: Allow using bpf_sk_storage in FENTRY/FEXIT/RAW_TP
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     KP Singh <kpsingh@chromium.org>,
        John Fastabend <john.fastabend@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 3:43 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, Nov 10, 2020 at 11:01:12PM +0100, KP Singh wrote:
> > On Mon, Nov 9, 2020 at 9:32 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > >
> > > Andrii Nakryiko wrote:
> > > > On Fri, Nov 6, 2020 at 5:52 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > >
> > > > > On Fri, Nov 06, 2020 at 05:14:14PM -0800, Andrii Nakryiko wrote:
> > > > > > On Fri, Nov 6, 2020 at 2:08 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > > >
> > > > > > > This patch enables the FENTRY/FEXIT/RAW_TP tracing program to use
> > > > > > > the bpf_sk_storage_(get|delete) helper, so those tracing programs
> > > > > > > can access the sk's bpf_local_storage and the later selftest
> > > > > > > will show some examples.
> > > > > > >
> > > > > > > The bpf_sk_storage is currently used in bpf-tcp-cc, tc,
> > > > > > > cg sockops...etc which is running either in softirq or
> > > > > > > task context.
> > > > > > >
> > > > > > > This patch adds bpf_sk_storage_get_tracing_proto and
> > > > > > > bpf_sk_storage_delete_tracing_proto.  They will check
> > > > > > > in runtime that the helpers can only be called when serving
> > > > > > > softirq or running in a task context.  That should enable
> > > > > > > most common tracing use cases on sk.
> > > > > > >
> > > > > > > During the load time, the new tracing_allowed() function
> > > > > > > will ensure the tracing prog using the bpf_sk_storage_(get|delete)
> > > > > > > helper is not tracing any *sk_storage*() function itself.
> > > > > > > The sk is passed as "void *" when calling into bpf_local_storage.
> > > > > > >
> > > > > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > > > > ---
> > > > > > >  include/net/bpf_sk_storage.h |  2 +
> > > > > > >  kernel/trace/bpf_trace.c     |  5 +++
> > > > > > >  net/core/bpf_sk_storage.c    | 73 ++++++++++++++++++++++++++++++++++++
> > > > > > >  3 files changed, 80 insertions(+)
> > > > > > >
> > > > > >
> > > > > > [...]
> > > > > >
> > > > > > > +       switch (prog->expected_attach_type) {
> > > > > > > +       case BPF_TRACE_RAW_TP:
> > > > > > > +               /* bpf_sk_storage has no trace point */
> > > > > > > +               return true;
> > > > > > > +       case BPF_TRACE_FENTRY:
> > > > > > > +       case BPF_TRACE_FEXIT:
> > > > > > > +               btf_vmlinux = bpf_get_btf_vmlinux();
> > > > > > > +               btf_id = prog->aux->attach_btf_id;
> > > > > > > +               t = btf_type_by_id(btf_vmlinux, btf_id);
> > > > > > > +               tname = btf_name_by_offset(btf_vmlinux, t->name_off);
> > > > > > > +               return !strstr(tname, "sk_storage");
> > > > > >
> > > > > > I'm always feeling uneasy about substring checks... Also, KP just
> > > > > > fixed the issue with string-based checks for LSM. Can we use a
> > > > > > BTF_ID_SET of blacklisted functions instead?
> > > > > KP one is different.  It accidentally whitelist-ed more than it should.
> > > > >
> > > > > It is a blacklist here.  It is actually cleaner and safer to blacklist
> > > > > all functions with "sk_storage" and too pessimistic is fine here.
> > > >
> > > > Fine for whom? Prefix check would be half-bad, but substring check is
> > > > horrible. Suddenly "task_storage" (and anything related) would be also
> > > > blacklisted. Let's do a prefix check at least.
> > > >
> > >
> > > Agree, prefix check sounds like a good idea. But, just doing a quick
> > > grep seems like it will need at least bpf_sk_storage and sk_storage to
> > > catch everything.
> >
> > Is there any reason we are not using BTF ID sets and an allow list similar
> > to bpf_d_path helper? (apart from the obvious inconvenience of
> > needing to update the set in the kernel)
> It is a blacklist here, a small recap from commit message.
>
> > During the load time, the new tracing_allowed() function
> > will ensure the tracing prog using the bpf_sk_storage_(get|delete)
> > helper is not tracing any *sk_storage*() function itself.
> > The sk is passed as "void *" when calling into bpf_local_storage.
>
> Both BTF_ID and string-based (either prefix/substr) will work.
>
> The intention is to first disallow a tracing program from tracing
> any function in bpf_sk_storage.c and also calling the
> bpf_sk_storage_(get|delete) helper at the same time.
> This blacklist can be revisited later if there would
> be a use case in some of the blacklist-ed
> functions (which I doubt).
>
> To use BTF_ID, it needs to consider about if the current (and future)
> bpf_sk_storage function can be used in BTF_ID or not:
> static, global/external, or inlined.
>
> If BTF_ID is the best way for doing all black/white list, I don't mind
> either.  I could force some to inline and we need to remember
> to revisit the blacklist when the scope of fentry/fexit tracable
> function changed, e.g. when static function becomes traceable

You can consider static functions traceable already. Arnaldo landed a
change a day or so ago in pahole that exposes static functions in BTF
and makes it possible to fentry/fexit attach them.

> later.  The future changes to bpf_sk_storage.c will need to
> adjust this list also.
