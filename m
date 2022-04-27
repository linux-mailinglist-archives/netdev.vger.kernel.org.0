Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D431511D49
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244402AbiD0RvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 13:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244349AbiD0RvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 13:51:13 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810C9443E5
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 10:48:01 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 129so1601195wmz.0
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 10:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yf4IEzeB1zfPWi9UBktEXEAnASflYtbvL38NGmaj4YU=;
        b=FkJdUGkFRF3BLaVpa7JJ+cXoJXoTM65mGetsWofpea6+0/2muV6vMmx+4bkF0MMf5w
         FzDb/QnPShwp1CP3bIi3w84CNxt4iBhizwlPL/6H+Ot0JdPk/MnWTiOUqjgKp7AsA0gY
         a6aaB4FWNYeQVkoHC37TaueDx7CiIgSmUs7Y8vFNADj+G/a1MVc66ldNWXZsmWdCdZRQ
         O1zlJRWH++VQwjfCf1F91H2D4zCeZqbMCYbfZc0psLPdyeqWg7A8o1FX/FV6DmRHkpEJ
         nr31zRuJXJihlb9vo+UWFI+bkVRwJQE/4VfK2DMtJDJfp1tbcq/HpdZYvdwCOuP/zUc4
         PKkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yf4IEzeB1zfPWi9UBktEXEAnASflYtbvL38NGmaj4YU=;
        b=tu0odlBdKgAG0HMvQkqXgy8ARrvvip7IiHo3fp3Xtrk58fuooYhA6pZ8FJBkZzOuF1
         kdN5wjFC9jWW80YKLpRbt4z7GWpV048nL/w9LH/vm3LoYxwt3xRN0NjcMk+dvfQwFI8R
         xtzM6WENgFxxgWntSZn9hKv9slHCrxACvzaYNh7v1trvYp/vFPiAgtuAHayYLo99lqei
         gqqY9UB7ertdlTjlrWPPT0teay4Vo/efk/Ritx1jv40jWz/5BrYv7mQv6AQvh1Ht25uP
         ukGaPyznhH5jKdPZaHrPgakTOTixk0OQiNAauWU5dyA/53d4slS/d8O18nqlVqHnn0NL
         ghtg==
X-Gm-Message-State: AOAM533kyJZFGkr3vEaXzS+FbrZYSbdAzX9K2B/JnD/wV0J83l4V4OzM
        ZLs+Z11GTeSwvHxgdt1OUZ8mNpLgStul6uLMuW/7Mg==
X-Google-Smtp-Source: ABdhPJzcD4Oq9IyT2Xht8M49zRixoI16G1glMWw8pSVDvLGvRZruzLq80ukIcaWGqi/acI9Nl1ZWsz+PXY0RAE0yPnw=
X-Received: by 2002:a05:600c:a42:b0:393:d831:bf05 with SMTP id
 c2-20020a05600c0a4200b00393d831bf05mr25071293wmq.187.1651081679889; Wed, 27
 Apr 2022 10:47:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220419190053.3395240-1-sdf@google.com> <20220419190053.3395240-4-sdf@google.com>
 <20220427001006.dr5dl5mocufskmvv@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220427001006.dr5dl5mocufskmvv@kafai-mbp.dhcp.thefacebook.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 27 Apr 2022 10:47:48 -0700
Message-ID: <CAKH8qBsB2Y5+5AhA0Unew77uxCGdNfF3f9DWdEoyp0HwCrWQZg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 3/8] bpf: per-cgroup lsm flavor
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 26, 2022 at 5:10 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, Apr 19, 2022 at 12:00:48PM -0700, Stanislav Fomichev wrote:
> > +static void bpf_cgroup_storages_unlink(struct bpf_cgroup_storage *storages[])
> > +{
> > +     enum bpf_cgroup_storage_type stype;
> > +
> > +     for_each_cgroup_storage_type(stype)
> > +             bpf_cgroup_storage_unlink(storages[stype]);
> > +}
> > +
> >  /* Called when bpf_cgroup_link is auto-detached from dying cgroup.
> >   * It drops cgroup and bpf_prog refcounts, and marks bpf_link as defunct. It
> >   * doesn't free link memory, which will eventually be done by bpf_link's
> > @@ -166,6 +256,16 @@ static void bpf_cgroup_link_auto_detach(struct bpf_cgroup_link *link)
> >       link->cgroup = NULL;
> >  }
> >
> > +static void bpf_cgroup_lsm_shim_release(struct bpf_prog *prog,
> > +                                     enum cgroup_bpf_attach_type atype)
> > +{
> > +     if (prog->aux->cgroup_atype < CGROUP_LSM_START ||
> > +         prog->aux->cgroup_atype > CGROUP_LSM_END)
> > +             return;
> > +
> > +     bpf_trampoline_unlink_cgroup_shim(prog);
> > +}
> > +
> >  /**
> >   * cgroup_bpf_release() - put references of all bpf programs and
> >   *                        release all cgroup bpf data
> > @@ -190,10 +290,18 @@ static void cgroup_bpf_release(struct work_struct *work)
> >
> >               hlist_for_each_entry_safe(pl, pltmp, progs, node) {
> >                       hlist_del(&pl->node);
> > -                     if (pl->prog)
> > +                     if (pl->prog) {
> > +                             if (atype == BPF_LSM_CGROUP)
> > +                                     bpf_cgroup_lsm_shim_release(pl->prog,
> > +                                                                 atype);
> >                               bpf_prog_put(pl->prog);
> > -                     if (pl->link)
> > +                     }
> > +                     if (pl->link) {
> > +                             if (atype == BPF_LSM_CGROUP)
> > +                                     bpf_cgroup_lsm_shim_release(pl->link->link.prog,
> > +                                                                 atype);
> >                               bpf_cgroup_link_auto_detach(pl->link);
> > +                     }
> >                       kfree(pl);
> >                       static_branch_dec(&cgroup_bpf_enabled_key[atype]);
> >               }
> > @@ -506,6 +614,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> >       struct bpf_prog *old_prog = NULL;
> >       struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
> >       struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
> > +     struct bpf_attach_target_info tgt_info = {};
> >       enum cgroup_bpf_attach_type atype;
> >       struct bpf_prog_list *pl;
> >       struct hlist_head *progs;
> > @@ -522,9 +631,35 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> >               /* replace_prog implies BPF_F_REPLACE, and vice versa */
> >               return -EINVAL;
> >
> > -     atype = to_cgroup_bpf_attach_type(type);
> > -     if (atype < 0)
> > -             return -EINVAL;
> > +     if (type == BPF_LSM_CGROUP) {
> > +             struct bpf_prog *p = prog ? : link->link.prog;
> > +
> > +             if (replace_prog) {
> > +                     /* Reusing shim from the original program.
> > +                      */
> > +                     if (replace_prog->aux->attach_btf_id !=
> > +                         p->aux->attach_btf_id)
> > +                             return -EINVAL;
> > +
> > +                     atype = replace_prog->aux->cgroup_atype;
> > +             } else {
> > +                     err = bpf_check_attach_target(NULL, p, NULL,
> > +                                                   p->aux->attach_btf_id,
> > +                                                   &tgt_info);
> > +                     if (err)
> > +                             return -EINVAL;
> > +
> > +                     atype = bpf_lsm_attach_type_get(p->aux->attach_btf_id);
> > +                     if (atype < 0)
> > +                             return atype;
> > +             }
> > +
> > +             p->aux->cgroup_atype = atype;
> > +     } else {
> > +             atype = to_cgroup_bpf_attach_type(type);
> > +             if (atype < 0)
> > +                     return -EINVAL;
> > +     }
> >
> >       progs = &cgrp->bpf.progs[atype];
> >
> > @@ -580,13 +715,26 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> >       if (err)
> >               goto cleanup;
> >
> > +     bpf_cgroup_storages_link(new_storage, cgrp, type);
> After looking between this patch 3 and the next patch 4, I can't
> quite think this through quickly, so it may be faster to ask :)
>
> I have questions on the ordering between update_effective_progs(),
> bpf_cgroup_storages_link(), and bpf_trampoline_link_cgroup_shim().
>
> Why bpf_cgroup_storages_link() has to be moved up and done before
> bpf_trampoline_link_cgroup_shim() ?

Looking at it again: I think I'm confusing bpf_cgroup_storages_assign
with bpf_cgroup_storages_link and we don't need to move the latter.
For context: my reasoning here was to make sure the prog has cgroup
storage before bpf_trampoline_link_cgroup_shim installs the actual
trampoline which might trigger the programs.

> > +
> > +     if (type == BPF_LSM_CGROUP && !old_prog) {
> > +             struct bpf_prog *p = prog ? : link->link.prog;
> > +
> > +             err = bpf_trampoline_link_cgroup_shim(p, &tgt_info);
> update_effective_progs() was done a few lines above, so the effective[atype]
> array has the new_prog now.
>
> If bpf_trampoline_link_cgroup_shim() did fail to add the
> shim_prog to the trampoline, the new_prog will still be left in
> effective[atype].  There is no shim_prog to execute effective[].
> However, there may be places that access effective[]. e.g.
> __cgroup_bpf_query() although I think to_cgroup_bpf_attach_type()
> is not handling BPF_LSM_CGROUP now.  More on __cgroup_bpf_query()
> later.
>
> Doing bpf_trampoline_link_cgroup_shim() just before activate_effective_progs() ?

Yeah, you're right, I thought that there was a cleanup path that
undoes update_effective_progs action :-( Moving link_cgroup_shim
before update_effective_progs/activate_effective_progs makes sense,
thank you!

> Have you thought about what is needed to support __cgroup_bpf_query() ?
> bpf_attach_type and cgroup_bpf_attach_type is no longer a 1:1 relationship.
> Looping through cgroup_lsm_atype_usecnt[] and output them under BPF_LSM_CGROUP ?
> Same goes for local_storage.  All lsm-cgrp attaching to different
> attach_btf_id sharing one local_storage because the key is only
> cgroup-id and attach_type.  Is it enough to start with that
> first and the key could be extended later with a new map_flag?
> This is related to the API.

Ugh, I think I was still under the impression that it would just work
out. But I haven't thought about __cgroup_bpf_query in the context of
the next change which breaks that 1:1 relationship. Good catch, I have
to look into that and will add a test to verify.

Regarding cgroup_id+attach_type key of local storage: maybe prohibit
that mode for BPF_LSM_CGROUP ? We have two modes: (1) keyed by
cgroup_id+attach_type and (2) keyed by cgroup_id only (and might be
shared across attach_types). The first one never made much sense to
me; the second one behaves exactly like the rest of local storages
(file/sk/etc). WDYT? (we can enable (1) if we ever decide that it's
needed)
