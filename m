Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE0474BCF00
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 15:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240285AbiBTOSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 09:18:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbiBTOSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 09:18:20 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F35E2DE6;
        Sun, 20 Feb 2022 06:17:59 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id h16so13089585iol.11;
        Sun, 20 Feb 2022 06:17:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nKxMOU1DEB+J7C5Ey0mu7XzkZAbcqEABhsAN519jxqI=;
        b=ZKH1JVuHHfjQWA43hbs0zhrpaEOQhO5ZauhSWa+iwYnduwMlQBosL2Iz3Ed1VT1Dg9
         I3a5jaHyyW2neiC9cCMeu/yjCNUFHFyOhtYlK0lHlf2rhuuk4eLN5znUxC3ee/uegCNP
         v6iYA45v5UUuabceYqSn3FG70GqPZ4ohVaNbNTaP8inIVd0cjEI2wmhgY4LdLU+0odpO
         sCsjIAgm1IgK0Vnu7I04I6wsTTy3vbJceP7GnbVMI51JkZnSncMH/5SH6K3sVxQ7Re6V
         Yythp8fnH2Mfz93pp4Lb5DnKh/sEBPGza+SaOlXxwvV4VsWIGAj/UJGvwsCC72QZTWSS
         XB6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nKxMOU1DEB+J7C5Ey0mu7XzkZAbcqEABhsAN519jxqI=;
        b=6e9UJsYagJffB0rQ3Y0vf9uG5htIiDjEUT+Ap1sxm4d9SKWdbebCWlmt+9E+FQZu0N
         2qhZ2KzpnbEwTMFvNLTY+hy591ktNOCiq/IfwhfN9g0k/m861VblWAKt3ajg0VzmU4xQ
         oPvMUXWYJl+pdzr39TSYwJrHGoow6xHvwccj2xRetD2dxcjf/C//xeqxdAiOwICTUUU0
         bmyyi8a2tXyiYb4sMEyZYVNaByln/MTR2sJWZX9ey1JYXgj2MdzmxVljW6Tl4nJJKarJ
         Hc282kYtz2KeY622nvDaojbh7znTKBF388Vq2lfeS2AbgBeFKNjpjTJ/mBZgqjfwttsD
         HKig==
X-Gm-Message-State: AOAM533TGRipAMswqt3wCfczb65c/Y4bfrUNj3hbD5kIPgmfXiL8o4re
        740clF1/JcWaTpgkBnga8wx/uT+rGeL0W4WWB60=
X-Google-Smtp-Source: ABdhPJyivfWBqfm3zm3f9HIv5ygNGQiavKRz100ocmYrz4Riq4wniMs0BySEGZPdq2rfBd+HlW/W6sXlH+KMAKSDQLg=
X-Received: by 2002:a02:3403:0:b0:314:b71f:eae7 with SMTP id
 x3-20020a023403000000b00314b71feae7mr7906502jae.6.1645366678534; Sun, 20 Feb
 2022 06:17:58 -0800 (PST)
MIME-Version: 1.0
References: <20220218095612.52082-1-laoar.shao@gmail.com> <20220218095612.52082-3-laoar.shao@gmail.com>
 <CAADnVQJhGmvY1NDsy9WE6tnqYM6JCmi4iZtB7xHuWh4yC-awPw@mail.gmail.com>
In-Reply-To: <CAADnVQJhGmvY1NDsy9WE6tnqYM6JCmi4iZtB7xHuWh4yC-awPw@mail.gmail.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Sun, 20 Feb 2022 22:17:22 +0800
Message-ID: <CALOAHbCytBP4osCXSZ_7+A69NuVf6SYDWGFC62O_MkHn9Fn10Q@mail.gmail.com>
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

On Sun, Feb 20, 2022 at 2:27 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Feb 18, 2022 at 1:56 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > Set the cgroup path when a bpf prog is attached to a cgroup, and unset
> > it when the bpf prog is detached.
> >
> > Below is the result after this change,
> > $ cat progs.debug
> >   id name             attached
> >    5 dump_bpf_map     bpf_iter_bpf_map
> >    7 dump_bpf_prog    bpf_iter_bpf_prog
> >   17 bpf_sockmap      cgroup:/
> >   19 bpf_redir_proxy
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  kernel/bpf/cgroup.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > index 43eb3501721b..ebd87e54f2d0 100644
> > --- a/kernel/bpf/cgroup.c
> > +++ b/kernel/bpf/cgroup.c
> > @@ -440,6 +440,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> >         struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
> >         struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
> >         enum cgroup_bpf_attach_type atype;
> > +       char cgrp_path[64] = "cgroup:";
> >         struct bpf_prog_list *pl;
> >         struct list_head *progs;
> >         int err;
> > @@ -508,6 +509,11 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> >         else
> >                 static_branch_inc(&cgroup_bpf_enabled_key[atype]);
> >         bpf_cgroup_storages_link(new_storage, cgrp, type);
> > +
> > +       cgroup_name(cgrp, cgrp_path + strlen("cgroup:"), 64);
> > +       cgrp_path[63] = '\0';
> > +       prog->aux->attach_name = kstrdup(cgrp_path, GFP_KERNEL);
> > +
>
> This is pure debug code. We cannot have it in the kernel.
> Not even under #ifdef.
>
> Please do such debug code on a side as your own bpf program.
> For example by kprobe-ing in this function and keeping the path
> in a bpf map or send it to user space via ringbuf.
> Or enable cgroup tracepoint and monitor cgroup_mkdir with full path.
> Record it in user space or in bpf map, etc.
>

It is another possible solution to  hook the related kernel functions
or tracepoints, but it may be a little complicated to track all the
bpf attach types, for example we also want to track
BPF_PROG_TYPE_SK_MSG[1], BPF_PROG_TYPE_FLOW_DISSECTOR and etc.
While the attach_name provides us a generic way to get how the bpf
progs are attached, which can't be got by bpftool.
It is not for debug-only purpose, while it gives us a better way to
maintain all the bpf progs running on a single host.

> Also please read Documentation/bpf/bpf_devel_QA.rst
> bpf patches should be based on bpf-next tree.
> These patches are not.

My local bpf-next repo is a little old.
Next time I will pull the newest bpf-next code before sending bpf
patches. Thanks for the information.

[1]. https://patchwork.kernel.org/project/netdevbpf/patch/20220218095612.52082-4-laoar.shao@gmail.com/

-- 
Thanks
Yafang
