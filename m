Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD75952E0A0
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 01:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343647AbiESXkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 19:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236252AbiESXkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 19:40:10 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E1D108A9E
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 16:40:08 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id r30so9282344wra.13
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 16:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e5mq4XhWsIxaG7OHtvD00PdpZiV8lIvRbszDExqkVEM=;
        b=U+y9PgXhnPRZ3gAuQHcPmpMICUZtCUL1pb0vIgYnkfp3N/Pwq/ZcUvWpSo7/NB5Y3j
         /F7+oWBF+hNTs1CN4Tx6kJ3pkkcEnJhV2HUaSPYzf/YFVj/u0VP5aXW79ptf14UXntHd
         UmOoS5bK9gSqWz0s+XxRc5Cbes0XdqIrH49LKnOjmczBCox/g/bK9WA/jHCxDCCFXHhF
         KW7gsUw98jLnGPKRA/Ur2MVYTr82P5J56UQ7tjG6N37tB6YEnE3wUUdBs//MEcP5+B1w
         15A08fLqJPCaK9phNLO+XKWzbY6yxALouJthkZsQle65XUgGor2Wa++UWRtUtTIjMNHA
         GbDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e5mq4XhWsIxaG7OHtvD00PdpZiV8lIvRbszDExqkVEM=;
        b=X84Qew2Rgoa44sRkWqzh7bsijizz2R0jL+JAErlcIbjk1v5NNMb091jsYGD/JAoL9o
         nvEVeuAwbgv571TMEpAIk0Eyl6Xl5Rt4YRaP1SwF5+TBb27XyC/19IsygbmhkCRfqkKo
         IbYZnBpG2Sc/tPPop2E7CnUXy16+/j3AS0PNZMzZqrNbT24GCgQRuHHIrVfujHm+kc9S
         Oq1sQfcwIZa3vcDESV8zpV11gdh/dVFsgbX5Zwe+mxZDk2K9sYc/Xnw/056/meGqa7bL
         o0zE201dsP7TzA/GFXgJLWgOodIAPyDetwrkxToGkMm7bd6Lsa7qU4r9+zw6ouuWPyPQ
         WuQg==
X-Gm-Message-State: AOAM531tZ/sBA+90olW1MiIHtohbUGwD9h9OgIgPpK/FopkwZ595oDJs
        D3UD7vJc2EKjenx4ZVTcyXexs387SPTz9KlRaFYjMQ==
X-Google-Smtp-Source: ABdhPJyDg0T1PACyWSIPcVz/BCGBIPfYawPjTX1uURMgCdq/TYdLlfaq5vE54jLk9PKvEtcHNiBq6gKl2ceyD6P8th0=
X-Received: by 2002:adf:f803:0:b0:20d:3a1:3c31 with SMTP id
 s3-20020adff803000000b0020d03a13c31mr6017075wrp.565.1653003607207; Thu, 19
 May 2022 16:40:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220518225531.558008-1-sdf@google.com> <3a732a8d-6e4f-0154-e317-795baa64022d@fb.com>
In-Reply-To: <3a732a8d-6e4f-0154-e317-795baa64022d@fb.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 19 May 2022 16:39:55 -0700
Message-ID: <CAKH8qBsaae3YGvJ34BpE=PmxeXyP_Gs31Q7ScGQT1uqpqBd4zg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 00/11] bpf: cgroup_sock lsm flavor
To:     Yonghong Song <yhs@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        kpsingh@kernel.org, jakub@cloudflare.com
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

On Thu, May 19, 2022 at 4:34 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 5/18/22 3:55 PM, Stanislav Fomichev wrote:
> > This series implements new lsm flavor for attaching per-cgroup programs to
> > existing lsm hooks. The cgroup is taken out of 'current', unless
> > the first argument of the hook is 'struct socket'. In this case,
> > the cgroup association is taken out of socket. The attachment
> > looks like a regular per-cgroup attachment: we add new BPF_LSM_CGROUP
> > attach type which, together with attach_btf_id, signals per-cgroup lsm.
> > Behind the scenes, we allocate trampoline shim program and
> > attach to lsm. This program looks up cgroup from current/socket
> > and runs cgroup's effective prog array. The rest of the per-cgroup BPF
> > stays the same: hierarchy, local storage, retval conventions
> > (return 1 == success).
> >
> > Current limitations:
> > * haven't considered sleepable bpf; can be extended later on
> > * not sure the verifier does the right thing with null checks;
> >    see latest selftest for details
> > * total of 10 (global) per-cgroup LSM attach points
> >
> > Cc: ast@kernel.org
> > Cc: daniel@iogearbox.net
> > Cc: kafai@fb.com
> > Cc: kpsingh@kernel.org
> > Cc: jakub@cloudflare.com
> >
> > v7:
> > - there were a lot of comments last time, hope I didn't forget anything,
> >    some of the bigger ones:
> >    - Martin: use/extend BTF_SOCK_TYPE_SOCKET
> >    - Martin: expose bpf_set_retval
> >    - Martin: reject 'return 0' at the verifier for 'void' hooks
> >    - Martin: prog_query returns all BPF_LSM_CGROUP, prog_info
> >      returns attach_btf_func_id
> >    - Andrii: split libbpf changes
> >    - Andrii: add field access test to test_progs, not test_verifier (still
> >      using asm though)
> > - things that I haven't addressed, stating them here explicitly, let
> >    me know if some of these are still problematic:
> >    1. Andrii: exposing only link-based api: seems like the changes
> >       to support non-link-based ones are minimal, couple of lines,
> >       so seems like it worth having it?
> >    2. Alexei: applying cgroup_atype for all cgroup hooks, not only
> >       cgroup lsm: looks a bit harder to apply everywhere that I
> >       originally thought; with lsm cgroup, we have a shim_prog pointer where
> >       we store cgroup_atype; for non-lsm programs, we don't have a
> >       trace program where to store it, so we still need some kind
> >       of global table to map from "static" hook to "dynamic" slot.
> >       So I'm dropping this "can be easily extended" clause from the
> >       description for now. I have converted this whole machinery
> >       to an RCU-managed list to remove synchronize_rcu().
> > - also note that I had to introduce new bpf_shim_tramp_link and
> >    moved refcnt there; we need something to manage new bpf_tramp_link
> >
> > v6:
> > - remove active count & stats for shim program (Martin KaFai Lau)
> > - remove NULL/error check for btf_vmlinux (Martin)
> > - don't check cgroup_atype in bpf_cgroup_lsm_shim_release (Martin)
> > - use old_prog (instead of passed one) in __cgroup_bpf_detach (Martin)
> > - make sure attach_btf_id is the same in __cgroup_bpf_replace (Martin)
> > - enable cgroup local storage and test it (Martin)
> > - properly implement prog query and add bpftool & tests (Martin)
> > - prohibit non-shared cgroup storage mode for BPF_LSM_CGROUP (Martin)
> >
> > v5:
> > - __cgroup_bpf_run_lsm_socket remove NULL sock/sk checks (Martin KaFai Lau)
> > - __cgroup_bpf_run_lsm_{socket,current} s/prog/shim_prog/ (Martin)
> > - make sure bpf_lsm_find_cgroup_shim works for hooks without args (Martin)
> > - __cgroup_bpf_attach make sure attach_btf_id is the same when replacing (Martin)
> > - call bpf_cgroup_lsm_shim_release only for LSM_CGROUP (Martin)
> > - drop BPF_LSM_CGROUP from bpf_attach_type_to_tramp (Martin)
> > - drop jited check from cgroup_shim_find (Martin)
> > - new patch to convert cgroup_bpf to hlist_node (Jakub Sitnicki)
> > - new shim flavor for 'struct sock' + list of exceptions (Martin)
> >
> > v4:
> > - fix build when jit is on but syscall is off
> >
> > v3:
> > - add BPF_LSM_CGROUP to bpftool
> > - use simple int instead of refcnt_t (to avoid use-after-free
> >    false positive)
> >
> > v2:
> > - addressed build bot failures
> >
> > Stanislav Fomichev (11):
> >    bpf: add bpf_func_t and trampoline helpers
> >    bpf: convert cgroup_bpf.progs to hlist
> >    bpf: per-cgroup lsm flavor
> >    bpf: minimize number of allocated lsm slots per program
> >    bpf: implement BPF_PROG_QUERY for BPF_LSM_CGROUP
> >    bpf: allow writing to a subset of sock fields from lsm progtype
> >    libbpf: implement bpf_prog_query_opts
> >    libbpf: add lsm_cgoup_sock type
> >    bpftool: implement cgroup tree for BPF_LSM_CGROUP
> >    selftests/bpf: lsm_cgroup functional test
> >    selftests/bpf: verify lsm_cgroup struct sock access
> >
> >   arch/x86/net/bpf_jit_comp.c                   |  24 +-
> >   include/linux/bpf-cgroup-defs.h               |  11 +-
> >   include/linux/bpf-cgroup.h                    |   9 +-
> >   include/linux/bpf.h                           |  36 +-
> >   include/linux/bpf_lsm.h                       |   8 +
> >   include/linux/btf_ids.h                       |   3 +-
> >   include/uapi/linux/bpf.h                      |   6 +
> >   kernel/bpf/bpf_lsm.c                          | 103 ++++
> >   kernel/bpf/btf.c                              |  11 +
> >   kernel/bpf/cgroup.c                           | 487 +++++++++++++++---
> >   kernel/bpf/core.c                             |   2 +
> >   kernel/bpf/syscall.c                          |  14 +-
> >   kernel/bpf/trampoline.c                       | 244 ++++++++-
> >   kernel/bpf/verifier.c                         |  31 +-
> >   tools/bpf/bpftool/cgroup.c                    |  77 ++-
> >   tools/bpf/bpftool/common.c                    |   1 +
> >   tools/include/linux/btf_ids.h                 |   4 +-
> >   tools/include/uapi/linux/bpf.h                |   6 +
> >   tools/lib/bpf/bpf.c                           |  42 +-
> >   tools/lib/bpf/bpf.h                           |  15 +
> >   tools/lib/bpf/libbpf.c                        |   2 +
> >   tools/lib/bpf/libbpf.map                      |   1 +
> >   .../selftests/bpf/prog_tests/lsm_cgroup.c     | 346 +++++++++++++
> >   .../testing/selftests/bpf/progs/lsm_cgroup.c  | 160 ++++++
> >   24 files changed, 1480 insertions(+), 163 deletions(-)
> >   create mode 100644 tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
> >   create mode 100644 tools/testing/selftests/bpf/progs/lsm_cgroup.c
>
> There are 4 test failures for test_progs in CI.
>
> https://github.com/kernel-patches/bpf/runs/6511113546?check_suite_focus=true
> All have error messages like:
>      At program exit the register R0 has value (0xffffffff; 0x0) should
> have been in (0x0; 0x1)
>
> Could you take a look?

Ugh, definitely, thanks for the pointer!
