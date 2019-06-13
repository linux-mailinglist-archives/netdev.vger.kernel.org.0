Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEBA643A6C
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732076AbfFMPUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:20:55 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36125 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732008AbfFMMvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 08:51:00 -0400
Received: by mail-qt1-f194.google.com with SMTP id p15so2966355qtl.3;
        Thu, 13 Jun 2019 05:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eFeTWMKs9ihsaxA0AMESBJJwqP1y2EWmZQjeKE8K34M=;
        b=g5eY/mfWcMvcmnpqGn2etP9f3/asNRaHlIAs5gV8VVQ6yPoHjSg+rVwmOwS6qCpwEj
         QjuZ4D6LHa/z+UUOhBFFepzlsFgLOznDJzFwY+58biydtFsuFPDItfCCzURn/sXk2tPa
         RtdixHbu1KRM7Fp0CiCZUQ1SydMXrXVeRl4yHq9lqlwYzY0O4O/GZ3zlwDbkNaj+UnD7
         EMQrH8P6rvOvhuYBy0miVndqTdKG6cKEA55DHUMAK7snvZKD4n8UjWnoFtYGYVeFhw/7
         QKqyvcTRhK9MHquBODj/SoQzVbdZi2FDYOI+8YzSRpAZFjbyuN7ehFy9Ws3JxMd47bX5
         EkAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eFeTWMKs9ihsaxA0AMESBJJwqP1y2EWmZQjeKE8K34M=;
        b=Wc8uVpP6qL28FfEJy3AuotRPleTiLB+QvYymZur/SUZW40QeEzu3RRD4q07oXXjeo3
         MCUpRlg6HZvuCyigIiAaQ6bQ8gPWba+lZgh0x4b0rvgMdmzKDP3+I16mOE9QYzoAvQKq
         o4JYl64AbsZ/ymkISvd2DRxaN3q91L9zDrGGPvCPSC4EqET2oEnrZhdTaeKEzQT3FPrH
         LB7rrKbCp6srQYVTOQtCoO7nHFQznkn8VQyZlGdu7+DGS93fOxq4O/ZkWJvxQZ5MP8Ra
         ImEcM+Cc4XBMbGn2MyoWR/ah+T2Dwx0ThG9xayZd7UmEAfyNl9SrZIeF21lvT13NMWDg
         LecA==
X-Gm-Message-State: APjAAAUuSuZDLwMEdws2VyQGCv78hD/buoVIJJ2unj8iVFNTH07h0W7s
        1Zz4vVPaNRbc1R8O3CXY1JJCSWvExgc0JPRUKmEkz35B/hw=
X-Google-Smtp-Source: APXvYqy2gXCzoqY0x4AZYdCUX9xjwFSaqKkDV96iAkDMv+zLdRoVgp+PmpJyydQqVfs7bEIfIWTz8aSzq/BrCSjLpcQ=
X-Received: by 2002:a0c:d0b6:: with SMTP id z51mr3471771qvg.3.1560430258625;
 Thu, 13 Jun 2019 05:50:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190612155605.22450-1-maximmi@mellanox.com> <20190612155605.22450-4-maximmi@mellanox.com>
In-Reply-To: <20190612155605.22450-4-maximmi@mellanox.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 13 Jun 2019 14:50:47 +0200
Message-ID: <CAJ+HfNi7a7X3X-1q8TKWn1t6oyX=3r2NzD_Omk3NQXWdtNPMTQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 03/17] xsk: Add getsockopt XDP_OPTIONS
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
> Make it possible for the application to determine whether the AF_XDP
> socket is running in zero-copy mode. To achieve this, add a new
> getsockopt option XDP_OPTIONS that returns flags. The only flag
> supported for now is the zero-copy mode indicator.
>

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
> Acked-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  include/uapi/linux/if_xdp.h       |  8 ++++++++
>  net/xdp/xsk.c                     | 20 ++++++++++++++++++++
>  tools/include/uapi/linux/if_xdp.h |  8 ++++++++
>  3 files changed, 36 insertions(+)
>
> diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
> index caed8b1614ff..faaa5ca2a117 100644
> --- a/include/uapi/linux/if_xdp.h
> +++ b/include/uapi/linux/if_xdp.h
> @@ -46,6 +46,7 @@ struct xdp_mmap_offsets {
>  #define XDP_UMEM_FILL_RING             5
>  #define XDP_UMEM_COMPLETION_RING       6
>  #define XDP_STATISTICS                 7
> +#define XDP_OPTIONS                    8
>
>  struct xdp_umem_reg {
>         __u64 addr; /* Start of packet data area */
> @@ -60,6 +61,13 @@ struct xdp_statistics {
>         __u64 tx_invalid_descs; /* Dropped due to invalid descriptor */
>  };
>
> +struct xdp_options {
> +       __u32 flags;
> +};
> +
> +/* Flags for the flags field of struct xdp_options */
> +#define XDP_OPTIONS_ZEROCOPY (1 << 0)
> +
>  /* Pgoff for mmaping the rings */
>  #define XDP_PGOFF_RX_RING                        0
>  #define XDP_PGOFF_TX_RING               0x80000000
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index b68a380f50b3..35ca531ac74e 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -650,6 +650,26 @@ static int xsk_getsockopt(struct socket *sock, int l=
evel, int optname,
>
>                 return 0;
>         }
> +       case XDP_OPTIONS:
> +       {
> +               struct xdp_options opts =3D {};
> +
> +               if (len < sizeof(opts))
> +                       return -EINVAL;
> +
> +               mutex_lock(&xs->mutex);
> +               if (xs->zc)
> +                       opts.flags |=3D XDP_OPTIONS_ZEROCOPY;
> +               mutex_unlock(&xs->mutex);
> +
> +               len =3D sizeof(opts);
> +               if (copy_to_user(optval, &opts, len))
> +                       return -EFAULT;
> +               if (put_user(len, optlen))
> +                       return -EFAULT;
> +
> +               return 0;
> +       }
>         default:
>                 break;
>         }
> diff --git a/tools/include/uapi/linux/if_xdp.h b/tools/include/uapi/linux=
/if_xdp.h
> index caed8b1614ff..faaa5ca2a117 100644
> --- a/tools/include/uapi/linux/if_xdp.h
> +++ b/tools/include/uapi/linux/if_xdp.h
> @@ -46,6 +46,7 @@ struct xdp_mmap_offsets {
>  #define XDP_UMEM_FILL_RING             5
>  #define XDP_UMEM_COMPLETION_RING       6
>  #define XDP_STATISTICS                 7
> +#define XDP_OPTIONS                    8
>
>  struct xdp_umem_reg {
>         __u64 addr; /* Start of packet data area */
> @@ -60,6 +61,13 @@ struct xdp_statistics {
>         __u64 tx_invalid_descs; /* Dropped due to invalid descriptor */
>  };
>
> +struct xdp_options {
> +       __u32 flags;
> +};
> +
> +/* Flags for the flags field of struct xdp_options */
> +#define XDP_OPTIONS_ZEROCOPY (1 << 0)
> +
>  /* Pgoff for mmaping the rings */
>  #define XDP_PGOFF_RX_RING                        0
>  #define XDP_PGOFF_TX_RING               0x80000000
> --
> 2.19.1
>
