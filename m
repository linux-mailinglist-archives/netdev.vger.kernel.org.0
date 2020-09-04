Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D245225DCC8
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 17:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730607AbgIDPFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 11:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729942AbgIDPFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 11:05:43 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15DD9C061244
        for <netdev@vger.kernel.org>; Fri,  4 Sep 2020 08:05:43 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id e14so3783104vsa.9
        for <netdev@vger.kernel.org>; Fri, 04 Sep 2020 08:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3jjjoUBDgAQKKNr6/NAsHp8FpBXuJgNzDq9zV2NhAAE=;
        b=a5oTtnQcXE/w6TZzlqwJSFuSQf42depMDBvgu6CS5BMApP9s7kmh66j7hSyVkDcr3N
         WuBn4x69Mc6CvtR9AbJPlqKzJkix6Ij++7Q5Y4wyMKgh0jbBcFqazuL8ZIKXUXobeOiD
         DfFN3/i0vHKqKRkXHALtnyfIEPJ2u27kYKxAIp6rcQIVTjrYdSFr6Cb28OwZfXvnXh4f
         lwXCfDzCWK13pq7yhZY2tkFMEzWpDEw6b9UdiuxU5KnSw2AQPOFHZK8Vr2WYeg8aoKHj
         A3D4wo7f9wg98HQMqpx+qD2lG8S0QT0bJG8NQwaOYLcyfXNz+gMDjBwdsdxelNHXhg5T
         GYog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3jjjoUBDgAQKKNr6/NAsHp8FpBXuJgNzDq9zV2NhAAE=;
        b=VqKmpBAj9Kybeb2NER8UMGUHHD4j2wArbE2rISw6ZugGqSHl4p36aYgmX2a4P07r4l
         Z1jL2a9yFT8xtxKsYvifCIZrwIauASzjhtyq9WB7cSpnXMe1Oy704/VVOC3l+PrYz9WB
         VBeHBS0YPJbfGPs7xWIkx/bGyE1gZ8z8L4CUmXAojReNVgTYPXH3pyGclxKlwEDnYcDM
         d5jirOmO7qZ7pB+mHfSqrM2DLCwn5J61yi9jBriy8RpB3zinl2JlA+COknD47/BThRt+
         +6x5reb7mTW6QkRo9b63HU7z253H6+snhFp7QHC9HuDkjq/z86fc2ouP5hVFidxtWgPN
         rWWg==
X-Gm-Message-State: AOAM532oIh5h2uLXm/hccLibqFpMNyib/cmgR5FWOfd1Oh96dmped0si
        ePn5banc9tQSSg1OTJ9D+iahbl83KTFP6w==
X-Google-Smtp-Source: ABdhPJx4ujT2i+FxNZKjmuqyJ6IzZLtTVF3yTNKMXXiJud1Li59LkiVoYguE6/rC8nyR81aPS2Xdtg==
X-Received: by 2002:a67:2d10:: with SMTP id t16mr5967821vst.136.1599231941762;
        Fri, 04 Sep 2020 08:05:41 -0700 (PDT)
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com. [209.85.217.54])
        by smtp.gmail.com with ESMTPSA id x23sm1090470vkd.0.2020.09.04.08.05.40
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2020 08:05:41 -0700 (PDT)
Received: by mail-vs1-f54.google.com with SMTP id j185so3814750vsc.3
        for <netdev@vger.kernel.org>; Fri, 04 Sep 2020 08:05:40 -0700 (PDT)
X-Received: by 2002:a67:ebc4:: with SMTP id y4mr5977365vso.119.1599231940347;
 Fri, 04 Sep 2020 08:05:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200903210022.22774-1-saeedm@nvidia.com> <20200903210022.22774-5-saeedm@nvidia.com>
In-Reply-To: <20200903210022.22774-5-saeedm@nvidia.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 4 Sep 2020 17:05:02 +0200
X-Gmail-Original-Message-ID: <CA+FuTSczxJXJuRDKRrMHpQdqjCJLhbujhrzAQZkS=0GO6oJ7ww@mail.gmail.com>
Message-ID: <CA+FuTSczxJXJuRDKRrMHpQdqjCJLhbujhrzAQZkS=0GO6oJ7ww@mail.gmail.com>
Subject: Re: [net-next 04/10] net/mlx5e: Unify constants for WQE_EMPTY_DS_COUNT
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 3, 2020 at 11:01 PM Saeed Mahameed <saeedm@nvidia.com> wrote:
>
> From: Maxim Mikityanskiy <maximmi@mellanox.com>
>
> A constant for the number of DS in an empty WQE (i.e. a WQE without data
> segments) is needed in multiple places (normal TX data path, MPWQE in
> XDP), but currently we have a constant for XDP and an inline formula in
> normal TX. This patch introduces a common constant.
>
> Additionally, mlx5e_xdp_mpwqe_session_start is converted to use struct
> assignment, because the code nearby is touched.
>
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  2 ++
>  .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 13 +++++++-----
>  .../net/ethernet/mellanox/mlx5/core/en/xdp.h  | 21 +++++++------------
>  .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  2 +-
>  4 files changed, 19 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
> index d4ee22789ab0..155b89998891 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
> @@ -7,6 +7,8 @@
>  #include "en.h"
>  #include <linux/indirect_call_wrapper.h>
>
> +#define MLX5E_TX_WQE_EMPTY_DS_COUNT (sizeof(struct mlx5e_tx_wqe) / MLX5_SEND_WQE_DS)
> +

Out of curiosity, what is the logic for dividing this struct by 16?

struct mlx5e_tx_wqe {
        struct mlx5_wqe_ctrl_seg ctrl;
        struct mlx5_wqe_eth_seg  eth;
        struct mlx5_wqe_data_seg data[0];
};

>  #define INL_HDR_START_SZ (sizeof(((struct mlx5_wqe_eth_seg *)NULL)->inline_hdr.start))
>
>  enum mlx5e_icosq_wqe_type {
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> index 7fccd2ea7dc9..81cd9a04bcb0 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> @@ -196,16 +196,19 @@ static void mlx5e_xdp_mpwqe_session_start(struct mlx5e_xdpsq *sq)
>  {
>         struct mlx5e_xdp_mpwqe *session = &sq->mpwqe;
>         struct mlx5e_xdpsq_stats *stats = sq->stats;
> +       struct mlx5e_tx_wqe *wqe;
>         u16 pi;
>
>         pi = mlx5e_xdpsq_get_next_pi(sq, MLX5E_XDP_MPW_MAX_WQEBBS);
> -       session->wqe = MLX5E_TX_FETCH_WQE(sq, pi);
> -
> +       wqe = MLX5E_TX_FETCH_WQE(sq, pi);
>         net_prefetchw(session->wqe->data);

Is this prefetch still valid? And is the temporary variable wqe still
needed at all?


> -       session->ds_count  = MLX5E_XDP_TX_EMPTY_DS_COUNT;
> -       session->pkt_count = 0;
>
> -       mlx5e_xdp_update_inline_state(sq);
> +       *session = (struct mlx5e_xdp_mpwqe) {
> +               .wqe = wqe,
> +               .ds_count = MLX5E_TX_WQE_EMPTY_DS_COUNT,
> +               .pkt_count = 0,
> +               .inline_on = mlx5e_xdp_get_inline_state(sq, session->inline_on),
> +       };
>
>         stats->mpwqe++;
>  }
