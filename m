Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1FF48F441
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 03:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbiAOCCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 21:02:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbiAOCCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 21:02:02 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D097BC061574;
        Fri, 14 Jan 2022 18:02:01 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id i82so14538231ioa.8;
        Fri, 14 Jan 2022 18:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=llJLt2sq5x3ZCKsbnKzT7WnzVaTDpxtG5NsvSspGqrE=;
        b=gQkhCgp8m/VfkXRgEQiHWZNM2vywTcV5spi+Jiu+aa0ZQ7oC9AhMEgB86YovQR4U+Y
         9eJHK4FI7SOCqtSV7UP+sKD2+0TZF5jb+kSW9UB87cEEoAsLVTebfFSVpbnGN1vQuVRX
         stdQArjhCpPjt/LPDdSC8FdEAKg1mkuNNnPqVkwXGwFvbfP71eGpTY5C4zE26sGaHx4w
         jw3InpJW3ExsXHwucnIPTJXR6KK0wgzl5a/aoNU6jNS0iPwquUoQc5PlwOp6jYqUX9hk
         +yAlZRxmoU15gygxnhi3DMv9Xr9eVo+y04tWyjRjtCaWhrp6poviE2WwtOCAmwRq0DDQ
         B0bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=llJLt2sq5x3ZCKsbnKzT7WnzVaTDpxtG5NsvSspGqrE=;
        b=j6W6XjVLMjry1BeL0Mqf/fNgI0vGzPfVDdjHYCnnqH808u6BFzL95IIT16NZUtCMU5
         agSo5pC8ztPZC0NnhkpaQqJK0IWZtmoXEAJytusUya9kdKe5gc73Rv8z8M0RkzZKjoES
         iSJrHpk2pn/tcU/e4qwM++A4H6aQ2D6QdjgZMBB5BG4We/oYqDsw6S7usI8z0TMKcRxH
         4ZlMwwEhiYhg41sCISkQ5FEgXkYw1T4njS4bU8bd18eCxHJkZ4h74n6nE9zTaDO3hIvn
         hYHCQzsXVOQRCljvvt7ZRWVjcEaKS3Sk1QNlbmpiIoanCdCQM4jvjdDGlKWo2G907xdn
         7nwg==
X-Gm-Message-State: AOAM530rDc7aRWqnQeHp7Q0N/VbT4bsLIXUiRl6uzqsHaiy7RZ2biOQf
        Ux+L9TwErwVbYYslGjWn/E2YnCOjd12LaZiJZ38=
X-Google-Smtp-Source: ABdhPJxpfWuku5roF04qOWxIKF+Z0nR8qVS2X/jS8MzowsXDG4Z1hCj6aEikVzHk/Lo5Q5lyEaLk/xfqwUS/i2InNu8=
X-Received: by 2002:a02:bb8d:: with SMTP id g13mr5448871jan.103.1642212120451;
 Fri, 14 Jan 2022 18:02:00 -0800 (PST)
MIME-Version: 1.0
References: <20220112142709.102423-1-mauricio@kinvolk.io> <20220112142709.102423-2-mauricio@kinvolk.io>
In-Reply-To: <20220112142709.102423-2-mauricio@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 14 Jan 2022 18:01:49 -0800
Message-ID: <CAEf4BzYSz99GTNiKMaVPMpOc4Y7YdZLEH1VDy2X4KJkaKbtYfA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/8] libbpf: split bpf_core_apply_relo()
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez?= <mauricio@kinvolk.io>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 6:27 AM Mauricio V=C3=A1squez <mauricio@kinvolk.io>=
 wrote:
>
> BTFGen needs to run the core relocation logic in order to understand
> what are the types in the target BTF that involved in a given
> relocation.
>
> Currently bpf_core_apply_relo() calculates and **applies** a relocation
> to an instruction. Having both operations in the same function makes it
> difficult to only calculate the relocation without patching the
> instruction. This commit splits that logic in two different phases: (1)
> calculate the relocation and (2) patch the instruction.
>
> For the first phase bpf_core_apply_relo() is renamed to
> bpf_core_calc_relo_res() who is now only on charge of calculating the

outdated name?

> relocation, the second phase uses the already existing
> bpf_core_patch_insn(). bpf_object__relocate_core() uses both of them and
> the BTFGen will use only bpf_core_calc_relo_res().

same?


BTW, this patch set breaks CI ([0]), please investigate

  [0] https://github.com/kernel-patches/bpf/runs/4797721812?check_suite_foc=
us=3Dtrue

>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> ---
>  kernel/bpf/btf.c          | 13 ++++--
>  tools/lib/bpf/libbpf.c    | 84 ++++++++++++++++++++++++---------------
>  tools/lib/bpf/relo_core.c | 79 +++++++++++-------------------------
>  tools/lib/bpf/relo_core.h | 42 +++++++++++++++++---
>  4 files changed, 122 insertions(+), 96 deletions(-)
>

[...]

> @@ -5661,12 +5642,53 @@ bpf_object__relocate_core(struct bpf_object *obj,=
 const char *targ_btf_path)
>                         if (!prog->load)
>                                 continue;
>
> -                       err =3D bpf_core_apply_relo(prog, rec, i, obj->bt=
f, cand_cache);
> +                       if (prog->obj->gen_loader) {
> +                               const struct btf_type *local_type;
> +                               const char *local_name, *spec_str;
> +
> +                               spec_str =3D btf__name_by_offset(obj->btf=
, rec->access_str_off);
> +                               if (!spec_str)
> +                                       return -EINVAL;
> +
> +                               local_type =3D btf__type_by_id(obj->btf, =
rec->type_id);
> +                               if (!local_type)
> +                                       return -EINVAL;
> +
> +                               local_name =3D btf__name_by_offset(obj->b=
tf, local_type->name_off);
> +                               if (!local_name)
> +                                       return -EINVAL;
> +
> +                               pr_debug("record_relo_core: prog %td insn=
[%d] %s %s %s final insn_idx %d\n",
> +                                       prog - prog->obj->programs, insn_=
idx,
> +                                       btf_kind_str(local_type), local_n=
ame, spec_str, insn_idx);

hmm, maybe let's just drop this pr_debug instead? that's a lot of code
and checks just to emit this debug info.

> +                               return record_relo_core(prog, rec, insn_i=
dx);
> +                       }
> +
> +                       if (rec->insn_off % BPF_INSN_SZ)
> +                               return -EINVAL;
> +                       insn_idx =3D rec->insn_off / BPF_INSN_SZ;
> +                       /* adjust insn_idx from section frame of referenc=
e to the local
> +                        * program's frame of reference; (sub-)program co=
de is not yet
> +                        * relocated, so it's enough to just subtract in-=
section offset
> +                        */
> +                       insn_idx =3D insn_idx - prog->sec_insn_off;
> +                       if (insn_idx >=3D prog->insns_cnt)
> +                               return -EINVAL;
> +                       insn =3D &prog->insns[insn_idx];
> +

This validation probably is better to do before prog->obj->gen_loader
check so that we don't silently do something bad in record_relo_core()
if insn_idx is wrong? It doesn't change the rest of the logic, right?
So there shouldn't be any harm or change of behavior.

> +                       err =3D bpf_core_resolve_relo(prog, rec, i, obj->=
btf, cand_cache, &targ_res);
>                         if (err) {
>                                 pr_warn("prog '%s': relo #%d: failed to r=
elocate: %d\n",
>                                         prog->name, i, err);
>                                 goto out;
>                         }
> +
> +                       err =3D bpf_core_patch_insn(prog->name, insn, ins=
n_idx, rec, i, &targ_res);
> +                       if (err) {
> +                               pr_warn("prog '%s': relo #%d: failed to p=
atch insn #%u: %d\n",
> +                                       prog->name, i, insn_idx, err);
> +                               goto out;
> +                       }
>                 }
>         }
>

[...]
