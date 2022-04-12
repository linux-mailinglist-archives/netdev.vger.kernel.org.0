Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED9C4FE866
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 21:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241027AbiDLTEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 15:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232475AbiDLTEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 15:04:12 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC43020E
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 12:01:53 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id 3so7067892qkj.5
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 12:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9NyrBIysFfbmStSkhH0W0umMgC5iJfoGoDBNA6fyRag=;
        b=GTTHIi1rmqLR28C52bq10tSV1AVWgdrA9aWH/C0O2ZrnDy64RO/Jx8RrKUMymPDtgH
         iIIqpi8wzy8jcifUUYO47uCewtkl1cPhtUosrEeBOwt9H5MG4wWnJtvM4I2QoqcYmH4J
         GiVEJxddbe+I5xo4mVlb4vSIrsjz3oUzpMyGkCizt4BBXEWb0XRlUrDu89g+qHFGhXjC
         eG139ftKKIu0UH/+O8C2DqaXATvBTu35redADwlmRSn0QhTX1E5X5wZcHJ+bJoPQdval
         6/j8CriT2dexrtqPt29nZellBqLBRFH6Za5A+7FABS25dF73/M8mr7ZCIiPEQOaQR/9F
         dQuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9NyrBIysFfbmStSkhH0W0umMgC5iJfoGoDBNA6fyRag=;
        b=mrvXDQesMa1+JFmuuTFD5f94A5MQgH7oeylOZRmM2rGSBNhOvHLxkk1teVWyRGkghT
         Btwmq7lTbwJ6zA6lujFqoJJPdZBSn/x2NXGC+dWWJJinYAUJWN7IfQBqUphCPymQDch5
         HH/ztnLTjhBYvjLLtgJcUdlVgbo4zeisLNv63BCpuZ+onKJ9/62muezAw3/aRMTImb4i
         3oAg4FThPEz+LNAs9HLU8KntNJQkByIvvLD7vbtwYqU3dcTAzEd3eFMkVEDY8zFFqRb/
         3GhWDZNjV6VdEjIdUQM4wQbB+dqWnLc5uvUI1cbztDxu254IaG6/VknwBknvylTHw05+
         YXpw==
X-Gm-Message-State: AOAM532D/W87nvSWQs8uIYQPL1X7MAc4DZel2BpvxkaFT+l1wqP98unG
        yoF+pGTlGPnBXlbOd2IRdNUAskzg9qrChrnVQp1Ndw==
X-Google-Smtp-Source: ABdhPJxgBpAp+6DjFexSNm4j8H7Zd7L5P+miHsxGvoRbEA0+aHIxlZ/VP3iXhjUdZ1BHpqW6MB7PThopK78xWV0gKt8=
X-Received: by 2002:a05:620a:2717:b0:69b:e996:11cb with SMTP id
 b23-20020a05620a271700b0069be99611cbmr4245788qkp.390.1649790112840; Tue, 12
 Apr 2022 12:01:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220407223112.1204582-1-sdf@google.com> <20220407223112.1204582-4-sdf@google.com>
 <20220408225628.oog4a3qteauhqkdn@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBuMMuuUJiZJY8Gb+tMQLKoRGpvv58sSM4sZXjyEc0i7dA@mail.gmail.com>
 <20220412013631.tntvx7lw3c7sw6ur@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBvCNVwEmoDyWvA5kEuNkCuVZYtf7RVL4AMXAsMr7aQDZA@mail.gmail.com> <20220412181353.zgyl2oy4vl3uyigl@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220412181353.zgyl2oy4vl3uyigl@kafai-mbp.dhcp.thefacebook.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 12 Apr 2022 12:01:41 -0700
Message-ID: <CAKH8qBuc8gVcS6GbSx4P6w2j6jTVXX8QROBjFW953mp0ejQqRA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/7] bpf: minimize number of allocated lsm
 slots per program
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
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

On Tue, Apr 12, 2022 at 11:13 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, Apr 12, 2022 at 09:42:40AM -0700, Stanislav Fomichev wrote:
> > On Mon, Apr 11, 2022 at 6:36 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > On Mon, Apr 11, 2022 at 11:46:20AM -0700, Stanislav Fomichev wrote:
> > > > On Fri, Apr 8, 2022 at 3:57 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > >
> > > > > On Thu, Apr 07, 2022 at 03:31:08PM -0700, Stanislav Fomichev wrote:
> > > > > > Previous patch adds 1:1 mapping between all 211 LSM hooks
> > > > > > and bpf_cgroup program array. Instead of reserving a slot per
> > > > > > possible hook, reserve 10 slots per cgroup for lsm programs.
> > > > > > Those slots are dynamically allocated on demand and reclaimed.
> > > > > > This still adds some bloat to the cgroup and brings us back to
> > > > > > roughly pre-cgroup_bpf_attach_type times.
> > > > > >
> > > > > > It should be possible to eventually extend this idea to all hooks if
> > > > > > the memory consumption is unacceptable and shrink overall effective
> > > > > > programs array.
> > > > > >
> > > > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > > > ---
> > > > > >  include/linux/bpf-cgroup-defs.h |  4 +-
> > > > > >  include/linux/bpf_lsm.h         |  6 ---
> > > > > >  kernel/bpf/bpf_lsm.c            |  9 ++--
> > > > > >  kernel/bpf/cgroup.c             | 96 ++++++++++++++++++++++++++++-----
> > > > > >  4 files changed, 90 insertions(+), 25 deletions(-)
> > > > > >
> > > > > > diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
> > > > > > index 6c661b4df9fa..d42516e86b3a 100644
> > > > > > --- a/include/linux/bpf-cgroup-defs.h
> > > > > > +++ b/include/linux/bpf-cgroup-defs.h
> > > > > > @@ -10,7 +10,9 @@
> > > > > >
> > > > > >  struct bpf_prog_array;
> > > > > >
> > > > > > -#define CGROUP_LSM_NUM 211 /* will be addressed in the next patch */
> > > > > > +/* Maximum number of concurrently attachable per-cgroup LSM hooks.
> > > > > > + */
> > > > > > +#define CGROUP_LSM_NUM 10
> > > > > hmm...only 10 different lsm hooks (or 10 different attach_btf_ids) can
> > > > > have BPF_LSM_CGROUP programs attached.  This feels quite limited but having
> > > > > a static 211 (and potentially growing in the future) is not good either.
> > > > > I currently do not have a better idea also. :/
> > > > >
> > > > > Have you thought about other dynamic schemes or they would be too slow ?
> > > > >
> > > > > >  enum cgroup_bpf_attach_type {
> > > > > >       CGROUP_BPF_ATTACH_TYPE_INVALID = -1,
> > > > > > diff --git a/include/linux/bpf_lsm.h b/include/linux/bpf_lsm.h
> > > > > > index 7f0e59f5f9be..613de44aa429 100644
> > > > > > --- a/include/linux/bpf_lsm.h
> > > > > > +++ b/include/linux/bpf_lsm.h
> > > > > > @@ -43,7 +43,6 @@ extern const struct bpf_func_proto bpf_inode_storage_delete_proto;
> > > > > >  void bpf_inode_storage_free(struct inode *inode);
> > > > > >
> > > > > >  int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog, bpf_func_t *bpf_func);
> > > > > > -int bpf_lsm_hook_idx(u32 btf_id);
> > > > > >
> > > > > >  #else /* !CONFIG_BPF_LSM */
> > > > > >
> > > > > > @@ -74,11 +73,6 @@ static inline int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
> > > > > >       return -ENOENT;
> > > > > >  }
> > > > > >
> > > > > > -static inline int bpf_lsm_hook_idx(u32 btf_id)
> > > > > > -{
> > > > > > -     return -EINVAL;
> > > > > > -}
> > > > > > -
> > > > > >  #endif /* CONFIG_BPF_LSM */
> > > > > >
> > > > > >  #endif /* _LINUX_BPF_LSM_H */
> > > > > > diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> > > > > > index eca258ba71d8..8b948ec9ab73 100644
> > > > > > --- a/kernel/bpf/bpf_lsm.c
> > > > > > +++ b/kernel/bpf/bpf_lsm.c
> > > > > > @@ -57,10 +57,12 @@ static unsigned int __cgroup_bpf_run_lsm_socket(const void *ctx,
> > > > > >       if (unlikely(!sk))
> > > > > >               return 0;
> > > > > >
> > > > > > +     rcu_read_lock(); /* See bpf_lsm_attach_type_get(). */
> > > > > >       cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> > > > > >       if (likely(cgrp))
> > > > > >               ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[prog->aux->cgroup_atype],
> > > > > >                                           ctx, bpf_prog_run, 0);
> > > > > > +     rcu_read_unlock();
> > > > > >       return ret;
> > > > > >  }
> > > > > >
> > > > > > @@ -77,7 +79,7 @@ static unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
> > > > > >       /*prog = container_of(insn, struct bpf_prog, insnsi);*/
> > > > > >       prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
> > > > > >
> > > > > > -     rcu_read_lock();
> > > > > > +     rcu_read_lock(); /* See bpf_lsm_attach_type_get(). */
> > > > > I think this is also needed for task_dfl_cgroup().  If yes,
> > > > > will be a good idea to adjust the comment if it ends up
> > > > > using the 'CGROUP_LSM_NUM 10' scheme.
> > > > >
> > > > > While at rcu_read_lock(), have you thought about what major things are
> > > > > needed to make BPF_LSM_CGROUP sleepable ?
> > > > >
> > > > > The cgroup local storage could be one that require changes but it seems
> > > > > the cgroup local storage is not available to BPF_LSM_GROUP in this change set.
> > > > > The current use case doesn't need it?
> > > >
> > > > No, I haven't thought about sleepable at all yet :-( But seems like
> > > > having that rcu lock here might be problematic if we want to sleep? In
> > > > this case, Jakub's suggestion seems better.
> > > The new rcu_read_lock() here seems fine after some thoughts.
> > >
> > > I was looking at the helpers in cgroup_base_func_proto() to get a sense
> > > on sleepable support.  Only the bpf_get_local_storage caught my eyes for
> > > now because it uses a call_rcu to free the storage.  That will be the
> > > major one to change for sleepable that I can think of for now.
> >
> > That rcu_read_lock should be switched over to rcu_read_lock_trace in
> > the sleepable case I'm assuming? Are we allowed to sleep while holding
> > rcu_read_lock_trace?
> Ah. right, suddenly forgot the obvious in between emails :(
>
> In that sense, may as well remove the rcu_read_lock() here and let
> the trampoline to decide which one (rcu_read_lock or rcu_read_lock_trace)
> to call before calling the shim_prog.  The __bpf_prog_enter(_sleepable) will
> call the right rcu_read_lock(_trace) based on the prog is sleepable or not.

Removing rcu_read_lock in __cgroup_bpf_run_lsm_current might be
problematic because we also want to guarantee current's cgroup doesn't
go away. I'm assuming things like task migrating to a new cgroup and
the old one being freed can happen while we are trying to get cgroup's
effective array.

I guess BPF_PROG_RUN_ARRAY_CG will also need some work before
sleepable can happen (it calls rcu_read_lock unconditionally).

Also, it doesn't seem like BPF_PROG_RUN_ARRAY_CG rcu usage is correct.
It receives __rcu array_rcu, takes rcu read lock and does deref. I'm
assuming that array_rcu can be free'd before we even get to
BPF_PROG_RUN_ARRAY_CG's rcu_read_lock? (so having rcu_read_lock around
BPF_PROG_RUN_ARRAY_CG makes sense)
