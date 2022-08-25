Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7B455A1935
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 20:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243562AbiHYS40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 14:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243536AbiHYS4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 14:56:25 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B69DF580
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 11:56:23 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id h22so15989557qtu.2
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 11:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=EDk7Jt2uZRRncSr/gTEg0S0FNgT/gNpLO3FmZsA//fA=;
        b=lggwvEUATyTifL2BFcwYTuCjX5Xws2W1lUnfZWPbjeca+/WyDPPV48Q9AMavRDlRD9
         0ZfjTxVKSp297twRIc8IuHWBcdk5R7sgvfeMxzwFJwK3BFQzl/bxwh2wGzgZbwW4Tjh5
         v40GvDvWOSY9HKic0GWE+CLddsJooRKsz83kSnXyyqefqUn7nTemz1NS9gtLsqxvKUFt
         TS3pPtuFDCDj1o+PH7uQefAL0PefDqidAwV+pxmQO4KUdiCxhFGA/C7HXWygEt4uTiK+
         kVXRP2ku+pcRRt/7gUL4c8JkJN3YWi4lLZgYvrFRcHFTLcukfc+dkH30KcZFYOAHb/TQ
         GzEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=EDk7Jt2uZRRncSr/gTEg0S0FNgT/gNpLO3FmZsA//fA=;
        b=wSKdrsBfloEtG2WRvmZy7B9bFx22gkN4HpDMW01aZfWv0NX76e5XBMAUQ/+efVpiOe
         sRRaUC3W91UDfZxDZc0NscfpNLVfO5RkBspAoVvbekOpzsrfil+fA0sP8HxeKyZbmgg4
         6CwKSDpBF5C1anYgplkBlK22nSf6CfjIbXAnjbCotRcCPg2vIpVmx3JOebBmrQ4oivPZ
         2hRbR2aQj8sDkpfa3SSwXAT4iPU+QKp+KwVkA+VM2HkQ+Bx7iTiWJVE6U1aWiECdh/0h
         isoEwC6tu6bf9r6iiCT79/1STQkVoy8+mceoc+ktx5JkGcm38I7J7Bxt8vRNeDSFT+HT
         /Cvg==
X-Gm-Message-State: ACgBeo1f/X4MV+hnRlBq4J9HL4i8rhv2Olv0sdKWudEA47tmITgmSAxW
        MNpFC8oG2UZcAxOXBzWS818nPE6Fssi+l5kerU8AHQ==
X-Google-Smtp-Source: AA6agR4+6f7pQrnuF25efJzbU5gkQZA5lk82nYynYDm4cQbp8txuu728rDrQH0kY33qj/UaSLW5KTjzFmrBPbsElcdM=
X-Received: by 2002:ac8:57d3:0:b0:344:51fd:6b36 with SMTP id
 w19-20020ac857d3000000b0034451fd6b36mr4830086qta.299.1661453782442; Thu, 25
 Aug 2022 11:56:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220824030031.1013441-1-haoluo@google.com> <20220824030031.1013441-2-haoluo@google.com>
 <20220825152455.GA29058@blackbody.suse.cz>
In-Reply-To: <20220825152455.GA29058@blackbody.suse.cz>
From:   Hao Luo <haoluo@google.com>
Date:   Thu, 25 Aug 2022 11:56:11 -0700
Message-ID: <CA+khW7hdciswrjhY19uQu0rAurWXbfb4xuOYEZqXETu954=-sA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9 1/5] bpf: Introduce cgroup iter
To:     =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        KP Singh <kpsingh@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 8:24 AM Michal Koutn=C3=BD <mkoutny@suse.com> wrote=
:
>
> Hello.
>
> On Tue, Aug 23, 2022 at 08:00:27PM -0700, Hao Luo <haoluo@google.com> wro=
te:
> > +static int bpf_iter_attach_cgroup(struct bpf_prog *prog,
> > +                               union bpf_iter_link_info *linfo,
> > +                               struct bpf_iter_aux_info *aux)
> > +{
> > +     int fd =3D linfo->cgroup.cgroup_fd;
> > +     u64 id =3D linfo->cgroup.cgroup_id;
> > +     int order =3D linfo->cgroup.order;
> > +     struct cgroup *cgrp;
> > +
> > +     if (order !=3D BPF_ITER_DESCENDANTS_PRE &&
> > +         order !=3D BPF_ITER_DESCENDANTS_POST &&
> > +         order !=3D BPF_ITER_ANCESTORS_UP &&
> > +         order !=3D BPF_ITER_SELF_ONLY)
> > +             return -EINVAL;
> > +
> > +     if (fd && id)
> > +             return -EINVAL;
> > +
> > +     if (fd)
> > +             cgrp =3D cgroup_get_from_fd(fd);
> > +     else if (id)
> > +             cgrp =3D cgroup_get_from_id(id);
> > +     else /* walk the entire hierarchy by default. */
> > +             cgrp =3D cgroup_get_from_path("/");
> > +
> > +     if (IS_ERR(cgrp))
> > +             return PTR_ERR(cgrp);
>
> This section caught my eye.
>
> Perhaps the simpler way for the default hierachy fallback would be
>
>                 cgrp =3D &cgrp_dfl_root.cgrp;
>                 cgroup_get(cgroup)
>
> But maybe it's not what is the intention if cgroup NS should be taken
> into account and cgroup_get_from_path() is buggy in this regard.
>
> Would it make sense to prepend the patch below to your series?

Michal, this patch series has merged. Do you need me to send your
patch on your behalf, or you want to do it yourself?

> ----8<----
> From 1098e60e89d4d901b7eef04e531f2c889309a91b Mon Sep 17 00:00:00 2001
> From: =3D?UTF-8?q?Michal=3D20Koutn=3DC3=3DBD?=3D <mkoutny@suse.com>
> Date: Thu, 25 Aug 2022 15:19:04 +0200
> Subject: [PATCH] cgroup: Honor caller's cgroup NS when resolving path
> MIME-Version: 1.0
> Content-Type: text/plain; charset=3DUTF-8
> Content-Transfer-Encoding: 8bit
>
> cgroup_get_from_path() is not widely used function. Its callers presume
> the path is resolved under cgroup namespace. (There is one caller
> currently and resolving in init NS won't make harm (netfilter). However,
> future users may be subject to different effects when resolving
> globally.)
> Since, there's currently no use for the global resolution, modify the
> existing function to take cgroup NS into account.
>
> Fixes: a79a908fd2b0 ("cgroup: introduce cgroup namespaces")
> Signed-off-by: Michal Koutn=C3=BD <mkoutny@suse.com>
> ---
>  kernel/cgroup/cgroup.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index ffaccd6373f1..9280f4b41d8b 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -6603,8 +6603,12 @@ struct cgroup *cgroup_get_from_path(const char *pa=
th)
>  {
>         struct kernfs_node *kn;
>         struct cgroup *cgrp =3D ERR_PTR(-ENOENT);
> +       struct cgroup *root_cgrp;
>
> -       kn =3D kernfs_walk_and_get(cgrp_dfl_root.cgrp.kn, path);
> +       spin_lock_irq(&css_set_lock);
> +       root_cgrp =3D current_cgns_cgroup_from_root(&cgrp_dfl_root);
> +       kn =3D kernfs_walk_and_get(root_cgrp->kn, path);
> +       spin_unlock_irq(&css_set_lock);
>         if (!kn)
>                 goto out;
>
>
> base-commit: 3cc40a443a04d52b0c95255dce264068b01e9bfe
> --
> 2.37.0
>
