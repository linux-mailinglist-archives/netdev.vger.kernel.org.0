Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6D11E88AB
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 22:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbgE2UMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 16:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbgE2UMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 16:12:33 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FBBC03E969;
        Fri, 29 May 2020 13:12:31 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id z64so389381pfb.1;
        Fri, 29 May 2020 13:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gUocMtpwdaWAZ7apW76UnYvJQVntYbYjDQYSBzcs1Yo=;
        b=KRHZXIHgK5lSYK8fl8l2EdAEuxToMG2nYz96YF9odBvToMi+KHVX1yxpy91pG+wNu5
         427jiCI1XW02fz2EJqz9xOsXMHQDJC1FcLSv/Fx1ff6vCaNjtq4zuyy+odzwchNQF+I5
         VbCpWLYv5s9eE34eKD9mfJJUzxHSdrObemXxbr9TzaMEo1rfXsaCKnDOs74MFqYF+Coj
         nxSv0+Q2ioCjy+ONHqPwGf58WOBKZlrSC71txNf9xeMsr9UVITt4QL9DZ1d7SwVwm6sD
         vMaB+tK5rJAljZhWn0NBNhvxUWSzNVrJ093wtwqSuNGagL4lKm3S55g2MEO1L71qexeN
         /T9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gUocMtpwdaWAZ7apW76UnYvJQVntYbYjDQYSBzcs1Yo=;
        b=TMkgHLhlP6e+rCEczRmeQa1GkJu9/mj96yC+TOn47jDbFY0mKRojh69ZhZf7gS/67Y
         ze4U4RzWvaCRyCXjpQVLP4Z9x1ytwk6LM9oKpno+D4gsiwTJQqZzmEPZJQpC9olAdAHN
         KOL2oKh0ScYjh+go44Rx1MkZc9zsQ0AOprd0kP0L3tyiFbPqnj8VFk3iiL24uk7TBFQj
         jH9npS8ZzVEAB0OXrS3iXCulrT2pOzuVfCkwv/iqEz0zF5Bolsz7na/j30maqJuvisgN
         3QkGot+vNlXFfMgfXO/RTsL80LmgK+RT3ycRvClXQ+n9M623CYd4kQXHKmjG+pQQuqK1
         K1wA==
X-Gm-Message-State: AOAM533D28DTudYHTjUs6l6yny+u56n4By9Zx0f9hsNYLVpI8aer688K
        HoYjhKcgtyLLcKGCSzYf5XM=
X-Google-Smtp-Source: ABdhPJyoBiAcX4B8h9eZvd7zqegfwCNH6eWnC7Lb4GCDcasEz2nOycz9LMi49tUuhLSNGbGBF4mnng==
X-Received: by 2002:a62:7b0b:: with SMTP id w11mr10740579pfc.7.1590783151331;
        Fri, 29 May 2020 13:12:31 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:6ddc])
        by smtp.gmail.com with ESMTPSA id m2sm7876197pfe.41.2020.05.29.13.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 13:12:30 -0700 (PDT)
Date:   Fri, 29 May 2020 13:12:28 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 2/4] bpf: Introduce sleepable BPF programs
Message-ID: <20200529201228.oixjsibn6uwktkgh@ast-mbp.dhcp.thefacebook.com>
References: <20200529043839.15824-1-alexei.starovoitov@gmail.com>
 <20200529043839.15824-3-alexei.starovoitov@gmail.com>
 <CAEf4BzZXnqLwhJaUVKX0ExVa+Sw5mnhg5FLJN-VKPX59f6EAoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZXnqLwhJaUVKX0ExVa+Sw5mnhg5FLJN-VKPX59f6EAoQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 01:25:06AM -0700, Andrii Nakryiko wrote:
> > index 11584618e861..26b18b6a3dbc 100644
> > --- a/kernel/bpf/arraymap.c
> > +++ b/kernel/bpf/arraymap.c
> > @@ -393,6 +393,11 @@ static void array_map_free(struct bpf_map *map)
> >          */
> >         synchronize_rcu();
> >
> > +       /* arrays could have been used by both sleepable and non-sleepable bpf
> > +        * progs. Make sure to wait for both prog types to finish executing.
> > +        */
> > +       synchronize_srcu(&bpf_srcu);
> > +
> 
> to minimize churn later on when you switch to rcu_trace, maybe extract
> synchronize_rcu() + synchronize_srcu(&bpf_srcu) into a function (e.g.,
> something like synchronize_sleepable_bpf?), exposed as an internal
> API? That way you also wouldn't need to add bpf_srcu to linux/bpf.h?

I think the opposite is must have actually. I think rcu operations should never
be hidden in helpers. All rcu/srcu/rcu_trace ops should always be open coded.

> > @@ -577,8 +577,8 @@ static void *__htab_map_lookup_elem(struct bpf_map *map, void *key)
> >         struct htab_elem *l;
> >         u32 hash, key_size;
> >
> > -       /* Must be called with rcu_read_lock. */
> > -       WARN_ON_ONCE(!rcu_read_lock_held());
> > +       /* Must be called with s?rcu_read_lock. */
> > +       WARN_ON_ONCE(!rcu_read_lock_held() && !srcu_read_lock_held(&bpf_srcu));
> >
> 
> Similar to above, might be worthwhile extracting into a function?

This one I'm 50/50, since this pattern will be in many places.
But what kind of helper that would be?
Clear name is very hard.
WARN_ON_ONCE(!bpf_specific_rcu_lock_held()) ?
Moving WARN into the helper would be even worse.

When rcu_trace is available the churn of patches to convert srcu to rcu_trace
will be a good thing. The patches will convey the difference.
Like bpf_srcu will disappear. They will give a way to do benchmarking before/after
and will help to go back to srcu in unlikely case there is some obscure bug
in rcu_trace. Hiding srcu vs rcu_trace details behind helpers is not how
the code should read. The trade off with one and another will be different
case by case. Like synchronize_srcu() is ok, but synchronize_rcu_trace()
may be too heavy in the trampoline update code and extra counter would be needed.
Also there will be synchronize_multi() that I plan to use as well.

> >
> > +       if (prog->aux->sleepable && prog->type != BPF_PROG_TYPE_TRACING &&
> > +           prog->type != BPF_PROG_TYPE_LSM) {
> > +               verbose(env, "Only fentry/fexit/fmod_ret and lsm programs can be sleepable\n");
> > +               return -EINVAL;
> > +       }
> 
> 
> BPF_PROG_TYPE_TRACING also includes iterator and raw tracepoint
> programs. You mention only fentry/fexit/fmod_ret are allowed. What
> about those two? I don't see any explicit checks for iterator and
> raw_tracepoint attach types in a switch below, so just checking if
> they should be allowed to be sleepable?

good point. tp_btf and iter don't use trampoline, so sleepable flag
is ignored. which is wrong. I'll add a check to get the prog rejected.

> Also seems like freplace ones are also sleeepable, if they replace
> sleepable programs, right?

freplace is a different program type. So it's rejected by this code already.
Eventually I'll add support to allow sleepable freplace prog that extend
sleepable target. But that's future.

> > +
> >         if (prog->type == BPF_PROG_TYPE_STRUCT_OPS)
> >                 return check_struct_ops_btf_id(env);
> >
> > @@ -10762,8 +10801,29 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
> >                         if (ret)
> >                                 verbose(env, "%s() is not modifiable\n",
> >                                         prog->aux->attach_func_name);
> > +               } else if (prog->aux->sleepable) {
> > +                       switch (prog->type) {
> > +                       case BPF_PROG_TYPE_TRACING:
> > +                               /* fentry/fexit progs can be sleepable only if they are
> > +                                * attached to ALLOW_ERROR_INJECTION or security_*() funcs.
> > +                                */
> > +                               ret = check_attach_modify_return(prog, addr);
> 
> I was so confused about this piece... check_attach_modify_return()
> should probably be renamed to something else, it's not for fmod_ret
> only anymore.

why? I think the name is correct. The helper checks whether target
allows modifying its return value. It's a first while list.
When that passes the black list applies via check_sleepable_blacklist() function.

I was considering using whitelist for sleepable as well, but that's overkill.
Too much overlap with mod_ret.
Imo check whitelist + check blacklist for white list exceptions is clean enough.

> 
> > +                               if (!ret)
> > +                                       ret = check_sleepable_blacklist(addr);
> > +                               break;
> > +                       case BPF_PROG_TYPE_LSM:
> > +                               /* LSM progs check that they are attached to bpf_lsm_*() funcs
> > +                                * which are sleepable too.
> > +                                */
> > +                               ret = check_sleepable_blacklist(addr);
> > +                               break;
