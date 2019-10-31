Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D72BEB63B
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 18:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbfJaRhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 13:37:38 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:38048 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728988AbfJaRhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 13:37:37 -0400
Received: by mail-qk1-f195.google.com with SMTP id e2so7871577qkn.5;
        Thu, 31 Oct 2019 10:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=e+VYZZnLKZGTMRc5D6Xzedv4GtgENJ5DgDtFjihyewQ=;
        b=JImKNmG/pWuGerdRv1Ox2WtKApORw5Achm8+OuX34P/x3HbiQe75Dntg2SB99+Obkc
         ptT+7o2fbmvv/u0d+T/aleFM1IHWMwPCQPoP6o5WlQ0w2eCeLVEMwPCM+MQnhPUXQwz3
         QhPNx0uR/DM4OueVR8bZvxjSfeuClCt2hJv1P03UAw+uH26pbm8JHTdxD73ouXfy3yWr
         wwviLtfyEVpwpkeC5dgGIy6aEsWdjdwcYk+9dq+n6VYQKjsRAJaxDqFBbQKwpcI+CM0I
         kNFHR9M1OfrRKWY7XNy1hX01E6miYK++s1zsYBq28srJ3tNjRQrYr9kYuTzJ27t0enJc
         UQvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=e+VYZZnLKZGTMRc5D6Xzedv4GtgENJ5DgDtFjihyewQ=;
        b=UEHL3Hpln3yMj/6EOhm1C2HOmiMAm3z8Via+0f4vqKQjduoLtbzcXLb2E28BH1r3rP
         8EjoVcQs1vqaDe1nnzGijJOdck5qXUW/LAGC3pKk5jz7u4i326PDldKPBkt3hgqcLI7q
         +bBnSa3zOIaKkr/qt9gNEVKV0ZYWOz8wpBDZQyG1UF3s9zZDuIQ5L7sw9G5++TZ699k3
         74Vx6526E3aUPIY4QETkMW97HjVDK5QO7uAGdhvzLHRwhaQAipVDXo/rMtQC3ddIJ2cO
         Dxdy1XeqQG88ZMCd6pQ8EMk4q/bzxUMosPju/rjk1RRcTw2/O9CeeWS+fIa/+LhVpng2
         E4NQ==
X-Gm-Message-State: APjAAAXYK3txme0nBFzP9Va6gTJrRo3/TCBItpO0WxU/ivHZ7qju+17O
        6UWCK5/lmv50VWwC13DI3DX1FMYYu6qFzuiqfgQ=
X-Google-Smtp-Source: APXvYqwMWbhd7WlgCDxrWAPg3nFOMaAMB2c+51rxudCb7jHEWHbodl5Kr+86D4efx+H8YqDKiUPqsz5W1uz6slsGWls=
X-Received: by 2002:a37:8f83:: with SMTP id r125mr1680272qkd.36.1572543456135;
 Thu, 31 Oct 2019 10:37:36 -0700 (PDT)
MIME-Version: 1.0
References: <157237796219.169521.2129132883251452764.stgit@toke.dk> <157237796671.169521.11697832576102917566.stgit@toke.dk>
In-Reply-To: <157237796671.169521.11697832576102917566.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 31 Oct 2019 10:37:25 -0700
Message-ID: <CAEf4BzYsFGm4BzFxcN37KVtjS0Zw0Zgw8on9OsP4_=Stew72Nw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 4/5] libbpf: Add auto-pinning of maps when
 loading BPF objects
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

On Tue, Oct 29, 2019 at 12:39 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> This adds support to libbpf for setting map pinning information as part o=
f
> the BTF map declaration, to get automatic map pinning (and reuse) on load=
.
> The pinning type currently only supports a single PIN_BY_NAME mode, where
> each map will be pinned by its name in a path that can be overridden, but
> defaults to /sys/fs/bpf.
>
> Since auto-pinning only does something if any maps actually have a
> 'pinning' BTF attribute set, we default the new option to enabled, on the
> assumption that seamless pinning is what most callers want.
>
> When a map has a pin_path set at load time, libbpf will compare the map
> pinned at that location (if any), and if the attributes match, will re-us=
e
> that map instead of creating a new one. If no existing map is found, the
> newly created map will instead be pinned at the location.
>
> Programs wanting to customise the pinning can override the pinning paths
> using bpf_map__set_pin_path() before calling bpf_object__load() (includin=
g
> setting it to NULL to disable pinning of a particular map).
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Please fix unconditional pin_path setting, with that:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/bpf_helpers.h |    6 ++
>  tools/lib/bpf/libbpf.c      |  144 +++++++++++++++++++++++++++++++++++++=
++++--
>  tools/lib/bpf/libbpf.h      |   13 ++++
>  3 files changed, 154 insertions(+), 9 deletions(-)
>
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index 2203595f38c3..0c7d28292898 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -38,4 +38,10 @@ struct bpf_map_def {
>         unsigned int map_flags;
>  };
>

[...]

> @@ -1270,6 +1292,28 @@ static int bpf_object__init_user_btf_map(struct bp=
f_object *obj,
>                         }
>                         map->def.value_size =3D sz;
>                         map->btf_value_type_id =3D t->type;
> +               } else if (strcmp(name, "pinning") =3D=3D 0) {
> +                       __u32 val;
> +                       int err;
> +
> +                       if (!get_map_field_int(map_name, obj->btf, def, m=
,
> +                                              &val))
> +                               return -EINVAL;
> +                       pr_debug("map '%s': found pinning =3D %u.\n",
> +                                map_name, val);
> +
> +                       if (val !=3D LIBBPF_PIN_NONE &&
> +                           val !=3D LIBBPF_PIN_BY_NAME) {
> +                               pr_warn("map '%s': invalid pinning value =
%u.\n",
> +                                       map_name, val);
> +                               return -EINVAL;
> +                       }
> +                       err =3D build_map_pin_path(map, pin_root_path);

uhm... only if (val =3D=3D LIBBPF_PIN_BY_NAME)?.. maybe extend tests with
a mix if auto-pinned and never pinned map to catch issue like this?

> +                       if (err) {
> +                               pr_warn("map '%s': couldn't build pin pat=
h.\n",
> +                                       map_name);
> +                               return err;
> +                       }
>                 } else {
>                         if (strict) {
>                                 pr_warn("map '%s': unknown field '%s'.\n"=
,
> @@ -1289,7 +1333,8 @@ static int bpf_object__init_user_btf_map(struct bpf=
_object *obj,
>         return 0;
>  }
>

[...]
