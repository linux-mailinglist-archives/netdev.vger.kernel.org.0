Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6029E486CD9
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 22:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244753AbiAFVxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 16:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239651AbiAFVxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 16:53:17 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA0EC061245;
        Thu,  6 Jan 2022 13:53:17 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id m4so3197462ilf.0;
        Thu, 06 Jan 2022 13:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZgyA/8f1KusUMgL7/XkrBehZ3A7cVY+FWzd49czG5EY=;
        b=aQAobBqZXmr9PfKL0eDi1LJkMpXsqEGOxvY+UFZHU26wumRp4QRjBNAnkxAIm5QjuI
         hNgpsW+z+5iz6ntvUfWRhRdD0R/W4SV5Js/MYtM+NhVtyOYpOD3+XS4/JIBQ4SRUMeT4
         U0tEXBzm+I99leF0oCtvAo9NFoZdiPC4lo/3sJzziWjX96/RdkSBln0Y+fsWzQTf1/LG
         xEDWfaXKTj7VeLj+lF90ReZ6fAYW6fq3OlbaAJZnSifNoFzd81IsdYjscjp2kIYEuAVY
         7ahQuE/0tqVnjUpDL/5w4d6tDhGXwDl+igLBxNDUVxbDfIVr3TinComOU8ppUB6sBubR
         5O0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZgyA/8f1KusUMgL7/XkrBehZ3A7cVY+FWzd49czG5EY=;
        b=Eok6PZb/erGJxabRxNDn4VLQs0O7CeC+J0FkyWyawE+wfA8KG6u/fmtK6B9tQi+neI
         2t3hfOzJZNmjqmcTM4dU80+2vk+JL+2jw6rs/GVlfXOV3CxTgmvGm4POw2PqVLaUhDKY
         Vr6Y3Lx2g9FNwUnVFwWPORwp27+0Cx2RjGUPLOK3r/fNedKncH7OYkRaii/UyKti/Y54
         sPpZTa7So2SOTcgSEaizid0a/pk7Pq3tvauvQEPxW4kGoncTd7TeNUXKGtX+zbKWPQgN
         xECSmCLGW/GWegSMrBEAmogjUXTMFmixvbHce0VjsR9jsW/qNnIr3Qc7N5dTpVRSgPTi
         SPig==
X-Gm-Message-State: AOAM530YMbDjRiXldUhQLrj+TkHA/zuSlKXl5Sc5fKYMU+xN50obn5Zx
        FX3wh9ue1WyGV+v1smYdiF3bOvqWNOZ8Uo5T7hs=
X-Google-Smtp-Source: ABdhPJyW5O4WRlXtbGT63/+7f6b8eOxZUal//7Kfbkoycx92tebhBWiIUQgMt2aAqeZohhagqaUF43IDuUJ1uwy46kE=
X-Received: by 2002:a05:6e02:b4c:: with SMTP id f12mr27134949ilu.252.1641505996964;
 Thu, 06 Jan 2022 13:53:16 -0800 (PST)
MIME-Version: 1.0
References: <20220104080943.113249-1-jolsa@kernel.org> <20220104080943.113249-9-jolsa@kernel.org>
 <CAEf4BzZ7s=Pp+2xY3qKX9u6KrPdGW9NNfoiep7nGW+=_s=JJJA@mail.gmail.com>
 <YdarSovbcmoY9lI6@krava> <CAADnVQJdgt41wprEmCdEgpQMii-AHm9ZesZX6gypNuTefntmEA@mail.gmail.com>
In-Reply-To: <CAADnVQJdgt41wprEmCdEgpQMii-AHm9ZesZX6gypNuTefntmEA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 6 Jan 2022 13:53:05 -0800
Message-ID: <CAEf4BzZbt1eVKtUaO4b1eEBpTZ3_47t6a_5YtnYGLA9-ZCJCDg@mail.gmail.com>
Subject: Re: [PATCH 08/13] bpf: Add kprobe link for attaching raw kprobes
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
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

On Thu, Jan 6, 2022 at 8:32 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Jan 6, 2022 at 12:41 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Wed, Jan 05, 2022 at 08:30:56PM -0800, Andrii Nakryiko wrote:
> > > On Tue, Jan 4, 2022 at 12:10 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > >
> > > > Adding new link type BPF_LINK_TYPE_KPROBE to attach kprobes
> > > > directly through register_kprobe/kretprobe API.
> > > >
> > > > Adding new attach type BPF_TRACE_RAW_KPROBE that enables
> > > > such link for kprobe program.
> > > >
> > > > The new link allows to create multiple kprobes link by using
> > > > new link_create interface:
> > > >
> > > >   struct {
> > > >     __aligned_u64   addrs;
> > > >     __u32           cnt;
> > > >     __u64           bpf_cookie;
> > >
> > > I'm afraid bpf_cookie has to be different for each addr, otherwise
> > > it's severely limiting. So it would be an array of cookies alongside
> > > an array of addresses
> >
> > ok
> >
> > >
> > > >   } kprobe;
> > > >
> > > > Plus new flag BPF_F_KPROBE_RETURN for link_create.flags to
> > > > create return probe.
> > > >
> > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > ---
> > > >  include/linux/bpf_types.h      |   1 +
> > > >  include/uapi/linux/bpf.h       |  12 +++
> > > >  kernel/bpf/syscall.c           | 191 ++++++++++++++++++++++++++++++++-
> > > >  tools/include/uapi/linux/bpf.h |  12 +++
> > > >  4 files changed, 211 insertions(+), 5 deletions(-)
> > > >
> > >
> > > [...]
> > >
> > > > @@ -1111,6 +1113,11 @@ enum bpf_link_type {
> > > >   */
> > > >  #define BPF_F_SLEEPABLE                (1U << 4)
> > > >
> > > > +/* link_create flags used in LINK_CREATE command for BPF_TRACE_RAW_KPROBE
> > > > + * attach type.
> > > > + */
> > > > +#define BPF_F_KPROBE_RETURN    (1U << 0)
> > > > +
> > >
> > > we have plenty of flexibility to have per-link type fields, so why not
> > > add `bool is_retprobe` next to addrs and cnt?
> >
> > well I thought if I do that, people would suggest to use the empty
> > flags field instead ;-)
> >
> > we can move it there as you suggest, but I wonder it's good idea to
> > use bool in uapi headers, because the bool size definition is vague
>
> Good point. No 'bool' please.
> grep bool include/uapi/linux/
> Only gives openvswitch.h and it's guarded by ifdef KERNEL
> So not a single uapi header has bool in it.

Yeah, I don't insist on bool specifically.

But I was trying to avoid link_create.flags to become map_flags where
we have various flags, each taking a separate bit, but most flags
don't apply to most map types. Ideally link_create.flags would have
few flags that apply to all or most link types (i.e., something
orthogonal to a specific link type), and for this case we could have
kprobe-specific flags (link_create.kprobe.flags) to adjust kprobe link
creation behavior.

But I don't know, maybe I'm overthinking this.
