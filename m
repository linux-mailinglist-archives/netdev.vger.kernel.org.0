Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1536C40C9B1
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 18:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbhIOQFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 12:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhIOQFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 12:05:52 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5584FC061574;
        Wed, 15 Sep 2021 09:04:33 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id s16so6874545ybe.0;
        Wed, 15 Sep 2021 09:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a7KJPRjegr1Mk4SkxcSDTXpkviD5Dd9JHixf2CKgigA=;
        b=mteEe17TA8bV7msOSGZlj1C4bkteYPBUJ4ef7OvAsDniLxuA6npsTGEi/92LE7PIVQ
         kTx3rf/Uy62UTuudzjX5J3RH0WDAQVs8wJtUXn8mNS2s9shK6FCXzpJPFS6GBbAX6+Ia
         To3ttowLFtUEsklgJzu+/gggdwtNDF1XqM69sKdJkwkhX1tkZMXBK/IJoT+yJYphrRcZ
         8VlOvf/wfZr7oGaO07l6lzY15uMsWm6DsPUB03mtgnuS7HLIqBn0EzqC3ZTDnrBBtJzc
         6u0gltVQh7zfGUJqwUNTpObJVh55kZsctCpc3CedvPTfHefjmIgpTcgIExYn846Dov7q
         JQeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a7KJPRjegr1Mk4SkxcSDTXpkviD5Dd9JHixf2CKgigA=;
        b=lpmEERYmURh/2qaTktiLM9dFExFPY0i90kdnhSKMUx7Zh69nXHpmQiNSER1oaCSiJr
         7kZ7klYt8eZA24KTLnkX7UP4IlhPF8wwaOdAxrgmFbiu3tBPlr/B9YNQ5UmnW64UCE9x
         AoH8WhjzduFJZcTXoFFnMVkgxeMYAt9/bgPeEe7ntnStiuOs3ZYIZtDSB+RyWcudbjFQ
         PMjv+CsFJXPDE3EKVG2cwqhxr43+hYZ4D0BDwE/oI+6f1lyU3/Eq41IqbNJr2DzHfVuU
         SL33MTyXNP8JLcmh3mJdA/TXx5Iq+MMIne2geuxqJivekp7DNDj9Rm0ADAyNBLuDNwo0
         Q4FQ==
X-Gm-Message-State: AOAM5301QW4iX4ItwDEXEtyVJr2t0CDnJ6GfClboFvJ/5HqPRSungSUZ
        h7WbeR+pLb2th88tkQob53LW4hGkRH4PHNl9v3k=
X-Google-Smtp-Source: ABdhPJy5nsnKs1aUYx9LECcm/C12Eu1CWNbv5Cpv1NRZMmxSkNBphBs2iNb4NghXdVSYXFbdmOTfDRR/GmHc2yLzgk4=
X-Received: by 2002:a25:9881:: with SMTP id l1mr858881ybo.455.1631721872604;
 Wed, 15 Sep 2021 09:04:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210915050943.679062-1-memxor@gmail.com>
In-Reply-To: <20210915050943.679062-1-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 15 Sep 2021 09:04:21 -0700
Message-ID: <CAEf4BzYwredoHa6Wv3AEMCfnqOXKcxk2yW3bSu3t6s_TmRmE5Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 00/10] Support kernel module function calls
 from eBPF
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 10:09 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This set enables kernel module function calls, and also modifies verifier logic
> to permit invalid kernel function calls as long as they are pruned as part of
> dead code elimination. This is done to provide better runtime portability for
> BPF objects, which can conditionally disable parts of code that are pruned later
> by the verifier (e.g. const volatile vars, kconfig options). libbpf
> modifications are made along with kernel changes to support module function
> calls. The set includes gen_loader support for emitting kfunc relocations.
>
> It also converts TCP congestion control objects to use the module kfunc support
> instead of relying on IS_BUILTIN ifdef.
>
> Changelog:
> ----------
> v2 -> v3:
> v2: https://lore.kernel.org/bpf/20210914123750.460750-1-memxor@gmail.com
>
>  * Fix issues pointed out by Kernel Test Robot
>  * Fix find_kfunc_desc to also take offset into consideration when comparing

See [0]:


  [  444.075332] mod kfunc i=42
  [  444.075383] mod kfunc i=42
  [  444.075522] mod kfunc i=42
  [  444.075578] mod kfunc i=42
  [  444.075631] mod kfunc i=42
  [  444.075683] mod kfunc i=42
  [  444.075735] mod kfunc i=42
  [  444.0
This step has been truncated due to its large size. Download the full
logs from the
menu once the workflow run has completed.

  [0] https://github.com/kernel-patches/bpf/runs/3606513281?check_suite_focus=true

>
> RFC v1 -> v2
> v1: https://lore.kernel.org/bpf/20210830173424.1385796-1-memxor@gmail.com
>
>  * Address comments from Alexei
>    * Reuse fd_array instead of introducing kfunc_btf_fds array
>    * Take btf and module reference as needed, instead of preloading
>    * Add BTF_KIND_FUNC relocation support to gen_loader infrastructure
>  * Address comments from Andrii
>    * Drop hashmap in libbpf for finding index of existing BTF in fd_array
>    * Preserve invalid kfunc calls only when the symbol is weak
>  * Adjust verifier selftests
>
> Kumar Kartikeya Dwivedi (10):
>   bpf: Introduce BPF support for kernel module function calls
>   bpf: Be conservative while processing invalid kfunc calls
>   bpf: btf: Introduce helpers for dynamic BTF set registration
>   tools: Allow specifying base BTF file in resolve_btfids
>   bpf: Enable TCP congestion control kfunc from modules
>   bpf: Bump MAX_BPF_STACK size to 768 bytes
>   libbpf: Support kernel module function calls
>   libbpf: Resolve invalid weak kfunc calls with imm = 0, off = 0
>   libbpf: Update gen_loader to emit BTF_KIND_FUNC relocations
>   bpf, selftests: Add basic test for module kfunc call
>
>  include/linux/bpf.h                           |   8 +-
>  include/linux/bpf_verifier.h                  |   2 +
>  include/linux/bpfptr.h                        |   1 +
>  include/linux/btf.h                           |  38 +++
>  include/linux/filter.h                        |   4 +-
>  kernel/bpf/btf.c                              |  56 +++++
>  kernel/bpf/core.c                             |   4 +
>  kernel/bpf/verifier.c                         | 217 +++++++++++++++---
>  kernel/trace/bpf_trace.c                      |   1 +
>  net/bpf/test_run.c                            |   2 +-
>  net/ipv4/bpf_tcp_ca.c                         |  36 +--
>  net/ipv4/tcp_bbr.c                            |  28 ++-
>  net/ipv4/tcp_cubic.c                          |  26 ++-
>  net/ipv4/tcp_dctcp.c                          |  26 ++-
>  scripts/Makefile.modfinal                     |   1 +
>  tools/bpf/resolve_btfids/main.c               |  19 +-
>  tools/lib/bpf/bpf.c                           |   1 +
>  tools/lib/bpf/bpf_gen_internal.h              |  12 +-
>  tools/lib/bpf/gen_loader.c                    |  93 +++++++-
>  tools/lib/bpf/libbpf.c                        |  81 +++++--
>  tools/lib/bpf/libbpf_internal.h               |   1 +
>  tools/testing/selftests/bpf/Makefile          |   1 +
>  .../selftests/bpf/bpf_testmod/bpf_testmod.c   |  23 +-
>  .../selftests/bpf/prog_tests/ksyms_module.c   |  13 +-
>  .../bpf/prog_tests/ksyms_module_libbpf.c      |  18 ++
>  .../selftests/bpf/progs/test_ksyms_module.c   |   9 +
>  .../bpf/progs/test_ksyms_module_libbpf.c      |  35 +++
>  tools/testing/selftests/bpf/verifier/calls.c  |  22 +-
>  .../selftests/bpf/verifier/raw_stack.c        |   4 +-
>  .../selftests/bpf/verifier/stack_ptr.c        |   6 +-
>  .../testing/selftests/bpf/verifier/var_off.c  |   4 +-
>  31 files changed, 673 insertions(+), 119 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_module_libbpf.c
>
> --
> 2.33.0
>
