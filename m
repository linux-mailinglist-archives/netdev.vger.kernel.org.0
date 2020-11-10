Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E462AE26A
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 23:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731558AbgKJWBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 17:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726861AbgKJWBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 17:01:25 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 165FDC0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 14:01:25 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id f11so321001lfs.3
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 14:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6I0ovRVnA3Z6L2MZt96LNqSIDz8PayxfO+tqbmR3OQ0=;
        b=Ai/Gum3RRedHg5Y2P0B68dVoitQLEXjgRgHyEA+f9B8qkdDdIYuLcCSZ1SBay2E1Ez
         SYTY2aCD8mZ7spw2vsHKrybyOonVLry6MtZ/atSEL/B04JNPgJJALv97dVlLlnGsZ6fk
         pToxMFhX7xm2DxJQ+G9Qhlii0wgEYU13WyFJU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6I0ovRVnA3Z6L2MZt96LNqSIDz8PayxfO+tqbmR3OQ0=;
        b=QwEbmlYJcs3YdZvSZoy/jS2Ys8dJM/a82RKzQpjo8ruNPDrEdl6pMhhkEH0VoTIG5S
         vbayarPvfMXj8+XH8P6Y6+jcs5784p5z+H8cQtpGRlKWAjd6sWwyt/sEkPfih+ZJGo+y
         fUCN7vSjieAQohdmoEBNzehTHcpx3SpQJzELdJYW+9Sc0lFtI6kuuYtx+xXNhpGlpczK
         RdzWFUiPPew7RNlrxu8CaLVwxat+sy8UIEcYIljfsqQrThp0SdiosuRrwScbgGAEUuK8
         KPFFWZpx4iRz6sAkc5O6jXWcheeCDF4wuUfwFoSm16WGEX4/TIFh2yZ7exv7ATSVifFu
         I/bg==
X-Gm-Message-State: AOAM531tmxr3+wiN+/KHyryJzc+QyhF4A2a5K2jrMbHlVM1k5bfhpAHh
        +/COiQb0h3B2/VoYvmyx2o8UdBfv5W2OLK5aXjqk0A==
X-Google-Smtp-Source: ABdhPJwZmQ0+r51YSboHceiFvWNczUGJp3INyNXxG7VeGm1UBxzCbfTfgQTNiwTjrqJ0t0Dn09+okX12Fe/7XXTLyIQ=
X-Received: by 2002:ac2:43b4:: with SMTP id t20mr4414850lfl.146.1605045683469;
 Tue, 10 Nov 2020 14:01:23 -0800 (PST)
MIME-Version: 1.0
References: <20201106220750.3949423-1-kafai@fb.com> <20201106220803.3950648-1-kafai@fb.com>
 <CAEf4BzaQMcnALQ3rPErQJxVjL-Mi8zB8aSBkL8bkR8mtivro+g@mail.gmail.com>
 <20201107015225.o7hm7oxpndqueae4@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzbRXvWdEXC3GdT4Q_dYe6=VPymyDws5QV8wLkdnSONghQ@mail.gmail.com> <5fa9a741dc362_8c0e20827@john-XPS-13-9370.notmuch>
In-Reply-To: <5fa9a741dc362_8c0e20827@john-XPS-13-9370.notmuch>
From:   KP Singh <kpsingh@chromium.org>
Date:   Tue, 10 Nov 2020 23:01:12 +0100
Message-ID: <CACYkzJ4Jdabs5ot7TnHmeq2x+ULhuPuw8wwbR2gQzi22c3N_7A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] bpf: Allow using bpf_sk_storage in FENTRY/FEXIT/RAW_TP
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 9, 2020 at 9:32 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Andrii Nakryiko wrote:
> > On Fri, Nov 6, 2020 at 5:52 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > On Fri, Nov 06, 2020 at 05:14:14PM -0800, Andrii Nakryiko wrote:
> > > > On Fri, Nov 6, 2020 at 2:08 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > >
> > > > > This patch enables the FENTRY/FEXIT/RAW_TP tracing program to use
> > > > > the bpf_sk_storage_(get|delete) helper, so those tracing programs
> > > > > can access the sk's bpf_local_storage and the later selftest
> > > > > will show some examples.
> > > > >
> > > > > The bpf_sk_storage is currently used in bpf-tcp-cc, tc,
> > > > > cg sockops...etc which is running either in softirq or
> > > > > task context.
> > > > >
> > > > > This patch adds bpf_sk_storage_get_tracing_proto and
> > > > > bpf_sk_storage_delete_tracing_proto.  They will check
> > > > > in runtime that the helpers can only be called when serving
> > > > > softirq or running in a task context.  That should enable
> > > > > most common tracing use cases on sk.
> > > > >
> > > > > During the load time, the new tracing_allowed() function
> > > > > will ensure the tracing prog using the bpf_sk_storage_(get|delete)
> > > > > helper is not tracing any *sk_storage*() function itself.
> > > > > The sk is passed as "void *" when calling into bpf_local_storage.
> > > > >
> > > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > > ---
> > > > >  include/net/bpf_sk_storage.h |  2 +
> > > > >  kernel/trace/bpf_trace.c     |  5 +++
> > > > >  net/core/bpf_sk_storage.c    | 73 ++++++++++++++++++++++++++++++++++++
> > > > >  3 files changed, 80 insertions(+)
> > > > >
> > > >
> > > > [...]
> > > >
> > > > > +       switch (prog->expected_attach_type) {
> > > > > +       case BPF_TRACE_RAW_TP:
> > > > > +               /* bpf_sk_storage has no trace point */
> > > > > +               return true;
> > > > > +       case BPF_TRACE_FENTRY:
> > > > > +       case BPF_TRACE_FEXIT:
> > > > > +               btf_vmlinux = bpf_get_btf_vmlinux();
> > > > > +               btf_id = prog->aux->attach_btf_id;
> > > > > +               t = btf_type_by_id(btf_vmlinux, btf_id);
> > > > > +               tname = btf_name_by_offset(btf_vmlinux, t->name_off);
> > > > > +               return !strstr(tname, "sk_storage");
> > > >
> > > > I'm always feeling uneasy about substring checks... Also, KP just
> > > > fixed the issue with string-based checks for LSM. Can we use a
> > > > BTF_ID_SET of blacklisted functions instead?
> > > KP one is different.  It accidentally whitelist-ed more than it should.
> > >
> > > It is a blacklist here.  It is actually cleaner and safer to blacklist
> > > all functions with "sk_storage" and too pessimistic is fine here.
> >
> > Fine for whom? Prefix check would be half-bad, but substring check is
> > horrible. Suddenly "task_storage" (and anything related) would be also
> > blacklisted. Let's do a prefix check at least.
> >
>
> Agree, prefix check sounds like a good idea. But, just doing a quick
> grep seems like it will need at least bpf_sk_storage and sk_storage to
> catch everything.

Is there any reason we are not using BTF ID sets and an allow list similar
to bpf_d_path helper? (apart from the obvious inconvenience of
needing to update the set in the kernel)
