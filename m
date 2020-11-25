Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AADF2C395C
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 07:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgKYGzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 01:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgKYGzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 01:55:47 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7EA1C0613D4;
        Tue, 24 Nov 2020 22:55:46 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id v21so1571361pgi.2;
        Tue, 24 Nov 2020 22:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=G3RsF/ezkJmPkJ9qbTzt79hYrwBPit4uVs8jUybVwcY=;
        b=fzP7tn3wA9xVnB/v3+2Ww/E5beISzOJk6MOhyfZgd3T4IXK+7c7FSCwh3IVbpWewSo
         tNiQNozwWaFseAltnA+KriezIhwEK9dZIaEVbZ55dAtsZFmjTQhc8nT6lHHEQ/tucTjY
         o4c7bvtEypJXC4WMGyx9Mw15ANI2+kCUIGdmEGM85zk/3LkwSfLnr5dOoG1vFLKgS57o
         UdZs1tpiGLLedieSWHQz8/pwG2taa6UqPNB+AE2YNyLUsF+2eVWFrjjrRgRlOUKyqdsW
         BsdVi7/9G07FgVmcI0yrt+BCl480ys32mWULTGs1yw6rcyo50umj8qly9avi5q/1OMp0
         sszg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=G3RsF/ezkJmPkJ9qbTzt79hYrwBPit4uVs8jUybVwcY=;
        b=CQTg7HnZZT5ibwEZ9al0seHDgLNcVAIQdqdYMnzIv881wOE7XlMy0ErDG3M1X0ul2y
         xQK1EjPBgcIEbN7M4bcCVhoJJWGo0dVUK+LziMlpu0bfGQ8uwJoMIGYKcquKxPzClLLk
         sbvk2hUXhm1fTG+L2E54Xn+z9UPTzxs00ZzfS+C1VQp0OgfOLOlwcNyIiLs8YMrk8Br9
         clde3B/0m/bIz/YudPKXh0oyexbe6kX9xFFuvhtzyjjfJg7iEQUDhsoTfFmwdEuptMZh
         Nr1513UVZ7yX+5dA/6PyB+Rxy78s6huDIK9GMvaSFsoQXZQDdSPPhoju92mN9bBnegDk
         OhBA==
X-Gm-Message-State: AOAM532ErpjSyp1r0TgmqTOKcnVy0uMQeebNnbPNfJ92McA6kWAaZSdy
        Das9jqS7QL2A6l1AfI8WE5hwq9Z/nieEVLJxrHY=
X-Google-Smtp-Source: ABdhPJzW4VGJLR86DrvFhciqr/CdbdTp/2rOTN/EInniqgQVnsS7B6Zen88VUyyHAgS6+KKANbjPNXRA308g739wOWM=
X-Received: by 2002:a17:90a:ea05:: with SMTP id w5mr2448056pjy.204.1606287346440;
 Tue, 24 Nov 2020 22:55:46 -0800 (PST)
MIME-Version: 1.0
References: <20201119083024.119566-1-bjorn.topel@gmail.com> <20201119083024.119566-4-bjorn.topel@gmail.com>
In-Reply-To: <20201119083024.119566-4-bjorn.topel@gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 25 Nov 2020 07:55:35 +0100
Message-ID: <CAJ8uoz38HYgHYPHCZ2fJ_GisgaT47sr+bcvHj=7s8dZdEgUDQQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 03/10] xsk: add support for recvmsg()
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

On Thu, Nov 19, 2020 at 9:32 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
m> wrote:
>
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> Add support for non-blocking recvmsg() to XDP sockets. Previously,
> only sendmsg() was supported by XDP socket. Now, for symmetry and the
> upcoming busy-polling support, recvmsg() is added.
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
>  net/xdp/xsk.c | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index b0141973f23e..56a52ec75696 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -531,6 +531,26 @@ static int xsk_sendmsg(struct socket *sock, struct m=
sghdr *m, size_t total_len)
>         return __xsk_sendmsg(sk);
>  }
>
> +static int xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len=
, int flags)
> +{
> +       bool need_wait =3D !(flags & MSG_DONTWAIT);
> +       struct sock *sk =3D sock->sk;
> +       struct xdp_sock *xs =3D xdp_sk(sk);
> +
> +       if (unlikely(!(xs->dev->flags & IFF_UP)))
> +               return -ENETDOWN;
> +       if (unlikely(!xs->rx))
> +               return -ENOBUFS;
> +       if (unlikely(!xsk_is_bound(xs)))
> +               return -ENXIO;
> +       if (unlikely(need_wait))
> +               return -EOPNOTSUPP;
> +
> +       if (xs->pool->cached_need_wakeup & XDP_WAKEUP_RX && xs->zc)
> +               return xsk_wakeup(xs, XDP_WAKEUP_RX);
> +       return 0;
> +}
> +
>  static __poll_t xsk_poll(struct file *file, struct socket *sock,
>                              struct poll_table_struct *wait)
>  {
> @@ -1191,7 +1211,7 @@ static const struct proto_ops xsk_proto_ops =3D {
>         .setsockopt     =3D xsk_setsockopt,
>         .getsockopt     =3D xsk_getsockopt,
>         .sendmsg        =3D xsk_sendmsg,
> -       .recvmsg        =3D sock_no_recvmsg,
> +       .recvmsg        =3D xsk_recvmsg,
>         .mmap           =3D xsk_mmap,
>         .sendpage       =3D sock_no_sendpage,
>  };
> --
> 2.27.0
>
