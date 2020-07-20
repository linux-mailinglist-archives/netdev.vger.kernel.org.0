Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF58F225701
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 07:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgGTFWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 01:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbgGTFWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 01:22:32 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76506C0619D2;
        Sun, 19 Jul 2020 22:22:32 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id b79so429417qkg.9;
        Sun, 19 Jul 2020 22:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J9yakJIWVJcO3qOP1hLM5tTSUBs1Jt+mXyEidCcZxjA=;
        b=L4R0GS9iJsO22staBD0RL/tWoOc+llS1WcszVoPCdFC287SWRXFVQqgLt43M2x/1hz
         B3zV/JsRDJY0RmkMvxadDiB6oei8AG0lvk0rE4fQnemMtppN9MmJ+y0zKSS/DqWjbQeI
         rTIPPLHyUgG9zAg1xGkpRw6mie2+fR0zgWUf7ZJOXaccJYoJ3YPFHO4luWFJ0PJIpwSR
         NJzZbGzB2pe86I77cSzsMtU27vhWbnVv9LAOcOBncp89pMlLOQC9V+Dz35gvAHWVuYrk
         qxL1kVAl6+6MMWU+oc2ez+N549j/jPNV1EHsbdywQd8KVWXa3PqaMNE9Cki/cuespRig
         x5yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J9yakJIWVJcO3qOP1hLM5tTSUBs1Jt+mXyEidCcZxjA=;
        b=opwbWUvgmKIK3FPU7+GmcYyV+D0+n41CMRzXs0MhiKkscMkKHVEBbVgzSUnmoM7Lgf
         jLIFL5ZuOb6k8uDaAb5Q7ImQlrvAel2i9d5vewQBTYy9VVNxZtAqeBuNmhjMLeDqo02T
         AYX+YgCyi7AbmLx5VcIYAXNyT0dZfU9ELoEq5fUXm6LsSnYlKHD7O9qj7a+zzv0XiGWQ
         C+8D552y/IJ3U3+f0gzGWGGEZYiTFyyrTtysZvpavMUhVVzroERtmPg1EXGLbvQehmUy
         zixCyJfz25eoqBPb8hbda/QLblAFcYVLh+thF8jSgE/vaA8fiSQfu21tWiuxRkpEWDrW
         MtZg==
X-Gm-Message-State: AOAM530zy0e2ZxBG7veoLSv2HGdVruUspk53QEbGElW8JF/nKy031ySh
        IZRkC2VLiC9NgUCImVvEzCxlUsx6MuLnflSs0PE=
X-Google-Smtp-Source: ABdhPJwLF9RC4pjguC8DeRtX9v4tK2sOM0n9fP/pk+TU3p8YY098D89niOWnI/+FVoz07U7mGLAdXNwr5g89KV1KBFs=
X-Received: by 2002:ae9:f002:: with SMTP id l2mr20890927qkg.437.1595222550340;
 Sun, 19 Jul 2020 22:22:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200715214312.2266839-1-haoluo@google.com> <20200715214312.2266839-2-haoluo@google.com>
In-Reply-To: <20200715214312.2266839-2-haoluo@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 19 Jul 2020 22:22:19 -0700
Message-ID: <CAEf4BzZ5A+uMPFEmgom+0x+jju3JgTLXuuy=QB_dm2Skf--5Dg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 1/2] bpf: BTF support for __ksym externs
To:     Hao Luo <haoluo@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Stanislav Fomichev <sdf@google.com>,
        Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 2:45 PM Hao Luo <haoluo@google.com> wrote:
>
> Previous commits:
>
>  commit 1c0c7074fefd ("libbpf: Add support for extracting kernel symbol addresses")
>  commit 2e33efe32e01 ("libbpf: Generalize libbpf externs support")
>
> have introduced a new type of extern variable ksyms to access kernel
> global variables. This patch extends that work by adding btf info
> for ksyms. In more details, in addition to the existing type btf_types,
> pahole is going to encode a certain global variables in kernel btf
> (percpu variables at this moment). With the extended kernel btf, we
> can associate btf id to the ksyms to improve the performance of
> accessing those vars by using direct load instructions.

This is a step in the right direction, thanks for working on this. See
below for a few problems, though.

Also, in the next version, please split kernel part and libbpf part
into separate patches.

>
> More specifically, libbpf can scan the kernel btf to find the btf id
> of a ksym at extern resolution. During relocation, it will replace
> "ld_imm64 rX, foo" with BPF_PSEUDO_BTF_ID. From the verifier point of
> view "ld_imm64 rX, foo // pseudo_btf_id" will be similar to ld_imm64
> with pseudo_map_fd and pseudo_map_value. The verifier will check btf_id
> and replace that with actual kernel address at program load time. It
> will also know that exact type of 'rX' from there on.
>
> Note that since only a subset of kernel symbols are encoded in btf right
> now, finding btf_id for ksyms is only best effort. If a ksym does not
> have a btf id, we do not rewrite its ld_imm64 to pseudo_btf_id. In that
> case, it is treated as loading from a scalar value, which is the current
> default behavior for ksyms.

I don't think that's the right approach. It can't be the best effort.
It's actually pretty clear when a user wants a BTF-based variable with
ability to do direct memory access vs __ksym address that we have
right now: variable type info. In your patch you are only looking up
variable by name, but it needs to be more elaborate logic:

1. if variable type is `extern void` -- do what we do today (no BTF required)
2. if the variable type is anything but `extern void`, then find that
variable in BTF. If no BTF or variable is not found -- hard error with
detailed enough message about what we expected to find in kernel BTF.
3. If such a variable is found in the kernel, then might be a good
idea to additionally check type compatibility (e.g., struct/union
should match struct/union, int should match int, typedefs should get
resolved to underlying type, etc). I don't think deep comparison of
structs is right, though, due to CO-RE, so just high-level
compatibility checks to prevent the most obvious mistakes.

>
> Also note since we need to carry the ksym's address (64bits) as well as
> its btf_id (32bits), pseudo_btf_id uses ld_imm64's both imm and off
> fields.

For BTF-enabled ksyms, libbpf doesn't need to provide symbol address,
kernel will find it and substitute it, so BTF ID is the only
parameter. Thus it can just go into the imm field (and simplify
ldimm64 validation logic a bit).


>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---
>  include/uapi/linux/bpf.h       | 37 +++++++++++++++++++------
>  kernel/bpf/verifier.c          | 26 +++++++++++++++---
>  tools/include/uapi/linux/bpf.h | 37 +++++++++++++++++++------
>  tools/lib/bpf/libbpf.c         | 50 +++++++++++++++++++++++++++++++++-
>  4 files changed, 127 insertions(+), 23 deletions(-)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 5e386389913a..7490005acdba 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -334,18 +334,37 @@ enum bpf_link_type {
>  #define BPF_F_TEST_STATE_FREQ  (1U << 3)
>
>  /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
> - * two extensions:
> - *
> - * insn[0].src_reg:  BPF_PSEUDO_MAP_FD   BPF_PSEUDO_MAP_VALUE
> - * insn[0].imm:      map fd              map fd
> - * insn[1].imm:      0                   offset into value
> - * insn[0].off:      0                   0
> - * insn[1].off:      0                   0
> - * ldimm64 rewrite:  address of map      address of map[0]+offset
> - * verifier type:    CONST_PTR_TO_MAP    PTR_TO_MAP_VALUE
> + * three extensions:
> + *
> + * insn[0].src_reg:  BPF_PSEUDO_MAP_FD
> + * insn[0].imm:      map fd
> + * insn[1].imm:      0
> + * insn[0].off:      0
> + * insn[1].off:      0
> + * ldimm64 rewrite:  address of map
> + * verifier type:    CONST_PTR_TO_MAP
>   */
>  #define BPF_PSEUDO_MAP_FD      1
> +/*
> + * insn[0].src_reg:  BPF_PSEUDO_MAP_VALUE
> + * insn[0].imm:      map fd
> + * insn[1].imm:      offset into value
> + * insn[0].off:      0
> + * insn[1].off:      0
> + * ldimm64 rewrite:  address of map[0]+offset
> + * verifier type:    PTR_TO_MAP_VALUE
> + */
>  #define BPF_PSEUDO_MAP_VALUE   2
> +/*
> + * insn[0].src_reg:  BPF_PSEUDO_BTF_ID
> + * insn[0].imm:      lower 32 bits of address
> + * insn[1].imm:      higher 32 bits of address
> + * insn[0].off:      lower 16 bits of btf id
> + * insn[1].off:      higher 16 bits of btf id
> + * ldimm64 rewrite:  address of kernel symbol
> + * verifier type:    PTR_TO_BTF_ID
> + */
> +#define BPF_PSEUDO_BTF_ID      3
>
>  /* when bpf_call->src_reg == BPF_PSEUDO_CALL, bpf_call->imm == pc-relative
>   * offset to another bpf function
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 3c1efc9d08fd..3c925957b9b6 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -7131,15 +7131,29 @@ static int check_ld_imm(struct bpf_verifier_env *env, struct bpf_insn *insn)
>                 verbose(env, "invalid BPF_LD_IMM insn\n");
>                 return -EINVAL;
>         }
> +       err = check_reg_arg(env, insn->dst_reg, DST_OP);
> +       if (err)
> +               return err;
> +
> +       /*
> +        * BPF_PSEUDO_BTF_ID insn's off fields carry the ksym's btf_id, so its
> +        * handling has to come before the reserved field check.
> +        */
> +       if (insn->src_reg == BPF_PSEUDO_BTF_ID) {
> +               u32 id = ((u32)(insn + 1)->off << 16) | (u32)insn->off;
> +               const struct btf_type *t = btf_type_by_id(btf_vmlinux, id);
> +

This is the kernel, we should be paranoid and assume the hackers want
to do bad things. So check t for NULL. Check that it's actually a
BTF_KIND_VAR. Check the name, find ksym addr, etc.


> +               mark_reg_known_zero(env, regs, insn->dst_reg);
> +               regs[insn->dst_reg].type = PTR_TO_BTF_ID;
> +               regs[insn->dst_reg].btf_id = t->type;
> +               return 0;
> +       }
> +
>         if (insn->off != 0) {
>                 verbose(env, "BPF_LD_IMM64 uses reserved fields\n");
>                 return -EINVAL;
>         }
>
> -       err = check_reg_arg(env, insn->dst_reg, DST_OP);
> -       if (err)
> -               return err;
> -
>         if (insn->src_reg == 0) {
>                 u64 imm = ((u64)(insn + 1)->imm << 32) | (u32)insn->imm;
>

[...]
