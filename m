Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A90805320CB
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 04:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbiEXCPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 22:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbiEXCPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 22:15:17 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159BD9CCA0
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 19:15:16 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id p10so5067399wrg.12
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 19:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Or8PTx9AUsidWdMwCbnt9/cMM67cUIEaj9gd6gWYIh8=;
        b=bLAWzSme4wcMHvAsgmjORkkySb0D1hN053+a727gAtF0VscPhq4iVFeYUsq3YnYu6X
         MOF5biG8/hFn59z6WC2spzK8XJdiVsIdD6mimz/3nCaeebvLatH52J2/BUtDZHV2XR2Q
         DTr2tfApHmzicmY5Cjxkd2KGj+U3wxFqixIFL7DIfYtLj7Otvkmg1TS0RlFpeiN58PtL
         R3czLr9Ucm7yw0DmPlb5+Je9K8yGkugeeCm92XpJz5w/nyK1uggt2j56cQJdjZGCYwPd
         Oyo14N/5Q5ZDxfDaIpUXs6FJTDOKrrubKfkxg32mlFfjavIlLdjpIBNFGgMWG5JSkOxt
         WFtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Or8PTx9AUsidWdMwCbnt9/cMM67cUIEaj9gd6gWYIh8=;
        b=XYnIpa9E5RiDbcCHpaXRsGGqfdQ2+dT1j9KAlhKPCwoBuZ0TLbYkhLXnYQn4kL82ot
         MZ72kbEikKMi/d4UQ8f9/GhcXSPxBtnsTXUmc6XPisfQ19J/4nFLNBy0R7Ea+ZEnhorx
         KurZzGVafxLTkIzXvAcch5d6qmVYJq5EZ/+UQ48pTEGGLQPPkeYmcWu38bH7qUnIYxki
         cQEPYMtUhMsje1iwzsPPrj2/2WgRF+fAY77dJXyrbbG6RPgqEevCoFw1nJegrdBxCA+o
         bN9ftoUMboNJqBI7At0pRhlX1AnSupfw3dvfIeVuQGlDafUOoIWbg/3caAASX+uzRpXj
         KMOw==
X-Gm-Message-State: AOAM532B07LC+7JHtuOgrETjGQVJx19v1wpr3GOpcVNRF9SWjvvSLi3V
        sjlPgdqEwkO00t+pRUTIpJ8XBdo+z9mfm5Xl6Hck7w==
X-Google-Smtp-Source: ABdhPJwvsZqgnH9wdgmNCtq35DY4vpSX0XvoyEB93xiIzKYu4J7TsI5lYD9AkG8TDFE0OUlYne3bpmDhkbECQA28w9c=
X-Received: by 2002:a5d:6c6e:0:b0:20f:c39b:c416 with SMTP id
 r14-20020a5d6c6e000000b0020fc39bc416mr13354422wrz.463.1653358514505; Mon, 23
 May 2022 19:15:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220518225531.558008-1-sdf@google.com> <20220518225531.558008-4-sdf@google.com>
 <20220521005313.3q3w2ventgwrccrd@kafai-mbp>
In-Reply-To: <20220521005313.3q3w2ventgwrccrd@kafai-mbp>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 23 May 2022 19:15:03 -0700
Message-ID: <CAKH8qBuUW8vSgTaF-K_kOPoX3kXBy5Z=ufcMx8mwTwkxs2wQ6g@mail.gmail.com>
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

,

On Fri, May 20, 2022 at 5:53 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Wed, May 18, 2022 at 03:55:23PM -0700, Stanislav Fomichev wrote:
>
> [ ... ]
>
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index ea3674a415f9..70cf1dad91df 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -768,6 +768,10 @@ void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start, struct bpf_tramp_
> >  u64 notrace __bpf_prog_enter_sleepable(struct bpf_prog *prog, struct bpf_tramp_run_ctx *run_ctx);
> >  void notrace __bpf_prog_exit_sleepable(struct bpf_prog *prog, u64 start,
> >                                      struct bpf_tramp_run_ctx *run_ctx);
> > +u64 notrace __bpf_prog_enter_lsm_cgroup(struct bpf_prog *prog,
> > +                                     struct bpf_tramp_run_ctx *run_ctx);
> > +void notrace __bpf_prog_exit_lsm_cgroup(struct bpf_prog *prog, u64 start,
> > +                                     struct bpf_tramp_run_ctx *run_ctx);
> >  void notrace __bpf_tramp_enter(struct bpf_tramp_image *tr);
> >  void notrace __bpf_tramp_exit(struct bpf_tramp_image *tr);
> >
> > @@ -1035,6 +1039,7 @@ struct bpf_prog_aux {
> >       u64 load_time; /* ns since boottime */
> >       u32 verified_insns;
> >       struct bpf_map *cgroup_storage[MAX_BPF_CGROUP_STORAGE_TYPE];
> > +     int cgroup_atype; /* enum cgroup_bpf_attach_type */
> >       char name[BPF_OBJ_NAME_LEN];
> >  #ifdef CONFIG_SECURITY
> >       void *security;
> > @@ -1107,6 +1112,12 @@ struct bpf_tramp_link {
> >       u64 cookie;
> >  };
> >
> > +struct bpf_shim_tramp_link {
> > +     struct bpf_tramp_link tramp_link;
> > +     struct bpf_trampoline *tr;
> > +     atomic64_t refcnt;
> There is already a refcnt in 'struct bpf_link'.
> Reuse that one if possible.

I was assuming that having a per-bpf_shim_tramp_link recfnt might be
more readable. I'll switch to the one from bpf_link per comments
below.

> [ ... ]
>
> > diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> > index 01ce78c1df80..c424056f0b35 100644
> > --- a/kernel/bpf/trampoline.c
> > +++ b/kernel/bpf/trampoline.c
> > @@ -11,6 +11,8 @@
> >  #include <linux/rcupdate_wait.h>
> >  #include <linux/module.h>
> >  #include <linux/static_call.h>
> > +#include <linux/bpf_verifier.h>
> > +#include <linux/bpf_lsm.h>
> >
> >  /* dummy _ops. The verifier will operate on target program's ops. */
> >  const struct bpf_verifier_ops bpf_extension_verifier_ops = {
> > @@ -497,6 +499,163 @@ int bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_trampolin
> >       return err;
> >  }
> >
> > +#if defined(CONFIG_BPF_JIT) && defined(CONFIG_BPF_SYSCALL)
> > +static struct bpf_shim_tramp_link *cgroup_shim_alloc(const struct bpf_prog *prog,
> > +                                                  bpf_func_t bpf_func)
> > +{
> > +     struct bpf_shim_tramp_link *shim_link = NULL;
> > +     struct bpf_prog *p;
> > +
> > +     shim_link = kzalloc(sizeof(*shim_link), GFP_USER);
> > +     if (!shim_link)
> > +             return NULL;
> > +
> > +     p = bpf_prog_alloc(1, 0);
> > +     if (!p) {
> > +             kfree(shim_link);
> > +             return NULL;
> > +     }
> > +
> > +     p->jited = false;
> > +     p->bpf_func = bpf_func;
> > +
> > +     p->aux->cgroup_atype = prog->aux->cgroup_atype;
> > +     p->aux->attach_func_proto = prog->aux->attach_func_proto;
> > +     p->aux->attach_btf_id = prog->aux->attach_btf_id;
> > +     p->aux->attach_btf = prog->aux->attach_btf;
> > +     btf_get(p->aux->attach_btf);
> > +     p->type = BPF_PROG_TYPE_LSM;
> > +     p->expected_attach_type = BPF_LSM_MAC;
> > +     bpf_prog_inc(p);
> > +     bpf_link_init(&shim_link->tramp_link.link, BPF_LINK_TYPE_TRACING, NULL, p);
> > +     atomic64_set(&shim_link->refcnt, 1);
> > +
> > +     return shim_link;
> > +}
> > +
> > +static struct bpf_shim_tramp_link *cgroup_shim_find(struct bpf_trampoline *tr,
> > +                                                 bpf_func_t bpf_func)
> > +{
> > +     struct bpf_tramp_link *link;
> > +     int kind;
> > +
> > +     for (kind = 0; kind < BPF_TRAMP_MAX; kind++) {
> > +             hlist_for_each_entry(link, &tr->progs_hlist[kind], tramp_hlist) {
> > +                     struct bpf_prog *p = link->link.prog;
> > +
> > +                     if (p->bpf_func == bpf_func)
> > +                             return container_of(link, struct bpf_shim_tramp_link, tramp_link);
> > +             }
> > +     }
> > +
> > +     return NULL;
> > +}
> > +
> > +static void cgroup_shim_put(struct bpf_shim_tramp_link *shim_link)
> > +{
> > +     if (shim_link->tr)
> I have been spinning back and forth with this "shim_link->tr" test and
> the "!shim_link->tr" test below with an atomic64_dec_and_test() test
> in between  :)

I did this dance so I can call cgroup_shim_put from
bpf_trampoline_link_cgroup_shim, I guess that's confusing.
bpf_trampoline_link_cgroup_shim can call cgroup_shim_put when
__bpf_trampoline_link_prog fails (shim_prog->tr==NULL);
cgroup_shim_put can be also called to unlink the prog from the
trampoline (shim_prog->tr!=NULL).

> > +             bpf_trampoline_put(shim_link->tr);
> Why put(tr) here?
>
> Intuitive thinking is that should be done after __bpf_trampoline_unlink_prog(.., tr)
> which is still using the tr.
> or I missed something inside __bpf_trampoline_unlink_prog(..., tr) ?
>
> > +
> > +     if (!atomic64_dec_and_test(&shim_link->refcnt))
> > +             return;
> > +
> > +     if (!shim_link->tr)
> And this is only for the error case in bpf_trampoline_link_cgroup_shim()?
> Can it be handled locally in bpf_trampoline_link_cgroup_shim()
> where it could actually happen ?

Yeah, agreed, I'll move the cleanup path to
bpf_trampoline_link_cgroup_shim to make it less confusing here.

> > +             return;
> > +
> > +     WARN_ON_ONCE(__bpf_trampoline_unlink_prog(&shim_link->tramp_link, shim_link->tr));
> > +     kfree(shim_link);
> How about shim_link->tramp_link.link.prog, is the prog freed ?
>
> Considering the bpf_link_put() does bpf_prog_put(link->prog).
> Is there a reason the bpf_link_put() not used and needs to
> manage its own shim_link->refcnt here ?

Good catch, I've missed the bpf_prog_put(link->prog) part. Let me see
if I can use the link's refcnt, it seems like I can define my own
link->ops->dealloc to call __bpf_trampoline_unlink_prog and the rest
will be taken care of.

> > +}
> > +
> > +int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
> > +                                 struct bpf_attach_target_info *tgt_info)
> > +{
> > +     struct bpf_shim_tramp_link *shim_link = NULL;
> > +     struct bpf_trampoline *tr;
> > +     bpf_func_t bpf_func;
> > +     u64 key;
> > +     int err;
> > +
> > +     key = bpf_trampoline_compute_key(NULL, prog->aux->attach_btf,
> > +                                      prog->aux->attach_btf_id);
> > +
> > +     err = bpf_lsm_find_cgroup_shim(prog, &bpf_func);
> > +     if (err)
> > +             return err;
> > +
> > +     tr = bpf_trampoline_get(key, tgt_info);
> > +     if (!tr)
> > +             return  -ENOMEM;
> > +
> > +     mutex_lock(&tr->mutex);
> > +
> > +     shim_link = cgroup_shim_find(tr, bpf_func);
> > +     if (shim_link) {
> > +             /* Reusing existing shim attached by the other program. */
> > +             atomic64_inc(&shim_link->refcnt);
> > +             /* note, we're still holding tr refcnt from above */
> hmm... why it still needs to hold the tr refcnt ?

I'm assuming we need to hold the trampoline for as long as shim_prog
is attached to it, right? Otherwise it gets kfreed.



> > +
> > +             mutex_unlock(&tr->mutex);
> > +             return 0;
> > +     }
> > +
> > +     /* Allocate and install new shim. */
> > +
> > +     shim_link = cgroup_shim_alloc(prog, bpf_func);
> > +     if (!shim_link) {
> > +             bpf_trampoline_put(tr);
> > +             err = -ENOMEM;
> > +             goto out;
> > +     }
> > +
> > +     err = __bpf_trampoline_link_prog(&shim_link->tramp_link, tr);
> > +     if (err)
> > +             goto out;
> > +
> > +     shim_link->tr = tr;
> > +
> > +     mutex_unlock(&tr->mutex);
> > +
> > +     return 0;
> > +out:
> > +     mutex_unlock(&tr->mutex);
> > +
> > +     if (shim_link)
> > +             cgroup_shim_put(shim_link);
> > +
> > +     return err;
> > +}
> > +
