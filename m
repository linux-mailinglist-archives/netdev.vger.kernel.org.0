Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3419520990
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 01:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiEIXrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 19:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235068AbiEIXrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 19:47:15 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312592CDEF3
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 16:38:46 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id q20so9202971wmq.1
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 16:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BiDu/cswbMs2ANToqI4HMQbrSKEuxwAekDMrvSFW/wU=;
        b=HPZCftN81HlFo2VUUHnUTiOGkvClHhws+4wBC0RhqHZbJGmAsq+ANp1LgpPuCS473b
         n9zGOtu+IzLirs5GII/IkvdobaJsgPLCkAGJK346e2nVP1DNzd1AsG2zfmPV58EIqCvw
         IdgH8z9n9uqv9Ziu6Up3r883uoFTu6djpcSQjQgSWpLkfwqJavNuNRCvKrK/RCl4TkOr
         VY2uBvSORsW8pwa7qCacW4PjSuigDAC3BYj3UeGJDYX/fZur8jSw2vlu1FPyOq+H/nfi
         o1fq2RX9pba/bCnf5RpRgWPly/tmsT+AgGpxPJ7fO5EdnSZKgp2cfLflLMNhjIKiPuvP
         XNvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BiDu/cswbMs2ANToqI4HMQbrSKEuxwAekDMrvSFW/wU=;
        b=ZSAgcLFnE04Wl7a2ICtzoac0lhSGgZMuSvBllUEMpZdEMaK1t3QmjxzvZVLTMAMgGu
         KqnvvQQQovSEbqN0gSyCvtbx0bCKCHnxpu/ahGgxSXGT0WsLx1U3Ic+I2+DBWmIXPJFd
         PDpTNVentALqDO8CXVdXqqEKQ4tJvWXvCdiBnpGT3q9nJdPoec7ZYW/IbAkJzWoBqXWg
         RHb80C2uWTLwZpZUUBJ6LckUwog+lWEfsqxdUI61iPRfxRuKUGWGU38JrkMWWj/aBIQB
         zk36txSJGNLIDJjxwf88chPZtB57cK5M5B2IphhcHrFZ9ESCCQgwkgWjWx1kwIrcMFEJ
         7GZw==
X-Gm-Message-State: AOAM5332WkHUc5jN4uryBbhXs91NffJtI6r+1Bo/NZqxaj1ThrzjfVw5
        bvQeuy7x1BIAacKQib/Ec0cVR9JTgQKyS9q3af529HXvXZw=
X-Google-Smtp-Source: ABdhPJyDkzBMRxHN2Lb7kIARmFzaf/7CL+zLf3Q7+Lc9THuJ0TD3qAU1nDju/CcijufxD1c8fTr17wQQdAfNo36TAbo=
X-Received: by 2002:a05:600c:4885:b0:393:fac6:f409 with SMTP id
 j5-20020a05600c488500b00393fac6f409mr25282011wmp.150.1652139525611; Mon, 09
 May 2022 16:38:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220429211540.715151-1-sdf@google.com> <20220429211540.715151-4-sdf@google.com>
 <CAEf4BzZ_c62i9_QX+6PFBZynAKkEH-2VX-7y_hYQhrP0Ks-ftQ@mail.gmail.com>
In-Reply-To: <CAEf4BzZ_c62i9_QX+6PFBZynAKkEH-2VX-7y_hYQhrP0Ks-ftQ@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 9 May 2022 16:38:34 -0700
Message-ID: <CAKH8qBtn1+KpeE7VFYv4=5iB+NGvqb91yXFpOhyUmrAgmPqXOQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 03/10] bpf: per-cgroup lsm flavor
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
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

On Mon, May 9, 2022 at 2:51 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Apr 29, 2022 at 2:15 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > Allow attaching to lsm hooks in the cgroup context.
> >
> > Attaching to per-cgroup LSM works exactly like attaching
> > to other per-cgroup hooks. New BPF_LSM_CGROUP is added
> > to trigger new mode; the actual lsm hook we attach to is
> > signaled via existing attach_btf_id.
> >
> > For the hooks that have 'struct socket' or 'struct sock' as its first
> > argument, we use the cgroup associated with that socket. For the rest,
> > we use 'current' cgroup (this is all on default hierarchy == v2 only).
> > Note that for some hooks that work on 'struct sock' we still
> > take the cgroup from 'current' because some of them work on the socket
> > that hasn't been properly initialized yet.
> >
> > Behind the scenes, we allocate a shim program that is attached
> > to the trampoline and runs cgroup effective BPF programs array.
> > This shim has some rudimentary ref counting and can be shared
> > between several programs attaching to the same per-cgroup lsm hook.
> >
> > Note that this patch bloats cgroup size because we add 211
> > cgroup_bpf_attach_type(s) for simplicity sake. This will be
> > addressed in the subsequent patch.
> >
> > Also note that we only add non-sleepable flavor for now. To enable
> > sleepable use-cases, bpf_prog_run_array_cg has to grab trace rcu,
> > shim programs have to be freed via trace rcu, cgroup_bpf.effective
> > should be also trace-rcu-managed + maybe some other changes that
> > I'm not aware of.
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  arch/x86/net/bpf_jit_comp.c     |  22 ++--
> >  include/linux/bpf-cgroup-defs.h |   6 ++
> >  include/linux/bpf-cgroup.h      |   7 ++
> >  include/linux/bpf.h             |  15 +++
> >  include/linux/bpf_lsm.h         |  14 +++
> >  include/uapi/linux/bpf.h        |   1 +
> >  kernel/bpf/bpf_lsm.c            |  64 ++++++++++++
> >  kernel/bpf/btf.c                |  11 ++
> >  kernel/bpf/cgroup.c             | 179 +++++++++++++++++++++++++++++---
> >  kernel/bpf/syscall.c            |  10 ++
> >  kernel/bpf/trampoline.c         | 161 ++++++++++++++++++++++++++++
> >  kernel/bpf/verifier.c           |  32 ++++++
> >  tools/include/uapi/linux/bpf.h  |   1 +
> >  13 files changed, 503 insertions(+), 20 deletions(-)
> >
>
> [...]
>
> > @@ -3474,6 +3476,11 @@ static int bpf_prog_attach(const union bpf_attr *attr)
> >         case BPF_PROG_TYPE_CGROUP_SOCKOPT:
> >         case BPF_PROG_TYPE_CGROUP_SYSCTL:
> >         case BPF_PROG_TYPE_SOCK_OPS:
> > +       case BPF_PROG_TYPE_LSM:
> > +               if (ptype == BPF_PROG_TYPE_LSM &&
> > +                   prog->expected_attach_type != BPF_LSM_CGROUP)
> > +                       return -EINVAL;
> > +
>
> Is it a hard requirement to support non-bpf_link attach for these BPF
> trampoline-backed programs? Can we keep it bpf_link-only and use
> LINK_CREATE for attachment? That way we won't need to extend query
> command and instead add new field to bpf_link_info?

I didn't think it was an option :-) So if non-link-based apis are
deprecated, I'll drop them from the patch series.
