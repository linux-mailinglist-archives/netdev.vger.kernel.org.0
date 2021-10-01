Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6DA41F752
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 00:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355395AbhJAWPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 18:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbhJAWPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 18:15:01 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10365C061775;
        Fri,  1 Oct 2021 15:13:17 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id d131so6239019ybd.5;
        Fri, 01 Oct 2021 15:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a92huAptXPQweEzjtK16RveRcK0JZxmlbQ8ugilsEtk=;
        b=IOQRcu0rbN9H/Ani3wm82Ujnjmv3g/zSSFb7qEsWHR1c8EMSdglKUtNR2WPx8SmXhf
         RaDrGz2MDxCDp3nXDsYW9alvhkK1xBdRh8wqkq7nxiNcDirTqjaEB021PK2ogNVdOFbg
         se0MBbuWmTtjec2qJl+9F0DvSNJQyzCI1vjtIa2PitIGCECtbAQQveYGNQb7dShgT9N3
         /b030AIGrKMaJVeUQcI7i4vC/m1OitFki/1+CbeHTOSNj7tTn6V9nVMuOP0FyRQygj8+
         WXVkgLB06i1/Oxt9yYB6HdnnJtdDZ4IdRi2T1VBQ3NPj6aw9OQVbsHFHarDP5/hGTXYF
         iCfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a92huAptXPQweEzjtK16RveRcK0JZxmlbQ8ugilsEtk=;
        b=NZsmccdHYPfSLsUFWG1ZQdOdZJidhr32ecdbHbAscfWtbv+eqywQRON3pTi1LvgXGl
         Cfr4l4WlHkVLbynH+Otq2Y204I9fEZ2HA79GSUjt5PyxDW4Byj/8O2pFomwFwE58NWo1
         5ufFty3h22Y2psI4+YSg/n21q/iL6AMen61FqytuPGYk388uY3VRz19WiOhYHOOcFg52
         BHu4zxfukPnVOYeic95ySb16ynK8IZ4eJS/cxMGzNyfEdHQEADm04n15ZKr/V+FBekh3
         ijPjTWj5bjyVmgupKN+3dVCw/Jg9krPBMjd+JYwqZyccMzEyQvfnN+FeUhBGimV3OyOT
         oTpA==
X-Gm-Message-State: AOAM530ScW38Nw92IohzLWSsCsSZRkBHaqHQgSsi+QzlSEZGZl6SjNAB
        z2scaVsU4RUB4i36vuuwcysfHL+wjQY8KgY4wCI=
X-Google-Smtp-Source: ABdhPJx3P6kxgCYThY4dUqvvJNmGGj9ACz8Xm/t3mE6wtZIfu9I/qyFnJXsn+kdzJZhsAjLgmxEltQQFLd5U4zNt3tM=
X-Received: by 2002:a25:afcf:: with SMTP id d15mr259566ybj.433.1633126396215;
 Fri, 01 Oct 2021 15:13:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210930062948.1843919-1-memxor@gmail.com> <20210930062948.1843919-10-memxor@gmail.com>
In-Reply-To: <20210930062948.1843919-10-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 1 Oct 2021 15:13:05 -0700
Message-ID: <CAEf4BzYXFU+o-AKj_JP3_2VzAYHRtkyzO5Wu0BD7W=n9UHxe6w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 9/9] bpf: selftests: Add selftests for module
 kfunc support
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

On Wed, Sep 29, 2021 at 11:30 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This adds selftests that tests the success and failure path for modules
> kfuncs (in presence of invalid kfunc calls) for both libbpf and
> gen_loader. It also adds a prog_test kfunc_btf_id_list so that we can
> add module BTF ID set from bpf_testmod.
>
> This also introduces  a couple of test cases to verifier selftests for
> validating whether we get an error or not depending on if invalid kfunc
> call remains after elimination of unreachable instructions.
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  include/linux/btf.h                           |  2 +
>  kernel/bpf/btf.c                              |  2 +
>  net/bpf/test_run.c                            |  5 +-
>  tools/testing/selftests/bpf/Makefile          |  8 ++--
>  .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 23 +++++++++-
>  .../selftests/bpf/prog_tests/ksyms_module.c   | 29 ++++++------
>  .../bpf/prog_tests/ksyms_module_libbpf.c      | 28 +++++++++++
>  .../selftests/bpf/progs/test_ksyms_module.c   | 46 ++++++++++++++-----
>  tools/testing/selftests/bpf/verifier/calls.c  | 23 ++++++++++
>  9 files changed, 135 insertions(+), 31 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c
>

[...]

> @@ -243,7 +244,9 @@ BTF_SET_END(test_sk_kfunc_ids)
>
>  bool bpf_prog_test_check_kfunc_call(u32 kfunc_id, struct module *owner)
>  {
> -       return btf_id_set_contains(&test_sk_kfunc_ids, kfunc_id);
> +       if (btf_id_set_contains(&test_sk_kfunc_ids, kfunc_id))
> +               return true;
> +       return __bpf_prog_test_check_kfunc_call(kfunc_id, owner);
>  }
>
>  static void *bpf_test_init(const union bpf_attr *kattr, u32 size,
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index e1ce73be7a5b..df461699932d 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -174,6 +174,7 @@ $(OUTPUT)/bpf_testmod.ko: $(VMLINUX_BTF) $(wildcard bpf_testmod/Makefile bpf_tes
>         $(Q)$(RM) bpf_testmod/bpf_testmod.ko # force re-compilation
>         $(Q)$(MAKE) $(submake_extras) -C bpf_testmod
>         $(Q)cp bpf_testmod/bpf_testmod.ko $@
> +       $(Q)$(RESOLVE_BTFIDS) -b $(VMLINUX_BTF) bpf_testmod.ko

This should be done by kernel Makefiles, which are used to build
bpf_testmod.ko. If this is not happening, something is wrong and let's
try to figure out what.

>
>  $(OUTPUT)/test_stub.o: test_stub.c $(BPFOBJ)
>         $(call msg,CC,,$@)
> @@ -315,8 +316,9 @@ LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h               \
>                 linked_vars.skel.h linked_maps.skel.h
>
>  LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
> -       test_ksyms_module.c test_ringbuf.c atomics.c trace_printk.c \
> -       trace_vprintk.c
> +       test_ringbuf.c atomics.c trace_printk.c trace_vprintk.c
> +# Generate both light skeleton and libbpf skeleton for these
> +LSKELS_EXTRA := test_ksyms_module.c
>  SKEL_BLACKLIST += $$(LSKELS)
>

[...]

> +#define X_0(x)
> +#define X_1(x) x X_0(x)
> +#define X_2(x) x X_1(x)
> +#define X_3(x) x X_2(x)
> +#define X_4(x) x X_3(x)
> +#define X_5(x) x X_4(x)
> +#define X_6(x) x X_5(x)
> +#define X_7(x) x X_6(x)
> +#define X_8(x) x X_7(x)
> +#define X_9(x) x X_8(x)
> +#define X_10(x) x X_9(x)
> +#define REPEAT_256(Y) X_2(X_10(X_10(Y))) X_5(X_10(Y)) X_6(Y)

this is impressive, I can even sort of read it :)

> +
>  extern const int bpf_testmod_ksym_percpu __ksym;
> +extern void bpf_testmod_test_mod_kfunc(int i) __ksym;
> +extern void bpf_testmod_invalid_mod_kfunc(void) __ksym __weak;
>
> -int out_mod_ksym_global = 0;
> -bool triggered = false;
> +int out_bpf_testmod_ksym = 0;
> +const volatile int x = 0;
>
> -SEC("raw_tp/sys_enter")
> -int handler(const void *ctx)
> +SEC("tc")

Did you switch to tc because kfuncs are not allowed from raw_tp
programs? Or is there some other reason?

> +int load(struct __sk_buff *skb)
>  {
> -       int *val;
> -       __u32 cpu;
> -
> -       val = (int *)bpf_this_cpu_ptr(&bpf_testmod_ksym_percpu);
> -       out_mod_ksym_global = *val;
> -       triggered = true;
> +       /* This will be kept by clang, but removed by verifier. Since it is
> +        * marked as __weak, libbpf and gen_loader don't error out if BTF ID
> +        * is not found for it, instead imm and off is set to 0 for it.
> +        */
> +       if (x)
> +               bpf_testmod_invalid_mod_kfunc();
> +       bpf_testmod_test_mod_kfunc(42);
> +       out_bpf_testmod_ksym = *(int *)bpf_this_cpu_ptr(&bpf_testmod_ksym_percpu);
> +       return 0;
> +}
>

[...]
