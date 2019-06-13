Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83B2043A63
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732062AbfFMPUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:20:41 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:37530 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732013AbfFMMvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 08:51:45 -0400
Received: by mail-qk1-f196.google.com with SMTP id d15so12632666qkl.4;
        Thu, 13 Jun 2019 05:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KKmmN038phC2yyCTzlT5LiooKBRVC9oBOIL2DAtYXHI=;
        b=soAA2vJV34Qwpz+g+a+jRrA1WGyNJKN2hFvIR6ikg4238mXH4YS1bWju86ixTCeeVK
         MRoqutqT+TGzg+SFIWw6kYEqFakRiuq0c07C6AT8YjWBrG+m3SSnRktNfemBxCdMSAka
         /7Cjw6S481a+c+GelAAxoyyHbZrM/ZcVF2ruc+kRLU0ar0qZqo3tPRzhTtAJw6YUJJX8
         aaaW/9nfaxxfXts+6EXpdTrqQ2SxUOziGuXZeTWojZBNhJVHyj6f6MvmGwR7J4Nl4KKW
         eenh6Us4d0ajRZ6ZS++QOc2fTfmm62TGKWpu/G/p2diKAsdIaQ6NNzh7CMNb4624P0eU
         8kYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KKmmN038phC2yyCTzlT5LiooKBRVC9oBOIL2DAtYXHI=;
        b=WJ+0si0OEyyHycaQ4BWpmqUhhDwWc44JqtNcr6sX3MyIRAol3zOy9CRTl46B3/F6Kc
         jm45ATEA/37Tftowv2CAGD7PzyrmROVDV2Gg1SQHXVd08i4V4yT0WeBUwe6GLrQ0LK7t
         u16/8TdUs97bXQSznh6ihcc70LyZ9AzpJ+2S8PRkYbKnIJPEZpOvq3iEuY1IIMz2D+vy
         hu/pDyxCECDT3CGndrJxmOSKl1OhTy4jzww62vWus/N6xZ255peao8FOm69pypE39YQi
         KjwtfdMJDnAILfKnlyhQ55nbH5+KSXCMTczXqUXxysmPe/YjDANq9M4clj9npEqiA3/T
         dCnA==
X-Gm-Message-State: APjAAAV6O+8X8Fmp2FkzzbHJODY6c9jxX9bD4oW5Dy9zIWFWabJ0aQMp
        LI7/qhAlfwMrQqCzcPqe+dPbUIVVjVMCarv77VY=
X-Google-Smtp-Source: APXvYqzSCHWJZE39A4jxOogJeI2vT1/4trVEnSOXtusaQUUF+WLaaaLehcvwCpGrQhe2x5wuhiXscWJf/zf7kurN7HA=
X-Received: by 2002:a05:620a:12c4:: with SMTP id e4mr20397748qkl.81.1560430304403;
 Thu, 13 Jun 2019 05:51:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190612155605.22450-1-maximmi@mellanox.com> <20190612155605.22450-5-maximmi@mellanox.com>
In-Reply-To: <20190612155605.22450-5-maximmi@mellanox.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 13 Jun 2019 14:51:32 +0200
Message-ID: <CAJ+HfNi1ERWq=ifGVupQ2yYXQQLibfx-yv6Fyi8ut3R8ttrLCQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 04/17] libbpf: Support getsockopt XDP_OPTIONS
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jun 2019 at 20:05, Maxim Mikityanskiy <maximmi@mellanox.com> wro=
te:
>
> Query XDP_OPTIONS in libbpf to determine if the zero-copy mode is active
> or not.
>

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
> Acked-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  tools/lib/bpf/xsk.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 7ef6293b4fd7..bf15a80a37c2 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -65,6 +65,7 @@ struct xsk_socket {
>         int xsks_map_fd;
>         __u32 queue_id;
>         char ifname[IFNAMSIZ];
> +       bool zc;
>  };
>
>  struct xsk_nl_info {
> @@ -480,6 +481,7 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, c=
onst char *ifname,
>         void *rx_map =3D NULL, *tx_map =3D NULL;
>         struct sockaddr_xdp sxdp =3D {};
>         struct xdp_mmap_offsets off;
> +       struct xdp_options opts;
>         struct xsk_socket *xsk;
>         socklen_t optlen;
>         int err;
> @@ -597,6 +599,16 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, =
const char *ifname,
>         }
>
>         xsk->prog_fd =3D -1;
> +
> +       optlen =3D sizeof(opts);
> +       err =3D getsockopt(xsk->fd, SOL_XDP, XDP_OPTIONS, &opts, &optlen)=
;
> +       if (err) {
> +               err =3D -errno;
> +               goto out_mmap_tx;
> +       }
> +
> +       xsk->zc =3D opts.flags & XDP_OPTIONS_ZEROCOPY;
> +
>         if (!(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_L=
OAD)) {
>                 err =3D xsk_setup_xdp_prog(xsk);
>                 if (err)
> --
> 2.19.1
>
