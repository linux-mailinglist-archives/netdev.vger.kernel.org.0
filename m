Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68C5DE41B6
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 04:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390650AbfJYCqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 22:46:44 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36638 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728416AbfJYCqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 22:46:44 -0400
Received: by mail-qt1-f193.google.com with SMTP id d17so1140361qto.3;
        Thu, 24 Oct 2019 19:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Uk0O+1Wy0f1d6NdxP+VRsck/NtQSLTDySSKs+mdVowY=;
        b=PuXQ0KCnl2P4yaeHfvqSabFoaJBb7wgVu0ce9SZksqs7DKyR9UZj6NHadNaRAVfrs6
         sdI1NgXt7wn1EC6VEzpOjtZXQzJYp8bN/3+AnzGNBHwtitcKpR0RAkyEaoXfZRciHQyJ
         VIJgBJyclempLkkOYILP7ilPVscM3zd146VNL69sdN5CHRy8NskNV4CiNIB9LsO3ohJ8
         fUdBo8k+XZFNKLlqr8ISVYPTEHAVZ0kr3rRLBMnjHDguXZZQstvXAKx3mMka3DA5CBes
         f/TrCXdtq4aq80UJAyEndBv2dpUICBwBYekaca+wRBoLfqaXbe6TK2OLiPLHFrazaTN1
         C9xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Uk0O+1Wy0f1d6NdxP+VRsck/NtQSLTDySSKs+mdVowY=;
        b=QNHi8gA2cEJstmMs6xJgBQu8Loj1m4N9blhkSO0Vp8vv5IBCVS07DBTPGknRxiDi1j
         vysv0XE+v7tQtFEe5yC+i46qTv/5Ub2H8s2j/TTLIbT0j9LMsILIsQDDcQYDI65XV/nT
         HsGiKCAqDSYLXLpVc3ypespnC/Q226kGmiN2IVfQEtWxEbXZPNV7TvwzlOocf8pJfGDO
         Fwov7Lt/IDyikKmHCa9nPmBLUrmDFHgCXYXkU44ki2hNAOcqHdQQPE7b9oYJ6kgm1HF+
         77qUGsC/w0HkEGebTMFh8RTZq3YFjGcFu1hjswXsffciaXgZYnMMplLaSkUflmoXpT+z
         /JBg==
X-Gm-Message-State: APjAAAXz9LdOGOPEMiMzbHKQtAoFiXS0jbKnTilALCthshSUk1UncjiW
        ZdXeody86B4MMeY2sU+n3bj+NjVelKrF7XvgvCE=
X-Google-Smtp-Source: APXvYqzZFlki7XvE0PhidpQ6wNk28XXjDGbkhyCAkn+YCRu/7+ZaMJy37cwTVv+GgZmDMSbrU2cH3JsyjF0BYqpTJTU=
X-Received: by 2002:ac8:66d9:: with SMTP id m25mr886913qtp.117.1571971603014;
 Thu, 24 Oct 2019 19:46:43 -0700 (PDT)
MIME-Version: 1.0
References: <157192269744.234778.11792009511322809519.stgit@toke.dk> <157192269854.234778.6284587028332090249.stgit@toke.dk>
In-Reply-To: <157192269854.234778.6284587028332090249.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 24 Oct 2019 19:46:31 -0700
Message-ID: <CAEf4BzaazESQUQNYVJdDX_7WY-=UBoKbKJk_pTK_PguHxoo8uQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/4] libbpf: Fix error handling in bpf_map__reuse_fd()
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

On Thu, Oct 24, 2019 at 6:11 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> bpf_map__reuse_fd() was calling close() in the error path before returnin=
g
> an error value based on errno. However, close can change errno, so that c=
an
> lead to potentially misleading error messages. Instead, explicitly store
> errno in the err variable before each goto.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/libbpf.c |   14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index cccfd9355134..a2a7d074ac48 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -1918,16 +1918,22 @@ int bpf_map__reuse_fd(struct bpf_map *map, int fd=
)
>                 return -errno;
>
>         new_fd =3D open("/", O_RDONLY | O_CLOEXEC);
> -       if (new_fd < 0)
> +       if (new_fd < 0) {
> +               err =3D -errno;
>                 goto err_free_new_name;
> +       }
>
>         new_fd =3D dup3(fd, new_fd, O_CLOEXEC);
> -       if (new_fd < 0)
> +       if (new_fd < 0) {
> +               err =3D -errno;
>                 goto err_close_new_fd;
> +       }
>
>         err =3D zclose(map->fd);
> -       if (err)
> +       if (err) {
> +               err =3D -errno;
>                 goto err_close_new_fd;
> +       }
>         free(map->name);
>
>         map->fd =3D new_fd;
> @@ -1946,7 +1952,7 @@ int bpf_map__reuse_fd(struct bpf_map *map, int fd)
>         close(new_fd);
>  err_free_new_name:
>         free(new_name);
> -       return -errno;
> +       return err;
>  }
>
>  int bpf_map__resize(struct bpf_map *map, __u32 max_entries)
>
