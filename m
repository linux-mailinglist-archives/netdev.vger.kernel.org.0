Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94F3A52262A
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 23:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbiEJVPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 17:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbiEJVPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 17:15:01 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B8CE2670AC
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 14:15:00 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id i186so17169vsc.9
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 14:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EfSaKUcnIGqI2C2rN5fNbQKVsYUsxFnVsOZtP/sRVN8=;
        b=CrEFhXwOaURvbIEz/1Qz7PBlFKWRP636RzrABf7ZrH6yz8M2wPLMxvrP9Yf/TQwmd8
         1OLe/wtb6u6O8cPaZrsnyX7oodeVKVy/Tr5s4pBetahT4mXzS0tg1QVvAY8r3hRp4ksj
         pxpFQBhWQy/rFyUUP/Ix3wgXOv942yi00NH/Q5ZjJ4uBjmkz/ofQmrXeZaEDDyP7V/5i
         rDQCXFkQcJRf2nH0eRfQzBA+LizldD53fFwkHF/ms/gOpNFTV1rP3rXzWsiaI/ZxDtY9
         Qgs9oCWyrfITTnJY3/3Dp/QkeA+lKqBXAJ6HGuCKtlTizQtw46dcOqWrgxfgrt3GvpIA
         eFrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EfSaKUcnIGqI2C2rN5fNbQKVsYUsxFnVsOZtP/sRVN8=;
        b=GQuFdwVvxeGeBpzW4r0gCqfy7Zh8dbGrUhL0YtEPa8A4sY9DxVy727etthzAif1mhj
         ZW4E7dV/s3zsotyasVLeD2q3nMkJ3stbS4EIuj0R4K8MIDxOOxRxiDLfKaqksUyhJdsT
         66omOFB8X4qq6m17s1Va7WP5+Nnr4bgjzuI7/J9Hf/H5WYLa7MRi7QXgCs5ShrYiSqu2
         YXPbjhAv5PcFhZxPB2G9Bsy8+IYLNyDeVta9abY+zjLouQ1FUH/WYiU8UC8bQEYDl8/J
         KX2v/b8aJ7h8BhjBp/KuxE+2/jnMA5KFB9QW98TqHtzCMkZQMC2HY0mdn4XfzfrIgZpa
         9hkA==
X-Gm-Message-State: AOAM532QDcidsp2iH5rgJ1mt5DeOgTW2iqV5gdbUNEQF1WdS3Ff9Fnrt
        oMLqMEtsfdVSxXadMK30m465iPPf/Ar+xrlQmuJvUfSAr2KzcQ==
X-Google-Smtp-Source: ABdhPJyHXAKkR8rXth7/PcqyVOTWY6vBUKNwdybFBFFfCU/uYq16x/Drr04B3+xu7V5OpCUromgyKTO778V6CYhY+f0=
X-Received: by 2002:a67:d48d:0:b0:32d:6f27:9d05 with SMTP id
 g13-20020a67d48d000000b0032d6f279d05mr12660799vsj.55.1652217299027; Tue, 10
 May 2022 14:14:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220429211540.715151-1-sdf@google.com> <20220429211540.715151-4-sdf@google.com>
 <20220506230244.4t4p5gnbgg6i4tht@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBsQnzHPtuAiCs67YvTh9m+CmVR+-9wVKJggKjZnV_oYtg@mail.gmail.com>
 <20220510071334.duvldvzob777dt47@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBsR_kgQ3ETwm++AL7vZDcq1H-56eykqDdAcrveH5+ejzA@mail.gmail.com> <20220510191846.exg6gremtqx7wbst@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220510191846.exg6gremtqx7wbst@kafai-mbp.dhcp.thefacebook.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 10 May 2022 14:14:48 -0700
Message-ID: <CAKH8qBvh8EtOyYjtU7U+o2CsnZsJxvKmVG5AmNchKvZuMT_3cQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 03/10] bpf: per-cgroup lsm flavor
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

On Tue, May 10, 2022 at 12:18 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, May 10, 2022 at 10:30:57AM -0700, Stanislav Fomichev wrote:
> > On Tue, May 10, 2022 at 12:13 AM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > On Mon, May 09, 2022 at 04:38:36PM -0700, Stanislav Fomichev wrote:
> > > > > > +unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
> > > > > > +                                       const struct bpf_insn *insn)
> > > > > > +{
> > > > > > +     const struct bpf_prog *shim_prog;
> > > > > > +     struct cgroup *cgrp;
> > > > > > +     int ret = 0;
> > > > > From lsm_hook_defs.h, there are some default return values that are not 0.
> > > > > Is it ok to always return 0 in cases like the cgroup array is empty ?
> > > >
> > > > That's a good point, I haven't thought about it. You're right, it
> > > > seems like attaching to this hook for some LSMs will change the
> > > > default from some error to zero.
> > > > Let's start by prohibiting those hooks for now? I guess in theory,
> > > > when we generate a trampoline, we can put this default value as an
> > > > input arg to these new __cgroup_bpf_run_lsm_xxx helpers (in the
> > > > future)?
> > > After looking at arch_prepare_bpf_trampoline, return 0 here should be fine.
> > > If I read it correctly, when the shim_prog returns 0, the trampoline
> > > will call the original kernel function which is the bpf_lsm_##NAME()
> > > defined in bpf_lsm.c and it will then return the zero/-ve DEFAULT.
> >
> > Not sure I read the same :-/ I'm assuming that for those cases we
> > actually end up generating fmod_ret trampoline which seems to be
> > unconditionally saving r0 into fp-8 ?
> invoke_bpf_mod_ret() calls invoke_bpf_prog(..., true) that saves the r0.
>
> Later, the "if (flags & BPF_TRAMP_F_CALL_ORIG)" will still
> "/* call the original function */" and then stores the r0 retval
> from the original function, no? or I mis-read something ?

I was under the wrong assumption this whole time that fmod_ret
programs run after the original one and the first bpf program sees the
output of the original one.
Turns out it's not the case; agreed that we already do the right
thing; thanks for pointing it out!

> > > > Another thing that seems to be related: there are a bunch of hooks
> > > > that return void, so returning EPERM from the cgroup programs won't
> > > > work as expected.
> > > > I can probably record, at verification time, whether lsm_cgroup
> > > > programs return any "non-success" return codes and prohibit attaching
> > > > these progs to the void hooks?
> > > hmm...yeah, BPF_LSM_CGROUP can be enforced to return either 0 or 1 as
> > > most other cgroup-progs do.
> > >
> > > Do you have a use case that needs to return something other than -EPERM ?
> >
> > We do already enforce 0/1 for cgroup progs (and we have helpers to
> > expose custom errno). What I want to avoid is letting users attach
> > programs that try to return the error for the void hooks. And it seems
> > like we record that return range for a particular cgroup program and
> > verify it at attach time, WDYT?
> Make sense.  Do that in check_return_code() at load time instead of
> attach time?
> To be specific, meaning enforce BPF_LSM_CGROUP to 0/1 for int return type
> and always 1 for void return type?

Yeah, let's try to enforce the following at load time:
- return 0 or call to bpf_set_retval should happen only for the hooks
that return int
- for the void ones, only 'return 1' should be accepted

> Ah, I forgot there is a bpf_set_retval().  I assume we eventually want
> to allow that for BPF_LSM_CGROUP later?  Once it is allowed,
> the verifier should also reject bpf_set_retval() when the
> attach_btf_id has a void return type?

Right, let me actually try to add bpf_set_retval to the set of allowed
helpers from the start, shouldn't be hard..
