Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C678B2C3A6E
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 09:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgKYH7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 02:59:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgKYH7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 02:59:48 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB9CC0613D4;
        Tue, 24 Nov 2020 23:59:48 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id v21so1723629pgi.2;
        Tue, 24 Nov 2020 23:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gGirE1fk9ycO/945LUizDxbsEckV/SVkmRIJ5uRwwqk=;
        b=GU1bEeuj8Mqv9v+W3J71JmmyuhUnDRuCU1DS5zyXYYyH7DezGx0GtrWQjhswmIzYUG
         hG1JgK7XURHkTNPOuzj+CBSot6BrfXT6K6tcU5m6ML+C4YuD4GREnLL8+k16th8NCemc
         JpRdDZ3GnynYbXqUjOg4M76aj4RWUevdl0Gg5NHyUh50NQyBDb7vjNggI0Z35KPdqjo7
         JY5bZIW83ZpkmhyaWCEQHLqCTDW94dOYDg2yA+0xqRc3ihv1NDK8l2bAC8BwVXzoYqCD
         GxM0UmjsA/7c4xL+NPJ3jIlMfehE75Bg/vkbJngHkYPuX4N61RSnwxUHDl+4LogwPaxB
         UqgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gGirE1fk9ycO/945LUizDxbsEckV/SVkmRIJ5uRwwqk=;
        b=sDrBrWDNM0UVs/eg/e0n9kcI/DpnaEYhxZletzyYJKUfLCY+BXu95o9q9agzjGq56t
         HOdUIDvGC7GY9d6noISQA/4md9KhudPP8xx4wQRQbPasWPXwPDYjiRjD3bZFnDw8K3TR
         zUHcyb0QPXkOY16QFc88EYJorXFrjvaYHXG7X6j+QW3TmuBpyGPdnu+0bIsUvGnu1/lu
         EQJ3dWt7yOx0FMjOru42NKeNibUy/IoVbBdhtT3nDmtvq6f0GGU0nD2L5c4T5a613HN3
         DY7jGuVTzYbt9Ws9NuKMXwSMNUHpLVi58fhIUmhfPY9fAZp4Jj+YSCGuFlet9gh8bOji
         GuYA==
X-Gm-Message-State: AOAM532WJVyu6/Ycx9L61ujweuup06ruJOSt9uox+WkWOqy7Ob8GwI2J
        v/3v7o2fBR6HdBst/lGDXEOJ8fM/n0sWpxAcA8Y=
X-Google-Smtp-Source: ABdhPJy2zrjvoHf2/X5gXVcpm4Fh8Z5QQOCPDpOI8f5kw4NZteA7uNBiTW+dSkojaBdsde6OMzt9twwHy77h8FwK3Ls=
X-Received: by 2002:a17:90a:ea05:: with SMTP id w5mr2705755pjy.204.1606291187769;
 Tue, 24 Nov 2020 23:59:47 -0800 (PST)
MIME-Version: 1.0
References: <20201119083024.119566-1-bjorn.topel@gmail.com> <20201119083024.119566-8-bjorn.topel@gmail.com>
In-Reply-To: <20201119083024.119566-8-bjorn.topel@gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 25 Nov 2020 08:59:36 +0100
Message-ID: <CAJ8uoz0Z6nTCf==qUGivQZv-o9cNpVbX2KpWMtZh33TrkA2+Kg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 07/10] samples/bpf: use recvfrom() in xdpsock/rxdrop
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Zhang, Qi Z" <qi.z.zhang@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 9:34 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
m> wrote:
>
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> Start using recvfrom() the rxdrop scenario.
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
>  samples/bpf/xdpsock_user.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> index 2567f0db5aca..f90111b95b2e 100644
> --- a/samples/bpf/xdpsock_user.c
> +++ b/samples/bpf/xdpsock_user.c
> @@ -1170,7 +1170,7 @@ static inline void complete_tx_only(struct xsk_sock=
et_info *xsk,
>         }
>  }
>
> -static void rx_drop(struct xsk_socket_info *xsk, struct pollfd *fds)
> +static void rx_drop(struct xsk_socket_info *xsk)
>  {
>         unsigned int rcvd, i;
>         u32 idx_rx =3D 0, idx_fq =3D 0;
> @@ -1180,7 +1180,7 @@ static void rx_drop(struct xsk_socket_info *xsk, st=
ruct pollfd *fds)
>         if (!rcvd) {
>                 if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
>                         xsk->app_stats.rx_empty_polls++;
> -                       ret =3D poll(fds, num_socks, opt_timeout);
> +                       recvfrom(xsk_socket__fd(xsk->xsk), NULL, 0, MSG_D=
ONTWAIT, NULL, NULL);
>                 }
>                 return;
>         }
> @@ -1191,7 +1191,7 @@ static void rx_drop(struct xsk_socket_info *xsk, st=
ruct pollfd *fds)
>                         exit_with_error(-ret);
>                 if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
>                         xsk->app_stats.fill_fail_polls++;
> -                       ret =3D poll(fds, num_socks, opt_timeout);
> +                       recvfrom(xsk_socket__fd(xsk->xsk), NULL, 0, MSG_D=
ONTWAIT, NULL, NULL);
>                 }
>                 ret =3D xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx=
_fq);
>         }
> @@ -1233,7 +1233,7 @@ static void rx_drop_all(void)
>                 }
>
>                 for (i =3D 0; i < num_socks; i++)
> -                       rx_drop(xsks[i], fds);
> +                       rx_drop(xsks[i]);
>
>                 if (benchmark_done)
>                         break;
> --
> 2.27.0
>
