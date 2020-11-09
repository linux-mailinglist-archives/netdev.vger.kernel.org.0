Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0835C2AC344
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 19:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729897AbgKISJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 13:09:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729247AbgKISJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 13:09:24 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A48C0613CF;
        Mon,  9 Nov 2020 10:09:24 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id i193so9058995yba.1;
        Mon, 09 Nov 2020 10:09:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=km7v9rH1kbiJ30CAs4KcvnpaPHBKWlWI3dCQEtnAft0=;
        b=jITjArRLO0ergLMRQhY/qXi42sbYVClVvzLhzmc8eiGYFkjWdjBi4EF/9mc1ArWQz4
         qerMdefbPHvCayQy5rOVTPH12AtsVc8salBin+ghlE9KkS08r2D4Xt1fBBRDx0eu58nq
         Nv062SIxT32u8PI4Pu/c2KbZqjAmcmgJK3+vLuo3oe463v6bygRnvbDCIfe39Tkh27DF
         0+bNW/X1Q0+AGzoPExpfqUMdAZHZioNrGA/BMf3ddtfp26ApB1wApHa/ruCF/RR0pQ8X
         IsL+DyrDcXUpv7l5x3EmksaBdV77SroYvHge+qZlI2tSaKKvheHw1XQ7nZ76jFtbWg+c
         JzmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=km7v9rH1kbiJ30CAs4KcvnpaPHBKWlWI3dCQEtnAft0=;
        b=DqOiJUiT5bZyv6WICHCUTETeGeHcAiuVmwPxBjH8nKeeBW8ugjtFNbykC0jm3df1BO
         QwJYKHSy4qnSumIF1gp3BN4VQIRQFKnzBKGzu66aLK0EkcpXg4y96sKc4B7mE4adCgie
         tv2Tmno8TZVepolfLgiEAqY0pSkCLAtJtSA0Fjc3RppiZDoPO8FPQdx3I/T7p1qDf2Wo
         jTRZJ7nOWNAwcwPuDuH58p7q/xN06d3D8SL9PoRKEcuTBrYSwbnNFru/nFAmP6er632s
         aVnxX9wBWPnvGITztJgIs55c4NtoDQyUZlCA5QfN2mRmUDs2WRgRHUAvNDaKbTG/l3mB
         KvXg==
X-Gm-Message-State: AOAM5308hs4cRfU67Zv35mFQQIFwpy8LuYmepsV8/BUTXMWL/6he1Ns+
        8SxqVwzChSnjrBvPadPrFAN/ydCDzqP9LGo9WDY5OarSP2c=
X-Google-Smtp-Source: ABdhPJwfvCEse4fkzbeQ3+C8bksgne3KA2aauyGcKdkCVdNoDMXX7N3r0BvNUBZA13zC4fWyfKPRjFSCPsBZ4iFLj5I=
X-Received: by 2002:a25:bdc7:: with SMTP id g7mr21774437ybk.260.1604945363491;
 Mon, 09 Nov 2020 10:09:23 -0800 (PST)
MIME-Version: 1.0
References: <20201106220750.3949423-1-kafai@fb.com> <20201106220803.3950648-1-kafai@fb.com>
 <CAEf4BzaQMcnALQ3rPErQJxVjL-Mi8zB8aSBkL8bkR8mtivro+g@mail.gmail.com> <20201107015225.o7hm7oxpndqueae4@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201107015225.o7hm7oxpndqueae4@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 9 Nov 2020 10:09:12 -0800
Message-ID: <CAEf4BzbRXvWdEXC3GdT4Q_dYe6=VPymyDws5QV8wLkdnSONghQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] bpf: Allow using bpf_sk_storage in FENTRY/FEXIT/RAW_TP
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 6, 2020 at 5:52 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Fri, Nov 06, 2020 at 05:14:14PM -0800, Andrii Nakryiko wrote:
> > On Fri, Nov 6, 2020 at 2:08 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > This patch enables the FENTRY/FEXIT/RAW_TP tracing program to use
> > > the bpf_sk_storage_(get|delete) helper, so those tracing programs
> > > can access the sk's bpf_local_storage and the later selftest
> > > will show some examples.
> > >
> > > The bpf_sk_storage is currently used in bpf-tcp-cc, tc,
> > > cg sockops...etc which is running either in softirq or
> > > task context.
> > >
> > > This patch adds bpf_sk_storage_get_tracing_proto and
> > > bpf_sk_storage_delete_tracing_proto.  They will check
> > > in runtime that the helpers can only be called when serving
> > > softirq or running in a task context.  That should enable
> > > most common tracing use cases on sk.
> > >
> > > During the load time, the new tracing_allowed() function
> > > will ensure the tracing prog using the bpf_sk_storage_(get|delete)
> > > helper is not tracing any *sk_storage*() function itself.
> > > The sk is passed as "void *" when calling into bpf_local_storage.
> > >
> > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > ---
> > >  include/net/bpf_sk_storage.h |  2 +
> > >  kernel/trace/bpf_trace.c     |  5 +++
> > >  net/core/bpf_sk_storage.c    | 73 ++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 80 insertions(+)
> > >
> >
> > [...]
> >
> > > +       switch (prog->expected_attach_type) {
> > > +       case BPF_TRACE_RAW_TP:
> > > +               /* bpf_sk_storage has no trace point */
> > > +               return true;
> > > +       case BPF_TRACE_FENTRY:
> > > +       case BPF_TRACE_FEXIT:
> > > +               btf_vmlinux = bpf_get_btf_vmlinux();
> > > +               btf_id = prog->aux->attach_btf_id;
> > > +               t = btf_type_by_id(btf_vmlinux, btf_id);
> > > +               tname = btf_name_by_offset(btf_vmlinux, t->name_off);
> > > +               return !strstr(tname, "sk_storage");
> >
> > I'm always feeling uneasy about substring checks... Also, KP just
> > fixed the issue with string-based checks for LSM. Can we use a
> > BTF_ID_SET of blacklisted functions instead?
> KP one is different.  It accidentally whitelist-ed more than it should.
>
> It is a blacklist here.  It is actually cleaner and safer to blacklist
> all functions with "sk_storage" and too pessimistic is fine here.

Fine for whom? Prefix check would be half-bad, but substring check is
horrible. Suddenly "task_storage" (and anything related) would be also
blacklisted. Let's do a prefix check at least.

>
> >
> > > +       default:
> > > +               return false;
> > > +       }
> > > +
> > > +       return false;
> > > +}
> > > +
> >
> > [...]
