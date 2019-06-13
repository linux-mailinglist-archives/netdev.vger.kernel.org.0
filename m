Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 339FF43A86
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733138AbfFMPVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:21:53 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41315 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731992AbfFMMs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 08:48:29 -0400
Received: by mail-qk1-f195.google.com with SMTP id c11so12596911qkk.8;
        Thu, 13 Jun 2019 05:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yw5Ck4XGy2ADHG1GZU/5KWNGDLzwNftuwE1cefPpTzg=;
        b=dviP3sKe7FebJZ+/9rxLAQ7AFaKHEJK0kJUsCND3BW0K7I3noRQ0dRX24G6Epb+8jU
         n61pZA/OW6F4bHZNC4fSbqnEzg9ed+WhFaCI1Jt/LFkUqOcmGHoyyW03bnqGHEtumcz1
         N9+j43HCWVOCQ8ckaLN9Ja4YmMt0toBK6c/S4JhN1SEnlwXfsXD7vfcyg6GKARhfyBsT
         y//WS7JppDX70dCl7mvrsnHcUZ8BaWd36F1B40PckqiwVpMZd+XxTldKfPir0OrghSvh
         VDzQ6s0M/9/B08HvHuhN8QEz9XWqCil1euBzw3eHPbr+FD9xo4mzTD+9cVafq8hSdX6n
         GBcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yw5Ck4XGy2ADHG1GZU/5KWNGDLzwNftuwE1cefPpTzg=;
        b=kRD/2rnr/mcXYC5oyz592nyHFNapN8K3cV92X3qAkrHWpJeg0pn79o9CtFBSBh70S5
         fB2Y1LhCHuDVx5JZLNCrPtP43paQj+tiQmnj49GcgLEISw/+yfjiP5eakfpnwZjWuLbM
         cbJpnkkZ1JbGwsC//3HyvLflC6OFuw43sCrfvBL5YIajxvuZTATthMgxb4KWiYDLDGVQ
         awRCcXS+mafHDswWnvwPSWRHFcoGZ0LE6BTaHNDMgF3rnGb53JdKBPxrSfoDfvpvX2s2
         bLmk9lPnyV680Ubb4buREUIX9N/8BQbJLKonc0YktWQgCPVA4hfZ02CwyLXd62s/RhGW
         FRTg==
X-Gm-Message-State: APjAAAXotvcmGX2P1I7wocI0Zi1g1i17RGji98s/6os5BzGJF0zrnE91
        YARX/T2hjPOCoEOkMWp52KjCtf/G+HDbB1lWQz0=
X-Google-Smtp-Source: APXvYqwaxHaNIao6ZZ3d7Yub5xpSwG7JI9uqWONYKr9tQF29Y9W568QiT0nFrg6/+TlRZL5SSbbz+mQ7M3DTdU5OQxw=
X-Received: by 2002:a37:490f:: with SMTP id w15mr71385472qka.165.1560430108287;
 Thu, 13 Jun 2019 05:48:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190612155605.22450-1-maximmi@mellanox.com> <20190612155605.22450-7-maximmi@mellanox.com>
In-Reply-To: <20190612155605.22450-7-maximmi@mellanox.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 13 Jun 2019 14:48:16 +0200
Message-ID: <CAJ+HfNhsjsCoDx5NCEu=AqrT-ENRb8JnqzJfo2m8kD2xraHc+w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 06/17] xsk: Return the whole xdp_desc from xsk_umem_consume_tx
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
> Some drivers want to access the data transmitted in order to implement
> acceleration features of the NICs. It is also useful in AF_XDP TX flow.
>
> Change the xsk_umem_consume_tx API to return the whole xdp_desc, that
> contains the data pointer, length and DMA address, instead of only the
> latter two. Adapt the implementation of i40e and ixgbe to this change.
>

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
> Acked-by: Saeed Mahameed <saeedm@mellanox.com>
> Cc: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> Cc: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c   | 12 +++++++-----
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 15 +++++++++------
>  include/net/xdp_sock.h                       |  6 +++---
>  net/xdp/xsk.c                                | 10 +++-------
>  4 files changed, 22 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/eth=
ernet/intel/i40e/i40e_xsk.c
> index 1b17486543ac..eae6fafad1b8 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> @@ -640,8 +640,8 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, =
unsigned int budget)
>         struct i40e_tx_desc *tx_desc =3D NULL;
>         struct i40e_tx_buffer *tx_bi;
>         bool work_done =3D true;
> +       struct xdp_desc desc;
>         dma_addr_t dma;
> -       u32 len;
>
>         while (budget-- > 0) {
>                 if (!unlikely(I40E_DESC_UNUSED(xdp_ring))) {
> @@ -650,21 +650,23 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring=
, unsigned int budget)
>                         break;
>                 }
>
> -               if (!xsk_umem_consume_tx(xdp_ring->xsk_umem, &dma, &len))
> +               if (!xsk_umem_consume_tx(xdp_ring->xsk_umem, &desc))
>                         break;
>
> -               dma_sync_single_for_device(xdp_ring->dev, dma, len,
> +               dma =3D xdp_umem_get_dma(xdp_ring->xsk_umem, desc.addr);
> +
> +               dma_sync_single_for_device(xdp_ring->dev, dma, desc.len,
>                                            DMA_BIDIRECTIONAL);
>
>                 tx_bi =3D &xdp_ring->tx_bi[xdp_ring->next_to_use];
> -               tx_bi->bytecount =3D len;
> +               tx_bi->bytecount =3D desc.len;
>
>                 tx_desc =3D I40E_TX_DESC(xdp_ring, xdp_ring->next_to_use)=
;
>                 tx_desc->buffer_addr =3D cpu_to_le64(dma);
>                 tx_desc->cmd_type_offset_bsz =3D
>                         build_ctob(I40E_TX_DESC_CMD_ICRC
>                                    | I40E_TX_DESC_CMD_EOP,
> -                                  0, len, 0);
> +                                  0, desc.len, 0);
>
>                 xdp_ring->next_to_use++;
>                 if (xdp_ring->next_to_use =3D=3D xdp_ring->count)
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/e=
thernet/intel/ixgbe/ixgbe_xsk.c
> index bfe95ce0bd7f..0297a70a4e2d 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> @@ -621,8 +621,9 @@ static bool ixgbe_xmit_zc(struct ixgbe_ring *xdp_ring=
, unsigned int budget)
>         union ixgbe_adv_tx_desc *tx_desc =3D NULL;
>         struct ixgbe_tx_buffer *tx_bi;
>         bool work_done =3D true;
> -       u32 len, cmd_type;
> +       struct xdp_desc desc;
>         dma_addr_t dma;
> +       u32 cmd_type;
>
>         while (budget-- > 0) {
>                 if (unlikely(!ixgbe_desc_unused(xdp_ring)) ||
> @@ -631,14 +632,16 @@ static bool ixgbe_xmit_zc(struct ixgbe_ring *xdp_ri=
ng, unsigned int budget)
>                         break;
>                 }
>
> -               if (!xsk_umem_consume_tx(xdp_ring->xsk_umem, &dma, &len))
> +               if (!xsk_umem_consume_tx(xdp_ring->xsk_umem, &desc))
>                         break;
>
> -               dma_sync_single_for_device(xdp_ring->dev, dma, len,
> +               dma =3D xdp_umem_get_dma(xdp_ring->xsk_umem, desc.addr);
> +
> +               dma_sync_single_for_device(xdp_ring->dev, dma, desc.len,
>                                            DMA_BIDIRECTIONAL);
>
>                 tx_bi =3D &xdp_ring->tx_buffer_info[xdp_ring->next_to_use=
];
> -               tx_bi->bytecount =3D len;
> +               tx_bi->bytecount =3D desc.len;
>                 tx_bi->xdpf =3D NULL;
>
>                 tx_desc =3D IXGBE_TX_DESC(xdp_ring, xdp_ring->next_to_use=
);
> @@ -648,10 +651,10 @@ static bool ixgbe_xmit_zc(struct ixgbe_ring *xdp_ri=
ng, unsigned int budget)
>                 cmd_type =3D IXGBE_ADVTXD_DTYP_DATA |
>                            IXGBE_ADVTXD_DCMD_DEXT |
>                            IXGBE_ADVTXD_DCMD_IFCS;
> -               cmd_type |=3D len | IXGBE_TXD_CMD;
> +               cmd_type |=3D desc.len | IXGBE_TXD_CMD;
>                 tx_desc->read.cmd_type_len =3D cpu_to_le32(cmd_type);
>                 tx_desc->read.olinfo_status =3D
> -                       cpu_to_le32(len << IXGBE_ADVTXD_PAYLEN_SHIFT);
> +                       cpu_to_le32(desc.len << IXGBE_ADVTXD_PAYLEN_SHIFT=
);
>
>                 xdp_ring->next_to_use++;
>                 if (xdp_ring->next_to_use =3D=3D xdp_ring->count)
> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> index b6f5ebae43a1..057b159ff8b9 100644
> --- a/include/net/xdp_sock.h
> +++ b/include/net/xdp_sock.h
> @@ -81,7 +81,7 @@ bool xsk_umem_has_addrs(struct xdp_umem *umem, u32 cnt)=
;
>  u64 *xsk_umem_peek_addr(struct xdp_umem *umem, u64 *addr);
>  void xsk_umem_discard_addr(struct xdp_umem *umem);
>  void xsk_umem_complete_tx(struct xdp_umem *umem, u32 nb_entries);
> -bool xsk_umem_consume_tx(struct xdp_umem *umem, dma_addr_t *dma, u32 *le=
n);
> +bool xsk_umem_consume_tx(struct xdp_umem *umem, struct xdp_desc *desc);
>  void xsk_umem_consume_tx_done(struct xdp_umem *umem);
>  struct xdp_umem_fq_reuse *xsk_reuseq_prepare(u32 nentries);
>  struct xdp_umem_fq_reuse *xsk_reuseq_swap(struct xdp_umem *umem,
> @@ -175,8 +175,8 @@ static inline void xsk_umem_complete_tx(struct xdp_um=
em *umem, u32 nb_entries)
>  {
>  }
>
> -static inline bool xsk_umem_consume_tx(struct xdp_umem *umem, dma_addr_t=
 *dma,
> -                                      u32 *len)
> +static inline bool xsk_umem_consume_tx(struct xdp_umem *umem,
> +                                      struct xdp_desc *desc)
>  {
>         return false;
>  }
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 35ca531ac74e..74417a851ed5 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -172,22 +172,18 @@ void xsk_umem_consume_tx_done(struct xdp_umem *umem=
)
>  }
>  EXPORT_SYMBOL(xsk_umem_consume_tx_done);
>
> -bool xsk_umem_consume_tx(struct xdp_umem *umem, dma_addr_t *dma, u32 *le=
n)
> +bool xsk_umem_consume_tx(struct xdp_umem *umem, struct xdp_desc *desc)
>  {
> -       struct xdp_desc desc;
>         struct xdp_sock *xs;
>
>         rcu_read_lock();
>         list_for_each_entry_rcu(xs, &umem->xsk_list, list) {
> -               if (!xskq_peek_desc(xs->tx, &desc))
> +               if (!xskq_peek_desc(xs->tx, desc))
>                         continue;
>
> -               if (xskq_produce_addr_lazy(umem->cq, desc.addr))
> +               if (xskq_produce_addr_lazy(umem->cq, desc->addr))
>                         goto out;
>
> -               *dma =3D xdp_umem_get_dma(umem, desc.addr);
> -               *len =3D desc.len;
> -
>                 xskq_discard_desc(xs->tx);
>                 rcu_read_unlock();
>                 return true;
> --
> 2.19.1
>
