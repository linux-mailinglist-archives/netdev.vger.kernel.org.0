Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C61037B07C
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 23:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbhEKVHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 17:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbhEKVHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 17:07:15 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6565EC061574;
        Tue, 11 May 2021 14:06:07 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id c3so30627216lfs.7;
        Tue, 11 May 2021 14:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T7H5DSMQGmthW/fFcIa05CsgiLo9R8DRtxiNNmTCJeQ=;
        b=miaEpzr0DuO8TgZDyFi33zhnTchkhu5xxUbi+cRZzdwu9Sx++Q4OV8tNUm8ujAD18a
         x1KLQBLm4R6Ysas+j9yfNdYIgRp6PQjZxOb/QWwTkLMjJbTpXr0KrxL0vH2B4571SHV6
         Y5cVaJ+kjeKAtcuZ9R982RmOvI2JCRDd8HUPWSBA4H6fBQcqfuwF3OjUXlGziDjkw3VO
         cn1kqOVGS4zkYDVauSSKzyeTbx7biFIae+LjzmB4a7oQpQUbCtoKBgM5uZu1GpxBD1nv
         Kb9NaA4WXZcLcBO9jBsVvJceugqMMIfjLfUm91ClKcCACZP1uJhEBXqpuWW415jRZKAE
         0JRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T7H5DSMQGmthW/fFcIa05CsgiLo9R8DRtxiNNmTCJeQ=;
        b=DeAA6ulxOIxQmJ9ZG6wb4fDeM+BTqxEzF/o6DjeyLD+ZFIE3pP5u3pRKjiywQM94Ie
         CRyTi6axy5NLDdWVJ98QvMy2k5ngVlLguKGI8X4v1eUMgeHJZoBP3Q2gnldCXf7PYi9i
         /6ALWyL6bI7D3MavFbaJ9Hx8Gew5Uv3bz/Iu5j5Uf07a0sL46M+jjVZoCGiQ0dXx5bWx
         1EqSEcOXR/diWW5coJDl6qAqB1hACT2vDPlZQv2IRIsMi44huxkY3DBDh4mMR/6wJb49
         MfvrY4MAj5XoOyCKzXsvA643zhGmIDGuIZSgAFVd9LpII1xz4kIYiJUMAWYPbzUTDqmV
         X00g==
X-Gm-Message-State: AOAM532Ypxqd6rZ8Cofui+E7mpiJ2LzXG5hfvcRDvHXbldVWJfa+G9E1
        daWduF4w+C0tdXzvMSDDnN3MyqlQdp76WqPITF6sjcmT
X-Google-Smtp-Source: ABdhPJyBX4PDMF3y34uLZfIpe95NLQvi6O34yulCDJF2inA1vhXel3l8cKsTkZypi27YMedd6sCOVJT4Bu6Pxqunpdw=
X-Received: by 2002:a05:6512:3f93:: with SMTP id x19mr22127695lfa.182.1620767165858;
 Tue, 11 May 2021 14:06:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210429114712.43783-1-jolsa@kernel.org> <CAADnVQLDwjE8KFcqbzB5op5b=fC2941tnnWOtQ+X1DYi6Yw1xA@mail.gmail.com>
 <YJkByQ4bGa7jrvWR@krava>
In-Reply-To: <YJkByQ4bGa7jrvWR@krava>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 11 May 2021 14:05:54 -0700
Message-ID: <CAADnVQLJzJinUhWM4eFd1=GEjgNT-25y_bCx7LOjhpSXumKcHw@mail.gmail.com>
Subject: Re: [PATCHv2] bpf: Add deny list of btf ids check for tracing programs
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 2:50 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, May 06, 2021 at 06:36:38PM -0700, Alexei Starovoitov wrote:
> > On Thu, Apr 29, 2021 at 4:47 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > The recursion check in __bpf_prog_enter and __bpf_prog_exit
> > > leaves some (not inlined) functions unprotected:
> > >
> > > In __bpf_prog_enter:
> > >   - migrate_disable is called before prog->active is checked
> > >
> > > In __bpf_prog_exit:
> > >   - migrate_enable,rcu_read_unlock_strict are called after
> > >     prog->active is decreased
> > >
> > > When attaching trampoline to them we get panic like:
> > >
> > >   traps: PANIC: double fault, error_code: 0x0
> > >   double fault: 0000 [#1] SMP PTI
> > >   RIP: 0010:__bpf_prog_enter+0x4/0x50
> > >   ...
> > >   Call Trace:
> > >    <IRQ>
> > >    bpf_trampoline_6442466513_0+0x18/0x1000
> > >    migrate_disable+0x5/0x50
> > >    __bpf_prog_enter+0x9/0x50
> > >    bpf_trampoline_6442466513_0+0x18/0x1000
> > >    migrate_disable+0x5/0x50
> > >    __bpf_prog_enter+0x9/0x50
> > >    bpf_trampoline_6442466513_0+0x18/0x1000
> > >    migrate_disable+0x5/0x50
> > >    __bpf_prog_enter+0x9/0x50
> > >    bpf_trampoline_6442466513_0+0x18/0x1000
> > >    migrate_disable+0x5/0x50
> > >    ...
> > >
> > > Fixing this by adding deny list of btf ids for tracing
> > > programs and checking btf id during program verification.
> > > Adding above functions to this list.
> > >
> > > Suggested-by: Alexei Starovoitov <ast@kernel.org>
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > > v2 changes:
> > >   - drop check for EXT programs [Andrii]
> > >
> > >  kernel/bpf/verifier.c | 14 ++++++++++++++
> > >  1 file changed, 14 insertions(+)
> > >
> > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > index 2579f6fbb5c3..42311e51ac71 100644
> > > --- a/kernel/bpf/verifier.c
> > > +++ b/kernel/bpf/verifier.c
> > > @@ -13112,6 +13112,17 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
> > >         return 0;
> > >  }
> > >
> > > +BTF_SET_START(btf_id_deny)
> > > +BTF_ID_UNUSED
> > > +#ifdef CONFIG_SMP
> > > +BTF_ID(func, migrate_disable)
> > > +BTF_ID(func, migrate_enable)
> > > +#endif
> > > +#if !defined CONFIG_PREEMPT_RCU && !defined CONFIG_TINY_RCU
> > > +BTF_ID(func, rcu_read_unlock_strict)
> > > +#endif
> > > +BTF_SET_END(btf_id_deny)
> >
> > I was wondering whether it makes sense to do this on pahole side instead ?
> > It can do more flexible regex matching and excluding all such functions
> > from vmlinux btf without the kernel having to do a maze of #ifdef
> > depending on config.
> > On one side we will lose BTF info about such functions, but what do we
> > need it for?
> > On the other side it will be a tiny reduction in vmlinux btf :)
> > Thoughts?
>
> we just removed the ftrace filter so BTF will have 'all' functions
>
> I think the filtering on pahole side could cause problems like
> the recent one with cubictcp_state.. it's just 3 functions, but
> what if they rename? this way we at least get compilation error ;-)
>
> I'd go with all functions in BTF and restrict attachment for those
> that cause problems

Ok. Let's see how it will work in practice.
Applied to bpf tree.
