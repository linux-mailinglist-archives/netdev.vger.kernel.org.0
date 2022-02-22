Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B85F4BF3BF
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 09:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiBVIfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 03:35:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiBVIft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 03:35:49 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C854158EBA;
        Tue, 22 Feb 2022 00:35:24 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id v5so1940628ilm.9;
        Tue, 22 Feb 2022 00:35:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ohS+tBJXbJlq7l0HDDlW1u4G+GIRR4Wd/pd1Ro3QENU=;
        b=gALrkjbbycpw0hWvhtTJ91/8oRHivrhLwnjLa9U/Ty5QHB+FXUVexvIejaiWKo9oFZ
         0X1YBACat3glKsCa9FhNF8i7jTe6XZoz6YKMlVd5FaMLpsPSZLzSyfuTgxy2hgTlASsx
         FglLJeaqmj2G6p71cD+gdQGw54Ur75bGd23ZnrgnAH884NHuefVKoEFfhXMv0CwsebO8
         e6KAOEWJ04RU5bNMIhM5quvJkh8x2jaOJ60AK6rqZHPQnFXnVro0LV1Xx41TxP9gd3gp
         lmmtxRSa0DfgrzEzRUNESzEgRE301P7qmbqv/l26OP0/JfCGRrb3CuI6WWGGdCvylPZR
         AjQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ohS+tBJXbJlq7l0HDDlW1u4G+GIRR4Wd/pd1Ro3QENU=;
        b=T5EMbM8uX5MDgnCZx8drgAYbtadNHl5p2qn4793OqQZ6okxMKfH4FMKQUMHkAK8UIk
         wB4FPqvvLLqxLaOiXm4j79rv6EOJ1IgWA1yAjPxbMXYp0xWtgrVvfTo/+XpOpoxr5YYY
         Y+BQG3sAWji7wTdsIAIH9OVQp5YrElDLJZmroJfvhi2IkXgOEmSUOIHVIJmgO6SBpXkk
         ORuqJgflAAT3kz1gSmWpAhhQJyhGOK1+Y5NbYPXMECZj0EthbkCx1qbE/JtjPhrc2YjI
         Vl7+GgrQ3dfF4uz5kuJLGWuZ/I+qmkBEpjVAEHzbNgF9Jg24qQLGzKGdaTlCrQdXimjF
         7bYg==
X-Gm-Message-State: AOAM531iO7ssdqRtecWJZ1Hd21XWOOG8a4OXUEQ1Fp3W76ysjznNqZEK
        Gi+HoN50SXV3usPJLoA5iN4HL0lvksBS3ldY7fVKYtZ1fXk=
X-Google-Smtp-Source: ABdhPJzY+Pn1Ko+vu3C7S+wW5+WwKfNSPl6MhiHXDisjkybCZ1aKT4RX7DsSJEu9WajpKaifLxkMn+qWnRVb/L5bdqs=
X-Received: by 2002:a05:6e02:154d:b0:2bc:84c0:b255 with SMTP id
 j13-20020a056e02154d00b002bc84c0b255mr20020315ilu.87.1645518923950; Tue, 22
 Feb 2022 00:35:23 -0800 (PST)
MIME-Version: 1.0
References: <20220218095612.52082-1-laoar.shao@gmail.com> <20220218095612.52082-3-laoar.shao@gmail.com>
 <CAADnVQJhGmvY1NDsy9WE6tnqYM6JCmi4iZtB7xHuWh4yC-awPw@mail.gmail.com>
 <CALOAHbCytBP4osCXSZ_7+A69NuVf6SYDWGFC62O_MkHn9Fn10Q@mail.gmail.com>
 <CAADnVQ+FuK2wihDy5GumBN3LVBky0r04CmS4h1JsVoS7QoH6LA@mail.gmail.com>
 <CALOAHbAvG1gEAFhqs61x4aStaxph-O3f8k0XbCuUJK4rxcMRFw@mail.gmail.com> <CAADnVQ+ye+hRB2RvDY+=-kTOhBZesW0fyLR0EY9cV972SwZSSQ@mail.gmail.com>
In-Reply-To: <CAADnVQ+ye+hRB2RvDY+=-kTOhBZesW0fyLR0EY9cV972SwZSSQ@mail.gmail.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 22 Feb 2022 16:34:48 +0800
Message-ID: <CALOAHbCkpL7hB-fLKupwODTXHopQ=tMzxgdG-JAV_Nuv6eG7cg@mail.gmail.com>
Subject: Re: [PATCH RFC 2/3] bpf: set attached cgroup name in attach_name
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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

On Tue, Feb 22, 2022 at 12:30 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Feb 21, 2022 at 6:26 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > On Mon, Feb 21, 2022 at 4:59 AM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Sun, Feb 20, 2022 at 6:17 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> > > >
> > > > On Sun, Feb 20, 2022 at 2:27 AM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > On Fri, Feb 18, 2022 at 1:56 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> > > > > >
> > > > > > Set the cgroup path when a bpf prog is attached to a cgroup, and unset
> > > > > > it when the bpf prog is detached.
> > > > > >
> > > > > > Below is the result after this change,
> > > > > > $ cat progs.debug
> > > > > >   id name             attached
> > > > > >    5 dump_bpf_map     bpf_iter_bpf_map
> > > > > >    7 dump_bpf_prog    bpf_iter_bpf_prog
> > > > > >   17 bpf_sockmap      cgroup:/
> > > > > >   19 bpf_redir_proxy
> > > > > >
> > > > > > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > > > > > ---
> > > > > >  kernel/bpf/cgroup.c | 8 ++++++++
> > > > > >  1 file changed, 8 insertions(+)
> > > > > >
> > > > > > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > > > > > index 43eb3501721b..ebd87e54f2d0 100644
> > > > > > --- a/kernel/bpf/cgroup.c
> > > > > > +++ b/kernel/bpf/cgroup.c
> > > > > > @@ -440,6 +440,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> > > > > >         struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
> > > > > >         struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
> > > > > >         enum cgroup_bpf_attach_type atype;
> > > > > > +       char cgrp_path[64] = "cgroup:";
> > > > > >         struct bpf_prog_list *pl;
> > > > > >         struct list_head *progs;
> > > > > >         int err;
> > > > > > @@ -508,6 +509,11 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> > > > > >         else
> > > > > >                 static_branch_inc(&cgroup_bpf_enabled_key[atype]);
> > > > > >         bpf_cgroup_storages_link(new_storage, cgrp, type);
> > > > > > +
> > > > > > +       cgroup_name(cgrp, cgrp_path + strlen("cgroup:"), 64);
> > > > > > +       cgrp_path[63] = '\0';
> > > > > > +       prog->aux->attach_name = kstrdup(cgrp_path, GFP_KERNEL);
> > > > > > +
> > > > >
> > > > > This is pure debug code. We cannot have it in the kernel.
> > > > > Not even under #ifdef.
> > > > >
> > > > > Please do such debug code on a side as your own bpf program.
> > > > > For example by kprobe-ing in this function and keeping the path
> > > > > in a bpf map or send it to user space via ringbuf.
> > > > > Or enable cgroup tracepoint and monitor cgroup_mkdir with full path.
> > > > > Record it in user space or in bpf map, etc.
> > > > >
> > > >
> > > > It is another possible solution to  hook the related kernel functions
> > > > or tracepoints, but it may be a little complicated to track all the
> > > > bpf attach types, for example we also want to track
> > > > BPF_PROG_TYPE_SK_MSG[1], BPF_PROG_TYPE_FLOW_DISSECTOR and etc.
> > > > While the attach_name provides us a generic way to get how the bpf
> > > > progs are attached, which can't be got by bpftool.
> > >
> > > bpftool can certainly print such details.
> > > See how it's using task_file iterator.
> > > It can be extended to look into cgroups and sockmap,
> > > and for each program print "sockmap:%d", map->id if so desired.
> >
> > I have read through the task_file code, but I haven't found a direct
> > way to get the attached cgroups or maps of a specified prog.
> > It is easy to look into a cgroup or sockmap, but the key point here is
> > which is the proper cgroup or sockmap.
> > There are some possible ways to get the attached cgroup or sockmap.
> >
> > - add new member into struct bpf_prog_aux
>
> No. Please stop proposing kernel changes for your debug needs.
>
> >    For example,
> >     struct bpf_prog_aux{
> >         union {
> >             struct cgroup *attached_cgrp;
> >             struct bpf_map *attached_map;
> >         };
> >     };
> >     Then we can easily get the related map or cgroup by extending
> > task_file iterator.
> >
> > - build a table for attached maps, cgroups and etc
> >    Like we did for pinned files.
> >    Then we can compare the prog with the members stored in this table
> > one by one, but that seems a little heavy.
> >
> > There may be some other ways.
>
> - iterate bpf maps
> - find sockmap
> - do equivalent of sock_map_progs(), but open coded inside bpf prog
> - read progs, print them.

That's similar to the second  way I proposed above.
The trouble is it may be too heavy to iterate the target objects, for
example, there may be thousands of cgroups on a single host, and if we
want to know which cgroup is attached by a bpf prog we have to iterate
all the cgroups until find it.
But it seems there is no better choice.
Anyway thanks for the advice.

-- 
Thanks
Yafang
