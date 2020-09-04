Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0C225DCD1
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 17:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730344AbgIDPHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 11:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730137AbgIDPHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 11:07:19 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83CD4C061244
        for <netdev@vger.kernel.org>; Fri,  4 Sep 2020 08:07:19 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id s29so2102923uae.1
        for <netdev@vger.kernel.org>; Fri, 04 Sep 2020 08:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F/o6zH449dNiqjwM/MflyAwj81FmSDxuZakjk/aqJDQ=;
        b=NxnmSWDQew6gxDzvOYQgZhWcTcWDa/ZwlvUHvPyoSzELelccNiT9OXl8JF0UNjgM+A
         XfosNFr4lGy8nXrovdDZ3I06fUfUz2xy6tINyV4KJnDSLNoz/G8cvW8g3hzuJUQWN6hu
         lvc2m6/eSqaOSzf4EaTBFZFXxzTO+JG/OCqnZ1Yqoqgp0NQE3ks7IYa55sWzYlkTAF2R
         jfT83xkY05KUQ3S6CQkHfOIyqmFgCOTwhmHYzUPSmCyRDhF5oGbfm+7OuDH2PO/DJk8p
         AV/8GPmx3JB9zxAIJgq9UVCMnSGU6xAOHPGb6QuVJNNS6t0vupJJhqgvEhsgwAvxV8QG
         uotg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F/o6zH449dNiqjwM/MflyAwj81FmSDxuZakjk/aqJDQ=;
        b=tvl6K18R4MtN2PK2Q36sOjPa3J2jaLWsImKhcMOJh/MiOVXRwxLANE5WtxIh4J++3P
         dOH3PWLhrFPgkMBOa13cukpoCPnfSTiT2YjCKYf4pdxLoKTktET6AzgeV7OFTLOcMX6D
         nVsEkyd++/iNVQ3TLLUQFh1Cc3Ehxtva/O7xMlx2KH7VxvBNrTyL5KBulqPde6p5te9+
         DVIRFK2Nq5l0gaNCH71TE9MdtdaHgNzgJ19zTpipxcoR0jJuTIAXkbsZ3uKmefwjzBDV
         XbizLc/MJPScTgKBYBN3HzeHEexm7VU0NNgHqBylJ+shDy7PWoABIvzle+oSuuu1gmYe
         j2EQ==
X-Gm-Message-State: AOAM531ky7rC+PMvVjQqeyDDWz4p65EEofz1zWej9b2A/6t2+nU77uUx
        1fPuVSyygm+4TaZQNqaFlbVRyHt00Cxu3w==
X-Google-Smtp-Source: ABdhPJxT8UD5L0C56/XNy7n2QoSUgv+IjF0J0SDKLLpWQ7E70LPuARzjs62khyCC/P0otKlWQVxPAQ==
X-Received: by 2002:ab0:34:: with SMTP id 49mr4922678uai.127.1599232037342;
        Fri, 04 Sep 2020 08:07:17 -0700 (PDT)
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com. [209.85.222.54])
        by smtp.gmail.com with ESMTPSA id b205sm1041794vkf.54.2020.09.04.08.07.16
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2020 08:07:16 -0700 (PDT)
Received: by mail-ua1-f54.google.com with SMTP id s29so2102884uae.1
        for <netdev@vger.kernel.org>; Fri, 04 Sep 2020 08:07:16 -0700 (PDT)
X-Received: by 2002:ab0:2404:: with SMTP id f4mr5230442uan.108.1599232034786;
 Fri, 04 Sep 2020 08:07:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200903210022.22774-1-saeedm@nvidia.com> <20200903210022.22774-10-saeedm@nvidia.com>
In-Reply-To: <20200903210022.22774-10-saeedm@nvidia.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 4 Sep 2020 17:06:37 +0200
X-Gmail-Original-Message-ID: <CA+FuTSdoUHM=8Z1FQ8L_eOGwKyzQyO3PD-FHvsf2Q0wBOJ9X7Q@mail.gmail.com>
Message-ID: <CA+FuTSdoUHM=8Z1FQ8L_eOGwKyzQyO3PD-FHvsf2Q0wBOJ9X7Q@mail.gmail.com>
Subject: Re: [net-next 09/10] net/mlx5e: Move TX code into functions to be
 used by MPWQE
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
> mlx5e_txwqe_complete performs some actions that can be taken to separate
> functions:
>
> 1. Update the flags needed for hardware timestamping.
>
> 2. Stop the TX queue if it's full.
>
> Take these actions into separate functions to be reused by the MPWQE
> code in the following commit and to maintain clear responsibilities of
> functions.
>
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 23 ++++++++++++++-----
>  1 file changed, 17 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> index 9ced350150b3..3b68c8333875 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> @@ -311,6 +311,20 @@ static inline void mlx5e_sq_calc_wqe_attr(struct sk_buff *skb,
>         };
>  }
>
> +static inline void mlx5e_tx_skb_update_hwts_flags(struct sk_buff *skb)
> +{
> +       if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
> +               skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
> +}

Subjective, but this helper adds a level of indirection and introduces
code churn without simplying anything, imho.

> +static inline void mlx5e_tx_check_stop(struct mlx5e_txqsq *sq)
> +{
> +       if (unlikely(!mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, sq->stop_room))) {
> +               netif_tx_stop_queue(sq->txq);
> +               sq->stats->stopped++;
> +       }
> +}
> +
>  static inline void
>  mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct sk_buff *skb,
>                      const struct mlx5e_tx_attr *attr,
> @@ -332,14 +346,11 @@ mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct sk_buff *skb,
>         cseg->opmod_idx_opcode = cpu_to_be32((sq->pc << 8) | attr->opcode);
>         cseg->qpn_ds           = cpu_to_be32((sq->sqn << 8) | wqe_attr->ds_cnt);
>
> -       if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
> -               skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
> +       mlx5e_tx_skb_update_hwts_flags(skb);
>
>         sq->pc += wi->num_wqebbs;
> -       if (unlikely(!mlx5e_wqc_has_room_for(wq, sq->cc, sq->pc, sq->stop_room))) {
> -               netif_tx_stop_queue(sq->txq);
> -               sq->stats->stopped++;
> -       }
> +
> +       mlx5e_tx_check_stop(sq);
>
>         send_doorbell = __netdev_tx_sent_queue(sq->txq, attr->num_bytes, xmit_more);
>         if (send_doorbell)
> --
> 2.26.2
>
