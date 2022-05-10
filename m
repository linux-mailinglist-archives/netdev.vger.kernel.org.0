Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 234295222BA
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 19:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348238AbiEJRfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 13:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245083AbiEJRfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 13:35:09 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A017381B1
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 10:31:10 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 129so10626105wmz.0
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 10:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=86+dyCf/6HmXI3GRuClQFtu8rHXl41P9h7Bj3EV+OIc=;
        b=RWByi1P501aV7KbOFn57eohhgkVOTWcupOLSPpCv2PLkfT+Exy8cDrqR+W0acvYYHW
         8LDl4KU6pBa81msedpOIfIswWY6O0uRoEIqmm+xE6IxEUk0g8Ldiwz2I8e9QxR3OJ0nB
         uY6kiPQmE0tIHW1+ocgz4HbcFlUUhvBFu597/N0H7QO6QpiyME0q3oH6ql5yaCKKMqTY
         BuBJw7dQqhvW1c60bDh6ifQyxzVQCEQ2oul+yM9HevgfImNgNTL7/+inIcwyTBB/OOpv
         +F4KjN8jwnLbzNxcDJ/Z/EJ6x5a35s/HYGwBMVa1Wvp+x57ZuLB2RYiu6QZChWFtuIzf
         vjhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=86+dyCf/6HmXI3GRuClQFtu8rHXl41P9h7Bj3EV+OIc=;
        b=5TrpzJRaaVjAZyDFdFcHuHbMNdtS9z72zKKXWMjzCt+UNCpwz0xM9cmAdiAOyZhFfA
         UWiLCH9x7vlKFKbdgTtzZe6QUgV2cz/IjFCgVMWIZBzN22nLuFPsH1XFxqYmnZYxgixW
         AvoUSIzhQZBj7MZehyBwL3bobXzUy7lo0S8Z9vUHl/dtsc+n2K0ls+6yblZpToD579Iw
         DaYtyFVLjJ2TyKuafqMTlqvkEifyR0MBAwrkoQGnWPEbZ1J0hv/o/dODw+UiwynFpXeD
         G3PzTMZrV8L9tEVCBQBRHBech7P1RMCtUgxXcGbNRrSw80kF2oX0xYxdaiMl9rOZWP/R
         Cp9g==
X-Gm-Message-State: AOAM530F9TfSapzoR4LSbXLVksYUen77YTAwWXPqGptH2iT064Y4YTS6
        iCsKrd5mE+7EYefUjHkdq5E8FNJkC+y/GLh4pwkmwg==
X-Google-Smtp-Source: ABdhPJxOcZh+gy1GXzyP/EOqnV/zyefYeDjZ4eB7SwEShZLCHy2T0XWzpL7s9Ii2T/HzlQOD6WFTTej16eicLNKi2IA=
X-Received: by 2002:a05:600c:a42:b0:393:d831:bf05 with SMTP id
 c2-20020a05600c0a4200b00393d831bf05mr974751wmq.187.1652203868463; Tue, 10 May
 2022 10:31:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220429211540.715151-1-sdf@google.com> <20220429211540.715151-4-sdf@google.com>
 <20220506230244.4t4p5gnbgg6i4tht@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBsQnzHPtuAiCs67YvTh9m+CmVR+-9wVKJggKjZnV_oYtg@mail.gmail.com> <20220510071334.duvldvzob777dt47@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220510071334.duvldvzob777dt47@kafai-mbp.dhcp.thefacebook.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 10 May 2022 10:30:57 -0700
Message-ID: <CAKH8qBsR_kgQ3ETwm++AL7vZDcq1H-56eykqDdAcrveH5+ejzA@mail.gmail.com>
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

On Tue, May 10, 2022 at 12:13 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Mon, May 09, 2022 at 04:38:36PM -0700, Stanislav Fomichev wrote:
> > > > +unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
> > > > +                                       const struct bpf_insn *insn)
> > > > +{
> > > > +     const struct bpf_prog *shim_prog;
> > > > +     struct cgroup *cgrp;
> > > > +     int ret = 0;
> > > From lsm_hook_defs.h, there are some default return values that are not 0.
> > > Is it ok to always return 0 in cases like the cgroup array is empty ?
> >
> > That's a good point, I haven't thought about it. You're right, it
> > seems like attaching to this hook for some LSMs will change the
> > default from some error to zero.
> > Let's start by prohibiting those hooks for now? I guess in theory,
> > when we generate a trampoline, we can put this default value as an
> > input arg to these new __cgroup_bpf_run_lsm_xxx helpers (in the
> > future)?
> After looking at arch_prepare_bpf_trampoline, return 0 here should be fine.
> If I read it correctly, when the shim_prog returns 0, the trampoline
> will call the original kernel function which is the bpf_lsm_##NAME()
> defined in bpf_lsm.c and it will then return the zero/-ve DEFAULT.

Not sure I read the same :-/ I'm assuming that for those cases we
actually end up generating fmod_ret trampoline which seems to be
unconditionally saving r0 into fp-8 ?

> > Another thing that seems to be related: there are a bunch of hooks
> > that return void, so returning EPERM from the cgroup programs won't
> > work as expected.
> > I can probably record, at verification time, whether lsm_cgroup
> > programs return any "non-success" return codes and prohibit attaching
> > these progs to the void hooks?
> hmm...yeah, BPF_LSM_CGROUP can be enforced to return either 0 or 1 as
> most other cgroup-progs do.
>
> Do you have a use case that needs to return something other than -EPERM ?

We do already enforce 0/1 for cgroup progs (and we have helpers to
expose custom errno). What I want to avoid is letting users attach
programs that try to return the error for the void hooks. And it seems
like we record that return range for a particular cgroup program and
verify it at attach time, WDYT?
