Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9ED554FCF3
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 20:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbiFQS2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 14:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233726AbiFQS2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 14:28:38 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8380231DE0
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 11:28:33 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id bo5so4836163pfb.4
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 11:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aIOzEJ9nDorPAb1CIWF343uwJxbCVbmMR2xp/p1y2bM=;
        b=JDoHowU7VuvIsjSTwGuHzxLQt+SroQuo+Sdjg8F6E9k2hLpCHgdeU1k9A2j5/YSuY8
         ICpt5ywtkQXIDQQFJIOHT0RIViwCA617sjcmknvqpMtcTh9HvEdcHGaQJL8fUodFZiIB
         pgYE4zWiQghjew3tm58XNgGsLBDrT1LPLyMxlQbRj+dQLVZh98cIvOKEIbjY7+W72XLd
         Xj4772UQXyS7lx1JYo1Q25mPuBD8rxuOGZ/iCxbL5sw8maCZEf5mL9OvEtl2r4RXiN00
         3hPPhafCoMDjL6vz4WwMrTSH2XbFndeeBiKtida2/kqrS3zExYz2UOvYNOAq1brxuhWA
         urVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aIOzEJ9nDorPAb1CIWF343uwJxbCVbmMR2xp/p1y2bM=;
        b=hux0kqeor0YBz8ob8MnePBH6iloF9Gts6fu+LA1/ENZqWHByoOWHF51bnqqS8F31Z4
         cyKZEYmsYvTBaD73dXxEyyt4Ktfqc4jPQKk4ZJ5vtaRRHzCx7IfNBkpw6VFqzHWbDxJc
         5DWk4lfwa8sksTvhWKPJL83WRP4kRN7CwU6iOegw4/rxG+X5jF6rR62rri0LsH9nAlvF
         7lQbTevZm9yai++QVJx31nB3NBRSfuQZay/pOjzrknr/fOM3RZmhUVH4g1PI2smlvIP8
         XL8XwCg4L83jaNKg+A8O79M9dH98ycx/VvZLlvbRRpY0OarFRfwQXeLlKeG/9EX8fRXE
         xyPg==
X-Gm-Message-State: AJIora+F3/IMV3fXGcWRMi10hs30Mff43x8WUdvYzI5B3b+l+A+sJcuL
        YJiGbQCncJTu+A/tdSDsW1GUhLxpL175XNXxLTh8Bw==
X-Google-Smtp-Source: AGRyM1vM0sf4kwEDAHSFcKgbVy1EVOIl/sVWlKRUU9vONC4f+pB4l31f+guUPvbYNfuzrnIFhiTR0xnGbhLPs7kWqw4=
X-Received: by 2002:a65:588b:0:b0:3fe:4237:2ee5 with SMTP id
 d11-20020a65588b000000b003fe42372ee5mr10145872pgu.442.1655490512733; Fri, 17
 Jun 2022 11:28:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220610165803.2860154-1-sdf@google.com> <20220610165803.2860154-6-sdf@google.com>
 <20220617005829.66pboow5uubbrdcu@kafai-mbp>
In-Reply-To: <20220617005829.66pboow5uubbrdcu@kafai-mbp>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 17 Jun 2022 11:28:21 -0700
Message-ID: <CAKH8qBvzBHgouvRvXYpi66RoYbjXrmPXQwW9gsC3sk8J=VzBng@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9 05/10] bpf: implement BPF_PROG_QUERY for BPF_LSM_CGROUP
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

On Thu, Jun 16, 2022 at 5:58 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Fri, Jun 10, 2022 at 09:57:58AM -0700, Stanislav Fomichev wrote:
> > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > index ba402d50e130..c869317479ec 100644
> > --- a/kernel/bpf/cgroup.c
> > +++ b/kernel/bpf/cgroup.c
> > @@ -1029,57 +1029,92 @@ static int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
> >  static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
> >                             union bpf_attr __user *uattr)
> >  {
> > +     __u32 __user *prog_attach_flags = u64_to_user_ptr(attr->query.prog_attach_flags);
> >       __u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
> >       enum bpf_attach_type type = attr->query.attach_type;
> > +     enum cgroup_bpf_attach_type from_atype, to_atype;
> >       enum cgroup_bpf_attach_type atype;
> >       struct bpf_prog_array *effective;
> >       struct hlist_head *progs;
> >       struct bpf_prog *prog;
> >       int cnt, ret = 0, i;
> > +     int total_cnt = 0;
> >       u32 flags;
> >
> > -     atype = to_cgroup_bpf_attach_type(type);
> > -     if (atype < 0)
> > -             return -EINVAL;
> > +     if (type == BPF_LSM_CGROUP) {
> > +             if (attr->query.prog_cnt && prog_ids && !prog_attach_flags)
> > +                     return -EINVAL;
> >
> > -     progs = &cgrp->bpf.progs[atype];
> > -     flags = cgrp->bpf.flags[atype];
> > +             from_atype = CGROUP_LSM_START;
> > +             to_atype = CGROUP_LSM_END;
> > +             flags = 0;
> > +     } else {
> > +             from_atype = to_cgroup_bpf_attach_type(type);
> > +             if (from_atype < 0)
> > +                     return -EINVAL;
> > +             to_atype = from_atype;
> > +             flags = cgrp->bpf.flags[from_atype];
> > +     }
> >
> > -     effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> > -                                           lockdep_is_held(&cgroup_mutex));
> > +     for (atype = from_atype; atype <= to_atype; atype++) {
> > +             progs = &cgrp->bpf.progs[atype];
> nit. Move the 'progs = ...' into the 'else {}' case below.
>
> >
> > -     if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
> > -             cnt = bpf_prog_array_length(effective);
> > -     else
> > -             cnt = prog_list_length(progs);
> > +             if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
> > +                     effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> > +                                                           lockdep_is_held(&cgroup_mutex));
> > +                     total_cnt += bpf_prog_array_length(effective);
> > +             } else {
> > +                     total_cnt += prog_list_length(progs);
> > +             }
> > +     }
> >
> >       if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
> >               return -EFAULT;
> > -     if (copy_to_user(&uattr->query.prog_cnt, &cnt, sizeof(cnt)))
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
> > +     for (atype = from_atype; atype <= to_atype && total_cnt; atype++) {
> > +             progs = &cgrp->bpf.progs[atype];
> same here.
>
> > +             flags = cgrp->bpf.flags[atype];
> and the 'flags = ...' can be moved to 'if (prog_attach_flags) {}'
>
> Others lgtm.
>
> Reviewed-by: Martin KaFai Lau <kafai@fb.com>

Everything makes sense, will do, thanks!

Maybe we should also move "struct hlist_head *progs;" closer to the
places where we use them? Same for "struct bpf_prog *prog;" which
seems to be used only in one place.
