Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C55825345B9
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 23:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244594AbiEYV0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 17:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238229AbiEYV0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 17:26:00 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3351BE00E
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 14:25:57 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 4-20020a251004000000b0064df0151b18so19470980ybq.21
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 14:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=f0cykqcVpQZ6/A132ZoRpqFr5lqp7HWj//bcumODcAA=;
        b=iGqAv8XDfEiJH5PVi3LYY77Hvfucv41GIdzFt5rr6lnadjXGUIwWQENzBRDBMWGcJH
         4NB94FmPUPF9/Os/BPvN7idW+8sbmxEXF5tBmkkbo+hQjo9jfZOZhRa2fK0mPDmMIwjY
         5D4CMYGRh+QIfRL5uu1SQEDKGVaASYDUVHlY7bsiv2SIeh2P75Pyvekkjv434SHJFFBi
         IPhcE5NxtXZ/wvr8SAUWNWbYwJcEi8fIBuWOAjhrLUJWJYYbKSQV4CLZmmeUNUyZ8FWd
         QNX9mvYVrSswGsDOyrod7/Gb80GN1sVigvSD5f4uGPcOvAgwEYO8s2mL90vJAh/8fMCo
         A7eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=f0cykqcVpQZ6/A132ZoRpqFr5lqp7HWj//bcumODcAA=;
        b=eKoqK925GUmljag1GLa0LukmYFEiYlKm8j4F6F0IAp/YHa48h4uqIQjBJNVrzczweX
         Sopu9nBrTWKXDDt5fsNtiUc+CYf68WWR42ceh6JER+ganJ9oDntFuL+kczhPs0g75LWb
         3eDt2r9QAiTUkBN+xYDKFDEivk8j1CBv2hFX8aOdp0YoWctTEwyiRXn/12HZQW3QaN/w
         1m1xUbXS9ofZhh4DH2k/fu8hoXcQlZAafywJGtjDuu3Qp6YxTBNQNGP2+P3YW0eJj3Eq
         LDmmUK2oqg+h8aFeUig/P7jTKwDzDbbL5t5irYMa02aH2qaYyGPYxIORdY1vQejHczFV
         MOmg==
X-Gm-Message-State: AOAM530ij3dL8pevvECJgBJnBM3cU+hok/c+97TXgUZAlIId3Xkc4fXT
        T7+ywi6XaiqwYtUAxn0dgYVC9L0=
X-Google-Smtp-Source: ABdhPJx6aqbwM2r0UPiwxJi4fEa7m2vN3Wy2TtubFOY9OLk/y2sy+6f2HLEjk4ZU1K2hOu/Mom3q1dc=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:5ad2:d36b:186c:728f])
 (user=sdf job=sendgmr) by 2002:a81:16d1:0:b0:301:b558:77af with SMTP id
 200-20020a8116d1000000b00301b55877afmr973775yww.431.1653513956405; Wed, 25
 May 2022 14:25:56 -0700 (PDT)
Date:   Wed, 25 May 2022 14:25:54 -0700
In-Reply-To: <20220525203935.xkjeb7qkfltjsfqc@kafai-mbp>
Message-Id: <Yo6e4sNHnnazM+Cx@google.com>
Mime-Version: 1.0
References: <20220518225531.558008-6-sdf@google.com> <20220524034857.jwbjciq3rfb3l5kx@kafai-mbp>
 <CAKH8qBuCZVNPZaCRWrTiv7deDCyOkofT_ypvAiuE=OMz=TUuJw@mail.gmail.com>
 <20220524175035.i2ltl7gcrp2sng5r@kafai-mbp> <CAEf4BzYEXKQ-J8EQtTiYci1wdrRG7SPpuGhejJFY0cc5QQovEQ@mail.gmail.com>
 <CAKH8qBuRvnVoY-KEa6ofTjc2Jh2HUZYb1U2USSxgT=ozk0_JUA@mail.gmail.com>
 <CAEf4BzYdH9aayLvKAVTAeQ2XSLZPDX9N+fbP+yZnagcKd7ytNA@mail.gmail.com>
 <CAKH8qBvQHFcSQQiig6YGRdnjTHnu0T7-q-mPNjRb_nbY49N-Xw@mail.gmail.com>
 <CAKH8qBsjUgzEFQEzN9dwD4EQdJyno4TW2vDDp-cSejs1gFS4Ww@mail.gmail.com> <20220525203935.xkjeb7qkfltjsfqc@kafai-mbp>
Subject: Re: [PATCH bpf-next v7 05/11] bpf: implement BPF_PROG_QUERY for BPF_LSM_CGROUP
From:   sdf@google.com
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/25, Martin KaFai Lau wrote:
> On Wed, May 25, 2022 at 10:02:07AM -0700, Stanislav Fomichev wrote:
> > On Wed, May 25, 2022 at 9:01 AM Stanislav Fomichev <sdf@google.com>  
> wrote:
> > >
> > > On Tue, May 24, 2022 at 9:39 PM Andrii Nakryiko
> > > <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > On Tue, May 24, 2022 at 9:03 PM Stanislav Fomichev <sdf@google.com>  
> wrote:
> > > > >
> > > > > On Tue, May 24, 2022 at 4:45 PM Andrii Nakryiko
> > > > > <andrii.nakryiko@gmail.com> wrote:
> > > > > >
> > > > > > On Tue, May 24, 2022 at 10:50 AM Martin KaFai Lau  
> <kafai@fb.com> wrote:
> > > > > > >
> > > > > > > On Tue, May 24, 2022 at 08:55:04AM -0700, Stanislav Fomichev  
> wrote:
> > > > > > > > On Mon, May 23, 2022 at 8:49 PM Martin KaFai Lau  
> <kafai@fb.com> wrote:
> > > > > > > > >
> > > > > > > > > On Wed, May 18, 2022 at 03:55:25PM -0700, Stanislav  
> Fomichev wrote:
> > > > > > > > > > We have two options:
> > > > > > > > > > 1. Treat all BPF_LSM_CGROUP the same, regardless of  
> attach_btf_id
> > > > > > > > > > 2. Treat BPF_LSM_CGROUP+attach_btf_id as a separate  
> hook point
> > > > > > > > > >
> > > > > > > > > > I was doing (2) in the original patch, but switching to  
> (1) here:
> > > > > > > > > >
> > > > > > > > > > * bpf_prog_query returns all attached BPF_LSM_CGROUP  
> programs
> > > > > > > > > > regardless of attach_btf_id
> > > > > > > > > > * attach_btf_id is exported via bpf_prog_info
> > > > > > > > > >
> > > > > > > > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > > > > > > > ---
> > > > > > > > > >  include/uapi/linux/bpf.h |   5 ++
> > > > > > > > > >  kernel/bpf/cgroup.c      | 103  
> +++++++++++++++++++++++++++------------
> > > > > > > > > >  kernel/bpf/syscall.c     |   4 +-
> > > > > > > > > >  3 files changed, 81 insertions(+), 31 deletions(-)
> > > > > > > > > >
> > > > > > > > > > diff --git a/include/uapi/linux/bpf.h  
> b/include/uapi/linux/bpf.h
> > > > > > > > > > index b9d2d6de63a7..432fc5f49567 100644
> > > > > > > > > > --- a/include/uapi/linux/bpf.h
> > > > > > > > > > +++ b/include/uapi/linux/bpf.h
> > > > > > > > > > @@ -1432,6 +1432,7 @@ union bpf_attr {
> > > > > > > > > >               __u32           attach_flags;
> > > > > > > > > >               __aligned_u64   prog_ids;
> > > > > > > > > >               __u32           prog_cnt;
> > > > > > > > > > +             __aligned_u64   prog_attach_flags; /*  
> output: per-program attach_flags */
> > > > > > > > > >       } query;
> > > > > > > > > >
> > > > > > > > > >       struct { /* anonymous struct used by  
> BPF_RAW_TRACEPOINT_OPEN command */
> > > > > > > > > > @@ -5911,6 +5912,10 @@ struct bpf_prog_info {
> > > > > > > > > >       __u64 run_cnt;
> > > > > > > > > >       __u64 recursion_misses;
> > > > > > > > > >       __u32 verified_insns;
> > > > > > > > > > +     /* BTF ID of the function to attach to within BTF  
> object identified
> > > > > > > > > > +      * by btf_id.
> > > > > > > > > > +      */
> > > > > > > > > > +     __u32 attach_btf_func_id;
> > > > > > > > > >  } __attribute__((aligned(8)));
> > > > > > > > > >
> > > > > > > > > >  struct bpf_map_info {
> > > > > > > > > > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > > > > > > > > > index a959cdd22870..08a1015ee09e 100644
> > > > > > > > > > --- a/kernel/bpf/cgroup.c
> > > > > > > > > > +++ b/kernel/bpf/cgroup.c
> > > > > > > > > > @@ -1074,6 +1074,7 @@ static int  
> cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
> > > > > > > > > >  static int __cgroup_bpf_query(struct cgroup *cgrp,  
> const union bpf_attr *attr,
> > > > > > > > > >                             union bpf_attr __user  
> *uattr)
> > > > > > > > > >  {
> > > > > > > > > > +     __u32 __user *prog_attach_flags =  
> u64_to_user_ptr(attr->query.prog_attach_flags);
> > > > > > > > > >       __u32 __user *prog_ids =  
> u64_to_user_ptr(attr->query.prog_ids);
> > > > > > > > > >       enum bpf_attach_type type =  
> attr->query.attach_type;
> > > > > > > > > >       enum cgroup_bpf_attach_type atype;
> > > > > > > > > > @@ -1081,50 +1082,92 @@ static int  
> __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
> > > > > > > > > >       struct hlist_head *progs;
> > > > > > > > > >       struct bpf_prog *prog;
> > > > > > > > > >       int cnt, ret = 0, i;
> > > > > > > > > > +     int total_cnt = 0;
> > > > > > > > > >       u32 flags;
> > > > > > > > > >
> > > > > > > > > > -     atype = to_cgroup_bpf_attach_type(type);
> > > > > > > > > > -     if (atype < 0)
> > > > > > > > > > -             return -EINVAL;
> > > > > > > > > > +     enum cgroup_bpf_attach_type from_atype, to_atype;
> > > > > > > > > >
> > > > > > > > > > -     progs = &cgrp->bpf.progs[atype];
> > > > > > > > > > -     flags = cgrp->bpf.flags[atype];
> > > > > > > > > > +     if (type == BPF_LSM_CGROUP) {
> > > > > > > > > > +             from_atype = CGROUP_LSM_START;
> > > > > > > > > > +             to_atype = CGROUP_LSM_END;
> > > > > > > > > > +     } else {
> > > > > > > > > > +             from_atype =  
> to_cgroup_bpf_attach_type(type);
> > > > > > > > > > +             if (from_atype < 0)
> > > > > > > > > > +                     return -EINVAL;
> > > > > > > > > > +             to_atype = from_atype;
> > > > > > > > > > +     }
> > > > > > > > > >
> > > > > > > > > > -     effective =  
> rcu_dereference_protected(cgrp->bpf.effective[atype],
> > > > > > > > > > -                                            
> lockdep_is_held(&cgroup_mutex));
> > > > > > > > > > +     for (atype = from_atype; atype <= to_atype;  
> atype++) {
> > > > > > > > > > +             progs = &cgrp->bpf.progs[atype];
> > > > > > > > > > +             flags = cgrp->bpf.flags[atype];
> > > > > > > > > >
> > > > > > > > > > -     if (attr->query.query_flags &  
> BPF_F_QUERY_EFFECTIVE)
> > > > > > > > > > -             cnt = bpf_prog_array_length(effective);
> > > > > > > > > > -     else
> > > > > > > > > > -             cnt = prog_list_length(progs);
> > > > > > > > > > +             effective =  
> rcu_dereference_protected(cgrp->bpf.effective[atype],
> > > > > > > > > > +                                                    
> lockdep_is_held(&cgroup_mutex));
> > > > > > > > > >
> > > > > > > > > > -     if (copy_to_user(&uattr->query.attach_flags,  
> &flags, sizeof(flags)))
> > > > > > > > > > -             return -EFAULT;
> > > > > > > > > > -     if (copy_to_user(&uattr->query.prog_cnt, &cnt,  
> sizeof(cnt)))
> > > > > > > > > > +             if (attr->query.query_flags &  
> BPF_F_QUERY_EFFECTIVE)
> > > > > > > > > > +                     total_cnt +=  
> bpf_prog_array_length(effective);
> > > > > > > > > > +             else
> > > > > > > > > > +                     total_cnt +=  
> prog_list_length(progs);
> > > > > > > > > > +     }
> > > > > > > > > > +
> > > > > > > > > > +     if (type != BPF_LSM_CGROUP)
> > > > > > > > > > +             if  
> (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
> > > > > > > > > > +                     return -EFAULT;
> > > > > > > > > > +     if (copy_to_user(&uattr->query.prog_cnt,  
> &total_cnt, sizeof(total_cnt)))
> > > > > > > > > >               return -EFAULT;
> > > > > > > > > > -     if (attr->query.prog_cnt == 0 || !prog_ids | 
> | !cnt)
> > > > > > > > > > +     if (attr->query.prog_cnt == 0 || !prog_ids | 
> | !total_cnt)
> > > > > > > > > >               /* return early if user requested only  
> program count + flags */
> > > > > > > > > >               return 0;
> > > > > > > > > > -     if (attr->query.prog_cnt < cnt) {
> > > > > > > > > > -             cnt = attr->query.prog_cnt;
> > > > > > > > > > +
> > > > > > > > > > +     if (attr->query.prog_cnt < total_cnt) {
> > > > > > > > > > +             total_cnt = attr->query.prog_cnt;
> > > > > > > > > >               ret = -ENOSPC;
> > > > > > > > > >       }
> > > > > > > > > >
> > > > > > > > > > -     if (attr->query.query_flags &  
> BPF_F_QUERY_EFFECTIVE) {
> > > > > > > > > > -             return  
> bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
> > > > > > > > > > -     } else {
> > > > > > > > > > -             struct bpf_prog_list *pl;
> > > > > > > > > > -             u32 id;
> > > > > > > > > > +     for (atype = from_atype; atype <= to_atype;  
> atype++) {
> > > > > > > > > > +             if (total_cnt <= 0)
> > > > > > > > > > +                     break;
> > > > > > > > > >
> > > > > > > > > > -             i = 0;
> > > > > > > > > > -             hlist_for_each_entry(pl, progs, node) {
> > > > > > > > > > -                     prog = prog_list_prog(pl);
> > > > > > > > > > -                     id = prog->aux->id;
> > > > > > > > > > -                     if (copy_to_user(prog_ids + i,  
> &id, sizeof(id)))
> > > > > > > > > > -                             return -EFAULT;
> > > > > > > > > > -                     if (++i == cnt)
> > > > > > > > > > -                             break;
> > > > > > > > > > +             progs = &cgrp->bpf.progs[atype];
> > > > > > > > > > +             flags = cgrp->bpf.flags[atype];
> > > > > > > > > > +
> > > > > > > > > > +             effective =  
> rcu_dereference_protected(cgrp->bpf.effective[atype],
> > > > > > > > > > +                                                    
> lockdep_is_held(&cgroup_mutex));
> > > > > > > > > > +
> > > > > > > > > > +             if (attr->query.query_flags &  
> BPF_F_QUERY_EFFECTIVE)
> > > > > > > > > > +                     cnt =  
> bpf_prog_array_length(effective);
> > > > > > > > > > +             else
> > > > > > > > > > +                     cnt = prog_list_length(progs);
> > > > > > > > > > +
> > > > > > > > > > +             if (cnt >= total_cnt)
> > > > > > > > > > +                     cnt = total_cnt;
> > > > > > > > > > +
> > > > > > > > > > +             if (attr->query.query_flags &  
> BPF_F_QUERY_EFFECTIVE) {
> > > > > > > > > > +                     ret =  
> bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
> > > > > > > > > > +             } else {
> > > > > > > > > > +                     struct bpf_prog_list *pl;
> > > > > > > > > > +                     u32 id;
> > > > > > > > > > +
> > > > > > > > > > +                     i = 0;
> > > > > > > > > > +                     hlist_for_each_entry(pl, progs,  
> node) {
> > > > > > > > > > +                             prog = prog_list_prog(pl);
> > > > > > > > > > +                             id = prog->aux->id;
> > > > > > > > > > +                             if (copy_to_user(prog_ids  
> + i, &id, sizeof(id)))
> > > > > > > > > > +                                     return -EFAULT;
> > > > > > > > > > +                             if (++i == cnt)
> > > > > > > > > > +                                     break;
> > > > > > > > > > +                     }
> > > > > > > > > >               }
> > > > > > > > > > +
> > > > > > > > > > +             if (prog_attach_flags)
> > > > > > > > > > +                     for (i = 0; i < cnt; i++)
> > > > > > > > > > +                             if  
> (copy_to_user(prog_attach_flags + i, &flags, sizeof(flags)))
> > > > > > > > > > +                                     return -EFAULT;
> > > > > > > > > > +
> > > > > > > > > > +             prog_ids += cnt;
> > > > > > > > > > +             total_cnt -= cnt;
> > > > > > > > > > +             if (prog_attach_flags)
> > > > > > > > > > +                     prog_attach_flags += cnt;
> > > > > > > > > >       }
> > > > > > > > > >       return ret;
> > > > > > > > > >  }
> > > > > > > > > > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > > > > > > > > > index 5ed2093e51cc..4137583c04a2 100644
> > > > > > > > > > --- a/kernel/bpf/syscall.c
> > > > > > > > > > +++ b/kernel/bpf/syscall.c
> > > > > > > > > > @@ -3520,7 +3520,7 @@ static int bpf_prog_detach(const  
> union bpf_attr *attr)
> > > > > > > > > >       }
> > > > > > > > > >  }
> > > > > > > > > >
> > > > > > > > > > -#define BPF_PROG_QUERY_LAST_FIELD query.prog_cnt
> > > > > > > > > > +#define BPF_PROG_QUERY_LAST_FIELD  
> query.prog_attach_flags
> > > > > > > > > >
> > > > > > > > > >  static int bpf_prog_query(const union bpf_attr *attr,
> > > > > > > > > >                         union bpf_attr __user *uattr)
> > > > > > > > > > @@ -3556,6 +3556,7 @@ static int bpf_prog_query(const  
> union bpf_attr *attr,
> > > > > > > > > >       case BPF_CGROUP_SYSCTL:
> > > > > > > > > >       case BPF_CGROUP_GETSOCKOPT:
> > > > > > > > > >       case BPF_CGROUP_SETSOCKOPT:
> > > > > > > > > > +     case BPF_LSM_CGROUP:
> > > > > > > > > >               return cgroup_bpf_prog_query(attr, uattr);
> > > > > > > > > >       case BPF_LIRC_MODE2:
> > > > > > > > > >               return lirc_prog_query(attr, uattr);
> > > > > > > > > > @@ -4066,6 +4067,7 @@ static int  
> bpf_prog_get_info_by_fd(struct file *file,
> > > > > > > > > >
> > > > > > > > > >       if (prog->aux->btf)
> > > > > > > > > >               info.btf_id = btf_obj_id(prog->aux->btf);
> > > > > > > > > > +     info.attach_btf_func_id =  
> prog->aux->attach_btf_id;
> > > > > > > > > Note that exposing prog->aux->attach_btf_id only may not  
> be enough
> > > > > > > > > unless it can assume info.attach_btf_id is always  
> referring to btf_vmlinux
> > > > > > > > > for all bpf prog types.
> > > > > > > >
> > > > > > > > We also export btf_id two lines above, right? Btw, I left a  
> comment in
> > > > > > > > the bpftool about those btf_ids, I'm not sure how resolve  
> them and
> > > > > > > > always assume vmlinux for now.
> > > > > > > yeah, that btf_id above is the cgroup-lsm prog's btf_id which  
> has its
> > > > > > > func info, line info...etc.   It is not the one the  
> attach_btf_id correspond
> > > > > > > to.  attach_btf_id refers to either aux->attach_btf or  
> aux->dst_prog's btf (or
> > > > > > > target btf id here).
> > > > > > >
> > > > > > > It needs a consensus on where this attach_btf_id, target btf  
> id, and
> > > > > > > prog_attach_flags should be.  If I read the patch 7 thread  
> correctly,
> > > > > > > I think Andrii is suggesting to expose them to userspace  
> through link, so
> > > > > > > potentially putting them in bpf_link_info.  The  
> bpf_prog_query will
> > > > > > > output a list of link ids.  The same probably applies to
> > > > > >
> > > > > > Yep and I think it makes sense because link is representing one
> > > > > > specific attachment (and I presume flags can be stored inside  
> the link
> > > > > > itself as well, right?).
> > > > > >
> > > > > > But if legacy non-link BPF_PROG_ATTACH is supported then using
> > > > > > bpf_link_info won't cover legacy prog-only attachments.
> > > > >
> > > > > I don't have any attachment to the legacy apis, I'm supporting  
> them
> > > > > only because it takes two lines of code; we can go link-only if  
> there
> > > > > is an agreement that it's inherently better.
> > > > >
> > > > > How about I keep sys_bpf(BPF_PROG_QUERY) as is and I do a loop in  
> the
> > > > > userspace (for BPF_LSM_CGROUP only) over all links
> > > > > (BPF_LINK_GET_NEXT_ID) and will find the the ones with matching  
> prog
> > > > > ids (BPF_LINK_GET_FD_BY_ID+BPF_OBJ_GET_INFO_BY_FD)?
> > > > >
> > > > > That way we keep new fields in bpf_link_info, but we don't have to
> > > > > extend sys_bpf(BPF_PROG_QUERY) because there doesn't seem to be a  
> good
> > > > > way to do it. Exporting links via new link_fds would mean we'd  
> have to
> > > > > support BPF_F_QUERY_EFFECTIVE, but getting an effective array of  
> links
> > > > > seems to be messy. If, in the future, we figure out a better way  
> to
> I don't see a clean way to get effective array from one individual
> link[_info] through link iteration.  effective array is the progs that
> will be run at a cgroup and in such order.  The prog running at a
> cgroup doesn't necessarily linked to that cgroup.

Yeah, that's the problem with exposing links via prog_info; getting an
effective list is painful.

> If staying with BPF_PROG_QUERY+BPF_F_QUERY_EFFECTIVE to get effective  
> array
> and if it is decided the addition should be done in bpf_link_info,
> then a list of link ids needs to be output instead of the current list of
> prog ids.  The old attach type will still have to stay with the list of
> prog ids though :/

> It will be sad not to be able to get effective only for BPF_LSM_CGROUP.
> I found it more useful to show what will be run at a cgroup and in such
> order instead of what is linked to a cgroup.

See my hacky proof-of-concept below (on top of this series).

I think if we keep prog_info as is (don't export anything new, don't
export the list of links), iterating through all links on the host should  
work,
right? We get prog_ids list (effective or not, doesn't matter), then we
go through all the links and find the ones with with the same
prog_id (we can ignore cgroup, it shouldn't matter). Then we can export
attach_type/attach_btf_id/etc. If it happens to be slow in the future,
we can improve with some tbd interface to get the list of links for cgroup
(and then we'd have to care about effective list).

But the problem with going link-only is that I'd have to teach bpftool
to use links for BPF_LSM_CGROUP and it brings a bunch of problems:
* I'd have to pin those links somewhere to make them stick around
* Those pin paths essentially become an API now because "detach" now
   depends on them?
* (right now it automatically works with the legacy apis without any  
changes)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 269ad43b68c1..f34b64b9ba97 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -6049,6 +6049,9 @@ struct bpf_link_info {
  		struct {
  			__u64 cgroup_id;
  			__u32 attach_type;
+			__u32 attach_flags;
+			__u32 attach_btf_id;
+			__u32 attach_btf_obj_id;
  		} cgroup;
  		struct {
  			__aligned_u64 target_name; /* in/out: target_name buffer ptr */
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index e05f7a11b45a..b5159e7f64f5 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1211,6 +1211,20 @@ static int bpf_cgroup_link_fill_link_info(const  
struct bpf_link *link,

  	info->cgroup.cgroup_id = cg_id;
  	info->cgroup.attach_type = cg_link->type;
+
+	info->cgroup.attach_btf_id = cg_link->link.prog->aux->attach_btf_id;
+	if (cg_link->link.prog->aux->attach_btf)
+		info->cgroup.attach_btf_obj_id =  
btf_obj_id(cg_link->link.prog->aux->attach_btf);
+
+	if (cg_link->cgroup) {
+		int atype;
+
+		mutex_lock(&cgroup_mutex);
+		atype = bpf_cgroup_atype_find(cg_link->type,  
cg_link->link.prog->aux->attach_btf_id);
+		info->cgroup.attach_flags = cg_link->cgroup->bpf.flags[atype];
+		mutex_unlock(&cgroup_mutex);
+	}
+
  	return 0;
  }

diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
index f40d4745711c..3cece48ebaa9 100644
--- a/tools/bpf/bpftool/cgroup.c
+++ b/tools/bpf/bpftool/cgroup.c
@@ -49,15 +49,34 @@ static enum bpf_attach_type parse_attach_type(const  
char *str)
  }

  static int show_bpf_prog(int id, enum bpf_attach_type attach_type,
-			 const char *attach_flags_str,
+			 __u32 attach_flags,
+			 __u32 attach_btf_id,
+			 __u32 attach_btf_obj_id,
  			 int level)
  {
  	char prog_name[MAX_PROG_FULL_NAME];
  	const char *attach_btf_name = NULL;
  	struct bpf_prog_info info = {};
  	__u32 info_len = sizeof(info);
+	const char *attach_flags_str;
+	char buf[32];
  	int prog_fd;

+	switch (attach_flags) {
+	case BPF_F_ALLOW_MULTI:
+		attach_flags_str = "multi";
+		break;
+	case BPF_F_ALLOW_OVERRIDE:
+		attach_flags_str = "override";
+		break;
+	case 0:
+		attach_flags_str = "";
+		break;
+	default:
+		snprintf(buf, sizeof(buf), "unknown(%x)", attach_flags);
+		attach_flags_str = buf;
+	}
+
  	prog_fd = bpf_prog_get_fd_by_id(id);
  	if (prog_fd < 0)
  		return -1;
@@ -68,13 +87,13 @@ static int show_bpf_prog(int id, enum bpf_attach_type  
attach_type,
  	}

  	if (btf_vmlinux &&
-	    info.attach_btf_id < btf__type_cnt(btf_vmlinux)) {
-		/* Note, we ignore info.btf_id for now. There
+	    attach_btf_id < btf__type_cnt(btf_vmlinux)) {
+		/* Note, we ignore attach_btf_obj_id for now. There
  		 * is no good way to resolve btf_id to vmlinux
  		 * or module btf.
  		 */
  		const struct btf_type *t = btf__type_by_id(btf_vmlinux,
-							   info.attach_btf_id);
+							   attach_btf_id);
  		attach_btf_name = btf__name_by_offset(btf_vmlinux,
  						      t->name_off);
  	}
@@ -93,8 +112,8 @@ static int show_bpf_prog(int id, enum bpf_attach_type  
attach_type,
  		jsonw_string_field(json_wtr, "name", prog_name);
  		if (attach_btf_name)
  			jsonw_string_field(json_wtr, "attach_btf_name", attach_btf_name);
-		jsonw_uint_field(json_wtr, "btf_id", info.btf_id);
-		jsonw_uint_field(json_wtr, "attach_btf_id", info.attach_btf_id);
+		jsonw_uint_field(json_wtr, "btf_id", attach_btf_obj_id);
+		jsonw_uint_field(json_wtr, "attach_btf_id", attach_btf_id);
  		jsonw_end_object(json_wtr);
  	} else {
  		printf("%s%-8u ", level ? "    " : "", info.id);
@@ -105,8 +124,8 @@ static int show_bpf_prog(int id, enum bpf_attach_type  
attach_type,
  		printf(" %-15s %-15s", attach_flags_str, prog_name);
  		if (attach_btf_name)
  			printf(" %-15s", attach_btf_name);
-		else if (info.attach_btf_id)
-			printf(" btf_id=%d attach_btf_id=%d", info.btf_id, info.attach_btf_id);
+		else if (attach_btf_id)
+			printf(" btf_id=%d attach_btf_id=%d", attach_btf_obj_id, attach_btf_id);
  		printf("\n");
  	}

@@ -150,10 +169,10 @@ static int show_attached_bpf_progs(int cgroup_fd,  
enum bpf_attach_type type,
  				   int level)
  {
  	LIBBPF_OPTS(bpf_prog_query_opts, p);
-	const char *attach_flags_str;
  	__u32 prog_ids[1024] = {0};
  	__u32 attach_prog_flags[1024] = {0};
-	char buf[32];
+	__u32 attach_btf_id[1024] = {0};
+	__u32 attach_btf_obj_id[1024] = {0};
  	__u32 iter;
  	int ret;

@@ -168,29 +187,58 @@ static int show_attached_bpf_progs(int cgroup_fd,  
enum bpf_attach_type type,
  	if (p.prog_cnt == 0)
  		return 0;

-	for (iter = 0; iter < p.prog_cnt; iter++) {
-		__u32 attach_flags;
+	if (type == BPF_LSM_CGROUP) {
+		/* Match prog_id to the link to find out link info. */
+		struct bpf_link_info link_info;
+		__u32 id = 0;
+		__u32 link_len;
+		int err;
+		int fd;
+
+		while (1) {
+			err = bpf_link_get_next_id(id, &id);
+			if (err) {
+				if (errno == ENOENT)
+					break;
+				continue;
+			}

-		attach_flags = attach_prog_flags[iter] ?: p.attach_flags;
+			fd = bpf_link_get_fd_by_id(id);
+			if (fd < 0)
+				continue;

-		switch (attach_flags) {
-		case BPF_F_ALLOW_MULTI:
-			attach_flags_str = "multi";
-			break;
-		case BPF_F_ALLOW_OVERRIDE:
-			attach_flags_str = "override";
-			break;
-		case 0:
-			attach_flags_str = "";
-			break;
-		default:
-			snprintf(buf, sizeof(buf), "unknown(%x)", attach_flags);
-			attach_flags_str = buf;
+			link_len = sizeof(struct bpf_link_info);
+			memset(&link_info, 0, link_len);
+			err = bpf_obj_get_info_by_fd(fd, &link_info, &link_len);
+			if (err) {
+				close(fd);
+				continue;
+			}
+
+			if (link_info.type != BPF_LINK_TYPE_CGROUP) {
+				close(fd);
+				continue;
+			}
+
+			for (iter = 0; iter < p.prog_cnt; iter++) {
+				if (prog_ids[iter] != link_info.prog_id)
+					continue;
+
+				fprintf(stderr, "\nprog_fd=%d btf_id=%d\n", link_info.prog_id,  
link_info.cgroup.attach_btf_id);
+
+				attach_prog_flags[iter] = link_info.cgroup.attach_flags;
+				attach_btf_id[iter] = link_info.cgroup.attach_btf_id;
+				attach_btf_obj_id[iter] = link_info.cgroup.attach_btf_obj_id;
+			}
  		}
+	}

+	for (iter = 0; iter < p.prog_cnt; iter++)
  		show_bpf_prog(prog_ids[iter], type,
-			      attach_flags_str, level);
-	}
+			      attach_prog_flags[iter] ?: p.attach_flags,
+			      attach_btf_id[iter],
+			      attach_btf_obj_id[iter],
+			      level);

  	return 0;
  }
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 269ad43b68c1..f34b64b9ba97 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -6049,6 +6049,9 @@ struct bpf_link_info {
  		struct {
  			__u64 cgroup_id;
  			__u32 attach_type;
+			__u32 attach_flags;
+			__u32 attach_btf_id;
+			__u32 attach_btf_obj_id;
  		} cgroup;
  		struct {
  			__aligned_u64 target_name; /* in/out: target_name buffer ptr */
