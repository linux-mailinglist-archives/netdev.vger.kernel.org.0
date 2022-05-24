Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE60533408
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 01:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241388AbiEXXpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 19:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237091AbiEXXpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 19:45:38 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B851857B35;
        Tue, 24 May 2022 16:45:37 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id v7so286603ilj.7;
        Tue, 24 May 2022 16:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qaat1R9QebrN1k5p2Jis1uexAQ4KBDB4bKrmHVQ8Z04=;
        b=oMtMLjn4+dV3OUzkl8k5ug3tjtdXZnSZ4h6/L3mLW8MMUOCtDIDLYqtuSPBfYfJq+0
         bpxriwLpyi5HclW8E5UMxZe0FZw/C01ps57kyBP2uHbFsj/chi1bbSN1MkUzwChPAoMg
         1L1j0MV3xevBUDa65EFt7EH3yfyXY28gyleDBLe4b5tqPoT3WaaYQ5YWttMOPMzBHCiB
         atbly0wphtLS/yJpMkosKPN/TiirfrlcoALzms7YZesXc9VqPWB2lnzdhkADuI36lU5D
         Hl2O94J+dZdLF1lsyH/MQrOsAsAsYtEl7wWJPa/7F+02M7VrBZUl6WYlYouiwXLMKrLV
         l1DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qaat1R9QebrN1k5p2Jis1uexAQ4KBDB4bKrmHVQ8Z04=;
        b=NGjbwCqgCd1rb1/D3tKk5G1mEJfCuPd2b50H5xpsSzRYoTEu4agTFVz4vT5w4kOs8V
         X5A1VN7tzzB3mLM4/9AwiWlg2iJ8yms/ySpqHWoe12mdEaXb8iFZN+S14m7yGSn/ylfk
         OJ5NWL2l4+nqqgpbQPWK7GN42cnkV3l2Rz8I9ESJonj5tXK9M/5CmvO+Zg+aXnbzOOwL
         SrwE3/Go+qJoPm4VcNCm/J4LXaDsLdCwhTnSOecqg55zlKX+GUEg0V4FpHw5NI84F9u3
         8+/s5Lr66jVzxBLoVgrVi4RfbFFsqkgkiBvDD4E5YRRSes6prmtuHjoBf0bvpFwCT1Mc
         IgtQ==
X-Gm-Message-State: AOAM532rYHLqs8vGmpJw+T9eyOA3A3vJn3d0wGNEIhVAG+UYaSALAF7N
        ua0qo9/mp8R/lATwivPLQ6d1Iy00WhBBv4ZFKXY=
X-Google-Smtp-Source: ABdhPJzPkjkldbTHuPxuradFbxd5LUAbAyaoNjGPM1iewREMWUquYf37x2RV6iqhx0wFKJRurCzKUo/O/bwefb+vPdc=
X-Received: by 2002:a05:6e02:1d85:b0:2d1:39cf:380c with SMTP id
 h5-20020a056e021d8500b002d139cf380cmr14763025ila.239.1653435937053; Tue, 24
 May 2022 16:45:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220518225531.558008-1-sdf@google.com> <20220518225531.558008-6-sdf@google.com>
 <20220524034857.jwbjciq3rfb3l5kx@kafai-mbp> <CAKH8qBuCZVNPZaCRWrTiv7deDCyOkofT_ypvAiuE=OMz=TUuJw@mail.gmail.com>
 <20220524175035.i2ltl7gcrp2sng5r@kafai-mbp>
In-Reply-To: <20220524175035.i2ltl7gcrp2sng5r@kafai-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 24 May 2022 16:45:25 -0700
Message-ID: <CAEf4BzYEXKQ-J8EQtTiYci1wdrRG7SPpuGhejJFY0cc5QQovEQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 05/11] bpf: implement BPF_PROG_QUERY for BPF_LSM_CGROUP
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
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

On Tue, May 24, 2022 at 10:50 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, May 24, 2022 at 08:55:04AM -0700, Stanislav Fomichev wrote:
> > On Mon, May 23, 2022 at 8:49 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > On Wed, May 18, 2022 at 03:55:25PM -0700, Stanislav Fomichev wrote:
> > > > We have two options:
> > > > 1. Treat all BPF_LSM_CGROUP the same, regardless of attach_btf_id
> > > > 2. Treat BPF_LSM_CGROUP+attach_btf_id as a separate hook point
> > > >
> > > > I was doing (2) in the original patch, but switching to (1) here:
> > > >
> > > > * bpf_prog_query returns all attached BPF_LSM_CGROUP programs
> > > > regardless of attach_btf_id
> > > > * attach_btf_id is exported via bpf_prog_info
> > > >
> > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > ---
> > > >  include/uapi/linux/bpf.h |   5 ++
> > > >  kernel/bpf/cgroup.c      | 103 +++++++++++++++++++++++++++------------
> > > >  kernel/bpf/syscall.c     |   4 +-
> > > >  3 files changed, 81 insertions(+), 31 deletions(-)
> > > >
> > > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > > index b9d2d6de63a7..432fc5f49567 100644
> > > > --- a/include/uapi/linux/bpf.h
> > > > +++ b/include/uapi/linux/bpf.h
> > > > @@ -1432,6 +1432,7 @@ union bpf_attr {
> > > >               __u32           attach_flags;
> > > >               __aligned_u64   prog_ids;
> > > >               __u32           prog_cnt;
> > > > +             __aligned_u64   prog_attach_flags; /* output: per-program attach_flags */
> > > >       } query;
> > > >
> > > >       struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
> > > > @@ -5911,6 +5912,10 @@ struct bpf_prog_info {
> > > >       __u64 run_cnt;
> > > >       __u64 recursion_misses;
> > > >       __u32 verified_insns;
> > > > +     /* BTF ID of the function to attach to within BTF object identified
> > > > +      * by btf_id.
> > > > +      */
> > > > +     __u32 attach_btf_func_id;
> > > >  } __attribute__((aligned(8)));
> > > >
> > > >  struct bpf_map_info {
> > > > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > > > index a959cdd22870..08a1015ee09e 100644
> > > > --- a/kernel/bpf/cgroup.c
> > > > +++ b/kernel/bpf/cgroup.c
> > > > @@ -1074,6 +1074,7 @@ static int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
> > > >  static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
> > > >                             union bpf_attr __user *uattr)
> > > >  {
> > > > +     __u32 __user *prog_attach_flags = u64_to_user_ptr(attr->query.prog_attach_flags);
> > > >       __u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
> > > >       enum bpf_attach_type type = attr->query.attach_type;
> > > >       enum cgroup_bpf_attach_type atype;
> > > > @@ -1081,50 +1082,92 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
> > > >       struct hlist_head *progs;
> > > >       struct bpf_prog *prog;
> > > >       int cnt, ret = 0, i;
> > > > +     int total_cnt = 0;
> > > >       u32 flags;
> > > >
> > > > -     atype = to_cgroup_bpf_attach_type(type);
> > > > -     if (atype < 0)
> > > > -             return -EINVAL;
> > > > +     enum cgroup_bpf_attach_type from_atype, to_atype;
> > > >
> > > > -     progs = &cgrp->bpf.progs[atype];
> > > > -     flags = cgrp->bpf.flags[atype];
> > > > +     if (type == BPF_LSM_CGROUP) {
> > > > +             from_atype = CGROUP_LSM_START;
> > > > +             to_atype = CGROUP_LSM_END;
> > > > +     } else {
> > > > +             from_atype = to_cgroup_bpf_attach_type(type);
> > > > +             if (from_atype < 0)
> > > > +                     return -EINVAL;
> > > > +             to_atype = from_atype;
> > > > +     }
> > > >
> > > > -     effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> > > > -                                           lockdep_is_held(&cgroup_mutex));
> > > > +     for (atype = from_atype; atype <= to_atype; atype++) {
> > > > +             progs = &cgrp->bpf.progs[atype];
> > > > +             flags = cgrp->bpf.flags[atype];
> > > >
> > > > -     if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
> > > > -             cnt = bpf_prog_array_length(effective);
> > > > -     else
> > > > -             cnt = prog_list_length(progs);
> > > > +             effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> > > > +                                                   lockdep_is_held(&cgroup_mutex));
> > > >
> > > > -     if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
> > > > -             return -EFAULT;
> > > > -     if (copy_to_user(&uattr->query.prog_cnt, &cnt, sizeof(cnt)))
> > > > +             if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
> > > > +                     total_cnt += bpf_prog_array_length(effective);
> > > > +             else
> > > > +                     total_cnt += prog_list_length(progs);
> > > > +     }
> > > > +
> > > > +     if (type != BPF_LSM_CGROUP)
> > > > +             if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
> > > > +                     return -EFAULT;
> > > > +     if (copy_to_user(&uattr->query.prog_cnt, &total_cnt, sizeof(total_cnt)))
> > > >               return -EFAULT;
> > > > -     if (attr->query.prog_cnt == 0 || !prog_ids || !cnt)
> > > > +     if (attr->query.prog_cnt == 0 || !prog_ids || !total_cnt)
> > > >               /* return early if user requested only program count + flags */
> > > >               return 0;
> > > > -     if (attr->query.prog_cnt < cnt) {
> > > > -             cnt = attr->query.prog_cnt;
> > > > +
> > > > +     if (attr->query.prog_cnt < total_cnt) {
> > > > +             total_cnt = attr->query.prog_cnt;
> > > >               ret = -ENOSPC;
> > > >       }
> > > >
> > > > -     if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
> > > > -             return bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
> > > > -     } else {
> > > > -             struct bpf_prog_list *pl;
> > > > -             u32 id;
> > > > +     for (atype = from_atype; atype <= to_atype; atype++) {
> > > > +             if (total_cnt <= 0)
> > > > +                     break;
> > > >
> > > > -             i = 0;
> > > > -             hlist_for_each_entry(pl, progs, node) {
> > > > -                     prog = prog_list_prog(pl);
> > > > -                     id = prog->aux->id;
> > > > -                     if (copy_to_user(prog_ids + i, &id, sizeof(id)))
> > > > -                             return -EFAULT;
> > > > -                     if (++i == cnt)
> > > > -                             break;
> > > > +             progs = &cgrp->bpf.progs[atype];
> > > > +             flags = cgrp->bpf.flags[atype];
> > > > +
> > > > +             effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> > > > +                                                   lockdep_is_held(&cgroup_mutex));
> > > > +
> > > > +             if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
> > > > +                     cnt = bpf_prog_array_length(effective);
> > > > +             else
> > > > +                     cnt = prog_list_length(progs);
> > > > +
> > > > +             if (cnt >= total_cnt)
> > > > +                     cnt = total_cnt;
> > > > +
> > > > +             if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
> > > > +                     ret = bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
> > > > +             } else {
> > > > +                     struct bpf_prog_list *pl;
> > > > +                     u32 id;
> > > > +
> > > > +                     i = 0;
> > > > +                     hlist_for_each_entry(pl, progs, node) {
> > > > +                             prog = prog_list_prog(pl);
> > > > +                             id = prog->aux->id;
> > > > +                             if (copy_to_user(prog_ids + i, &id, sizeof(id)))
> > > > +                                     return -EFAULT;
> > > > +                             if (++i == cnt)
> > > > +                                     break;
> > > > +                     }
> > > >               }
> > > > +
> > > > +             if (prog_attach_flags)
> > > > +                     for (i = 0; i < cnt; i++)
> > > > +                             if (copy_to_user(prog_attach_flags + i, &flags, sizeof(flags)))
> > > > +                                     return -EFAULT;
> > > > +
> > > > +             prog_ids += cnt;
> > > > +             total_cnt -= cnt;
> > > > +             if (prog_attach_flags)
> > > > +                     prog_attach_flags += cnt;
> > > >       }
> > > >       return ret;
> > > >  }
> > > > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > > > index 5ed2093e51cc..4137583c04a2 100644
> > > > --- a/kernel/bpf/syscall.c
> > > > +++ b/kernel/bpf/syscall.c
> > > > @@ -3520,7 +3520,7 @@ static int bpf_prog_detach(const union bpf_attr *attr)
> > > >       }
> > > >  }
> > > >
> > > > -#define BPF_PROG_QUERY_LAST_FIELD query.prog_cnt
> > > > +#define BPF_PROG_QUERY_LAST_FIELD query.prog_attach_flags
> > > >
> > > >  static int bpf_prog_query(const union bpf_attr *attr,
> > > >                         union bpf_attr __user *uattr)
> > > > @@ -3556,6 +3556,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
> > > >       case BPF_CGROUP_SYSCTL:
> > > >       case BPF_CGROUP_GETSOCKOPT:
> > > >       case BPF_CGROUP_SETSOCKOPT:
> > > > +     case BPF_LSM_CGROUP:
> > > >               return cgroup_bpf_prog_query(attr, uattr);
> > > >       case BPF_LIRC_MODE2:
> > > >               return lirc_prog_query(attr, uattr);
> > > > @@ -4066,6 +4067,7 @@ static int bpf_prog_get_info_by_fd(struct file *file,
> > > >
> > > >       if (prog->aux->btf)
> > > >               info.btf_id = btf_obj_id(prog->aux->btf);
> > > > +     info.attach_btf_func_id = prog->aux->attach_btf_id;
> > > Note that exposing prog->aux->attach_btf_id only may not be enough
> > > unless it can assume info.attach_btf_id is always referring to btf_vmlinux
> > > for all bpf prog types.
> >
> > We also export btf_id two lines above, right? Btw, I left a comment in
> > the bpftool about those btf_ids, I'm not sure how resolve them and
> > always assume vmlinux for now.
> yeah, that btf_id above is the cgroup-lsm prog's btf_id which has its
> func info, line info...etc.   It is not the one the attach_btf_id correspond
> to.  attach_btf_id refers to either aux->attach_btf or aux->dst_prog's btf (or
> target btf id here).
>
> It needs a consensus on where this attach_btf_id, target btf id, and
> prog_attach_flags should be.  If I read the patch 7 thread correctly,
> I think Andrii is suggesting to expose them to userspace through link, so
> potentially putting them in bpf_link_info.  The bpf_prog_query will
> output a list of link ids.  The same probably applies to

Yep and I think it makes sense because link is representing one
specific attachment (and I presume flags can be stored inside the link
itself as well, right?).

But if legacy non-link BPF_PROG_ATTACH is supported then using
bpf_link_info won't cover legacy prog-only attachments.

> the BPF_F_QUERY_EFFECTIVE query_flags but not sure about the prog_attach_flags
> in this case and probably the userspace can figure that out by using
> the cgroup_id in the link?  That is all I can think of right now
> and don't have better idea :)
