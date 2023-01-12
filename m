Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11EB667EF7
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 20:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240317AbjALTW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 14:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240294AbjALTW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 14:22:29 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F938DED6
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 11:10:37 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id cx21-20020a17090afd9500b00228f2ecc6dbso3106408pjb.0
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 11:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=53sdGuq/NzWHU0jo/zzueJzKJrvMxD2g4VsVI/pFtHc=;
        b=YEIiYNVa55JvhyoIkYkAQT//OfhY0VspcCBp3zgji61sxmcxZMysmtq3Qf/AKgmul2
         l9oDgoo/Ml8heMTiwpxIbYay/HKWD2snaB2tuYPEeubkeNow/UkO+oPWDzDw0AOa+EBd
         IOVCdr6b0VQQdL1KQAIfB3iDurww8/HbhTLSOiYwHj9eY6Bp383/AXh4XGEpq62OfB00
         +z7pNUGRlCzPOk66OqHfC8TAfsy5nfjN+Oz3ONejKqAaT28qDBjYWeGYGRbSuvNDKA3h
         MU+LW1E2DzN4AIm4MyZftEc4tD14BoUDZoieCOMVrcrDClRLoqlvInYK5EPSN8fFG+vN
         ZhdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=53sdGuq/NzWHU0jo/zzueJzKJrvMxD2g4VsVI/pFtHc=;
        b=glyKFYnJG0j7dKLsZ9xzMysDt4yWNHMyQ3bvra2YN+E8xVbOcRt2JN/vhZpILFz7j3
         +QdGAFuWmu/91mud33DcKaV0BHqb9DczZy6lj3BD5nNpQP+GCSd4K0B/kSk2ti/JKQ2X
         8KX/WvCqtZP23gT2O32DJ1v7I5SBHVIBCQ7UkpephUlEN0AWPbDieJ/r0U0qed+GtMf8
         0fvg59DV2XDesAmREUWth0k64/EFY9GlHKYBbaQSKMrJGw7Alkr4+amaJI2M3nNaxPi5
         0R+EYBG/UyBx4WosidlAoScFF2GW90dQo+PU1fjcpV3zhergldi6a3UUukVratIdFYOz
         LfIg==
X-Gm-Message-State: AFqh2kpLh4bcmkGiggz5lvGCgwEx4buV+aEEg29A4WbiZOyBDvWnk2dY
        M4tk4VgTnL1zZ4Vz7KP45zlATe0AAMwiXPpC2aDedg==
X-Google-Smtp-Source: AMrXdXt96Y3G4+HAMH54pddeWRxHo/k0fh3wCRv2Mqlt1asl4pr1W92s5WwvxXt7cKqXwyWDnZNOxzujXI2Q0ImhQGk=
X-Received: by 2002:a17:902:a506:b0:189:97e2:ab8b with SMTP id
 s6-20020a170902a50600b0018997e2ab8bmr8450862plq.131.1673550636298; Thu, 12
 Jan 2023 11:10:36 -0800 (PST)
MIME-Version: 1.0
References: <20230112003230.3779451-1-sdf@google.com> <20230112003230.3779451-16-sdf@google.com>
 <a0bac9bd-6772-64d4-8fd5-756ff4d8c2ad@gmail.com>
In-Reply-To: <a0bac9bd-6772-64d4-8fd5-756ff4d8c2ad@gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 12 Jan 2023 11:10:24 -0800
Message-ID: <CAKH8qBsUOdRax0m5XM8guudSX_VYpJuMz_mzdMJegDsq4_ezwA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 15/17] net/mlx5e: Introduce wrapper for xdp_buff
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
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

On Thu, Jan 12, 2023 at 12:07 AM Tariq Toukan <ttoukan.linux@gmail.com> wro=
te:
>
>
>
> On 12/01/2023 2:32, Stanislav Fomichev wrote:
> > From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >
> > Preparation for implementing HW metadata kfuncs. No functional change.
> >
> > Cc: Tariq Toukan <tariqt@nvidia.com>
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
> >   drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
> >   .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  3 +-
> >   .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  6 +-
> >   .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 25 ++++----
> >   .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 58 +++++++++---------=
-
> >   5 files changed, 50 insertions(+), 43 deletions(-)
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
>
> In XSK files below you mix usage of both alloc_units[page_idx].mxbuf and
> alloc_units[page_idx].xsk, while both fields share the memory of a union.
>
> As struct mlx5e_xdp_buff wraps struct xdp_buff, I think that you just
> need to change the existing xsk field type from struct xdp_buff *xsk
> into struct mlx5e_xdp_buff *xsk and align the usage.

Hmmm, good point. I'm actually not sure how it works currently.
mlx5e_alloc_unit.mxbuf doesn't seem to be initialized anywhere? Toke,
am I missing something?

I'm thinking about something like this:

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h
b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index af663978d1b4..2d77fb8a8a01 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -469,7 +469,6 @@ struct mlx5e_txqsq {
 union mlx5e_alloc_unit {
        struct page *page;
        struct xdp_buff *xsk;
-       struct mlx5e_xdp_buff *mxbuf;
 };

 /* XDP packets can be transmitted in different ways. On completion, we nee=
d to
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index 9cff82d764e3..fd0805df34b7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -234,7 +234,8 @@ struct sk_buff
*mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
                                                    u32 head_offset,
                                                    u32 page_idx)
 {
-       struct mlx5e_xdp_buff *mxbuf =3D wi->alloc_units[page_idx].mxbuf;
+       struct mlx5e_xdp_buff *mxbuf =3D
container_of(wi->alloc_units[page_idx].xsk,
+                                                   struct mlx5e_xdp_buff, =
xdp);
        struct bpf_prog *prog;

        /* Check packet size. Note LRO doesn't use linear SKB */
@@ -286,7 +287,8 @@ struct sk_buff
*mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
                                              struct mlx5e_wqe_frag_info *w=
i,
                                              u32 cqe_bcnt)
 {
-       struct mlx5e_xdp_buff *mxbuf =3D wi->au->mxbuf;
+       struct mlx5e_xdp_buff *mxbuf =3D container_of(wi->au->xsk,
+                                                   struct mlx5e_xdp_buff, =
xdp);
        struct bpf_prog *prog;

        /* wi->offset is not used in this function, because xdp->data and t=
he

Does it look sensible?


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
> > index c8820ab22169..6affdddf5bcf 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> > @@ -1575,11 +1575,11 @@ struct sk_buff *mlx5e_build_linear_skb(struct m=
lx5e_rq *rq, void *va,
> >       return skb;
> >   }
> >
> > -static void mlx5e_fill_xdp_buff(struct mlx5e_rq *rq, void *va, u16 hea=
droom,
> > -                             u32 len, struct xdp_buff *xdp)
> > +static void mlx5e_fill_mxbuf(struct mlx5e_rq *rq, void *va, u16 headro=
om,
> > +                          u32 len, struct mlx5e_xdp_buff *mxbuf)
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
> > +             struct mlx5e_xdp_buff mxbuf;
> >
> >               net_prefetchw(va); /* xdp_frame data area */
> > -             mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &xdp);
> > -             if (mlx5e_xdp_handle(rq, au->page, prog, &xdp))
> > +             mlx5e_fill_mxbuf(rq, cqe, va, rx_headroom, cqe_bcnt, &mxb=
uf);
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
> > +     mlx5e_fill_mxbuf(rq, va, rx_headroom, frag_consumed_bytes, &mxbuf=
);
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
> > +             mlx5e_fill_mxbuf(rq, va, rx_headroom, cqe_bcnt, &mxbuf);
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
