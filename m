Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01765663437
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 23:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237313AbjAIWow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 17:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbjAIWou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 17:44:50 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0222BC1
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 14:44:48 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id o13so6847895pjg.2
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 14:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vXPi1qIdFWXgkJ0323UgY8MArjHduf1UYDdur6/ZSoY=;
        b=ddvLN2fNiX3NMoU/J1+nAZAyJ4iNLV7pgnE0s9K+FITuIikIYYQx+q2fIvFlKNhj+j
         17o3qWONn6DHNPIOuLEBQ04kePHBZkH5cIpd9e8DWP8C6ZmnFmwK0hsPDP07/RIL5548
         VQhBiCgJHROP57+bbMwHfm/6M34ANwdO1YKctrHXSgT6XBjYxGMVHJZl1BGxwsLNmJpp
         TrT+EPQMHof9tcohMeErnYju7vRF2o9sGP+Qtcw1p+1KBXU19MnTl1AdhTFel6hkYGSr
         MIe3DjZhrMTi2kGUZsZ+Cr0A5QVdYDX3/d/cWrljHiWYjfVkvzkAhVNsED5yeLB/9ymV
         v6yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vXPi1qIdFWXgkJ0323UgY8MArjHduf1UYDdur6/ZSoY=;
        b=NjGjaNEjJgjVbkYbO7QLNTyoD9b3iOXcBkvZLjkP4n6KjOFkGXKx8JpgcMjmSRXuRQ
         XHc8E/NvCwgFMhD58Qle/h/lL7hnCaq1vs582sJ9qhGWOKo3gnDbCzFqf/9u7SPY4C95
         q3JuSWNY3jsbqEJHE/JbJ4mJSaySqItDuGpDfBICYFIAAJoo0IgYHKyC2F5vM5HF+iqS
         XeG/HS7JQFj7GUiX06OqQMHQ3Sm3MvRtIs1XE8DAAXI4SZFnYmLfBDuIJORYEbESBSdc
         yP1t1bhMK/6SNCLNFKfNd2wuT8Tf9gtLUV0BcU9xEg7P3Hb2ex9ZOiwEv0s8NeFmaMnS
         xh/Q==
X-Gm-Message-State: AFqh2krktmykHfqsKhM/mvhUENFBJ3R+ppcSdppuoN4C0gSeOiKVKTE1
        HT6XrsD8MjBzvxLw353ZT2OSJ3R62Vz8jdJWLx29qw==
X-Google-Smtp-Source: AMrXdXtHCBOEZXK8GlIjK0GXxqt4+erG2Vmz43r56qJFk5wyqK1qp+n9pQFXpwbHd/GnMFNF6YO3fSbJKWh5bg9G9bY=
X-Received: by 2002:a17:902:b20d:b0:191:283d:612e with SMTP id
 t13-20020a170902b20d00b00191283d612emr3300551plr.88.1673304287798; Mon, 09
 Jan 2023 14:44:47 -0800 (PST)
MIME-Version: 1.0
References: <20230104215949.529093-1-sdf@google.com> <20230104215949.529093-16-sdf@google.com>
 <c91c22db-a59f-20de-0229-722900f1ce59@gmail.com>
In-Reply-To: <c91c22db-a59f-20de-0229-722900f1ce59@gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 9 Jan 2023 14:44:35 -0800
Message-ID: <CAKH8qBu-rAyfq+-cTRQLe+Dw4Hh-apeN-1PKQq3SKBRc_SDOyA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 15/17] net/mlx5e: Introduce wrapper for xdp_buff
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 7, 2023 at 11:38 PM Tariq Toukan <ttoukan.linux@gmail.com> wrot=
e:
>
>
>
> On 04/01/2023 23:59, Stanislav Fomichev wrote:
> > From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >
> > Preparation for implementing HW metadata kfuncs. No functional change.
> >
> > Cc: Saeed Mahameed <saeedm@nvidia.com>
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: David Ahern <dsahern@gmail.com>
> > Cc: Martin KaFai Lau <martin.lau@linux.dev>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Willem de Bruijn <willemb@google.com>
> > Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> > Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> > Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> > Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> > Cc: Maryam Tahhan <mtahhan@redhat.com>
> > Cc: xdp-hints@xdp-project.net
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
>
> Thanks for you patch.
> Find 1 minor comment below.
>
> >   drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
> >   .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  3 +-
> >   .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  6 +-
> >   .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 25 +++++----
> >   .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 56 +++++++++---------=
-
> >   5 files changed, 49 insertions(+), 42 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net=
/ethernet/mellanox/mlx5/core/en.h
> > index 2d77fb8a8a01..af663978d1b4 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> > @@ -469,6 +469,7 @@ struct mlx5e_txqsq {
> >   union mlx5e_alloc_unit {
> >       struct page *page;
> >       struct xdp_buff *xsk;
> > +     struct mlx5e_xdp_buff *mxbuf;
> >   };
> >
> >   /* XDP packets can be transmitted in different ways. On completion, w=
e need to
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers=
/net/ethernet/mellanox/mlx5/core/en/xdp.c
> > index 20507ef2f956..31bb6806bf5d 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> > @@ -158,8 +158,9 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct =
mlx5e_rq *rq,
> >
> >   /* returns true if packet was consumed by xdp */
> >   bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct page *page,
> > -                   struct bpf_prog *prog, struct xdp_buff *xdp)
> > +                   struct bpf_prog *prog, struct mlx5e_xdp_buff *mxbuf=
)
> >   {
> > +     struct xdp_buff *xdp =3D &mxbuf->xdp;
> >       u32 act;
> >       int err;
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers=
/net/ethernet/mellanox/mlx5/core/en/xdp.h
> > index bc2d9034af5b..389818bf6833 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
> > @@ -44,10 +44,14 @@
> >       (MLX5E_XDP_INLINE_WQE_MAX_DS_CNT * MLX5_SEND_WQE_DS - \
> >        sizeof(struct mlx5_wqe_inline_seg))
> >
> > +struct mlx5e_xdp_buff {
> > +     struct xdp_buff xdp;
> > +};
> > +
> >   struct mlx5e_xsk_param;
> >   int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_p=
aram *xsk);
> >   bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct page *page,
> > -                   struct bpf_prog *prog, struct xdp_buff *xdp);
> > +                   struct bpf_prog *prog, struct mlx5e_xdp_buff *mlctx=
);
> >   void mlx5e_xdp_mpwqe_complete(struct mlx5e_xdpsq *sq);
> >   bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq);
> >   void mlx5e_free_xdpsq_descs(struct mlx5e_xdpsq *sq);
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/driv=
ers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> > index c91b54d9ff27..9cff82d764e3 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> > @@ -22,6 +22,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16=
 ix)
> >               goto err;
> >
> >       BUILD_BUG_ON(sizeof(wi->alloc_units[0]) !=3D sizeof(wi->alloc_uni=
ts[0].xsk));
> > +     XSK_CHECK_PRIV_TYPE(struct mlx5e_xdp_buff);
> >       batch =3D xsk_buff_alloc_batch(rq->xsk_pool, (struct xdp_buff **)=
wi->alloc_units,
> >                                    rq->mpwqe.pages_per_wqe);
> >
> > @@ -233,7 +234,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear=
(struct mlx5e_rq *rq,
> >                                                   u32 head_offset,
> >                                                   u32 page_idx)
> >   {
> > -     struct xdp_buff *xdp =3D wi->alloc_units[page_idx].xsk;
> > +     struct mlx5e_xdp_buff *mxbuf =3D wi->alloc_units[page_idx].mxbuf;
> >       struct bpf_prog *prog;
> >
> >       /* Check packet size. Note LRO doesn't use linear SKB */
> > @@ -249,9 +250,9 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear=
(struct mlx5e_rq *rq,
> >        */
> >       WARN_ON_ONCE(head_offset);
> >
> > -     xsk_buff_set_size(xdp, cqe_bcnt);
> > -     xsk_buff_dma_sync_for_cpu(xdp, rq->xsk_pool);
> > -     net_prefetch(xdp->data);
> > +     xsk_buff_set_size(&mxbuf->xdp, cqe_bcnt);
> > +     xsk_buff_dma_sync_for_cpu(&mxbuf->xdp, rq->xsk_pool);
> > +     net_prefetch(mxbuf->xdp.data);
> >
> >       /* Possible flows:
> >        * - XDP_REDIRECT to XSKMAP:
> > @@ -269,7 +270,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear=
(struct mlx5e_rq *rq,
> >        */
> >
> >       prog =3D rcu_dereference(rq->xdp_prog);
> > -     if (likely(prog && mlx5e_xdp_handle(rq, NULL, prog, xdp))) {
> > +     if (likely(prog && mlx5e_xdp_handle(rq, NULL, prog, mxbuf))) {
> >               if (likely(__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, r=
q->flags)))
> >                       __set_bit(page_idx, wi->xdp_xmit_bitmap); /* non-=
atomic */
> >               return NULL; /* page/packet was consumed by XDP */
> > @@ -278,14 +279,14 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_line=
ar(struct mlx5e_rq *rq,
> >       /* XDP_PASS: copy the data from the UMEM to a new SKB and reuse t=
he
> >        * frame. On SKB allocation failure, NULL is returned.
> >        */
> > -     return mlx5e_xsk_construct_skb(rq, xdp);
> > +     return mlx5e_xsk_construct_skb(rq, &mxbuf->xdp);
> >   }
> >
> >   struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
> >                                             struct mlx5e_wqe_frag_info =
*wi,
> >                                             u32 cqe_bcnt)
> >   {
> > -     struct xdp_buff *xdp =3D wi->au->xsk;
> > +     struct mlx5e_xdp_buff *mxbuf =3D wi->au->mxbuf;
> >       struct bpf_prog *prog;
> >
> >       /* wi->offset is not used in this function, because xdp->data and=
 the
> > @@ -295,17 +296,17 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(str=
uct mlx5e_rq *rq,
> >        */
> >       WARN_ON_ONCE(wi->offset);
> >
> > -     xsk_buff_set_size(xdp, cqe_bcnt);
> > -     xsk_buff_dma_sync_for_cpu(xdp, rq->xsk_pool);
> > -     net_prefetch(xdp->data);
> > +     xsk_buff_set_size(&mxbuf->xdp, cqe_bcnt);
> > +     xsk_buff_dma_sync_for_cpu(&mxbuf->xdp, rq->xsk_pool);
> > +     net_prefetch(mxbuf->xdp.data);
> >
> >       prog =3D rcu_dereference(rq->xdp_prog);
> > -     if (likely(prog && mlx5e_xdp_handle(rq, NULL, prog, xdp)))
> > +     if (likely(prog && mlx5e_xdp_handle(rq, NULL, prog, mxbuf)))
> >               return NULL; /* page/packet was consumed by XDP */
> >
> >       /* XDP_PASS: copy the data from the UMEM to a new SKB. The frame =
reuse
> >        * will be handled by mlx5e_free_rx_wqe.
> >        * On SKB allocation failure, NULL is returned.
> >        */
> > -     return mlx5e_xsk_construct_skb(rq, xdp);
> > +     return mlx5e_xsk_construct_skb(rq, &mxbuf->xdp);
> >   }
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en_rx.c
> > index c8820ab22169..c8a2b26de36e 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> > @@ -1576,10 +1576,10 @@ struct sk_buff *mlx5e_build_linear_skb(struct m=
lx5e_rq *rq, void *va,
> >   }
> >
> >   static void mlx5e_fill_xdp_buff(struct mlx5e_rq *rq, void *va, u16 he=
adroom,
>
> This now acts on an mlx5e_xdp_buff object. How about changing the func
> name accordingly?
>
> The obvious rename to mlx5e_fill_mlx5e_xdp_buff doesn't work here.
> Maybe mlx5e_fill_mxbuf ?

mlx5e_fill_mxbuf SG, fix rename.


> > -                             u32 len, struct xdp_buff *xdp)
> > +                             u32 len, struct mlx5e_xdp_buff *mxbuf)
> >   {
> > -     xdp_init_buff(xdp, rq->buff.frame0_sz, &rq->xdp_rxq);
> > -     xdp_prepare_buff(xdp, va, headroom, len, true);
> > +     xdp_init_buff(&mxbuf->xdp, rq->buff.frame0_sz, &rq->xdp_rxq);
> > +     xdp_prepare_buff(&mxbuf->xdp, va, headroom, len, true);
> >   }
> >
> >   static struct sk_buff *
> > @@ -1606,16 +1606,16 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, =
struct mlx5e_wqe_frag_info *wi,
> >
> >       prog =3D rcu_dereference(rq->xdp_prog);
> >       if (prog) {
> > -             struct xdp_buff xdp;
> > +             struct mlx5e_xdp_buff mxbuf >
> >               net_prefetchw(va); /* xdp_frame data area */
> > -             mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &xdp);
> > -             if (mlx5e_xdp_handle(rq, au->page, prog, &xdp))
> > +             mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &mxbuf=
);
> > +             if (mlx5e_xdp_handle(rq, au->page, prog, &mxbuf))
> >                       return NULL; /* page/packet was consumed by XDP *=
/
> >
> > -             rx_headroom =3D xdp.data - xdp.data_hard_start;
> > -             metasize =3D xdp.data - xdp.data_meta;
> > -             cqe_bcnt =3D xdp.data_end - xdp.data;
> > +             rx_headroom =3D mxbuf.xdp.data - mxbuf.xdp.data_hard_star=
t;
> > +             metasize =3D mxbuf.xdp.data - mxbuf.xdp.data_meta;
> > +             cqe_bcnt =3D mxbuf.xdp.data_end - mxbuf.xdp.data;
> >       }
> >       frag_size =3D MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt);
> >       skb =3D mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cq=
e_bcnt, metasize);
> > @@ -1637,9 +1637,9 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq,=
 struct mlx5e_wqe_frag_info *wi
> >       union mlx5e_alloc_unit *au =3D wi->au;
> >       u16 rx_headroom =3D rq->buff.headroom;
> >       struct skb_shared_info *sinfo;
> > +     struct mlx5e_xdp_buff mxbuf;
> >       u32 frag_consumed_bytes;
> >       struct bpf_prog *prog;
> > -     struct xdp_buff xdp;
> >       struct sk_buff *skb;
> >       dma_addr_t addr;
> >       u32 truesize;
> > @@ -1654,8 +1654,8 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq,=
 struct mlx5e_wqe_frag_info *wi
> >       net_prefetchw(va); /* xdp_frame data area */
> >       net_prefetch(va + rx_headroom);
> >
> > -     mlx5e_fill_xdp_buff(rq, va, rx_headroom, frag_consumed_bytes, &xd=
p);
> > -     sinfo =3D xdp_get_shared_info_from_buff(&xdp);
> > +     mlx5e_fill_xdp_buff(rq, va, rx_headroom, frag_consumed_bytes, &mx=
buf);
> > +     sinfo =3D xdp_get_shared_info_from_buff(&mxbuf.xdp);
> >       truesize =3D 0;
> >
> >       cqe_bcnt -=3D frag_consumed_bytes;
> > @@ -1673,13 +1673,13 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *r=
q, struct mlx5e_wqe_frag_info *wi
> >               dma_sync_single_for_cpu(rq->pdev, addr + wi->offset,
> >                                       frag_consumed_bytes, rq->buff.map=
_dir);
> >
> > -             if (!xdp_buff_has_frags(&xdp)) {
> > +             if (!xdp_buff_has_frags(&mxbuf.xdp)) {
> >                       /* Init on the first fragment to avoid cold cache=
 access
> >                        * when possible.
> >                        */
> >                       sinfo->nr_frags =3D 0;
> >                       sinfo->xdp_frags_size =3D 0;
> > -                     xdp_buff_set_frags_flag(&xdp);
> > +                     xdp_buff_set_frags_flag(&mxbuf.xdp);
> >               }
> >
> >               frag =3D &sinfo->frags[sinfo->nr_frags++];
> > @@ -1688,7 +1688,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq,=
 struct mlx5e_wqe_frag_info *wi
> >               skb_frag_size_set(frag, frag_consumed_bytes);
> >
> >               if (page_is_pfmemalloc(au->page))
> > -                     xdp_buff_set_frag_pfmemalloc(&xdp);
> > +                     xdp_buff_set_frag_pfmemalloc(&mxbuf.xdp);
> >
> >               sinfo->xdp_frags_size +=3D frag_consumed_bytes;
> >               truesize +=3D frag_info->frag_stride;
> > @@ -1701,7 +1701,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq,=
 struct mlx5e_wqe_frag_info *wi
> >       au =3D head_wi->au;
> >
> >       prog =3D rcu_dereference(rq->xdp_prog);
> > -     if (prog && mlx5e_xdp_handle(rq, au->page, prog, &xdp)) {
> > +     if (prog && mlx5e_xdp_handle(rq, au->page, prog, &mxbuf)) {
> >               if (test_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
> >                       int i;
> >
> > @@ -1711,22 +1711,22 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *r=
q, struct mlx5e_wqe_frag_info *wi
> >               return NULL; /* page/packet was consumed by XDP */
> >       }
> >
> > -     skb =3D mlx5e_build_linear_skb(rq, xdp.data_hard_start, rq->buff.=
frame0_sz,
> > -                                  xdp.data - xdp.data_hard_start,
> > -                                  xdp.data_end - xdp.data,
> > -                                  xdp.data - xdp.data_meta);
> > +     skb =3D mlx5e_build_linear_skb(rq, mxbuf.xdp.data_hard_start, rq-=
>buff.frame0_sz,
> > +                                  mxbuf.xdp.data - mxbuf.xdp.data_hard=
_start,
> > +                                  mxbuf.xdp.data_end - mxbuf.xdp.data,
> > +                                  mxbuf.xdp.data - mxbuf.xdp.data_meta=
);
> >       if (unlikely(!skb))
> >               return NULL;
> >
> >       page_ref_inc(au->page);
> >
> > -     if (unlikely(xdp_buff_has_frags(&xdp))) {
> > +     if (unlikely(xdp_buff_has_frags(&mxbuf.xdp))) {
> >               int i;
> >
> >               /* sinfo->nr_frags is reset by build_skb, calculate again=
. */
> >               xdp_update_skb_shared_info(skb, wi - head_wi - 1,
> >                                          sinfo->xdp_frags_size, truesiz=
e,
> > -                                        xdp_buff_is_frag_pfmemalloc(&x=
dp));
> > +                                        xdp_buff_is_frag_pfmemalloc(&m=
xbuf.xdp));
> >
> >               for (i =3D 0; i < sinfo->nr_frags; i++) {
> >                       skb_frag_t *frag =3D &sinfo->frags[i];
> > @@ -2007,19 +2007,19 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq=
 *rq, struct mlx5e_mpw_info *wi,
> >
> >       prog =3D rcu_dereference(rq->xdp_prog);
> >       if (prog) {
> > -             struct xdp_buff xdp;
> > +             struct mlx5e_xdp_buff mxbuf;
> >
> >               net_prefetchw(va); /* xdp_frame data area */
> > -             mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &xdp);
> > -             if (mlx5e_xdp_handle(rq, au->page, prog, &xdp)) {
> > +             mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &mxbuf=
);
> > +             if (mlx5e_xdp_handle(rq, au->page, prog, &mxbuf)) {
> >                       if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, =
rq->flags))
> >                               __set_bit(page_idx, wi->xdp_xmit_bitmap);=
 /* non-atomic */
> >                       return NULL; /* page/packet was consumed by XDP *=
/
> >               }
> >
> > -             rx_headroom =3D xdp.data - xdp.data_hard_start;
> > -             metasize =3D xdp.data - xdp.data_meta;
> > -             cqe_bcnt =3D xdp.data_end - xdp.data;
> > +             rx_headroom =3D mxbuf.xdp.data - mxbuf.xdp.data_hard_star=
t;
> > +             metasize =3D mxbuf.xdp.data - mxbuf.xdp.data_meta;
> > +             cqe_bcnt =3D mxbuf.xdp.data_end - mxbuf.xdp.data;
> >       }
> >       frag_size =3D MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt);
> >       skb =3D mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cq=
e_bcnt, metasize);
