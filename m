Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0C438D624
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 16:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbhEVONv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 10:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbhEVONv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 May 2021 10:13:51 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F21AC061574;
        Sat, 22 May 2021 07:12:25 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 62so11543876wmb.3;
        Sat, 22 May 2021 07:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sWrTPvPYozr/f+12WltxM2mcxCA93yZQ2zbGh1apyJ0=;
        b=fXGP5Nwz92mfVr539UiHVkdPj0lj67MjoE525tMxLI/v1MS3dszYb9dk0LgZb9GkW0
         an2oiVSlae/hQNQtjatfplsyfod1n2st9R3ALuEJzQJNvriVe9G8/olnGJX8NJv1+kVK
         LfRufcH7sNhFQymYdC3iYN9qfAWE/6qowA5V8G4xKY5I5WbYXczIsC8ySKgYpX9tojVw
         xb01DLK1UCo1DgACxYO2s6kllJpOfvGKJTxXKDjTjzmPWQ+6mnRB7cYhwh+NUeGwwOuu
         l/GIe5JbXqYNW0yFJCSHnucz5+1hC/K9ou30Wt17KpFJARW/eC2ecjs7pfzZGDY6CDjt
         FHZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sWrTPvPYozr/f+12WltxM2mcxCA93yZQ2zbGh1apyJ0=;
        b=Ds0g7QwMLKL9tOCnfaWmgQxBbrwkIyXNqK2eD4h26j65VPpCpbTTInEZ5naRysCN64
         d3BfXa9OEwDebiqLsifb7YVHXFRe6vPxu5h359trJO8Xp+ZRXC3OVFpt63NJY7A13y7k
         YHSUEd9KLaf3RNWmlUxbCQcjtgKlAwtQSgGcyv51SNalAg3srb7XOLK172AZHGDgZIYF
         8Y6ko0ioQm1EGQg8ss5RwVQzQWfT+S7bc44AcYx01PIYicEP0TeLO7+mQXp7P56WQzYM
         rSpAiRgY3Ie1CNaIKSe9OCkt02p0BZ2odWUnnwSLLkH4XVyqftuETLNTrImZuARyb8/+
         n9ig==
X-Gm-Message-State: AOAM5338uHywVLiPCny/4pkMYZJas/ROAbeETb03N4xn/szPd+nCIy3I
        ZSphqr2H6mXTqrIRJU9HbBPnyB594gE6rWkz0nk=
X-Google-Smtp-Source: ABdhPJytt/Nl2aIRQ7q2sftCVv5/7zYDggKaT7HoX1VEkwWETm5o+CBvk2owSSj8/xKv+ZY3Wp1IzPRKETRVQ8jN9Qk=
X-Received: by 2002:a05:600c:2054:: with SMTP id p20mr13687013wmg.165.1621692744070;
 Sat, 22 May 2021 07:12:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210521083301.26921-1-magnus.karlsson@gmail.com>
In-Reply-To: <20210521083301.26921-1-magnus.karlsson@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Sat, 22 May 2021 16:12:12 +0200
Message-ID: <CAJ+HfNjBwNjGwuT1jkkPO+n06GFnN4yornYpxb3M9MNg7+EYgg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] xsk: use kvcalloc to support large umems
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, Dan Siemon <dan@coverfire.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 May 2021 at 10:33, Magnus Karlsson <magnus.karlsson@gmail.com> w=
rote:
>
> From: Magnus Karlsson <magnus.karlsson@intel.com>
>
> Use kvcalloc() instead of kcalloc() to support large umems with, on my
> server, one million pages or more in the umem.
>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> Reported-by: Dan Siemon <dan@coverfire.com>

Nice!

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>

> ---
>  net/xdp/xdp_umem.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> index 56a28a686988..f01ef6bda390 100644
> --- a/net/xdp/xdp_umem.c
> +++ b/net/xdp/xdp_umem.c
> @@ -27,7 +27,7 @@ static void xdp_umem_unpin_pages(struct xdp_umem *umem)
>  {
>         unpin_user_pages_dirty_lock(umem->pgs, umem->npgs, true);
>
> -       kfree(umem->pgs);
> +       kvfree(umem->pgs);
>         umem->pgs =3D NULL;
>  }
>
> @@ -99,8 +99,7 @@ static int xdp_umem_pin_pages(struct xdp_umem *umem, un=
signed long address)
>         long npgs;
>         int err;
>
> -       umem->pgs =3D kcalloc(umem->npgs, sizeof(*umem->pgs),
> -                           GFP_KERNEL | __GFP_NOWARN);
> +       umem->pgs =3D kvcalloc(umem->npgs, sizeof(*umem->pgs), GFP_KERNEL=
 | __GFP_NOWARN);
>         if (!umem->pgs)
>                 return -ENOMEM;
>
> @@ -123,7 +122,7 @@ static int xdp_umem_pin_pages(struct xdp_umem *umem, =
unsigned long address)
>  out_pin:
>         xdp_umem_unpin_pages(umem);
>  out_pgs:
> -       kfree(umem->pgs);
> +       kvfree(umem->pgs);
>         umem->pgs =3D NULL;
>         return err;
>  }
>
> base-commit: a49e72b3bda73d36664a084e47da9727a31b8095
> --
> 2.29.0
>
