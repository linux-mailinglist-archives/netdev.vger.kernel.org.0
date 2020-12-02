Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C062CB16A
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 01:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgLBAXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 19:23:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbgLBAXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 19:23:47 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311B7C0613CF;
        Tue,  1 Dec 2020 16:23:07 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id v92so23181ybi.4;
        Tue, 01 Dec 2020 16:23:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=joKz0ssbPI6pK0hD4AE9+qYsarfRsjS4ar9Apyuoi2g=;
        b=NRhMiL4dh7/VFE1qUpxbxrpPogx/vCe2g7x6SQ3YesdLTd3OSKHXloPx2Z4fWFuAEW
         3ZvQTssdKK+1StNBzm4uYojDTlsFv4llR4nb2cCr6Zkd271+g3Q+oynaCrPSDYNn0tux
         UVokv3yEZA2UpVO492b9D6xcgTPgzIpuJ4t7uGxWIx/SGlP/BTVc9nKsfb4/tYB5GnPD
         uFzpY/2F2ap7XPXRoOUW4zbwdUgH2gkCu82wBQiK3KIPq4azsW65MJuYPkWt/0ElMO11
         xMuBFABUzZ2C9zfg3cTl5y3gLKih/KcyFLIsglCrZ1tUxcEGvDpou1Ox3NmGyywjAJlY
         7UUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=joKz0ssbPI6pK0hD4AE9+qYsarfRsjS4ar9Apyuoi2g=;
        b=FMmOp4CoDNmeWv0pkCifTojXeaz/CoiklCjmzA/b4TpObH8Ivv8+O7KBMPL0E8rKxj
         wahKntuhI4pLl8g1FqP+vhsmnuMfVZgSJr4Fhx7c2kPzp5uE8bkGiOV2JQAlzU6aIpHg
         sxcR3N3nVJvSmqo4Mi5XAbd55f+IvEGhy9zraSJYtnpODXeP8Sscixts+geHE2K0fXFU
         4ykIcXbXq4stanzlkMu+PXTXdKyiptnwY0eqcbSiZ8DpVJhQKBaJffkcgwXnipWM6/7Q
         qtjR0/usZ7uIM6Fd9yCFMeeQPaOftB5tRWYn5R0XoHsEegOZyiMU8yn1WSqAY8ogj8Vd
         RJGg==
X-Gm-Message-State: AOAM532Avg+UkTsietyoaH3lfhFAkRYrfj8+mioEwz1j+CHrfck4HbVn
        o2wnJoKOhVkY4W1t0EEfcRqbLGQkXicXXO+P2iI=
X-Google-Smtp-Source: ABdhPJz9/yOt62JvY9MUMPnGXxNFgmM3NqAa6nfUtue8UAan60CNEuMvdXTjIuYKwNWpI4E9P7wXkMZW3ziSAD+0874=
X-Received: by 2002:a25:c089:: with SMTP id c131mr6773464ybf.510.1606868586466;
 Tue, 01 Dec 2020 16:23:06 -0800 (PST)
MIME-Version: 1.0
References: <20201118001742.85005-1-sdf@google.com> <20201118001742.85005-4-sdf@google.com>
In-Reply-To: <20201118001742.85005-4-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Dec 2020 16:22:55 -0800
Message-ID: <CAEf4BzYr-2CGFa0qFcYzB0+J7f=fa+1kuZzjhiA7JKyw5q1Ppw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: extend bind{4,6} programs
 with a call to bpf_setsockopt
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 4:20 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> To make sure it doesn't trigger sock_owned_by_me splat.
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  .../testing/selftests/bpf/progs/bind4_prog.c  | 31 +++++++++++++++++++
>  .../testing/selftests/bpf/progs/bind6_prog.c  | 31 +++++++++++++++++++
>  2 files changed, 62 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/progs/bind4_prog.c b/tools/testing/selftests/bpf/progs/bind4_prog.c
> index ff3def2ee6f9..9d1d8d642edc 100644
> --- a/tools/testing/selftests/bpf/progs/bind4_prog.c
> +++ b/tools/testing/selftests/bpf/progs/bind4_prog.c
> @@ -19,8 +19,35 @@
>  #define SERV4_REWRITE_IP       0x7f000001U /* 127.0.0.1 */
>  #define SERV4_REWRITE_PORT     4444
>
> +#ifndef IFNAMSIZ
> +#define IFNAMSIZ 16
> +#endif
> +
>  int _version SEC("version") = 1;

nit: would be nice to drop this anachronism

>

[...]

> diff --git a/tools/testing/selftests/bpf/progs/bind6_prog.c b/tools/testing/selftests/bpf/progs/bind6_prog.c
> index 97686baaae65..a443927dae53 100644
> --- a/tools/testing/selftests/bpf/progs/bind6_prog.c
> +++ b/tools/testing/selftests/bpf/progs/bind6_prog.c
> @@ -25,8 +25,35 @@
>  #define SERV6_REWRITE_IP_3     0x00000001
>  #define SERV6_REWRITE_PORT     6666
>
> +#ifndef IFNAMSIZ
> +#define IFNAMSIZ 16
> +#endif
> +
>  int _version SEC("version") = 1;

nit: same

>

[...]
