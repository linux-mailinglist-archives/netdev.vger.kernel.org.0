Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54EA26A24E7
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 00:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjBXXLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 18:11:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBXXLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 18:11:07 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C2216889;
        Fri, 24 Feb 2023 15:11:05 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id cy6so3430194edb.5;
        Fri, 24 Feb 2023 15:11:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rdSYf7vui7oNgAtgTIe/bH5myA/geCI8DNybHAD28ws=;
        b=LPnCDyJcgc7y5aXLEBIu7FW0Tu8FarOmGoH5gkLp6z/pYw6eNc+jG0XHpOjc4WQCdi
         i1yFP/CGMCUAR3zjgWdga9S46YdvGp5W0Ef+Z4/VlIOnZfIsW8dRNREnT+JOA5c5qNHo
         0bSyD8/wjh2YjyKAS+SX+z4F8PbTrogErpmu7M6aYeDBdEFpIj34Hagld14TMBokTbKg
         F+yL8oW+WeBgGn1cPpDp5taEdExONZ+9ZSkKBusWS9Up+imeY5aglA+j3KlQ30s8Qlf8
         A6nhktw8x7Jb49E8nqs0q0hsqlVP5hm5EQU1r+yk32lLqupIDe8CMrBFnZ2dSHQgZ348
         If7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rdSYf7vui7oNgAtgTIe/bH5myA/geCI8DNybHAD28ws=;
        b=0aOIl6Q+Gwe+Q+q+GK1OuxxZ4lqmn97LgQc/qdORHTWcxCIv6PKXtDM0S/Kb2b7FVT
         xdvAJzvniKLOqsEMyFfts33sI1pUuZ2vvFuHk6zV6egD9Vhf0ON4uaP1Cr2pSwSruxi4
         pLx2nmBlP28amwBK3KFajlDIf420/UnkKmoI4vOtdhihjHSu5UzAPvymI+EBHCrrgPV2
         bJ8w+h+uTMnCEEOL85WEMP+cko8oVdZUZnV9CJseGxb6WS0lROIbbipqbG9wW3eOyO07
         B7+gXq/Yhb9xoKsRG22yzRR8TzIJM1kxDVqILz95F7EdS03APBCvXuIc+26YAANnQE48
         UmMA==
X-Gm-Message-State: AO0yUKVjOFht9nn3KK470vvl46gFXL05YZMwTESxvcKn26DYKHLYh0rn
        IAeHiT76l55CYCKWPAuxSS59tOpSn4JSz7UEiLRX/uHhoNU=
X-Google-Smtp-Source: AK7set964/yvcQ8dGgfx5gpzfup9A8Eu9cja8HUFBTdlQxn7wgKCigJpMWVa0w/aPet/l9t9SAcPWWdeIURD/Yzsgr8=
X-Received: by 2002:a17:906:d8d8:b0:8b1:2898:2138 with SMTP id
 re24-20020a170906d8d800b008b128982138mr11709333ejb.3.1677280264186; Fri, 24
 Feb 2023 15:11:04 -0800 (PST)
MIME-Version: 1.0
References: <20230223030717.58668-1-alexei.starovoitov@gmail.com>
 <20230223030717.58668-5-alexei.starovoitov@gmail.com> <Y/ffPMRzRANCZS+1@google.com>
In-Reply-To: <Y/ffPMRzRANCZS+1@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 24 Feb 2023 15:10:52 -0800
Message-ID: <CAADnVQ+MW9mkeYu3zxNvTi2DsFk18gq5CpgoRrWmJ1xf4u2fcw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 4/4] selftests/bpf: Tweak cgroup kfunc test.
To:     Stanislav Fomichev <sdf@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        David Vernet <void@manifault.com>,
        Dave Marchevsky <davemarchevsky@meta.com>,
        Tejun Heo <tj@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 23, 2023 at 1:48 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> On 02/22, Alexei Starovoitov wrote:
> > From: Alexei Starovoitov <ast@kernel.org>
>
> > Adjust cgroup kfunc test to dereference RCU protected cgroup pointer
> > as PTR_TRUSTED and pass into KF_TRUSTED_ARGS kfunc.
>
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> >   tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h  | 2 +-
> >   tools/testing/selftests/bpf/progs/cgrp_kfunc_failure.c | 2 +-
> >   tools/testing/selftests/bpf/progs/cgrp_kfunc_success.c | 7 ++++++-
> >   3 files changed, 8 insertions(+), 3 deletions(-)
>
> > diff --git a/tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h
> > b/tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h
> > index 50d8660ffa26..eb5bf3125816 100644
> > --- a/tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h
> > +++ b/tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h
> > @@ -10,7 +10,7 @@
> >   #include <bpf/bpf_tracing.h>
>
> >   struct __cgrps_kfunc_map_value {
> > -     struct cgroup __kptr * cgrp;
> > +     struct cgroup __kptr_rcu * cgrp;
> >   };
>
> >   struct hash_map {
> > diff --git a/tools/testing/selftests/bpf/progs/cgrp_kfunc_failure.c
> > b/tools/testing/selftests/bpf/progs/cgrp_kfunc_failure.c
> > index 4ad7fe24966d..d5a53b5e708f 100644
> > --- a/tools/testing/selftests/bpf/progs/cgrp_kfunc_failure.c
> > +++ b/tools/testing/selftests/bpf/progs/cgrp_kfunc_failure.c
> > @@ -205,7 +205,7 @@ int BPF_PROG(cgrp_kfunc_get_unreleased, struct cgroup
> > *cgrp, const char *path)
> >   }
>
> >   SEC("tp_btf/cgroup_mkdir")
> > -__failure __msg("arg#0 is untrusted_ptr_or_null_ expected ptr_ or
> > socket")
> > +__failure __msg("bpf_cgroup_release expects refcounted")
> >   int BPF_PROG(cgrp_kfunc_release_untrusted, struct cgroup *cgrp, const
> > char *path)
> >   {
> >       struct __cgrps_kfunc_map_value *v;
> > diff --git a/tools/testing/selftests/bpf/progs/cgrp_kfunc_success.c
> > b/tools/testing/selftests/bpf/progs/cgrp_kfunc_success.c
> > index 0c23ea32df9f..37ed73186fba 100644
> > --- a/tools/testing/selftests/bpf/progs/cgrp_kfunc_success.c
> > +++ b/tools/testing/selftests/bpf/progs/cgrp_kfunc_success.c
> > @@ -61,7 +61,7 @@ int BPF_PROG(test_cgrp_acquire_leave_in_map, struct
> > cgroup *cgrp, const char *pa
> >   SEC("tp_btf/cgroup_mkdir")
> >   int BPF_PROG(test_cgrp_xchg_release, struct cgroup *cgrp, const char
> > *path)
> >   {
> > -     struct cgroup *kptr;
> > +     struct cgroup *kptr, *cg;
> >       struct __cgrps_kfunc_map_value *v;
> >       long status;
>
> > @@ -80,6 +80,11 @@ int BPF_PROG(test_cgrp_xchg_release, struct cgroup
> > *cgrp, const char *path)
> >               return 0;
> >       }
>
>
> [..]
>
> > +     kptr = v->cgrp;
> > +     cg = bpf_cgroup_ancestor(kptr, 1);
> > +     if (cg)
> > +             bpf_cgroup_release(cg);
>
> I went through the series, it all makes sense, I'm assuming Kumar
> will have another look eventually? (since he did for v1).
>
> One question here, should we have something like the following?
>
> if (cg) {
>         bpf_cgroup_release(cg);
> } else {
>         err = 4;
>         return 0;
> }
>
> Or are we just making sure here that the verifier is not complaining
> about bpf_cgroup_ancestor(v->cgrp) and don't really care whether
> bpf_cgroup_ancestor returns something useful or not?

It's the verifier only check.
See other bpf_cgroup_ancestor() related tests in the same file.
They check the run-time component quite well.
No need to duplicate.
