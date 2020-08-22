Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC35B24E4E5
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 05:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgHVDbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 23:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbgHVDbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 23:31:51 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33525C061573;
        Fri, 21 Aug 2020 20:31:51 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id x2so2094708ybf.12;
        Fri, 21 Aug 2020 20:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/HgzY/I9T6Wi9t0rHAA3x298KDA7A38lzqGKWQMTAME=;
        b=N219IKkwMkbaOCJSbBdHCdLFAPBV3M2j8LUZqDb+kv1fTEDLv03p5KPbJFTbKWeRJK
         pLDUR4bBCVieS8YTQfMmSkynz3Dl4Jpa2frVz4FDA19EYShaLKMsHN8EOneWnaDJ8D1e
         5EpoNYsTjDonXGqv9DSWe0VfUxjgbMzL6B1BzqsoVzS6iUdKXDTO9BW7T8nZDd/vA+52
         oHzzEqTHS4Ack7VCv428W1YGkoykoMQkt1cuimui0trZPixMip2lLbo0RwAVYAm9d7Kp
         /tX/q1C0IoiF6LbbmwnjAat8WjyvSfeH5gG7hLsv0lqTiCGDmIAz3YrePN1EMI0dB5tx
         BT4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/HgzY/I9T6Wi9t0rHAA3x298KDA7A38lzqGKWQMTAME=;
        b=c2VrLXH3KIgAuoSu+jLSB2cjP+P0smWE5dc1vd/3Ut/pM70qSxkdLJjfNPhAxvTGkD
         wCUF+6OlrUzYYzUOtGK9KspT4odJlkOGdqYKhaZZn0CdE6A/yOkD6tGcPUic+EQNtjhg
         stUgo0hXkwlRbnhSHUxCuE/l1qaThCE+znXHSfNO+6bkxl59fyy2aNXDtl3S2il6aU26
         Zr/QMhG+R8CiGHAopLv+WcG89lzKL/ZkcmQfjLAfk7CDkOGPNJge8hyG3Ef/9J+hzV0T
         ZULljqQcBhBOsCGAfyqzOQRseUVfUqtUbGLC5JNmmB9PlYFNhTfubiI3ZwSzo+b4QTwf
         nivA==
X-Gm-Message-State: AOAM531EiUe6miOUR+MBZsls4YMSmud6E0StbTLMzyzUQ23uHNYwJkIL
        BrUCGsc7hR+ZENlm6lL1Ldk23gD6bMnA6WiWhAc=
X-Google-Smtp-Source: ABdhPJxTeoqarUOnaGYpQNCMqK2rPd/cQOK8v2PHRqaJ7A6oY1hln0k0JXQb/buwZ5qvPe++lqoNvdSeScSqwkbyZ6Q=
X-Received: by 2002:a25:824a:: with SMTP id d10mr8096614ybn.260.1598067110462;
 Fri, 21 Aug 2020 20:31:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200819224030.1615203-1-haoluo@google.com> <20200819224030.1615203-7-haoluo@google.com>
 <CAEf4BzZY2LyJvF9HCdAzHM7WG26GO0qqX=Wc6EiXArks=kmazA@mail.gmail.com>
In-Reply-To: <CAEf4BzZY2LyJvF9HCdAzHM7WG26GO0qqX=Wc6EiXArks=kmazA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 21 Aug 2020 20:31:39 -0700
Message-ID: <CAEf4BzZ+uqE73tM6W1vXyc-hu6fB8B9ZNniq-XHYhFDjhHg9gA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 6/8] bpf: Introduce bpf_per_cpu_ptr()
To:     Hao Luo <haoluo@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Andrey Ignatov <rdna@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 8:26 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Aug 19, 2020 at 3:42 PM Hao Luo <haoluo@google.com> wrote:
> >
> > Add bpf_per_cpu_ptr() to help bpf programs access percpu vars.
> > bpf_per_cpu_ptr() has the same semantic as per_cpu_ptr() in the kernel
> > except that it may return NULL. This happens when the cpu parameter is
> > out of range. So the caller must check the returned value.
> >
> > Signed-off-by: Hao Luo <haoluo@google.com>
> > ---
>
> The logic looks correct, few naming nits, but otherwise:
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
>
> >  include/linux/bpf.h      |  3 ++
> >  include/linux/btf.h      | 11 +++++++
> >  include/uapi/linux/bpf.h | 14 +++++++++
> >  kernel/bpf/btf.c         | 10 -------
> >  kernel/bpf/verifier.c    | 64 ++++++++++++++++++++++++++++++++++++++--
> >  kernel/trace/bpf_trace.c | 18 +++++++++++
> >  6 files changed, 107 insertions(+), 13 deletions(-)
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 55f694b63164..613404beab33 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -268,6 +268,7 @@ enum bpf_arg_type {
> >         ARG_PTR_TO_ALLOC_MEM,   /* pointer to dynamically allocated memory */
> >         ARG_PTR_TO_ALLOC_MEM_OR_NULL,   /* pointer to dynamically allocated memory or NULL */
> >         ARG_CONST_ALLOC_SIZE_OR_ZERO,   /* number of allocated bytes requested */
> > +       ARG_PTR_TO_PERCPU_BTF_ID,       /* pointer to in-kernel percpu type */
> >  };
> >
> >  /* type of values returned from helper functions */
> > @@ -281,6 +282,7 @@ enum bpf_return_type {
> >         RET_PTR_TO_SOCK_COMMON_OR_NULL, /* returns a pointer to a sock_common or NULL */
> >         RET_PTR_TO_ALLOC_MEM_OR_NULL,   /* returns a pointer to dynamically allocated memory or NULL */
> >         RET_PTR_TO_BTF_ID_OR_NULL,      /* returns a pointer to a btf_id or NULL */
> > +       RET_PTR_TO_MEM_OR_BTF_OR_NULL,  /* returns a pointer to a valid memory or a btf_id or NULL */
>
> I know it's already very long, but still let's use BTF_ID consistently
>
> >  };
> >
> >  /* eBPF function prototype used by verifier to allow BPF_CALLs from eBPF programs
> > @@ -360,6 +362,7 @@ enum bpf_reg_type {
> >         PTR_TO_RDONLY_BUF_OR_NULL, /* reg points to a readonly buffer or NULL */
> >         PTR_TO_RDWR_BUF,         /* reg points to a read/write buffer */
> >         PTR_TO_RDWR_BUF_OR_NULL, /* reg points to a read/write buffer or NULL */
> > +       PTR_TO_PERCPU_BTF_ID,    /* reg points to percpu kernel type */
> >  };
> >
>
> [...]
>
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 468376f2910b..c7e49a102ed2 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -3415,6 +3415,19 @@ union bpf_attr {
> >   *             A non-negative value equal to or less than *size* on success,
> >   *             or a negative error in case of failure.
> >   *
> > + * void *bpf_per_cpu_ptr(const void *ptr, u32 cpu)

btw, having bpf_this_cpu_ptr(const void *ptr) seems worthwhile as well, WDYT?

> > + *     Description
> > + *             Take the address of a percpu ksym and return a pointer pointing
> > + *             to the variable on *cpu*. A ksym is an extern variable decorated
> > + *             with '__ksym'. A ksym is percpu if there is a global percpu var
> > + *             (either static or global) defined of the same name in the kernel.
>
> The function signature has "ptr", not "ksym", but the description is
> using "ksym". please make them consistent (might name param
> "percpu_ptr")
>
> > + *
> > + *             bpf_per_cpu_ptr() has the same semantic as per_cpu_ptr() in the
> > + *             kernel, except that bpf_per_cpu_ptr() may return NULL. This
> > + *             happens if *cpu* is larger than nr_cpu_ids. The caller of
> > + *             bpf_per_cpu_ptr() must check the returned value.
> > + *     Return
> > + *             A generic pointer pointing to the variable on *cpu*.
> >   */
>
> [...]
>
> > +       } else if (arg_type == ARG_PTR_TO_PERCPU_BTF_ID) {
> > +               expected_type = PTR_TO_PERCPU_BTF_ID;
> > +               if (type != expected_type)
> > +                       goto err_type;
> > +               if (!reg->btf_id) {
> > +                       verbose(env, "Helper has zero btf_id in R%d\n", regno);
>
> nit: "invalid btf_id"?
>
> > +                       return -EACCES;
> > +               }
> > +               meta->ret_btf_id = reg->btf_id;
> >         } else if (arg_type == ARG_PTR_TO_BTF_ID) {
> >                 expected_type = PTR_TO_BTF_ID;
> >                 if (type != expected_type)
> > @@ -4904,6 +4918,30 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
> >                 regs[BPF_REG_0].type = PTR_TO_MEM_OR_NULL;
> >                 regs[BPF_REG_0].id = ++env->id_gen;
> >                 regs[BPF_REG_0].mem_size = meta.mem_size;
>
> [...]
