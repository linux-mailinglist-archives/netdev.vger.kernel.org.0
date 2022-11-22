Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B0B63434C
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 19:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbiKVSIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 13:08:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234400AbiKVSIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 13:08:43 -0500
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC28C2DAB5
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:08:41 -0800 (PST)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-13bd19c3b68so18126386fac.7
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=G/+CkOXYfB8ZlUe0lQxCv/js581DawFiKZd9/L8amPg=;
        b=DvYBNWd1xYf7d67xFw1/x61RfV/5IW+zP9pZIJ2PiG+227mHRlD1q5hoSn68yaA+zn
         mbSK/wCfR24MhIyezTDIvLNVx2YTk9wHO3PQxir2C6pogUq61dtkBiFhSIBmRTA2eQTy
         6euybBgmtWqw+KtVQWW1exti8Id2WMQXBLOTw7l7IV2j8P711KtDtR8pQ3FHg96DowZu
         Cikk88vSkkrilH7k5wbqMJf5DOzvNAh88cQdzZ++ssNLid0rH5s2EZO1Jh/xoWRHnMzy
         MZIEWSHIdzfjQ3zecTKcKG2oCgXRZ/odIz5Xj4VXt8nEIwgeecZKAywmwiS83FouxZqw
         OZYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G/+CkOXYfB8ZlUe0lQxCv/js581DawFiKZd9/L8amPg=;
        b=4Z/DpIB4M017WYbQ4qkcra8flY0j+lZj4sreWnBC2mZAlIn35zfVnXklLQ/TZJ6inw
         9vHVWN6smnWPqjJ/iTLvCuW/0/XG/JDNinPFlYVhUDVk8GgWY8gxIO80LrIIJcrg6rfu
         kSGxfNy1dtgSb07xyoyOOU+GDgT+TT5qvOwja6IUjAyW1wYYrPINZ6iOr63P+th9jJW1
         8JgcTuwdxeJ/J2t3JQ4qDvljH6KCuqbtobkI0UsLtYLCqZb8m79CUa7fyy4bBMTE16p9
         7FSnVTOwdhf/ZonTp/w2/ACu7dme4LVhveuan/BHRCfsuN9wfJFq/1r12a2P8kGjh/Uz
         SThA==
X-Gm-Message-State: ANoB5pl8hDhg1yd1y3zY0HIPWQ9XU93HhPKngZmlf5BDAIc6jIi2i1BG
        fJyTKY112HiNvopPh/A3jYyHBjgOg47+OauOsN0vDQ==
X-Google-Smtp-Source: AA0mqf7FGjCj2A1KXbRxjU0cU5r57Sbn9O5FkntMogUbeHHmFLH2gAcufRD++azWzORZiybSCrvmO8x2KYql1YfDs4o=
X-Received: by 2002:a05:6870:9d95:b0:13b:a163:ca6 with SMTP id
 pv21-20020a0568709d9500b0013ba1630ca6mr17548541oab.125.1669140520654; Tue, 22
 Nov 2022 10:08:40 -0800 (PST)
MIME-Version: 1.0
References: <20221121182552.2152891-1-sdf@google.com> <20221121182552.2152891-7-sdf@google.com>
 <b0764e41-b01d-ee28-4e5a-fd306929e75f@gmail.com>
In-Reply-To: <b0764e41-b01d-ee28-4e5a-fd306929e75f@gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 22 Nov 2022 10:08:29 -0800
Message-ID: <CAKH8qBtcXVVeidGiMYNXVMmrOS6G09ADO1LqFLeTHFruY9WO3w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 6/8] mlx4: Introduce mlx4_xdp_buff wrapper for xdp_buff
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
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
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 5:49 AM Tariq Toukan <ttoukan.linux@gmail.com> wrote:
>
>
>
> On 11/21/2022 8:25 PM, Stanislav Fomichev wrote:
> > No functional changes. Boilerplate to allow stuffing more data after xdp_buff.
> >
> > Cc: Tariq Toukan <tariqt@nvidia.com>
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
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >   drivers/net/ethernet/mellanox/mlx4/en_rx.c | 26 +++++++++++++---------
> >   1 file changed, 15 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> > index 8f762fc170b3..467356633172 100644
> > --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> > +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> > @@ -661,17 +661,21 @@ static int check_csum(struct mlx4_cqe *cqe, struct sk_buff *skb, void *va,
> >   #define MLX4_CQE_STATUS_IP_ANY (MLX4_CQE_STATUS_IPV4)
> >   #endif
> >
> > +struct mlx4_xdp_buff {
> > +     struct xdp_buff xdp;
> > +};
> > +
> >   int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int budget)
> >   {
> >       struct mlx4_en_priv *priv = netdev_priv(dev);
> >       int factor = priv->cqe_factor;
> >       struct mlx4_en_rx_ring *ring;
> > +     struct mlx4_xdp_buff this would helpmxbuf;
>
> as it doesn't go through an init function (only mxbuf.xdp does), better
> init to zero.

SG, will do, thanks!

> >       struct bpf_prog *xdp_prog;
> >       int cq_ring = cq->ring;
> >       bool doorbell_pending;
> >       bool xdp_redir_flush;
> >       struct mlx4_cqe *cqe;
> > -     struct xdp_buff xdp;
> >       int polled = 0;
> >       int index;
> >
> > @@ -681,7 +685,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
> >       ring = priv->rx_ring[cq_ring];
> >
> >       xdp_prog = rcu_dereference_bh(ring->xdp_prog);
> > -     xdp_init_buff(&xdp, priv->frag_info[0].frag_stride, &ring->xdp_rxq);
> > +     xdp_init_buff(&mxbuf.xdp, priv->frag_info[0].frag_stride, &ring->xdp_rxq);
> >       doorbell_pending = false;
> >       xdp_redir_flush = false;
> >
> > @@ -776,24 +780,24 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
> >                                               priv->frag_info[0].frag_size,
> >                                               DMA_FROM_DEVICE);
> >
> > -                     xdp_prepare_buff(&xdp, va - frags[0].page_offset,
> > +                     xdp_prepare_buff(&mxbuf.xdp, va - frags[0].page_offset,
> >                                        frags[0].page_offset, length, false);
> > -                     orig_data = xdp.data;
> > +                     orig_data = mxbuf.xdp.data;
> >
> > -                     act = bpf_prog_run_xdp(xdp_prog, &xdp);
> > +                     act = bpf_prog_run_xdp(xdp_prog, &mxbuf.xdp);
> >
> > -                     length = xdp.data_end - xdp.data;
> > -                     if (xdp.data != orig_data) {
> > -                             frags[0].page_offset = xdp.data -
> > -                                     xdp.data_hard_start;
> > -                             va = xdp.data;
> > +                     length = mxbuf.xdp.data_end - mxbuf.xdp.data;
> > +                     if (mxbuf.xdp.data != orig_data) {
> > +                             frags[0].page_offset = mxbuf.xdp.data -
> > +                                     mxbuf.xdp.data_hard_start;
> > +                             va = mxbuf.xdp.data;
> >                       }
> >
> >                       switch (act) {
> >                       case XDP_PASS:
> >                               break;
> >                       case XDP_REDIRECT:
> > -                             if (likely(!xdp_do_redirect(dev, &xdp, xdp_prog))) {
> > +                             if (likely(!xdp_do_redirect(dev, &mxbuf.xdp, xdp_prog))) {
> >                                       ring->xdp_redirect++;
> >                                       xdp_redir_flush = true;
> >                                       frags[0].page = NULL;
