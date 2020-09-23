Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694AA276128
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 21:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgIWTgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 15:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgIWTgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 15:36:25 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D8ADC0613CE;
        Wed, 23 Sep 2020 12:36:25 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id k2so577322ybp.7;
        Wed, 23 Sep 2020 12:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3hTOlgzTl5hJRV97NQpy5QEUIjKm+U3ejE9GCIupaz8=;
        b=KjScLvjv2844xRGXGn/zV7dYSzkYv+O5YQ73hbPbsQfKnuPMv6eFNjG4qq+3HNEPB5
         +bKObDLcC6LmX3ACWdEO1wOFnkFtAmon9u1UbtyGVlkgb5rBdHtdfSfVXod1ro+7wVR0
         x1zIj0SlN1s87zBQ7cGC50CMKNyHmznP6+zWSQXXWqx9AXjeY6ATsKJK64SfBNR14Crm
         Ugoit+zWn2LgJv6/vxuQYmT+qcJtcgD9/RFpZHrjXRvsrSN77PbsdY+E/TC+U3aJBmvD
         LnNdXw8K7+aCLrkaFJ6XJ7No4Ps/TIICHIXCSxW3qsl8X+uc3P/qkZ8wp+JJGvBvvcgi
         O43A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3hTOlgzTl5hJRV97NQpy5QEUIjKm+U3ejE9GCIupaz8=;
        b=K8Yokmpoh5bQ0nRyN+T8u87QvzJLS+pJmKROyYTW7HJvnX8FPZOcjUy+fv8NCM+lLo
         FpcIH+Utrtbx87AO2hUbzoAdVif2qFRMlnH4TCLQLg0Oo7sGQp+m/GCGLp+sLZ5XAl9A
         Rknp4yppgAKNqS7jGuAg66W8boP6N8KUP8nQlxUCuSHDSW2VinXk34si+/NRkJRVfYx/
         sfFKS0zhYMvFbBLebcg/Ok/EMQqKjwxOBXbSGPET0VH5KnuFmXR/YaZyOXAXSsZTsYQt
         XqR5DqfA3bk/5c95e4TaNMo1oV6ZStMmZ8Dda51n4JopdFCHo2EDjDnpXQOX0fiihiIR
         t4UA==
X-Gm-Message-State: AOAM531EFRPkVPAgRZqrTqTq2ups4Bl7S7ZQFM2pkM/np936omeInCd1
        MYryYfRbDG1Lppnb4KD6LsXu7aJ+byHwvVz6lv0=
X-Google-Smtp-Source: ABdhPJznHSeYzekj8iQlaJRt+Ay4uhcrHoEr/mhynAiJzVJP8XK+CMu8BJWnWJRIg7lJJRf/FcA5r1PFsYhjx+YK2Wc=
X-Received: by 2002:a25:4446:: with SMTP id r67mr2118098yba.459.1600889784361;
 Wed, 23 Sep 2020 12:36:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200923165401.2284447-1-songliubraving@fb.com> <20200923165401.2284447-2-songliubraving@fb.com>
In-Reply-To: <20200923165401.2284447-2-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 23 Sep 2020 12:36:12 -0700
Message-ID: <CAEf4BzYfnhtZN9d6x2BnvktZk_BL=H6gfSxS_qeVTR5_QJAWqA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: enable BPF_PROG_TEST_RUN for raw_tracepoint
To:     Song Liu <songliubraving@fb.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 9:54 AM Song Liu <songliubraving@fb.com> wrote:
>
> Add .test_run for raw_tracepoint. Also, introduce a new feature that runs
> the target program on a specific CPU. This is achieved by a new flag in
> bpf_attr.test, cpu_plus. For compatibility, cpu_plus == 0 means run the
> program on current cpu, cpu_plus > 0 means run the program on cpu with id
> (cpu_plus - 1). This feature is needed for BPF programs that handle
> perf_event and other percpu resources, as the program can access these
> resource locally.
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  include/linux/bpf.h            |  3 ++
>  include/uapi/linux/bpf.h       |  5 ++
>  kernel/bpf/syscall.c           |  2 +-
>  kernel/trace/bpf_trace.c       |  1 +
>  net/bpf/test_run.c             | 88 ++++++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h |  5 ++
>  6 files changed, 103 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index d7c5a6ed87e30..23758c282eb4b 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1376,6 +1376,9 @@ int bpf_prog_test_run_tracing(struct bpf_prog *prog,
>  int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
>                                      const union bpf_attr *kattr,
>                                      union bpf_attr __user *uattr);
> +int bpf_prog_test_run_raw_tp(struct bpf_prog *prog,
> +                            const union bpf_attr *kattr,
> +                            union bpf_attr __user *uattr);
>  bool btf_ctx_access(int off, int size, enum bpf_access_type type,
>                     const struct bpf_prog *prog,
>                     struct bpf_insn_access_aux *info);
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index a22812561064a..89acf41913e70 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -566,6 +566,11 @@ union bpf_attr {
>                                                  */
>                 __aligned_u64   ctx_in;
>                 __aligned_u64   ctx_out;
> +               __u32           cpu_plus;       /* run this program on cpu
> +                                                * (cpu_plus - 1).
> +                                                * If cpu_plus == 0, run on
> +                                                * current cpu.
> +                                                */

the "_plus" part of the name is so confusing, just as off-by-one
semantics.. Why not do what we do with BPF_PROG_ATTACH? I.e., we have
flags field, and if the specific bit is set then we use extra field's
value. In this case, you'd have:

__u32 flags;
__u32 cpu; /* naturally 0-based */

cpu indexing will be natural without any offsets, and you'll have
something like BPF_PROG_TEST_CPU flag, that needs to be specified.
This will work well with backward/forward compatibility. If you need a
special "current CPU" mode, you can achieve that by not specifying
BPF_PROG_TEST_CPU flag, or we can designate (__u32)-1 as a special
"current CPU" value.

WDYT?


>         } test;
>
>         struct { /* anonymous struct used by BPF_*_GET_*_ID */
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index ec68d3a23a2b7..4664531ff92ea 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2975,7 +2975,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
>         }
>  }
>
> -#define BPF_PROG_TEST_RUN_LAST_FIELD test.ctx_out
> +#define BPF_PROG_TEST_RUN_LAST_FIELD test.cpu_plus
>

[...]
