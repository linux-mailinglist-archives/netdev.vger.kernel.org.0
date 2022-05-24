Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682E4532DE6
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 17:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239125AbiEXPzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 11:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239114AbiEXPzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 11:55:19 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11069728B
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 08:55:17 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id x12so2084784wrg.2
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 08:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PRjMEPpJhhvNzJfYuyFcpUO/ZYV0Mptzs7O7U43AFao=;
        b=YU4ymip4VgpuHKC1Plgw9bCu2Vou5zASXvaxwPMzAuHYh6vot1oedEgJKi483OOgyr
         Qo958CQyNJoqusHva9hZVWgYfpFIjzGnxuvBWVpt0q/umYVKQrSEQMRID86edrm1SG6d
         RPPUW/gWFTkiEjlHDuolfxpf2keLNfsU2dREORGFAasIhFVDF3QwGXKYJ3TUodk6+Rk/
         3OzOron4VDTeUad0BrKdH523qovgEtLfpIOUdkjNEfIV7R2UfDZrBIVqvqEY3NNn/1oM
         OKGgjYhlcO8KJSMan8h0XZDnGUE0l9ra+ik4jsI8UyAijU/8XlrfRfvHDLxrZc35Dq3S
         /ltA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PRjMEPpJhhvNzJfYuyFcpUO/ZYV0Mptzs7O7U43AFao=;
        b=iQ4ENCdBEKq8mOR4VJ4JupUMNt/UzzDNxVCvVT5/tXRcHNaNzIP06NQBlhh5IFNh3i
         aY/6kwZwgthDJr9nRZxARjajVna8cldoenw9XpSuTzJLAeFAV6K79zGr2kFwGQCK3rTE
         6E4zpt/2KtzETycKUAFm+5DQvwaUkbMNPKR7nsdfOVn2NNAtV/K8WYmpDSaiYSbX1SEP
         WvXlRl7MSx0qFFdkxpTURDgC97FiKnum/QTPnhHD6YQapg4g6c4uDezV8jwv/gxndKTf
         NOY0XeylYb1tdyl5ZknQnbC5caRQ99Xf9mOXDEa9XEot6pQ09WPeeOCrJJuLr46mkSrf
         hEcQ==
X-Gm-Message-State: AOAM533q/WgoInbasSCLtNp1bjMNOrT0Mx5EFoVnwuOBNBLhbeerATzf
        8o6Nv6wpS6BfATz6mGizmSuxrXouGCvGvegSmsnDZQ==
X-Google-Smtp-Source: ABdhPJyUDMAvKVuAcuDBaufoBbVCEZnPdvxhjNOY7R1wk0PEda2kq3i22SmGXXB/RxGnHqNsmUl7FcZnlbM/mmpGVAA=
X-Received: by 2002:a5d:4a43:0:b0:20f:c53d:6796 with SMTP id
 v3-20020a5d4a43000000b0020fc53d6796mr9078837wrs.15.1653407716152; Tue, 24 May
 2022 08:55:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220518225531.558008-1-sdf@google.com> <20220518225531.558008-6-sdf@google.com>
 <20220524034857.jwbjciq3rfb3l5kx@kafai-mbp>
In-Reply-To: <20220524034857.jwbjciq3rfb3l5kx@kafai-mbp>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 24 May 2022 08:55:04 -0700
Message-ID: <CAKH8qBuCZVNPZaCRWrTiv7deDCyOkofT_ypvAiuE=OMz=TUuJw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 05/11] bpf: implement BPF_PROG_QUERY for BPF_LSM_CGROUP
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Mon, May 23, 2022 at 8:49 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Wed, May 18, 2022 at 03:55:25PM -0700, Stanislav Fomichev wrote:
> > We have two options:
> > 1. Treat all BPF_LSM_CGROUP the same, regardless of attach_btf_id
> > 2. Treat BPF_LSM_CGROUP+attach_btf_id as a separate hook point
> >
> > I was doing (2) in the original patch, but switching to (1) here:
> >
> > * bpf_prog_query returns all attached BPF_LSM_CGROUP programs
> > regardless of attach_btf_id
> > * attach_btf_id is exported via bpf_prog_info
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  include/uapi/linux/bpf.h |   5 ++
> >  kernel/bpf/cgroup.c      | 103 +++++++++++++++++++++++++++------------
> >  kernel/bpf/syscall.c     |   4 +-
> >  3 files changed, 81 insertions(+), 31 deletions(-)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index b9d2d6de63a7..432fc5f49567 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -1432,6 +1432,7 @@ union bpf_attr {
> >               __u32           attach_flags;
> >               __aligned_u64   prog_ids;
> >               __u32           prog_cnt;
> > +             __aligned_u64   prog_attach_flags; /* output: per-program attach_flags */
> >       } query;
> >
> >       struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
> > @@ -5911,6 +5912,10 @@ struct bpf_prog_info {
> >       __u64 run_cnt;
> >       __u64 recursion_misses;
> >       __u32 verified_insns;
> > +     /* BTF ID of the function to attach to within BTF object identified
> > +      * by btf_id.
> > +      */
> > +     __u32 attach_btf_func_id;
> >  } __attribute__((aligned(8)));
> >
> >  struct bpf_map_info {
> > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > index a959cdd22870..08a1015ee09e 100644
> > --- a/kernel/bpf/cgroup.c
> > +++ b/kernel/bpf/cgroup.c
> > @@ -1074,6 +1074,7 @@ static int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
> >  static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
> >                             union bpf_attr __user *uattr)
> >  {
> > +     __u32 __user *prog_attach_flags = u64_to_user_ptr(attr->query.prog_attach_flags);
> >       __u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
> >       enum bpf_attach_type type = attr->query.attach_type;
> >       enum cgroup_bpf_attach_type atype;
> > @@ -1081,50 +1082,92 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
> >       struct hlist_head *progs;
> >       struct bpf_prog *prog;
> >       int cnt, ret = 0, i;
> > +     int total_cnt = 0;
> >       u32 flags;
> >
> > -     atype = to_cgroup_bpf_attach_type(type);
> > -     if (atype < 0)
> > -             return -EINVAL;
> > +     enum cgroup_bpf_attach_type from_atype, to_atype;
> >
> > -     progs = &cgrp->bpf.progs[atype];
> > -     flags = cgrp->bpf.flags[atype];
> > +     if (type == BPF_LSM_CGROUP) {
> > +             from_atype = CGROUP_LSM_START;
> > +             to_atype = CGROUP_LSM_END;
> > +     } else {
> > +             from_atype = to_cgroup_bpf_attach_type(type);
> > +             if (from_atype < 0)
> > +                     return -EINVAL;
> > +             to_atype = from_atype;
> > +     }
> >
> > -     effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> > -                                           lockdep_is_held(&cgroup_mutex));
> > +     for (atype = from_atype; atype <= to_atype; atype++) {
> > +             progs = &cgrp->bpf.progs[atype];
> > +             flags = cgrp->bpf.flags[atype];
> >
> > -     if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
> > -             cnt = bpf_prog_array_length(effective);
> > -     else
> > -             cnt = prog_list_length(progs);
> > +             effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> > +                                                   lockdep_is_held(&cgroup_mutex));
> >
> > -     if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
> > -             return -EFAULT;
> > -     if (copy_to_user(&uattr->query.prog_cnt, &cnt, sizeof(cnt)))
> > +             if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
> > +                     total_cnt += bpf_prog_array_length(effective);
> > +             else
> > +                     total_cnt += prog_list_length(progs);
> > +     }
> > +
> > +     if (type != BPF_LSM_CGROUP)
> > +             if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
> > +                     return -EFAULT;
> > +     if (copy_to_user(&uattr->query.prog_cnt, &total_cnt, sizeof(total_cnt)))
> >               return -EFAULT;
> > -     if (attr->query.prog_cnt == 0 || !prog_ids || !cnt)
> > +     if (attr->query.prog_cnt == 0 || !prog_ids || !total_cnt)
> >               /* return early if user requested only program count + flags */
> >               return 0;
> > -     if (attr->query.prog_cnt < cnt) {
> > -             cnt = attr->query.prog_cnt;
> > +
> > +     if (attr->query.prog_cnt < total_cnt) {
> > +             total_cnt = attr->query.prog_cnt;
> >               ret = -ENOSPC;
> >       }
> >
> > -     if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
> > -             return bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
> > -     } else {
> > -             struct bpf_prog_list *pl;
> > -             u32 id;
> > +     for (atype = from_atype; atype <= to_atype; atype++) {
> > +             if (total_cnt <= 0)
> > +                     break;
> >
> > -             i = 0;
> > -             hlist_for_each_entry(pl, progs, node) {
> > -                     prog = prog_list_prog(pl);
> > -                     id = prog->aux->id;
> > -                     if (copy_to_user(prog_ids + i, &id, sizeof(id)))
> > -                             return -EFAULT;
> > -                     if (++i == cnt)
> > -                             break;
> > +             progs = &cgrp->bpf.progs[atype];
> > +             flags = cgrp->bpf.flags[atype];
> > +
> > +             effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> > +                                                   lockdep_is_held(&cgroup_mutex));
> > +
> > +             if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
> > +                     cnt = bpf_prog_array_length(effective);
> > +             else
> > +                     cnt = prog_list_length(progs);
> > +
> > +             if (cnt >= total_cnt)
> > +                     cnt = total_cnt;
> > +
> > +             if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
> > +                     ret = bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
> > +             } else {
> > +                     struct bpf_prog_list *pl;
> > +                     u32 id;
> > +
> > +                     i = 0;
> > +                     hlist_for_each_entry(pl, progs, node) {
> > +                             prog = prog_list_prog(pl);
> > +                             id = prog->aux->id;
> > +                             if (copy_to_user(prog_ids + i, &id, sizeof(id)))
> > +                                     return -EFAULT;
> > +                             if (++i == cnt)
> > +                                     break;
> > +                     }
> >               }
> > +
> > +             if (prog_attach_flags)
> > +                     for (i = 0; i < cnt; i++)
> > +                             if (copy_to_user(prog_attach_flags + i, &flags, sizeof(flags)))
> > +                                     return -EFAULT;
> > +
> > +             prog_ids += cnt;
> > +             total_cnt -= cnt;
> > +             if (prog_attach_flags)
> > +                     prog_attach_flags += cnt;
> >       }
> >       return ret;
> >  }
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index 5ed2093e51cc..4137583c04a2 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -3520,7 +3520,7 @@ static int bpf_prog_detach(const union bpf_attr *attr)
> >       }
> >  }
> >
> > -#define BPF_PROG_QUERY_LAST_FIELD query.prog_cnt
> > +#define BPF_PROG_QUERY_LAST_FIELD query.prog_attach_flags
> >
> >  static int bpf_prog_query(const union bpf_attr *attr,
> >                         union bpf_attr __user *uattr)
> > @@ -3556,6 +3556,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
> >       case BPF_CGROUP_SYSCTL:
> >       case BPF_CGROUP_GETSOCKOPT:
> >       case BPF_CGROUP_SETSOCKOPT:
> > +     case BPF_LSM_CGROUP:
> >               return cgroup_bpf_prog_query(attr, uattr);
> >       case BPF_LIRC_MODE2:
> >               return lirc_prog_query(attr, uattr);
> > @@ -4066,6 +4067,7 @@ static int bpf_prog_get_info_by_fd(struct file *file,
> >
> >       if (prog->aux->btf)
> >               info.btf_id = btf_obj_id(prog->aux->btf);
> > +     info.attach_btf_func_id = prog->aux->attach_btf_id;
> Note that exposing prog->aux->attach_btf_id only may not be enough
> unless it can assume info.attach_btf_id is always referring to btf_vmlinux
> for all bpf prog types.

We also export btf_id two lines above, right? Btw, I left a comment in
the bpftool about those btf_ids, I'm not sure how resolve them and
always assume vmlinux for now.
