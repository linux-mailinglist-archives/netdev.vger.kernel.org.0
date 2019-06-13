Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D28A43A70
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732090AbfFMPU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:20:56 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40932 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732007AbfFMMuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 08:50:19 -0400
Received: by mail-qt1-f193.google.com with SMTP id a15so22335989qtn.7;
        Thu, 13 Jun 2019 05:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0dXwiQ9boMkcoIRiyMAKQVrSPhK0KAhhtxiIsNmxnz8=;
        b=h22vNLsi0/LmtzV80veF+h4wX/7PF55PrixcMt51YG+nrMi1mFPRT4drh8N515IV1B
         aJDayiyouB+cvV5WIUeNqlDLVKCwB14bgmm2pRhb/q2QhYP3UcHqTeUyPtFkuZQDm25V
         PLu9rZYKTMkfV/mfVQV/CGJ2U7Wgoj3BVaZEYa1iYY+BHlC5hXMEwwVsATacV2SHOIKt
         h6mLetn1dYyycQpuBYIL0hLB9gZZGzdzSJbE/l4dHedwLYLrMaiQLgQDBjrW2aKhxWAA
         J7sWHh50RA/r2/TQXlYWINqj1ns2pkXYv9SNOdm/pUP6Hx/IYWSyZPot0uUbF8pIvv5G
         KIvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0dXwiQ9boMkcoIRiyMAKQVrSPhK0KAhhtxiIsNmxnz8=;
        b=OcAC9aK2opUYWzTyIu6t3PkSM8LvL/CEJQP9EUYC/cYc2ZafnJ6T3dnsoqtRDY7ODt
         LKKx/xt+BfujcqwB2MRfk7yvo7dRquD8Ov6zye7j/VqYbPF/pVpllYHdA1Q7dQlEjRJr
         AbQqiNY4WL2EMqoEQNabEccibzHzMf1r73AUFL2ieQrB/oyppIvyD1gXHZGmk0bEKCcx
         272yW31+DoNKq1+ss2JgSKIgiA8JxLIm1v0hal21YPI/GouQMb7/VZ+figGWqc7SQKeV
         +OQnzb5D9r6U/OOqpp3MjSJFDV3y2rSxbq2bFpuYGfcpfpg0xqDMfsaiX2blreCVg5u5
         Lo/A==
X-Gm-Message-State: APjAAAV05OJLkabTqKJot6iutJxqeDQrb9bEU6C/BQrZoN0FArxu5KQV
        BWfTttP2FI4n3Hao/4iDX3mVbq2lZ+Azmjfnoxw=
X-Google-Smtp-Source: APXvYqx5Wd2lLoIVcKsrc9UNRJPUPE+8ZEA957etRFWQZwieRHK6GS/2QNAmi4q5aSc1OG19VX+HDVk/L+NhfH3wouU=
X-Received: by 2002:ac8:219d:: with SMTP id 29mr12847045qty.37.1560430217912;
 Thu, 13 Jun 2019 05:50:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190612155605.22450-1-maximmi@mellanox.com> <20190612155605.22450-3-maximmi@mellanox.com>
In-Reply-To: <20190612155605.22450-3-maximmi@mellanox.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 13 Jun 2019 14:50:06 +0200
Message-ID: <CAJ+HfNhY0fMa2QiJJM0xnrzcPWw4ZYKoFjMrD03wfL0aKSnoyg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 02/17] xsk: Add API to check for available
 entries in FQ
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
> Add a function that checks whether the Fill Ring has the specified
> amount of descriptors available. It will be useful for mlx5e that wants
> to check in advance, whether it can allocate a bulk of RX descriptors,
> to get the best performance.
>

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
> Acked-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  include/net/xdp_sock.h | 21 +++++++++++++++++++++
>  net/xdp/xsk.c          |  6 ++++++
>  net/xdp/xsk_queue.h    | 14 ++++++++++++++
>  3 files changed, 41 insertions(+)
>
> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> index ae0f368a62bb..b6f5ebae43a1 100644
> --- a/include/net/xdp_sock.h
> +++ b/include/net/xdp_sock.h
> @@ -77,6 +77,7 @@ int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp);
>  void xsk_flush(struct xdp_sock *xs);
>  bool xsk_is_setup_for_bpf_map(struct xdp_sock *xs);
>  /* Used from netdev driver */
> +bool xsk_umem_has_addrs(struct xdp_umem *umem, u32 cnt);
>  u64 *xsk_umem_peek_addr(struct xdp_umem *umem, u64 *addr);
>  void xsk_umem_discard_addr(struct xdp_umem *umem);
>  void xsk_umem_complete_tx(struct xdp_umem *umem, u32 nb_entries);
> @@ -99,6 +100,16 @@ static inline dma_addr_t xdp_umem_get_dma(struct xdp_=
umem *umem, u64 addr)
>  }
>
>  /* Reuse-queue aware version of FILL queue helpers */
> +static inline bool xsk_umem_has_addrs_rq(struct xdp_umem *umem, u32 cnt)
> +{
> +       struct xdp_umem_fq_reuse *rq =3D umem->fq_reuse;
> +
> +       if (rq->length >=3D cnt)
> +               return true;
> +
> +       return xsk_umem_has_addrs(umem, cnt - rq->length);
> +}
> +
>  static inline u64 *xsk_umem_peek_addr_rq(struct xdp_umem *umem, u64 *add=
r)
>  {
>         struct xdp_umem_fq_reuse *rq =3D umem->fq_reuse;
> @@ -146,6 +157,11 @@ static inline bool xsk_is_setup_for_bpf_map(struct x=
dp_sock *xs)
>         return false;
>  }
>
> +static inline bool xsk_umem_has_addrs(struct xdp_umem *umem, u32 cnt)
> +{
> +       return false;
> +}
> +
>  static inline u64 *xsk_umem_peek_addr(struct xdp_umem *umem, u64 *addr)
>  {
>         return NULL;
> @@ -200,6 +216,11 @@ static inline dma_addr_t xdp_umem_get_dma(struct xdp=
_umem *umem, u64 addr)
>         return 0;
>  }
>
> +static inline bool xsk_umem_has_addrs_rq(struct xdp_umem *umem, u32 cnt)
> +{
> +       return false;
> +}
> +
>  static inline u64 *xsk_umem_peek_addr_rq(struct xdp_umem *umem, u64 *add=
r)
>  {
>         return NULL;
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index a14e8864e4fa..b68a380f50b3 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -37,6 +37,12 @@ bool xsk_is_setup_for_bpf_map(struct xdp_sock *xs)
>                 READ_ONCE(xs->umem->fq);
>  }
>
> +bool xsk_umem_has_addrs(struct xdp_umem *umem, u32 cnt)
> +{
> +       return xskq_has_addrs(umem->fq, cnt);
> +}
> +EXPORT_SYMBOL(xsk_umem_has_addrs);
> +
>  u64 *xsk_umem_peek_addr(struct xdp_umem *umem, u64 *addr)
>  {
>         return xskq_peek_addr(umem->fq, addr);
> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> index 88b9ae24658d..12b49784a6d5 100644
> --- a/net/xdp/xsk_queue.h
> +++ b/net/xdp/xsk_queue.h
> @@ -117,6 +117,20 @@ static inline u32 xskq_nb_free(struct xsk_queue *q, =
u32 producer, u32 dcnt)
>         return q->nentries - (producer - q->cons_tail);
>  }
>
> +static inline bool xskq_has_addrs(struct xsk_queue *q, u32 cnt)
> +{
> +       u32 entries =3D q->prod_tail - q->cons_tail;
> +
> +       if (entries >=3D cnt)
> +               return true;
> +
> +       /* Refresh the local pointer. */
> +       q->prod_tail =3D READ_ONCE(q->ring->producer);
> +       entries =3D q->prod_tail - q->cons_tail;
> +
> +       return entries >=3D cnt;
> +}
> +
>  /* UMEM queue */
>
>  static inline bool xskq_is_valid_addr(struct xsk_queue *q, u64 addr)
> --
> 2.19.1
>
