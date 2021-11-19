Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2219457572
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 18:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236575AbhKSR3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 12:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhKSR3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 12:29:19 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D68CC061574;
        Fri, 19 Nov 2021 09:26:17 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id y68so30346197ybe.1;
        Fri, 19 Nov 2021 09:26:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3hR2j1jwMUEyIgd4hrA+gxpK9gueB3esVgn2t0/TazQ=;
        b=NceeadjCDFzZkDsl1jzoJz+6NJ1o0GRyqItaIQnffk0nVYN+gcxx+kSpPd3rIpTpv6
         lbDEByQhqvzW3Kf1SJwPqD4Ms0tm0TF3otpEQbxqqgEjlhR1G9M1SQqhwr54zdpML3YO
         LkQtHSdTkpGtI2cJ43Oc/nAvEtmKXaCCPS5mVYzCdrSgcd//PivyScecskcvrz6x77at
         MV8y1EUwMWmBBZFqd+Lb+Lz7GM9cVoscQ6fGPzPcNART1ZrkTfYQbyFz1sWwfOOr+R1J
         /jnNMzjbLwpYY8a7N/6qYQMiCDbcH4zPx8YBBBP+cNfWzv66YILHawU3XfgFKNC8mIwh
         Monw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3hR2j1jwMUEyIgd4hrA+gxpK9gueB3esVgn2t0/TazQ=;
        b=5fTbe9Am6m91M4+ieAHkAoVIrIaWcEyEFiFfx9CAwlfTNAAlrjXCdZ3S/Ijb/7IWLr
         4WjHGABG8zExR6llVI5HLX7AfYYdXbvCj//DfnhMqYR/RlF9q0MianWbccd6XWJC27lA
         twuI3GmVblVydBpR2oZq2EpY3u9+XSqST1YkQWQUzuj9/btHIR/b1mvNZQWGC65pjwLC
         0XYplEs9VHFNf07FxJMvmY3Lifj6Qvoc5Qdrtg8etmrygSaRLZR28/DLA5Mys6tFFhoK
         JXEkP+efEP1V3YhZ3aMRqPvtl+cBHKWBoFQtF2PgE9jqJS6xP9G86ri97Lyb6imRfbkI
         zmsg==
X-Gm-Message-State: AOAM5334DY3+aNeAMi3qjfhdMEW/cBSiy8VentN7JPLS3on9A1tFBMkx
        8v/YmhpSdJjeYj9lnjIEAtbKWj6n3Oz3GaYb0Q8=
X-Google-Smtp-Source: ABdhPJxZAHF971HBE+n74FnANZ/xH0HqZpyCDZjLb4VnckrnZw7QvbCiw5U8k/1S8VW48LiUcGXAN8a3lpspQcFoz9c=
X-Received: by 2002:a25:afcd:: with SMTP id d13mr39353978ybj.504.1637342776429;
 Fri, 19 Nov 2021 09:26:16 -0800 (PST)
MIME-Version: 1.0
References: <20211116164208.164245-1-mauricio@kinvolk.io> <20211116164208.164245-4-mauricio@kinvolk.io>
In-Reply-To: <20211116164208.164245-4-mauricio@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 19 Nov 2021 09:26:05 -0800
Message-ID: <CAEf4BzaD1rxWztzokQJu7X5papVqYncMHXZEThaXYeSADo6h2g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/4] libbpf: Introduce 'bpf_object__prepare()'
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez?= <mauricio@kinvolk.io>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 8:42 AM Mauricio V=C3=A1squez <mauricio@kinvolk.io>=
 wrote:
>
> BTFGen[0] requires access to the result of the CO-RE relocations without
> actually loading the bpf programs. The current libbpf API doesn't allow
> it because all the object preparation (subprogs, relocations: co-re,
> elf, maps) happens inside bpf_object__load().
>
> This commit introduces a new bpf_object__prepare() function to perform
> all the preparation steps than an ebpf object requires, allowing users
> to access the result of those preparation steps without having to load
> the program. Almost all the steps that were done in bpf_object__load()
> are now done in bpf_object__prepare(), except map creation and program
> loading.
>
> Map relocations require a bit more attention as maps are only created in
> bpf_object__load(). For this reason bpf_object__prepare() relocates maps
> using BPF_PSEUDO_MAP_IDX, if someone dumps the instructions before
> loading the program they get something meaningful. Map relocations are
> completed in bpf_object__load() once the maps are created and we have
> their fd to use with BPF_PSEUDO_MAP_FD.
>
> Users won=E2=80=99t see any visible changes if they=E2=80=99re using bpf_=
object__open()
> + bpf_object__load() because this commit keeps backwards compatibility
> by calling bpf_object__prepare() in bpf_object_load() if it wasn=E2=80=99=
t
> called by the user.
>
> bpf_object__prepare_xattr() is not implemented as their counterpart
> bpf_object__load_xattr() will be deprecated[1]. New options will be
> added only to bpf_object_open_opts.
>
> [0]: https://github.com/kinvolk/btfgen/
> [1]: https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#libbp=
fh-high-level-apis
>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> ---

Most of the comments are irrelevant after my comments on patch #4, but
still sending them out for the sake of completeness.

>  tools/lib/bpf/libbpf.c   | 130 ++++++++++++++++++++++++++++-----------
>  tools/lib/bpf/libbpf.h   |   2 +
>  tools/lib/bpf/libbpf.map |   1 +
>  3 files changed, 98 insertions(+), 35 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 6ca76365c6da..f50f9428bb03 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -514,6 +514,7 @@ struct bpf_object {
>         int nr_extern;
>         int kconfig_map_idx;
>
> +       bool prepared;
>         bool loaded;

let's turn `bool loaded` into an enum to represent the stage of a
bpf_object, as there is a strict sequence of state transitions.

>         bool has_subcalls;
>         bool has_rodata;

[...]

> +static int __bpf_object__prepare(struct bpf_object *obj, int log_level,
> +                                const char *target_btf_path)
> +{
> +       int err;
> +
> +       if (obj->prepared) {
> +               pr_warn("object '%s': prepare can't be attempted twice\n"=
, obj->name);
> +               return libbpf_err(-EINVAL);
> +       }
> +
> +       if (obj->gen_loader)
> +               bpf_gen__init(obj->gen_loader, log_level);
> +
> +       err =3D bpf_object__probe_loading(obj);
> +       err =3D err ? : bpf_object__load_vmlinux_btf(obj, false);
> +       err =3D err ? : bpf_object__resolve_externs(obj, obj->kconfig);
> +       err =3D err ? : bpf_object__sanitize_and_load_btf(obj);
> +       err =3D err ? : bpf_object__sanitize_maps(obj);
> +       err =3D err ? : bpf_object__init_kern_struct_ops_maps(obj);
> +       err =3D err ? : bpf_object__relocate(obj, obj->btf_custom_path ? =
: target_btf_path);
> +

I think only load_vmlinux_btf and relocations should happen in prepare
phase. resolve_externs might fail if you don't run it on target system
(non-weak extern that's missing will error out). There is no need to
load and sanitize BTFs or sanitize maps either. struct_ops can't work
on the kernel that doesn't have BTF enabled, so BTFgen won't help
there, so it's fine to move it to load phase as well.

We need to move relocations way earlier, right after load_vmlinux_btf
(and move probe_loading to load phase, of course) and perform them in
preparation phase. We can also split relocation into individual steps
and do map relocations in the load phase, so you won't have to do the
dance with map_idx (and given it's internal process, we can always
change our mind later and rework it, if necessary; but for now let's
keep things simple).

> +       obj->prepared =3D true;
> +
> +       return err;
> +}
> +
> +LIBBPF_API int bpf_object__prepare(struct bpf_object *obj)

LIBBPF_API is used only in header files

> +{
> +       if (!obj)
> +               return libbpf_err(-EINVAL);

if someone passes NULL pointer instead of obj, then it's a completely
inappropriate use of libbpf APIs. No need to check for that (we don't
in a lot of APIs for sure).

> +       return __bpf_object__prepare(obj, 0, NULL);
> +}
> +
>  int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
>  {
>         struct bpf_object *obj;

[...]
