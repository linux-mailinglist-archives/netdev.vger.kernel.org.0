Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E27B46475F5
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 20:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbiLHTHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 14:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiLHTHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 14:07:20 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89DD592FEC
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 11:07:17 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id c13so2028590pfp.5
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 11:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0pERAo/ZUY9HPHqlXk6GLorKGil/4lwotRBEEP3U6BA=;
        b=A+s2Ha6RpdyJvZKOPICTQHccx65R6tx+6+1yRtvT+NGr+1XksaFfbh3Fyo6o0MWGLd
         vjXw68egtpDzwDZ3tXmdJSD+vvdzxDFYu4S+JA81KNSvBAkEOmEuvKS0ksH77zWMaJLD
         1cxLoiuXot4WxmwATOci1ArkYjMyqd873MjMQSC8a3vQb2jVQYMcGzUMYzpY4GAMMIQC
         YDJp0Gc3djv3E6bQcZgoOSxriLkvdPH5ldZ1XRS07Jldh9oAZC30H/gi0kgGOzkRr3Gv
         1pGoIIxWpiNGDjHjeVpjckToQSBMV+TuQVy2faTmWIEqNl9Tj/6FGBe/xkEZcPMOvcV3
         WbyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0pERAo/ZUY9HPHqlXk6GLorKGil/4lwotRBEEP3U6BA=;
        b=WfFxFbHRVJdefC+N988yBJ8sE6NFeQCxEqDO92B7BJISKb3tmHUiKP0jv4pDUOq6SQ
         Txexnh0ZxVWbn+a9HHNJx3ohLy8gMFoexCSva3wY9ceoiQcZgmdtyrzlSZhu3K04ZxCf
         6N8oDLIsmhJm5XD6aBN1eKLN0gNXddUOP5/5l8F2EONXZHNaPxyGzL9UY7VTE6EN3OJy
         BMTUt4NiBWqRu75I7qT6EtwoyVmT3+Ls2Qn3qpgQsggb/OqfN8rX4YfzUOdjvpsjJbel
         Vkv3aNL/kfkP6csu+9g5CGLS05lnS+zPjxxNPImT+TdfRbjoJawkPpg1c8tJ4EZ0I/Z1
         YvRg==
X-Gm-Message-State: ANoB5pmVu7vTgLBAo+KrdK43r3hzfwLmui3kgr26FRZnGsC6DuMAWDRg
        +UdM+dobud/eilZ/hNi17Ja+38H53m7flQd5abgbWQ==
X-Google-Smtp-Source: AA0mqf5dmNfyJ3xh5zt+N4zrlJJXwQvF0SdoOdXSqDlNIN4+gU3J2R3fvV2gJd0gSqaMRCEor4zBdu7N/72ru8DWnfY=
X-Received: by 2002:a63:4c01:0:b0:478:b7ab:2f72 with SMTP id
 z1-20020a634c01000000b00478b7ab2f72mr16273057pga.186.1670526436918; Thu, 08
 Dec 2022 11:07:16 -0800 (PST)
MIME-Version: 1.0
References: <20221206024554.3826186-1-sdf@google.com> <20221206024554.3826186-8-sdf@google.com>
 <8d5f451a-c49b-1abc-6573-71831aa09739@gmail.com>
In-Reply-To: <8d5f451a-c49b-1abc-6573-71831aa09739@gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 8 Dec 2022 11:07:05 -0800
Message-ID: <CAKH8qBsh+XgHqGt+-wwOSV_F0Skiz_erFApZ=HAUWP1hvEoAZg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 07/12] mlx4: Introduce mlx4_xdp_buff wrapper
 for xdp_buff
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 7, 2022 at 10:11 PM Tariq Toukan <ttoukan.linux@gmail.com> wrote:
>
>
>
> On 12/6/2022 4:45 AM, Stanislav Fomichev wrote:
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
> > index 8f762fc170b3..9c114fc723e3 100644
> > --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> > +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> > @@ -661,9 +661,14 @@ static int check_csum(struct mlx4_cqe *cqe, struct sk_buff *skb, void *va,
> >   #define MLX4_CQE_STATUS_IP_ANY (MLX4_CQE_STATUS_IPV4)
> >   #endif
> >
> > +struct mlx4_xdp_buff {
> > +     struct xdp_buff xdp;
> > +};
> > +
>
> Prefer name with 'en', struct mlx4_en_xdp_buff.

Sure, will rename!


> >   int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int budget)
> >   {
> >       struct mlx4_en_priv *priv = netdev_priv(dev);
> > +     struct mlx4_xdp_buff mxbuf = {};
> >       int factor = priv->cqe_factor;
> >       struct mlx4_en_rx_ring *ring;
> >       struct bpf_prog *xdp_prog;
> > @@ -671,7 +676,6 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
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
