Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B72BB5340F1
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 18:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236282AbiEYQBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 12:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232345AbiEYQBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 12:01:46 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43DF56B7FC
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 09:01:43 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id s28so30608524wrb.7
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 09:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1bT/SRtJA60uXkshI7XI2yP202vOkkHNq//n5wAg2xQ=;
        b=pShoJ9JqlF44PN48yTuy8vbKYfA8Edw0CpVbu5z/H8SQ6wLjZoz4778SRM5LFTRrIT
         LO7NkX4s4w7b6rHWXk06UDHPVDCLkHsbK7bPPwd9Ext87T887ce06WQayNBWNEJMKdAV
         YmvhOWL1Voq9mAW0ylEdr9plBXHuZ06hkTLTZL6iv9tsaW7ZZkyBD/uB5fh9N7z+twiZ
         nr3+nZZOialVAzH4N/Bltf5XH0H79LnT4ZqKr/yJWE9iAVtbDMLxMTo/7QNG0ldnqJzr
         4iOHWfretAWbHwTlPKVouFstjEwynshwKu6j7wIJBATpsZfFfkFH2RP+I0mjhGXC7sRo
         kKuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1bT/SRtJA60uXkshI7XI2yP202vOkkHNq//n5wAg2xQ=;
        b=MJKHBFrzGaSMj6ml9JQjY3HpJ5r9F20dX+dopJp348xgKrrLel/EXyTe7Whz8gMDvB
         b/zsM+98ZfIVHQFPocM4F/yG3T488MU4AxJB1MR/Cw36PwQWO4iJo4882ZHHXjMdjztv
         wWDlyI/yzCyaYNuYNtGd2MrhprqBTYuxE+pZy27Kq1uvwv8pEZLBaou8jLJaUCJi6Ox5
         J3v4pkAiVIpqqshAzJFFpoiulzKSkMbhFQECr78cV5CleAnQbxJ+g0Vv+8JQGo6qbLc8
         8mrD9DjgUX3TbeK1n4hEo38FU2RzJBBjZlxCVsVVdfb6N8e0a5M49/6oYSG55R7k9l6C
         oNPQ==
X-Gm-Message-State: AOAM530DqV7jaHj5YauLPrjejaTA1Kd/RBNoqQUuyZ8DJDG2qmvRJWKt
        Uv7+1QYG5E5g2NRMaQWrJ7OMYN5ZCt8eCORp4KoEaA==
X-Google-Smtp-Source: ABdhPJxE/GRM3CwbwFN/rN9bAtxg7Z/jg3Sy+Autai6Mi7YPdR6OkLDL6o+U3kG5ek7bYPQI0uNUfgq5deqB+StjbpU=
X-Received: by 2002:a5d:6c6e:0:b0:20f:c39b:c416 with SMTP id
 r14-20020a5d6c6e000000b0020fc39bc416mr20081467wrz.463.1653494501379; Wed, 25
 May 2022 09:01:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220518225531.558008-1-sdf@google.com> <20220518225531.558008-6-sdf@google.com>
 <20220524034857.jwbjciq3rfb3l5kx@kafai-mbp> <CAKH8qBuCZVNPZaCRWrTiv7deDCyOkofT_ypvAiuE=OMz=TUuJw@mail.gmail.com>
 <20220524175035.i2ltl7gcrp2sng5r@kafai-mbp> <CAEf4BzYEXKQ-J8EQtTiYci1wdrRG7SPpuGhejJFY0cc5QQovEQ@mail.gmail.com>
 <CAKH8qBuRvnVoY-KEa6ofTjc2Jh2HUZYb1U2USSxgT=ozk0_JUA@mail.gmail.com> <CAEf4BzYdH9aayLvKAVTAeQ2XSLZPDX9N+fbP+yZnagcKd7ytNA@mail.gmail.com>
In-Reply-To: <CAEf4BzYdH9aayLvKAVTAeQ2XSLZPDX9N+fbP+yZnagcKd7ytNA@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 25 May 2022 09:01:29 -0700
Message-ID: <CAKH8qBvQHFcSQQiig6YGRdnjTHnu0T7-q-mPNjRb_nbY49N-Xw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 05/11] bpf: implement BPF_PROG_QUERY for BPF_LSM_CGROUP
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
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

On Tue, May 24, 2022 at 9:39 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, May 24, 2022 at 9:03 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > On Tue, May 24, 2022 at 4:45 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Tue, May 24, 2022 at 10:50 AM Martin KaFai Lau <kafai@fb.com> wrote:
> > > >
> > > > On Tue, May 24, 2022 at 08:55:04AM -0700, Stanislav Fomichev wrote:
> > > > > On Mon, May 23, 2022 at 8:49 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > >
> > > > > > On Wed, May 18, 2022 at 03:55:25PM -0700, Stanislav Fomichev wrote:
> > > > > > > We have two options:
> > > > > > > 1. Treat all BPF_LSM_CGROUP the same, regardless of attach_btf_id
> > > > > > > 2. Treat BPF_LSM_CGROUP+attach_btf_id as a separate hook point
> > > > > > >
> > > > > > > I was doing (2) in the original patch, but switching to (1) here:
> > > > > > >
> > > > > > > * bpf_prog_query returns all attached BPF_LSM_CGROUP programs
> > > > > > > regardless of attach_btf_id
> > > > > > > * attach_btf_id is exported via bpf_prog_info
> > > > > > >
> > > > > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > > > > ---
> > > > > > >  include/uapi/linux/bpf.h |   5 ++
> > > > > > >  kernel/bpf/cgroup.c      | 103 +++++++++++++++++++++++++++------------
> > > > > > >  kernel/bpf/syscall.c     |   4 +-
> > > > > > >  3 files changed, 81 insertions(+), 31 deletions(-)
> > > > > > >
> > > > > > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > > > > > index b9d2d6de63a7..432fc5f49567 100644
> > > > > > > --- a/include/uapi/linux/bpf.h
> > > > > > > +++ b/include/uapi/linux/bpf.h
> > > > > > > @@ -1432,6 +1432,7 @@ union bpf_attr {
> > > > > > >               __u32           attach_flags;
> > > > > > >               __aligned_u64   prog_ids;
> > > > > > >               __u32           prog_cnt;
> > > > > > > +             __aligned_u64   prog_attach_flags; /* output: per-program attach_flags */
> > > > > > >       } query;
> > > > > > >
> > > > > > >       struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
> > > > > > > @@ -5911,6 +5912,10 @@ struct bpf_prog_info {
> > > > > > >       __u64 run_cnt;
> > > > > > >       __u64 recursion_misses;
> > > > > > >       __u32 verified_insns;
> > > > > > > +     /* BTF ID of the function to attach to within BTF object identified
> > > > > > > +      * by btf_id.
> > > > > > > +      */
> > > > > > > +     __u32 attach_btf_func_id;
> > > > > > >  } __attribute__((aligned(8)));
> > > > > > >
> > > > > > >  struct bpf_map_info {
> > > > > > > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > > > > > > index a959cdd22870..08a1015ee09e 100644
> > > > > > > --- a/kernel/bpf/cgroup.c
> > > > > > > +++ b/kernel/bpf/cgroup.c
> > > > > > > @@ -1074,6 +1074,7 @@ static int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
> > > > > > >  static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
> > > > > > >                             union bpf_attr __user *uattr)
> > > > > > >  {
> > > > > > > +     __u32 __user *prog_attach_flags = u64_to_user_ptr(attr->query.prog_attach_flags);
> > > > > > >       __u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
> > > > > > >       enum bpf_attach_type type = attr->query.attach_type;
> > > > > > >       enum cgroup_bpf_attach_type atype;
> > > > > > > @@ -1081,50 +1082,92 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
> > > > > > >       struct hlist_head *progs;
> > > > > > >       struct bpf_prog *prog;
> > > > > > >       int cnt, ret = 0, i;
> > > > > > > +     int total_cnt = 0;
> > > > > > >       u32 flags;
> > > > > > >
> > > > > > > -     atype = to_cgroup_bpf_attach_type(type);
> > > > > > > -     if (atype < 0)
> > > > > > > -             return -EINVAL;
> > > > > > > +     enum cgroup_bpf_attach_type from_atype, to_atype;
> > > > > > >
> > > > > > > -     progs = &cgrp->bpf.progs[atype];
> > > > > > > -     flags = cgrp->bpf.flags[atype];
> > > > > > > +     if (type == BPF_LSM_CGROUP) {
> > > > > > > +             from_atype = CGROUP_LSM_START;
> > > > > > > +             to_atype = CGROUP_LSM_END;
> > > > > > > +     } else {
> > > > > > > +             from_atype = to_cgroup_bpf_attach_type(type);
> > > > > > > +             if (from_atype < 0)
> > > > > > > +                     return -EINVAL;
> > > > > > > +             to_atype = from_atype;
> > > > > > > +     }
> > > > > > >
> > > > > > > -     effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> > > > > > > -                                           lockdep_is_held(&cgroup_mutex));
> > > > > > > +     for (atype = from_atype; atype <= to_atype; atype++) {
> > > > > > > +             progs = &cgrp->bpf.progs[atype];
> > > > > > > +             flags = cgrp->bpf.flags[atype];
> > > > > > >
> > > > > > > -     if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
> > > > > > > -             cnt = bpf_prog_array_length(effective);
> > > > > > > -     else
> > > > > > > -             cnt = prog_list_length(progs);
> > > > > > > +             effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> > > > > > > +                                                   lockdep_is_held(&cgroup_mutex));
> > > > > > >
> > > > > > > -     if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
> > > > > > > -             return -EFAULT;
> > > > > > > -     if (copy_to_user(&uattr->query.prog_cnt, &cnt, sizeof(cnt)))
> > > > > > > +             if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
> > > > > > > +                     total_cnt += bpf_prog_array_length(effective);
> > > > > > > +             else
> > > > > > > +                     total_cnt += prog_list_length(progs);
> > > > > > > +     }
> > > > > > > +
> > > > > > > +     if (type != BPF_LSM_CGROUP)
> > > > > > > +             if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
> > > > > > > +                     return -EFAULT;
> > > > > > > +     if (copy_to_user(&uattr->query.prog_cnt, &total_cnt, sizeof(total_cnt)))
> > > > > > >               return -EFAULT;
> > > > > > > -     if (attr->query.prog_cnt == 0 || !prog_ids || !cnt)
> > > > > > > +     if (attr->query.prog_cnt == 0 || !prog_ids || !total_cnt)
> > > > > > >               /* return early if user requested only program count + flags */
> > > > > > >               return 0;
> > > > > > > -     if (attr->query.prog_cnt < cnt) {
> > > > > > > -             cnt = attr->query.prog_cnt;
> > > > > > > +
> > > > > > > +     if (attr->query.prog_cnt < total_cnt) {
> > > > > > > +             total_cnt = attr->query.prog_cnt;
> > > > > > >               ret = -ENOSPC;
> > > > > > >       }
> > > > > > >
> > > > > > > -     if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
> > > > > > > -             return bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
> > > > > > > -     } else {
> > > > > > > -             struct bpf_prog_list *pl;
> > > > > > > -             u32 id;
> > > > > > > +     for (atype = from_atype; atype <= to_atype; atype++) {
> > > > > > > +             if (total_cnt <= 0)
> > > > > > > +                     break;
> > > > > > >
> > > > > > > -             i = 0;
> > > > > > > -             hlist_for_each_entry(pl, progs, node) {
> > > > > > > -                     prog = prog_list_prog(pl);
> > > > > > > -                     id = prog->aux->id;
> > > > > > > -                     if (copy_to_user(prog_ids + i, &id, sizeof(id)))
> > > > > > > -                             return -EFAULT;
> > > > > > > -                     if (++i == cnt)
> > > > > > > -                             break;
> > > > > > > +             progs = &cgrp->bpf.progs[atype];
> > > > > > > +             flags = cgrp->bpf.flags[atype];
> > > > > > > +
> > > > > > > +             effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> > > > > > > +                                                   lockdep_is_held(&cgroup_mutex));
> > > > > > > +
> > > > > > > +             if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
> > > > > > > +                     cnt = bpf_prog_array_length(effective);
> > > > > > > +             else
> > > > > > > +                     cnt = prog_list_length(progs);
> > > > > > > +
> > > > > > > +             if (cnt >= total_cnt)
> > > > > > > +                     cnt = total_cnt;
> > > > > > > +
> > > > > > > +             if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
> > > > > > > +                     ret = bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
> > > > > > > +             } else {
> > > > > > > +                     struct bpf_prog_list *pl;
> > > > > > > +                     u32 id;
> > > > > > > +
> > > > > > > +                     i = 0;
> > > > > > > +                     hlist_for_each_entry(pl, progs, node) {
> > > > > > > +                             prog = prog_list_prog(pl);
> > > > > > > +                             id = prog->aux->id;
> > > > > > > +                             if (copy_to_user(prog_ids + i, &id, sizeof(id)))
> > > > > > > +                                     return -EFAULT;
> > > > > > > +                             if (++i == cnt)
> > > > > > > +                                     break;
> > > > > > > +                     }
> > > > > > >               }
> > > > > > > +
> > > > > > > +             if (prog_attach_flags)
> > > > > > > +                     for (i = 0; i < cnt; i++)
> > > > > > > +                             if (copy_to_user(prog_attach_flags + i, &flags, sizeof(flags)))
> > > > > > > +                                     return -EFAULT;
> > > > > > > +
> > > > > > > +             prog_ids += cnt;
> > > > > > > +             total_cnt -= cnt;
> > > > > > > +             if (prog_attach_flags)
> > > > > > > +                     prog_attach_flags += cnt;
> > > > > > >       }
> > > > > > >       return ret;
> > > > > > >  }
> > > > > > > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > > > > > > index 5ed2093e51cc..4137583c04a2 100644
> > > > > > > --- a/kernel/bpf/syscall.c
> > > > > > > +++ b/kernel/bpf/syscall.c
> > > > > > > @@ -3520,7 +3520,7 @@ static int bpf_prog_detach(const union bpf_attr *attr)
> > > > > > >       }
> > > > > > >  }
> > > > > > >
> > > > > > > -#define BPF_PROG_QUERY_LAST_FIELD query.prog_cnt
> > > > > > > +#define BPF_PROG_QUERY_LAST_FIELD query.prog_attach_flags
> > > > > > >
> > > > > > >  static int bpf_prog_query(const union bpf_attr *attr,
> > > > > > >                         union bpf_attr __user *uattr)
> > > > > > > @@ -3556,6 +3556,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
> > > > > > >       case BPF_CGROUP_SYSCTL:
> > > > > > >       case BPF_CGROUP_GETSOCKOPT:
> > > > > > >       case BPF_CGROUP_SETSOCKOPT:
> > > > > > > +     case BPF_LSM_CGROUP:
> > > > > > >               return cgroup_bpf_prog_query(attr, uattr);
> > > > > > >       case BPF_LIRC_MODE2:
> > > > > > >               return lirc_prog_query(attr, uattr);
> > > > > > > @@ -4066,6 +4067,7 @@ static int bpf_prog_get_info_by_fd(struct file *file,
> > > > > > >
> > > > > > >       if (prog->aux->btf)
> > > > > > >               info.btf_id = btf_obj_id(prog->aux->btf);
> > > > > > > +     info.attach_btf_func_id = prog->aux->attach_btf_id;
> > > > > > Note that exposing prog->aux->attach_btf_id only may not be enough
> > > > > > unless it can assume info.attach_btf_id is always referring to btf_vmlinux
> > > > > > for all bpf prog types.
> > > > >
> > > > > We also export btf_id two lines above, right? Btw, I left a comment in
> > > > > the bpftool about those btf_ids, I'm not sure how resolve them and
> > > > > always assume vmlinux for now.
> > > > yeah, that btf_id above is the cgroup-lsm prog's btf_id which has its
> > > > func info, line info...etc.   It is not the one the attach_btf_id correspond
> > > > to.  attach_btf_id refers to either aux->attach_btf or aux->dst_prog's btf (or
> > > > target btf id here).
> > > >
> > > > It needs a consensus on where this attach_btf_id, target btf id, and
> > > > prog_attach_flags should be.  If I read the patch 7 thread correctly,
> > > > I think Andrii is suggesting to expose them to userspace through link, so
> > > > potentially putting them in bpf_link_info.  The bpf_prog_query will
> > > > output a list of link ids.  The same probably applies to
> > >
> > > Yep and I think it makes sense because link is representing one
> > > specific attachment (and I presume flags can be stored inside the link
> > > itself as well, right?).
> > >
> > > But if legacy non-link BPF_PROG_ATTACH is supported then using
> > > bpf_link_info won't cover legacy prog-only attachments.
> >
> > I don't have any attachment to the legacy apis, I'm supporting them
> > only because it takes two lines of code; we can go link-only if there
> > is an agreement that it's inherently better.
> >
> > How about I keep sys_bpf(BPF_PROG_QUERY) as is and I do a loop in the
> > userspace (for BPF_LSM_CGROUP only) over all links
> > (BPF_LINK_GET_NEXT_ID) and will find the the ones with matching prog
> > ids (BPF_LINK_GET_FD_BY_ID+BPF_OBJ_GET_INFO_BY_FD)?
> >
> > That way we keep new fields in bpf_link_info, but we don't have to
> > extend sys_bpf(BPF_PROG_QUERY) because there doesn't seem to be a good
> > way to do it. Exporting links via new link_fds would mean we'd have to
> > support BPF_F_QUERY_EFFECTIVE, but getting an effective array of links
> > seems to be messy. If, in the future, we figure out a better way to
> > expose a list of attached/effective links per cgroup, we can
> > convert/optimize bpftool.
>
> Why not use iter/bpf_link program (see progs/bpf_iter_bpf_link.c for
> an example) instead? Once you have struct bpf_link and you know it's
> cgroup link, you can cast it to struct bpf_cgroup_link and get access
> to prog and cgroup. From cgroup to cgroup_bpf you can even get access
> to effective array. Basically whatever kernel has access to you can
> have access to from bpftool without extending any UAPIs.

Seems a bit too involved just to read back the fields? I might as well
use drgn? I'm also not sure about the implementation: will I be able
to upcast bpf_link to bpf_cgroup_link in the bpf prog? And getting
attach_type might be problematic from the iterator program as well: I
need to call kernel's bpf_lsm_attach_type_get to find atype for
attach_btf_id, I'd have to export it as kfunc?
