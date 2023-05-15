Return-Path: <netdev+bounces-2716-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D13370339F
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 18:39:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 195851C20C43
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 16:39:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36257D534;
	Mon, 15 May 2023 16:39:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C05DF40
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 16:39:36 +0000 (UTC)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43FA540DD
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:39:34 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f4234f67feso381145e9.0
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684168773; x=1686760773;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qW7yIigBtLRrY6uNmmACcIRXDHgWbzvgRoYdbJ5oHgA=;
        b=Yty3x7FbIvmGK4zgJH5Vqc8Ke+uEz37duxS41XH6FXTo+mUfGQvHxgpPigYrDRV5AH
         i322TZX5fiBPTGvGeaVcwvc9/BifCyZV5aJIzT3q3rYRDBKiqZq1j0j4q8Y3t3e/AaFe
         pbdy+sCvd37smWPZ34AGXZGclQ0WtPrHDfbHihyTFoLC61RqVDEwS4cWoEtW7+AIwHLD
         BgK0nVcSm/8TeA8fvbK6CTnIm1i0OvzaXQsOIWePpo57Kql0Om4AuMUimeCSvMDydTet
         xwdlBiT2PfcaJlgD3GwEOLNQnATKGHYJa0YLhUX8hUC5wNELR8ovC2cA6iY6UCRIEDDO
         sT+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684168773; x=1686760773;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qW7yIigBtLRrY6uNmmACcIRXDHgWbzvgRoYdbJ5oHgA=;
        b=Rj/eVp3CMpNGwuCErRsNIXTMkz41mb35DSouvt49Qxlcb+NDv+cgjkIChCvHO558JO
         /jCeimGmG157n+hdkdk+kGJFnXo5MEo2nqsfpwI3zCKVNlLNjanY9+9aiNhsokgZEz7d
         Uxh/QA9i7On2P3OX3wZPTgGQ3FNGmP2ZtX6dfGWmgjiO4yihrGvASmotGzK+YzOQhgF/
         x7ZOyei6bdf+FPjoe+X5r4r5vQLtuE4OSwdA5dF+9vJYtNPV/wmDx949ZOHO3p9/CZb1
         MMmWCBYIym3uNHC0Fyll8Doc1Wr51fUm3KahsCZ4o+6V4gkw58B2cIvsl2k+9oZX2WXi
         WjdQ==
X-Gm-Message-State: AC+VfDyKT0MNPDC0Cwj17fD5rJkN0KfqPDmMXz9xX9pc2idZhjACkh+1
	mSE7VumoTxfZdKoecmOw/WTLh8oRIPag3eN3UiHHCAhRjEAIKLpB9pt7MQ==
X-Google-Smtp-Source: ACHHUZ4kKCM2k5XSi7ziwbBGNzulQrPHGYp7VnzIA8rNSK0Qrw7GuAAGv9K1bOIwjc4a9DDLZwc+LIhuzsLR3qzWHHI=
X-Received: by 2002:a05:600c:3551:b0:3f4:1dce:3047 with SMTP id
 i17-20020a05600c355100b003f41dce3047mr40873wmq.2.1684168772596; Mon, 15 May
 2023 09:39:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230512025740.1068965-1-kuba@kernel.org>
In-Reply-To: <20230512025740.1068965-1-kuba@kernel.org>
From: Eric Dumazet <edumazet@google.com>
Date: Mon, 15 May 2023 18:39:20 +0200
Message-ID: <CANn89iJgT49PKvwZKXShQXivayESxRWYOHC5tHC8CLwkTSwmZg@mail.gmail.com>
Subject: Re: [PATCH net] net/mlx5e: do as little as possible in napi poll when
 budget is 0
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com, 
	saeedm@nvidia.com, leon@kernel.org, brouer@redhat.com, tariqt@mellanox.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 4:57=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> NAPI gets called with budget of 0 from netpoll, which has interrupts
> disabled. We should try to free some space on Tx rings and nothing
> else.
>
> Specifically do not try to handle XDP TX or try to refill Rx buffers -
> we can't use the page pool from IRQ context. Don't check if IRQs moved,
> either, that makes no sense in netpoll. Netpoll calls _all_ the rings
> from whatever CPU it happens to be invoked on.
>
> In general do as little as possible, the work quickly adds up when
> there's tens of rings to poll.
>
> The immediate stack trace I was seeing is:
>
>     __do_softirq+0xd1/0x2c0
>     __local_bh_enable_ip+0xc7/0x120
>     </IRQ>
>     <TASK>
>     page_pool_put_defragged_page+0x267/0x320
>     mlx5e_free_xdpsq_desc+0x99/0xd0
>     mlx5e_poll_xdpsq_cq+0x138/0x3b0
>     mlx5e_napi_poll+0xc3/0x8b0
>     netpoll_poll_dev+0xce/0x150
>
> AFAIU page pool takes a BH lock, releases it and since BH is now
> enabled tries to run softirqs.
>
> Fixes: 60bbf7eeef10 ("mlx5: use page_pool for xdp_return_frame call")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> I'm pointing Fixes at where page_pool was added, although that's
> probably not 100% fair.
>
> CC: saeedm@nvidia.com
> CC: leon@kernel.org
> CC: brouer@redhat.com
> CC: tariqt@mellanox.com
> ---
>  .../net/ethernet/mellanox/mlx5/core/en_txrx.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en_txrx.c
> index a50bfda18e96..bd4294dd72da 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
> @@ -161,20 +161,25 @@ int mlx5e_napi_poll(struct napi_struct *napi, int b=
udget)
>                 }
>         }
>
> +       /* budget=3D0 means we may be in IRQ context, do as little as pos=
sible */
> +       if (unlikely(!budget)) {
> +               /* no work done, can't be asked to re-enable IRQs */
> +               WARN_ON_ONCE(napi_complete_done(napi, work_done));

This is not clear why you call napi_complete_done() here ?

Note the fine doc  ( https://www.kernel.org/doc/html/next/networking/napi.h=
tml )
says:

<quote>If the budget is 0 napi_complete_done() should never be called.</quo=
te>



> +               goto out;
> +       }
> +
>         busy |=3D mlx5e_poll_xdpsq_cq(&c->xdpsq.cq);
>
>         if (c->xdp)
>                 busy |=3D mlx5e_poll_xdpsq_cq(&c->rq_xdpsq.cq);
>
> -       if (likely(budget)) { /* budget=3D0 means: don't poll rx rings */
> -               if (xsk_open)
> -                       work_done =3D mlx5e_poll_rx_cq(&xskrq->cq, budget=
);
> +       if (xsk_open)
> +               work_done =3D mlx5e_poll_rx_cq(&xskrq->cq, budget);
>
> -               if (likely(budget - work_done))
> -                       work_done +=3D mlx5e_poll_rx_cq(&rq->cq, budget -=
 work_done);
> +       if (likely(budget - work_done))
> +               work_done +=3D mlx5e_poll_rx_cq(&rq->cq, budget - work_do=
ne);
>
> -               busy |=3D work_done =3D=3D budget;
> -       }
> +       busy |=3D work_done =3D=3D budget;
>
>         mlx5e_poll_ico_cq(&c->icosq.cq);
>         if (mlx5e_poll_ico_cq(&c->async_icosq.cq))
> --
> 2.40.1
>

