Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B73C4BD1C4
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 22:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239643AbiBTVAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 16:00:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235640AbiBTVAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 16:00:20 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652252DD47;
        Sun, 20 Feb 2022 12:59:58 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id y11so6971170pfa.6;
        Sun, 20 Feb 2022 12:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vZ02YZOgDrVwpXxu5Hh2IeZyutIz7L7EXvfRr92KaEQ=;
        b=FV9CHBay5FKiJSC+n+l9oLKIuj9FLBV15sKCHkhSkn6ryQojFLju4EqcomQbtYIMRK
         tnKsWZlerzWjR61cah1t9seN9hRUMHrg0MmDS4rAWzLE3xtGmulL8Wkj0oMIdg8+7kiU
         dZzGKuT3IqYh1KTiTqr/1VRJmkcmPviNw/MrnDkXOCCEVntrxzqEewnM3ZRxTlY6eSHb
         IMIBARuzjLMQWbNH3a+GW1pv/3svBVfzQS/bG/4BtzrT5flPfeCM3Dvk6SvP7kgs5wsH
         iDxwz9TAngLGsi5rvYEk6MCILVKDxhHoYKj/wjU44iP5jb0HBlJIIgnPUp2zd1ZAZtb2
         sKEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vZ02YZOgDrVwpXxu5Hh2IeZyutIz7L7EXvfRr92KaEQ=;
        b=ZMmfq/3qHKjphxq0be/C8YUI9/9l/UTl/DV9N7uWO7Cq++U0k+qwu2+NpThvijaHG6
         X9xbZ03CNYb5UCM9tMvvJ9faiHStjsa6/VKI1QJIEXv2Hh+UegcmG8LIgfyc5TkTNyuE
         Qi1jSmNj5FE9qDPMCysVpe5t/RExZ7hpj3fV6BpOGVBAT4qIpk65rMnJ2G4AXAbFyofw
         BWxiyb4DSsFwcrc2Du41tpXWih2zKQxGSIx82+SDM1dFYQXzTWXDE6FRlmGrXqCnKLrE
         noLSzltfW0pnx6JXwPQLWEv11cEzqf2kbmyfDydDu+1hCMcAM46NgbIxQ/MHNkAjyI4U
         k/yw==
X-Gm-Message-State: AOAM530h3K96qhvdIqD85CsIycrMZ7lGbl0j7MTx8joIvDySqwsLPwgo
        SqEzH9Oxx9kIJ0J8llc3LdF95YFpVVYmXuDAGsTOmSOX+Mg=
X-Google-Smtp-Source: ABdhPJzkfljOiO/45d10wt5Ent2wIyxLX/k2INviYgRDEVaIX/7lgH9wARbj8ccdTKTUJ1kKJ3qxTxApZdJzFHyEWqA=
X-Received: by 2002:a05:6a00:809:b0:4f1:14bb:40b1 with SMTP id
 m9-20020a056a00080900b004f114bb40b1mr5767416pfk.69.1645390797775; Sun, 20 Feb
 2022 12:59:57 -0800 (PST)
MIME-Version: 1.0
References: <20220218095612.52082-1-laoar.shao@gmail.com> <20220218095612.52082-3-laoar.shao@gmail.com>
 <CAADnVQJhGmvY1NDsy9WE6tnqYM6JCmi4iZtB7xHuWh4yC-awPw@mail.gmail.com> <CALOAHbCytBP4osCXSZ_7+A69NuVf6SYDWGFC62O_MkHn9Fn10Q@mail.gmail.com>
In-Reply-To: <CALOAHbCytBP4osCXSZ_7+A69NuVf6SYDWGFC62O_MkHn9Fn10Q@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 20 Feb 2022 12:59:46 -0800
Message-ID: <CAADnVQ+FuK2wihDy5GumBN3LVBky0r04CmS4h1JsVoS7QoH6LA@mail.gmail.com>
Subject: Re: [PATCH RFC 2/3] bpf: set attached cgroup name in attach_name
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 20, 2022 at 6:17 AM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> On Sun, Feb 20, 2022 at 2:27 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Feb 18, 2022 at 1:56 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> > >
> > > Set the cgroup path when a bpf prog is attached to a cgroup, and unset
> > > it when the bpf prog is detached.
> > >
> > > Below is the result after this change,
> > > $ cat progs.debug
> > >   id name             attached
> > >    5 dump_bpf_map     bpf_iter_bpf_map
> > >    7 dump_bpf_prog    bpf_iter_bpf_prog
> > >   17 bpf_sockmap      cgroup:/
> > >   19 bpf_redir_proxy
> > >
> > > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > > ---
> > >  kernel/bpf/cgroup.c | 8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > >
> > > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > > index 43eb3501721b..ebd87e54f2d0 100644
> > > --- a/kernel/bpf/cgroup.c
> > > +++ b/kernel/bpf/cgroup.c
> > > @@ -440,6 +440,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> > >         struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
> > >         struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
> > >         enum cgroup_bpf_attach_type atype;
> > > +       char cgrp_path[64] = "cgroup:";
> > >         struct bpf_prog_list *pl;
> > >         struct list_head *progs;
> > >         int err;
> > > @@ -508,6 +509,11 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> > >         else
> > >                 static_branch_inc(&cgroup_bpf_enabled_key[atype]);
> > >         bpf_cgroup_storages_link(new_storage, cgrp, type);
> > > +
> > > +       cgroup_name(cgrp, cgrp_path + strlen("cgroup:"), 64);
> > > +       cgrp_path[63] = '\0';
> > > +       prog->aux->attach_name = kstrdup(cgrp_path, GFP_KERNEL);
> > > +
> >
> > This is pure debug code. We cannot have it in the kernel.
> > Not even under #ifdef.
> >
> > Please do such debug code on a side as your own bpf program.
> > For example by kprobe-ing in this function and keeping the path
> > in a bpf map or send it to user space via ringbuf.
> > Or enable cgroup tracepoint and monitor cgroup_mkdir with full path.
> > Record it in user space or in bpf map, etc.
> >
>
> It is another possible solution to  hook the related kernel functions
> or tracepoints, but it may be a little complicated to track all the
> bpf attach types, for example we also want to track
> BPF_PROG_TYPE_SK_MSG[1], BPF_PROG_TYPE_FLOW_DISSECTOR and etc.
> While the attach_name provides us a generic way to get how the bpf
> progs are attached, which can't be got by bpftool.

bpftool can certainly print such details.
See how it's using task_file iterator.
It can be extended to look into cgroups and sockmap,
and for each program print "sockmap:%d", map->id if so desired.
