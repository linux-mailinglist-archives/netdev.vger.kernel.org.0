Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE9A45756F
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 18:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236582AbhKSR2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 12:28:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhKSR2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 12:28:30 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DD5C061574;
        Fri, 19 Nov 2021 09:25:28 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id v7so30436517ybq.0;
        Fri, 19 Nov 2021 09:25:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uQDd2jJP4FhgbEt2hnJnBcOv7NF/WnkFpQelaMEiK5w=;
        b=ZHtD8NkEzunPDpV3rgqQDBNgecJ6T3psKFjH/R98PvhW4xskQhz60BxKlStiNUjpjp
         UjNIeK96GKtvTx9kWrUKBegQek8k9eMKhRCb9WgOHj31cDQoBY5RckTcqBsv0fF3+UXI
         m7Ms/9zY9iLNzC8gPuGA/rf6Qtn7jrwIg/07yuCfDXtl9j76C3BzKbvO8j2rR/hzCcHn
         WjKGruwCTEwE/Vsq0VqKZFQUxZOKJDCQoNH+PAXQL/tbFDppiXuqAZHR7BfeJtxoh2Y5
         GV3wWGRdgQ0Usbrjli+u6jnlBm3QxaWAWMgrlbGKPIjvnQLengEWMea9+L5jMM8vX46v
         GdEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uQDd2jJP4FhgbEt2hnJnBcOv7NF/WnkFpQelaMEiK5w=;
        b=8Kh6QHtGAEbLHgqL37RMB9skZ3vuiEaDOFTzC+UtQiAz8qXgkbsrZlm/sNS1dmNGVo
         WGjRU0qYwqmfjxO7Yaq1RaJzy26MHd6g147Ouvnb6RjmB/kuUzGEXWr6M+oPFWBCbvkO
         CiBhn5FiZEu9NBNfdwM3o9pSUzh5SCtTlgEcGYwYLitrvsZljonMnF9ZLQNbRivDX5oN
         REEsvUgnHNFuuw5iUsneczxYpxg15bYEl1BzDWPTyKC/F1ZM+rWLm19PQA5pWiBtLzdg
         J69m5PuNLakHIEQnHmhPcskyIbaZ37SU1MhEE5uW16pA4H9pqo5g1nVPMVRgTCcXTgoU
         k/qg==
X-Gm-Message-State: AOAM532uJbysQ2XLvtnQJOji1/ZxatSCImbTg6foiNiVewvKzCrnvHXx
        JIOm55Mq8ZIwSerRM9H6rbfcKIuwMthy/a4p4tTKsLZK
X-Google-Smtp-Source: ABdhPJx1DbcrI40j0F1F9/UWs3ERAhVI1/oOPkuhr5UIbJIavR4RlA7Rp5UIyfthrv5dQAeCiZF/HmSajWy/hCY73pY=
X-Received: by 2002:a25:d187:: with SMTP id i129mr38422646ybg.2.1637342727537;
 Fri, 19 Nov 2021 09:25:27 -0800 (PST)
MIME-Version: 1.0
References: <20211116164208.164245-1-mauricio@kinvolk.io> <20211116164208.164245-3-mauricio@kinvolk.io>
In-Reply-To: <20211116164208.164245-3-mauricio@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 19 Nov 2021 09:25:16 -0800
Message-ID: <CAEf4BzZL_7dGmuzt-weids8FMJc5Tph+-om2d9zgQGvd+yC82Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/4] libbpf: Introduce 'btf_custom' to 'bpf_obj_open_opts'
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
> Commit 1373ff599556 ("libbpf: Introduce 'btf_custom_path' to
> 'bpf_obj_open_opts'") introduced btf_custom_path which allows developers
> to specify a BTF file path to be used for CO-RE relocations. This
> implementation parses and releases the BTF file for each bpf object.
>
> This commit introduces a new 'btf_custom' option to allow users to
> specify directly the btf object instead of the path. This avoids
> parsing/releasing the same BTF file multiple times when the application
> loads multiple bpf objects.
>
> Our specific use case is BTFGen[0], where we want to reuse the same BTF
> file with multiple bpf objects. In this case passing btf_custom_path is
> not only inefficient but it also complicates the implementation as we
> want to save pointers of BTF types but they are invalidated after the
> bpf object is closed with bpf_object__close().

How much slower and harder is it in practice, though? Can you please
provide some numbers? How many objects are going to reuse the same
struct btf? Parsing raw BTF file is quite efficient, I'm curious
what's the scale where this becomes unacceptable.


>
> [0]: https://github.com/kinvolk/btfgen/
>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> ---
>  tools/lib/bpf/libbpf.c | 20 ++++++++++++++++----
>  tools/lib/bpf/libbpf.h |  9 ++++++++-
>  2 files changed, 24 insertions(+), 5 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index de7e09a6b5ec..6ca76365c6da 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -542,6 +542,8 @@ struct bpf_object {
>         char *btf_custom_path;
>         /* vmlinux BTF override for CO-RE relocations */
>         struct btf *btf_vmlinux_override;
> +       /* true when the user provided the btf structure with the btf_cus=
tom opt */
> +       bool user_provided_btf_vmlinux;
>         /* Lazily initialized kernel module BTFs */
>         struct module_btf *btf_modules;
>         bool btf_modules_loaded;
> @@ -2886,7 +2888,7 @@ static int bpf_object__load_vmlinux_btf(struct bpf_=
object *obj, bool force)
>         int err;
>
>         /* btf_vmlinux could be loaded earlier */
> -       if (obj->btf_vmlinux || obj->gen_loader)
> +       if (obj->btf_vmlinux || obj->btf_vmlinux_override || obj->gen_loa=
der)
>                 return 0;
>
>         if (!force && !obj_needs_vmlinux_btf(obj))
> @@ -5474,7 +5476,7 @@ bpf_object__relocate_core(struct bpf_object *obj, c=
onst char *targ_btf_path)
>         if (obj->btf_ext->core_relo_info.len =3D=3D 0)
>                 return 0;
>
> -       if (targ_btf_path) {
> +       if (!obj->user_provided_btf_vmlinux && targ_btf_path) {
>                 obj->btf_vmlinux_override =3D btf__parse(targ_btf_path, N=
ULL);
>                 err =3D libbpf_get_error(obj->btf_vmlinux_override);
>                 if (err) {
> @@ -5543,8 +5545,10 @@ bpf_object__relocate_core(struct bpf_object *obj, =
const char *targ_btf_path)
>
>  out:
>         /* obj->btf_vmlinux and module BTFs are freed after object load *=
/
> -       btf__free(obj->btf_vmlinux_override);
> -       obj->btf_vmlinux_override =3D NULL;
> +       if (!obj->user_provided_btf_vmlinux) {
> +               btf__free(obj->btf_vmlinux_override);
> +               obj->btf_vmlinux_override =3D NULL;
> +       }
>
>         if (!IS_ERR_OR_NULL(cand_cache)) {
>                 hashmap__for_each_entry(cand_cache, entry, i) {
> @@ -6767,6 +6771,10 @@ __bpf_object__open(const char *path, const void *o=
bj_buf, size_t obj_buf_sz,
>         if (!OPTS_VALID(opts, bpf_object_open_opts))
>                 return ERR_PTR(-EINVAL);
>
> +       /* btf_custom_path and btf_custom can't be used together */
> +       if (OPTS_GET(opts, btf_custom_path, NULL) && OPTS_GET(opts, btf_c=
ustom, NULL))
> +               return ERR_PTR(-EINVAL);
> +
>         obj_name =3D OPTS_GET(opts, object_name, NULL);
>         if (obj_buf) {
>                 if (!obj_name) {
> @@ -6796,6 +6804,10 @@ __bpf_object__open(const char *path, const void *o=
bj_buf, size_t obj_buf_sz,
>                 }
>         }
>
> +       obj->btf_vmlinux_override =3D OPTS_GET(opts, btf_custom, NULL);
> +       if (obj->btf_vmlinux_override)
> +               obj->user_provided_btf_vmlinux =3D true;
> +
>         kconfig =3D OPTS_GET(opts, kconfig, NULL);
>         if (kconfig) {
>                 obj->kconfig =3D strdup(kconfig);
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 4ec69f224342..908ab04dc9bd 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -104,8 +104,15 @@ struct bpf_object_open_opts {
>          * struct_ops, etc) will need actual kernel BTF at /sys/kernel/bt=
f/vmlinux.
>          */
>         const char *btf_custom_path;
> +       /* Pointer to the custom BTF object to be used for BPF CO-RE relo=
cations.
> +        * This custom BTF completely replaces the use of vmlinux BTF
> +        * for the purpose of CO-RE relocations.
> +        * NOTE: any other BPF feature (e.g., fentry/fexit programs,
> +        * struct_ops, etc) will need actual kernel BTF at /sys/kernel/bt=
f/vmlinux.
> +        */
> +       struct btf *btf_custom;
>  };
> -#define bpf_object_open_opts__last_field btf_custom_path
> +#define bpf_object_open_opts__last_field btf_custom
>
>  LIBBPF_API struct bpf_object *bpf_object__open(const char *path);
>  LIBBPF_API struct bpf_object *
> --
> 2.25.1
>
