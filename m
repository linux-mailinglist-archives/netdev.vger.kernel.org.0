Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 524013C6735
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 01:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbhGLX4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 19:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232562AbhGLX4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 19:56:23 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D05C0613DD;
        Mon, 12 Jul 2021 16:53:33 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id i18so31746248yba.13;
        Mon, 12 Jul 2021 16:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6Bkmy9ikEKAYb92VgPQbIXHePbgsu1WFm/WeBd69/4A=;
        b=cPaqVmnwtP+G0MZJ6zLxaDgpqP6o+w8dr4IzfoL4N/XVoWNaCVMpIh5/whPjZ/JPVR
         kLh4QgwvC0IPTbjmGz7SXdljKRULl1JcGXsk3S1EcfmLvH86SPjYF9+ZQsjhwqjeayx/
         eqHhbA7q49yDe6D6ukHwd4QttV5/76YRqDfvc2BmanFhzrGP7cn+h5Y0SHypT9zsjHQB
         gyYhugr9nZSHNG8bCzDeiClAGbOPDkmWNwuuvOeF8R8iETV6LoJP68oX5I1MF0FSazfN
         ls9un2jtQvNUKkc5d8WWbr9cZybFZPEsLRr6YcQ6S91n2KxlAK3HJ5f7VeLkIifXp1FV
         Zz1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6Bkmy9ikEKAYb92VgPQbIXHePbgsu1WFm/WeBd69/4A=;
        b=E+debvv9HXQY61pYcGv+iVSRmzdp/Z5Byh+SNRHf1ZmA9Qs8v1u3z4ud844xePmXp/
         U6ZNhVyoi8OWtMt1bB6LWHjr610MkIpHJilkb2s5fvVVdTZ3Yl2wuqQG0KDOq812M6FS
         XGL94+kWwJAbAFD5cfcAtt8qeYxWDD+29txucUgOhODGR+WYclqnOHXt5byYtwqCn4Eg
         iNTs1P4zQI36+nQfYDy864vdLcZGw+YauMhbFAwj5Eee7K/Sp3F7dfSsYmxsaKgv8mB9
         oI65F5KDD4H1JBMmv9FzsGzgMLfuDcV8PDRXlWWI4gdPJNqhyvTSOM88ibfQdK8uZCiL
         1Tbg==
X-Gm-Message-State: AOAM533iOejpyuqiJlkCK73k8FmF75U549gmqgCUZeAqH4gGtrvgc1R9
        xHrjrMAvBwI5H84M4CniaRSdsJZO9O345vz7q9I=
X-Google-Smtp-Source: ABdhPJwbZUR23qP1SL8nI0WBTvLTw1J1fo3TB5F0rBlL02dVCWfB9Xn1BujMLkveBaLWj/C3IJqFKQfMt9zEQ1gjoXc=
X-Received: by 2002:a25:3787:: with SMTP id e129mr1985915yba.459.1626134012573;
 Mon, 12 Jul 2021 16:53:32 -0700 (PDT)
MIME-Version: 1.0
References: <1625798873-55442-1-git-send-email-chengshuyi@linux.alibaba.com> <1625798873-55442-2-git-send-email-chengshuyi@linux.alibaba.com>
In-Reply-To: <1625798873-55442-2-git-send-email-chengshuyi@linux.alibaba.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 12 Jul 2021 16:53:21 -0700
Message-ID: <CAEf4BzZaAQzwY1q5isvN5hM2eeA9NB8c_rftJ-czSWmyJLYbkA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/2] libbpf: Introduce 'btf_custom_path' to 'bpf_obj_open_opts'
To:     Shuyi Cheng <chengshuyi@linux.alibaba.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 8, 2021 at 7:48 PM Shuyi Cheng <chengshuyi@linux.alibaba.com> wrote:
>
> btf_custom_path allows developers to load custom BTF, and subsequent
> CO-RE will use custom BTF for relocation.
>
> Learn from Andrii's comments in [0], add the btf_custom_path parameter
> to bpf_obj_open_opts, you can directly use the skeleton's
> <objname>_bpf__open_opts function to pass in the btf_custom_path
> parameter.
>
> Prior to this, there was also a developer who provided a patch with
> similar functions. It is a pity that the follow-up did not continue to
> advance. See [1].
>
>         [0]https://lore.kernel.org/bpf/CAEf4BzbJZLjNoiK8_VfeVg_Vrg=9iYFv+po-38SMe=UzwDKJ=Q@mail.gmail.com/#t
>         [1]https://yhbt.net/lore/all/CAEf4Bzbgw49w2PtowsrzKQNcxD4fZRE6AKByX-5-dMo-+oWHHA@mail.gmail.com/
>
> Signed-off-by: Shuyi Cheng <chengshuyi@linux.alibaba.com>
> ---
>  tools/lib/bpf/libbpf.c | 46 ++++++++++++++++++++++++++++++++++++++++++++--
>  tools/lib/bpf/libbpf.h |  6 +++++-
>  2 files changed, 49 insertions(+), 3 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 1e04ce7..6702b7f 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -498,6 +498,10 @@ struct bpf_object {
>          * it at load time.
>          */
>         struct btf *btf_vmlinux;
> +       /* custom BTF is in addition to vmlinux BTF (i.e., Use the CO-RE
> +        * feature in the old kernel).
> +        */

nit: "path to custom BTF used for CO-RE relocations" as a description?

> +       char *btf_custom_path;
>         /* vmlinux BTF override for CO-RE relocations */
>         struct btf *btf_vmlinux_override;
>         /* Lazily initialized kernel module BTFs */
> @@ -2668,6 +2672,27 @@ static bool obj_needs_vmlinux_btf(const struct bpf_object *obj)
>         return false;
>  }
>
> +static int bpf_object__load_override_btf(struct bpf_object *obj)
> +{
> +       int err;
> +
> +       if (obj->btf_vmlinux_override)
> +               return 0;
> +
> +       if (!obj->btf_custom_path)
> +               return 0;
> +
> +       obj->btf_vmlinux_override = btf__parse(obj->btf_custom_path, NULL);
> +       err = libbpf_get_error(obj->btf_vmlinux_override);
> +       pr_debug("loading custom BTF '%s': %d\n", obj->btf_custom_path, err);
> +       if (err) {
> +               pr_warn("failed to parse custom BTF\n");
> +               obj->btf_vmlinux_override = NULL;
> +       }
> +
> +       return err;
> +}

see below, I don't think we need this function

> +
>  static int bpf_object__load_vmlinux_btf(struct bpf_object *obj, bool force)
>  {
>         int err;
> @@ -7554,7 +7579,7 @@ int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
>  __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
>                    const struct bpf_object_open_opts *opts)
>  {
> -       const char *obj_name, *kconfig;
> +       const char *obj_name, *kconfig, *btf_tmp_path;
>         struct bpf_program *prog;
>         struct bpf_object *obj;
>         char tmp_name[64];
> @@ -7584,6 +7609,19 @@ int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
>         obj = bpf_object__new(path, obj_buf, obj_buf_sz, obj_name);
>         if (IS_ERR(obj))
>                 return obj;
> +
> +       btf_tmp_path = OPTS_GET(opts, btf_custom_path, NULL);
> +       if (btf_tmp_path) {
> +               if (strlen(btf_tmp_path) >= PATH_MAX) {
> +                       err = -ENAMETOOLONG;
> +                       goto out;
> +               }
> +               obj->btf_custom_path = strdup(btf_tmp_path);
> +               if (!obj->btf_custom_path) {
> +                       err = -ENOMEM;
> +                       goto out;
> +               }
> +       }

this part looks good

>
>         kconfig = OPTS_GET(opts, kconfig, NULL);
>         if (kconfig) {
> @@ -8049,6 +8087,7 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
>                 bpf_gen__init(obj->gen_loader, attr->log_level);
>
>         err = bpf_object__probe_loading(obj);
> +       err = err ? : bpf_object__load_override_btf(obj);

btf_vmlinux_override is already working properly, so all you need to
do here (once you remembered btf_custom_path) is to pass it to
bpf_object__relocate. All the rest is taken care of, so you don't need
to add extra cleanup (except for zfree(btf_custom_path)).

>         err = err ? : bpf_object__load_vmlinux_btf(obj, false);
>         err = err ? : bpf_object__resolve_externs(obj, obj->kconfig);
>         err = err ? : bpf_object__sanitize_and_load_btf(obj);

so few lines below this code, after bpf_object__create_maps(obj):

err = err ? : bpf_object__relocate(obj, obj->btf_custom_path ?:
attr->target_btf_path);

This way open_opts->btf_custom_path serves as an override for
load_attr's target_btf_path (which we are going to deprecate anyways).

The only remaining thing is to make sure that
bpf_object__load_vmlinux_btf() won't attempt to load real vmlinux BTF
*just for CO-RE*. So in  obj_needs_vmlinux_btf() make sure to not
return true for CO-RE relocations if custom_btf_path is specified (see
Vamsi's patch which has this logic already).

> @@ -8075,9 +8114,11 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
>         }
>         free(obj->btf_modules);
>
> -       /* clean up vmlinux BTF */
> +       /* clean up vmlinux BTF and custom BTF*/
>         btf__free(obj->btf_vmlinux);
>         obj->btf_vmlinux = NULL;
> +       btf__free(obj->btf_vmlinux_override);
> +       obj->btf_vmlinux_override = NULL;

this shouldn't be necessary, bpf_object__relocate_core() handled this

>
>         obj->loaded = true; /* doesn't matter if successfully or not */
>
> @@ -8702,6 +8743,7 @@ void bpf_object__close(struct bpf_object *obj)
>         for (i = 0; i < obj->nr_maps; i++)
>                 bpf_map__destroy(&obj->maps[i]);
>
> +       zfree(&obj->btf_custom_path);
>         zfree(&obj->kconfig);
>         zfree(&obj->externs);
>         obj->nr_extern = 0;
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 6e61342..5002d1f 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -94,8 +94,12 @@ struct bpf_object_open_opts {
>          * system Kconfig for CONFIG_xxx externs.
>          */
>         const char *kconfig;
> +       /* custom BTF is in addition to vmlinux BTF (i.e., Use the CO-RE
> +        * feature in the old kernel).

Instead of "Use the CO-RE feature in the old kernel", let's point out
explicitly that this custom BTF is used *only* for CO-RE, and any
other feature that relies on kernel BTF will still need actual vmlinux
BTF. Something like this:

/* Path to the custom BTF to be used for BPF CO-RE relocations.
 * This custom BTF completely replaces the use of vmlinux BTF
 * for the purpose of CO-RE relocations.
 * NOTE: any other BPF feature (e.g., fentry/fexit programs,
 * struct_ops, etc) will need actual kernel BTF at /sys/kernel/btf/vmlinux.
 */

I think this will make it much clearer what's the intended purpose here.

> +        */
> +       char *btf_custom_path;
>  };
> -#define bpf_object_open_opts__last_field kconfig
> +#define bpf_object_open_opts__last_field btf_custom_path
>
>  LIBBPF_API struct bpf_object *bpf_object__open(const char *path);
>  LIBBPF_API struct bpf_object *
> --
> 1.8.3.1
>
