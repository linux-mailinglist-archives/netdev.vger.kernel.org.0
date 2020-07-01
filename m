Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78D8211269
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 20:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732814AbgGASPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 14:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728453AbgGASPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 14:15:36 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E71C08C5C1;
        Wed,  1 Jul 2020 11:15:36 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id h18so11433781qvl.3;
        Wed, 01 Jul 2020 11:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ffVEjADBbo/VcYQlJtVoKxDYeZbCipjlXX2jDm0ogMk=;
        b=ZEOz2i+FZwinVKDlvQMo1VKyUkzgDYIZJ4cIooDZW1hG56cvvvMWgjs3XY7oSuqv37
         KXUE6rEjWDn/3l1cUFGGDWZA7BLrI56kx47cdFiCN63ThNnbh8kZuo0yvw9fnQhjIeDL
         2HiclPKf0KGyH7dx4S5mAPPx3mzK+ybKAy2ecRUaV7NGpkGa9OhUnnvsYQmjW/1+mpwJ
         oqxQcie2XKi4WPBTwWn2PYaobcs/Wwhs1PFYzt34BfHABTcqHKRpwYatX19yDrYNSBgP
         437tsmtvbJle5PZ2FK8ZT2+FtuJK8Aj9TqxTZUbfKFfPUij2LtEzOjJFXLnWn1ZJfNFQ
         L6og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ffVEjADBbo/VcYQlJtVoKxDYeZbCipjlXX2jDm0ogMk=;
        b=ss8MI6GCLv296FV2/N1a+wj7NAAx8VNVJ6e+mJEF3JnYtGIZBrf45MYoKC2H1kQw/v
         lLTaPquiXQBtX3f5um1H3+Do5UVQTINjM9dVruiRncdrdUPAZaioNU4jm7bmJGbVoQTq
         6TLoETQiSIWeSGLiDvmADholwWpyM/25M3+vBPn64PODRctyWRf/0cHPY2TomdBUYd1x
         2dIlXcmjjLpdgxUSXHp6T43r9yKaWHCoIklKij4U95VIq6/2Eejj/NQ2QBCiLUtFLgfu
         gBvoVjSpWa0G2/RxDVfwryValaxy8CfJvlxX4JbQ21ykE9c27+aeRPWIlqcPWgxIZxSA
         voBw==
X-Gm-Message-State: AOAM530uIII8nZf4NJ7DoW4/DAkruu7iFmPwLhihKCnVPrJTGixcPPx0
        Coc/4msaucSSOi6ZiVOF7dI+1OIioFYFq5A0RIWA8IPMIjM=
X-Google-Smtp-Source: ABdhPJzxUI48qUEz1x5DiiIpW19NVi4yKU17Pc3lVhmC5sgbTYudq7jwPwFBy9tz62m1aH+n9+SWrzGCVK9AeiuCyMk=
X-Received: by 2002:a0c:9ae2:: with SMTP id k34mr25738144qvf.247.1593627335428;
 Wed, 01 Jul 2020 11:15:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200701064527.3158178-1-andriin@fb.com> <CAADnVQLGQB9MeOpT0vGpbwV4Ye7j1A9bJVQzF-krWQY_gNfcpA@mail.gmail.com>
 <CAEf4BzbtPBLXU9OKCxeqOKr2WkUHz3P8zO6hD-602htLr21RvQ@mail.gmail.com> <20200701163650.qoxr5xgjmz5mpzgn@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200701163650.qoxr5xgjmz5mpzgn@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 1 Jul 2020 11:15:24 -0700
Message-ID: <CAEf4BzYqmNvhZ5ZkEHJsBRZYiMR5Muvn0QFCzV+XJek8jML4jw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] Strip away modifiers from BPF skeleton
 global variables
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Anton Protopopov <a.s.protopopov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 1, 2020 at 9:36 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Jul 01, 2020 at 09:08:45AM -0700, Andrii Nakryiko wrote:
> > On Wed, Jul 1, 2020 at 8:02 AM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Tue, Jun 30, 2020 at 11:46 PM Andrii Nakryiko <andriin@fb.com> wrote:
> > > >
> > > > Fix bpftool logic of stripping away const/volatile modifiers for all global
> > > > variables during BPF skeleton generation. See patch #1 for details on when
> > > > existing logic breaks and why it's important. Support special .strip_mods=true
> > > > mode in btf_dump. Add selftests validating that everything works as expected.
> > >
> > > Why bother with the flag?
> >
> > You mean btf_dump should do this always? That's a bit too invasive a
> > change, I don't like it.
> >
> > > It looks like bugfix to me.
> >
> > It can be considered a bug fix for bpftool's skeleton generation, but
> > it depends on non-trivial changes in libbpf, which are not bug fix per
> > se, so should probably better go through bpf-next.
>
> I'm not following.
> Without tweaking opts and introducing new flag the actual fix is only
> two hunks in patch 1:

Right, but from the btf_dump point of view this is not a bug fix, its
current behavior is correct and precise. So this change is a change in
behavior and not universally correct for all the possible use cases.
So I can't just make it always strip modifiers, it's changing
generated output. It has to be an optional feature.


>
> @@ -1045,6 +1050,10 @@ static void btf_dump_emit_type_decl(struct btf_dump *d, __u32 id,
>
>         stack_start = d->decl_stack_cnt;
>         for (;;) {
> +               t = btf__type_by_id(d->btf, id);
> +               if (btf_is_mod(t))
> +                       goto skip_mod;
> +
>                 err = btf_dump_push_decl_stack_id(d, id);
>                 if (err < 0) {
>                         /*
> @@ -1056,12 +1065,11 @@ static void btf_dump_emit_type_decl(struct btf_dump *d, __u32 id,
>                         d->decl_stack_cnt = stack_start;
>                         return;
>                 }
> -
> +skip_mod:
>                 /* VOID */
>                 if (id == 0)
>                         break;
>
> -               t = btf__type_by_id(d->btf, id);
>
