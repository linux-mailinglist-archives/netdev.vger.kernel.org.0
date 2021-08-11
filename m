Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371653E9B4C
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 01:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbhHKXmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 19:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232803AbhHKXmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 19:42:23 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4032C061765;
        Wed, 11 Aug 2021 16:41:58 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id m193so7976059ybf.9;
        Wed, 11 Aug 2021 16:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L0BwPmqvnJeUSMek9XOHFkeNmYhH90EdLiuOpsd4a7o=;
        b=ado0EwCxiRdwaN/R3l3MPUqT9mDGeTrKAocYenqwORuEWaQCkKT/ftXeKzZK0wp4hE
         VsHT+OgqOEWH9U+EqvTJb5ms6GEh0Gk+yrjHl4Bxvp6DMQXpLIEo/OrzUp0yyytoiXFL
         CH1B1GT2Pd9B+txqLf9Ur/5C4lodhSkC9+d6+2KOmEPctcLUm/BKUIC0dvi2is9pWzgl
         expo6a+gUp5qauuZMhWQqOPfZTk/EaofIXC1vix9Yc9aKJG8VXic4kV80g2oc3X35AlU
         gGwO81zXZ6VaBloSIFlJIqlP0lyxPu0O7CVv4PXlLH0QQdLBwmtHjeJc4fZqfYNlWRIk
         NHnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L0BwPmqvnJeUSMek9XOHFkeNmYhH90EdLiuOpsd4a7o=;
        b=EnLzugZPfge+6x+Sx8FKksX21h/48kVBlSKbwfBlWJ4bBH2cfdoKaXYINy7gmMALPj
         OOcr76Yb1wLepiyfLSlukCUk6Rotb53UAzUjJpcciT+J96n6pkkdIGwYXA8upUqjZt0t
         yC15AE/skutqVCmA4ST9b6+td9Xi4feuzs2Zaewr/3/9NnDMqbIj8kRzED5JZijb0lE6
         ikPgOKPSsRPlSVExMRFMaBfynQO9PewRPnsVJYRYZjVfdfeBy6xubyg42gULuqEivh56
         eYqCrhaKgDoUAAVw3ENlXBfZ4rP6X78sH8NiH5FazL4PNHp09U77Tatj2Bx0DOrzDwnQ
         3K5Q==
X-Gm-Message-State: AOAM53298pNuLvm07Uz1rdGFU6hF1lyg1TDFtIIGChswyvIO0VJxY9Y7
        7ZtErUNLMbRkgo/3Jba5z4EAnylIbRp+bhho+VA=
X-Google-Smtp-Source: ABdhPJz7Wdlh0mO70JYQcCq9U3Q49TV8QUMsySdSgOi5cWxSofN8oP+uhBsHi7pvAI1seNSkiqp6qipTp6s09bLipqU=
X-Received: by 2002:a5b:648:: with SMTP id o8mr706314ybq.260.1628725318158;
 Wed, 11 Aug 2021 16:41:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210811224036.2416308-1-haoluo@google.com>
In-Reply-To: <20210811224036.2416308-1-haoluo@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 11 Aug 2021 16:41:47 -0700
Message-ID: <CAEf4BzYX8Vg1YBHwGxj7cs+6FjsxnnYfxp1NKViZzO3nm=xudA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] libbpf: support weak typed ksyms.
To:     Hao Luo <haoluo@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 3:40 PM Hao Luo <haoluo@google.com> wrote:
>
> Currently weak typeless ksyms have default value zero, when they don't
> exist in the kernel. However, weak typed ksyms are rejected by libbpf
> if they can not be resolved. This means that if a bpf object contains
> the declaration of a nonexistent weak typed ksym, it will be rejected
> even if there is no program that references the symbol.
>
> Nonexistent weak typed ksyms can also default to zero just like
> typeless ones. This allows programs that access weak typed ksyms to be
> accepted by verifier, if the accesses are guarded. For example,
>
> extern const int bpf_link_fops3 __ksym __weak;
>
> /* then in BPF program */
>
> if (&bpf_link_fops3) {
>    /* use bpf_link_fops3 */
> }
>
> If actual use of nonexistent typed ksym is not guarded properly,
> verifier would see that register is not PTR_TO_BTF_ID and wouldn't
> allow to use it for direct memory reads or passing it to BPF helpers.
>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---
>  Changes since v1:
>   - Weak typed symbols default to zero, as suggested by Andrii.
>   - Use ASSERT_XXX() for tests.
>
>  tools/lib/bpf/libbpf.c                        | 17 ++++--
>  .../selftests/bpf/prog_tests/ksyms_btf.c      | 31 ++++++++++
>  .../selftests/bpf/progs/test_ksyms_weak.c     | 57 +++++++++++++++++++
>  3 files changed, 100 insertions(+), 5 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_weak.c
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index cb106e8c42cb..e7547a2967cf 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -5277,11 +5277,11 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
>                                 }
>                                 insn[1].imm = ext->kcfg.data_off;
>                         } else /* EXT_KSYM */ {
> -                               if (ext->ksym.type_id) { /* typed ksyms */
> +                               if (ext->ksym.type_id && ext->is_set) { /* typed ksyms */
>                                         insn[0].src_reg = BPF_PSEUDO_BTF_ID;
>                                         insn[0].imm = ext->ksym.kernel_btf_id;
>                                         insn[1].imm = ext->ksym.kernel_btf_obj_fd;
> -                               } else { /* typeless ksyms */
> +                               } else { /* typeless ksyms or unresolved typed ksyms */
>                                         insn[0].imm = (__u32)ext->ksym.addr;
>                                         insn[1].imm = ext->ksym.addr >> 32;
>                                 }
> @@ -6584,7 +6584,7 @@ static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
>  }
>
>  static int find_ksym_btf_id(struct bpf_object *obj, const char *ksym_name,
> -                           __u16 kind, struct btf **res_btf,
> +                           __u16 kind, bool is_weak, struct btf **res_btf,

instead of teaching find_ksym_btf_id() about weak symbol, just handle
-ESRCH in bpf_object__resolve_ksym_var_btf_id (you already are
special-handling it anyway). Just move the pr_warn from
find_ksym_btf_id into bpf_object__resolve_ksym_var_btf_id.
bpf_object__resolve_ksym_func_btf_id() already has a relevant pr_warn,
which duplicates the one in find_ksym_btf_id.

>                             int *res_btf_fd)
>  {
>         int i, id, btf_fd, err;
> @@ -6608,6 +6608,9 @@ static int find_ksym_btf_id(struct bpf_object *obj, const char *ksym_name,
>                                 break;
>                 }
>         }
> +       if (is_weak && id == -ENOENT)
> +               return 0;
> +

so this is not needed

>         if (id <= 0) {
>                 pr_warn("extern (%s ksym) '%s': failed to find BTF ID in kernel BTF(s).\n",
>                         __btf_kind_str(kind), ksym_name);

and this will be moved out to not emit unnecessary warnings for weak symbols

> @@ -6627,11 +6630,15 @@ static int bpf_object__resolve_ksym_var_btf_id(struct bpf_object *obj,
>         const char *targ_var_name;
>         int id, btf_fd = 0, err;
>         struct btf *btf = NULL;
> +       bool is_weak = ext->is_weak;
>
> -       id = find_ksym_btf_id(obj, ext->name, BTF_KIND_VAR, &btf, &btf_fd);
> +       id = find_ksym_btf_id(obj, ext->name, BTF_KIND_VAR, is_weak, &btf, &btf_fd);
>         if (id < 0)
>                 return id;
>
> +       if (is_weak && id == 0)
> +               return 0;
> +

and this will handle ESRCH + is_weak as a special case

>         /* find local type_id */
>         local_type_id = ext->ksym.type_id;
>
> @@ -6676,7 +6683,7 @@ static int bpf_object__resolve_ksym_func_btf_id(struct bpf_object *obj,
>
>         local_func_proto_id = ext->ksym.type_id;
>
> -       kfunc_id = find_ksym_btf_id(obj, ext->name, BTF_KIND_FUNC,
> +       kfunc_id = find_ksym_btf_id(obj, ext->name, BTF_KIND_FUNC, false,
>                                     &kern_btf, &kern_btf_fd);
>         if (kfunc_id < 0) {
>                 pr_warn("extern (func ksym) '%s': not found in kernel BTF\n",

[...]

> +/* existing weak symbols */
> +
> +/* test existing weak symbols can be resolved. */
> +extern const struct rq runqueues __ksym __weak; /* typed */
> +extern const void bpf_prog_active __ksym __weak; /* typeless */
> +
> +
> +/* non-existent weak symbols. */
> +
> +/* typeless symbols, default to zero. */
> +extern const void bpf_link_fops1 __ksym __weak;
> +
> +/* typed symbols, default to zero. */
> +extern const int bpf_link_fops2 __ksym __weak;
> +
> +/* typed symbols, pass if not referenced. */
> +extern const int bpf_link_fops3 __ksym __weak;
> +

this will be compiled out by compiler, you are not really testing
anything with that (libbpf doesn't even know about bpf_link_fops3).
Just drop bpf_link_fops3, bpf_link_fops2 is testing everything anyway.

> +SEC("raw_tp/sys_enter")
> +int pass_handler(const void *ctx)
> +{
> +       /* tests existing symbols. */
> +       struct rq *rq = (struct rq *)bpf_per_cpu_ptr(&runqueues, 0);

empty line between variable declaration and statements (better declare
and initialize rq separately, with empty line between those two)

> +       if (rq)
> +               out__existing_typed = rq->cpu;
> +       out__existing_typeless = (__u64)&bpf_prog_active;
> +
> +       /* tests non-existent symbols. */
> +       out__non_existent_typeless = (__u64)&bpf_link_fops1;
> +
> +       /* tests non-existent symbols. */
> +       out__non_existent_typed = (__u64)&bpf_link_fops2;
> +
> +       if (&bpf_link_fops2) /* can't happen */
> +               out__non_existent_typed = (__u64)bpf_per_cpu_ptr(&bpf_link_fops2, 0);
> +
> +       return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> --
> 2.32.0.605.g8dce9f2422-goog
>
