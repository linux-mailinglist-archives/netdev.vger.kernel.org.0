Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC4D1E8904
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 22:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgE2Uiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 16:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbgE2Uiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 16:38:52 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E2BC03E969;
        Fri, 29 May 2020 13:38:51 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id q8so3473512qkm.12;
        Fri, 29 May 2020 13:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/2NpPMvxa1lPQ5BaGs7xYWYN2ckerFZ7HMypI+K/BRA=;
        b=uiHTM4oC/suL9B7x5+eawCUCqXq+UdH+vR8qgK+l5x7595H6TvAuOjzWV/czmSa+tm
         DuhVwTxh1Euki9NREGLanUYj5ACCuy3EWsIbyQkIABJiepmBQJt0/wVYTnkPYtNkKwaF
         lAVXBm5kqJqgN1L9HSr+U3z+E/ZyaaYyMQ3ts9E2UpgZLi39zQhaZeT/f+xOKw4v8Ce3
         NGjrL3L/T8lxffzQRaEQkhboB50gUURQ0K1A5eBzqGYiSiiJPfh7euKOML6YUNt36Iqw
         E50QZC01Wl9semCGflmch/J3WRRWmfCNPY707ql2c4/j94/IajY/CmTP21hJDiJaiQHb
         fD1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/2NpPMvxa1lPQ5BaGs7xYWYN2ckerFZ7HMypI+K/BRA=;
        b=DhBRP4c+KuaVdcE12fpOhSixvTeaVc+LZukyLZ0u+x74+UoGPaLRh8ON0FmN5pH0yg
         vyU6zO99hjwsXnwG3jtJIY2apkuE/7p0KsWggWyN4ji68KUI5g+H66bjOomlQWCSMJBr
         vkHUqDOMD4sC63YQ47nCui7sMVodQibnyhviWmjCBIMHLAnGk016p/xQ7/1UdOr1V8Gt
         MCwi0W/SFJj0swwEckFEplsjqkBW/TgaGkomBEdb10YSudpAWUgSQd77MbsaSVC5Ttg8
         ObN71rT3hGKBuuAuBIeULYW+7XOJiP6VEVCGRpzkKsuHZtTsxRya/vVb1lGXV3IZl153
         L+IA==
X-Gm-Message-State: AOAM530JIL+0aGpXYlDFPkuM5zDNsPDp1Uh/nvDlPh1i4LkGHxqCDQ4l
        6GXR+jJAl6cISYJ8Xvd3z1xUzMxE42zozgkPXB8=
X-Google-Smtp-Source: ABdhPJzBHrnB7JAC+YiMpcFQIp5ENtfg8IuIfCTj6hayUHz8o8p9M/7cMrzziIQu97W7GMfXi3aVk0biYRBrprJnGgc=
X-Received: by 2002:a37:6508:: with SMTP id z8mr9665440qkb.39.1590784731078;
 Fri, 29 May 2020 13:38:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200529043839.15824-1-alexei.starovoitov@gmail.com>
 <20200529043839.15824-3-alexei.starovoitov@gmail.com> <CAEf4BzZXnqLwhJaUVKX0ExVa+Sw5mnhg5FLJN-VKPX59f6EAoQ@mail.gmail.com>
 <20200529201228.oixjsibn6uwktkgh@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200529201228.oixjsibn6uwktkgh@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 29 May 2020 13:38:40 -0700
Message-ID: <CAEf4BzaVHD7HyRDQGRCUKBDOZq-LcZpHrBoOjuOP+443Xc+Vaw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/4] bpf: Introduce sleepable BPF programs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 1:12 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, May 29, 2020 at 01:25:06AM -0700, Andrii Nakryiko wrote:
> > > index 11584618e861..26b18b6a3dbc 100644
> > > --- a/kernel/bpf/arraymap.c
> > > +++ b/kernel/bpf/arraymap.c
> > > @@ -393,6 +393,11 @@ static void array_map_free(struct bpf_map *map)
> > >          */
> > >         synchronize_rcu();
> > >
> > > +       /* arrays could have been used by both sleepable and non-sleepable bpf
> > > +        * progs. Make sure to wait for both prog types to finish executing.
> > > +        */
> > > +       synchronize_srcu(&bpf_srcu);
> > > +
> >
> > to minimize churn later on when you switch to rcu_trace, maybe extract
> > synchronize_rcu() + synchronize_srcu(&bpf_srcu) into a function (e.g.,
> > something like synchronize_sleepable_bpf?), exposed as an internal
> > API? That way you also wouldn't need to add bpf_srcu to linux/bpf.h?
>
> I think the opposite is must have actually. I think rcu operations should never
> be hidden in helpers. All rcu/srcu/rcu_trace ops should always be open coded.

Ok, that's fair.

>
> > > @@ -577,8 +577,8 @@ static void *__htab_map_lookup_elem(struct bpf_map *map, void *key)
> > >         struct htab_elem *l;
> > >         u32 hash, key_size;
> > >
> > > -       /* Must be called with rcu_read_lock. */
> > > -       WARN_ON_ONCE(!rcu_read_lock_held());
> > > +       /* Must be called with s?rcu_read_lock. */
> > > +       WARN_ON_ONCE(!rcu_read_lock_held() && !srcu_read_lock_held(&bpf_srcu));
> > >
> >
> > Similar to above, might be worthwhile extracting into a function?
>
> This one I'm 50/50, since this pattern will be in many places.
> But what kind of helper that would be?
> Clear name is very hard.
> WARN_ON_ONCE(!bpf_specific_rcu_lock_held()) ?
> Moving WARN into the helper would be even worse.

yeah, naming is hard, it's fine to leave as is, I think

>
> When rcu_trace is available the churn of patches to convert srcu to rcu_trace
> will be a good thing. The patches will convey the difference.
> Like bpf_srcu will disappear. They will give a way to do benchmarking before/after
> and will help to go back to srcu in unlikely case there is some obscure bug
> in rcu_trace. Hiding srcu vs rcu_trace details behind helpers is not how
> the code should read. The trade off with one and another will be different
> case by case. Like synchronize_srcu() is ok, but synchronize_rcu_trace()
> may be too heavy in the trampoline update code and extra counter would be needed.
> Also there will be synchronize_multi() that I plan to use as well.

yeah, makes sense

>
> > >
> > > +       if (prog->aux->sleepable && prog->type != BPF_PROG_TYPE_TRACING &&
> > > +           prog->type != BPF_PROG_TYPE_LSM) {
> > > +               verbose(env, "Only fentry/fexit/fmod_ret and lsm programs can be sleepable\n");
> > > +               return -EINVAL;
> > > +       }
> >
> >
> > BPF_PROG_TYPE_TRACING also includes iterator and raw tracepoint
> > programs. You mention only fentry/fexit/fmod_ret are allowed. What
> > about those two? I don't see any explicit checks for iterator and
> > raw_tracepoint attach types in a switch below, so just checking if
> > they should be allowed to be sleepable?
>
> good point. tp_btf and iter don't use trampoline, so sleepable flag
> is ignored. which is wrong. I'll add a check to get the prog rejected.
>
> > Also seems like freplace ones are also sleeepable, if they replace
> > sleepable programs, right?
>
> freplace is a different program type. So it's rejected by this code already.
> Eventually I'll add support to allow sleepable freplace prog that extend
> sleepable target. But that's future.

Yeah, I know they are rejected (because they are EXT, not
LSM/TRACING). But they do use trampoline and they run in the same
context as replaced programs, so they are effectively same type as
replaced programs, which is why I asked. And yes, it's ok to do it in
the future, was mostly curious whether freplace have anything specific
precluding them to be sleepable.

>
> > > +
> > >         if (prog->type == BPF_PROG_TYPE_STRUCT_OPS)
> > >                 return check_struct_ops_btf_id(env);
> > >
> > > @@ -10762,8 +10801,29 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
> > >                         if (ret)
> > >                                 verbose(env, "%s() is not modifiable\n",
> > >                                         prog->aux->attach_func_name);
> > > +               } else if (prog->aux->sleepable) {
> > > +                       switch (prog->type) {
> > > +                       case BPF_PROG_TYPE_TRACING:
> > > +                               /* fentry/fexit progs can be sleepable only if they are
> > > +                                * attached to ALLOW_ERROR_INJECTION or security_*() funcs.
> > > +                                */
> > > +                               ret = check_attach_modify_return(prog, addr);
> >
> > I was so confused about this piece... check_attach_modify_return()
> > should probably be renamed to something else, it's not for fmod_ret
> > only anymore.
>
> why? I think the name is correct. The helper checks whether target
> allows modifying its return value. It's a first while list.

check_attach_modify_return() name implies to me that it's strictly for
fmod_ret-specific attachment checks, that's all. It's minor, if you
feel like name is appropriate I'm fine with it.


> When that passes the black list applies via check_sleepable_blacklist() function.
>
> I was considering using whitelist for sleepable as well, but that's overkill.
> Too much overlap with mod_ret.
> Imo check whitelist + check blacklist for white list exceptions is clean enough.

I agree about whitelist+blacklist, my only point was that
check_attach_modify_return() is not communicating that it's a
whitelist. check_sleepable_blacklist() is clear as day,
check_sleepable_whitelist() would be as clear, even if internally it
(for now) just calls into check_attach_modify_return(). Eventually it
might be evolved beyond what's in check_attach_modify_return(). Not a
big deal and can be changed later, if necessary.

>
> >
> > > +                               if (!ret)
> > > +                                       ret = check_sleepable_blacklist(addr);
> > > +                               break;
> > > +                       case BPF_PROG_TYPE_LSM:
> > > +                               /* LSM progs check that they are attached to bpf_lsm_*() funcs
> > > +                                * which are sleepable too.
> > > +                                */
> > > +                               ret = check_sleepable_blacklist(addr);
> > > +                               break;
