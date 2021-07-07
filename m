Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9663BE35D
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 09:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhGGHFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 03:05:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230312AbhGGHFo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 03:05:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEBB461C82;
        Wed,  7 Jul 2021 07:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625641384;
        bh=7tAg32fZBNuoC3CL6Ig9nwQmfyHrXRZJzl9msb7tNXU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Opw0/Qnf0maQx5i0xrXCvxYz4iruyv0anc2s2/Yi8j2FibTvuZd72eSwqyzlwgv5c
         3uvuNYklFsC/cmGR1ir7xHpgCugutKIj7FOFYu+/ocnEdRJfZutXprzzgG6Tvk6nQa
         628ybg+RSg1CRj4bOIujhUob5TVhHdMYUDkr9fjB9KjywTHzkLf4YUjF//nNNZLwP2
         hQuoSkeAUvTIVPfWtR7WCrvG5luMiDhE54qyFiHCviLOnq/ZvfATTc0/P3WEc3I6IB
         /LL4EF/hv4Qc5ESJpS0USl3BU++e31Q8EzUfzeEvgOycU7EwguC8XsmRHEGjvf4QJZ
         jE7zrpcBTUkkw==
Received: by mail-lf1-f52.google.com with SMTP id f30so2318795lfj.1;
        Wed, 07 Jul 2021 00:03:04 -0700 (PDT)
X-Gm-Message-State: AOAM5300V/ChYahK3dtqfz/IxOoI9WDhjuUoLTLpDa+VtpSQWWTAfL+3
        GLUSE7D0NM8B6PbH1Rbu6oOilo/5FXzUzOC8Fpc=
X-Google-Smtp-Source: ABdhPJxbN4bL0q+HrIKopleZYUj1uHSBnNBtvm0u6Qu+/u/6iUE+OcL4H6ha/sp7iRUw6S8of6WjFEGj1+DtoUGNd6Q=
X-Received: by 2002:ac2:42cb:: with SMTP id n11mr14678250lfl.160.1625641383121;
 Wed, 07 Jul 2021 00:03:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210707043811.5349-1-hefengqing@huawei.com> <20210707043811.5349-2-hefengqing@huawei.com>
In-Reply-To: <20210707043811.5349-2-hefengqing@huawei.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 7 Jul 2021 00:02:52 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4RNWsOH5-NDiOF5RNgejsadrkqUbqN9Mh+fxWHQZOCMQ@mail.gmail.com>
Message-ID: <CAPhsuW4RNWsOH5-NDiOF5RNgejsadrkqUbqN9Mh+fxWHQZOCMQ@mail.gmail.com>
Subject: Re: [bpf-next 1/3] bpf: Move bpf_prog_clone_free into filter.h file
To:     He Fengqing <hefengqing@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 6, 2021 at 8:53 PM He Fengqing <hefengqing@huawei.com> wrote:
>
> Move bpf_prog_clone_free function into filter.h, so we can use
> it in other file.
>
> Signed-off-by: He Fengqing <hefengqing@huawei.com>
> ---
>  include/linux/filter.h | 15 +++++++++++++++
>  kernel/bpf/core.c      | 20 +-------------------
>  2 files changed, 16 insertions(+), 19 deletions(-)
>
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 472f97074da0..f39e008a377d 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -884,6 +884,21 @@ struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
>                                   gfp_t gfp_extra_flags);
>  void __bpf_prog_free(struct bpf_prog *fp);
>
> +static inline void bpf_prog_clone_free(struct bpf_prog *fp)
> +{
> +       /* aux was stolen by the other clone, so we cannot free
> +        * it from this path! It will be freed eventually by the
> +        * other program on release.
> +        *
> +        * At this point, we don't need a deferred release since
> +        * clone is guaranteed to not be locked.
> +        */
> +       fp->aux = NULL;
> +       fp->stats = NULL;
> +       fp->active = NULL;
> +       __bpf_prog_free(fp);
> +}
> +
>  static inline void bpf_prog_unlock_free(struct bpf_prog *fp)
>  {
>         __bpf_prog_free(fp);
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 034ad93a1ad7..49b0311f48c1 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -238,10 +238,7 @@ struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
>                 /* We keep fp->aux from fp_old around in the new
>                  * reallocated structure.
>                  */
After the change, we can remove the comment above.

> -               fp_old->aux = NULL;
> -               fp_old->stats = NULL;
> -               fp_old->active = NULL;
> -               __bpf_prog_free(fp_old);
> +               bpf_prog_clone_free(fp_old);

Please add a couple sentences in the commit log about this chanage.

Thanks,
Song
