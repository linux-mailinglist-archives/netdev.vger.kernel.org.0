Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72182D4F3C
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 01:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728452AbgLJAMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 19:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbgLJAMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 19:12:46 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1D2C0613CF;
        Wed,  9 Dec 2020 16:12:06 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id a16so3058742ybh.5;
        Wed, 09 Dec 2020 16:12:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FDH8Mbhv49QKKn/hxGYS9/HvITjSZR0zdVcux6lz23g=;
        b=lc4rWpZRq5i7d9NezgwrF4uF5qkFWK2FXom+CKn45TsIC03Mmk4IZMTKolWM70r9eq
         WGA8tztAnfpdjaf5bUQqc1hMF5+zDbu3+L/IMXR95pl/R3GQFhm6z0uLU/I6U46Bz4pS
         lYIBX33/hzBUIJwsGlcNWkH+njNRHzgOVODFHjA1Rkge4VE/doP+46dZR+5BsdUSkShl
         yTd7OkkIvaRe2LRbwzwZemws8ncBdvK0I7TiOSre6Pl7kJ/n0zIwpfZkwF5G2Aad1hLk
         eXATFz5pfUpYxuEy7Q/pkv6zLAjFrvCFpDYa2jei9ToRsg9jTViM+e5FWVVS907Gkc2X
         41aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FDH8Mbhv49QKKn/hxGYS9/HvITjSZR0zdVcux6lz23g=;
        b=Fqb89Yd3TSivaygme4880+V8PdnJzF9i8AyyQzaoa/HntCYJDpy/vaAjwmfhTs0mDR
         wtgJoXYWdPAwZrYzQl/pNqfPrRx3eMneUpFdIpC6tVTnsN1pjnCVttOOtLCiUwsBgrsJ
         pKIYVQPxAk1N0SswElUVUk7QWZwwntTcQjIAxjZ4sCoHOYhifDv3UwckJ9BXnKkCp5SB
         YVUPed71blR4GhJb9NjK/U6nuLZf5QNO0kzOTHxTyRB5ymLvOH6FieVUvsBZXIx3Vu/y
         yA30vvCCWnsPeyXDRT1yLcgz0bcXhGma5ZfFbX2JH+FyjtAppXG1yiRLp1FoXCZUpy5F
         UQNQ==
X-Gm-Message-State: AOAM533KVuJH+GL5xQPoRYcXUgC6NJmlVIUo7aQGtNGpqcyjXZCtm4m4
        YY9YsDm8pbyD926aIAirJdO/y23WZCXmQBaAM9c=
X-Google-Smtp-Source: ABdhPJzp4prtqpbG5l2kiTptG9x2I7o1artraee9zo8YipJhoXhlTtDxIU5yhnONdTsi9JssE08NvP00hUQ34xnit5o=
X-Received: by 2002:a25:c089:: with SMTP id c131mr7046892ybf.510.1607559125607;
 Wed, 09 Dec 2020 16:12:05 -0800 (PST)
MIME-Version: 1.0
References: <20201208235332.354826-1-andrii@kernel.org> <alpine.LRH.2.23.451.2012092249520.26400@localhost>
In-Reply-To: <alpine.LRH.2.23.451.2012092249520.26400@localhost>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 9 Dec 2020 16:11:54 -0800
Message-ID: <CAEf4BzYokeyqnj76vBXqk2gK=Nt6-xVxPnrjCDzEBPsrqgaGyA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] libbpf: support module BTF for
 BPF_TYPE_ID_TARGET CO-RE relocation
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 9, 2020 at 3:10 PM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> On Tue, 8 Dec 2020, Andrii Nakryiko wrote:
>
> > When Clang emits ldimm64 instruction for BPF_TYPE_ID_TARGET CO-RE relocation,
> > put module BTF FD, containing target type, into upper 32 bits of imm64.
> >
> > Because this FD is internal to libbpf, it's very cumbersome to test this in
> > selftests. Manual testing was performed with debug log messages sprinkled
> > across selftests and libbpf, confirming expected values are substituted.
> > Better testing will be performed as part of the work adding module BTF types
> > support to  bpf_snprintf_btf() helpers.
> >
> > v1->v2:
> >   - fix crash on failing to resolve target spec (Alan).
> >
> > Cc: Alan Maguire <alan.maguire@oracle.com>
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>
> Thanks for this!
>
> Can confirm the segmentation fault has gone away. I tested with the
> veth_stats_rx program (though will switch to btf_test module later),
> and I still see the issue with a local kind of fwd for veth_stats
> leading to an inability to find the target kind in the module BTF:

Yes, this patch wasn't intended to change that part of libbpf logic.

For the FWD -> STRUCT/UNION (you forgot about union, btw)
"resolution". For your use case, where does the veth_stats forward
declaration come from? Is it coming from vmlinux.h as
forward-declared? You can easily "work around" that by defining struct
on your own, even the empty one:

struct veth_stats {}

That should make local veth_stats definition a concrete struct, not
fwd. The idea behind this strictness was that you have a local
expected *concrete* definition of the type you need to match against
the kernel type, not just its name (which is the only thing that is
recorded with FWD).

So I'm still hesitant about that FWD -> STRUCT/UNION resolution. BTF
dedup, btw, doesn't match just by name when it resolves FWD to
STRUCT/UNION, it has considerably more complicated logic to do the
resolution. So just make sure you have non-fwd declaration of the type
you work with.





>
> libbpf: sec 'kprobe/veth_stats_rx': found 5 CO-RE relocations
> libbpf: prog 'veth_stats_rx': relo #0: kind <target_type_id> (7), spec is
> [20] fwd veth_stats
> libbpf: prog 'veth_stats_rx': relo #0: no matching targets found
> libbpf: prog 'veth_stats_rx': relo #0: patched insn #3 (LDIMM64) imm64 20
> -> 0
> libbpf: prog 'veth_stats_rx': relo #1: kind <target_type_id> (7), spec is
> [20] fwd veth_stats
> libbpf: prog 'veth_stats_rx': relo #1: no matching targets found
> libbpf: prog 'veth_stats_rx': relo #1: patched insn #5 (LDIMM64) imm64 20
> -> 0
>
> Here's the same debug info with a patch on top of yours that loosens the
> constraints on kind matching such that a fwd local type will match a struct
> target type:
>
> libbpf: prog 'veth_stats_rx': relo #0: kind <target_type_id> (7), spec is
> [20] fwd veth_stats
> libbpf: CO-RE relocating [0] fwd veth_stats: found target candidate
> [91516] struct veth_stats in [veth]
> libbpf: prog 'veth_stats_rx': relo #0: matching candidate #0 [91516]
> struct veth_stats
> libbpf: prog 'veth_stats_rx': relo #0: patched insn #3 (LDIMM64) imm64 20
> -> 450971657596
> libbpf: prog 'veth_stats_rx': relo #1: kind <target_type_id> (7), spec is
> [20] fwd veth_stats
> libbpf: prog 'veth_stats_rx': relo #1: matching candidate #0 [91516]
> struct veth_stats
> libbpf: prog 'veth_stats_rx': relo #1: patched insn #5 (LDIMM64) imm64 20
> -> 450971657596
>
> Patch is below; if it makes sense to support loosening constraints on kind
> matching like this feel free to roll it into your patch or I can send a
> follow-up, whatever's easiest. Thanks!
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 2fb9824..9ead5b3 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4673,6 +4673,23 @@ static void bpf_core_free_cands(struct
> core_cand_list *ca
>         free(cands);
>  }
>
> +/* module-specific structs may have relo kind set to fwd, so as
> + * well as handling exact matches, a fwd kind has to match
> + * a target struct kind.
> + */
> +static bool kind_matches_target(const struct btf_type *local,
> +                               const struct btf_type *target)
> +{
> +       __u8 local_kind = btf_kind(local);
> +       __u8 target_kind = btf_kind(target);
> +
> +       if (local_kind == target_kind)
> +               return true;
> +       if (local_kind == BTF_KIND_FWD && target_kind == BTF_KIND_STRUCT)
> +               return true;
> +       return false;
> +}
> +
>  static int bpf_core_add_cands(struct core_cand *local_cand,
>                               size_t local_essent_len,
>                               const struct btf *targ_btf,
> @@ -4689,7 +4706,7 @@ static int bpf_core_add_cands(struct core_cand
> *local_cand
>         n = btf__get_nr_types(targ_btf);
>         for (i = targ_start_id; i <= n; i++) {
>                 t = btf__type_by_id(targ_btf, i);
> -               if (btf_kind(t) != btf_kind(local_cand->t))
> +               if (!kind_matches_target(local_cand->t, t))
>                         continue;
>
>                 targ_name = btf__name_by_offset(targ_btf, t->name_off);
> @@ -5057,7 +5074,7 @@ static int bpf_core_types_are_compat(const struct
> btf *loc
>         /* caller made sure that names match (ignoring flavor suffix) */
>         local_type = btf__type_by_id(local_btf, local_id);
>         targ_type = btf__type_by_id(targ_btf, targ_id);
> -       if (btf_kind(local_type) != btf_kind(targ_type))
> +       if (!kind_matches_target(local_type, targ_type))
>                 return 0;
>
>  recur:
> @@ -5070,7 +5087,7 @@ static int bpf_core_types_are_compat(const struct
> btf *loc
>         if (!local_type || !targ_type)
>                 return -EINVAL;
>
> -       if (btf_kind(local_type) != btf_kind(targ_type))
> +       if (!kind_matches_target(local_type, targ_type))
>                 return 0;
>
>         switch (btf_kind(local_type)) {
>
>
