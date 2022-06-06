Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7669F53F238
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 00:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234175AbiFFWqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 18:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbiFFWqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 18:46:39 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6EDCA5022
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 15:46:37 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id n8so13313187plh.1
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 15:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hBlp0m0FfUT/dBVAsBVVQW1rlRH6/pse+3PC/lyMh6Y=;
        b=ahEQzHMg7A0nLLUBiMRgIv7hhXUcQOvHCaUvdeREvYoh5HcyXMR4axNkIP92BqdwwS
         wLmKboD+bbd1ZIqlL5PyptYfDe9vRAtZrTwxAnPcq6fKbMeGKfbJFKHelpHJoUW2LH+6
         sw5OzffXoMtAx0WUfLWTLp9pStJ/GLG7ecEK7YCxGkywL3h+OC+cDRSzYIKRNR6w8s3s
         yLCK73Qunb1IiH5lA3z8MuXxrVWVSHMWDREGaZRZyhafG5qiqh1k56BeNjrJ32GGNlO7
         9Bv5kSHmWA6n55Tspi3q1+lZ9fFAi3guur7/boQm/gJ4BIGEm/S0ByjgnaazyCyuuy5w
         iyBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hBlp0m0FfUT/dBVAsBVVQW1rlRH6/pse+3PC/lyMh6Y=;
        b=37BityYNiAuRs+4jWaKoIaYu5h4yJNa09H4Q4NZnAFQExdp6dKZzcZUZ0ubmPyVoO9
         R3qamDSjrVOPnFtFYQ6R5LhbDGTxwXx2Mtw7CbbHQsQX20Cjqapw1tmLB5DCKr+eZjbI
         j2ENBRHDYN1Jz0sdcaogUU5rt0pNbYkZSUu9DNQP827AIMjYLLPXHaiK63zSQ1qp/1tT
         KSfIIQ1S1SS15zAd34d/PRQnAsK28YhfYXr6k3mVlMd6eaAUWH+nFoLvWb59Pa8udybr
         mvh9pxcrxG3aLMETNivQmg7r4eEz9UtqW3D2ASXhEvLd8BtP/ficDIRbs+cm7l0kqRfk
         AhVA==
X-Gm-Message-State: AOAM5332l5FstT/9XmQfwn7h47HiPQgBLFZcRMdg5GsEjLWSdJztXeWZ
        7X2MhJwySXYzJYGQ94fcOHfZSsyByl6sCIE+2UhheQ==
X-Google-Smtp-Source: ABdhPJwxl4dIW7L3VhdlltyuvMd1su3hxypaOF1H/3X27CkrHo1USKfKYXvMtmrzU2yRtacWZWmIkzYDMypJjYFOqp8=
X-Received: by 2002:a17:90b:380b:b0:1e6:67f6:f70c with SMTP id
 mq11-20020a17090b380b00b001e667f6f70cmr31133111pjb.120.1654555596743; Mon, 06
 Jun 2022 15:46:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220601190218.2494963-1-sdf@google.com> <20220601190218.2494963-6-sdf@google.com>
 <20220604065935.lg5vegzhcqpd5laq@kafai-mbp>
In-Reply-To: <20220604065935.lg5vegzhcqpd5laq@kafai-mbp>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 6 Jun 2022 15:46:25 -0700
Message-ID: <CAKH8qBvX2OL17pLNusN_W6q8GpoNs7X9=h9YMwsx7-2-QEer1g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 05/11] bpf: implement BPF_PROG_QUERY for BPF_LSM_CGROUP
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

On Fri, Jun 3, 2022 at 11:59 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Wed, Jun 01, 2022 at 12:02:12PM -0700, Stanislav Fomichev wrote:
> > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > index a27a6a7bd852..cb3338ef01e0 100644
> > --- a/kernel/bpf/cgroup.c
> > +++ b/kernel/bpf/cgroup.c
> > @@ -1035,6 +1035,7 @@ static int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
> >  static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
> >                             union bpf_attr __user *uattr)
> >  {
> > +     __u32 __user *prog_attach_flags = u64_to_user_ptr(attr->query.prog_attach_flags);
> >       __u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
> >       enum bpf_attach_type type = attr->query.attach_type;
> >       enum cgroup_bpf_attach_type atype;
> > @@ -1042,50 +1043,92 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
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
> Enforce prog_attach_flags for BPF_LSM_CGROUP:
>
>                 if (total_cnt && !prog_attach_flags)
>                         return -EINVAL;

All the comments make sense, will apply. The only thing that I'll
probably keep as is is the copy_to_user(flags) part. We can't move it
above because it hasn't been properly initialized there.

What I think I'll do is:

if (atype != to_atype) /* exported via prog_attach_flags */
  flags = 0;
copy_to_user(.., flags,..);

That seems to better describe why we're not doing it?


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
> nit. This can be done under the BPF_F_QUERY_EFFECTIVE case below.
>
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
> nit. Move this copy_to_user(&uattr->query.attach_flags,...) to the
> 'if (type == BPF_LSM_CGROUP) { from_atype = .... } else { ... }' above.
> That will save a BPF_LSM_CGROUP test.
>
> I think the '== BPF_LSM_CGROUP' case needs to copy a 0 to user also.
>
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
> nit. total_cnt cannot be -ve ?
> !total_cnt instead ?
> and may be do it in the for-loop test.
>
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
> nit. This can be done under the BPF_F_QUERY_EFFECTIVE case below.
>
> > +
> > +             if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
> > +                     cnt = bpf_prog_array_length(effective);
> > +             else
> > +                     cnt = prog_list_length(progs);
> > +
> > +             if (cnt >= total_cnt)
> > +                     cnt = total_cnt;
> nit. This seems to be the only reason that
> the "if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)"
> need to be broken up into two halves.  One above and one below.
> It does not save much code.  How about repeating this one line
> 'cnt = min_t(int, cnt, total_cnt);' instead ?
>
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
> nit. Merge this into the above "if (prog_attach_flags)" case.
>
> >       }
> >       return ret;
> >  }
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index a237be4f8bb3..27492d44133f 100644
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
> > @@ -4066,6 +4067,9 @@ static int bpf_prog_get_info_by_fd(struct file *file,
> >
> >       if (prog->aux->btf)
> >               info.btf_id = btf_obj_id(prog->aux->btf);
> > +     info.attach_btf_id = prog->aux->attach_btf_id;
> > +     if (prog->aux->attach_btf)
> > +             info.attach_btf_obj_id = btf_obj_id(prog->aux->attach_btf);
> Need this also:
>
>         else if (prog->aux->dst_prog)
>                 info.attach_btf_obj_id = btf_obj_id(prog->aux->dst_prog->aux->attach_btf);
>
> >
> >       ulen = info.nr_func_info;
> >       info.nr_func_info = prog->aux->func_info_cnt;
> > --
> > 2.36.1.255.ge46751e96f-goog
> >
