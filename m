Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F77E34136E
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 04:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhCSDRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 23:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233469AbhCSDRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 23:17:02 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE58CC06174A;
        Thu, 18 Mar 2021 20:17:01 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id v107so3993689ybi.0;
        Thu, 18 Mar 2021 20:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c8SJjtzomDa4P2no5zcb3DnH7I1x3RP6p1WqONt2l2w=;
        b=HYHg7XgT5ZeXz3Qu+IsWHik2FLjy8s3KzwHpcx/SvZxO1IoSz5/Bg8Ka25pPge6iJC
         L2XP1L9fSg7/Vcpzysm9AbUCJFnhUC8DhN0uLEVptXwkRORLk6jKBkOFKu3gj3gkhhHy
         7ktdd3ExqYXdWntkHUe0L3WV73BQ71PoYic1Eay2gBnDao3F26wuhEaaJXHtBNqajnZW
         h67j/SxdaysyoZqTwQnGArhQlt3xrN8IZbG41x3h7zW6pMOz4E9Hf7mprmRL7H3+4vxL
         rzHoJnIcl003E/D0+fA4rlGDdcTuPKTR0DT68tJ7baibjJb/Zx28dODSu6UqFUdnVvGu
         lo/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c8SJjtzomDa4P2no5zcb3DnH7I1x3RP6p1WqONt2l2w=;
        b=hvYZ7VYHs8DYsZL5VZ8HaiOXe9aw7OgH2apxoxL1bLGHen/5hI3C1vT+3noQsMAZVy
         KZOSFFTcCE5mGESTGx7mP5TMPOqd3I+PilUhxisV+Wg7vx+E545MNrm6ksldZsOpuUEP
         exkwkoDR1FePr3qIOR1YgUssBDbSrNioi9falvCu3Un7UPnZTJ+hEpYTI35/9X+y1Rdj
         H0QTlwGh5qEYJaFIdtCQ+gNcqYPOVeT2buFw1pbA9I6lXtUaKbUU3WUl/wbyXAwyZDO+
         8jRhqhDWMcVXQWvzBeL2ype07N/T4lUaU3wzdq5HHR0p5YWJQdjEvU/+8WyQF6+/xSsk
         /rLQ==
X-Gm-Message-State: AOAM531GDKH660Vb2E76vqz2oUymaxDG1s9f3/0VrR9FFJx4A0qnI3YF
        IWHfK0/xCalpEpiEBfvZqOtlf1OGY0ifMK69mHg=
X-Google-Smtp-Source: ABdhPJwrjlAZhOpjlOr47IiuXUWK6EbY9/0Z4SAqa9Te0MOAdEU8X9ZbyYFRo5d6fTVIqLbv5+P+jBxrftWmxsXLyQw=
X-Received: by 2002:a25:4982:: with SMTP id w124mr3464768yba.27.1616123821222;
 Thu, 18 Mar 2021 20:17:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210316011336.4173585-1-kafai@fb.com> <20210316011445.4179633-1-kafai@fb.com>
In-Reply-To: <20210316011445.4179633-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Mar 2021 20:16:50 -0700
Message-ID: <CAEf4BzaLcqHEHu506t+Lr1X-d01-D0isxM0NZ56nLnR3bv1eUQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 11/15] libbpf: Record extern sym relocation first
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 12:02 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch records the extern sym relocs first before recording
> subprog relocs.  The later patch will have relocs for extern
> kernel function call which is also using BPF_JMP | BPF_CALL.
> It will be easier to handle the extern symbols first in
> the later patch.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

Looks good, just let's add that tiny helper for cleanliness and to
match what we do for ldimm64

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/lib/bpf/libbpf.c | 50 +++++++++++++++++++++---------------------
>  1 file changed, 25 insertions(+), 25 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 8f924aece736..0a60fcb2fba2 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -3416,31 +3416,7 @@ static int bpf_program__record_reloc(struct bpf_program *prog,
>
>         reloc_desc->processed = false;
>
> -       /* sub-program call relocation */
> -       if (insn->code == (BPF_JMP | BPF_CALL)) {
> -               if (insn->src_reg != BPF_PSEUDO_CALL) {
> -                       pr_warn("prog '%s': incorrect bpf_call opcode\n", prog->name);
> -                       return -LIBBPF_ERRNO__RELOC;
> -               }
> -               /* text_shndx can be 0, if no default "main" program exists */
> -               if (!shdr_idx || shdr_idx != obj->efile.text_shndx) {
> -                       sym_sec_name = elf_sec_name(obj, elf_sec_by_idx(obj, shdr_idx));
> -                       pr_warn("prog '%s': bad call relo against '%s' in section '%s'\n",
> -                               prog->name, sym_name, sym_sec_name);
> -                       return -LIBBPF_ERRNO__RELOC;
> -               }
> -               if (sym->st_value % BPF_INSN_SZ) {
> -                       pr_warn("prog '%s': bad call relo against '%s' at offset %zu\n",
> -                               prog->name, sym_name, (size_t)sym->st_value);
> -                       return -LIBBPF_ERRNO__RELOC;
> -               }
> -               reloc_desc->type = RELO_CALL;
> -               reloc_desc->insn_idx = insn_idx;
> -               reloc_desc->sym_off = sym->st_value;
> -               return 0;
> -       }
> -
> -       if (!is_ldimm64(insn)) {
> +       if (insn->code != (BPF_JMP | BPF_CALL) && !is_ldimm64(insn)) {
>                 pr_warn("prog '%s': invalid relo against '%s' for insns[%d].code 0x%x\n",
>                         prog->name, sym_name, insn_idx, insn->code);
>                 return -LIBBPF_ERRNO__RELOC;
> @@ -3469,6 +3445,30 @@ static int bpf_program__record_reloc(struct bpf_program *prog,
>                 return 0;
>         }
>
> +       /* sub-program call relocation */
> +       if (insn->code == (BPF_JMP | BPF_CALL)) {

can you please add is_call_insn() helper checking this, similarly to
how we now have is_ldimm64() (should probably be is_ldimm64_insn() for
consistency)

> +               if (insn->src_reg != BPF_PSEUDO_CALL) {
> +                       pr_warn("prog '%s': incorrect bpf_call opcode\n", prog->name);
> +                       return -LIBBPF_ERRNO__RELOC;
> +               }
> +               /* text_shndx can be 0, if no default "main" program exists */
> +               if (!shdr_idx || shdr_idx != obj->efile.text_shndx) {
> +                       sym_sec_name = elf_sec_name(obj, elf_sec_by_idx(obj, shdr_idx));
> +                       pr_warn("prog '%s': bad call relo against '%s' in section '%s'\n",
> +                               prog->name, sym_name, sym_sec_name);
> +                       return -LIBBPF_ERRNO__RELOC;
> +               }
> +               if (sym->st_value % BPF_INSN_SZ) {
> +                       pr_warn("prog '%s': bad call relo against '%s' at offset %zu\n",
> +                               prog->name, sym_name, (size_t)sym->st_value);
> +                       return -LIBBPF_ERRNO__RELOC;
> +               }
> +               reloc_desc->type = RELO_CALL;
> +               reloc_desc->insn_idx = insn_idx;
> +               reloc_desc->sym_off = sym->st_value;
> +               return 0;
> +       }
> +
>         if (!shdr_idx || shdr_idx >= SHN_LORESERVE) {
>                 pr_warn("prog '%s': invalid relo against '%s' in special section 0x%x; forgot to initialize global var?..\n",
>                         prog->name, sym_name, shdr_idx);
> --
> 2.30.2
>
