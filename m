Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553265A1831
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 19:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242964AbiHYR6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 13:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242940AbiHYR6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 13:58:40 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90106BD0AE
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 10:58:38 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id b9so15798267qka.2
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 10:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=/GYRroV0j1HQtttqGy5ikwY0tvszI/gqxle1gBMtBi8=;
        b=ck2vOHHo88Dym2Eg5dmOrOFWsd+DiRYzQswvx+qDw/AaR6oiFaBJuXUDozxFm5NdeY
         RyIHT6ucnHWVYW6HD8rQ+SaVdPk0knVAyhXIGj5w8crdLz6PBdvQtFIIaAYJdupUr7Jf
         m1xm1ISYsse8LApnX9JzNrTmopx1LnHBt+ZKHiKPVL0+L8GUr6VeP3JxqlvNj8ckaxzE
         V4nu1m+hX8cIclMyiKgMwCNn4rkZdPf3FccCw+8fdv7PtEeMjXwsvWy9eT3Gia6EroBO
         DE334U1ACpqjXh+T9+MFSK12LcnccR145icds02vQe0SfVkKnQiwa6FtY2yGHSVjM2t+
         KwEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=/GYRroV0j1HQtttqGy5ikwY0tvszI/gqxle1gBMtBi8=;
        b=2OJPAMLtx0lXo0e7ezTnCFtwJdsJnk9M/1Ra4TgtIVUdOgZoeUnayTsGxiPKpcS9XA
         PFKJbyeaYLNFGeBds+S10N+lHY9ubjoSCefE7ssmPM3WHZ4UYK08kRh7Saff/bACvRRZ
         JSjgpcwZWS+11EP2Aba+w+5NLHUwNgMGmwVTImqFEHtZHFFqWj35htFTKizyNCyvo5HV
         aH6n4815At9Hi498QosAXYi+imFM2V+c4aX9T+OsGb4QtMWjUQyZ4L0nvsDcY6wgn9Eq
         eAiCzsq77+fFaE+/HnZlmS/vyDRdUFaiPNb/7WwTiWgzfydTRI6gpKJQ0a1kPpaTH2Ny
         Jd+w==
X-Gm-Message-State: ACgBeo3IeSiPdYfkHiu4LX6+YmHYFiZpNeyr6t3s9VUrlwqnboSBpCmU
        EghvYyK4vlJmP1q1PZ2nb58LWuXoug5O76e/xJNvwA==
X-Google-Smtp-Source: AA6agR6ELzGCme7sNE+BR81Sm1mE1ctCXPEA2yfDoucsxgkqNCq0OsDtN/7qgdFikCJXE381jvngdogkJXIw9FJc8Ew=
X-Received: by 2002:a05:620a:458c:b0:6bb:848a:b86b with SMTP id
 bp12-20020a05620a458c00b006bb848ab86bmr3882934qkb.267.1661450317552; Thu, 25
 Aug 2022 10:58:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220824030031.1013441-1-haoluo@google.com> <20220824030031.1013441-2-haoluo@google.com>
 <20220825152455.GA29058@blackbody.suse.cz>
In-Reply-To: <20220825152455.GA29058@blackbody.suse.cz>
From:   Hao Luo <haoluo@google.com>
Date:   Thu, 25 Aug 2022 10:58:26 -0700
Message-ID: <CA+khW7hKk8yMvsQCQjnEoR3=G9=77F2TgAEDa+uSVedoOE=NsA@mail.gmail.com>
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
        autolearn=unavailable autolearn_force=no version=3.4.6
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

Yep. Being able to take cgroup NS into account is my intention here.
Right now, I imagine the control plane who uses this default option is
the system daemon which lives in the init cgroup ns. They could always
specify a particular cgroup using ID or FD. Printing the whole
hierarchy is something a system daemon would do. Anyhow, can I add the
appended patch if there is going to be a v10 of this patch series? If
v9 is ok to merge, I can send the appended patch separately. Does that
sound good? The appended patch looks good to me, thanks!

>
> Also, that makes me think about iter initialization with ID. In contrast
> with FD passing (that's subject to some permissions and NS checks), the
> retrieval via ID is not equipped with that, ids are not unguessable and
> I'd consider cgroup IDs an implementation detail.
>
> So, is the ID initialization that much useful? (I have no idea about
> permissions model of BPF here, so it might be just fine but still it'd
> be good to take cgroup NS into account. Likely for BPF_ITER_ANCESTORS_UP
> too.)
>

Permission is a valid point about FD. There was discussion in an
earlier version of this patch series [0]. The good thing about ID is
that it can be passed across processes and it's meaningful to appear
in logs. It's more user-friendly. So we decided to support both.

[0] https://lore.kernel.org/netdev/YuK+eg3lgwJ2CJnJ@slm.duckdns.org/

> HTH,
> Michal
>
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
