Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A56C436B811
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235627AbhDZRaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235324AbhDZRaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:30:05 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D8FC06175F;
        Mon, 26 Apr 2021 10:29:21 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id 82so65881235yby.7;
        Mon, 26 Apr 2021 10:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fe244vks1l4ikiCCo50EbQFUtXr+3c/1LtfABFMFHAg=;
        b=duwxWrhFOv8t2NkwHJ5dC+FhTnDL5DE9TH+feVtgka7ITtuE6c7Q7gPkYgJWe0qMbz
         S+Z6IcLFzfJnPb21MYaNGLhAPbHXaDTwjk3SQaBPm/B4n0xfaVX70LtJHLI9W+OxJ1nf
         LmD/2x6oaKPfpZ7S5g5ny6Er9NWWXic6Ev7lbr/A5uvaCsWmNbEDScNFE6TbMJkvMfEo
         Q9+q00/6rXm7fitReH6QeP7G0KtXe5bEnTUDqlsmiG7NJZ4LDqF9m3NIoaX1emkUkSfd
         vLM+KuTcM1XhsXwdcOk/OkDUr/wda8K2UCzJemzSc6iWH/u2xit3ZuyptTdRs/mSwO87
         YGAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fe244vks1l4ikiCCo50EbQFUtXr+3c/1LtfABFMFHAg=;
        b=eLTDsU8uvR445G6zSTB8ajAhkJUHKd9KZHjAS36xTZCVQFsHMnS+QJYTzjJRIbsz87
         VFPquFxyJrTZbvsbxt/h+5Wp9EFNESyksqSjQha+fa3NXpuqGVckAHwp6uWURVfEq9De
         UKwyaBfmXdJfWdUScpiKPGEuW6wnrWhBSnt3vB1gk7biX2OcPMFogyC/XUcThW4vK4pl
         IEiJaQB5L7oT/jgfCQQfitErjVo3r+W603tYGfXFmyCkXVuRHhZIpCVcmGeLvKk5wGIW
         2FQ1MPnhhbo5phcqTRR5cGJB5b+l5x84ZiaoBAK4kCkDLriZov6tPNqsIUqwCxS9m0GN
         /A7A==
X-Gm-Message-State: AOAM532tAU2XzmvZFrRObIBM7sihHMYx+0qrLdI7RsrRhFGwP70E8BBw
        6ZRd2yaAhAVtlVECJQZc+5nxyvG4Rb2vA+xTdM+K5R1Np0c=
X-Google-Smtp-Source: ABdhPJxBsSo2XAJ61LvR90Mgsr0oMOAbcuQ9Tvm0PJmceVQWjjAP/VJeXH12zg98VFhpUrUw/14wSvZe7OwRqpz08jM=
X-Received: by 2002:a25:ba06:: with SMTP id t6mr24656916ybg.459.1619458160896;
 Mon, 26 Apr 2021 10:29:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com> <20210423002646.35043-13-alexei.starovoitov@gmail.com>
In-Reply-To: <20210423002646.35043-13-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 26 Apr 2021 10:29:09 -0700
Message-ID: <CAEf4BzZofcwskPQXRpV4ZEiVbrzg296t+fSpezFxDLF3ueQBWg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 12/16] libbpf: Change the order of data and
 text relocations.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 5:27 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> In order to be able to generate loader program in the later
> patches change the order of data and text relocations.
> Also improve the test to include data relos.
>
> If the kernel supports "FD array" the map_fd relocations can be processed
> before text relos since generated loader program won't need to manually
> patch ld_imm64 insns with map_fd.
> But ksym and kfunc relocations can only be processed after all calls
> are relocated, since loader program will consist of a sequence
> of calls to bpf_btf_find_by_name_kind() followed by patching of btf_id
> and btf_obj_fd into corresponding ld_imm64 insns. The locations of those
> ld_imm64 insns are specified in relocations.
> Hence process all data relocations (maps, ksym, kfunc) together after call relos.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  tools/lib/bpf/libbpf.c                        | 86 +++++++++++++++----
>  .../selftests/bpf/progs/test_subprogs.c       | 13 +++
>  2 files changed, 80 insertions(+), 19 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 17cfc5b66111..c73a85b97ca5 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -6379,11 +6379,15 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
>                         insn[0].imm = ext->ksym.kernel_btf_id;
>                         break;
>                 case RELO_SUBPROG_ADDR:
> -                       insn[0].src_reg = BPF_PSEUDO_FUNC;
> -                       /* will be handled as a follow up pass */
> +                       if (insn[0].src_reg != BPF_PSEUDO_FUNC) {
> +                               pr_warn("prog '%s': relo #%d: bad insn\n",
> +                                       prog->name, i);
> +                               return -EINVAL;
> +                       }

given SUBPROG_ADDR is now handled similarly to RELO_CALL in a
different place, I'd probably drop this error check and just combine
RELO_SUBPROG_ADDR and RELO_CALL cases with just a /* handled already
*/ comment.

> +                       /* handled already */
>                         break;
>                 case RELO_CALL:
> -                       /* will be handled as a follow up pass */
> +                       /* handled already */
>                         break;
>                 default:
>                         pr_warn("prog '%s': relo #%d: bad relo type %d\n",
> @@ -6552,6 +6556,31 @@ static struct reloc_desc *find_prog_insn_relo(const struct bpf_program *prog, si
>                        sizeof(*prog->reloc_desc), cmp_relo_by_insn_idx);
>  }
>
> +static int append_subprog_relos(struct bpf_program *main_prog, struct bpf_program *subprog)
> +{
> +       int new_cnt = main_prog->nr_reloc + subprog->nr_reloc;
> +       struct reloc_desc *relos;
> +       size_t off = subprog->sub_insn_off;
> +       int i;
> +
> +       if (main_prog == subprog)
> +               return 0;
> +       relos = libbpf_reallocarray(main_prog->reloc_desc, new_cnt, sizeof(*relos));
> +       if (!relos)
> +               return -ENOMEM;
> +       memcpy(relos + main_prog->nr_reloc, subprog->reloc_desc,
> +              sizeof(*relos) * subprog->nr_reloc);
> +
> +       for (i = main_prog->nr_reloc; i < new_cnt; i++)
> +               relos[i].insn_idx += off;

nit: off is used only here, so there is little point in having it as a
separate var, inline?

> +       /* After insn_idx adjustment the 'relos' array is still sorted
> +        * by insn_idx and doesn't break bsearch.
> +        */
> +       main_prog->reloc_desc = relos;
> +       main_prog->nr_reloc = new_cnt;
> +       return 0;
> +}
> +
>  static int
>  bpf_object__reloc_code(struct bpf_object *obj, struct bpf_program *main_prog,
>                        struct bpf_program *prog)
> @@ -6560,18 +6589,32 @@ bpf_object__reloc_code(struct bpf_object *obj, struct bpf_program *main_prog,
>         struct bpf_program *subprog;
>         struct bpf_insn *insns, *insn;
>         struct reloc_desc *relo;
> -       int err;
> +       int err, i;
>
>         err = reloc_prog_func_and_line_info(obj, main_prog, prog);
>         if (err)
>                 return err;
>
> +       for (i = 0; i < prog->nr_reloc; i++) {
> +               relo = &prog->reloc_desc[i];
> +               insn = &main_prog->insns[prog->sub_insn_off + relo->insn_idx];
> +
> +               if (relo->type == RELO_SUBPROG_ADDR)
> +                       /* mark the insn, so it becomes insn_is_pseudo_func() */
> +                       insn[0].src_reg = BPF_PSEUDO_FUNC;
> +       }
> +

This will do the same work over and over each time we append a subprog
to main_prog. This should logically follow append_subprog_relos(), but
you wanted to do it for main_prog with the same code, right?

How about instead doing this before we start appending subprogs to
main_progs? I.e., do it explicitly in bpf_object__relocate() before
you start code relocation loop.

>         for (insn_idx = 0; insn_idx < prog->sec_insn_cnt; insn_idx++) {
>                 insn = &main_prog->insns[prog->sub_insn_off + insn_idx];
>                 if (!insn_is_subprog_call(insn) && !insn_is_pseudo_func(insn))
>                         continue;
>
>                 relo = find_prog_insn_relo(prog, insn_idx);
> +               if (relo && relo->type == RELO_EXTERN_FUNC)
> +                       /* kfunc relocations will be handled later
> +                        * in bpf_object__relocate_data()
> +                        */
> +                       continue;
>                 if (relo && relo->type != RELO_CALL && relo->type != RELO_SUBPROG_ADDR) {
>                         pr_warn("prog '%s': unexpected relo for insn #%zu, type %d\n",
>                                 prog->name, insn_idx, relo->type);

[...]
