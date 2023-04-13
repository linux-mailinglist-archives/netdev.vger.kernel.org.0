Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 761E16E1260
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 18:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjDMQet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 12:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbjDMQes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 12:34:48 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E980212C
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 09:34:47 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id y63so7691541pgd.13
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 09:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681403687; x=1683995687;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8HvoJ679JuZRdirnHe569ZyC5ZGOdrOnvhMCfAAv7TA=;
        b=3AV1Vq3WEo42XDTB+pzABN4ZQGhRgzKvgGGRMpqjEY4vrCgRQLSc6nldf0HxtaKXa+
         kD56HHiCSZzSyEZZfu2q0r+fSBzScCJ03zomGDfbTkvrRRm5KOh5FzGP1yIyr1JW0Rxq
         mblhLqRHMs7Ag9HWqRwaLyDebTDb3XuOMG+hTbZB1ULS5r2gSRm741v8pVvzIu8TeW/7
         Pqt7v3nQIuQxKmJ1maXy3a2ncJNhstXZ2QWwC5TyAkwUE3W2UxNwQu3T6/C7arQaUu5/
         PYJEZ1dps6WXd/BqMAuuaeE0dsGIcgrRr+a+YWF/8/P36E/Zmbrp52oKsgGKdouWF+dm
         +s7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681403687; x=1683995687;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8HvoJ679JuZRdirnHe569ZyC5ZGOdrOnvhMCfAAv7TA=;
        b=DPcDhUYX4szeePQMPMaACeNuwkOS3Ov6k25ZC0mJ9HBPX3qkA7yDOLDSxdjtm2VidV
         MQFkunLyh2KE4pOMxXZ9xpxDg4Hxeq+p+VqzRV8LorwnPcVjUGnwiU6SZXT9ZVAeHDqM
         scDkAB/uiFrGu2umoAUioiGumJ7ji0oUrhIdHvxOZIaEc7+wXX6BZy61yKUGiBBSL+Wz
         m4tSBPk2fjJrBeC4y9ERBarHzMqkz+bEg7+EkANbKTpeMAqzlvfLeldqi66vtGO2z7Kq
         KjIxXQ9fOWeOWyfD66TH1+OLRDPvrWGzxP5kD0pEVtxBRJociso2Vx/rXB4zZ1DzXGEu
         nW0A==
X-Gm-Message-State: AAQBX9cBaKjV9m8rmwQi1k/iGvv+EhvXYJ6hh6Pi6M80+ZIpHqf6YKMG
        bRDbxSmCq4waJT+8WC7vJ7POAqXsYe73yXn1ZMD6tQ==
X-Google-Smtp-Source: AKy350brZLSKImyACD/vTwBAWkj9JzXf2zpBwAPKP+J93fB14HCkdn9PtWI/qhlPPMVYTW639OYp4l/LOfig57cvsRQ=
X-Received: by 2002:a63:642:0:b0:51b:fa5:7bce with SMTP id 63-20020a630642000000b0051b0fa57bcemr679747pgg.1.1681403686843;
 Thu, 13 Apr 2023 09:34:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230413032541.885238-1-yoong.siang.song@intel.com> <20230413032541.885238-3-yoong.siang.song@intel.com>
In-Reply-To: <20230413032541.885238-3-yoong.siang.song@intel.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 13 Apr 2023 09:34:35 -0700
Message-ID: <CAKH8qBsWwaGrL4X_xkqGtDB_4Qr3oM4wcFcWVtBanCEE6F9gCg@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/3] net: stmmac: add Rx HWTS metadata to XDP
 receive pkt
To:     Song Yoong Siang <yoong.siang.song@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-hints@xdp-project.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 8:26=E2=80=AFPM Song Yoong Siang
<yoong.siang.song@intel.com> wrote:
>
> Add receive hardware timestamp metadata support via kfunc to XDP receive
> packets.
>
> Suggested-by: Stanislav Fomichev <sdf@google.com>
> Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>

Conceptually looks good, thanks!
Acked-by: Stanislav Fomichev <sdf@google.com>


> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  3 ++
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c | 40 ++++++++++++++++++-
>  2 files changed, 42 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/e=
thernet/stmicro/stmmac/stmmac.h
> index ac8ccf851708..826ac0ec88c6 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> @@ -94,6 +94,9 @@ struct stmmac_rx_buffer {
>
>  struct stmmac_xdp_buff {
>         struct xdp_buff xdp;
> +       struct stmmac_priv *priv;
> +       struct dma_desc *p;
> +       struct dma_desc *np;
>  };
>
>  struct stmmac_rx_queue {
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/=
net/ethernet/stmicro/stmmac/stmmac_main.c
> index 6ffce52ca837..831a3e22e0d8 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -5313,10 +5313,15 @@ static int stmmac_rx(struct stmmac_priv *priv, in=
t limit, u32 queue)
>
>                         xdp_init_buff(&ctx.xdp, buf_sz, &rx_q->xdp_rxq);
>                         xdp_prepare_buff(&ctx.xdp, page_address(buf->page=
),
> -                                        buf->page_offset, buf1_len, fals=
e);
> +                                        buf->page_offset, buf1_len, true=
);
>
>                         pre_len =3D ctx.xdp.data_end - ctx.xdp.data_hard_=
start -
>                                   buf->page_offset;
> +
> +                       ctx.priv =3D priv;
> +                       ctx.p =3D p;
> +                       ctx.np =3D np;
> +
>                         skb =3D stmmac_xdp_run_prog(priv, &ctx.xdp);
>                         /* Due xdp_adjust_tail: DMA sync for_device
>                          * cover max len CPU touch
> @@ -7060,6 +7065,37 @@ void stmmac_fpe_handshake(struct stmmac_priv *priv=
, bool enable)
>         }
>  }
>
> +static int stmmac_xdp_rx_timestamp(const struct xdp_md *_ctx, u64 *times=
tamp)
> +{
> +       const struct stmmac_xdp_buff *ctx =3D (void *)_ctx;
> +       struct stmmac_priv *priv =3D ctx->priv;
> +       struct dma_desc *desc =3D ctx->p;
> +       struct dma_desc *np =3D ctx->np;
> +       struct dma_desc *p =3D ctx->p;
> +       u64 ns =3D 0;
> +
> +       if (!priv->hwts_rx_en)
> +               return -ENODATA;
> +
> +       /* For GMAC4, the valid timestamp is from CTX next desc. */
> +       if (priv->plat->has_gmac4 || priv->plat->has_xgmac)
> +               desc =3D np;
> +
> +       /* Check if timestamp is available */
> +       if (stmmac_get_rx_timestamp_status(priv, p, np, priv->adv_ts)) {
> +               stmmac_get_timestamp(priv, desc, priv->adv_ts, &ns);
> +               ns -=3D priv->plat->cdc_error_adj;
> +               *timestamp =3D ns_to_ktime(ns);
> +               return 0;
> +       }
> +
> +       return -ENODATA;
> +}
> +
> +static const struct xdp_metadata_ops stmmac_xdp_metadata_ops =3D {
> +       .xmo_rx_timestamp               =3D stmmac_xdp_rx_timestamp,
> +};
> +
>  /**
>   * stmmac_dvr_probe
>   * @device: device pointer
> @@ -7167,6 +7203,8 @@ int stmmac_dvr_probe(struct device *device,
>
>         ndev->netdev_ops =3D &stmmac_netdev_ops;
>
> +       ndev->xdp_metadata_ops =3D &stmmac_xdp_metadata_ops;
> +
>         ndev->hw_features =3D NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6=
_CSUM |
>                             NETIF_F_RXCSUM;
>         ndev->xdp_features =3D NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDI=
RECT |
> --
> 2.34.1
>
