Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75E4C1271CF
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 00:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfLSXvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 18:51:10 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:44147 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbfLSXvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 18:51:10 -0500
Received: by mail-qk1-f193.google.com with SMTP id w127so6141676qkb.11;
        Thu, 19 Dec 2019 15:51:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XrJ59tiWQE9MErbGB8Avs3Qqob/Udw2Qp1l0w9c5NOs=;
        b=YqP6JvZXKJNj0g05OnixHUstywAGGOwvGR98BCY5UHBnCqmJ4CZceu7/zl/KL25eTh
         3QqovONJOLNDdIIVaPAlV0048S67yRssvmNSeCO3lXNu4Cp1oxeaJYtRRV4Sy9tUOLAe
         vTfVVwaWh+JLV+jQkxP2PyEUKDOR4CosMAzvQ7i9xTB+D9qmElQSzCnNXsIiiM9vfvAv
         p0ZbWosnPBpVoyad7CFo19JZZUi8/TepA6ULAgrk3m/oSNKwOujsN3NHX+D8BUhcIgJ+
         7qSLKXagcAWU565X3fCEaAIYDsXOnwB+14Pb4yPHit5VYw3izhenhALuW+UTCUPkb/yF
         jbkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XrJ59tiWQE9MErbGB8Avs3Qqob/Udw2Qp1l0w9c5NOs=;
        b=MMdQ3KC15yACuZzb1kQ4VuJYFMS9k9FRUROhLd+WNlSdkMrewGIMxYvYfwQPUOne2r
         CBozlK+JsvYe2JQw/x2mqyZJUlNW6L+lYc0UrVQo2m097LxOyS3M/rSQ/PZKjtnB4tFU
         uCHXlmwTCGW0ymxgJE8f6UBXh/UMhNQ/Q/xSrXdKzcKzMCy7ZFaRvNqngLTg8J4HpUi8
         s2xDcNAKmowF8snOFRv98MsorycJfRuMyPGM7Mtd89YnNkB+/groujlz3ElkKUaJAw4m
         loV3L8HmGEzRAmX3YUp7kKyuOgCYP5EeHm90tHZDSR8mkKpF2j2dYtCG619OfHV25esN
         LGKQ==
X-Gm-Message-State: APjAAAXbYJg+1RBtJh6HZJh85SOt+SvMxFXlPhMlT44OspHtYh87a+b5
        WTmkzB48NFG7yTw+t3Kqc1+UUrGQifVDPrLiqks=
X-Google-Smtp-Source: APXvYqx8iRx0fILDilvpUpFh8/wa422wtk6gaAAbGduPeng/XfncldBLa27iM/LSYyRrQol/aJgP9hIicC5//QbkEoY=
X-Received: by 2002:a37:a685:: with SMTP id p127mr11233546qke.449.1576799468986;
 Thu, 19 Dec 2019 15:51:08 -0800 (PST)
MIME-Version: 1.0
References: <157676577049.957277.3346427306600998172.stgit@toke.dk> <157676577159.957277.7471130922810004500.stgit@toke.dk>
In-Reply-To: <157676577159.957277.7471130922810004500.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 19 Dec 2019 15:50:57 -0800
Message-ID: <CAEf4BzYKpstQk8JO_iOws93VpHEEs+J+z+ZO7cKRiKRNvN1zMg@mail.gmail.com>
Subject: Re: [PATCH RFC bpf-next 1/3] libbpf: Add new bpf_object__load2()
 using new-style opts
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 6:29 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Since we introduced DECLARE_LIBBPF_OPTS and related macros for declaring
> function options, that is now the preferred way to extend APIs. Introduce=
 a
> variant of the bpf_object__load() function that uses this function, and
> deprecate the _xattr variant. Since all the good function names were take=
n,
> the new function is unimaginatively called bpf_object__load2().
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

I've been thinking about options for load quite a bit lately, and I'm
leaning towards an opinion, that bpf_object__load() shouldn't take any
options, and all the various per-bpf_object options have to be
specified in bpf_object_open_opts and stored, if necessary for
load/attach phase. So I'd rather move target_btf_path and log_level to
open_opts instead.

For cases where we need to tune load behavior/options per individual
BPF program, bpf_object_load_opts don't work either way, and we'll
have to add some getters/setters for bpf_program objects, anyways. So
I think it's overall cleaner to specify everything per-bpf_object at
"creation time" (which is open), and keep load()/attach() option-less.

>  tools/lib/bpf/libbpf.c   |   31 ++++++++++++++++++-------------
>  tools/lib/bpf/libbpf.h   |   13 +++++++++++++
>  tools/lib/bpf/libbpf.map |    1 +
>  3 files changed, 32 insertions(+), 13 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index febbaac3daf4..266b725e444b 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4844,15 +4844,12 @@ static int bpf_object__resolve_externs(struct bpf=
_object *obj,
>         return 0;
>  }
>
> -int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
> +int bpf_object__load2(struct bpf_object *obj,
> +                     const struct bpf_object_load_opts *opts)
>  {
> -       struct bpf_object *obj;
>         int err, i;
>
> -       if (!attr)
> -               return -EINVAL;
> -       obj =3D attr->obj;
> -       if (!obj)
> +       if (!obj || !OPTS_VALID(opts, bpf_object_load_opts))
>                 return -EINVAL;
>
>         if (obj->loaded) {
> @@ -4867,8 +4864,10 @@ int bpf_object__load_xattr(struct bpf_object_load_=
attr *attr)
>         err =3D err ? : bpf_object__sanitize_and_load_btf(obj);
>         err =3D err ? : bpf_object__sanitize_maps(obj);
>         err =3D err ? : bpf_object__create_maps(obj);
> -       err =3D err ? : bpf_object__relocate(obj, attr->target_btf_path);
> -       err =3D err ? : bpf_object__load_progs(obj, attr->log_level);
> +       err =3D err ? : bpf_object__relocate(obj,
> +                                          OPTS_GET(opts, target_btf_path=
, NULL));
> +       err =3D err ? : bpf_object__load_progs(obj,
> +                                            OPTS_GET(opts, log_level, 0)=
);
>         if (err)
>                 goto out;
>
> @@ -4884,13 +4883,19 @@ int bpf_object__load_xattr(struct bpf_object_load=
_attr *attr)
>         return err;
>  }
>
> -int bpf_object__load(struct bpf_object *obj)
> +int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
>  {
> -       struct bpf_object_load_attr attr =3D {
> -               .obj =3D obj,
> -       };
> +       DECLARE_LIBBPF_OPTS(bpf_object_load_opts, opts,
> +           .log_level =3D attr->log_level,
> +           .target_btf_path =3D attr->target_btf_path,
> +       );
> +
> +       return bpf_object__load2(attr->obj, &opts);
> +}
>
> -       return bpf_object__load_xattr(&attr);
> +int bpf_object__load(struct bpf_object *obj)
> +{
> +       return bpf_object__load2(obj, NULL);
>  }
>
>  static int make_parent_dir(const char *path)
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index fe592ef48f1b..ce86277d7445 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -132,8 +132,21 @@ struct bpf_object_load_attr {
>         const char *target_btf_path;
>  };
>
> +struct bpf_object_load_opts {
> +       /* size of this struct, for forward/backward compatiblity */
> +       size_t sz;
> +       /* log level on load */
> +       int log_level;
> +       /* BTF path (for CO-RE relocations) */
> +       const char *target_btf_path;
> +};
> +#define bpf_object_load_opts__last_field target_btf_path
> +
>  /* Load/unload object into/from kernel */
>  LIBBPF_API int bpf_object__load(struct bpf_object *obj);
> +LIBBPF_API int bpf_object__load2(struct bpf_object *obj,
> +                                const struct bpf_object_load_opts *opts)=
;
> +/* deprecated, use bpf_object__load2() instead */
>  LIBBPF_API int bpf_object__load_xattr(struct bpf_object_load_attr *attr)=
;
>  LIBBPF_API int bpf_object__unload(struct bpf_object *obj);
>
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index e3a471f38a71..d6cb860763d1 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -217,6 +217,7 @@ LIBBPF_0.0.7 {
>                 bpf_object__attach_skeleton;
>                 bpf_object__destroy_skeleton;
>                 bpf_object__detach_skeleton;
> +               bpf_object__load2;
>                 bpf_object__load_skeleton;
>                 bpf_object__open_skeleton;
>                 bpf_program__attach;
>
