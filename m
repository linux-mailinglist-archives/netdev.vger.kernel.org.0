Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D60A2AE4CD
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 01:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732090AbgKKARS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 19:17:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbgKKARS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 19:17:18 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3CBC0613D1;
        Tue, 10 Nov 2020 16:17:17 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id c18so230470ybj.10;
        Tue, 10 Nov 2020 16:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yaUVkE6ga6OeEMKnSxu8Z7wIpa/rKvADpYWxBqJ5R2k=;
        b=IrWyN6Hnd83VMEzNx0TgYcwRpPRMNUyrJUF5mJxSVhDhiEZCLYS0PKTcjOi96uupGt
         XFc6xLSGBqorYjHf9jdTcn6srrW67S1gebp9aAy88IXlLVEQoJHcWp5XukycOb4DFGgC
         +LJsb9r+DGYVY9VZEBD9lO6o6pOV2WHYvKvXb1wZpof0IcF0lnAYrHxU4i+y1Ze+x9Vw
         4iyeuTQGf2iR5E8xmfDibaFM2ALKD81NA/ikwao7ppvOG3WeEOExuzjP1UT8Jh+eX1AT
         HZ56fNJ4YURYJoGOY5BwmYwHLipEv7xpLOpOZFquJXngG6Jc0qWcswoC0j6Bv7uXqXPp
         wnBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yaUVkE6ga6OeEMKnSxu8Z7wIpa/rKvADpYWxBqJ5R2k=;
        b=BaUpCMyjIGRCzV7nxTLfNPxdNzgDMgvNxbu6unqtnlo/xCd+KFqUlK+K7QyB/3cHr5
         RhUq0G8dYhH9n2eGKIqA/NwkLsaN/P0SNl0SZlb7vJtOFMNnN1YcInTiO9YWn+Qb5URG
         d/LJsHXbLALke7n8Mg0xTpL2wEF0VcV2iWdu0oat7+niTlt4nQdHULKlpRWKRueymiFJ
         cv9LUvXCQbsFiNlAvQHzUMZXkMVOB21GyC3+XMH8q158ndr1IwUdwRt2P0gaA2Ph/06L
         NlAxt0qSIO1Naqdk0/JMmE88QLtKcP8+L3hgXN1bYlB1K863uQaQaOPU3zRW3AdX+lle
         e0mQ==
X-Gm-Message-State: AOAM533OVhErg0MfcnAbb009h6Hn37Bga1f4+FV44W+0+8pdOkq93XyA
        ikUSGBOYqUv2sQRtpcp/FDR2vS7ceEsB0cvShRHkuRJzEQIa2Q==
X-Google-Smtp-Source: ABdhPJw5/afo/wTqM7PWAxxtJ3piAGuSGh7bJ6TD3pUqiPNFt0YUfmXM0BaJKz/TWdnfZ4o5JQGpXEqV/vUTJOokC7I=
X-Received: by 2002:a25:df8e:: with SMTP id w136mr4125771ybg.230.1605053837177;
 Tue, 10 Nov 2020 16:17:17 -0800 (PST)
MIME-Version: 1.0
References: <20201106220750.3949423-1-kafai@fb.com> <20201106220803.3950648-1-kafai@fb.com>
 <CAEf4BzaQMcnALQ3rPErQJxVjL-Mi8zB8aSBkL8bkR8mtivro+g@mail.gmail.com>
 <20201107015225.o7hm7oxpndqueae4@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzbRXvWdEXC3GdT4Q_dYe6=VPymyDws5QV8wLkdnSONghQ@mail.gmail.com>
 <5fa9a741dc362_8c0e20827@john-XPS-13-9370.notmuch> <CACYkzJ4Jdabs5ot7TnHmeq2x+ULhuPuw8wwbR2gQzi22c3N_7A@mail.gmail.com>
 <20201110234325.kk7twlyu5ejvde6e@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzZs+5xdA0ZEct6cXSgF294RATnn8TmAfaJrBX+kvc6Gxg@mail.gmail.com> <20201111000651.fmsuax3fuzcn5v6s@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201111000651.fmsuax3fuzcn5v6s@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 10 Nov 2020 16:17:06 -0800
Message-ID: <CAEf4BzY0nCXaShyxivyvC0zqGo=JSDazAOGoHVUrr4Dv2Lugiw@mail.gmail.com>
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

On Tue, Nov 10, 2020 at 4:07 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, Nov 10, 2020 at 03:53:13PM -0800, Andrii Nakryiko wrote:
> > On Tue, Nov 10, 2020 at 3:43 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > On Tue, Nov 10, 2020 at 11:01:12PM +0100, KP Singh wrote:
> > > > On Mon, Nov 9, 2020 at 9:32 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > > > >
> > > > > Andrii Nakryiko wrote:
> > > > > > On Fri, Nov 6, 2020 at 5:52 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > > >
> > > > > > > On Fri, Nov 06, 2020 at 05:14:14PM -0800, Andrii Nakryiko wrote:
> > > > > > > > On Fri, Nov 6, 2020 at 2:08 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > > > > >
> > > > > > > > > This patch enables the FENTRY/FEXIT/RAW_TP tracing program to use
> > > > > > > > > the bpf_sk_storage_(get|delete) helper, so those tracing programs
> > > > > > > > > can access the sk's bpf_local_storage and the later selftest
> > > > > > > > > will show some examples.
> > > > > > > > >
> > > > > > > > > The bpf_sk_storage is currently used in bpf-tcp-cc, tc,
> > > > > > > > > cg sockops...etc which is running either in softirq or
> > > > > > > > > task context.
> > > > > > > > >
> > > > > > > > > This patch adds bpf_sk_storage_get_tracing_proto and
> > > > > > > > > bpf_sk_storage_delete_tracing_proto.  They will check
> > > > > > > > > in runtime that the helpers can only be called when serving
> > > > > > > > > softirq or running in a task context.  That should enable
> > > > > > > > > most common tracing use cases on sk.
> > > > > > > > >
> > > > > > > > > During the load time, the new tracing_allowed() function
> > > > > > > > > will ensure the tracing prog using the bpf_sk_storage_(get|delete)
> > > > > > > > > helper is not tracing any *sk_storage*() function itself.
> > > > > > > > > The sk is passed as "void *" when calling into bpf_local_storage.
> > > > > > > > >
> > > > > > > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > > > > > > ---
> > > > > > > > >  include/net/bpf_sk_storage.h |  2 +
> > > > > > > > >  kernel/trace/bpf_trace.c     |  5 +++
> > > > > > > > >  net/core/bpf_sk_storage.c    | 73 ++++++++++++++++++++++++++++++++++++
> > > > > > > > >  3 files changed, 80 insertions(+)
> > > > > > > > >
> > > > > > > >
> > > > > > > > [...]
> > > > > > > >
> > > > > > > > > +       switch (prog->expected_attach_type) {
> > > > > > > > > +       case BPF_TRACE_RAW_TP:
> > > > > > > > > +               /* bpf_sk_storage has no trace point */
> > > > > > > > > +               return true;
> > > > > > > > > +       case BPF_TRACE_FENTRY:
> > > > > > > > > +       case BPF_TRACE_FEXIT:
> > > > > > > > > +               btf_vmlinux = bpf_get_btf_vmlinux();
> > > > > > > > > +               btf_id = prog->aux->attach_btf_id;
> > > > > > > > > +               t = btf_type_by_id(btf_vmlinux, btf_id);
> > > > > > > > > +               tname = btf_name_by_offset(btf_vmlinux, t->name_off);
> > > > > > > > > +               return !strstr(tname, "sk_storage");
> > > > > > > >
> > > > > > > > I'm always feeling uneasy about substring checks... Also, KP just
> > > > > > > > fixed the issue with string-based checks for LSM. Can we use a
> > > > > > > > BTF_ID_SET of blacklisted functions instead?
> > > > > > > KP one is different.  It accidentally whitelist-ed more than it should.
> > > > > > >
> > > > > > > It is a blacklist here.  It is actually cleaner and safer to blacklist
> > > > > > > all functions with "sk_storage" and too pessimistic is fine here.
> > > > > >
> > > > > > Fine for whom? Prefix check would be half-bad, but substring check is
> > > > > > horrible. Suddenly "task_storage" (and anything related) would be also
> > > > > > blacklisted. Let's do a prefix check at least.
> > > > > >
> > > > >
> > > > > Agree, prefix check sounds like a good idea. But, just doing a quick
> > > > > grep seems like it will need at least bpf_sk_storage and sk_storage to
> > > > > catch everything.
> > > >
> > > > Is there any reason we are not using BTF ID sets and an allow list similar
> > > > to bpf_d_path helper? (apart from the obvious inconvenience of
> > > > needing to update the set in the kernel)
> > > It is a blacklist here, a small recap from commit message.
> > >
> > > > During the load time, the new tracing_allowed() function
> > > > will ensure the tracing prog using the bpf_sk_storage_(get|delete)
> > > > helper is not tracing any *sk_storage*() function itself.
> > > > The sk is passed as "void *" when calling into bpf_local_storage.
> > >
> > > Both BTF_ID and string-based (either prefix/substr) will work.
> > >
> > > The intention is to first disallow a tracing program from tracing
> > > any function in bpf_sk_storage.c and also calling the
> > > bpf_sk_storage_(get|delete) helper at the same time.
> > > This blacklist can be revisited later if there would
> > > be a use case in some of the blacklist-ed
> > > functions (which I doubt).
> > >
> > > To use BTF_ID, it needs to consider about if the current (and future)
> > > bpf_sk_storage function can be used in BTF_ID or not:
> > > static, global/external, or inlined.
> > >
> > > If BTF_ID is the best way for doing all black/white list, I don't mind
> > > either.  I could force some to inline and we need to remember
> > > to revisit the blacklist when the scope of fentry/fexit tracable
> > > function changed, e.g. when static function becomes traceable
> >
> > You can consider static functions traceable already. Arnaldo landed a
> > change a day or so ago in pahole that exposes static functions in BTF
> > and makes it possible to fentry/fexit attach them.
> Good to know.
>
> Is all static traceable (and can be used in BTF_ID)?

Only those that end up not inlined, I think. Similarly as with
kprobes. pahole actually checks mcount section to keep only those that
are attachable with ftrace. See [0] for patches.

  [0] https://patchwork.kernel.org/project/netdevbpf/list/?series=379377&state=*
