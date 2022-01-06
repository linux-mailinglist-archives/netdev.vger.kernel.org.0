Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6544867B9
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 17:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241282AbiAFQcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 11:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiAFQca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 11:32:30 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95171C061245;
        Thu,  6 Jan 2022 08:32:30 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id c9-20020a17090a1d0900b001b2b54bd6c5so9227405pjd.1;
        Thu, 06 Jan 2022 08:32:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kMqP5DUrb/FAT7MeAYvxaJ3PDFZQ/9iFD97ycYbpY3w=;
        b=SbxvszxmEkR5o/vuM3SIOGno9fRLHzd1ao6VAMPym8DUs2HbF+9nN2w9ZyN1pl7MFf
         1GropGXfAe6oLxqaCmJmJJR0PIOXIs9r0+ybK5J9nCYA36glhKlzjG+ex10ftNNphrWK
         zeIxoJHI9lZmbpNYGma/z+1lVMMkDVcc7Dz94y46DaepmmfgDo2XEA3X9e57M4ZmjW6Q
         Qmt94XXBEho1FIpap+KBIN4yQO3LuguHsP/tk2EZ9rv4FHiplLP3sG2rrsLpWKRG8l5N
         WEobYnzb2l9phlg/UmmP5vYTgmpMK0/gkaTpwGjuUO17P+Au1kiWLVbI3YKIvA049oOR
         PeQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kMqP5DUrb/FAT7MeAYvxaJ3PDFZQ/9iFD97ycYbpY3w=;
        b=K73fcoXOeJmaW2L8ENKTmbWGKpDItBEEO+tp6nVcZLMJMv6MmMCyo4fCjqRvvLHLZ6
         lfJzT/IWjtclwZLHqMRSqzbLU7VAxyVfj7Nz3M30bu2uF47dPZu6Tcp0TRX+hiz2DSzP
         133LERLOg+bcVdO/T6XcD+6wa8SMe36Lqe915gNiLuPRnv6X786Bf2by1Ml+LOc4xabu
         K1rbO7z6wL7efFV7+ra3VRGcM7+1Gdz/9wLaeC+G4h0aKfD0saicicu5u93ChGBoVGyr
         B8gv0mJBIunWqPJLXvJshaeA00gNcMNm3fLRRLkp+kmnC6vqrg95h1739eUKtpu4hdUW
         8MkA==
X-Gm-Message-State: AOAM532emcM+C7CsgqCxNJEFWz9n9/z9w+D5mVLI/TCkmaI2qp4nbYg4
        U5DTdFNIOgKijSNKq85Oqqq488jjeg9/VfZWSQI=
X-Google-Smtp-Source: ABdhPJxHk4+FJEzOOWKpDqO9+LXypuP8eFgev5ToUUXb5mS8bVuvbibHMRkWyz/Rerpju51XjyJnKqWVsmy99UOTVEY=
X-Received: by 2002:a17:902:6502:b0:149:1162:f0b5 with SMTP id
 b2-20020a170902650200b001491162f0b5mr58474182plk.126.1641486750040; Thu, 06
 Jan 2022 08:32:30 -0800 (PST)
MIME-Version: 1.0
References: <20220104080943.113249-1-jolsa@kernel.org> <20220104080943.113249-9-jolsa@kernel.org>
 <CAEf4BzZ7s=Pp+2xY3qKX9u6KrPdGW9NNfoiep7nGW+=_s=JJJA@mail.gmail.com> <YdarSovbcmoY9lI6@krava>
In-Reply-To: <YdarSovbcmoY9lI6@krava>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 6 Jan 2022 08:32:18 -0800
Message-ID: <CAADnVQJdgt41wprEmCdEgpQMii-AHm9ZesZX6gypNuTefntmEA@mail.gmail.com>
Subject: Re: [PATCH 08/13] bpf: Add kprobe link for attaching raw kprobes
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 6, 2022 at 12:41 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, Jan 05, 2022 at 08:30:56PM -0800, Andrii Nakryiko wrote:
> > On Tue, Jan 4, 2022 at 12:10 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > Adding new link type BPF_LINK_TYPE_KPROBE to attach kprobes
> > > directly through register_kprobe/kretprobe API.
> > >
> > > Adding new attach type BPF_TRACE_RAW_KPROBE that enables
> > > such link for kprobe program.
> > >
> > > The new link allows to create multiple kprobes link by using
> > > new link_create interface:
> > >
> > >   struct {
> > >     __aligned_u64   addrs;
> > >     __u32           cnt;
> > >     __u64           bpf_cookie;
> >
> > I'm afraid bpf_cookie has to be different for each addr, otherwise
> > it's severely limiting. So it would be an array of cookies alongside
> > an array of addresses
>
> ok
>
> >
> > >   } kprobe;
> > >
> > > Plus new flag BPF_F_KPROBE_RETURN for link_create.flags to
> > > create return probe.
> > >
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >  include/linux/bpf_types.h      |   1 +
> > >  include/uapi/linux/bpf.h       |  12 +++
> > >  kernel/bpf/syscall.c           | 191 ++++++++++++++++++++++++++++++++-
> > >  tools/include/uapi/linux/bpf.h |  12 +++
> > >  4 files changed, 211 insertions(+), 5 deletions(-)
> > >
> >
> > [...]
> >
> > > @@ -1111,6 +1113,11 @@ enum bpf_link_type {
> > >   */
> > >  #define BPF_F_SLEEPABLE                (1U << 4)
> > >
> > > +/* link_create flags used in LINK_CREATE command for BPF_TRACE_RAW_KPROBE
> > > + * attach type.
> > > + */
> > > +#define BPF_F_KPROBE_RETURN    (1U << 0)
> > > +
> >
> > we have plenty of flexibility to have per-link type fields, so why not
> > add `bool is_retprobe` next to addrs and cnt?
>
> well I thought if I do that, people would suggest to use the empty
> flags field instead ;-)
>
> we can move it there as you suggest, but I wonder it's good idea to
> use bool in uapi headers, because the bool size definition is vague

Good point. No 'bool' please.
grep bool include/uapi/linux/
Only gives openvswitch.h and it's guarded by ifdef KERNEL
So not a single uapi header has bool in it.
