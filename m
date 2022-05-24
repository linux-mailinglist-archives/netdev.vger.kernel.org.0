Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 589B5532DEC
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 17:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239166AbiEXP46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 11:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239113AbiEXP4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 11:56:50 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51231980BD
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 08:56:48 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id i81-20020a1c3b54000000b003974edd7c56so57235wma.2
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 08:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3cffZCgP4sr8BnADi733FLoP9vNC7tnFYq6HsCC4n/0=;
        b=HnoxOwV62O7lG84mgl/xi2qvJFSmAGCP43AcwiVCYPHXEK804cz2ynCdzxQz/nzdYK
         Iw4qozHTg0zzWkg2ukbeN8BvY5HXrAUvj9m0llajqakPRGXclXzoJIKz+k9+cClkA363
         dMZp+/1XAxbb0Z016MxDuuhcPa73iEdqXeuCAhtFJwsoVkbgUTA8syLeEqCM8l0oKMth
         f++tZTJ/+DYvMABxwDcRZWd5ErNOXfnSIkPIIun04J7QBoRxU0nxa22+TApjCx8WB1hN
         6/PkfZwBOdkRrCfi/J7dQyuniGTh3iCqfZMw6QE2lWbWqHvsbOsEjW/BElcLkNHy0z0q
         bf8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3cffZCgP4sr8BnADi733FLoP9vNC7tnFYq6HsCC4n/0=;
        b=lskVUiOUhC7rLkK//VExurTT8+ovX/lZjVjLBZFFnI4AqdsKE9yRTtrNxXIuQBaB+N
         UKg/3D2v7uF7t7k6N3p3FSTFbie/h5c+qhJob99JVJj04FQ2BZq8bMNqQD7SvEjDKVu2
         2jT8F3Ftrs1s6i0PtVzakCu+n/VF9wbzrynykdnypZR709cyBt4wS9M9qXjmic4+u3Q5
         Xs5whTdxdmw3kIqvVTHiqk+5OWC8/UJsjj9hHdpxuApK5GjDKia8SEus5wuAdauoGV+q
         pvwK7VvHiREoodHNUmz7zPY3nBHFe84OGljtFkt28pu5AXVTXVf0rv0guQbgKful2rdR
         u3dg==
X-Gm-Message-State: AOAM5316nMpa9x7Fcecn31XVUQ96GDIqnXOdd16QkG+RS0wKmsUJVJ5I
        Dmxp+9k7L28ppgK1ZQBHFsbKdmmXnINQC+IkYp557Q==
X-Google-Smtp-Source: ABdhPJxRpy4RwaYAEWNGB/4NZSVDsLgz1+2j8/xGCCV6MIR8Q/mJ+Hm+ZqIqtlsbJPQBqgwtocQAFY4h4+4Gzw1eGTw=
X-Received: by 2002:a05:600c:a42:b0:393:d831:bf05 with SMTP id
 c2-20020a05600c0a4200b00393d831bf05mr4265524wmq.187.1653407806702; Tue, 24
 May 2022 08:56:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220518225531.558008-1-sdf@google.com> <20220518225531.558008-4-sdf@google.com>
 <20220521005313.3q3w2ventgwrccrd@kafai-mbp> <CAKH8qBuUW8vSgTaF-K_kOPoX3kXBy5Z=ufcMx8mwTwkxs2wQ6g@mail.gmail.com>
 <20220524054007.nskzzkghazi73xr4@kafai-mbp>
In-Reply-To: <20220524054007.nskzzkghazi73xr4@kafai-mbp>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 24 May 2022 08:56:35 -0700
Message-ID: <CAKH8qBudhdTz7w90-pVZGKA57H9+1ymh8jwrc0SPLuNeXr+JRA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 03/11] bpf: per-cgroup lsm flavor
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

On Mon, May 23, 2022 at 10:40 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Mon, May 23, 2022 at 07:15:03PM -0700, Stanislav Fomichev wrote:
> > ,
> >
> > On Fri, May 20, 2022 at 5:53 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > On Wed, May 18, 2022 at 03:55:23PM -0700, Stanislav Fomichev wrote:
> > >
> > > [ ... ]
> > >
> > > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > > index ea3674a415f9..70cf1dad91df 100644
> > > > --- a/include/linux/bpf.h
> > > > +++ b/include/linux/bpf.h
> > > > @@ -768,6 +768,10 @@ void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start, struct bpf_tramp_
> > > >  u64 notrace __bpf_prog_enter_sleepable(struct bpf_prog *prog, struct bpf_tramp_run_ctx *run_ctx);
> > > >  void notrace __bpf_prog_exit_sleepable(struct bpf_prog *prog, u64 start,
> > > >                                      struct bpf_tramp_run_ctx *run_ctx);
> > > > +u64 notrace __bpf_prog_enter_lsm_cgroup(struct bpf_prog *prog,
> > > > +                                     struct bpf_tramp_run_ctx *run_ctx);
> > > > +void notrace __bpf_prog_exit_lsm_cgroup(struct bpf_prog *prog, u64 start,
> > > > +                                     struct bpf_tramp_run_ctx *run_ctx);
> > > >  void notrace __bpf_tramp_enter(struct bpf_tramp_image *tr);
> > > >  void notrace __bpf_tramp_exit(struct bpf_tramp_image *tr);
> > > >
> > > > @@ -1035,6 +1039,7 @@ struct bpf_prog_aux {
> > > >       u64 load_time; /* ns since boottime */
> > > >       u32 verified_insns;
> > > >       struct bpf_map *cgroup_storage[MAX_BPF_CGROUP_STORAGE_TYPE];
> > > > +     int cgroup_atype; /* enum cgroup_bpf_attach_type */
> > > >       char name[BPF_OBJ_NAME_LEN];
> > > >  #ifdef CONFIG_SECURITY
> > > >       void *security;
> > > > @@ -1107,6 +1112,12 @@ struct bpf_tramp_link {
> > > >       u64 cookie;
> > > >  };
> > > >
> > > > +struct bpf_shim_tramp_link {
> > > > +     struct bpf_tramp_link tramp_link;
> > > > +     struct bpf_trampoline *tr;
> > > > +     atomic64_t refcnt;
> > > There is already a refcnt in 'struct bpf_link'.
> > > Reuse that one if possible.
> >
> > I was assuming that having a per-bpf_shim_tramp_link recfnt might be
> > more readable. I'll switch to the one from bpf_link per comments
> > below.
> >
> > > [ ... ]
> > >
> > > > diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> > > > index 01ce78c1df80..c424056f0b35 100644
> > > > --- a/kernel/bpf/trampoline.c
> > > > +++ b/kernel/bpf/trampoline.c
> > > > @@ -11,6 +11,8 @@
> > > >  #include <linux/rcupdate_wait.h>
> > > >  #include <linux/module.h>
> > > >  #include <linux/static_call.h>
> > > > +#include <linux/bpf_verifier.h>
> > > > +#include <linux/bpf_lsm.h>
> > > >
> > > >  /* dummy _ops. The verifier will operate on target program's ops. */
> > > >  const struct bpf_verifier_ops bpf_extension_verifier_ops = {
> > > > @@ -497,6 +499,163 @@ int bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_trampolin
> > > >       return err;
> > > >  }
> > > >
> > > > +#if defined(CONFIG_BPF_JIT) && defined(CONFIG_BPF_SYSCALL)
> > > > +static struct bpf_shim_tramp_link *cgroup_shim_alloc(const struct bpf_prog *prog,
> > > > +                                                  bpf_func_t bpf_func)
> > > > +{
> > > > +     struct bpf_shim_tramp_link *shim_link = NULL;
> > > > +     struct bpf_prog *p;
> > > > +
> > > > +     shim_link = kzalloc(sizeof(*shim_link), GFP_USER);
> > > > +     if (!shim_link)
> > > > +             return NULL;
> > > > +
> > > > +     p = bpf_prog_alloc(1, 0);
> > > > +     if (!p) {
> > > > +             kfree(shim_link);
> > > > +             return NULL;
> > > > +     }
> > > > +
> > > > +     p->jited = false;
> > > > +     p->bpf_func = bpf_func;
> > > > +
> > > > +     p->aux->cgroup_atype = prog->aux->cgroup_atype;
> > > > +     p->aux->attach_func_proto = prog->aux->attach_func_proto;
> > > > +     p->aux->attach_btf_id = prog->aux->attach_btf_id;
> > > > +     p->aux->attach_btf = prog->aux->attach_btf;
> > > > +     btf_get(p->aux->attach_btf);
> > > > +     p->type = BPF_PROG_TYPE_LSM;
> > > > +     p->expected_attach_type = BPF_LSM_MAC;
> > > > +     bpf_prog_inc(p);
> > > > +     bpf_link_init(&shim_link->tramp_link.link, BPF_LINK_TYPE_TRACING, NULL, p);
> > > > +     atomic64_set(&shim_link->refcnt, 1);
> > > > +
> > > > +     return shim_link;
> > > > +}
> > > > +
> > > > +static struct bpf_shim_tramp_link *cgroup_shim_find(struct bpf_trampoline *tr,
> > > > +                                                 bpf_func_t bpf_func)
> > > > +{
> > > > +     struct bpf_tramp_link *link;
> > > > +     int kind;
> > > > +
> > > > +     for (kind = 0; kind < BPF_TRAMP_MAX; kind++) {
> > > > +             hlist_for_each_entry(link, &tr->progs_hlist[kind], tramp_hlist) {
> > > > +                     struct bpf_prog *p = link->link.prog;
> > > > +
> > > > +                     if (p->bpf_func == bpf_func)
> > > > +                             return container_of(link, struct bpf_shim_tramp_link, tramp_link);
> > > > +             }
> > > > +     }
> > > > +
> > > > +     return NULL;
> > > > +}
> > > > +
> > > > +static void cgroup_shim_put(struct bpf_shim_tramp_link *shim_link)
> > > > +{
> > > > +     if (shim_link->tr)
> > > I have been spinning back and forth with this "shim_link->tr" test and
> > > the "!shim_link->tr" test below with an atomic64_dec_and_test() test
> > > in between  :)
> >
> > I did this dance so I can call cgroup_shim_put from
> > bpf_trampoline_link_cgroup_shim, I guess that's confusing.
> > bpf_trampoline_link_cgroup_shim can call cgroup_shim_put when
> > __bpf_trampoline_link_prog fails (shim_prog->tr==NULL);
> > cgroup_shim_put can be also called to unlink the prog from the
> > trampoline (shim_prog->tr!=NULL).
> >
> > > > +             bpf_trampoline_put(shim_link->tr);
> > > Why put(tr) here?
> > >
> > > Intuitive thinking is that should be done after __bpf_trampoline_unlink_prog(.., tr)
> > > which is still using the tr.
> > > or I missed something inside __bpf_trampoline_unlink_prog(..., tr) ?
> > >
> > > > +
> > > > +     if (!atomic64_dec_and_test(&shim_link->refcnt))
> > > > +             return;
> > > > +
> > > > +     if (!shim_link->tr)
> > > And this is only for the error case in bpf_trampoline_link_cgroup_shim()?
> > > Can it be handled locally in bpf_trampoline_link_cgroup_shim()
> > > where it could actually happen ?
> >
> > Yeah, agreed, I'll move the cleanup path to
> > bpf_trampoline_link_cgroup_shim to make it less confusing here.
> >
> > > > +             return;
> > > > +
> > > > +     WARN_ON_ONCE(__bpf_trampoline_unlink_prog(&shim_link->tramp_link, shim_link->tr));
> > > > +     kfree(shim_link);
> > > How about shim_link->tramp_link.link.prog, is the prog freed ?
> > >
> > > Considering the bpf_link_put() does bpf_prog_put(link->prog).
> > > Is there a reason the bpf_link_put() not used and needs to
> > > manage its own shim_link->refcnt here ?
> >
> > Good catch, I've missed the bpf_prog_put(link->prog) part. Let me see
> > if I can use the link's refcnt, it seems like I can define my own
> > link->ops->dealloc to call __bpf_trampoline_unlink_prog and the rest
> > will be taken care of.
> >
> > > > +}
> > > > +
> > > > +int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
> > > > +                                 struct bpf_attach_target_info *tgt_info)
> > > > +{
> > > > +     struct bpf_shim_tramp_link *shim_link = NULL;
> > > > +     struct bpf_trampoline *tr;
> > > > +     bpf_func_t bpf_func;
> > > > +     u64 key;
> > > > +     int err;
> > > > +
> > > > +     key = bpf_trampoline_compute_key(NULL, prog->aux->attach_btf,
> > > > +                                      prog->aux->attach_btf_id);
> > > > +
> > > > +     err = bpf_lsm_find_cgroup_shim(prog, &bpf_func);
> > > > +     if (err)
> > > > +             return err;
> > > > +
> > > > +     tr = bpf_trampoline_get(key, tgt_info);
> > > > +     if (!tr)
> > > > +             return  -ENOMEM;
> > > > +
> > > > +     mutex_lock(&tr->mutex);
> > > > +
> > > > +     shim_link = cgroup_shim_find(tr, bpf_func);
> > > > +     if (shim_link) {
> > > > +             /* Reusing existing shim attached by the other program. */
> > > > +             atomic64_inc(&shim_link->refcnt);
> > > > +             /* note, we're still holding tr refcnt from above */
> > > hmm... why it still needs to hold the tr refcnt ?
> >
> > I'm assuming we need to hold the trampoline for as long as shim_prog
> > is attached to it, right? Otherwise it gets kfreed.
> Each 'attached' cgroup-lsm prog holds the shim_link's refcnt.
> shim_link holds both the trampoline's and the shim_prog's refcnt.
>
> As long as there is attached cgroup-lsm prog(s).  shim_link's refcnt
> should not be zero.  The shim_link will stay and so does the
> shim_link's trampoline and shim_prog.
>
> When the last cgroup-lsm prog is detached, bpf_link_put() should
> unlink itself (and its shim_prog) from the trampoline first and
> then do a bpf_trampoline_put(tr) and bpf_prog_put(shim_prog).
> I think bpf_tracing_link_release() is doing something similar also.

Yeah, I played with it a bit yesterday and ended up with the same
contents as bpf_tracing_link_release. Thanks for the pointers!
