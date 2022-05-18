Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B5052B0CB
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 05:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiERDb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 23:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiERDbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 23:31:53 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FEB814B0;
        Tue, 17 May 2022 20:31:50 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id y13so546402eje.2;
        Tue, 17 May 2022 20:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CRUVZxUiPFa++e0erHqoMtj4bXpVQNsrlJ20yGYjhvc=;
        b=UwonYpJJCOJV4Rl7KWzUFXn0d60C4PgqizzRx0Ah9Shb0qiH5aqP83U/u+FcVa5Wfq
         O/hMSFCfmDK31AJ9JXapppG2PLQBbVA6nFgL0Y+z2AUvXvfw8xzLsHhVxx7sDmLfTLrx
         FIb9S/lQLvRvSCRBJ3CSgRw56hvNYE1DYskMaNFJSgLaEQuqsP17dWNUri3tmaHzzQH5
         sOkr1XsYK0vRGLqcoihOHwP6JVEqWhwvjgVHeV+w0BQHD3uFtrcyzdoJMq8YrRF/AMLg
         dWj4rUi0c2iEgqxCLv6d1am3njz7IVZP7jrt+jtALdyHMcHGoHA5fp8vpUe8x7V9+6LT
         iT7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CRUVZxUiPFa++e0erHqoMtj4bXpVQNsrlJ20yGYjhvc=;
        b=vUl3XH4yEAAEFL0eON/Vb1oTDXF9wzPoIc3YN8SPgjcFkA7x8RjPrks0q4qMx2+UON
         j9B5iiV/cwti9GDkT1lUNSe/+LdqFh4WkF8dR0rirG3FVyFM19ph9rV45iBq3lzAzYRM
         IcQI/lRv659xfXl5xhQCcHtggF4PUdfyJj3B3xvx9Q3QKrUzLJhC9lMJE0/2aQtVWZnc
         jLjQdU3Wgs+p4YPyfkVqB7YGSrIfcjsqu+KNxHkoxjWASPhVyHU/ih2XmESt1k5KViCB
         gwKlf/9zhD1V/9P147FQTqrKqQEm8UlvvNtyUhTE0VOAYl8CCFJ3626CN5JaF+UwWsFc
         G8EQ==
X-Gm-Message-State: AOAM530z6yNQgPjLhnMP//29vY75DBdYtOk9Jxm8xbwGfUOULB+nAgNU
        yqxTwsLHEW09mD7xVHcSQQEXt6toZmILPofLnW4=
X-Google-Smtp-Source: ABdhPJzZesTdsqqQsPaLv5+45A2/zx0v+IlanzmxIY6npSHLfR6XsED9IFJz3gtqYpZ8pLNTrrgG8bmj/AiRbKAvETw=
X-Received: by 2002:a17:907:7ea7:b0:6f4:7a72:da92 with SMTP id
 qb39-20020a1709077ea700b006f47a72da92mr22032393ejc.348.1652844709009; Tue, 17
 May 2022 20:31:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220517034107.92194-1-imagedong@tencent.com> <CAADnVQLRmv107zFL-dgB07Mf8NmR0TCAC9eG9aZ1O4DG3=ityw@mail.gmail.com>
In-Reply-To: <CAADnVQLRmv107zFL-dgB07Mf8NmR0TCAC9eG9aZ1O4DG3=ityw@mail.gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 18 May 2022 11:31:37 +0800
Message-ID: <CADxym3bLXhgCK-BO6JL3OVbVdC9Tsc0k_LqMRBbXA7eOpUtdYQ@mail.gmail.com>
Subject: Re: [PATCH] bpf: add access control for map
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alan Maguire <alan.maguire@oracle.com>
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

On Wed, May 18, 2022 at 12:58 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, May 16, 2022 at 8:44 PM <menglong8.dong@gmail.com> wrote:
> >
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > Hello,
> >
> > I have a idea about the access control of eBPF map, could you help
> > to see if it works?
> >
> > For now, only users with the CAP_SYS_ADMIN or CAP_BPF have the right
> > to access the data in eBPF maps. So I'm thinking, are there any way
> > to control the access to the maps, just like what we do to files?
>
> The bpf objects pinned in bpffs should always be accessible
> as files regardless of sysctl or cap-s.
>
> > Therefore, we can decide who have the right to read the map and who
> > can write.
> >
> > I think it is useful in some case. For example, I made a eBPF-based
> > network statistics program, and the information is stored in an array
> > map. And I want all users can read the information in the map, without
> > changing the capacity of them. As the information is iunsensitive,
> > normal users can read it. This make publish-consume mode possible,
> > the eBPF program is publisher and the user space program is consumer.
>
> Right. It is a choice of the bpf prog which data expose in the map.
>
> > So this aim can be achieve, if we can control the access of maps as a
> > file. There are many ways I thought, and I choosed one to implement:
> >
> > While pining the map, add the inode that is created to a list on the
> > map. root can change the permission of the inode through the pin path.
> > Therefore, we can try to find the inode corresponding to current user
> > namespace in the list, and check whether user have permission to read
> > or write.
> >
> > The steps can be:
> >
> > 1. create the map with BPF_F_UMODE flags, which imply that enable
> >    access control in this map.
> > 2. load and pin the map on /sys/fs/bpf/xxx.
> > 3. change the umode of /sys/fs/bpf/xxx with 'chmod 744 /sys/fs/bpf/xxx',
> >    therefor all user can read the map.
>
> This behavior should be available by default.
> Only sysctl was preventing it. It's being fixed by
> the following patch. Please take a look at:
> https://patchwork.kernel.org/project/netdevbpf/patch/1652788780-25520-2-git-send-email-alan.maguire@oracle.com/
>
> Does it solve your use case?

Yeah, it seems this patch gives another way: give users all access to
bpf commands (except map_create and prog_load). Therefore, users
that have the access to the pin path have corresponding r/w of the
eBPF object. This patch can cover my case.

However, this seems to give users too much permission (or the
access check is not enough?) I have do a test:

1. load a ebpf program of type cgroup and pin it on
   /sys/fs/bpf/post_bind as root.
2. give users access to read /sys/fs/bpf/post_bind
3. Now, all users can attach or detach the eBPF program
   to /sys/fs/cgroup/, who have only read access to the ebpf
   and the cgroup.

I think there are many such cases. Is this fine?

>
> > @@ -542,14 +557,26 @@ int bpf_obj_get_user(const char __user *pathname, int flags)
> >         if (IS_ERR(raw))
> >                 return PTR_ERR(raw);
> >
> > -       if (type == BPF_TYPE_PROG)
> > +       if (type != BPF_TYPE_MAP && !bpf_capable())
> > +               return -EPERM;
>
> obj_get already implements normal ACL style access to files.
> Let's not fragment this security model with extra cap checks.
>

Yeah, my way is too rough.

> > +
> > +       switch (type) {
> > +       case BPF_TYPE_PROG:
> >                 ret = bpf_prog_new_fd(raw);
> > -       else if (type == BPF_TYPE_MAP)
> > +               break;
> > +       case BPF_TYPE_MAP:
> > +               if (bpf_map_permission(raw, f_flags)) {
> > +                       bpf_any_put(raw, type);
> > +                       return -EPERM;
> > +               }
>
> bpf_obj_do_get() already does such check.
>

With the patch you mentioned above, now bpf_obj_do_get()
can do this job, as normal users can also get there too.

> > +int bpf_map_permission(struct bpf_map *map, int flags)
> > +{
> > +       struct bpf_map_inode *map_inode;
> > +       struct user_namespace *ns;
> > +
> > +       if (capable(CAP_SYS_ADMIN))
> > +               return 0;
> > +
> > +       if (!(map->map_flags & BPF_F_UMODE))
> > +               return -1;
> > +
> > +       rcu_read_lock();
> > +       list_for_each_entry_rcu(map_inode, &map->inode_list, list) {
> > +               ns = map_inode->inode->i_sb->s_user_ns;
> > +               if (ns == current_user_ns())
> > +                       goto found;
> > +       }
> > +       rcu_read_unlock();
> > +       return -1;
> > +found:
> > +       rcu_read_unlock();
> > +       return inode_permission(ns, map_inode->inode, ACC_MODE(flags));
> > +}
>
> See path_permission() in bpf_obj_do_get().
>
> >  static int bpf_map_get_fd_by_id(const union bpf_attr *attr)
> > @@ -3720,9 +3757,6 @@ static int bpf_map_get_fd_by_id(const union bpf_attr *attr)
> >             attr->open_flags & ~BPF_OBJ_FLAG_MASK)
> >                 return -EINVAL;
> >
> > -       if (!capable(CAP_SYS_ADMIN))
> > -               return -EPERM;
> > -
>
> This part we cannot relax.
> What you're trying to do is to bypass path checks
> by pointing at a map with its ID only.
> That contradicts to your official goal in the cover letter.
>
> bpf_map_get_fd_by_id() has to stay cap_sys_admin only.
> Exactly for the reason that bpf subsystem has file ACL style.
> fd_by_id is a debug interface used by tools like bpftool and
> root admin that needs to see the system as a whole.
> Normal tasks/processes need to use bpffs and pin files with
> correct permissions to pass maps from one process to another.
> Or use FD passing kernel facilities.

Yeah, this part is not necessary for me either. Without this
part, the current code already can do what I wanted.

Thanks
Menglong Dong
