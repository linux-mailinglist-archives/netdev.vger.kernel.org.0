Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4035C4BE35F
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377776AbiBUO1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 09:27:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377779AbiBUO1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 09:27:16 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4C22196;
        Mon, 21 Feb 2022 06:26:52 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id t9so7603393ilf.13;
        Mon, 21 Feb 2022 06:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uljOiLd66xpetJx0r72sLRAF02XT1S7b6VYjvM9jydk=;
        b=THbWzgligE4bkojM2wrZxkWKHPbzPta+67EMdonT+JLjppx6A2XrfmgtJO03+1P1qd
         wzO7rINmQCjE/uKBSkwtKJUZ1vBooBu4rupN2hXB0oB5WklD1V0YE2U5UWtS3V0BlvGS
         1RE2TQskoqPZl173bEvWKs3NZNhUX1GaefDw46onHWDjFdvSiredN55sukbs4o1NWKb0
         T/P6cQXoMB4kD2gZmRl5ELQMwP5OJZ1oOh4TO8sm+Lytiuu9XHfFbjXhwgJw2bsQ1IGr
         7G+pDlejtFgFE7n6bg7H/y4/lXtDz0Wxt6YRcC8RZZN7FO8GyZBj4IDtBxo37vlVzQr3
         nHmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uljOiLd66xpetJx0r72sLRAF02XT1S7b6VYjvM9jydk=;
        b=5LIHe25zs+aAVmiUxE5VuhjTK+CZgqv3AqEMuFxobk3nw4TI07a4L+2AgYtFvbOWu2
         Sl9GtEai4+P7ocTrnNtgBmKh6dYkp51KH1yPzcpcWMpiqKWxR21DfHgmr9FUSZb5iud/
         en0YTx5I4rMB8wAnEHayRoe0cw5HdM156Irgnyvm1uThOy0z5473D0n3xhGyomUr/A6e
         SgLssWzE3dgXL3rvsNnfk+dUxfCgbUhlP0ORbUwDYPG+Rfb3A5v7IFF6QM8aIFBS4srl
         cWlsZXGkkgrti6pmDQmBwmL/d2OgWyLqskwiRfyUaWGY+DJOksKBICg3k16SuWLNtemz
         98KQ==
X-Gm-Message-State: AOAM5304K+Bdt1QoF2egn4STh/6bVMmvWCQWAmD9zJpH1uSSxI+A0Hwr
        tRG9vmeA51CprnoFMQGD14ezZFZSKhfWME+sI3g=
X-Google-Smtp-Source: ABdhPJzA8Evh3FBFg+wQlCRb16Dc5G39AshYQYUTuZAbWI9pawT+AJ70tPxLix7z78KbBoqZLNNNh2EsIZ6Ptq6ZUEk=
X-Received: by 2002:a05:6e02:1a2f:b0:2c2:3afa:95fa with SMTP id
 g15-20020a056e021a2f00b002c23afa95famr4915088ile.257.1645453612219; Mon, 21
 Feb 2022 06:26:52 -0800 (PST)
MIME-Version: 1.0
References: <20220218095612.52082-1-laoar.shao@gmail.com> <20220218095612.52082-3-laoar.shao@gmail.com>
 <CAADnVQJhGmvY1NDsy9WE6tnqYM6JCmi4iZtB7xHuWh4yC-awPw@mail.gmail.com>
 <CALOAHbCytBP4osCXSZ_7+A69NuVf6SYDWGFC62O_MkHn9Fn10Q@mail.gmail.com> <CAADnVQ+FuK2wihDy5GumBN3LVBky0r04CmS4h1JsVoS7QoH6LA@mail.gmail.com>
In-Reply-To: <CAADnVQ+FuK2wihDy5GumBN3LVBky0r04CmS4h1JsVoS7QoH6LA@mail.gmail.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Mon, 21 Feb 2022 22:26:16 +0800
Message-ID: <CALOAHbAvG1gEAFhqs61x4aStaxph-O3f8k0XbCuUJK4rxcMRFw@mail.gmail.com>
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

On Mon, Feb 21, 2022 at 4:59 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sun, Feb 20, 2022 at 6:17 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > On Sun, Feb 20, 2022 at 2:27 AM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Fri, Feb 18, 2022 at 1:56 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> > > >
> > > > Set the cgroup path when a bpf prog is attached to a cgroup, and unset
> > > > it when the bpf prog is detached.
> > > >
> > > > Below is the result after this change,
> > > > $ cat progs.debug
> > > >   id name             attached
> > > >    5 dump_bpf_map     bpf_iter_bpf_map
> > > >    7 dump_bpf_prog    bpf_iter_bpf_prog
> > > >   17 bpf_sockmap      cgroup:/
> > > >   19 bpf_redir_proxy
> > > >
> > > > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > > > ---
> > > >  kernel/bpf/cgroup.c | 8 ++++++++
> > > >  1 file changed, 8 insertions(+)
> > > >
> > > > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > > > index 43eb3501721b..ebd87e54f2d0 100644
> > > > --- a/kernel/bpf/cgroup.c
> > > > +++ b/kernel/bpf/cgroup.c
> > > > @@ -440,6 +440,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> > > >         struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
> > > >         struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
> > > >         enum cgroup_bpf_attach_type atype;
> > > > +       char cgrp_path[64] = "cgroup:";
> > > >         struct bpf_prog_list *pl;
> > > >         struct list_head *progs;
> > > >         int err;
> > > > @@ -508,6 +509,11 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> > > >         else
> > > >                 static_branch_inc(&cgroup_bpf_enabled_key[atype]);
> > > >         bpf_cgroup_storages_link(new_storage, cgrp, type);
> > > > +
> > > > +       cgroup_name(cgrp, cgrp_path + strlen("cgroup:"), 64);
> > > > +       cgrp_path[63] = '\0';
> > > > +       prog->aux->attach_name = kstrdup(cgrp_path, GFP_KERNEL);
> > > > +
> > >
> > > This is pure debug code. We cannot have it in the kernel.
> > > Not even under #ifdef.
> > >
> > > Please do such debug code on a side as your own bpf program.
> > > For example by kprobe-ing in this function and keeping the path
> > > in a bpf map or send it to user space via ringbuf.
> > > Or enable cgroup tracepoint and monitor cgroup_mkdir with full path.
> > > Record it in user space or in bpf map, etc.
> > >
> >
> > It is another possible solution to  hook the related kernel functions
> > or tracepoints, but it may be a little complicated to track all the
> > bpf attach types, for example we also want to track
> > BPF_PROG_TYPE_SK_MSG[1], BPF_PROG_TYPE_FLOW_DISSECTOR and etc.
> > While the attach_name provides us a generic way to get how the bpf
> > progs are attached, which can't be got by bpftool.
>
> bpftool can certainly print such details.
> See how it's using task_file iterator.
> It can be extended to look into cgroups and sockmap,
> and for each program print "sockmap:%d", map->id if so desired.

I have read through the task_file code, but I haven't found a direct
way to get the attached cgroups or maps of a specified prog.
It is easy to look into a cgroup or sockmap, but the key point here is
which is the proper cgroup or sockmap.
There are some possible ways to get the attached cgroup or sockmap.

- add new member into struct bpf_prog_aux
   For example,
    struct bpf_prog_aux{
        union {
            struct cgroup *attached_cgrp;
            struct bpf_map *attached_map;
        };
    };
    Then we can easily get the related map or cgroup by extending
task_file iterator.

- build a table for attached maps, cgroups and etc
   Like we did for pinned files.
   Then we can compare the prog with the members stored in this table
one by one, but that seems a little heavy.

There may be some other ways.
I'm not sure if I clearly understand what you mean.
Hopefully you could help clarify it.

-- 
Thanks
Yafang
