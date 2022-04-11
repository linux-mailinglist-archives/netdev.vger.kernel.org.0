Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB494FC456
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 20:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349238AbiDKSss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 14:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349224AbiDKSsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 14:48:47 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5925E2CCB7
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 11:46:32 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id c199so9872363qkg.4
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 11:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=91Li9XU9gpsJ9k8wCFOCx1n06URSq0VVBp27IbgO0dU=;
        b=ZE3jzHxvrXCeyfU3Ym1d86TePHiIgNaCYyP4+rQ9CLUlbAHm4ms3tb2AIilc/amm1J
         NdcDHNQQzHMmT/jA0Kk7+g0EJnptw9ayPbM6qU6e6z98YNRwKWtQ9WxtvQ+1BQGEKaqW
         0lZhkMlBE6OaMK/0TiP5qzJkkzYgIrSKB5Yx5epoa8GDHW16j1uXNYfZNckrWC3dyuxV
         8g6y2hquS/Zfm0hL2SOT6/6ntDG8YIJt+rSmkwhd+9pKeJh1jPTBPCD8Hfb40JwlabOS
         ZV+/aEpKWS5IWSvzn4T9/2mHSk/dRmNC7SrlmJaDuhBFXdHOiJuTguDUeIClkewxwr10
         YOEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=91Li9XU9gpsJ9k8wCFOCx1n06URSq0VVBp27IbgO0dU=;
        b=1N+B4RZ9d8RRuBhZ/rkjY46dd6UkVZgeNRpKbw6Vggx3oKqzQPYHUsVSZ7YMzrqvQl
         goIwYznRG/B1lgjg8MTxjMTQ1zzWRmOfdBXoG4xZ2nR2+TNpX4j9KXLr/Qn84eVtOw7y
         kcfXy9CL0yEdQAczXmqoZ6OMf3epuaL913fsuVmymF4Gv458fWYng/a5upqL66yteS2L
         075GGcz+YqCx4v4hpLd2nEiba51kgvrGou5v4CITvVIp2s43N+GcLSggdtzTU7len+VZ
         HtlZhaBrwFcrVXbP6X4QhKpibY8N3spVnlY/B+PYTkkCB5XRiQIbfLo6h2oLZoSOtJ3i
         PShw==
X-Gm-Message-State: AOAM531qe7hL1xOJdfjRzc4eCmIFuy0+5+KUjNCe5nxDiIMMG2l6c+py
        /cgvwQfMZl3PucXREjl0Gn/2yq4+lYLdr04+C5vsFA==
X-Google-Smtp-Source: ABdhPJxPt6k2TunyH0GsmTgJkWGdFloK65fX+MIrLpDEF9/p39z+AURPMKD9fLQujeyYFeRlXPPe6i8pbLZMBWvs+U8=
X-Received: by 2002:ae9:eb01:0:b0:69c:10ca:ed6 with SMTP id
 b1-20020ae9eb01000000b0069c10ca0ed6mr574203qkg.496.1649702791220; Mon, 11 Apr
 2022 11:46:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220407223112.1204582-1-sdf@google.com> <20220407223112.1204582-4-sdf@google.com>
 <20220408225628.oog4a3qteauhqkdn@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220408225628.oog4a3qteauhqkdn@kafai-mbp.dhcp.thefacebook.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 11 Apr 2022 11:46:20 -0700
Message-ID: <CAKH8qBuMMuuUJiZJY8Gb+tMQLKoRGpvv58sSM4sZXjyEc0i7dA@mail.gmail.com>
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 8, 2022 at 3:57 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Apr 07, 2022 at 03:31:08PM -0700, Stanislav Fomichev wrote:
> > Previous patch adds 1:1 mapping between all 211 LSM hooks
> > and bpf_cgroup program array. Instead of reserving a slot per
> > possible hook, reserve 10 slots per cgroup for lsm programs.
> > Those slots are dynamically allocated on demand and reclaimed.
> > This still adds some bloat to the cgroup and brings us back to
> > roughly pre-cgroup_bpf_attach_type times.
> >
> > It should be possible to eventually extend this idea to all hooks if
> > the memory consumption is unacceptable and shrink overall effective
> > programs array.
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  include/linux/bpf-cgroup-defs.h |  4 +-
> >  include/linux/bpf_lsm.h         |  6 ---
> >  kernel/bpf/bpf_lsm.c            |  9 ++--
> >  kernel/bpf/cgroup.c             | 96 ++++++++++++++++++++++++++++-----
> >  4 files changed, 90 insertions(+), 25 deletions(-)
> >
> > diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
> > index 6c661b4df9fa..d42516e86b3a 100644
> > --- a/include/linux/bpf-cgroup-defs.h
> > +++ b/include/linux/bpf-cgroup-defs.h
> > @@ -10,7 +10,9 @@
> >
> >  struct bpf_prog_array;
> >
> > -#define CGROUP_LSM_NUM 211 /* will be addressed in the next patch */
> > +/* Maximum number of concurrently attachable per-cgroup LSM hooks.
> > + */
> > +#define CGROUP_LSM_NUM 10
> hmm...only 10 different lsm hooks (or 10 different attach_btf_ids) can
> have BPF_LSM_CGROUP programs attached.  This feels quite limited but having
> a static 211 (and potentially growing in the future) is not good either.
> I currently do not have a better idea also. :/
>
> Have you thought about other dynamic schemes or they would be too slow ?
>
> >  enum cgroup_bpf_attach_type {
> >       CGROUP_BPF_ATTACH_TYPE_INVALID = -1,
> > diff --git a/include/linux/bpf_lsm.h b/include/linux/bpf_lsm.h
> > index 7f0e59f5f9be..613de44aa429 100644
> > --- a/include/linux/bpf_lsm.h
> > +++ b/include/linux/bpf_lsm.h
> > @@ -43,7 +43,6 @@ extern const struct bpf_func_proto bpf_inode_storage_delete_proto;
> >  void bpf_inode_storage_free(struct inode *inode);
> >
> >  int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog, bpf_func_t *bpf_func);
> > -int bpf_lsm_hook_idx(u32 btf_id);
> >
> >  #else /* !CONFIG_BPF_LSM */
> >
> > @@ -74,11 +73,6 @@ static inline int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
> >       return -ENOENT;
> >  }
> >
> > -static inline int bpf_lsm_hook_idx(u32 btf_id)
> > -{
> > -     return -EINVAL;
> > -}
> > -
> >  #endif /* CONFIG_BPF_LSM */
> >
> >  #endif /* _LINUX_BPF_LSM_H */
> > diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> > index eca258ba71d8..8b948ec9ab73 100644
> > --- a/kernel/bpf/bpf_lsm.c
> > +++ b/kernel/bpf/bpf_lsm.c
> > @@ -57,10 +57,12 @@ static unsigned int __cgroup_bpf_run_lsm_socket(const void *ctx,
> >       if (unlikely(!sk))
> >               return 0;
> >
> > +     rcu_read_lock(); /* See bpf_lsm_attach_type_get(). */
> >       cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> >       if (likely(cgrp))
> >               ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[prog->aux->cgroup_atype],
> >                                           ctx, bpf_prog_run, 0);
> > +     rcu_read_unlock();
> >       return ret;
> >  }
> >
> > @@ -77,7 +79,7 @@ static unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
> >       /*prog = container_of(insn, struct bpf_prog, insnsi);*/
> >       prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
> >
> > -     rcu_read_lock();
> > +     rcu_read_lock(); /* See bpf_lsm_attach_type_get(). */
> I think this is also needed for task_dfl_cgroup().  If yes,
> will be a good idea to adjust the comment if it ends up
> using the 'CGROUP_LSM_NUM 10' scheme.
>
> While at rcu_read_lock(), have you thought about what major things are
> needed to make BPF_LSM_CGROUP sleepable ?
>
> The cgroup local storage could be one that require changes but it seems
> the cgroup local storage is not available to BPF_LSM_GROUP in this change set.
> The current use case doesn't need it?

No, I haven't thought about sleepable at all yet :-( But seems like
having that rcu lock here might be problematic if we want to sleep? In
this case, Jakub's suggestion seems better.
